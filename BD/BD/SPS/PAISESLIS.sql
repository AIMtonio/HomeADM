-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAISESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAISESLIS`;DELIMITER $$

CREATE PROCEDURE `PAISESLIS`(
    -- Lista de Paises --
	Par_Nombre		    VARCHAR(50),			-- Nombre del pais
	Par_NumLis		    TINYINT UNSIGNED, 		-- Numero de lista
	Par_EmpresaID		INT, 					-- Auditoria

	Aud_Usuario			INT,					-- Auditoria
	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT					-- Auditoria
	)
TerminaStore: BEGIN

DECLARE Var_PaisIDBase		INT(11);

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Lis_Principal		INT;
DECLARE Lis_Regulatorio 	INT;
DECLARE Lis_PaisesDIOT 		INT(11);
DECLARE Lis_TasasISRResExt	INT(11);
DECLARE Lis_PaisesResExt	INT(11);

SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia 		:= '1900-01-01';
SET	Entero_Cero	    	:= 0;
SET	Lis_Principal		:= 1;
SET Lis_Regulatorio 	:= 2;
SET Lis_PaisesDIOT 		:= 3;
SET Lis_TasasISRResExt	:= 4;			-- Lista de Paises en el Esquema de Tasas ISR Residentes en el Extranjero.
SET Lis_PaisesResExt	:= 5;			-- Lista de Paises de Tasas ISR Residentes en el Extranjero.

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	`PaisID`,		`Nombre`
	FROM PAISES
	WHERE  Nombre LIKE CONCAT("%", Par_Nombre, "%")
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_Regulatorio) THEN
	SELECT PaisRegSITI as `PaisCNBV`,		`Nombre`
	FROM PAISES
	WHERE  Nombre LIKE CONCAT("%", Par_Nombre, "%")
    AND PaisRegSITI <> Entero_Cero
	LIMIT 0, 15;
END IF;

-- Lista los Paises de la DIOT
IF(Par_NumLis = Lis_PaisesDIOT) THEN
	SELECT	Clave,		UPPER(Pais) AS Pais, Nacionalidad
	FROM CATPAISESDIOT
	WHERE  Pais LIKE CONCAT("%", Par_Nombre, "%")
	LIMIT 0, 15;
END IF;

-- Lista de Paises en el Esquema de Tasas ISR Residentes en el Extranjero.
IF(Par_NumLis = Lis_TasasISRResExt) THEN
	SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');

	SELECT
		P.PaisID, P.Nombre
	FROM PAISES P
	WHERE P.Nombre LIKE CONCAT("%", Par_Nombre, "%")
		AND P.PaisID != Var_PaisIDBase
	LIMIT 0, 15;
END IF;

-- Lista de Paises de Tasas ISR Residentes en el Extranjero (Aportaciones).
IF(Par_NumLis = Lis_PaisesResExt) THEN
	SELECT
		T.PaisID,	UPPER(P.Nombre) AS Nombre
	FROM TASASISREXTRAJERO T
		INNER JOIN PAISES P ON T.PaisID = P.PaisID
	WHERE P.Nombre LIKE CONCAT("%", Par_Nombre, "%")
		ORDER BY P.Nombre
	LIMIT 0, 15;
END IF;

END TerminaStore$$