-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSCONTPRO`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSCONTPRO`(
    # =====================================================================================
    # ----- STORE PARADAR DE ALTA CREDITOS CONTINGENTES --
    # =====================================================================================
    Par_CreditoID           BIGINT(12),             -- ID del credito
    Par_Fecha               DATE,                   -- Fecha de Operacion
    Par_Monto               DECIMAL(14,2),          -- Saldo del credito
    Par_AltaEncPoliza       CHAR(1),                -- Indica si tendra encabezado de poliza
    Par_PolizaID            BIGINT(12),             -- ID de la poliza
    Par_GarantiaID          INT(11),                -- ID de garantia fira

    Par_Salida              CHAR(1),                -- indica una salida
    INOUT   Par_NumErr      INT(11),                -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

    Par_EmpresaID           INT(11),                -- parametros de auditoria
    Aud_Usuario             INT(11),                -- parametros de auditoria
    Aud_FechaActual         DATETIME ,              -- parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),            -- parametros de auditoria
    Aud_ProgramaID          VARCHAR(70),            -- parametros de auditoria
    Aud_Sucursal            INT(11),                -- parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)              -- parametros de auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_FechaSis            DATE;               -- Fecha del sistema
    DECLARE Var_CreditoID           BIGINT(12);         -- ID del credito
    DECLARE Var_CuentaID            BIGINT(12);         -- ID de la cuenta
    DECLARE Var_ClienteID           INT(11);            -- Id del cliente
    DECLARE Var_Poliza              BIGINT(12);         -- Numero de Poliza
    DECLARE Var_Consecutivo         BIGINT(12);         -- Consecutivo
    DECLARE Var_TipoPrepago         CHAR(1);            -- Tipo de prepago
    DECLARE Var_FechaVen            DATE;               -- Fecha de vencimiento
    DECLARE Var_ConSim              INT(11);            -- Consecutivo de simulador
    DECLARE Var_Control             VARCHAR(50);        -- Variable de control.
    DECLARE Var_Producto            INT(11);            -- producto de credito
    DECLARE Var_Moneda              INT(11);            -- id de la moneda de la cuenta
    DECLARE Var_FacMora             DECIMAL(12,2);      -- factor mora
    DECLARE Var_CalcInter           INT(11);            -- calculo de intereses
    DECLARE Var_TasaFija            DECIMAL(12,4);      -- tasa fija
    DECLARE Var_TasaBase            DECIMAL(12,4);      -- tasa base
    DECLARE Var_SobreTasa           DECIMAL(12,4);      -- sobre tasa
    DECLARE Var_PisoTasa            DECIMAL(12,4);      -- piso de la tasa
    DECLARE Var_TechTasa            DECIMAL(12,4);      -- techo de la tasa
    DECLARE Var_FrecCap             CHAR(1);            -- frecuencia del capital
    DECLARE Var_PeriodCap           INT(11);            -- periodicidad del capital
    DECLARE Var_FrecInter           CHAR(1);            -- frecuencia de los intereses
    DECLARE Var_PeriodInt           INT(11);            -- periodo de intereses
    DECLARE Var_TipoPagCap          CHAR(1);            -- tipo de pago capital
    DECLARE Var_NumAmorti           INT(11);            -- numero de amortizaciones
    DECLARE Var_FechInha            CHAR(1);            -- fecha inhabil
    DECLARE Var_CalIrreg            CHAR(1);            -- calendario irregular
    DECLARE Var_AjFeUlVA            CHAR(1);            -- ajuste de fecha ultimo vencimiento
    DECLARE Var_AjFecExV            CHAR(1);            -- ajuste de fecha exigible
    DECLARE Var_NumTrSim            BIGINT(20);         -- numero transaccion amortizacion
    DECLARE Var_TipoFond            CHAR(1);            -- tipo de fondeador Fira
    DECLARE Var_MonComA             DECIMAL(12,4);      -- monto de comision por apertura
    DECLARE Var_IVAComA             DECIMAL(12,4);      -- monto iva comision por apertura
    DECLARE Var_CAT                 DECIMAL(12,4);      -- valor del cat
    DECLARE Var_CATReal             DECIMAL(12,4);      -- valor cat REAL
    DECLARE Var_Plazo               VARCHAR(20);        -- ID del plazo
    DECLARE Var_TipoDisper          CHAR(1);            -- tipo de dispersion
    DECLARE Var_DestCred            INT(11);            -- destino del credito
    DECLARE Var_TipoCalIn           INT(11);            -- tipo de calculo de intereses
    DECLARE Var_NumAmoInt           INT(11);            -- numero amortizaciones interes
    DECLARE Var_ClasiDestinCred     CHAR(1);            -- clasificacion del credito
    DECLARE Var_FechaCobroComision  DATE;               -- Fecha de cobro de la comision por apertura
    DECLARE Var_LineaCreditoID      INT(11);            -- linea del credito
    DECLARE Var_FechaVencimien      DATE;               -- fecha de vencimiento
    DECLARE Var_PeriodicidadInt     INT(11);            -- periodicidad INT
    DECLARE Var_LineaFondeoID       INT(11);            -- ID linea de fondeo
    DECLARE Var_InstitutFondID      INT(11);            -- ID instituto de fondeo
    DECLARE Var_SucursalID          INT(11);            -- sucursal ID
    DECLARE Var_MontoCuota          DECIMAL(14,2);      -- monto cuota
    DECLARE Var_ComAperCont         DECIMAL(14,2);      -- Monto de la Comisión por Apertura Contabilizada
    DECLARE Var_IVAComAperCont      DECIMAL(14,2);      -- Monto del IVA de la Comision por Apertura Contabilizada
    DECLARE Var_ConsecutivoID       INT(11);
    DECLARE Var_IVASucurs           DECIMAL(12,2);
    DECLARE Var_CliPagIVA           CHAR(1);
    DECLARE Var_IVAIntOrd           CHAR(1);
    DECLARE Var_IVAIntMor           CHAR(1);
    DECLARE Var_ValIVAIntOr         DECIMAL(12,2);
    DECLARE Var_ValIVAIntMo         DECIMAL(12,2);
    DECLARE Var_ValIVAGen           DECIMAL(12,2);
    DECLARE Var_TotalPago           DECIMAL(14,2);
    DECLARE Var_ResiduoPago         DECIMAL(14,2);
    DECLARE Var_MontoAplica         DECIMAL(14,2);
    DECLARE Var_Contador            INT(11);
    DECLARE Var_SaldoAmoInicial     DECIMAL(16,2);
    DECLARE Var_AmortiActual        INT(11);
    DECLARE Var_EsHabil             CHAR;
    DECLARE Var_Capital             DECIMAL(16,2);
    DECLARE Var_FechaInicio         DATE;
    DECLARE Var_TipoCalculoInteres  CHAR(1);
    DECLARE Var_AmortiActualAgro    INT(11);
    DECLARE Var_Amortizaciones      INT(11);
    DECLARE Var_UltimaAmortiza      INT(11);
    DECLARE Var_FechaUltima         DATE;
    DECLARE Var_TipoGarantiaFIRAID  INT(11);
    DECLARE Var_SucCliente          INT;
    DECLARE Var_SubClasifID         INT;
    DECLARE Var_AmortizacionID      INT;
    DECLARE Var_FechaValida         DATE;
    DECLARE Var_CapitalOriginal     DECIMAL(16,2);      -- Capital Original
    DECLARE Var_InteresOriginal     DECIMAL(16,2);      -- Interes Original
    DECLARE Var_MoraOriginal        DECIMAL(16,2);      -- Moratorio Original
    DECLARE Var_ComOriginal         DECIMAL(16,2);      -- Comision Original
    DECLARE Var_CapitalInicial      DECIMAL(16,2);      -- Capital Inicial
    DECLARE Var_InteresInicial      DECIMAL(16,2);      -- Interes Inicial
    DECLARE Var_MoraInicial         DECIMAL(16,2);      -- Moratorio Inicial
    DECLARE Var_ComInicial          DECIMAL(16,2);      -- Comision Inicial
    DECLARE Var_MontoReal           DECIMAL(16,2);      -- Monto Real de Pago
    DECLARE Var_Diferencia          DECIMAL(16,2);      -- Diferencia del Monto Real de Pago


    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT(11);                -- entero cero
    DECLARE Entero_Uno          INT(11);                -- entero uno
    DECLARE Decimal_Cero        DECIMAL(14,2);          -- DECIMAL Cero
    DECLARE Salida_SI           CHAR(1);                -- salida SI
    DECLARE Fecha_Vacia         DATE;                   -- Fecha vacia
    DECLARE Cadena_Vacia        CHAR(1);                -- cadena vacia
    DECLARE EstatusVigente      CHAR(1);                -- Credito vigente
    DECLARE EstatusInactivo     CHAR(1);                -- Credito Vencido
    DECLARE ConstanteNo         CHAR(1);                -- Constamnte no
    DECLARE EstatusActivo       CHAR(1);                -- EStatus activo
    DECLARE TipoCredito         CHAR(1);                -- Tipo de Credito Nuevo
    DECLARE EstatusPagado       CHAR(1);                -- Estatus pagado
    DECLARE EstatusVencido      CHAR(1);                -- estatus  vencido
    DECLARE FechaVig            DATE;                   -- fecha vigente
    DECLARE Fre_Dias            INT(11);
    DECLARE CapInt              CHAR(1);
    DECLARE Cons_Capital        CHAR(1);
    DECLARE Cons_CapInt         CHAR(1);
    DECLARE EstatusDes          CHAR(1);
    DECLARE Ultimas_Cuotas      CHAR(1);
    DECLARE AltaPolCre_SI       CHAR(1);
    DECLARE AltaMovCre_NO       CHAR(1);
    DECLARE Con_CtaAcredora     INT(11);
    DECLARE Con_CtaDeudora      INT(11);
    DECLARE Mov_Capital         INT(11);
    DECLARE Nat_Cargo           CHAR(1);                -- Naturaleza de Cargo
    DECLARE Nat_Abono           CHAR(1);                -- Naturaleza de abono
    DECLARE AltaMovAho_NO       CHAR(1);                -- Alta del Movimiento de Ahorro: NO
    DECLARE DescripcionCont     VARCHAR(50);
    DECLARE ReferenciaCont      VARCHAR(50);
    DECLARE EstatusAtrasado         CHAR(1);
    DECLARE Llave_FiraInstitucionID VARCHAR(50);        -- ID de la tabla INSTITUTFONDEO asignado a FIRA
    DECLARE Llave_FiraLineaID       VARCHAR(50);        -- ID de la linea de Fondeo correspondiente a FIRA

    -- Asignacion de constantes
    SET Entero_Cero         := 0;
    SET Entero_Uno          := 1;
    SET Decimal_Cero        := 0.00;
    SET Salida_SI           := 'S';
    SET Fecha_Vacia         := '1900-01-01';
    SET Cadena_Vacia        := '';
    SET EstatusVigente      := 'V';
    SET EstatusInactivo     := 'I';
    SET ConstanteNo         := 'N';
    SET EstatusActivo       := 'A';
    SET TipoCredito         := 'N';
    SET EstatusPagado       := 'P';
    SET EstatusVencido      := 'B';
    SET Cons_Capital        := 'C';
    SET Cons_CapInt         := 'G';
    SET EstatusDes          := 'D';
    SET Ultimas_Cuotas      := 'I';
    SET AltaPolCre_SI       := 'S';
    SET AltaMovCre_NO       := 'N';
    SET Con_CtaAcredora     := 71;
    SET Con_CtaDeudora      := 70;
    SET Mov_Capital         := 1;
    SET Nat_Cargo           := 'C';
    SET Nat_Abono           := 'A';
    SET AltaMovAho_NO       := 'N';
    SET DescripcionCont     := 'CREACION DE CREDITO CONTINGENTE';
    SET ReferenciaCont      := '';
    SET EstatusAtrasado     := 'A';
    SET Var_NumAmoInt       := 0;
    SET Var_NumAmorti       := 0;
    SET Var_TipoFond        := 'F';
    SET Llave_FiraInstitucionID   := 'FiraInstitucionID';
    SET Llave_FiraLineaID         := 'FiraLineaID';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CREDITOSCONTPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        -- Asignamos valor a varibles
        SET Aud_FechaActual     := NOW();
        SET Var_FechaSis        := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);
        SET Var_Consecutivo     := Entero_Cero;
        SET Var_TotalPago       := Par_Monto;
        SET Var_Poliza          := Par_PolizaID;
        SET Par_AltaEncPoliza   := ConstanteNo;

        SELECT Cre.CreditoID,       Cre.TipoGarantiaFIRAID,     Cli.SucursalOrigen,     Des.SubClasifID
            INTO Var_CreditoID,     Var_TipoGarantiaFIRAID,     Var_SucCliente,         Var_SubClasifID
            FROM CLIENTES Cli,
                 DESTINOSCREDITO Des,
                 CREDITOS Cre
        WHERE Cre.CreditoID = Par_CreditoID
            AND Cre.ClienteID = Cli.ClienteID
            AND Cre.DestinoCreID = Des.DestinoCreID;

        SELECT  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Pro.CobraIVAMora

        INTO    Var_CliPagIVA,          Var_IVASucurs,          Var_IVAIntOrd,          Var_IVAIntMor

        FROM CREDITOS   Cre,
            CLIENTES   Cli,
            SUCURSALES Suc,
            PRODUCTOSCREDITO Pro
        WHERE   Cre.CreditoID           = Par_CreditoID
          AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
          AND   Cre.ClienteID           = Cli.ClienteID
          AND   Cre.SucursalID          = Suc.SucursalID;

        SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, Salida_SI);
        SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, Salida_SI);
        SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, Salida_SI);
        SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
        SET Var_ValIVAIntOr := Entero_Cero;
        SET Var_ValIVAIntMo := Entero_Cero;
        SET Var_ValIVAGen   := Entero_Cero;

        SELECT  MAX(AmortizacionID) INTO Var_AmortiActualAgro
            FROM AMORTICREDITOAGRO WHERE CreditoID  = Par_CreditoID
                AND EstatusDesembolso = EstatusDes
                    AND  Var_FechaSis <=  FechaExigible LIMIT Entero_Uno;

        SET Var_TipoCalculoInteres := (SELECT TipoCalculoInteres  FROM AMORTICREDITOAGRO
                                            WHERE CreditoID  = Par_CreditoID AND AmortizacionID=Var_AmortiActualAgro);

        IF( IFNULL(Var_CreditoID,Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Credito No Existe.';
            SET Var_Control:= 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        IF (Var_CliPagIVA = Salida_SI) THEN
            SET Var_ValIVAGen  := Var_IVASucurs;

            IF (Var_IVAIntOrd = Salida_SI) THEN
                SET Var_ValIVAIntOr  := Var_IVASucurs;
            END IF;

            IF (Var_IVAIntMor = Salida_SI) THEN
                SET Var_ValIVAIntMo  := Var_IVASucurs;
            END IF;
        END IF;

        -- Se asignan valores para nuevo credito con los valores del credito activo el contingente
        SELECT  CreditoID,              ClienteID,              LineaCreditoID,         ProductoCreditoID,      CuentaID,
                MonedaID,               FechaVencimien,         FactorMora,             CalcInteresID,          TasaBase,
                TasaFija,               SobreTasa,              PisoTasa,               TechoTasa,              FrecuenciaCap,
                PeriodicidadCap,        FrecuenciaInt,          PeriodicidadInt,        TipoPagoCapital,
                FechaInhabil,           CalendIrregular,        AjusFecUlVenAmo,        AjusFecExiVen,
                NumTransacSim,          SucursalID,             ValorCAT,               MontoComApert,
                IVAComApertura,         PlazoID,                TipoDispersion,         TipoCalInteres,         DestinoCreID,
                MontoCuota,             ClasiDestinCred,        ComAperCont,            IVAComAperCont

        INTO    Var_CreditoID,          Var_ClienteID,          Var_LineaCreditoID,         Var_Producto,               Var_CuentaID,
                Var_Moneda,             Var_FechaVencimien,     Var_FacMora,                Var_CalcInter,              Var_TasaBase,
                Var_TasaFija,           Var_SobreTasa,          Var_PisoTasa,               Var_TechTasa,               Var_FrecCap,
                Var_PeriodCap,          Var_FrecInter,          Var_PeriodicidadInt,        Var_TipoPagCap,
                Var_FechInha,           Var_CalIrreg,           Var_AjFeUlVA,               Var_AjFecExV,
                Var_NumTrSim,           Var_SucursalID,         Var_CAT,                    Var_MonComA,
                Var_IVAComA,            Var_Plazo,              Var_TipoDisper,             Var_TipoCalIn,              Var_DestCred,
                Var_MontoCuota,         Var_ClasiDestinCred,    Var_ComAperCont,            Var_IVAComAperCont

        FROM  CREDITOS
            WHERE CreditoID = Par_CreditoID;

        -- Se obtiene la institucion de Fodeo Parametrizada
        SELECT CAST(ValorParametro AS UNSIGNED)
        INTO Var_InstitutFondID
        FROM PARAMGENERALES
        WHERE LlaveParametro = Llave_FiraInstitucionID;

        -- Se obtiene la Linea de Fondeo Parametrizada
        SELECT CAST(ValorParametro AS UNSIGNED)
        INTO Var_LineaFondeoID
        FROM PARAMGENERALES
        WHERE LlaveParametro = Llave_FiraLineaID;

        -- inicializa variables
        SET Var_CalcInter     := (IFNULL(Var_CalcInter,Entero_Cero));
        SET Var_TasaFija      := (IFNULL(Var_TasaFija,Decimal_Cero));
        SET Var_FrecCap       := (IFNULL(Var_FrecCap,Cadena_Vacia));
        SET Var_PeriodCap     := (IFNULL(Var_PeriodCap,Entero_Cero));
        SET Var_FrecInter     := (IFNULL(Var_FrecInter,Cadena_Vacia));
        SET Var_PeriodInt     := (IFNULL(Var_PeriodInt,Entero_Cero));
        SET Var_TipoPagCap    := (IFNULL(Var_TipoPagCap,Cadena_Vacia));
        SET Var_FechInha      := (IFNULL(Var_FechInha,Cadena_Vacia));
        SET Var_AjFeUlVA      := (IFNULL(Var_AjFeUlVA,Cadena_Vacia));
        SET Var_AjFecExV      := (IFNULL(Var_AjFecExV,Cadena_Vacia));
        SET Var_TipoCalIn     := (IFNULL(Var_TipoCalIn,Entero_Cero));
        SET Var_FechaCobroComision  := (SELECT FNSUMADIASFECHA(Var_FechaSis,Var_PeriodCap));
        SET Var_FechaCobroComision  := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, Entero_Cero, Par_EmpresaID));
        SET Var_TipoPrepago         := Ultimas_Cuotas;
        SET Var_ComAperCont         := Decimal_Cero;
        SET Var_MonComA             := Decimal_Cero;
        SET Var_IVAComA             := Decimal_Cero;
        SET Var_IVAComAperCont      := Decimal_Cero;

        -- Se genera llamada Alta de Creditos
        CALL CREDITOSCONTALT (
            Var_ClienteID,          Var_LineaCreditoID,     Var_Producto,           Var_CuentaID,           TipoCredito,
            Entero_Cero,            Entero_Cero,            Par_Monto,              Var_Moneda,             Var_FechaSis,
            Var_FechaVencimien,     Var_FacMora,            Var_CalcInter,          Var_TasaBase,           Var_TasaFija,
            Var_SobreTasa,          Var_PisoTasa,           Var_TechTasa,           Var_FrecCap,            Var_PeriodCap,
            Var_FrecInter,          Var_PeriodInt,          Var_TipoPagCap,         Var_NumAmorti,          Var_FechInha,
            Var_CalIrreg,           Var_AjFeUlVA,           Var_AjFecExV,           Var_NumTrSim,           Var_TipoFond,
            Var_MonComA,            Var_IVAComA,            Var_CAT,                Var_Plazo,              Var_TipoDisper,
            Var_TipoCalIn,          Var_DestCred,           Var_InstitutFondID,     Var_LineaFondeoID,      Var_NumAmoInt,
            Var_MontoCuota,         Var_ClasiDestinCred,    Var_TipoPrepago,        Var_FechaSis,           Var_FechaCobroComision,
            ConstanteNo,            Var_CreditoID,          Par_NumErr,             Par_ErrMen,             Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        DELETE FROM TMPAMORTICREDCONT WHERE CreditoID = Par_CreditoID;

        SET @ConsecutivoID := 0;
        INSERT INTO TMPAMORTICREDCONT(
            AmortizacionID,         CreditoID,              FechaInicio,        FechaVen,   Estatus,
            MontoAplica,            MontoReal,
            SalCapitalOriginal,     SalInteresOriginal,     SalMoraOriginal,    SalComOriginal,
            EmpresaID,  Usuario,    FechaActual,    DireccionIP,    ProgramaID, Sucursal,  NumTransaccion)
        SELECT  ( @ConsecutivoID:=@ConsecutivoID+1),    CreditoID,    FechaInicio,    FechaVencim,    Estatus,
                -- saldo total del adeudo de la amortizacion
               ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
                SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
                SaldoInteresVen + SaldoIntNoConta +
                (SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa +  SaldoComServGar +
                SaldoOtrasComis, 2)  +

                ROUND(SaldoInteresPro * Var_ValIVAGen, 2) +
                ROUND(SaldoInteresAtr * Var_ValIVAGen, 2) +
                ROUND(SaldoInteresVen * Var_ValIVAGen, 2) +
                ROUND(SaldoIntNoConta * Var_ValIVAGen, 2) +
                ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2) +
                ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
                ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2) +
                ROUND(SaldoComFaltaPa * Var_ValIVAGen, 2) +
                ROUND(SaldoComServGar * Var_ValIVAGen, 2) +
                ROUND(SaldoOtrasComis * Var_ValIVAGen, 2) +
                ROUND(SaldoComisionAnual, 2) +/*COMISION ANUAL*/
                ROUND(SaldoComisionAnual * Var_ValIVAGen, 2) +/*COMISION ANUAL*/
                ROUND(SaldoSeguroCuota,2) +
                ROUND(SaldoIVASeguroCuota,2),
                Decimal_Cero,
                ROUND((IFNULL(SaldoCapVigente,Entero_Cero) + IFNULL(SaldoCapAtrasa,Entero_Cero) +   IFNULL(SaldoCapVencido,Entero_Cero) + IFNULL(SaldoCapVenNExi,Entero_Cero)), 2),
                ROUND((IFNULL(SaldoInteresPro,Entero_Cero) + IFNULL(SaldoInteresAtr,Entero_Cero) +  IFNULL(SaldoInteresVen,Entero_Cero) + IFNULL(SaldoIntNoConta,Entero_Cero)), 2),
                ROUND((IFNULL(SaldoMoratorios,Entero_Cero) + IFNULL(SaldoMoraVencido,Entero_Cero) + IFNULL(SaldoMoraCarVen,Entero_Cero)), 2),
                ROUND((IFNULL(SaldoComFaltaPa,Entero_Cero) + IFNULL(SaldoComServGar,Entero_Cero)  + IFNULL(SaldoOtrasComis,Entero_Cero)), 2),
                Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,  Aud_NumTransaccion
        FROM AMORTICREDITO
        WHERE CreditoID = Par_CreditoID
          AND Estatus <> EstatusPagado;

        -- Tratamiento para asignar el saldo a las amoritzaciones
        SET Var_Contador := Entero_Uno;
        SET Var_ResiduoPago := Var_TotalPago;

        WHILE (Var_ResiduoPago > Entero_Cero)  DO

            -- Se obtiene el valor del monto de la amortizacion
            SET Var_MontoAplica :=(SELECT MontoAplica FROM TMPAMORTICREDCONT WHERE AmortizacionID = Var_Contador AND CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
            SET Var_MontoAplica := IFNULL(Var_MontoAplica,Decimal_Cero);

            IF(Var_ResiduoPago>=Var_MontoAplica)THEN
                UPDATE TMPAMORTICREDCONT SET
                    MontoReal = Var_MontoAplica
                WHERE AmortizacionID = Var_Contador
                  AND CreditoID = Par_CreditoID
                  AND NumTransaccion = Aud_NumTransaccion;
            ELSE
                UPDATE TMPAMORTICREDCONT SET
                    MontoReal = Var_ResiduoPago
                WHERE AmortizacionID = Var_Contador
                  AND CreditoID = Par_CreditoID
                  AND NumTransaccion = Aud_NumTransaccion;
            END IF;

            SET Var_ResiduoPago := Var_ResiduoPago - Var_MontoAplica;
            SET Var_Contador := Var_Contador + Entero_Uno;

        END WHILE;

           -- Obtener la amortizacion en curso
        SET Var_AmortiActual := (SELECT MIN(AmortizacionID) FROM TMPAMORTICREDCONT WHERE  Var_FechaSis
                                    BETWEEN FechaInicio AND FechaVen AND Estatus <> EstatusPagado AND NumTransaccion = Aud_NumTransaccion );

        IF(IFNULL(Var_AmortiActual,Entero_Cero)=Entero_Cero)THEN

            SET Var_AmortiActual := (SELECT MAX(AmortizacionID) FROM TMPAMORTICREDCONT WHERE Estatus <> EstatusPagado AND NumTransaccion = Aud_NumTransaccion );

        END IF;

        -- si se trata de una sola amortizacion
        SET Var_Amortizaciones := (SELECT COUNT(AmortizacionID) FROM  TMPAMORTICREDCONT WHERE CreditoID=Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);

         -- Actualizar saldo de la primer amortizacion si existen vencidas considerando si solo existe una amortizacion
        IF(Var_Amortizaciones > Entero_Uno)THEN
            SET Var_SaldoAmoInicial := (SELECT SUM(MontoReal)
                                        FROM TMPAMORTICREDCONT
                                        WHERE AmortizacionID < Var_AmortiActual
                                          AND CreditoID = Par_CreditoID
                                          AND NumTransaccion = Aud_NumTransaccion
                                          AND Estatus IN (EstatusVencido,EstatusVigente,EstatusAtrasado));

            SELECT  SUM(SalCapitalOriginal),    SUM(SalInteresOriginal),    SUM(SalMoraOriginal),   SUM(SalComOriginal)
            INTO    Var_CapitalInicial,         Var_InteresInicial,         Var_MoraInicial,        Var_ComInicial
            FROM TMPAMORTICREDCONT
            WHERE AmortizacionID < Var_AmortiActual
              AND CreditoID = Par_CreditoID
              AND NumTransaccion = Aud_NumTransaccion
              AND Estatus IN (EstatusVencido,EstatusVigente,EstatusAtrasado);
        END IF;

        SET Var_SaldoAmoInicial := IFNULL(Var_SaldoAmoInicial,Decimal_Cero);
        SET Var_CapitalInicial  := IFNULL(Var_CapitalInicial,Decimal_Cero);
        SET Var_InteresInicial  := IFNULL(Var_InteresInicial,Decimal_Cero);
        SET Var_MoraInicial     := IFNULL(Var_MoraInicial,Decimal_Cero);
        SET Var_ComInicial      := IFNULL(Var_ComInicial,Decimal_Cero);


        -- Actualizar el total de la primer amortizacion, asi como su fecha de inicio
        UPDATE TMPAMORTICREDCONT SET
            MontoReal           = MontoReal + Var_SaldoAmoInicial,
            FechaInicio         = Var_FechaSis,
            SalCapitalOriginal  = SalCapitalOriginal + Var_CapitalInicial,
            SalInteresOriginal  = SalInteresOriginal + Var_InteresInicial,
            SalMoraOriginal     = SalMoraOriginal + Var_MoraInicial,
            SalComOriginal      = SalComOriginal + Var_ComInicial
        WHERE AmortizacionID = Var_AmortiActual
          AND CreditoID = Par_CreditoID
          AND NumTransaccion = Aud_NumTransaccion;

        -- eliminar amortizaciones que no se afectaron efectivamente.
        DELETE FROM TMPAMORTICREDCONT WHERE AmortizacionID < Var_AmortiActual AND NumTransaccion = Aud_NumTransaccion;
        DELETE FROM TMPAMORTICREDCONT WHERE MontoReal = Decimal_Cero AND NumTransaccion = Aud_NumTransaccion;

        SET Var_Contador        := Entero_Cero;
        SET Var_ConsecutivoID   := Entero_Uno;
        SET Var_Contador        :=(SELECT COUNT(AmortizacionID) FROM TMPAMORTICREDCONT  WHERE CreditoID=Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
        SET Var_UltimaAmortiza  :=(SELECT MAX(AmortizacionID) FROM TMPAMORTICREDCONT WHERE CreditoID=Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
        SET Var_FechaUltima     :=(SELECT FechaVen FROM TMPAMORTICREDCONT WHERE CreditoID=Par_CreditoID AND AmortizacionID=Var_UltimaAmortiza AND NumTransaccion = Aud_NumTransaccion);

        -- validar si la ultima fecha seleccionada es menor a la del sistema, se asinara una fecha con un dia mas.
        IF(Var_FechaUltima<Var_FechaSis)THEN
            SET Var_FechaUltima:= DATE_ADD(IFNULL(Var_FechaSis,Fecha_Vacia), INTERVAL IFNULL(1, Entero_Cero) DAY);

            CALL DIASFESTIVOSCAL(
                Var_FechaUltima,        Entero_Cero,        Var_FechaValida,    Var_EsHabil,        Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            UPDATE TMPAMORTICREDCONT SET
                FechaVen= Var_FechaUltima
            WHERE AmortizacionID=Var_UltimaAmortiza
              AND CreditoID=Par_CreditoID
              AND NumTransaccion = Aud_NumTransaccion;
        END IF;

        SET Var_CapitalOriginal := Entero_Cero;
        SET Var_InteresOriginal := Entero_Cero;
        SET Var_MoraOriginal    := Entero_Cero;
        SET Var_ComOriginal     := Entero_Cero;
        -- Se inserta en TMPAMORSIN
        WHILE(Var_Contador> Entero_Cero)DO

            SELECT  FechaInicio,            FechaVen,               MontoReal,          MontoReal,
                    SalCapitalOriginal,     SalInteresOriginal,     SalMoraOriginal,    SalComOriginal
            INTO    Var_FechaInicio,        Var_FechaVencimien,     Var_Capital,        Var_MontoReal,
                    Var_CapitalOriginal,    Var_InteresOriginal,    Var_MoraOriginal,   Var_ComOriginal
            FROM TMPAMORTICREDCONT
            WHERE AmortizacionID = Var_AmortiActual
              AND CreditoID = Par_CreditoID
              AND NumTransaccion = Aud_NumTransaccion;

            SET Var_CapitalOriginal := IFNULL(Var_CapitalOriginal,Entero_Cero);
            SET Var_InteresOriginal := IFNULL(Var_InteresOriginal,Entero_Cero);
            SET Var_MoraOriginal    := IFNULL(Var_MoraOriginal,Entero_Cero);
            SET Var_ComOriginal     := IFNULL(Var_ComOriginal,Entero_Cero);

            ProcesoValidaMonto:BEGIN
                IF( Var_MontoReal <> (Var_CapitalOriginal + Var_InteresOriginal + Var_MoraOriginal + Var_ComOriginal) ) THEN

                    -- Valido si el Monton Real es igual o superior a la comision Original de la amortizacion
                    IF ( Var_ComOriginal > Entero_Cero ) THEN

                        SET Var_Diferencia := Var_MontoReal - Var_ComOriginal;

                        -- Si el monto real es mayor a la comision la diferencia de la operacion es la base para validar los moratorios
                        -- En caso contrario el monto
                        IF( Var_MontoReal >= Var_ComOriginal) THEN
                            SET Var_MontoReal   := Var_Diferencia;
                        ELSE
                            SET Var_ComOriginal := Var_MontoReal;
                        END IF;

                        -- Si la diferencia es cero los montos de capital, interes y mora original son cero
                        IF( Var_Diferencia <= Entero_Cero) THEN
                            SET Var_CapitalOriginal := Entero_Cero;
                            SET Var_InteresOriginal := Entero_Cero;
                            SET Var_MoraOriginal    := Entero_Cero;
                            LEAVE ProcesoValidaMonto;
                        END IF;
                    END IF;

                    -- Valido si el Monton Real es igual o superior a los Moratorios Originales de la amortizacion
                    IF ( Var_MoraOriginal > Entero_Cero ) THEN
                        SET Var_Diferencia := Var_MontoReal - Var_MoraOriginal;

                        -- Si el monto real es mayor a la comision la diferencia de la operacion es la base para validar los moratorios
                        -- En caso contrario el monto
                        IF( Var_MontoReal >= Var_MoraOriginal) THEN
                            SET Var_MontoReal   := Var_Diferencia;
                        ELSE
                            SET Var_MoraOriginal := Var_MontoReal;
                        END IF;

                        -- Si la diferencia es cero los montos de capital, interes son cero
                        IF( Var_Diferencia <= Entero_Cero) THEN
                            SET Var_CapitalOriginal := Entero_Cero;
                            SET Var_InteresOriginal := Entero_Cero;
                            LEAVE ProcesoValidaMonto;
                        END IF;

                    END IF;

                    -- Valido si el Monton Real es igual o superior a los Intereses Originales de la amortizacion
                    IF ( Var_InteresOriginal > Entero_Cero ) THEN
                        SET Var_Diferencia := Var_MontoReal - Var_InteresOriginal;

                        -- Si el monto real es mayor a la comision la diferencia de la operacion es la base para validar los moratorios
                        -- En caso contrario el monto
                        IF( Var_MontoReal >= Var_InteresOriginal) THEN
                            SET Var_MontoReal   := Var_Diferencia;
                        ELSE
                            SET Var_InteresOriginal := Var_MontoReal;
                        END IF;

                        -- Si la diferencia es cero los montos de capital, interes son cero
                        IF( Var_Diferencia <= Entero_Cero) THEN
                            SET Var_CapitalOriginal := Entero_Cero;
                            LEAVE ProcesoValidaMonto;
                        END IF;

                    END IF;

                    -- Valido si el Monton Real es igual o superior al Capital Original de la amortizacion
                    IF ( Var_CapitalOriginal > Entero_Cero ) THEN
                        SET Var_Diferencia := Var_MontoReal - Var_CapitalOriginal;

                        -- Si el monto real es mayor a la comision la diferencia de la operacion es la base para validar los moratorios
                        -- En caso contrario el monto
                        IF( Var_MontoReal >= Var_CapitalOriginal) THEN
                            SET Var_MontoReal   := Var_Diferencia;
                        ELSE
                            SET Var_CapitalOriginal := Var_MontoReal;
                        END IF;

                        IF( Var_Diferencia <= Entero_Cero) THEN
                            LEAVE ProcesoValidaMonto;
                        END IF;

                    END IF;
                END IF;
            END ProcesoValidaMonto;

            UPDATE TMPAMORTICREDCONT SET
                SalCapitalOriginal = Var_CapitalOriginal,
                SalInteresOriginal = Var_InteresOriginal,
                SalMoraOriginal    = Var_MoraOriginal,
                SalComOriginal     = Var_ComOriginal
            WHERE AmortizacionID = Var_AmortiActual
              AND CreditoID = Par_CreditoID
              AND NumTransaccion = Aud_NumTransaccion;

            IF(IFNULL(Var_Capital, Entero_Cero)= Entero_Cero) THEN
                SET Par_NumErr      := 9;
                SET Par_ErrMen      :='El Monto de la Amortizacion Contingente esta Vacio.';
                LEAVE ManejoErrores;
            END IF;

            CALL DIASFESTIVOSCAL(
                Var_FechaVencimien,     Entero_Cero,        FechaVig,           Var_EsHabil,        Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Var_Capital = Entero_Cero) THEN
                SET CapInt := Cons_Capital;
            ELSE
                SET CapInt := Cons_CapInt;
            END IF;

            SET Fre_Dias    := (DATEDIFF(Var_FechaVencimien,Var_FechaInicio));

            INSERT INTO TMPPAGAMORSIM(
                Tmp_Consecutivo,        Tmp_FecIni,             Tmp_FecFin,             Tmp_FecVig,     Tmp_Capital,
                Tmp_CapInt,             NumTransaccion,         Tmp_Dias,
                Tmp_SalCapitalOriginal, Tmp_SalInteresOriginal, Tmp_SalMoraOriginal,    Tmp_SalComOriginal)
            VALUES(
                Var_ConsecutivoID,      Var_FechaInicio,        Var_FechaVencimien,     FechaVig,       Var_Capital,
                CapInt,                 Aud_NumTransaccion,     Fre_Dias,
                Var_CapitalOriginal,    Var_InteresOriginal,    Var_MoraOriginal,       Var_ComOriginal);

            SET Var_Contador:= Var_Contador- Entero_Uno;
            SET Var_AmortiActual := Var_AmortiActual + Entero_Uno;
            SET Var_ConsecutivoID := Var_ConsecutivoID + Entero_Uno;
            SET Var_CapitalOriginal := Entero_Cero;
            SET Var_InteresOriginal := Entero_Cero;
            SET Var_MoraOriginal    := Entero_Cero;
            SET Var_ComOriginal     := Entero_Cero;

        END WHILE;

        -- Obtengo el monto Original de la aplicacion de las garantias
        SELECT  SUM(ROUND(IFNULL(SalCapitalOriginal,Entero_Cero), 2)),
                SUM(ROUND(IFNULL(SalInteresOriginal,Entero_Cero), 2)),
                SUM(ROUND(IFNULL(SalMoraOriginal,Entero_Cero), 2)),
                SUM(ROUND(IFNULL(SalComOriginal,Entero_Cero), 2))
        INTO    Var_CapitalOriginal,    Var_InteresOriginal,   Var_MoraOriginal,   Var_ComOriginal
        FROM TMPAMORTICREDCONT
        WHERE CreditoID = Par_CreditoID
          AND NumTransaccion = Aud_NumTransaccion;

        UPDATE CREDITOSCONT SET
            SalCapitalOriginal = Var_CapitalOriginal,
            SalInteresOriginal = Var_InteresOriginal,
            SalMoraOriginal    = Var_MoraOriginal,
            SalComOriginal     = Var_ComOriginal
        WHERE CreditoID = Par_CreditoID;

        -- Se genera llamada sp de calculo de intereses
        CALL CRERECPAGLIBREFPRO(
            Par_Monto,          Var_TasaFija,       Var_Producto,       Var_ClienteID,      Var_ComAperCont,
            ConstanteNo,        ConstanteNo,        Decimal_Cero,       Entero_Cero,    ConstanteNo,
            Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- Se dan de alta las amortizaciones
        CALL AMORTICREDITOCONTALT(
            Par_CreditoID,      Aud_NumTransaccion,     Var_ClienteID,      Var_CuentaID,       Par_Monto,
            Entero_Uno,         ConstanteNo,            Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- se dan de baja amortizaciones temporales
        CALL TMPPAGAMORSIMBAJ(
            Aud_NumTransaccion,     ConstanteNo,        Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- actualiza CREDITOSCONT
        SET Var_Amortizaciones  := (SELECT COUNT(AmortizacionID) FROM  AMORTICREDITOCONT WHERE CreditoID=Par_CreditoID);

        UPDATE CREDITOSCONT SET
            NumAmortizacion = Var_Amortizaciones,
            NumAmortInteres = Var_Amortizaciones,
            FechaMinistrado = Var_FechaSis,
            FechaVencimien  = Var_FechaUltima
        WHERE  CreditoID = Par_CreditoID;

        -- alta de movimientos operativos credito contingente
        INSERT INTO CREDITOSCONTMOVS(
             CreditoID,     AmortiCreID,    Transaccion,    FechaOperacion,     FechaAplicacion,
             TipoMovCreID,  NatMovimiento,  MonedaID,       Cantidad,           Descripcion,
             Referencia,    PolizaID,       EmpresaID,      Usuario,            FechaActual,
             DireccionIP,   ProgramaID,     Sucursal,       NumTransaccion)
        SELECT
            Par_CreditoID,      Amo.AmortizacionID,     Aud_NumTransaccion,     Var_FechaSis,           Var_FechaSis,
            Mov_Capital,        Nat_Cargo,              Var_Moneda,             Amo.Capital,            DescripcionCont,
            Var_CuentaID,       Var_Poliza,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
        FROM  AMORTICREDITOCONT Amo WHERE CreditoID=Par_CreditoID
            AND Estatus=EstatusVigente;

        -- Contabilidad  Abono  acredora cta orden cartera contingente   ID 71
        CALL CONTACREDITOSCONTPRO (
            Par_CreditoID,          Entero_Cero,        Var_CuentaID,       Var_ClienteID,      Var_FechaSis,
            Var_FechaSis,           Par_Monto,          Var_Moneda,         Var_Producto,       Var_ClasiDestinCred,
            Var_SubClasifID,        Var_SucCliente,     DescripcionCont,    ReferenciaCont,     Par_AltaEncPoliza,
            Entero_Cero,            Var_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_CtaAcredora,
            Mov_Capital,            Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            ConstanteNo,            Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    Par_EmpresaID,
            Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- Contabilidad  Cargo a cta deudora orden cartera contingente ID 70
        CALL  CONTACREDITOSCONTPRO (
            Par_CreditoID,          Entero_Cero,        Var_CuentaID,       Var_ClienteID,      Var_FechaSis,
            Var_FechaSis,           Par_Monto,          Var_Moneda,         Var_Producto,       Var_ClasiDestinCred,
            Var_SubClasifID,        Var_SucCliente,     DescripcionCont,    ReferenciaCont,     Par_AltaEncPoliza,
            Entero_Cero,            Var_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_CtaDeudora,
            Mov_Capital,            Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            ConstanteNo,            Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    Par_EmpresaID,
            Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        -- Dar de alta credito pasivo
        CALL CREDITOPASIVOCONTALT(
            Par_CreditoID,      Par_Monto,          Par_PolizaID,       Var_TipoCalculoInteres,     Par_GarantiaID,
            ConstanteNo,        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,              Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,               Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        DELETE FROM TMPAMORTICREDCONT WHERE CreditoID = Par_CreditoID;
        SET Par_NumErr      := Entero_Cero;
        SET Par_ErrMen      := CONCAT('Credito Contingente Registrado Exitosamente: ',Var_CreditoID);
        SET Var_Consecutivo := Var_CreditoID;
        SET Var_Control     := 'creditoID';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen,
            Var_Control         AS control,
            Var_Consecutivo     AS consecutivo;

    END IF;

END TerminaStore$$