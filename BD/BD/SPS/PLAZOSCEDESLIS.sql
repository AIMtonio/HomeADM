-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSCEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSCEDESLIS`;DELIMITER $$

CREATE PROCEDURE `PLAZOSCEDESLIS`(
# ===========================================================
# ----------- SP PARA LISTAR LOS PLAZOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID		INT(11),
	Par_NumLis			TINYINT UNSIGNED,

	Par_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Lis_PlazosCedes	INT(11);
	DECLARE Lis_Combo		INT(11);

	-- Asignacion de constantes
	SET	Lis_PlazosCedes		:= 2;
	SET Lis_Combo			:= 3;

	/* NO DE LISTA : 2
	 * USADO EN TASAS CEDES*/
	IF(Par_NumLis = Lis_PlazosCedes) THEN
		SELECT PlazoInferior, PlazoSuperior
			FROM	PLAZOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;
	END IF;

	/* NO DE LISTA : 3
	 * USADO EN TASAS CEDES Y REPORTE DE CAPTACION */
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT PlazoInferior,
				CONCAT(CONVERT(PlazoInferior, CHAR), ' - ',CONVERT(PlazoSuperior, CHAR)) AS PlazosDescripcion
			FROM	PLAZOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;
	END IF;

END TerminaStore$$