-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASVENTANILLAACT`;
DELIMITER $$

CREATE PROCEDURE `CAJASVENTANILLAACT`(

    Par_SucursalID       INT(11),
    Par_CajaID           INT(11),
    Par_TipoCaja         CHAR(2),
    Par_UsuarioID        INT(11),
    Par_DescripCaja      VARCHAR(50),

    Par_NomImpresora     VARCHAR(30),
    Par_NomImpresoraCheq CHAR(30),
    Par_Estatus          CHAR(1),
    Par_FechaCan         DATETIME,
    Par_MotivoCan        VARCHAR(100),
    Par_FechaInac        DATETIME,
    Par_MotivoInac       VARCHAR(100),

    Par_FechaAct         DATETIME,
    Par_MotivoAct        VARCHAR(100),

    Par_MonedaID         INT(11),
    Par_Cantidad         DECIMAL(14,2),
    Par_LimiteDes        DECIMAL(14,2),
    Par_MaxRetiro        DECIMAL(14,2),

    Par_Naturaleza       INT,
    Par_HuellaDigital   CHAR(1),
    Par_NumAct           TINYINT UNSIGNED,

    Par_EmpresaID        INT(11),
    Aud_Usuario          INT(11),
    Aud_FechaActual      DATETIME,
    Aud_DireccionIP      VARCHAR(15),
    Aud_ProgramaID       VARCHAR(50),
    Aud_Sucursal         INT(11),
    Aud_NumTransaccion   BIGINT(20)

    )
TerminaStore: BEGIN


DECLARE Var_MonNac          INT;
DECLARE Var_MonExt          INT;
DECLARE Var_CajaOriEstatus  CHAR(1);
DECLARE Var_CajaActEstatus  CHAR(1);
DECLARE Var_SucCaja         INT;
DECLARE Var_SucUsuario      INT;
DECLARE Var_UsuEstatus      CHAR(1);
DECLARE Var_CajaEstatus     CHAR(1);
DECLARE Var_FechaSistema    DATETIME;
DECLARE Var_EjeProceso      CHAR(1);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Act_Saldo       INT;
DECLARE Mov_Entrada     INT;
DECLARE Mov_Salida      INT;
DECLARE Act_LimEfectivo INT;
DECLARE Act_ActivaCaja  INT;
DECLARE Act_CancelaCaja INT;
DECLARE Act_Activa      INT;
DECLARE Act_Inactiva    INT;
DECLARE Act_Asigna      INT;
DECLARE Act_EstatOpA    INT;
DECLARE Act_EstatOpC    INT;
DECLARE Act_EjeProcNo   INT;
DECLARE Act_EjeProcSi   INT;
DECLARE EstatusA        CHAR(1);
DECLARE EstatusC        CHAR(1);
DECLARE EstatusI        CHAR(1);
DECLARE EstOpCerrada    CHAR(1);
DECLARE VarCajaID       INT;
DECLARE Var_SucOrigen   INT;
DECLARE varestop        CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE Par_ErrMen      VARCHAR(400);
DECLARE Par_NumErr      INT(11);
DECLARE Valor_NO        CHAR(1);
DECLARE Valor_SI        CHAR(1);
DECLARE Act_OpenCajas   INT(11);
DECLARE Act_CiBovPrin   INT(11);
DECLARE CajaBoveda      CHAR(2);



SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Act_Saldo           := 1;
SET Mov_Entrada         := 1;
SET Mov_Salida          := 2;
SET Act_LimEfectivo     := 3;
SET Act_ActivaCaja      := 4;
SET Act_CancelaCaja     := 5;
SET Act_Inactiva        := 6;
SET Act_Asigna          := 7;
SET Act_EstatOpA        := 9;
SET Act_EstatOpC        := 8;
SET Act_EjeProcNo       := 10;
SET Act_EjeProcSi       := 11;
SET Act_CiBovPrin       := 12;
SET Act_OpenCajas       := 13;
SET EstatusA            := 'A';
SET EstatusC            := 'C';
SET EstatusI            := 'I';
SET EstOpCerrada        := 'C';
SET Aud_FechaActual     := NOW();
SET Salida_NO           := 'N';
SET Par_NumErr          := 0;
SET Par_ErrMen          := 'ok';
SET Valor_SI            := 'S';
SET Valor_NO            := 'N';
SET CajaBoveda          := "BG";

ManejoErrores:BEGIN


SELECT FechaSistema INTO Var_FechaSistema
    FROM PARAMETROSSIS
    LIMIT 1;

IF(Par_NumAct = Act_Saldo) THEN
    IF (Par_Naturaleza = Mov_Salida) THEN
        SET Par_Cantidad    := Par_Cantidad*-1;
    END IF;

    SELECT MonedaBaseID, MonedaExtrangeraID INTO Var_MonNac, Var_MonExt
        FROM PARAMETROSSIS;

    IF Par_MonedaID = Var_MonNac THEN
        UPDATE CAJASVENTANILLA SET
            SaldoEfecMN    = SaldoEfecMN + Par_Cantidad
            WHERE SucursalID = Par_SucursalID
              AND CajaID = Par_CajaID;

    ELSE
        UPDATE CAJASVENTANILLA SET
            SaldoEfecME    = SaldoEfecME + Par_Cantidad
            WHERE SucursalID    = Par_SucursalID
              AND CajaID        = Par_CajaID;
    END IF;
END IF;


IF(Par_NumAct = Act_LimEfectivo)THEN
    IF(IFNULL(Par_LimiteDes, Entero_Cero))= Entero_Cero THEN
        SELECT '002' AS NumErr,
            'El Limite por Desembolso esta Vacio.' AS ErrMen,
            'limiteDesembolsoMN' AS control;
        LEAVE TerminaStore;
    END IF;
    IF(IFNULL(Par_MaxRetiro, Entero_Cero))= Entero_Cero THEN
        SELECT '003' AS NumErr,
            'El MÃ¡ximo de Retiro esta Vacio.' AS ErrMen,
            'maximoRetiroMN' AS control;
        LEAVE TerminaStore;
    END IF;
    IF(IFNULL(Par_Cantidad, Entero_Cero))= Entero_Cero THEN
        SELECT '004' AS NumErr,
            'El Limite de Efectivo esta Vacio.' AS ErrMen,
            'limiteEfectivoMN' AS control;
        LEAVE TerminaStore;
    ELSE
        UPDATE CAJASVENTANILLA SET
            LimiteEfectivoMN    = Par_Cantidad,
            LimiteDesemMN       = Par_LimiteDes,
            MaximoRetiroMN      = Par_MaxRetiro,
            DescripcionCaja     = Par_DescripCaja,
            NomImpresora        = Par_NomImpresora,
            NomImpresoraCheq    = Par_NomImpresoraCheq,
            HuellaDigital       = Par_HuellaDigital,
            EmpresaID           = Par_EmpresaID ,
            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion
        WHERE  SucursalID   = Par_SucursalID
        AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
            'Caja Modificada.' AS ErrMen,
            'cajaID' AS control;
    END IF;
END IF;


IF(Par_NumAct = Act_ActivaCaja)THEN
    IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
        SELECT '005' AS NumErr,
            'El Numero de Caja esta Vacia.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    ELSE
        UPDATE CAJASVENTANILLA SET
            Estatus = EstatusA,
            FechaAct = Par_FechaAct,
            MotivoAct = Par_MotivoAct
        WHERE SucursalID    = Par_SucursalID
        AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
            'Caja Activada.' AS ErrMen,
            'cajaID' AS control;
    END IF;
END IF;


IF(Par_NumAct = Act_CancelaCaja)THEN
    IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
        SELECT '006' AS NumErr,
            'El Numero de Caja esta Vacia.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    ELSE
        UPDATE CAJASVENTANILLA SET
            Estatus = EstatusC,
            FechaCan = Par_FechaCan,
            MotivoCan = Par_MotivoCan
        WHERE SucursalID    = Par_SucursalID
        AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
            'Caja Cancelada.' AS ErrMen,
            'cajaID' AS control;
    END IF;
END IF;


IF(Par_NumAct = Act_Inactiva)THEN
    IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
        SELECT '007' AS NumErr,
            'El Numero de Caja esta Vacia.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    ELSE
        UPDATE CAJASVENTANILLA SET
            Estatus = EstatusI,
            FechaInac = Par_FechaInac,
            MotivoInac = Par_MotivoInac
        WHERE SucursalID    = Par_SucursalID
        AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
            'Caja Inactivada.' AS ErrMen,
            'cajaID' AS control;
    END IF;
END IF;


IF(Par_NumAct = Act_Asigna)THEN
    SELECT  IFNULL(Estatus,'') INTO Var_CajaEstatus
        FROM CAJASVENTANILLA
        WHERE  CajaID=Par_CajaID
        AND SucursalID=  Par_SucursalID;

    IF Var_CajaEstatus<>"A" THEN
        SELECT '010' AS NumErr,
               'La Caja no se Encuentra Activa.' AS ErrMen,
               'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;

    IF(IFNULL(Par_UsuarioID, Entero_Cero))= Entero_Cero THEN
        SELECT '008' AS NumErr,
               'El Usuario no Existe.' AS ErrMen,
               'usuarioID' AS control;
        LEAVE TerminaStore;
    END IF;

    SELECT  SucursalUsuario, Estatus INTO Var_SucUsuario, Var_UsuEstatus
        FROM USUARIOS
        WHERE UsuarioID = Par_UsuarioID;

    SET Var_SucUsuario  := IFNULL(Var_SucUsuario, Entero_Cero);
    SET Var_UsuEstatus  := IFNULL(Var_UsuEstatus, Cadena_Vacia);

    IF (Var_UsuEstatus != EstatusA) THEN
        SELECT '009' AS NumErr,
               'El Usuario no se encuentra Activo.' AS ErrMen,
               'usuarioID' AS control;
        LEAVE TerminaStore;
    END IF;



    SELECT CajaID, EstatusOpera,SucursalID INTO VarCajaID, Var_CajaOriEstatus,Var_SucCaja
        FROM CAJASVENTANILLA
        WHERE UsuarioID = Par_UsuarioID;

    SET VarCajaID   := IFNULL(VarCajaID, Entero_Cero);

    IF(VarCajaID > Entero_Cero) THEN
        IF(Var_CajaOriEstatus != EstOpCerrada) THEN
            SELECT '009' AS NumErr,
                   'El Nuevo Usuario tiene una Caja que no ha sido Cerrada.' AS ErrMen,
                   'usuarioID' AS control;
            LEAVE TerminaStore;
        END IF;

        UPDATE CAJASVENTANILLA SET
                UsuarioID = Entero_Cero
            WHERE SucursalID = Var_SucCaja
            AND CajaID = VarCajaID;

    END IF;

    SELECT  EstatusOpera, SucursalID INTO Var_CajaActEstatus, Var_SucCaja
        FROM CAJASVENTANILLA
        WHERE SucursalID    = Par_SucursalID
        AND CajaID = Par_CajaID;

    IF(Var_CajaActEstatus != EstOpCerrada) THEN
        SELECT '010' AS NumErr,
               CONCAT('La Caja ', CONVERT(Par_CajaID, CHAR), ' no ha sido Cerrada.') AS ErrMen,
               'usuarioID' AS control;
        LEAVE TerminaStore;
    END IF;


    UPDATE CAJASVENTANILLA SET
            UsuarioID = Par_UsuarioID
        WHERE SucursalID    = Par_SucursalID
        AND CajaID = Par_CajaID;


    IF(Var_SucCaja != Var_SucUsuario) THEN
        UPDATE USUARIOS SET
            SucursalUsuario = Var_SucCaja
            WHERE UsuarioID = Par_UsuarioID;
    END IF;

    SELECT '000' AS NumErr ,
       'Caja Asignada Exitosamente ' AS ErrMen,
        'cajaID' AS control;
END IF;


IF(Par_NumAct = Act_EstatOpA)THEN
    IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
        SELECT '010' AS NumErr,
            'La sucursal no Existe.' AS ErrMen,
            'Sucursal' AS control;
        LEAVE TerminaStore;
    END IF;
    IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
        SELECT '011' AS NumErr,
            'El Numero de Caja esta Vacia.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;
    SELECT Estatus INTO Var_CajaEstatus FROM CAJASVENTANILLA WHERE SucursalID   = Par_SucursalID AND CajaID = Par_CajaID;
    SET Var_CajaEstatus := IFNULL(Var_CajaEstatus,EstatusC);

    IF   Var_CajaEstatus != EstatusA THEN
        SELECT '012' AS NumErr,
        'El Estatus de la Caja No se encuentra Activa.' AS ErrMen,
        'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;

    SELECT EstatusOpera INTO varestop FROM CAJASVENTANILLA WHERE SucursalID = Par_SucursalID AND CajaID = Par_CajaID;
    IF(IFNULL(varestop, Cadena_Vacia))= EstatusA  THEN
    SELECT '013' AS NumErr,
        ' La caja ya se encuentra Abierta.' AS ErrMen,
        'cajaID' AS control;
    LEAVE TerminaStore;
    END IF;


    CALL CUENTACONTACAJAVAL(
            Par_SucursalID, Par_CajaID,     Salida_NO,       Par_NumErr,       Par_ErrMen,
            Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual, Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);

    IF(Par_NumErr <> 0)THEN
        SELECT Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;

        UPDATE CAJASVENTANILLA SET
                EstatusOpera = EstatusA,

                EmpresaID   = Par_EmpresaID ,
                Usuario     =Aud_Usuario,
                FechaActual =Aud_FechaActual,
                DireccionIP =Aud_DireccionIP,
                ProgramaID  =Aud_ProgramaID,
                Sucursal        =Aud_Sucursal,
                NumTransaccion=Aud_NumTransaccion
        WHERE SucursalID = Par_SucursalID
            AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
            'Caja Aperturada Exitosamente.' AS ErrMen,
            'cajaID' AS control;

END IF;


IF(Par_NumAct = Act_EstatOpC)THEN
    IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
        SELECT '014' AS NumErr,
            'La sucursal no Existe.' AS ErrMen,
            'Sucursal' AS control;
        LEAVE TerminaStore;
    END IF;
    IF(IFNULL(Par_CajaID, Entero_Cero))= Entero_Cero THEN
        SELECT '015' AS NumErr,
            'El Numero de Caja esta Vacia.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;
    IF   Var_CajaEstatus != EstatusA THEN
        SELECT '016' AS NumErr,
        'El Estatus de la Caja No se encuentra Activa.' AS ErrMen,
        'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;
    SELECT EstatusOpera INTO varestop
        FROM CAJASVENTANILLA
        WHERE SucursalID=Par_SucursalID
        AND CajaID = Par_CajaID;

    IF(IFNULL(varestop, Cadena_Vacia))= EstatusC THEN
        SELECT '017' AS NumErr,
            ' La caja ya se encuentra Cerrada.' AS ErrMen,
            'cajaID' AS control;
        LEAVE TerminaStore;
    END IF;

    IF EXISTS( SELECT CajaOrigen
                FROM CAJASTRANSFER
                WHERE CajaDestino=Par_CajaID
                AND Estatus =EstatusA
                AND SucursalDestino=Par_SucursalID)THEN
            SELECT '18' AS NumErr,
            CONCAT('La Caja ',CONVERT(Par_CajaID,CHAR), ' tiene Transferencias Pendientes.') AS ErrMen,
            'cajaID' AS control;
            LEAVE TerminaStore;
    END IF;

    UPDATE CAJASVENTANILLA SET
            EstatusOpera = EstatusC,

            EmpresaID       = Par_EmpresaID ,
            Usuario         =Aud_Usuario,
            FechaActual     =Aud_FechaActual,
            DireccionIP     =Aud_DireccionIP,
            ProgramaID      =Aud_ProgramaID,
            Sucursal        =Aud_Sucursal,
            NumTransaccion  =Aud_NumTransaccion
    WHERE SucursalID = Par_SucursalID
            AND CajaID = Par_CajaID;


    SELECT '000' AS NumErr ,
        'Caja Cerrada Exitosamente.' AS ErrMen,
        'cajaID' AS control;
END IF;




IF(Par_NumAct = Act_EjeProcNo)THEN
    UPDATE CAJASVENTANILLA SET
            EjecutaProceso  = Valor_NO

    WHERE SucursalID = Par_SucursalID
            AND CajaID = Par_CajaID;

    SELECT '000' AS NumErr ,
        'Proceso Terminado Exitosamente.' AS ErrMen;
END IF;




IF (Par_NumAct = Act_EjeProcSi)THEN


    SELECT EjecutaProceso INTO Var_EjeProceso
    FROM CAJASVENTANILLA
    WHERE SucursalID = Par_SucursalID
    AND CajaID = Par_CajaID;


    IF(IFNULL(Var_EjeProceso,Cadena_Vacia)) = Valor_SI  THEN
            SELECT '20' AS NumErr ,
            'Operacion en Proceso. Espere Por Favor' AS ErrMen;
    ELSE

        UPDATE CAJASVENTANILLA SET
                EjecutaProceso  = Valor_SI,

                EmpresaID       = Par_EmpresaID ,
                Usuario         =Aud_Usuario,
                FechaActual     =Aud_FechaActual,
                DireccionIP     =Aud_DireccionIP,
                ProgramaID      =Aud_ProgramaID,
                Sucursal        =Aud_Sucursal,
                NumTransaccion  =Aud_NumTransaccion
        WHERE SucursalID = Par_SucursalID
                AND CajaID = Par_CajaID;

        SELECT '000' AS NumErr ,
        'Proceso Terminado Exitosamente.' AS ErrMen;
    END IF;
END IF;

-- Cerrar Bovéda Principal
IF (Par_NumAct = Act_CiBovPrin ) THEN
    -- Cerrar las bóvedas (USAR solo con CONFIADORA)
    UPDATE CAJASVENTANILLA SET
            EstatusOpera = EstatusC,

            EmpresaID       = Par_EmpresaID ,
            Usuario         =Aud_Usuario,
            FechaActual     =Aud_FechaActual,
            DireccionIP     =Aud_DireccionIP,
            ProgramaID      =Aud_ProgramaID,
            Sucursal        =Aud_Sucursal,
            NumTransaccion  =Aud_NumTransaccion
    WHERE TipoCaja = CajaBoveda;
    LEAVE ManejoErrores;
END IF;

-- Abirir CAJAS Activas
IF (Par_NumAct = Act_OpenCajas ) THEN
    -- Abrir todas las cajas que se encuentren activas (USAR solo con CONFIADORA)
    UPDATE CAJASVENTANILLA SET
            EstatusOpera = EstatusA,

            EmpresaID       = Par_EmpresaID ,
            Usuario         =Aud_Usuario,
            FechaActual     =Aud_FechaActual,
            DireccionIP     =Aud_DireccionIP,
            ProgramaID      =Aud_ProgramaID,
            Sucursal        =Aud_Sucursal,
            NumTransaccion  =Aud_NumTransaccion
    WHERE Estatus = EstatusA;
    LEAVE ManejoErrores;
END IF;


END ManejoErrores;
END TerminaStore$$