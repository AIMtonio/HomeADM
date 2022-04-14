-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQGRUPALFOGAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQGRUPALFOGAFIPRO`;

DELIMITER $$
CREATE PROCEDURE `BLOQGRUPALFOGAFIPRO`(
  # ======================================================================================================
  # ----- SP QUE REALIZA BLOQUEO DE LA GARANTIA FOGAFI DE MANERA PRORRATEADA PARA CRÉDITOS GRUPALES
  # ======================================================================================================
  Par_GrupoID       INT(11),      -- Numero de grupo
  INOUT Par_MontoPagar  DECIMAL(12,2),    -- Monto a Pagar
  Par_CuentaPago      BIGINT(12),     -- Cuenta de la que se tomará el dinero para realizar el pago.
  Par_CicloGrupo      INT(11),      -- Indica el ciclo del grupo
  Par_PolizaID      BIGINT(20),     -- Numero de Poliza

  Par_ActualizaDetalle  CHAR(1),      -- Indica si actualiza la tabla de detalle para descontar o no el movimiento de bloqueo

  Par_EmpresaID       INT(11),      -- ID de la empresa
  Par_Salida        CHAR(1),      -- Salida S:SI  N:NO
  INOUT Par_NumErr      INT(11),      -- Numero de Error
  INOUT Par_ErrMen      VARCHAR(400),   -- Mensaje de Error

  # Parámetros de Auditoría
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT
  )
TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE Var_FechaSis    DATETIME;
  DECLARE Var_NumCiclo    INT(11);
  DECLARE Var_TotalCiclo    INT(11);
  DECLARE Var_PagoIndiv   DECIMAL(14,2);
  DECLARE Var_MontoAplic    DECIMAL(14,2);

  DECLARE Var_SumTotPagar   DECIMAL(14,2);
  DECLARE Var_MaxCredito    BIGINT(12);
  DECLARE Var_MaxAmorti   INT(11);
  DECLARE Var_CreditoID     BIGINT(12);
  DECLARE Var_AmortiCreID   INT(11);

  DECLARE Var_CuentaAhoTrans  BIGINT(12);
  DECLARE Var_ClienteIDTrans  INT(11);
  DECLARE Var_MonedaID    INT(11);
  DECLARE Var_SucCliente    INT(11);
  DECLARE Var_ExiCredito    DECIMAL(14,2);

  DECLARE Var_ExiAmorti     DECIMAL(14,2);
  DECLARE Var_TotCredito    DECIMAL(14,2);
  DECLARE Var_SaldoPago   DECIMAL(14,2);
  DECLARE AltaEncPoliza   CHAR(1);
  DECLARE Var_CicloActual   INT(11);

    DECLARE Var_NumAmortizacion INT(11);    -- Numero de Amortizaciones Exigibles
  DECLARE Var_MontoPago   DECIMAL(14,2);  -- Monto de Pago de Garantia
  DECLARE Var_ReqContaGarLiq  CHAR(1);    -- Indica si se requiere el registro contable de Garantía Líquida
  DECLARE Var_ClienteID   INT(11);
  DECLARE ContadorAux     INT(11);

  DECLARE NumRegistros    INT(11);


  -- Declaracion de Constantes
  DECLARE Entero_Cero     INT(11);
  DECLARE Decimal_Cero    INT(11);
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Cons_SI       CHAR(1);    -- Constante: SI

    DECLARE Cons_NO       CHAR(1);    -- Constante: NO
  DECLARE SalidaNO      CHAR(1);
  DECLARE SalidaSI      CHAR(1);
  DECLARE Si_Prorratea    CHAR(1);
  DECLARE Nat_Cargo       CHAR(1);

  DECLARE Nat_Abono       CHAR(1);
  DECLARE AltaPoliza_NO     CHAR(1);
  DECLARE AltaPoliza_SI     CHAR(1);
  DECLARE AltaMovAho_SI     CHAR(1);
  DECLARE Pol_Automatica    CHAR(1);

  DECLARE Coc_PagoCred    INT(11);
  DECLARE Esta_Activo     CHAR(1);
  DECLARE Esta_Vencido    CHAR(1);
  DECLARE Esta_Vigente    CHAR(1);
  DECLARE Esta_Pagado     CHAR(1);

  DECLARE CuentaInterna   CHAR(1);
  DECLARE NatCargo      CHAR(1);
  DECLARE NatAbono      CHAR(1);
  DECLARE DescripcionMov    VARCHAR(100);
  DECLARE ReferenciaMov   VARCHAR(100);

  DECLARE Mov_TraspasoCta   CHAR(4) ;
  DECLARE Con_TransfCta     INT(11);    -- CONCEPTOSCONTA: Concepto Contable: Transferencia entre Cuentas Propias
  DECLARE AltaMovPoliza_SI  CHAR(1);
  DECLARE Con_AhoCapital    INT(11);    -- Concepto de ahorro de capital
    DECLARE Bloqueo       CHAR(1);    -- Constante: Bloqueo

  DECLARE TipoBloqGarFOGAFI INT(11);    -- TIPOSBLOQUEOS: Bloqueo de Garantia FOGAFI(Garantia Financiada)
  DECLARE Desc_BloqFOGAFI   VARCHAR(50);  -- Descripción del bloqueo de la Garantía FOGAFI
    DECLARE Con_BloqGarFOGAFI INT(11);    -- CONCEPTOSCONTA: Bloqueo de Garantia FOGAFI
    DECLARE Var_MontoTotExi   DECIMAL(14,2);  -- Monto Total Exigible de Garantías FOGAFI
  DECLARE Aplica_Cuenta       CHAR(1);      -- Constante Aplica a Cuenta de Ahorro

  -- Asignacion de Constantes
  SET Entero_Cero     := 0;     -- Entero en Cero
  SET Decimal_Cero    := 0.00;    -- Decimal en Cero
    SET Cadena_Vacia    := '';      -- Constante: Cadena Vacia
    SET Fecha_Vacia     := '1900-01-01';-- Constante: Fecha Vacia
  SET SalidaNO      := 'N';     -- Salida: NO

  SET SalidaSI      := 'S';     -- Salida: SI
  SET Si_Prorratea    := 'S';     -- Si prorratea el pago en el grupo
  SET Nat_Cargo       := 'C';     -- Naturaleza de Cargo
  SET Nat_Abono       := 'A';     -- Naturaleza de Abono
  SET AltaPoliza_NO     := 'N';     -- Alta del Encabezado de la Poliza: NO

  SET AltaPoliza_SI     := 'S';     -- Alta del Encabezado de la Poliza: SI
  SET AltaMovAho_SI     := 'S';     -- Alta del Movimiento de Ahorro: SI
  SET Con_AhoCapital    := 1;       -- Concepto de Ahorro: Capital
  SET Pol_Automatica    := 'A';     -- Tipo de Poliza Automatica
  SET Coc_PagoCred    := 54;      -- Concepto Contable: Pago de Credito

  SET Esta_Activo     := 'A';     -- Estatus: Activo
  SET Esta_Vencido    := 'B';     -- Estatus: Vencido
  SET Esta_Vigente    := 'V';     -- Estatus: Vigente
  SET Esta_Pagado     := 'P';     -- Estatus: Pagado
  SET CuentaInterna   := 'I';     -- Cuenta Tipo Interna

  SET NatCargo      := 'C';     -- Naturaleza Cargo
  SET NatAbono      := 'A';     -- Naturaleza Abono
  SET DescripcionMov    := 'TRANSFERENCIA A CUENTA';
  SET ReferenciaMov   := 'GARANTIA LIQUIDA FINANCIADA';
  SET Mov_TraspasoCta   := '12';    -- TIPOSMOVSAHO: Traspaso Cuenta Interna

  SET Con_TransfCta   := 90;      -- CONCEPTOSCONTA: Concepto Contable: Transferencia entre Cuentas Propias
  SET AltaMovPoliza_SI  := 'S';     -- Alta de movimientos de ahorro
  SET Bloqueo       := 'B';     -- Constante: Bloqueo
    SET TipoBloqGarFOGAFI := 20;      -- TIPOSBLOQUEOS: Bloqueo de Garantia FOGAFI(Garantia Financiada)
  SET Desc_BloqFOGAFI   := 'BLOQUEO POR GARANTIA LIQUIDA FINANCIADA';

    SET Cons_SI       := 'S';     -- Constante: SI
  SET Cons_NO       := 'N';     -- Constante: NO
    SET Con_BloqGarFOGAFI := 48;          -- CONCEPTOSCONTA: Concepto Contable Bloqueo de Garantía FOGAFI
  SET Aud_ProgramaID := 'PAGOCREDITOPRO'; -- Programa ID
  SET Aplica_Cuenta       := 'S';

  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-BLOQGRUPALFOGAFIPRO');
        END;

    # Se obtiene el ciclo actual del grupo
    SELECT CicloActual INTO Var_CicloActual
    FROM GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

    SET Var_ClienteID := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaPago);


    SELECT FechaSistema,  ContabilidadGL INTO Var_FechaSis, Var_ReqContaGarLiq
      FROM PARAMETROSSIS;

    DELETE FROM TMPAMORTIFOGAFIGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPCREDITOFOGAFIGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion;


    -- Aplica solo para el encabezado de la poliza
    IF(IFNULL(Par_PolizaID,Entero_Cero)=Entero_Cero)THEN
      SET AltaEncPoliza := AltaPoliza_SI;
    ELSE
      IF(IFNULL(Par_PolizaID,Entero_Cero)>Entero_Cero)THEN
        SET AltaEncPoliza := AltaPoliza_NO;
      END IF;
    END IF;

    # Se valida si el ciclo del grupo es el actual
    IF(Par_CicloGrupo = Var_CicloActual) THEN

      # Se inserta a la tabla el exigible de garantía por amortizaciones de los créditos de todos los integrantes del grupo
      INSERT INTO `TMPAMORTIFOGAFIGRUPO` (
          `NumTransaccion`,   `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAplicar`)
        SELECT Aud_NumTransaccion,  Cre.CreditoID,  Det.AmortizacionID, FNEXIGIBLEGARFOGAFI(Det.CreditoID, Det.AmortizacionID),
                                                  Entero_Cero
          FROM INTEGRAGRUPOSCRE Ing
            INNER JOIN SOLICITUDCREDITO Sol
              ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
            INNER JOIN CREDITOS Cre
              ON Sol.CreditoID = Cre.CreditoID
            INNER JOIN DETALLEGARFOGAFI Det
              ON Cre.CreditoID = Det.CreditoID
          WHERE Ing.GrupoID = Par_GrupoID
          AND Ing.Estatus = Esta_Activo
          AND Ing.ProrrateaPago = Si_Prorratea
          AND ( Cre.Estatus = Esta_Vigente
            OR Cre.Estatus = Esta_Vencido)
          AND Det.Estatus != Esta_Pagado
          AND Det.FechaPago <= DATE(Var_FechaSis);

    ELSE
      # Se inserta a la tabla el exigible de garantía por amortizaciones de los créditos de todos los integrantes del grupo
      INSERT INTO `TMPAMORTIFOGAFIGRUPO` (
            `NumTransaccion`, `CreditoID`,  `AmortizacionID`, `MontoExigible`,  `MontoAplicar`)
        SELECT  Aud_NumTransaccion, Cre.CreditoID,  Det.AmortizacionID, FNEXIGIBLEGARFOGAFI(Det.CreditoID, Det.AmortizacionID),
                                                  Entero_Cero
          FROM `HIS-INTEGRAGRUPOSCRE` Ing
            INNER JOIN SOLICITUDCREDITO Sol
              ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
            INNER JOIN CREDITOS Cre
              ON Sol.CreditoID = Cre.CreditoID
            INNER JOIN DETALLEGARFOGAFI Det
              ON Cre.CreditoID = Det.CreditoID
          WHERE Ing.GrupoID = Par_GrupoID
          AND Ing.Estatus = Esta_Activo
          AND Ing.Ciclo = Par_CicloGrupo
          AND Ing.ProrrateaPago = Si_Prorratea
          AND ( Cre.Estatus = Esta_Vigente
            OR Cre.Estatus = Esta_Vencido)
          AND Det.Estatus != Esta_Pagado
          AND Det.FechaPago <= DATE(Var_FechaSis);

    END IF;

    # Se inserta cuanto es el monto a pagar por amortización de todos los integrantes del grupo.
    INSERT INTO TMPCREDITOFOGAFIGRUPO(
          `NumTransaccion`, `AmortizacionID`, `MontoExigible`)
      SELECT  Aud_NumTransaccion, AmortizacionID,   SUM(MontoExigible)
        FROM TMPAMORTIFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion
        GROUP BY AmortizacionID;

    DELETE FROM TMPBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
    DELETE FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;

    -- Inicializaciones
    SET Var_MontoAplic  := Decimal_Cero;  -- El monto aplicado se inicia en Cero.
    SET Var_SaldoPago := Par_MontoPagar; -- El saldo del Pago es el Monto a Pagar

    SET @Contador := 0;
    -- Inserta datos en la tabla temporal para el primer ciclo
    INSERT INTO TMPBLOQGPALGARFOGAFI(
          Consecutivo,  CreditoID,    AmortizacionID,   MontoExigible,    NumTransaccion)
      SELECT  (@Contador := @Contador + 1),
                  MAX(CreditoID), AmortizacionID,   SUM(MontoExigible), Aud_NumTransaccion
        FROM TMPAMORTIFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion
        GROUP BY AmortizacionID;

    SET @Contador := 0;
    -- Inserta datos en
    INSERT INTO BLOQGPALGARFOGAFI(
          Consecutivo,  CreditoID,    CuentaID,     ClienteID,      MonedaID,
          SucursalID,   NumTransaccion)
      SELECT  (@Contador := @Contador + 1),
                  Cre.CreditoID,  MAX(Cre.CuentaID),  MAX(Cre.ClienteID), MAX(Cre.MonedaID),
          MAX(Cli.SucursalOrigen), Aud_NumTransaccion
        FROM TMPAMORTIFOGAFIGRUPO Tem,
           CREDITOS Cre, CLIENTES Cli
      WHERE Tem.NumTransaccion = Aud_NumTransaccion
       AND Tem.CreditoID = Cre.CreditoID
       AND Cre.ClienteID = Cli.ClienteID
      GROUP BY Cre.CreditoID
      ORDER BY Cre.CreditoID;


    SET ContadorAux := 1;
    -- Obtiene el numero de resgistros para operar el while
    SET NumRegistros := (SELECT COUNT(*) FROM TMPBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion);

    WHILE( ContadorAux<=NumRegistros AND Var_SaldoPago>Decimal_Cero )DO

      SELECT CreditoID, AmortizacionID,   MontoExigible
        INTO Var_CreditoID, Var_AmortiCreID, Var_ExiAmorti
      FROM TMPBLOQGPALGARFOGAFI
      WHERE Consecutivo = ContadorAux
      AND NumTransaccion = Aud_NumTransaccion;

      -- Inicializacion
      SET Var_ExiCredito  := Entero_Cero;

      # Exigible total de Garantía por amortización de todos los créditos del grupo.
      SELECT MontoExigible INTO Var_ExiCredito
        FROM TMPCREDITOFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion
        AND AmortizacionID = Var_AmortiCreID;

      SET Var_ExiCredito := IFNULL(Var_ExiCredito, Entero_Cero);

      -- Si Completa a Pagar el Saldo de las Amortizaciones Indicadas
      IF(Var_SaldoPago >= Var_ExiCredito) THEN

        UPDATE TMPAMORTIFOGAFIGRUPO SET
          MontoAplicar = MontoExigible
          WHERE NumTransaccion = Aud_NumTransaccion
           AND AmortizacionID = Var_AmortiCreID;

        SET Var_SaldoPago := Var_SaldoPago - Var_ExiCredito; -- Al saldo del Pago se le resta el exigible del crédito.

      ELSE
        # Se asigna el pago total del grupo correspondiente al saldo del pago.
        UPDATE TMPAMORTIFOGAFIGRUPO SET
          MontoAplicar = ROUND(IF(Var_ExiCredito != Entero_Cero, (MontoExigible / Var_ExiCredito), Entero_Cero) * Var_SaldoPago,2)
          WHERE NumTransaccion = Aud_NumTransaccion
           AND AmortizacionID = Var_AmortiCreID;

        SET Var_SaldoPago := Entero_Cero; -- El saldo del pago queda en cero.

      END IF;

      SET ContadorAux := ContadorAux + 1;

    END WHILE;

    -- Consideraciones de Redondeos y Centavos
    -- Suma el Monto Total a Pagar y el Monto Total Exigible
    SELECT SUM(MontoAplicar), SUM(MontoExigible)
      INTO Var_SumTotPagar, Var_MontoTotExi
    FROM TMPAMORTIFOGAFIGRUPO Tem
    WHERE Tem.NumTransaccion = Aud_NumTransaccion;

    -- Verificamos si la diferencia alcanzó para pagar el exigible o no
    IF( Par_MontoPagar < Var_MontoTotExi )THEN
      -- Ajusta el Monto Total a Pagar con el Monto de Diferencia
      IF( Var_SumTotPagar <>  Par_MontoPagar )THEN

        -- Se obtiene el credito y el numero de la última amortizacion
        SELECT  MAX(CreditoID),   MAX(AmortizacionID)
          INTO Var_MaxCredito,  Var_MaxAmorti
        FROM TMPAMORTIFOGAFIGRUPO Tem
        WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.MontoAplicar > Entero_Cero;

        SET Var_MaxCredito  := IFNULL(Var_MaxCredito, Entero_Cero);
        SET Var_MaxAmorti := IFNULL(Var_MaxAmorti, Entero_Cero);

        -- El monto de la cuota será el monto a pagar +(El monto a pagar menos la suma total a pagar)
        -- Esto es para saber si existen diferencias de centavos y sumarlos o restarlos.
        UPDATE TMPAMORTIFOGAFIGRUPO Tem SET
          MontoAplicar = MontoAplicar + ROUND(Par_MontoPagar-Var_SumTotPagar, 2)
        WHERE Tem.NumTransaccion = Aud_NumTransaccion
        AND Tem.MontoAplicar > Entero_Cero
        AND Tem.CreditoID = Var_MaxCredito
        AND Tem.AmortizacionID = Var_MaxAmorti;

      END IF;

    END IF;


    SET ContadorAux := 1;
    -- Obtiene el numero de resgistros para operar el while
    SET NumRegistros := (SELECT COUNT(*) FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion);

    WHILE(ContadorAux<=NumRegistros)DO
      -- Inicializacion

      SELECT  CreditoID,    CuentaID,     ClienteID,      MonedaID,   SucursalID
        INTO Var_CreditoID, Var_CuentaAhoTrans, Var_ClienteIDTrans, Var_MonedaID, Var_SucCliente
      FROM BLOQGPALGARFOGAFI
      WHERE NumTransaccion = Aud_NumTransaccion
      AND Consecutivo = ContadorAux;

      SET Var_PagoIndiv := Entero_Cero;

      -- Obtenemos el Monto del Pago Asignado por crédito
      SELECT SUM(Tem.MontoAplicar) INTO Var_PagoIndiv
        FROM TMPAMORTIFOGAFIGRUPO Tem
        WHERE NumTransaccion = Aud_NumTransaccion
         AND CreditoID = Var_CreditoID;

      SET Var_PagoIndiv := IFNULL(Var_PagoIndiv, Entero_Cero);

        -- =============================== RELACION DE CUENTAS ==============================
        IF(Var_ClienteIDTrans <>Var_ClienteID) THEN

          IF NOT EXISTS(SELECT * FROM CUENTASTRANSFER
                WHERE ClienteID=Var_ClienteID
                AND CuentaDestino = Var_CuentaAhoTrans
                AND ClienteDestino = Var_ClienteIDTrans) THEN

            CALL CUENTASTRANSFERALT(
              Var_ClienteID,      Entero_Cero,        Entero_Cero,    Cadena_Vacia,   Cadena_Vacia,
              Cadena_Vacia,       Var_FechaSis,       CuentaInterna,  Entero_Cero,    Entero_Cero,
              Var_CuentaAhoTrans, Var_ClienteIDTrans, Entero_Cero,    Cadena_Vacia,   Cons_NO,
              Aplica_Cuenta,      Entero_Cero,
              SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,
              Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

          END IF;

          -- =============================== TRANSFERENCIA ENTRE CUENTAS ====================================
          -- ================================================================================================
          CALL CARGOABONOCTAPRO(
            Par_CuentaPago,   Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
            NatCargo,     Var_PagoIndiv,      DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
            Var_MonedaID,   Var_SucCliente,     AltaEncPoliza,      Con_TransfCta,      Par_PolizaID,
            AltaMovPoliza_SI, Con_AhoCapital,     NatCargo,       SalidaNO,       Par_NumErr,
            Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;


          CALL CARGOABONOCTAPRO(
            Var_CuentaAhoTrans, Var_ClienteIDTrans,   Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
            Nat_Abono,      Var_PagoIndiv,      DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
            Var_MonedaID,   Var_SucCliente,     AltaPoliza_NO,      Con_TransfCta,      Par_PolizaID,
            AltaMovPoliza_SI, Con_AhoCapital,     Nat_Abono,        SalidaNO,       Par_NumErr,
            Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
            Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;
         END IF;
        -- =============================== FIN TRANSFERENCIA ENTRE CUENTAS ====================================
        -- ================================================================================================

        -- ===============================  BLOQUEO POR GARANTIA FOGAFI ====================================
        -- ================================= MOVIMIENTOS OPERATIVOS ====================================
        # Si el monto a pagar es mayor al exigible, se realiza un bloqueo con el concepto "Deposito de Garantia Liquida Financiada"
        CALL BLOQUEOSPRO(
            Entero_Cero,    Bloqueo,      Var_CuentaAhoTrans, Var_FechaSis, Var_PagoIndiv,
            Var_FechaSis,   TipoBloqGarFOGAFI,  Desc_BloqFOGAFI,  Var_CreditoID,  Cadena_Vacia,
            Cadena_Vacia,   SalidaNO,     Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

        -- ===============================  BLOQUEO POR GARANTIA FOGAFI ====================================
        -- ================================= MOVIMIENTOS CONTABLES ====================================
        # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
        IF(Var_ReqContaGarLiq = Cons_SI) THEN

            --  Se Genera el Bloqueo Contable de la Garantía FOGAFI
            CALL CONTAGARLIQPRO(
            Par_PolizaID,     Var_FechaSis,   Var_ClienteIDTrans,     Var_CuentaAhoTrans, Var_MonedaID,
            Var_PagoIndiv,      Cons_NO,      Con_BloqGarFOGAFI,      Bloqueo,      TipoBloqGarFOGAFI,
            Desc_BloqFOGAFI,    SalidaNO,     Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
            Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

        END IF;

        -- ===============================  ACTUALIZACION TABLA DETALLEGARFOGAFI  ====================================
        -- ===========================================================================================================
        WHILE(Var_PagoIndiv > Decimal_Cero AND Par_ActualizaDetalle=Cons_SI) DO

          # Se obtiene el numero de amortizacion que debe garantía FOGAFI
          SET Var_NumAmortizacion := (SELECT MIN(AmortizacionID) FROM DETALLEGARFOGAFI WHERE CreditoID = Var_CreditoID AND FechaLiquida = Fecha_Vacia);

           # Se obtiene el adeudo de Garantía FOGAFI por amortización
           SET Var_MontoPago := (SELECT SaldoFOGAFI FROM DETALLEGARFOGAFI WHERE CreditoID = Var_CreditoID AND AmortizacionID = Var_NumAmortizacion);
           SET Var_MontoPago := IFNULL(Var_MontoPago, Decimal_Cero);

           # Validar el monto total bloqueado contra el adeudo de garantia FOGAFI
           IF(Var_PagoIndiv > Var_MontoPago) THEN -- Si el monto de bloqueo es mayor al adeudo, el monto de pago es el total del adeudo
            SET Var_MontoPago := Var_MontoPago;
           ELSE
            SET Var_MontoPago := Var_PagoIndiv;-- Si el monto de bloqueo es menor al adeudo, el monto de pago es el monto de bloqueo
          END IF;

           # Se actualiza el valor de la tabla DETALLEGARFOGAFI por cada cuota afectada.
           UPDATE DETALLEGARFOGAFI  SET
            SaldoFOGAFI = SaldoFOGAFI - Var_MontoPago,
            FechaLiquida  = CASE WHEN SaldoFOGAFI = Decimal_Cero THEN Var_FechaSis ELSE Fecha_Vacia END,
            Estatus   = CASE WHEN SaldoFOGAFI = Decimal_Cero THEN Esta_Pagado ELSE Esta_Vigente END
           WHERE CreditoID = Var_CreditoID
           AND AmortizacionID = Var_NumAmortizacion;

           # El monto de desbloqueo disminuye para poder continuar con la siguiente amortización-
           SET Var_PagoIndiv := Var_PagoIndiv - Var_MontoPago;


        END WHILE;

        # Se obtiene el monto total aplicado
        SET Var_MontoAplic := Var_MontoAplic + Var_MontoPago;

        # Al monto total a pagar, se le resta el monto que se está pagando de más y corresponde a GARANTÍA FOGAFI
        SET Par_MontoPagar := Par_MontoPagar - Var_PagoIndiv;

      SET ContadorAux := ContadorAux + 1;

    END WHILE;

  DELETE FROM TMPAMORTIFOGAFIGRUPO
    WHERE NumTransaccion = Aud_NumTransaccion;

  DELETE FROM TMPCREDITOFOGAFIGRUPO
    WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
  DELETE FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;

  SET Par_NumErr    := '000';
  SET Par_ErrMen    := CONCAT('Pago realizado exitosamente. ');

  END ManejoErrores;

  IF (Par_Salida = SalidaSI) THEN
    SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
      Par_ErrMen AS ErrMen,
      'creditoID' AS control,
      0 AS consecutivo;
  END IF;


END TerminaStore$$