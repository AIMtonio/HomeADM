-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCALCULAISRREST
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCALCULAISRREST`;DELIMITER $$

CREATE FUNCTION `FNCALCULAISRREST`(
# ====================================================================
# -------   FUNCION QUE CALCULA EL ISR RESTANTE		--------
# ------- DEPENDIENDO DE LA VARIACION DE LA TASA	--------
# -------	    ISR DURANTE UN PERIODO  			--------
# ====================================================================
    Par_FechaFin		DATE,			-- FECHA FIN DEL PERIODO A CALCULAR
	Par_FechaInicio 	DATE,			-- FECHA DE INICIO DEL PERIODO A CALCULAR
    Par_SaldoPromedio	DECIMAL(18,2)	-- SALDO PROMEDIO

) RETURNS decimal(18,6)
    DETERMINISTIC
BEGIN
-- DECLARACION DE VARIABLES
DECLARE InteresRetenerRest 	DECIMAL(18,6);

-- DECLARACION DE CONSTANTES
DECLARE Fecha_Vacia			DATE;
DECLARE Decimal_Cero		DECIMAL(12,2);

-- ASIGNACION DE CONSTANTES
SET Fecha_Vacia 	:= '1900-01-01';
SET Decimal_Cero 	:= 0.00;

		/* FORMULA:
		 * [(FECHA DE CAMBIO DE LA TASA - FECHA DE INICIO DE PERIODO) x
		 * (TASA ACTUAL - TASA ANTERIOR AL CAMBIO) x (SALDO PROMEDIO)] / [36000]
		 */
		SET InteresRetenerRest	:=(
			SELECT SUM((DATEDIFF(TI.Fecha,Par_FechaInicio)*(TI.Valor-TI.ValorAnterior)*Par_SaldoPromedio)/36000)
				FROM `HIS-TASASIMPUESTOS` TI
				WHERE TI.Fecha BETWEEN Par_FechaInicio AND Par_FechaFin);

		SET InteresRetenerRest	:= IFNULL(InteresRetenerRest, Decimal_Cero);

RETURN InteresRetenerRest;
END$$