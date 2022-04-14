-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAINVKUBOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAINVKUBOPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTAINVKUBOPRO`(
	Par_FondeoKuboID		bigint,
	Par_AmortizacionID	int(4),

	Par_CuentaAhoID		bigint,
	Par_ClienteID			bigint,
	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,
	Par_Monto			decimal(14,4),
	Par_MonedaID			int,
	Par_NumRetMes			int,
	Par_SucCliente		int,

	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(50),

	Par_AltaEncPoliza		char(1),
	Par_ConceptoCon		int,
inout	Par_Poliza			bigint,

	Par_AltaPolizaKubo	char(1),
	Par_AltaMovKubo		char(1),
	Par_ConcContaKubo		int,
	Par_TipoMovKubo		int,
	Par_NatKuboConta		char(1),
	Par_NatKuboOpe		char(1),

	Par_AltaMovAho		char(1),
	Par_TipoMovAho		varchar(4),
	Par_NatAhorro			char(1),

inout	Par_NumErr			int(11),
inout	Par_ErrMen			varchar(100),
inout	Par_Consecutivo		bigint,

	Par_Empresa			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN



DECLARE 	Var_CuentaStr		varchar(20);
DECLARE 	Var_InvKuboStr	varchar(20);
DECLARE	Var_Cargos		decimal(14,4);
DECLARE	Var_Abonos		decimal(14,4);
DECLARE	Var_RefCtaAho		varchar(50);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12, 2);

DECLARE	AltaPoliza_SI		char(1);
DECLARE	AltaMovAho_SI		char(1);
DECLARE	AltaMovKubo_SI	char(1);
DECLARE	AltaPolKubo_SI	char(1);

DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);

DECLARE	Pol_Automatica	char(1);
DECLARE	Salida_NO		char(1);
DECLARE	Con_AhoCapital	int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.00;

Set	AltaPoliza_SI		:= 'S';
Set	AltaMovAho_SI		:= 'S';
Set	AltaMovKubo_SI	:= 'S';
Set	AltaPolKubo_SI	:= 'S';

Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set	Pol_Automatica	:= 'A';
Set	Salida_NO		:= 'N';
Set	Con_AhoCapital	:= 1;

Set Var_InvKuboStr	:= convert(Par_FondeoKuboID, char);
Set Var_CuentaStr 	:= convert(Par_CuentaAhoID, char);


if (Par_AltaEncPoliza = AltaPoliza_SI) then
	CALL MAESTROPOLIZAALT(
		Par_Poliza,		Par_Empresa,	Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
		Par_Descripcion,	Salida_NO, 	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
end if;


if (Par_AltaMovKubo = AltaMovKubo_SI) then

	call FONDEOKUBOMOVSSALT(
		Par_FondeoKuboID,	Par_AmortizacionID,	Aud_NumTransaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
		Par_TipoMovKubo,	Par_NatKuboOpe,		Par_MonedaID,			Par_Monto,			Par_Descripcion,
		Par_Referencia, 	Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Par_Empresa,
		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

end if;


if (Par_AltaPolizaKubo = AltaPolKubo_SI) then

	if(Par_NatKuboConta = Nat_Cargo) then
		set	Var_Cargos	:= Par_Monto;
		set	Var_Abonos	:= Decimal_Cero;
	else
		set	Var_Cargos	:= Decimal_Cero;
		set	Var_Abonos	:= Par_Monto;
	end if;

	call POLIZAINVKUBOPRO(
		Par_Poliza,		Par_Empresa,			Par_FechaAplicacion,	Par_FondeoKuboID,	Par_NumRetMes,
		Par_SucCliente,	Par_ConcContaKubo,	Var_Cargos,			Var_Abonos,		Par_MonedaID,
		Par_Descripcion,	Var_InvKuboStr,		Par_NumErr,			Par_ErrMen,		Par_Consecutivo,
		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

end if;


if (Par_AltaMovAho = AltaMovAho_SI	) then

	if(Par_NatAhorro = Nat_Cargo) then
		set	Var_Cargos	:= Par_Monto;
		set	Var_Abonos	:= Decimal_Cero;
	else
		set	Var_Cargos	:= Decimal_Cero;
		set	Var_Abonos	:= Par_Monto;
	end if;

	set	Var_RefCtaAho		:= Par_Referencia;

	call CUENTASAHOMOVALT(
		Par_CuentaAhoID, 	Aud_NumTransaccion, 	Par_FechaAplicacion, 		Par_NatAhorro, 	Par_Monto,
		Par_Descripcion,	Var_RefCtaAho,		Par_TipoMovAho,			Par_Empresa, 		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


	call POLIZAAHORROPRO(
		Par_Poliza,		Par_Empresa,		Par_FechaAplicacion, 		Par_ClienteID,	Con_AhoCapital,
		Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos,				Var_Abonos,		Par_Descripcion,
		Var_CuentaStr,	Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

end if;

END TerminaStore$$