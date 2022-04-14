-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOCALIDADREPUBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOCALIDADREPUBCON`;DELIMITER $$

CREATE PROCEDURE `LOCALIDADREPUBCON`(
    -- Consulta de localidades --
	Par_EstadoID		INT,				-- clave de estado
	Par_MunicipioID		INT,				-- clave de municipio
	Par_LocalidadID		BIGINT, 			-- clave de localidad
	Par_NumCon			TINYINT UNSIGNED, 	-- Numero de consulta
	Par_EmpresaID		INT, 				-- Auditoria

	Aud_Usuario			INT,				-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Auditoria
	Aud_Sucursal		INT,				-- Auditoria
	Aud_NumTransaccion	BIGINT				-- Auditoria

		)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;
DECLARE Con_Regulatorio INT;
DECLARE Con_RegSofipo   INT;
DECLARE Var_LocalidadID VARCHAR(13); -- Almacena el resultado de convertir LocalidadID a CHAR.

-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';			-- Cadena Vacia
SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero		:= 0;			-- Entero Cero
SET	Con_Principal	:= 1;			-- Consulta Principal
SET	Con_Foranea		:= 2;			-- Consulta Foranea
SET Con_Regulatorio := 3;			-- Consulta para Regulatorios (A1713)
SET Con_RegSofipo   := 4;			-- Consulta para Regulatorios (A1713) -- Sofipos

IF(Par_NumCon = Con_Principal) THEN
	SELECT	LocalidadID, NombreLocalidad, NumHabitantes, EsMarginada
	FROM LOCALIDADREPUB
	WHERE EstadoID 	= Par_EstadoID
	  AND MunicipioID	= Par_MunicipioID
	  AND LocalidadID = Par_LocalidadID;
END IF;

IF(Par_NumCon = Con_Regulatorio) THEN
-- Convierte el valor de Par_LocalidadID a CHAR , LocalidadCNBV es VARCHAR.
   SELECT CONVERT(Par_LocalidadID, CHAR) INTO Var_LocalidadID;
   SELECT	ColoniaCNBV AS LocalidadCNBV, CONCAT(TipoAsenta," ", Asentamiento) AS NombreLocalidad, 1 AS NumHabitantes, 'S' AS EsMarginada
	FROM COLONIASREPUB
	WHERE EstadoID 	= Par_EstadoID
	  AND MunicipioID	= Par_MunicipioID
	  AND ColoniaCNBV = Par_LocalidadID;
END IF;

IF(Par_NumCon = Con_RegSofipo) THEN
	SELECT	LocalidadCNBV, NombreLocalidad, NumHabitantes, EsMarginada
	FROM LOCALIDADREPUB
	WHERE EstadoID 	= Par_EstadoID
	  AND MunicipioID	= Par_MunicipioID
	  AND LocalidadCNBV = Par_LocalidadID;
END IF;

END TerminaStore$$