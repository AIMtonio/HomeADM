-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBMOVSLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBMOVSLIS`(
	Par_CuentaAhoID		bigint(12),
	Par_Mes				int,
	Par_Anio			int,
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



declare	Nat_Cargo			char(1);
declare	Cadena_Vacia		char(1);
declare	Decimal_Cero		decimal(12,2);
declare	Nat_Abono			char(1);
declare	Lis_Principal 		int;
declare	Lis_PrincipalHis 	int;



declare	SaldoDisp			decimal(12,2);
declare	Var_ClienteID 		int;
declare	Movimiento			char(1);
declare	NumeroMov			int;
declare	VarFecha			date;
declare	VarMovimiento		char(1);
declare	VarDescripcion		varchar(150);
declare	VarCantidadMov		decimal(12,2);
declare	VarReferenciaMov	varchar(15);
declare	VarSaldo			decimal(12,2);
declare	Var_FechaSistema	date;
declare	Var_FechaIni 		char(16);
declare	Var_FechaInicial 	date;
declare	Var_FechaFinal 		date;
declare	Var_FechaSis	 	date;
declare	Var_FechaSisIni 	date;
declare SaldoIniMesMov		decimal(12,2);
declare SaldoIniMesHis		decimal(12,2);

DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE TiposMovs		int;
DECLARE TiposMovs1		int;
DECLARE TiposMovs2		int;
DECLARE TiposMovs3		int;
DECLARE TiposMovs4		int;


declare  	CursorMov  CURSOR FOR
		select 	CM.Fecha, 		CM.NatMovimiento, 	CM.DescripcionMov, 	CM.CantidadMov, 	CM.ReferenciaMov
		from		CUENTASAHOMOV	CM
		where	CM.CuentaAhoID		=	Par_CuentaAhoID
		and 		CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		and 		CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		and 		CM.TipoMovAhoID in(TiposMovs,TiposMovs1,TiposMovs2,TiposMovs3,TiposMovs4)
		order by CM.Fecha, CM.FechaActual, CM.NatMovimiento;

declare  	CursorMovHis  CURSOR FOR
		select 	CM.Fecha, 		CM.NatMovimiento, 	CM.DescripcionMov,	CM.CantidadMov, 	CM.ReferenciaMov
		FROM		`HIS-CUENAHOMOV`	CM
		where	CM.CuentaAhoID		=	Par_CuentaAhoID
		and 		CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		and 		CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
		and 		CM.TipoMovAhoID in(TiposMovs,TiposMovs1,TiposMovs2,TiposMovs3,TiposMovs4)
		order by CM.Fecha, CM.FechaActual,CM.NatMovimiento;



Set	SaldoDisp		:= 0.0;
Set	Movimiento		:= '';
Set	NumeroMov		:= 0;
Set VarSaldo		:= 0;

select FechaSistema into Var_FechaSistema from  PARAMETROSSIS;
Set Var_FechaIni		:= CONCAT(Par_Anio,'-', Par_Mes,'-','01');
set Var_FechaInicial 	:= date_format(Var_FechaIni, '%Y-%m-%d');
set Var_FechaFinal 		:= last_day(Var_FechaInicial);
set Var_FechaSis 		:= (select FechaSistema from PARAMETROSSIS);

set Var_FechaSisIni	:= convert(DATE_ADD(Var_FechaSis, interval -1*(day(Var_FechaSis))+1 day),char(12));

set SaldoIniMesMov 	:= (select ifnull(SaldoIniMes,Decimal_Cero) from CUENTASAHO where CuentaAhoID = Par_CuentaAhoID limit 1);

set SaldoIniMesHis	:= (select ifnull(SaldoIniMes,Decimal_Cero) from `HIS-CUENTASAHO` where CuentaAhoID = Par_CuentaAhoID
						and Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
						and Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01')) limit 1);


Set	Cadena_Vacia		:= '';
Set	Decimal_Cero		:= 0.00;
Set	Lis_Principal		:= 1;
Set	Lis_PrincipalHis	:= 2;
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set Entero_Cero     := 0;
set TiposMovs		:= 18;
set TiposMovs1		:= 19;
set TiposMovs2		:= 20;
set TiposMovs3		:= 21;
set TiposMovs4		:= 22;


if(Par_NumLis = Lis_Principal) then

	Create Temporary Table TMPMOVIMIENTOS(Fecha date, NatMovimiento char(1), DescripcionMov varchar(150),
							CantidadMov decimal(12,2), ReferenciaMov varchar(35));



	Open  CursorMov;
	BEGIN
		declare EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorMov  Into VarFecha, VarMovimiento, VarDescripcion, VarCantidadMov, VarReferenciaMov;



			insert into TMPMOVIMIENTOS
				values (	VarFecha,	VarMovimiento,	VarDescripcion, 	VarCantidadMov, 	VarReferenciaMov);

		End Loop;
	END;
	Close CursorMov;


	select 	Fecha, 				NatMovimiento, 		DescripcionMov,			FORMAT(CantidadMov,2),	ReferenciaMov

	 from TMPMOVIMIENTOS;

	Drop Table TMPMOVIMIENTOS;

end if;


if(Par_NumLis = Lis_PrincipalHis) then

	Create Temporary Table TMPMOVIMIENTOS(Fecha date, NatMovimiento char(1), DescripcionMov varchar(150),
							CantidadMov decimal(12,2), ReferenciaMov varchar(35));



	Open  CursorMovHis;
	BEGIN
		declare EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		Loop
			Fetch CursorMovHis  Into VarFecha, VarMovimiento, VarDescripcion, VarCantidadMov, VarReferenciaMov;



			insert into TMPMOVIMIENTOS
				values (	VarFecha,	VarMovimiento,	VarDescripcion, 	VarCantidadMov,	VarReferenciaMov);

		End Loop;
	END;
	Close CursorMovHis;


	select 	Fecha,			NatMovimiento,	DescripcionMov,	FORMAT(CantidadMov,2),	ReferenciaMov

	 from TMPMOVIMIENTOS;

	Drop Table TMPMOVIMIENTOS;

end if;


END TerminaStore$$