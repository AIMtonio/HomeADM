-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MUNICIPIOSREPUBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MUNICIPIOSREPUBCON`;DELIMITER $$

CREATE PROCEDURE `MUNICIPIOSREPUBCON`(
	Par_EstadoID	    INT(11),
	Par_MunicipioID	    INT(11),
	Par_NumCon		    TINYINT UNSIGNED,
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;
DECLARE   LinFondeo     INT;

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia	:= '1900-01-01';
SET	Entero_Cero	:= 0;
SET	Con_Principal	:= 1;
SET	Con_Foranea	:= 2;
SET   LinFondeo     := 3;


IF(Par_NumCon = Con_Principal) THEN
	SELECT	EstadoID,	MunicipioID, 	EmpresaID, 	Nombre
	FROM MUNICIPIOSREPUB
	WHERE EstadoID 		= Par_EstadoID
	AND MunicipioID	= Par_MunicipioID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT	MunicipioID,		Nombre,	CASE Ciudad WHEN Cadena_Vacia THEN Nombre ELSE Ciudad END AS Ciudad
	FROM MUNICIPIOSREPUB
	WHERE EstadoID 		= Par_EstadoID
	AND MunicipioID	= Par_MunicipioID;
END IF;

IF(Par_NumCon = LinFondeo) THEN

SELECT	Mun.MunicipioID,		Mun.Nombre, IFNULL(SUM(Loc.NumHabitantes),Entero_Cero) AS NumHabitantes
    FROM MUNICIPIOSREPUB Mun
    INNER JOIN LOCALIDADREPUB Loc
    ON Loc.MunicipioID=Mun.MunicipioID
    AND Loc.EstadoID=Mun.EstadoID
    WHERE Mun.EstadoID 		= Par_EstadoID
    AND Mun.MunicipioID	= Par_MunicipioID;

END IF;

END TerminaStore$$