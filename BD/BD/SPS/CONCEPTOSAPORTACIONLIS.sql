-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSAPORTACIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSAPORTACIONLIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSAPORTACIONLIS`(
# ==================================================================
# --------- SP PARA LISTAR LAS CONCEPTOS DE APORTACIONES -----------
# ==================================================================
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID		INT(11),			-- Parametro de auditoria
	Aud_Usuario			INT(11),			-- Parametro de auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal		INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Conceptos 	INT(11);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Constante cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Lis_Conceptos		:= 1;				-- Lista para conceptos

	IF(Par_NumLis = Lis_Conceptos) THEN
		SELECT 	`ConceptoAportID`,	`Descripcion`
			FROM	CONCEPTOSAPORTACION;
	END IF;

END TerminaStore$$