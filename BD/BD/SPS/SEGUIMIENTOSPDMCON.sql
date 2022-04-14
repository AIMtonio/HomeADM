-- SEGUIMIENTOSPDMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOSPDMCON`;
DELIMITER $$
CREATE PROCEDURE `SEGUIMIENTOSPDMCON`(

	/*SP para consultar folios de seguimiento jpmovil*/

	Par_Folio				INT(11),			-- Folio a Buscar del Seguimiento
	Par_NumConsulta			INT(11),			-- Numero de consulta a realizar

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
	DECLARE Con_Principal		INT(11);			-- Consulta principal para la pantalla de seguiminto

	-- Seteo de valores
	SET Con_Principal	:= 1;

	/*Consulta principal para obtener datos del folio
	para la pantalla de Seguimiento de folio jpmovil*/
	IF Par_NumConsulta = Con_Principal THEN

		SELECT	Seg.SeguimientoID,	Seg.ClienteID,	Cli.FechaNacimiento,	Seg.Telefono,	Seg.TipoSoporteID,
				Seg.Estatus
		FROM SEGUIMIENTOSPDM Seg
		INNER JOIN CLIENTES Cli ON Seg.ClienteID = Cli.ClienteID
		WHERE Seg.SeguimientoID = Par_Folio;

	END IF;

END TerminaStore$$