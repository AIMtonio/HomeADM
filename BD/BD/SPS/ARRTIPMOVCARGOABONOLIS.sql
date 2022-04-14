-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRTIPMOVCARGOABONOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRTIPMOVCARGOABONOLIS`;DELIMITER $$

CREATE PROCEDURE `ARRTIPMOVCARGOABONOLIS`(
  -- STORED PROCEDURE DE LISTA DE CONCEPTOS DE MOVIMIENTOS DE CARGO Y ABONO DEL ARRENDAMIENTO
	Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID		INT(11),				-- Parametros de Auditoria
	Aud_Usuario			INT(11),				-- Parametros de Auditoria

	Aud_FechaActual		DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID 		VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal		INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion 	BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Con_Principal		INT;			-- Lista principal

	-- Asignacion de Constantes
	SET Con_Principal			:= 1; 			-- Lista principal

	-- CONSULTA PRINCIPAL
	IF(Par_NumLis	= Con_Principal)THEN
		SELECT	TIPCARABO.TipMovCargoAbonoID,	TIPCARABO.Descripcion
			FROM	ARRTIPMOVCARGOABONO	TIPCARABO
			INNER JOIN	CONCEPTOSARRENDA	CONARRENDA	ON	CONARRENDA.ConceptoArrendaID	= TIPCARABO.TipMovCargoAbonoID;
	END IF;

END TerminaStore$$