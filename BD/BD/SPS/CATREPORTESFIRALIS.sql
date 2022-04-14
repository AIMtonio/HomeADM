-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATREPORTESFIRALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATREPORTESFIRALIS`;DELIMITER $$

CREATE PROCEDURE `CATREPORTESFIRALIS`(
/* LISTA EL CATALOGO DE REPORTES (ARCHIVOS) DE MONITOREO CARTERA AGRO (FIRA) */
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA
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
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI		CHAR(1);
DECLARE	SalidaNO		CHAR(1);
DECLARE	ListaPrincipal	INT(11);
DECLARE	ListaProyeccion	INT(11);
DECLARE FechaSis		DATE;
DECLARE	Anio_Sis			INT(11);
DECLARE	Var_Anio		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI			:= 'S';				-- Salida Si
SET	SalidaNO			:= 'N'; 			-- Salida No
SET	ListaPrincipal		:= 1; 				-- Tipo de lista Principal
SET	ListaProyeccion		:= 3; 				-- Tipo de lista de Anios de la Proyeccion

SET FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Anio_Sis	 := YEAR(FechaSis);

IF(IFNULL(Par_TipoLista, Entero_Cero) = ListaPrincipal)THEN
	SELECT TipoReporteID, Nombre, NombreReporte
		FROM CATREPORTESFIRA;
END IF;

IF(IFNULL(Par_TipoLista, Entero_Cero) = ListaProyeccion)THEN
	SELECT IFNULL(Anio, Entero_Cero) INTO Var_Anio FROM PROYECCIONINDICA WHERE Anio = Anio_Sis LIMIT 1;

    IF(Var_Anio <> Entero_Cero) THEN
		SELECT Anio
			FROM PROYECCIONINDICA
				GROUP BY Anio;
    ELSE
		(SELECT Anio
			FROM PROYECCIONINDICA
			GROUP BY Anio)
		UNION
			SELECT Anio_Sis;

    END IF;

END IF;

END TerminaStore$$