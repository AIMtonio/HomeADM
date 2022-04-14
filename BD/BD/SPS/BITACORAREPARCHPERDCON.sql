-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAREPARCHPERDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAREPARCHPERDCON`;DELIMITER $$

CREATE PROCEDURE `BITACORAREPARCHPERDCON`(
/*SP para la consulta de los archivos subidos y el */
	Par_TransaccionID		BIGINT(20),				# Numero Transaccion
	Par_NumCon				TINYINT UNSIGNED,		# Numero de consulta

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN

	DECLARE Con_Principal	INT(11);

	SET Con_Principal		:= 1; # Consulta Principal

	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			TransaccionID,		Fecha,		RutaArchivoSubido,		RutaArchivoReporteG
			FROM BITACORAREPARCHPERD
				WHERE TransaccionID = Par_TransaccionID;
	END IF;
END TerminaStore$$