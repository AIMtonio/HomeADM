
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSCRWCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSCRWCON`;
DELIMITER $$

CREATE PROCEDURE `PARAMETROSCRWCON`(
	Par_ProductoCreditoID	INT(11),		-- ID del Producto de Crédito.
	Par_NumCon				TINYINT UNSIGNED,	-- Número de consulta
	/* Parámetros de Auditoría. */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de constantes
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;

-- Asignación de constantes
SET	Con_Principal	:= 1;	-- Consulta principal de pantalla.
SET	Con_Foranea		:= 2;	-- Consulta foránea.

-- CONSULTA PRINCIPAL NO.1
IF(Par_NumCon = Con_Principal) THEN
	SELECT
		ProductoCreditoID,	FormulaRetencion,	TasaISR,		PorcISRMoratorio,	PorcISRComision,
		MinPorcFonProp,		MaxPorcPagCre,		MaxDiasAtraso,	DiasGraciaPrimVen
	FROM PARAMETROSCRW
	WHERE ProductoCreditoID = Par_ProductoCreditoID;
END IF;


END TerminaStore$$