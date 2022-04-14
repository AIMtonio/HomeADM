-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBDEPOSIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBDEPOSIPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBDEPOSIPRO`(
    Par_TarjetaID       char(16),
    Par_MontoTran       decimal(12,2),
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
DECLARE Var_DesAho      varchar(150);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Salida_NO       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Mov_AhoDeposi   varchar(4);
DECLARE Con_TarjetaDeb  int;
DECLARE Con_DeposiRED   int;
DECLARE Con_AhoCapital  int;
DECLARE Pol_Automatica  char(1);
DECLARE Con_DescriMov   varchar(100);
DECLARE Con_DescriEfe   varchar(150);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE Decimal_Cero    decimal(12,2);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Salida_NO       := 'N';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Mov_AhoDeposi   := '19';
Set Con_TarjetaDeb  := 300;
Set Con_DeposiRED   := 3;
Set Con_AhoCapital  := 1;
Set Pol_Automatica  := 'A';
set SalidaSI        := 'S';
set SalidaNO        := 'N';
set Con_DescriMov   := 'DEPOSITO A CTA CON TD EN RED';
set Decimal_Cero    := '0.00';

    ManejoErrores: BEGIN

    set Aud_FechaActual := now();

    if (ifnull(Par_MontoTran, Decimal_Cero) = Decimal_Cero )then
        select '13' as CodigoRespuesta,
            'Cantidad Invalida.' as MensajeRespuesta,
            Entero_Cero  as SaldoActualizado,
            Entero_Cero  as NumeroTransaccion;
        LEAVE ManejoErrores;
    end if;

    SELECT CuentaAhoID into Var_CuentaAhoID
        FROM TARJETADEBITO
        WHERE TarjetaDebID = Par_TarjetaID;

    set Var_CuentaAhoID := ifnull(Var_CuentaAhoID, Entero_Cero);


    UPDATE CUENTASAHO set
        AbonosDia   = AbonosDia + Par_MontoTran,
        AbonosMes   = AbonosMes + Par_MontoTran,
        Saldo       = Saldo  + Par_MontoTran,
        SaldoDispon = SaldoDispon + Par_MontoTran
        WHERE CuentaAhoID 	= Var_CuentaAhoID;

    SELECT FechaSistema into Var_FechaSis
        FROM PARAMETROSSIS
        WHERE EmpresaID = Par_EmpresaID;

    SELECT ClienteID into Var_ClienteID
        FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;


    set Var_ClienteID   := ifnull(Var_ClienteID, Entero_Cero);
    set Par_Referencia  := concat("TAR **** ", SUBSTRING(Par_TarjetaID,13, 4));
    set Var_DesAho 		:= concat("PAGO TARJETA.",Par_DescriMov);

    INSERT INTO CUENTASAHOMOV(CuentaAhoID,	NumeroMov,	Fecha,		NatMovimiento,	CantidadMov,
			      DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,	PolizaID,
			      EmpresaID, 	Usuario,	FechaActual,	DireccionIP, 	ProgramaID,
			      Sucursal,		NumTransaccion)
      VALUES(
        Var_CuentaAhoID, Aud_NumTransaccion, Var_FechaSis,       Nat_Abono,       Par_MontoTran,
        Var_DesAho,      Par_Referencia, 	Mov_AhoDeposi,      Par_MonedaID,    Entero_Cero,
	Par_EmpresaID,   Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,
	Aud_Sucursal,	 Aud_NumTransaccion  );


    CALL MAESTROPOLIZAALT(
        Var_Poliza,         Par_EmpresaID,  Var_FechaSis,       Pol_Automatica,     Con_TarjetaDeb,
        Con_DescriMov,      Salida_NO,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);


    call POLIZAAHORROPRO(
        Var_Poliza,         Par_EmpresaID,  Var_FechaSis,       Var_ClienteID,      Con_AhoCapital,
        Var_CuentaAhoID,    Par_MonedaID,   Entero_Cero,        Par_MontoTran,      Par_DescriMov,
        Par_Referencia,     Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion  );


    call POLIZATARJETAPRO(
        Var_Poliza,         Par_EmpresaID,      Var_FechaSis,     Par_TarjetaID,  Var_ClienteID,
        Con_DeposiRED,      Par_MonedaID,       Par_MontoTran,    Entero_Cero,    Par_DescriMov,
        Par_Referencia,     Entero_Cero,	Salida_NO,        Par_NumErr,     Par_ErrMen,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
        Aud_NumTransaccion  );

    if (Par_NumErr <> Entero_Cero)then
        LEAVE ManejoErrores;
    end if;

    if (Par_NumErr = Entero_Cero)then
        SELECT
            '00' as CodigoRespuesta,
            'Pago Realizado Correctamente' as MensajeRespuesta,
            Entero_Cero  as SaldoActualizado,
            Entero_Cero  as NumeroTransaccion;
        end if;
    END ManejoErrores;
END TerminaStore$$