-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESLIS`;DELIMITER $$

CREATE PROCEDURE `TASASCEDESLIS`(
# ========================================================
# ----------- SP PARA LISTAR LAS TASAS DE CEDES-----------
# ========================================================
	Par_TipoCedeID		INT(11),
	Par_NumLis			TINYINT UNSIGNED,
    Par_Plazo			VARCHAR(15),
	Aud_Empresa			INT(11),

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
	DECLARE	Lis_Principal	INT(11);
	DECLARE Lis_Grid		INT(11);
	DECLARE Lis_Reporte		INT(11);
	DECLARE Var_Plazo		VARCHAR(15);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET Lis_Grid			:= 2;
	SET Lis_Reporte			:= 3;


	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	TasaCedeID, CONCAT(MontoInferior," a ",MontoSuperior) AS Montos,
				CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
				CASE Calificacion WHEN "N" THEN "NO ASIGNADA"
								  WHEN "A" THEN "EXCELENTE"
								  WHEN "B" THEN "BUENA"
								  WHEN "C" THEN "REGULAR"
				END AS Calificacion
		FROM TASASCEDES
		WHERE TipoCedeID=Par_TipoCedeID LIMIT 15;
	END IF;

	IF (Lis_Grid=Par_NumLis)THEN
	SELECT	TasaCedeID,	CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
						CONCAT(format(CONVERT(MontoInferior, CHAR),2)," a ",format(CONVERT(MontoSuperior, CHAR),2)) AS Montos,
						TasaFija,TasaBase,SobreTasa,PisoTasa,TechoTasa,
						CASE Calificacion WHEN "N" THEN "NO ASIGNADA"
										  WHEN "A" THEN "EXCELENTE"
										  WHEN "B" THEN "BUENA"
										  WHEN "C" THEN "REGULAR"
						END AS Calificacion
		FROM TASASCEDES
		WHERE TipoCedeID=Par_TipoCedeID;


	END IF;

	IF(Par_NumLis = Lis_Reporte) THEN
		SELECT	TasaCedeID,	CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,
				CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2)," a ",FORMAT(CONVERT(MontoSuperior, CHAR),2), " - ", FORMAT(CONVERT(TasaFija, CHAR),2)) AS MontosConTasa,
				TasaFija
		FROM TASASCEDES
		WHERE TipoCedeID=Par_TipoCedeID
			AND CONCAT(PlazoInferior," - ",PlazoSuperior) LIKE CONCAT('%',Par_Plazo,'%');


	END IF;
END TerminaStore$$