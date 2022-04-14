-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCRWLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCRWLIS`;
DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCRWLIS`(
/* LISTA LOS CONCEPTOS DE LA GUIA CONTABLE DE CROWDFUNDING. */
	Par_NumLis			TINYINT UNSIGNED,		-- Número de Lista
	/* Parámetros de Auditoría. */
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de Constantes.
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Conceptos 	INT;

-- Asignación de Constantes.
SET	Cadena_Vacia	:= '';				-- Constante Cadena Vacia.
SET	Fecha_Vacia		:= '1900-01-01';	-- Constante Fecha Vacia.
SET	Entero_Cero		:= 0;				-- Constante Entero Cero.
SET	Lis_Conceptos	:= 1;				-- Constante Lista principal.

# LISTA PRINCIPAL DE CONCEPTOS.
IF(Par_NumLis = Lis_Conceptos) THEN
	SELECT
		ConceptoCRWID,	Descripcion
	FROM CONCEPTOSCRW;
END IF;

END TerminaStore$$