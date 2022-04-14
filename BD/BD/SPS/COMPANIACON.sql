-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMPANIACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMPANIACON`;DELIMITER $$

CREATE PROCEDURE `COMPANIACON`(

	Par_NumCon			TINYINT UNSIGNED,
	Par_EmpresaID		VARCHAR(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		VARCHAR(15),

    Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Con_Principal		INT;


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Con_Principal			:= 1;



IF(Par_NumCon = Con_Principal)then
	SELECT Nombre,		 LogoCtePantalla
		  FROM COMPANIA  limit 1;
END IF;

END TerminaStore$$