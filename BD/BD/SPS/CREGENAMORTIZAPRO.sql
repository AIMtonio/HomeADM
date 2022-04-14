-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGENAMORTIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGENAMORTIZAPRO`;
DELIMITER $$


CREATE PROCEDURE `CREGENAMORTIZAPRO`(
-- ====================================================================================================================================
-- ---------------------- SP QUE SE EJECUTA CUANDO SE GENERA EL PAGARE DE CREDITO -----------------------------------------------------
-- ====================================================================================================================================
  Par_CreditoID   BIGINT(12),   -- ID del credito
  Par_FecMinist   DATE,   -- Fecha de desembolso
  Par_FechaInicioAmor DATE,   -- Fecha de inicio de las amortizaciones
  Par_TipoPrepago   CHAR(1),    -- Tipo de prepago
  Par_Salida      CHAR(1),

  INOUT Par_NumErr  INT(11),
  INOUT Par_ErrMen  VARCHAR(400),
  -- Parametros de Auditoria
  Par_EmpresaID   INT(11),
  Aud_Usuario     INT(11),
  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT(11),
  Aud_NumTransaccion  BIGINT(20)
      )

TerminaStore: BEGIN

  -- Declaracion de variables
  DECLARE Var_EstCredito    		CHAR(1);
  DECLARE Var_FecInicio   			DATE;
  DECLARE Var_FecTermin   			DATE;
  DECLARE Var_Monto     			DECIMAL(12,2); -- Variables para el Simulador
  DECLARE Var_TasaFija    			DECIMAL(12,4);
  DECLARE Var_PeriodCap   			INT(11);
  DECLARE Var_PeriodInt   			INT(11);
  DECLARE Var_FrecCap     			CHAR(1);
  DECLARE Var_FrecInter   			CHAR(1);
  DECLARE Var_DiaPagCap   			CHAR(1);
  DECLARE Var_DiaPagIn    			CHAR(1);
  DECLARE Var_DiaMesCap   			INT(11);
  DECLARE Var_DiaMesIn    			INT(11);
  DECLARE Var_FechaIni   			DATE;
  DECLARE Var_FechInha    			CHAR(1);
  DECLARE Var_NumAmorti   			INT(11);
  DECLARE Var_AjFeUlVA    			CHAR(1);
  DECLARE Var_AjFecExV    			CHAR(1);
  DECLARE Var_CalcInter   			INT(11);
  DECLARE Var_TipoPagCap    		CHAR(1);
  DECLARE Var_Producto    			INT(11);
  DECLARE Var_Cliente     			INT(11);
  DECLARE Var_MonComA     			DECIMAL(12,4);
  DECLARE Var_FechaSis    			DATE;
  DECLARE Var_Dia       			INT(11);
  DECLARE Var_Cuenta      			BIGINT(12);
  DECLARE Var_MontoCre    			DECIMAL(12,2);
  DECLARE Var_TipoCalIn   			INT(11);
  DECLARE Var_NumAmoInt   			INT(11);
  DECLARE Var_Cuotas      			INT;
  DECLARE Var_CuotasInt   			INT;
  DECLARE Var_NumDias     			INT(10);
  DECLARE Var_SalidaFecha   		DATE;
  DECLARE Var_EsHabil     			CHAR(1);
  DECLARE varControl      			CHAR(20);   -- almacena el elmento que es incorrecto
  DECLARE Var_Garantia    			DECIMAL(12,2);  -- Almacena el valor de la garantia liquida
  #SEGUROS -------------------------------------------------------------------------------
  DECLARE Var_CobraSeguroCuota 		CHAR(1);     -- Cobra Seguro por cuota
  DECLARE Var_CobraIVASeguroCuota 	CHAR(1);    -- Cobra IVA seguro por cuota
  DECLARE Var_MontoSeguroCuota 		DECIMAL(12,2);   -- Cobra seguro por cuota el credito
  DECLARE Var_EstatusNominaAutorizado CHAR(1);

  DECLARE Var_TasaBase    			INT;
  DECLARE Var_ValorTasa   			DECIMAL(12,4);
  DECLARE Var_SobreTasa   			DECIMAL(12,4);
  DECLARE Var_TasaBPuntos   		DECIMAL(12,4); -- Variable para la tasa base mas puntos
  DECLARE Var_FechaCobroCom 		DATE;     -- Fecha de Cobro de la comision
  DECLARE Var_NumCuotasAmor 		INT(11);    -- Numero de cuotas de la tabla AMORTICREDITO

  DECLARE Var_LineaCreditoID  		BIGINT;     -- Identificador de la línea de crédito
  DECLARE Var_CobraComAnual   		CHAR(1);    -- Indica si cobra o no comisión anual de linea de crédito
  DECLARE Var_ComisionCobrada 		CHAR(1);    -- Indica si la comisión anual de linea ya fue cobrada
  DECLARE Var_SaldoComAnual 		DECIMAL(14,2);    -- Saldo pendiente de la comisión anual de linea de crédito
  DECLARE Var_ComAnualLin   		DECIMAL(14,2);  -- Indica el monto a cubrir de la comisión anual de linea de crédito


  -- Valores a enviar al simulador
  DECLARE Par_ValorCAT    			DECIMAL(14,4);
  DECLARE Par_NumTransSim   		BIGINT;
  DECLARE Var_NumCuotas   			INT;
  DECLARE Var_NumCuotInt    		INT;
  DECLARE Par_MontoCuo    			DECIMAL(14,4);
  DECLARE Par_FechaVen    			DATE;
  DECLARE Var_NumTransacSim 		BIGINT;

  DECLARE Var_CobraAccesorios 		CHAR(1);      -- Indica si la solicitud cobra accesorios
  DECLARE Var_SolicitudCreditoID  	BIGINT(20);   -- Numero de la solicitud de credito
  DECLARE Var_PlazoID       		INT(11);    -- Clave del Plazo
  DECLARE Var_CobraAccesoriosGen  	CHAR(1);    -- Valor del Cobro de Accesorios
  DECLARE Var_NumTransSol   		BIGINT(20);     -- Numero de transaccion generado en la simulacion de amortizaciones

  DECLARE Var_CreditoID   			BIGINT(12);   -- Almacena el Numero de Credito con Monto Autorizado Modificado
  DECLARE Var_ConvenioNominaID    	BIGINT UNSIGNED;

  -- Declaracion de Constantes
  DECLARE Fecha_Vacia     			DATE;
  DECLARE Entero_Cero     			INT;
  DECLARE Cadena_Vacia    			CHAR(1);
  DECLARE Decimal_Cero    			DECIMAL(12,2);
  DECLARE Cre_Autorizado    		CHAR(1);
  DECLARE Cre_Inactivo    			CHAR(1);
  DECLARE Cre_Procesado   			CHAR(1);
  DECLARE SalidaNO      			CHAR(1);
  DECLARE SalidaSI      			CHAR(1);
  DECLARE TasFija       			INT;
  DECLARE PagCrecientes   			CHAR(1);
  DECLARE PagIguales      			CHAR(1);
  DECLARE PagLibres     			CHAR(1);  -- Pagos Libres
  DECLARE FrecMensual     			CHAR(1);
  DECLARE FrecQuincenal   			CHAR(1);
  DECLARE DiaAniversario    		CHAR(1);
  DECLARE Act_CreditoAmor   		INT;
  DECLARE Var_SI        			CHAR(1);
  DECLARE TipoCalIntGlo   			INT;
  DECLARE Var_Aniversario   		CHAR(1);  -- dia de pago por ANIVERSARIO
  DECLARE Var_DiaDelMes   			CHAR(1);  -- dia de pago por DIA DEL MES
  DECLARE Var_Indistinto    		CHAR(1);  -- dia de pago por INDISTINTO
  DECLARE Var_Capital     			CHAR(1);
  DECLARE Var_Interes     			CHAR(1);
  DECLARE Var_CapInt      			CHAR(1);
  DECLARE Var_MontoSeguro   		DECIMAL(12,2);
  DECLARE NoHabil       			CHAR(1);
  DECLARE CalendarioNormal  		INT(11);
  DECLARE Cons_NO       			CHAR(1);      -- Constante No: N
  DECLARE OperaPagare    			INT(11);      -- Indica que la transacción viene desde el pagaré
  DECLARE Llave_CobraAccesorios 	VARCHAR(100);   -- Llave para consulta el valor de Cobro de Accesorios
  DECLARE CobroFinanciado   		CHAR(1);
  DECLARE Act_Simulado    			INT(11);
  DECLARE Var_EsAgropecuario		CHAR(1);		-- Variable para almacenar si el credito es agropecuario
  DECLARE Var_FechaIniAmor			DATE;
  DECLARE Var_ManejaCalendario		CHAR(1);

  -- Asignacion de Constantes
  SET Fecha_Vacia   				:= '1900-01-01';  -- Fecha Vacia
  SET Entero_Cero   				:= 0;     -- Entero en Cero
  SET Cadena_Vacia  				:= '';      -- String o Cadena Vacia
  SET Decimal_Cero  				:= '0.00';    -- Decimal Cero
  SET Cre_Autorizado  				:= 'A';     -- Estatus del Credito Autorizado
  SET Cre_Inactivo  				:= 'I';     -- Estatus del Credito Inactivo o Recien Creado
  SET Cre_Procesado 				:= 'M';     -- Estatus del Credito Procesado(Procesado en el Monitor de Creditos)
  SET SalidaNO    					:= 'N';     -- El store NO Genera Salida
  SET SalidaSI    					:= 'S';     -- El store SI Genera Salida
  SET TasFija     					:= 1;     -- TasaFija
  SET PagCrecientes 				:= 'C';     -- Pago de capital crecientes
  SET PagIguales    				:= 'I';     -- Pago de capital iguales
  SET PagLibres   					:= 'L';     -- Pagos de capital Libre
  SET FrecMensual   				:= 'M';     -- Frecuencia de Pagos: Mensual
  SET FrecQuincenal 				:= 'Q';     -- Frecuencia de Pagos: Quincenal
  SET DiaAniversario  				:= 'A';     -- Dia de Pago en Mensuales: Aniversario
  SET Act_CreditoAmor 				:= 4;       -- Tipo de Actualizacion del Credito: Amortizaciones
  SET Var_SI      					:= 'S';     -- Constante SI
  SET TipoCalIntGlo 				:= 2;     -- tipo calculo interes Monto Original (Saldos Globales)
  SET Var_Aniversario 				:= 'A';     -- Dia de pago ANIVERSARIO
  SET Var_DiaDelMes 				:= 'D';     -- dia de pago por DIA DEL MES
  SET Var_Indistinto  				:= 'I';     -- dia de pago por INDISTINTO
  SET Var_Capital   				:= 'C';
  SET Var_Interes   				:= 'I';
  SET Var_CapInt    				:= 'G';
  SET NoHabil     					:= 'N';
  SET CalendarioNormal 				:= 1;
  SET Cons_NO     					:= 'N';     -- Constante NO
  SET OperaPagare   				:= 1;     -- Indica que la transaccion se genera al grabar el pagare de credito
  SET Llave_CobraAccesorios 		:= 'CobraAccesorios'; -- Llave para consultar Si Cobra Accesorios
  SET CobroFinanciado     			:= 'F';   -- Forma de cobro FINANCIADO
  SET Act_Simulado      			:= 1;   -- Actualiza a Simulado el Credito con Monto Autorizado Modificado

  SET Var_FechaSis 					:= (SELECT FechaSistema FROM PARAMETROSSIS);

  SET Par_NumErr    				:= Entero_Cero;
  SET Par_ErrMen    				:= "";
  SET Par_ValorCAT  				:= 0.0;
  SET Par_NumTransSim 				:= Entero_Cero;
  SET Var_NumCuotas 				:= 0;
  SET Var_NumCuotInt  				:= 0;


  ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-CREGENAMORTIZAPRO');
      SET varControl := 'sqlexception';
      END;

         -- Se obtiene el valor de si se realiza o no el cobro de accesorios
    SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
    SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

      -- obtencion de valores a enviar al simulador
    SELECT  CRE.MontoCredito,     	CRE.TasaFija,       	CRE.PeriodicidadCap,     	CRE.PeriodicidadInt,    CRE.FrecuenciaCap,
			CRE.FrecuenciaInt,      CRE.DiaPagoCapital,     CRE.DiaPagoInteres,      	CRE.DiaMesCapital,      CRE.DiaMesInteres,
			CRE.FechaInicio,      	CRE.FechaInhabil,     	CRE.NumAmortizacion,    	CRE.AjusFecUlVenAmo,    CRE.AjusFecExiVen,
			CRE.CalcInteresID,      CRE.TipoPagoCapital,  	CRE.ProductoCreditoID,   	CRE.ClienteID,        	CRE.MontoComApert,
			CRE.CuentaID,       	CRE.MontoCredito,     	CRE.TipoCalInteres,      	CRE.NumAmortInteres,    CRE.Estatus,
			CRE.NumTransacSim,      CRE.TasaBase,         	CRE.SobreTasa,           	CRE.CobraSeguroCuota,   CRE.CobraIVASeguroCuota,
			CRE.MontoSeguroCuota,   CRE.CobraAccesorios,    CRE.SolicitudCreditoID,  	CRE.PlazoID,        	CRE.LineaCreditoID,
			CRE.EsAgropecuario,		SOL.ConvenioNominaID, CRE.EstatusNomina
    INTO
			Var_Monto,        		Var_TasaFija,     		Var_PeriodCap,        		Var_PeriodInt,      	Var_FrecCap,
			Var_FrecInter,      	Var_DiaPagCap,      	Var_DiaPagIn,       		Var_DiaMesCap,      	Var_DiaMesIn,
			Var_FechaIni,     		Var_FechInha,     		Var_NumAmorti,        		Var_AjFeUlVA,     		Var_AjFecExV,
			Var_CalcInter,      	Var_TipoPagCap,     	Var_Producto,       		Var_Cliente,      		Var_MonComA,
			Var_Cuenta,       		Var_MontoCre,     		Var_TipoCalIn,        		Var_NumAmoInt,      	Var_EstCredito,
			Var_NumTransacSim,    	Var_TasaBase,     		Var_SobreTasa,        		Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota,
			Var_MontoSeguroCuota,  	Var_CobraAccesorios,  	Var_SolicitudCreditoID,  	Var_PlazoID,      		Var_LineaCreditoID,
			Var_EsAgropecuario,		Var_ConvenioNominaID, Var_EstatusNominaAutorizado
    FROM  CREDITOS CRE
    INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
      WHERE CRE.CreditoID = Par_CreditoID;

    SET Var_CobraSeguroCuota    := IFNULL(Var_CobraSeguroCuota, Cons_NO);
    SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, Cons_NO);
    SET Var_MontoSeguroCuota    := IFNULL(Var_MontoSeguroCuota, Entero_Cero);
	SET Var_CobraAccesorios     := IFNULL(Var_CobraAccesorios, Cons_NO);
    SET Var_LineaCreditoID      := IFNULL(Var_LineaCreditoID,Entero_Cero);
    SET Var_ConvenioNominaID    := IFNULL(Var_ConvenioNominaID,Entero_Cero);

    SET Var_NumTransSol := (SELECT NumTransacSim FROM SOLICITUDCREDITO WHERE SolicitudCreditoID  = Var_SolicitudCreditoID);
    IF((Var_EstCredito != Cre_Autorizado AND Var_EstCredito != Cre_Inactivo AND Var_EstCredito != Cre_Procesado) AND Var_EstatusNominaAutorizado = Cre_Autorizado) THEN
      SET Par_NumErr := 1;
      SET Par_ErrMen := CONCAT('El Credito ', CONVERT(Par_CreditoID, CHAR),' No esta Autorizado o Activo.');
      SET varControl := 'creditoID';
      LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_FecMinist,Fecha_Vacia)) = Fecha_Vacia THEN
        SET Par_NumErr  :=2;
        SET Par_ErrMen  :='La Fecha de Desembolso esta Vacia.';
        SET varControl  := 'fechaMinistrado';
        LEAVE ManejoErrores;
    -- Verifica que la fecha de desembolso NO sea un dia ihabil
    ELSE

      CALL DIASFESTIVOSCAL(Par_FecMinist,     Entero_Cero,    Var_SalidaFecha,    Var_EsHabil,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,     Aud_NumTransaccion);

      IF(Var_EsHabil = NoHabil)THEN
        SET Par_NumErr:= 3;
        SET Par_ErrMen:='La Fecha de Desembolso es Dia Inhabil.';
        SET varControl  := 'fechaMinistrado';
        LEAVE ManejoErrores;
      END IF;

    END IF;

    IF(IFNULL(Var_EsAgropecuario, Cons_NO) = Var_SI)THEN
		SET Par_NumErr 	:= 004;
		SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito ',CONVERT(Par_CreditoID, CHAR),' es de tipo Agropecuario.');
		SET varControl 	:= 'creditoID';
		LEAVE ManejoErrores;
    END IF;

        SELECT CobraComAnual, SaldoComAnual, ComisionCobrada
      INTO Var_CobraComAnual, Var_SaldoComAnual,  Var_ComisionCobrada
    FROM LINEASCREDITO
        WHERE LineaCreditoID= Var_LineaCreditoID;

        SET Var_CobraComAnual := IFNULL(Var_CobraComAnual,Cadena_Vacia);
        SET Var_SaldoComAnual := IFNULL(Var_SaldoComAnual,Entero_Cero);
        SET Var_ComisionCobrada := IFNULL(Var_ComisionCobrada,Cadena_Vacia);

        IF(Var_LineaCreditoID<>Entero_Cero AND Var_CobraComAnual='S' AND Var_ComisionCobrada='N')THEN
      SET Var_ComAnualLin := Var_SaldoComAnual;
        ELSE
      SET Var_ComAnualLin := Entero_Cero;
        END IF;

    IF(Var_CobraAccesorios = Var_SI AND Var_CobraAccesoriosGen = Var_SI) THEN

            IF (Var_TipoPagCap <> PagLibres) THEN

        # SE DAN DE ALTA LOS ACCESORIOS COBRADOS POR EL |CREDITO PARA GRABARLOS DEFINITIVAMENTE
        CALL DETALLEACCESORIOSALT(
          Par_CreditoID,  Var_SolicitudCreditoID, Var_Producto, Var_Cliente,  Aud_NumTransaccion,
          Var_PlazoID,  OperaPagare,  Var_Monto,  Var_ConvenioNominaID, SalidaNO,
          Par_NumErr, Par_ErrMen, Par_EmpresaID,  Aud_Usuario, Aud_FechaActual,
          Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);


        IF(Par_NumErr != Entero_Cero ) THEN
          SET varControl  := 'creditoID';
          LEAVE ManejoErrores;
        END IF;
      END IF;
    END IF;
    -- ========================== inicia la simulacion de amortizaciones ==============================

    -- Valida el dia de pago del capital, puede ser por ANIVERSARIO, INDISTINTO O DIA DEL MES.
    IF(Var_FrecCap != FrecQuincenal)THEN
    CASE Var_DiaPagCap
      WHEN Var_Aniversario  THEN SET Var_DiaMesCap  := DAY(Par_FechaInicioAmor);
      WHEN Var_DiaDelMes    THEN SET Var_DiaMesCap  := IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
      WHEN Var_Indistinto   THEN SET Var_DiaMesCap  := IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
      ELSE SET Var_DiaMesCap  := DAY(Par_FechaInicioAmor);
    END CASE ;
    END IF;

    -- Valida el dia de pago del interes, puede ser por ANIVERSARIO, INDISTINTO O DIA DEL MES.
    IF(Var_FrecInter != FrecQuincenal)THEN
    CASE Var_DiaPagIn
      WHEN Var_Aniversario  THEN SET Var_DiaMesIn := DAY(Par_FechaInicioAmor);
      WHEN Var_DiaDelMes    THEN SET Var_DiaMesIn := IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
      WHEN Var_Indistinto   THEN SET Var_DiaMesIn := IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
      ELSE SET Var_DiaMesIn := DAY(Par_FechaInicioAmor);
    END CASE ;
    END IF;

    -- Tasa Fija y que el tipo de calculo no sea sobre Saldos Globales
    IF(Var_CalcInter = TasFija AND Var_TipoCalIn <> TipoCalIntGlo ) THEN
     SELECT AporteCliente INTO Var_Garantia FROM CREDITOS WHERE CreditoID = Par_CreditoID;
      CASE Var_TipoPagCap
        WHEN PagCrecientes THEN
           -- tasa fija pagos crecientes
          CALL CREPAGCRECAMORPRO (
			Var_ConvenioNominaID,
            Var_Monto,        		Var_TasaFija,       		Var_PeriodCap,      	Var_FrecCap,    		Var_DiaPagCap,
            Var_DiaMesCap,      	Par_FechaInicioAmor,    	Var_NumAmorti,      	Var_Producto,   		Var_Cliente,
            Var_FechInha,     		Var_AjFeUlVA,       		Var_AjFecExV,     		Var_MonComA,    		Var_Garantia,
            Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota,  	Var_MontoSeguroCuota, 	Var_ComAnualLin,  		SalidaNO,
			Par_NumErr,       		Par_ErrMen,         		Par_NumTransSim,    	Var_NumCuotas,    		Par_ValorCAT,
            Par_MontoCuo,     		Par_FechaVen,       		Par_EmpresaID,      	Aud_Usuario,    		Aud_FechaActual,
            Aud_DireccionIP,    	Aud_ProgramaID,       		Aud_Sucursal,     		Aud_NumTransaccion);

        WHEN PagIguales THEN
          -- tasa fija pagos iguales
          CALL PRINCIPALSIMPAGIGUAPRO (
			Var_ConvenioNominaID,
            Var_Monto,        		Var_TasaFija,       		Var_PeriodCap,      	Var_PeriodInt,      	Var_FrecCap,
            Var_FrecInter,      	Var_DiaPagCap,        		Var_DiaPagIn,     		Par_FechaInicioAmor,	Var_NumAmorti,
            Var_NumAmoInt,      	Var_Producto,       		Var_Cliente,      		Var_FechInha,     		Var_AjFeUlVA,
            Var_AjFecExV,     		Var_DiaMesIn,       		Var_DiaMesCap,      	Var_MonComA,      		Var_Garantia,
            Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota,  	Var_MontoSeguroCuota, 	Var_ComAnualLin,    	SalidaNO,
			Par_NumErr,       		Par_ErrMen,         		Par_NumTransSim,    	Var_NumCuotas,      	Var_NumCuotInt,
			Par_ValorCAT,     		Par_MontoCuo,       		Par_FechaVen,     		Par_EmpresaID,      	Aud_Usuario,
			Aud_FechaActual,    	Aud_DireccionIP,      		Aud_ProgramaID,     	Aud_Sucursal,     		Aud_NumTransaccion);

        WHEN PagLibres THEN

          CALL PAGAMORLIBPRO(
            Var_NumTransacSim,  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
          SET Par_NumTransSim := Var_NumTransacSim;
          SELECT ValorCAT INTO Par_ValorCAT FROM CREDITOS WHERE CreditoID = Par_CreditoID;

                    IF(Var_CobraAccesorios = Var_SI AND Var_CobraAccesoriosGen = Var_SI) THEN
            UPDATE DETALLEACCESORIOS
              SET CreditoID  = Par_CreditoID
                            WHERE NumTransacSim = Var_NumTransacSim;
                    END IF;

        END CASE ;
    END IF; -- fin if(Var_CalcInter = TasFija ) THEN

    -- Tasa Variable Pagos Iguales y que el tipo de calculo no sea sobre Saldos Globales
    IF(Var_CalcInter != TasFija AND Var_TipoCalIn <> TipoCalIntGlo) THEN
      IF(Var_TipoPagCap = PagIguales )THEN

         -- Obtenemos el valor de la Tasa Base
         SELECT Valor INTO Var_ValorTasa
                  FROM  TASASBASE
                  WHERE TasaBaseID = Var_TasaBase;

         SET Var_TasaBPuntos := IFNULL(Var_ValorTasa, Entero_Cero) + IFNULL(Var_SobreTasa, Entero_Cero);

          CALL PRINCIPALSIMPAGIGUAPRO (
			Var_ConvenioNominaID,
            Var_Monto,        		Var_TasaBPuntos,      		Var_PeriodCap,      	Var_PeriodInt,      	Var_FrecCap,
            Var_FrecInter,      	Var_DiaPagCap,        		Var_DiaPagIn,     		Par_FechaInicioAmor,  	Var_NumAmorti,
            Var_NumAmoInt,      	Var_Producto,       		Var_Cliente,      		Var_FechInha,     		Var_AjFeUlVA,
            Var_AjFecExV,     		Var_DiaMesIn,       		Var_DiaMesCap,      	Var_MonComA,      		Var_Garantia,
            Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota,  	Var_MontoSeguroCuota, 	Var_ComAnualLin,    	SalidaNO,
			Par_NumErr,       		Par_ErrMen,         		Par_NumTransSim,    	Var_NumCuotas,      	Var_NumCuotInt,
			Par_ValorCAT,     		Par_MontoCuo,       		Par_FechaVen,     		Par_EmpresaID,      	Aud_Usuario,
			Aud_FechaActual,    	Aud_DireccionIP,      		Aud_ProgramaID,     	Aud_Sucursal,     		Aud_NumTransaccion);
      END IF;
    END IF; -- fin if(Var_CalcInter != TasFija )


    IF(Var_TipoCalIn = TipoCalIntGlo) THEN

      SET Par_NumTransSim := Var_NumTransacSim;

      SELECT AporteCliente INTO Var_Garantia FROM CREDITOS WHERE CreditoID = Par_CreditoID;
            IF (Var_TipoPagCap=PagLibres) THEN
        CALL CRERECPAGLIBPRO(
          Var_Monto,        Var_TasaFija,       Var_Producto,     Var_Cliente,      Var_MonComA,
          Var_CobraSeguroCuota, Var_CobraIVASeguroCuota,  Var_MontoSeguroCuota, Var_ComAnualLin,    SalidaNO,
                    Par_NumErr,       Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID,       Aud_Sucursal,     Aud_NumTransaccion);
            ELSE
              DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransSim;
        DELETE FROM DETALLEACCESORIOS WHERE NumTransaccion = Var_NumTransSol AND TipoFormaCobro  = CobroFinanciado ;

      CALL PRINCIPALSIMSALGLOPRO (
			Var_ConvenioNominaID,
			Var_Monto,        		Var_TasaFija,       		Var_PeriodCap,      	Var_FrecCap,    		Var_DiaPagCap,
			Var_DiaMesCap,      	Par_FechaInicioAmor,    	Var_NumAmorti,      	Var_Producto,   		Var_Cliente,
			Var_FechInha,     		Var_AjFeUlVA,       		Var_AjFecExV,     		Var_MonComA,    		Var_Garantia,
			Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota,  	Var_MontoSeguroCuota, 	Var_ComAnualLin,  		SalidaNO,
			Par_NumErr,       		Par_ErrMen,         		Par_NumTransSim,    	Var_NumCuotas,    		Par_ValorCAT,
			Par_MontoCuo,     		Par_FechaVen,       		Par_EmpresaID,      	Aud_Usuario,    		Aud_FechaActual,
			Aud_DireccionIP,    	Aud_ProgramaID,       		Aud_Sucursal,     		Aud_NumTransaccion);



    END IF; -- fin if(Var_TipoCalIn = TipoCalIntGlo)
    END IF;

    -- verifica que no hubo error en la simulacion
    IF(Par_NumErr != Entero_Cero ) THEN
      SET varControl  := 'creditoID';
      LEAVE ManejoErrores;
    END IF; -- fin if(Par_NumErr != Entero_Cero )


    SET Par_NumErr := Entero_Cero;
    SET Par_ErrMen  := Cadena_Vacia;

    -- llama al sp que Graba las amortizaciones temporales en la tabla de amortizaciones definitivas
    CALL AMORTICREDITOALT (
        Par_CreditoID,    Par_NumTransSim,  Var_Cliente,    Var_Cuenta,     Var_MontoCre,
        CalendarioNormal, SalidaNO,     Par_NumErr,     Par_ErrMen,     Par_EmpresaID,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

    -- verifica que no exista ningun error al dar de alta las amortizaciones
    IF(Par_NumErr != Entero_Cero ) THEN
      SET varControl  := 'creditoID';

      -- Elimina amortizaciones temporales si no se trata de un pago de capital libre
      IF(Var_TipoPagCap != PagLibres) THEN

        DELETE
          FROM TMPPAGAMORSIM
          WHERE NumTransaccion= Par_NumTransSim;

      END IF;
      LEAVE ManejoErrores;
    END IF; -- fin if(Par_NumErr != Entero_Cero )


    IF(Par_NumErr = Entero_Cero ) THEN

      -- Elimina amortizaciones temporales si no se trata de un pago de capital libre
      IF(Var_TipoPagCap != PagLibres) THEN
        DELETE
          FROM TMPPAGAMORSIM
          WHERE NumTransaccion= Par_NumTransSim;
      ELSE
        SET Var_Cuotas    := (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR Tmp_CapInt = Var_CapInt) AND NumTransaccion=Par_NumTransSim);
        SET Var_CuotasInt := (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR Tmp_CapInt = Var_CapInt) AND NumTransaccion=Par_NumTransSim);
        UPDATE CREDITOS SET
          NumAmortizacion = Var_Cuotas,
          NumAmortInteres = Var_CuotasInt
        WHERE CreditoID = Par_CreditoID;
      END IF;


            SET Var_FechaCobroCom := (SELECT FNSUMADIASFECHA(Var_FechaSis,  Var_PeriodCap));
      SET Var_FechaCobroCom := (SELECT FUNCIONDIAHABIL(Var_FechaCobroCom, 0, Par_EmpresaID));

      UPDATE CREDITOS SET
        DiaMesCapital   = Var_DiaMesCap,
        DiaMesInteres   = Var_DiaMesIn,
        FechaInicioAmor   = Par_FechaInicioAmor,
        FechaCobroComision  = Var_FechaCobroCom
      WHERE CreditoID = Par_CreditoID;

      SELECT  MIN(FechaInicio),   MAX(FechaVencim)
      INTO Var_FecInicio,   Var_FecTermin
      FROM AMORTICREDITO WHERE CreditoID= Par_CreditoID;


           SELECT COUNT(AmortizacionID) AS Total INTO Var_NumCuotasAmor
        FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID
                AND Capital != Decimal_Cero;

      UPDATE CREDITOS
            SET NumAmortizacion = Var_NumCuotasAmor
            WHERE CreditoID = Par_CreditoID;

            UPDATE SOLICITUDCREDITO
            SET NumAmortizacion = Var_NumCuotasAmor
            WHERE CreditoID = Par_CreditoID;

      SET Par_NumErr := Entero_Cero;
      SET Par_ErrMen := Cadena_Vacia;
      CALL CREDITOSACT(
          Par_CreditoID,      Par_NumTransSim,  Fecha_Vacia,    Entero_Cero,    Act_CreditoAmor,
          Par_FecMinist,      Var_FecTermin,    Par_ValorCAT,   Entero_Cero,    Entero_Cero,
          Cadena_Vacia,     Par_TipoPrepago,    Entero_Cero,    SalidaNO,     Par_NumErr,
          Par_ErrMen,       Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID,     Aud_Sucursal,     Aud_NumTransaccion);

        -- Actualiza la Fecha Inicio y Fecha de Vencimiento en la tabla SEGUROVIDA
        SET Aud_FechaActual := NOW();
        UPDATE SEGUROVIDA Seg
          INNER JOIN CREDITOS Cre
          ON(Seg.CreditoID = Cre.CreditoID)
        SET Seg.FechaInicio     = Var_FecInicio,
          Seg.FechaVencimiento  = Var_FecTermin,

          Seg.EmpresaID       = Par_EmpresaID,
          Seg.Usuario       = Aud_Usuario,
          Seg.FechaActual     = Aud_FechaActual,
          Seg.DireccionIP     = Aud_DireccionIP,
          Seg.ProgramaID      = Aud_ProgramaID,
          Seg.Sucursal      = Aud_Sucursal,
          Seg.NumTransaccion    = Aud_NumTransaccion
        WHERE Seg.CreditoID     = Par_CreditoID
            AND Cre.Estatus IN (Cre_Inactivo,Cre_Autorizado, Cre_Procesado);

        -- verifica que no exista nungun error al actualizar el credito
        IF(Par_NumErr != Entero_Cero ) THEN
          SET varControl  := 'creditoID';
          LEAVE ManejoErrores;
        END IF;


    END IF; -- fin if(Par_NumErr = Entero_Cero )

        -- SE OBTIENE EL CREDITO CON MONTO AUTORIZADO MODIFICADO
    SET Var_CreditoID := (SELECT CreditoID FROM CREDITOSMONTOAUTOMOD WHERE CreditoID = Par_CreditoID AND Simulado = Cons_NO);
        SET Var_CreditoID := IFNULL(Var_CreditoID,Entero_Cero);

        -- SE ACTUALIZA EL ESTATUS A SIMULADO EL CREDITO CON MONTO AUTORIZADO MODIFICADO
        IF(Var_CreditoID > Entero_Cero)THEN
      CALL CREDITOSMONTOAUTOMODACT (
        Var_CreditoID,    Act_Simulado,   SalidaNO,     Par_NumErr,     Par_ErrMen,
                Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
                Aud_Sucursal,   Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
        SET varControl  := 'creditoID';
        LEAVE ManejoErrores;
      END IF;
        END IF;

	IF (Var_ConvenioNominaID <> Entero_Cero) THEN

		SELECT		ManejaCalendario
			INTO	Var_ManejaCalendario
			FROM	CONVENIOSNOMINA
			WHERE	ConvenioNominaID = Var_ConvenioNominaID;

		SET Var_ManejaCalendario	:= IFNULL(Var_ManejaCalendario, SalidaNO);

		-- Si el convenio maneja calendario, se ajusta la fecha de inicio y de inicio de amortizaciones de la solicitud de credito y del credito a lo que fue simulado
		IF (Var_ManejaCalendario = SalidaSI) THEN

			SELECT		MIN(FechaInicio)
				INTO	Var_FechaIniAmor
				FROM	AMORTICREDITO
				WHERE	CreditoID = Par_CreditoID;

			SET Var_FechaIniAmor	:= IFNULL(Var_FechaIniAmor, Fecha_Vacia);

			IF (Var_FechaIniAmor <> Fecha_Vacia) THEN

				UPDATE CREDITOS SET
					FechaInicioAmor	= Var_FechaIniAmor
				WHERE CreditoID = Par_CreditoID;

				UPDATE SOLICITUDCREDITO SET
					FechaInicioAmor	= Var_FechaIniAmor
				WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

			END IF;

		END IF;

	END IF;

    SET Par_NumErr  := 0;
    SET Par_ErrMen  := CONCAT('Pagar&eacute; de Cr&eacute;dito Grabado Exitosamente: ', Par_CreditoID);
    SET varControl  := 'exportarPDF';

  END ManejoErrores; -- End del Handler de Errores


   IF (Par_Salida = SalidaSI) THEN
    SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
        Par_ErrMen    AS ErrMen,
        varControl    AS control,
        Entero_Cero   AS consecutivo;
   END IF;

END TerminaStore$$