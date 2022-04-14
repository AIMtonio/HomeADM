-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENAPLICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENAPLICAPRO`;
DELIMITER $$


CREATE PROCEDURE `COBROSPENAPLICAPRO`(

	Par_ClienteID		int(11),
	Par_CuentaAhoID		bigint(12),
	Par_Fecha			date,
	Par_FechaPago		date,
	Par_Transaccion		bigint(20),

	Par_Monto			decimal(12,2),
	Par_MontoConIVA		decimal(12,2),
	Par_MontoIVA		decimal(12,2),
	Par_DesMov			varchar(100),
	Par_DesIvaMov		varchar(100),

	Par_TipoMovAho		char(4),
	Par_TipoMovAhoIva	char(4),
	Par_MonedaID		int(11),
	Par_SucOrigen		int(11),
	Par_ConcepConta		int,

	Par_ConAho			int,
	Par_ConAhoIva		int,
	Par_AltaEncPoliza	char(1),
    Par_Salida			char(1),
	inout Par_NumErr	int,

    inout Par_ErrMen  	varchar(350),
	inout Par_Poliza	bigint,
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,

	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE	Salida_NO		char(1);
DECLARE	Salida_SI		char(1);
DECLARE Est_Pendiente	char(1);
DECLARE Var_SI			char(1);
DECLARE Var_NO			char(1);
DECLARE Nat_Cargo		char(1);
DECLARE Nat_Abono		char(1);
DECLARE AltaEncPolizaSi	char(1);
DECLARE AltaEncPolizaNo	char(1);
DECLARE AltaPolizaSi	char(1);
DECLARE Act_PagoPend	int(11);
DECLARE ConAhoPasivo		int;
DECLARE Var_CliProEsp    INT;
DECLARE Nat_Origen       char(1);
DECLARE Var_MontoP       decimal(12,2);
DECLARE Var_MontoS       decimal(12,2);
DECLARE Con_CliProcEspe  VARCHAR(20);
DECLARE Clien_especi     INT;


Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero	:= 0.0;
Set Est_Pendiente	:= 'P' ;
set	Nat_Cargo		:= 'C';
set	Nat_Abono		:= 'A';
set Var_SI			:= 'S';
set Var_NO			:= 'N';
set AltaPolizaSi	:= 'S';
set AltaEncPolizaSi	:= 'S';
set AltaEncPolizaNo	:= 'N';
set Salida_NO		:= 'N';
set Salida_SI		:= 'S';
Set	Act_PagoPend	:= 1;
set ConAhoPasivo	:= 1;
SET Clien_especi    :=9;

SET Con_CliProcEspe := 'CliProcEspecifico';


Set Aud_FechaActual	:= now();

SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);


IF (Var_CliProEsp = Clien_especi )THEN
    SET Nat_Origen  := Nat_Abono;
    SET Var_MontoP  :=   Par_MontoConIVA  ;
    SET Var_MontoS  := Decimal_Cero   ;

ELSE
    SET Nat_Origen  := Nat_Cargo;
    SET Var_MontoP  :=   Decimal_Cero  ;
    SET Var_MontoS  := Par_MontoConIVA   ;

END IF;





call COBROSPENDACT(
	Par_ClienteID,		Par_CuentaAhoID,		Par_Fecha,				Par_FechaPago,		Par_TipoMovAho,
	Par_Transaccion,	Par_Monto,				Act_PagoPend,			Salida_NO,			Par_NumErr,
	Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


if(Par_NumErr <> Entero_Cero)then
	if (Par_Salida = Salida_SI ) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'cuentaAhoID' as control,
				Entero_Cero as consecutivo;
	end if;
	LEAVE TerminaStore;
end if;


call CONTAAHORROPRO(
	Par_CuentaAhoID,	Par_ClienteID,			Par_Transaccion,		Par_FechaPago,		Par_FechaPago,
	Nat_Abono,			Par_Monto,				Par_DesMov,				Par_Transaccion,	Par_TipoMovAho,
	Par_MonedaID,		Par_SucOrigen,			Par_AltaEncPoliza,		Par_ConcepConta,	Par_Poliza,
	AltaPolizaSi, 		Par_ConAho,				Nat_Origen,				Par_NumErr,			Par_ErrMen,
	Entero_Cero,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


if(Par_NumErr <> Entero_Cero)then
	if (Par_Salida = Salida_SI ) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'cuentaAhoID' as control,
				Entero_Cero as consecutivo;
	end if;
	LEAVE TerminaStore;
end if;


call POLIZAAHORROPRO(
	Par_Poliza,				Par_EmpresaID,			Par_FechaPago, 			Par_ClienteID,		ConAhoPasivo,
	Par_CuentaAhoID,		Par_MonedaID,			Var_MontoP,		        Var_MontoS,		    Par_DesMov,
	convert(Par_CuentaAhoID,char),		Aud_Usuario,Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,			Aud_NumTransaccion);


if(Par_MontoIVA>Decimal_Cero)then

	call CONTAAHORROPRO(
		Par_CuentaAhoID,	Par_ClienteID,			Par_Transaccion,		Par_FechaPago,		Par_FechaPago,
		Nat_Abono,			Par_MontoIVA,			Par_DesIvaMov,			Par_Transaccion,	Par_TipoMovAhoIva,
		Par_MonedaID,		Par_SucOrigen,			AltaEncPolizaNo,		Par_ConcepConta,	Par_Poliza,
		AltaPolizaSi, 		Par_ConAhoIva,			Nat_Origen,				Par_NumErr,			Par_ErrMen,
		Entero_Cero,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

	if(Par_NumErr <> Entero_Cero)then
		if (Par_Salida = Salida_SI ) then
			select  Par_NumErr as NumErr,
					Par_ErrMen as ErrMen,
					'cuentaAhoID' as control,
					Entero_Cero as consecutivo;
		end if;
		LEAVE TerminaStore;
	end if;
end if;

set	Par_NumErr := 0;
set	Par_ErrMen := concat("Cobro Pendiente Aplicado.");


if (Par_Salida = Salida_SI ) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
end if;



END TerminaStore$$
