-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_REVCOMPRANORMALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_REVCOMPRANORMALPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_REVCOMPRANORMALPRO`(
-- ---------------------------------------------------------------------------------
-- SP QUE REALIZA LAS VALIDACIONES PARA PROCESOS DE REVERSA DE COMPRA NORMAL
-- ---------------------------------------------------------------------------------
    Par_NumeroTarjeta               CHAR(16),       --  Numero de Tarjeta de Credito
    Par_Referencia                  VARCHAR(25),    --  Referencia
    Par_MontoTransaccion            DECIMAL(12,2),  --  Monto en pesos de la transaccion
    Par_MontoComision               DECIMAL(12,2),  --  Monto de Comision
    Par_MontoIVAComision            DECIMAL(12,2),  --  Monto de IVA de Comision

    Par_NumAutorizacion             BIGINT,         --  Numero de autorizacion PROSA
    Par_FechaActual                 DATETIME,       --  Fecha actual de la operacion
    Par_NomUbicTerminal             VARCHAR(150),   --  Nombre de la terminal
    Par_MonedaID                    INT(11),

    INOUT Par_NumeroTransaccion     BIGINT,         --  Respuesta: Numero de Transaccion
    INOUT Par_SaldoContableAct      DECIMAL(16,2),  --  Respuesta: Saldo disponible de la linea
    INOUT Par_SaldoDisponibleAct    DECIMAL(16,2),  --  Respuesta: Saldo disponible,  + saldo bloqueado + saldo a favor

    INOUT Par_CodigoRespuesta       VARCHAR(3),     --  Respuesta: Codigo de Respuesta PROSA
    INOUT Par_FechaAplicacion       DATE,           --  Fecha de Aplicacion de la operacion
    Var_TarCredMovID                INT(11),        --  Numero de movimiento
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
    DECLARE Var_SaldoDispoAct       DECIMAL(12,2);      -- Valor del saldo disponible actual

    DECLARE Var_SaldoContable       DECIMAL(12,2);      -- Valor del saldo contable de la cuenta
    DECLARE Var_TipoTarjetaCred      INT(11);           -- Valor del tipo de tarjeta
    DECLARE Var_NumTransaccion      BIGINT(20);         -- Se obtiene el numero de transaccion
    DECLARE Var_TotalCompra         DECIMAL(16,2);      -- Monto total de compra
    DECLARE Var_ProductoCreditoID   INT;                -- Producto de credito

    DECLARE Var_Clasificacion       CHAR(1);            -- Clasificacion de credito
    DECLARE Var_SubClasificacion    INT(11);            -- Subclasificacion de Credito
    DECLARE Var_SucursalCte         INT(11);            -- Sucursal del cliente
    DECLARE Var_Poliza              BIGINT;             -- Numero de Poliza
    DECLARE Var_Consecutivo         INT(11);            -- Consecutivo

    -- Declaracion de constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Entero_Cero             INT(11);
    DECLARE Salida_NO               CHAR(1);
    DECLARE Salida_SI               CHAR(1);
    DECLARE Decimal_Cero            DECIMAL(12,2);

    DECLARE Nat_Abono               CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Saldo_Cero              DECIMAL(16,2);
    DECLARE Est_Procesado           CHAR(1);
    DECLARE Est_Registrado          CHAR(1);

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
    DECLARE Clas_TarjetaCred        INT;
	DECLARE TipoOperaTarjeta		VARCHAR(2);
    -- Asignacion de constantes

    SET Cadena_Vacia        := '';          -- Cadena vacia
    SET Entero_Cero         := 0;           -- Entero cero
    SET Salida_NO           := 'N';         -- El Store NO genera una Salida
    SET Salida_SI           := 'S';         -- El Store SI genera una Salida
    SET Decimal_Cero        := 0.00;        -- DECIMAL cero

    SET Saldo_Cero          := 0;           -- Saldo cero
    SET Nat_Abono           := 'A';         -- Naturaleza de movimiento: Cargo


    SET Fecha_Vacia         := '1900-01-01';    -- Fecha vacia
    SET Est_Procesado       := 'P';             -- Estatus de la tarjeta: Procesado

    SET Est_Registrado      := 'R';             -- Estatus de Ristrado TARDEBBITACORAMOVS

    SET Alta_Enc_Pol_SI     := 'S';
    SET Alta_Enc_Pol_NO     := 'N';
    SET Concepto_TarCred    := 1100;            -- Concepto contable de tarjetas
    SET AltaPolCre_Si       := 'S';
    SET AltaMovLin_SI       := 'S';
    SET Con_CapVigente      := 1;               -- Concepto capital vigente
    SET Con_ComTarCred      := 70;              -- Comision de tarjeta
    SET Con_IVAComTarCred   := 71;              -- IVA de comision
    SET Mov_CapOrdinario    := 1;               -- Movimiento de capital ordinario
    SET Mov_ComisionDisp    := 53;              -- Comision por disposicion
    SET Mov_IvaComDisp      := 54;              -- IVA de Comision
    SET Con_OperacPOS       := 2;               -- Concepto operacion: POS

    SET AltaPolLinCre_Si    := 'S';
    SET RegistraMov_NO      := 'N';
    SET Des_ComDispo        := 'REVERSA COMISION POR DISPOSICION';
    SET Des_ComIVADispo     := 'REVERSA IVA COMISION POR DISPOSICION';
    SET Clas_TarjetaCred    := 201;             -- Tarjeta de credito
	
	SET TipoOperaTarjeta    := '19';
	
ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_REVCOMPRANORMALPRO');
      END;

    -- Se obtiene la fecha actual
    SET Aud_FechaActual := NOW();

    -- Se obtiene la fecha del sistema
    SET Par_FechaAplicacion :=  (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);



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

    SELECT LineaTarCredID,          TipoTarjetaCredID,      ClienteID
      INTO Var_LineaCreditoID,      Var_TipoTarjetaCred,    Var_ClienteID
    FROM TARJETACREDITO tar
    WHERE tar.TarjetaCredID = Par_NumeroTarjeta;

    SET Var_TotalCompra := IFNULL(Par_MontoTransaccion,Entero_Cero) + IFNULL(Par_MontoComision,Entero_Cero) + IFNULL(Par_MontoIVAComision,Entero_Cero);

    SET Var_LineaCreditoID := IFNULL(Var_LineaCreditoID, Entero_Cero);
    SELECT  ProductoCredID
        INTO  Var_ProductoCreditoID
    FROM LINEATARJETACRED
    WHERE LineaTarCredID = Var_LineaCreditoID;

    -- Inicalizacion
    SET Var_ClienteID           := IFNULL(Var_ClienteID, Entero_Cero);
    SET Var_Referencia          := CONCAT("TAR **** ", SUBSTRING(Par_NumeroTarjeta,13, 4));
    SET Par_MontoComision       := IFNULL(Par_MontoComision, Decimal_Cero);
    SET Par_MontoIVAComision    := IFNULL(Par_MontoIVAComision, Decimal_Cero);
    SET Var_DesAhorro           := CONCAT("REVERSA COMPRA ");


    CALL TARDEBTRANSACPRO(Var_NumTransaccion);

    SET Var_DesAhorro=CONCAT(Var_DesAhorro,' ',Par_NomUbicTerminal );

    SELECT      Tipo AS Clasificacion,  Clas_TarjetaCred AS SubClasificacion
        INTO    Var_Clasificacion,      Var_SubClasificacion
    FROM PRODUCTOSCREDITO
    WHERE ProducCreditoID = Var_ProductoCreditoID;

    SELECT  SucursalOrigen
        INTO Var_SucursalCte
    FROM CLIENTES WHERE ClienteID = Var_ClienteID;

    /* ------->>> Registro de Movimiento en Linea y Conta */
    -- Llamada Abono
    CALL TC_CONTALINEAPRO(
        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
        Par_MontoTransaccion,   Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
        Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Alta_Enc_Pol_SI,        Concepto_TarCred,
        Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_CapVigente,
        Mov_CapOrdinario,       Nat_Abono,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,
        TipoOperaTarjeta,
        Salida_NO,              Par_NumErr,             Par_ErrMen,
        Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

    IF Par_NumErr != Entero_Cero THEN
        SET Par_CodigoRespuesta     := "116";
        LEAVE ManejoErrores;
    END IF;

        IF Par_MontoComision > Entero_Cero THEN
            -- Reversa Llamada Comision

            CALL TC_CONTALINEAPRO(
                Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                Par_MontoComision,      Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Des_ComDispo,           Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
                Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_ComTarCred,
                Mov_ComisionDisp,       Nat_Abono,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,
                TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

            -- Reversa Llamada IVA Comision

            CALL TC_CONTALINEAPRO(
                Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
                Par_MontoIVAComision,   Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Des_ComIVADispo,        Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
                Var_Poliza,             AltaPolCre_Si,          RegistraMov_NO,         AltaMovLin_SI,          Con_IVAComTarCred,
                Mov_IvaComDisp,         Nat_Abono,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,
                TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

        END IF;

    -- Reversa a cuentas de Orden
    CALL TC_CONTALINEAPRO(
        Var_LineaCreditoID,     Par_NumeroTarjeta,      Var_ClienteID,          DATE(Par_FechaActual),  Par_FechaAplicacion,
        Var_TotalCompra,        Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
        Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
        Var_Poliza,             RegistraMov_NO,         AltaPolLinCre_Si,       RegistraMov_NO,         Entero_Cero,
        Entero_Cero,            Nat_Abono,              Par_NumAutorizacion,    RegistraMov_NO,         Cadena_Vacia,
        TipoOperaTarjeta,
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
    Con_OperacPOS,      Par_MonedaID,       Var_TotalCompra,            Entero_Cero,            Var_DesAhorro,
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
        NoCompraDiario      =   IFNULL(NoCompraDiario,Entero_Cero) - 1,
        NoCompraMes         =   IFNULL(NoCompraMes, Entero_Cero) - 1,
        MontoCompraDiario   =   IFNULL(MontoCompraDiario, Decimal_Cero) - Var_TotalCompra,
        MontoCompraMes      =   IFNULL(MontoCompraMes, Decimal_Cero) - Var_TotalCompra
        WHERE TarjetaCredID  =   Par_NumeroTarjeta;

    UPDATE TC_BITACORAMOVS SET
            NumTransaccion  = Var_NumTransaccion,
            Estatus         = Est_Procesado
    WHERE TarjetaCredID     = Par_NumeroTarjeta
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
    SET Par_ErrMen := 'Reversa de Compra Realizada Exitosamente';


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
