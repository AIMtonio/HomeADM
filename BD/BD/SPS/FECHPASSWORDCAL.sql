-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FECHPASSWORDCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `FECHPASSWORDCAL`;DELIMITER $$

CREATE PROCEDURE `FECHPASSWORDCAL`(
	Par_PriFecha		date,
	Par_SegFecha		date,
	Par_TipCalculo	int
	)
TerminaStore: BEGIN


DECLARE	Var_NumDias		int;
DECLARE	Var_FechaRes		date;


DECLARE Fecha_Vacia		date;
DECLARE Entero_Cero		int;
DECLARE Tip_SumaDias		int;
DECLARE Tip_RestaFechas	int;


set Fecha_Vacia		:= '1900-01-01';
set Entero_Cero		:= 0;
set Tip_RestaFechas	:= 1;



if(Par_TipCalculo = Tip_RestaFechas) then
	set Var_NumDias := DATEDIFF(Par_PriFecha, Par_SegFecha);
	set Var_NumDias = ifnull(Var_NumDias, Entero_Cero);
	select Var_NumDias as DiasCambioPass;
end if;


END TerminaStore$$