-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGRUPALCOMESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGRUPALCOMESPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOGRUPALCOMESPRO`(
    Par_GrupoID         INT,
    Par_MontoPagar      DECIMAL(12,2),
    Par_CuentaPago      BIGINT(12),
    Par_MonedaID        INT,
    Par_FormaPago       CHAR(1),

    Par_CicloGrupo      INT,
    Par_EmpresaID       INT(11),
    Par_AltaEncPoliza   CHAR(1),
    Par_Salida          CHAR(1),

  INOUT Var_Poliza  BIGINT,
  OUT Var_MontoPago DECIMAL(12,2),
  Par_OrigenPago      CHAR(1),      -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
  OUT Par_NumErr    INT(11),
  OUT Par_ErrMen    VARCHAR(400),
  OUT Par_Consecutivo BIGINT,

  Aud_Usuario     INT(11),
  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT(11),
  Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE Var_MontoCreOri DECIMAL(14,2);
  DECLARE Var_FechaSis    DATETIME;
  DECLARE Var_NumCiclo    INT;
  DECLARE Var_TotalCiclo  INT;
  DECLARE Var_PorcPago    DECIMAL(14,8);

  DECLARE Var_PagoIndiv   DECIMAL(14,2);
  DECLARE Var_AcumPagos   DECIMAL(14,2);
  DECLARE Var_CreditoStr  VARCHAR(20);
  DECLARE Var_MontoAplic  DECIMAL(14,2);
  DECLARE Var_ExiGrupo    DECIMAL(14,2);

  DECLARE Var_TotGrupo    DECIMAL(14,2);
  DECLARE Var_SumTotPagar DECIMAL(14,2);
  DECLARE Var_MaxCredito  BIGINT;
  DECLARE Var_MaxAmorti INT;
  DECLARE Var_CreditoID   BIGINT(12);

  DECLARE Var_AmortiCreID INT;
  DECLARE Var_CuentaID    BIGINT(12);
  DECLARE Var_ClienteID   BIGINT;
  DECLARE Var_MonedaID    INT;
  DECLARE Var_SolCredID   BIGINT;

  DECLARE Var_MontoAutorizado DECIMAL(14,2);
  DECLARE Var_SucCliente  INT;
  DECLARE Var_ExiCredito  DECIMAL(14,2);
  DECLARE Var_ExiAmorti   DECIMAL(14,2);
  DECLARE Var_ComFalPago  DECIMAL(14,2);

  DECLARE Var_TotCredito  DECIMAL(14,2);
  DECLARE Var_SaldoPago DECIMAL(14,2);
  DECLARE Var_SaldoSinCom DECIMAL(14,2);
  DECLARE Var_SaldoComisi DECIMAL(14,2);
  DECLARE Var_APagarSinCom DECIMAL(14,2);

  DECLARE Var_APagarComisi DECIMAL(14,2);
  DECLARE Var_CobraFOGAFI CHAR(1);
  DECLARE Var_MontoDesbloqueo DECIMAL(14,2);
  DECLARE Var_MontoAbono    DECIMAL(14,2);
  DECLARE Var_MontoBloqueo  DECIMAL(14,2);

  DECLARE Var_MontoAbonoGar DECIMAL(14,2);
  DECLARE Var_ClienteIDTrans  INT(11);
  DECLARE Var_MontoTranfer  DECIMAL(14,2);
  DECLARE ReferenciaMov     VARCHAR(100);
    DECLARE Var_GarantiaAcum  DECIMAL(14,2);

    DECLARE Var_Consecutivo   INT(11);
    DECLARE NumIteraciones    INT(11);



  -- Declaracion de Constantes
  DECLARE Entero_Cero     INT;
  DECLARE Decimal_Cero    INT;
  DECLARE Par_SalidaNO    CHAR(1);
  DECLARE Par_SalidaSI    CHAR(1);
  DECLARE Si_Prorratea    CHAR(1);

  DECLARE Nat_Cargo       CHAR(1);
  DECLARE Nat_Abono       CHAR(1);
  DECLARE AltaPoliza_NO   CHAR(1);
  DECLARE AltaPoliza_SI   CHAR(1);
  DECLARE AltaMovAho_SI   CHAR(1);

  DECLARE Pol_Automatica  CHAR(1);
  DECLARE Coc_PagoCred    INT;
  DECLARE Con_AhoCapital  INT;
  DECLARE Esta_Activo     CHAR(1);
  DECLARE Esta_Vencido    CHAR(1);

  DECLARE Esta_Vigente    CHAR(1);
  DECLARE Esta_Pagado     CHAR(1);
  DECLARE SI_EsPrePago    CHAR(1);
  DECLARE SI_EsFiniquito  CHAR(1);
  DECLARE NO_EsPrePago    CHAR(1);

  DECLARE NO_EsFiniquito  CHAR(1);
  DECLARE Pago_Ordinario  CHAR(1);
  DECLARE Pago_Finiquito  CHAR(1);
  DECLARE Pago_Anticipado CHAR(1);
  DECLARE Forma_CargoCue  CHAR(1);

  DECLARE Forma_Efectivo  CHAR(1);
  DECLARE Des_DepPagCre   VARCHAR(50);
  DECLARE Des_ConPagCre   VARCHAR(50);
  DECLARE Aho_DepEfeVen   CHAR(4);
  DECLARE Var_CicloActual INT;

  DECLARE Con_Origen    CHAR(1);
  DECLARE Desbloqueo    CHAR(1);
  DECLARE Bloqueos    CHAR(1);
  DECLARE TipoBloqFOGAFI  INT(11);
  DECLARE TipoBloqFOGA  INT(11);

  DECLARE Cadena_Vacia  CHAR(1);
  DECLARE CuentaInterna   CHAR(1);
  DECLARE DescripcionMov  VARCHAR(100);
  DECLARE Mov_TraspasoCta CHAR(4);
  DECLARE Con_TransfCta   INT(11);

  DECLARE AltaMovPoliza_SI CHAR(1);
  DECLARE RespaldaCredSI    CHAR(1);
  DECLARE Con_NO            CHAR(1);    -- Constante NO
  DECLARE Aplica_Cuenta     CHAR(1);    -- Constante Aplica a Cuenta de Ahorro
  DECLARE Var_ExisteCreditos  INT(11);    -- Variable para almacenar si existe creditos para realizar pagos
  DECLARE Estatus_Suspendido CHAR(1);     -- Estatus Suspendido

  -- Cursor Para Asignar el Monto del Pago Sin Comision por Amortizacion
  DECLARE CURSORGRUPO CURSOR FOR
    SELECT MAX(CreditoID),  AmortizacionID, SUM(MontoExigible)
      FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion
       GROUP BY AmortizacionID;

  -- Cursor Para Asignar el Monto de la Comision por Falta de Pago por Amortizacion
  DECLARE CURSOCOMISION CURSOR FOR
    SELECT MAX(CreditoID),  AmortizacionID, SUM(ComisionFaltaPago)
      FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion
        AND MontoExigible  > Entero_Cero
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
  SET Entero_Cero     := 0;     -- Entero en Cero
  SET Decimal_Cero    := 0.00;    -- Decimal en Cero
  SET Par_SalidaNO    := 'N';     -- Salida: NO
  SET Par_SalidaSI    := 'S';     -- Salida: SI
  SET Si_Prorratea    := 'S';       -- Si prorratea el pago en el grupo

  SET Nat_Cargo       := 'C';     -- Naturaleza de Cargo
  SET Nat_Abono       := 'A';     -- Naturaleza de Abono
  SET AltaPoliza_NO   := 'N';       -- Alta del Encabezado de la Poliza: NO
  SET AltaPoliza_SI   := 'S';       -- Alta del Encabezado de la Poliza: SI
  SET AltaMovAho_SI   := 'S';       -- Alta del Movimiento de Ahorro: SI

  SET Con_AhoCapital  := 1;         -- Concepto de Ahorro: Capital
  SET Pol_Automatica  := 'A';     -- Tipo de Poliza Automatica
  SET Coc_PagoCred    := 54;        -- Concepto Contable: Pago de Credito
  SET Esta_Activo     := 'A';       -- Estatus: Activo
  SET Esta_Vencido    := 'B';       -- Estatus: Vencido

  SET Esta_Vigente    := 'V';       -- Estatus: Vigente
  SET Esta_Pagado     := 'P';       -- Estatus: Pagado
  SET SI_EsPrePago    := 'S';       -- Es Prepago: SI
  SET SI_EsFiniquito  := 'S';     -- Es Finiquito: SI
  SET NO_EsPrePago    := 'N';     -- Es Prepago: NO

  SET NO_EsFiniquito  := 'N';     -- Es Finiquito: NO
  SET Pago_Ordinario  := 'O';       -- Tipo de Pago: Ordinario
  SET Pago_Finiquito  := 'F';       -- Tipo de Pago: Finiquito
  SET Pago_Anticipado := 'A';       -- Tipo de Pago: Anticipado
  SET Forma_CargoCue  := 'C';       -- Forma de Pago: Con Cargo a Cuenta

  SET Forma_Efectivo  := 'E';       -- Forma de Pago: Efectivo
  SET Aho_DepEfeVen   := '10';    -- Tipo de Deposito en Efectivo
  SET Des_DepPagCre   := 'DEP.PAGO DE CREDITO';   -- Descripcion Operativa
  SET Des_ConPagCre   := 'PAGO DE CREDITO';     -- Descripcion Contable
  SET Aud_ProgramaID  := 'PAGOCREDITOPRO';    -- Programa ID

  SET Con_Origen    := 'S';     -- Constante Origen donde se llama el SP (S= safy, W=WS)
  SET Desbloqueo    := 'D';     -- Constante para indicar los movimientos por desbloqueos
  SET Bloqueos    := 'B';     -- Constante para indicar los movimientos por bloqueos
  SET TipoBloqFOGAFI  := 20;      -- Constante Tipo de Bloqueo Garantía Líquida
  SET TipoBloqFOGA  := 8;     -- Constante Tipo de Bloqueo Garantía Financiada

  SET Cadena_Vacia  := '';
  SET CuentaInterna := 'I';
  SET DescripcionMov  := 'TRANSFERENCIA A CUENTA';
  SET Mov_TraspasoCta := '12';
  SET Con_TransfCta := 90;

  SET AltaMovPoliza_SI := 'S';
  SET RespaldaCredSI   := 'S';
  SET Con_NO            := 'N';
  SET Aplica_Cuenta     := 'S';
  SET Estatus_Suspendido := 'S';  -- Estatus Suspendido

  ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                    'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOGRUPALCOMESPRO');
        END;

    -- Obtiene el sico actual de grupo
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
        `NumTransaccion`, `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAPagar`, `ComisionFaltaPago`)

        SELECT  Aud_NumTransaccion, Cre.CreditoID, Amo.AmortizacionID,
            FUNCIONEXIAMORCRESINCOM(Amo.CreditoID, Amo.AmortizacionID),
            Entero_Cero,
            FUNCIONEXIAMORCOMFALPAG(Amo.CreditoID, Amo.AmortizacionID)

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
        `NumTransaccion`,   `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAPagar`,  `ComisionFaltaPago`)
      SELECT Aud_NumTransaccion,  Cre.CreditoID,  Amo.AmortizacionID, FUNCIONEXIAMORCRESINCOM(Amo.CreditoID, Amo.AmortizacionID),
                                                Entero_Cero,  FUNCIONEXIAMORCOMFALPAG(Amo.CreditoID, Amo.AmortizacionID)
        FROM `HIS-INTEGRAGRUPOSCRE` Ing,
           SOLICITUDCREDITO Sol,
           AMORTICREDITO Amo,
           CREDITOS Cre
        LEFT OUTER JOIN CREDDIASPAGANT Dpa
          ON Dpa.ProducCreditoID = Cre.ProductoCreditoID
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

  -- Se realiza conteo para ver si existe creditos para realizar los pagos.
  SET Var_ExisteCreditos  := Entero_Cero;
  SET Var_ExisteCreditos  := (SELECT COUNT(*) FROM TMPAMORTIPAGOGRUPO WHERE NumTransaccion = Aud_NumTransaccion);
  SET Var_ExisteCreditos  := IFNULL(Var_ExisteCreditos,Entero_Cero);
  IF(Var_ExisteCreditos = Entero_Cero)THEN
    SET Par_NumErr  := 001;
    SET Par_ErrMen  := CONCAT('No existen Creditos que presentan adeudos para el Grupo ', Par_GrupoID);
    LEAVE ManejoErrores;
  END IF;

    INSERT INTO TMPCREDITOPAGOGRUPO(
      `NumTransaccion`, `AmortizacionID`, `MontoExigible`, `ComisionFaltaPago`)

      SELECT Aud_NumTransaccion, AmortizacionID, SUM(MontoExigible), SUM(ComisionFaltaPago)
        FROM TMPAMORTIPAGOGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion
        GROUP BY AmortizacionID;

    -- Totales (Sin Comision y Pura Comision)
    SELECT SUM(MontoExigible), SUM(ComisionFaltaPago) INTO Var_SaldoSinCom, Var_SaldoComisi
      FROM TMPAMORTIPAGOGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    SET Var_SaldoSinCom := IFNULL(Var_SaldoSinCom, Entero_Cero);
    SET Var_SaldoComisi := IFNULL(Var_SaldoComisi, Entero_Cero);

    -- Identificamos los montos a repartir del pago
    IF(Var_SaldoSinCom >= Par_MontoPagar) THEN
      SET Var_APagarSinCom := Par_MontoPagar;
      SET Var_APagarComisi := Entero_Cero;
    ELSE
      SET Var_APagarSinCom := Var_SaldoSinCom;
      SET Var_APagarComisi := Par_MontoPagar - Var_APagarSinCom;
    END IF;

    -- Inicializaciones
    SET Var_MontoAplic  := Decimal_Cero;
    SET Var_SaldoPago   := Var_APagarSinCom;

    -- Obtiene el parámetro que indica si cobra o no FOGAFI
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

    -- Alta del Encabezado de la Poliza
    IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
      CALL MAESTROPOLIZAALT(
        Var_Poliza,     Par_EmpresaID,  Var_FechaSis,   Pol_Automatica,     Coc_PagoCred,
        Des_ConPagCre,  Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
    END IF;


    -- Cursor para el Reparto del Pago Sin Comisiones
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

    -- Repartir el Pago de la Comision por Falta de Pago

    IF(Var_APagarComisi > Entero_Cero) THEN

      -- Inicializaciones
      SET Var_MontoAplic  := Decimal_Cero;
      SET Var_SaldoPago   := Var_APagarComisi;

      OPEN CURSOCOMISION;

      BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        CICLOCOMISION:LOOP

        FETCH CURSOCOMISION INTO
        Var_CreditoID,  Var_AmortiCreID,  Var_ComFalPago;

        -- Inicializacion
        SET Var_ExiCredito  := Entero_Cero;

        IF(Var_SaldoPago <= Decimal_Cero) THEN
          LEAVE CICLOCOMISION;
        END IF;

        SELECT ComisionFaltaPago INTO Var_ExiCredito
          FROM TMPCREDITOPAGOGRUPO
          WHERE NumTransaccion = Aud_NumTransaccion
            AND AmortizacionID = Var_AmortiCreID;

        SET Var_ExiCredito := IFNULL(Var_ExiCredito, Entero_Cero);

        -- Si Completa a Pagar el Saldo de las Amortizaciones Indicadas
        IF(Var_SaldoPago >=  Var_ExiCredito) THEN

          UPDATE TMPAMORTIPAGOGRUPO SET
            MontoAPagar = MontoAPagar + ComisionFaltaPago
            WHERE NumTransaccion = Aud_NumTransaccion
              AND AmortizacionID = Var_AmortiCreID;

          SET Var_SaldoPago := Var_SaldoPago - Var_ExiCredito;

        ELSE

          UPDATE TMPAMORTIPAGOGRUPO SET
            MontoAPagar = MontoAPagar + ROUND(IF(Var_ExiCredito != Entero_Cero, (ComisionFaltaPago / Var_ExiCredito), Entero_Cero) * Var_SaldoPago,2)
            WHERE NumTransaccion = Aud_NumTransaccion
              AND AmortizacionID = Var_AmortiCreID;

          SET Var_SaldoPago := Entero_Cero;

        END IF;

        IF(Var_SaldoPago <= Decimal_Cero) THEN
          LEAVE CICLOCOMISION;
        END IF;

        END LOOP CICLOCOMISION;
      END;

      CLOSE CURSOCOMISION;

      IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;
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

      SET @Contador := Entero_Cero;
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

      WHILE( Var_Consecutivo <= NumIteraciones AND Var_SaldoPago>Entero_Cero )DO

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
        SET Var_GarantiaAcum := 0.00;

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

          IF( Var_MontoAbonoGar>Entero_Cero AND Var_CobraFOGAFI='S' )THEN

                        SELECT SUM(IFNULL(MontoEfecNeto,Entero_Cero)) INTO Var_MontoAbono
                        FROM TMPAMORTIPAGOGRUPO
            WHERE NumTransaccion = Aud_NumTransaccion
            AND CreditoID = Var_CreditoID;

          ELSE
            SET Var_MontoAbono := Var_PagoIndiv;
          END IF;

          CALL CONTAAHORROPRO (
            Var_CuentaID,       Var_ClienteID,  Aud_NumTransaccion, Var_FechaSis,       Var_FechaSis,
            Nat_Abono,          Var_MontoAbono,  Des_DepPagCre,      Var_CreditoStr,     Aho_DepEfeVen,
            Var_MonedaID,       Var_SucCliente, AltaPoliza_NO,      Entero_Cero,        Var_Poliza,
            AltaMovAho_SI,      Con_AhoCapital, Nat_Abono,          Par_NumErr,         Par_ErrMen,
            Par_Consecutivo,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

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
                  Var_ClienteIDTrans, Entero_Cero,      Entero_Cero,    Cadena_Vacia,   Cadena_Vacia,
                  Cadena_Vacia,       Var_FechaSis,     CuentaInterna,  Entero_Cero,    Entero_Cero,
                  Var_CuentaID,       Var_ClienteID,    Entero_Cero,    Cadena_Vacia,   Con_NO,
                  Aplica_Cuenta,      Entero_Cero,
                  Par_SalidaNO,       Par_NumErr,       Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,
                  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
                  LEAVE ManejoErrores;
                END IF;

              END IF;


              SET ReferenciaMov := CONVERT(Var_CuentaID,CHAR);

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

              SET ReferenciaMov := CONVERT(Par_CuentaPago,CHAR);

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
          Var_CreditoID,    Var_CuentaID,       Var_PagoIndiv,      Var_MonedaID,       NO_EsPrePago,
          NO_EsFiniquito,   Par_EmpresaID,      Par_SalidaNO,       AltaPoliza_NO,      Var_MontoPago,
          Var_Poliza,         Par_NumErr,         Par_ErrMen,         Par_Consecutivo,  Par_FormaPago,
          Par_OrigenPago,     RespaldaCredSI,     Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero)THEN
           SET Var_MontoPago   := Entero_Cero;
           SET Var_MontoAplic  := Entero_Cero;
          LEAVE ManejoErrores;
        END IF;

        SET Var_MontoAplic  := Var_MontoAplic + Var_MontoPago;

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