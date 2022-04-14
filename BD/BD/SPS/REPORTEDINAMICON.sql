-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPORTEDINAMICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPORTEDINAMICON`;DELIMITER $$

CREATE PROCEDURE `REPORTEDINAMICON`(

	Par_ReporteID					INT(11),
	Par_NumConsulta 				TINYINT,

	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(50),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion 				BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Con_Vista				INT(11);
	DECLARE Con_Encabezados			INT(11);
	DECLARE Con_Parametros			INT(11);
	DECLARE Con_Columnas			INT(11);


	SET Con_Vista					:= 1;
	SET Con_Encabezados				:= 2;
	SET Con_Parametros				:= 3;
	SET Con_Columnas				:= 4;

	IF(Par_NumConsulta = Con_Vista) THEN
		SELECT
			ReporteID,		Vista
			FROM REPORTEDINAMICO
				WHERE ReporteID=Par_ReporteID;
	END IF;

	IF(Par_NumConsulta = Con_Encabezados) THEN
		SELECT
			ReporteID,		TituloReporte,		NombreArchivo,		NombreSP,		NombreHoja
			FROM REPORTEDINAMICO
				WHERE ReporteID=Par_ReporteID;
	END IF;

	IF(Par_NumConsulta = Con_Parametros) THEN
		SELECT
			ReporteID,		NombreParametro, Orden, Tipo
			FROM REPDINAMICOPARAM
				WHERE ReporteID=Par_ReporteID
				ORDER BY Orden;
	END IF;

	IF(Par_NumConsulta = Con_Columnas) THEN
		SELECT
			ReporteID,		NombreColumna, Orden, Tipo
			FROM REPDINAMICOCOLUM
				WHERE ReporteID=Par_ReporteID
				ORDER BY Orden;
	END IF;

END TerminaStore$$