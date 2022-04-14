-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETARETEFEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS TARJETARETEFEPRO;
DELIMITER $$


CREATE PROCEDURE TARJETARETEFEPRO(

    Par_TarjetaID       char(16),
    Par_MontoTran       decimal(12,2),
    Par_MontoAdicio     decimal(12,2),
    Par_Surcharge       decimal(12,2),
    Par_LoyaltyFee      decimal(12,2),
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


DECLARE Var_MontoDisp   decimal(12,2);
DECLARE Var_MontoCom    decimal(12,2);
DECLARE Var_MontoIVACom decimal(12,2);
DECLARE Var_IVA         decimal(12,4);
DECLARE Var_FechaSis    date;
DECLARE Var_CuentaAhoID bigint;
DECLARE Par_Referencia  varchar(35);
DECLARE Var_Poliza      bigint;
DECLARE Var_ClienteID   int;
DECLARE Var_DesAhorro   varchar(150);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Salida_NO       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Mov_AhoRetEfe   varchar(4);
DECLARE Mov_AhoComRet   varchar(4);
DECLARE Mov_AhoIVACom   varchar(4);

DECLARE Con_TarjetaDeb  int;
DECLARE Con_RetATM      int;
DECLARE Con_AhoCapital  int;
DECLARE Pol_Automatica  char(1);
DECLARE Con_DescriMov   varchar(100);
DECLARE Con_DescriEfe   varchar(150);
DECLARE Des_ComRetiro   varchar(100);
DECLARE Des_IVAComRet   varchar(100);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Salida_NO       := 'N';
Set Nat_Cargo       := 'C';
Set Mov_AhoRetEfe   := '20';
Set Mov_AhoComRet   := '21';
Set Mov_AhoIVACom   := '22';

Set Con_TarjetaDeb  := 300;
Set Con_RetATM      := 1;
Set Con_AhoCapital  := 1;
Set Pol_Automatica  := 'A';
set SalidaSI        := 'S';
set SalidaNO        := 'N';
set Des_ComRetiro   := 'COMISION POR RETIRO';
set Des_IVAComRet   := 'IVA COMISION POR RETIRO';
Set Con_DescriMov   := 'RETIRO EFECTIVO EN OTRO BANCO CON TD';

ManejoErrores: BEGIN


set Par_Surcharge   := ifnull(Par_Surcharge, Entero_Cero);
set Par_LoyaltyFee  := ifnull(Par_LoyaltyFee, Entero_Cero);
set Var_MontoCom    := Entero_Cero;
set Var_MontoIVACom := Entero_Cero;
set Var_MontoDisp   := Par_MontoTran;
set Aud_FechaActual := now();

select  FechaSistema into Var_FechaSis
    from PARAMETROSSIS
    where EmpresaID = Par_EmpresaID;

select  CuentaAhoID into Var_CuentaAhoID
    from TARJETADEBITO
    where TarjetaDebID = Par_TarjetaID;

select ClienteID into Var_ClienteID
    from CUENTASAHO
    where CuentaAhoID = Var_CuentaAhoID;

set Par_Referencia  := concat("TAR **** ", SUBSTRING(Par_TarjetaID,13, 4));


if(Par_Surcharge > Entero_Cero ) then
    select IVA into Var_IVA
        from SUCURSALES
        where SucursalID = Aud_Sucursal;

    set Var_MontoDisp   := (Par_MontoTran - Par_Surcharge);
    set Var_MontoIVACom := round(Par_Surcharge / (1 + Var_IVA) * Var_IVA, 2);
    set Var_MontoCom    := Par_Surcharge - Var_MontoIVACom;

end if;

set Var_DesAhorro   := concat("RETIRO.", Par_DescriMov);


INSERT INTO CUENTASAHOMOV	(
                    CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
                    DescripcionMov,				ReferenciaMov,				TipoMovAhoID,				MonedaID,						PolizaID,
                    EmpresaID,					Usuario,					FechaActual,				DireccionIP,					ProgramaID,
                    Sucursal,					NumTransaccion)
    VALUES  (
    Var_CuentaAhoID,    Aud_NumTransaccion, Var_FechaSis,       Nat_Cargo,      Var_MontoDisp,
    Var_DesAhorro,      Par_Referencia,     Mov_AhoRetEfe,      Par_MonedaID,   Entero_Cero,
    Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,     Aud_NumTransaccion  );

if (Var_MontoCom > Entero_Cero) then

    INSERT INTO CUENTASAHOMOV	(
                    CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
                    DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
                    EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
                    Sucursal,						NumTransaccion)
    VALUES  (
        Var_CuentaAhoID,    Aud_NumTransaccion, Var_FechaSis,       Nat_Cargo,      Var_MontoCom,
        Des_ComRetiro,      Par_Referencia,     Mov_AhoComRet,      Par_MonedaID,   Entero_Cero,
        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );

    INSERT INTO CUENTASAHOMOV     (
                    CuentaAhoID,					NumeroMov,					Fecha,					NatMovimiento,					CantidadMov,
                    DescripcionMov,					ReferenciaMov,				TipoMovAhoID,			MonedaID,						PolizaID,
                    EmpresaID,						Usuario,					FechaActual,			DireccionIP,					ProgramaID,
                    Sucursal,						NumTransaccion)
    VALUES  (
        Var_CuentaAhoID,    Aud_NumTransaccion, Var_FechaSis,       Nat_Cargo,      Var_MontoIVACom,
        Des_IVAComRet,      Par_Referencia,     Mov_AhoIVACom,      Par_MonedaID,   Entero_Cero,
        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );
end if;


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
    Con_RetATM,         Par_MonedaID,       Entero_Cero,    Par_MontoTran,  Par_DescriMov,
    Par_Referencia,     Entero_Cero,		Salida_NO,          Par_NumErr,     Par_ErrMen,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion  );

if (Par_NumErr <> Entero_Cero)then
    LEAVE ManejoErrores;
end if;

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'TarjetaID' as control,
            Entero_Cero as consecutivo;
end if;


END TerminaStore$$
