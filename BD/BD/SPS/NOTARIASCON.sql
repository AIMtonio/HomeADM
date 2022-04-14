-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTARIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOTARIASCON`;DELIMITER $$

CREATE PROCEDURE `NOTARIASCON`(
	Par_EstadoID	INT,
	Par_MunicipioID	INT,
	Par_NotariaID	INT,
	Par_NumCon		TINYINT UNSIGNED,
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

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Con_Principal	:= 1;
SET	Con_Foranea		:= 2;

IF(Par_NumCon = Con_Principal) THEN
	SELECT	`EstadoID`,		`MunicipioID`, 		`NotariaID`,	`EmpresaID`,
			`Titular`,		`Direccion`, 		`Telefono`,		`Correo`,	`ExtTelefonoPart`
	FROM NOTARIAS
	WHERE EstadoID 	 = Par_EstadoID
	  AND MunicipioID = Par_MunicipioID
	  AND NotariaID	 = Par_NotariaID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT	`NotariaID`,	`Titular`,	`Direccion`
	FROM NOTARIAS
	WHERE EstadoID 	 = Par_EstadoID
	  AND MunicipioID = Par_MunicipioID
	  AND NotariaID	 = Par_NotariaID;
END IF;
END TerminaStore$$