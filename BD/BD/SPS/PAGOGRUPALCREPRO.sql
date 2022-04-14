-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGRUPALCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGRUPALCREPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOGRUPALCREPRO`(
  # ======================================================================================================
  # ----- SE QUE REALIZA EL PROCESO DE PAGO DE CREDITO GRUPAL DE MANERA PRORRATEADA
  # ======================================================================================================
  Par_GrupoID         INT(11),        -- Numero de Grupo
  Par_MontoPagar      DECIMAL(12,2),  -- Monto a Pagar
  Par_CuentaPago      BIGINT(12),     -- Cuenta de donde se realiza el pago
  Par_MonedaID        INT(11),        -- Clave Moneda
  Par_EsPrePago       CHAR(1),        -- Indica si es prepago S:SI  N:NO

  Par_Finiquito       CHAR(1),        -- Indica si es Finiquito  S:SI   N:NO
  Par_FormaPago       CHAR(1),        -- Forma de Pago
  Par_CicloGrupo      INT(11),        -- Indica el ciclo del Grupo
  Par_EmpresaID       INT(11),        -- Numero de Empresa
  Par_AltaEncPoliza   CHAR(1),        -- Indica si se dará de alta el encabezado de la póliza   S:SI   N:NO
  Par_Salida          CHAR(1),        -- Salida   S:SI   N:NO
  INOUT Var_Poliza    BIGINT(20),     -- Numero de Poliza
  INOUT Var_MontoPago DECIMAL(12,2),  -- Monto de Pago Aplicado
  Par_OrigenPago      CHAR(1),        -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
  OUT   Par_NumErr    INT(11),        -- Numero de Error
  OUT   Par_ErrMen    VARCHAR(400),   -- Mensaje de Error

  INOUT Par_Consecutivo BIGINT,       -- Consecutivo

  -- Parametros de Auditoria
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

  -- Declaracion de Variables.
  DECLARE Var_CicloActual       INT(11);        -- Variable para el ciclo actual
  DECLARE Var_TipPagComFal      CHAR(1);        -- Variable tipo de pago con comisión o sin comisión
  DECLARE Var_Control         	VARCHAR(100);   -- Variable de Control
  DECLARE Var_CobraFOGAFI       CHAR(1);        -- Variable par indicar si permite el cobro de garantía financiada
  DECLARE Var_EjecucionCobAut   CHAR(1);        -- Ejecuta Cobranza Automatica
  DECLARE Var_SaldoDisponible   DECIMAL(12,2);  -- Saldo Disponible de la Cuenta de Ahorro
  DECLARE Var_ExistenRegistros  INT(11);        -- Variable para alamacenar cuando existan registros de pagos
  DECLARE Var_FechaSistema      DATETIME;       -- Fecha del sistema

  DECLARE Var_ClienteID         INT(11);        -- Numero de Cliente
  DECLARE Var_CuentaAhoID       BIGINT(12);     -- Cuenta de Ahorro
  DECLARE Var_CreditoID         BIGINT(12);     -- Numero de Credito
  DECLARE Var_NumIteraciones    INT(11);        -- Numero de Iteraciones
  DECLARE Var_MontoTransf       DECIMAL(12,2); -- Monto de Transferencia

  DECLARE Var_MonedaID          INT(11);        -- Numero de Moneda
  DECLARE Var_SucursalID        INT(11);        -- Numero de Sucursal
  DECLARE Var_ConsecutivoTra    BIGINT(20);     -- Consecutivo de Transaccion
  DECLARE Var_Consecutivo       INT(11);        -- Numero Consecutivo
  DECLARE Var_ClienteIDTrans    INT(11);        -- Cliente de Tranferencia

  DECLARE Var_RequiereGarFOGAFI CHAR(1);        -- Indica si se requiere garantía FOGAFI
  DECLARE Var_RequiereGarantia  CHAR(1);        -- Indica si se requiere el cobro de garantía Liquida(FOGA)
  DECLARE Var_TotalExigible     DECIMAL(14,2);  -- Total Exigible del grupo de credito
  DECLARE Var_ReferenciaMov     VARCHAR(100);   -- Referencia de Movimiento


  DECLARE Var_CargosPoliza	DECIMAL(14,4);
	DECLARE Var_AbonosPoliza	DECIMAL(14,4);

  -- Declaracion de Constantes
  DECLARE Entero_Cero     INT(11);      -- Indica Entero Cero
  DECLARE Decimal_Cero    INT(11);      -- Indica Decimal Cero
  DECLARE Cadena_Vacia    CHAR(1);      -- Indica Cadena Vacía.
  DECLARE Par_SalidaNO    CHAR(1);      -- Indica que NO requiere salida
  DECLARE Par_SalidaSI    CHAR(1);      -- Indica que SI requiere salida del sp

  DECLARE Con_PorCuota    CHAR(1);      -- Indica el tipo de consulta por FOGAFI
  DECLARE Con_FinalPrel   CHAR(1);      -- Indica el tipo de consulta para fina de la prelación
  DECLARE Si_Prorratea    CHAR(1);      -- Indica si permite prorrateo o no
  DECLARE SI_EsFiniquito  CHAR(1);      -- Indica si es Pago por Finiquito

  DECLARE Con_CargoCta    CHAR(1);      -- Intica el tipo de consuulta para las cuentas
  DECLARE Esta_Activo     CHAR(1);      -- Indica Estatus Activo
  DECLARE Esta_Vencido    CHAR(1);      -- Indica Estatis Vencido
  DECLARE Esta_Vigente    CHAR(1);      -- Indica Estatus Vigente
  DECLARE Esta_Pagado     CHAR(1);      -- Indica Estatus Pagado

  DECLARE Cons_SI             CHAR(1);    -- Indica Constante SI
  DECLARE Con_NO              CHAR(1);    -- Constante CON
  DECLARE Estatus_Suspendido  CHAR(1);    -- Estatus Suspendido

  DECLARE DescripcionMov    VARCHAR(100); -- Descripcion de Movimiento
  DECLARE Entero_Uno        INT(11);
  DECLARE Con_AhoCapital    INT(11);      -- Concepto de ahorro de capital
  DECLARE Nat_Cargo         CHAR(1);
  DECLARE Nat_Abono         CHAR(1);
  DECLARE Mov_TraspasoCta   CHAR(4);
  DECLARE Con_TransfCta     INT(11);      -- CONCEPTOSCONTA: Concepto Contable: Transferencia entre Cuentas Propias

	DECLARE LimiteDifPoliza		DECIMAL;

  -- Asignacion de Constantes
  SET Entero_Cero     := 0;       -- Entero en Cero
  SET Decimal_Cero    := 0.00;    -- Decimal Cero
  SET Cadena_Vacia    := '';      -- Cadena Vacia
  SET Par_SalidaNO    := 'N';     -- Salida: NO
  SET Par_SalidaSI    := 'S';     -- Salida: SI

  SET Si_Prorratea    := 'S';     -- Si Prorratea el Pago Grupal
  SET Con_PorCuota    := 'C';     -- Prelacion de Pago: Ordinaria
  SET Con_FinalPrel   := 'F';     -- Prelacion de Pago: Al Final La comision por falta de pago
  SET SI_EsFiniquito  := 'S';     -- Tipo de Pago: Finiquito
  SET Esta_Activo     := 'A';     -- Estatus: Activo

  SET Esta_Vencido    := 'B';     -- Estatus: Vencido
  SET Esta_Vigente    := 'V';     -- Estatus: Vigente
  SET Esta_Pagado     := 'P';     -- Estatus: Pagado
  SET Con_CargoCta    := 'C';     -- Indica la forma de pago con Cargo a Cuenta
  SET Cons_SI       := 'S';     -- Constante: Si
  SET Con_NO      := 'N';
  SET Estatus_Suspendido := 'S';  -- Estatus Suspendido

  SET DescripcionMov  := 'TRANSFERENCIA A CUENTA';
  SET Mov_TraspasoCta := '12';    -- TIPOSMOVSAHO: Traspaso Cuenta Interna
  SET Con_TransfCta   := 90;      -- CONCEPTOSCONTA: Concepto Contable: Transferencia entre Cuentas Propias
  SET Con_AhoCapital  := 1;       -- Concepto de Ahorro: Capital
  SET Nat_Cargo       := 'C';     -- Naturaleza de Cargo

  SET Nat_Abono       := 'A';     -- Naturaleza de Abono
  SET Entero_Uno      := 1;       -- Entero en Cero
  SET LimiteDifPoliza			:=0.01;

  ManejoErrores: BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr = 999;
      SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
          'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOGRUPALCREPRO');
      SET Var_Control = 'SQLEXCEPTION';
    END;

    -- Obtiene el parámetro que indica si cobra o no garnatia financiada.
    SET Var_CobraFOGAFI := IFNULL(FNPARAMGENERALES('CobraGarantiaFinanciada'),Con_NO);

    -- Obtiene el parámetro que indica si la cobranza Automatica esta encendida
    SET Var_EjecucionCobAut := IFNULL(FNPARAMGENERALES('EjecucionCobAut'),Con_NO);

    SELECT FechaSistema INTO Var_FechaSistema
    FROM PARAMETROSSIS;

    SELECT CicloActual INTO Var_CicloActual
    FROM  GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    IF(Par_CicloGrupo = Var_CicloActual) THEN
      SELECT  DISTINCT(TipoPagoComFalPago) INTO Var_TipPagComFal
      FROM INTEGRAGRUPOSCRE Ing,
         SOLICITUDCREDITO Sol,
         CREDITOS Cre,
         PRODUCTOSCREDITO Pro
      WHERE Ing.GrupoID               = Par_GrupoID
        AND Ing.Estatus               = Esta_Activo
        AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
        AND Ing.ProrrateaPago         = Si_Prorratea
        AND Sol.CreditoID             = Cre.CreditoID
        AND Pro.ProducCreditoID       = Cre.ProductoCreditoID
        AND (   Cre.Estatus   = Esta_Vigente
           OR  Cre.Estatus    = Esta_Vencido
           OR  Cre.Estatus    = Estatus_Suspendido
        )
      LIMIT 1;

	-- SE CONSULTA SI EL CICLO ACTUAL TIENE PAGOS PENDIENTES
		SELECT	COUNT(*)
		INTO	Var_ExistenRegistros
		FROM INTEGRAGRUPOSCRE Ing,
		SOLICITUDCREDITO Sol,
		AMORTICREDITO Amo,
		CREDITOS Cre
		LEFT OUTER JOIN CREDDIASPAGANT Dpa ON Dpa.ProducCreditoID = Cre.ProductoCreditoID AND Dpa.Frecuencia = Cre.FrecuenciaCap
			WHERE Ing.GrupoID = Par_GrupoID
				AND Ing.Estatus = Esta_Activo
				AND Ing.SolicitudCreditoID= Sol.SolicitudCreditoID
				AND Ing.ProrrateaPago = Si_Prorratea
				AND Sol.CreditoID = Cre.CreditoID
				AND ( Cre.Estatus = Esta_Vigente
					OR Cre.Estatus = Esta_Vencido
					OR Cre.Estatus = Estatus_Suspendido
					)
				AND Cre.CreditoID = Amo.CreditoID
				AND Amo.Estatus != Esta_Pagado
				AND Amo.FechaExigible <= ADDDATE(Var_FechaSistema, IFNULL(Dpa.NumDias, Entero_Cero));
    ELSE
      SELECT  DISTINCT(TipoPagoComFalPago) INTO Var_TipPagComFal
      FROM `HIS-INTEGRAGRUPOSCRE` Ing,
         SOLICITUDCREDITO Sol,
         CREDITOS Cre,
         PRODUCTOSCREDITO Pro
      WHERE Ing.GrupoID               = Par_GrupoID
        AND Ing.Estatus               = Esta_Activo
        AND Ing.Ciclo                 = Par_CicloGrupo
        AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
        AND Ing.ProrrateaPago         = Si_Prorratea
        AND Sol.CreditoID             = Cre.CreditoID
        AND Pro.ProducCreditoID       = Cre.ProductoCreditoID
        AND (   Cre.Estatus   = Esta_Vigente
           OR  Cre.Estatus    = Esta_Vencido
           OR  Cre.Estatus    = Estatus_Suspendido
          )
      LIMIT 1;

	-- SE CONSULTA POR CICLO HISTORICO
		SELECT	COUNT(*)
		INTO	Var_ExistenRegistros
		FROM `HIS-INTEGRAGRUPOSCRE` Ing,
		SOLICITUDCREDITO Sol,
		AMORTICREDITO Amo,
		CREDITOS Cre
		LEFT OUTER JOIN CREDDIASPAGANT Dpa ON Dpa.ProducCreditoID = Cre.ProductoCreditoID AND Dpa.Frecuencia = Cre.FrecuenciaCap
		WHERE Ing.GrupoID = Par_GrupoID
			AND Ing.Estatus = Esta_Activo
			AND Cre.CicloGrupo = Par_CicloGrupo
			AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Ing.ProrrateaPago = Si_Prorratea
			AND Sol.CreditoID = Cre.CreditoID
			AND ( Cre.Estatus = Esta_Vigente
				OR Cre.Estatus = Esta_Vencido
				OR Cre.Estatus = Estatus_Suspendido
				)
			AND Cre.CreditoID = Amo.CreditoID
			AND Amo.Estatus != Esta_Pagado
			AND Amo.FechaExigible <= ADDDATE(Var_FechaSistema, IFNULL(Dpa.NumDias, Entero_Cero));

    END IF;

	-- Validacion de datos nulos
    SET Var_TipPagComFal := IFNULL(Var_TipPagComFal, Cadena_Vacia);
	SET Var_ExistenRegistros := IFNULL(Var_ExistenRegistros, Entero_Cero);

	-- SE VALIDA QUE LA BARREDORA ESTE ACTIVA PARA MANDAR LA VALIDACIONE
	IF(Var_EjecucionCobAut = Cons_SI)THEN
		-- Cuando no existen pagos pendientes por realizar se marca como exito el codigo de error
		IF(Var_ExistenRegistros = Entero_Cero)THEN
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('ELIMINAPOLIZA'); -- NO MODIFICAR EL MENSAJE DE ERROR, SE UTILIZA PARA NO GENERAR POLIZAS SIN DETALLE
			LEAVE ManejoErrores;
		END IF;
	END IF;

    SELECT  RequiereGarFOGAFI,      RequiereGarantia
    INTO    Var_RequiereGarFOGAFI,  Var_RequiereGarantia
    FROM DETALLEGARLIQUIDA Det
    INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
    INNER JOIN CUENTASAHO Cue ON Cre.CuentaID = Cue.CuentaAhoID
    WHERE Cre.GrupoID = Par_GrupoID
      AND Cre.CicloGrupo = Par_CicloGrupo
      AND Cre.CuentaID = Par_CuentaPago
      AND Cre.Estatus IN (Esta_Vigente , Esta_Vencido);

      SET Var_RequiereGarFOGAFI := IFNULL(Var_RequiereGarFOGAFI, Con_NO);
      SET Var_RequiereGarantia := IFNULL(Var_RequiereGarantia, Con_NO);

    IF( Var_EjecucionCobAut = Cons_SI AND Par_FormaPago = Con_CargoCta AND Var_CobraFOGAFI = Cons_SI AND
        (Var_RequiereGarFOGAFI = Cons_SI OR Var_RequiereGarantia = Cons_SI)) THEN

        SELECT SUM(IFNULL(Cue.SaldoDispon, Entero_Cero))
        INTO Var_SaldoDisponible
        FROM CREDITOS Cre
        INNER JOIN CUENTASAHO Cue ON Cre.CuentaID = Cue.CuentaAhoID
        WHERE Cre.GrupoID = Par_GrupoID
          AND Cre.CicloGrupo = Par_CicloGrupo
           AND Cre.Estatus <> Esta_Pagado;

        DELETE FROM TMPTRANSFERCUEFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
        SET @RegistroID := Entero_Cero;

        INSERT INTO TMPTRANSFERCUEFOGAFI(
            RegistroID,
            CreditoID,          CuentaAhoID,  SaldoExigible,                    SaldoExigibleFogafi,
            SaldoDisponible,
            PorcentajePago,
            MontoPago,          MontoTransferencia,
            EmpresaID,          Usuario,      FechaActual,        DireccionIP,
            ProgramaID,         Sucursal,     NumTransaccion)
        SELECT
            @RegistroID:=(@RegistroID +1),
            Cre.CreditoID,      Cre.CuentaID, FUNCIONCONPAGOANTCRE(CreditoID),  FNEXIGIBLECREGARFOGAFI(CreditoID, Var_FechaSistema),
            IFNULL(Cue.SaldoDispon, Entero_Cero),
            -- Se utiliza como cuenta Pivote la cuenta de Pago de Entrada
            CASE WHEN Cre.CuentaID <> Par_CuentaPago THEN ROUND( IFNULL(Cue.SaldoDispon, Entero_Cero)/Var_SaldoDisponible,8) ELSE Entero_Cero END,
            Entero_Cero,        Entero_Cero,
            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
        FROM CREDITOS Cre
        INNER JOIN CUENTASAHO Cue ON Cre.CuentaID = Cue.CuentaAhoID
        WHERE Cre.GrupoID = Par_GrupoID
          AND Cre.CicloGrupo = Par_CicloGrupo
          AND Cre.Estatus <> Esta_Pagado;

        SELECT SUM(SaldoExigible + SaldoExigibleFogafi)
        INTO   Var_TotalExigible
        FROM TMPTRANSFERCUEFOGAFI
        WHERE NumTransaccion = Aud_NumTransaccion;

        UPDATE TMPTRANSFERCUEFOGAFI Tmp SET
          Tmp.MontoPago           = ROUND(Tmp.PorcentajePago * Var_TotalExigible,2) ,
          Tmp.MontoTransferencia  = CASE WHEN (Tmp.MontoPago > Tmp.SaldoDisponible) THEN Tmp.SaldoDisponible ELSE Tmp.MontoPago END
        WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

        SET Var_NumIteraciones := (SELECT COUNT(*) FROM TMPTRANSFERCUEFOGAFI WHERE NumTransaccion = Aud_NumTransaccion);
        SET Var_ClienteIDTrans := IFNULL( (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaPago), Entero_Cero);

        SET Var_Consecutivo := Entero_Uno;
        WHILE(Var_Consecutivo <= Var_NumIteraciones) DO

          SELECT Tmp.CreditoID, Tmp.CuentaAhoID,  Tmp.MontoTransferencia
          INTO   Var_CreditoID, Var_CuentaAhoID,  Var_MontoTransf
          FROM TMPTRANSFERCUEFOGAFI Tmp
          WHERE Tmp.RegistroID = Var_Consecutivo
            AND Tmp.NumTransaccion = Aud_NumTransaccion;

          IF( Var_CuentaAhoID <> Par_CuentaPago AND Var_MontoTransf > Entero_Cero ) THEN

            SELECT Cre.ClienteID,  Cue.MonedaID, Cue.SucursalID
            INTO   Var_ClienteID,  Var_MonedaID, Var_SucursalID
            FROM CREDITOS Cre
            INNER JOIN CUENTASAHO Cue ON Cre.CuentaID = Cue.CuentaAhoID
            WHERE CreditoID = Var_CreditoID;

            SET Var_ReferenciaMov   := Var_CreditoID;

            -- Cargo a la cuenta del grupo
            CALL CARGOABONOCTAPRO(
              Var_CuentaAhoID,    Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSistema,     Var_FechaSistema,
              Nat_Cargo,          Var_MontoTransf,    DescripcionMov,       Var_ReferenciaMov,    Mov_TraspasoCta,
              Var_MonedaID,       Var_SucursalID,     Con_NO,               Con_TransfCta,        Var_Poliza,
              Cons_SI,            Con_AhoCapital,     Nat_Cargo,            Par_SalidaNO,         Par_NumErr,
              Par_ErrMen,         Var_ConsecutivoTra, Par_EmpresaID,        Aud_Usuario,          Aud_FechaActual,
              Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,         Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

            -- Abono a la cuenta que realizara el pago
            CALL CARGOABONOCTAPRO(
              Par_CuentaPago,     Var_ClienteIDTrans, Aud_NumTransaccion,   Var_FechaSistema,     Var_FechaSistema,
              Nat_Abono,          Var_MontoTransf,    DescripcionMov,       Var_ReferenciaMov,    Mov_TraspasoCta,
              Var_MonedaID,       Var_SucursalID,     Con_NO,               Con_TransfCta,        Var_Poliza,
              Cons_SI,            Con_AhoCapital,     Nat_Abono,            Par_SalidaNO,         Par_NumErr,
              Par_ErrMen,         Var_ConsecutivoTra, Par_EmpresaID,        Aud_Usuario,          Aud_FechaActual,
              Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,         Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;
          END IF;

          SET Var_ConsecutivoTra  := Entero_Cero;
          SET Var_CreditoID       := Entero_Cero;
          SET Var_CuentaAhoID     := Entero_Cero;
          SET Var_MontoTransf     := Entero_Cero;
          SET Var_ClienteID       := Entero_Cero;
          SET Var_MonedaID        := Entero_Cero;
          SET Var_SucursalID      := Entero_Cero;
          SET Var_ReferenciaMov   := Cadena_Vacia;

          SET Var_Consecutivo := Var_Consecutivo + Entero_Uno;
        END WHILE;

        DELETE FROM TMPTRANSFERCUEFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
        SET Par_MontoPagar := (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaPago);

      END IF;

    IF (Par_Finiquito = SI_EsFiniquito) THEN
      CALL PAGOGRUPALFINIQPRO(
        Par_GrupoID,        Par_MontoPagar,     Par_CuentaPago,     Par_MonedaID,       Par_FormaPago,
        Par_CicloGrupo,     Par_EmpresaID,      Par_AltaEncPoliza,  Par_SalidaNO,       Var_Poliza,
        Var_MontoPago,      Par_OrigenPago,     Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

      IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;

    ELSE
      /*
      Se realiza la llamada al SP que valida si el monto a pagar es mayor o menor al exigible para que posteriormente,
      se bloquee o desbloquee saldo de la cuenta del cliente
      */


      -- Valida si permite el cobro por garantía financiada
      IF( Var_CobraFOGAFI = Cons_SI )THEN
        CALL PAGOGRUPALFOGAFIPRO(
          Par_GrupoID,        Par_MontoPagar,     Par_CuentaPago,     Par_CicloGrupo,     Par_FormaPago,
          Par_EmpresaID,      Par_SalidaNO,       Var_Poliza,       Par_NumErr,       Par_ErrMen,
          Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
          Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;
      END IF;

      IF(Var_TipPagComFal = Con_FinalPrel) THEN

        CALL PAGOGRUPALCOMESPRO(
          Par_GrupoID,        Par_MontoPagar,     Par_CuentaPago,     Par_MonedaID,       Par_FormaPago,
          Par_CicloGrupo,     Par_EmpresaID,      Par_AltaEncPoliza,  Par_SalidaNO,       Var_Poliza,
          Var_MontoPago,      Par_OrigenPago,     Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
          Aud_NumTransaccion  );

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

      ELSE

        CALL PAGOGRUPALORDPRO(
          Par_GrupoID,        Par_MontoPagar,     Par_CuentaPago,     Par_MonedaID,     Par_FormaPago,
          Par_CicloGrupo,     Par_EmpresaID,      Par_AltaEncPoliza,  Par_OrigenPago,   Par_SalidaNO,
          Var_Poliza,         Var_MontoPago,      Par_NumErr,         Par_ErrMen,       Par_Consecutivo,
          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
          Aud_NumTransaccion  );

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

      END IF;

    END IF;

-- Validacion de Poliza Descuadrada o sin detallePoliza
	-- IALDANA T_14211 Se agrega condicional para que valide unicamente con cargo a cuenta.
	IF( Par_OrigenPago = Con_CargoCta ) THEN
		SELECT round(sum(Cargos),2), round(sum(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
			FROM DETALLEPOLIZA
			WHERE PolizaID = Var_Poliza;

		SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Entero_Cero);
		SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Entero_Cero);


		IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza or (Var_CargosPoliza + Var_AbonosPoliza)=Entero_Cero)THEN
				SET Par_ErrMen:=CONCAT(" 1.- Poliza Descuadrada Cargos: ",Var_CargosPoliza," Abonos: ",Var_AbonosPoliza);
				SET Par_NumErr:=009;
				LEAVE ManejoErrores;
		END IF;
	END IF;




    SET Par_NumErr  := Entero_Cero;

  END ManejoErrores;

  IF (Par_Salida = Par_SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'creditoID' AS control,
        Var_Poliza AS consecutivo;
  END IF;

END TerminaStore$$