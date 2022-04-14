-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANTICIPOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANTICIPOSPRO`;
DELIMITER $$

CREATE PROCEDURE `ANTICIPOSPRO`(
    Par_SucursalID          int(11),
    Par_CajaID              int(11),
    Par_Fecha               date,
    Par_MontoOperacion      decimal(14,2),
    Par_FormaPago           char(1),
    Par_TipoOpe             int(11),
    Par_Naturaleza          char(1),
    Par_EmpleadoID          int(11),
    Par_Moneda              int(11),
    Par_ConceptoConta       int(11),
    Par_DescripcionMov      varchar(150),
    Par_PolizaID            bigint(20),

    Par_Salida              char(1),
    inout   Par_NumErr      int(11),
    inout   Par_ErrMen      varchar(400),

    Aud_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint
        )
TerminaStore: BEGIN

DECLARE Var_Cargos          decimal(14,2);
DECLARE Var_Abonos          decimal(14,2);
DECLARE Var_CuentaContable  varchar(20);
DECLARE Var_CenCosto        varchar(20);
DECLARE Var_ReqEmpleado     char(1);
DECLARE Var_InstrumentoID   int(11);
DECLARE Var_NomenclaturaCR  char(3);
DECLARE Var_NomenclaturaSO  char(3);
DECLARE Var_NomenclaturaSE  char(3);
DECLARE Var_Instrumento     varchar(30);
DECLARE Var_Referencia      varchar(200);
DECLARE Var_ReqEmp          char(1);
DECLARE Var_MontoMaxEfect   decimal(14,2);
DECLARE Var_MontoMaxTrans   decimal(14,2);



DECLARE Pol_Automatica      char(1);
DECLARE Salida_NO           char(1);
DECLARE SalidaSI            char(1);
DECLARE Decimal_Cero        decimal(12,2);
DECLARE Entero_Cero         int(11);
DECLARE DescripcionMov      varchar(150);
DECLARE SalidaEfectivo      char(1);
DECLARE AUDControl          varchar(50);
DECLARE Fecha_Vacia         varchar(50);

DECLARE ConceptoConta       int(11);
DECLARE Procedimiento       varchar(30);
DECLARE For_SucOrigen       char(3);
DECLARE For_SucEmp          char(3);
DECLARE Si_Requiere         char(1);
DECLARE Cadena_Vacia        char(1);
DECLARE Efectivo            char(1);
DECLARE Sireq               char(1);
DECLARE Var_CentroCostosID  int(11);

set Si_Requiere             :='S';
Set Pol_Automatica          := 'A';
Set Salida_NO               := 'N';
set SalidaSI                := 'S';
Set Decimal_Cero            := 0.0;
Set Entero_Cero             :=   0;
set SalidaEfectivo          := "S";
set DescripcionMov          :=  "";
set AUDControl              :=  "";
set Fecha_Vacia             :='1900-01-01';
set ConceptoConta           := 501;
set Procedimiento           :='ANTICIPOSPRO';
set For_SucOrigen           := '&SO';
set For_SucEmp              := '&SE';
set Cadena_Vacia            :='';
set Efectivo                :='E';
set Sireq                   :="S";
set Var_CentroCostosID      :=0;

ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr := 999;
            set Par_ErrMen := concat("El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-ANTICIPOSPRO");
        END;


    set Par_NumErr          := '000';
    set Par_ErrMen          := '';

    select ReqNoEmp,MontoMaxEfect,MontoMaxTrans
        into Var_ReqEmp,Var_MontoMaxEfect,Var_MontoMaxTrans
        from TIPOSANTGASTOS
        where TipoAntGastoID=Par_TipoOpe;


    IF(ifnull(Par_Fecha, Fecha_Vacia))= Fecha_Vacia THEN
                SET Par_NumErr  := '003';
                SET Par_ErrMen  := 'La Fecha esta Vacia.';
                SET AUDControl  := 'fecha' ;
                LEAVE ManejoErrores;
    END IF;


    IF(ifnull(Par_MontoOperacion, Decimal_Cero))= Decimal_Cero THEN
                SET Par_NumErr  := '004';
                SET Par_ErrMen  := 'El Monto de la Operacion esta vacio.';
                SET AUDControl  := 'monto' ;
                LEAVE ManejoErrores;
    END IF;


    IF(ifnull(Par_TipoOpe, Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr  := '005';
                SET Par_ErrMen  := 'El Tipo de Operacion esta vacio.';
                SET AUDControl  := 'operacion' ;
                LEAVE ManejoErrores;
    END IF;

    IF Var_ReqEmp=SiReq THEN
        if not exists(select EmpleadoID from  EMPLEADOS where EmpleadoID=Par_EmpleadoID)then
                SET Par_NumErr  := '006';
                SET Par_ErrMen  := 'El Empleado Indicado no Existe.';
                SET AUDControl  := 'operacion' ;
                LEAVE ManejoErrores;
        end if;
        if ifnull(Par_EmpleadoID,Entero_Cero)=Entero_Cero then
                SET Par_NumErr  := '006';
                SET Par_ErrMen  := 'El Empleado Indicado no Existe.';
                SET AUDControl  := 'operacion' ;
                LEAVE ManejoErrores;
        end if;
    END IF;

    IF Par_Naturaleza="S" THEN
        IF Par_FormaPago=Efectivo THEN
            IF Par_MontoOperacion>Var_MontoMaxEfect THEN
                        SET Par_NumErr  := '007';
                        SET Par_ErrMen  := 'El Monto Excede al Maximo Permitido por Efectivo.';
                        SET AUDControl  := 'monto' ;
                        LEAVE ManejoErrores;
            END IF;
        END IF;
    END IF;

    IF Par_MontoOperacion>Var_MontoMaxTrans THEN
                SET Par_NumErr  := '008';
                SET Par_ErrMen  := 'El Monto Excede al Maximo Permitido por Operacion.';
                SET AUDControl  := 'monto' ;
                LEAVE ManejoErrores;
    END IF;



    INSERT INTO MOVSANTGASTOS(  SucursalID,         CajaID,             Fecha,              MontoOpe,           FormaPago,
                                TipoOperacion,      Naturaleza,         EmpleadoID,         EmpresaID,          Usuario,
                                FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)

                        VALUES( Par_SucursalID,     Par_CajaID,         Par_Fecha,          Par_MontoOperacion, Par_FormaPago,
                                Par_TipoOpe,        Par_Naturaleza,     Par_EmpleadoID,     Aud_EmpresaID,      Aud_Usuario,
                                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


    SELECT   CentroCosto,CtaContable,ReqNoEmp,Instrumento
    INTO Var_CenCosto, Var_CuentaContable,Var_ReqEmpleado,Var_InstrumentoID
        FROM TIPOSANTGASTOS
            WHERE TipoAntGastoID=Par_TipoOpe;

    SET Var_CuentaContable := ifnull(Var_CuentaContable, Cadena_Vacia);
    SET Var_CenCosto := ifnull(Var_CenCosto, Cadena_Vacia);


    IF LOCATE(For_SucOrigen, Var_CenCosto) > 0 THEN
        SET Var_NomenclaturaSO := Par_SucursalID;
        IF (Var_NomenclaturaSO != Cadena_Vacia) THEN
            SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
        END IF;
    ELSE
    IF LOCATE(For_SucEmp, Var_CenCosto) > 0 THEN
        SET Var_NomenclaturaSE := (SELECT   SucursalID
                                        FROM  EMPLEADOS
                                            WHERE EmpleadoID =Par_EmpleadoID);
        IF (Var_NomenclaturaSE != Cadena_Vacia) THEN
            SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSE);
        END IF;

    END IF;
    END IF;

    IF(Var_ReqEmpleado=Si_Requiere)THEN
        SET Var_Instrumento:=Par_EmpleadoID;
        SET Var_Referencia:= (SELECT NombreCompleto FROM EMPLEADOS WHERE EmpleadoID=Par_EmpleadoID);
    ELSE
        SET Var_Instrumento :=(SELECT UsuarioID FROM CAJASVENTANILLA WHERE CajaID=Par_CajaID);
        SET Var_Referencia:= (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID=Var_Instrumento);

    END IF;

    IF (Par_Naturaleza=SalidaEfectivo)THEN

        SET Var_Abonos:=0.0;
        SET Var_Cargos:=Par_MontoOperacion;
            CALL DETALLEPOLIZAALT(  Aud_EmpresaID,      Par_PolizaID,           Par_Fecha,              Var_CentroCostosID,         Var_CuentaContable,
                                    Var_Instrumento,    Par_Moneda,             Var_Cargos,             Var_Abonos,                 Par_DescripcionMov,
                                    Var_Referencia,     Procedimiento,          Var_InstrumentoID,      Cadena_Vacia,               0,
                                    Cadena_Vacia,       Salida_NO,              Par_NumErr,             Par_ErrMen,                 Aud_Usuario,
                                    Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);

    ELSE

        SET Var_Abonos:=Par_MontoOperacion;
        SET Var_Cargos:=0.0;
            CALL DETALLEPOLIZAALT(  Aud_EmpresaID,      Par_PolizaID,           Par_Fecha,              Var_CentroCostosID,         Var_CuentaContable,
                                    Var_Instrumento,    Par_Moneda,             Var_Cargos,             Var_Abonos,                 Par_DescripcionMov,
                                    Var_Referencia,     Procedimiento,          Var_InstrumentoID,      Cadena_Vacia,               0.0,
                                    Cadena_Vacia,       Salida_NO,              Par_NumErr,             Par_ErrMen,                 Aud_Usuario,
                                    Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);

    END IF;

    set Par_NumErr  := 0;
    set Par_ErrMen  := Par_ErrMen;
    set AUDControl  :='polizaID';


  END ManejoErrores;

     IF (Par_Salida = SalidaSI) THEN
                 SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen          AS ErrMen,
                    AUDControl          AS control,
                    Par_PolizaID        AS consecutivo;

     END IF;

END TerminaStore$$