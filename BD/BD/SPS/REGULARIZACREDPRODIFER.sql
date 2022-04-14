DELIMITER ;
DROP PROCEDURE IF EXISTS REGULARIZACREDPRODIFER;

DELIMITER $$
CREATE PROCEDURE `REGULARIZACREDPRODIFER`(
    Par_CreditoID       BIGINT(12),
    Par_Fecha           DATE,
    Par_AltaEncPoliza   CHAR(1),
    inout Par_Poliza          BIGINT,
    Par_EmpresaID       INT(11),

    Par_Salida          CHAR(1),
    OUT Par_NumErr      INT(11),
    OUT Par_ErrMen      VARCHAR(400),
    Par_ModoPago        CHAR(1),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore: BEGIN


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



    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12, 2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Estatus_Vigente     CHAR(1);
    DECLARE Estatus_Vencido     CHAR(1);
    DECLARE Estatus_Atrasado    CHAR(1);
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
              AND Amo.Estatus IN (Estatus_Vencido,Estatus_Atrasado,Estatus_Vigente)
            AND Cre.Estatus IN (Estatus_Vigente,Estatus_Vencido);


    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.00;
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Estatus_Vigente := 'V';
    SET Estatus_Atrasado := 'A';
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

        CALL MAESTROPOLIZAALT(
            Par_Poliza,     Par_EmpresaID,  Var_FecApl,     Pol_Automatica,     Con_regularCred,
            Ref_RegCred,    Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

    END IF;

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


         IF(Var_AmoCapVen > Decimal_Cero) THEN
            SET Mov_AboConta    := Con_CapVencido;
            SET Mov_CarConta    := Con_CapVigente;
            SET Mov_CarOpera    := Mov_CapVigente;
            SET Mov_AboOpera    := Mov_CapVencido;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCapVen,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCapVen,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion  );

        END IF;


        IF(Var_AmoCaVeNex > Decimal_Cero) THEN
            SET Mov_AboConta    := Con_CapVenNoEx;
            SET Mov_CarConta    := Con_CapVigente;
            SET Mov_CarOpera    := Mov_CapVigente;
            SET Mov_AboOpera    := Mov_CapVenNoEx;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCaVeNex,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCaVeNex,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion  );

        END IF;

        IF(Var_AmoCapAtra > Decimal_Cero) THEN
            SET Mov_AboConta    := 2;
            SET Mov_CarConta    := Con_CapVigente;
            SET Mov_CarOpera    := Mov_CapVigente;
            SET Mov_AboOpera    := 2;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCapAtra,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_AmoCapAtra,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion  );

        END IF;


        IF (Var_IntNoCont > Decimal_Cero) THEN

            SET Mov_AboConta    := Con_CtaOrIntDev;
            SET Mov_CarConta    := Con_CoCtaOrIntD;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntNoCont,      Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_CarConta,
                Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntNoCont,      Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_AboConta,
                Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            SET Mov_AboConta    := Con_IngresosInt;
            SET Mov_CarConta    := Con_IntDevVig;
            SET Mov_CarOpera    := Mov_InterProv;
            SET Mov_AboOpera    := Mov_IntDevNcont;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntNoCont,      Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI   ,   Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntNoCont,      Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

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

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntVencido,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_Reserva,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_CarConta,
                Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);





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

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntVencido,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_AboConta,
                Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            SET Mov_AboConta    := Con_IntVencido;
            SET Mov_AboOpera    := Mov_IntVencido;

            SET Mov_CarConta    := Con_IntDevVig;
            SET Mov_CarOpera    := Mov_InterProv;


            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntVencido,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntVencido,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion  );
        END IF;


        IF(Var_IntAtrasado > Decimal_Cero) THEN
            SET Mov_AboConta    := 20;
            SET Mov_CarConta    := Con_IntDevVig;
            SET Mov_CarOpera    := Mov_InterProv;
            SET Mov_AboOpera    := 11;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntAtrasado,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,
                Par_Fecha,          Var_FecApl,             Var_IntAtrasado,     Var_MonedaID,
                Var_ProdCreID,      Var_ClasifCre,          Var_SubClasifID,    Var_SucCliente,
                Des_RegCred,        Ref_RegCred,            AltaPoliza_NO,      Entero_Cero,
                Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
                Cadena_Vacia,       Cadena_Vacia,           /*Par_SalidaNO,*/       Par_NumErr,
                Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion  );

        END IF;


        END;

        UPDATE AMORTICREDITO SET
        Estatus = Estatus_Vigente,

        Usuario             = Aud_Usuario,
        FechaActual         = Aud_FechaActual,
        DireccionIP         = Aud_DireccionIP,
        ProgramaID          = Aud_ProgramaID,
        Sucursal            = Aud_Sucursal,
        NumTransaccion      = Aud_NumTransaccion

        WHERE CreditoID     = Var_CreditoID
        AND AmortizacionID  = Var_AmortizacionID;


         END LOOP;
    END;

    CLOSE CURSORPAGCREVEN;

    UPDATE CREDITOS SET
        Estatus = Estatus_Vigente,

        Usuario             = Aud_Usuario,
        FechaActual         = Aud_FechaActual,
        DireccionIP         = Aud_DireccionIP,
        ProgramaID          = Aud_ProgramaID,
        Sucursal            = Aud_Sucursal,
        NumTransaccion      = Aud_NumTransaccion

        WHERE CreditoID     = Var_CreditoID;

END TerminaStore$$
