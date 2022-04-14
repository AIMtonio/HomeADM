-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIALIQUIDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTIALIQUIDAPRO`;DELIMITER $$

CREATE PROCEDURE `GARANTIALIQUIDAPRO`(
-- =======================================================================
-- SP PARA EL COBRO COBRO DE GARANTÍA FOGAFI
-- =======================================================================
  Par_PolizaID      BIGINT(20),     # Numero de Poliza
  Par_CreditoID     BIGINT(20),     # Indica el numero de credito
    Par_MonedaID      INT(11),      # MonedaID
  INOUT   Par_Monto   DECIMAL(14,2),    # Monto a Pagar
  Par_EsPrePago     CHAR(1),      # Indica si se esta realizando un prepago

  Par_Salida        CHAR(1),      # Indica la Salida
  INOUT Par_NumErr    INT(11),
  INOUT Par_ErrMen    VARCHAR(400),

  -- Parametros de Auditoria
  Par_EmpresaID     INT(11),
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)
)
TerminaStore:Begin

  # Declaracion de variables
  DECLARE Var_GrupoID       INT(11);    # Almacena el numero de grupo
  DECLARE Var_RequiereGarFOGAFI CHAR(1);    # Indica si se requiere garantía FOGAFI
  DECLARE Var_ModalidadFOGAFI   CHAR(1);    # Indica la modalidad del cobro de la garantía FOGAFI
  DECLARE Var_DesbloqAutFOGAFI  CHAR(1);    # Indica si la garantia FOGAFI puede ser desbloqueada para el pago de crédito.
  DECLARE Var_SaldoFOGAFI     DECIMAL(14,2);  # Saldo Actual de la Garantia FOGAFI
  DECLARE Var_RequiereGarantia  CHAR(1);    # Indica si se requiere el cobro de garantía Liquida(FOGA)
  DECLARE Var_DesbloqAut      CHAR(1);    # Indica si la Garantia Líquida(FOGA) puede ser desbloqueada para el pago de crédito
  DECLARE Var_SaldoGarLiquida   DECIMAL(14,2);  # Saldo Actual de la Garantía Líquida(FOGA)
  DECLARE Var_MontoExigible   DECIMAL(14,2);  # Monto exigible del credito
  DECLARE Var_Diferencia      DECIMAL(14,2);  # Diferencia entre lo exigible y el monto a pagar
  DECLARE Var_MontoPendiente    DECIMAL(14,2);  # Monto pendiente de pago entre lo exigible y el monto a pagar
  DECLARE Var_MontoBloqueo    DECIMAL(14,2);  # Monto bloquear
  DECLARE Var_NuevoBloqueo    DECIMAL(14,2);  # Monto a desbloquear
  DECLARE Var_Control       VARCHAR(100); # Variable de Control
  DECLARE Var_NumAmortizacion   INT(11);    # Numero de Amortizaciones Exigibles
  DECLARE Var_MontoPago     DECIMAL(14,2);  # Monto de Pago de Garantia

  # DATOS CREDITO
  DECLARE Var_CuentaAhoID     BIGINT(12);   # Cuenta de Ahorro ligada al Crédito
  DECLARE Var_FechaMov      DATE;
    DECLARE Var_ClienteID     INT(11);    # Numero de Cliente

  DECLARE Var_NumBloqueos     INT(11);    # Numero de bloqueos que tiene un crédito
  DECLARE Var_Contador      INT(11);    # Contador auxiliar para evaluar los bloqueos de la tabla
  DECLARE Var_TotalDesbloq    DECIMAL(14,2);  # Variable que lleva el total de garantia FOGAFI desbloqueado
  DECLARE Var_BloqueoID     INT(11);    # Numero de bloqueo
  DECLARE Var_MontoBloq     DECIMAL(14,2);  # Variable que almacena el monto de bloqueo
  DECLARE Var_ReqContaGarLiq    CHAR(1);    # Indica si se requiere el registro contable de Garantía Líquida

  # Declaracion de Constantes
  DECLARE Entero_Cero       INT(11);    # Constante: Entero Cero
  DECLARE Decimal_Cero      DECIMAL(14,2);  # Constante: Decimal_Cero
  DECLARE Fecha_Vacia       DATE;     # Constante: Fecha Vacia
  DECLARE Cadena_Vacia      CHAR(1);    # Constante: Cadena Vacia
  DECLARE Mod_Periodico     CHAR(1);    # Constante Modalidad: Periodico
  DECLARE Cons_SI         CHAR(1);    # Constante: SI
    DECLARE Cons_NO         CHAR(1);    # Constante: NO
  DECLARE Salida_NO       CHAR(1);    # Constante: Salida NO
  DECLARE Salida_SI       CHAR(1);    # Constante: Salida SI
  DECLARE Desbloqueo        CHAR(1);    # Constante: Desbloqueo
  DECLARE Bloqueo         CHAR(1);    # Constante: Bloqueo
  DECLARE TipoBloqGarFOGAFI   INT(11);    # TIPOSBLOQUEOS: Bloqueo de Garantia FOGAFI(Garantia Financiada)
  DECLARE TipoBloqGarFOGA     INT(11);    # TIPOSBLOQUEOS: Bloqueo de Garantia Liquida(Garantia FOGA)
  DECLARE ProgramaAud       VARCHAR(50);  # Nombre del programa de Auditoria
    DECLARE Desb_GarFOGAFI      CHAR(1);    # Indica que la operación será un desbloqueo de garantía FOGAFI

    DECLARE Con_BloqGarLiq          INT(11);        # CONCEPTOSCONTA: Bloqueo de Garantía Líquida (FOGA)
    DECLARE Con_DesGarLiq           INT(11);        # CONCEPTOSCONTA: Desbloqueo de Garantía Líquida (FOGA)
    DECLARE Con_BloqGarFOGAFI   INT(11);    # CONCEPTOSCONTA: Bloqueo de Garantia FOGAFI
    DECLARE Con_DesGarFogafi    INT(11);    # CONCEPTOSCONTA: Desbloqueo de Garantia FOGAFI

  DECLARE Desc_BloqueoGarLiq    VARCHAR(50);  # Descripción del bloqueo de Garantía Líquida
    DECLARE Desc_DesbGarLiq     VARCHAR(50);  # Descripción del desbloqueo de la Garantía L{iquida FOGA
  DECLARE Desc_BloqFOGAFI     VARCHAR(50);  # Descripción del bloqueo de la Garantía FOGAFI
    DECLARE Desc_DesbFOGAFI     VARCHAR(50);  # Descripción del desbloqueo de la Garantía FOGAFI

  # Asignacion de Constantes
  SET Entero_Cero         := 0;     # Constante: Entero Cero
  SET Decimal_Cero        := 0.00;    # Constante: Decimal_Cero
  SET Fecha_Vacia         := '1900-01-01';# Constante: Fecha Vacia
  SET Cadena_Vacia        := '';      # Constante: Cadena Vacia
  SET Mod_Periodico       := 'P';     # Constante Modalidad: Periodico
  SET Cons_SI           := 'S';     # Constante: SI
    SET Cons_NO           := 'N';     # Constante: NO
  SET Desbloqueo          := 'D';     # Constante: Desbloqueo
  SET Bloqueo           := 'B';     # Constante: Bloqueo
  SET TipoBloqGarFOGAFI     := 20;      # TIPOSBLOQUEOS: Bloqueo de Garantia FOGAFI(Garantia Financiada)
  SET TipoBloqGarFOGA       := 8;     # TIPOSBLOQUEOS: Bloqueo de Garantia Liquida(Garantia FOGA)
  SET Salida_NO         := 'N';     # Constante: Salida NO
  SET Salida_SI         := 'S';     # Constante: Salida SI
  SET ProgramaAud         := 'GARANTIALIQUIDAPRO';  # Nombre del programa de Auditoria
    SET Desb_GarFOGAFI        := 'V';     # Indica que la operación será un desbloqueo de Garantía FOGAFI

    -- CONCEPTOS CONTABLES
  SET Con_BloqGarLiq        := 64;      # CONCEPTOSCONTA: Concepto Contable Bloqueo de Garantía FOGA
    SET Con_DesGarLiq               := 62;          # CONCEPTOSCONTA: Concepto Contable Desbloqueo de Garantia Líquida (FOGA)
    SET Con_BloqGarFOGAFI           := 48;          # CONCEPTOSCONTA: Concepto Contable Bloqueo de Garantía FOGAFI
    SET Con_DesGarFogafi      := 49;      # CONCEPTOSCONTA: Concepto Contable Desbloqueo de Garantía FOGAFI

  SET Desc_BloqueoGarLiq      := 'BLOQUEO POR GARANTIA LIQUIDA';        # Descripción del Bloqueo de Garantía Liquida(FOGA)
    SET Desc_DesbGarLiq             := 'DESBLOQUEO POR GARANTIA LIQUIDA';           # Desbloqueo por concepto de Garantía Líquida(FOGA)
    SET Desc_BloqFOGAFI       := 'BLOQUEO POR GARANTIA LIQUIDA FINANCIADA';
    SET Desc_DesbFOGAFI       := 'DESBLOQUEO POR GARANTIA LIQUIDA FINANCIADA';


 ManejoErrores: BEGIN

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
       SET Par_NumErr = 999;
       SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-GARANTIALIQUIDAPRO');
       SET Var_Control = 'SQLEXCEPTION';
      END;


  SET @Contador := Entero_Cero;

  DELETE FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion;

  INSERT INTO TMPBLOQUEOSFOGAFI(
          TransaccionID,    Consecutivo,    BloqueoID,      MontoBloq,    ClienteID,
                    CuentaAhoID)
  SELECT  Aud_NumTransaccion, @Contador:= @Contador+1 AS Consecutivo, BLOQ.BloqueoID, BLOQ.MontoBloq, CRED.ClienteID,
      CRED.CuentaID
      FROM BLOQUEOS AS BLOQ
  INNER JOIN CREDITOS AS CRED ON BLOQ.Referencia = CRED.CreditoID
  WHERE BLOQ.NatMovimiento = Bloqueo
    AND BLOQ.TiposBloqID = 20
    AND CRED.Estatus IN('V','B')
    AND BLOQ.Referencia = Par_CreditoID
    AND BLOQ.FolioBloq = Entero_Cero
  ORDER BY BLOQ.FechaMov;



  SELECT FechaSistema,  ContabilidadGL INTO Var_FechaMov, Var_ReqContaGarLiq FROM PARAMETROSSIS LIMIT 1;

  # Se obtiene si el credito es individual o grupal
  SELECT GrupoID, CuentaID, ClienteID INTO Var_GrupoID, Var_CuentaAhoID,  Var_ClienteID
  FROM CREDITOS
  WHERE CreditoID = Par_CreditoID;

  # Se obtienen los datos de la configuracion del credito
  SELECT  RequiereGarFOGAFI,    ModalidadFOGAFI,        DesbloqAutFOGAFI,   (MontoGarFOGAFI - MontoBloqueadoFOGAFI),    RequiereGarantia,
      DesbloqAut,       MontoGarLiq - MontoBloqueadoGar
  INTO  Var_RequiereGarFOGAFI,  Var_ModalidadFOGAFI,      Var_DesbloqAutFOGAFI, Var_SaldoFOGAFI,                Var_RequiereGarantia,
      Var_DesbloqAut,     Var_SaldoGarLiquida
  FROM DETALLEGARLIQUIDA
  WHERE CreditoID = Par_CreditoID;

  SET Var_SaldoFOGAFI   := IFNULL(Var_SaldoFOGAFI, Decimal_Cero);
  SET Var_SaldoGarLiquida := IFNULL(Var_SaldoGarLiquida, Decimal_Cero);

  # INICIALIZACIÓN DE VARIABLES
  SET Var_NuevoBloqueo  := Decimal_Cero;
  SET Var_MontoBloqueo  := Decimal_Cero;

  # Se obtiene el monto exigible del credito
  SET Var_MontoExigible := FUNCIONEXIGIBLE(Par_CreditoID);
  SET Var_MontoExigible := IFNULL(Var_MontoExigible, Decimal_Cero);

  # Se obtiene la diferencia entre lo exigible del credito y lo que se esta recibiendo del pago
  SET Var_Diferencia := Par_Monto - Var_MontoExigible;
-- ==========================================================================================================================
-- ============================ BLOQUEO DE LA GARANTIA CUANDO SE PAGA DE MÁS) ============================
-- ==========================================================================================================================
  # Primero se valida que el credito debe cubrir una garantia financiada
  # Se valida la modalidad del Pago de la Garantia Financiada
  IF(Var_RequiereGarFOGAFI = Cons_SI AND Var_ModalidadFOGAFI = Mod_Periodico AND Var_Diferencia > Decimal_Cero) THEN

    SET Var_MontoBloqueo := (SELECT SUM(SaldoFOGAFI) FROM DETALLEGARFOGAFI WHERE CreditoID = Par_CreditoID AND FechaPago <= Var_FechaMov AND Estatus = 'V');
    SET Var_MontoBloqueo := IFNULL(Var_MontoBloqueo, Decimal_Cero);

        IF(Var_MontoBloqueo>=Var_Diferencia)THEN
      SET Var_MontoBloqueo := Var_Diferencia;
        END IF;

      # BLOQUEO
      # Si el monto a pagar es mayor al exigible, se realiza un bloqueo con el concepto "Deposito de Garantia Liquida Financiada"
    CALL BLOQUEOSPRO(
        Entero_Cero,    Bloqueo,      Var_CuentaAhoID,  Var_FechaMov, Var_MontoBloqueo,
        Var_FechaMov,   TipoBloqGarFOGAFI,  Desc_BloqFOGAFI,  Par_CreditoID,  Cadena_Vacia,
        Cadena_Vacia,   Salida_NO,      Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  ProgramaAud,  Aud_Sucursal,
        Aud_NumTransaccion);

      IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
      END IF;

            # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida Financiada
            IF(Var_ReqContaGarLiq = Cons_SI) THEN

            --  Se Genera el Bloqueo Contable de la Garantía FOGAFI
                  CALL CONTAGARLIQPRO(
          Par_PolizaID,     Var_FechaMov,   Var_ClienteID,        Var_CuentaAhoID,  Par_MonedaID,
          Var_MontoBloqueo,     Cons_NO,      Con_BloqGarFOGAFI,      Bloqueo,      TipoBloqGarFOGAFI,
          Desc_BloqFOGAFI,    Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
          Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      ProgramaAud,    Aud_Sucursal,
          Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

      END IF;

      WHILE(Var_MontoBloqueo > Decimal_Cero) DO
        # Se obtiene el numero de amortizacion que debe garantía FOGAFI
        SET Var_NumAmortizacion := (SELECT MIN(AmortizacionID) FROM DETALLEGARFOGAFI WHERE CreditoID = Par_CreditoID AND FechaLiquida = Fecha_Vacia);

         # Se obtiene el adeudo de Garantía FOGAFI por amortización
         SET Var_MontoPago := (SELECT SaldoFOGAFI FROM DETALLEGARFOGAFI WHERE CreditoID = Par_CreditoID AND AmortizacionID = Var_NumAmortizacion);
         SET Var_MontoPago := IFNULL(Var_MontoPago, Decimal_Cero);

         # Validar el monto total bloqueado contra el adeudo de garantia FOGAFI
         IF(Var_MontoBloqueo > Var_MontoPago) THEN -- Si el monto de bloqueo es mayor al adeudo, el monto de pago es el total del adeudo
          SET Var_MontoPago := Var_MontoPago;
         ELSE
          SET Var_MontoPago := Var_MontoBloqueo;-- Si el monto de bloqueo es menor al adeudo, el monto de pago es el monto de bloqueo
        END IF;

         # Se actualiza el valor de la tabla DETALLEGARFOGAFI por cada cuota afectada.
         UPDATE DETALLEGARFOGAFI  SET
         SaldoFOGAFI  = SaldoFOGAFI - Var_MontoPago,
         FechaLiquida = CASE WHEN SaldoFOGAFI = Decimal_Cero THEN Var_FechaMov ELSE Fecha_Vacia END,
         Estatus    = CASE WHEN SaldoFOGAFI = Decimal_Cero THEN 'P' ELSE 'V' END
         WHERE CreditoID = Par_CreditoID
         AND AmortizacionID = Var_NumAmortizacion;

         # El monto de desbloqueo disminuye para poder continuar con la siguiente amortización-
         SET Var_MontoBloqueo := Var_MontoBloqueo - Var_MontoPago;

         # Al monto total a pagar, se le resta el monto que se está pagando de más y corresponde a GARANTÍA FOGAFI
         SET Par_Monto := Par_Monto - Var_MontoPago;

       END WHILE;
    END IF; -- End ID   Termina IF(Var_RequiereGarFOGAFI = Cons_SI)

-- ==========================================================================================================================
-- ============================ FIN DEL BLOQUEO DE LA GARANTIA CUANDO SE PAGA DE MÁS) ============================
-- ==========================================================================================================================


-- ==========================================================================================================================
-- ============================ DESBLOQUEO DE LA GARANTIA CUANDO EL PAGO ES MENOR A LO DISPONIBLE) ============================
-- ==========================================================================================================================

    # Si el monto a pagar es menor al exigible del crédito, se podrá hacer uso de la garantia Financiada (Siempre y cuando se permita hacer uso de ella)
    IF(Var_Diferencia < Decimal_Cero) THEN

      # Se obtiene el numero de bloqueos por Garantia FOGAFI que tiene un crédito.
      SET Var_NumBloqueos := (SELECT MAX(Consecutivo) FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion);
      SET Var_NumBloqueos := IFNULL(Var_NumBloqueos, Entero_Cero);
      SET Var_TotalDesbloq  := Decimal_Cero;

      SET Var_Contador := 1;  -- Se inicializa el contador

      SET Var_MontoPendiente := ABS(Var_Diferencia); # DIFERENCIA DEL PAGO

      #=============================== DESBLOQUEO FOGAFI #===============================
      #==================================================================================
      # Se valida si el producto de crédito permite hacer uso de la garantia FOGAFI para el pago de crédito.
      # Se valida si el saldo que tiene la garantia FOGAFI es mayor cero.
      IF(Var_DesbloqAutFOGAFI = Cons_SI AND Var_NumBloqueos > Entero_Cero) THEN

        WHILE(Var_Contador <= Var_NumBloqueos AND Var_TotalDesbloq<=Var_MontoPendiente) DO
          SET Var_BloqueoID := Entero_Cero;
          SET Var_MontoBloq := Entero_Cero;


          SELECT TMP.BloqueoID, TMP.MontoBloq
          INTO Var_BloqueoID, Var_MontoBloq
          FROM TMPBLOQUEOSFOGAFI AS TMP
          WHERE TMP.Consecutivo = Var_Contador
            AND TMP.TransaccionID = Aud_NumTransaccion;

          # DESBLOQUEO
          # Se realiza el desbloqueo de la Garantía Financiada(FOGAFI)
          CALL BLOQUEOSPRO(
            Var_BloqueoID,    Desbloqueo,     Var_CuentaAhoID,  Var_FechaMov, Var_MontoBloq,
            Var_FechaMov,   TipoBloqGarFOGAFI,  Desc_DesbFOGAFI,  Par_CreditoID,  Cadena_Vacia,
            Cadena_Vacia,   Salida_NO,      Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  ProgramaAud,  Aud_Sucursal,
            Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

                     # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia FOGAFI
          IF(Var_ReqContaGarLiq = Cons_SI) THEN

            --  Se Genera el Desbloqueo Contable
            CALL CONTAGARLIQPRO(
              Par_PolizaID,     Var_FechaMov,   Var_ClienteID,        Var_CuentaAhoID,  Par_MonedaID,
              Var_MontoBloq,      Cons_NO,      Con_DesGarFogafi,     Desbloqueo,       TipoBloqGarFOGAFI,
              Desc_DesbFOGAFI,    Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
              Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      ProgramaAud,    Aud_Sucursal,
              Aud_NumTransaccion);

              IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
              END IF;

          END IF;


          SET Var_TotalDesbloq := Var_TotalDesbloq + Var_MontoBloq;
          SET Var_Contador := Var_Contador + 1; -- Incrementa el contador
        END WHILE ;-- Fin de WHILE


        # Si el total desbloqueado es mayor al monto pendiente de pago, se realiza un bloqueo por la diferencia.
        IF(Var_TotalDesbloq > Var_MontoPendiente) THEN
          # Si se desbloquea más del monto pendiente, significa que la diferencia se le tiene que sumar al MontoPagar para que se cubra todo el exigible.
          SET Par_Monto := Par_Monto + Var_MontoPendiente;

          SET Var_NuevoBloqueo := Var_TotalDesbloq - Var_MontoPendiente;
          SET Var_NuevoBloqueo := IFNULL(Var_NuevoBloqueo, Decimal_Cero);

                    # BLOQUEO FOGAFI
           # Si se libera más de lo requerido, el sobrante de vuelve a bloquear.
          CALL BLOQUEOSPRO(
            Entero_Cero,    Bloqueo,      Var_CuentaAhoID,  Var_FechaMov, Var_NuevoBloqueo,
            Var_FechaMov,   TipoBloqGarFOGAFI,  Desc_BloqFOGAFI,  Par_CreditoID,  Cadena_Vacia,
            Cadena_Vacia,   Salida_NO,      Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  ProgramaAud,  Aud_Sucursal,
            Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

                    # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia FOGAFI
                    IF(Var_ReqContaGarLiq = Cons_SI) THEN

                        --  Se Genera el BLOQUEO Contable
                        CALL CONTAGARLIQPRO(
                            Par_PolizaID,     Var_FechaMov,   Var_ClienteID,        Var_CuentaAhoID,  Par_MonedaID,
                            Var_NuevoBloqueo,     Cons_NO,      Con_BloqGarFOGAFI,      Bloqueo,      TipoBloqGarFOGAFI,
                            Desc_BloqFOGAFI,    Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                            Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      ProgramaAud,    Aud_Sucursal,
                            Aud_NumTransaccion);

                            IF(Par_NumErr != Entero_Cero)THEN
                                LEAVE ManejoErrores;
                            END IF;

                    END IF;

          # Una vez realizado el desbloqueo, actualizar el valor pendiente de pago
          SET Var_MontoPendiente := Decimal_Cero;
        ELSE
          # Si el monto desbloqueado es menor al monto pendiente, significa que no se alcanza a cubrir la diferencia, entonces todo lo que se alcanza a desbloquear, se le suma al monto a pagar.
          SET Par_Monto := Par_Monto + Var_TotalDesbloq;
          # Una vez realizado el desbloqueo, actualizar el valor pendiente de pago
          SET Var_MontoPendiente := Var_MontoPendiente - Var_TotalDesbloq;
         END IF;
      END IF;-- END IF Termina IF(Var_DesbloqAutFOGAFI = Cons_SI AND Var_SaldoFOGAFI >= Decimal_Cero)


      #=============================== DESBLOQUEO FOGA #=================================
      #==================================================================================
      SET @Contador := Entero_Cero;
      # Se eliminan los registros si tuviera bloqueos de garantía FOGAFI
      DELETE FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion;

      # Se insertan los bloqueos del crédito que se hayan realizado por Garantia Líquida (FOGA)
      INSERT INTO TMPBLOQUEOSFOGAFI(
          TransaccionID,    Consecutivo,    BloqueoID,      MontoBloq,    ClienteID,
                    CuentaAhoID)
      SELECT  Aud_NumTransaccion, @Contador:= @Contador+1 AS Consecutivo, BLOQ.BloqueoID, BLOQ.MontoBloq, CRED.ClienteID,
          CRED.CuentaID
      FROM  BLOQUEOS AS BLOQ
      INNER JOIN CREDITOS AS CRED ON BLOQ.Referencia = CRED.CreditoID
      WHERE BLOQ.NatMovimiento = Bloqueo
      AND BLOQ.TiposBloqID = 8
      AND CRED.Estatus IN('V','B')
      AND BLOQ.Referencia = Par_CreditoID
      AND BLOQ.FolioBloq = Entero_Cero
      ORDER BY BLOQ.FechaMov;

      SET Var_NumBloqueos := Entero_Cero;
      SET Var_TotalDesbloq  := Decimal_Cero;
      # Se obtiene el numero de bloqueos por Garantia FOGAFI que tiene un crédito.
      SET Var_NumBloqueos   := (SELECT MAX(Consecutivo) FROM TMPBLOQUEOSFOGAFI WHERE TransaccionID = Aud_NumTransaccion);
      SET Var_NumBloqueos   := IFNULL(Var_NumBloqueos, Entero_Cero);
      SET Var_TotalDesbloq  := IFNULL(Var_TotalDesbloq, Decimal_Cero);

      SET Var_Contador := 1;  -- Se inicializa el contador
      # Si el crédito aún tiene un valor pendiente de pago y sus características lo permiten, utilizar la garantía liquida, .
      IF(Var_RequiereGarantia = Cons_SI AND Var_DesbloqAut = Cons_SI AND Var_NumBloqueos > Entero_Cero AND Var_MontoPendiente > Decimal_Cero) THEN


         WHILE(Var_Contador <= Var_NumBloqueos AND Var_TotalDesbloq <= Var_MontoPendiente) DO
         SET Var_BloqueoID  := Entero_Cero;
         SET Var_MontoBloq  := Entero_Cero;


         SELECT
         TMP.BloqueoID,     TMP.MontoBloq
         INTO
         Var_BloqueoID,     Var_MontoBloq
         FROM
         TMPBLOQUEOSFOGAFI AS TMP
         WHERE TMP.Consecutivo = Var_Contador
         AND TMP.TransaccionID = Aud_NumTransaccion;

        # DESBLOQUEO
        # Se realiza el desbloqueo de la Garantía Líquida(FOGA)
        CALL BLOQUEOSPRO(
          Var_BloqueoID,    Desbloqueo,     Var_CuentaAhoID,  Var_FechaMov, Var_MontoBloq,
          Var_FechaMov,   TipoBloqGarFOGA,  Desc_DesbGarLiq,  Par_CreditoID,  Cadena_Vacia,
          Cadena_Vacia,   Salida_NO,      Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
          Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  ProgramaAud,  Aud_Sucursal,
          Aud_NumTransaccion);


        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

                 # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida
                IF(Var_ReqContaGarLiq = Cons_SI) THEN

                    --  Se Genera el Desbloqueo Contable FOGA
                    CALL CONTAGARLIQPRO(
                        Par_PolizaID,     Var_FechaMov,   Var_ClienteID,        Var_CuentaAhoID,  Par_MonedaID,
                        Var_MontoBloq,        Cons_NO,      Con_DesGarLiq,          Desbloqueo,     TipoBloqGarFOGA,
                        Desc_DesbGarLiq,    Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                        Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      ProgramaAud,    Aud_Sucursal,
                        Aud_NumTransaccion);

                        IF(Par_NumErr != Entero_Cero)THEN
                            LEAVE ManejoErrores;
                        END IF;

                END IF;


        SET Var_TotalDesbloq := Var_TotalDesbloq + Var_MontoBloq;
        SET Var_Contador := Var_Contador + 1; -- Incrementa el contador
      END WHILE ;-- Fin de WHILE

      # Si el total desbloqueado es mayor al monto pendiente de pago, se realiza un bloqueo por la diferencia.
      IF(Var_TotalDesbloq > Var_MontoPendiente) THEN
        # Si se desbloquea más del monto pendiente, significa que la diferencia se le tiene que sumar al MontoPagar para que se cubra todo el exigible.
        SET Par_Monto := Par_Monto + Var_MontoPendiente;

        SET Var_NuevoBloqueo := Var_TotalDesbloq - Var_MontoPendiente;
        SET Var_NuevoBloqueo := IFNULL(Var_NuevoBloqueo, Decimal_Cero);

        # Si se libera más de lo requerido, el sobrante de vuelve a bloquear.
        CALL BLOQUEOSPRO(
          Entero_Cero,    Bloqueo,      Var_CuentaAhoID,  Var_FechaMov, Var_NuevoBloqueo,
          Var_FechaMov,   TipoBloqGarFOGA,  Desc_BloqueoGarLiq, Par_CreditoID,  Cadena_Vacia,
          Cadena_Vacia,   Salida_NO,      Par_NumErr,     Par_ErrMen,   Par_EmpresaID,
          Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  ProgramaAud,  Aud_Sucursal,
          Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
        LEAVE ManejoErrores;
        END IF;

                 # Si realizan los movimientos contables si se requiere generar la contabilidad por los movimientos de Garantia Líquida
                IF(Var_ReqContaGarLiq = Cons_SI) THEN

                    --  Se Genera el Bloqueo Contable
                    CALL CONTAGARLIQPRO(
                        Par_PolizaID,     Var_FechaMov,   Var_ClienteID,        Var_CuentaAhoID,  Par_MonedaID,
                        Var_NuevoBloqueo,     Cons_NO,      Con_BloqGarLiq,       Bloqueo,      TipoBloqGarFOGA,
                        Desc_BloqueoGarLiq,   Salida_NO,      Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                        Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,      ProgramaAud,    Aud_Sucursal,
                        Aud_NumTransaccion);

                        IF(Par_NumErr != Entero_Cero)THEN
                            LEAVE ManejoErrores;
                        END IF;

                END IF;

        # Una vez realizado el desbloqueo, actualizar el valor pendiente de pago
        SET Var_MontoPendiente := Decimal_Cero;
      ELSE
        # Si el monto desbloqueado es menor al monto pendiente, significa que no se alcanza a cubrir la diferencia, entonces todo lo que se alcanza a desbloquear, se le suma al monto a pagar.
        SET Par_Monto := Par_Monto + Var_TotalDesbloq;

        # Una vez realizado el desbloqueo, actualizar el valor pendiente de pago
        SET Var_MontoPendiente := Var_MontoPendiente - Var_TotalDesbloq;
      END IF;

    END IF;

  END IF; -- End IF Termina IF(Var_Diferencia < Decimal_Cero)

  SET Par_NumErr  := Entero_Cero;
  SET Par_ErrMen  := 'Proceso aplicado exitosamente.';

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT Par_NumErr AS NumErr,
    Par_ErrMen AS ErrMen,
    'creditoID' AS control,
    Par_CreditoID AS consecutivo;
  END IF;

END TerminaStore$$