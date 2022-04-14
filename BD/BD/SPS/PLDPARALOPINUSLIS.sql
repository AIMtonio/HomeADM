-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARALOPINUSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARALOPINUSLIS`;DELIMITER $$

CREATE PROCEDURE `PLDPARALOPINUSLIS`(
	Par_TipoPersona			CHAR(1),
	Par_NivelRiesgo			CHAR(1),
	Par_FolioID				INT,
	Par_NumLis				TINYINT UNSIGNED,

	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Principal	INT;
DECLARE	EstatusVigente	CHAR(1);

-- Asignacion de contantes
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET	Lis_Principal			:= 1;
SET EstatusVigente			:='V';

IF(Par_NumLis = Lis_Principal) THEN
	(SELECT FolioID,	FechaVigencia
		FROM PLDPARALEOPINUS
			WHERE
			TipoPersona = Par_TipoPersona AND
			NivelRiesgo = Par_NivelRiesgo)
	UNION ALL
	(SELECT FolioID,	FechaVigencia
		FROM PLDHISPARALEOPINUS
			WHERE
			TipoPersona = Par_TipoPersona AND
			NivelRiesgo = Par_NivelRiesgo
			ORDER BY FechaVigencia DESC
			LIMIT 15);
END IF;

END TerminaStore$$