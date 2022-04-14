-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTEPRO`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIENTEPRO`(

    Par_ClienteID           bigint,
    Par_NumeroMov           bigint,
    Par_CantidadMov         decimal(12,2),
    Par_MonedaID            int,

    Par_AltaEncPoliza       char(1),
    Par_SucursalID          int(2),
    inout Par_Poliza        bigint(20),
    Par_AltaDetPol          char(1),
    Par_CajaID              int(11),
    Par_UsuarioID           int(11),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
        )
TerminaStore:BEGIN


DECLARE Var_ClienteID           int(11);
DECLARE Var_MontoPolizaSegA     decimal(14,2);
DECLARE Var_MontoSeguroApoyo    decimal(14,2);
DECLARE Var_ReferDetPol         varchar(20);
DECLARE Var_FechaOper           date;
DECLARE Var_FechaApl            date;
DECLARE Var_EsHabil             char(1);
DECLARE Var_SucCliente          int(5);
DECLARE Var_EsMEnorEdad         char(1);

DECLARE Var_SegClienteID        int(11);
DECLARE Var_MontoSegPagadosuma  decimal(14,2);
DECLARE Var_SegClienteIDCiclo   int(11);
DECLARE Var_SeguroClienteID     int(11);


DECLARE SalidaNO                char(1);
DECLARE SalidaSI                char(1);
DECLARE descrpcionMov           varchar(100);
DECLARE ConContaCobSegVida      int;
DECLARE ConceptosCaja           int;
DECLARE NatAbono                char(1);
DECLARE Entero_Cero             int;
DECLARE Act_Vigente             int;
DECLARE Cadena_Vacia            char;
DECLARE Decimal_Cero            decimal;
DECLARE Cobro                   char(1);
DECLARE Si                      char(1);
DECLARE Contador                int;
DECLARE Est_Inactivo            char(1);
DECLARE Est_Vigente             char(1);

DECLARE Cue_Activa              char(1);
DECLARE Es_Beneficiario         char(1);
DECLARE EsPrincipal             char(1);
DECLARE TipoInstrumentoID       int(11);


set SalidaNO                :='N';
set SalidaSI                :='S';
set descrpcionMov           :='COBRO SEGURO VIDA AYUDA';
Set ConContaCobSegVida      :=402;
set ConceptosCaja           :=2;
set NatAbono                :='A';
set Entero_Cero             :=0;
set Act_Vigente             :=1;
set Cadena_Vacia            :='';
set Decimal_Cero            :=0.0;
set Cobro                   :='C';
set Si                      :='S';
set Contador                :=1;
set Est_Inactivo            :='I';
set Est_Vigente             :='V';

Set Cue_Activa              := 'A';
Set Es_Beneficiario         := 'S';
Set EsPrincipal             := 'S';
set TipoInstrumentoID       :=4;
ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-SEGUROCLIENTEPRO");
    END;

 set Par_NumErr     := Entero_Cero;
 set Par_ErrMen     := Cadena_Vacia;
set Aud_FechaActual := now();

select FechaSistema,MontoPolizaSegA,MontoSegAyuda
        into Var_FechaOper, Var_MontoPolizaSegA,Var_MontoSeguroApoyo
        from PARAMETROSSIS;

set Var_MontoSeguroApoyo:=ifnull(Var_MontoSeguroApoyo,Decimal_Cero);

select  Cli.SucursalOrigen,Cli.EsMenorEdad  into Var_SucCliente, Var_EsMEnorEdad
    from  CLIENTES Cli
    where Cli.ClienteID   = Par_ClienteID;
set Var_ClienteID       :=ifnull(Var_ClienteID,Entero_Cero);
set Var_EsMEnorEdad     :=ifnull(Var_EsMEnorEdad,Cadena_Vacia);


call DIASFESTIVOSCAL(
        Var_FechaOper,      Entero_Cero,        Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

if(Var_EsMEnorEdad = Si)then
    set Par_NumErr := 1;
    set Par_ErrMen := "La persona es un Socio Menor. No es necesario Cobro del Seguro de Ayuda";
    LEAVE ManejoErrores;
end if;


if not exists(select Per.CuentaAhoID as Cuenta, Per.NombreCompleto, Tip.Descripcion as Relacion
        from CUENTASAHO Cue,
             CUENTASPERSONA Per,
             TIPORELACIONES Tip
        where Cue.ClienteID = Par_ClienteID
          and Cue.Estatus = Cue_Activa
          and Cue.EsPrincipal = EsPrincipal
          and Cue.CuentaAhoID = Per.CuentaAhoID
          and Per.EstatusRelacion = Est_Vigente
          and Per.EsBeneficiario = Es_Beneficiario
          and Per.ParentescoID = Tip.TipoRelacionID)then
    set Par_NumErr := 2;
    set Par_ErrMen := concat("El Socio ",convert(Par_ClienteID,char)," no tiene una Cuenta Principal con Beneficiarios Asignados");
    LEAVE ManejoErrores;
end if;

call SEGUROCLIENTEALT(
            Par_ClienteID,      Var_MontoPolizaSegA,Var_MontoSeguroApoyo,   Par_CantidadMov,    Var_FechaOper,
            Var_SeguroClienteID,SalidaNO,           Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);
    if (Par_NumErr <> Entero_Cero)then
        LEAVE ManejoErrores;
    end if;


call SEGUROCLIMOVALT
            (Var_SeguroClienteID,   Par_ClienteID,  Par_CantidadMov,    Cobro,          Par_SucursalID,
            Par_CajaID,             Var_FechaOper,  Par_UsuarioID,      descrpcionMov,  Par_NumeroMov,
            Par_MonedaID,           SalidaNO,       Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);
    if (Par_NumErr <> Entero_Cero)then
        LEAVE ManejoErrores;
    end if;


    set Var_ReferDetPol     := convert(Par_ClienteID, char);

CALL CONTACAJAPRO(
    Par_NumeroMov,      Var_FechaApl,       Par_CantidadMov,    descrpcionMov,      Par_MonedaID,
    Var_SucCliente,     Par_AltaEncPoliza,  ConContaCobSegVida, Par_Poliza,         Par_AltaDetPol,
    ConceptosCaja,      NatAbono,           Var_ReferDetPol,    Var_ReferDetPol,    Entero_Cero,
    TipoInstrumentoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
    Aud_NumTransaccion);


set Par_NumErr := Entero_Cero;
set Par_ErrMen := "Seguro de Vida Ayuda Cobrado Exitosamente.";

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'operacionID' as control,
            Par_Poliza as consecutivo;
end if;

END TerminaStore$$