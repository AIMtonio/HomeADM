-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESLIS`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESLIS`(
# ================================================================
# ----------- SP PARA LISTAR LAS TASAS DE APORTACIONES -----------
# ================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista
    Par_Plazo				VARCHAR(15),		-- Plazo de la aportacion
	Aud_Empresa				INT(11),			-- Parametro de auditoria

	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal	INT(11);
	DECLARE Lis_Grid		INT(11);
	DECLARE Lis_Reporte		INT(11);
	DECLARE Var_Plazo		VARCHAR(15);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Lis_Principal		:= 1;				-- Lista principal
	SET Lis_Grid			:= 2;				-- Lista para el grid
	SET Lis_Reporte			:= 3;				-- Lista para el reporte


	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	TasaAportacionID, CONCAT(MontoInferior," a ",MontoSuperior) AS Montos,
				CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
				CASE Calificacion WHEN "N" THEN "NO ASIGNADA"
								  WHEN "A" THEN "EXCELENTE"
								  WHEN "B" THEN "BUENA"
								  WHEN "C" THEN "REGULAR"
				END AS Calificacion
		FROM TASASAPORTACIONES
		WHERE TipoAportacionID=Par_TipoAportacionID LIMIT 15;
	END IF;

	IF (Lis_Grid=Par_NumLis)THEN
	SELECT	TasaAportacionID,	CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
						CONCAT(format(CONVERT(MontoInferior, CHAR),2)," a ",format(CONVERT(MontoSuperior, CHAR),2)) AS Montos,
						TasaFija,TasaBase,SobreTasa,PisoTasa,TechoTasa,
						CASE Calificacion WHEN "N" THEN "NO ASIGNADA"
										  WHEN "A" THEN "EXCELENTE"
										  WHEN "B" THEN "BUENA"
										  WHEN "C" THEN "REGULAR"
						END AS Calificacion
		FROM TASASAPORTACIONES
		WHERE TipoAportacionID=Par_TipoAportacionID;


	END IF;

	IF(Par_NumLis = Lis_Reporte) THEN
		SELECT	TasaAportacionID,	CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
				CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2)," a ",FORMAT(CONVERT(MontoSuperior, CHAR),2), " - ", FORMAT(CONVERT(TasaFija, CHAR),2)) AS MontosConTasa,
				TasaFija
		FROM TASASAPORTACIONES
		WHERE TipoAportacionID=Par_TipoAportacionID
			AND CONCAT(PlazoInferior," - ",PlazoSuperior) LIKE CONCAT('%',Par_Plazo,'%');
	END IF;

END TerminaStore$$