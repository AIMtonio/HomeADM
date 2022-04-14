-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BETRANSFERINTERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BETRANSFERINTERPRO`;DELIMITER $$

CREATE PROCEDURE `BETRANSFERINTERPRO`(
	Par_CuentaAhoOriID  bigint,
    Par_CuentaAhoDesID  bigint,
    Par_ReferenciaMov   varchar(35),
    Par_Monto           decimal(14,2),

    Par_Salida			char(1),
    inout Par_NumErr	int,
    inout Par_ErrMen	varchar(400),

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Poliza          bigint;
DECLARE Var_Control         varchar(50);
DECLARE Var_FecAplicacion   date;
DECLARE Var_SucCliente      int;

DECLARE Var_ClienteOri      int;
DECLARE Var_SaldoCtaOri     decimal(14,2);
DECLARE Var_MonedaCtaOri    int;
DECLARE Var_StatusCtaOri    char(1);

DECLARE Var_ClienteDes      int;
DECLARE Var_SaldoCtaDes     decimal(14,2);
DECLARE Var_MonedaCtaDes    int;
DECLARE Var_StatusCtaDes    char(1);



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Entero_Uno      int;
DECLARE Entero_Dos      int;
DECLARE Sta_Activa      char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Mov_TransCtas   varchar(4);
DECLARE Con_TransCta    int;
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE Alta_EncPolSI   char(1);
DECLARE Alta_EncPolNO   char(1);
DECLARE Alta_DetPolSI   char(1);
DECLARE Aho_ConCapital  int;
DECLARE Des_MovimiCta   varchar(100);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Entero_Uno      := 1;
Set Entero_Dos      := 2;
Set Sta_Activa      := 'A';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Nat_Abono       := 'A';
Set Mov_TransCtas   := '12';
Set Con_TransCta    := 501;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set Alta_EncPolSI   := 'S';
Set Alta_EncPolNO   := 'N';
Set Alta_DetPolSI   := 'S';
Set Aho_ConCapital  := 1;
set Des_MovimiCta   := 'TRANSFERENCIA, B.LINEA.';

ManejoErrores: BEGIN

set Aud_FechaActual 	:= NOW();
set Aud_ProgramaID    := 'BETRANSFERINTERPRO';

call TRANSACCIONESPRO(Aud_NumTransaccion);

select FechaSistema into Var_FecAplicacion
    from PARAMETROSSIS;


call SALDOSAHORROCON(
    Var_ClienteOri,     Var_SaldoCtaOri,    Var_MonedaCtaOri,   Var_StatusCtaOri,
    Par_CuentaAhoOriID  );

if(Var_StatusCtaOri != Sta_Activa) then
    set Par_NumErr  := 1;
    set Par_ErrMen  := 'El Estatus de la Cuenta de Cargo no esta Activa';
    set Var_Control := 'cuentaCargoID';
    LEAVE ManejoErrores;
end if;

if(Var_SaldoCtaOri < Par_Monto) then
    set Par_NumErr  := 2;
    set Par_ErrMen  := 'Saldo Disponible Insuficiente para Realizar la Transferencia';
    set Var_Control := 'cuentaCargoID';
    LEAVE ManejoErrores;
end if;




set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;

set Des_MovimiCta = concat(Des_MovimiCta, "CTA: **", lpad(right(convert(Par_CuentaAhoDesID, char),4),4,'0'));

select  SucursalOrigen into Var_SucCliente
    from CLIENTES
    where ClienteID = Var_ClienteOri;

call CONTAAHORROPRO(
    Par_CuentaAhoOriID, Var_ClienteOri,     Aud_NumTransaccion, Var_FecAplicacion,  Var_FecAplicacion,
    Nat_Cargo,          Par_Monto,          Des_MovimiCta,      Par_ReferenciaMov,  Mov_TransCtas,
    Var_MonedaCtaOri,   Var_SucCliente,     Alta_EncPolSI,      Con_TransCta,       Var_Poliza,
    Alta_DetPolSI,      Aho_ConCapital,     Nat_Cargo,          Par_NumErr,         Par_ErrMen,
    Entero_Uno,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

if (Par_NumErr != Entero_Cero) then
    LEAVE ManejoErrores;
end if;




call SALDOSAHORROCON(
    Var_ClienteDes,     Var_SaldoCtaDes,    Var_MonedaCtaDes,   Var_StatusCtaDes,
    Par_CuentaAhoDesID  );

if(Var_StatusCtaDes != Sta_Activa) then
    set Par_NumErr  := 3;
    set Par_ErrMen  := 'El Estatus de la Cuenta Beneficiaria no esta Activa';
    set Var_Control := 'cuentaCargoID';
    LEAVE ManejoErrores;
end if;

if(Var_MonedaCtaOri != Var_MonedaCtaDes) then
    set Par_NumErr  := 4;
    set Par_ErrMen  := 'La Moneda de la Cuenta Origen y del Beneficiario son Distintas';
    set Var_Control := 'cuentaCargoID';
    LEAVE ManejoErrores;
end if;

set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;

set Des_MovimiCta = concat('TRANSFERENCIA, B.LINEA.',
                           "CTA: **", lpad(right(convert(Par_CuentaAhoOriID, char),4),4,'0'));

select  SucursalOrigen into Var_SucCliente
    from CLIENTES
    where ClienteID = Var_ClienteDes;

call CONTAAHORROPRO(
    Par_CuentaAhoDesID, Var_ClienteDes,     Aud_NumTransaccion, Var_FecAplicacion,  Var_FecAplicacion,
    Nat_Abono,          Par_Monto,          Des_MovimiCta,      Par_ReferenciaMov,  Mov_TransCtas,
    Var_MonedaCtaDes,   Var_SucCliente,     Alta_EncPolNO,      Con_TransCta,       Var_Poliza,
    Alta_DetPolSI,      Aho_ConCapital,     Nat_Abono,          Par_NumErr,         Par_ErrMen,
    Entero_Dos,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

if (Par_NumErr != Entero_Cero) then
    LEAVE ManejoErrores;
end if;

set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := 'Transaccion Realizada';
set Var_Control := 'cuentaCargoID';

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$