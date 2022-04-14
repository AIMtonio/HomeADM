-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORAPORTACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORAPORTACIONCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORAPORTACIONCON`(
# ==================================================================
# ----- SP PARA CONSULTAR LAS CUENTAS DE MAYOR DE APORTACIONES -----
# ==================================================================
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

	-- Asignacion de constantes
	SET	Con_Principal		:= 1;	-- Constante para consulta principal

	IF(Par_NumCon = Con_Principal) THEN
		SELECT		ConceptoAportID,		Cuenta, 	Nomenclatura,	NomenclaturaCR
			FROM 	CUENTASMAYORAPORT
			WHERE	ConceptoAportID 	= Par_ConceptoAportacionID;
	END IF;

END TerminaStore$$