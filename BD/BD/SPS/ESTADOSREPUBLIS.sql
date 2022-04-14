-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADOSREPUBLIS`;DELIMITER $$

CREATE PROCEDURE `ESTADOSREPUBLIS`(
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


SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia	:= '1900-01-01';
SET	Entero_Cero	:= 0;
SET	Lis_Principal	:= 1;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	`EstadoID`,		`Nombre`
	FROM ESTADOSREPUB
	WHERE  Nombre LIKE CONCAT("%", Par_Nombre, "%")
	LIMIT 0, 15;
END IF;

END TerminaStore$$