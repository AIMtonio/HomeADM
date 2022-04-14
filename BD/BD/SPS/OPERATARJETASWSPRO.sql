-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERATARJETASWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPERATARJETASWSPRO`;DELIMITER $$

CREATE PROCEDURE `OPERATARJETASWSPRO`(


	Par_TarDebID			char(16),
	Par_NatMovimiento		char(2),
	Par_MontoOpe 			decimal(12,2),
	Par_NIP				varchar(256),
	Par_Salida				char(1),
	inout Par_NumErr   		 int,
    inout Par_ErrMen    		varchar(400),

	Par_EmpresaID			int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero		int;
DECLARE	DecimalCero		decimal(12,2);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
declare Salida_NO 			char(1);
declare	Var_Si	 		char(1);
DECLARE	EstatusActivo		char(1);
DECLARE	EstatusAsigna		int(11);
DECLARE	EstatusExpira		int(11);


DECLARE	Var_SaldoDisp		decimal(12,2);
DECLARE	Var_CuentaAhoID	bigint(12);
DECLARE	Var_Cuenta		int(12);
DECLARE	Var_EstatusCta		char(1);
DECLARE	Var_EstatusTar		int(11);
DECLARE	Var_NIP			varchar(256);
DECLARE	Var_FechaVencim	char(5);
DECLARE	Var_Anio 			char(5);
DECLARE	Var_Mes			char(5);
DECLARE	Var_AnioTar		char(5);
DECLARE	Var_MesTar		char(5);


Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	DecimalCero		:= 0.00;
Set	EstatusActivo		:= 'A';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Salida_NO			:= 'N';
Set	Var_Si			:= 'S';
Set	EstatusAsigna		:= 6;
Set	EstatusExpira		:= 10;


select Estatus, NIP, FechaVencimiento, CuentaAhoID
	into Var_EstatusTar , Var_NIP, Var_FechaVencim, Var_CuentaAhoID
	from TARJETADEBITO
	where TarjetaDebID =  Par_TarDebID;

if(ifnull(Var_EstatusTar, Entero_Cero) <> EstatusAsigna ) then
	if(ifnull(Var_EstatusTar, Entero_Cero) = EstatusExpira ) then
		if(Par_Salida =  Var_Si) then
			select '33' as CodigoRespuesta,
					'Tarjeta Expirada.' as MensajeRespuesta,
					Entero_Cero  as SaldoActualizado,
					Entero_Cero  as NumeroTransaccion;
		else
			set Par_NumErr	:= 33;
			set Par_ErrMen	:= 'Tarjeta Expirada.';
		end if;
	else
		if(Par_Salida =  Var_Si) then
			select '14' as CodigoRespuesta,
					'Numero de Tarjeta Invalido.' as MensajeRespuesta,
					Entero_Cero  as SaldoActualizado,
					Entero_Cero  as NumeroTransaccion;
		else
			set Par_NumErr	:= 14;
			set Par_ErrMen	:= 'Numero de Tarjeta Invalido.';
		end if;
	end if;
	LEAVE TerminaStore;
end if;


set Var_NIP := ifnull(Var_NIP,Cadena_Vacia);
if(ifnull(Par_NIP, Cadena_Vacia) <> Var_NIP) then
	if(Par_Salida =  Var_Si) then
		select '55' as CodigoRespuesta,
				'Numero de Identificacion incorrecto' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
	else
		set Par_NumErr	:= 55;
		set Par_ErrMen	:= 'Numero de Identificacion incorrecto';
	end if;
	LEAVE TerminaStore;
end if;


set Var_MesTar	:= SUBSTRING(Var_FechaVencim, 1,2);
set Var_AnioTar	:= SUBSTRING(Var_FechaVencim, 4,2);

select SUBSTRING(FechaSistema, 6,2), SUBSTRING(FechaSistema, 3,2)
into Var_Mes, Var_Anio
from PARAMETROSSIS;


if( cast(Var_AnioTar as signed ) < cast(Var_Anio as signed ) ) then
	if(Par_Salida =  Var_Si) then
		select '33' as CodigoRespuesta,
			'Tarjeta Expirada.' as MensajeRespuesta,
			Entero_Cero  as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion;
	else
		set Par_NumErr	:= 33;
		set Par_ErrMen	:= 'Tarjeta Expirada.';
	end if;

	LEAVE TerminaStore;
else
	if( cast(Var_MesTar as signed ) < cast(Var_Mes as signed ) ) then
		if(Par_Salida =  Var_Si) then
			select '33' as CodigoRespuesta,
				'Tarjeta Expirada.' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
		else
			set Par_NumErr	:= 33;
			set Par_ErrMen	:= 'Tarjeta Expirada.';
		end if;
		LEAVE TerminaStore;
	end if;
end if;



select ifnull(SaldoDispon,Entero_Cero),  Estatus, CuentaAhoID   into Var_SaldoDisp, Var_EstatusCta, Var_Cuenta
	from CUENTASAHO
	where CuentaAhoID = Var_CuentaAhoID;

if( ifnull(Var_Cuenta,Entero_Cero) = Entero_Cero) then
	if(Par_Salida =  Var_Si) then
		select '14' as CodigoRespuesta,
				'Numero de Tarjeta Invalido.' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
	else
		set Par_NumErr	:= 14;
		set Par_ErrMen	:= 'Numero de Tarjeta Invalido.';
	end if;
	LEAVE TerminaStore;
end if;


if(Var_EstatusCta <>EstatusActivo) then
	if(Par_Salida =  Var_Si) then
		select '14' as CodigoRespuesta,
				'Numero de Tarjeta Invalido.' as MensajeRespuesta,
				Entero_Cero  as SaldoActualizado,
				Entero_Cero  as NumeroTransaccion;
	else
		set Par_NumErr	:= 14;
		set Par_ErrMen	:= 'Numero de Tarjeta Invalido.';
	end if;
	LEAVE TerminaStore;
end if;


if(Par_NatMovimiento = Nat_Cargo) then
	if(Var_SaldoDisp<Par_MontoOpe ) then
		if(Par_Salida =  Var_Si) then
			select '51' as CodigoRespuesta,
					'Saldo insuficiente.' as MensajeRespuesta,
					Entero_Cero  as SaldoActualizado,
					Entero_Cero  as NumeroTransaccion;
		else
			set Par_NumErr	:= 51;
			set Par_ErrMen	:= 'Saldo insuficiente.';
		end if;
		LEAVE TerminaStore;
	else
		update CUENTASAHO set
			CargosDia		= CargosDia		+Par_MontoOpe ,
			CargosMes		= CargosMes		+Par_MontoOpe,
			Saldo 			= Saldo 		-Par_MontoOpe,
			SaldoDispon		= SaldoDispon 	-Par_MontoOpe
		where CuentaAhoID 	= Var_CuentaAhoID;
	end if;
end if;

if(Par_NatMovimiento = Nat_Abono) then
	update CUENTASAHO set
			AbonosDia		= AbonosDia		+Par_MontoOpe,
			AbonosMes		= AbonosMes		+Par_MontoOpe,
			Saldo 			= Saldo 		+Par_MontoOpe,
			SaldoDispon		= SaldoDispon	+Par_MontoOpe
		where CuentaAhoID 	= Var_CuentaAhoID;
end if;


if(Par_Salida =  Var_Si) then
	select '00' as CodigoRespuesta,
			'Operacion Realizada.' as MensajeRespuesta,
			ifnull(SaldoDispon,Entero_Cero) as SaldoActualizado,
			Entero_Cero  as NumeroTransaccion
		from CUENTASAHO
		where CuentaAhoID = Var_CuentaAhoID;
else
	set Par_NumErr	:= 0;
	set Par_ErrMen	:= 'Operacion Realizada.';
end if;

END TerminaStore$$