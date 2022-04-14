-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSLIS`;DELIMITER $$

CREATE PROCEDURE `PROSPECTOSLIS`(
	Par_Nombre			VARCHAR(200),
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Lis_Principal	INT(11);
DECLARE Lis_PersonaFisica	INT(11);	-- Lista los prospectos que son persona fisica o fisica con actividad empresarial
DECLARE PersonaMoral	CHAR(1);		-- Persona Moral


SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;
SET Lis_PersonaFisica	:= 3;
SET PersonaMoral	:= 'M';

IF(Par_NumLis = Lis_Principal) THEN

SELECT ProspectoID, NombreCompleto
	FROM PROSPECTOS
	WHERE NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
    LIMIT 0, 15;
END IF;

-- Lista los prospectos que son persona fisica o fisica con actividad empresarial
IF(Par_NumLis = Lis_PersonaFisica) THEN

SELECT ProspectoID, NombreCompleto
	FROM PROSPECTOS
	WHERE NombreCompleto LIKE CONCAT("%", Par_Nombre, "%")
    AND TipoPersona <> PersonaMoral
    LIMIT 0, 15;
END IF;
END TerminaStore$$