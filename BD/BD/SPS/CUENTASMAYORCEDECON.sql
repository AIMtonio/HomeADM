-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCEDECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCEDECON`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORCEDECON`(
# ==========================================================
# ----- SP PARA CONSULTAR LAS CUENTAS DE MAYOR DE CEDES-----
# ==========================================================
	Par_ConceptoCedeID 	INT(11),
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
	SET	Con_Principal		:= 1;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT		ConceptoCedeID,		Cuenta, 	Nomenclatura,	NomenclaturaCR
			FROM 	CUENTASMAYORCEDE
			WHERE	ConceptoCedeID 	= Par_ConceptoCedeID;
	END IF;

END TerminaStore$$