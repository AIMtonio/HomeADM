-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOCEDECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOCEDECON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOCEDECON`(
# ===============================================================
# ------ SP PARA CONSULTAR LAS SUBCUENTAS DE PLAZOS DE CEDES-----
# ===============================================================
	Par_ConceptoCedeID		INT(11),
	Par_TipoCedeID 			INT(11),
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
	DECLARE	Con_Principal	INT(11);

	-- Asignacion de constantes
	SET	Con_Principal		:= 1;

	IF(Par_NumCon = Con_Principal) THEN

		SELECT		ConceptoCedeID,		TipoCedeID,		CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,	SubCuenta
			FROM 	SUBCTAPLAZOCEDE
			WHERE	ConceptoCedeID	= Par_ConceptoCedeID
			AND		TipoCedeID		= Par_TipoCedeID
            AND		PlazoInferior	= Par_PlazoInferior
            AND		PlazoSuperior	= Par_PlazoSuperior;

	END IF;

END TerminaStore$$