-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAPORTACIONESCON`;DELIMITER $$

CREATE PROCEDURE `TASASAPORTACIONESCON`(
# =========================================================================
# ----------- SP PARA CONSULTAR LAS TASAS DE APORTACIONES -----------------
# =========================================================================
	Par_TipoAportacionID	INT(11),			-- ID del tipo de aportacion
	Par_TasaAportacionID	INT(11),			-- ID de la tasa
	Par_MontoInferior		DECIMAL(18,2),		-- Monto inferior
	Par_MontoSuperior		DECIMAL(18,2),		-- Monto superior
	Par_PlazoInferior		INT(11),			-- Plazo inferior

	Par_PlazoSuperior		INT(11),			-- Plazo superior
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

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
	DECLARE	Con_Principal	INT(11);
	DECLARE Con_TasaVar		INT(11);

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Con_Principal		:= 1;				-- Numero de consulta principal
	SET Con_TasaVar			:= 3;				-- Consulta tasa


	IF(Par_NumCon = Con_Principal)THEN
		SELECT	TasaAportacionID, 	TipoAportacionID, 	CONCAT(FORMAT(CONVERT(MontoInferior, CHAR),2)," a ",FORMAT(CONVERT(MontoSuperior, CHAR),2)) AS Montos,
				CONCAT(PlazoInferior," - ",PlazoSuperior) AS Plazos,Calificacion, TasaFija,TasaBase,
                SobreTasa,PisoTasa,TechoTasa,CalculoInteres
		FROM 	TASASAPORTACIONES
		WHERE  	TasaAportacionID 	= Par_TasaAportacionID
		AND 	TipoAportacionID	= Par_TipoAportacionID;
	END IF;

	IF(Par_NumCon = Con_TasaVar)THEN
		SELECT tce.TasaBase, tce.CalculoInteres, tba.Nombre AS NombreTasaBase
			FROM 	TASASAPORTACIONES tce
					INNER JOIN TASASBASE tba ON tce.TasaBase = tba.TasaBaseID
			WHERE 	TipoAportacionID = Par_TipoAportacionID
			AND 	Par_MontoInferior BETWEEN MontoInferior AND MontoSuperior
			AND 	Par_PlazoInferior BETWEEN PlazoInferior AND PlazoSuperior;
	END IF;

END TerminaStore$$