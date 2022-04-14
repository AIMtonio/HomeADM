-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIENCACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIENCACON`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIENCACON`(
	Par_FechaProceso 	CHAR(6),			-- Fecha del proceso
	Par_Consecutivo		INT, 				-- Numero de validacion
	Par_NombreArchivo	VARCHAR(150),		-- Nombre del archivo cargado
	Par_NumCon			INT, 				-- Numero de consulta


	Aud_EmpresaID		INT, 				-- Auditoria
	Aud_Usuario			INT,	 			-- Auditoria
	Aud_FechaActual		DATETIME, 			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT, 				-- Auditoria
	Aud_NumTransaccion	BIGINT 				-- Auditoria
	)
TerminaStore:BEGIN

DECLARE Cadena_Vacia			CHAR(1);
DECLARE Entero_Cero				INT(11);
DECLARE Entero_Uno				INT(11);
DECLARE Fecha_Vacia				DATE;
DECLARE Con_FechaProceso		INT;
DECLARE Var_ContinuaCarga		INT;

SET	Cadena_Vacia	:= '';
SET Entero_Cero		:= 0;
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Uno		:= 1;
SET Con_FechaProceso:= 3;

	IF (Par_NumCon = Con_FechaProceso) THEN
		SELECT
			CASE WHEN FechaProceso = Par_FechaProceso
						AND Consecutivo = Par_Consecutivo THEN Entero_Uno ELSE Entero_Cero END AS ContinuaCarga
			FROM TARDEBCONCIENCABEZA
			WHERE FechaProceso = Par_FechaProceso AND Consecutivo = Par_Consecutivo
            AND NombreArchivo = Par_NombreArchivo
		INTO Var_ContinuaCarga;

		SELECT IFNULL(Var_ContinuaCarga, Entero_Cero) AS ContinuaCarga;
	END IF;

END TerminaStore$$