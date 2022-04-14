-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSCEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSCEDESLIS`;DELIMITER $$

CREATE PROCEDURE `MONTOSCEDESLIS`(
# ===========================================================
# ----------- SP PARA LISTAR LOS MONTOS DE CEDES----------
# ===========================================================
	Par_TipoCedeID		INT(11),
	Par_NumLis			INT(11),

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
	DECLARE Lis_MontosCedes	INT;
	DECLARE	Lis_Principal	INT;
	DECLARE Lis_Combo		INT;

	-- Asignacion de constantes
	SET	Lis_Principal		:= 1;
	SET	Lis_MontosCedes		:= 2;
	SET Lis_Combo			:= 3;


	IF(Par_NumLis = Lis_MontosCedes) THEN
		SELECT MontoInferior, MontoSuperior
			FROM 	MONTOSCEDES
			WHERE  	TipoCedeID	= Par_TipoCedeID;
	END IF;

	IF(Par_NumLis = Lis_Combo) THEN
		SELECT CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2), " a ",FORMAT(CONVERT(MontoSuperior, CHAR),2)) AS  Montos
			FROM 	MONTOSCEDES
			WHERE	TipoCedeID	= Par_TipoCedeID;
	END IF;

END TerminaStore$$