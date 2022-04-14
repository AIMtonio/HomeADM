-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCAMBIOSUCURCLIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISCAMBIOSUCURCLIPRO`;
DELIMITER $$


CREATE PROCEDURE `HISCAMBIOSUCURCLIPRO`(




    Par_ClienteID           INT(11),
    Par_SucursalOrigen      INT(11),
    Par_SucursalDestino     INT(11),
    Par_PromotorAnterior    INT(11),
    Par_PromotorActual      INT(11),
    Par_UsuarioID           INT(11),

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


    DECLARE varControl              CHAR(15);
    DECLARE Var_FechaOper           DATE;
    DECLARE Var_FechaApl            DATE;
    DECLARE Var_EsHabil             CHAR(1);
    DECLARE Var_Saldo               DECIMAL(14,2);

    DECLARE Var_MonedaBaseID        INT(1);
    DECLARE Var_Poliza              BIGINT(25);
    DECLARE Var_ClienteStr          VARCHAR(15);
    DECLARE Var_FechaSis            DATE;
    DECLARE Var_FechaCambio         DATETIME;

    DECLARE Var_NumCuentas          INT(11);
    DECLARE Var_ValCtasActivas      CHAR(1);
    DECLARE Var_ValCtasBloqueadas   CHAR(1);
    DECLARE Var_ValDiasAtraso       CHAR(1);
    DECLARE Var_ValCreCastVencido   CHAR(1);

    DECLARE Var_ValInvProceso       CHAR(1);
    DECLARE Var_ValProfun           CHAR(1);
    DECLARE Var_Reclasificaconta    CHAR(1);


    DECLARE Estatus_Activo      CHAR(1);
    DECLARE Estatus_InActivo    CHAR(1);
    DECLARE Estatus_Liberado    CHAR(1);
    DECLARE Estatus_Autorizado  CHAR(1);
    DECLARE Entero_Cero         INT;

    DECLARE Decimal_Cero        DECIMAL(14,2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Salida_SI           CHAR(1);
    DECLARE DescrpcionMov       VARCHAR(100);

    DECLARE DescrpcionMovCTA    VARCHAR(100);
    DECLARE DescrpcionMovINV    VARCHAR(100);
    DECLARE DescrpcionMovCRE    VARCHAR(100);
    DECLARE AltaEncPolizaSI     CHAR(1);
    DECLARE AltaEncPolizaNO     CHAR(1);

    DECLARE ConCambioSucurs     INT;
    DECLARE AltaDetPolSI        CHAR(1);
    DECLARE ConceptosCaja       INT(11);
    DECLARE NatCargo            CHAR(1);
    DECLARE NatAbono            CHAR(1);

    DECLARE TipoInstrumentoID   INT(11);
    DECLARE SalidaNO            CHAR(1);
    DECLARE Var_CuentaBloq      BIGINT(12);
    DECLARE Var_MotivoBlo       VARCHAR(100);
    DECLARE Var_PolizaCuenta    INT(11);

    DECLARE Var_PolizaInver     INT(11);
    DECLARE Var_MontoPendiente  DECIMAL(14,2);
    DECLARE EstatusBloqueada    CHAR(1);
    DECLARE EstatusRegistrada   CHAR(1);
    DECLARE EstatusVencido      CHAR(1);

    DECLARE EstatusVigente      CHAR(1);
    DECLARE StringSI            CHAR(1);
    DECLARE InversionVigente    CHAR(1);


    SET Estatus_Activo          :='A';
    SET Estatus_InActivo        :='I';
    SET Estatus_Liberado        :='L';
    SET Estatus_Autorizado      :='A';
    SET Entero_Cero             :=0;

    SET Decimal_Cero            :=0.0;
    SET Cadena_Vacia            :='';
    SET Fecha_Vacia             :='1900-01-01';
    SET Salida_SI               :='S';
    SET DescrpcionMov           :='REASIGNACION DE SUCURSAL';

    SET DescrpcionMovCTA        :='CUENTAS DE AHORRO';
    SET DescrpcionMovINV        :='INVERSIONES';
    SET DescrpcionMovCRE        :='CREDITOS';
    SET AltaEncPolizaSI         :='S';
    SET AltaEncPolizaNO         :='N';

    SET ConCambioSucurs         := 410;
    SET AltaDetPolSI            :='S';
    SET ConceptosCaja           :=1;
    SET NatCargo                :='C';
    SET NatAbono                :='A';

    SET TipoInstrumentoID       :=4;
    SET SalidaNO                :='N';
    SET InversionVigente        :='N';
    SET EstatusBloqueada        :="B";
    SET EstatusRegistrada       :="R";

    SET EstatusVencido          :="B";
    SET EstatusVigente          :="V";
    SET StringSI                :='S';


    SET Par_NumErr              := 0;
    SET Par_ErrMen              := '';
    SET Var_PolizaCuenta        :=0;
    SET Var_PolizaInver         :=0;


    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = '999';
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-HISCAMBIOSUCURCLIPRO ');

                SET varControl = 'sqlException' ;
        END;

        SELECT ValCtasActivas,ValCtasBloqueadas, ValDiasAtraso,ValCreCastVencido,
                ValInvProceso, ValProfun, Reclasificaconta
                INTO Var_ValCtasActivas,Var_ValCtasBloqueadas, Var_ValDiasAtraso,Var_ValCreCastVencido,
                    Var_ValInvProceso, Var_ValProfun, Var_Reclasificaconta
            FROM PARAMCAMBIOSUCUR LIMIT 1;

         SET Var_ValCtasActivas :=IFNULL(Var_ValCtasActivas,Cadena_Vacia );
         SET Var_ValCtasBloqueadas:=IFNULL(Var_ValCtasBloqueadas,Cadena_Vacia );
         SET Var_ValDiasAtraso:=IFNULL(Var_ValDiasAtraso,Cadena_Vacia );
         SET Var_ValCreCastVencido:=IFNULL(Var_ValCreCastVencido,Cadena_Vacia );
         SET Var_ValInvProceso:=IFNULL(Var_ValInvProceso,Cadena_Vacia );
         SET Var_ValProfun:=IFNULL(Var_ValProfun,Cadena_Vacia );
         SET Var_Reclasificaconta   :=IFNULL(Var_Reclasificaconta,Cadena_Vacia );

        IF(IFNULL(Par_ClienteID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El ID del safilocale.cliente  esta vacio.';
            SET varControl  := 'clienteID' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_SucursalOrigen,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'La Sucursal de Origen esta vacia.';
            SET varControl  := 'sucursalOrigen' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_SucursalDestino,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'La Sucursal Destino esta vacia.';
            SET varControl  := 'sucursalDestino' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_PromotorAnterior,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El Promotor actual  esta vacio.';
            SET varControl  := 'promotorAnterior' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_PromotorActual,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'El Nuevo Promotor  esta vacio.';
            SET varControl  := 'promotorActual' ;
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_UsuarioID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := 006;
            SET Par_ErrMen  := 'El Usuario que registra el cambio de sucursal al safilocale.cliente  esta vacio.';
            SET varControl  := 'usuarioID' ;
            LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS(SELECT ClienteID
                    FROM    CLIENTES
                    WHERE ClienteID = Par_ClienteID
                    AND Estatus =Estatus_Activo)THEN
                SET Par_NumErr  := 007;
                SET Par_ErrMen  := 'El safilocale.cliente  no existe.';
                SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
        END IF;
        IF EXISTS(SELECT ClienteID
                    FROM    CLIENTES
                    WHERE ClienteID = Par_ClienteID
                        AND SucursalOrigen = Par_SucursalDestino)THEN
                SET Par_NumErr  := 008;
                SET Par_ErrMen  := 'La Sucursal Actual del safilocale.cliente es la misma que la Sucursal Destino.';
                SET varControl  := 'sucursalDestino' ;
                LEAVE ManejoErrores;
        END IF;
        IF NOT EXISTS(SELECT PromotorID
                    FROM    PROMOTORES
                    WHERE PromotorID = Par_PromotorActual
                        AND SucursalID = Par_SucursalDestino
                    LIMIT 1)THEN
                SET Par_NumErr  := 013;
                SET Par_ErrMen  := 'El Promotor Destino No existe.';
                SET varControl  := 'promotorActual' ;
                LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS(SELECT SucursalID
                    FROM    SUCURSALES
                    WHERE SucursalID = Par_SucursalDestino
                    LIMIT 1)THEN
                SET Par_NumErr  := 014;
                SET Par_ErrMen  := 'La Sucursal Destino No existe.';
                SET varControl  := 'sucursalDestino' ;
                LEAVE ManejoErrores;
        END IF;

        SELECT FechaSistema INTO Var_FechaSis FROM PARAMETROSSIS;


        IF(Var_ValCtasBloqueadas =StringSI)THEN
            SELECT IFNULL(CuentaAhoID,Entero_Cero),MotivoBlo INTO Var_CuentaBloq, Var_MotivoBlo
                FROM CUENTASAHO Cue
                        INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cue.ClienteID
                    WHERE Cue.ClienteID = Par_ClienteID
                    AND Cue.SucursalID != Par_SucursalDestino
                    AND Cue.Estatus = EstatusBloqueada LIMIT 1;

            IF(Var_CuentaBloq != Entero_Cero) THEN
                SET Par_NumErr  := 016;
                SET Par_ErrMen  := CONCAT('El  safilocale.cliente tiene Cuenta Bloqueada'
                                          ' CTA: ',CONVERT(Var_CuentaBloq , CHAR),
                                          ' Motivo: ',Var_MotivoBlo);
                SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
           END IF ;
       END IF;

        IF EXISTS(SELECT CreditoID
                    FROM    CREDITOS
                    WHERE ClienteID = Par_ClienteID
                    AND (Estatus = Estatus_InActivo OR Estatus = Estatus_Autorizado)
                    LIMIT 1)THEN
                SET Par_NumErr  := 009;
                SET Par_ErrMen  := 'El safilocale.cliente tiene Credito(s) Inactivo(s) y/o Autorizado(s).';
                SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
        END IF;

        IF(Var_ValDiasAtraso = StringSI)THEN
            IF EXISTS(SELECT CreditoID
                        FROM    CREDITOS
                        WHERE ClienteID = Par_ClienteID
                            AND FUNCIONDIASATRASO(CreditoID,Var_FechaSis)>0
                            AND Estatus IN(EstatusVigente,EstatusVencido)
                        LIMIT 1)THEN
                    SET Par_NumErr  := 011;
                    SET Par_ErrMen  := 'El safilocale.cliente tiene Credito(s) con Dias de Atraso.';
                    SET varControl  := 'clienteID' ;
                    LEAVE ManejoErrores;
            END IF;
        END IF;

        IF EXISTS(SELECT SolicitudCreditoID
                    FROM    SOLICITUDCREDITO
                    WHERE ClienteID = Par_ClienteID
                        AND Estatus IN(Estatus_InActivo,Estatus_Liberado,Estatus_Autorizado)
                    LIMIT 1)THEN
                SET Par_NumErr  := 012;
                SET Par_ErrMen  := 'El safilocale.cliente tiene Solicitud(es) de Credito Inactiva(s), Liberada(s) y/o Autorizada(s).';
                SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
        END IF;

      IF EXISTS(SELECT ClienteID, SucursalID
                        FROM INTEGRAGRUPONOSOL SOL
                            INNER JOIN GRUPOSNOSOLIDARIOS GRU ON SOL.GrupoID=GRU.GrupoID
                            WHERE ClienteID= Par_ClienteID
                            AND SucursalID=Par_SucursalOrigen
                            LIMIT 1) THEN
                SET Par_NumErr  := 015;
                SET Par_ErrMen  := 'El  safilocale.cliente Pertenece a un Grupo No Solidario.';
                SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
       END IF ;
        IF(Var_ValInvProceso = StringSI)THEN
            IF EXISTS (SELECT *
                            FROM INVERSIONES Inv
                                    INNER JOIN CLIENTES Cli ON Cli.ClienteID=Inv.ClienteID
                                WHERE Inv.ClienteID= Par_ClienteID
                                AND Inv.Estatus=Estatus_Activo LIMIT 1) THEN
                    SET Par_NumErr  := 017;
                    SET Par_ErrMen  := CONCAT('El  safilocale.cliente tiene Inversion (es) Registrada (s) \n Pendiente (s) por Autorizar.');
                    SET varControl  := 'clienteID' ;
                    LEAVE ManejoErrores;
           END IF ;
        END IF;
        IF(Var_ValProfun = StringSI)THEN
            SET Var_MontoPendiente := (SELECT IFNULL(Cob.MontoPendiente,Decimal_Cero)
                                        FROM CLICOBROSPROFUN  Cob
                                            INNER JOIN CLIENTESPROFUN Pro
                                            WHERE Cob.ClienteID =  Pro.ClienteID
                                            AND Cob.ClienteID = Par_ClienteID
                                            AND Pro.Estatus IN(Estatus_InActivo,EstatusRegistrada));

           IF (Var_MontoPendiente > Decimal_Cero) THEN
                    SET Par_NumErr  := 018;
                    SET Par_ErrMen  := CONCAT('El  safilocale.cliente tiene Adeudos de Profun.');
                    SET varControl  := 'clienteID' ;
                    LEAVE ManejoErrores;
           END IF ;
       END IF;

        IF(Var_ValCtasActivas = StringSI)THEN
            SELECT COUNT(CuentaAhoID) INTO Var_NumCuentas
                FROM CUENTASAHO
                WHERE ClienteID=Par_ClienteID
                AND Estatus IN (Estatus_Activo,EstatusBloqueada);

           IF Var_NumCuentas = Entero_Cero THEN
                    SET Par_NumErr  := 019;
                    SET Par_ErrMen  := CONCAT('El  safilocale.cliente No tiene Cuentas Activas.');
                    SET varControl  := 'clienteID' ;
                    LEAVE ManejoErrores;
           END IF;
        END IF;


        SELECT FechaSistema, MonedaBaseID INTO Var_FechaOper,Var_MonedaBaseID
            FROM PARAMETROSSIS;

        CALL DIASFESTIVOSCAL(
                Var_FechaOper,      Entero_Cero,            Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);


        SELECT Saldo INTO Var_Saldo
            FROM APORTACIONSOCIO
            WHERE ClienteID = Par_ClienteID;



        SET Var_Poliza  := Entero_Cero;
        SET Var_ClienteStr := CONVERT(Par_ClienteID, CHAR);

        IF(Var_Saldo > Entero_Cero) THEN
            CALL CONTACAJAPRO(
                    Aud_NumTransaccion, Var_FechaApl,       Var_Saldo,          DescrpcionMov,      Var_MonedaBaseID,
                    Par_SucursalOrigen, AltaEncPolizaSI,    ConCambioSucurs,    Var_Poliza,         AltaDetPolSI,
                    ConceptosCaja,      NatCargo,           Var_ClienteStr,     Var_ClienteStr,     Entero_Cero,
                    TipoInstrumentoID,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Aud_NumTransaccion  );
			
            -- VALIDACION DE ERRORES
            IF(Par_NumErr!=Entero_Cero)THEN
                SET Par_NumErr  := Par_NumErr;
				SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
            END IF;
            
            CALL CONTACAJAPRO(
                    Aud_NumTransaccion,     Var_FechaApl,       Var_Saldo,          DescrpcionMov,      Var_MonedaBaseID,
                    Par_SucursalDestino,    AltaEncPolizaNO,    ConCambioSucurs,    Var_Poliza,         AltaDetPolSI,
                    ConceptosCaja,          NatAbono,           Var_ClienteStr,     Var_ClienteStr,     Entero_Cero,
                    TipoInstrumentoID,      SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
                    Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Aud_NumTransaccion  );
			-- VALIDACION DE ERRORES
            IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr  := Par_NumErr;
				SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
            END IF;
        END IF;


        IF(Var_Reclasificaconta = StringSI )THEN
            CALL CONTACAMBIOSUCURSALPRO(
                Par_ClienteID,          Par_SucursalOrigen,     Par_SucursalDestino,        NatCargo,           AltaEncPolizaNO,
                ConCambioSucurs,        DescrpcionMovINV,       Var_Poliza,                 Par_NumErr,         Par_ErrMen,
                Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,            Aud_DireccionIP,    Aud_ProgramaID,
                Par_SucursalOrigen,     Aud_NumTransaccion);
			-- VALIDACION DE ERRORES
            IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr  := Par_NumErr;
				SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Aud_FechaActual     := NOW();
        SET Var_FechaCambio     := Var_FechaSis + INTERVAL HOUR(CURRENT_TIME) HOUR + INTERVAL MINUTE(CURRENT_TIME) MINUTE + INTERVAL SECOND(CURRENT_TIME) SECOND;

        UPDATE CLIENTES
            SET SucursalOrigen = Par_SucursalDestino,
                PromotorActual = Par_PromotorActual
        WHERE ClienteID = Par_ClienteID;

        UPDATE APORTACIONSOCIO
            SET SucursalID = Par_SucursalDestino
        WHERE ClienteID = Par_ClienteID;

        INSERT INTO HISCAMBIOSUCURCLI(
                ClienteID,          SucursalOrigen,         SucursalDestino,        PromotorAnterior,       PromotorActual,
                UsuarioID,          Fecha,                  EmpresaID,              Usuario,                FechaActual,
                DireccionIP,        ProgramaID,             Sucursal,               NumTransaccion)
        VALUES( Par_ClienteID,      Par_SucursalOrigen,     Par_SucursalDestino,    Par_PromotorAnterior,   Par_PromotorActual,
                Par_UsuarioID,      Var_FechaCambio,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);



        IF(Var_Reclasificaconta = StringSI )THEN
            CALL CONTACAMBIOSUCURSALPRO(
                    Par_ClienteID,          Par_SucursalOrigen,     Par_SucursalDestino,    NatAbono,           AltaEncPolizaNO,
                    ConCambioSucurs,        DescrpcionMovINV,       Var_Poliza,             Par_NumErr,         Par_ErrMen,
                    Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                    Par_SucursalDestino,    Aud_NumTransaccion);

			-- VALIDACION DE ERRORES
            IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr  := Par_NumErr;
				SET varControl  := 'clienteID' ;
                LEAVE ManejoErrores;
            END IF;

            IF Var_Poliza >Entero_Cero THEN
                UPDATE DETALLEPOLIZA
                    SET   Sucursal      =Aud_Sucursal
                    WHERE PolizaID      =Var_Poliza
                    AND   Numtransaccion=Aud_NumTransaccion;
            END IF;
         END IF;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Informacion Grabada Exitosamente: ',CONVERT(Par_ClienteID,CHAR));
        SET varControl  := 'imprimir' ;
        LEAVE ManejoErrores;

END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  Par_NumErr           AS NumErr,
                    Par_ErrMen           AS ErrMen,
                    varControl           AS control,
                    Par_ClienteID        AS consecutivo;
        END IF;

END TerminaStore$$