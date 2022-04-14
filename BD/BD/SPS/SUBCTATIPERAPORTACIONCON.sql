-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERAPORTACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERAPORTACIONCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERAPORTACIONCON`(
# ===============================================================================
# ------ SP PARA CONSULTAR LAS SUBCUENTAS DE TIPOS PERSONA DE APORTACIONES ------
# ===============================================================================
	Par_ConceptoAportacionID 	INT(11),			-- ID del concepto de la aportacion
	Par_NumCon					TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Con_Principal	INT(11);
	DECLARE	Con_Foranea		INT(11);

	-- Asignacion de constantes
	SET	Con_Principal	:= 1;		-- Constante para consulta principal
	SET	Con_Foranea		:= 2;		-- Constante oara consulta foranea


	IF(Par_NumCon = Con_Principal) THEN
		SELECT		ConceptoAportID,		Fisica, 		FisicaActEmp,	Moral
			FROM 	SUBCTATIPERAPORTACION
			WHERE  	ConceptoAportID 	= Par_ConceptoAportacionID;
	END IF;

END TerminaStore$$