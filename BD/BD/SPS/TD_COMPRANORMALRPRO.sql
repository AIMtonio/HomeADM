DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_COMPRANORMALRPRO`;
DELIMITER $$

CREATE PROCEDURE `TD_COMPRANORMALRPRO`(
-- ---------------------------------------------------------------------------------
-- SP QUE REALIZA LAS VALIDACIONES COMPRA NORMAL CON TD
-- ---------------------------------------------------------------------------------
    Par_TipoOperacion               CHAR(2),        --  Tipo de Operacion de Tarjeta
    Par_NumeroTarjeta               CHAR(16),       --  Numero de Tarjeta de Débito
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
    INOUT Par_SaldoContableAct      DECIMAL(16,2),  --  Respuesta: Saldo disponible de la Cuenta

    INOUT Par_SaldoDisponibleAct    DECIMAL(16,2),  --  Respuesta: Saldo disponible,  + saldo bloqueado + saldo a favor
    INOUT Par_CodigoRespuesta       VARCHAR(3),     --  Respuesta: Codigo de Respuesta PROSA
    INOUT Par_FechaAplicacion       DATE,           --  Fecha de Aplicacion de la operacion
    Var_TarDebMovID                 INT(11),        --  Numero de movimiento
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

    
    DECLARE Var_CuentaAhoID         BIGINT(12);         
    DECLARE Var_ClienteID           INT(11);            
    DECLARE Var_Referencia          VARCHAR(50);        
    DECLARE Var_DesAhorro           VARCHAR(150);       
    DECLARE Var_SaldoDisp           DECIMAL(12,2);      

    DECLARE Var_SaldoDispoAct       DECIMAL(12,2);      
    DECLARE Var_SaldoContable       DECIMAL(12,2);      
    DECLARE Var_TipoTarjetaDeb      INT(11);            
    DECLARE Val_Giro                CHAR(4);            
    DECLARE Var_BloqueID            INT(11);            

    DECLARE Var_BloqPOS             VARCHAR(5);         
    DECLARE Var_MontoCompLibre      DECIMAL(12,2);      
    DECLARE Var_MontoCompraMes      DECIMAL(12,2);      
    DECLARE Var_LimiteCompraMes     DECIMAL(12,2);      
    DECLARE Var_Saldo               DECIMAL(12,2);      

    DECLARE Var_SaldoDispon         DECIMAL(12,2);      
    DECLARE Var_NumTransaccion      BIGINT(20);         
    DECLARE Var_TotalCompra         DECIMAL(16,2);      

    DECLARE Var_ProductoDebID       INT(11);
    DECLARE Var_Clasificacion       CHAR(1);
    DECLARE Var_SubClasificacion    INT(11);
    DECLARE Var_SucursalCte         INT(11);
    DECLARE Var_Poliza              BIGINT(20);
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_MontoTotal          DECIMAL(12,2);
    DECLARE Var_Enc_Pol             CHAR(1);            
    DECLARE Var_EstatusCta          CHAR(1);            
    DECLARE Est_Activa              CHAR(1);            
    DECLARE Var_EstatusTarjeta      INT(11);            
    DECLARE Con_TarjetaActiva       INT(11);            
    DECLARE Var_TarjetaDebID        CHAR(16);           
    DECLARE LongitudTarjeta         INT(11);            

    
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

    DECLARE Alta_Enc_Pol_NO         CHAR(1);
    DECLARE Concepto_TarDeb         INT(11);
    DECLARE AltaPolAho_Si           CHAR(1);
    DECLARE AltaMov_SI              CHAR(1);
    DECLARE RegistraMov_NO          CHAR(1);

    DECLARE Con_CapVigente          INT(11);
    DECLARE Con_ComTarDeb           INT(11);
    DECLARE Con_IVAComTarDeb        INT(11);
    DECLARE Mov_CapOrdinario        INT(11);
    DECLARE Var_TipoMovAho          INT(11);
    DECLARE Mov_ComisionDisp        INT(11);
    DECLARE Mov_IvaComDisp          INT(11);
    DECLARE Con_OperacPOS           INT(11);
    DECLARE Des_ComDispo            VARCHAR(50);
    DECLARE Des_ComIVADispo         VARCHAR(50);
    DECLARE Con_ConceptoCon         INT(11);
    DECLARE AltaPolizaAhorroSI      CHAR(1);
    DECLARE ConceptoAhoPas          INT(11);    -- Movimento contable pasivo

    DECLARE Origen_OperaEmi         CHAR(1);
    DECLARE Origen_OperaStats       CHAR(1);
    DECLARE Var_TipoMovAhoID        CHAR(4);
    DECLARE ConConta_TarDeb         INT(11);

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

    SET Saldo_Cero          := 0;           -- Saldo cero
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
    SET TipBloqTarjeta      := 3;           -- Tipo Bloqueo :Tarjeta Debito

    SET Var_Enc_Pol         := 'S';
    SET Alta_Enc_Pol_NO     := 'N';
    SET Concepto_TarDeb     := 1100;
    SET AltaPolAho_Si       := 'S';
    SET AltaMov_SI          := 'S';
    SET Con_CapVigente      := 1;
    SET Con_ComTarDeb       := 70;
    SET Con_IVAComTarDeb    := 71;
    SET Mov_CapOrdinario    := 1;
    SET Var_TipoMovAho      := 105;             -- COMPRA CON TDD: CHECKOUT - TIPOSMOVSAHO
    SET Mov_ComisionDisp    := 53;
    SET Mov_IvaComDisp      := 54;
    SET Con_OperacPOS       := 2;               -- Concepto operacion: POS
    SET Con_ConceptoCon     := 300;             -- movimientos con tarjeta debito
    SET AltaPolizaAhorroSI  := 'S';             -- Indica si requiere alta de la poliza ahorro
    SET ConceptoAhoPas      := 1;               -- Movimento contable pasivo
    
    SET RegistraMov_NO      := 'N';
    SET Des_ComDispo        := 'COMISION POR DISPOSICION';
    SET Des_ComIVADispo     := 'IVA COMISION POR DISPOSICION';

    SET Origen_OperaStats   := 'T';
    SET Origen_OperaEmi     := 'E';
    SET Est_Activa             := 'A';
    SET Con_TarjetaActiva       := 7;
    SET LongitudTarjeta         := 16;
    SET ConConta_TarDeb         := 300;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
		SET Par_CodigoRespuesta := "12";
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TD_COMPRANORMALRPRO');
      END;

    -- Se obtiene la fecha actual
    SET Aud_FechaActual := NOW();

    -- Se obtiene la fecha del sistema
    SET Par_FechaAplicacion :=  (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

    IF( Par_NumeroTarjeta = Cadena_Vacia ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1401;
        SET Par_ErrMen  := 'El Numero de la Tarjeta de Debito esta Vacio.';
        LEAVE ManejoErrores;
    END IF;

    IF( CHAR_LENGTH(Par_NumeroTarjeta) != LongitudTarjeta ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1402;
        SET Par_ErrMen  := 'El Numero de la Tarjeta de Debito esta Incorrecto.';
        LEAVE ManejoErrores;
    END IF;

    SELECT TarjetaDebID,        Estatus,            CuentaAhoID
    INTO    Var_TarjetaDebID,   Var_EstatusTarjeta, Var_CuentaAhoID
    FROM TARJETADEBITO 
        WHERE TarjetaDebID = Par_NumeroTarjeta;

    IF( IFNULL(Var_TarjetaDebID, Cadena_Vacia) = Cadena_Vacia ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1403;
        SET Par_ErrMen  := CONCAT('El Numero de Tarjeta de Debito no Existe: ',Par_NumeroTarjeta);
        LEAVE ManejoErrores;
    END IF;

    IF( IFNULL(Var_EstatusTarjeta, Entero_Cero) <> Con_TarjetaActiva ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1404;
        SET Par_ErrMen  := CONCAT('La Tarjeta de Debito: ',Par_NumeroTarjeta, ' No esta Activa');
        LEAVE ManejoErrores;
    END IF;

    IF( Var_CuentaAhoID = Entero_Cero ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1205;
        SET Par_ErrMen  := CONCAT('La Tarjeta de Debito: ',Par_NumeroTarjeta,' no esta relacionado con una cuenta de ahorro.');
        LEAVE ManejoErrores;
    END IF;

    SELECT Estatus
    INTO    Var_EstatusCta
    FROM CUENTASAHO
        WHERE CuentaAhoID = Var_CuentaAhoID;

    IF( IFNULL(Var_EstatusCta, Cadena_Vacia) != Est_Activa ) THEN
        SET Par_CodigoRespuesta := "14";
        SET Par_NumErr  := 1206;
        SET Par_ErrMen  := CONCAT('La Cuenta de Ahorro Asociada a la Tarjeta: ',Par_NumeroTarjeta,' no esta activa.');
        LEAVE ManejoErrores;
    END IF;


    IF (IFNULL(Par_GiroNegocio, Cadena_Vacia) = Cadena_Vacia) THEN
        SET Par_CodigoRespuesta     := "12";
        SET Par_NumErr              := 1;
        SET Par_ErrMen              := 'Giro de Negocio Vacio';

        LEAVE ManejoErrores;
    END IF;

    IF(Par_OrigenOperacion IN(Origen_OperaEmi, Origen_OperaStats )) THEN

        SET Var_MontoTotal := CAST(Par_MontoTransaccion AS DECIMAL(12,2)) + CAST(Par_MontoComision AS DECIMAL(12,2));

        IF (IFNULL(Var_MontoTotal, Decimal_Cero ) = Decimal_Cero )THEN

            SET Par_CodigoRespuesta     := "13";
            SET Par_NumErr              := 106;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

    ELSE
        IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN

            SET Par_CodigoRespuesta     := "13";
            SET Par_NumErr              := 105;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

        IF (Par_MontoTransaccion = Decimal_Cero )THEN

            SET Par_CodigoRespuesta     := "13";
            SET Par_NumErr              := 106;
            SET Par_ErrMen              := 'Monto de Transaccion Vacio';
            LEAVE ManejoErrores;

        END IF;

        IF (Par_MontoComision >=  Par_MontoTransaccion) THEN

            SET Par_CodigoRespuesta     := "13";
            SET Par_NumErr              := 107;
            SET Par_ErrMen              := 'Monto de Comision Mayor o igual al Total';
            LEAVE ManejoErrores;

        END IF;
    END IF;

    SELECT CuentaAhoID, TipoTarjetaDebID,
      IFNULL(TD_FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS), Cadena_Vacia),
      IFNULL(tar.MontoCompraDiario, Entero_MenosUno ),
      IFNULL(TD_FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario), Decimal_Cero),
      IFNULL(tar.MontoCompraMes, Decimal_Cero),
      IFNULL(TD_FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes), Decimal_Cero) , ClienteID
      INTO Var_CuentaAhoID,        Var_TipoTarjetaDeb,    Var_BloqPOS,        Var_MontoCompraDiario, Var_LimiteCompraDiario,
      Var_MontoCompraMes,       Var_LimiteCompraMes,    Var_ClienteID
    FROM TARJETADEBITO tar 
    WHERE tar.TarjetaDebID = Par_NumeroTarjeta;

    SET Val_Giro :=  (SELECT TD_FUNCIONGIRO (Par_NumeroTarjeta, Var_ClienteID, Var_TipoTarjetaDeb, Par_GiroNegocio));

    SET Var_TotalCompra := IFNULL(Par_MontoTransaccion,Entero_Cero) + IFNULL(Par_MontoComision,Entero_Cero) + IFNULL(Par_MontoIVAComision,Entero_Cero);

    IF ( Val_Giro = Entero_Cero ) THEN

        IF (Var_BloqPOS != BloqPOS_SI) THEN

            IF (Var_LimiteCompraDiario != Decimal_Cero) THEN
                IF ((Var_TotalCompra + Var_MontoCompraDiario) <= Var_LimiteCompraDiario) THEN
                    SET Var_MontoCompLibre = Var_LimiteCompraDiario - Var_MontoCompraDiario ;

                    IF (Var_TotalCompra <= Var_MontoCompLibre) THEN
                        SET Var_Continuar := Entero_Cero;
                    ELSE
                        SET Par_CodigoRespuesta     := "61";
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

                        SET Par_CodigoRespuesta  := "65";
                        SET Par_NumErr          := 103;
                        SET Par_ErrMen          := 'La Operacion excede el limite de Compra Mensual';
                        LEAVE ManejoErrores;

                    END IF;
                ELSE

                    SET Par_CodigoRespuesta     := "65";
                    SET Par_NumErr              := 104;
                    SET Par_ErrMen              := 'La Operacion excede el limite de Compra Mensual';
                    LEAVE ManejoErrores;

                END IF;
            END IF;


            SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);

            -- Inicalizacion
            SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
            SET Var_Referencia  := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
            SET Par_MontoComision := IFNULL(Par_MontoComision, Decimal_Cero);
            SET Par_MontoIVAComision := IFNULL(Par_MontoIVAComision, Decimal_Cero);
            SET Var_DesAhorro   := CONCAT("COMPRA ");

            -- Se  asigna el valor del saldo disponible actual antes de realizar la operacion
            SELECT SaldoDispon
            INTO Var_SaldoDisp
            FROM CUENTASAHO
                WHERE CuentaAhoID = Var_CuentaAhoID;

            SET Var_SaldoDisp := IFNULL(Var_SaldoDisp,Decimal_Cero);

            IF (Var_SaldoDisp <= Decimal_Cero ) THEN

                SET Par_CodigoRespuesta     := "51";
                SET Par_NumErr              := 108;
                SET Par_ErrMen              := 'No cuenta con saldo disponible';
                LEAVE ManejoErrores;

            END IF;

			IF( (Var_SaldoDisp - Var_TotalCompra) < Decimal_Cero ) THEN
				SET Par_NumErr	:= 108;
				SET Par_ErrMen	:= 'El Monto de la Operacion Excede el Disponible de la Tarjeta.';
				SET Par_CodigoRespuesta     := "51";
				LEAVE ManejoErrores;
			END IF;
            
            SET Var_Consecutivo := Entero_Cero;
            CALL TARDEBTRANSACPRO(Var_NumTransaccion);

            IF (Par_CompraPOSLinea = CompraEnLineaSI) THEN

                SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal );

                SELECT  SucursalOrigen
                    INTO Var_SucursalCte
                FROM CLIENTES 
                    WHERE ClienteID = Var_ClienteID;

                -- Si el parametro poliza diferente de cero se reasigna la el alta de poliza(Usado en Ajuste  de Compra)
                SET Var_Enc_Pol := Var_Enc_Pol;
                IF( Par_PolizaID > Entero_Cero ) THEN
                    SET Var_Enc_Pol := Alta_Enc_Pol_NO;
                    SET Var_Poliza  := Par_PolizaID;
                END IF;

                IF (Par_MontoTransaccion > Entero_Cero) THEN
                     /* ------->>> Registro de Movimiento en Cuenta y Conta */

                    -- Llamada Cargos
                    -- Procesos contables de cuentas de ahorro
                    CALL TD_CONTACTAAHORROPRO (
                        Var_CuentaAhoID,        Par_NumeroTarjeta,     Var_ClienteID,           DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoTransaccion,   Par_MonedaID,          Var_DesAhorro,           Var_Referencia,         Var_Enc_Pol,
                        ConConta_TarDeb,        Var_Poliza,            AltaPolAho_Si,           AltaMov_SI,          Mov_AhoCompra,
                        Nat_Cargo,              Par_NumAutorizacion,   RegistraMov_NO,          Cadena_Vacia,           Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,         Par_ErrMen,                 Var_Consecutivo,        Par_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                        Aud_NumTransaccion);

                    IF (Par_NumErr <> Entero_Cero) THEN
                        SET Par_CodigoRespuesta := "12";
                        LEAVE ManejoErrores;
                    END IF;

                    

                ELSE
                     -- Damos de Alta la Poliza para la cuenta contable
                    CALL TD_CONTACTAAHORROPRO (
                        Var_CuentaAhoID,        Par_NumeroTarjeta,      Var_ClienteID,       DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoTransaccion,   Par_MonedaID,           Var_DesAhorro,       Var_Referencia,         Var_Enc_Pol,
                        ConConta_TarDeb,        Var_Poliza,             RegistraMov_NO,      RegistraMov_NO,         Var_TipoMovAho,         
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,      Cadena_Vacia,           Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,          Var_Consecutivo,        Par_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,     Aud_ProgramaID,         Aud_Sucursal,
                        Aud_NumTransaccion);

                     IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "12";
                        LEAVE ManejoErrores;
                    END IF;

                END IF;


                IF (Par_MontoComision > Entero_Cero) THEN
                    -- Llamada Comision
                    CALL TD_CONTACTAAHORROPRO (
                        Var_CuentaAhoID,        Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoComision,      Par_MonedaID,           Var_DesAhorro,          Var_Referencia,         Var_Enc_Pol,
                        ConConta_TarDeb,        Var_Poliza,             AltaPolAho_Si,          AltaMov_SI,             Mov_AhoCompra,          
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,           Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,             Var_Consecutivo,        Par_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
                        Aud_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "12";
                        LEAVE ManejoErrores;
                    END IF;
                END IF;

                IF (Par_MontoIVAComision > Entero_Cero) THEN
                    -- Llamda IVA Comision
                    CALL TD_CONTACTAAHORROPRO (
                        Var_CuentaAhoID,        Par_NumeroTarjeta,      Var_ClienteID,      DATE(Par_FechaActual),  Par_FechaAplicacion,
                        Par_MontoIVAComision,   Par_MonedaID,           Var_DesAhorro,      Var_Referencia,         Var_Enc_Pol,
                        ConConta_TarDeb,        Var_Poliza,             AltaPolAho_Si,      AltaMov_SI,             Mov_AhoCompra,          
                        Nat_Cargo,              Par_NumAutorizacion,    RegistraMov_NO,     Cadena_Vacia,           Par_TipoOperacion,
                        Salida_NO,              Par_NumErr,             Par_ErrMen,         Var_Consecutivo,        Par_EmpresaID,
                        Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                        Aud_NumTransaccion);

                    IF Par_NumErr != Entero_Cero THEN
                        SET Par_CodigoRespuesta     := "12";
                        LEAVE ManejoErrores;
                    END IF;

                END IF;

                IF Par_NumErr != Entero_Cero THEN
                    SET Par_CodigoRespuesta     := "12";
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
                    SET Par_CodigoRespuesta     := "12";
                    LEAVE ManejoErrores;
                END IF;

                -- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
                UPDATE TARJETADEBITO SET
                    NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero) + 1,
                    NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero) + 1,
                    MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) + Var_TotalCompra,
                    MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero) + Var_TotalCompra
                    WHERE TarjetaDebID  =   Par_NumeroTarjeta;

                UPDATE TARDEBBITACORAMOVS SET
                        NumTransaccion  = Var_NumTransaccion,
                        Estatus         = Est_Procesado
                WHERE TipoOperacionID   = Par_TipoOperacion
                  AND TarjetaDebID      = Par_NumeroTarjeta
                  AND Referencia        = Par_Referencia
                  AND TarDebMovID       = Var_TarDebMovID
                  AND Estatus = Est_Registrado;

                SELECT  IFNULL(SaldoDispon, Decimal_Cero), IFNULL((SaldoDispon + SaldoBloq), Decimal_Cero)
                INTO Var_SaldoDispoAct, Var_SaldoContable  
                FROM CUENTASAHO
                WHERE CuentaAhoID = Var_CuentaAhoID;

                SET Par_NumeroTransaccion   := Var_NumTransaccion;
                SET Par_SaldoContableAct    := Var_SaldoContable;
                SET Par_SaldoDisponibleAct  := Var_SaldoDispoAct;
                SET Par_CodigoRespuesta     := "000";
                SET Par_FechaAplicacion     := Par_FechaAplicacion;

                SET Par_NumErr := 0;
                SET Par_ErrMen := 'Compra Realizada Exitosamente';
                LEAVE ManejoErrores;

            ELSE

                SET Par_CodigoRespuesta     := "12";
                SET Par_NumErr              := 110;
                SET Par_ErrMen              := 'No puede realizar compras POS';
                LEAVE ManejoErrores;

            END IF;

        ELSE

            SET Par_CodigoRespuesta     := "62";
            SET Par_NumErr              := 110;
            SET Par_ErrMen              := 'Tarjeta Bloqueada para Compra POS';
            LEAVE ManejoErrores;

        END IF;

    ELSE
        SET Par_CodigoRespuesta     := "12";
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