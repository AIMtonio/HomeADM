-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERMORAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS DEVENGOINTERMORAPRO;
DELIMITER $$


CREATE PROCEDURE DEVENGOINTERMORAPRO(
-- SP para devengo de interes ordinario
    Par_CreditoID       BIGINT,
    Par_AmortizacionID  INT,
    Par_MontoMora       DECIMAL(16,2),
    Par_PolizaID        BIGINT,

    Par_Salida        CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
  
    Aud_EmpresaID     INT(11),      -- Empresa ID
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
      )

TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoID   BIGINT(12);
DECLARE Var_EmpresaID   INT;
DECLARE Var_FormulaID     INT(11);
DECLARE Var_TasaFija    DECIMAL(12,4);
DECLARE Var_MonedaID    INT(11);
DECLARE Var_Estatus     CHAR(1);
DECLARE Var_SucCliente      INT;
DECLARE Var_ProdCreID   INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_FactorMora    DECIMAL(10,4);

DECLARE Var_CreditoStr    VARCHAR(30);
DECLARE Var_DiasCredito   DECIMAL(10,2);
DECLARE Var_IntereMor   DECIMAL(12,4);
DECLARE Var_ComFalPag   CHAR(1);
DECLARE Var_MontoFalPag   DECIMAL(12,4);
DECLARE Mora_NVeces         CHAR(1);
DECLARE Mora_TasaFija       CHAR(1);

DECLARE Var_CobraMora       CHAR(1);
DECLARE Var_TipCobComMor    CHAR(1);

DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE DiasInteres         DECIMAL(10,2);
DECLARE Ref_GenInt          VARCHAR(50);
DECLARE Error_Key           INT;
DECLARE Mov_AboConta    INT;
DECLARE Mov_CarConta    INT;
DECLARE Mov_CarOpera    INT;
DECLARE Mov_AboOpera    INT;
DECLARE Var_Poliza          BIGINT;
DECLARE Par_Consecutivo     BIGINT;
DECLARE Var_ContadorCre     INT;
DECLARE Var_DifMorMov       DECIMAL(14,2);  -- almacena el valor del abonos - cargos  de los movimientos cuando se cobra mora y los dias de gracia ya vencieron
DECLARE Var_BaseComisi      DECIMAL(14,2);
DECLARE Var_TipoComision    CHAR(1);
DECLARE Var_Comision        DECIMAL(12,4);
DECLARE Var_SubClasifID     INT;
DECLARE Var_CicloActual     INT;
DECLARE Var_SucursalCred  INT;
DECLARE Var_TipoContaMora CHAR(1);
DECLARE Var_AmorVencido   INT(11);    -- Variable de conteo de amortisaciones vencidas del credito
DECLARE Var_FechaSistema  DATE;

/* Declaracion de Constantes */
DECLARE Estatus_Vigente CHAR(1);
DECLARE Estatus_Vencida CHAR(1);
DECLARE Estatus_Atrasado  CHAR(1);
DECLARE Cre_Vencido     CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Dec_Cien        DECIMAL(10,2);
DECLARE Com_MonOriCap   CHAR(1);
DECLARE Com_MonOriTot   CHAR(1);
DECLARE Com_SaldoAmo    CHAR(1);
DECLARE Pro_PasoAtras   INT;
DECLARE Var_ComFalPagM  CHAR(1);
DECLARE Var_ComFalPagP  CHAR(1);
DECLARE Mov_MoraVigen   INT;
DECLARE Mov_MoraCarVen  INT;
DECLARE Mov_CapAtrasado INT;
DECLARE Mov_CapVigente  INT;
DECLARE Mov_CapVencido  INT;
DECLARE Mov_ComFalPago  INT;
DECLARE Mov_InterPro    INT;
DECLARE Mov_IntAtras    INT;
DECLARE Mov_IntVencido  INT;
DECLARE Mov_CapVenNoEx  INT;
DECLARE Con_CueOrdMor   INT;
DECLARE Con_CorOrdMor   INT;
DECLARE Con_MoraDeven   INT;
DECLARE Con_MoraIngreso INT;
DECLARE Con_CapVigente  INT;
DECLARE Con_CapAtrasado INT;
DECLARE Con_CapVencido  INT;
DECLARE Con_CueOrdComFP INT;
DECLARE Con_CorOrdComFP INT;
DECLARE Con_IntDevVig   INT;
DECLARE Con_IntAtrasado INT;
DECLARE Con_IntVencido  INT;
DECLARE Con_CapVenNoEx  INT;
DECLARE Pol_Automatica  CHAR(1);
DECLARE Con_GenIntere   INT;
DECLARE Par_SalidaNO    CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE Des_CieDia      VARCHAR(100);
DECLARE TipoMovCapOrd   INT;
DECLARE TipoMovCapAtr   INT;
DECLARE TipoMovCapVen   INT;
DECLARE TipoMovCapVN    INT;
DECLARE No_EsReestruc   CHAR(1);
DECLARE Si_EsReestruc   CHAR(1);
DECLARE Si_Regulariza   CHAR(1);
DECLARE No_Regulariza   CHAR(1);
DECLARE Act_PagoSost    INT;
DECLARE SI_CobraMora    CHAR(1);
DECLARE SI_CobraFalPag  CHAR(1);
DECLARE NO_CobraFalPag  CHAR(1);
DECLARE SI_Prorratea    CHAR(1);
DECLARE Inte_Activo     CHAR(1);
DECLARE Per_Diario      CHAR(1);
DECLARE Per_Evento      CHAR(1);
DECLARE Por_Amorti      CHAR(1);
DECLARE Por_Credito     CHAR(1);
DECLARE Mora_CtaOrden CHAR(1);
DECLARE Des_ErrorGral       VARCHAR(100);
DECLARE Des_ErrorLlavDup    VARCHAR(100);
DECLARE Des_ErrorCallSP     VARCHAR(100);
DECLARE Des_ErrorValNulos   VARCHAR(100);

DECLARE Estatus_Suspendido  CHAR(1);  -- Estatus Suspendido
DECLARE Con_IntDevenSup   INT(11);  -- Concepto Contable Interes Devengado Supencion
DECLARE Con_IntAtrasadoSup  INT(11);  -- Concepto Contable: Interes Atrasado Suspendido
DECLARE Con_IntVencidoSup INT(11);  -- Concepto Contable: Interes Vencido Suspendido
DECLARE Con_CapVigenteSup INT(11);  -- Concepto Contable: Capital Vigente Suspendido
DECLARE Con_CapAtrasadoSup  INT(11);  -- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
DECLARE Con_CapVencidoSup INT(11);  -- Concepto Contable: Capital Vencido Suspendido
DECLARE Con_CapVenNoExSup INT(11);  -- Concepto Contable: Capital Vencido no Exigible Suspendido
DECLARE Act_PagoSostenido INT(11);  -- Actualizacion de Pago Sostenido
DECLARE Con_SI            CHAR(1);  -- Constante SI
DECLARE Con_NO            CHAR(1);  -- Constante NO




/* Asignacion de Constantes */
SET Estatus_Vigente   := 'V';             -- Estatus Amortizacion: Vigente
SET Estatus_Vencida   := 'B';             -- Estatus Amortizacion: Vencido
SET Estatus_Atrasado    := 'A';             -- Estatus Amortizacion: Atrasado
SET Cre_Vencido       := 'B';             -- Estatus Credito: Vencido
SET Cadena_Vacia    := '';                  -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     := 0;                   -- Entero en Cero
SET Decimal_Cero    := 0.00;                -- Decimal Cero
SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
SET Nat_Abono       := 'A';                 -- Naturaleza de Cargo
SET Dec_Cien        := 100.00;              -- Decimal Cien
SET Com_MonOriCap   := 'C';                 -- Criterio Comision: Monto Original de la Cuota Capital
SET Com_MonOriTot   := 'T';                 -- Criterio Comision: Monto Original de la Cuota Capital + Int + IVA
SET Com_SaldoAmo    := 'S';                 -- Criterio Comision: Saldo de la Cuota
SET Var_ComFalPagM  := 'M';                 -- Tipo de Comision por Falta de Pago: Monto
SET Var_ComFalPagP  := 'P';                 -- Tipo de Comision por Falta de Pago: Porcentaje
SET Mora_NVeces     := 'N';                 -- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
SET Mora_TasaFija   := 'T';                 -- Tipo de Cobro de Moratorios: Tasa Fija Anualizada
SET Pro_PasoAtras   := 202;                 -- Numero de Proceso Batch: Trapsaso a Atrasado
SET Mov_MoraVigen   := 15;                  -- Tipo de Movimiento de Credito: Moratorios
SET Mov_MoraCarVen  := 17;          -- Tipo de Movimiento de Credito: Moratorios de Cartera Vencida
SET Mov_CapAtrasado := 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
SET Mov_CapVigente  := 1;                   -- Tipo de Movimiento de Credito: Capital Vigente
SET Mov_ComFalPago  := 40;                  -- Tipo de Movimiento de Credito: Comision x Falta de Pago
SET Mov_InterPro    := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
SET Mov_IntAtras    := 11;                  -- Tipo de Movimiento de Credito: Interes Atrasado
SET Mov_CapVencido  := 3;                   -- Tipo de Movimiento de Credito: Interes Vencido
SET Mov_IntVencido  := 12;                  -- Tipo de Movimiento de Credito: Interes Vencido
SET Mov_CapVenNoEx  := 4;                   -- Tipo de Movimiento de Credito: Capital Vencido no Exigible
SET Con_CueOrdMor   := 13;                  -- Concepto Contable: Cuentas de Orden de Moratorios
SET Con_CorOrdMor   := 14;                  -- Concepto Contable: Correlativa de Orden de Moratorios
SET Con_CueOrdComFP := 15;                  -- Concepto Contable: Cuentas de Orden Comision Falta de Pago
SET Con_CorOrdComFP := 16;                  -- Concepto Contable: Correlativa de Orden Comision Falta de Pago
SET Con_MoraDeven   := 33;                  -- Concepto Contable: Interes Moratorio Devengado
SET Con_MoraIngreso := 6;         -- Concepto Contable: Ingreso por Interes Moratorio
SET Con_CapVigente  := 1;                   -- Concepto Contable: Capital Vigente
SET Con_CapAtrasado := 2;                   -- Concepto Contable: Capital Atrasado
SET Con_IntDevVig   := 19;                  -- Concepto Contable: Interes Devengado
SET Con_IntAtrasado := 20;                  -- Concepto Contable: Interes Atrasado
SET Con_IntVencido  := 21;                  -- Concepto Contable: Interes Vencido
SET Con_CapVencido  := 3;                   -- Concepto Contable: Capital Vigente
SET Con_CapVenNoEx  := 4;                   -- Concepto Contable: Capital Vencido No Exigible
SET Pol_Automatica  := 'A';                 -- Tipo de Poliza: Automatica
SET Con_GenIntere   := 52;                  -- Tipo de Proceso Contable: Generacion de Interes de Cartera
SET Par_SalidaNO    := 'N';                 -- El store no Arroja una Salida
SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: SI
SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: NO
SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
SET SI_Prorratea    := 'S';                 -- SI Prorratea la Comision por Falta de Pago
SET Inte_Activo     := 'A';                 -- Integrante Activo del Grupo
SET Per_Diario      := 'D';                 -- Periodiciad en el Cobro de FalPago: Diario
SET Per_Evento      := 'C';                 -- Periodiciad en el Cobro de FalPago: Por Evento o Atraso
SET Por_Amorti      := 'A';                 -- Tipo de Cobro de FalPago: Por Amortizacion
SET Por_Credito     := 'C';                 -- Tipo de Cobro de FalPago: Por Credito
SET Des_CieDia      := 'CIERRE DIARO CARTERA';
SET Ref_GenInt      := 'GENERACION INTERES MORATORIO';

SET TipoMovCapOrd   := 1;                   -- Tipo de Movimiento de Credito: Capital Ordinario
SET TipoMovCapAtr   := 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
SET TipoMovCapVen   := 3;                   -- Tipo de Movimiento de Credito: Capital Vencido
SET TipoMovCapVN    := 4;                   -- Tipo de Movimiento de Credito: Capital Vencido No Exigible.

SET No_EsReestruc       := 'N';             -- El Producto de Credito no es para Reestructuras
SET Si_EsReestruc       := 'S';             -- El credito si es una Reestructura
SET Si_Regulariza       := 'S';             -- La Reestructura ya fue Regularizada
SET No_Regulariza       := 'N';             -- La Reestructura NO ha sido Regularizada
SET Act_PagoSost        := 2;               -- Tipo de Actualizacion de la Reest: Pagos Sostenidos
SET SI_CobraMora        := 'S';             -- Si Cobra Interes Moratorio
SET SI_CobraFalPag      := 'S';             -- Si Cobra Comisicion por Falta de Pago
SET NO_CobraFalPag      := 'N';             -- No Cobra Comisicion por Falta de Pago
SET Mora_CtaOrden   := 'C';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';

SET Estatus_Suspendido  := 'S';   -- Estatus Suspendido
SET Con_IntDevenSup   := 114;   -- Concepto Contable Interes Devengado Ssupencion
SET Con_IntAtrasadoSup  := 115;   -- Concepto Contable: Interes Atrasado Suspendido
SET Con_IntVencidoSup := 116;   -- Concepto Contable: Interes Vencido
SET Con_CapVigenteSup := 110;   -- Concepto Contable: Capital Vigente Suspendido
SET Con_CapAtrasadoSup  := 111;   -- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
SET Con_CapVencidoSup := 112;   -- Concepto Contable: Capital Vencido Suspendido
SET Con_CapVenNoExSup := 113;   -- Concepto Contable: Capital Vencido no Exigible Suspendido
SET Con_SI            := 'S';
SET Con_NO            := 'N';
SET Act_PagoSostenido := 1;



ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr  := 999;
      SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
              'Disculpe las molestias que esto le ocaciona. Ref: SP-DEVENGOINTERMORAPRO');
    END;
  

  SELECT DiasCredito, TipoContaMora, FechaSistema INTO Var_DiasCredito, Var_TipoContaMora, Var_FechaSistema FROM PARAMETROSSIS;
  SET Var_TipoContaMora := IFNULL(Var_TipoContaMora, Cadena_Vacia);


   SELECT  Cre.CreditoID,   Cre.EmpresaID,           
            CalcInteresID,        Cre.TasaFija,       Cre.MonedaID,     Cre.Estatus,
            Cli.SucursalOrigen,   Cre.ProductoCreditoID,  Des.Clasificacion,  Cre.FactorMora,
            Pro.CobraMora,          Cre.TipCobComMorato,
            Des.SubClasifID,    Cre.SucursalID

            INTO 
            Var_CreditoID,     
            Var_EmpresaID,      Var_FormulaID,      Var_TasaFija,
            Var_MonedaID,       Var_Estatus,        Var_SucCliente,     Var_ProdCreID,      Var_ClasifCre,
            Var_FactorMora,              
            Var_CobraMora,
            Var_TipCobComMor,  
            Var_SubClasifID,  Var_SucursalCred

            FROM CLIENTES Cli,
                 PRODUCTOSCREDITO Pro,
                 DESTINOSCREDITO Des,
                 CREDITOS Cre
          LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
            WHERE Cre.ClienteID   = Cli.ClienteID
              AND Cre.ProductoCreditoID = Pro.ProducCreditoID
              AND Cre.DestinoCreID  = Des.DestinoCreID
              AND (Cre.Estatus    =  'V'
              OR Cre.Estatus    =  'B'
              OR Cre.Estatus    =  'S')
              AND Cre.CreditoID = Par_CreditoID;



    -- Inicializacion
    SET DiasInteres         := Entero_Cero;
    SET Var_IntereMor       := Entero_Cero;
    SET Var_SucursalCred  := IFNULL(Var_SucursalCred, Aud_Sucursal);


  # ======================== GENERACION DE MORATORIOS ==============================
   -- Generacion de Intereses moratorios
    IF(Var_CobraMora = SI_CobraMora) THEN

      -- Verificamos como Registrar Operativa y Contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
      -- Si se contabiliza en cuentas de orden o en cuentas de ingresos
      IF(Var_TipoContaMora = Mora_CtaOrden) THEN
        SET Mov_AboConta    := Con_CorOrdMor;
        SET Mov_CarConta    := Con_CueOrdMor;
        SET Mov_CarOpera    := Mov_MoraVigen;
      ELSE
        -- Verificamos si el Credito esta Vigente o Vencido, para saber como contabilizar
        IF( Var_Estatus = Estatus_Vigente) THEN
          SET Mov_AboConta    := Con_MoraIngreso;
          SET Mov_CarConta    := Con_MoraDeven;
          SET Mov_CarOpera    := Mov_MoraVigen;
        ELSE
          SET Mov_AboConta    := Con_CorOrdMor;
          SET Mov_CarConta    := Con_CueOrdMor;
          SET Mov_CarOpera    := Mov_MoraCarVen;
        END IF;
      END IF;


      SET Var_IntereMor := Par_MontoMora;

      -- se realizan los movimientos contables y operativos del cargo por interes moratorio
      IF (Var_IntereMor > Decimal_Cero) THEN

          CALL  CONTACREDITOSPRO (
          Var_CreditoID,      Par_AmortizacionID, Entero_Cero,        Entero_Cero,      Var_FechaSistema,
          Var_FechaSistema, Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,    Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_GenInt,       AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,         AltaPolCre_SI,      AltaMovCre_SI,    Mov_CarConta,
          Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,     Cadena_Vacia,
          Cadena_Vacia,       Par_SalidaNO,
          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,    Cadena_Vacia,
          Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion);
          
          IF Par_ErrMen <> Entero_Cero THEN
            SET Par_ErrMen := CONCAT('Error en registro contable,',Par_ErrMen);
          END IF;

          CALL  CONTACREDITOSPRO (
          Var_CreditoID,      Par_AmortizacionID, Entero_Cero,        Entero_Cero,      Var_FechaSistema,
          Var_FechaSistema, Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,    Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_GenInt,       AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,         AltaPolCre_SI,      AltaMovCre_NO,    Mov_AboConta,
          Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,     Cadena_Vacia,
          Cadena_Vacia,       Par_SalidaNO,
          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,    Cadena_Vacia,
          Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion  );
          
                    
          IF Par_ErrMen <> Entero_Cero THEN
            SET Par_ErrMen := CONCAT('Error en registro contable,',Par_ErrMen);
          END IF;

    END IF; -- Endif de Var_IntereMor (Moratorios) mayor que cero
  END IF; -- EndIf Generacion de Intereses moratorios

    SET Par_NumErr := 0;
    SET Par_ErrMen := 'Devengo Moratorio Realizado Exitosamente';


END ManejoErrores;

IF(Par_Salida != Par_SalidaNO) THEN
    SELECT  Par_NumErr    AS NumErr,
            Par_ErrMen    AS ErrMen;
END IF;


END TerminaStore$$
