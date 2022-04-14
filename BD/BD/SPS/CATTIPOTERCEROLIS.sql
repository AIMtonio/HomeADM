-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOTERCEROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOTERCEROLIS`;DELIMITER $$

CREATE PROCEDURE `CATTIPOTERCEROLIS`(
	Par_Descripcion		VARCHAR(50),
	Par_NumLis		 	TINYINT UNSIGNED,
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

-- declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Lis_Principal 	INT(11);
DECLARE	Lis_Foranea 	INT(11);

-- asignacion de constantes
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Lis_Principal		:= 3;
SET	Lis_Foranea			:= 4;



IF(Par_NumLis = Lis_Principal) THEN
	SELECT 	Clave,	UPPER(Tercero) AS Tercero
	FROM 	CATTIPOTERCERODIOT
	WHERE Tercero LIKE CONCAT("%", Par_Descripcion, "%")
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_Foranea) THEN

	SELECT 	Clave,	UPPER(Tercero) AS Tercero
	FROM 	CATTIPOTERCERODIOT;
END IF;

END TerminaStore$$