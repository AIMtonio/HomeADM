-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSAPORTACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLAZOSAPORTACIONESLIS`;DELIMITER $$

CREATE PROCEDURE `PLAZOSAPORTACIONESLIS`(
# ================================================================
# ----------- SP PARA LISTAR LOS PLAZOS DE APORTACIONES	----------
# ================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Par_Empresa				INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Lis_PlazosAportaciones	INT(11);	-- Lista plazos aportaciones
	DECLARE Lis_Combo				INT(11);	-- Lista para combo

	-- Asignacion de constantes
	SET	Lis_PlazosAportaciones		:= 2;
	SET Lis_Combo					:= 3;

	/* NO DE LISTA : 2
	 * USADO EN TASAS APORTACIONES*/
	IF(Par_NumLis = Lis_PlazosAportaciones) THEN
		SELECT PlazoInferior, PlazoSuperior
			FROM	PLAZOSAPORTACIONES
			WHERE	TipoAportacionID = Par_TipoAportacionID;
	END IF;

	/* NO DE LISTA : 3
	 * USADO EN TASAS APORTACIONES Y REPORTE DE CAPTACION */
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT PlazoInferior,
				CONCAT(CONVERT(PlazoInferior, CHAR), ' - ',CONVERT(PlazoSuperior, CHAR)) AS PlazosDescripcion
			FROM	PLAZOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;
	END IF;

END TerminaStore$$