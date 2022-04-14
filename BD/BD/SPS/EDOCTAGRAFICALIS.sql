-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAGRAFICALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAGRAFICALIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTAGRAFICALIS`(
	-- Store procedure que lista la informacion requerida para desplegar la grafica en los estados de cuenta de clientes nuevos en tronco principal
	Par_ClienteID						INT(11),					-- Identificador del cliente
	Par_CuentaAhoID						BIGINT(12),					-- Identificador de la cuenta de ahorro perteneciente al cliente

	Par_NumLis							TINYINT UNSIGNED,			-- Numero de lista

	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(12)					-- Parametro de Auditoria
	)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	DECLARE Lis_DatosGrafica			INT(11);					-- Lista con los datos para el llenado de la grafica
	DECLARE Var_ProductoAhorro			CHAR(1);					-- Valor indicar que se trata de un producto de ahorro
	DECLARE Var_ProductoInv				CHAR(1);					-- Valor indicar que se trata de un producto de inversion
	DECLARE Var_EntNoventaYNueve		INT(11);					-- Entero 99

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia
	SET Lis_Principal					:= 1;						-- Lista principal de las cuentas de ahorro por cliente
	SET Lis_DatosGrafica				:= 2;						-- Lista datos para llenar grafica de una cuenta de ahorro
	SET Var_ProductoAhorro				:= 'A';						-- Valor indicar que se trata de un producto de ahorro
	SET Var_ProductoInv					:= 'I';						-- Valor indicar que se trata de un producto de inversion
	SET Var_EntNoventaYNueve			:= 99;						-- Entero 99

	-- LISTA DE CUENTAS DE AHORRO PARA PINTAR LA GRAFICA DETALLE Y HEDER DE LAS CUENTAS DE AHORRO
	IF (Par_NumLis = Lis_Principal)THEN
		(SELECT
				DISTINCT edo.CuentaAhoID, IFNULL(ord.Orden, Var_EntNoventaYNueve) AS OrdenProducto
		FROM EDOCTAGRAFICA AS edo
		INNER JOIN CUENTASAHO AS cue ON edo.CuentaAhoID = cue.CuentaAhoID
		LEFT JOIN EDOCTAORDENPRODUCTOS AS ord ON cue.TipoCuentaID = ord.ProductoID AND ord.TipoProducto = Var_ProductoAhorro
		WHERE edo.ClienteID		= Par_ClienteID
		ORDER BY OrdenProducto, CuentaAhoID)
		UNION
		(SELECT
				DISTINCT edo.CuentaAhoID, IFNULL(ordinv.Orden, Var_EntNoventaYNueve) AS OrdenProducto
		FROM EDOCTAGRAFICA AS edo
		INNER JOIN INVERSIONES AS inv ON edo.CuentaAhoID = inv.InversionID
		LEFT JOIN EDOCTAORDENPRODUCTOS AS ordinv ON inv.TipoInversionID = ordinv.ProductoID AND ordinv.TipoProducto = Var_ProductoInv
		WHERE edo.ClienteID		= Par_ClienteID
		ORDER BY OrdenProducto, CuentaAhoID)
		ORDER BY OrdenProducto;
	END IF;


	-- LISTA CON INFORMACION DE LA GRAFICA POR CUENTA DE AHORRO
	IF (Par_NumLis = Lis_DatosGrafica )THEN

		SELECT
				Monto,		Descripcion
		FROM EDOCTAGRAFICA
		WHERE ClienteID		= Par_ClienteID
		  AND CuentaAhoID	= Par_CuentaAhoID
		ORDER BY ClienteID, CuentaAhoID;
	END IF;

END TerminaStore$$