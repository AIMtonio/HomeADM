-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGRUPALFOGAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGRUPALFOGAFIPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOGRUPALFOGAFIPRO`(
-- =======================================================================
-- SP PARA REALIZAR EL COBRO DE FOGAFI EN CREDITOS GRUPALES
-- =======================================================================
    Par_GrupoID           INT(11),      -- Numero de grupo
    INOUT Par_MontoPagar  DECIMAL(12,2),    -- Monto a Pagar
    Par_CuentaPago        BIGINT(12),     -- Cuenta de la que se tomará el dinero para realizar el pago.
    Par_CicloGrupo        INT(11),      -- Indica el ciclo del grupo

    Par_FormaPago     CHAR(1),      -- Indica la Forma de Pago

    Par_EmpresaID         INT(11),      -- ID de la empresa.
    Par_Salida            CHAR(1),      -- Salida S:SI   N:NO
  INOUT Par_PolizaID    BIGINT(20),     -- Numero de Poliza
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
  DECLARE Var_CreditoID BIGINT(12);       -- Indica el Número de Crédito
  DECLARE Var_RequiereGarFOGAFI CHAR(1);    -- Indica si se requiere garantía FOGAFI
  DECLARE Var_ModalidadFOGAFI   CHAR(1);    -- Indica la modalidad del cobro de la garantía FOGAFI
  DECLARE Var_DesbloqAutFOGAFI  CHAR(1);    -- Indica si la garantia FOGAFI puede ser desbloqueada para el pago de crédito.
  DECLARE Var_RequiereGarantia  CHAR(1);    -- Indica si se requiere el cobro de garantía Liquida(FOGA)

  DECLARE Var_DesbloqAut      CHAR(1);    -- Indica si la Garantia Líquida(FOGA) puede ser desbloqueada para el pago de crédito
    DEClARE Var_ClienteID       INT(11);    -- Indica el Número de Cliente
    DECLARE Var_FechaSis      DATE;       -- Indica la fecha del sistema
    DECLARE Var_CreditoStr      VARCHAR(50);  -- Indica número de crédito en String
    DECLARE Var_MonedaID      INT(11);    -- Indica el Tipo de Moneda

    DECLARE Var_SucCliente      INT(11);    -- Indica la Sucursal del Cliente

  # GARANTIAS
  DECLARE Var_ExigibleGrupo DECIMAL(14,2);    -- Monto exigible de créditos del grupo
  DECLARE Var_Diferencia    DECIMAL(14,2);    -- Indica la diferencia entre el monto total a pagar y el exigible grupal


  -- Declaracion de Constantes
  DECLARE Entero_Cero     INT(11);  -- Constante: Entero Cero
  DECLARE Decimal_Cero    INT(11);  -- Constante: Decimal Cero
  DECLARE Cons_SI     CHAR(1);  -- Constante: SI
  DECLARE Mod_Periodico CHAR(1);  -- Constante: Modalidad Periodico
  DECLARE Salida_SI   CHAR(1);  -- Constante: Salida SI

  DECLARE Salida_NO   CHAR(1);  -- Constante: Salida NO
    DECLARE Par_ActDetalleSi CHAR(1);   -- Constante: Indica si actualiza el detalle de FOGAFI
    DECLARE Forma_Efectivo  CHAR(1);  -- Indica Fomora de Pago en Efectivo
    DECLARE Nat_Abono     CHAR(1);  -- Indica Naturaleza de Movimiento Abono
    DECLARE Des_DepPagCre   VARCHAR(50); -- Descripción operativa de movimiento

    DECLARE Aho_DepEfeVen   CHAR(4);  -- Indica Tipo de Depósito en Efectivo
    DECLARE AltaPoliza_NO   CHAR(1);  -- Indica el Alta de Poliza
    DECLARE AltaMovAho_SI   CHAR(1);  -- Indica Alta de Movimiento de Ahorro
    DECLARE Con_AhoCapital  INT(11);  -- Concepto de Ahorro Capital

    DECLARE Var_Consecutivo INT(11);  -- Indica Consecutivo para el parametro en pantalla

  -- Asignacion de Constantes
  SET Entero_Cero       := 0;     -- Entero en Cero
  SET Decimal_Cero      := 0.00;    -- Decimal en Cero
  SET Cons_SI       := 'S';     -- Constante: SI
  SET Mod_Periodico   := 'P';     -- Constante Modalidad: Periodico
  SET Salida_SI     := 'S';     -- Constante: Salida SI

  SET Salida_NO     := 'N';     -- Constante: Salida NO
    SET Par_ActDetalleSi  := 'S';     -- Indica que SI actualiza la tabla de detalle para FOGAFI
    SET Forma_Efectivo    := 'E';     -- Indica forma de Pago en Efectivo
    SET Nat_Abono       := 'A';     -- Indida Naturaleza de Movimiento Abono

    SET Des_DepPagCre     := 'DEP.PAGO DE CREDITO'; -- Descripcion Operativa
    SET Aho_DepEfeVen     := '10';    -- Tipo de Deposito en Efectivo
    SET AltaPoliza_NO   := 'N';     -- Indica el Alta de Poliza
    SET AltaMovAho_SI     := 'S';     -- Indica el Alta de Movimiento de Ahorro

    SET Con_AhoCapital    := 1;         -- Concepto de Ahorro: Capital

  ManejoErrores:BEGIN

       DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOGRUPALFOGAFIPRO');
        END;

    SET Var_CreditoID := (SELECT CreditoID FROM CREDITOS WHERE CuentaID = Par_CuentaPago
              AND GrupoID = Par_GrupoID AND CicloGrupo = Par_CicloGrupo);

    # Se obtienen los datos de la configuracion del credito
    SELECT  RequiereGarFOGAFI,    ModalidadFOGAFI,        DesbloqAutFOGAFI,   RequiereGarantia,
        DesbloqAut
    INTO  Var_RequiereGarFOGAFI,  Var_ModalidadFOGAFI,      Var_DesbloqAutFOGAFI, Var_RequiereGarantia,
        Var_DesbloqAut
    FROM DETALLEGARLIQUIDA
    WHERE CreditoID = Var_CreditoID;

     # Se obtiene el monto exigible del grupo
    SET Var_ExigibleGrupo := (SELECT `FNEXIGIBLEGRUPOALDIA`(Par_GrupoID,  Par_CicloGrupo));
    SET Var_ExigibleGrupo := IFNULL(Var_ExigibleGrupo, Decimal_Cero);

    # Se obtiene la diferencia entre el monto a pagar y el exigible del grupo
    # Esto para saber si se realizará un bloqueo de garantía o tomar saldo de las cuentas para completar el pago.
    SET Var_Diferencia := Par_MontoPagar - Var_ExigibleGrupo;
    SET Var_Diferencia := IFNULL(Var_Diferencia, Decimal_Cero);

    -- ==========================================================================================================================
    -- ============================ BLOQUEO DE LA GARANTIA CUANDO SE PAGA DE MÁS) ============================
    -- ==========================================================================================================================
    # Primero se valida que el credito debe cubrir una garantia financiada
    # Se valida la modalidad del Pago de la Garantia Financiada
    # Si la diferencia es mayor a cero, indica que se está pagando más de lo exigible y que se va a bloquear de manera prorrateada
    IF(Var_RequiereGarFOGAFI = Cons_SI AND Var_ModalidadFOGAFI = Mod_Periodico AND Var_Diferencia > Decimal_Cero) THEN

            SELECT ClienteID, MonedaID
        INTO Var_ClienteID, Var_MonedaID
            FROM CUENTASAHO
            WHERE CuentaAhoID=Par_CuentaPago;

            SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

            SET Var_CreditoStr  := CONVERT(Var_CreditoID, CHAR(15));

            SELECT SucursalOrigen INTO Var_SucCliente
            FROM CLIENTES
            WHERE ClienteID = Var_ClienteID;

      -- Valida si el pago viene desde ventanilla para poder agregar un abono anterior para poder comenzar a realizar los bloqueos
      IF(Par_FormaPago=Forma_Efectivo)THEN
        CALL CONTAAHORROPRO (
          Par_CuentaPago,     Var_ClienteID,  Aud_NumTransaccion, Var_FechaSis,       Var_FechaSis,
          Nat_Abono,          Var_Diferencia, Des_DepPagCre,      Var_CreditoStr,     Aho_DepEfeVen,
          Var_MonedaID,       Var_SucCliente, AltaPoliza_NO,      Entero_Cero,        Par_PolizaID,
          AltaMovAho_SI,      Con_AhoCapital, Nat_Abono,          Par_NumErr,         Par_ErrMen,
          Var_Consecutivo,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
          Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

            END IF;
      # Llamada al SP que realizará el bloqueo grupal de manera prorrateada
      CALL BLOQGRUPALFOGAFIPRO(
        Par_GrupoID,    Var_Diferencia,   Par_CuentaPago,   Par_CicloGrupo,   Par_PolizaID,
        Par_ActDetalleSi, Par_EmpresaID,    Salida_NO,      Par_NumErr,     Par_ErrMen,
        Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

      # Se actualiza el valor del monto de pago.
      SET Par_MontoPagar := Par_MontoPagar - Var_Diferencia;

      IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;


    ELSEIF( (Var_RequiereGarFOGAFI = Cons_SI AND Var_DesbloqAutFOGAFI = Cons_SI AND Var_Diferencia < Decimal_Cero)
        OR (Var_RequiereGarantia = Cons_SI AND Var_DesbloqAut = Cons_SI AND Var_Diferencia < Decimal_Cero) )THEN

      -- Seccion para desbloqueos
      CALL DESBLOQGRUPFOGAFIPRO(
        Par_GrupoID,    Par_MontoPagar,   Var_ExigibleGrupo,  Par_CuentaPago,   Par_CicloGrupo,
        Par_PolizaID,       Par_EmpresaID,    Salida_No,      Par_NumErr,     Par_ErrMen,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

      IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;

    END IF;

  SET Par_NumErr    := '000';
  SET Par_ErrMen    := CONCAT('Pago realizado exitosamente');

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'creditoID' AS control,
        0 AS consecutivo;
  END IF;

END TerminaStore$$