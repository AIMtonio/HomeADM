DELIMITER ;
DROP procedure IF EXISTS `CREPAGIGUAMORCVNPRO`;

DELIMITER $$
CREATE PROCEDURE `CREPAGIGUAMORCVNPRO`(
    -- SP que simula cuotas de pagos iguales de  capital
    Par_ConvenioNominaID        BIGINT UNSIGNED,        # Numero del Convenio de Nomina
    Par_Monto                   DECIMAL(12,2),          # Monto a prestar
    Par_Tasa                    DECIMAL(12,4),          # Tasa Anualizada
    Par_Frecu                   INT(11),                # Frecuencia del pago Capital en Dias (si el pago es Periodo)
    Par_FrecuInt                INT(11),                # Frecuencia del pago interes en Dias (si el pago es Periodo)
    Par_PagoCuota               CHAR(1),                # Pago de la cuota capital (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual U.-Unico)

    Par_PagoInter               CHAR(1),                # Pago de la cuota de Intereses  (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual U.-Unico)
    Par_PagoFinAni              CHAR(1),                # solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A)
    Par_PagoFinAniInt           CHAR(1),                # solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A) para los intereses
    Par_FechaInicio             DATE,                   # fecha en que empiezan los pagos
    Par_NumeroCuotas            INT(11),                # Numero de Cuotas que se simularan

    Par_NumCuotasInt            INT(11),                # Numero de Cuotas que se simularan para interes
    Par_ProducCreditoID         INT(11),                # identificador de PRODUCTOSCREDITO para obtener dias de gracia y margen para pag iguales
    Par_ClienteID               INT(11),                # identificador de CLIENTES para obtener el valor PagaIVA
    Par_DiaHabilSig             CHAR(1),                # Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
    Par_AjustaFecAmo            CHAR(1),                # Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)

    Par_AjusFecExiVen           CHAR (1),               # Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
    Par_DiaMesInt               INT(11),                # solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para los intereses
    Par_DiaMesCap               INT(11),                # solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para el capital
    Par_ComAper                 DECIMAL(12,2),          # Monto de la comision por apertura
    Par_MontoGL                 DECIMAL(12,2),          # Monto de la garantia liquida

    Par_CobraSeguroCuota        CHAR(1),                -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota     CHAR(1),                -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota        DECIMAL(12,2),         -- Monto Seguro por Cuota
    Par_ComAnualLin             DECIMAL(12,2),      -- Monto Comisión por Anualidad Línea de Crédito
    Par_Salida                  CHAR(1),                # Indica si hay una salida o no

    INOUT   Par_NumErr          INT(11),
    INOUT   Par_ErrMen          VARCHAR(400),
    INOUT   Par_NumTran         BIGINT(20),             # Numero de transaccion con el que se genero el calENDario de pagos
    INOUT   Par_Cuotas          INT(11),                # devuelve el numero de cuotas de Capital
    INOUT   Par_CuotasInt       INT(11),                # devuelve el numero de cuotas de Interes

    INOUT   Par_Cat             DECIMAL(14,4),          # cat que corresponde con lo generado
    INOUT   Par_MontoCuo        DECIMAL(14,4),          # corresponde con la cuota promedio a pagar
    INOUT   Par_FechaVen        DATE,                   # corresponde con la fecha final que genere el cotizador
    Par_EmpresaID               INT(11),

    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
            )
TerminaStore: BEGIN
    -- Declaracion de Constantes
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Entero_Cero         INT(11);
    DECLARE Entero_Uno          INT;
    DECLARE Entero_Negativo     INT;
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Var_SI              CHAR(1);    -- SI
    DECLARE Var_No              CHAR(1);    -- NO
    DECLARE PagoSemanal         CHAR(1);    -- Pago Semanal (S)
    DECLARE PagoDecenal         CHAR(1);    -- Pago Decenal (D)
    DECLARE PagoCatorcenal      CHAR(1);    -- Pago Catorcenal (C)
    DECLARE PagoQuincenal       CHAR(1);    -- Pago Quincenal (Q)
    DECLARE PagoMensual         CHAR(1);    -- Pago Mensual (M)
    DECLARE PagoPeriodo         CHAR(1);    -- Pago por periodo (P)
    DECLARE PagoBimestral       CHAR(1);    -- PagoBimestral (B)
    DECLARE PagoTrimestral      CHAR(1);    -- PagoTrimestral (T)
    DECLARE PagoTetrames        CHAR(1);    -- PagoTetraMestral (R)
    DECLARE PagoSemestral       CHAR(1);    -- PagoSemestral (E)
    DECLARE PagoAnual           CHAR(1);    -- PagoAnual (A)
    DECLARE PagoUnico           CHAR(1);    -- Pago Unico (U)
    DECLARE PagoFinMes          CHAR(1);    -- Pago al final del mes (F)
    DECLARE PagoAniver          CHAR(1);    -- Pago por aniversario (A)
    DECLARE FrecSemanal         INT(11);        -- frecuencia semanal en dias
    DECLARE FrecDecenal     INT(11);        -- Frecuencia Decenal en dias
    DECLARE FrecCator           INT(11);        -- frecuencia Catorcenal en dias
    DECLARE FrecQuin            INT(11);        -- frecuencia en dias quincena
    DECLARE FrecMensual         INT(11);        -- frecuencia mensual
    DECLARE FrecBimestral       INT(11);    -- Frecuencia en dias Bimestral
    DECLARE FrecTrimestral      INT(11);
    DECLARE FrecTetrames        INT(11);
    DECLARE FrecSemestral       INT(11);
    DECLARE FrecAnual           INT(11);
    DECLARE Var_Capital         CHAR(1);
    DECLARE Var_Interes         CHAR(1);
    DECLARE Var_CapInt          CHAR(1);
    DECLARE Var_TipoCap         CHAR(1);
    DECLARE ComApDeduc          CHAR(1);
    DECLARE ComApFinan          CHAR(1);
    DECLARE Salida_SI                       CHAR(1);
    DECLARE Cons_FrecExtDiasSemanal         INT(11);
    DECLARE Cons_FrecExtDiasDecenal         INT(11);
    DECLARE Cons_FrecExtDiasCatorcenal      INT(11);
    DECLARE Cons_FrecExtDiasQuincenal       INT(11);
    DECLARE Cons_FrecExtDiasMensual         INT(11);
    DECLARE Cons_FrecExtDiasPeriodo         INT(11);
    DECLARE Cons_FrecExtDiasBimestral       INT(11);
    DECLARE Cons_FrecExtDiasTrimestral      INT(11);
    DECLARE Cons_FrecExtDiasTetrames        INT(11);
    DECLARE Cons_Var_FrecExtDiasSemestral   INT(11);
    DECLARE Cons_FrecExtDiasAnual           INT(11);
    DECLARE Cons_FrecExtDiasFinMes          INT(11);
    DECLARE Cons_FrecExtDiasAniver          INT(11);
    DECLARE Var_PlazoID                     INT(11);        -- Plazo del credito
    DECLARE Var_SolicitudCreditoID          BIGINT(20);     -- Numero de Solicitud de Credito
    DECLARE Var_CreditoID                   BIGINT(12);     -- Numero de Credito
    DECLARE Var_CobraAccesoriosGen          CHAR(1);        -- Valor del Cobro de Accesorios
    DECLARE Var_CobraAccesorios             CHAR(1);        -- Indica si la solicitud cobra accesorios
    DECLARE Var_TipoFormaCobro              CHAR(1);        -- Tipo de Forma de Accesorios

    -- Declaracion de Variables
    DECLARE Var_UltDia          INT(11);
    DECLARE Contador            INT(11);
    DECLARE Consecutivo         INT(11);
    DECLARE ContadorInt         INT(11);
    DECLARE ContadorCap         INT(11);
    DECLARE FechaInicio         DATE;
    DECLARE FechaFinal          DATE;
    DECLARE FechaInicioInt      DATE;
    DECLARE FechaFinalInt       DATE;
    DECLARE FechaVig            DATE;
    DECLARE Par_FechaVenc       DATE;        -- fecha vencimiento en que terminan los pagos
    DECLARE Var_EsHabil         CHAR(1);
    DECLARE Var_Cuotas          INT(11);
    DECLARE Var_CuotasInt       INT(11);
    DECLARE Var_Amor            INT(11);
    DECLARE Capital             DECIMAL(12,2);
    DECLARE Interes             DECIMAL(12,4);
    DECLARE IvaInt              DECIMAL(12,4);
    DECLARE Garantia            DECIMAL(12,2);
    DECLARE Subtotal            DECIMAL(12,2);
    DECLARE Insoluto            DECIMAL(12,2);
    DECLARE Var_IVA             DECIMAL(12,4);
    DECLARE Fre_DiasAnio        INT(11);        -- dias del año
    DECLARE Fre_Dias            INT(11);        -- numero de dias para pagos de capital
    DECLARE Fre_DiasTab         INT(11);        -- numero de dias para pagos de capital
    DECLARE Fre_DiasInt         INT(11);        -- numero de dias para pagos de interes
    DECLARE Fre_DiasIntTab      INT(11);        -- numero de dias para pagos de interes
    DECLARE Var_DiasExtra       INT(11);
    DECLARE Var_ProCobIva       CHAR(1);     -- Producto cobra Iva S si N no
    DECLARE Var_CtePagIva       CHAR(1);    -- Cliente Paga Iva S si N no
    DECLARE Var_PagaIVA                             CHAR(1);
    DECLARE CapInt                                  CHAR(1);
    DECLARE Var_InteresAco                          DECIMAL(12,4);
    DECLARE Var_IvaAco                              DECIMAL(12,4);
    DECLARE Var_CoutasAmor                          VARCHAR(8000);
    DECLARE Var_CAT                                 DECIMAL(12,4);
    DECLARE Var_FrecuPago                           INT(11);
    DECLARE MtoSinComAp                             DECIMAL(12,2);
    DECLARE CuotaSinIva                             DECIMAL(12,2);
    DECLARE Var_TotalCap                            DECIMAL(14,2);
    DECLARE Var_TotalInt                            DECIMAL(14,2);
    DECLARE Var_TotalIva                            DECIMAL(14,2);
    DECLARE NumCapInt                               INT(11);
    DECLARE Var_FrecExtDiasSemanal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasDecenal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasCatorcenal               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasQuincenal                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasMensual                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasPeriodo                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasBimestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTrimestral               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTetrames                 INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasSemestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAnual                    INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasFinMes                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAniver                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_Control                             VARCHAR(100);               -- Variable de control
    # SEGUROS
    DECLARE Var_SeguroCuota                         DECIMAL(12,2);              -- Monto que cobra por seguro por cuota
    DECLARE Var_IVASeguroCuota                      DECIMAL(12,2);              -- Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota                    DECIMAL(12,2);              -- Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota                 DECIMAL(12,2);              -- Total de iva seguro cuota
    DECLARE Var_1erDiaQuinc                         INT(11);                    -- Primer día de la quincena.
    DECLARE Var_2doDiaQuinc                         INT(11);                    -- Segundo día de la quincena.
    DECLARE Var_1erDiaQuincInt                      INT(11);                    -- Primer día de la quincena.
    DECLARE Var_2doDiaQuincInt                      INT(11);                    -- Segundo día de la quincena.

    DECLARE Var_SaldoOtrasComisiones                DECIMAL(14,2);              -- Saldo Otras Comisiones
    DECLARE Var_SaldoIVAOtrasComisiones             DECIMAL(14,2);              -- Saldo IVA Otras Comisiones
    DECLARE Llave_CobraAccesorios                   VARCHAR(100);               -- Llave para consulta el valor de Cobro de Accesorios
    DECLARE OperaSimulador                          INT(11);                    -- Indica que la transacción viene desde el simulador
    DECLARE FormaFinanciado                         CHAR(1);

    DECLARE Var_FechaInicioCre                      DATE;						-- Fecha de Inicio
    DECLARE Var_FechaVenc                           DATE;						-- Fecha de vencimiento
    DECLARE Var_ManejaCalendario					CHAR(1);					-- Maneja calendario
	DECLARE Var_InstitNominaID      				INT(11);					-- Institucion de nomina
    DECLARE FormaApertura                           CHAR(1);                    -- valida forma de pago Apertura
    DECLARE FormaDeducciones                        CHAR(1);                    -- valida forma de pago Deducciones
    DECLARE TipoPagoAccesorioM                      CHAR(1);                    -- valida TIPO PAGO MONTO
    DECLARE TipoPagoAccesorioP                      CHAR(1);                    -- valida TIPO PAGO PROCENTAJE
    DECLARE Var_MontoApertu                         DECIMAL(12,2);              -- monto acesorios apertura
    DECLARE Var_MontoIvaApertu                      DECIMAL(12,2);              -- monto acesorios IVA apertura
    DECLARE Var_MontoDeducci                        DECIMAL(12,2);              -- monto acesorios Deduccion
    DECLARE Var_MontoIvaDeducci                     DECIMAL(12,2);              -- monto acesorios IVA Deduccion
    DECLARE Entero_Dos                              INT;                                -- entero dos
    DECLARE Entero_Cien                             INT;                                -- entero cien
    DECLARE Var_MontoCredito                        DECIMAL(12,2);              -- monto acesorios IVA Deduccion

   -- asignacion de constantes
    SET Decimal_Cero                    := 0.00;
    SET Entero_Cero                     := 0;
    SET Entero_Uno                      := 1;
    SET Entero_Dos                      := 2;
    SET Entero_Cien                     := 100;
    SET Cadena_Vacia                    := '';
    SET Var_SI                          := 'S';
    SET Var_No                          := 'N';
    SET PagoSemanal                     := 'S'; -- PagoSemanal
    SET PagoDecenal                     := 'D'; -- Pago Decenal
    SET PagoCatorcenal                  := 'C'; -- PagoCatorcenal
    SET PagoQuincenal                   := 'Q'; -- PagoQuincenal
    SET PagoMensual                     := 'M'; -- PagoMensual
    SET PagoPeriodo                     := 'P'; -- PagoPeriodo
    SET PagoBimestral                   := 'B'; -- PagoBimestral
    SET PagoTrimestral                  := 'T'; -- PagoTrimestral
    SET PagoTetrames                    := 'R'; -- PagoTetraMestral
    SET PagoSemestral                   := 'E'; -- PagoSemestral
    SET PagoAnual                       := 'A'; -- PagoAnual
    SET PagoFinMes                      := 'F'; -- PagoFinMes
    SET PagoAniver                      := 'A'; -- Pago por aniversario
    SET PagoUnico                       := 'U'; -- Pago Unico (U)
    SET Salida_SI                       := 'S';
    SET FrecSemanal                     := 7;    -- frecuencia semanal en dias
    SET FrecDecenal                     := 10;  -- Frecuencia decenal en diAS
    SET FrecCator                       := 14;    -- frecuencia Catorcenal en dias
    SET FrecQuin                        := 15;    -- frecuencia en dias de quincena
    SET FrecMensual                     := 30;    -- frecuencia mesual

    SET FrecBimestral                   := 60;    -- Frecuencia en dias Bimestral
    SET FrecTrimestral                  := 90;    -- Frecuencia en dias Trimestral
    SET FrecTetrames                    := 120;    -- Frecuencia en dias TetraMestral
    SET FrecSemestral                   := 180;    -- Frecuencia en dias Semestral
    SET FrecAnual                       := 360;    -- frecuencia en dias Anual
    SET Var_Capital                     := 'C';    -- Bandera que me indica que se trata de un pago de capital
    SET Var_Interes                     := 'I';    -- Bandera que me indica que se trata de un pago de interes
    SET Var_CapInt                      := 'G';    -- Bandera que me indica que se trata de un pago de capital y de interes
    SET ComApDeduc                      := 'D';
    SET ComApFinan                      := 'F';

    -- asignacion de variables
    SET Contador                        := 1;
    SET ContadorInt                     := 1;
    SET FechaInicio                     := Par_FechaInicio;
    SET FechaInicioInt                  := Par_FechaInicio;
    SET Var_CoutasAmor                  := '';
    SET Var_CAT                         := 0.0000;
    SET Var_FrecuPago                   := 0;
    SET MtoSinComAp                     := 0.00;
    SET CuotaSinIva                     := 0;
    SET Cons_FrecExtDiasSemanal         := 5;
    SET Cons_FrecExtDiasDecenal         := 4;
    SET Cons_FrecExtDiasCatorcenal      := 10;
    SET Cons_FrecExtDiasQuincenal       := 10;
    SET Cons_FrecExtDiasMensual         := 20;
    SET Cons_FrecExtDiasBimestral       := 40;
    SET Cons_FrecExtDiasTrimestral      := 60;
    SET Cons_FrecExtDiasTetrames        := 80;
    SET Cons_Var_FrecExtDiasSemestral   := 120;
    SET Cons_FrecExtDiasAnual           := 240;
    SET Llave_CobraAccesorios           := 'CobraAccesorios'; -- Llave para Consultar si Cobra Accesorios
    SET OperaSimulador                  := 1;       -- Indica Opera Simulador
    SET FormaFinanciado                 := 'F';     -- Forma de cobro Financiado
    SET FormaApertura                   := 'A';     -- Forma de cobro Financiado
    SET FormaDeducciones                := 'D';     -- Forma de cobro Financiado
    SET TipoPagoAccesorioM              := 'M';     -- Forma de cobro MONTO
    SET TipoPagoAccesorioP              := 'P';     -- Forma de cobro Procentaje
    SET Par_NumErr                      := 0;

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGIGUAMORNOMPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        -- Se obtiene el valor de si se realiza o no el cobro de accesorios
        SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
        SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

        SET Var_CobraAccesorios := (SELECT CobraAccesorios FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);
        SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios, Cadena_Vacia);

        SET Var_IVA                         := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
        SET Fre_DiasAnio                    := (SELECT DiasCredito FROM PARAMETROSSIS);

        /*PARAMETRIZACION DE DIAS EXTRAS PARA LAS AMORITZACIONES*/
        SET Var_FrecExtDiasSemanal          :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemanal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasDecenal          :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoDecenal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasCatorcenal       :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoCatorcenal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasQuincenal        :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoQuincenal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasMensual          :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoMensual AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasPeriodo          :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoPeriodo AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasBimestral        :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoBimestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTrimestral       :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTrimestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTetrames         :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTetrames AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasSemestral        :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAnual            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAnual AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasFinMes           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoFinMes AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAniver           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAniver AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);

        -- SE SETEAN LOS SIGUIENTES VALORES SI ES QUE EL CLIENTE NO LO HA PARAMETRIZADO
        SET Var_FrecExtDiasSemanal              :=IFNULL(Var_FrecExtDiasSemanal, Cons_FrecExtDiasSemanal);
        SET Var_FrecExtDiasDecenal              :=IFNULL(Var_FrecExtDiasDecenal, Cons_FrecExtDiasDecenal);
        SET Var_FrecExtDiasCatorcenal           :=IFNULL(Var_FrecExtDiasCatorcenal, Cons_FrecExtDiasCatorcenal);
        SET Var_FrecExtDiasQuincenal            :=IFNULL(Var_FrecExtDiasQuincenal, Cons_FrecExtDiasQuincenal);
        SET Var_FrecExtDiasMensual              :=IFNULL(Var_FrecExtDiasMensual, Cons_FrecExtDiasMensual);
        SET Var_FrecExtDiasPeriodo              :=IFNULL(Var_FrecExtDiasPeriodo, Cons_FrecExtDiasPeriodo);
        SET Var_FrecExtDiasBimestral            :=IFNULL(Var_FrecExtDiasBimestral, Cons_FrecExtDiasBimestral);
        SET Var_FrecExtDiasTrimestral           :=IFNULL(Var_FrecExtDiasTrimestral, Cons_FrecExtDiasTrimestral);
        SET Var_FrecExtDiasTetrames             :=IFNULL(Var_FrecExtDiasTetrames, Cons_FrecExtDiasTetrames);
        SET Var_FrecExtDiasSemestral            :=IFNULL(Var_FrecExtDiasSemestral, Cons_Var_FrecExtDiasSemestral);
        SET Var_FrecExtDiasAnual                :=IFNULL(Var_FrecExtDiasAnual, Cons_FrecExtDiasAnual);
        SET Var_FrecExtDiasFinMes               :=IFNULL(Var_FrecExtDiasFinMes, Cons_FrecExtDiasFinMes);
        SET Var_FrecExtDiasAniver               :=IFNULL(Var_FrecExtDiasAniver, Cons_FrecExtDiasAniver);
        /* FIN PARAMETRIZACION DE DIAS EXTRAS PARA LAS AMORITZACIONES*/

        /** SECCION VALIDACIONES **/
        IF ( Par_PagoCuota = PagoPeriodo) THEN
            IF(IFNULL(Par_Frecu, Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr := 1;
                SET Par_ErrMen := 'Especificar Frecuencia Pago.';
                LEAVE ManejoErrores;
            END  IF ;
        END  IF ;


         IF ( Par_PagoInter = PagoPeriodo) THEN
            IF(IFNULL(Par_FrecuInt, Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr := 2;
                SET Par_ErrMen := 'Especificar Frecuencia Pago.';
                LEAVE TerminaStore;
            END  IF ;
        END  IF ;

        IF(IFNULL(Par_Monto, Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr     := 3;
            SET Par_ErrMen     := 'El Monto solicitado esta Vacio.';
            LEAVE ManejoErrores;
        ELSE
            IF(Par_Monto < Entero_Cero)THEN
                SET Par_NumErr     := 9;
                SET Par_ErrMen     := 'El Monto no puede ser Negativo.';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_NumCuotasInt, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 4;
            SET Par_ErrMen := 'Especificar Numero de Cuotas de Interes.';
            LEAVE TerminaStore;
        END  IF ;

        IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra Seguro por Cuota.';
            LEAVE ManejoErrores;
          ELSE
            IF(Par_CobraSeguroCuota = Var_SI) THEN
                IF(IFNULL(Par_CobraIVASeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
                    SET Par_NumErr := 005;
                    SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra IVA por Seguro por Cuota.';
                    LEAVE ManejoErrores;
                END IF;
                IF(IFNULL(Par_MontoSeguroCuota,Entero_Cero)= Entero_Cero) THEN
                    SET Par_NumErr := 006;
                    SET Par_ErrMen := 'El Monto para el Seguro no se encuentra Parametrizado.';
                    LEAVE ManejoErrores;
                END IF;
              ELSE
                SET Par_MontoSeguroCuota := Decimal_Cero;
                SET Var_TotalSeguroCuota := Decimal_Cero;
                SET Var_TotalIVASeguroCuota := Decimal_Cero;
            END IF;
        END IF;
        /** FIN SECCION VALIDACIONES **/
		 SELECT ManejaCalendario, InstitNominaID INTO Var_ManejaCalendario, Var_InstitNominaID
			FROM CONVENIOSNOMINA
			WHERE ConvenioNominaID = Par_ConvenioNominaID;

        SET Var_ManejaCalendario := IFNULL(Var_ManejaCalendario, Var_No);
        SET Var_InstitNominaID := IFNULL(Var_InstitNominaID, Entero_Cero);
        SET Par_ConvenioNominaID := IFNULL(Par_ConvenioNominaID, Entero_Cero);

		IF(Par_ConvenioNominaID = Entero_Cero)THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'Especificar el convenio';
			LEAVE ManejoErrores;
        END IF;

        IF(Var_InstitNominaID = Entero_Cero)THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'Especificar la institución de nomina';
			LEAVE ManejoErrores;
        END IF;


        IF(Var_ManejaCalendario = Var_SI) THEN
            /** FIN SECCION VALIDACIONES **/
            CALL FECHASCALENDARIOCVNCAL(
                Par_ConvenioNominaID,   Var_InstitNominaID,     Par_FechaInicio,    Par_PagoCuota,      Par_PagoFinAni,
                Var_FechaInicioCre,     Var_FechaVenc,          Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
            SET Par_FechaVenc   := Var_FechaVenc;
            SET Par_FechaInicio := Var_FechaInicioCre;
            SET Par_DiaMesCap   := DAY(Par_FechaVenc);
            SET Par_DiaMesInt   := DAY(Par_FechaVenc);

            SET Var_1erDiaQuinc := CAST(DAY(Par_FechaVenc) AS SIGNED);
            SET Var_1erDiaQuincInt := CAST(DAY(Par_FechaVenc) AS SIGNED);

            IF Var_1erDiaQuinc > 15 THEN 
                SET Var_2doDiaQuinc := Var_1erDiaQuinc-FrecQuin;
				SET Var_2doDiaQuincInt := Var_1erDiaQuincInt-FrecQuin;
				IF Var_1erDiaQuinc > 28 THEN
					SET Var_2doDiaQuinc := Var_1erDiaQuinc;
                    SET Var_1erDiaQuinc := Var_1erDiaQuinc-FrecQuin;

                    SET Var_2doDiaQuincInt := Var_1erDiaQuincInt;
                    SET Var_1erDiaQuincInt := Var_1erDiaQuincInt-FrecQuin;
				END IF;
            ELSE 
                SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
				SET Var_2doDiaQuincInt := Var_1erDiaQuincInt + FrecQuin;
            END IF;

        END IF;

        -- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
        CASE Par_PagoCuota
            WHEN PagoSemanal        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecSemanal DAY));
            WHEN PagoDecenal        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecDecenal DAY));
            WHEN PagoCatorcenal     THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecCator DAY));
            WHEN PagoQuincenal      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecQuin DAY));
            WHEN PagoMensual        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas MONTH));
            WHEN PagoPeriodo        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu DAY));
            WHEN PagoBimestral      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*2 MONTH));
            WHEN PagoTrimestral     THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*3 MONTH));
            WHEN PagoTetrames       THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*4 MONTH));
            WHEN PagoSemestral      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*6 MONTH));
            WHEN PagoAnual          THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas YEAR));
            WHEN PagoUnico          THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu  DAY));
        END CASE;

        -- se guarda el valor de dias de gracia y margen de pagos iguales en las variables
        SELECT CobraIVAInteres INTO Var_ProCobIva
            FROM PRODUCTOSCREDITO
            WHERE ProducCreditoID = Par_ProducCreditoID;

        -- se guarda el valor de si el cliente paga o no IVA
        SELECT PagaIVA INTO Var_CtePagIva
            FROM CLIENTES
            WHERE ClienteID = Par_ClienteID;


        IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Var_CtePagIva     := Var_Si;
        END IF;

         IF (Var_ProCobIva = Var_Si) THEN
             IF (Var_CtePagIva = Var_Si) THEN
                SET Var_PagaIVA        := Var_Si;
            END IF;
        ELSE
            SET Var_PagaIVA        := Var_No;
        END IF;
         /***CALCULANDO IVA PARA SEGURO POR CUOTA***/
        IF(Par_CobraIVASeguroCuota = Var_Si) THEN
            SET Var_IVASeguroCuota :=  ROUND(Par_MontoSeguroCuota * Var_IVA,2);
          ELSE
            SET Var_IVASeguroCuota := Decimal_Cero;
        END IF;
         /***CALCULANDO IVA PARA SEGURO POR CUOTA***/

        /*Compara el valor de pago de la cuota para asiganrle un valor en dias*/
        CASE Par_PagoCuota
            WHEN PagoSemanal        THEN SET Fre_Dias    :=  FrecSemanal;   SET Var_DiasExtra:= Var_FrecExtDiasSemanal;
            WHEN PagoDecenal        THEN SET Fre_Dias    :=  FrecDecenal;   SET Var_DiasExtra:= Var_FrecExtDiasDecenal;
            WHEN PagoCatorcenal     THEN SET Fre_Dias    :=  FrecCator;     SET Var_DiasExtra:= Var_FrecExtDiasCatorcenal;
            WHEN PagoQuincenal      THEN SET Fre_Dias    :=  FrecQuin;      SET Var_DiasExtra:= Var_FrecExtDiasQuincenal;
            WHEN PagoMensual        THEN SET Fre_Dias    :=  FrecMensual;   SET Var_DiasExtra:= Var_FrecExtDiasMensual;
            WHEN PagoPeriodo        THEN SET Fre_Dias    :=  Par_Frecu;
            WHEN PagoBimestral      THEN SET Fre_Dias    :=  FrecBimestral; SET Var_DiasExtra:= Var_FrecExtDiasBimestral;
            WHEN PagoTrimestral     THEN SET Fre_Dias    :=  FrecTrimestral;SET Var_DiasExtra:= Var_FrecExtDiasTrimestral;
            WHEN PagoTetrames       THEN SET Fre_Dias    :=  FrecTetrames;  SET Var_DiasExtra:= Var_FrecExtDiasTetrames;
            WHEN PagoSemestral      THEN SET Fre_Dias    :=  FrecSemestral; SET Var_DiasExtra:= Var_FrecExtDiasSemestral;
            WHEN PagoAnual          THEN SET Fre_Dias    :=  FrecAnual; SET Var_DiasExtra:= Var_FrecExtDiasAnual;
            WHEN PagoUnico          THEN SET Fre_Dias    :=  Par_Frecu; SET Var_DiasExtra:= 0;
        END CASE;


        SET  Var_FrecuPago = Fre_Dias;

        -- ASIGNA EL VALOR QUE LE CORRESPONDE EN FRECUENCIA EN DIAS SEGUN EL TIPO DE PAGO PARA INTERESES
        CASE Par_PagoInter
            WHEN PagoSemanal        THEN SET Fre_DiasInt    :=  FrecSemanal;        SET Var_DiasExtra:= Var_FrecExtDiasSemanal;
            WHEN PagoDecenal        THEN SET Fre_DiasInt    :=  FrecDecenal;        SET Var_DiasExtra:= Var_FrecExtDiasDecenal;
            WHEN PagoCatorcenal     THEN SET Fre_DiasInt    :=  FrecCator;          SET Var_DiasExtra:= Var_FrecExtDiasCatorcenal;
            WHEN PagoQuincenal      THEN SET Fre_DiasInt    :=  FrecQuin;           SET Var_DiasExtra:= Var_FrecExtDiasQuincenal;
            WHEN PagoMensual        THEN SET Fre_DiasInt    :=  FrecMensual;        SET Var_DiasExtra:= Var_FrecExtDiasMensual;
            WHEN PagoPeriodo        THEN SET Fre_DiasInt    :=  Par_FrecuInt;
            WHEN PagoBimestral      THEN SET Fre_DiasInt    :=  FrecBimestral;      SET Var_DiasExtra:= Var_FrecExtDiasBimestral;
            WHEN PagoTrimestral     THEN SET Fre_DiasInt    :=  FrecTrimestral;     SET Var_DiasExtra:= Var_FrecExtDiasTrimestral;
            WHEN PagoTetrames       THEN SET Fre_DiasInt    :=  FrecTetrames;       SET Var_DiasExtra:= Var_FrecExtDiasTetrames;
            WHEN PagoSemestral      THEN SET Fre_DiasInt    :=  FrecSemestral;      SET Var_DiasExtra:= Var_FrecExtDiasSemestral;
            WHEN PagoAnual          THEN SET Fre_DiasInt    :=  FrecAnual;          SET Var_DiasExtra:= Var_FrecExtDiasAnual;
            WHEN PagoUnico          THEN SET Fre_DiasInt    :=  Par_Frecu;          SET Var_DiasExtra:= 0;
        END CASE;


        IF Fre_Dias < Fre_DiasInt THEN
            SET  Var_FrecuPago = Fre_Dias;
        ELSE
            SET  Var_FrecuPago = Fre_DiasInt;
        END IF;


        SET Var_Cuotas      := IFNULL(Par_NumeroCuotas, Entero_Cero);
        SET Var_CuotasInt   := IFNULL(Par_NumCuotasInt, Entero_Cero);

        IF(Var_Cuotas > Entero_Cero)THEN
            SET Capital     := Par_Monto / Var_Cuotas;
        ELSE
            SET Capital     := Entero_Cero;
        END IF;

        SET Insoluto        := Par_Monto;

        DROP TABLE  IF EXISTS Tmp_Amortizacion;
        DROP TABLE  IF EXISTS Tmp_AmortizacionInt;

        -- tabla temporal donde inserta las fechas de pago de capital
        CREATE TEMPORARY TABLE Tmp_Amortizacion(
            Tmp_Consecutivo    INT,
            Tmp_Dias            INT,
            Tmp_FecIni        DATE,
            Tmp_FecFin        DATE,
            Tmp_FecVig        DATE,
            Tmp_Capital        DECIMAL(12,2),
            Tmp_Interes        DECIMAL(12,4),
            Tmp_iva            DECIMAL(12,4),
            Tmp_SubTotal        DECIMAL(12,2),
            Tmp_Insoluto        DECIMAL(12,2),
            Tmp_CapInt        CHAR(1),
            Tmp_InteresAco     DECIMAL(12,2),
            PRIMARY KEY  (Tmp_Consecutivo));

        -- tabla temporal donde inserta las fechas de pago de intereses
        CREATE TEMPORARY TABLE Tmp_AmortizacionInt(
            Tmp_Consecutivo    INT,
            Tmp_Dias            INT,
            Tmp_FecIni        DATE,
            Tmp_FecFin        DATE,
            Tmp_FecVig        DATE,
            Tmp_Capital        DECIMAL(12,2),
            Tmp_Interes        DECIMAL(12,4),
            Tmp_iva            DECIMAL(12,4),
            Tmp_SubTotal        DECIMAL(12,2),
            Tmp_Insoluto        DECIMAL(12,2),
            Tmp_CapInt        CHAR(1),
            Tmp_InteresAco     DECIMAL(12,2),
            PRIMARY KEY  (Tmp_Consecutivo));

        -- -- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE CAPITAL
	-- WHILE PARA OBTENER LAS FECHAS
        WHILE (Contador <= Var_Cuotas) DO
			IF(Contador = 1 AND Var_ManejaCalendario = Var_SI) THEN
				SET FechaInicio := Var_FechaInicioCre;
			END IF;
			IF(Contador = 2 AND Var_ManejaCalendario = Var_SI)THEN
				SET FechaInicio := Var_FechaVenc;
			END IF;

            -- pagos decenales
            IF (Par_PagoCuota = PagoDecenal) THEN
                IF (DAY(FechaInicio) = FrecDecenal) THEN
                    SET FechaFinal     := DATE_ADD(FechaInicio, INTERVAL FrecDecenal DAY);
                  ELSE
                    IF (DAY(FechaInicio) < 6 ) THEN
                        SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '10'),DATE);
                      ELSE
                        IF(DAY(FechaInicio) < 16 ) THEN
                            SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '20'),DATE);
                          ELSE
                            IF(DAY(FechaInicio) < 26 ) THEN
                                SET FechaFinal := LAST_DAY(FechaInicio);
                              ELSE
                                SET FechaFinal := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                            END IF;
                        END    IF;
                    END IF;
                END IF;
              ELSE
                -- pagos quincenales
                IF (Par_PagoCuota = PagoQuincenal) THEN
                    # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                    IF(Par_PagoFinAni <> 'D') THEN
                        IF (DAY(FechaInicio) = FrecQuin) THEN
                            SET FechaFinal  := DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                        ELSE
                            IF (DAY(FechaInicio) >28) THEN
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '15'),DATE);
                            ELSE
                                SET FechaFinal  := DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
                                IF  (FechaFinal <= FechaInicio) THEN
                                    SET FechaFinal := LAST_DAY(FechaInicio);
                                    IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    ELSE
                        # Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
                        IF(Var_ManejaCalendario <> Var_SI) THEN
                            SET Var_1erDiaQuinc := Par_DiaMesCap;
                            SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                        END IF;

                        IF (DAY(FechaInicio) = Var_1erDiaQuinc) THEN
                             IF(MONTH(FechaInicio) = 2  AND Var_2doDiaQuinc>28)THEN
                                SET FechaFinal := LAST_DAY(FechaInicio);
                            ELSE
                                SET FechaFinal  := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                            END IF;
                        ELSE
                            IF (DAY(FechaInicio) >28) THEN
                                SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                            ELSE
                                 -- SI ES FEBRERO Y  EL DIA QUINCENA ES 30 SE AJUSTA
                                IF(MONTH(FechaInicio) = 2  AND Var_2doDiaQuinc >28)THEN
                                    SET FechaFinal := LAST_DAY(FechaInicio);
                                ELSE
                                    SET FechaFinal := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                END IF;

                                IF(FechaFinal <= FechaInicio) THEN
                                    SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        LPAD(Var_1erDiaQuinc,2,'0')));
                                    IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                        SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                  ELSE
                    -- Pagos Mensuales
                    IF (Par_PagoCuota = PagoMensual) THEN
                        -- Para pagos que se haran cada 30 dias
                        IF (Par_PagoFinAni != PagoFinMes) THEN
                            IF(Par_DiaMesCap>28)THEN
                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                         CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                IF(Var_UltDia < Par_DiaMesCap)THEN
                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                         CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
                                  ELSE
                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                         CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                    IF(DATEDIFF(FechaFinal,FechaInicio)>(Par_DiaMesCap+Cons_FrecExtDiasMensual)) THEN
                                        SET FechaFinal := LAST_DAY(FechaInicio);
                                    END IF;
                                END IF;
                              ELSE
                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                         CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                            END IF;
                          ELSE
                            -- Para pagos que se haran cada fin de mes
                             IF (Par_PagoFinAni = PagoFinMes) THEN
                                /* se obtiene el final del mes.*/
                                SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                            END IF;
                        END IF;
                      ELSE
                        IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
                            SET FechaFinal     := DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
                          ELSE
                            IF (Par_PagoCuota = PagoBimestral ) THEN
                                IF (Par_PagoFinAni != PagoFinMes ) THEN
                                    IF(Par_DiaMesCap>28)THEN
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                        CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                        SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                        IF(Var_UltDia < Par_DiaMesCap)THEN
                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                        CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
                                          ELSE
                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                        CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                        END IF;
                                      ELSE
                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                    END IF;
                                  ELSE
                                    -- Para pagos que se haran en fin de mes
                                     IF (Par_PagoFinAni = PagoFinMes) THEN
                                         IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                            SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
                                            SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                        ELSE
                                            SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                        END IF;
                                    END IF;
                                END IF;
                              ELSE
                                     IF (Par_PagoCuota = PagoTrimestral ) THEN
                                        -- Para pagos que se haran cada 90 dias
                                         IF (Par_PagoFinAni != PagoFinMes) THEN

                                            IF(Par_DiaMesCap>28)THEN
                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
                                                SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                IF(Var_UltDia < Par_DiaMesCap)THEN
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

                                                ELSE
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                END IF;
                                            ELSE
                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                            END IF;
                                        ELSE
                                             IF (Par_PagoFinAni = PagoFinMes) THEN
                                                 IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                    SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
                                                    SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                ELSE
                                                    SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                END IF;
                                            END IF;
                                        END IF;
                                    ELSE
                                         IF (Par_PagoCuota = PagoTetrames ) THEN
                                             IF (Par_PagoFinAni != PagoFinMes) THEN
                                                IF(Par_DiaMesCap>28)THEN
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                                    SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                    IF(Var_UltDia < Par_DiaMesCap)THEN
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

                                                    ELSE
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                    END IF;
                                                ELSE
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                END IF;
                                            ELSE

                                                 IF (Par_PagoFinAni = PagoFinMes) THEN
                                                     IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                        SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
                                                        SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                    ELSE
                                                        SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                    END IF;
                                                END IF;
                                            END IF;

                                        ELSE
                                             IF (Par_PagoCuota = PagoSemestral ) THEN

                                                 IF (Par_PagoFinAni != PagoFinMes) THEN
                                                    IF(Par_DiaMesCap>28)THEN
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                                        SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                        IF(Var_UltDia < Par_DiaMesCap)THEN
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

                                                        ELSE
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                        END IF;
                                                    ELSE
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                    END IF;

                                                ELSE

                                                     IF (Par_PagoFinAni = PagoFinMes) THEN
                                                         IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                            SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
                                                            SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                        ELSE
                                                            SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                        END IF;
                                                    END IF;
                                                END IF;
                                            ELSE
                                                 IF (Par_PagoCuota = PagoAnual ) THEN

                                                    SET FechaFinal     := CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
                IF(Par_DiaHabilSig = Var_SI) THEN
                    CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                                        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                        Aud_NumTransaccion);
                  ELSE
                    CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                END IF;

			-- DIAS DE GRACIA
            WHILE ((CAST(DATEDIFF(FechaVig, FechaInicio) AS SIGNED)*1) <= Var_DiasExtra ) DO

                IF (Par_PagoCuota = PagoDecenal) THEN
                    IF (DAY(FechaFinal) = FrecDecenal) THEN
                        SET FechaFinal     := DATE_ADD(FechaFinal, INTERVAL FrecDecenal DAY);
                      ELSE
                        IF (DAY(FechaFinal) < 6 ) THEN
                            SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '10'),DATE);
                          ELSE
                            IF(DAY(FechaFinal) < 16 ) THEN
                                SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '20'),DATE);
                              ELSE
                                IF(DAY(FechaFinal) < 26 ) THEN
                                    SET FechaFinal := LAST_DAY(FechaFinal);
                                  ELSE
                                    SET FechaFinal := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                                END IF;
                            END    IF;
                        END IF;
                    END IF;
                  ELSE
                    IF (Par_PagoCuota = PagoQuincenal ) THEN
                        # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                        IF(Par_PagoFinAni <> 'D') THEN
                            IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
                                SET FechaFinal     := DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
                              ELSE
                                IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                        CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
                                  ELSE
                                    SET FechaFinal     := DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
                                    IF  (FechaFinal <= FechaInicio) THEN
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
                                    END IF;
                                END IF;
                            END IF;
                        ELSE
                            IF(Var_ManejaCalendario <> Var_SI) THEN
                                SET Var_1erDiaQuinc := Par_DiaMesCap;
                                SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                            END IF;
                            IF (DAY(FechaFinal) >= Var_2doDiaQuinc) THEN

                                SET FechaFinal  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                        CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);

                            ELSE
                                IF (DAY(FechaFinal) < Var_2doDiaQuinc) THEN
                                    IF(MONTH(FechaInicio) = 2  AND Var_2doDiaQuinc >28)THEN
                                        SET FechaFinal := LAST_DAY(FechaFinal);
                                    ELSE
                                        SET FechaFinal  :=  DATE(CONCAT(YEAR(FechaFinal),'-',MONTH(FechaFinal),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                    END IF;
                                END IF;

                            END IF;
                        END IF;
                      ELSE
                        IF (Par_PagoCuota = PagoMensual  ) THEN
                             IF (Par_PagoFinAni != PagoFinMes) THEN
                                IF(Par_DiaMesCap>28)THEN
                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                             CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                    SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                    IF(Var_UltDia < Par_DiaMesCap)THEN
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                             CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
                                      ELSE
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                             CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                        IF(DATEDIFF(FechaFinal,FechaInicio)>(Par_DiaMesCap+Cons_FrecExtDiasMensual)) THEN
                                            SET FechaFinal := LAST_DAY(FechaInicio);
                                        END IF;
                                    END IF;
                                  ELSE
                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                             CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                END IF;
                          ELSE
                            -- Para pagos que se haran cada fin de mes
                            IF (Par_PagoFinAni = PagoFinMes) THEN
                                IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
                                    SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
                                    SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                  ELSE
                                    -- si no indica que es un numero menor y se obtiene el final del mes.
                                    SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
                                END IF;
                            END IF;
                        END  IF ;
                      ELSE
                        IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
                            SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
                        END IF;
                    END IF;
                    END IF;
                END IF;

                IF(Par_DiaHabilSig = Var_SI) THEN
                    CALL DIASFESTIVOSCAL(FechaFinal,        Entero_Cero,        FechaVig,           Var_EsHabil,        Par_EmpresaID,
                                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                                        Aud_NumTransaccion);
                ELSE
                    CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                END IF;
            END WHILE;
            -- FIN DIA DE GRACIA

			/* si el valor de la fecha final es mayoy a la de vencimiento en se ajusta */
			IF (Par_AjustaFecAmo = Var_SI)THEN
                 IF (Par_FechaVenc <=  FechaFinal) THEN
                    SET FechaFinal     := Par_FechaVenc;
                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL(
                            FechaFinal,        Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                            Aud_NumTransaccion);
                    ELSE
                        CALL DIASHABILANTERCAL(
                            FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                    END IF;
                END IF;
                 IF (Contador = Var_Cuotas )THEN
                    SET FechaFinal     := Par_FechaVenc;
                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                                            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                            Aud_NumTransaccion);
                    ELSE
                        CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                    END IF;
                END IF;
            END IF;

            IF(Par_DiaHabilSig = Var_SI) THEN
                CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                                    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                    Aud_NumTransaccion);
            ELSE
                CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                    Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
            END IF;

			/* valida si se ajusta a fecha de exigibilidad o no*/
             IF (Par_AjusFecExiVen= Var_SI)THEN
                SET FechaFinal:= FechaVig;

            END IF;

            SET CapInt:= Var_Capital;

            SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1
                            FROM Tmp_Amortizacion);

            SET Fre_DiasTab        := (DATEDIFF(FechaFinal,FechaInicio));
             -- SE ASIGNA UN NUMERO DE DIAS FIJOS  ------------------------------------
            CASE Par_PagoCuota
                WHEN PagoSemanal        THEN SET Fre_DiasTab := 7;
                WHEN PagoCatorcenal     THEN SET Fre_DiasTab := 14;
                WHEN PagoQuincenal      THEN SET Fre_DiasTab := 15;
                WHEN PagoMensual        THEN SET Fre_DiasTab := 30;
            END CASE;
            -- FIN PARA ASIGNAR NUMERO DE DIAS FIJOS  --------------------------------



            IF(Contador = 1 AND Var_ManejaCalendario = Var_SI) THEN
				SET FechaFinal   := Var_FechaVenc;
				SET FechaInicio := Var_FechaInicioCre;
			END IF;

            IF(Contador = 2 AND Var_ManejaCalendario = Var_SI)THEN
				SET FechaInicio := Var_FechaVenc;
			END IF;

            INSERT INTO Tmp_Amortizacion(    Tmp_Consecutivo,     Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,    Tmp_Dias, Tmp_CapInt)
                            VALUES    (    Consecutivo,    FechaInicio,    FechaFinal,    FechaVig,    Fre_DiasTab, CapInt);

            SET FechaInicio := FechaFinal;/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/

            IF (Par_AjustaFecAmo = Var_SI)THEN
                 IF (Par_FechaVenc <=  FechaFinal) THEN
                    SET Contador     := Var_Cuotas+1;
                END IF;
            END IF;

            IF((Contador+1) = Var_Cuotas )THEN

        #Ajuste Saldo
        -- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
                IF (Par_AjustaFecAmo = Var_SI)THEN
                    SET FechaFinal     := Par_FechaVenc;
                ELSE
           -- pagos decenales
                      IF (Par_PagoCuota = PagoDecenal) THEN
                        IF (DAY(FechaInicio) = FrecDecenal) THEN
                            SET FechaFinal     := DATE_ADD(FechaInicio, INTERVAL FrecDecenal DAY);
                        ELSE
                            IF (DAY(FechaInicio) < 6 ) THEN
                                SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '10'),DATE);
                            ELSE
                                IF(DAY(FechaInicio) < 16 ) THEN
                                    SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '20'),DATE);
                                ELSE
                                    IF(DAY(FechaInicio) < 26 ) THEN
                                        SET FechaFinal := LAST_DAY(FechaInicio);
                                    ELSE
                                        SET FechaFinal := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                                    END IF;
                                END    IF;
                            END IF;
                        END IF;
                      ELSE
                -- pagos quincenales
                        IF (Par_PagoCuota = PagoQuincenal) THEN
                            # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                            IF(Par_PagoFinAni <> 'D') THEN
                                IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) = FrecQuin) THEN
                                    SET FechaFinal     := DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                                ELSE
                                    IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
                                    ELSE
                                        SET FechaFinal     := DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
                                        SET FechaFinal := LAST_DAY(FechaInicio);
                                        IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                        END IF;
                                    END IF;
                                END IF;
                            ELSE
                                IF(Var_ManejaCalendario <> Var_SI) THEN
                                    SET Var_1erDiaQuinc := Par_DiaMesCap;
                                    SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                END IF;
                                # Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
                                IF (DAY(FechaInicio) = Var_1erDiaQuinc) THEN
                                    IF(MONTH(FechaInicio) = 2  AND Var_2doDiaQuinc >28)THEN
                                        SET FechaFinal := LAST_DAY(FechaInicio);
                                    ELSE
                                        SET FechaFinal  := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                    END IF;

                                ELSE
                                    IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
                                        SET FechaFinal := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);
                                    ELSE
                                         -- SI ES FEBRERO Y  EL DIA QUINCENA ES 30 SE AJUSTA
                                        IF(MONTH(FechaInicio) = 2  AND Var_2doDiaQuinc >28)THEN
                                            SET FechaFinal := LAST_DAY(FechaInicio);
                                        ELSE
                                            SET FechaFinal := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                        END IF;

                                        IF(FechaFinal <= FechaInicio) THEN
                                            SET FechaFinal := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        ELSE         -- Pagos Mensuales
                             IF (Par_PagoCuota = PagoMensual) THEN
                        -- Para pagos que se haran cada 30 dias
                                 IF (Par_PagoFinAni != PagoFinMes) THEN
                                    IF(Par_DiaMesCap>28)THEN
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                        SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                        IF(Var_UltDia < Par_DiaMesCap)THEN
                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
                                        ELSE
                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);

                                            IF(DATEDIFF(FechaFinal,FechaInicio)>(Par_DiaMesCap+Cons_FrecExtDiasMensual)) THEN
                                                SET FechaFinal := LAST_DAY(FechaInicio);
                                            END IF;
                                        END IF;
                                    ELSE
                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                    END IF;
                                ELSE
                            -- Para pagos que se haran cada fin de mes
                                     IF (Par_PagoFinAni = PagoFinMes) THEN
                                         IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                            SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 2 MONTH),CHAR(12));
                                            SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                        ELSE
                                -- si no indica que es un numero menor y se obtiene el final del mes.
                                            SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                        END IF;
                                    END IF;
                                END IF;
                            ELSE
                                 IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
                                    SET FechaFinal     := DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
                                ELSE
                                     IF (Par_PagoCuota = PagoBimestral ) THEN
                                         IF (Par_PagoFinAni != PagoFinMes ) THEN
                                            IF(Par_DiaMesCap>28)THEN
                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                                SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                IF(Var_UltDia < Par_DiaMesCap)THEN
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

                                                ELSE
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                END IF;
                                            ELSE
                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                            END IF;
                                        ELSE
                                    -- Para pagos que se haran en fin de mes
                                             IF (Par_PagoFinAni = PagoFinMes) THEN
                                                 IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                    SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
                                                    SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                ELSE
                                                    SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                END IF;
                                            END IF;
                                        END IF;
                                    ELSE
                                         IF (Par_PagoCuota = PagoTrimestral ) THEN
                                    -- Para pagos que se haran cada 90 dias
                                             IF (Par_PagoFinAni != PagoFinMes) THEN
                                                IF(Par_DiaMesCap>28)THEN
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
                                                    SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                    IF(Var_UltDia < Par_DiaMesCap)THEN
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

                                                    ELSE
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                    END IF;
                                                ELSE
                                                    SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                END IF;
                                            ELSE
                                        -- Para pagos que se haran en fin de mes
                                                 IF (Par_PagoFinAni = PagoFinMes) THEN
                                                     IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                        SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
                                                        SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                    ELSE
                                                        SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                    END IF;
                                                END IF;
                                            END IF;

                                        ELSE
                                             IF (Par_PagoCuota = PagoTetrames ) THEN
                                        -- Para pagos que se haran cada 120 dias
                                                 IF (Par_PagoFinAni != PagoFinMes) THEN
                                                    IF(Par_DiaMesCap>28)THEN
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                                        SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                        IF(Var_UltDia < Par_DiaMesCap)THEN
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

                                                        ELSE
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                        END IF;
                                                    ELSE
                                                        SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                    END IF;
                                                ELSE
                                            -- Para pagos que se haran en fin de mes
                                                     IF (Par_PagoFinAni = PagoFinMes) THEN
                                                         IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                            SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
                                                            SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                        ELSE
                                                            SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                        END IF;
                                                    END IF;
                                                END IF;

                                            ELSE
                                                 IF (Par_PagoCuota = PagoSemestral ) THEN
                                                     IF (Par_PagoFinAni != PagoFinMes) THEN
                                                        IF(Par_DiaMesCap>28)THEN
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
                                                            SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
                                                            IF(Var_UltDia < Par_DiaMesCap)THEN
                                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

                                                            ELSE
                                                                SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                            END IF;
                                                        ELSE
                                                            SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
                                                        END IF;
                                                    ELSE
                                                -- Para pagos que se haran en fin de mes
                                                         IF (Par_PagoFinAni = PagoFinMes) THEN
                                                             IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
                                                                SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
                                                                SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
                                                            ELSE
                                                                SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
                                                            END IF;
                                                        END IF;
                                                    END IF;
                                                ELSE
                                                     IF (Par_PagoCuota = PagoAnual ) THEN
                                                        SET FechaFinal     := CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
                                                    END IF;
                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;

                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                                            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                            Aud_NumTransaccion);
                    ELSE
                        CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                    END IF;
-- DIAS DE GRACIA
                    WHILE ((DATEDIFF(FechaVig, FechaInicio)*1) <= Var_DiasExtra ) DO
						IF (Par_PagoCuota = PagoDecenal) THEN
							IF (DAY(FechaFinal) = FrecDecenal) THEN
								SET FechaFinal     := DATE_ADD(FechaFinal, INTERVAL FrecDecenal DAY);
							ELSE
								IF (DAY(FechaFinal) < 6 ) THEN
									SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '10'),DATE);
								ELSE
									IF(DAY(FechaFinal) < 16 ) THEN
										SET FechaFinal := CONVERT(    CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '20'),DATE);
									ELSE
										IF(DAY(FechaFinal) < 26 ) THEN
											SET FechaFinal := LAST_DAY(FechaFinal);
										ELSE
											SET FechaFinal := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '10'),DATE);
										END IF;
									END    IF;
								END IF;
							END IF;
						ELSE
							 IF (Par_PagoCuota = PagoQuincenal ) THEN
								# Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
								IF(Par_PagoFinAni <> 'D') THEN
									IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
										SET FechaFinal     := DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
									ELSE
										IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
											SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
										ELSE
											SET FechaFinal     := DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
											IF  (FechaFinal <= FechaInicio) THEN
												SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
											END IF;
										END IF;
									END IF;
								ELSE
                                    IF(Var_ManejaCalendario <> Var_SI) THEN
                                        SET Var_1erDiaQuinc := Par_DiaMesCap;
                                        SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                    END IF;
									# Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
									IF (DAY(FechaFinal) >= Var_2doDiaQuinc) THEN
                                        IF(MONTH(FechaFinal) = 2  AND Var_2doDiaQuinc >28)THEN
                                            SET FechaFinal := LAST_DAY(FechaFinal);
                                        ELSE
                                            SET FechaFinal  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);
                                        END IF;
									ELSE
										IF (DAY(FechaFinal) < Var_2doDiaQuinc) THEN
											SET FechaFinal  :=  DATE(CONCAT(YEAR(FechaFinal),'-',MONTH(FechaFinal),'-',LPAD(Var_2doDiaQuinc,2,'0')));
										END IF;

									END IF;
								END IF;
							ELSE
								 IF (Par_PagoCuota = PagoMensual  ) THEN
									 IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMesCap>28)THEN
											SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												 IF(DATEDIFF(FechaFinal,FechaInicio)>(Par_DiaMesCap+Cons_FrecExtDiasMensual)) THEN
													SET FechaFinal := LAST_DAY(FechaInicio);
												END IF;
											END IF;
										ELSE
											SET FechaFinal := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
								-- Para pagos que se haran cada fin de mes
										 IF (Par_PagoFinAni = PagoFinMes) THEN
											 IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
											ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
												SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
											END IF;
										END IF;
									END  IF ;
								ELSE
									 IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
										SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
									END IF;
								END IF;
							END IF;
						END IF;

						IF(Par_DiaHabilSig = Var_SI) THEN
							CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
												Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
												Aud_NumTransaccion);

						ELSE
							CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
												Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
						END IF;
                    END WHILE;
                END IF;
        -- Obtiene el dia habil siguiente o anterior
                IF(Par_DiaHabilSig = Var_SI) THEN
                    CALL DIASFESTIVOSCAL(    FechaFinal,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
                                        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                        Aud_NumTransaccion);

                ELSE
                    CALL DIASHABILANTERCAL(FechaFinal,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
                                        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
                END IF;

                 IF (Par_AjusFecExiVen= Var_SI)THEN
                    SET FechaFinal:= FechaVig;
                END IF;

                IF(Contador = 1 AND Var_ManejaCalendario = Var_SI) THEN
					SET FechaFinal   := Var_FechaVenc;
					SET FechaInicio := Var_FechaInicioCre;
				END IF;
				IF(Contador = 2 AND Var_ManejaCalendario = Var_SI)THEN
					SET FechaInicio := Var_FechaVenc;
				END IF;

                SET CapInt:= Var_Capital;
                SET Fre_DiasTab        := (DATEDIFF(FechaFinal,FechaInicio));
                 -- SE ASIGNA UN NUMERO DE DIAS FIJOS  ------------------------------------
                CASE Par_PagoCuota
                    WHEN PagoSemanal        THEN SET Fre_DiasTab := 7;
                    WHEN PagoCatorcenal     THEN SET Fre_DiasTab := 14;
                    WHEN PagoQuincenal      THEN SET Fre_DiasTab := 15;
                    WHEN PagoMensual        THEN SET Fre_DiasTab := 30;
                END CASE;
                -- FIN PARA ASIGNAR NUMERO DE DIAS FIJOS  --------------------------------


                INSERT INTO Tmp_Amortizacion(    Tmp_Consecutivo,     Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,    Tmp_Dias, Tmp_CapInt)
                            VALUES    (    Consecutivo+1,    FechaInicio,    FechaFinal,    FechaVig,    Fre_DiasTab, CapInt);
                 IF (Par_AjustaFecAmo = Var_SI)THEN
                     IF (Par_FechaVenc <=  FechaFinal) THEN
                        SET Contador     := Var_Cuotas+1;
                    END IF;
                END IF;
                SET Contador = Contador+1;
            END IF;
            SET Contador = Contador+1;

		END WHILE;
	-- FIN WHILE PARA OBTENER LAS FECHAS


    -- WHILE DE INTERES
		WHILE (ContadorInt <= Var_CuotasInt ) DO

				IF (Par_PagoInter = PagoDecenal) THEN
					IF (DAY(FechaInicioInt) = FrecDecenal) THEN
						SET FechaFinalInt     := DATE_ADD(FechaInicioInt, INTERVAL FrecDecenal DAY);
					ELSE
						IF ( DAY(FechaInicioInt) < 6 ) THEN
							SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaInicioInt) , '-' ,MONTH(FechaInicioInt), '-' , '10'),DATE);
						ELSE
							IF(DAY(FechaInicioInt) < 16 ) THEN
								SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaInicioInt) , '-' ,MONTH(FechaInicioInt), '-' , '20'),DATE);
							ELSE
								IF(DAY(FechaInicioInt) < 26 ) THEN
									SET FechaFinalInt := LAST_DAY(FechaInicioInt);
								ELSE
									SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
													MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)), '-' , '10'),DATE);
								END IF;
							END    IF;
						END IF;
					END IF;
				ELSE

					 IF (Par_PagoInter = PagoQuincenal) THEN
						# Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
						IF(Par_PagoFinAniInt <> 'D') THEN
							IF (DAY(FechaInicioInt) = FrecQuin) THEN
								SET FechaFinalInt     := DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
							ELSE
								IF (DAY(FechaInicioInt) >28) THEN
									SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)), '-' , '15'),DATE);
								ELSE
									SET FechaFinalInt     := DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
									IF  (FechaFinalInt <= FechaInicioInt) THEN
										SET FechaFinalInt := LAST_DAY(FechaInicioInt);
										IF(CAST(DATEDIFF(FechaFinalInt, FechaInicioInt)AS SIGNED)<Var_DiasExtra) THEN
											SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
																MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
										END IF;
									END    IF;
								END IF;
							END IF;
						ELSE
                            IF(Var_ManejaCalendario <> Var_SI) THEN
                                SET Var_1erDiaQuinc     := Par_DiaMesInt;
                                SET Var_2doDiaQuinc     := Var_1erDiaQuinc + FrecQuin;
                                SET Var_1erDiaQuincInt := Par_DiaMesInt;
                                SET Var_2doDiaQuincInt := Var_1erDiaQuinc + FrecQuin;
                            END IF;
							# Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
							IF (DAY(FechaInicioInt) = Var_1erDiaQuinc) THEN
                                IF(MONTH(FechaInicioInt) = 2  AND Var_2doDiaQuinc>28)THEN
                                    SET FechaFinalInt := LAST_DAY(FechaInicioInt);
                                ELSE
                                    SET FechaFinalInt := DATE(CONCAT(YEAR(FechaInicioInt),'-',MONTH(FechaInicioInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                END IF;

							ELSE
								IF (DAY(FechaInicioInt) >28) THEN
									SET FechaFinalInt := DATE(CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
															MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)), '-' , LPAD(Var_1erDiaQuinc,2,'0')));
								ELSE
									 -- SI ES FEBRERO Y  EL DIA QUINCENA ES 30 SE AJUSTA
                                    IF(MONTH(FechaInicioInt) = 2  AND Var_2doDiaQuinc >28)THEN
                                        SET FechaFinalInt := LAST_DAY(FechaInicioInt);
                                    ELSE
                                        SET FechaFinalInt := DATE(CONCAT(YEAR(FechaInicioInt),'-',MONTH(FechaInicioInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));

                                    END IF;

									IF(FechaFinalInt <= FechaInicioInt) THEN
										SET FechaFinalInt := DATE(CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),'-',
																MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),'-',
																LPAD(Var_1erDiaQuinc,2,'0')));
										IF(CAST(DATEDIFF(FechaFinalInt, FechaInicioInt)AS SIGNED)<Var_DiasExtra) THEN
											SET FechaFinalInt := DATE(CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
																MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')));
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					ELSE

						 IF (Par_PagoInter = PagoMensual) THEN

							 IF (Par_PagoFinAniInt != PagoFinMes) THEN
								IF(Par_DiaMesInt>28)THEN
									SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesInt)THEN
										SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
									ELSE
										SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
						-- Para pagos que se haran cada fin de mes
								 IF (Par_PagoFinAniInt = PagoFinMes) THEN
							/* obtiene el final del mes.*/
									SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
								END IF;
							END IF;
						ELSE
							 IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
								SET FechaFinalInt    := DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
							ELSE
								 IF ( Par_PagoInter = PagoBimestral) THEN
							-- Para pagos que se haran cada 60 dias Intereses
									 IF (Par_PagoFinAniInt != PagoFinMes ) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
								-- Para pagos que se haran en fin de mes
										 IF (Par_PagoFinAniInt = PagoFinMes) THEN
											 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinalInt    := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									 IF (Par_PagoInter = PagoTrimestral) THEN
								-- Para pagos que se haran cada 90 dias IntereseS
										 IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesInt)THEN
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
									-- Para pagos que se haran en fin de mes
											 IF (Par_PagoFinAniInt = PagoFinMes) THEN
												 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;
									ELSE
										 IF ( Par_PagoInter = PagoTetrames) THEN
									-- Para pagos que se haran cada 120 dias interes
											 IF (Par_PagoFinAniInt != PagoFinMes) THEN
												IF(Par_DiaMesInt>28)THEN
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesInt)THEN
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

													ELSE
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
										-- Para pagos que se haran en fin de mes
												 IF (Par_PagoFinAniInt = PagoFinMes) THEN
													 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;
										ELSE
											 IF (Par_PagoInter = PagoSemestral) THEN
										-- Para pagos que se haran cada 180 dias Interes
												 IF (Par_PagoFinAniInt != PagoFinMes) THEN
													IF(Par_DiaMesInt>28)THEN
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
														SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
														IF(Var_UltDia < Par_DiaMesInt)THEN
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

														ELSE
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
														END IF;
													ELSE
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
											-- Para pagos que se haran en fin de mes
													 IF (Par_PagoFinAniInt = PagoFinMes) THEN
														 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
														ELSE
															SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
														END IF;
													END IF;
												END IF;
											ELSE
												 IF ( Par_PagoInter = PagoAnual) THEN
											-- Para pagos que se haran cada 360 diasInteres
													SET FechaFinalInt    := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
												END IF;
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;

                IF(ContadorInt = 1 AND Var_ManejaCalendario = Var_SI) THEN
					SET FechaFinalInt   := Var_FechaVenc;
                    SET FechaInicioInt := Var_FechaInicioCre;
				END IF;
				IF(ContadorInt = 2 AND Var_ManejaCalendario = Var_SI)THEN
					SET FechaInicioInt := Var_FechaVenc;
				END IF;

				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
										Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
										Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
				END IF;

				-- DIAS DE GRACIA DE CALCULO DE INTERES
				WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_DiasExtra ) DO

					IF (Par_PagoInter = PagoDecenal) THEN
						IF (DAY(FechaFinalInt) = FrecDecenal) THEN
							SET FechaFinalInt     := DATE_ADD(FechaFinalInt, INTERVAL FrecDecenal DAY);
						ELSE
							IF (DAY(FechaFinalInt) < 6 ) THEN
								SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaFinalInt) , '-' ,MONTH(FechaFinalInt), '-' , '10'),DATE);
							ELSE
								IF(DAY(FechaFinalInt) < 16 ) THEN
									SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaFinalInt) , '-' ,MONTH(FechaFinalInt), '-' , '20'),DATE);
								ELSE
									IF(DAY(FechaFinalInt) < 26 ) THEN
										SET FechaFinalInt := LAST_DAY(FechaFinalInt);
									ELSE
										SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)) , '-' ,
													MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)), '-' , '10'),DATE);

									END IF;
								END    IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoInter = PagoQuincenal ) THEN
							# Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
							IF(Par_PagoFinAniInt <> 'D') THEN
								IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
									SET FechaFinalInt     := DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
								ELSE
									IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
										SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
									ELSE
										SET FechaFinalInt     := DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
										IF  (FechaFinalInt <= FechaInicioInt) THEN
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);

										END    IF;
									END IF;
								END IF;
							ELSE
                                IF(Var_ManejaCalendario <> Var_SI) THEN
                                    SET Var_1erDiaQuinc := Par_DiaMesInt;
                                    SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                END IF;
								# Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
								IF (DAY(FechaFinalInt) >= Var_2doDiaQuinc) THEN
                                    IF(MONTH(FechaFinalInt) = 2  AND Var_2doDiaQuinc>28)THEN
                                        SET FechaFinalInt := LAST_DAY(FechaFinalInt);
                                    ELSE
                                        SET FechaFinalInt  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                                CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);

                                    END IF;

								ELSE
									IF (DAY(FechaFinalInt) < Var_2doDiaQuinc) THEN
										SET FechaFinalInt  :=   DATE(CONCAT(YEAR(FechaFinalInt),'-',MONTH(FechaFinalInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));
									END IF;

								END IF;
							END IF;
						ELSE
				-- Pagos Mensuales
							 IF (Par_PagoInter = PagoMensual  ) THEN
								 IF (Par_PagoFinAniInt != PagoFinMes) THEN
									IF(Par_DiaMesInt>28)THEN
										SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesInt)THEN
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

										ELSE
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
							-- Para pagos que se haran cada fin de mes
									 IF (Par_PagoFinAniInt = PagoFinMes) THEN
										 IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
										ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
											SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
										END IF;
									END IF;
								END  IF ;
							ELSE
								 IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
									SET FechaFinalInt    := DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
								END IF;
							END IF;
						END IF;
					END IF;
					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,            Var_EsHabil,    Par_EmpresaID,
											Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
											Aud_NumTransaccion);
					ELSE
						CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
											Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
					END IF;
				END WHILE;
                -- FIN DIAS DE GRACIA DE CALCULO DE INTERES


                IF(ContadorInt = 1 AND Var_ManejaCalendario = Var_SI) THEN
					SET FechaFinalInt   := Var_FechaVenc;
				END IF;

				/*si la fecha final es mayor a la de vencimiento se ajusta */
				 IF (Par_AjustaFecAmo = Var_SI)THEN
					 IF (Par_FechaVenc <=  FechaFinalInt) THEN
						SET ContadorInt = Var_CuotasInt+1;
						SET FechaFinalInt     := Par_FechaVenc;
					END IF;
					 IF (ContadorInt = Var_CuotasInt )THEN
						SET FechaFinalInt     := Par_FechaVenc;
					END IF;
				END IF;

				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,            Var_EsHabil,    Par_EmpresaID,
										Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
										Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
				END IF;
		/* valida si se ajusta a fecha de exigibilidad o no*/
				IF(Par_AjusFecExiVen= Var_SI)THEN
					SET FechaFinalInt:= FechaVig;
				END IF;

				SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1 FROM Tmp_AmortizacionInt);
				SET CapInt:= Var_Interes;
				SET Fre_DiasIntTab        := (DATEDIFF(FechaFinalInt,FechaInicioInt));

				INSERT INTO Tmp_AmortizacionInt(
					Tmp_Consecutivo,     Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,    Tmp_Dias,
					Tmp_CapInt
				 ) VALUES (
					Consecutivo,    FechaInicioInt,    FechaFinalInt,    FechaVig,     Fre_DiasIntTab, CapInt);

				SET FechaInicioInt := FechaFinalInt;

				IF( (ContadorInt+1) = Var_CuotasInt )THEN
			#Ajuste Saldo
			-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
					 IF (Par_AjustaFecAmo = Var_SI)THEN
						SET FechaFinalInt    := Par_FechaVenc;
					ELSE
				-- pagos decenales
						  IF (Par_PagoInter = PagoDecenal) THEN
							IF (DAY(FechaInicioInt) = FrecDecenal) THEN
								SET FechaFinalInt     := DATE_ADD(FechaInicioInt, INTERVAL FrecDecenal DAY);
							ELSE
								IF (DAY(FechaInicioInt) < 6 ) THEN
									SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaInicioInt) , '-' ,MONTH(FechaInicioInt), '-' , '10'),DATE);
								ELSE
									IF(DAY(FechaInicioInt) < 16 ) THEN
										SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaInicioInt) , '-' ,MONTH(FechaInicioInt), '-' , '20'),DATE);
									ELSE
										IF(DAY(FechaInicioInt) < 26 ) THEN
											SET FechaFinalInt := LAST_DAY(FechaInicioInt);
										ELSE
											SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)), '-' , '10'),DATE);
										END IF;
									END    IF;
								END IF;
							END IF;
						  ELSE
					-- pagos quincenales
							IF (Par_PagoInter = PagoQuincenal) THEN
								# Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
								IF(Par_PagoFinAniInt <> 'D') THEN
									IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) = FrecQuin) THEN
										SET FechaFinalInt     := DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
									ELSE
										IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
										ELSE
											SET FechaFinalInt     := DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
											IF  (FechaFinalInt <= FechaInicioInt) THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
											END    IF;
										END IF;
									END IF;
								ELSE
                                    IF(Var_ManejaCalendario <> Var_SI) THEN
                                        SET Var_1erDiaQuinc := Par_DiaMesInt;
                                        SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                    END IF;
									# Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
									IF (DAY(FechaInicioInt) = Var_1erDiaQuinc) THEN
                                        IF(MONTH(FechaInicioInt) = 2  AND Var_2doDiaQuinc >28)THEN
                                            SET FechaFinalInt := LAST_DAY(FechaInicioInt);
                                        ELSE
                                            SET FechaFinalInt := DATE(CONCAT(YEAR(FechaInicioInt),'-',MONTH(FechaInicioInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                        END IF;

									ELSE
										IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
											SET FechaFinalInt := DATE(CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)) , '-' ,
																	MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)), '-' , LPAD(Var_1erDiaQuinc,2,'0')));
										ELSE
                                             -- SI ES FEBRERO Y  EL DIA QUINCENA ES 30 SE AJUSTA
                                            IF(MONTH(FechaInicioInt) = 2  AND Var_2doDiaQuinc >28)THEN
                                                SET FechaFinalInt := LAST_DAY(FechaInicioInt);
                                            ELSE
                                                SET FechaFinalInt := DATE(CONCAT(YEAR(FechaInicioInt),'-',MONTH(FechaInicioInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                            END IF;
											IF  (FechaFinalInt <= FechaInicioInt) THEN
												SET FechaFinalInt := DATE(CONCAT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),'-',
																MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),'-',
																LPAD(Var_1erDiaQuinc,2,'0')));
											END IF;
										END IF;
									END IF;
								END IF;
							ELSE

								 IF (Par_PagoInter = PagoMensual) THEN

									 IF (Par_PagoFinAniInt != PagoFinMes) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
											ELSE
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										 IF (Par_PagoFinAniInt = PagoFinMes) THEN
											 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE

												SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									 IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
										SET FechaFinalInt    := DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
									ELSE
										 IF ( Par_PagoInter = PagoBimestral) THEN

											 IF (Par_PagoFinAniInt != PagoFinMes ) THEN
												IF(Par_DiaMesInt>28)THEN
													SET FechaFinalInt := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesInt)THEN
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

													ELSE
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
										-- Para pagos que se haran en fin de mes
												 IF (Par_PagoFinAniInt = PagoFinMes) THEN
													 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinalInt    := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;
										ELSE
											 IF (Par_PagoInter = PagoTrimestral) THEN
										-- Para pagos que se haran cada 90 dias IntereseS
												 IF (Par_PagoFinAniInt != PagoFinMes) THEN
													IF(Par_DiaMesInt>28)THEN
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
														SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
														IF(Var_UltDia < Par_DiaMesInt)THEN
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

														ELSE
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
														END IF;
													ELSE
														SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
											-- Para pagos que se haran en fin de mes
													 IF (Par_PagoFinAniInt = PagoFinMes) THEN
														 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
														ELSE
															SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
														END IF;
													END IF;
												END IF;
											ELSE
												 IF ( Par_PagoInter = PagoTetrames) THEN

													 IF (Par_PagoFinAniInt != PagoFinMes) THEN
														IF(Par_DiaMesInt>28)THEN
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
															SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
															IF(Var_UltDia < Par_DiaMesInt)THEN
																SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

															ELSE
																SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
															END IF;
														ELSE
															SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
														END IF;
													ELSE

														 IF (Par_PagoFinAniInt = PagoFinMes) THEN
															 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
																SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
																SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
															ELSE
																SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
															END IF;
														END IF;
													END IF;
												ELSE
													 IF (Par_PagoInter = PagoSemestral) THEN

														 IF (Par_PagoFinAniInt != PagoFinMes) THEN
															IF(Par_DiaMesInt>28)THEN
																SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
																SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
																IF(Var_UltDia < Par_DiaMesInt)THEN
																	SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

																ELSE
																	SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
																END IF;
															ELSE
																SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
															END IF;
														ELSE

															 IF (Par_PagoFinAniInt = PagoFinMes) THEN
																 IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
																	SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
																	SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
																ELSE
																	SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
																END IF;
															END IF;
														END IF;
													ELSE
														 IF ( Par_PagoInter = PagoAnual) THEN
													-- Para pagos que se haran cada 360 diasInteres
															SET FechaFinalInt    := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
														END IF;
													END IF;
												END IF;
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
						IF(Par_DiaHabilSig = Var_SI) THEN
							CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
												Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
												Aud_NumTransaccion);
						ELSE
							CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
												Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
						END IF;
                        -- hace un ciclo para comparar los dias de gracia
						-- DIAS DE GRACIAS
                        WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_DiasExtra ) DO
						-- pagos decenales
							IF (Par_PagoInter = PagoDecenal) THEN
								IF (DAY(FechaFinalInt) = FrecDecenal) THEN
									SET FechaFinalInt     := DATE_ADD(FechaFinalInt, INTERVAL FrecDecenal DAY);
								ELSE
									IF (DAY(FechaFinalInt) < 6 ) THEN
										SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaFinalInt) , '-' ,MONTH(FechaFinalInt), '-' , '10'),DATE);
									ELSE
										IF(DAY(FechaFinalInt) < 16 ) THEN
											SET FechaFinalInt := CONVERT(    CONCAT(YEAR(FechaFinalInt) , '-' ,MONTH(FechaFinalInt), '-' , '20'),DATE);
										ELSE
											IF(DAY(FechaFinalInt) < 26 ) THEN
												SET FechaFinalInt := LAST_DAY(FechaFinalInt);
											ELSE
												SET FechaFinalInt := CONVERT(    CONCAT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)) , '-' ,
													MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)), '-' , '10'),DATE);
											END IF;
										END    IF;
									END IF;
								END IF;
							ELSE
								 IF (Par_PagoInter = PagoQuincenal ) THEN
									# Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
									IF(Par_PagoFinAniInt <> 'D') THEN
										IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
											SET FechaFinalInt     := DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
										ELSE
											IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
											ELSE
												SET FechaFinalInt     := DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
												IF  (FechaFinalInt <= FechaInicioInt) THEN
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																			CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
												END    IF;
											END IF;
										END IF;
									ELSE
                                        IF(Var_ManejaCalendario <> Var_SI) THEN
                                            SET Var_1erDiaQuinc := Par_DiaMesInt;
                                            SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                        END IF;
										# Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.

										IF (DAY(FechaFinalInt) >= Var_2doDiaQuinc) THEN

											SET FechaFinalInt  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																	CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);

										ELSE
											IF (DAY(FechaFinalInt) < Var_2doDiaQuinc) THEN
                                                IF(MONTH(FechaInicioInt) = 2  AND Var_2doDiaQuinc >28)THEN
                                                    SET FechaFinalInt := LAST_DAY(FechaFinalInt);
                                                ELSE
                                                    SET FechaFinalInt  :=   DATE(CONCAT(YEAR(FechaFinalInt),'-',MONTH(FechaFinalInt),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                                END IF;


											END IF;

										END IF;
									END IF;
								ELSE
									-- Pagos Mensuales
									 IF (Par_PagoInter = PagoMensual  ) THEN
										 IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesCap)THEN
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

												ELSE
													SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												SET FechaFinalInt := CONVERT(    CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
									-- Para pagos que se haran cada fin de mes
											 IF (Par_PagoFinAniInt = PagoFinMes) THEN
												 IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
												ELSE
										-- si no indica que es un numero menor y se obtiene el final del mes.
													SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
												END IF;
											END IF;
										END  IF ;
									ELSE
										 IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico ) THEN
											SET FechaFinalInt    := DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
										END IF;
									END IF;
								END IF;
							END IF;

							IF(Par_DiaHabilSig = Var_SI) THEN
								CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
																Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
																Aud_NumTransaccion);
							ELSE
								CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
													Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
							END IF;

						END WHILE;
                        -- FIN DIAS DE GRACIAS
					END IF;

					-- Obtiene el dia habil siguiente o anterior
					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(    FechaFinalInt,    Entero_Cero,        FechaVig,        Var_EsHabil,        Par_EmpresaID,
											Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
											Aud_NumTransaccion);
					ELSE
						CALL DIASHABILANTERCAL(FechaFinalInt,        Entero_Cero,            FechaVig,        Par_EmpresaID,    Aud_Usuario,
											Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,    Aud_Sucursal,        Aud_NumTransaccion);
					END IF;

					SET CapInt:= Var_Interes;
					/* valida si se ajusta a fecha de exigibilidad o no*/
					 IF (Par_AjusFecExiVen= Var_SI)THEN
						SET FechaFinalInt:= FechaVig;
					END IF;

					IF(ContadorInt = 1 AND Var_ManejaCalendario = Var_SI) THEN
						SET FechaInicioInt	:= Var_FechaInicioCre;
						SET FechaFinalInt 	:= Var_FechaVenc;
					END IF;

					SET Fre_DiasIntTab    := (DATEDIFF(FechaFinalInt,FechaInicioInt));
					INSERT INTO Tmp_AmortizacionInt(    Tmp_Consecutivo,     Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,    Tmp_Dias,    Tmp_CapInt)
								VALUES    (    Consecutivo+1,    FechaInicioInt,    FechaFinalInt,    FechaVig,     Fre_DiasIntTab,    CapInt);
					SET ContadorInt = ContadorInt+1;
				END IF;


				SET ContadorInt = ContadorInt+1;
		END WHILE;
		-- FINALIZA WHILE DE INTERES

        -- INICIALIZO VARIABLES DE CONTROL
        SET Contador := 1;
        SET ContadorCap := 1;
        SET ContadorInt := 1;
        SET Consecutivo := 1;


		-- COMPARO EL NUMERO DE LAS CUOTAS PARA SABER CUAL ES LA MAYOR
		IF(Var_Cuotas >= Var_CuotasInt) THEN
            SET Var_Amor := Var_Cuotas;
        ELSE
            SET Var_Amor := Var_CuotasInt;
        END IF;
        SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicio, FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = Contador;
        SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicioInt, FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

		-- INICIO UN CICLO PARA REACOMODAR LAS FECHAS PARA GENERAR UN CALENDARIO PARA MOSTRAR AL CLIENTE
        WHILE (Contador <= Var_Amor) DO

            /*IF(Contador = 1 AND Var_ManejaCalendario = Var_SI) THEN
				SET FechaFinal   	:= Var_FechaVenc;
				SET FechaInicio 	:= Var_FechaInicioCre;
				SET FechaInicioInt	:= Var_FechaInicioCre;
                SET FechaFinalInt	:= Var_FechaVenc;
			END IF;

			IF(Contador = 2 AND Var_ManejaCalendario = Var_SI)THEN
				SET FechaInicio := Var_FechaVenc;
                SET FechaInicioInt	:= Var_FechaVenc;
			END IF;*/

             IF (FechaFinal<FechaFinalInt)THEN
                SET Fre_Dias        := (DATEDIFF(FechaFinal,FechaInicio));

                 IF (ContadorInt = Var_CuotasInt)THEN
                    SET Var_TipoCap    := Var_CapInt;
                ELSE
                    SET Var_TipoCap    := Var_Capital;
                END IF;

                INSERT INTO TMPPAGAMORSIM (
                        Tmp_Consecutivo,        Tmp_Dias,    Tmp_FecIni,        Tmp_FecFin,    Tmp_FecVig,
                        Tmp_CapInt,            NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                SELECT    Consecutivo,        Fre_Dias,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                        Var_TipoCap,        Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                FROM    Tmp_Amortizacion
                WHERE Tmp_Consecutivo = ContadorCap;

                SET FechaInicio := FechaFinal;

                 IF (ContadorInt <= Var_CuotasInt)THEN
                     IF (ContadorInt>1)THEN SET ContadorInt := ContadorInt-1;ELSE SET ContadorInt :=0 ; END IF;
                END IF;
            ELSE
                 IF (FechaFinal=FechaFinalInt)THEN
                    SET Fre_Dias        := (DATEDIFF(FechaFinal,FechaInicio));

                    INSERT INTO TMPPAGAMORSIM (
                            Tmp_Consecutivo,    Tmp_Dias,    Tmp_FecIni,        Tmp_FecFin,    Tmp_FecVig,
                            Tmp_CapInt,            NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                    SELECT    Consecutivo,        Fre_Dias,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                            Var_CapInt,            Aud_NumTransaccion,Par_MontoSeguroCuota, Var_IVASeguroCuota
                    FROM    Tmp_Amortizacion
                    WHERE Tmp_Consecutivo = ContadorCap;
                    SET FechaInicio := FechaFinal;
                ELSE
                     IF (FechaFinal> FechaFinalInt)THEN

                        SET Fre_DiasInt        := (DATEDIFF(FechaFinalInt,FechaInicio));
                         IF (ContadorInt = Var_CuotasInt)THEN
                            SET Var_TipoCap    := Var_CapInt;
                        ELSE
                            SET Var_TipoCap    := Var_Interes;
                        END IF;

                        INSERT INTO TMPPAGAMORSIM (
                                Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                Tmp_CapInt,            NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                        SELECT     Consecutivo,        Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,

                                Tmp_CapInt ,        Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                        FROM    Tmp_AmortizacionInt
                        WHERE    Tmp_Consecutivo = ContadorInt;

                         IF (ContadorCap <= Var_Cuotas)THEN
                             IF (ContadorCap>1)THEN SET ContadorCap := ContadorCap-1;ELSE SET ContadorCap :=0 ; END IF;
                        END IF;
                        SET FechaInicio := FechaFinalInt;
                    END IF;
                END IF;
            END IF;

            SET Contador := Contador+1;
            SET ContadorCap := ContadorCap+1;
            SET ContadorInt := ContadorInt+1;
            SET Consecutivo := Consecutivo+1;

             IF (Contador>Var_Amor) THEN
                 IF (ContadorCap < Var_Cuotas) THEN
                    SET Contador:= ContadorCap;
                ELSE  IF (ContadorInt < Var_CuotasInt) THEN
                        SET Contador:= ContadorInt;
                    END IF;
                END IF;
            END IF;

             IF (ContadorCap <= Var_Cuotas) THEN
                SELECT Tmp_FecFin INTO  FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
                ELSE SET FechaFinal:= '2100-12-31';
            END IF;
             IF (ContadorInt <= Var_CuotasInt)THEN
                SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
            ELSE
                SET FechaFinalInt:= '2100-12-31';
            END IF;


        END WHILE;


	-- AJUSTE DE FECHAS, INSERTA EL ULTIMO REGISTRO DE LA TABLA.
	IF (ContadorCap = Var_Cuotas) THEN /* si el contador de capital es = al numero de cuotas consideradas */
    IF(ContadorInt = Var_CuotasInt) THEN /* si el contador de interes  es = al numero de cuotas de interes  consideradas */
                SELECT  Tmp_FecFin INTO FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo =ContadorCap;
                SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

         IF (FechaFinal<FechaFinalInt)THEN/* si la fecha final  de capital es menor que la de  interes  */
                    SET Fre_Dias        := (DATEDIFF(FechaFinal,FechaInicio));
                    INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,    Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                            Tmp_CapInt,        NumTransaccion,   Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                        SELECT Consecutivo,    Fre_Dias,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                            FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
                    SET FechaInicio := FechaFinal;
                    SET Fre_DiasInt        := (DATEDIFF(FechaFinalInt,FechaInicio));
                    SET Consecutivo := Consecutivo+1;
                    INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                            Tmp_CapInt,         NumTransaccion,   Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                                SELECT     Consecutivo,    Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                        Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                                    FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
        ELSE /* si la fecha final  de capital no  es menor que la de  interes  */
                     IF (FechaFinal=FechaFinalInt)THEN
                        SET Fre_Dias        := (DATEDIFF(FechaFinal,FechaInicio));
                        INSERT INTO     TMPPAGAMORSIM (    Tmp_Consecutivo,    Tmp_Dias,    Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                                    Tmp_CapInt,        NumTransaccion)
                            SELECT    Consecutivo,    Fre_Dias,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                    Var_CapInt,    Aud_NumTransaccion
                                FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
                        SET Fre_DiasInt        := (DATEDIFF(FechaFinalInt,FechaInicio));
                        SET FechaInicio := FechaFinal;
                        SET Consecutivo := Consecutivo+1;
                        INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                                Tmp_CapInt,        NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                                    SELECT     Consecutivo,    Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                            Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                                        FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
                    END IF;
        END IF; /* fin de si la fecha final  de capital es menor que la de  interes  */

                 IF (FechaFinal> FechaFinalInt)THEN
                    SET Fre_DiasInt        := (DATEDIFF(FechaFinalInt,FechaInicio));
                    INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                            Tmp_CapInt,        NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                                SELECT     Consecutivo,    Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                        Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                                    FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
                    SET FechaInicio := FechaFinal;
                    SET Consecutivo := Consecutivo+1;
                    INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                            Tmp_CapInt,        NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                                    SELECT     Consecutivo,    Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                            Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                                        FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
                END IF;
    ELSE /* si el contador de interes  no es igual al numero de cuotas de interes  consideradas */
                SET Fre_Dias        := (DATEDIFF(FechaFinal,FechaInicio));
                INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,    Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                        Tmp_CapInt,        NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                    SELECT Consecutivo,    Fre_Dias,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                            Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                        FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
                SET FechaInicio := FechaFinal;
            END IF;
        ELSE
            IF(ContadorInt = Var_CuotasInt) THEN
                SET Fre_DiasInt        := (DATEDIFF(FechaFinalInt,FechaInicio));
                    INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,    Tmp_Dias,        Tmp_FecIni,    Tmp_FecFin,    Tmp_FecVig,
                                            Tmp_CapInt,        NumTransaccion,  Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                                SELECT     Consecutivo,    Fre_DiasInt,    FechaInicio,    Tmp_FecFin,    Tmp_FecVig,
                                        Var_CapInt,    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota
                                    FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
            END IF;

        END IF;


	-- INICIO UN CICLO PARA CALCULO DE CAPITAL Y/O  INTERESES
	SET Contador := 1;
	SELECT MAX(Tmp_Consecutivo) INTO ContadorInt FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion ;
	WHILE (Contador <= ContadorInt) DO
		SELECT Tmp_InteresAco INTO  Var_InteresAco FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador-1 AND NumTransaccion = Aud_NumTransaccion ;
		SELECT Tmp_Dias, Tmp_CapInt INTO Fre_Dias, CapInt FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion = Aud_NumTransaccion ;

		SELECT COUNT(Tmp_CapInt) INTO NumCapInt FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;

		SET NumCapInt       := IFNULL(NumCapInt, Entero_Cero);
		SET Var_InteresAco  := IFNULL(Var_InteresAco, Entero_Cero);

		IF(NumCapInt > Entero_Cero)THEN
			SET Garantia    := Par_MontoGL / NumCapInt;
		ELSE
			SET Garantia    := Entero_Cero;
		END IF;

		IF (CapInt= Var_Interes) THEN
			SET Interes        := ROUND(((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco,2);
			SET Capital        := Decimal_Cero;
			SET Var_InteresAco := Entero_Cero;
		ELSE
			 IF (CapInt= Var_CapInt) THEN
				SET Interes    := ROUND(((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco,2);

				IF(Var_Cuotas > Entero_Cero)THEN
					SET Capital    := ROUND(Par_Monto / Var_Cuotas,2);
				ELSE
					SET Capital    := Entero_Cero;
				END IF;

				SET Var_InteresAco := Entero_Cero;
			ELSE
				SET Interes        := Decimal_Cero;

				IF(Var_Cuotas > Entero_Cero)THEN
					SET Capital    := ROUND(Par_Monto / Var_Cuotas,2);
				ELSE
					SET Capital    := Entero_Cero;
				END IF;

				SET Var_InteresAco := ROUND(((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco,2);
			END IF;
		END IF;

-- verifica si el producto de credito y el cliente pagan iva
		 IF (Var_PagaIVA = Var_Si) THEN
			SET IvaInt    := ROUND(Interes * Var_IVA,2);
		ELSE
			SET IvaInt := Decimal_Cero;
		END IF;

		SET Subtotal    := ROUND(Capital + Interes + IvaINT+Par_MontoSeguroCuota+Var_IVASeguroCuota + 1000,2);

		 IF (Insoluto<=Capital) THEN
			SET Capital := Insoluto;
		END IF;
		SET Insoluto    := ROUND(Insoluto - Capital,2);

		SET CuotaSinIva := ROUND(Capital + Interes,2);
		SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,CuotaSinIva,',');
		UPDATE TMPPAGAMORSIM SET
			Tmp_Capital    = Capital,
			Tmp_Interes    = Interes,
			Tmp_iva        = IvaInt,
			Tmp_SubTotal    = Subtotal,
			Tmp_Insoluto    = Insoluto,
			Tmp_InteresAco    = Var_InteresAco
		WHERE Tmp_Consecutivo = Contador
		AND     NumTransaccion = Aud_NumTransaccion;

-- si el insoluto es Cero ya no se sigen calculando montos
		IF(Insoluto = Entero_Cero) THEN
			SET Contador := ContadorInt+1;
		END IF;

		IF((Contador+1) = ContadorInt)THEN
			SELECT Tmp_Insoluto, Tmp_InteresAco INTO Insoluto, Var_InteresAco FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion=Aud_NumTransaccion;
			SET Contador = Contador+1;
			SELECT Tmp_Dias, Tmp_CapInt INTO Fre_Dias, CapInt FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion = Aud_NumTransaccion ;
			IF(IFNULL(Var_InteresAco, Entero_Cero))= Entero_Cero  THEN
				SET Var_InteresAco := Entero_Cero;
			END IF;
			#Ajuste
			 IF (CapInt= Var_Interes) THEN
				IF(Var_Cuotas > Entero_Cero)THEN
					SET Capital    := ROUND(Par_Monto / Var_Cuotas,2);
				ELSE
					SET Capital    := Entero_Cero;
				END IF;

				SET Capital    := Insoluto + Capital;
				SET Subtotal   := Insoluto + Subtotal;
				UPDATE TMPPAGAMORSIM SET
					Tmp_Capital    = Capital,
					Tmp_SubTotal    = Subtotal,
					Tmp_Insoluto    = Insoluto-Insoluto
				WHERE Tmp_Consecutivo = Contador-1
				AND NumTransaccion=Aud_NumTransaccion;

				SET Interes        := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				SET Capital        := Decimal_Cero;
				SET Var_InteresAco := Entero_Cero;
			ELSE
				 IF (CapInt= Var_CapInt) THEN
					SET Interes    := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
					SET Capital    := Insoluto;
					SET Var_InteresAco := Entero_Cero;
				ELSE
					SET Interes    := Decimal_Cero;
					SET Capital    := Insoluto;
					SET Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				END IF;
				 IF (Insoluto<=Capital) THEN
					SET Capital := Insoluto;
				END IF;
				SET Insoluto    := Insoluto - Capital;

		-- verifica si el producto de credito y el cliente pagan iva
				 IF (Var_PagaIVA = Var_Si) THEN
					SET IvaInt    := Interes * Var_IVA;
				ELSE
					SET IvaInt := Decimal_Cero;
				END IF;

				SET Subtotal    := Capital + Interes + IvaInt + 50000;

				SET CuotaSinIva := Capital + Interes;

				SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,CuotaSinIva);
				UPDATE TMPPAGAMORSIM SET
					Tmp_Capital    = Capital,
					Tmp_Interes    = Interes,
					Tmp_iva        = IvaInt,
					Tmp_SubTotal    = Subtotal,
					Tmp_Insoluto    = Insoluto,
					Tmp_InteresAco    = Var_InteresAco,
					Tmp_MontoSeguroCuota = Par_MontoSeguroCuota,
					Tmp_IVASeguroCuota = Var_IVASeguroCuota
				WHERE Tmp_Consecutivo = Contador
				AND NumTransaccion=Aud_NumTransaccion;

			END IF;
		END IF;
		SET Contador = Contador+1;
	END WHILE;


	SELECT Tmp_Consecutivo INTO Consecutivo FROM TMPPAGAMORSIM WHERE Tmp_Insoluto = Entero_Cero AND NumTransaccion=Aud_NumTransaccion;
	DELETE FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo > Consecutivo AND NumTransaccion=Aud_NumTransaccion;

	SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
	SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);





	SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE     NumTransaccion = Aud_NumTransaccion);


	IF(Var_CobraAccesoriosGen = Var_SI AND Var_CobraAccesorios = Var_SI) THEN

		SELECT  SolicitudCreditoID,     CreditoID,      PlazoID,        TipoFormaCobro
		INTO    Var_SolicitudCreditoID, Var_CreditoID,  Var_PlazoID,    Var_TipoFormaCobro
		FROM DETALLEACCESORIOS
		WHERE NumTransacSim = Aud_NumTransaccion
		AND MontoAccesorio = Decimal_Cero LIMIT 1;

		SET Var_SolicitudCreditoID  := IFNULL(Var_SolicitudCreditoID, Entero_Cero);
		SET Var_CreditoID           := IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_PlazoID             := IFNULL(Var_PlazoID, Entero_Cero);
		SET Var_TipoFormaCobro      := IFNULL(Var_TipoFormaCobro, Cadena_Vacia);

		IF(Var_TipoFormaCobro = FormaFinanciado) THEN
			# SE DAN DE ALTA LOS ACCESORIOS COBRADOS POR EL CREDITO PARA GRABARLOS DEFINITIVAMENTE
			CALL DETALLEACCESORIOSALT(
				Var_CreditoID,          Var_SolicitudCreditoID,     Par_ProducCreditoID,        Par_ClienteID,          Aud_NumTransaccion,
				Var_PlazoID,            OperaSimulador,             Par_Monto,                  Par_ConvenioNominaID,   Var_No,
                Par_NumErr,             Par_ErrMen,                 Par_EmpresaID,              Aud_Usuario,            Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,               Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			# SE CALCULA EL VALOR DE LAS COMISIONES COBRADAS POR EL CREDITO
			CALL CALCOTRASCOMISIONESPRO(
				Aud_NumTransaccion,     Par_ClienteID,      Par_ProducCreditoID,        Par_Monto,          Var_No,
				Par_NumErr,             Par_ErrMen,         Par_EmpresaID,              Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,               Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END IF;



    IF(Par_PagoCuota = 'U' AND Par_PagoInter = 'U') THEN

        CALL CALCULARCATPAGUNIPRO(
            Par_Monto,      Par_Monto,      Var_FrecuPago,      Var_No,     Par_ProducCreditoID,
                    Par_ClienteID,      Par_Tasa,       Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);

    ELSEIF(Par_PagoCuota = PagoPeriodo AND Par_PagoInter = PagoPeriodo) THEN
            CALL CALCULARCATPAGLIBPRO(
                Par_Monto,          Var_CoutasAmor, Var_FrecuPago,  Var_No,         Par_ProducCreditoID,
                Par_ClienteID,      Par_ComAper,    Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);
    ELSE

         CALL CALCULARCATPRO(
                    Par_Monto,      Var_CoutasAmor,     Var_FrecuPago,      Var_No,     Par_ProducCreditoID,
                    Par_ClienteID,      Par_ComAper,        Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);
    END IF;

	SELECT  SUM(Tmp_Capital),           SUM(Tmp_Interes),   SUM(Tmp_Iva),       SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota),
			SUM(Tmp_OtrasComisiones),   SUM(Tmp_IVAOtrasComisiones)
	INTO     Var_TotalCap,              Var_TotalInt,       Var_TotalIva,       Var_TotalSeguroCuota,       Var_TotalIVASeguroCuota,
			Var_SaldoOtrasComisiones,   Var_SaldoIVAOtrasComisiones
		FROM TMPPAGAMORSIM
		WHERE   NumTransaccion = Aud_NumTransaccion;

	SELECT SUM(Tmp_Capital),            SUM(Tmp_Interes),               SUM(Tmp_Iva), SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota),
	SUM(Tmp_OtrasComisiones),           SUM(Tmp_IVAOtrasComisiones)
		INTO Var_TotalCap,              Var_TotalInt,                   Var_TotalIva, Var_TotalSeguroCuota, Var_TotalIVASeguroCuota,
			Var_SaldoOtrasComisiones,   Var_SaldoIVAOtrasComisiones
		FROM TMPPAGAMORSIM
		WHERE   NumTransaccion = Aud_NumTransaccion;
	SET Var_TotalSeguroCuota            := IFNULL(Var_TotalSeguroCuota,Decimal_Cero);
	SET Var_TotalIVASeguroCuota         := IFNULL(Var_TotalIVASeguroCuota, Decimal_Cero);
	SET Var_SaldoOtrasComisiones        := IFNULL(Var_SaldoOtrasComisiones, Decimal_Cero);
	SET Var_SaldoIVAOtrasComisiones     := IFNULL(Var_SaldoIVAOtrasComisiones, Decimal_Cero);


	SET Par_NumErr     := 0;
	SET Par_ErrMen     := 'Cuotas generadas';
	SET Par_NumTran    := Aud_NumTransaccion;
	SET Par_Cat        := Var_CAT;
	SET Par_Cuotas     := Var_Cuotas;
	SET Par_CuotasInt    := Var_CuotasInt;
	SET Par_MontoCuo     := Entero_Cero;
	SET Par_FechaVen     := Par_FechaVenc;

	 DROP TABLE Tmp_Amortizacion;
	 DROP TABLE Tmp_AmortizacionInt;
    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        IF(Par_NumErr = Entero_Cero) THEN
            SELECT    Tmp_Consecutivo,                        Tmp_FecIni,                    Tmp_FecFin,                            Tmp_FecVig,                            FORMAT(Tmp_Capital,2)AS Tmp_Capital,
                    FORMAT(Tmp_Interes,2)AS Tmp_Interes,    FORMAT(Tmp_Iva,2)AS Tmp_Iva,    FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal ,    FORMAT(Tmp_Insoluto,2)AS Tmp_Insoluto,    Tmp_Dias,
                    Tmp_CapInt,                            Var_Cuotas,                    Var_CuotasInt,                         NumTransaccion,                         Var_CAT,
                    Par_FechaVenc,                        Par_FechaInicio,                 FORMAT(Tmp_SubTotal,2) AS MontoCuota,
                    FORMAT(Var_TotalCap,2) AS TotalCap,
                    FORMAT(Var_TotalInt,2) AS TotalInt,
                    FORMAT(Var_TotalIva,2) AS TotalIva,
                    Par_CobraSeguroCuota AS CobraSeguroCuota,
                    Tmp_MontoSeguroCuota AS MontoSeguroCuota,
                    Tmp_IVASeguroCuota AS IVASeguroCuota,
                    Var_TotalSeguroCuota AS TotalSeguroCuota,
                    Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
                    Tmp_OtrasComisiones AS OtrasComisiones,
                    Tmp_IVAOtrasComisiones  AS IVAOtrasComisiones,
                    Var_SaldoOtrasComisiones AS TotalOtrasComisiones,
                    Var_SaldoIVAOtrasComisiones AS TotalIVAOtrasComisiones,
                    IFNULL(Var_1erDiaQuinc,0) AS 1erDiaQuincCap,
                    IFNULL(Var_1erDiaQuincInt,0) AS 1erDiaQuincInt,
                    IFNULL(Var_2doDiaQuinc,0) AS 2doDiaQuincCap,
                    IFNULL(Var_2doDiaQuincInt,0) AS 2doDiaQuincInt,
                    IFNULL(Par_DiaMesCap,0) AS DiaMesCap,
                    IFNULL(Par_DiaMesInt,0) AS DiaMesInt,
                    Par_NumErr AS NumErr,
                    Par_ErrMen AS ErrMen
                FROM    TMPPAGAMORSIM
                WHERE NumTransaccion=Aud_NumTransaccion;
        END IF;
    END IF;
END TerminaStore$$
