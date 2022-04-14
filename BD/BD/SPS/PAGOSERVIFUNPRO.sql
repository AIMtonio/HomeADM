-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVIFUNPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSERVIFUNPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOSERVIFUNPRO`(
    Par_ServiFunFolioID     int(11),
    Par_ServiFunEntregadoID int(11),
    Par_NombreRecibePago    varchar(200),
    Par_TipoIdentiID        int(11),
    Par_FolioIdentific      varchar(30),
    Par_CajaID              int(11),
    Par_SucursalID          int(11),
    Par_PolizaID            bigint(20),

    Par_Salida              char(1),
    inout   Par_NumErr      int,
    inout   Par_ErrMen      varchar(400),

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)

        )
TerminaStore:BEGIN

DECLARE Var_Poliza              bigint(20);
DECLARE Var_FechaSistema        date;
DECLARE Var_MonedaBaseID        int(11);
DECLARE Var_Control             varchar(100);
DECLARE Var_CantStatusAutoriza  int;
DECLARE Var_CentroCostosID      int(11);
DECLARE Var_CtaContaSRVFUN      varchar(25);
DECLARE Var_CantidadEntregado   decimal(14,2);
DECLARE Var_TipoServicio        char(1);
DECLARE Var_Estatus             char(1);
DECLARE Var_HaberExSocios       varchar(25);
DECLARE Var_CCServifun          varchar(30);
DECLARE Var_SucCliente          int(11);


DECLARE SalidaSI                char(1);
DECLARE SalidaNO                char(1);
DECLARE EstatusAutorizado       char(1);
DECLARE EstatusPagado           char(1);
DECLARE Pol_Automatica          char(1);
DECLARE ConceptoCon             int(11);
DECLARE DescripcionMov          varchar(100);
DECLARE DescripcionMovDet       varchar(100);
DECLARE Decimal_Cero            decimal;
DECLARE Programa                varchar(100);
DECLARE Entero_Cero             int;
DECLARE Cadena_Vacia            char;
DECLARE ServicioCliente         char(1);
DECLARE ServicioFamiliar        char(1);
DECLARE TipoInstrumentoID       int(11);
DECLARE For_SucOrigen           char(3);
DECLARE For_SucCliente          char(3);


set SalidaSI                :='S';
set SalidaNO                :='N';
set EstatusAutorizado       :='A';
set EstatusPagado           :='P';
set Pol_Automatica          :='A';
set ConceptoCon             :=801;
set DescripcionMov          :='PAGO SERVIFUN';
set DescripcionMovDet       :='PAGO SERVIFUN';
set Decimal_Cero            :=0.0;
set Programa                :='PAGOSERVIFUNPRO';
set Entero_Cero             :=0;
set Cadena_Vacia            :='';
set ServicioCliente         :='C';
set ServicioFamiliar        :='F';
Set TipoInstrumentoID       := 4;
set For_SucOrigen           := '&SO';
set For_SucCliente          := '&SC';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr := 999;
        set Par_ErrMen := concat("El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOSERVIFUNPRO");
        set Var_Control :='serviFunFolioID';
    END;
select FechaSistema, MonedaBaseID into Var_FechaSistema, Var_MonedaBaseID
        from PARAMETROSSIS Limit 1;

if(ifnull(Par_ServiFunFolioID, Entero_Cero) = Entero_Cero)then
    set Par_NumErr  :=1;
    set Par_ErrMen  :=' El Numero de Folio se encuentra Vacio';
    set Var_Control :='serviFunFolioID';
    LEAVE ManejoErrores;
end if;

if not exists (select ServiFunFolioID
                from SERVIFUNFOLIOS
                    where ServiFunFolioID =Par_ServiFunFolioID)then
    set Par_NumErr  :=2;
    set Par_ErrMen  :=concat('El Folio ', convert(ServiFunFolioID,char) ,' Indicado no Existe');
    set Var_Control :='serviFunFolioID';
    LEAVE ManejoErrores;
end if;
set Var_CentroCostosID    := FNCENTROCOSTOS(Aud_Sucursal);

select Ser.TipoServicio, Ser.Estatus, Cli.SucursalOrigen
    into Var_TipoServicio, Var_Estatus, Var_SucCliente
        from SERVIFUNFOLIOS Ser
                inner Join CLIENTES Cli on Cli.ClienteID =Ser.ClienteID
        where Ser.ServiFunFolioID = Par_ServiFunFolioID;

set Var_TipoServicio    :=ifnull(Var_TipoServicio, Cadena_Vacia);
set Var_Estatus         := ifnull(Var_Estatus, Cadena_Vacia);
set Var_SucCliente      :=ifnull(Var_SucCliente,Entero_Cero );

if(ifnull(Var_Estatus, Cadena_Vacia) = EstatusPagado )then
    set Par_NumErr  :=1;
    set Par_ErrMen  :=' El Folio ya fue Pagado';
    set Var_Control :='serviFunFolioID';
    LEAVE ManejoErrores;
end if;

if(ifnull(Var_Estatus, Cadena_Vacia) != EstatusAutorizado )then
    set Par_NumErr  :=1;
    set Par_ErrMen  :=' El Folio no esta Autorizado';
    set Var_Control :='serviFunFolioID';
    LEAVE ManejoErrores;
end if;


select CtaContaSRVFUN,      HaberExSocios,      CCServifun
    into Var_CtaContaSRVFUN, Var_HaberExSocios, Var_CCServifun
        from PARAMETROSCAJA
        where  EmpresaID = Par_EmpresaID;

set Var_CtaContaSRVFUN  :=ifnull(Var_CtaContaSRVFUN,Cadena_Vacia);
set Var_HaberExSocios   :=ifnull(Var_HaberExSocios,Cadena_Vacia);
set Var_CCServifun      :=ifnull(Var_CCServifun, Cadena_Vacia);

select  CantidadEntregado into Var_CantidadEntregado
        from SERVIFUNENTREGADO
        where ServiFunEntregadoID = Par_ServiFunEntregadoID
        and ServiFunFolioID = Par_ServiFunFolioID;

set Var_CantidadEntregado   :=ifnull(Var_CantidadEntregado, Decimal_Cero);




    if LOCATE(For_SucOrigen, Var_CCServifun) > 0 then
        set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
    else
        if LOCATE(For_SucCliente, Var_CCServifun) > 0 then
                if (Var_SucCliente > 0) then
                    set Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
                else
                    set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                end if;
        else
            set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
        end if;
    end if;


if (Var_TipoServicio = ServicioCliente)then
    CALL DETALLEPOLIZAALT(
        Par_EmpresaID,          Par_PolizaID,       Var_FechaSistema,       Var_CentroCostosID, Var_HaberExSocios,
        Par_ServiFunFolioID,    Var_MonedaBaseID,   Var_CantidadEntregado,  Entero_Cero,        DescripcionMovDet,
        Par_ServiFunFolioID,    Programa,           TipoInstrumentoID,      Cadena_Vacia,       Decimal_Cero,
        Cadena_Vacia,           SalidaNO,           Par_NumErr,             Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

elseif(Var_TipoServicio = ServicioFamiliar)then
    CALL DETALLEPOLIZAALT(
        Par_EmpresaID,          Par_PolizaID,       Var_FechaSistema,       Var_CentroCostosID, Var_CtaContaSRVFUN,
        Par_ServiFunFolioID,    Var_MonedaBaseID,   Var_CantidadEntregado,  Entero_Cero,        DescripcionMovDet,
        Par_ServiFunFolioID,    Programa,           TipoInstrumentoID,      Cadena_Vacia,       Decimal_Cero,
        Cadena_Vacia,           SalidaNO,           Par_NumErr,             Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

end if;



update SERVIFUNENTREGADO set
        Estatus                 = EstatusPagado,
        NombreRecibePago        = Par_NombreRecibePago,
        TipoIdentiID            = Par_TipoIdentiID,
        FolioIdentific          = Par_FolioIdentific,
        FechaEntrega            = Var_FechaSistema,
        CajaID                  =Par_CajaID,
        SucursalID              =Par_SucursalID

    where ServiFunFolioID       =Par_ServiFunFolioID
        and ServiFunEntregadoID =Par_ServiFunEntregadoID;


set Var_CantStatusAutoriza  :=(select count(ServiFunFolioID)
                            from SERVIFUNENTREGADO
                                where Par_ServiFunFolioID = ServiFunFolioID
                                and Estatus = EstatusAutorizado);
set Var_CantStatusAutoriza  :=ifnull(Var_CantStatusAutoriza,Entero_Cero);
if( Var_CantStatusAutoriza = Entero_Cero)then
    update SERVIFUNFOLIOS set
        Estatus = EstatusPagado
        where ServiFunFolioID = Par_ServiFunFolioID;
end if;

set Par_ErrMen :=0;
set Par_ErrMen  :="Pago Realizado Exitosamente";

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            '' as control,
            Par_PolizaID as consecutivo;
end if;

END TerminaStore$$