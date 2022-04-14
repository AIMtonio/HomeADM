-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCEDESLIS`;
DELIMITER $$


CREATE PROCEDURE `TIPOSCEDESLIS`(
# ====================================================
# -------- SP PARA LISTAR LOS TIPOS DE CEDES----------
# ====================================================
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
	DECLARE Lis_TiposCedes			INT(11);
    DECLARE Estatus_Activo			CHAR(2);					-- Estatus Activo
	DECLARE Lis_TiposCedesAct		INT(11);					-- Lista de los tipos Cedes activos
    DECLARE Lis_ComboTipCedesAct	INT(11);					-- Lista Combo de los tipos Cedes activos
	-- Asignacion de Variables
	SET	Lis_Principal			:= 1;
	SET Lis_TiposCedes			:= 2;
    SET Lis_TiposCedesAct		:= 3;
    SET Lis_ComboTipCedesAct 	:= 4;
    SET Estatus_Activo			:= 'A';

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoCedeID, Descripcion
			FROM	TIPOSCEDES
			WHERE 	Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			LIMIT 	0, 15;
	END IF;

	IF(Par_NumLis = Lis_TiposCedes) THEN
		SELECT TipoCedeID, Descripcion
			FROM	TIPOSCEDES
			LIMIT 	0, 15;
	END IF;

	IF(Par_NumLis = Lis_TiposCedesAct) THEN
		SELECT TipoCedeID, Descripcion
			FROM	TIPOSCEDES
			WHERE 	Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
            AND 	Estatus = Estatus_Activo
			LIMIT 	0, 15;
	END IF;

	IF(Par_NumLis = Lis_ComboTipCedesAct) THEN
		SELECT TipoCedeID, Descripcion
			FROM	TIPOSCEDES
			WHERE 	Estatus = Estatus_Activo
			LIMIT 	0, 15;
	END IF;

END TerminaStore$$