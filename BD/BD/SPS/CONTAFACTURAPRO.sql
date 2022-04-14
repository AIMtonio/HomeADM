-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAFACTURAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAFACTURAPRO`;DELIMITER $$

CREATE PROCEDURE `CONTAFACTURAPRO`(
    Par_ProveedorID     INT(11),
    Par_NoFactura       VARCHAR(20),
    Par_TipoRegis       char(1),

    Par_PagoAnticipado  CHAR(1),
    Par_AltaEncPoliza   CHAR(1),
    INOUT Par_Poliza    BIGINT,
    Par_Fecha           DATETIME,
    Par_Monto           DECIMAL(14,2),

    Par_CenCostoPagoAnt INT,
    Par_CentroCostoID   INT,
    Par_CuentaComp      CHAR(25),
    Par_EmpleadoID      INT,
    Par_RFC             CHAR(13),
    Par_FolioUUID       VARCHAR(100),

    Par_NatConta        CHAR(1),
    Par_ConConta        INT(11),
    Par_DescMov         VARCHAR(100),
    Par_NumeroCheque    VARCHAR(18),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_CueProvee       char(25);

DECLARE Var_TraCueIVA       char(25);
DECLARE Var_TraCueRetIVA    char(25);
DECLARE Var_TraCueRetISR    char(25);

DECLARE Var_ReaCueIVA       char(25);
DECLARE Var_ReaCueRetIVA    char(25);
DECLARE Var_ReaCueRetISR    char(25);
DECLARE Var_CtaPagoAnt      char(25);

DECLARE Con_Contable        int;
DECLARE Var_DescriMov       varchar(250);
DECLARE Var_Instrumento     varchar(15);
DECLARE Var_CtaProvee       varchar(25);
DECLARE Var_CtaAntProv      varchar(25);
DECLARE Mon_Base            int;
DECLARE Var_Cargos          decimal(14,2);
DECLARE Var_Abonos          decimal(14,2);
DECLARE Var_CargosFac       decimal(14,2);
DECLARE Var_AbonosFac       decimal(14,2);
DECLARE Var_Control         varchar(100);



DECLARE  Entero_Cero        int;
DECLARE  Decimal_Cero       decimal(12,2);
DECLARE  Cadena_Vacia       char(1);
DECLARE  Fecha_Vacia        date;
DECLARE  SalidaNO           char(1);
DECLARE  SalidaSI           char(1);
DECLARE  Tipo_RegFact       char(1);
DECLARE  Tipo_PagFact       char(1);
DECLARE  Tipo_AntFactAlt    char(1);
DECLARE  Tipo_AntFactCan    char(1);
DECLARE  Tipo_AntFactPag    char(1);
DECLARE  Tipo_CanFact       char(1);
DECLARE  Tipo_PagAntFact    char(1);

DECLARE  Imp_IVA            int;
DECLARE  Imp_RetIVA         int;
DECLARE  Imp_RetISR         int;

DECLARE Nat_Cargo           char(1);
DECLARE Nat_Abono           char(1);
DECLARE AltaPoliza_SI       char(1);
DECLARE Pol_Automatica      char(1);
DECLARE Salida_NO           char(1);
DECLARE Con_IngFactura      int;
DECLARE Con_PagoFactura     int;
DECLARE Con_ReqGasto        int;
DECLARE Con_CanFactura      int;
DECLARE Con_AntFactura      int;
DECLARE Con_AntFactAlta     int;
DECLARE Con_AntFactCan      int;
DECLARE Con_PagAntFact      int;
DECLARE Des_IngrFactura     varchar(100);
DECLARE Des_AntFactPag      varchar(100);
DECLARE Des_AntFactAlta     varchar(100);
DECLARE Des_AntFactCan      varchar(100);
DECLARE Des_PagoFactura     varchar(100);
DECLARE Des_CanFactura      varchar(100);
DECLARE Des_ReqGasto        varchar(100);
DECLARE Des_PagoAntFact     varchar(100);
DECLARE Cuenta_Vacia        varchar(15);
DECLARE Procedimiento       varchar(20);
DECLARE Var_SaldoFactura    decimal(14,2);
DECLARE TipoInstrumentoID   int(11);
DECLARE PagoAnticipadoSI    char(1);
DECLARE Var_PrimerDiaMes    date;
DECLARE Var_EstatusP        char(1);
DECLARE EjercicioCerrado    char(1);
DECLARE Var_NumFactura      VARCHAR(20);
DECLARE Var_Referencia      varchar(200);


Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';

Set Tipo_RegFact    := 'R';
Set Tipo_PagFact    := 'P';
Set Tipo_AntFactAlt := 'A';
Set Tipo_AntFactCan := 'K';
Set Tipo_AntFactPag := 'O';
Set Tipo_CanFact    := 'C';
Set Tipo_PagAntFact := 'G';

Set Imp_IVA         := 1;
Set Imp_RetIVA      := 2;
Set Imp_RetISR      := 5;

Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set AltaPoliza_SI   := 'S';
Set Pol_Automatica  := 'A';
Set Salida_NO       := 'N';

Set Con_IngFactura  := 71;
Set Con_PagoFactura := 72;
Set Con_ReqGasto    := 77;
Set Con_CanFactura  := 78;
Set Con_AntFactura  := 79;
Set Con_AntFactAlta := 83;
Set Con_AntFactCan  := 84;
Set Con_PagAntFact  := 85;

set Des_AntFactPag  := 'PAGO DE ANTICIPO DE FACTURA';
set Des_AntFactAlta := 'ALTA DE ANTICIPO DE FACTURA';
set Des_AntFactCan  := 'CANCELACION DE ANTICIPO DE FACTURA';
set Des_IngrFactura := 'REGISTRO DE FACTURA';
set Des_PagoFactura := 'PAGO DE FACTURA';
set Des_ReqGasto    := 'REQUISICION DE GASTO';
set Des_CanFactura  := 'CANCELACION DE FACTURA';
Set Des_PagoAntFact := 'PAGO ANTICIPADO DE FACTURA';
Set Cuenta_Vacia    := '000000000000000';
Set Procedimiento   := 'CONTAFACTURAPRO';
SET TipoInstrumentoID   := 6;
Set PagoAnticipadoSI    := 'S';
set EjercicioCerrado    :='C';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-CONTAFACTURAPRO');
                SET Var_Control = 'sqlException' ;
            END;

    if(Par_NumeroCheque != Entero_Cero)then
        Set Var_Referencia := Par_NumeroCheque;
    else
        Set Var_Referencia :=Par_NoFactura;
    end if;


    if (Par_AltaEncPoliza = AltaPoliza_SI) then

    set Var_DescriMov   := concat(Par_DescMov, ": ", Par_NoFactura);

        set Var_PrimerDiaMes:= convert(DATE_ADD(Par_Fecha, interval -1*(day(Par_Fecha))+1 day),date);
        select Estatus  into Var_EstatusP
            from PERIODOCONTABLE
                where Inicio=Var_PrimerDiaMes;
        if(Var_EstatusP = EjercicioCerrado )then

            select '002' as NumErr,
                     'El Periodo Contable para la Fecha Ingresada se encuentra Cerrado.' as ErrMen,
                     'fecha' as control,
                     0 as consecutivo;
                LEAVE TerminaStore;
        else

            CALL MAESTROPOLIZAALT(
            Par_Poliza,         Par_EmpresaID,  Par_Fecha,      Pol_Automatica,     Par_ConConta,
            Var_DescriMov,      Salida_NO,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion  );

            IF(Par_NumErr != Entero_Cero)THEN
                  SET Par_NumErr := 10;
                  SET Par_ErrMen := 'No se Genero la Poliza';
                LEAVE ManejoErrores;
            END IF;

        end if;
    end if;

    select MonedaBaseID into Mon_Base
        from PARAMETROSSIS;

    if(Par_PagoAnticipado= PagoAnticipadoSI)then
        Set Var_CtaPagoAnt  := Par_CenCostoPagoAnt;
        Set Var_Instrumento :=  convert(Par_EmpleadoID,char);
    else
        set Var_Instrumento := convert(Par_ProveedorID, char);
        Set Var_CtaPagoAnt  := Par_CentroCostoID;
    end if;

    set Var_DescriMov   := concat(Par_DescMov, ": ", Par_NoFactura);

    if (Par_Monto > Entero_Cero) then
        IF(Par_NatConta = Nat_Cargo)THEN
            SET Var_Cargos := Par_Monto;
            SET Var_Abonos := Decimal_Cero;

        ELSE
            IF(Par_NatConta = Nat_Abono)THEN
                SET Var_Cargos := Decimal_Cero;
                SET Var_Abonos := Par_Monto;
            END IF;
        END IF;

        CALL DETALLEPOLIZAALT (
            Par_EmpresaID,      Par_Poliza,         Par_Fecha,          Var_CtaPagoAnt,     Par_CuentaComp,
            Var_Instrumento,    Mon_Base,           Var_Cargos,         Var_Abonos,         Var_DescriMov,
            Var_Referencia,     Procedimiento,      TipoInstrumentoID,  Par_RFC,            Par_Monto,
            Par_FolioUUID,      Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

       IF(Par_NumErr != Entero_Cero)THEN
              SET Par_NumErr := 10;
              SET Par_ErrMen := 'No se Realizo el Detalle de la Poliza';
            LEAVE ManejoErrores;
        END IF;

    end if;


END ManejoErrores;

if(Par_Salida = SalidaSI) then
    select '000' as NumErr,
            'Contabilidad Registrada' as ErrMen,
            'facturaProvID' as control,
             Par_Poliza as consecutivo;
end if;
if(Par_Salida = SalidaNO) then
    set     Par_NumErr := 0;
    set Par_ErrMen := 'Contabilidad Registrada';
end if;

END TerminaStore$$