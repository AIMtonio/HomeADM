-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETGARANTIALIQUIDAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETGARANTIALIQUIDAALT`;DELIMITER $$

CREATE PROCEDURE `DETGARANTIALIQUIDAALT`(
-- ===================================================================
-- SP PARA DAR DE ALTA LOS CREDITOS CON GARANTIA LIQUIDA O FINANCEADA
-- ===================================================================
  Par_CreditoID     BIGINT(12),   # Indica el Número de Crédito
    Par_SolicitudCreditoID  BIGINT(20),   # Indica el Número de Solicitud de Crédito
    Par_ProductoCreditoID INT(11),    # Indica el Número de Producto de Crédito
    Par_ClienteID     INT(11),    # Indica el Número de Cliente

  Par_Salida        CHAR(1),
  INOUT Par_NumErr    INT(11),
  INOUT Par_ErrMen    VARCHAR(400),

    # Parametros de Auditoria
  Aud_EmpresaID     INT(11) ,
  Aud_Usuario       INT(11),
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT(11),
  Aud_NumTransaccion    BIGINT(20)
  )
TerminaStore: BEGIN


  DECLARE Var_Control     VARCHAR(20);    # Indica el Elemento de Control en Pantalla
  DECLARE Var_Consecutivo   VARCHAR(50);    # Indica Consecutivo para Numerar registros
    DECLARE Var_MontoCredito  DECIMAL(14,2);    # Indica el Monto del Crédito
    DECLARE Contador      INT(11);      # Contador Utilizado para los ciclos
    DECLARE Var_CicloCliente  INT(11);      # Indica el Ciclo del Cliente
    DECLARE Var_CalificaCredito CHAR(1);      # Indica la Clasificación del Cliente
    DECLARE Var_RequiereGarLiq    CHAR(1);    # Indica Si Requiere Garantia Líquida
    DECLARE Var_RequiereGarFOGAFI CHAR(1);    # Indica Si Requiere FOGAFI
    DECLARE Var_ModalidadFOGAFI   CHAR(1);    # Indica la Modadlidad de FOGAFI
    DECLARE Var_NumRegistros  INT(11);      # Indica Número de Registro Consultados


  DECLARE Cadena_Vacia    CHAR(1);    # Constante: Cadena Vacía
  DECLARE Salida_SI       CHAR(1);    # Constante: Salida No
    DECLARE Salida_NO     CHAR(1);    # Constante: Salida Si
    DECLARE Entero_Cero     INT(11);    # Constante: Entero Cero
    DECLARE Decimal_Cero    DECIMAL(12,2);  # Constante: Decimal Cero
    DECLARE Fecha_Vacia     DATE;     # Constante: Fecha Vacía
  DECLARE NumAmortizacion   INT(11);    # Indica Número de Amortización
    DECLARE CobroFinanciado   CHAR(1);    # Indica Cobro Financiado
    DECLARE CobroAnticipado   CHAR(1);    # Indica Cobro Anticipado
    DECLARE CobroDeduccion    CHAR(1);    # Indica Cobro por Deducción
    DECLARE TipoMontoOriginal CHAR(1);    # Constante: Tipo de Monto Original
  DECLARE Valor_UNO     INT(11);    # Constante: No
    DECLARE Con_SI        CHAR(1);    # Constante: SI
    DECLARE CobroPeriodico    CHAR(1);    # Indica Cobro Periodico


  SET Cadena_Vacia      := '';    # Constante: Cadena Vacia
  SET Salida_SI       := 'S';   # Constante: Salida Si
    SET Salida_NO       := 'N';   # Constante: Salida No
    SET Entero_Cero       := 0;   # Constante: Entero Cero
    SET Decimal_Cero      := 0.00;  # Constante: Decimal Cero
  SET Fecha_Vacia       := '1900-01-01'; # Constante: Fecha Vacía
    SET NumAmortizacion     := 1;   # Indica Número de Amortizaciones
    SET CobroFinanciado     := 'F';   # Indica Cobro Financiado
    SET CobroAnticipado     := 'A';   # Indica Cobro Anticipado
    SET CobroDeduccion      := 'D';   # Indica Cobro por Deducción
    SET CobroPeriodico      := 'P';   # Indica Cobro Periodico
    SET TipoMontoOriginal   := 'M';     # Tipo de Monto Orginal
  SET Valor_UNO       := 1;   # Constante: NO
  SET Con_SI          := 'S';   # Constante: SI

  ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-DETGARANTIALIQUIDAALT');
            SET Var_Control := 'SQLEXCEPTION';
    END;

    SET Par_CreditoID     := IFNULL(Par_CreditoID, Entero_Cero);
    SET Par_SolicitudCreditoID  := IFNULL(Par_SolicitudCreditoID, Entero_Cero);
        SET Par_ProductoCreditoID := IFNULL(Par_ProductoCreditoID, Entero_Cero);
        SET NumAmortizacion     := IFNULL(NumAmortizacion, Entero_Cero);

    SET Aud_FechaActual := NOW();

    SELECT  Garantizado,    RequiereGarFOGAFI,    ModalidadFOGAFI
    INTO  Var_RequiereGarLiq, Var_RequiereGarFOGAFI,  Var_ModalidadFOGAFI
      FROM PRODUCTOSCREDITO
            WHERE ProducCreditoID = Par_ProductoCreditoID;


        SET Var_CalificaCredito := (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID = Par_ClienteID);

      IF(Par_SolicitudCreditoID > Entero_Cero) THEN

                DELETE FROM DETALLEGARLIQUIDA
                WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

                 SET Var_MontoCredito := (SELECT CASE WHEN (Estatus = CobroAnticipado OR Estatus = CobroDeduccion) THEN MontoAutorizado
                        ELSE MontoSolici END
                      FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
            END IF;

            IF(Par_CreditoID > Entero_Cero) THEN

        DELETE FROM DETALLEGARLIQUIDA
                WHERE CreditoID = Par_CreditoID;


                SET Var_MontoCredito := (SELECT MontoCredito FROM CREDITOS  WHERE CreditoID = Par_CreditoID);

            END IF;

      IF(Var_RequiereGarLiq = Con_SI OR Var_RequiereGarFOGAFI = Con_SI) THEN

          INSERT INTO DETALLEGARLIQUIDA(
              SolicitudCreditoID,   CreditoID,        ProductoCreditoID,    RequiereGarantia,   Bonificacion,
              PorcBonificacion,   DesbloqAut,       RequiereGarFOGAFI,    PorcGarFOGAFI,      ModalidadFOGAFI,
                            BonificacionFOGAFI,   PorcBonificacionFOGAFI, DesbloqAutFOGAFI,   LiberaGarLiq,     MontoGarLiq,
                            MontoGarFOGAFI,     FechaLiquidaGar,    FechaLiquidaFOGAFI,   MontoBloqueadoGar,    MontoBloqueadoFOGAFI,
                            EmpresaID,        Usuario,        FechaActual,            DireccionIP,      ProgramaID,
                            Sucursal,       NumTransaccion)

          SELECT  Par_SolicitudCreditoID, Par_CreditoID,      Par_ProductoCreditoID,  Pro.Garantizado,    Pro.BonificacionFOGA,
              Decimal_Cero,     Pro.DesbloqAutFOGA,   Pro.RequiereGarFOGAFI,  Decimal_Cero,     Pro.ModalidadFOGAFI,
                            Pro.BonificacionFOGAFI, Decimal_Cero,     Pro.DesbloqAutFOGAFI, Pro.LiberarGaranLiq,  Decimal_Cero,
                            Decimal_Cero,     Fecha_Vacia,      Fecha_Vacia,      Decimal_Cero,     Decimal_Cero,
              Aud_EmpresaID,      Aud_Usuario,      Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,     Aud_NumTransaccion

          FROM  PRODUCTOSCREDITO Pro
          WHERE   Pro.ProducCreditoID = Par_ProductoCreditoID;


          UPDATE DETALLEGARLIQUIDA Det INNER JOIN ESQUEMAGARANTIALIQ Esq
          ON Det.ProductoCreditoID = Esq.ProducCreditoID
          INNER JOIN SOLICITUDCREDITO Sol
          ON Sol.SolicitudCreditoID  = Det.SolicitudCreditoID
          SET Det.PorcBonificacion = Esq.BonificacionFOGA,
                        Det.MontoGarLiq = Sol.PorcGarLiq * Var_MontoCredito / 100
          WHERE   Det.ProductoCreditoID = Par_ProductoCreditoID
          AND    Esq.LimiteInferior   <= Var_MontoCredito
          AND    Esq.LimiteSuperior   >= Var_MontoCredito
          AND Esq.Clasificacion = Var_CalificaCredito
          AND Det.SolicitudCreditoID = Par_SolicitudCreditoID;


          UPDATE DETALLEGARLIQUIDA Det INNER JOIN ESQUEMAGARFOGAFI Esq
          ON Det.ProductoCreditoID = Esq.ProducCreditoID
          SET Det.PorcGarFOGAFI = Esq.Porcentaje,
            Det.PorcBonificacionFOGAFI = Esq.BonificacionFOGAFI,
                       Det.MontoGarFOGAFI = Esq.Porcentaje * Var_MontoCredito / 100
          WHERE   Det.ProductoCreditoID = Par_ProductoCreditoID
          AND    Esq.LimiteInferior   <= Var_MontoCredito
          AND    Esq.LimiteSuperior   >= Var_MontoCredito
          AND Esq.Clasificacion = Var_CalificaCredito
          AND Det.SolicitudCreditoID = Par_SolicitudCreditoID;

    END IF;


    SET Par_NumErr      := 0;
    SET Par_ErrMen      := CONCAT('Detalle Agregado Exitosamente: ');
    SET Var_Control     := 'NumTransacSim';
    SET Var_Consecutivo   := 0;

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS Control,
        Var_Consecutivo AS Consecutivo;
  END IF;

END TerminaStore$$