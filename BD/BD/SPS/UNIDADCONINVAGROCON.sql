-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- UNIDADCONINVAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIDADCONINVAGROCON`;DELIMITER $$

CREATE PROCEDURE `UNIDADCONINVAGROCON`(
	/*  SP PARA CONSULTAR CATALOGO CONCEPTOS DE UNIDAD */
    Par_UniConceptoInvID		INT(11),				-- ID dcel cliente
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

	-- Asignacion de constantes
	SET Con_principal 			:= 1;


	-- consulta principal
	IF(Par_NumList = Con_principal) THEN
		SELECT UniConceptoInvID, Clave, Unidad
			FROM UNIDADCONINVAGRO
		WHERE  UniConceptoInvID =  Par_UniConceptoInvID;

    END IF;


END TerminaStore$$