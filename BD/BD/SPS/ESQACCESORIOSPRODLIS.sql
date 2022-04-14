-- ESQACCESORIOSPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQACCESORIOSPRODLIS`;
DELIMITER $$

CREATE PROCEDURE `ESQACCESORIOSPRODLIS`(
-- =====================================================================================
-- ----- SP QUE LISTA LOS ACCESORIOS COBRADOS POR PRODUCTO DE CREDITO  -----------------
-- =====================================================================================
	Par_ProducCreditoID 	INT(11),			-- Producto de Credito
    Par_ClienteID			INT(11),			-- Numero de Cliente
    Par_MontoCredito		DECIMAL(14,2),		-- Monto de Credito
    Par_PlazoID				INT(11),			-- Plazo
	Par_AccesorioID			INT(11),			-- Accesorio
	Par_InstitNominaID		INT(11),			-- Institucion Nomina
	Par_ConvenioID			INT(11),			-- Numero de Convenio
	Par_TipoLista			TINYINT UNSIGNED,	-- Tipo de Lista

	-- Parametros de Auditoria
	Aud_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
  	Aud_FechaActual 	DATETIME,
  	Aud_DireccionIP 	VARCHAR(15),
  	Aud_ProgramaID 		VARCHAR(50),
  	Aud_Sucursal 		INT(11),
  	Aud_NumTransaccion 	BIGINT(20)
)
TerminaStore:BEGIN

    -- Declaracion de variables
    DECLARE Var_SucCliente		INT(11); 		-- Variable Número de Sucursal Cliente
    DECLARE Var_IVASucursal		DECIMAL(14,2); 	-- Variable Porcentaje IVA Sucursal
	DECLARE Var_CicloCliente	INT(11);		-- Ciclo Actual del Cliente

	-- Declaracion de Constantes
    DECLARE Decimal_Cero		DECIMAL(12,2); 	-- Constante Decimal Cero
    DECLARE Entero_Cien			INT(11); 		-- Constante Entero Cien
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE ListaPlazos			INT(11); 		-- Lista Por Plazos : 1
    DECLARE ListaAccesorios		INT(11); 		-- Lista Accesorios : 2
    DECLARE ListaAccesoriosProdCli	INT(11);	-- Lista para consultar los acessorio que correspond por producto de credito para ws de milagro
    DECLARE Lis_AccesorioProd		INT(1);		-- Lista de todos los accesorio por producto de credito

    DECLARE CobroFinanciado		CHAR(1); 		-- Cobro Financiado : F
    DECLARE CobroAnticipado		CHAR(1); 		-- Cobro Anticipado : A
    DECLARE CobroDeduccion		CHAR(1); 		-- Cobro Por Deducción : D
    DECLARE TipoMontoOriginal	CHAR(1); 		-- Tipo de Pogo Monto Original : M
    DECLARE TipoPorcentaje		CHAR(1); 		-- Tipo Pago Porcentale : P
    DECLARE String_Si			CHAR(1); 		-- Constante Cadena Si
    DECLARE String_No 			CHAR(1); 		-- Constante Cadena No

	-- Asignacion de Constantes
    SET Decimal_Cero		:= 0.00;			-- Constante Decimal Cero
    SET Entero_Cien 		:= 100;				-- Constante Cien
    SET Entero_Cero			:= 0;				-- Constante Cero
	SET ListaPlazos 		:= 1;				-- Lista los plazos por accesorio
    SET ListaAccesorios		:= 2;				-- Lista los accesorios por producto de credito
    SET ListaAccesoriosProdCli	:= 3;			-- Lista para consultar los acessorio que correspond por producto de credito y por el cliclo de cliente para ws de milagro
    SET Lis_AccesorioProd	:= 4;				-- Lista de todos los accesorio por producto de credito


	SET CobroFinanciado		:= 'F';				-- Forma de cobro FINANCIADO
    SET CobroAnticipado		:= 'A';				-- Forma de cobro ANTICIPADO
    SET CobroDeduccion		:= 'D';				-- Forma de cobro DEDUCCION
    SET TipoMontoOriginal	:= 'M';   			-- Tipo de pago: MONTO ORIGINAL
	SET TipoPorcentaje		:= 'P';				-- TIpo de pago: PORCENTAJE
    SET String_SI 			:= 'S'; 			-- Constante Cadena Si
    SET String_No 			:= 'N'; 			-- Constante Cedena No


    SET Par_MontoCredito	:= IFNULL(Par_MontoCredito, Decimal_Cero);
    SET Var_SucCliente		:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID);
    SET Var_IVASucursal		:= (SELECT IVA FROM SUCURSALES	WHERE SucursalID = Var_SucCliente);

    # LISTA EL ESQUEMA POR PLAZO DE ACUERDO AL PRODUCTO DE CREDITO Y ACCESORIO
	IF(Par_TipoLista=ListaPlazos)THEN
		IF(Par_InstitNominaID>Entero_Cero)THEN
			SELECT
				ConvenioID, PlazoID, Porcentaje AS Monto, NivelID,
				CicloIni, CicloFin, MontoMin, MontoMax
			FROM ESQCOBROACCESORIOS
			INNER JOIN CONVENIOSNOMINA ON ConvenioNominaID = ConvenioID
			WHERE ProductoCreditoID = Par_ProducCreditoID
			AND AccesorioID = Par_AccesorioID
			AND InstitNominaID = Par_InstitNominaID;
        ELSE
			SELECT
				ConvenioID, PlazoID, Porcentaje AS Monto, NivelID,
				CicloIni, CicloFin, MontoMin, MontoMax
			FROM ESQCOBROACCESORIOS
			WHERE ProductoCreditoID = Par_ProducCreditoID
			AND AccesorioID = Par_AccesorioID
			AND ConvenioID = Entero_Cero;
        END IF;
	END IF;

	# LISTA LOS ACCESORIOS QUE COBRA UN PRODUCTO DE CREDITO, CONSIDERANDO EL PLAZO Y EL PRODUCTO.
	# SE UTILIZA PARA DEVOLVER LOS DATOS QUE SE MOSTRARAN EN LA PANTALLA DEL ALTA DE LA SOLICITUD DE CREDITO
	IF(Par_TipoLista = ListaAccesorios) THEN

		# Se obtiene el ciclo del Cliente
		 CALL CRECALCULOCICLOPRO(
			Par_ClienteID,		Entero_Cero,		Par_ProducCreditoID,	Entero_Cero,	Var_CicloCliente,
			Entero_Cero,		String_No,			Aud_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


			SELECT  Esq.AccesorioID, Esq.TipoFormaCobro AS TipoFormaCobro,
			CASE	WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN IFNULL(EsqAc.Porcentaje, Decimal_Cero)
					WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Par_MontoCredito > Decimal_Cero THEN IFNULL(ROUND((Par_MontoCredito * EsqAc.Porcentaje)/Entero_Cien,2),Decimal_Cero)
			END AS MontoAccesorio,
			CASE
				WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = String_SI THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVASucursal),2),Decimal_Cero)
				WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = String_No THEN Decimal_Cero
				WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Par_MontoCredito > Decimal_Cero AND Esq.CobraIVA = String_SI THEN IFNULL(ROUND(((Par_MontoCredito * EsqAc.Porcentaje) /Entero_Cien * Var_IVASucursal),2),Decimal_Cero)
				WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Par_MontoCredito > Decimal_Cero AND Esq.CobraIVA = String_No THEN Decimal_Cero
			END AS MontoIVAAccesorio, Esq.CobraIVA,	Ac.NombreCorto
				FROM ESQUEMAACCESORIOSPROD Esq
				INNER JOIN ESQCOBROACCESORIOS EsqAc
					ON	Esq.AccesorioID = EsqAc.AccesorioID
					AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
				INNER JOIN ACCESORIOSCRED Ac
					ON	Esq.AccesorioID = Ac.AccesorioID
					AND EsqAc.AccesorioID = Ac.AccesorioID
				WHERE Esq.ProductoCreditoID = Par_ProducCreditoID
				  AND EsqAc.PlazoID 		= Par_PlazoID
				  AND Var_CicloCliente 		>= EsqAc.CicloIni
				  AND Var_CicloCliente 		<= EsqAc.CicloFin
				  AND EsqAc.ConvenioID 		= Par_ConvenioID
				  AND Par_MontoCredito 		BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax
				  AND Esq.InstitNominaID = Par_InstitNominaID
				ORDER BY Esq.TipoFormaCobro;
	END IF;

	-- 3.- Lista para consultar los acessorio que correspond por producto de credito para ws de milagro
	IF(Par_TipoLista = ListaAccesoriosProdCli) THEN

		# Se obtiene el ciclo del Cliente
		CALL CRECALCULOCICLOPRO(	Par_ClienteID,		Entero_Cero,		Par_ProducCreditoID,	Entero_Cero,		Var_CicloCliente,
									Entero_Cero,		String_No,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


		SELECT	Esq.AccesorioID,		Esq.CobraIVA,		Esq.TipoFormaCobro,			Esq.TipoPago,		Esq.BaseCalculo,
				EsqAc.Porcentaje,		Esq.GeneraInteres,	Esq.CobraIVAInteres
			FROM ESQUEMAACCESORIOSPROD Esq
			INNER JOIN ESQCOBROACCESORIOS EsqAc ON	Esq.AccesorioID = EsqAc.AccesorioID
			WHERE Esq.ProductoCreditoID = Par_ProducCreditoID
			  AND Var_CicloCliente 		>= EsqAc.CicloIni
			  AND Var_CicloCliente 		<= EsqAc.CicloFin
			  AND EsqAc.ConvenioID 		= Par_ConvenioID
			  AND Par_MontoCredito 		BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax
			  AND Esq.InstitNominaID = Par_InstitNominaID;
	END IF;

	-- 4.- Lista de todos los accesorio por producto de credito
	IF(Par_TipoLista = Lis_AccesorioProd)THEN
		SELECT 	Esq.ProductoCreditoID,		Esq.AccesorioID,		Esq.CobraIVA,		Esq.TipoFormaCobro,			Esq.TipoPago,
				Esq.BaseCalculo,			EsqAc.Porcentaje,		Esq.GeneraInteres,	Esq.CobraIVAInteres
		FROM ESQUEMAACCESORIOSPROD Esq
			INNER JOIN ESQCOBROACCESORIOS EsqAc ON Esq.AccesorioID = EsqAc.AccesorioID
			WHERE Esq.ProductoCreditoID = Par_ProducCreditoID
			AND Esq.InstitNominaID = Par_InstitNominaID;
	END IF;

END TerminaStore$$