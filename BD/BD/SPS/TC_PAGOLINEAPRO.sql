-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PAGOLINEAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS TC_PAGOLINEAPRO;

DELIMITER $$
CREATE PROCEDURE `TC_PAGOLINEAPRO`(
-- ---------------------------------------------------------------------------------
-- SP QUE REALIZA EL PAGO DEL ADEUDO DE LA LINEA DE CREDITO
-- ---------------------------------------------------------------------------------
    Par_NumeroTarjeta               CHAR(16),       --  Numero de Tarjeta de Credito
    Par_CuentaClabe                 CHAR(18),       --  Numero de Cuenta Clabe de la Tarjeta de Credito
    Par_Referencia                  VARCHAR(25),    --  Referencia
    Par_MontoTransaccion            DECIMAL(12,2),  --  Monto en pesos de la transaccion

    Par_MonedaID                    INT(11),        --  Codigo de Moneda
    Par_NumTransaccion              VARCHAR(10),    --  Numero de Transaccion
    Par_FechaActual                 VARCHAR(50),       --  Fecha actual de la operacion

    INOUT Par_NumeroTransaccion     BIGINT,         --  Respuesta: Numero de Transaccion
    INOUT Par_SaldoContableAct      DECIMAL(16,2),  --  Respuesta: Saldo disponible de la linea
    INOUT Par_SaldoDisponibleAct    DECIMAL(16,2),  --  Respuesta: Saldo disponible,  + saldo bloqueado + saldo a favor
    INOUT Par_CodigoRespuesta       VARCHAR(3),     --  Respuesta: Codigo de Respuesta PROSA

    INOUT Par_FechaAplicacion       DATE,           --  Fecha de Aplicacion de la operacion
    Var_TarCredMovID                INT(11),        --  Numero de movimiento
    Par_OrigenPago                  CHAR(1),        --  P: Archivo Pagos, T: Archivo Transacciones

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
    DECLARE Var_TotalPago           DECIMAL(16,2);      -- Monto total de compra
    DECLARE Var_MontoPagoPro         DECIMAL(16,2);      -- Monto total del pago Realizado

    DECLARE Var_ProductoCreditoID   INT;
    DECLARE Var_Clasificacion       CHAR(1);
    DECLARE Var_SubClasificacion    INT(11);
    DECLARE Var_SucursalCte         INT(11);
    DECLARE Var_Poliza              BIGINT;
    DECLARE Var_Consecutivo         INT(11);
    DECLARE Var_FechaActual         DATE;


    DECLARE Var_LineaTarCredID          INT(11);
    DECLARE Var_ClienteID               INT(11);
    DECLARE Var_TarjetaPrincipal        VARCHAR(16);
    DECLARE Var_SaldoAFavor             DECIMAL(16,2);
    DECLARE Var_SaldoCapVigente         DECIMAL(16,2);
    DECLARE Var_SaldoCapVencido         DECIMAL(16,2);
    DECLARE Var_SaldoInteres            DECIMAL(16,2);
    DECLARE Var_SaldoIVAInteres         DECIMAL(16,2);
    DECLARE Var_SaldoMoratorios         DECIMAL(16,2);
    DECLARE Var_SaldoIVAMoratorios      DECIMAL(16,2);
    DECLARE Var_SalComFaltaPag          DECIMAL(16,2);
    DECLARE Var_SalIVAComFaltaPag       DECIMAL(16,2);
    DECLARE Var_SalOrtrasComis          DECIMAL(16,2);
    DECLARE Var_SalIVAOrtrasComis       DECIMAL(16,2);
    declare Var_PeriodoID               INT;
    declare Var_FechaCortePer           DATE;
    DECLARE Var_MontoDesc DECIMAL(12,2);
    DECLARE Var_MontoComision DECIMAL(12,2);


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
	DECLARE TipoOperaTarjeta		VARCHAR(2);

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
    SET TipoOperaTarjeta	:= '19';

    SET AltaPolLinCre_Si    := 'S';
    SET RegistraMov_NO      := 'N';
    SET Des_ComDispo        := 'COMISION POR DISPOSICION';
    SET Des_ComIVADispo     := 'IVA COMISION POR DISPOSICION';
    SET Var_DesAhorro       := 'PAGO DE TARJETA DE CREDITO';

ManejoErrores:BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_PAGOLINEAPRO');
      END;

    if ifnull(Par_CuentaClabe,'') = '' then
        SET Par_NumErr  = 0;
        set Par_ErrMen  = 'Pago Realizado Exitosamente';
        leave ManejoErrores;
    end if;

    SET Var_FechaActual := str_to_date(substr(Par_FechaActual,1,8),'%d/%m/%Y');




    -- Se obtiene la fecha actual
    SET Aud_FechaActual := NOW();

    -- Se obtiene la fecha del sistema
    SET Par_FechaAplicacion :=  (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);



    IF (IFNULL(Par_MontoTransaccion, Cadena_Vacia) = Cadena_Vacia) THEN

        SET Par_CodigoRespuesta     := "110";
        SET Par_NumErr              := 105;
        SET Par_ErrMen              := 'Monto de Pago Vacio';
        LEAVE ManejoErrores;

    END IF;

    IF (Par_MontoTransaccion = Decimal_Cero )THEN

        SET Par_CodigoRespuesta     := "110";
        SET Par_NumErr              := 106;
        SET Par_ErrMen              := 'Monto de Pago Vacio';
        LEAVE ManejoErrores;

    END IF;


    /* Se elimina el monto de 1.8 de comision de copayment
        Es temporal se debe modificar para que sea parametrizable */

    SET Var_MontoComision := IFNULL(FNPARAMGENERALES('MontoComisionPagoTarjetaCredito'), Entero_Cero);
    SET @Var_MontoOriginal := Par_MontoTransaccion;
    SET Var_MontoDesc      := ROUND((Par_MontoTransaccion * Var_MontoComision), 2);
    SET Var_MontoPagoPro := round(Par_MontoTransaccion - Var_MontoDesc ,2);
    SET Par_MontoTransaccion := Var_MontoPagoPro;


    -- Se consultan los datos de la linea de credito para realizar el pago del mismo
    select
        LineaTarCredID,     ClienteID,          TarjetaPrincipal,       SaldoAFavor,        SaldoCapVigente,
        SaldoCapVencido,    SaldoInteres,       SaldoIVAInteres,        SaldoMoratorios,    SaldoIVAMoratorios,
        SalComFaltaPag,     SalIVAComFaltaPag,  SalOrtrasComis,         SalIVAOrtrasComis,  ProductoCredID
    into
        Var_LineaTarCredID,     Var_ClienteID,          Var_TarjetaPrincipal,       Var_SaldoAFavor,        Var_SaldoCapVigente,
        Var_SaldoCapVencido,    Var_SaldoInteres,       Var_SaldoIVAInteres,        Var_SaldoMoratorios,    Var_SaldoIVAMoratorios,
        Var_SalComFaltaPag,     Var_SalIVAComFaltaPag,  Var_SalOrtrasComis,         Var_SalIVAOrtrasComis,  Var_ProductoCreditoID
    from LINEATARJETACRED
    where CuentaClabe = Par_CuentaClabe;


    -- se inserta en la bitacora de pagos los descuentos por servicio
   set @folioPago := 0;
    select max(PagoTarDescuentoID) into @folioPago from TC_PAGOTARDESCUENTO;
    set @folioPago := ifnull(@folioPago,0)+1;
    INSERT INTO TC_PAGOTARDESCUENTO(
        PagoTarDescuentoID, LineaTarCredID, TarjetaCredID,      ClienteID,      MontoPagoOriginal,
        PorcDescuento,      MontoDescuento, MontoAplicadoTC,    FechaPago,      FechaAplicacion,
        EmpresaID,          Usuario,        FechaActual,        DireccionIP,    ProgramaID,
        Sucursal,           NumTransaccion
        )
    VALUES(
        @folioPago,         Var_LineaTarCredID, Var_TarjetaPrincipal, Var_ClienteID, @Var_MontoOriginal,
        1.8,                Var_MontoDesc,     Var_MontoPagoPro,  Var_FechaActual,   Par_FechaAplicacion,
        Par_EmpresaID,      Aud_Usuario,         Aud_FechaActual,   Aud_DireccionIP,  Aud_ProgramaID,
        Aud_Sucursal,           Aud_NumTransaccion
        );


    select max(FechaCorte) INTO Var_FechaCortePer
    from TC_PERIODOSLINEA where FechaCorte <= Par_FechaAplicacion
    AND LineaTarCredID = Var_LineaTarCredID;



     SET Var_Referencia  := CONCAT("TAR **** ", SUBSTRING(Var_TarjetaPrincipal,13, 4));

     SELECT      Tipo AS Clasificacion,  '201' AS SubClasificacion
                    INTO    Var_Clasificacion,      Var_SubClasificacion
                FROM PRODUCTOSCREDITO
                WHERE ProducCreditoID = Var_ProductoCreditoID;

    SELECT  SucursalOrigen
                    INTO Var_SucursalCte
                FROM CLIENTES WHERE ClienteID = Var_ClienteID;


    CALL MAESTROPOLIZASALT(Var_Poliza, Par_EmpresaID, Par_FechaAplicacion, 'A', Concepto_TarCred,
                             Var_DesAhorro, 'N', Par_NumErr,  Par_ErrMen,
                              Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Var_NumTransaccion);

    IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;


    -- Pago de IVA de Comision por falta de pago
    if Var_SalIVAComFaltaPag > 0 and Par_MontoTransaccion > 0 THEN

            IF Var_SalIVAComFaltaPag > Par_MontoTransaccion  THEN
                set Var_TotalPago := Par_MontoTransaccion;
                set Par_MontoTransaccion := 0;
            else
                set Var_TotalPago = Var_SalIVAComFaltaPag;
                set Par_MontoTransaccion := Par_MontoTransaccion - Var_SalIVAComFaltaPag;
            end if;


            CALL TC_CONTALINEAPRO(
                Var_LineaTarCredID,     Var_TarjetaPrincipal,   Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
                Var_TotalPago,          Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         'N',                    Concepto_TarCred,
                Var_Poliza,             'S',                    'N',                    'S',                    10,         22,
                'A',                    Aud_NumTransaccion,     RegistraMov_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);



            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;



            -- Poliza de Tarjeta - Transacciones POS
            CALL POLIZATARJETAPRO(
                Var_Poliza,         Par_EmpresaID,      Var_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,      Par_MonedaID,       Var_TotalPago,            Entero_Cero,            Var_DesAhorro,
                Var_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

    END IF;

    -- Pago de Comision por falta de pago
    if Var_SalComFaltaPag > 0 and Par_MontoTransaccion > 0 THEN

            IF Var_SalComFaltaPag > Par_MontoTransaccion  THEN
                set Var_TotalPago := Par_MontoTransaccion;
                set Par_MontoTransaccion := 0;
            else
                set Var_TotalPago = Var_SalComFaltaPag;
                set Par_MontoTransaccion := Par_MontoTransaccion - Var_SalComFaltaPag;
            end if;


            CALL TC_CONTALINEAPRO(
                Var_LineaTarCredID,     Var_TarjetaPrincipal,   Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
                Var_TotalPago,          Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         'N',                    Concepto_TarCred,
                Var_Poliza,             'S',                    'N',                    'S',                    7,         40,
                'A',                    Aud_NumTransaccion,     RegistraMov_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;



            -- Poliza de Tarjeta - Transacciones POS
            CALL POLIZATARJETAPRO(
                Var_Poliza,         Par_EmpresaID,      Var_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,      Par_MonedaID,       Var_TotalPago,            Entero_Cero,            Var_DesAhorro,
                Var_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

    END IF;


    -- Pago de Iva de Interes
    if Var_SaldoIVAInteres > 0 and Par_MontoTransaccion > 0 THEN

            IF Var_SaldoIVAInteres > Par_MontoTransaccion  THEN
                set Var_TotalPago := Par_MontoTransaccion;
                set Par_MontoTransaccion := 0;
            else
                set Var_TotalPago = Var_SaldoIVAInteres;
                set Par_MontoTransaccion := Par_MontoTransaccion - Var_SaldoIVAInteres;
            end if;


            CALL TC_CONTALINEAPRO(
                Var_LineaTarCredID,     Var_TarjetaPrincipal,   Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
                Var_TotalPago,          Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         'N',                    Concepto_TarCred,
                Var_Poliza,             'S',                    'N',                    'S',                    8,         20,
                'A',                    Aud_NumTransaccion,     RegistraMov_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;


            -- Poliza de Tarjeta - Transacciones POS
            CALL POLIZATARJETAPRO(
                Var_Poliza,         Par_EmpresaID,      Var_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,      Par_MonedaID,       Var_TotalPago,            Entero_Cero,            Var_DesAhorro,
                Var_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

    END IF;


    -- Pago de Interes
    if Var_SaldoInteres > 0 and Par_MontoTransaccion > 0 THEN

            IF Var_SaldoInteres > Par_MontoTransaccion  THEN
                set Var_TotalPago := Par_MontoTransaccion;
                set Par_MontoTransaccion := 0;
            else
                set Var_TotalPago = Var_SaldoInteres;
                set Par_MontoTransaccion := Par_MontoTransaccion - Var_SaldoInteres;
            end if;


            CALL TC_CONTALINEAPRO(
                Var_LineaTarCredID,     Var_TarjetaPrincipal,   Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
                Var_TotalPago,          Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         'N',                    Concepto_TarCred,
                Var_Poliza,             'S',                    'N',                    'S',                    19,         14,
                'A',                    Aud_NumTransaccion,     RegistraMov_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;


            -- Poliza de Tarjeta - Transacciones POS
            CALL POLIZATARJETAPRO(
                Var_Poliza,         Par_EmpresaID,      Var_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,      Par_MonedaID,       Var_TotalPago,            Entero_Cero,            Var_DesAhorro,
                Var_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

    END IF;


    -- PAGO DE CAPITAL
    if Var_SaldoCapVigente > 0 and Par_MontoTransaccion > 0 THEN

            IF Var_SaldoCapVigente > Par_MontoTransaccion  THEN
                set Var_TotalPago := Par_MontoTransaccion;
                set Par_MontoTransaccion := 0;
            else
                set Var_TotalPago = Var_SaldoCapVigente;
                set Par_MontoTransaccion := Par_MontoTransaccion - Var_SaldoCapVigente;
            end if;


            CALL TC_CONTALINEAPRO(
                Var_LineaTarCredID,     Var_TarjetaPrincipal,   Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
                Var_TotalPago,          Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
                Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         'N',                    Concepto_TarCred,
                Var_Poliza,             'S',                    'N',                    'S',                    Con_CapVigente,         Mov_CapOrdinario,
                'A',                    Aud_NumTransaccion,     RegistraMov_NO,         Cadena_Vacia,			TipoOperaTarjeta,
                Salida_NO,              Par_NumErr,             Par_ErrMen,
                Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;


            -- Poliza de Tarjeta - Transacciones POS
            CALL POLIZATARJETAPRO(
                Var_Poliza,         Par_EmpresaID,      Var_FechaActual,            Par_NumeroTarjeta,      Var_ClienteID,
                Con_OperacPOS,      Par_MonedaID,       Var_TotalPago,            Entero_Cero,            Var_DesAhorro,
                Var_Referencia,     Entero_Cero,        Salida_NO,                  Par_NumErr,             Par_ErrMen,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                SET Par_CodigoRespuesta     := "116";
                LEAVE ManejoErrores;
            END IF;

    END IF;


		-- Llamada a cuentas de Orden del Pago Realizado
		CALL TC_CONTALINEAPRO(
        Var_LineaTarCredID,     Var_TarjetaPrincipal,      Var_ClienteID,          DATE(Var_FechaActual),  Par_FechaAplicacion,
        Var_MontoPagoPro,       Par_MonedaID,           Var_ProductoCreditoID,  Var_Clasificacion,      Var_SubClasificacion,
        Var_SucursalCte,        Var_DesAhorro,          Var_Referencia,         Alta_Enc_Pol_NO,        Concepto_TarCred,
        Var_Poliza,             RegistraMov_NO,         AltaPolLinCre_Si,       RegistraMov_NO,         Entero_Cero,        Entero_Cero,
        'A',                    Aud_NumTransaccion,     'S',                    'SU ABONO GRACIAS **',	TipoOperaTarjeta,
        Salida_NO,              Par_NumErr,             Par_ErrMen,
        Var_Consecutivo,        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    IF Par_NumErr != Entero_Cero THEN
        SET Par_CodigoRespuesta     := "116";
        LEAVE ManejoErrores;
    END IF;


    UPDATE TC_PERIODOSLINEA  SET
        MontoPagado = MontoPagado + Var_MontoPagoPro ,
        FechaUltPago = Par_FechaAplicacion
    where FechaCorte = Var_FechaCortePer
    and  LineaTarCredID = Var_LineaTarCredID;



   SET Par_CodigoRespuesta     := "000";
   SET Par_NumErr              := 0;
   SET Par_ErrMen              := 'Pago de Tarjeta Realizado Exitosamente';
   LEAVE ManejoErrores;

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
            Par_ErrMen AS ErrMen,
            Cadena_Vacia AS Control;

END IF;


END TerminaStore$$
