-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNAPORTISRREST
DELIMITER ;
DROP FUNCTION IF EXISTS `FNAPORTISRREST`;DELIMITER $$

CREATE FUNCTION `FNAPORTISRREST`(
/** ========================================================
 ** -- FUNCION QUE CALCULA EL ISR RESTANTE -----------------
 ** -- DEPENDIENDO DE LA VARIACION DE LA TASA ISR ----------
 ** -- DURANTE UN PERIODO PARA APORTACIONES. ---------------
 ** ======================================================== */
	Par_FechaFin		DATE,			-- FECHA FIN DEL PERIODO A CALCULAR
	Par_FechaInicio 	DATE,			-- FECHA DE INICIO DEL PERIODO A CALCULAR
	Par_SaldoPromedio	DECIMAL(18,2),	-- SALDO PROMEDIO
	Par_TipoPeriodo		CHAR(1)			-- TIPO DE PERIODO. R: REGULAR I: IRREGULAR.

) RETURNS decimal(18,6)
    DETERMINISTIC
BEGIN
-- DECLARACION DE VARIABLES
DECLARE InteresRetenerRest 	DECIMAL(18,6);

-- DECLARACION DE CONSTANTES
DECLARE Fecha_Vacia			DATE;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE TipoISRRestante		INT(11);

-- ASIGNACION DE CONSTANTES
SET Fecha_Vacia 	:= '1900-01-01';
SET Decimal_Cero 	:= 0.00;
SET TipoISRRestante	:= 02;

/* FORMULA:
 * [(FECHA DE CAMBIO DE LA TASA - FECHA DE INICIO DE PERIODO) x
 * (TASA ACTUAL - TASA ANTERIOR AL CAMBIO) x (SALDO PROMEDIO)] / [BASE * 100]
 */
SET InteresRetenerRest := (
	SELECT
		SUM(FNFORMINTERES(
			TipoISRRestante,Par_TipoPeriodo,Par_SaldoPromedio,(TI.Valor-TI.ValorAnterior),
			DATEDIFF(TI.Fecha,Par_FechaInicio)))
	FROM `HIS-TASASIMPUESTOS` TI
		WHERE TI.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);

SET InteresRetenerRest := IFNULL(InteresRetenerRest, Decimal_Cero);

RETURN InteresRetenerRest;
END$$