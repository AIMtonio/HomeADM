-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASCALCULATASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASCALCULATASAPRO`;DELIMITER $$

CREATE PROCEDURE `CREPASCALCULATASAPRO`(

	Par_CreditoFondeoID	int(11),
	Par_FormulaID 		int(11) ,
	Par_TasaFija 		DECIMAL(12,4),
	Par_FechaTasa		date,
	inout Par_TasaOut		Decimal(12,4),

	Par_EmpresaID		int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


DECLARE	Var_PisoTasa		DECIMAL(12,4);
DECLARE	Var_TechoTasa		DECIMAL(12,4);
DECLARE	Var_TasaBase		int;
DECLARE	Var_SobreTasa		DECIMAL(12,4);
DECLARE	Var_FechaSistema		Date;
DECLARE Var_UltimaFecha		date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	For_TasaFija		int;
DECLARE	For_BasePuntos		int;
DECLARE	For_BaPunPisTecho	int;
DECLARE	Est_Vigente			char(1);


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	For_TasaFija			:= 1;
Set	For_BasePuntos			:= 2;
Set	For_BaPunPisTecho		:= 3;
Set	Est_Vigente				:= 'N';
Set Var_FechaSistema		:= (select FechaSistema from PARAMETROSSIS);

if (Par_FormulaID = For_TasaFija) then
	set Par_TasaOut = Par_TasaFija ;
elseif (Par_FormulaID = For_BasePuntos) then
	set Var_TasaBase := (select TasaBase
		from CREDITOFONDEO
		where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_SobreTasa := (select  SobreTasa
		from CREDITOFONDEO
		where CreditoFondeoID	= Par_CreditoFondeoID);

	Set Par_TasaOut := (select  max(Valor)
		from `HIS-TASASBASE`
		where TasaBaseID = Var_TasaBase
		  and Fecha	    = Par_FechaTasa);

	set	Par_TasaOut = ifnull(Par_TasaOut, Entero_Cero);


	if(Par_TasaOut = Entero_Cero)then

		set Var_UltimaFecha :=ifnull((select  max(Fecha)
										from CALHISTASASBASE
										where TasaBaseID = Var_TasaBase
										and Fecha	    = Par_FechaTasa), Fecha_Vacia);

		set Par_TasaOut := (select  Valor
							from CALHISTASASBASE
							where TasaBaseID = Var_TasaBase
							  and Fecha	    = Var_UltimaFecha);
	end if;

		set	Par_TasaOut = Par_TasaOut + Var_SobreTasa;


elseif (Par_FormulaID = For_BaPunPisTecho) then
	set Var_TasaBase := (select 	TasaBase
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_SobreTasa := (select 	SobreTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_PisoTasa := (select 	PisoTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_TechoTasa := (select TechoTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Par_TasaOut := (select  max(Valor)
							from `HIS-TASASBASE`
							where TasaBaseID = Var_TasaBase
							  and Fecha	    = Par_FechaTasa);

	set	Par_TasaOut = ifnull(Par_TasaOut, Entero_Cero);


	if(Par_TasaOut = Entero_Cero)then

	set Var_UltimaFecha :=ifnull((select  max(Fecha)
							from CALHISTASASBASE
							where TasaBaseID = Var_TasaBase
							and Fecha	    = Par_FechaTasa), Fecha_Vacia);

	set Par_TasaOut := (select  Valor
						from CALHISTASASBASE
						where TasaBaseID = Var_TasaBase
						  and Fecha	    = Var_UltimaFecha);
	end if;

	set	Par_TasaOut = Par_TasaOut + Var_SobreTasa;

	if (Par_TasaOut > Var_TechoTasa) then
		set	Par_TasaOut = Var_TechoTasa;
	end if;

	if (Par_TasaOut < Var_PisoTasa) then
		set	Par_TasaOut = Var_PisoTasa;
	end if;
else
	SET Par_TasaOut = Entero_Cero;
end if;

END TerminaStore$$