-- SEGUIMIENTOSPDMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOSPDMLIS`;
DELIMITER $$
CREATE PROCEDURE `SEGUIMIENTOSPDMLIS`(

	/*SP para listar folios de seguimiento jpmovil*/

	Par_Folio				VARCHAR(10),		-- Folio a Buscar del Seguimiento
	Par_NumLista			INT(11),			-- Numero de lista a realizar

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables

	-- Declaracion de constantes
	DECLARE Lis_Principal		INT(11);			-- Consulta principal para la pantalla de seguiminto
	DECLARE Est_EnProceso		CHAR(1);			-- Estatus Del Folio en Proceso
	DECLARE Est_Cancelado		CHAR(1);			-- Estatus Del Folio Cancelado
	DECLARE Est_Resuleto		CHAR(1);			-- Estatus Del Folio Resuelto
	DECLARE Txt_EnProceso		VARCHAR(10);		-- Texto del estatus En Proceso
	DECLARE Txt_Cancelado		VARCHAR(9);			-- Texto del estatus Cancelado
	DECLARE Txt_Resuleto		VARCHAR(8);			-- Texto del estatus Resuleto
	-- Seteo de valores
	SET Lis_Principal	:= 1;
	SET Est_EnProceso	:= 'P';
	SET Est_Cancelado	:= 'C';
	SET Est_Resuleto	:= 'R';
	SET Txt_EnProceso	:= 'EN PROCESO';
	SET Txt_Cancelado	:= 'CANCELADO';
	SET Txt_Resuleto	:= 'RESUELTO';

	/*Lista principal para obtener datos del folio
	para la pantalla de Seguimiento de folio jpmovil*/
	IF Par_NumLista = Lis_Principal THEN

		SELECT	Seg.SeguimientoID,	Seg.ClienteID,	Cli.NombreCompleto,
		CASE Seg.Estatus WHEN Est_EnProceso THEN
												Txt_EnProceso
						WHEN Est_Cancelado THEN
												Txt_Cancelado
						WHEN Est_Resuleto THEN
												Txt_Resuleto
		END Estatus
		FROM SEGUIMIENTOSPDM Seg
		INNER JOIN CLIENTES Cli ON Seg.ClienteID = Cli.ClienteID
		WHERE Cli.NombreCompleto LIKE CONCAT("%",Par_Folio,"%")
		AND Seg.Estatus = Est_EnProceso;

	END IF;

END TerminaStore$$