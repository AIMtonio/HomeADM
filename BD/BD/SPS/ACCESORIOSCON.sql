-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS ACCESORIOSCON;

DELIMITER $$
CREATE PROCEDURE ACCESORIOSCON(
/* SP PARA CONSULTAR LOS ACCESORIOS DE LOS PRODUCTOS DE CRÉDITO */
	Par_TipoConsulta		INT(11),		-- Especifica el tipo de consulta
	Par_ProductoCreditoID	INT(11),		-- Parametro para el producto de crédito
	Par_PlazoID				BIGINT(11),		-- Parametro para el plazo de crédito
	Par_CicloCliente		INT(11),		-- Ciclo del Cliente
	Par_Monto				DECIMAL(12,2),	-- Monto
	Par_ConvenioNominaID	BIGINT UNSIGNED,-- Identificador del convenio

	-- Parametros de Auditoria
	Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario

    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	# Declaracion de variables

	DECLARE Var_NumAccesoriosProd INT(11);		# Numero de Accesorios a Cobrar por  Producto de Credito
    DECLARE Var_NumAccesoriosParam	INT(11);	# Numero de Accesorios Parametrizados por Producto de Credito, Plazo y Ciclo

	DECLARE Salida_Si			CHAR(1);
	DECLARE TipoProducCredito	INT(11);
	DECLARE TipoPlazo			INT(11);
	DECLARE Entero_Cero			INT(11);
	DECLARE Var_ProdEsNomina	CHAR(1);		-- Variable para validar si el producto es de nomina
	DECLARE Var_EmpManejaConv	CHAR(1);		-- Variable para validar si Empresa maneja convenio es de nomina
	DECLARE Con_ProdNomSI		CHAR(1);		-- Constante SI para validar si el producto es de nomina
	DECLARE Con_LlaveManejaCon	CHAR(20);		-- Constante para validar en parametros generales la llave ManejaCovenioNomina
	DECLARE Con_SiManejaConv	CHAR(1);		-- Constante para validar si la empresa maneja convenio
	DECLARE Var_InstNominaID	INT(11);		-- Variable para InstitNominaID

	SET Salida_Si			:= 'S';							-- Constante Si: S
	SET TipoProducCredito	:= 38;							-- Especifica el tipo de consulta por producto de crédito
	SET TipoPlazo			:= 39;							-- Especifica el tipo de consulta por producto y plazo
	SET Entero_Cero			:= 0;							-- Constante Entero Cero: 0
	SET Con_ProdNomSI		:= 'S';							-- Constante SI para validar si el producto es de nomina
	SET Con_LlaveManejaCon	:= 'ManejaCovenioNomina';		-- Constante para validar en parametros generales la llave ManejaCovenioNomina
	SET Con_SiManejaConv	:= 'S';							-- Constante para validar si la empresa maneja convenio

	IF(Par_TipoConsulta=TipoProducCredito)THEN
		SELECT ProductoCreditoID,Entero_Cero AS PlazoID
		  FROM ESQUEMAACCESORIOSPROD
		 WHERE ProductoCreditoID = Par_ProductoCreditoID;

	ELSEIF(Par_TipoConsulta=TipoPlazo) THEN

		-- Se valida si el producto es de nómina
		IF (Con_ProdNomSI = (SELECT ProductoNomina
							   FROM PRODUCTOSCREDITO
							  WHERE ProducCreditoID = Par_ProductoCreditoID)) THEN

			-- Se valida si la empresa maneja convenio
			IF(Con_SiManejaConv = (SELECT ValorParametro
									 FROM PARAMGENERALES
									WHERE LlaveParametro = Con_LlaveManejaCon) ) THEN


				-- Se consulta el convenio de nómina asociado al convenio
				SET Var_InstNominaID = (SELECT InstitNominaID
										  FROM CONVENIOSNOMINA CON
										 WHERE CON.ConvenioNominaID = Par_ConvenioNominaID);

								-- Se obtiene el numero de Accesorios que son requeridos por producto de credito e institución de nómina
								SET Var_NumAccesoriosProd := (SELECT COUNT(*)
																FROM ESQUEMAACCESORIOSPROD
															   WHERE ProductoCreditoID = Par_ProductoCreditoID
																 AND InstitNominaID = Var_InstNominaID
															);
			ELSE
				SET Var_NumAccesoriosProd := (SELECT COUNT(*)
												FROM ESQUEMAACCESORIOSPROD
											   WHERE ProductoCreditoID = Par_ProductoCreditoID);
			END IF;
		ELSE
			SET Var_NumAccesoriosProd := (SELECT COUNT(*)
											FROM ESQUEMAACCESORIOSPROD
										   WHERE ProductoCreditoID = Par_ProductoCreditoID);
		END IF;



		-- Se obtiene el numero de Accesorios que se encuentran parametrozaidos por producto de credito, plazo y ciclo del cliente y monto solicitado
		SET Var_NumAccesoriosParam := (SELECT COUNT(DISTINCT(AccesorioID))
										FROM ESQCOBROACCESORIOS
										WHERE ProductoCreditoID = Par_ProductoCreditoID
											AND PlazoID = Par_PlazoID
											AND Par_CicloCliente >= CicloIni
											AND Par_CicloCliente <= CicloFin
											AND ConvenioID = Par_ConvenioNominaID
											AND Par_Monto BETWEEN MontoMin AND MontoMax);

		IF(Var_NumAccesoriosProd = Var_NumAccesoriosParam) THEN
			SELECT ProductoCreditoID,PlazoID
			FROM ESQCOBROACCESORIOS
			WHERE ProductoCreditoID=Par_ProductoCreditoID
			AND PlazoID=Par_PlazoID
			AND Par_CicloCliente >= CicloIni
			AND Par_CicloCliente <= CicloFin
			AND ConvenioID = Par_ConvenioNominaID
			AND Par_Monto BETWEEN MontoMin AND MontoMax;
		END IF;

	END IF;


END TerminaStore$$