-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_TRANSACCIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_TRANSACCIONESPRO`;
DELIMITER $$

CREATE PROCEDURE `TC_TRANSACCIONESPRO`(
/* ----------------------------------------------------------
    Procesa las operaciones de tarjetas de credito
-- ---------------------------------------------------------- */
    Par_OrigenOperacion     CHAR(1),          -- Origen de la operacion
    Par_TipoMensaje         CHAR(4),          -- Tipo de mensaje POS
    Par_TipoOperacionID     CHAR(2),          -- Tipo de Operacion
    Par_TarjetaCredID       CHAR(16),         -- Numero de tarjeta
    Par_MontoOperacion      DECIMAL(16,2),    -- Monto de la operacion original

    Par_MontoCashBack       DECIMAL(16,2),    -- Monto para cashback
    Par_MontoComision       DECIMAL(16,2),    -- Monto de comision
    Par_MontoIva            DECIMAL(10,2),    -- Monto de IVA
    Par_CodigoMonOpe        VARCHAR(10),      -- Codigo de la moneda de origen
    Par_FechaOperacion      DATE,             -- Fecha de Operacion

    Par_HoraOperacion       TIME,             -- Hora de Operacion
    Par_GiroNegocio         VARCHAR(5),       -- Giro del Negocio
    Par_IRD                 VARCHAR(4),       -- Clave IRD
    Par_NombreComercio      VARCHAR(50),      -- Nombre del comercio
    Par_Ciudad              VARCHAR(20),      -- Ciudad del comercio

    Par_Pais                VARCHAR(6),       -- Pais del comercio
    Par_Referencia          VARCHAR(25),      -- Datos de referencia
    Par_DatosTiempoAire     VARCHAR(70),      -- Datos de tiempo aire
    Par_CodigoAprobacion    VARCHAR(6),       -- Codigo de Aprobacion
    Par_CheckIn             CHAR(1),          -- CHECK IN


    Par_Salida              CHAR(1),          -- Salida
    INOUT Par_NumErr        INT,              -- Salida
    INOUT Par_ErrMen        VARCHAR(400),     -- Salida

    Par_EmpresaID           INT,            -- Auditoria
    Aud_Usuario             INT,            -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT,            -- Auditoria
    Aud_NumTransaccion      BIGINT          -- Auditoria
)
TerminaStore:BEGIN


-- --------------------------------------------------
-- Variables
-- --------------------------------------------------
DECLARE Var_TarCredMovID        INT;                -- Id del movimiento de tarjeta
DECLARE Var_MonedaID            INT;                -- Codigo de Moneda
DECLARE Var_CntTrDbBtcrMvs      INT(11);            -- Numero de registros duplicados
DECLARE Var_ValorDivisa         DECIMAL(10,2);      -- Valor de la divisa (TC - DOlares)

DECLARE Var_MontoOperacionMx    DECIMAL(16,2);      -- Monto de operacion en pesos
DECLARE Var_MontoCashBackMx     DECIMAL(16,2);      -- Monto de cashback en pesos
DECLARE Var_MontoComisionMx     DECIMAL(16,2);      -- Monto de Comision en pesos
DECLARE Var_MontoIvaMx          DECIMAL(10,2);      -- Monto de IVA en pesos

DECLARE Var_NumeroTransaccion   BIGINT;             -- Numero de transaccion de la operacion
DECLARE Var_SaldoContableAct    DECIMAL(16,2);      -- Saldo Contable
DECLARE Var_SaldoDisponibleAct  DECIMAL(16,2);      -- Saldo disponible
DECLARE Var_ComisionManejoUso   DECIMAL(16,2);      -- Comision por manejo de uso
DECLARE Var_CodigoRespuesta     CHAR(3);            -- Codigo de respuesta
DECLARE Var_FechaAplicacion     DATE;               -- Fecha de Aplicacion
DECLARE Var_FechaRegMoneda      DATE;               -- Fecha Reg Moneda
DECLARE Var_TranRegMoneda       BIGINT;             -- Tramsaccion Moneda

DECLARE Var_TransLinea          CHAR(1);            -- Indica si transacciona en linea
DECLARE Var_MonedaMex           CHAR(5);            -- Codigo Moneda Mex
DECLARE Var_EstatusTar          CHAR(1);            -- Estatus de tarjeta
DECLARE Var_FechaVencim         DATE;               -- Fecha de Vencimiento
DECLARE Var_TipoCancela         INT(11);            -- Tipo de Cancelacion

DECLARE Var_EstatusLinea        CHAR(1);            -- Estatus de la Linea
DECLARE Var_LineaTarCred        INT;                -- Linea tarjeta de credito

DECLARE TarjetaActiva           INT(11);            -- Numero que indica tarjeta activa
DECLARE Tar_Bloqueada           INT(11);            -- Tarjeta bloqueda
DECLARE Tar_Cancelada           INT(11);            -- Tarjeta Cancelada
DECLARE Tar_Expirada            INT(11);            -- Tarjeta Expirada
DECLARE Reporte_Robo            INT(11);            -- Reporte de robo

DECLARE Error_Key               INT;
DECLARE Cadena_Vacia            VARCHAR(2);

DECLARE Compra_Normal       VARCHAR(2);
DECLARE Retiro_Efectivo     VARCHAR(2);
DECLARE Consulta_Saldo      VARCHAR(2);
DECLARE Pago_Tarjeta        VARCHAR(2);
DECLARE Var_Naturaleza      CHAR(1);
DECLARE Var_MontoTotal      DECIMAL(16,2);
-- --------------------------------------------------
-- Constantes
-- --------------------------------------------------
DECLARE Salida_No           CHAR(1);
DECLARE POSEnLineaSi        CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Cons_SI             CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Mon_Dolares         INT;
DECLARE Est_Procesado       CHAR(1);
DECLARE Moneda_Peso         INT;
DECLARE Saldo_Cero          DECIMAL(4,2);
DECLARE Origen_OperaEmi     CHAR(1);
DECLARE Origen_OperaStats   CHAR(1);

-- --------------------------------------------------
-- Inicializacion de variables
-- --------------------------------------------------
SET TarjetaActiva       := 7;               -- Numero que indica que la tarjeta se encuentra activa
SET Tar_Bloqueada       := 8;               -- Tarjeta blqueada
SET Tar_Cancelada       := 9;               -- Tarjeta Cancelada
SET Tar_Expirada        := 10;              -- Tarjeta Expirada
SET Reporte_Robo        :=  8;              -- Reporte de robo
SET Cadena_Vacia        := '';

SET Salida_No           := 'N';
SET Var_MonedaMex       := '484';
SET POSEnLineaSi        := 'S';             -- DEFAULT si transacciona en linea
SET Entero_Cero         := 0;
SET Saldo_Cero          := 0.0;

SET Compra_Normal       := '00';            -- Codigo Compra Normal
SET Retiro_Efectivo     := '01';            -- Codigo Retiro de Efectivo
SET Consulta_Saldo      := '31';            -- Codigo Consulta de Saldo
SET Pago_Tarjeta        := '91';            -- Codigo Pago Con tarjeta
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Mon_Dolares         := 2;               -- Moneda en Dolares
SET Cons_SI             := 'S';
SET Est_Procesado       := 'P';
SET Moneda_Peso         := 1;
SET Origen_OperaEmi     := 'E';
SET Origen_OperaStats   := 'T';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_TRANSACCIONESPRO');
      END;


    SET Par_CodigoMonOpe := trim(Par_CodigoMonOpe);
    -- Fecha de aplicacion . Fecha de Sistema
    SELECT FechaSistema
        INTO Var_FechaAplicacion
        FROM PARAMETROSSIS LIMIT 1;


    -- Validar si es operacion en Pesos
    IF Par_CodigoMonOpe != Var_MonedaMex THEN

        IF Var_FechaAplicacion < Par_FechaOperacion THEN

            SELECT MIN(FechaRegistro), MIN(NumTransaccion)
                INTO Var_FechaRegMoneda, Var_TranRegMoneda
                FROM `HIS-MONEDAS`
                WHERE MonedaId = Mon_Dolares
                AND FechaRegistro > Par_FechaOperacion;

            SELECT TipCamFixVen
                INTO Var_ValorDivisa
            FROM `HIS-MONEDAS`
                WHERE  MonedaId = Mon_Dolares
                AND FechaRegistro = Var_FechaRegMoneda
                AND NumTransaccion = Var_TranRegMoneda;

        ELSE

            SELECT TipCamFixVen
                INTO Var_ValorDivisa
            FROM `MONEDAS`
                WHERE  MonedaId = Mon_Dolares;

        END IF;


        SET Var_ValorDivisa := IFNULL(Var_ValorDivisa, Entero_Cero);

        SET Var_MontoOperacionMx:= Par_MontoOperacion * Var_ValorDivisa;
        SET Var_MontoCashBackMx := Par_MontoCashBack * Var_ValorDivisa;
        SET Var_MontoComisionMx := Par_MontoComision * Var_ValorDivisa;
        SET Var_MontoIvaMx      := Par_MontoIva * Var_ValorDivisa;
    ELSE
        SET Var_ValorDivisa     := 1;
        SET Var_MontoOperacionMx:= Par_MontoOperacion;
        SET Var_MontoCashBackMx := Par_MontoCashBack;
        SET Var_MontoComisionMx := Par_MontoComision;
        SET Var_MontoIvaMx      := Par_MontoIva;

    END IF;


    -- Validar si la tarjeta transacciona en Linea
    SELECT IFNULL(tip.CompraPOSLinea, POSEnLineaSi)
      INTO Var_TransLinea
      FROM TARJETACREDITO tar, TIPOTARJETADEB tip
     WHERE tar.TipoTarjetaCredID = tip.TipoTarjetaDebID
       AND tip.IdentificacionSocio != Cons_SI
       AND tar.TarjetaCredID = Par_TarjetaCredID;

    SET Var_TransLinea := IFNULL(Var_TransLinea,POSEnLineaSi);

    SELECT Naturaleza
            INTO Var_Naturaleza
        FROM TC_TIPOSOPERACION
        WHERE TipoOperacionID = Par_TipoOperacionID;

    --
    -- Se registra la operacion en la bitacora de transacciones
    CALL TC_BITACORAMOVSALT(
        Par_OrigenOperacion,    Par_TipoMensaje,        Par_TipoOperacionID,    Par_TarjetaCredID,      Par_MontoOperacion,
        Par_MontoCashBack,      Par_MontoComision,      Par_MontoIva,           Par_CodigoMonOpe,       Entero_Cero,
        Var_MontoOperacionMx,   Var_MontoCashBackMx,    Var_MontoComisionMx,    Var_MontoIvaMx,         Entero_Cero,
        Par_FechaOperacion,     Par_HoraOperacion,      Par_GiroNegocio,        Par_IRD,                Par_NombreComercio,
        Par_Ciudad,             Par_Pais,               Par_Referencia,         Par_DatosTiempoAire,    Par_CodigoAprobacion,
        Var_TransLinea,         Par_CheckIn,            Var_Naturaleza,         Var_ValorDivisa,        Var_TarCredMovID,
        Salida_No,              Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    IF Par_NumErr != Entero_Cero THEN
        SET Par_ErrMen := CONCAT('TC_BITACORAMOVSALT - ',Par_ErrMen);
        LEAVE ManejoErrores;
    END IF;


    -- validacion de tipo de operacion
    IF (IFNULL(Par_TipoOperacionID, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "412";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 412;
        SET Par_ErrMen  := 'Tipo de Operacion Vacio';

        LEAVE ManejoErrores;
    END IF;


    -- validacion de numero de tarjeta
    IF (IFNULL(Par_TarjetaCredID, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "214";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 214;
        SET Par_ErrMen  := 'Numero de tarjeta Vacia';

        LEAVE ManejoErrores;
    END IF;

    IF CHAR_LENGTH(Par_TarjetaCredID) != 16 THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "214";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 214;
        SET Par_ErrMen  := 'Numero de tarjeta incorrecto';

        LEAVE ManejoErrores;
    END IF;

    -- valida codigo de aprobacion
    IF (IFNULL(Par_CodigoAprobacion, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "412";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 412;
        SET Par_ErrMen  := 'Numero de Autorizacion Vacio';

        LEAVE ManejoErrores;
    END IF;

    IF(Par_OrigenOperacion IN (Origen_OperaEmi, Origen_OperaStats)) THEN
        SET Var_MontoTotal :=  Par_MontoOperacion + Par_MontoComision;
        -- Monto de Operacion
        IF (IFNULL(Var_MontoTotal, Saldo_Cero) = Saldo_Cero) THEN
            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "412";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 412;
            SET Par_ErrMen  := 'Monto de Operacion Vacio';

            LEAVE ManejoErrores;
        END IF;
    ELSE
        -- Monto de Operacion
        IF (IFNULL(Par_MontoOperacion, Saldo_Cero) = Saldo_Cero) THEN
            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "412";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 412;
            SET Par_ErrMen  := 'Monto de Operacion Vacio';

            LEAVE ManejoErrores;
        END IF;
    END IF;


    -- Nombre del comercio
    IF (IFNULL(Par_NombreComercio, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "412";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 412;
        SET Par_ErrMen  := 'Nombre de Comercio Vacio';

        LEAVE ManejoErrores;
    END IF;

    -- Nombre del comercio
    IF NOT EXISTS(SELECT TarjetaCredID FROM TARJETACREDITO WHERE TarjetaCredID = Par_TarjetaCredID) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "412";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 412;
        SET Par_ErrMen  := 'Numero de Tarjeta no Existe';

        LEAVE ManejoErrores;
    END IF;



    -- Validar Estatus de la Tarjeta
    SELECT tar.Estatus, tar.MotivoCancelacion,LineaTarCredID
          INTO Var_EstatusTar, Var_TipoCancela, Var_LineaTarCred
          FROM TARJETACREDITO tar
          WHERE tar.TarjetaCredID = Par_TarjetaCredID;


    IF(IFNULL(Var_EstatusTar, Entero_Cero)<> TarjetaActiva ) THEN
        IF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Bloqueada ) THEN

            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "334";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 334;
            SET Par_ErrMen  := 'Tarjeta Bloqueada';

        ELSEIF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Cancelada AND IFNULL(Var_TipoCancela,Entero_Cero) = Reporte_Robo  ) THEN

            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "333";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 333;
            SET Par_ErrMen  := 'Tarjeta Reportada como Robada';

        ELSEIF(IFNULL(Var_EstatusTar, Entero_Cero) = Tar_Expirada ) THEN

            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "215";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 215;
            SET Par_ErrMen  := 'Tarjeta Expirada';
        ELSE

            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_CodigoRespuesta     := "214";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;
            SET Var_ComisionManejoUso   := Saldo_Cero;

            SET Par_NumErr  := 214;
            SET Par_ErrMen  := 'Tarjeta Cancelada';
        END IF;
        LEAVE ManejoErrores;
    END IF;

    -- Validacion de la Linea de Credito
    SELECT Estatus, LineaTarCredID
    INTO   Var_EstatusLinea,Var_LineaTarCred
    FROM LINEATARJETACRED
    WHERE LineaTarCredID = Var_LineaTarCred;

    IF (IFNULL(Var_LineaTarCred, Entero_Cero) = Entero_Cero) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "116";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 116;
        SET Par_ErrMen  := 'La linea de tarjeta no existe';

        LEAVE ManejoErrores;
    END IF;

    IF (IFNULL(Var_EstatusLinea, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_CodigoRespuesta     := "412";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;
        SET Var_ComisionManejoUso   := Saldo_Cero;

        SET Par_NumErr  := 116;
        SET Par_ErrMen  := CONCAT('Estatus de la Linea Incorrecto - Est. ',IFNULL(Var_EstatusLinea, Cadena_Vacia));

        LEAVE ManejoErrores;
    END IF;

    -- Validar si la operacion se registro antes y fue procesada con exito
    SELECT COUNT(*)
          INTO Var_CntTrDbBtcrMvs
      FROM TC_BITACORAMOVS
     WHERE TarjetaCredID = Par_TarjetaCredID
       AND Referencia = Par_Referencia
       AND MontoOperacion = Par_MontoOperacion
       AND CodigoAprobacion = Par_CodigoAprobacion
       AND Estatus = Est_Procesado
       AND FechaOperacion = Par_FechaOperacion;

    IF(Var_CntTrDbBtcrMvs > Entero_Cero)THEN
        SET Var_NumeroTransaccion   := Entero_Cero;
        SET Var_SaldoContableAct    := Saldo_Cero;
        SET Var_SaldoDisponibleAct  := Saldo_Cero;
        SET Var_ComisionManejoUso   := Saldo_Cero;
        SET Var_CodigoRespuesta     := "308";
        SET Var_FechaAplicacion     := Var_FechaAplicacion;

        SET Par_NumErr  := 308;
        SET Par_ErrMen  := 'Transaccion Repetida';

        LEAVE ManejoErrores;
    END IF;


    -- ----------------------------------------------------------------------------------------------------------
    --     INICIA EL PROCESO DE LA TRANSACCION POR TIPO
    -- ----------------------------------------------------------------------------------------------------------
    CASE WHEN EXISTS (SELECT TipoOperacionID
                    FROM TC_TIPOSOPERACION
                        WHERE TipoOperacionID = Par_TipoOperacionID
                        AND Naturaleza = Nat_Cargo) THEN

            START TRANSACTION;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                        BEGIN
                            SET Par_NumErr := 909;
                            SET Par_ErrMen := 'Error SQL Seccion Aplicacion de Transaccion';
                        END;

                    CALL `TC_COMPRANORMALRPRO`(
                            Par_TipoOperacionID,    Par_TarjetaCredID,      Par_Referencia,         Var_MontoOperacionMx,       Par_MontoComision,
                            Par_MontoIVA ,          Par_GiroNegocio ,       Moneda_Peso  ,          Aud_NumTransaccion,         Var_TransLinea,
                            Par_FechaOperacion ,    Par_OrigenOperacion,    Par_NombreComercio,     Var_NumeroTransaccion,      Var_SaldoContableAct,
                            Var_SaldoDisponibleAct, Var_CodigoRespuesta,    Var_FechaAplicacion,    Var_TarCredMovID,           Par_CodigoAprobacion,
                            Entero_Cero,
                            Salida_NO,              Par_NumErr,             Par_ErrMen,             Par_EmpresaID,              Aud_Usuario,
                            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        LEAVE ManejoErrores;
                        ROLLBACK;
                    END IF;

                END;

            IF Par_NumErr <> Entero_Cero THEN
                ROLLBACK;
            ELSE
                COMMIT;
            END IF;

    ELSE

            SET Var_NumeroTransaccion   := Entero_Cero;
            SET Var_SaldoContableAct    := Saldo_Cero;
            SET Var_SaldoDisponibleAct  := Saldo_Cero;
            SET Var_ComisionManejoUso   := Saldo_Cero;
            SET Var_CodigoRespuesta     := "412";
            SET Var_FechaAplicacion     := Var_FechaAplicacion;

            SET Par_NumErr  := 412;
            SET Par_ErrMen  := 'Tipo de Operacion No Soportada';

            LEAVE ManejoErrores;

    END CASE; -- END CASE


END ManejoErrores;

    -- Se ingresa el alta de la respuesta de transaccion
    CALL TC_BITACORARESPALT(
        Par_TarjetaCredID,      Par_TipoMensaje,    Par_TipoOperacionID,        Par_FechaOperacion,         Par_HoraOperacion,
        Par_MontoOperacion,     Par_Referencia,     Var_NumeroTransaccion,      Var_SaldoContableAct,           Var_SaldoDisponibleAct,
        Var_CodigoRespuesta,    Par_ErrMen,
        Salida_NO,              @Par_NumErr,        @Par_ErrMen,                Par_EmpresaID,              Aud_Usuario,
        Par_FechaOperacion,     Aud_DireccionIP,    Aud_ProgramaID,             Aud_Sucursal,
        Var_NumeroTransaccion   );


    IF Par_Salida = Cons_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$