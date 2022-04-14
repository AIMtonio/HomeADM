-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROREACTIVACLIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROREACTIVACLIALT`;DELIMITER $$

CREATE PROCEDURE `COBROREACTIVACLIALT`(

    Par_ClienteID           int(11),
    Par_CajaID              int(11),
    Par_SucursalID          int(11),
    Par_MonedaID            int(11),
    Par_PolizaID            bigint(20),
    Par_MontoTotal          decimal(14,2),

    Par_Salida              char(1),
    INOUT Par_NumErr        int,
    INOUT Par_ErrMen        varchar(400),

    Par_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         datetime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
)
TerminaStore: BEGIN

    Declare varControl          varchar(50);
    Declare Var_FechaSistema    date;
    Declare Var_MontoReactiva   decimal(14,2);
    Declare Var_PermiteReactivacion char(1);
    Declare Var_RequiereCobro   char(1);
    Declare Var_Estatus     char(1);
    Declare Var_CobroReactCliID int(11);


    Declare Entero_Cero     int;
    Declare Decimal_Cero        decimal(14,2);
    Declare Cadena_Vacia        char(1);
    Declare Fecha_Vacia     date;
    Declare Est_Aplicado    char(1);
    Declare Est_Pendiente   char(1);
    Declare ActivaCliente   int;
    Declare PermiteReactivacionSI  char(1);
    Declare PermiteReactivacionNO   char(1);
    Declare RequiereCobroSI     char(1);
    Declare RequiereCostoNO     char(1);
    Declare Est_Inactivo        char(1);
    Declare Salida_SI           char(1);



    Set varControl          :='';


    Set Entero_Cero     := 0;
    Set Decimal_Cero    := 0.0;
    Set Cadena_Vacia    := '';
    Set Fecha_Vacia     := '1900-01-01';
    Set Est_Aplicado    := 'A';
    Set Est_Pendiente   := 'P';
    Set ActivaCliente   :=  5;
    Set PermiteReactivacionSI   :='S';
    Set PermiteReactivacionNO   :='N';
    Set RequiereCobroSI := 'S';
    Set RequiereCostoNO := 'N';
    Set Est_Inactivo    := 'I';
    set Salida_SI       :='S';
    Set Aud_FechaActual := now();



    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
                                         'estamos trabajando para resolverla. Disculpe las molestias que ',
                                         'esto le ocasiona. Ref: SP-COBROREACTIVACLIALT');
                SET varControl = 'sqlException' ;
            END;

        Set Var_FechaSistema    := (select FechaSistema from PARAMETROSSIS limit 1);

        IF(ifnull(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El numero de safilocale.cliente esta vacio.';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_CajaID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'El numero de caja esta vacia.';
            SET varControl  := 'cajaID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_SucursalID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'El numero de sucursal esta vacio.';
            SET varControl  := 'sucursalID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_MonedaID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El numero de moneda esta vacio.';
            SET varControl  := 'monedaID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_polizaID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'El numero de poliza esta vacio.';
            SET varControl  := 'poliza ID' ;
            LEAVE ManejoErrores;
        END IF;

        SELECT M.PermiteReactivacion, M.RequiereCobro, C.Estatus
            into Var_PermiteReactivacion, Var_RequiereCobro, Var_Estatus
            from    MOTIVACTIVACION M, CLIENTES C
            where C.ClienteID = Par_ClienteID
            and C.TipoInactiva = M.MotivoActivaID;



        set Var_PermiteReactivacion :=ifnull(Var_PermiteReactivacion, Cadena_Vacia);
        set Var_RequiereCobro   :=ifnull(Var_RequiereCobro,Cadena_Vacia);
        set Var_Estatus     := ifnull(Var_Estatus, Cadena_Vacia);

        IF(Var_Estatus != Est_Inactivo) then
            SET Par_NumErr  := '006';
            SET Par_ErrMen  := 'El safilocale.cliente no se encuentra inactivo .';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
        end if;

        if(Var_PermiteReactivacion != PermiteReactivacionSI) then
         SET Par_NumErr  := '007';
            SET Par_ErrMen  := 'El motivo de inactivacion del safilocale.cliente no permite reactivacion.';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
        end if;

        if(Var_RequiereCobro != RequiereCobroSI) then
          SET Par_NumErr  := 008;
            SET Par_ErrMen  := 'La reactivacion no tiene costo.';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
        end if;

    call FOLIOSAPLICAACT('COBROREACTIVACLI', Var_CobroReactCliID);

        INSERT INTO COBROREACTIVACLI(
                        CobroReactCliID,    ClienteID,      CajaID,         SucursalID, MontoReactiva,
                        FechaCobro,         Estatus,        MonedaID,       PolizaID,   EmpresaID,
                        Usuario,            FechaActual,    DireccionIP,    ProgramaID, Sucursal,
                        NumTransaccion)

                VALUES (Var_CobroReactCliID,    Par_ClienteID,      Par_CajaID,     Par_SucursalID, Par_MontoTotal,
                    Var_FechaSistema,           Est_Pendiente,      Par_MonedaID,   Par_PolizaID,   Par_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'El cobro se realizo correctamente.';
        SET varControl  := 'clienteID' ;

    END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT Par_NumErr AS NumErr,
            Par_ErrMen           AS ErrMen,
            varControl           AS control,
            Par_ClienteID    AS consecutivo;
        end IF;

END TerminaStore$$