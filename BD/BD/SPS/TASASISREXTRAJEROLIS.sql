-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASISREXTRAJEROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASISREXTRAJEROLIS`;DELIMITER $$

CREATE PROCEDURE `TASASISREXTRAJEROLIS`(
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
	SET @Consecutivo := Entero_Cero;
	SELECT
		(@Consecutivo := @Consecutivo + 1) AS Consecutivo,
		T.PaisID,	UPPER(P.Nombre) AS Nombre,	T.TasaISR
	FROM TASASISREXTRAJERO T
		INNER JOIN PAISES P ON T.PaisID = P.PaisID
	ORDER BY T.PaisID;
END IF;

END TerminaStore$$