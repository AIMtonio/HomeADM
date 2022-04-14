-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COLONIASREPUBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COLONIASREPUBCON`;DELIMITER $$

CREATE PROCEDURE `COLONIASREPUBCON`(
	Par_EstadoID			INT,
	Par_MunicipioID			INT,
	Par_ColoniaID			INT,
	Par_NumCon				TINYINT UNSIGNED,
	Par_EmpresaID			INT,

	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Con_Principal		INT;
DECLARE	Con_Foranea			INT;


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia		    := '1900-01-01';
SET	Entero_Cero		    := 0;
SET	Con_Principal		:= 1;
SET	Con_Foranea		    := 2;


IF(Par_NumCon = Con_Principal) THEN
	SELECT	ColoniaID,CONCAT(TipoAsenta," ", Asentamiento)AS Asentamiento,CodigoPostal
	FROM COLONIASREPUB
	WHERE EstadoID 	= Par_EstadoID
	  AND MunicipioID	= Par_MunicipioID
	  AND ColoniaID = Par_ColoniaID;
END IF;
END TerminaStore$$