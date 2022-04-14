-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNOBTIENEFINMES
DELIMITER ;
DROP FUNCTION IF EXISTS `FNOBTIENEFINMES`;DELIMITER $$

CREATE FUNCTION `FNOBTIENEFINMES`(
	# FUNCION QUE OBTIENE EL FIN DE MES DE UNA FECHA
	Par_Fecha			DATE
) RETURNS date
    DETERMINISTIC
BEGIN

DECLARE	Var_FinMes		DATE;
DECLARE Var_FechaFinMes	DATE;

DECLARE	Fecha_Vacia	date;
DECLARE	Entero_Cero	int;

SET	Fecha_Vacia	:= '1900-01-01';
SET	Entero_Cero	:= 0;

# Se obtiene el ultimo dia del mes
SET Var_FinMes := (SELECT LAST_DAY(Par_Fecha));



IF(Var_FinMes = Par_Fecha) THEN
	SET Var_FechaFinMes := Var_FinMes;
ELSE

	SET Var_FinMes := (SELECT SUBDATE(Par_Fecha, DAYOFMONTH(Par_Fecha) - 1));
	SET Var_FinMes	:= (SELECT DATE_SUB(Var_FinMes, INTERVAL 1 DAY));
 SET Var_FechaFinMes := Var_FinMes;
END IF;

RETURN Var_FechaFinMes;

END$$