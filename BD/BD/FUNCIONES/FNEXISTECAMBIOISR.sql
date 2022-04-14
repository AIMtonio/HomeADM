
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXISTECAMBIOISR
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXISTECAMBIOISR`;

DELIMITER $$
CREATE FUNCTION `FNEXISTECAMBIOISR`(
# ====================================================================
# -------FUNCION PARA CONOCER SI EXISTE CAMBIO EN LA TASA ISR--------
# ====================================================================
	Par_FechaInicio			DATE,			-- Fecha de inicio
	Par_FechaVencimiento	DATE			-- Fecha de vencimiento
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

IF EXISTS (SELECT * FROM `HIS-TASASIMPUESTOS`
	WHERE Fecha BETWEEN Par_FechaInicio AND Par_FechaVencimiento ) THEN
	SET Var_ExisteCambio := 'S';
ELSE
	SET Var_ExisteCambio := 'N';
END IF;

RETURN Var_ExisteCambio;

END$$