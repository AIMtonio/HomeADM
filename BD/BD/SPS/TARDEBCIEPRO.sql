-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCIEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS TARDEBCIEPRO;
DELIMITER $$


CREATE PROCEDURE TARDEBCIEPRO(
	Par_FechaActual 	varchar(10)
	)

TerminaStore:BEGIN

DECLARE Var_MesAnterior			date;
DECLARE Var_MesInicio			date;
DECLARE Var_MesFin				date;
DECLARE Var_MovsAnterior		int(11);


DECLARE MovsCero				char(1);


set MovsCero:= '0';



set Var_MesAnterior:=(select Par_FechaActual-interval 1 month);

set Var_MesInicio:=(select concat(substring(Var_MesAnterior,1,8),'01'));

set Var_MesFin:=last_day(Var_MesInicio);

set Var_MovsAnterior := (select count(*)
							from CUENTASAHOMOV
							where Fecha >= Var_MesInicio and Fecha <= Var_MesFin);


if(Var_MovsAnterior > MovsCero) then

	drop table if exists HISCTASTARJETAS;

	create temporary table HISCTASTARJETAS(
	RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	CuentaAhoID			bigint(12),
	NatMovimiento		char(1),
	CantidadMov			decimal(12,2),
	index(CuentaAhoID)
	);

	drop table if exists TMPCTASMOVS;

	create temporary table TMPCTASMOVS(
            RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			CuentaAhoID 		bigint(12),
			NumeroMov 			bigint(20) ,
			Fecha 				date ,
			NatMovimiento 		char(1) ,
			CantidadMov			decimal(12,2) ,
			DescripcionMov 		varchar(150) ,
			ReferenciaMov 		varchar(50),
			TipoMovAhoID 		char(4) ,
			MonedaID 			int(11),
			PolizaID 			bigint(20),
			EmpresaID 			int(11) ,
			Usuario 			int(11),
			FechaActual 		datetime ,
			DireccionIP 		varchar(15) ,
			ProgramaID 			varchar(50) ,
			Sucursal 			int(11) ,
			NumTransaccion 		bigint(20) ,
			index(CuentaAhoID)
	);

	insert into TMPCTASMOVS (
				CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
				DescripcionMov,				ReferenciaMov,					TipoMovAhoID,			MonedaID,						PolizaID,
				EmpresaID,					Usuario,						FechaActual,			DireccionIP,					ProgramaID,
				Sucursal,					NumTransaccion)
	
	select 	CuentaAhoID,NumeroMov,Fecha,NatMovimiento,CantidadMov,
			DescripcionMov,ReferenciaMov,TipoMovAhoID,MonedaID,PolizaID,
			EmpresaID,Usuario,FechaActual,DireccionIP,ProgramaID,
			Sucursal,NumTransaccion
		from CUENTASAHOMOV
		where Fecha>= Var_MesInicio and Fecha <= Var_MesFin
		and TipoMovAhoID in(17,20,21,22,86,87,88,96,97,98);

	insert into HISCTASTARJETAS (CuentaAhoID,		NatMovimiento,		CantidadMov)
	select CuentaAhoID,NatMovimiento,sum(CantidadMov)
		from TMPCTASMOVS
		group by CuentaAhoID,NatMovimiento;


	delete
	from CUENTASAHOMOV
		where Fecha>=Var_MesInicio and Fecha<=Var_MesFin;

	INSERT INTO `HIS-CUENAHOMOV`	(
			`CuentaAhoID`,					`NumeroMov`,					`Fecha`,					`NatMovimiento`,					`CantidadMov`,
			`DescripcionMov`,				`ReferenciaMov`,				`TipoMovAhoID`,				`MonedaID`,							`PolizaID`,
			`EmpresaID`,					`Usuario`,						`FechaActual`,				`DireccionIP`,						`ProgramaID`,
			`Sucursal`,						`NumTransaccion`)
	select 	CuentaAhoID,NumeroMov,Fecha,NatMovimiento,CantidadMov,
			DescripcionMov,ReferenciaMov,TipoMovAhoID,MonedaID,PolizaID,
			EmpresaID,Usuario,FechaActual,DireccionIP,ProgramaID,
			Sucursal,NumTransaccion
		from TMPCTASMOVS;

	update `HIS-CUENTASAHO` his
		inner join HISCTASTARJETAS tar on his.CuentaAhoID=tar.CuentaAhoID
		set his.Saldo =(his.saldo-tar.CantidadMov),
			his.SaldoDispon=(his.SaldoDispon-tar.CantidadMov),
			his.SaldoProm=(his.SaldoProm-tar.CantidadMov),
			his.CargosMes=(his.CargosMes+tar.cantidadMov)
		where his.Fecha >= Var_MesInicio and his.Fecha<=Var_MesFin;

	update CUENTASAHO cta
		inner join HISCTASTARJETAS tar on cta.CuentaAhoID=tar.CuentaAhoID
		set	cta.SaldoIniMes=(cta.SaldoIniMes-tar.CantidadMov),
			cta.SaldoProm=(cta.SaldoProm-tar.CantidadMov),
			cta.CargosMes=(cta.CargosMes-tar.cantidadMov),
			cta.CargosDia=(cta.CargosDia-tar.cantidadMov);

end if;



END TerminaStore$$
