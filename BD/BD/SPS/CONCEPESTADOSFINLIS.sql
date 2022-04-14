-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPESTADOSFINLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPESTADOSFINLIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPESTADOSFINLIS`(
/* LISTA EL CATALOGO DE CONCEPTOS FINANCIEROS */
	Par_EstadoFinanID			INT(11),		-- ID del reporte financiero
	Par_ConceptoFinanID			INT(11),		-- ID del Concepto Financiero
	Par_NumClien				INT(11),		-- Identificador del Cliente
	Par_EsCalculado				CHAR(1),		-- Indica si es un Campo calculado(Con formulas) S .- SI N .- NO
	Par_TipoLista				TINYINT,		-- Número de lista

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
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);
DECLARE	ListaPrincipal	INT(11);
DECLARE	ListaTipoCalc	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	ListaPrincipal		:= 1; 				-- Tipo de lista para Paises en Mejora
SET	ListaTipoCalc       := 2; 				-- Tipo de lista para Paises en Mejora

/* LISTA TODOS LOS CONCEPTOS DE UN CLIENTE */
IF(IFNULL(Par_TipoLista, Entero_Cero) = ListaPrincipal)THEN
	SELECT
		EstadoFinanID,	ConceptoFinanID,	NumClien,		Descripcion,	Desplegado,
		CuentaContable,	EsCalculado,		NombreCampo,	Espacios,		Negrita,
		Sombreado,		CombinarCeldas,		CuentaFija,		Presentacion,	Tipo
      FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Par_EstadoFinanID
			AND NumClien = Par_NumClien;
END IF;

/* LISTA TODOS LOS CONCEPTOS DE UN CLIENTE DEPENDIENDO SI ES O NO CALCULADO */
IF(IFNULL(Par_TipoLista, Entero_Cero) = ListaTipoCalc)THEN
	SELECT
		EstadoFinanID,	ConceptoFinanID,	NumClien,		Descripcion,	Desplegado,
		CuentaContable,	EsCalculado,		NombreCampo,	Espacios,		Negrita,
		Sombreado,		CombinarCeldas,		CuentaFija,		Presentacion,	Tipo
      FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Par_EstadoFinanID
			AND NumClien = Par_NumClien
			AND EsCalculado = Par_EsCalculado;
END IF;

END TerminaStore$$