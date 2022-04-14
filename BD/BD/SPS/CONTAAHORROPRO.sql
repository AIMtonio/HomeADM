-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAAHORROPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTAAHORROPRO`(
	Par_CuentaAhoID		bigint,
	Par_ClienteID		bigint,
	Par_NumeroMov		bigint,
	Par_Fecha			date,
	Par_FechaAplicacion	date,

	Par_NatMovimiento	char(1),
	Par_CantidadMov		decimal(12,2),
	Par_DescripcionMov	varchar(150),
	Par_ReferenciaMov	varchar(50),
	Par_TipoMovAhoID	char(4),

	Par_MonedaID		int,
	Par_SucCliente		int,
	Par_AltaEncPoliza	char(1),
	Par_ConceptoCon		int,
	inout Par_Poliza	bigint,

	Par_AltaPoliza		char(1),
	Par_ConceptoAho		int,
	Par_NatConta		char(1),
	Par_NumErr			int(11),
	Par_ErrMen			varchar(100),

	Par_Consecutivo		bigint,
	Aud_EmpresaID		int,
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
DECLARE	AltaPoliza_SI	char(1);
DECLARE	AltaConta_SI	char(1);
DECLARE	Pol_Automatica	char(1);
DECLARE	EstatusActivo	char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE Salida_NO		char(1);


DECLARE	Var_Cargos		decimal(12,2);
DECLARE	Var_Abonos		decimal(12,2);
DECLARE Var_CuentaStr	varchar(20);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0.0;
Set	AltaPoliza_SI		:= 'S';
Set	AltaConta_SI		:= 'S';
Set	Pol_Automatica		:= 'A';
Set	EstatusActivo		:= 'A';
Set	Nat_Cargo			:= 'C';
Set	Nat_Abono			:= 'A';
Set	Salida_NO			:= 'N';


if (Par_AltaEncPoliza = AltaPoliza_SI) then
	CALL MAESTROPOLIZAALT(
		Par_Poliza,			Aud_EmpresaID,	Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
		Par_DescripcionMov,	Salida_NO, 		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
end if;


if (Par_AltaPoliza = AltaConta_SI	) then
	if(Par_NatConta = Nat_Cargo) then
		Set	Var_Cargos	:= Par_CantidadMov;
		Set	Var_Abonos	:= Decimal_Cero;
	else
		Set	Var_Cargos	:= Decimal_Cero;
		Set	Var_Abonos	:= Par_CantidadMov;
	end if;

	Set Var_CuentaStr 	:= concat("Cta.",convert(Par_CuentaAhoID, char));



	call POLIZAAHORROPRO(
		Par_Poliza,			Aud_EmpresaID,		Par_FechaAplicacion,	Par_ClienteID,		Par_ConceptoAho,
		Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos,				Var_Abonos,			Par_DescripcionMov,
		Var_CuentaStr,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

end if;


call CUENTASAHOMOVALT(
	Par_CuentaAhoID,		Par_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
	Par_DescripcionMov,		Par_ReferenciaMov,	Par_TipoMovAhoID,	Aud_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$