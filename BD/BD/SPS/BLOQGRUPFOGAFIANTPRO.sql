-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQGRUPFOGAFIANTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQGRUPFOGAFIANTPRO`;

DELIMITER $$
CREATE PROCEDURE `BLOQGRUPFOGAFIANTPRO`(
  # ======================================================================================================
  # ----- SP QUE REALIZA BLOQUEO DE LA GARANTIA FOGA DE MANERA ANTICIPADA PARA CRÉDITOS GRUPALES
  # ======================================================================================================
  Par_GrupoID       INT(11),      -- Numero de grupo
  INOUT Par_MontoPagar  DECIMAL(12,2),    -- Monto a Pagar
  Par_CuentaPago      BIGINT(12),     -- Cuenta de la que se tomará el dinero para realizar el pago.
  Par_CicloGrupo      INT(11),      -- Indica el ciclo del grupo
  Par_PolizaID      BIGINT(20),     -- Numero de Poliza

    Par_ActualizaDetalle  CHAR(1),      -- Indica si actualiza la tabla de detalle para descontar o no el movimiento de bloqueo

  Par_EmpresaID       INT(11),      -- ID de la empresa.
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

  -- Declaración de Variables
  DECLARE Var_CicloActual     INT(11);    -- Indica el ciclo actual del grupo
  DECLARE Var_ClienteID       BIGINT;     -- Indica el Número de cliente
  DECLARE Var_ReqContaGarLiq    CHAR(1);    -- indica si requiere garantía líquida
  DECLARE Var_FechaSis      DATE;     -- Indica la Fecha del Sistema
  DECLARE Var_ClienteIDPresi    INT(11);    -- Indica el Número de cliente que está pagando

  DECLARE Var_CreditoID       BIGINT;     -- Indica el Número del crédito
  DECLARE Var_CuentaID      BIGINT;     -- Indica el número de la cuenta relacionada al crédito
  DECLARE Var_MonedaID      INT(11);    -- Indica el tipo de moneda
  DECLARE Var_SucursalID      INT(11);    -- Indica el número de sucursal
  DECLARE Var_TotalGrupExigible   DECIMAL(14,2);  -- Indica el Total Exigible Grupal

  DECLARE Var_MontoFOGAFI     DECIMAL(14,2);  -- Indica el monto total FOGAFI Grupal
  DECLARE Var_MontoGarFOGAFI    DECIMAL(14,2);  -- Indica el Monto de la Garantía Financiada
  DECLARE Var_SaldoPago     DECIMAL(14,2);  -- Indica el saldo respatante de pagos

  DECLARE ContadorAux       INT(11);    -- Contador Auxiliar para los ciclos
  DECLARE NumRegistros      INT(11);    -- Número de registros para procesar los ciclos
  DECLARE AltaEncPoliza       CHAR(1);    -- Indica el alta en encabezado de poliza

  -- Declaración de Constantes
  DECLARE Const_Si      CHAR(1);      -- Constante: SI
  DECLARE Entero_Cero     INT(11);      -- Constante: Entero Cero
  DECLARE AltaPoliza_SI     CHAR(1);      -- Alta de Encabezado de Poliza Si
  DECLARE AltaPoliza_NO     CHAR(1);      -- Alta de Encabezado de Poliza No
  DECLARE Cadena_Vacia    VARCHAR(100);   -- Constante: Cadena Vacía

  DECLARE CuentaInterna   CHAR(1);      -- Constante: Cuenta Interna I
  DECLARE SalidaNO      CHAR(1);      -- Salida No
  DECLARE Nat_Cargo     CHAR(1);      -- Constante: Abonos
  DECLARE Nat_Abono       CHAR(1);      -- Constante: Cargos
  DECLARE DescripcionMov    VARCHAR(100);   -- Descripción del Movimiento de Ahorro

  DECLARE ReferenciaMov     VARCHAR(100);   -- Referencia del Movimiento de Ahorro
  DECLARE Mov_TraspasoCta   CHAR(4);      -- Movimiento de Transpaso entre cuentas
  DECLARE Con_TransfCta     INT(90);      -- Concepto: Transferencia entre cuentas
  DECLARE AltaMovPoliza_SI  CHAR(1);      -- Alta de Movimiento en Poliza Si
  DECLARE Con_AhoCapital    INT(11);      -- Concepto: Capital Contable

  DECLARE TipoBloqGarFOGAFI   INT(11);      -- Tipo de Bloqueo para FOGAFI
  DECLARE Desc_BloqFOGAFI   VARCHAR(100);   -- Descripción de Bloqueo para FOGAFI
    DECLARE Bloqueo       CHAR(1);      -- Constante: Bloqueo 'B'
    DECLARE Con_BloqGarFOGAFI INT(11);
    DECLARE Cons_NO       CHAR(1);      -- Constante No
  DECLARE Aplica_Cuenta       CHAR(1);      -- Constante Aplica a Cuenta de Ahorro

  -- Asignación de Constantes
  SET Const_Si      := 'S';     -- Constante: Si
  SET Entero_Cero     := 0;     -- Constante: Entero Cero
  SET AltaPoliza_SI     := 'S';     -- Alta Encabezado de Poliza Si
  SET AltaPoliza_NO   := 'N';     -- Alta Encabezado de Poliza No
  SET Cadena_Vacia    := '';      -- Constante: Cadena Vacia

  SET CuentaInterna   := 'I';     -- Constante: Cuenta Interna
  SET SalidaNO      := 'N';     -- Salida No
  SET Nat_Cargo       := 'C';     -- Naturaleza Cargo
  SET Nat_Abono       := 'A';     -- Naturaleza Abono
  SET DescripcionMov    := 'TRANSFERENCIA A CUENTA';

  SET ReferenciaMov   := 'GARANTIA LIQUIDA FINCANCIADA';
  SET Mov_TraspasoCta   := '12';    -- Movimiento de Traspaso entre cuentas
  SET Con_TransfCta   := 90;      -- Concepto Contable Transferencia entre cuentas
  SET AltaMovPoliza_Si  := 'S';     -- Alta Movimiento de Poliza Si
  SET Con_AhoCapital    := 1;     -- Concepto Contable Capital

  SET TipoBloqGarFOGAFI := 20;      -- Tipo de Bloqueo para FOGAFI
  SET Desc_BloqFOGAFI   := 'BLOQUEO POR GARANTIA LIQUIDA FINANCIADA';
    SET Bloqueo       := 'B';     -- Constante: Bloqueos
  SET Con_BloqGarFOGAFI := 48;      -- CONCEPTOSCONTA: Concepto Contable Bloqueo de Garantía FOGAFI
    SET Cons_NO       := 'N';     -- Constante: No
  SET Aplica_Cuenta       := 'S';


  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-BLOQGRUPFOGAFIANTPRO');
    END;

    -- Se obtiene el ciclo actual del grupo
    SELECT CicloActual INTO Var_CicloActual
    FROM GRUPOSCREDITO
    WHERE GrupoID = Par_GrupoID;

    SET Var_CicloActual := IFNULL(Var_CicloActual,Entero_Cero);

    -- Se obtiene el Número de cliente
    SET Var_ClienteIDPresi := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaPago);

    -- Se obtiene la fecha del sistema y si la garantía permite afectación contable
    SELECT FechaSistema,  ContabilidadGL
      INTO Var_FechaSis,  Var_ReqContaGarLiq
    FROM PARAMETROSSIS;

    -- Se eliminana los registros con el numero de transacción para ageruara que solo esistan los ocupados en este sp
    DELETE FROM TMPAMORTIFOGAFIGRUPO WHERE NumTransaccion = Aud_NumTransaccion;
    DELETE FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;

    -- Aplica solo para el encabezado de la poliza
    IF(IFNULL(Par_PolizaID,Entero_Cero)=Entero_Cero)THEN
      SET AltaEncPoliza := AltaPoliza_SI;
    ELSE
      IF(IFNULL(Par_PolizaID,Entero_Cero)>Entero_Cero)THEN
        SET AltaEncPoliza := AltaPoliza_NO;
      END IF;
    END IF;

        -- Obtiene el total de FOGAFI
    SET Var_TotalGrupExigible := ( SELECT SUM(DETG.MontoGarFOGAFI)
                  FROM CREDITOS CRE
                    INNER JOIN DETALLEGARLIQUIDA DETG
                      ON CRE.CreditoID = DETG.CreditoID
                      AND CRE.GrupoID = Par_GrupoID
                      AND CRE.CicloGrupo = Par_CicloGrupo
                  WHERE DETG.ModalidadFOGAFI='A');

    -- Valida el ciclo actual del grupo para obtener los integrantes de cada grupo
    IF( Par_CicloGrupo = Var_CicloActual )THEN
      -- Agrega los integrantes a la tabla temporal si el cilo del grupo es el actual
      INSERT INTO TMPAMORTIFOGAFIGRUPO(
          `NumTransaccion`,   `CreditoID`,    `AmortizacionID`,   `MontoExigible`,    `MontoAplicar`)
        SELECT Aud_NumTransaccion,  Cre.CreditoID,    Entero_Cero,      Det.MontoGarFOGAFI,   ROUND( Par_MontoPagar * Det.MontoGarFOGAFI / Var_TotalGrupExigible ,2)
        FROM INTEGRAGRUPOSCRE Ing
          INNER JOIN CREDITOS Cre
            ON Ing.SolicitudCreditoID = Cre.SolicitudCreditoID
                        AND Ing.ClienteID = Cre.ClienteID
            AND Cre.GrupoID = Par_GrupoID
            AND Cre.CicloGrupo = Par_CicloGrupo
          INNER JOIN DETALLEGARLIQUIDA Det
            ON Cre.CreditoID = Det.CreditoID
            AND Det.ModalidadFOGAFI = 'A';

    ELSE
      -- Agrega los integrantes del grupo si el ciclo del grupo es un ciclo anterior
      INSERT INTO TMPAMORTIFOGAFIGRUPO(
          `NumTransaccion`,   `CreditoID`,    `AmortizacionID`,   `MontoExigible`,    `MontoAplicar`)
        SELECT Aud_NumTransaccion,  Cre.CreditoID,    Entero_Cero,      Det.MontoGarFOGAFI,   ROUND( Par_MontoPagar * Det.MontoGarFOGAFI / Var_TotalGrupExigible ,2)
        FROM `HIS-INTEGRAGRUPOSCRE` Ing
          INNER JOIN CREDITOS Cre
            ON Ing.SolicitudCreditoID = Cre.SolicitudCreditoID
                        AND Ing.ClienteID = Cre.ClienteID
            AND Cre.GrupoID = Par_GrupoID
            AND Cre.CicloGrupo = Par_CicloGrupo
          INNER JOIN DETALLEGARLIQUIDA Det
            ON Cre.CreditoID = Det.CreditoID
            AND Det.ModalidadFOGAFI = 'A';

    END IF;

    SELECT SUM(MontoAplicar) INTO Var_SaldoPago
        FROM TMPAMORTIFOGAFIGRUPO
        WHERE NumTransaccion = Aud_NumTransaccion;

        IF( Var_SaldoPago <> Par_MontoPagar )THEN

            SELECT MAX(CreditoID) INTO Var_CreditoID
      FROM TMPAMORTIFOGAFIGRUPO
            wHERE NumTransaccion = Aud_NumTransaccion;

      UPDATE TMPAMORTIFOGAFIGRUPO SET
        MontoAplicar = MontoAplicar + ROUND( Par_MontoPagar - Var_SaldoPago ,2)
            WHERE NumTransaccion = Aud_NumTransaccion
            AND CreditoID = Var_CreditoID;

        END IF;

    -- Inicializamos contador
    SET @Contador := 0;

    -- Agrega los registros a la tabla temporal para inciar el ciclo del proceso
    INSERT INTO BLOQGPALGARFOGAFI(
          Consecutivo,  CreditoID,    CuentaID,     ClienteID,      MonedaID,
          SucursalID,   NumTransaccion)
      SELECT (@Contador := @Contador + 1),
                  Cre.CreditoID,  Cre.CuentaID,   Cre.ClienteID,    Cre.MonedaID,
          Cli.SucursalOrigen, Aud_NumTransaccion
      FROM TMPAMORTIFOGAFIGRUPO Tem
        INNER JOIN CREDITOS Cre
          ON Tem.CreditoID = Cre.CreditoID
                    AND Cre.GrupoID = Par_GrupoID
                    AND Cre.CicloGrupo = Par_CicloGrupo
        INNER JOIN  CLIENTES Cli
          ON Cre.ClienteID = Cli.ClienteID
      WHERE Tem.NumTransaccion = Aud_NumTransaccion;


    -- Variable Contador Auxiliar para el ciclo
    SET ContadorAux := 1;

    -- Obtenemos numero de registros de la tabla
    SET NumRegistros := (SELECT COUNT(*) FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion );
        SET NumRegistros := IFNULL(NumRegistros, Entero_Cero);

    SET Var_SaldoPago := Par_MontoPagar;

    -- Ciclo operar con cada uno de los integrantes del grupo
    WHILE( ContadorAux<=NumRegistros ) DO

      -- Obtenemos los datos de cada cliente
      SELECT CreditoID,   CuentaID,   ClienteID,    MonedaID,   SucursalID
        INTO Var_CreditoID, Var_CuentaID, Var_ClienteID,  Var_MonedaID, Var_SucursalID
      FROM BLOQGPALGARFOGAFI
      WHERE NumTransaccion = Aud_NumTransaccion
      AND Consecutivo = ContadorAux;

      SELECT  MontoExigible,    MontoAplicar
        INTO Var_MontoFOGAFI,   Var_MontoGarFOGAFI
      FROM TMPAMORTIFOGAFIGRUPO
      WHERE NumTransaccion = Aud_NumTransaccion
      AND CreditoID = Var_CreditoID;

      --  Verifica que el cliente sea diferente al que realiza el pago
      IF(Var_ClienteIDPresi<>Var_ClienteID)THEN

        -- Verifica si no existe la relación entre cuenta, si no, la registra para poder hacer la transferencia entre cuentas
        IF NOT EXISTS(SELECT * FROM CUENTASTRANSFER
                WHERE ClienteID=Var_ClienteIDPresi
                AND CuentaDestino = Var_CuentaID
                AND ClienteDestino = Var_ClienteID) THEN

          CALL CUENTASTRANSFERALT(
            Var_ClienteIDPresi, Entero_Cero,      Entero_Cero,    Cadena_Vacia,   Cadena_Vacia,
            Cadena_Vacia,       Var_FechaSis,     CuentaInterna,  Entero_Cero,    Entero_Cero,
            Var_CuentaID,       Var_ClienteID,    Entero_Cero,    Cadena_Vacia,   Cons_NO,
            Aplica_Cuenta,      Entero_Cero,
            SalidaNO,           Par_NumErr,       Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

        END IF;

        -- =============================== TRANSFERENCIA ENTRE CUENTAS ==================================== --
        CALL CARGOABONOCTAPRO(
          Par_CuentaPago,   Var_ClienteIDPresi,   Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
          Nat_Cargo,      Var_MontoGarFOGAFI,   DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
          Var_MonedaID,   Var_SucursalID,     AltaEncPoliza,      Con_TransfCta,      Par_PolizaID,
          AltaMovPoliza_SI, Con_AhoCapital,     Nat_Cargo,        SalidaNO,       Par_NumErr,
          Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
          Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;


        CALL CARGOABONOCTAPRO(
          Var_CuentaID,   Var_ClienteID,      Aud_NumTransaccion,   Var_FechaSis,     Var_FechaSis,
          Nat_Abono,      Var_MontoGarFOGAFI,   DescripcionMov,     ReferenciaMov,      Mov_TraspasoCta,
          Var_MonedaID,   Var_SucursalID,     AltaEncPoliza,      Con_TransfCta,      Par_PolizaID,
          AltaMovPoliza_SI, Con_AhoCapital,     Nat_Abono,        SalidaNO,       Par_NumErr,
          Par_ErrMen,     Entero_Cero,      Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
          Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

      END IF;

      CALL BLOQUEOSPRO(
          Entero_Cero,    Bloqueo,      Var_CuentaID,   Var_FechaSis, Var_MontoGarFOGAFI,
          Var_FechaSis,   TipoBloqGarFOGAFI,  Desc_BloqFOGAFI,  Var_CreditoID,  Cadena_Vacia,
          Cadena_Vacia,   SalidaNO,     Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
          Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
          Aud_NumTransaccion);

      IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;

      # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
      IF(Var_ReqContaGarLiq = Const_SI) THEN

         --  Se Genera el Bloqueo Contable de la Garantía FOGAFI
         CALL CONTAGARLIQPRO(
          Par_PolizaID,     Var_FechaSis,   Var_ClienteID,    Var_CuentaID,     Var_MonedaID,
          Var_MontoGarFOGAFI,   Cons_NO,      Con_BloqGarFOGAFI,  Bloqueo,      TipoBloqGarFOGAFI,
          Desc_BloqFOGAFI,    SalidaNO,     Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
          Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
          Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

      END IF;

      SET Var_SaldoPago := Var_SaldoPago - Var_MontoGarFOGAFI;

      SET ContadorAux := ContadorAux + 1;

    END WHILE;

        DELETE FROM TMPAMORTIFOGAFIGRUPO WHERE NumTransaccion = Aud_NumTransaccion;
    DELETE FROM BLOQGPALGARFOGAFI WHERE NumTransaccion = Aud_NumTransaccion;

  END ManejoErrores;

  IF(Par_Salida=Const_Si)THEN

    SELECT CONVERT(Par_NumEr,CHAR(3)) AS NumErr,
      Par_ErrMen AS ErrMen,
      'creditoID' AS control,
      0 AS consecutivo;

  END IF;


END TerminaStore$$