-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAISESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAISESCON`;DELIMITER $$

CREATE PROCEDURE `PAISESCON`(
	Par_PaisID		    BIGINT,
	Par_NumCon		    INT,
	/* Parámetros de Auditoría */
	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

DECLARE Var_PaisIDBase		INT(11);

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Con_Principal		INT;
DECLARE	Con_Foranea			INT;
DECLARE Con_Regulatorio 	INT;
DECLARE	Con_TasasISRResExt	INT;

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia	    	:= '1900-01-01';
SET	Entero_Cero	    	:= 0;
SET	Con_Principal		:= 1;
SET	Con_Foranea	    	:= 2;
SET	Con_Regulatorio		:= 3; /* Devuelve la columna PaisCNBV requerida por Regulatorios(A1713)
							Designaciones y Bajas de Personal*/
SET	Con_TasasISRResExt	:= 6;

IF(Par_NumCon = Con_Principal) THEN
	SELECT	`PaisID`, 		`EmpresaID`, 	`Nombre`, 		`Gentilicio`,
			`Usuario`, 		`FechaActual`, 	`DireccionIP`, 	`ProgramaID`,
			`Sucursal`, 	`NumTransaccion`
	FROM PAISES
	WHERE  PaisID = Par_PaisID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT	`PaisID`,		`Nombre`
	FROM PAISES
	WHERE  PaisID = Par_PaisID;
END IF;

IF(Par_NumCon = Con_Regulatorio) THEN
	SELECT	PaisRegSITI as `PaisCNBV`,		`Nombre`
	FROM PAISES
	WHERE  PaisRegSITI = Par_PaisID
    AND PaisRegSITI<> Entero_Cero;
END IF;

IF(Par_NumCon = Con_TasasISRResExt) THEN
	SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');

	SELECT
		PaisID,		EmpresaID,	Nombre,		Gentilicio
	FROM PAISES
	WHERE PaisID = Par_PaisID
		AND PaisID != Var_PaisIDBase;
END IF;

END TerminaStore$$