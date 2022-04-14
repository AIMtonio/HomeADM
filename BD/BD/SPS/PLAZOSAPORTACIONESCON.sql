-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSAPORTACIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSAPORTACIONESCON`;DELIMITER $$

CREATE PROCEDURE `PLAZOSAPORTACIONESCON`(
# ===================================================================
# ----------- SP PARA CONSULTAR LOS PLAZOS DE APORTACIONES ----------
# ===================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion
	Par_PlazoInferior		INT(11),			-- Plazo inferior de la aportacion
	Par_PlazoSuperior		INT(11),			-- Plazo superior de la aportacion
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Con_Principal	INT(11);
	DECLARE Con_Foranea		INT(11);

	-- Asignacion de constantes
	SET Con_Principal		:=	1;  -- Constante para consulta principal
	SET Con_Foranea			:=  2;	-- Constante para consulta foranea


	IF(Par_NumCon = Con_Principal) THEN
			SELECT	`TipoAportacionID`, 	`PlazoInferior`, 	`PlazoSuperior`
				FROM	 PLAZOSAPORTACIONES
				WHERE	 TipoAportacionID	= Par_TipoAportacionID;
		END IF;


	IF(Par_NumCon = Con_Foranea) THEN
			SELECT	`TipoAportacionID`, 	`PlazoSuperior`, 	`PlazoSuperior`
				FROM	PLAZOSAPORTACIONES
				WHERE	TipoAportacionID 	= Par_TipoAportacionID
				AND 	PlazoInferior		= Par_PlazoInferior
				AND 	PlazoSuperior		= Par_PlazoSuperior;
		END IF;

END TerminaStore$$