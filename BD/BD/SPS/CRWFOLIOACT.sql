-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFOLIOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFOLIOACT`;
DELIMITER $$


CREATE PROCEDURE `CRWFOLIOACT`(
	Par_NombreTabla		VARCHAR(100),		-- Nombre de la tabla que contendra el folio
	Par_NumFolios		INT(12),			-- Numero del folio 
	OUT	Par_FolioIni	BIGINT,			-- Parametro de salida folio inicio
	OUT	Par_FolioFin	BIGINT			-- Parametro de salida folio final
)

TerminaStore : BEGIN

-- Decalracion de constantes
DECLARE	Entero_Cero		BIGINT;			-- Entero cero

-- Asignacion de constantes
SET	Entero_Cero			:= 0;

IF IFNULL(Par_NumFolios, Entero_Cero) = Entero_Cero THEN 
	SET		Par_FolioIni	:= Entero_Cero;
	LEAVE	TerminaStore;
END IF;


SELECT	FolioID
INTO	Par_FolioIni
FROM 	CRWFOLIO
WHERE	Tabla = Par_NombreTabla
FOR UPDATE;

IF Par_FolioIni IS NULL THEN
	SET	Par_FolioIni	= Par_NumFolios;
	INSERT INTO CRWFOLIO VALUES (
		Par_FolioIni,	Par_NombreTabla
	);
ELSE
	SET	Par_FolioIni	:= Par_FolioIni +  1;
	UPDATE	CRWFOLIO
	SET		FolioID	= FolioID + Par_NumFolios
	WHERE	Tabla	= Par_NombreTabla;
END IF;

SET Par_FolioFin := (SELECT	FolioID
				FROM CRWFOLIO
				WHERE	Tabla	= Par_NombreTabla);

END TerminaStore$$
