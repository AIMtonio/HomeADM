-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOCRWCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOCRWCON`;

DELIMITER $$
CREATE PROCEDURE `SUBCTAPLAZOCRWCON`(
/* CONSULTA DE SUBCUENTAS PLAZOS CROWDFUNDING. */
	Par_ConceptoCRWID		INT(11),		-- ID del Concepto.
	Par_NumRetiros			INT(11),		-- ID de la Moneda.
	Par_NumCon		TINYINT UNSIGNED,		-- Número de consulta.
	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaración de Constantes.
DECLARE Entero_Cero				INT;
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);
DECLARE Con_Principal			INT;

-- Asignación de constantes.
SET Entero_Cero					:=0;		-- Constante Entero Cero
SET Decimal_Cero				:=0.00;		-- Constante Decimal Cero
SET Cadena_Vacia				:= '';		-- Constante Cadena Vacia
SET Str_SI						:= 'S';		-- Constante SI
SET Str_NO						:= 'N';		-- Constante NO
SET Con_Principal				:= 1;		-- Consulta Principal

# CONSULTA PRINCIPAL
IF(Par_NumCon = Con_Principal) THEN
	SELECT
		ConceptoCRWID,		NumRetiros,		SubCuenta
	FROM SUBCTAPLAZOCRW
	WHERE ConceptoCRWID = Par_ConceptoCRWID
		AND NumRetiros = Par_NumRetiros;
END IF;

END TerminaStore$$