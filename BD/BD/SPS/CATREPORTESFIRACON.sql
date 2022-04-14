-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATREPORTESFIRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATREPORTESFIRACON`;DELIMITER $$

CREATE PROCEDURE `CATREPORTESFIRACON`(
/* CONSULTA EL CATALOGO DE REPORTES (ARCHIVOS) DE MONITOREO CARTERA AGRO (FIRA) */
	Par_TipoReporteID			INT(11),		-- ID DEL TIPO DE REPORTE
	Par_NumConsulta				TINYINT,		-- TIPO DE CONSULTA
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	SalidaSI			CHAR(1);
DECLARE	SalidaNO			CHAR(1);
DECLARE	ConNombreArchivo	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI			:= 'S';				-- Salida Si
SET	SalidaNO			:= 'N'; 			-- Salida No
SET	ConNombreArchivo	:= 1; 				-- Tipo de lista Principal

IF(IFNULL(Par_NumConsulta, Entero_Cero) = ConNombreArchivo)THEN
	SELECT TipoReporteID, NombreReporte
		FROM CATREPORTESFIRA
		  WHERE TipoReporteID = Par_TipoReporteID;
END IF;

END TerminaStore$$