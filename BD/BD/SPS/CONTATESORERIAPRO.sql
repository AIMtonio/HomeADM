-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTATESORERIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTATESORERIAPRO`;DELIMITER $$

CREATE PROCEDURE `CONTATESORERIAPRO`(
    Par_SucOperacion    int,
    Par_MonedaID        int,
    Par_InstitucionID   int,
    Par_CuentaBancos    varchar(20),
    Par_TipoGastoID     int,

    Par_ProveedorID     int,
    Par_TipImpuestoID   int,
    Par_FechaOperacion  date,
    Par_FechaAplicacion date,
    Par_Monto           decimal(14,4),

    Par_Descripcion     varchar(100),
    Par_Referencia      varchar(50),
    Par_Instrumento     varchar(20),

    Par_AltaEncPoliza   char(1),
inout	Par_Poliza        bigint,
    Par_ConceptoCon     int,
    Par_ConTesoreria    int,
    Par_NatConta        char(1),

    Par_AltaMovAho      char(1),
    Par_CuentaAhoID     bigint(12),
    Par_ClienteID       int,
    Par_TipoMovAho      varchar(4),
    Par_NatAhorro       char(1),

inout	Par_NumErr			int,
inout	Par_ErrMen			varchar(400),
inout	Par_Consecutivo		bigint,

    Par_Empresa         int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
		)
TerminaStore: BEGIN



DECLARE	Var_Cargos      decimal(14,4);
DECLARE	Var_Abonos      decimal(14,4);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12, 2);

DECLARE	AltaPoliza_SI		char(1);
DECLARE	AltaMovAho_SI		char(1);

DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);

DECLARE	Pol_Automatica	char(1);
DECLARE	Salida_NO		char(1);
DECLARE	Con_AhoCapital	int;


Set	Cadena_Vacia    := '';
Set	Fecha_Vacia     := '1900-01-01';
Set	Entero_Cero     := 0;
Set	Decimal_Cero    := 0.00;

Set	AltaPoliza_SI   := 'S';
Set	AltaMovAho_SI   := 'S';

Set	Nat_Cargo		    := 'C';
Set	Nat_Abono		    := 'A';

Set	Pol_Automatica  := 'A';
Set	Salida_NO       := 'N';
Set	Con_AhoCapital  := 1;


if (Par_AltaEncPoliza = AltaPoliza_SI) then
    CALL MAESTROPOLIZAALT(
        Par_Poliza,		Par_Empresa,    Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
        Par_Descripcion,	Salida_NO,      Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
end if;

if(Par_NatConta = Nat_Cargo) then
    set	Var_Cargos	:= Par_Monto;
    set	Var_Abonos	:= Decimal_Cero;
else
    set	Var_Cargos	:= Decimal_Cero;
    set	Var_Abonos	:= Par_Monto;
end if;


if (Par_AltaMovAho = AltaMovAho_SI	) then

	if(Par_NatAhorro = Nat_Cargo) then
		set	Var_Cargos	:= Par_Monto;
		set	Var_Abonos	:= Decimal_Cero;
	else
		set	Var_Cargos	:= Decimal_Cero;
		set	Var_Abonos	:= Par_Monto;
	end if;

    call CUENTASAHOMOVALT(
        Par_CuentaAhoID,    Aud_NumTransaccion, Par_FechaAplicacion,    Par_NatAhorro,  Par_Monto,
        Par_Descripcion,    Par_Referencia,     Par_TipoMovAho,         Par_Empresa,    Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);

    call POLIZAAHORROPRO(
        Par_Poliza,         Par_Empresa,        Par_FechaAplicacion,    Par_ClienteID,	    Con_AhoCapital,
        Par_CuentaAhoID,    Par_MonedaID,       Var_Cargos,             Var_Abonos,		    Par_Descripcion,
        Par_Referencia,     Aud_Usuario,	    Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion);

end if;

if(Par_NatConta = Nat_Cargo) then
    set	Var_Cargos	:= Par_Monto;
    set	Var_Abonos	:= Decimal_Cero;
else
    set	Var_Cargos	:= Decimal_Cero;
    set	Var_Abonos	:= Par_Monto;
end if;


call POLIZATESOREPRO(
    Par_Poliza,         Par_Empresa,        Par_FechaAplicacion,    Par_Instrumento,    Par_SucOperacion,
    Par_ConTesoreria,   Var_Cargos,         Var_Abonos,             Par_MonedaID,       Par_TipoGastoID,
    Par_ProveedorID,    Par_TipImpuestoID,  Par_InstitucionID,      Par_CuentaBancos,   Par_Descripcion,
    Par_Referencia,     Salida_NO,          Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
    Aud_NumTransaccion  );



END TerminaStore$$