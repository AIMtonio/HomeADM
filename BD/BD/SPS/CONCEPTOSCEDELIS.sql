-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCEDELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCEDELIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCEDELIS`(
# =================================================================
# --------- SP PARA LISTAR LAS CONCEPTOS DE CEDES-----------
# =================================================================
	Par_NumLis			TINYINT UNSIGNED,

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
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Conceptos 	INT(11);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Conceptos		:= 1;

	IF(Par_NumLis = Lis_Conceptos) THEN
		SELECT 	`ConceptoCedeID`,	`Descripcion`
			FROM	CONCEPTOSCEDE;
	END IF;

END TerminaStore$$