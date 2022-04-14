-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACAMBIOFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACAMBIOFONDEOPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTACAMBIOFONDEOPRO`(
# =====================================================================================
# ----- STORE QUE REALIZA LA CONTABILIDAD DE CAMBIO DE FUENTE DE FONDEADOR ---
# =====================================================================================
    Par_CreditoID           BIGINT(12),         -- Indica el numero de Credito
    Par_FechaAplicacion     DATE,               -- Fecha de Aplicacion
    Par_MonedaID            INT(11),            -- moneda
    Par_ProdCreditoID       INT(11),            -- producto del credito
    Par_AltaEncPoliza       CHAR(1),            -- indica alta en el encabezado de la poliza

    Par_NatCredito          CHAR(1),            -- Naturaleza del movimiento
    Par_ConceptoCon         INT(11),            -- Concepto contable
    Par_Descripcion         VARCHAR(100),       -- Descripcion del movimiento
    INOUT Par_Poliza        BIGINT(12),         -- numero de poliza

    Par_Salida              CHAR(1),            -- indica una salida
    INOUT   Par_NumErr      INT(11),            -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),       -- mensaje de error

    Par_EmpresaID           INT(11),            -- parametros de auditoria
    Aud_Usuario             INT(11),            -- parametros de auditoria
    Aud_FechaActual         DATETIME ,          -- parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),        -- parametros de auditoria
    Aud_ProgramaID          VARCHAR(70),        -- parametros de auditoria
    Aud_Sucursal            INT(11),            -- parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)          -- parametros de auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Cargos          DECIMAL(14,4);
    DECLARE Var_Abonos          DECIMAL(14,4);
    DECLARE Var_CuentaStr       VARCHAR(20);
    DECLARE Var_CreditoStr      VARCHAR(20);
    DECLARE Var_Control         VARCHAR(100);               -- Variable de control
    DECLARE Var_Consecutivo     VARCHAR(20);                -- Variable consecutivo
    DECLARE Var_SucCliente      INT(11);                    -- Sucursal origen del cliente
    DECLARE Var_ClasifCre       CHAR(1);                    -- Clasificacion
    DECLARE Var_IVAIntOrd       CHAR(1);
    DECLARE Var_MonedaID        INT(11);
    DECLARE Var_FechaVencim     DATE;
    DECLARE Var_SubClasifID     INT(11);
    DECLARE Var_EsRevolvente    CHAR(1);                    -- Variable para saber si es revolvente la linea */
    DECLARE Var_CalInteresID    INT(11);
    DECLARE Var_SaldoCapVigente DECIMAL(16,2);      -- Saldo Capital Vigente
    DECLARE Var_SaldoInteresOrd DECIMAL(16,2);      -- Saldo Interes Vigenre
    DECLARE Var_SaldoCapAtrasa  DECIMAL(16,2);      -- Saldo Capital Atrasado
    DECLARE Var_SaldoInteresAtr DECIMAL(16,2);      -- Saldo Interes Atrasado
    DECLARE Var_SaldoCapVencido DECIMAL(16,2);      -- Saldo Capital Vencido
    DECLARE Var_SaldoInteresVen DECIMAL(16,2);      -- Saldo Interes Vencido
    DECLARE Var_SaldoCapVenNExi DECIMAL(16,2);      -- Saldo Capital Vencido no Exigible

    DECLARE Var_ConsecutivoID   BIGINT(20);
    DECLARE Var_FecVenCred      DATE;
    DECLARE Var_Descripcion     VARCHAR(150);
    -- Declaracion de Constantes
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT;
    DECLARE Decimal_Cero    DECIMAL(12, 2);
    DECLARE AltaPoliza_SI   CHAR(1);
    DECLARE AltaMovAho_SI   CHAR(1);
    DECLARE AltaMovCre_SI   CHAR(1);
    DECLARE AltaPolCre_SI   CHAR(1);
    DECLARE Nat_Cargo       CHAR(1);
    DECLARE Nat_Abono       CHAR(1);
    DECLARE Pol_Automatica  CHAR(1);
    DECLARE Salida_No       CHAR(1);
    DECLARE Con_AhoCapital  INT;
    DECLARE Salida_SI       CHAR(1);
    DECLARE EstatusPagado   CHAR(1);
    DECLARE Mon_MinPago     DECIMAL(12,2);
    DECLARE Con_InteresDev  INT(11);        -- CONCEPTOSCARTERA 19.- Interes Devengado Vigente
    DECLARE Con_InteresAtra INT(11);        -- CONCEPTOSCARTERA 20.- Interes Atrasado
    DECLARE Con_InteresVenc INT(11);        -- CONCEPTOSCARTERA 21.- Interes Vencido
    DECLARE Con_CapVigente  INT(11);        -- CONCEPTOSCARTERA 1.- Cartera Vigente
    DECLARE Con_CapAtrasado      INT(11);   -- CONCEPTOSCARTERA 2.- Cartera Atrasada
    DECLARE Con_CapVencido       INT(11);   -- CONCEPTOSCARTERA 3.- Cartera Vencida
    DECLARE Con_CapVenNoExigible INT(11);   -- CONCEPTOSCARTERA 4.- Cartera Vencida No Exigible

    -- Asignacion de Constantes
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.00;
    SET AltaPoliza_SI   := 'S';
    SET AltaMovAho_SI   := 'S';
    SET AltaMovCre_SI   := 'S';
    SET AltaPolCre_SI   := 'S';
    SET Nat_Cargo       := 'C';
    SET Nat_Abono       := 'A';
    SET Pol_Automatica  := 'A';
    SET Salida_No       := 'N';
    SET Con_AhoCapital  := 1;
    SET Salida_SI       := 'S';
    SET EstatusPagado   := 'P';
    SET Mon_MinPago     := 0.01;
    SET Con_InteresDev  := 19;
    SET Con_InteresAtra := 20;
    SET Con_InteresVenc := 21;
    SET Con_CapVigente  := 1;
    SET Con_CapAtrasado      := 2;
    SET Con_CapVencido       := 3;
    SET Con_CapVenNoExigible := 4;
    SET Var_CreditoStr  := CONCAT("Cred.",CONVERT(Par_CreditoID, CHAR(20)));
    SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTACAMBIOFONDEOPRO');
            SET Var_Control := 'sqlException' ;
        END;

        -- obtenbemos los valores para clasificacion y sub. clasificacion
        SELECT  Cli.SucursalOrigen,     Des.Clasificacion,      Pro.CobraIVAInteres,    Cre.MonedaID,           Cre.FechaVencimien,
                Des.SubClasifID,        Pro.EsRevolvente,       Cre.CalcInteresID

        INTO    Var_SucCliente,         Var_ClasifCre,          Var_IVAIntOrd,          Var_MonedaID,           Var_FecVenCred,
                Var_SubClasifID,        Var_EsRevolvente,       Var_CalInteresID
        FROM    PRODUCTOSCREDITO Pro,
                CLIENTES Cli,
                DESTINOSCREDITO Des,
                CREDITOS Cre
        WHERE Cre.CreditoID         = Par_CreditoID
            AND Cre.ProductoCreditoID   = Pro.ProducCreditoID
            AND Cre.ClienteID           = Cli.ClienteID
            AND Cre.DestinoCreID        = Des.DestinoCreID
            AND Cre.EsAgropecuario = Salida_SI;

        -- Se obtienen los saldos
        SELECT
            -- Capital Vigente
            IFNULL(SUM(ROUND(Amo.SaldoCapVigente,2)),Entero_Cero),
            -- Intereses Vigente
            IFNULL(SUM(ROUND(Amo.SaldoInteresOrd+Amo.SaldoInteresPro,2)),Entero_Cero),
            -- Capital Atrasado
            IFNULL(SUM(ROUND(Amo.SaldoCapAtrasa,2)),Entero_Cero),
            -- Intereses Atrasado
            IFNULL(SUM(ROUND(Amo.SaldoInteresAtr,2)),Entero_Cero),
            -- Capital Vencido
            IFNULL(SUM(ROUND(Amo.SaldoCapVencido,2)),Entero_Cero),
            -- Intereses Vencido
            IFNULL(SUM(ROUND(Amo.SaldoInteresVen,2)),Entero_Cero),
            -- Capital Ven. No Exigible
            IFNULL(SUM(ROUND(Amo.SaldoCapVenNExi,2)),Entero_Cero)
        INTO Var_SaldoCapVigente,   Var_SaldoInteresOrd,    Var_SaldoCapAtrasa,   Var_SaldoInteresAtr,
             Var_SaldoCapVencido,   Var_SaldoInteresVen,    Var_SaldoCapVenNExi
        FROM AMORTICREDITO Amo,
                CREDITOS Cre
        WHERE Cre.CreditoID = Par_CreditoID
          AND Cre.CreditoID = Amo.CreditoID
          AND Amo.Estatus <> EstatusPagado
          AND Cre.EsAgropecuario = Salida_SI;

        IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
            CALL MAESTROPOLIZASALT(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Pol_Automatica,         Par_ConceptoCon,
                Par_Descripcion,    Salida_No,          Par_NumErr,             Par_ErrMen,             Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        -- Se realiza llamada para  capital Vigente
        IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE CAPITAL VIGENTE';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoCapVigente;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoCapVigente;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_CapVigente,     Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

         -- Se realiza llamada para  interes Vigente
        IF (Var_SaldoInteresOrd >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE INTERES VIGENTE';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoInteresOrd;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoInteresOrd;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_InteresDev,     Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        -- Se realiza llamada para  capital Atrasado
        IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE CAPITAL ATRASADO';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoCapAtrasa;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoCapAtrasa;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_CapAtrasado,    Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

         -- Se realiza llamada para  interes Atrasado
        IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE INTERES ATRASADO';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoInteresAtr;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoInteresAtr;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_InteresAtra,    Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        -- Se realiza llamada para  capital Vencido
        IF (Var_SaldoCapVencido >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE CAPITAL VENCIDO';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoCapVencido;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoCapVencido;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_CapVencido,     Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

         -- Se realiza llamada para  interes
        IF (Var_SaldoInteresVen >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE INTERES VENCIDO';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoInteresVen;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoInteresVen;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,      Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_InteresVenc,    Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,       Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,         Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        -- Se realiza llamada para  capital
        IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

            SET Var_Descripcion:= 'CAMBIO DE CAPITAL VENCIDO NO EXIGIBLE';

            IF(Par_NatCredito = Nat_Cargo) THEN
                SET Var_Cargos  := Var_SaldoCapVenNExi;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Var_SaldoCapVenNExi;
            END IF;

            CALL POLIZASCREDITOPRO(
                Par_Poliza,         Par_EmpresaID,          Par_FechaAplicacion,    Par_CreditoID,      Par_ProdCreditoID,
                Var_SucCliente,     Con_CapVenNoExigible,   Var_ClasifCre,          Var_SubClasifID,    Var_Cargos,
                Var_Abonos,         Par_MonedaID,           Var_Descripcion,        Var_CreditoStr,     Salida_No,
                Par_NumErr,         Par_ErrMen,             Var_ConsecutivoID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := CONCAT('Informacion Procesada Exitosamente.');
        SET Var_Control := 'creditoID' ;
        SET Var_Consecutivo := Par_CreditoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
                Par_ErrMen  AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$