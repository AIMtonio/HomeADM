-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACEDECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDACEDECON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDACEDECON`(
# =================================================================
# ------ SP PARA CONSULTAR LAS SUBCUENTAS DE MONEDAS DE CEDES------
# =================================================================
	Par_ConceptoCedeID	INT(11),
	Par_MonedaID 		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Con_Principal	INT(11);

	-- Asignacion de constantes
	SET	Con_Principal	:= 1;


	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ConceptoCedeID,		MonedaID,		SubCuenta
			FROM	SUBCTAMONEDACEDE
			WHERE	ConceptoCedeID	= Par_ConceptoCedeID
			AND		MonedaID		= Par_MonedaID;
	END IF;

END TerminaStore$$