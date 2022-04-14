-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERADORXLMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERADORXLMCON`;
DELIMITER $$

CREATE PROCEDURE `GENERADORXLMCON`(
	/*SP QUE CONSULTA LA INFORMACION DEL REPORTE XML.*/
	Par_NumLis						TINYINT UNSIGNED,			# Numero de Consulta
	Par_ReporteID					INT(11),					# Numero de reporte

	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(50),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion 				BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes,
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Con_Principal			INT;
	DECLARE Con_Parametros			INT;
	DECLARE Con_tiquetas			INT;

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';						-- Cadena Vacia
	SET Fecha_Vacia					:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero					:= 0;						-- Entero Cero
	SET Con_Principal				:= 1;						-- Consulta Principal
	SET Con_Parametros				:= 2;						-- Consulta Parametros
	SET Con_tiquetas				:= 3;						-- Consulta Parametros

	IF(Par_NumLis = Con_Principal) THEN
		SELECT
			ReporteID,		NombreReporte,		DescripcionReporte,		NombreArchivo,		NombreSP,
			ElementoRoot,	RutaRep,			Extension
			FROM REPORTESXML
				WHERE
				ReporteID = Par_ReporteID;
	END IF;
	IF(Par_NumLis = Con_Parametros) THEN
		SELECT
			ReporteID,		NombreParametro, Orden, Tipo
			FROM REPORTESXMLPARAM
				WHERE ReporteID=Par_ReporteID
				ORDER BY Orden;
	END IF;
	IF(Par_NumLis = Con_tiquetas) THEN
		SELECT
			ReporteID,		Etiqueta, Orden, Tipo, Nivel
			FROM REPORTESXMLTAG
				WHERE ReporteID=Par_ReporteID
				ORDER BY Orden;
	END IF;

END TerminaStore$$