-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIBERAGARFOGAFIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIBERAGARFOGAFIPRO`;DELIMITER $$

CREATE PROCEDURE `LIBERAGARFOGAFIPRO`(
    # ======================================================================================================
  # ----- SP QUE LIBERA LA GARANTIA FOGAFI SI EL PRODUCTO DE CREDITO LO INDICA
  # ======================================================================================================
  Par_CreditoID     BIGINT(12),   -- Numero de Credito
  Par_Poliza        BIGINT(20),   -- Numero de Poliza

  Par_Salida        CHAR(1),    -- Salida S:SI  N:NO
  INOUT Par_NumErr    INT(11),    -- Numero de Error
  INOUT Par_ErrMen    VARCHAR(400), -- Mensaje de Error

  -- Parametros de Auditoria
  Par_EmpresaID     INT(11),
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)

  )
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_Cliente       INT(11);    -- Numero de Cliente
DECLARE Var_BloqueoID     INT(11);    -- Numero de Blqueo
DECLARE Var_CuentaAhoID     BIGINT(12);   -- Numero de la Cuenta de Ahorro
DECLARE Var_FechaSistema      DATE;     -- Fecha del Sistema
DECLARE Var_EstatusCredito    CHAR(1);    -- Estatus del Credito
DECLARE Var_ProductoCredito   INT(11);    -- Numero de Producto de Credito
DECLARE Var_ReqGarFOGAFI    CHAR(1);    -- Indica si el Credito Requiere Garantia FOGAFI
DECLARE Var_LiberaAlLiquidar  CHAR(1);    -- Indica si se libera la Garantia FOGAFI al Liquidar el Credito
DECLARE Var_ClaveUsuario    CHAR(1);    -- Clave de Usuario
DECLARE Var_RequiereContaGarLiq CHAR(1);    -- Indica si se requiere realizar movimientos contables al liberar la garantia FOGAFI
DECLARE Var_MontoDesbloquear  DECIMAL(14,2);  -- Indica el monto a desbloquear
DECLARE Var_NumBloqueos     INT(11);    # Numero de bloqueos que tiene un crédito
DECLARE Var_Control       VARCHAR(100);
DECLARE Var_MonedaID      INT(11);

-- Declaracion de Constantes
DECLARE Entero_Cero     INT(11);
DECLARE BloqPorGarFOGAFI  INT(11);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE EstatusPagado   CHAR(1);
DECLARE ValorSI       CHAR(1);
DECLARE ValorNO       CHAR(1);
DECLARE NatDesbloqueo   CHAR(1);
DECLARE DescripcionDesblo VARCHAR(50);
DECLARE Con_DevGarFOGAFI    INT(11);        # CONCEPTOSCONTA: Devolucion de Garantía FOGAFI
DECLARE DevolucionGarLiq  CHAR(1);
DECLARE Contador      INT(11);


-- Asignacion de Constantes
SET Entero_Cero       := 0;     -- Constante de Entero Cero
SET BloqPorGarFOGAFI    := 20;      -- Constante del Tipo de Bloqueo por Garantia liquida
SET Cadena_Vacia      := '';      -- Constante de Cadena Vacia
SET EstatusPagado     := 'P';     -- Estatus de Credito que indica que esta pagado
SET ValorSI         := 'S';     -- Representa el valor Si
SET ValorNO         := 'N';     -- Representa el valor No
SET NatDesbloqueo     := 'D';     -- Natauraleza de Desbloqueo en saldo de cuenta por Garantia FOGAFI
SET DevolucionGarLiq    := 'V';     -- Operacion contable de Devolucion de Garantia liquida

SET DescripcionDesblo   := 'LIBERACION GAR. FOGAFI POR LIQUIDACION DE CREDITO';
SET Con_DevGarFOGAFI    := 47;


ManejoErrores:BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-LIBERAGARFOGAFIPRO');
    END;

  -- Inicializacion
  SET Aud_FechaActual   := NOW();

  -- Se obtiene la fecha del sistema y el valor si requiere Contabilidad para la Garantia Liquida
  SELECT FechaSistema,  ContabilidadGL
  INTO Var_FechaSistema, Var_RequiereContaGarLiq
  FROM PARAMETROSSIS;

  -- Se obtiene datos generales del credito
  SELECT  Estatus,      ProductoCreditoID,    ClienteID,    MonedaID
  INTO  Var_EstatusCredito, Var_ProductoCredito,  Var_Cliente,  Var_MonedaID
  FROM CREDITOS
  WHERE CreditoID = Par_CreditoID;

  -- Se obtienen datos de la parametrizacion del credito sobre la Garantia Liquida
  SELECT RequiereGarFOGAFI, LiberaGarLiq INTO Var_ReqGarFOGAFI, Var_LiberaAlLiquidar
    FROM DETALLEGARLIQUIDA
    WHERE CreditoID = Par_CreditoID;

  SET Var_EstatusCredito    := IFNULL(Var_EstatusCredito, Cadena_Vacia);
  SET Var_ProductoCredito   := IFNULL(Var_ProductoCredito, Entero_Cero);
    SET Var_Cliente       := IFNULL(Var_Cliente, Cadena_Vacia);
  SET Var_MonedaID      := IFNULL(Var_MonedaID, Entero_Cero);
  SET Var_ReqGarFOGAFI    := IFNULL(Var_ReqGarFOGAFI, ValorNO);
  SET Var_LiberaAlLiquidar  := IFNULL(Var_LiberaAlLiquidar, ValorNO);

  -- Se valida el estatus del credito
  IF(Var_EstatusCredito != EstatusPagado ) THEN
    SET Par_NumErr    := 1;
    SET Par_ErrMen    := CONCAT('El Credito ', CAST(Par_CreditoID AS CHAR), ' no se encuentra liquidado.');
    LEAVE ManejoErrores;
  END IF;

  -- Se valida si el credito requiere Garantia FOGAFI
  IF(Var_ReqGarFOGAFI != ValorSI) THEN
    SET Par_NumErr    := 2;
    SET Par_ErrMen    := CONCAT('El Credito ', CAST(Par_CreditoID AS CHAR), ' no requiere de garantia FOGAFI.');
    LEAVE ManejoErrores;
  END IF;

  -- Se valida si el credito libera Garantia FOGAFI
  IF(Var_LiberaAlLiquidar !=  ValorSI) THEN
    SET Par_NumErr    := 3;
    SET Par_ErrMen := CONCAT('El Credito ', CAST(Par_CreditoID AS CHAR), ' no libera garantia FOGAFI al liquidar.');
    LEAVE ManejoErrores;
  END IF;


  SET Var_ClaveUsuario = Cadena_Vacia;
    SET   @Contador := 0;
    # Se llena la tabla con los bloqueos correspondiente al credito para posteriormente desbloquearlos (Liberacion de Garantia FOGAFI)
  DELETE FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion;
  INSERT INTO TMPBLOQUEOSFOGAFI(
      TransaccionID,    Consecutivo,    BloqueoID,      MontoBloq,    ClienteID,
      CuentaAhoID)
  SELECT  Aud_NumTransaccion, @Contador:= @Contador+1 AS Consecutivo, BLOQ.BloqueoID, BLOQ.MontoBloq, CRED.ClienteID,
      BLOQ.CuentaAhoID
      FROM BLOQUEOS AS BLOQ
  INNER JOIN CREDITOS AS CRED ON BLOQ.Referencia = CRED.CreditoID
  WHERE BLOQ.NatMovimiento = 'B'
    AND BLOQ.TiposBloqID = 20
    AND BLOQ.Referencia = Par_CreditoID
    AND BLOQ.FolioBloq = Entero_Cero
  ORDER BY BLOQ.FechaMov;

  # Se obtiene el numero de bloqueos por Garantia FOGAFI que tiene un crédito.
  SET Var_NumBloqueos := (SELECT MAX(Consecutivo) FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion);
  SET Var_NumBloqueos := IFNULL(Var_NumBloqueos, Entero_Cero);

  SET Contador := 1;

   -- Ciclo para recorrer los bloqueos de Garantia FOGAFI
    WHILE(Contador <= Var_NumBloqueos) DO

    -- Se obtiene el Numero de Bloqueo, Cuenta de Ahorro y Monto a Desbloquear
    SELECT BloqueoID, CuentaAhoID,    MontoBloq INTO
      Var_BloqueoID, Var_CuentaAhoID, Var_MontoDesbloquear
        FROM TMPBLOQUEOSFOGAFI
        WHERE Consecutivo = Contador
        AND TransaccionID = Aud_NumTransaccion;

    --  Se Genera el Desbloqueo operativo
    CALL BLOQUEOSPRO(
        Var_BloqueoID,    NatDesbloqueo,    Var_CuentaAhoID,  Var_FechaSistema, Var_MontoDesbloquear,
        Var_FechaSistema, BloqPorGarFOGAFI, DescripcionDesblo,  Par_CreditoID,    Var_ClaveUsuario,
        Cadena_Vacia,   ValorNO,      Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr <> Entero_Cero) THEN
      LEAVE ManejoErrores;
    END IF;

    IF(Var_RequiereContaGarLiq = ValorSI) THEN

        --  Se Genera el Desbloqueo Contable
        CALL CONTAGARLIQPRO(
        Par_Poliza,       Var_FechaSistema, Var_Cliente,    Var_CuentaAhoID,  Var_MonedaID,
        Var_MontoDesbloquear,   ValorNO,      Con_DevGarFOGAFI, DevolucionGarLiq, BloqPorGarFOGAFI,
        DescripcionDesblo,    ValorNO,      Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
        Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

      IF(Par_NumErr <> Entero_Cero) THEN
        LEAVE ManejoErrores;
      END IF;
    END IF;

        SET Contador := Contador + 1; -- Incrementa el contador
    END WHILE;

  IF (Par_NumErr <> Entero_Cero) THEN
    LEAVE ManejoErrores;
  END IF;

  SET Par_NumErr    := Entero_Cero;
  SET Par_ErrMen    := CONCAT('Garantia(s) Liquida(s) del Credito No.', CAST(Par_CreditoID AS CHAR), ' se liberaron con exito.');
  SET Var_Control   := 'creditoID';

  DELETE FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion;

END ManejoErrores;  -- End Manejo de Errores


 IF (Par_Salida = ValorSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'CreditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$