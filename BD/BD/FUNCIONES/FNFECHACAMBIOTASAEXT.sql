
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHACAMBIOTASAEXT

DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHACAMBIOTASAEXT`;

DELIMITER $$
CREATE FUNCTION `FNFECHACAMBIOTASAEXT`(
# ====================================================================
# -------FUNCION PARA LA FECHA DEL ULTIMO CAMBIO EN LA TASA ISR--------
# ====================================================================
	Par_NumCon				INT(11),		-- Número de consulta
	Par_FechaInicio			DATE,			-- Fecha de inicio
	Par_FechaVencimiento	DATE,			-- Fecha de vencimiento
	Par_PaisID				INT(11)			-- ID del pais.
) RETURNS DATE
    DETERMINISTIC
BEGIN

DECLARE Var_FechaUltimoCam	DATE ;
DECLARE Var_SigAntFecha		DATE ;
DECLARE Var_TasaISR			DECIMAL(12,2);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Var_NumTrans		BIGINT(20);
DECLARE Var_SAntNumTrans	BIGINT(20);
DECLARE Var_ExisteCambio	CHAR(1);

DECLARE TasaISRID			INT;
DECLARE EnteroUno			INT;
DECLARE Tipo_ConRango		INT;
DECLARE Tipo_ConFecha		INT;
DECLARE Fecha_Vacia			DATE;

SET TasaISRID				:= 1;
SET Var_TasaISR				:= 0.00;
SET Decimal_Cero			:= 0.00;
SET EnteroUno				:= 1;
SET Tipo_ConRango			:= 1;
SET Tipo_ConFecha			:= 2;
SET Fecha_Vacia				:= '1900-01-01';

IF(Par_NumCon = Tipo_ConRango)THEN
	SET Var_FechaUltimoCam := (SELECT MAX(Fecha) FROM HISTASASISREXTRAJERO WHERE Fecha BETWEEN Par_FechaInicio AND Par_FechaVencimiento AND PaisID = Par_PaisID);
END IF;

IF(Par_NumCon = Tipo_ConFecha)THEN
	SET Var_FechaUltimoCam := (SELECT MAX(Fecha) FROM HISTASASISREXTRAJERO WHERE Fecha <= Par_FechaInicio AND PaisID = Par_PaisID);
END IF;

RETURN IFNULL(Var_FechaUltimoCam,Fecha_Vacia);

END$$