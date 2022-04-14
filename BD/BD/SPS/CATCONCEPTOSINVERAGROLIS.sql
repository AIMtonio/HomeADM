-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCEPTOSINVERAGROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCONCEPTOSINVERAGROLIS`;DELIMITER $$

CREATE PROCEDURE `CATCONCEPTOSINVERAGROLIS`(
	/*  SP PARA LISTAR CATALOGO CONCEPTOS DE INVERSION FIRA */
    Par_ConceptoFiraID		INT(11),				-- ID dcel cliente
    Par_Descripcion			VARCHAR(50),			-- Descripcion del concepto
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
	DECLARE Lis_principal		INT(11);
    DECLARE Estatus_Vigente		CHAR(1);
	-- Asignacion de constantes
	SET Lis_principal 			:= 1;
	SET Estatus_Vigente			:= 'V';


	-- lista principal
	IF(Par_NumList = Lis_principal) THEN
		SELECT ConceptoFiraID, Descripcion
			FROM CATCONCEPTOSINVERAGRO
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			AND Estatus = Estatus_Vigente LIMIT 15;
    END IF;


END TerminaStore$$