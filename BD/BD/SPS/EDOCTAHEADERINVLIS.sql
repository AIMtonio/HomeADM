-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERINVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERINVLIS`;DELIMITER $$

CREATE PROCEDURE `EDOCTAHEADERINVLIS`(
	-- SP para lista la informacion del encabezado y detalle de las inversiones del cliente en el estado de cuenta
	Par_ClienteID						INT(11),					-- Identificador del cliente

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
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	DECLARE Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de la cabecera y detalle de las inversiones por cliente
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia

	-- LISTA DE CABECERA Y DETALLE DE MOVIMIENTOS DE UNA INVERSION POR CLIENTE
	IF (Lis_Principal = Par_NumLis)THEN
		SELECT	Head.NombreProducto,	Head.InversionID, 	Head.InvCapital, 	Head.FechaInicio,	Head.FechaVence,
				Head.Plazo,				Head.Gat,			Head.GATReal,		Head.TasaBruta,		Head.TotalComisionesCobradas,
				Head.IvaComision,		Head.ISRretenido,	Detail.FechanMov,	Detail.Descripcion,	Detail.Abono,
				Detail.Cargo,			Detail.Orden,		Detail.Referencia,	IFNULL(Suc.NombreSucurs, Cadena_Vacia) AS NombreSucurs
		FROM EDOCTAHEADER099INV Head INNER JOIN EDOCTADETINVER Detail ON Head.InversionID = Detail.InversionID
		LEFT JOIN SUCURSALES Suc ON Head.SucursalOrigen = Suc.SucursalID
		WHERE Head.ClienteID = Par_ClienteID
		ORDER BY Head.InversionID, Detail.Orden ASC;
	END IF;

END TerminaStore$$