-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSAPORTACIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSAPORTACIONESCON`;DELIMITER $$

CREATE PROCEDURE `MONTOSAPORTACIONESCON`(
# ===================================================================
# ----------- SP PARA CONSULTAR LOS MONTOS DE APORTACIONES ----------
# ===================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion
	Par_MontoInferior		DECIMAL(18,2),		-- Monto inferior de la aportacion
	Par_MontoSuperior		DECIMAL(18,2),		-- Monto superior
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
	SET Con_Principal		:=	1;		-- Consulta principal de aportaciones
	SET Con_Foranea			:=  2;		-- Consulta foranea


	IF(Par_NumCon = Con_Principal) THEN
			SELECT	`TipoAportacionID`, 	`MontoInferior`, 	`MontoSuperior`
			FROM	 MONTOSAPORTACIONES
			WHERE	 TipoAportacionID = Par_TipoAportacionID;
		END IF;


	IF(Par_NumCon = Con_Foranea) THEN
			SELECT	`TipoAportacionID`, 	`MontoInferior`, 	`MontoSuperior`
			FROM	 MONTOSAPORTACIONES
			WHERE	 TipoAportacionID = Par_TipoAportacionID
			AND MontoInferior = Par_MontoInferior
			AND MontoSuperior = Par_MontoSuperior;
		END IF;

END TerminaStore$$