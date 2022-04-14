-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASISREXTRAJEROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASISREXTRAJEROCON`;DELIMITER $$

CREATE PROCEDURE `TASASISREXTRAJEROCON`(
/* CONSULTA EL CATALOGO DE PAISES TASAS ISR RESIDENTES EN EL EXTRANJERO. */
	Par_PaisID					INT(11),		-- ID del Pais.
	Par_NumConsulta				TINYINT,		-- TIPO DE LISTA.
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

-- Declaracion de Variables
DECLARE Var_PaisIDBase			INT(11);	-- ID del Pais Base (PAISES).
DECLARE Var_Fecha				DATE;		-- FECHA DE CAMBIO.

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
SET	ListaPrincipal		:= 5; 				-- Tipo de lista Principal Grid.

IF(IFNULL(Par_NumConsulta, Entero_Cero)) = ListaPrincipal THEN
	SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');
	SET Var_Fecha := (SELECT MAX(Fecha) FROM HISTASASISREXTRAJERO AS hti
						INNER JOIN TASASISREXTRAJERO AS ti ON ti.TasaISR = hti.Valor
							WHERE ti.PaisID = Par_PaisID);
	SET Var_Fecha := IFNULL(Var_Fecha,Fecha_Vacia);

	SELECT
		T.PaisID,	UPPER(P.Nombre) AS Nombre, T.TasaISR,
		Var_PaisIDBase AS PaisIDBase,
		Var_Fecha AS Fecha
	FROM TASASISREXTRAJERO T
		INNER JOIN PAISES P ON T.PaisID = P.PaisID
	WHERE T.PaisID = Par_PaisID;
END IF;

END TerminaStore$$