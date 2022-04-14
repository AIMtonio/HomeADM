-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSINSTITUCIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSINSTITUCIONLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSINSTITUCIONLIS`(
	Par_NumLis		TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID		INT,			-- Auditoria
	Aud_Usuario			INT,			-- Auditoria
	Aud_FechaActual		DATETIME,		-- Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Auditoria
	Aud_Sucursal		INT,			-- Auditoria
	Aud_NumTransaccion	BIGINT 			-- Auditoria
	)
TerminaStore: BEGIN

-- declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);		-- Cadena vacia
DECLARE	Fecha_Vacia		DATE; 			-- Fecha Vacia
DECLARE	Entero_Cero		INT; 			-- Entero Cero
DECLARE	Lis_Combo	 	INT;			-- Lista para el combo
DECLARE Lis_Regulatorio INT; 			-- Lista para regulatorios

-- asignacion de constantes
SET	Entero_Cero		:= 0;
SET	Lis_Combo		:= 1;
SET Lis_Regulatorio := 2;


-- Lista para combo
IF(Par_NumLis = Lis_Combo) THEN
	SELECT 	`TipoInstitID`,	`Descripcion`
	FROM 	TIPOSINSTITUCION;
END IF;

-- Lista para parametros regulatorios
IF(Par_NumLis = Lis_Regulatorio) THEN
	SELECT 	`TipoInstitID`,	upper(`Descripcion`) AS Descripcion
	FROM 	TIPOSINSTITUCION
    WHERE  TieneRegulatorios = 'S';
END IF;


END TerminaStore$$