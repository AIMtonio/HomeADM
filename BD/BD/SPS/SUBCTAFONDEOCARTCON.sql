-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAFONDEOCARTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAFONDEOCARTCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAFONDEOCARTCON`(
# ==============================================================
#			SP PARA LA CONSULTA DE LA SUBCUENTA POR FONDEADOR
# ==============================================================
	Par_ConceptoCarID		INT(11),		-- Parametro de Concepto
	Par_InstitutFondID		INT(11),		-- Parametro ID Institucion de fondeo
	Par_NumCon		TINYINT UNSIGNED,		-- Parametro para el número de consulta

    -- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaración de constantes
	DECLARE	Con_Principal	INT(1);		-- Constante consulta principal

    -- Asignacion de constantes
	SET	Con_Principal	:= 1;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ConceptoCarID,	InstitutFondID,	SubCuenta
			FROM	SUBCTAFONDEADORCART
			WHERE  	ConceptoCarID 	= Par_ConceptoCarID
			AND 	InstitutFondID	= Par_InstitutFondID;
	END IF;



END TerminaStore$$