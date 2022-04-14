-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSCEDESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSCEDESCON`;DELIMITER $$

CREATE PROCEDURE `MONTOSCEDESCON`(
# ===========================================================
# ----------- SP PARA CONSULTAR LOS MONTOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID			INT(11),
	Par_MontoInferior		DECIMAL(18,2),
	Par_MontoSuperior		DECIMAL(18,2),
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
			SELECT	`TipoCedeID`, 	`MontoInferior`, 	`MontoSuperior`
			FROM	 MONTOSCEDES
			WHERE	 TipoCedeID = Par_TipoCedeID;
		END IF;


	IF(Par_NumCon = Con_Foranea) THEN
			SELECT	`TipoCedeID`, 	`MontoInferior`, 	`MontoSuperior`
			FROM	 MONTOSCEDES
			WHERE	 TipoCedeID = Par_TipoCedeID
			AND MontoInferior = Par_MontoInferior
			AND MontoSuperior = Par_MontoSuperior;
		END IF;

END TerminaStore$$