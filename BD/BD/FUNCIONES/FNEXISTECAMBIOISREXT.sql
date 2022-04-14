
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXISTECAMBIOISREXT
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXISTECAMBIOISREXT`;

DELIMITER $$
CREATE FUNCTION `FNEXISTECAMBIOISREXT`(
# ====================================================================
# -------FUNCION PARA CONOCER SI EXISTE CAMBIO EN LA TASA ISR--------
# ====================================================================
	Par_FechaInicio			DATE,			-- Fecha de inicio
	Par_FechaVencimiento	DATE,			-- Fecha de vencimiento
	Par_PaisID				INT(11)			-- ID DEL PAIS.
) RETURNS CHAR(1)
    DETERMINISTIC
BEGIN
# Declaración de variables.
DECLARE Var_ExisteCambio	CHAR(1);

# Declaración de constantes.
DECLARE TasaISRID			INT;
DECLARE EnteroUno			INT;
DECLARE Decimal_Cero		DECIMAL(12,2);

# Asignación de constantes.
SET TasaISRID				:= 1;
SET Decimal_Cero			:= 0.00;
SET EnteroUno				:= 1;

IF EXISTS (SELECT * FROM HISTASASISREXTRAJERO
	WHERE Fecha BETWEEN Par_FechaInicio AND Par_FechaVencimiento AND PaisID = Par_PaisID) THEN
	SET Var_ExisteCambio := 'S';
ELSE
	SET Var_ExisteCambio := 'N';
END IF;

RETURN Var_ExisteCambio;

END$$