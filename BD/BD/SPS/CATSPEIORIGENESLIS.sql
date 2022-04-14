

-- CATSPEIORIGENESLIS --

DELIMITER ;
DROP PROCEDURE IF EXISTS `CATSPEIORIGENESLIS`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `CATSPEIORIGENESLIS`(
/* LISTA EL CATALOGO DE TASAS ISR RESIDENTES EN EL EXTRANJERO. */
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA.
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
DECLARE	ListaPrincipal	INT(11);
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI			:= 'S';				-- Salida Si
SET	SalidaNO			:= 'N'; 			-- Salida No
SET	ListaPrincipal		:= 1; 				-- Tipo de lista Principal Grid.

IF(IFNULL(Par_TipoLista, Entero_Cero)) = ListaPrincipal THEN
	SELECT
		O.OrigenSpeiID,
		UPPER(O.NombreCompleto) AS NombreCompleto
	FROM CATSPEIORIGENES O
	ORDER BY O.Orden;
END IF;

END TerminaStore$$