-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSPLANTILLACON`;DELIMITER $$

CREATE PROCEDURE `SMSPLANTILLACON`(
# ========================================================
# ---------- SP PARA CONSULTAR LAS PLANTILLAS SMS---------
# ========================================================
	Par_PlantillaID		VARCHAR(10),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(11)
)
TerminaStore: BEGIN

	-- Declaracion de constantes

	DECLARE	Con_Principal	INT;
	DECLARE	Con_Foranea		INT;

	-- Asignacion de constantes
	SET	Con_Principal		:= 1;		-- Consulta Principal
	SET	Con_Foranea			:= 2;		-- Consulta Foranea

	IF(Par_NumCon = Con_Principal) THEN
		SELECT		PlantillaID, Nombre, Descripcion
			FROM 	SMSPLANTILLA
			WHERE	PlantillaID	= Par_PlantillaID;
	END IF;

END TerminaStore$$