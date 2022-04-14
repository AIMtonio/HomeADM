-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGRUPALORDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGRUPALORDPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOGRUPALORDPRO`(
  Par_GrupoID         INT,        -- Indica el número de grupo
  Par_MontoPagar      DECIMAL(12,2),    -- Indica el monto total a pagar
  Par_CuentaPago      BIGINT(12),     -- Indica la cuenta de la cual se realiza el pago
  Par_MonedaID        INT,        -- Indica el tipo de moneda
  Par_FormaPago       CHAR(1),      -- Indica la forma de pago

  Par_CicloGrupo      INT,        -- Indica el  ciclo del grupo
  Par_EmpresaID       INT,        -- Indica el número de empresa
  Par_AltaEncPoliza   CHAR(1),      -- Indica si requiere alta en encabezado de poliza
  Par_OrigenPago			CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
  Par_Salida          CHAR(1),

INOUT Var_Poliza    BIGINT,       -- Indica el número de poliza
INOUT Var_MontoPago   DECIMAL(12,2),    -- Monto total del Pago Aplicado
INOUT Par_NumErr      INT(11),
INOUT Par_ErrMen      VARCHAR(400),
INOUT Par_Consecutivo   BIGINT,

  -- Parametros de Auditoria
  Aud_Usuario       INT,
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT,
  Aud_NumTransaccion  BIGINT
)

TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE Var_MontoCreOri   DECIMAL(14,2);    -- Indica el Monto Original del crédito
  DECLARE Var_FechaSis      DATETIME;     -- Indica la Fecha del Sistma
  DECLARE Var_NumCiclo      INT;        -- Indica el Número del Ciclo
  DECLARE Var_TotalCiclo    INT;        -- Indica el total de Ciclo
  DECLARE Var_PorcPago      DECIMAL(14,8);    -- Indica el Porcentaje del Pago

  DECLARE Var_PagoIndiv     DECIMAL(14,2);    -- Indica el Monto de Pago Individual
  DECLARE Var_AcumPagos     DECIMAL(14,2);    -- Indica el Monto Acumulado de los pagos individuales
  DECLARE Var_CreditoStr    VARCHAR(20);    -- Indica el núermo de crédito en cadena
  DECLARE Var_MontoAplic    DECIMAL(14,2);    -- Indica el monto del pago Aplicado
  DECLARE Var_ExiGrupo      DECIMAL(14,2);    -- Indica el Monto del Ecigible Grupal

  DECLARE Var_TotGrupo      DECIMAL(14,2);    -- Indica el total grupal
  DECLARE Var_SumTotPagar   DECIMAL(14,2);    -- Indica la Suma de todas las amortizaciones
  DECLARE Var_MaxCredito    BIGINT;       -- Indica el Número de Crédito Mayor
  DECLARE Var_MaxAmorti     INT;        -- Indica el número de la amortización mayor
  DECLARE Var_CreditoID     BIGINT;       -- Indica el número de crédito

  DECLARE Var_AmortiCreID   INT;        -- Indica el número de amortización
  DECLARE Var_CuentaID      BIGINT;       -- Indica el número de cliente
  DECLARE Var_ClienteID     BIGINT;       -- Indica el número de cuenta
  DECLARE Var_MonedaID      INT;        -- Indica el tipo de moneda
  DECLARE Var_SolCredID     BIGINT;       -- Indica el número de solicitud de crédito

  DECLARE Var_MontoAutorizado DECIMAL(14,2);    -- Indica el monto autorizado para el pago
  DECLARE Var_SucCliente    INT;        -- Indica el número de sucursal del crédito
  DECLARE Var_ExiCredito    DECIMAL(14,2);    -- Indica el Exigible por cada Crédito
  DECLARE Var_ExiAmorti     DECIMAL(14,2);    -- Indica el Exigible por Amortización Grupal
  DECLARE Var_TotCredito    DECIMAL(14,2);    -- Indica el Monto Total del Crédito

  DECLARE Var_SaldoPago     DECIMAL(14,2);    -- Indica el Saldo Pendiente de Pago
  DECLARE Var_MontoDesbloqueo DECIMAL(14,2);    -- Indica el monto de los desbloqueos por garantias
  DECLARE Var_MontoAbono    DECIMAL(14,2);    -- Indica el monto del Abono para tranferir entre cuentas
  DECLARE Var_MontoBloqueo  DECIMAL(14,2);    -- Indica el monto de los bloqueos por garantías
  DECLARE Var_ClienteIDTrans  INT(11);      -- Indica el número del cliente que realiza el pago

  DECLARE Var_MontoTranfer  DECIMAL(14,2);    -- Indica el monto que tranfiere entre cuentas en caso de garantías
    DECLARE Var_MontoAbonoGar   DECIMAL(14,2);    -- Indica el monto total de bloqueos y desbloqueos por garantías
  DECLARE Var_CobraFOGAFI   CHAR(1);      -- Indica si cobra o no Garantía Financiada
    DECLARE Var_Consecutivo   INT(11);
    DECLARE NumIteraciones    INT(11);
  DECLARE Var_ExisteCreditos  INT(11);    -- Variable para almacenar si existe creditos para realizar pagos

  -- Declaracion de Constantes
  DECLARE Entero_Cero       INT;        -- Constante: Entero Cero
  DECLARE Decimal_Cero      INT;        -- Constante: Decimal Cero
  DECLARE Par_SalidaNO      CHAR(1);      -- Constante: Salida No
  DECLARE Par_SalidaSI      CHAR(1);      -- Constante: Salida Si
  DECLARE Si_Prorratea      CHAR(1);      -- Constante: Si Prorratea

  DECLARE Nat_Cargo         CHAR(1);      -- Naturaleza Cargos 'C'
  DECLARE Nat_Abono         CHAR(1);      -- Naturaleza Abonos 'A'
  DECLARE AltaPoliza_NO     CHAR(1);      -- Alta Encabezado Poliza No
  DECLARE AltaPoliza_SI     CHAR(1);      -- Alta Encabezado Poliza Si
  DECLARE AltaMovAho_SI     CHAR(1);      -- Alta movimiento de Ahorro Si

  DECLARE Pol_Automatica    CHAR(1);      -- Poliza Automátiza
  DECLARE Coc_PagoCred      INT;        -- Concepto Contale Pago de Crédito
  DECLARE Con_AhoCapital    INT;        -- Concepto Contable Capital
  DECLARE Cadena_Vacia    CHAR(1);      -- Constante: Cadena Vacía
  DECLARE Esta_Activo       CHAR(1);      -- Estatus Activo

  DECLARE Esta_Vencido      CHAR(1);      -- Estatus Vencido
  DECLARE Esta_Vigente      CHAR(1);      -- Estatus Vigente
  DECLARE Esta_Pagado       CHAR(1);      -- Estatus Pagado
  DECLARE SI_EsPrePago      CHAR(1);      -- Si Es Prepago
  DECLARE SI_EsFiniquito    CHAR(1);      -- Si es Finiquito

  DECLARE NO_EsPrePago      CHAR(1);      -- No Es Prepago
  DECLARE NO_EsFiniquito    CHAR(1);      -- No Es Finiquito
  DECLARE Pago_Ordinario    CHAR(1);      -- Pago de Crédito Ordinario
  DECLARE Pago_Finiquito    CHAR(1);      -- Pago Finiquito de Crédito
  DECLARE Pago_Anticipado   CHAR(1);      -- Pago de Crédito Anticipado

  DECLARE Forma_CargoCue    CHAR(1);      -- Forma de Pago con Cargo a Cuenta
  DECLARE Forma_Efectivo    CHAR(1);      -- Forma de Pago en Efectivo
  DECLARE Des_DepPagCre     VARCHAR(50);    -- Descripción Detalle Pago de Crédito
  DECLARE Des_ConPagCre     VARCHAR(50);    -- Descripción Concepto Pago de Crédito
  DECLARE Aho_DepEfeVen     CHAR(4);      -- Tipo de depósito en efectivo

  DECLARE Var_CicloActual     INT;        -- Indica el ciclo actual del grupo
  DECLARE Con_Origen        CHAR(1);      -- Constante: Origen de la ejecución
  DECLARE Desbloqueo        CHAR(1);      -- Naturaleza de Bloqueo 'B'
  DECLARE Bloqueos        CHAR(1);      -- Naturaleza de Desbloqueos 'D'
  DECLARE TipoBloqFOGAFI    INT(11);      -- Tipo de Bloqueo para FOGAFI

  DECLARE TipoBloqFOGA      INT(11);      -- Tipo de Bloqueo para FOGA
  DECLARE CuentaInterna   CHAR(1);      -- Cuenta Interna
  DECLARE DescripcionMov    VARCHAR(100);   -- Descripción del Movimiento
  DECLARE ReferenciaMov     VARCHAR(100);   -- Referencia del Movimiento
  DECLARE Mov_TraspasoCta   CHAR(4);      -- Movimiento de Traspaso entre cuentas

  DECLARE Con_TransfCta     INT(11);      -- Concepto Contable Tranferencia entre cuentas
  DECLARE AltaMovPoliza_SI  CHAR(1);      -- Alta de Movimiento de Poliza Si
  DECLARE RespaldaCredSI    CHAR(1);
  DECLARE Con_NO            CHAR(1);      -- Constante NO
  DECLARE Aplica_Cuenta     CHAR(1);      -- Constante Aplica a Cuenta de Ahorro
  DECLARE Estatus_Suspendido CHAR(1);     -- Estatus Suspendido

  -- Cursor Para Asignar el Monto del Pago por Amortizacion
  DECLARE CURSORGRUPO CURSOR FOR
    SELECT MAX(CreditoID), AmortizacionID,  SUM(MontoExigible)
    FROM TMPAMORTIPAGOGRUPO
    WHERE NumTransaccion = Aud_NumTransaccion
    GROUP BY AmortizacionID;


  -- Cursor Para Mandar Pagar el Cada Credito
  DECLARE CURSORPAGO CURSOR FOR
    SELECT Cre.CreditoID, MAX(Cre.CuentaID), MAX(Cre.ClienteID), MAX(Cre.MonedaID),
       MAX(Cli.SucursalOrigen)
    FROM TMPAMORTIPAGOGRUPO Tem,
       CREDITOS Cre,
         CLIENTES Cli
    WHERE Tem.NumTransaccion = Aud_NumTransaccion
      AND Tem.CreditoID = Cre.CreditoID
      AND Cre.ClienteID = Cli.ClienteID
    GROUP BY Cre.CreditoID
    ORDER BY Cre.CreditoID;

  -- Asignacion de Constantes
  SET Entero_Cero       := 0;         -- Entero en Cero
  SET Decimal_Cero      := 0.00;      -- Decimal en Cero
  SET Par_SalidaNO      := 'N';       -- Salida: NO
  SET Par_SalidaSI      := 'S';       -- Salida: SI
  SET Si_Prorratea      := 'S';       -- Si prorratea el pago en el grupo

  SET Nat_Cargo         := 'C';       -- Naturaleza de Cargo
  SET Nat_Abono         := 'A';       -- Naturaleza de Abono
  SET AltaPoliza_NO     := 'N';       -- Alta del Encabezado de la Poliza: NO
  SET AltaPoliza_SI     := 'S';       -- Alta del Encabezado de la Poliza: SI
  SET AltaMovAho_SI     := 'S';       -- Alta del Movimiento de Ahorro: SI

  SET Con_AhoCapital    := 1;         -- Concepto de Ahorro: Capital
  SET Pol_Automatica    := 'A';       -- Tipo de Poliza Automatica
  SET Coc_PagoCred      := 54;        -- Concepto Contable: Pago de Credito
  SET Esta_Activo       := 'A';       -- Estatus: Activo
  SET Esta_Vencido      := 'B';       -- Estatus: Vencido

  SET Esta_Vigente      := 'V';       -- Estatus: Vigente
  SET Esta_Pagado       := 'P';       -- Estatus: Pagado
  SET SI_EsPrePago      := 'S';       -- Es Prepago: SI
  SET SI_EsFiniquito    := 'S';       -- Es Finiquito: SI
  SET NO_EsPrePago      := 'N';       -- Es Prepago: NO

  SET NO_EsFiniquito    := 'N';       -- Es Finiquito: NO
  SET Pago_Ordinario    := 'O';       -- Tipo de Pago: Ordinario
  SET Pago_Finiquito    := 'F';       -- Tipo de Pago: Finiquito
  SET Pago_Anticipado   := 'A';       -- Tipo de Pago: Anticipado
  SET Forma_CargoCue    := 'C';       -- Forma de Pago: Con Cargo a Cuenta

  SET Forma_Efectivo    := 'E';       -- Forma de Pago: Efectivo
  SET Aho_DepEfeVen     := '10';      -- Tipo de Deposito en Efectivo
  SET Des_DepPagCre     := 'DEP.PAGO DE CREDITO'; -- Descripcion Operativa
  SET Des_ConPagCre     := 'PAGO DE CREDITO';   -- Descripcion Contable
  SET Aud_ProgramaID    := 'PAGOCREDITOPRO';    -- Programa ID

  SET Con_Origen      := 'S';       -- Constante Origen donde se llama el SP (S= safy, W=WS)
  SET Desbloqueo      := 'D';     -- Naturaleza Desbloqueos
  SET Bloqueos        := 'B';     -- Naturaleza Bloqueos
  SET TipoBloqFOGAFI    := 20;      -- Tipo de Bloqueo para FOGAFI
  SET TipoBloqFOGA      := 8;     -- Tipo de Bloqueo para FOGA

  SET Cadena_Vacia    := '';      -- Constante: Cadena Vacía
  SET CuentaInterna   := 'I';     -- Cuenta Interna
  SET DescripcionMov    := 'TRANSFERENCIA A CUENTA';
  SET ReferenciaMov   := 'GARANTIA LIQUIDA FINANCIADA';
  SET Mov_TraspasoCta   := '12';    -- TIPOSMOVSAHO: Traspaso Cuenta Interna

  SET Con_TransfCta   := 90;      -- Concepto Contable Transerencia entre cuentas
  SET AltaMovPoliza_SI  := 'S';     -- Alta Movimiento Poliza Si
  SET RespaldaCredSI      := 'S';
  SET Con_NO            := 'N';
  SET Aplica_Cuenta     := 'S';
  SET Estatus_Suspendido := 'S';  -- Estatus Suspendido

  ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOGRUPALORDPRO');
        END;

    SELECT CicloActual INTO Var_CicloActual
      FROM  GRUPOSCREDITO
      WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    SELECT FechaSistema INTO Var_FechaSis
      FROM PARAMETROSSIS;

    DELETE FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPCREDITOPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPGRUPOPAGO
      WHERE NumTransaccion = Aud_NumTransaccion;

    IF(Par_CicloGrupo = Var_CicloActual) THEN
      INSERT INTO `TMPAMORTIPAGOGRUPO` (
      `NumTransaccion`, `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAPagar`)

      SELECT  Aud_NumTransaccion, Cre.CreditoID, Amo.AmortizacionID,
        FUNCIONCONPAGOANTAMOR(Amo.CreditoID, Amo.AmortizacionID),
        Entero_Cero

        FROM INTEGRAGRUPOSCRE Ing,
         SOLICITUDCREDITO Sol,
         AMORTICREDITO Amo,
         CREDITOS Cre

        LEFT OUTER JOIN CREDDIASPAGANT Dpa ON Dpa.ProducCreditoID = Cre.ProductoCreditoID
                AND Dpa.Frecuencia = Cre.FrecuenciaCap

        WHERE Ing.GrupoID               = Par_GrupoID
        AND Ing.Estatus               = Esta_Activo
        AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
        AND Ing.ProrrateaPago         = Si_Prorratea
        AND Sol.CreditoID             = Cre.CreditoID
        AND (   Cre.Estatus   = Esta_Vigente
           OR  Cre.Estatus    = Esta_Vencido
           OR  Cre.Estatus    = Estatus_Suspendido
        )
        AND Cre.CreditoID = Amo.CreditoID
        AND Amo.Estatus != Esta_Pagado
        AND Amo.FechaExigible <= ADDDATE(Var_FechaSis, IFNULL(Dpa.NumDias, Entero_Cero));

    ELSE

      INSERT INTO `TMPAMORTIPAGOGRUPO` (
      `NumTransaccion`, `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAPagar`)

      SELECT  Aud_NumTransaccion, Cre.CreditoID, Amo.AmortizacionID,
        FUNCIONCONPAGOANTAMOR(Amo.CreditoID, Amo.AmortizacionID),
        Entero_Cero

        FROM `HIS-INTEGRAGRUPOSCRE` Ing,
           SOLICITUDCREDITO Sol,
         AMORTICREDITO Amo,
           CREDITOS Cre
        LEFT OUTER JOIN CREDDIASPAGANT Dpa ON Dpa.ProducCreditoID = Cre.ProductoCreditoID
                AND Dpa.Frecuencia = Cre.FrecuenciaCap

        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.Estatus               = Esta_Activo
          AND Cre.CicloGrupo            = Par_CicloGrupo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Sol.CreditoID             = Cre.CreditoID
          AND (   Cre.Estatus   = Esta_Vigente
             OR  Cre.Estatus    = Esta_Vencido
             OR  Cre.Estatus    = Estatus_Suspendido
          )
        AND Cre.CreditoID = Amo.CreditoID
        AND Amo.Estatus != Esta_Pagado
        AND Amo.FechaExigible <= ADDDATE(Var_FechaSis, IFNULL(Dpa.NumDias, Entero_Cero));

    END IF;

  -- Se realiza conteo para ver si existe creditos para realizar los pagos
  SET Var_ExisteCreditos  := Entero_Cero;
  SET Var_ExisteCreditos  := (SELECT COUNT(*) FROM TMPAMORTIPAGOGRUPO WHERE NumTransaccion = Aud_NumTransaccion);
  SET Var_ExisteCreditos  := IFNULL(Var_ExisteCreditos,Entero_Cero);
  IF(Var_ExisteCreditos = Entero_Cero)THEN
    SET Par_NumErr  := 001;
    SET Par_ErrMen  := CONCAT('No existen Creditos que presentan adeudos para el Grupo ', Par_GrupoID);
    LEAVE ManejoErrores;
  END IF;

    INSERT INTO TMPCREDITOPAGOGRUPO(
      `NumTransaccion`, `AmortizacionID`, `MontoExigible`)

      SELECT Aud_NumTransaccion, AmortizacionID, SUM(MontoExigible)
      FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion
      GROUP BY AmortizacionID;
    -- Inicializaciones
    SET Var_MontoAplic  := Decimal_Cero;
    SET Var_SaldoPago   := Par_MontoPagar;

        -- Obtiene el parámetro que indica si cobra o no garnatia financiada.
        SET Var_CobraFOGAFI := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CobraGarantiaFinanciada');

        -- Obtiene movimientos de Bloqueos y Desbloqueos si cobra FOGA o FOGAFI
        IF(Var_CobraFOGAFI='S')THEN
      SET Var_MontoDesbloqueo := (SELECT SUM(BLOQ.MontoBloq) FROM BLOQUEOS BLOQ
              INNER JOIN CREDITOS CRE
                ON CRE.CreditoID  = BLOQ.Referencia
                AND BLOQ.CuentaAhoID = CRE.CuentaID
              WHERE BLOQ.NatMovimiento = Desbloqueo
              AND CRE.GrupoID = Par_GrupoID
              AND CRE.CicloGrupo = Par_CicloGrupo
              AND BLOQ.TiposBloqID IN (TipoBloqFOGAFI,TipoBloqFOGA)
              AND BLOQ.NumTransaccion = Aud_NumTransaccion);

      SET Var_MontoDesbloqueo := IFNULL(Var_MontoDesbloqueo,Entero_Cero);

      IF(Var_MontoDesbloqueo>Entero_Cero)THEN
        SET Var_MontoBloqueo := (SELECT SUM(BLOQ.MontoBloq) FROM BLOQUEOS BLOQ
                INNER JOIN CREDITOS CRE
                  ON CRE.CreditoID  = BLOQ.Referencia
                  AND BLOQ.CuentaAhoID = CRE.CuentaID
                WHERE BLOQ.NatMovimiento = Bloqueos
                AND CRE.GrupoID = Par_GrupoID
                AND CRE.CicloGrupo = Par_CicloGrupo
                AND BLOQ.TiposBloqID IN (TipoBloqFOGAFI,TipoBloqFOGA)
                AND BLOQ.NumTransaccion = Aud_NumTransaccion);
      END IF;

            SET Var_MontoBloqueo := IFNULL(Var_MontoBloqueo,Entero_Cero);

            SET Var_MontoAbonoGar := Var_MontoDesbloqueo - Var_MontoBloqueo;

        END IF;
        SET Var_MontoAbonoGar := IFNULL(Var_MontoAbonoGar,Entero_Cero);

    IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
      CALL MAESTROPOLIZAALT(
        Var_Poliza,     Par_EmpresaID,  Var_FechaSis,   Pol_Automatica,     Coc_PagoCred,
        Des_ConPagCre,  Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
    END IF;


    OPEN CURSORGRUPO;

    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
      CICLO:LOOP

      FETCH CURSORGRUPO INTO
      Var_CreditoID,  Var_AmortiCreID,  Var_ExiAmorti;

      -- Inicializacion
      SET Var_ExiCredito  := Entero_Cero;

      IF(Var_SaldoPago <= Decimal_Cero) THEN
      LEAVE CICLO;
      END IF;

      SELECT MontoExigible INTO Var_ExiCredito
      FROM TMPCREDITOPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion
        AND AmortizacionID = Var_AmortiCreID;

      SET Var_ExiCredito := IFNULL(Var_ExiCredito, Entero_Cero);

      -- Si Completa a Pagar el Saldo de las Amortizaciones Indicadas
      IF(Var_SaldoPago >=  Var_ExiCredito) THEN
      UPDATE TMPAMORTIPAGOGRUPO SET
        MontoAPagar = MontoExigible
        WHERE NumTransaccion = Aud_NumTransaccion
        AND AmortizacionID = Var_AmortiCreID;

      SET Var_SaldoPago := Var_SaldoPago - Var_ExiCredito;

      ELSE
      UPDATE TMPAMORTIPAGOGRUPO SET
        MontoAPagar = ROUND(IF(Var_ExiCredito != Entero_Cero, (MontoExigible / Var_ExiCredito), Entero_Cero) * Var_SaldoPago,2)
        WHERE NumTransaccion = Aud_NumTransaccion
        AND AmortizacionID = Var_AmortiCreID;

      SET Var_SaldoPago := Entero_Cero;

      END IF;

      IF(Var_SaldoPago <= Decimal_Cero) THEN
      LEAVE CICLO;
      END IF;

      END LOOP CICLO;
    END;

    CLOSE CURSORGRUPO;


    IF (Par_NumErr <> Entero_Cero)THEN
      LEAVE ManejoErrores;
    END IF;

    -- Consideraciones de Redondeos y Centavos
    SELECT SUM(MontoAPagar) INTO Var_SumTotPagar
      FROM TMPAMORTIPAGOGRUPO Tem
      WHERE Tem.NumTransaccion = Aud_NumTransaccion;

    SET Var_SumTotPagar := IFNULL(Var_SumTotPagar, Entero_Cero);

    IF(Var_SumTotPagar != Par_MontoPagar) THEN

      SELECT MAX(CreditoID), MAX(AmortizacionID) INTO Var_MaxCredito, Var_MaxAmorti
      FROM TMPAMORTIPAGOGRUPO Tem
      WHERE Tem.NumTransaccion = Aud_NumTransaccion
      AND Tem.MontoAPagar > Entero_Cero;

      SET Var_MaxCredito  := IFNULL(Var_MaxCredito, Entero_Cero);
      SET Var_MaxAmorti := IFNULL(Var_MaxAmorti, Entero_Cero);

      UPDATE TMPAMORTIPAGOGRUPO Tem SET
      MontoAPagar = MontoAPagar + ROUND(Par_MontoPagar-Var_SumTotPagar, 2)
      WHERE Tem.NumTransaccion = Aud_NumTransaccion
      AND Tem.MontoAPagar > Entero_Cero
      AND Tem.CreditoID = Var_MaxCredito
      AND Tem.AmortizacionID = Var_MaxAmorti;


    END IF;

        -- Reparto para el depósito cuando el pago sea por efectivo y haya desbloqueado garantía para completar el pago
        IF( Var_CobraFOGAFI='S' AND  Var_MontoAbonoGar>Entero_Cero )THEN

      SET @Contador := 0;
      -- Se dan de alta los registros para realizar el ciclo del ajuste
            INSERT INTO TMPGRUPOPAGO(
            `Consecutivo`,      `CreditoID`,    `AmortizacionID`, `MontoExigible`,    `NumTransaccion`)
        SELECT  @Contador := @Contador + 1,
                        MAX(CreditoID),   AmortizacionID,   SUM(MontoExigible),   Aud_NumTransaccion
          FROM TMPAMORTIPAGOGRUPO
          WHERE NumTransaccion = Aud_NumTransaccion
          GROUP BY AmortizacionID;

      -- Inicializciones
            SET Var_SaldoPago := ( Par_MontoPagar - Var_MontoAbonoGar );

            SET Var_Consecutivo := 1;
      SET NumIteraciones := (SELECT COUNT(*) FROM TMPGRUPOPAGO WHERE NumTransaccion = Aud_NumTransaccion);

      WHILE(Var_Consecutivo <= NumIteraciones AND Var_SaldoPago>Entero_Cero)DO

        SET Var_ExiCredito := Entero_Cero;

                SELECT AmortizacionID INTO Var_AmortiCreID
                FROM TMPGRUPOPAGO Tmp
                WHERE Tmp.NumTransaccion = Aud_NumTransaccion
                AND Tmp.Consecutivo = Var_Consecutivo;

        SELECT SUM(MontoAPagar) INTO Var_ExiCredito
        FROM TMPAMORTIPAGOGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion
        AND AmortizacionID = Var_AmortiCreID;

        SET Var_ExiCredito := IFNULL(Var_ExiCredito,Entero_Cero);

        IF(Var_SaldoPago >= Var_ExiCredito)THEN

          UPDATE TMPAMORTIPAGOGRUPO SET
            MontoEfecNeto = MontoExigible
          WHERE NumTransaccion = Aud_NumTransaccion
          AND AmortizacionID = Var_AmortiCreID;

          SET Var_SaldoPago := Var_SaldoPago - Var_ExiCredito;

        ELSE

          UPDATE TMPAMORTIPAGOGRUPO SET
            MontoEfecNeto = ROUND(IF(Var_ExiCredito<>Entero_Cero,(MontoAPagar / Var_ExiCredito),Entero_Cero) * Var_SaldoPago,2)
          WHERE NumTransaccion = Aud_NumTransaccion
          AND AmortizacionID = Var_AmortiCreID;

          SET Var_SaldoPago := Entero_Cero;

        END IF;

                SET Var_Consecutivo := Var_Consecutivo + 1;

            END WHILE;

      -- Ajuste de lo prorrateado con el monto original del pago
            SELECT SUM(MontoEfecNeto) INTO Var_SaldoPago
            FROM TMPAMORTIPAGOGRUPO
            WHERE NumTransaccion = Aud_NumTransaccion;

            IF( Var_SaldoPago <> (Par_MontoPagar - Var_MontoAbonoGar) )THEN

                SELECT MAX(CreditoID), MAX(AmortizacionID) INTO Var_MaxCredito, Var_MaxAmorti
        FROM TMPAMORTIPAGOGRUPO Tem
        WHERE Tem.NumTransaccion = Aud_NumTransaccion
          AND Tem.MontoAPagar > Entero_Cero;

        SET Var_MaxCredito  := IFNULL(Var_MaxCredito, Entero_Cero);
        SET Var_MaxAmorti := IFNULL(Var_MaxAmorti, Entero_Cero);

                UPDATE TMPAMORTIPAGOGRUPO Tem SET
          MontoEfecNeto = MontoEfecNeto + ROUND( (Par_MontoPagar - Var_MontoAbonoGar) -  Var_SaldoPago,2)
        WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.CreditoID = Var_MaxCredito
        AND Tem.AmortizacionID = Var_MaxAmorti;

            END IF;

        END IF;

    -- Inicializaciones
    SET Var_NumCiclo    := 1;
    SET Var_AcumPagos   := Decimal_Cero;

    -- Cursor para Mandar hacer el Pago
    OPEN CURSORPAGO;

    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
      CICLOPAGO:LOOP

      FETCH CURSORPAGO INTO
      Var_CreditoID,  Var_CuentaID,   Var_ClienteID,  Var_MonedaID, Var_SucCliente;

      -- Inicializacion
      SET Var_PagoIndiv := Entero_Cero;


      -- Obtenemos el Monto del Pago Asignado
      SELECT SUM(Tem.MontoAPagar) INTO Var_PagoIndiv
      FROM TMPAMORTIPAGOGRUPO Tem
      WHERE NumTransaccion = Aud_NumTransaccion
        AND CreditoID = Var_CreditoID;

      SET Var_PagoIndiv := IFNULL(Var_PagoIndiv, Entero_Cero);

      SET Var_CreditoStr  := CONVERT(Var_CreditoID, CHAR(15));

      IF(Var_PagoIndiv  > Entero_Cero) THEN

      SET Var_AcumPagos := Var_AcumPagos + Var_PagoIndiv;

      IF(Par_FormaPago = Forma_Efectivo ) THEN

        IF(Var_MontoAbonoGar>Entero_Cero AND Var_CobraFOGAFI='S' )THEN

          SELECT SUM(Tem.MontoEfecNeto) INTO Var_MontoAbono
                    FROM TMPAMORTIPAGOGRUPO Tem
          WHERE NumTransaccion = Aud_NumTransaccion
          AND CreditoID = Var_CreditoID;

        ELSE

          SET Var_MontoAbono := Var_PagoIndiv;
                END IF;

        CALL CONTAAHORROPRO (
          Var_CuentaID,   Var_ClienteID,  Aud_NumTransaccion, Var_FechaSis,       Var_FechaSis,
          Nat_Abono,          Var_MontoAbono, Des_DepPagCre,      Var_CreditoStr,     Aho_DepEfeVen,
          Var_MonedaID,       Var_SucCliente, AltaPoliza_NO,      Entero_Cero,        Var_Poliza,
          AltaMovAho_SI,      Con_AhoCapital, Nat_Abono,          Par_NumErr,         Par_ErrMen,
          Par_Consecutivo,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
          Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
                END IF;

                -- ReTransfiere la cantidad de dinero para realizar el pago completo de los integrantes del grupo
                -- Esto solo en caso de haber desbloqueos por garantía liquida o financiada.
                IF(Var_PagoIndiv>Var_MontoAbono AND Var_CobraFOGAFI='S' AND Var_MontoAbonoGar>Entero_Cero )THEN

                    SET Var_ClienteIDTrans := (SELECT ClienteID FROM CUENTASAHO
                        WHERE CuentaAhoID = Par_CuentaPago);

                    SET Var_MontoTranfer := Var_PagoIndiv - Var_MontoAbono;

                    -- =============================== RELACION DE CUENTAS ==============================
          IF(Var_ClienteIDTrans <> Var_ClienteID) THEN

            IF NOT EXISTS(SELECT * FROM CUENTASTRANSFER
                  WHERE ClienteID = Var_ClienteIDTrans
                  AND CuentaDestino = Var_CuentaID
                  AND ClienteDestino = Var_ClienteID) THEN

              CALL CUENTASTRANSFERALT(
                Var_ClienteIDTrans, Entero_Cero,      Entero_Cero,      Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,       Var_FechaSis,     CuentaInterna,    Entero_Cero,    Entero_Cero,
                Var_CuentaID,       Var_ClienteID,    Entero_Cero,      Cadena_Vacia,   Con_NO,
                Aplica_Cuenta,      Entero_Cero,
                Par_SalidaNO,       Par_NumErr,       Par_ErrMen,       Par_EmpresaID,  Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

            END IF;

            -- =============================== TRANSFERENCIA ENTRE CUENTAS ====================================
            CALL CARGOABONOCTAPRO(
              Par_CuentaPago,   Var_ClienteIDTrans,   Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
              Nat_Cargo,      Var_MontoTranfer,   DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
              Var_MonedaID,   Var_SucCliente,     AltaPoliza_NO,      Con_TransfCta,      Var_Poliza,
              AltaMovPoliza_SI, Con_AhoCapital,     Nat_Cargo,        Par_SalidaNO,     Par_NumErr,
              Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
              Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

            CALL CARGOABONOCTAPRO(
              Var_CuentaID,   Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
              Nat_Abono,      Var_MontoTranfer,   DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
              Var_MonedaID,   Var_SucCliente,     AltaPoliza_NO,      Con_TransfCta,      Var_Poliza,
              AltaMovPoliza_SI, Con_AhoCapital,     Nat_Abono,        Par_SalidaNO,     Par_NumErr,
              Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
              Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;
           END IF;

        END IF;

      ELSE

        SET Var_CuentaID    := Par_CuentaPago;

      END IF;

      CALL PAGOCREDITOPRO(
                Var_CreditoID,    Var_CuentaID,     Var_PagoIndiv,      Var_MonedaID,       NO_EsPrePago,
                NO_EsFiniquito,   Par_EmpresaID,    Par_SalidaNO,       AltaPoliza_NO,      Var_MontoPago,
                Var_Poliza,       Par_NumErr,       Par_ErrMen,         Par_Consecutivo,    Par_FormaPago,
                Par_OrigenPago,   RespaldaCredSI,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,   Aud_Sucursal,       Aud_NumTransaccion);

      IF(Par_NumErr <> Entero_Cero)THEN
         SET Var_MontoPago   := Entero_Cero;
         SET Var_MontoAplic  := Entero_Cero;
        LEAVE ManejoErrores;
      END IF;

      SET Var_MontoAplic  := Var_MontoAplic + Var_MontoPago;

	ELSE
		SET Par_NumErr    := '002';
		    SET Par_ErrMen    := CONCAT('Monto a pagar en Cero');
		    SET Par_Consecutivo := 0;
		LEAVE ManejoErrores;

  END IF;


      SET Var_NumCiclo := Var_NumCiclo + 1;


      END LOOP CICLOPAGO;
    END;

    CLOSE CURSORPAGO;

    SET Var_MontoPago := Var_MontoAplic;

    DELETE FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPCREDITOPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPGRUPOPAGO
      WHERE NumTransaccion = Aud_NumTransaccion;

    SET Par_NumErr    := '000';
    SET Par_ErrMen    := CONCAT('Pago Exitoso. Monto del Pago Aplicado: ', FORMAT(Var_MontoPago,2));
    SET Par_Consecutivo := 0;

  END ManejoErrores;

  IF (Par_Salida = Par_SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'creditoID' AS control,
        Var_Poliza AS consecutivo;
  END IF;

END TerminaStore$$