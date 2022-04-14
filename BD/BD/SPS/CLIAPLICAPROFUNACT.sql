-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROFUNACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROFUNACT`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROFUNACT`(

    Par_ClienteID           INT(11),
    Par_UsuarioAuto         VARCHAR(45),
    Par_MotivoRechazo       VARCHAR(400),
    Par_Contrasenia         VARCHAR(180),
    Par_Monto               DECIMAL(12,2),

    Par_NumAct              TINYINT UNSIGNED,
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN


DECLARE varControl          CHAR(15);
DECLARE Var_Estatus         CHAR(1);
DECLARE VarClientePro       INT(11);
DECLARE VarUsuarioReg       INT(11);
DECLARE Var_UsuarioAuto     INT(11);
DECLARE Var_Contrasenia     VARCHAR(500);
DECLARE Var_Poliza          BIGINT;
DECLARE VarDescripMov       VARCHAR(150);
DECLARE VarSucursalCte      INT(11);
DECLARE VarCtaContaProfun   VARCHAR(25);
DECLARE VarHaberExSocios    VARCHAR(25);
DECLARE Var_Instrumento     VARCHAR(20);
DECLARE Var_MonedaID        INT(11);
DECLARE VarPerfilAutoriProtec   INT(11);
DECLARE Var_RolID           INT(11);
DECLARE Var_Cargos          DECIMAL(12,2);
DECLARE Var_Abonos          DECIMAL(12,2);
DECLARE Var_NumPagosCons    INT(11);
DECLARE Var_PagosCli        INT(11);


DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(14,2);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Cliente_Activo      CHAR(1);

DECLARE Act_Autoriza        INT;
DECLARE Act_Rechaza         INT;
DECLARE Act_MutualSoc       INT;
DECLARE Est_Registrado      CHAR(1);
DECLARE Est_Autorizado      CHAR(1);
DECLARE Est_Rechazado       CHAR(1);
DECLARE Est_Pagado          CHAR(1);

DECLARE Fecha_Autoriza      DATE;
DECLARE Act_Pagar           INT;
DECLARE Pol_Automatica      CHAR(1);
DECLARE Salida_SI           CHAR(1);
DECLARE Salida_NO           CHAR(1);
DECLARE Var_Si              CHAR(1);

DECLARE VarConcepConta      INT;
DECLARE VarProcedimiento    VARCHAR(20);
DECLARE Var_CantidadEstatus INT;



SET Entero_Cero         :=0;
SET Decimal_Cero        :=0.0;
SET Cadena_Vacia        :='';
SET Fecha_Vacia         :='1900-01-01';
SET Cliente_Activo      :='A';

SET Act_MutualSoc       :=1;
SET Act_Autoriza        :=2;
SET Act_Pagar           :=3;
SET Act_Rechaza         :=4;
SET Est_Registrado      :='R';
SET Est_Autorizado      :='A';
SET Est_Rechazado       :='E';

SET Est_Pagado          := 'P';
SET Pol_Automatica      := 'A';
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';
SET Var_Si              := 'S';
SET VarConcepConta      := '85';



SET Par_NumErr          := 0;
SET Par_ErrMen          := '';
SET Aud_FechaActual     := NOW();



ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = '999';
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-CLIAPLICAPROFUNACT');
            SET varControl = 'sqlException' ;
        END;

    IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := '001';
        SET Par_ErrMen  := 'El numero de Cliente esta Vacio';
        SET varControl  := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_NumAct,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := '002';
        SET Par_ErrMen  := 'El tipo de Actualizacion esta Vacio';
        SET varControl  := 'numAct' ;
        LEAVE ManejoErrores;
    END IF;


    IF NOT EXISTS(SELECT ClienteID
                    FROM CLIENTES
                    WHERE ClienteID=Par_ClienteID)THEN
            SET Par_NumErr  := '003';
            SET Par_ErrMen  := 'El cliente NO Existe';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS(SELECT ClienteID
                FROM CLIENTESPROFUN
                WHERE ClienteID = Par_ClienteID)THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'El cliente no esta registrado en PROFUN';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
    END IF;


IF(Par_NumAct = Act_Autoriza OR Par_NumAct = Act_Rechaza) THEN

    SELECT  ClienteID,      UsuarioReg,     Estatus
     INTO   VarClientePro,  VarUsuarioReg,  Var_Estatus
        FROM    CLIAPLICAPROFUN
        WHERE   ClienteID       = Par_ClienteID
        AND     Estatus         = Est_Registrado;

    IF(IFNULL(VarClientePro,Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := '005';
        SET Par_ErrMen  := 'El cliente no tiene solicitud registrada';
        SET varControl  := 'clienteID' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_Estatus = Est_Autorizado )THEN
        SET Par_NumErr  := '006';
        SET Par_ErrMen  := 'La Solicitud esta Autorizada';
        SET varControl  := 'estatus' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_Estatus = Est_Rechazado )THEN
        SET Par_NumErr  := '006';
        SET Par_ErrMen  := 'La Solicitud esta Rechazada';
        SET varControl  := 'estatus' ;
        LEAVE ManejoErrores;
    END IF;
END IF;


IF(Par_NumAct = Act_Autoriza) THEN

    SET VarPerfilAutoriProtec := (SELECT PerfilAutoriProtec
                                    FROM PARAMETROSCAJA
                                    WHERE EmpresaID = 1);

    SELECT  UsuarioID ,         Contrasenia,        RolID
        INTO  Var_UsuarioAuto,  Var_Contrasenia,    Var_RolID
        FROM USUARIOS
        WHERE Clave = Par_UsuarioAuto;

    IF(IFNULL(Par_UsuarioAuto,Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := '008';
        SET Par_ErrMen  := 'El Numero de Usuario que Autoriza esta Vacio';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_UsuarioAuto = VarUsuarioReg)THEN
        SET Par_NumErr  := '009';
        SET Par_ErrMen  := 'El Usuario que Realiza el Registro no puede ser el mismo que  Autoriza';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_RolID != VarPerfilAutoriProtec)THEN
        SET Par_NumErr  := '009';
        SET Par_ErrMen  := 'El Usuario no tiene El Perfil para Autorizar';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    SET Var_Contrasenia := IFNULL(Var_Contrasenia, Cadena_Vacia);

    IF(Par_Contrasenia != Var_Contrasenia)THEN
        SET Par_NumErr  := '010';
        SET Par_ErrMen  := 'Contraseña o Usuario Incorrecto';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    SET Var_NumPagosCons := (SELECT MesesConsPago FROM PARAMETROSCAJA LIMIT 1);
    SET Var_PagosCli = (SELECT MesesConsPago FROM CLIENTESPROFUN WHERE ClienteID = Par_ClienteID);

    IF(IFNULL(Var_NumPagosCons, Entero_Cero) > IFNULL(Var_PagosCli,Entero_Cero))THEN
        SET Par_NumErr  := '011';
        SET Par_ErrMen  := CONCAT('La solicitud no puede ser Autorizada ya que el socio no tiene al menos ',Var_NumPagosCons,' meses constantes de pagos PROFUN');
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    SET Fecha_Autoriza      := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    UPDATE CLIAPLICAPROFUN SET
        Estatus         = Est_Autorizado,
        UsuarioAuto     = Var_UsuarioAuto,
        FechaAutoriza   = Fecha_Autoriza,
        EmpresaID       = Par_EmpresaID,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,

        NumTransaccion  = Aud_NumTransaccion
    WHERE ClienteID = Par_ClienteID;

    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'La Solicitud ha sido Autorizada Exitosamente';
    SET varControl  := 'detalleApoyoID' ;
END IF;



IF(Par_NumAct = Act_Rechaza) THEN

    SET VarPerfilAutoriProtec := (SELECT PerfilAutoriProtec
                                    FROM PARAMETROSCAJA
                                    WHERE EmpresaID = 1);

    SELECT  UsuarioID ,         Contrasenia,        RolID
        INTO  Var_UsuarioAuto,  Var_Contrasenia,    Var_RolID
        FROM USUARIOS
        WHERE Clave = Par_UsuarioAuto;

    IF(IFNULL(Par_UsuarioAuto,Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := '008';
        SET Par_ErrMen  := 'El Numero de Usuario que Rechaza esta vacio';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_RolID != VarPerfilAutoriProtec)THEN
        SET Par_NumErr  := '009';
        SET Par_ErrMen  := 'El Usuario no tiene El Perfil para Autorizar';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;


    IF(Var_UsuarioAuto = VarUsuarioReg)THEN
        SET Par_NumErr  := '009';
        SET Par_ErrMen  := 'El Usuario que realiza el Registro no puede ser el mismo que  Autoriza';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    SET Var_Contrasenia := IFNULL(Var_Contrasenia, Cadena_Vacia);

    IF(Par_Contrasenia != Var_Contrasenia)THEN
        SET Par_NumErr  := '010';
        SET Par_ErrMen  := 'Contraseña o Usuario Incorrecto';
        SET varControl  := 'usuarioAuto' ;
        LEAVE ManejoErrores;
    END IF;

    SET Fecha_Autoriza      := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    UPDATE CLIAPLICAPROFUN SET
        Estatus         = Est_Rechazado,
        UsuarioRechaza  = Var_UsuarioAuto,
        FechaRechaza    = Fecha_Autoriza,
        MotivoRechazo   = Par_MotivoRechazo,
        EmpresaID       = Par_EmpresaID,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,

        NumTransaccion  = Aud_NumTransaccion
    WHERE ClienteID = Par_ClienteID;

    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'La Solicitud ha sido Rechazada Exitosamente';
    SET varControl  := 'detalleApoyoID' ;
END IF;


IF(Par_NumAct = Act_MutualSoc) THEN
    IF(IFNULL(Par_Monto, Entero_Cero) = Entero_Cero) THEN
        SET Par_NumErr  := '007';
        SET Par_ErrMen  := 'El Monto esta Vacio';
        SET varControl  := 'monto' ;
        LEAVE ManejoErrores;
    END IF;


    UPDATE PROTECCIONES SET
        AplicaPROFUN        = Var_Si,
        MontoPROFUN         = Par_Monto,
        SaldoFavorCliente   = SaldoFavorCliente + Par_Monto,
        TotalBeneAplicado   = TotalBeneAplicado + Par_Monto
    WHERE ClienteID         = Par_ClienteID;

    UPDATE CLIAPLICAPROFUN SET
        AplicadoSocios  = Var_Si,
        Monto           = Par_Monto,
        EmpresaID       = Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,

        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
    WHERE ClienteID = Par_ClienteID;

    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'La Solicitud ha sido Considerada Para el Pago Mensual';
    SET varControl  := 'detalleApoyoID' ;
END IF;


IF(Par_NumAct = Act_Pagar) THEN
    SELECT COUNT(PersonaID) INTO Var_CantidadEstatus
                        FROM CLIAPOYOPROFUNBEN
                                WHERE ClienteID =Par_ClienteID
                                AND Estatus !=Est_Pagado;

    IF( Var_CantidadEstatus = Entero_Cero)THEN
        UPDATE CLIAPLICAPROFUN SET
            Estatus         = Est_Pagado,

            EmpresaID       = Par_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
        WHERE ClienteID = Par_ClienteID;
    END IF;
    SET Par_NumErr  := '000';
    SET Par_ErrMen  := 'La Solicitud ha sido Pagada';
    SET varControl  := 'clienteID' ;

END IF;


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen           AS ErrMen,
            varControl           AS control,
            Par_ClienteID    AS consecutivo;
END IF;

END TerminaStore$$