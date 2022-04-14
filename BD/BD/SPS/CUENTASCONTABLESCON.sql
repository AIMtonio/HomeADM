-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCONTABLESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCONTABLESCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASCONTABLESCON`(
	Par_CuentaCompleta	char(25),
	Par_NumCon			tinyint unsigned,
	Par_FechaCreacion	varchar(10),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;
DECLARE		Con_NumCtas		int(11);
DECLARE 	Cadena_Cero		char(1);
DECLARE 	Cadena_Vacia	char(1);
DECLARE 	Var_numCtas		varchar(10);
DECLARE     Var_RFC			varchar(15);
Declare		Var_UltimoDia	varchar(10);
DECLARE 	Con_NumCtasBalanaza int(11);

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_NumCtas		:= 3;
Set Con_NumCtasBalanaza :=4;
Set Cadena_Cero		:= '0';
Set Cadena_Vacia	:= '';

if(Par_NumCon = Con_Principal) then
	select	CuentaCompleta, 	CuentaMayor, 		Descripcion, 	DescriCorta,
			Naturaleza,			Grupo,				TipoCuenta,		MonedaID,
			Restringida,	 	CodigoAgrupador, 	Nivel, 			FechaCreacionCta
	from 		CUENTASCONTABLES
	where		CuentaCompleta 	= Par_CuentaCompleta;
end if;

if(Par_NumCon = Con_Foranea) then
	select	CuentaCompleta, 	Descripcion, 	Grupo
	from 		CUENTASCONTABLES
	where		CuentaCompleta 	= Par_CuentaCompleta;
end if;

if(Par_NumCon = Con_NumCtas) then
	set Var_UltimoDia=last_day(Par_FechaCreacion);

	set Var_numCtas := (select count(CuentaCompleta)
		from CUENTASCONTABLES
		where FechaCreacionCta<=Var_UltimoDia);

	set Var_RFC := (select RFC
					from PARAMETROSSIS param
					inner join INSTITUCIONES ins on param.InstitucionID=ins.InstitucionID);


select ifnull(Var_numCtas,Cadena_Cero),ifnull(Var_RFC,Cadena_Vacia);

end if;

if(Par_NumCon = Con_NumCtasBalanaza) then
	set Var_UltimoDia=last_day(Par_FechaCreacion);

	set Var_numCtas := (select count(distinct sc.CuentaCompleta)
							from SALDOSCONTABLES sc
								inner join CUENTASCONTABLES cc on sc.CuentaCompleta=cc.CuentaCompleta and sc.FechaCorte >= Par_FechaCreacion and sc.FechaCorte<=Var_UltimoDia
						);

	set Var_RFC := (select RFC
					from PARAMETROSSIS param
					inner join INSTITUCIONES ins on param.InstitucionID=ins.InstitucionID);


select ifnull(Var_numCtas,Cadena_Cero),ifnull(Var_RFC,Cadena_Vacia);

end if;

END TerminaStore$$