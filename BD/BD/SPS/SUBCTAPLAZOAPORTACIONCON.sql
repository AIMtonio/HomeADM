-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOAPORTACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOAPORTACIONCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOAPORTACIONCON`(
# =======================================================================
# ------ SP PARA CONSULTAR LAS SUBCUENTAS DE PLAZOS DE APORTACIONES -----
# =======================================================================
	Par_ConceptoAportacionID	INT(11),			-- ID del concepto de la aportacion
	Par_TipoAportacionID 		INT(11),			-- ID del tipo de aportacion
	Par_PlazoInferior			INT(11),			-- Plazo inferior
	Par_PlazoSuperior			INT(11),			-- Plazo superior
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

	-- Asignacion de constantes
	SET	Con_Principal		:= 1;		-- Constante para consulta principal

	IF(Par_NumCon = Con_Principal) THEN

		SELECT		ConceptoAportID,		TipoAportacionID,		CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,	SubCuenta
			FROM 	SUBCTAPLAZOAPORTACION
			WHERE	ConceptoAportID	= Par_ConceptoAportacionID
			AND		TipoAportacionID		= Par_TipoAportacionID
            AND		PlazoInferior			= Par_PlazoInferior
            AND		PlazoSuperior			= Par_PlazoSuperior;

	END IF;

END TerminaStore$$