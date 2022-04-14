-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCALCTAGATAHO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCALCTAGATAHO`;
DELIMITER $$

CREATE FUNCTION `FUNCIONCALCTAGATAHO`(

	Par_FechaOperacion		date,
	Par_FechaApertura		date,
	Par_Tasa				decimal(12,2)
)
	RETURNS decimal(12,2)
	DETERMINISTIC
BEGIN


DECLARE Var_Mes				int(11);
DECLARE Var_PerioUni		decimal(12,8);
DECLARE Par_Gat				decimal(12,2);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE	Salida_SI		char(1);
DECLARE	Var_NumMeses	int(11);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0;
Set	Salida_SI			:= 'S';
Set Var_NumMeses		:= 12;


set Par_Gat				:= 0.00;




set Par_Tasa			:= ifnull(Par_Tasa,Decimal_Cero);
set Par_FechaOperacion	:= ifnull(Par_FechaOperacion,Fecha_Vacia);
set Par_FechaApertura	:= ifnull(Par_FechaApertura,Fecha_Vacia);

if (year(Par_FechaOperacion) != year(Par_FechaApertura))then
	set Var_Mes				:= 01;
else
	set Var_Mes				:= MONTH(Par_FechaApertura);
end if;

case Var_Mes
	when 01 then set Var_PerioUni	:= 1;
	when 02	then set Var_PerioUni	:= 11/Var_NumMeses;
	when 03	then set Var_PerioUni	:= 10/Var_NumMeses;
	when 04	then set Var_PerioUni	:= 9/Var_NumMeses;
	when 05	then set Var_PerioUni	:= 8/Var_NumMeses;
	when 06	then set Var_PerioUni	:= 7/Var_NumMeses;
	when 07	then set Var_PerioUni	:= 6/Var_NumMeses;
	when 08	then set Var_PerioUni	:= 5/Var_NumMeses;
	when 09	then set Var_PerioUni	:= 4/Var_NumMeses;
	when 10	then set Var_PerioUni	:= 3/Var_NumMeses;
	when 11	then set Var_PerioUni	:= 2/Var_NumMeses;
	when 12	then set Var_PerioUni	:= 1/Var_NumMeses;
	else 	set Var_PerioUni		:= 1/Entero_Cero;
END case;

set Par_Gat		:= round(power(1 + (Par_Tasa/Var_PerioUni),Var_PerioUni) - 1 ,2);


return Par_Gat;

END$$