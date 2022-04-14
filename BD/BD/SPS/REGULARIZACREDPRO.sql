-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULARIZACREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULARIZACREDPRO`;
DELIMITER $$

CREATE PROCEDURE `REGULARIZACREDPRO`(
    Par_CreditoID       BIGINT(12),
    Par_Fecha           DATE,
    Par_AltaEncPoliza   CHAR(1),
    Par_Poliza          BIGINT,
    Par_EmpresaID       INT(11),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_ModoPago        CHAR(1),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore: BEGIN

    DECLARE Var_Control         CHAR(100);
    DECLARE Var_Consecutivo     BIGINT(12);

    DECLARE Var_CreditoID       BIGINT(12);
    DECLARE Var_AmortizacionID  INT;
    DECLARE Var_FechaInicio     DATE;
    DECLARE Var_FechaVencim     DATE;
    DECLARE Var_FechaExigible   DATE;
    DECLARE Var_AmoCapVig       DECIMAL(14,2);
    DECLARE Var_AmoCapAtra      DECIMAL(14,2);
    DECLARE Var_AmoCapVen       DECIMAL(14,2);
    DECLARE Var_AmoCaVeNex      DECIMAL(14,2);
    DECLARE Var_EmpresaID       INT;
    DECLARE Var_CreCapVig       DECIMAL(14,2);
    DECLARE Var_CreCapAtra      DECIMAL(14,2);
    DECLARE Var_CreCapVen       DECIMAL(14,2);
    DECLARE Var_CreCapVNE       DECIMAL(14,2);
    DECLARE Var_CreIntOrd       DECIMAL(14,2);
    DECLARE Var_MonedaID        INT(11);
    DECLARE Var_Estatus         CHAR(1);
    DECLARE Var_StatuAmort      CHAR(1);
    DECLARE Var_SucCliente      INT;
    DECLARE Var_ProdCreID       INT;
    DECLARE Var_ClasifCre       CHAR(1);
    DECLARE Var_IntAtrasado     DECIMAL(12,4);
    DECLARE Var_IntNoCont       DECIMAL(12,4);
    DECLARE Var_IntProvision    DECIMAL(12,4);
    DECLARE Var_IntVencido      DECIMAL(12,4);


    DECLARE Var_FecApl          DATE;
    DECLARE Var_EsHabil         CHAR(1);
    DECLARE Error_Key           INT;
    DECLARE Mov_AboConta        INT;
    DECLARE Mov_CarConta        INT;
    DECLARE Mov_CarOpera        INT;
    DECLARE Mov_AboOpera        INT;
    DECLARE Var_RegContaEPRC    CHAR(1);
    DECLARE Var_DivideEPRC      CHAR(1);
    DECLARE Var_EPRCAdicional   CHAR(1);

    DECLARE Par_Consecutivo     BIGINT;
    DECLARE Var_SubClasifID     INT;
    DECLARE Var_CreEstatus  CHAR(1);    -- Estatus de Credito

    DECLARE Con_CapVenNoExSup   INT(11);    -- Concepto Contable: Capital Vencido no Exigible Suspendido
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12, 2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Estatus_Vigente     CHAR(1);
    DECLARE Estatus_Vencido     CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Con_CapVigente      INT;
    DECLARE Con_CapVencido      INT;
    DECLARE Con_CapVenNoEx      INT;
    DECLARE Con_IntDevVig       INT;
    DECLARE Con_IntVencido      INT;
    DECLARE Con_IngresosInt     INT;
    DECLARE Con_CtaOrIntDev     INT;
    DECLARE Con_CoCtaOrIntD     INT;
    DECLARE Mov_CapVigente      INT;
    DECLARE Mov_CapVencido      INT;
    DECLARE Mov_CapVenNoEx      INT;
    DECLARE Mov_IntVencido      INT;
    DECLARE Mov_IntDevNcont     INT;
    DECLARE Mov_InterProv       INT;
    DECLARE Pol_Automatica      CHAR(1);
    DECLARE Con_regularCred     INT;
    DECLARE Par_SalidaNO        CHAR(1);
    DECLARE AltaPoliza_NO       CHAR(1);
    DECLARE AltaPoliza_SI       CHAR(1);
    DECLARE AltaPolCre_SI       CHAR(1);
    DECLARE AltaMovCre_SI       CHAR(1);
    DECLARE AltaMovCre_NO       CHAR(1);
    DECLARE AltaMovAho_NO       CHAR(1);
    DECLARE Des_RegCred         VARCHAR(100);
    DECLARE Ref_RegCred         VARCHAR(50);
    DECLARE Con_Balance         INT;
    DECLARE Con_ResultEPRC      INT;
    DECLARE Con_BalIntere       INT;
    DECLARE Con_PtePrinci       INT;
    DECLARE Con_PteIntere       INT;
    DECLARE Con_ResIntere       INT;
    DECLARE Con_BalAdiEPRC      INT;
    DECLARE Con_PteAdiEPRC      INT;
    DECLARE Con_ResAdiEPRC      INT;

    DECLARE EPRC_Resultados     CHAR(1);
    DECLARE SI_DivideEPRC       CHAR(1);
    DECLARE NO_DivideEPRC       CHAR(1);
    DECLARE NO_EPRCAdicional    CHAR(1);
    DECLARE SI_EPRCAdicional    CHAR(1);

    DECLARE Des_Reserva         VARCHAR(100);
    DECLARE Estatus_Suspendido  CHAR(1);        -- Estatus Suspendido
    DECLARE Con_CapVigenteSup   INT(11);        -- Concepto Contable: Capital Vigente Suspendido
    DECLARE Con_CtaOrdIntSup    INT(11);        -- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
    DECLARE Con_CorIntOrdSup    INT(11);        -- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
    DECLARE Con_IntDevenSup     INT(11);        -- Concepto Contable Interes Devengado Supencion
    DECLARE Con_IntVencidoSup   INT(11);        -- Concepto Contable: Interes Vencido Suspendido
    DECLARE Salida_SI           CHAR(1);

    DECLARE CURSORPAGCREVEN CURSOR FOR
        SELECT  Cre.CreditoID,          Amo.AmortizacionID,     Amo.FechaInicio,            Amo.FechaVencim,        Amo.FechaExigible,
                Amo.SaldoCapVigente,    Amo.SaldoCapAtrasa,     Amo.SaldoCapVencido,        Amo.SaldoCapVenNExi,    Cre.EmpresaID,
                Cre.SaldoCapVigent,     Cre.SaldoCapAtrasad,    Cre.SaldoCapVencido,        Cre.SaldCapVenNoExi,    Cre.SaldoInterOrdin,
                Cre.MonedaID,           Cre.Estatus,            Cre.ProductoCreditoID,      Amo.Estatus,            Cli.SucursalOrigen,
                Des.Clasificacion,      Amo.SaldoInteresAtr,    Amo.SaldoIntNoConta,        Amo.SaldoInteresPro,    Des.SubClasifID,
                Amo.SaldoInteresVen
            FROM AMORTICREDITO Amo,
                 CREDITOS    Cre,
              DESTINOSCREDITO Des,
                 CLIENTES Cli
            WHERE Amo.CreditoID = Cre.CreditoID
              AND Amo.CreditoID = Par_CreditoID
              AND Cre.ClienteID = Cli.ClienteID
              AND Cre.DestinoCreID  = Des.DestinoCreID
              AND Amo.Estatus = Estatus_Vigente
            AND (
                Cre.Estatus = Estatus_Vencido OR
                Cre.Estatus = Estatus_Suspendido
            );


    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.00;
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Estatus_Vigente := 'V';
    SET Estatus_Vencido := 'B';
    SET Nat_Cargo       := 'C';
    SET Nat_Abono       := 'A';

    SET Con_CapVigente  := 1;
    SET Con_CapVencido  := 3;
    SET Con_CapVenNoEx  := 4;
    SET Con_IngresosInt := 5;
    SET Con_CtaOrIntDev := 11;
    SET Con_CoCtaOrIntD := 12;
    SET Con_Balance     := 17;
    SET Con_ResultEPRC  := 18;
    SET Con_IntDevVig   := 19;
    SET Con_IntVencido  := 21;
    SET Con_BalIntere   := 36;
    SET Con_ResIntere   := 37;
    SET Con_PtePrinci   := 38;
    SET Con_PteIntere   := 39;
    SET Con_BalAdiEPRC  := 49;
    SET Con_PteAdiEPRC  := 50;
    SET Con_ResAdiEPRC  := 51;


    SET Mov_CapVigente  := 1;
    SET Mov_CapVencido  := 3;
    SET Mov_CapVenNoEx  := 4;
    SET Mov_IntVencido  := 12;
    SET Mov_IntDevNcont := 13;
    SET Mov_InterProv   := 14;

    SET Pol_Automatica  := 'A';
    SET Con_regularCred := 55;
    SET Par_SalidaNO    := 'N';
    SET AltaPoliza_NO   := 'N';
    SET AltaPoliza_SI   := 'S';
    SET AltaPolCre_SI   := 'S';
    SET AltaMovCre_NO   := 'N';
    SET AltaMovCre_SI   := 'S';
    SET AltaMovAho_NO   := 'N';

    SET EPRC_Resultados     := 'R';
    SET SI_DivideEPRC       := 'S';
    SET NO_DivideEPRC       := 'N';
    SET NO_EPRCAdicional    := 'N';
    SET SI_EPRCAdicional    := 'S';

    SET Des_Reserva     := 'CANC.ESTIM.INTERESES DEL PASO A VENC.';
    SET Des_RegCred     := 'REGULARIZACION DE CREDITO';
    SET Ref_RegCred     := 'REGULARIZACION DE CREDITO';

    SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);
    SET Estatus_Suspendido  := 'S';     -- Estatus Suspendido
    SET Con_CapVenNoExSup   := 113;     -- Concepto Contable: Capital Vencido no Exigible Suspendido
    SET Con_CapVigenteSup   := 110;     -- Concepto Contable: Capital Vigente Suspendido
    SET Con_CtaOrdIntSup    := 119;     -- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
    SET Con_CorIntOrdSup    := 120;     -- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
    SET Con_IntDevenSup     := 114;     -- Concepto Contable Interes Devengado Ssupencion
    SET Con_IntVencidoSup   := 116;     -- Concepto Contable: Interes Vencido
    SET Salida_SI           := 'S';

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                 'Disculpe las molestias que esto le ocasiona. Ref: SP-REGULARIZACREDPRO');
                SET Var_Control = 'sqlException' ;
            END;

    SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCAdicional INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCAdicional
        FROM PARAMSRESERVCASTIG
        WHERE EmpresaID = Par_EmpresaID;

    SET Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
    SET Var_DivideEPRC  := IFNULL(Var_DivideEPRC, NO_DivideEPRC);
    SET Var_EPRCAdicional   := IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

    CALL DIASFESTIVOSCAL(
        Par_Fecha,      Entero_Cero,        Var_FecApl,         Var_EsHabil,    Par_EmpresaID,
        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
        Aud_NumTransaccion);


    IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
        CALL MAESTROPOLIZASALT(
            Par_Poliza,         Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_regularCred,
            Ref_RegCred,        Par_SalidaNO,       Par_NumErr,     Par_ErrMen,         Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

        IF (Par_NumErr != Entero_Cero) THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SELECT Estatus
        INTO Var_CreEstatus
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

    OPEN CURSORPAGCREVEN;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORPAGCREVEN INTO
            Var_CreditoID,  Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
            Var_AmoCapVig,  Var_AmoCapAtra,     Var_AmoCapVen,      Var_AmoCaVeNex,     Var_EmpresaID,
            Var_CreCapVig,  Var_CreCapAtra,     Var_CreCapVen,      Var_CreCapVNE,      Var_CreIntOrd,
            Var_MonedaID,   Var_Estatus,        Var_ProdCreID,      Var_StatuAmort,     Var_SucCliente,
            Var_ClasifCre,  Var_IntAtrasado,    Var_IntNoCont,      Var_IntProvision,   Var_SubClasifID,
            Var_IntVencido;

        BEGIN

        SET Var_IntVencido := IFNULL(Var_IntVencido, Decimal_Cero);

        IF(Var_AmoCaVeNex > Decimal_Cero) THEN

            IF (Var_CreEstatus = Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_CapVenNoExSup;
                SET Mov_CarConta    := Con_CapVigenteSup;
            END IF;

            IF (Var_CreEstatus != Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_CapVenNoEx;
                SET Mov_CarConta    := Con_CapVigente;
            END IF;

            SET Mov_CarOpera    := Mov_CapVigente;
            SET Mov_AboOpera    := Mov_CapVenNoEx;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_AmoCaVeNex,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_AmoCaVeNex,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;



        IF (Var_IntProvision > Decimal_Cero) THEN




            IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

                IF(Var_DivideEPRC = NO_DivideEPRC) THEN
                    SET Mov_CarConta    := Con_Balance;
                ELSE
                    SET Mov_CarConta    := Con_BalIntere;
                END IF;
            ELSE
                SET Mov_CarConta    := Con_BalAdiEPRC;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntProvision,       Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_Reserva,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_CarConta,
                Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;



            IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

                IF(Var_DivideEPRC = NO_DivideEPRC) THEN

                    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                        SET Mov_AboConta    := Con_ResultEPRC;
                    ELSE
                        SET Mov_AboConta    := Con_PtePrinci;
                    END IF;
                ELSE

                    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                        SET Mov_AboConta    := Con_ResIntere;
                    ELSE
                        SET Mov_AboConta    := Con_PteIntere;
                    END IF;

                END IF;

            ELSE


                IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                    SET Mov_AboConta    := Con_ResAdiEPRC;
                ELSE
                    SET Mov_AboConta    := Con_PteAdiEPRC;
                END IF;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntProvision,       Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_AboConta,
                Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF (Var_IntNoCont > Decimal_Cero) THEN

            IF (Var_CreEstatus = Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_CtaOrdIntSup;
                SET Mov_CarConta    := Con_CorIntOrdSup;
            END IF;

            IF (Var_CreEstatus != Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_CtaOrIntDev;
                SET Mov_CarConta    := Con_CoCtaOrIntD;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntNoCont,          Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_CarConta,
                Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL  CONTACREDITOSPRO (
               Var_CreditoID,       Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntNoCont,          Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_AboConta,
                Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            IF (Var_CreEstatus = Estatus_Suspendido) THEN
                SET Mov_CarConta    := Con_IntDevenSup;
            END IF;

            IF (Var_CreEstatus != Estatus_Suspendido) THEN
                SET Mov_CarConta    := Con_IntDevVig;
            END IF;

            SET Mov_AboConta    := Con_IngresosInt;
            SET Mov_CarOpera    := Mov_InterProv;
            SET Mov_AboOpera    := Mov_IntDevNcont;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntNoCont,          Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntNoCont,          Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;


        IF (Var_IntVencido > Decimal_Cero) THEN





            IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

                IF(Var_DivideEPRC = NO_DivideEPRC) THEN
                    SET Mov_CarConta    := Con_Balance;
                ELSE
                    SET Mov_CarConta    := Con_BalIntere;
                END IF;
            ELSE
                SET Mov_CarConta    := Con_BalAdiEPRC;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntVencido,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_Reserva,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_CarConta,
                Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;


            IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

                IF(Var_DivideEPRC = NO_DivideEPRC) THEN

                    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                        SET Mov_AboConta    := Con_ResultEPRC;
                    ELSE
                        SET Mov_AboConta    := Con_PtePrinci;
                    END IF;
                ELSE

                    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                        SET Mov_AboConta    := Con_ResIntere;
                    ELSE
                        SET Mov_AboConta    := Con_PteIntere;
                    END IF;

                END IF;

            ELSE


                IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                    SET Mov_AboConta    := Con_ResAdiEPRC;
                ELSE
                    SET Mov_AboConta    := Con_PteAdiEPRC;
                END IF;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntVencido,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_AboConta,
                Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            IF (Var_CreEstatus = Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_IntVencidoSup;
                SET Mov_CarConta    := Con_IntDevenSup;
            END IF;

            IF (Var_CreEstatus != Estatus_Suspendido) THEN
                SET Mov_AboConta    := Con_IntVencido;
                SET Mov_CarConta    := Con_IntDevVig;
            END IF;

            SET Mov_AboOpera    := Mov_IntVencido;
            SET Mov_CarOpera    := Mov_InterProv;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntVencido,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            CALL  CONTACREDITOSPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,         Var_IntVencido,         Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,
                Entero_Cero,        Par_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Cadena_Vacia,       Par_SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;


        END;

         END LOOP;
    END;

    CLOSE CURSORPAGCREVEN;

    -- El credito de cartera suspendidas  no se requiere actualizacion de su estatus ya  que solo se regularizas los saldos de sus amortizaciones
    IF (Var_CreEstatus = Estatus_Suspendido) THEN
        UPDATE CREDITOS SET
            Estatus = Estatus_Suspendido,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
            WHERE CreditoID = Var_CreditoID;
    END IF;

    -- Se actualiza el estatus del credito a vigente cuando se regulariza
    IF (Var_CreEstatus != Estatus_Suspendido) THEN
        UPDATE CREDITOS SET
            Estatus = Estatus_Vigente,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion

            WHERE CreditoID = Var_CreditoID;
    END IF;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := 'Pago de Comision por Falta de Pago realizado Exitosamente.';
        SET Var_Control := 'creditoID';
        SET Var_Consecutivo := Par_CreditoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr      AS NumErr,
                Par_ErrMen      AS ErrMen,
                Var_Control     AS Control,
                Var_Consecutivo AS Consecutivo;
    END IF;

END TerminaStore$$