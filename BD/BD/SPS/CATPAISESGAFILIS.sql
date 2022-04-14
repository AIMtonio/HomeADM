-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPAISESGAFILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATPAISESGAFILIS`;DELIMITER $$

CREATE PROCEDURE `CATPAISESGAFILIS`(
/* LISTA EL CATALOGO DE PAISES DE LA GAFI */
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA: 1 para Paises en Mejora y 2 para Paises No Cooperantes
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
DECLARE	TipoPaisesMej	INT(11);
DECLARE	TipoPaisesNC	INT(11);
DECLARE	PaisesMej		CHAR(1);
DECLARE	PaisesNC		CHAR(1);
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET	TipoPaisesMej       := 1; 				-- Tipo de lista para Paises en Mejora
SET	TipoPaisesNC        := 2; 				-- Tipo de lista para Paises No Cooperantes
SET	PaisesMej       	:= 'M'; 			-- Paises en Mejora
SET	PaisesNC        	:= 'N'; 			-- Paises No Cooperantes

IF(IFNULL(Par_TipoLista, Entero_Cero)) = TipoPaisesMej THEN
	SELECT PaisID,	Nombre, TipoPais
      FROM CATPAISESGAFI
		WHERE TipoPais = PaisesMej;
END IF;

IF(IFNULL(Par_TipoLista, Entero_Cero)) = TipoPaisesNC THEN
	SELECT PaisID,	Nombre, TipoPais
      FROM CATPAISESGAFI
		WHERE TipoPais = PaisesNC;
END IF;

END TerminaStore$$