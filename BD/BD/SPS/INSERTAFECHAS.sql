-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSERTAFECHAS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSERTAFECHAS`;DELIMITER $$

CREATE PROCEDURE `INSERTAFECHAS`(	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Ini		date;
DECLARE		i		int;
DECLARE		Fecha_tmp		date;
DECLARE     diames int;
DECLARE     diasem int;
DECLARE     diaanio int;
DECLARE     semana int;
DECLARE     mes int;
DECLARE     anio int;


set i:=0;
set Fecha_Ini := '2000-07-02';


WHILE i <= 4357
 DO
    set Fecha_Tmp = date_ADD(Fecha_Ini,INTERVAL i DAY);
	set diames := DAYOFMONTH(Fecha_Tmp);
    set diasem :=  DAYOFWEEK(Fecha_Tmp);
    set diaanio := DAYOFYEAR(Fecha_Tmp);
    set mes := MONTH(Fecha_Tmp);
    set anio := YEAR(Fecha_Tmp);
    set semana := WEEK(Fecha_Tmp);
    select Fecha_Tmp,diames,diasem,diaanio,mes,anio,semana;
    set i:= i + 1;
END WHILE;

END TerminaStore$$