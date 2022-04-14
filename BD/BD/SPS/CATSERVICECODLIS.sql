-- CATSERVICECODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATSERVICECODLIS`;
DELIMITER $$

CREATE PROCEDURE `CATSERVICECODLIS`(
-- ===================================================================================
-- SP PARA LISTAR CODIGO DE SERVICIOS EN TARJETAS
-- ===================================================================================
	Par_TipoLista				TINYINT UNSIGNED,	# Tipo de Lista

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
DECLARE	Lista_Principal	INT(11);
DECLARE Lista_Combo		INT(11);
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				# Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	# Fecha vacia
SET Entero_Cero			:= 0;				# Entero Cero
SET	SalidaSI        	:= 'S';				# Salida Si
SET	SalidaNO        	:= 'N'; 			# Salida No
SET	Lista_Principal     := 1; 				# Tipo de lista para ACCESORIOS
SET Lista_Combo			:= 2;				# Tipo de Lista para mostrar en el Combo

IF(IFNULL(Par_TipoLista, Entero_Cero)) = Lista_Principal THEN
	SELECT CatServiceCodeID,	NumeroServicio, Descripcion
      FROM CATSERVICECOD;
END IF;

IF(IFNULL(Par_TipoLista, Entero_Cero)) = Lista_Combo THEN
	SELECT CatServiceCodeID,	NumeroServicio, CONCAT(NumeroServicio,'-',Descripcion) AS Descripcion
      FROM CATSERVICECOD;
END IF;


END TerminaStore$$
