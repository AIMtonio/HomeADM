-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAISESDIOTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAISESDIOTCON`;DELIMITER $$

CREATE PROCEDURE `PAISESDIOTCON`(
	/* SP QUE CONSULTA LOS PAISES DE LA DIOT */
	Par_PaisID		    VARCHAR(2),
	Par_NumCon		    INT,
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
DECLARE Con_Regulatorio INT;
DECLARE Con_PaisesDIOT	INT(11);


SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia	    := '1900-01-01';
SET	Entero_Cero	    := 0;
SET	Con_PaisesDIOT	 := 4;


IF(Par_NumCon = Con_PaisesDIOT) THEN
	SELECT	Clave,	UPPER(Pais) AS Pais,	UPPER(Nacionalidad) AS Nacionalidad
	FROM CATPAISESDIOT
	WHERE  Clave = Par_PaisID;
END IF;


END TerminaStore$$