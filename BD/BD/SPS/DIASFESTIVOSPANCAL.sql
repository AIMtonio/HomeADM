-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASFESTIVOSPANCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASFESTIVOSPANCAL`;DELIMITER $$

CREATE PROCEDURE `DIASFESTIVOSPANCAL`(
	Par_Fecha			date,
	Par_NumDias			int,
	Par_SigAnt			char(1),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE Siguiente		char(1);
DECLARE Anterior 		char(1);
DECLARE Cadena_Vacia	char(1);


DECLARE Var_FecSal	date;
DECLARE Var_EsHabil	char(1);


Set Cadena_Vacia		:= '';
Set Siguiente			:= 'S';
Set Anterior 			:= 'A';


if (Par_SigAnt = Siguiente) then
	call DIASFESTIVOSCAL(
		Par_Fecha,		Par_NumDias, 		Var_FecSal, 		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion	);

	select	Var_FecSal as FechaHabil, DATEDIFF(Var_FecSal, Par_Fecha)  as Dias, Var_EsHabil as EsDiaHabil;
end if;

if (Par_SigAnt = Anterior) then
	call DIASHABILANTERCAL(
		Par_Fecha,		Par_NumDias, 		Var_FecSal,		Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	select	Var_FecSal as FechaHabil, DATEDIFF(Par_Fecha,Var_FecSal)  as Dias, Cadena_Vacia;
end if;

END TerminaStore$$