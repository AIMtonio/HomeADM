-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSAPORTACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSAPORTACIONESLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSAPORTACIONESLIS`(
# ============================================================
# -------- SP PARA LISTAR LOS TIPOS DE APORTACIONES ----------
# ============================================================
	Par_Descripcion		VARCHAR(200),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Principal			INT(11);
	DECLARE Lis_TiposAportaciones	INT(11);

	-- Asignacion de Variables
	SET	Lis_Principal				:= 1;
	SET Lis_TiposAportaciones		:= 2;

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoAportacionID, Descripcion
			FROM	TIPOSAPORTACIONES
			WHERE 	Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			LIMIT 	0, 15;
	END IF;

	IF(Par_NumLis = Lis_TiposAportaciones) THEN
		SELECT TipoAportacionID, Descripcion
			FROM	TIPOSAPORTACIONES
			LIMIT 	0, 15;
	END IF;


END TerminaStore$$