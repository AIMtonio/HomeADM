-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSAPORTACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSAPORTACIONESLIS`;DELIMITER $$

CREATE PROCEDURE `MONTOSAPORTACIONESLIS`(
# ================================================================
# ----------- SP PARA LISTAR LOS MONTOS DE APORTACIONES ----------
# ================================================================
	Par_TipoAportacionID	INT(11),		-- Id del tipo de aportacion
	Par_NumLis				INT(11),		-- Numero de lista

	Par_Empresa				INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Lis_MontosAportaciones	INT;
	DECLARE	Lis_Principal			INT;
	DECLARE Lis_Combo				INT;

	-- Asignacion de constantes
	SET	Lis_Principal			:= 1;		-- Lista principal de aportaciones
	SET	Lis_MontosAportaciones	:= 2; 		-- Lista montos de aportaciones
	SET Lis_Combo				:= 3;		-- Lista para combo


	IF(Par_NumLis = Lis_MontosAportaciones) THEN
		SELECT MontoInferior, MontoSuperior
			FROM 	MONTOSAPORTACIONES
			WHERE  	TipoAportacionID	= Par_TipoAportacionID;
	END IF;

	IF(Par_NumLis = Lis_Combo) THEN
		SELECT CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2), " a ",FORMAT(CONVERT(MontoSuperior, CHAR),2)) AS  Montos
			FROM 	MONTOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;
	END IF;

END TerminaStore$$