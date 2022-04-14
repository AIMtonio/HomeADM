-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_COMPRANORMALRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_COMPRANORMALRPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_COMPRANORMALRPRO`(
-- ---------------------------------------------------------------------------------
-- SP QUE REALIZA LAS VALIDACIONES COMPRA NORMAL CON TC
-- ---------------------------------------------------------------------------------
    Par_TipoOperacion               CHAR(2),        --  Tipo de Operacion de Tarjeta
    Par_NumeroTarjeta               CHAR(16),       --  Numero de Tarjeta de Credito
    Par_Referencia                  VARCHAR(25),    --  Referencia
    Par_MontoTransaccion            DECIMAL(12,2),  --  Monto en pesos de la transaccion
    Par_MontoComision               DECIMAL(12,2),  --  Monto de Comision

    Par_MontoIVAComision            DECIMAL(12,2),  --  Monto de IVA de Comision
    Par_GiroNegocio                 CHAR(5),        --  ID del Giro de Negocio
    Par_MonedaID                    INT(11),        --  Codigo de Moneda
    Par_NumTransaccion              VARCHAR(10),    --  Numero de Transaccion
    Par_CompraPOSLinea              CHAR(1),        --  Indica si puede realizar compras en linea

    Par_FechaActual                 DATETIME,       --  Fecha actual de la operacion
    Par_OrigenOperacion             CHAR(1),        --  Origen de la operacion 12
    Par_NomUbicTerminal             VARCHAR(150),   --  Nombre de la terminal
    INOUT Par_NumeroTransaccion     BIGINT,         --  Respuesta: Numero de Transaccion
    INOUT Par_SaldoContableAct      DECIMAL(16,2),  --  Respuesta: Saldo disponible de la linea

    INOUT Par_SaldoDisponibleAct    DECIMAL(16,2),  --  Respuesta: Saldo disponible,  + saldo bloqueado + saldo a favor
    INOUT Par_CodigoRespuesta       VARCHAR(3),     --  Respuesta: Codigo de Respuesta PROSA
    INOUT Par_FechaAplicacion       DATE,           --  Fecha de Aplicacion de la operacion
    Var_TarCredMovID                INT(11),        --  Numero de movimiento
    Par_NumAutorizacion             BIGINT,         --  Numero de autorizacion PROSA
    Par_PolizaID                    BIGINT(20),     --  Numero de Poliza

    Par_Salida                      CHAR(1),        --  Salida de datos
    INOUT Par_NumErr                INT,            --  Numero de Error
    INOUT Par_ErrMen                VARCHAR(400),   --  Mensaje de Salida

    Par_EmpresaID                   INT,            --  Auditoria
    Aud_Usuario                     INT,            --  Auditoria
    Aud_FechaActual                 DATETIME,       --  Auditoria
    Aud_DireccionIP                 VARCHAR(15),    --  Auditoria
    Aud_ProgramaID                  VARCHAR(50),    --  Auditoria
    Aud_Sucursal                    INT,            --  Auditoria
    Aud_NumTransaccion              BIGINT          --  Auditoria
)

TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE Var_LineaCreditoID      BIGINT(12);         -- Valor del numero de cuenta
    DECLARE Var_ClienteID           INT(11);            -- Valor del numero de cliente
    DECLARE Var_Referencia          VARCHAR(50);        -- Valor del numero de tarjeta
    DECLARE Var_DesAhorro           VARCHAR(150);       -- Descripcion por compra con tarjeta
    DECLARE Var_SaldoDisp           DECIMAL(12,2);      -- Valor del saldo disponible

    DECLARE Var_SaldoDispoAct       DECIMAL(12,2);      -- Valor del saldo disponible actual
    DECLARE Var_SaldoContable       DECIMAL(12,2);      -- Valor del saldo contable de la cuenta
    DECLARE Var_TipoTarjetaDeb      INT(11);            -- Valor del tipo de tarjeta
    DECLARE Val_Giro                CHAR(4);            -- Valor del giro de negocio
    DECLARE Var_BloqueID            INT(11);            -- Numero de bloqueo

    DECLARE Var_BloqPOS             VARCHAR(5);         -- Valor bloqueo: POS
    DECLARE Var_MontoCompLibre      DECIMAL(12,2);      -- Monto de compra libre
    DECLARE Var_MontoCompraMes      DECIMAL(12,2);      -- Monto de compra al mes
    DECLARE Var_LimiteCompraMes     DECIMAL(12,2);      -- Monto de limite de compras al mes
    DECLARE Var_Saldo               DECIMAL(12,2);      -- Valor del saldo

    DECLARE Var_SaldoDispon         DECIMAL(12,2);      -- Monto del salod disponible
    DECLARE Var_NumTransaccion      BIGINT(20);         -- Se obtiene el numero de transaccion
    DECLARE Var_TotalCompra         DECIMAL(16,2);      -- Monto total de compra

    DECLARE Var_ProductoCreditoID   INT;
    DECLARE Var_Clasificacion       CHAR(1);
    DECLARE Var_SubClasificacion    INT(11);
    DECLARE Var_SucursalCte         INT(11);
    DECLARE Var_Poliza              BIGINT(20);
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_MontoTotal          DECIMAL(12,2);
    DECLARE Var_Enc_Pol             CHAR(1);            -- Variable que Indica si crea encabezado de Poliza
    DECLARE Var_EstatusLinea        CHAR(1);            -- Estatus de la linea R: Registrada, V: Vigente, B: Bloqueada, C:
    DECLARE Est_Vigente             CHAR(1);            
    DECLARE Var_EstatusTarjeta      INT(11);            -- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
    DECLARE Con_TarjetaActiva       INT(11);            -- Constante Estatus Activo de Tarjetas
    DECLARE Var_TarjetaCreditoID    CHAR(16);           -- Numero de Linea de Credito
    DECLARE LongitudTarjeta         INT(11);            -- Constante Longitud Tarjeta

    -- Declaracion de constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(11);
    DECLARE Salida_NO               CHAR(1);
    DECLARE Salida_SI               CHAR(1);
    DECLARE Decimal_Cero            DECIMAL(12,2);

    DECLARE CompraEnLineaSI         CHAR(1);
    DECLARE CompraEnLineaNO         CHAR(1);
    DECLARE Nat_Cargo               CHAR(1);
    DECLARE Mov_AhoCompra           VARCHAR(50);

    DECLARE Error_Key               INT(11);
    DECLARE BloqPOS_SI              CHAR(1);
    DECLARE Var_MontoCompraDiario   DECIMAL(12,2);
    DECLARE Var_LimiteCompraDiario  DECIMAL(12,2);
    DECLARE Entero_MenosUno         INT(11);

    DECLARE Var_NatMovimiento       CHAR(1);
    DECLARE Var_TipoBloqID          INT(11);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Saldo_Cero              DECIMAL(16,2);
    DECLARE ProActualiza            INT(11);

    DECLARE Est_Procesado           CHAR(1);
    DECLARE Var_Continuar           INT(11);
    DECLARE Est_Registrado          CHAR(1);
    DECLARE Con_BloqPOS             INT(11);
    DECLARE Con_CompraDiario        INT(11);

    DECLARE Con_DispoDiario         INT(11);
    DECLARE Con_CompraMes           INT(11);
    DECLARE Con_DispoMes            INT(11);
    DECLARE BloqueoSaldo            CHAR(1);
    DECLARE TipBloqTarjeta          INT(11);

    DECLARE Alta_Enc_Pol_SI         CHAR(1);
    DECLARE Alta_Enc_Pol_NO         CHAR(1);
    DECLARE Concepto_TarCred        INT(11);
    DECLARE AltaPolCre_Si           CHAR(1);
    DECLARE AltaMovLin_SI           CHAR(1);
    DECLARE AltaPolLinCre_Si        CHAR(1);
    DECLARE RegistraMov_NO          CHAR(1);

    DECLARE Con_CapVigente          INT(11);
    DECLARE Con_ComTarCred          INT(11);
    DECLARE Con_IVAComTarCred       INT(11);
    DECLARE Mov_CapOrdinario        INT(11);
    DECLARE Mov_ComisionDisp        INT(11);
    DECLARE Mov_IvaComDisp          INT(11);
    DECLARE Con_OperacPOS           INT(11);
    DECLARE Des_ComDispo            VARCHAR(50);
    DECLARE Des_ComIVADispo         VARCHAR(50);

    DECLARE Origen_OperaEmi         CHAR(1);
    DECLARE Origen_OperaStats       CHAR(1);

    -- Asignacion de constantes
    SET Con_BloqPOS         := 2;           -- Consulta para obtener si se bloquea POS
    SET Con_CompraDiario    := 3;           -- Consulta para obtener el limite de monto diario para compra
    SET Con_DispoDiario     := 1;           -- Consulta para obtener el limite de monto diario para disposicion
    SET Con_CompraMes       := 4;           -- Consulta para obtener el limite de monto mensual para compra
    SET Con_DispoMes        := 2;           -- Consulta para obtener el limite de monto mensual para disposicion

    SET Cadena_Vacia        := '';          -- Cadena vacia
    SET Entero_Cero         := 0;           -- Entero cero
    SET Salida_NO           := 'N';         -- El Store NO genera una Salida
    SET Salida_SI           := 'S';         -- El Store SI genera una Salida
    SET Decimal_Cero        := 0.00;        -- DECIMAL cero

    SET Saldo_Cero          := 0;       -- Saldo cero
    SET CompraEnLineaSI     := 'S';         -- Compra en linea: SI
    SET Nat_Cargo           := 'C';         -- Naturaleza de movimiento: Cargo
    SET Mov_AhoCompra       := '17';        -- Tipo de Movimiento Ahorro: Compra Normal con Tarjeta

    SET Error_Key           := Entero_Cero; -- Numero de error: Cero

    SET BloqPOS_SI          := 'S';         -- Bloqueo POS: SI
    SET Entero_MenosUno     := -1;          -- Valor entero menos uno
    SET Fecha_Vacia         := '1900-01-01'; -- Fecha vacia
    SET ProActualiza        := 2;           -- Numero de actualizacion
    SET Est_Procesado       := 'P';         -- Estatus de la tarjeta: Procesado

    SET Var_Continuar       := Entero_Cero; -- Valor proceso continuar
    SET Est_Registrado      := 'R';         -- Estatus de Ristrado TARDEBBITACORAMOVS
    SET BloqueoSaldo        := 'B';         -- Bloqueo de Saldo
    SET TipBloqTarjeta      := 3;           -- Tipo Bloqueo :Tarjeta Credito

    SET Alta_Enc_Pol_SI     := 'S';
    SET Alta_Enc_Pol_NO     := 'N';
    SET Concepto_TarCred    := 1100;
    SET AltaPolCre_Si       := 'S';
    SET AltaMovLin_SI       := 'S';
    SET Con_CapVigente      := 1;
    SET Con_ComTarCred      := 70;
    SET Con_IVAComTarCred   := 71;
    SET Mov_CapOrdinario    := 1;
    SET Mov_ComisionDisp    := 53;
    SET Mov_IvaComDisp      := 54;
    SET Con_OperacPOS       := 2;               -- Concepto operacion: POS

    SET AltaPolLinCre_Si    := 'S';
    SET RegistraMov_NO      := 'N';
    SET Des_ComDispo        := 'COMISION POR DISPOSICION';
    SET Des_ComIVADispo     := 'IVA COMISION POR DISPOSICION';

    SET Origen_OperaStats   := 'T';
    SET Origen_OperaEmi     := 'E';
    SET Est_Vigente             := 'V';
    SET Con_TarjetaActiva       := 7;
    SET LongitudTarjeta         := 16;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_COMPRANORMALRPRO');
      END;

    -- Se obtiene la fecha actual
    SET Aud_FechaActual := NOW();

    -- Se obtiene la fecha del sistema
    SET Par_FechaAplicacion :=  (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    IF( Par_NumeroTarjeta = Cadena_Vacia ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1401;
        SET Par_ErrMen  := 'El Numero de la Tarjeta de Credito esta Vacio.';
        LEAVE ManejoErrores;
    END IF;

    IF( CHAR_LENGTH(Par_NumeroTarjeta) != LongitudTarjeta ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1402;
        SET Par_ErrMen  := 'El Numero de la Tarjeta de Credito esta Incorrecto.';
        LEAVE ManejoErrores;
    END IF;

    SELECT  TarjetaCredID,          Estatus,            LineaTarCredID
    INTO    Var_TarjetaCreditoID,   Var_EstatusTarjeta, Var_LineaCreditoID
    FROM TARJETACREDITO
    WHERE TarjetaCredID = Par_NumeroTarjeta;

    IF( IFNULL(Var_TarjetaCreditoID, Cadena_Vacia) = Cadena_Vacia ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1403;
        SET Par_ErrMen  := CONCAT('El Numero de Tarjeta de Credito no Existe: ',Par_NumeroTarjeta);
        LEAVE ManejoErrores;
    END IF;

    IF( IFNULL(Var_EstatusTarjeta, Entero_Cero) <> Con_TarjetaActiva ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1404;
        SET Par_ErrMen  := CONCAT('La Tarjeta de Credito: ',Par_NumeroTarjeta, ' No esta Activa');
        LEAVE ManejoErrores;
    END IF;

    IF( Var_LineaCreditoID = Entero_Cero ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1205;
        SET Par_ErrMen  := CONCAT('La Tarjeta de Credito: ',Par_NumeroTarjeta,' no cuenta con Linea de Credito.');
        LEAVE ManejoErrores;
    END IF;

    SELECT  Estatus
    INTO    Var_EstatusLinea
    FROM LINEATARJETACRED
    WHERE LineaTarCredID = Var_LineaCreditoID;

    IF( IFNULL(Var_EstatusLinea, Cadena_Vacia) != Est_Vigente ) THEN
        SET Par_CodigoRespuesta := "110";
        SET Par_NumErr  := 1206;
        SET Par_ErrMen  := CONCAT('La Linea de la Credito Asociada a la Tarjeta: ',Par_NumeroTarjeta,' no esta activa.');
        LEAVE ManejoErrores;
    END IF;


    IF (IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Par_CodigoRespuesta     := "410";
        SET Par_NumErr              := 1;
        SET Par_ErrMen              := 'Giro de Negocio Vacio';

        LEAVE ManejoErrores;
    END IF;

    IF(Par_OrigenOperacion IN(Origen_OperaEmi, Origen_OperaStats )) THEN

        SET Var_MontoTotal := CAST(Par_MontoTransaccion AS DECIMAL(12,2)) + CAST(Par_MontoComision AS DECIMAL(12,2));

        IF (IFNULL(Var_MontoTotal, Decimal_Cero ) = Decimal_Cero )THEN

            SET Par_CodigoRespuesta     := "110";
            SET Par_NumErr              := 106;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

    ELSE
        IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN

            SET Par_CodigoRespuesta     := "110";
            SET Par_NumErr              := 105;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

        IF (Par_MontoTransaccion = Decimal_Cero )THEN

            SET Par_CodigoRespuesta     := "110";
            SET Par_NumErr              := 106;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

        IF (Par_MontoComision >=  Par_MontoTransaccion) THEN

            SET Par_CodigoRespuesta     := "110";
            SET Par_NumErr              := 107;
            SET Par_ErrMen              := 'Monto de Comision Mayor o igual al Total';
            LEAVE ManejoErrores;

        END IF;
    END IF;

    SELECT LineaTarCredID, TipoTarjetaCredID,
      IFNULL(TC_FUNCIONLIMITEBLOQ(tar.TarjetaCredID,   tar.ClienteID,  tar.TipoTarjetaCredID, Con_BloqPOS), Cadena_Vacia),
      IFNULL(tar.MontoCompraDiario, Entero_MenosUno ),
      IFNULL(TC_FUNCIONLIMITEMONTO(tar.TarjetaCredID,   tar.ClienteID,  tar.TipoTarjetaCredID, Con_CompraDiario), Decimal_Cero),
      IFNULL(tar.MontoCompraMes, Decimal_Cero),
      IFNULL(TC_FUNCIONLIMITEMONTO(tar.TarjetaCredID,   tar.ClienteID,  tar.TipoTarjetaCredID, Con_CompraMes), Decimal_Cero) , ClienteID
      INTO Var_LineaCreditoID,      Var_TipoTarjetaDeb,    Var_BloqPOS,        Var_MontoCompraDiario, Var_LimiteCompraDiario,
      Var_MontoCompraMes, Var_LimiteCompraMes , Var_ClienteID
    FROM TARJETACREDITO tar
    WHERE tar.TarjetaCredID = Par_NumeroTarjeta;

    SET Val_Giro :=  (SELECT TC_FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    SET Var_TotalCompra := IFNULL(Par_MontoTransaccion,Entero_Cero) + IFNULL(Par_MontoComision,Entero_Cero) + IFNULL(Par_MontoIVAComision,Entero_Cero);

    IF ( Val_Giro = Entero_Cero ) THEN

        IF (Var_BloqPOS != BloqPOS_SI) THEN

            IF (Var_LimiteCompraDiario != Decimal_Cero) THEN
                IF ((Var_TotalCompra + Var_MontoCompraDiario) <= Var_LimiteCompraDiario) THEN
                    SET Var_MontoCompLibre = Var_LimiteCompraDiario - Var_MontoCompraDiario ;

                    IF (Var_TotalCompra <= Var_MontoCompLibre) THEN
                        SET Var_Continuar := Entero_Cero;
                    ELSE
                        SET Par_CodigoRespuesta     := "126";
                        SET Par_NumErr              := 101;
                        SET Par_ErrMen              := 'La Operacion excede el limite de Compra Diario';
                        LEAVE ManejoErrores;
                    END IF;
                ELSE
                    -- Ha excedido el limite de Compra Diario
                    SET Par_CodigoRespuesta   := "127";
                    SET Par_NumErr        := 102;
                    SET Par_ErrMen        := 'La Operacion excede limite de Compra Diario';
                    LEAVE ManejoErrores;
                END IF;
            END IF;

            -- Limites Compra Mensual
            IF (Var_LimiteCompraMes != Decimal_Cero) THEN
                IF ((Var_TotalCompra + Var_MontoCompraMes) <= Var_LimiteCompraMes) THEN

                    SET Var_MontoCompLibre := Var_LimiteCompraMes - Var_MontoCompraMes;

                    IF (Var_TotalCompra <= Var_MontoCompLibre) THEN
                        SET Var_Continuar := Entero_Cero;
                    ELSE

                        SET Par_CodigoRespuesta  := "128";
                        SET Par_NumErr          := 103;
                        SET Par_ErrMen          := 'La Operacion excede el limite de Compra Mensual';
                        LEAVE ManejoErrores;

                    END IF;
                ELSE

                    SET Par_CodigoRespuesta     := "129";
                    SET Par_NumErr              := 104;
                    SET Par_ErrMen              := 'La Operacion excede el limite de Compra Mensual';
                    LEAVE ManejoErrores;

                END IF;
            END IF;


            SET Var_LineaCreditoID := IFNULL(Var_LineaCreditoID, Entero_Cero);

            -- Inicalizacion
            SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
            SET Var_Referencia  := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
            SET Par_MontoComision := IFNULL(Par_MontoComision, Decimal_Cero);
            SET Par_MontoIVAComision := IFNULL(Par_MontoIVAComision, Decimal_Cero);
            SET Var_DesAhorro   := CONCAT("COMPRA ");

            -- Se  asigna el valor del saldo disponible actual antes de realizar la operacion
            --  Indicar si permite sobregirar el saldo
            SELECT IFNULL(MontoDisponible, Decimal_Cero), ProductoCredID
                    INTO Var_SaldoDisp, Var_ProductoCreditoID
                FROM LINEATARJETACRED
                WHERE LineaTarCredID = Var_LineaCreditoID;

            IF (Var_SaldoDisp <= Decimal_Cero ) THEN

                SET Par_CodigoRespuesta     := "116";
                SET Par_NumErr              := 108;
                SET Par_ErrMen              := 'No cuenta con credito disponible';
                LEAVE ManejoErrores;

            END IF;

            -- <<<< Permite Sobregrio -----------------------------------
                IF( Var_SaldoDisp < Var_TotalCompra ) THEN

                    SET Par_CodigoRespuesta     := "116";
                    SET Par_NumErr              := 108;
                    SET Par_ErrMen              := 'No cuenta con credito disponible';
                    LEAVE ManejoErrores;

                END IF;

                IF( Var_SaldoDisp - Var_TotalCompra < Entero_Cero) THEN

                    SET Par_CodigoRespuesta     := "116";
                    SET Par_NumErr              := 108;
                    SET Par_ErrMen              := 'No cuenta con credito disponible';
                    LEAVE ManejoErrores;

                END IF;
            -- >>>>>> Permite Sobregrio -----------------------------------


            CALL TARDEBTRANSACPRO(Var_NumTransaccion);

            IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN

                SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal );

                SELECT      Tipo AS Clasificacion,  '201' AS SubClasificacion
                    INTO    Var_Clasificacion,      Var_SubClasificacion
                FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Var_ProductoCreditoID;

                SELECT  SucursalOrigen
                    INTO Var_SucursalCte
                FROM CLIENTES WHERE ClienteID = Var_ClienteID;

                -- Si el parametro poliza diferente de cero se reasigna la el alta de poliza(Usado en Ajuste  de Compra)
                SET Var_Enc_Pol := Alta_Enc_Pol_SI;
                IF( Par_PolizaID > Entero_Cero ) THEN
                    SET Var_Enc_Pol := Alta_Enc_Pol_NO;
                    SET Var_Poliza  := Par_PolizaID;
                END IF;

                IF (Par_MontoTransaccion > Entero_Cero) THEN
                     /* ------->>> Registro de Movimiento en Linea y Conta */
                    -- Llamada Cargos
                    CALL TC_CONTALINEAPRO(
                        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoTransaccion,   Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Var_Enc_Pol,            Concepto_TarCred,
                        Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_CapVigente,         Mov_CapOrdinario,
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,           Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "116";
                        LEAVE ManejoErrores;
                    END IF;

                ELSE
                     -- Damos de Alta la Poliza
                    CALL TC_CONTALINEAPRO(
                        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoTransaccion,   Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Var_Enc_Pol,            Concepto_TarCred,
                        Var_Poliza,             RegistraMov_NO,         RegistraMov_NO,         RegistraMov_NO,         Con_CapVigente,
                        Mov_CapOrdinario,       Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,
                        Par_TipoOperacion,      Salida_NO,              Par_NumErr,             Par_ErrMen,             Var_Consecutivo,
                        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                        Aud_Sucursal,           Var_NumTransaccion
                    );

                     IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "116";
                        LEAVE ManejoErrores;
                    END IF;

                END IF;


                IF (Par_MontoComision > Entero_Cero) THEN
                    -- Llamada Comision

                    CALL TC_CONTALINEAPRO(
                        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoComision,      Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Des_ComDispo,           Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
                        Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_ComTarCred,         Mov_ComisionDisp,
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,			Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "116";
                        LEAVE ManejoErrores;
                    END IF;
                END IF;

                IF (Par_MontoIVAComision > Entero_Cero) THEN
                    -- Llamda IVA Comision

                    CALL TC_CONTALINEAPRO(
                        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoIVAComision,   Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                        Var_SucursalCte,        Des_ComIVADispo,        Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
                        Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_IVAComTarCred,      Mov_IvaComDisp,
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,			Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,
                        Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "116";
                        LEAVE ManejoErrores;
                    END IF;

                END IF;

                -- Llamada a cuentas de Orden
                CALL TC_CONTALINEAPRO(
                    Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                    Var_TotalCompra,        Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                    Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
                    Var_Poliza,             RegistraMov_NO,         AltaPolLinCre_Si,       RegistraMov_NO,         Entero_Cero,        Entero_Cero,
                    Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,			Par_TipoOperacion,
                    Salida_NO,              Par_NumErr,             Par_ErrMen,
                    Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

                IF Par_NumErr != Entero_Cero THEN
                    SET Par_CodigoRespuesta     := "116";
                    LEAVE ManejoErrores;
                END IF;

                -- Poliza de Tarjeta - Transacciones POS
                CALL POLIZATARJETAPRO(
                    Var_Poliza,         Par_EmpresaID,      Par_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                    Con_OperacPOS,      Par_MonedaID,       Entero_Cero,                Var_TotalCompra,        Var_DesAhorro,
                    Par_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                    Var_NumTransaccion);

                IF Par_NumErr != Entero_Cero THEN
                    SET Par_CodigoRespuesta     := "116";
                    LEAVE ManejoErrores;
                END IF;

                /* <<<------ Registro de Movimiento en Linea y Conta */


                -- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
                UPDATE TARJETACREDITO SET
                    NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero) + 1,
                    NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero) + 1,
                    MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) + Var_TotalCompra,
                    MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero) + Var_TotalCompra
                    WHERE TarjetaCredID  =   Par_NumeroTarjeta;

                UPDATE TC_BITACORAMOVS SET
                        NumTransaccion  = Var_NumTransaccion,
                        Estatus         = Est_Procesado
                WHERE TipoOperacionID   = Par_TipoOperacion
                  AND TarjetaCredID     = Par_NumeroTarjeta
                  AND Referencia        = Par_Referencia
                  AND TarCredMovID      = Var_TarCredMovID
                  AND Estatus = Est_Registrado;


                SELECT IFNULL(MontoDisponible,Decimal_Cero), IFNULL((MontoDisponible + MontoBloqueado), Decimal_Cero)
                        INTO Var_SaldoDispoAct, Var_SaldoContable
                    FROM LINEATARJETACRED
                    WHERE LineaTarCredID = Var_LineaCreditoID;


                SET Par_NumeroTransaccion   := Var_NumTransaccion;
                SET Par_SaldoContableAct    := Var_SaldoContable;
                SET Par_SaldoDisponibleAct  := Var_SaldoDispoAct;
                SET Par_CodigoRespuesta     := "000";
                SET Par_FechaAplicacion     := Par_FechaAplicacion;

                SET Par_NumErr := 0;
                SET Par_ErrMen := 'Compra Realizada Exitosamente';
                LEAVE ManejoErrores;

            ELSE

                SET Par_CodigoRespuesta     := "116";
                SET Par_NumErr              := 110;
                SET Par_ErrMen              := 'No puede realizar compras POS';
                LEAVE ManejoErrores;

            END IF;


        ELSE

            SET Par_CodigoRespuesta     := "415";
            SET Par_NumErr              := 110;
            SET Par_ErrMen              := 'Tarjeta Bloqueada para Compra POS';
            LEAVE ManejoErrores;

        END IF;



    ELSE
        SET Par_CodigoRespuesta     := "415";
        SET Par_NumErr              := 110;
        SET Par_ErrMen              := 'Giro No permitido';
        LEAVE ManejoErrores;

    END IF;


END ManejoErrores;

IF Par_NumErr != Entero_Cero THEN
    SET Par_NumeroTransaccion       := Entero_Cero;
    SET Par_SaldoContableAct        := Saldo_Cero;
    SET Par_SaldoDisponibleAct      := Saldo_Cero;
    SET Par_CodigoRespuesta         := Par_CodigoRespuesta;
    SET Par_FechaAplicacion         := Par_FechaAplicacion;
END IF;

IF Par_Salida = Salida_SI THEN
    SELECT Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;

END IF;


END TerminaStore$$
