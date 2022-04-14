-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENDLIS`;DELIMITER $$

CREATE PROCEDURE `COBROSPENDLIS`(
	Par_ClienteID		int(11),
	Par_CuentaAhoID 	bigint(12),
	Par_Mes				int,
	Par_Anio			int,
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID		int,
	Aud_Usuario			int,

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Lis_CobCteCta 		int;
DECLARE	Lis_CobCteCtaHis	int;


DECLARE Var_SumPenOri		decimal(12,2);
DECLARE Var_SumPenAct		decimal(12,2);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero	:= 0;
Set Lis_CobCteCta 	:= 1;
Set Lis_CobCteCtaHis:= 2;


if(Par_NumLis = Lis_CobCteCta) then
	select 	case when Cli.PagaIVA = 'S' then sum(Pen.CantPenOri)+sum(Pen.CantPenOri* Suc.IVA) ELSE sum(Pen.CantPenOri) end as CantPenOri,
			case when Cli.PagaIVA = 'S' then sum(Pen.CantPenAct)+sum(Pen.CantPenAct* Suc.IVA) ELSE sum(Pen.CantPenAct) end as CantPenAct
		into 	Var_SumPenOri,		Var_SumPenAct
		from 	COBROSPEND Pen,
				CLIENTES Cli,
				SUCURSALES Suc
		WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
		and 	Pen.ClienteID 	= Par_ClienteID
		and 	Pen.ClienteID 	= Cli.ClienteID
		and		Suc.SucursalID	= Cli.SucursalOrigen
		and 	CantPenAct		> 0;

	set	Var_SumPenOri	:= ifnull(Var_SumPenOri,Decimal_Cero);
	set Var_SumPenAct	:= ifnull(Var_SumPenAct,Decimal_Cero);

	Select 	Pen.Fecha,
			case when Cli.PagaIVA = 'S' then concat(Pen.Descripcion,' IVA INCLUIDO') ELSE Pen.Descripcion end as Descripcion,
			case when Cli.PagaIVA = 'S' then format(Pen.CantPenOri+(Pen.CantPenOri* Suc.IVA),2) ELSE format(Pen.CantPenOri,2) end as CantPenOri,
			case when Cli.PagaIVA = 'S' then format(Pen.CantPenAct+(Pen.CantPenAct* Suc.IVA),2) ELSE format(Pen.CantPenAct,2) end as CantPenAct,
			format(Var_SumPenOri,2) as Var_SumPenOri,
			format(ifnull(Var_SumPenAct,Decimal_Cero),2) as Var_SumPenAct
		from 	COBROSPEND Pen,
				CLIENTES Cli,
				SUCURSALES Suc
		WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
		and 	Pen.ClienteID 	= Par_ClienteID
		and 	Pen.ClienteID 	= Cli.ClienteID
		and		Suc.SucursalID	= Cli.SucursalOrigen
		and 	CantPenAct		> 0;
end if;



if(Par_NumLis = Lis_CobCteCtaHis) then
	select 	case when Cli.PagaIVA = 'S' then sum(Pen.CantPenOri)+sum(Pen.CantPenOri* Suc.IVA) ELSE sum(Pen.CantPenOri) end as CantPenOri,
			case when Cli.PagaIVA = 'S' then sum(Pen.CantPenAct)+sum(Pen.CantPenAct* Suc.IVA) ELSE sum(Pen.CantPenAct) end as CantPenAct
		into 	Var_SumPenOri,		Var_SumPenAct
		from 	COBROSPEND Pen,
				CLIENTES Cli,
				SUCURSALES Suc
		WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
		and 	Pen.ClienteID 	= Par_ClienteID
		and 	Pen.ClienteID 	= Cli.ClienteID
		and		Suc.SucursalID	= Cli.SucursalOrigen
		and 	Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		and 	Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		and 	CantPenAct		> 0;


	set	Var_SumPenOri	:= ifnull(Var_SumPenOri,Decimal_Cero);
	set Var_SumPenAct	:= ifnull(Var_SumPenAct,Decimal_Cero);

	Select 	Pen.Fecha,
			case when Cli.PagaIVA = 'S' then concat(Pen.Descripcion,' IVA INCLUIDO') ELSE Pen.Descripcion end as Descripcion,
			case when Cli.PagaIVA = 'S' then format(Pen.CantPenOri+(Pen.CantPenOri* Suc.IVA),2) ELSE format(Pen.CantPenOri,2) end as CantPenOri,
			case when Cli.PagaIVA = 'S' then format(Pen.CantPenAct+(Pen.CantPenAct* Suc.IVA),2) ELSE format(Pen.CantPenAct,2) end as CantPenAct,
			format(Var_SumPenOri,2) as Var_SumPenOri,
			format(ifnull(Var_SumPenAct,Decimal_Cero),2) as Var_SumPenAct
		from 	COBROSPEND Pen,
				CLIENTES Cli,
				SUCURSALES Suc
		WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
		and 	Pen.ClienteID 	= Par_ClienteID
		and 	Pen.ClienteID 	= Cli.ClienteID
		and		Suc.SucursalID	= Cli.SucursalOrigen
		and 	Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		and 	Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		and 	CantPenAct		> 0;

end if;


END TerminaStore$$