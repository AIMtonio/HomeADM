-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERCTALIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTAHEADERCTALIS`(
	-- SP para listar la informacion del encabezado y detalle de las cuentas de ahorro del cliente en el estado de cuenta
	Par_ClienteID						INT(11),					-- Identificador del cliente
	Par_CuentaAhoID						BIGINT(12),					-- Identificador de la cuenta de ahorro perteneciente al cliente

	Par_NumLis							TINYINT UNSIGNED,			-- Numero de lista

	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)					-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	DECLARE Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de la cabecera y detalle de sus movimientos de una cuenta de ahorro
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia

	-- LISTA DE CABECERA Y DETALLE DE MOVIMIENTOS DE UNA CUENTA DE AHORRO POR CLIENTE
	IF (Lis_Principal = Par_NumLis)THEN

		SELECT	Head.ProductoDesc, 				Head.CuentaAhoID,					Head.Clabe,							Head.SaldoMesAnterior,	Head.SaldoActual,
				Head.SaldoPromedio,				Head.SaldoMinimo,					Head.GATNominal,					Head.GATReal,			ROUND(Head.TasaBruta,2) as TasaBruta,
				Head.InteresPerido AS Interes,	Head.MontoComision AS Comisiones,	Head.IvaComision AS IvaComisiones,	Head.ISRRetenido AS ISR,Detail.Fecha,
				Detail.Transaccion,				Detail.SucursalID, 					Detail.DescripcionMov,				Detail.Deposito,		Detail.Retiro,
				SUC.NombreSucurs
		FROM EDOCTAHEADERCTA Head INNER JOIN EDOCTADETACTA Detail ON Head.CuentaAhoID = Detail.CuentaAhoID
		INNER JOIN SUCURSALES SUC ON Head.SucursalID =  SUC.SucursalID
		WHERE Head.ClienteID	=  Par_ClienteID
		AND Head.CuentaAhoID	=  Par_CuentaAhoID;
	END IF;

END TerminaStore$$