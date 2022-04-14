-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASCEDESCON`;DELIMITER $$

CREATE PROCEDURE `TASASCEDESCON`(
# =================================================================
# ----------- SP PARA CONSULTAR LAS TASAS DE CEDES-----------------
# =================================================================
	Par_TipoCedeID		INT(11),
	Par_TasaCedeID		INT(11),
	Par_MontoInferior	DECIMAL(18,2),
	Par_MontoSuperior	DECIMAL(18,2),
	Par_PlazoInferior	INT(11),

	Par_PlazoSuperior	INT(11),
	Par_NumCon			TINYINT UNSIGNED,

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
	DECLARE	Con_Principal	INT(11);
	DECLARE Con_TasaVar		INT(11);

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	SET Con_TasaVar			:= 3;


	IF(Par_NumCon = Con_Principal)THEN
		SELECT	TasaCedeID, 	TipoCedeID, 	CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2)," a ",FORMAT(CONVERT(MontoSuperior, CHAR),2)) AS Montos,
				CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,Calificacion, TasaFija,TasaBase,
                SobreTasa,PisoTasa,TechoTasa,CalculoInteres
		FROM 	TASASCEDES
		WHERE  	TasaCedeID  = Par_TasaCedeID
		AND 	TipoCedeID	= Par_TipoCedeID;
	END IF;

	IF(Par_NumCon = Con_TasaVar)THEN
		SELECT tce.TasaBase, tce.CalculoInteres, tba.Nombre AS NombreTasaBase
			FROM 	TASASCEDES tce
					INNER JOIN TASASBASE tba ON tce.TasaBase = tba.TasaBaseID
			WHERE 	TipoCedeID = Par_TipoCedeID
			AND 	Par_MontoInferior BETWEEN MontoInferior AND MontoSuperior
			AND 	Par_PlazoInferior BETWEEN PlazoInferior AND PlazoSuperior;
	END IF;

END TerminaStore$$