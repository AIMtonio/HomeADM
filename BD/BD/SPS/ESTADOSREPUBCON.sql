-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSREPUBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADOSREPUBCON`;DELIMITER $$

CREATE PROCEDURE `ESTADOSREPUBCON`(
	Par_EstadoID	    BIGINT,
	Par_NumCon		    TINYINT UNSIGNED,
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Con_Principal	INT(11);
DECLARE	Con_Foranea		INT(11);

-- ASIGNACION DE VARIABLES
SET	Cadena_Vacia  := '';
SET	Fecha_Vacia	  := '1900-01-01';
SET	Entero_Cero	  := 0;
SET	Con_Principal := 1;
SET	Con_Foranea	  := 2;

-- CONSULTA NO.:1
IF(Par_NumCon = Con_Principal) THEN
	SELECT	`EstadoID`, 	`EmpresaID`, 	`Nombre`, 		`EqBuroCred`,	`EqCirCre`,
            `Usuario`, 	    `FechaActual`, 	`DireccionIP`, 	`ProgramaID`, 	`Sucursal`,
			`NumTransaccion`
	FROM ESTADOSREPUB
	WHERE  EstadoID = Par_EstadoID;
END IF;

-- CONSULTA NO.:2
IF(Par_NumCon = Con_Foranea) THEN
	SELECT	`EstadoID`,		`Nombre`
	FROM ESTADOSREPUB
	WHERE  EstadoID = Par_EstadoID;
END IF;


END TerminaStore$$