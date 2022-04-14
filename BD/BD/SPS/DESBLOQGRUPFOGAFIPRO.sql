-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESBLOQGRUPFOGAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESBLOQGRUPFOGAFIPRO`;

DELIMITER $$
CREATE PROCEDURE `DESBLOQGRUPFOGAFIPRO`(
-- =======================================================================================
-- Store para realizar el desbloqueo de saldo de FOGAFI y/o FOGA
-- =======================================================================================
  Par_GrupoID       INT(11),      -- Numero de grupo
  INOUT Par_MontoPagar  DECIMAL(12,2),    -- Monto a Pagar
    Par_ExigibleGrupo   DECIMAL(12,2),    -- Monto Exigigle del grupo
  Par_CuentaPago      BIGINT(12),     -- Cuenta de la que se tomará el dinero para realizar el pago.
  Par_CicloGrupo      INT(11),      -- Indica el ciclo del grupo

  Par_PolizaID      BIGINT(20),     -- Numero de Poliza
  Par_EmpresaID       INT(11),      -- ID de la empresa.

  Par_Salida        CHAR(1),      -- Salida S:SI  N:NO
  INOUT Par_NumErr		INT(11),      -- Numero de Error
  INOUT Par_ErrMen      VARCHAR(400),   -- Mensaje de Error

  # Parámetros de Auditoría
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT
)
TerminaStore:BEGIN
  -- Declaración de Variables
  DECLARE Var_FechaSis    DATE;       -- Indica la Fecha del sistema
    DECLARE Var_ReqContaGarLiq  CHAR(1);      -- Indica la Referencia de la Garantía Líquida
    DECLARE Var_CicloActual   INT(11);      -- Indica el Ciclo Actual del Grupo
    DECLARE Var_ReqGarantia   CHAR(1);      -- Indica si requiere Garantía
    DECLARE Var_DesbloqAut    CHAR(1);      -- Insica si Rquiere Desbloqueo Automático

    DECLARE Var_ReqFOGAFI     CHAR(1);      -- Indica si Requiere FOGAFI
    DECLARE Var_DesbloqAutFGI   CHAR(1);      -- Indica si FOGAFI permite Desbloqueo Automático
    DECLARE Var_CreditoID     BIGINT(20);     -- Guarda el Identificador del Crédito
    DECLARE Var_CuentaID    BIGINT(20);     -- Guarda la cuenta de Ahorro
    DECLARE Var_ClienteID   INT(11);      -- Guarda el Identificador del Cliente

    DECLARE Var_MontoBloqFOGA DECIMAL(12,2);    -- Indica el Monto de la Garantía Líquida
    DECLARE Var_MontoBloqFOGAFI DECIMAL(12,2);    -- Indica el Monto de la Garantía FOGAFI
    DECLARE Var_ClienteTransfer INT(11);      -- Almacena el Identificador del Cliente que hace el pago
    DECLARE Var_BloqueoID     INT(11);      -- Indica el número de Bloqueo
    DECLARE Var_MontoDesbloqueo DECIMAL(12,2);    -- Indica el Monto Desbloqueado

    DECLARE Var_Diferencia    DECIMAL(12,2);    -- Indica la Diferencia Entre el Exigible y Monto del Pago
    DECLARE Var_MonedaID    INT(11);      -- Indica el ID de la Moneda
    DECLARE Var_SucCliente    INT(11);      -- insica la Sucursal del Cliente
    DECLARE Var_ExigibleCredito DECIMAL(12,2);    -- Indica el Monto del Ecigible por Crédito
    DECLARE Var_MontoPagoCredInd  DECIMAL(12,2);  -- Indica el Monto del Pago de maenra Individual

    DECLARE Var_DifPagCreInd  DECIMAL(12,2);    -- Indica la diferencia entre el exigible y el monto del pago
    DECLARE Var_MontoTranfer  DECIMAL(12,2);    -- Indica el Monto de la Tranferencia entre Cuentas
    DECLARE Var_DifNuevoBloq  DECIMAL(12,2);    -- Indica el sobrante desúes de aplicar FOGAFI
    DECLARE Var_FechaBloq     DATE;       -- Indica la Fecha en que fue bloqueado
    DECLARE Var_MontoPagar    DECIMAL(14,2);    -- Indica el Monto Original del Pago

    DECLARE Var_Continuar     CHAR(1);      -- Bandera para el número de interacciones en un ciclo.
    DECLARE ContadorAux     INT(11);      -- Contador de Ciclos
    DECLARE NumRegistros    INT(11);      -- Numero de Registros por ciclo
    DECLARE AltaEncPoliza   CHAR(1);      -- Indica Alta Encabezado de Póliza
    DECLARE Var_ModalidadFOGAFI CHAR(1);      -- Indica la Modalidad del Cobro de FOGAFI

    DECLARE Var_TotalFOGA   DECIMAL(14,2);    -- Indica el Monto Total FOGA

  -- Declaración de Constentes
    DECLARE Entero_Cero     INT(11);      -- Constante: Entero Cero
    DECLARE Cadena_Vacia    VARCHAR(50);    -- Constante: Cadena Vacía
    DECLARE Desbloqueo      CHAR(1);      -- Constante: Desbloqueo
    DECLARE TipoBloqFOGAFI    INT(11);      -- Constante: Tipo de Bloqueo para FOGAFI
    DECLARE TipoDesbloqFOGAFI   INT(11);      -- Constante: Tipo Desbloqueo FOGAFI

    DECLARE Desc_DesbloqFOGAFI  VARCHAR(50);    -- Constante: Descripción para Desbloqueo FOGAFI
    DECLARE SalidaNO      CHAR(1);      -- Constante: Salida No
    DECLARE CuentaInterna   CHAR(1);      -- Tipo Movimiento entre Cuentas Internas
    DECLARE DescripcionMov    VARCHAR(50);    -- Descripción de Movimiento de Ahorro
    DECLARE ReferenciaMov   VARCHAR(50);    -- Referencia para el Movimiento de Ahorro

    DECLARE Mov_TraspasoCta   CHAR(4);      -- Tipo Movimiento Traspado Entre Cuentas
    DECLARE AltaPoliza_SI     CHAR(1);      -- Constante: Indica Alta Encabezado de Poliza SI
    DECLARE AltaPoliza_NO     CHAR(1);      -- Constante: Indica Alta de Encabezado de Poliza NO
    DECLARE Con_TransfCta   INT(11);      -- Concepto Tranferencia entre Cuentas
    DECLARE AltaMovPoliza_SI  CHAR(1);      -- Constante: Alta Detalle de Poliza SI

    DECLARE Con_AhoCapital    INT(11);      -- Concepto Ahorro de Capital
    DECLARE NatCargo      CHAR(1);      -- Constante: Naturaleza Cargo
    DECLARE Nat_Abono     CHAR(1);      -- Constante: Naturaleza Abono
    DECLARE Bloqueo       CHAR(1);      -- Constante: Indica Bloqueo
    DECLARE TipoBloqGarFOGA   INT(11);      -- Tipo de Bloqueo Garantía Líquida

    DECLARE Desc_BloqFOGAFI   VARCHAR(50);    -- Descripción Bloqueo por FOGAFI
    DECLARE Desc_DesbloqFOGA  VARCHAR(50);    -- Descripción Desbloqueo FOGA
    DECLARE Desc_BloqFOGA     VARCHAR(50);    -- Descripción Bloqueo FOGA
    DECLARE TipoDesbloqGarFOGA  INT(11);      -- Tipo de Desbloqueo par FOGA
    DECLARE ReferenciaMovFOGA VARCHAR(50);    -- Referencia para Movimientos de FOGA

    DECLARE Cons_SI       CHAR(1);      -- Constante:  SI
    DECLARE ActDetalle_No     CHAR(1);      -- Indica si actualiza el detalle
    DECLARE Fecha_Vacia     DATE;       -- Indica Fecha Vacía
    DECLARE Cons_NO       CHAR(1);      -- Constante: NO
    DECLARE Con_DesGarFogafi  INT(11);      -- Concento Contable FOGAFI

    DECLARE Con_BloqGarLiq    INT(11);      -- Concepto Contable FOGA
    DECLARE Con_DesGarLiq     INT(11);      -- Concepto Contable FOGA
    DECLARE Salida_NO       CHAR(1);      -- Constante Salida No
    DECLARE Aplica_Cuenta   CHAR(1);      -- Constante Aplica a Cuenta de Ahorro

    -- Asignación de Constantes
    SET Entero_Cero     := 0;     -- Constante: Entero_Cero
    SET Cadena_Vacia    := '';      -- Constante: Cadena Vacía
    SET Desbloqueo      := 'D';     -- Constante: Desbloqueo
    SET TipoDesbloqFOGAFI   := 21;      -- Tipo de Desbloqueo por FOGAFI
    SET TipoBloqFOGAFI    := 20;      -- Tipo de Bloqueo

    SET Desc_DesbloqFOGAFI  := 'DESBLOQUEO POR GARANTIA FOGAFI';
    SET SalidaNO      := 'N';     -- Constante: Salida No
    SET CuentaInterna   := 'I';     -- Constante: Indica Transferencia entre Cuentas Internas
    SET DescripcionMov    := 'TRANSFERENCIA A CUENTA';
    SET ReferenciaMov   := 'GARANTIA LIQUIDA FINANCIADA';

    SET Mov_TraspasoCta   := '12';    -- Constante: Indica número de Movimiento para Transferencia entre Cuentas
    SET AltaPoliza_SI     := 'S';     -- Constante: Alta de Encabezado de Poliza SI
    SET AltaPoliza_NO     := 'N';     -- Constante: Alta de Encabezado de Poliza No
    SET Con_TransfCta   := 90;      -- Concepto Tranferencia entre Cuentas
    SET AltaMovPoliza_SI  := 'S';     -- Constante: Alta Detalle Poliza SI

    SET Con_AhoCapital    := 1;       -- Concepto de Ahorro para Capital
    SET NatCargo      := 'C';     -- Constante: Naturaleza Cargo
  SET Nat_Abono       := 'A';     -- Constante: Naturaleza Abono
  SET Bloqueo       := 'B';     -- Constante: Bloqueo
  SET TipoBloqGarFOGA   := 8;       -- Constante: Tipo de Bloqueo por Garantía Líquida

  SET TipoDesbloqGarFOGA  := 9;       -- Constante: Tipo de Desbloqueo por Garantía Líquida
    SET Cons_SI       := 'S';     -- Constante: Si
    SET ActDetalle_No     := 'N';     -- Indica si actualiza detalle
  SET Desc_BloqFOGAFI   := 'BLOQUEO POR GARANTIA LIQUIDA FINANCIADA';
  SET Desc_DesbloqFOGA  := 'DEVOLUCION POR GARANTIA LIQUIDA';

  SET Desc_BloqFOGA     := 'DEPOSITO POR GARANTIA LIQUIDA';
  SET ReferenciaMovFOGA   := 'GARANTIA LIQUIDA';
    SET Var_Continuar     := 'S';
    SET Fecha_Vacia     := '1900-01-01'; -- Indica Constante No
    SET Con_DesGarFogafi  := 49;      -- CONCEPTOSCONTA: Concepto Contable Desbloqueo de Garantía FOGAFI

    SET Con_BloqGarLiq    := 64;      -- CONCEPTOSCONTA: Concepto Contable Bloqueo de Garantía FOGA
    SET Con_DesGarLiq       := 62;          -- CONCEPTOSCONTA: Concepto Contable Desbloqueo de Garantia Líquida (FOGA)
    SET Salida_NO       := 'N';     -- Salida No
    SET Aplica_Cuenta   := 'S';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-DESBLOQGRUPFOGAFIPRO');
        END;

        # Se obtiene el ciclo actual del grupo
    SELECT CicloActual INTO Var_CicloActual
    FROM  GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

        -- Obtiene datos domo fecha del sistema y si las garantias permiten afectación contable
        SELECT FechaSistema,  ContabilidadGL
      INTO Var_FechaSis,  Var_ReqContaGarLiq
    FROM PARAMETROSSIS;

        -- Verifica datos en Null
        SET Var_FechaSis := IFNULL(Var_FechaSis,Cadena_Vacia);
        SET Var_ReqContaGarLiq := IFNULL(Var_ReqContaGarLiq,Cadena_Vacia);

        SELECT CreditoID INTO Var_CreditoID
    FROM CREDITOS
        WHERE GrupoID = Par_GrupoID
        AND CicloGrupo = Par_CicloGrupo
        LIMIT 1;

        -- Obtiene datos generales de las garantias FOGA y FOGAFI
        SELECT RequiereGarantia, DesbloqAut,  RequiereGarFOGAFI, DesbloqAutFOGAFI, ModalidadFOGAFI
      INTO Var_ReqGarantia, Var_DesbloqAut, Var_ReqFOGAFI, Var_DesbloqAutFGI, Var_ModalidadFOGAFI
        FROM DETALLEGARLIQUIDA
        WHERE CreditoID = Var_CreditoID;

        SELECT SUM(MontoBloqueadoGar),SUM(MontoBloqueadoFOGAFI)
      INTO Var_MontoBloqFOGA, Var_MontoBloqFOGAFI
        FROM CREDITOS Cre
      INNER JOIN DETALLEGARLIQUIDA Det
        ON Cre.CreditoID=Det.CreditoID
                AND Cre.GrupoID=Par_GrupoID
                AND CicloGrupo = Par_CicloGrupo;

        -- Valida Montos de Saldo Bloqueo en Null
        SET Var_MontoBloqFOGA := IFNULL(Var_MontoBloqFOGA,Entero_Cero);
        SET Var_MontoBloqFOGAFI := IFNULL(Var_MontoBloqFOGAFI,Entero_Cero);

        -- Obtiene el Cliente quien realiza el pago para realizar las transferencias de desbloqueo
    SET Var_ClienteTransfer := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID=Par_CuentaPago);

        DELETE FROM DESBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
        DELETE FROM TMPAMORTIFOGAFIGRUPO WHERE NumTransaccion = Aud_NumTransaccion;

    SET @Contador := 0;
    -- Inserta datos en
    INSERT INTO DESBLOQGPALGARFOGAFI(
          Consecutivo,  CreditoID,    CuentaID,     ClienteID,      MonedaID,
          SucursalID,   NumTransaccion)
      SELECT  (@Contador := @Contador + 1),
                  CreditoID,    CuentaID,     ClienteID,      MonedaID,
          SucursalID,   Aud_NumTransaccion
      FROM CREDITOS
      WHERE GrupoID=Par_GrupoID
      AND CicloGrupo = Par_CicloGrupo;

        -- Verifica si tiene garantía FOGAFI y si permite desbloqueo para hacer los movimientos correspondientes
    IF(Var_ReqFOGAFI=Cons_SI AND Var_DesbloqAutFGI=Cons_SI)THEN

            -- Ciclo para realizar los desbloqueos necesarios mientras tenga saldo bloqueado.
            WHILE(Par_MontoPagar<Par_ExigibleGrupo AND Var_MontoBloqFOGAFI>Entero_Cero AND Var_Continuar=Cons_SI)DO

        SET ContadorAux := 1;
        SET NumRegistros := (SELECT COUNT(*) FROM DESBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion);
        WHILE(ContadorAux<=NumRegistros)DO

          SELECT CreditoID,   CuentaID,   ClienteID,    MonedaID,   SucursalID
            INTO Var_CreditoID, Var_CuentaID,   Var_ClienteID,  Var_MonedaID, Var_SucCliente
          FROM DESBLOQGPALGARFOGAFI
          WHERE NumTransaccion = Aud_NumTransaccion
          AND Consecutivo = ContadorAux;

          SELECT DATE(MIN(BLOQ.FechaMov)) INTO Var_FechaBloq
            FROM CREDITOS CRE
              INNER JOIN BLOQUEOS BLOQ
              ON CRE.CreditoID = BLOQ.Referencia
              AND CRE.GrupoID = Par_GrupoID
              AND CRE.CicloGrupo = Par_CicloGrupo
            WHERE BLOQ.TiposBloqID = TipoBloqFOGAFI
            AND NatMovimiento=Bloqueo
            AND FolioBloq=Entero_Cero;

                    -- Obtiene el ID del bloqueo más antiguo
          SET Var_BloqueoID := (SELECT MIN(BloqueoID) FROM BLOQUEOS
                    WHERE CuentaAhoID = Var_CuentaID
                    AND NatMovimiento=Bloqueo
                    AND DATE(FechaMov) = Var_FechaBloq
                    AND TiposBloqID=TipoBloqFOGAFI
                    AND Referencia=Var_CreditoID
                    AND FolioBloq=Entero_Cero);

          SET Var_BloqueoID := IFNULL(Var_BloqueoID,Entero_Cero);

          IF(Var_BloqueoID>Entero_Cero)THEN
            -- Obtiene el monto del bloqueo
            SET Var_MontoDesbloqueo := (SELECT MontoBloq FROM BLOQUEOS
                          WHERE BloqueoID = Var_BloqueoID);

            SET Var_MontoDesbloqueo := IFNULL(Var_MontoDesbloqueo,Entero_Cero);

            -- Realiza Desbloqueo del saldo correspondiente a la GARANTIA FOGAFI
            CALL BLOQUEOSPRO(
              Var_BloqueoID,    Desbloqueo,     Var_CuentaID,   Var_FechaSis, Var_MontoDesbloqueo,
              Var_FechaSis,   TipoBloqFOGAFI,   Desc_DesbloqFOGAFI, Var_CreditoID,  Cadena_Vacia,
              Cadena_Vacia,   SalidaNO,     Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
              Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
              Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

                        # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
            IF(Var_ReqContaGarLiq = Cons_SI) THEN

              -- Se Genera el Bloqueo Contable de la Garantía FOGAFI
              CALL CONTAGARLIQPRO(
                Par_PolizaID,     Var_FechaSis,   Var_ClienteID,        Var_CuentaID,     Var_MonedaID,
                Var_MontoDesbloqueo,  Cons_NO,      Con_DesGarFogafi,     Desbloqueo,     TipoBloqFOGAFI,
                Desc_DesbloqFOGAFI,   Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal,
                Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

            END IF;

                        -- Valida que el cliente que paga no sea el mismo para la transferencia entre cuentas
                        IF (Var_ClienteTransfer<>Var_ClienteID) THEN

              IF NOT EXISTS(SELECT * FROM CUENTASTRANSFER
                    WHERE ClienteID=Var_ClienteID
                    AND CuentaDestino = Par_CuentaPago
                    AND ClienteDestino = Var_ClienteTransfer) THEN
                -- Alta del movimiento de transferencias enter cuentas
                CALL CUENTASTRANSFERALT(
                  Var_ClienteID,      Entero_Cero,          Entero_Cero,      Cadena_Vacia,     Cadena_Vacia,
                  Cadena_Vacia,       Var_FechaSis,         CuentaInterna,    Entero_Cero,      Entero_Cero,
                  Par_CuentaPago,     Var_ClienteTransfer,  Entero_Cero,      Cadena_Vacia,     Cons_NO,
                  Aplica_Cuenta,      Entero_Cero,
                  SalidaNO,           Par_NumErr,           Par_ErrMen,       Par_EmpresaID,    Aud_Usuario,
                  Aud_FechaActual,    Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal,     Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
                  LEAVE ManejoErrores;
                END IF;
              END IF;

              -- =============================== TRANSFERENCIA ENTRE CUENTAS ====================================
              -- Aplica solo para el encabezado de la poliza
              IF(IFNULL(Par_PolizaID,Entero_Cero)=Entero_Cero)THEN
                SET AltaEncPoliza := AltaPoliza_SI;
              ELSE
                IF(IFNULL(Par_PolizaID,Entero_Cero)>Entero_Cero)THEN
                  SET AltaEncPoliza := AltaPoliza_NO;
                END IF;
              END IF;

              -- Movimientos Contables y Operativos de la transferencia
              CALL CARGOABONOCTAPRO(
                Var_CuentaID,   Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
                NatCargo,     Var_MontoDesbloqueo,  DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
                Var_MonedaID,   Var_SucCliente,     AltaEncPoliza,      Con_TransfCta,      Par_PolizaID,
                AltaMovPoliza_SI, Con_AhoCapital,     NatCargo,       SalidaNO,       Par_NumErr,
                Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
                Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

              -- Movimientos Contables y Operativos de la transferencia
              CALL CARGOABONOCTAPRO(
                Par_CuentaPago,   Var_ClienteTransfer,  Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
                Nat_Abono,      Var_MontoDesbloqueo,  DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
                Var_MonedaID,   Var_SucCliente,     AltaPoliza_NO,      Con_TransfCta,      Par_PolizaID,
                AltaMovPoliza_SI, Con_AhoCapital,     Nat_Abono,        SalidaNO,       Par_NumErr,
                Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
                Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

            END IF;

            -- Actualiza el Monto a Pagar Grupal
            SET Par_MontoPagar := Par_MontoPagar + Var_MontoDesbloqueo;
            SET Var_MontoBloqFOGAFI := Var_MontoBloqFOGAFI - Var_MontoDesbloqueo;

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

          END IF;

          SET ContadorAux := ContadorAux + 1;

        END WHILE;

                IF(IFNULL(Var_FechaBloq,Fecha_Vacia)=Fecha_Vacia AND ContadorAux=NumRegistros)THEN
          SET Var_Continuar := 'N';
                END IF;

            END WHILE;

            SET Var_Diferencia := Par_MontoPagar - Par_ExigibleGrupo;
            SET Var_Diferencia := IFNULL(Var_Diferencia ,Entero_Cero);

            -- Valida nuevamente que no se tenga saldo sobrante, aquí debe de llamar al otro sp para volver a prorratear el restante
            IF(Var_Diferencia>Entero_Cero)THEN

        SET Par_MontoPagar := Par_MontoPagar - Var_Diferencia;

        IF(Var_ModalidadFOGAFI='P')THEN

          CALL BLOQGRUPALFOGAFIPRO(
            Par_GrupoID,  Var_Diferencia,   Par_CuentaPago,   Par_CicloGrupo, Par_PolizaID,
            ActDetalle_No,  Par_EmpresaID,    Par_Salida,     Par_NumErr,   Par_ErrMen,
            Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

        ELSE

          CALL BLOQGRUPFOGAFIANTPRO(
            Par_GrupoID,  Var_Diferencia,   Par_CuentaPago,   Par_CicloGrupo, Par_PolizaID,
            ActDetalle_No,  Par_EmpresaID,    Par_Salida,     Par_NumErr,   Par_ErrMen,
            Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

                END IF;

          END IF;

        END IF;

        -- Verifica si aún no completa el monto exigible, tenga garantía FOGA y si permite desbloqueo para completar el monto de pago.
        IF(Var_ReqGarantia=Cons_SI AND Var_DesbloqAut=Cons_SI AND Par_MontoPagar<Par_ExigibleGrupo)THEN

      SET ContadorAux := 1;
      -- Se utiliza la misma tabla DESBLOQGPALGARFOGAFI para la garantía líquida
      SET NumRegistros := (SELECT COUNT(*) FROM DESBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion);

            -- Obtiene el monto total de las garantías líquidas
      SELECT SUM(Liq.MontoGarLiq) INTO Var_TotalFOGA
              FROM CREDITOS Cre
          INNER JOIN DETALLEGARLIQUIDA Liq
            ON Cre.CreditoID = Liq.CreditoID
            AND Cre.SolicitudCreditoID = Liq.SolicitudCreditoID
            AND Cre.GrupoID = Par_GrupoID
            AND Cre.CicloGrupo = Par_CicloGrupo
        WHERE Liq.RequiereGarantia = Cons_SI;

      -- Obtiene la diferencia entre el pago y el exigible. Monto Faltante de pago
      SET Var_Diferencia := Par_ExigibleGrupo - Par_MontoPagar ;

            INSERT INTO TMPAMORTIFOGAFIGRUPO (
                `NumTransaccion`,   `CreditoID`,    `AmortizacionID`, `MontoExigible`,  `MontoAplicar`)
              SELECT Aud_NumTransaccion,  Cre.CreditoID,    Entero_Cero,    Liq.MontoGarLiq,  ROUND( Var_Diferencia *  Liq.MontoGarLiq / Var_TotalFOGA ,2)
              FROM CREDITOS Cre
          INNER JOIN DETALLEGARLIQUIDA Liq
            ON Cre.CreditoID = Liq.CreditoID
            AND Cre.SolicitudCreditoID = Liq.SolicitudCreditoID
            AND Cre.GrupoID = Par_GrupoID
            AND Cre.CicloGrupo = Par_CicloGrupo
        WHERE Liq.RequiereGarantia = 'S';


      -- Sección de Ajustes de Centavos y redondeos
      SELECT SUM(MontoAplicar) INTO Var_MontoPagar
        FROM TMPAMORTIFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion;

      IF( Var_MontoPagar <> Var_Diferencia )THEN

        SELECT MAX(CreditoID) INTO Var_CreditoID
        FROM TMPAMORTIFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion;

        UPDATE TMPAMORTIFOGAFIGRUPO SET
          MontoAplicar = MontoAplicar + ROUND( Var_Diferencia - Var_MontoPagar ,2)
        WHERE NumTransaccion = Aud_NumTransaccion
        AND CreditoID = Var_CreditoID;

      END IF;


      WHILE(ContadorAux<=NumRegistros)DO

          SELECT  CreditoID,    CuentaID,   ClienteID,    MonedaID,   SucursalID
            INTO Var_CreditoID, Var_CuentaID,   Var_ClienteID,  Var_MonedaID, Var_SucCliente
          FROM DESBLOQGPALGARFOGAFI
          WHERE NumTransaccion = Aud_NumTransaccion
          AND Consecutivo = ContadorAux;

          -- Obtiene el ID del bloqueo más antiguo
          SET Var_BloqueoID := (SELECT MIN(BloqueoID) FROM BLOQUEOS
                    WHERE CuentaAhoID = Var_CuentaID
                    AND NatMovimiento=Bloqueo
                    AND TiposBloqID=TipoBloqGarFOGA
                    AND Referencia=Var_CreditoID
                    AND FolioBloq=Entero_Cero);

          SET Var_BloqueoID := IFNULL(Var_BloqueoID,Entero_Cero);

          IF(Var_BloqueoID>Entero_Cero)THEN
            -- Obtiene el monto del bloqueo
            SET Var_MontoDesbloqueo := (SELECT MontoBloq FROM BLOQUEOS
                          WHERE BloqueoID = Var_BloqueoID);

            SET Var_MontoDesbloqueo := IFNULL(Var_MontoDesbloqueo,Entero_Cero);

            -- Realiza Desbloqueo del saldo correspondiente a la GARANTIA FOGAFI
            CALL BLOQUEOSPRO(
              Var_BloqueoID,    Desbloqueo,     Var_CuentaID,   Var_FechaSis, Var_MontoDesbloqueo,
              Var_FechaSis,   TipoBloqGarFOGA,  Desc_DesbloqFOGA, Var_CreditoID,  Cadena_Vacia,
              Cadena_Vacia,   SalidaNO,     Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
              Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
              Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;

                        # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
            IF(Var_ReqContaGarLiq = Cons_SI) THEN

                --  Se Genera el Bloqueo Contable de la Garantía FOGAFI
              CALL CONTAGARLIQPRO(
                Par_PolizaID,     Var_FechaSis,   Var_ClienteID,    Var_CuentaID,     Var_MonedaID,
                Var_MontoDesbloqueo,  Cons_NO,      Con_DesGarLiq,    Desbloqueo,     TipoBloqGarFOGA,
                Desc_DesbloqFOGA,   Salida_NO,      Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
                Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
                Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

            END IF;

            SELECT MontoAplicar INTO Var_MontoTranfer
            FROM TMPAMORTIFOGAFIGRUPO
            WHERE NumTransaccion = Aud_NumTransaccion
            AND CreditoID = Var_CreditoID;

            IF(Var_MontoTranfer>Var_MontoDesbloqueo)THEN
              SET Var_MontoTranfer := Var_MontoDesbloqueo;
            END IF;

                        -- Valida que el cliente que paga no sea el mismo para la transferencia entre cuentas
                        IF (Var_ClienteTransfer<>Var_ClienteID) THEN

              IF NOT EXISTS(SELECT * FROM CUENTASTRANSFER
                    WHERE ClienteID=Var_ClienteID
                    AND CuentaDestino = Par_CuentaPago
                    AND ClienteDestino = Var_ClienteTransfer) THEN
                -- =============================== TRANSFERENCIA ENTRE CUENTAS ====================================
                -- Alta del movimiento de transferencias enter cuentas
                CALL CUENTASTRANSFERALT(
                  Var_ClienteID,    Entero_Cero,          Entero_Cero,      Cadena_Vacia,   Cadena_Vacia,
                  Cadena_Vacia,     Var_FechaSis,         CuentaInterna,    Entero_Cero,    Entero_Cero,
                  Par_CuentaPago,   Var_ClienteTransfer,  Entero_Cero,      Cadena_Vacia,   Cons_NO,
                  Aplica_Cuenta,    Entero_Cero,
                  SalidaNO,         Par_NumErr,           Par_ErrMen,       Par_EmpresaID,  Aud_Usuario,
                  Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
                  LEAVE ManejoErrores;
                END IF;

              END IF;

              -- Aplica solo para el encabezado de la poliza
              IF(IFNULL(Par_PolizaID,Entero_Cero)=Entero_Cero)THEN
                SET AltaEncPoliza := AltaPoliza_SI;
              ELSE
                IF(IFNULL(Par_PolizaID,Entero_Cero)>Entero_Cero)THEN
                  SET AltaEncPoliza := AltaPoliza_NO;
                END IF;
              END IF;

              -- Movimientos Contables y Operativos de la transferencia
              CALL CARGOABONOCTAPRO(
                Var_CuentaID,   Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
                NatCargo,     Var_MontoTranfer,   DescripcionMov,     ReferenciaMovFOGA,    Mov_TraspasoCta,
                Var_MonedaID,   Var_SucCliente,     AltaEncPoliza,      Con_TransfCta,      Par_PolizaID,
                AltaMovPoliza_SI, Con_AhoCapital,     NatCargo,       SalidaNO,       Par_NumErr,
                Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
                Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

              -- Movimientos Contables y Operativos de la transferencia
              CALL CARGOABONOCTAPRO(
                Par_CuentaPago,   Var_ClienteTransfer,  Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
                Nat_Abono,      Var_MontoTranfer,   DescripcionMov,     ReferenciaMovFOGA,    Mov_TraspasoCta,
                Var_MonedaID,   Var_SucCliente,     AltaPoliza_NO,      Con_TransfCta,      Par_PolizaID,
                AltaMovPoliza_SI, Con_AhoCapital,     Nat_Abono,        SalidaNO,       Par_NumErr,
                Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
                Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

            END IF;

            -- Valida si no se utilizó todo el monto de la garantía liquida
            IF(Var_MontoTranfer<Var_MontoDesbloqueo)THEN
              -- Calcula la diferencia
              SET Var_DifNuevoBloq = Var_MontoDesbloqueo - Var_MontoTranfer;

              CALL BLOQUEOSPRO(
                Entero_Cero,    Bloqueo,      Var_CuentaID,   Var_FechaSis, Var_DifNuevoBloq,
                Var_FechaSis,   TipoBloqGarFOGA,  Desc_BloqFOGA,    Var_CreditoID,  Cadena_Vacia,
                Cadena_Vacia,   SalidaNO,     Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
                Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

                            # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
              IF(Var_ReqContaGarLiq = Cons_SI) THEN

                 --  Se Genera el Bloqueo Contable de la Garantía FOGAFI
                 CALL CONTAGARLIQPRO(
                  Par_PolizaID,     Var_FechaSis,   Var_ClienteID,    Var_CuentaID,     Var_MonedaID,
                  Var_DifNuevoBloq,     Cons_NO,      Con_BloqGarLiq,   Bloqueo,      TipoBloqGarFOGA,
                  Desc_BloqFOGA,      Salida_NO,      Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
                  Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
                  Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
                  LEAVE ManejoErrores;
                END IF;

              END IF;

            END IF;

            SET Par_MontoPagar := Par_MontoPagar + Var_MontoTranfer ;

          END IF;

          SET ContadorAux := ContadorAux + 1;

      END WHILE;

        END IF;

        DELETE FROM DESBLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;
        DELETE FROM TMPAMORTIFOGAFIGRUPO WHERE NumTransaccion = Aud_NumTransaccion;

    END ManejoErrores;


END TerminaStore$$