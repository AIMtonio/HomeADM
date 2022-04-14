-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MUNICIPIOSREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `MUNICIPIOSREPUBLIS`;DELIMITER $$

CREATE PROCEDURE `MUNICIPIOSREPUBLIS`(
	Par_EstadoID	    INT,
	Par_Nombre		    VARCHAR(50),
	Par_NumLis		    TINYINT UNSIGNED,
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
DECLARE	Lis_Principal	INT;
DECLARE	Lis_Ciudades	INT(11);


SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia	    := '1900-01-01';
SET	Entero_Cero  	:= 0;
SET	Lis_Principal	:= 1;
SET	Lis_Ciudades	:= 2;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	MunicipioID,		Nombre
	FROM MUNICIPIOSREPUB
	WHERE EstadoID = Par_EstadoID
	AND 	Nombre LIKE CONCAT("%", Par_Nombre, "%")
	LIMIT 0, 15;
END IF;

	-- Lista de ciudades. Si la ciudad esta vacia se mostrara en su lugar el nombre del municipio
	IF(Par_NumLis = Lis_Ciudades) THEN
		SELECT	MunicipioID,	Nombre,	CASE Ciudad WHEN Cadena_Vacia THEN Nombre ELSE Ciudad END AS Ciudad
			FROM MUNICIPIOSREPUB
			WHERE	EstadoID = Par_EstadoID
			  AND	Nombre LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

END TerminaStore$$