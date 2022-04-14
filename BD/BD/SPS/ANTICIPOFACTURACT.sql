-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANTICIPOFACTURACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANTICIPOFACTURACT`;DELIMITER $$

CREATE PROCEDURE `ANTICIPOFACTURACT`(
    Par_AnticipoFactID      int(11),
    Par_ClaveDispMov        int(11),
    Par_ProveedorID         int(11),
    Par_NoFactura           varchar(20),
    Par_FormaPago           int(1),

    Par_NumAct              tinyint unsigned,
    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),
    Aud_EmpresaID           int(11),

    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,

    Aud_NumTransaccion      bigint

    )
Terminastore: BEGIN



DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero         int;
DECLARE EstatusCancela      char(1);
DECLARE EstatusPagado       char(1);
DECLARE FechaSist           date;
DECLARE SalidaSI            char(1);
DECLARE SalidaNO            char(1);
DECLARE Act_Cancelar        int(11);
DECLARE Act_Pagado          int(11);
DECLARE Act_DisperAlta      int(11);
DECLARE Act_DisperCance     int(11);
DECLARE Tipo_AntFactCan     char(1);
DECLARE Si_EmitePoliza      char(1);
DECLARE Var_Cheque          char(1);
DECLARE Var_Banca           char(1);
DECLARE Var_Tarjeta         char(1);
DECLARE Var_SPEI            char(1);
DECLARE Var_FormaPago       char(1);
DECLARE Con_PagoAntNO       char(1);
DECLARE Con_AntFactCan      INT;
DECLARE Des_AntFactCan      varchar(100);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Cuenta_Vacia        VARCHAR(15);
DECLARE AltaPoliza_NO       CHAR(1);


DECLARE Var_ProveedorID     int(11);
DECLARE Var_NoFactura       varchar(20);
DECLARE Var_Poliza          bigint;
DECLARE Var_MontoAnticipo   decimal(12,2);
DECLARE Var_RFC             char(13);
DECLARE Var_Control         varchar(100);
DECLARE CentroCostos        int(2);
DECLARE Var_NatConta        CHAR(2);
DECLARE Var_CtaAntProv      VARCHAR(25);
DECLARE Var_CtaProvee       VARCHAR(25);



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set EstatusCancela  := 'C';
Set EstatusPagado   := 'P';
set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set Act_Cancelar    := 1;
Set Act_Pagado      := 2;
Set Act_DisperAlta  := 3;
Set Act_DisperCance := 4;
Set Tipo_AntFactCan := 'K';
Set Si_EmitePoliza  := 'S';
Set Var_Cheque      := 'C';
Set Var_Banca       := 'B';
Set Var_Tarjeta     := 'T';
Set Var_SPEI        := 'S';
Set Con_PagoAntNO   := 'N';
Set Con_AntFactCan  := 84;
set Des_AntFactCan  := 'CANCELACION DE ANTICIPO DE FACTURA';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Cuenta_Vacia    := '000000000000000';
SET AltaPoliza_NO       := 'N';

set Aud_FechaActual := now();

set CentroCostos:= (select fac.CenCostoManualID
                            from ANTICIPOFACTURA ant
                                inner join FACTURAPROV fac on ant.ProveedorID=fac.ProveedorID and ant.NoFactura=fac.NoFactura
                            where ant.AnticipoFactID=Par_AnticipoFactID );

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                set Par_NumErr = 999;
                set Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-ANTICIPOFACTURACT');
                        SET Var_Control = 'sqlException' ;
            END;


if (Par_NumAct = Act_Cancelar)then
    set FechaSist := (Select FechaSistema from PARAMETROSSIS);

    Select  ProveedorID,        NoFactura,      ClaveDispMov,   MontoAnticipo
     into   Var_ProveedorID,    Var_NoFactura,  Par_ClaveDispMov,   Var_MontoAnticipo
        from ANTICIPOFACTURA
    where  AnticipoFactID  = Par_AnticipoFactID;

    if(Par_ClaveDispMov > Entero_Cero) then
        if(Par_Salida = SalidaSI) then
            select '001' as NumErr,
                'El Monto de Anticipo ya se encuentra en un folio de dispersion' as ErrMen,
                'montoAnticipo' as control,
                Entero_Cero as consecutivo;
            LEAVE TerminaStore;
        end if;

        if(Par_Salida =SalidaNO) then
            set Par_NumErr := 1;
            set Par_ErrMen := 'El Monto de Anticipo ya se encuentra un folio de dispersion';
        end if;
    end if;


    update ANTICIPOFACTURA set
        EstatusAnticipo  = EstatusCancela,
        FechaCancela     = FechaSist,

        EmpresaID        = Aud_EmpresaID,
        Usuario          = Aud_Usuario,
        FechaActual      = Aud_FechaActual,
        DireccionIP      = Aud_DireccionIP,
        ProgramaID       = Aud_ProgramaID,
        Sucursal         = Aud_Sucursal,
        NumTransaccion   = Aud_NumTransaccion

        where AnticipoFactID  = Par_AnticipoFactID;

Set Var_RFC := (select RFC from PROVEEDORES
                where   ProveedorID = Var_ProveedorID);

    SELECT CuentaAnticipo,CuentaCompleta
    INTO Var_CtaAntProv, Var_CtaProvee
    FROM PROVEEDORES
    WHERE ProveedorID = Var_ProveedorID;

    SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
    SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

    SET Var_NatConta := Nat_Abono;


    call CONTAFACTURAPRO(
        Var_ProveedorID,        Var_NoFactura,      Tipo_AntFactCan,    Con_PagoAntNO,      Si_EmitePoliza,
        Var_Poliza,             FechaSist,          Var_MontoAnticipo,  Entero_Cero,        CentroCostos,
        Var_CtaProvee,          Entero_Cero,        Var_RFC,            Cadena_Vacia,       Var_NatConta,
        Con_AntFactCan,         Des_AntFactCan,     Entero_Cero,        SalidaNO,           Par_NumErr,
        Par_ErrMen,             Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
    );

        SET Var_NatConta := Nat_Cargo;

        call CONTAFACTURAPRO(
        Var_ProveedorID,        Var_NoFactura,      Tipo_AntFactCan,    Con_PagoAntNO,      AltaPoliza_NO,
        Var_Poliza,             FechaSist,          Var_MontoAnticipo,  Entero_Cero,        CentroCostos,
        Var_CtaAntProv,         Entero_Cero,        Var_RFC,            Cadena_Vacia,       Var_NatConta,
        Con_AntFactCan,         Des_AntFactCan,     Entero_Cero,        SalidaNO,           Par_NumErr,
        Par_ErrMen,             Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
    );

    if (Par_Salida = SalidaSI) then
    select '000' as NumErr,
          "Anticipo de Factura Cancelado." as ErrMen,
             'noFactura' as control, Par_AnticipoFactID as consecutivo;
    end if;
    if (Par_Salida = SalidaNO) then
        set Par_NumErr := 0;
        set Par_ErrMen := 'Anticipo de Factura Cancelado.';
    end if;
end if;

if (Par_NumAct = Act_Pagado)then
    set FechaSist := (Select FechaSistema from PARAMETROSSIS);

    CASE Par_FormaPago
        WHEN 1 THEN SET Var_FormaPago := Var_SPEI;
        WHEN 2 THEN SET Var_FormaPago := Var_Cheque;
        WHEN 3 THEN SET Var_FormaPago := Var_Banca;
        WHEN 4 THEN SET Var_FormaPago := Var_Tarjeta;
    END CASE;


     update ANTICIPOFACTURA set
        EstatusAnticipo  = EstatusPagado,
        FechaCancela     = FechaSist,

        EmpresaID        = Aud_EmpresaID,
        Usuario          = Aud_Usuario,
        FechaActual      = Aud_FechaActual,
        DireccionIP      = Aud_DireccionIP,
        ProgramaID       = Aud_ProgramaID,
        Sucursal         = Aud_Sucursal,
        NumTransaccion   = Aud_NumTransaccion
        where       ProveedorID     =   Par_ProveedorID
            and     NoFactura       =   Par_NoFactura
            and     FormaPago       =   Var_FormaPago
            and     EstatusAnticipo =   'R'
            and     ClaveDispMov    =   Par_ClaveDispMov;

    if (Par_Salida = SalidaSI) then
        select '000' as NumErr,
          "Anticipo de Factura Pagado." as ErrMen,
             'noFactura' as control, Par_AnticipoFactID as consecutivo;
    else
        set Par_NumErr := 0;
        set Par_ErrMen := 'Anticipo de Factura Pagado.';
    end if;
end if;


if (Par_NumAct = Act_DisperAlta)then
    update ANTICIPOFACTURA set
            ClaveDispMov    = Par_ClaveDispMov,

            EmpresaID       = Aud_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion

        where   ProveedorID     =   Par_ProveedorID
        and     NoFactura       =   Par_NoFactura
        and     FormaPago       <>  'E'
        and     EstatusAnticipo =   'R'
        and     ClaveDispMov    =   Entero_Cero;

end if;


if (Par_NumAct = Act_DisperCance)then
    CASE Par_FormaPago
        WHEN 1 THEN SET Var_FormaPago := Var_SPEI;
        WHEN 2 THEN SET Var_FormaPago := Var_Cheque;
        WHEN 3 THEN SET Var_FormaPago := Var_Banca;
        WHEN 4 THEN SET Var_FormaPago := Var_Tarjeta;
    END CASE;


    update ANTICIPOFACTURA set
            ClaveDispMov    = Entero_Cero,

            EmpresaID       = Aud_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
        where   ProveedorID     =   Par_ProveedorID
        and     NoFactura       =   Par_NoFactura
        and     FormaPago       =   Var_FormaPago
        and     EstatusAnticipo =   'R'
        and     ClaveDispMov    =   Par_ClaveDispMov;
end if;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select '000' as NumErr,
      "Anticipo de Factura Actualizado." as ErrMen,
         'noFactura' as control, Par_AnticipoFactID as consecutivo;
else
    set Par_NumErr := 0;
    set Par_ErrMen := 'Anticipo de Factura Actualizado.';
end if;

END TerminaStore$$