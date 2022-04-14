-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETACOMPNORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETACOMPNORPRO`;
DELIMITER $$


CREATE PROCEDURE `TARJETACOMPNORPRO`(

    Par_TarjetaID       char(16),
    Par_MontoTran       decimal(12,2),
    Par_MontoAdicio     decimal(12,2),
    Par_MonedaID        int,
    Par_Transaccion     varchar(10),
    Par_DescriMov       varchar(50),

    Par_Salida          char(1),
out Par_NumErr          int,
out Par_ErrMen          varchar(200),


    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint	)

TerminaStore: BEGIN


DECLARE Var_CuentaAhoID bigint;
DECLARE Var_FechaSis    date;
DECLARE Par_Referencia  varchar(35);
DECLARE Var_Poliza      bigint;
DECLARE Var_ClienteID   int;
DECLARE Var_DesAhorro   varchar(150);



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Salida_NO       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Mov_AhoCompra   varchar(4);
DECLARE Mov_AhoRetEfe   varchar(4);
DECLARE Con_TarjetaDeb  int;
DECLARE Con_OperacPOS   int;
DECLARE Con_AhoCapital  int;
DECLARE Pol_Automatica  char(1);
DECLARE Con_DescriMov   varchar(100);
DECLARE Con_DescriEfe   varchar(150);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Salida_NO       := 'N';
Set Nat_Cargo       := 'C';
Set Mov_AhoCompra   := '17';
Set Mov_AhoRetEfe   := '18';
Set Con_TarjetaDeb  := 300;
Set Con_OperacPOS   := 2;
Set Con_AhoCapital  := 1;
Set Pol_Automatica  := 'A';
set SalidaSI        := 'S';
set SalidaNO        := 'N';
Set Con_DescriMov   := 'COMPRA CON TARJETA DE DEBITO';

ManejoErrores: BEGIN

set Aud_FechaActual := now();

select  CuentaAhoID into Var_CuentaAhoID
    from TARJETADEBITO
    where TarjetaDebID = Par_TarjetaID;

set Var_CuentaAhoID := ifnull(Var_CuentaAhoID, Entero_Cero);

select  FechaSistema into Var_FechaSis
    from PARAMETROSSIS
    where EmpresaID = Par_EmpresaID;

select ClienteID into Var_ClienteID
    from CUENTASAHO
    where CuentaAhoID = Var_CuentaAhoID;


set Var_ClienteID   := ifnull(Var_ClienteID, Entero_Cero);
set Par_Referencia  := concat("TAR **** ", SUBSTRING(Par_TarjetaID,13, 4));
set Par_MontoAdicio := ifnull(Par_MontoAdicio, Entero_Cero);
set Var_DesAhorro   := concat("COMPRA.", Par_DescriMov);


INSERT INTO `CUENTASAHOMOV`     (
                    `CuentaAhoID`,					`NumeroMov`,					`Fecha`,					`NatMovimiento`,					`CantidadMov`,
                    `DescripcionMov`,				`ReferenciaMov`,				`TipoMovAhoID`,				`MonedaID`,							`PolizaID`,
                    `EmpresaID`,					`Usuario`,						`FechaActual`,				`DireccionIP`,						`ProgramaID`,
                    `Sucursal`,						`NumTransaccion`)
            VALUES  (
    Var_CuentaAhoID,    Aud_NumTransaccion, Var_FechaSis,       Nat_Cargo,      Par_MontoTran,
    Var_DesAhorro,      Par_Referencia,     Mov_AhoCompra,      Par_MonedaID,   Entero_Cero,
    Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,      Aud_NumTransaccion  );


CALL MAESTROPOLIZAALT(
    Var_Poliza,         Par_EmpresaID,  Var_FechaSis,       Pol_Automatica,     Con_TarjetaDeb,
    Con_DescriMov,      Salida_NO,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);


call POLIZAAHORROPRO(
    Var_Poliza,         Par_EmpresaID,  Var_FechaSis,       Var_ClienteID,      Con_AhoCapital,
    Var_CuentaAhoID,    Par_MonedaID,   Par_MontoTran,      Entero_Cero,        Par_DescriMov,
    Par_Referencia,     Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,       Aud_NumTransaccion  );


call POLIZATARJETAPRO(
    Var_Poliza,         Par_EmpresaID,      Var_FechaSis,   Par_TarjetaID,  Var_ClienteID,
    Con_OperacPOS,      Par_MonedaID,       Entero_Cero,    Par_MontoTran,  Par_DescriMov,
    Par_Referencia,     Entero_Cero,	    Salida_NO,          Par_NumErr,     Par_ErrMen,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion  );

if (Par_NumErr <> Entero_Cero)then
    LEAVE ManejoErrores;
end if;

set	Par_NumErr := Entero_Cero;
set	Par_ErrMen := "Operacion Registrada Exitosamente: ";

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'TarjetaID' as control,
            Entero_Cero as consecutivo;
end if;

END	TerminaStore$$
