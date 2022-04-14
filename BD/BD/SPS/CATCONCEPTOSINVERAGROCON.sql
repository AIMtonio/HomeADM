-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCEPTOSINVERAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCONCEPTOSINVERAGROCON`;DELIMITER $$

CREATE PROCEDURE `CATCONCEPTOSINVERAGROCON`(
	/*  SP PARA CONSULTAR CATALOGO CONCEPTOS DE INVERSION FIRA */
    Par_ConceptoFiraID		INT(11),				-- ID dcel cliente
	Par_NumList				TINYINT UNSIGNED,		-- no. del tipo de consulta

	Par_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Con_principal		INT(11);
    DECLARE Estatus_Vigente		CHAR(1);
	-- Asignacion de constantes
	SET Con_principal 			:= 1;
	SET Estatus_Vigente			:= 'V';

	-- consulta principal
	IF(Par_NumList = Con_principal) THEN
		SELECT ConceptoFiraID, Descripcion
			FROM CATCONCEPTOSINVERAGRO
		WHERE  ConceptoFiraID = Par_ConceptoFiraID
			AND Estatus = Estatus_Vigente;
    END IF;


END TerminaStore$$