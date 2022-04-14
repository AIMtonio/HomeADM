-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSUMMESESFECHA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSUMMESESFECHA`;DELIMITER $$

CREATE FUNCTION `FNSUMMESESFECHA`(
/*Funcion que suma los meses a una fecha y regresa la fecha del ultimo dia habil.*/
Par_Fecha		DATE,			-- Fecha de calculo
Par_NumMeses 	INT(11)			-- Número de Meses




) RETURNS date
    DETERMINISTIC
BEGIN
	DECLARE Var_Fecha			DATE;
	DECLARE Var_EsHabil			CHAR(1);

	DECLARE Entero_Uno			INT(11);

	SET Var_Fecha	:= DATE_ADD(Par_Fecha, INTERVAL Par_NumMeses MONTH);
	SET Var_Fecha	:= LAST_DAY(Var_Fecha);
	SET Var_EsHabil	:= 'S';

	-- SE CALCULA UN DIA HÁBIL ANTERIOR A LA FECHA CALCULADA PARA QUE SE EJECUTE JUSTO EN EL CIERRE DE MES.
	CALL DIASFESTIVOSCAL(
		Var_Fecha,					(Entero_Uno * -1),	Var_Fecha,				Var_EsHabil,			1,
		1,							NOW(),				'127.0.0.1',			'FNFECHASUMMESES',		1,
		0);

	RETURN Var_Fecha;
END$$