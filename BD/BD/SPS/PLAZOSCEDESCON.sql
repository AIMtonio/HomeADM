-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSCEDESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSCEDESCON`;DELIMITER $$

CREATE PROCEDURE `PLAZOSCEDESCON`(
# ===========================================================
# ----------- SP PARA CONSULTAR LOS PLAZOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID			INT(11),
	Par_PlazoInferior		INT(11),
	Par_PlazoSuperior		INT(11),
	Par_NumCon				TINYINT UNSIGNED,

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Con_Principal	INT(11);
	DECLARE Con_Foranea		INT(11);

	-- Asignacion de constantes
	SET Con_Principal		:=	1;
	SET Con_Foranea			:=  2;


	IF(Par_NumCon = Con_Principal) THEN
			SELECT	`TipoCedeID`, 	`PlazoInferior`, 	`PlazoSuperior`
				FROM	 PLAZOSCEDES
				WHERE	 TipoCedeID	= Par_TipoCedeID;
		END IF;


	IF(Par_NumCon = Con_Foranea) THEN
			SELECT	`TipoCedeID`, 	`PlazoSuperior`, 	`PlazoSuperior`
				FROM	PLAZOSCEDES
				WHERE	TipoCedeID 		= Par_TipoCedeID
				AND 	PlazoInferior	= Par_PlazoInferior
				AND 	PlazoSuperior	= Par_PlazoSuperior;
		END IF;

END TerminaStore$$