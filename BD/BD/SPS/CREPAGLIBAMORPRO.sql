-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGLIBAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGLIBAMORPRO`;
DELIMITER $$

CREATE PROCEDURE `CREPAGLIBAMORPRO`(
-- ----------------------------------------------------------------
-- SE UTILIZA PARA GENERAR EL CALENDARIO DE FECHAS DEL COTIZADOR
-- EN EL MODO DE PAGOS LIBRES
-- ----------------------------------------------------------------
	Par_Monto               DECIMAL(12,2),          /* Monto solicitado*/
    Par_Frecu				INT(11),		-- Frecuencia del pago de capital en Dias
	Par_FrecuInt			INT(11),		-- Frecuencia del pago de interes en Dias
	Par_PagoCuota			CHAR(1),		-- Pago de la cuota capital (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_PagoInter			CHAR(1),		-- Pago de la cuota de Intereses  (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_PagoFinAni			CHAR(1),		-- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)

	Par_PagoFinAniInt		CHAR(1),		-- solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A) para los intereses
	Par_FechaInicio			DATE	,		-- fecha en que empiezan los pagos
	Par_NumeroCuotas		INT(11),		-- Numero de Cuotas que se simularan
	Par_ProducCreditoID		INT(11),		-- identificador de PRODUCTOSCREDITO para obtener dias de gracia
	Par_DiaHabilSig			CHAR(1),		-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)

	Par_AjustaFecAmo		CHAR(1),		-- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	Par_AjusFecExiVen		CHAR (1),		-- Indica si se ajusta la fecha de vencimiento a fecha de exigibilidad (S- si se ajusta N- no se ajusta)
	Par_DiaMesInt			INT(11),		-- solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para los intereses
	Par_DiaMesCap			INT(11),		-- solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para el capital
	Par_CobraSeguroCuota    CHAR(1),        -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota CHAR(1),        -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota     DECIMAL(12,2), -- Monto Seguro por Cuota
    Par_ClienteID			INT(11),		-- Numero de Cliente

	Par_Salida    			CHAR(1),		-- Indica si hay una salida o no
	/*AUDITORIA*/
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),
	INOUT	Par_NumTran		BIGINT(20),		-- Numero de transaccion con el que se genero el calendario de pagos
	INOUT	Par_MontoCuo	DECIMAL(14,4),	-- corresponde con la cuota promedio a pagar

	INOUT	Par_FechaVen 	DATE,			-- corresponde con la fecha final que genere el cotizador
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
				)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Negativo		INT(11);
	DECLARE Var_SI				CHAR(1);	-- SI
	DECLARE Var_No				CHAR(1);	-- NO
	DECLARE PagoSemanal			CHAR(1);	-- Pago Semanal (S)
	DECLARE PagoDecenal			CHAR(1);
	DECLARE PagoCatorcenal		CHAR(1);	-- Pago Catorcenal (C)
	DECLARE PagoQuincenal		CHAR(1);	-- Pago Quincenal (Q)
	DECLARE PagoMensual			CHAR(1);	-- Pago Mensual (M)
	DECLARE PagoPeriodo			CHAR(1);	-- Pago por periodo (P)
	DECLARE PagoBimestral		CHAR(1);	-- PagoBimestral (B)
	DECLARE PagoTrimestral		CHAR(1);	-- PagoTrimestral (T)
	DECLARE PagoTetrames		CHAR(1);	-- PagoTetraMestral (R)
	DECLARE PagoSemestral		CHAR(1);	-- PagoSemestral (E)
	DECLARE PagoAnual			CHAR(1);	-- PagoAnual (A)
	DECLARE PagoUnico			CHAR(1);	-- Pago Unico (U)
	DECLARE PagoFinMes			CHAR(1);	-- Pago al final del mes (F)
	DECLARE PagoAniver			CHAR(1);	-- Pago por aniversario (A)
	DECLARE FrecSemanal			INT(11);	-- frecuencia semanal en dias
	DECLARE FrecCator			INT(11);	-- frecuencia Catorcenal en dias
	DECLARE FrecQuin			INT(11);	-- frecuencia en dias quincena
	DECLARE FrecMensual			INT(11);	-- frecuencia mensual
	DECLARE FrecBimestral		INT(11);	-- Frecuencia en dias Bimestral
	DECLARE FrecTrimestral		INT(11);	-- Frecuencia en dias Trimestral
	DECLARE FrecTetrames		INT(11);	-- Frecuencia en dias TetraMestral
	DECLARE FrecSemestral		INT(11);	-- Frecuencia en dias Semestral
	DECLARE FrecAnual			INT(11);	-- frecuencia en dias Anual
	DECLARE Var_Capital			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital
	DECLARE Var_Interes			CHAR(1);	-- Bandera que me indica que se trata de un pago de interes
	DECLARE Var_CapInt			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital y de interes
	DECLARE Var_TipoCap			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital y de interes
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Cons_FrecExtDiasSemanal                 INT(11);
    DECLARE Cons_FrecExtDiasDecenal                 INT(11);
    DECLARE Cons_FrecExtDiasCatorcenal              INT(11);
    DECLARE Cons_FrecExtDiasQuincenal               INT(11);
    DECLARE Cons_FrecExtDiasMensual                 INT(11);
    DECLARE Cons_FrecExtDiasPeriodo                 INT(11);
    DECLARE Cons_FrecExtDiasBimestral               INT(11);
    DECLARE Cons_FrecExtDiasTrimestral              INT(11);
    DECLARE Cons_FrecExtDiasTetrames                INT(11);
    DECLARE Cons_Var_FrecExtDiasSemestral           INT(11);
    DECLARE Cons_FrecExtDiasAnual                   INT(11);
    DECLARE Cons_FrecExtDiasFinMes                  INT(11);
    DECLARE Cons_FrecExtDiasAniver                  INT(11);
	DECLARE Llave_CobraAccesorios					VARCHAR(100); 		-- Llave para consulta el valor de Cobro de Accesorios
    DECLARE OperaSimulador							INT(11);			-- Indica que la transacción viene desde el simulador


	-- Declaracion de Variables
	DECLARE Var_UltDia			INT(11);
	DECLARE Contador			INT(11);
	DECLARE Consecutivo			INT(11);
	DECLARE ContadorInt			INT(11);
	DECLARE ContadorCap			INT(11);
	DECLARE FechaInicio			DATE;
	DECLARE FechaFinal			DATE;
	DECLARE FechaInicioInt		DATE;
	DECLARE FechaFinalInt		DATE;
	DECLARE FechaVig			DATE;
	DECLARE Par_FechaVenc		DATE;		-- fecha vencimiento en que terminan los pagos
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_Cuotas			INT(11);
	DECLARE Var_CuotasInt		INT(11);
	DECLARE Var_Amor			INT(11);
	DECLARE Fre_Dias			INT(11);	-- numero de dias para pagos de capital
	DECLARE Fre_DiasTab			INT(11);	-- numero de dias para pagos de capital
	DECLARE Fre_DiasInt			INT(11);	-- numero de dias para pagos de interes
	DECLARE Fre_DiasIntTab		INT(11);	-- numero de dias para pagos de interes
	DECLARE Var_DiasExtra		INT(11);	-- dias de gracia
	DECLARE CapInt				CHAR(1);
	DECLARE Var_FrecuPago		INT(11);
	DECLARE Var_TotalCap		DECIMAL(14,2);
	DECLARE Var_TotalInt		DECIMAL(14,2);
	DECLARE	Var_TotalIva		DECIMAL(14,2);
	DECLARE Var_IVA                                 DECIMAL(14,2);              -- Variable de IVA
	DECLARE Var_Control                             VARCHAR(100);               -- Variable de control
    DECLARE Var_FrecExtDiasSemanal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasDecenal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasCatorcenal               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasQuincenal                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasMensual                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasPeriodo                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasBimestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTrimestral               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTetrames                 INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasSemestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAnual                    INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasFinMes                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAniver                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    # SEGUROS
    DECLARE Var_SeguroCuota                         DECIMAL(12,2);              -- Monto que cobra por seguro por cuota
    DECLARE Var_IVASeguroCuota                      DECIMAL(12,2);              -- Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota                    DECIMAL(12,2);              -- Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota                 DECIMAL(12,2);              -- Total de iva seguro cuota

    DECLARE Var_CobraAccesorios						CHAR(1);					-- Indica si la solicitud cobra accesorios
	DECLARE Var_SaldoOtrasComisiones				DECIMAL(14,2);				-- Saldo de Otras Comisiones
	DECLARE Var_SaldoIVAOtrasComisiones				DECIMAL(14,2);				-- Saldo IVA Otras Comisiones

    DECLARE Var_PlazoID								INT(11);					-- Plazo del credito
    DECLARE Var_SolicitudCreditoID					BIGINT(20);					-- Numero de Solicitud de Credito
    DECLARE Var_CreditoID							BIGINT(12);					-- Numero de Credito
	DECLARE Var_CobraAccesoriosGen					CHAR(1);					-- Valor del Cobro de Accesorios

	-- asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Decimal_Cero		:= 0.00;
	SET Entero_Cero			:= 0;
	SET Entero_Negativo		:= -1;
	SET Var_SI				:= 'S';
	SET Var_No				:= 'N';
	SET PagoSemanal			:= 'S'; -- PagoSemanal
	SET PagoDecenal			:= 'D';
	SET PagoCatorcenal		:= 'C'; -- PagoCatorcenal
	SET PagoQuincenal		:= 'Q'; -- PagoQuincenal
	SET PagoMensual			:= 'M'; -- PagoMensual
	SET PagoPeriodo			:= 'P'; -- PagoPeriodo
	SET PagoBimestral		:= 'B'; -- PagoBimestral
	SET PagoTrimestral		:= 'T'; -- PagoTrimestral
	SET PagoTetrames		:= 'R'; -- PagoTetraMestral
	SET PagoSemestral		:= 'E'; -- PagoSemestral
	SET PagoAnual			:= 'A'; -- PagoAnual
	SET PagoUnico			:= 'U'; -- Pago Unico (U)
	SET PagoFinMes			:= 'F'; -- PagoFinMes
	SET PagoAniver			:= 'A'; -- Pago por aniversario
	SET FrecSemanal			:= 7;	-- frecuencia semanal en dias
	SET FrecCator			:= 14;	-- frecuencia Catorcenal en dias
	SET FrecQuin			:= 15;	-- frecuencia en dias de quincena
	SET FrecMensual			:= 30;	-- frecuencia mesual

	SET FrecBimestral		:= 60;	-- Frecuencia en dias Bimestral
	SET FrecTrimestral		:= 90;	-- Frecuencia en dias Trimestral
	SET FrecTetrames		:= 120;	-- Frecuencia en dias TetraMestral
	SET FrecSemestral		:= 180;	-- Frecuencia en dias Semestral
	SET FrecAnual			:= 360;	-- frecuencia en dias Anual
	SET Var_Capital			:= 'C';	-- Bandera que me indica que se trata de un pago de capital
	SET Var_Interes			:= 'I';	-- Bandera que me indica que se trata de un pago de interes
	SET Var_CapInt			:= 'G';	-- Bandera que me indica que se trata de un pago de capital y de interes
	SET Salida_SI 	   		:= 'S';
    SET Cons_FrecExtDiasSemanal         := 5;
    SET Cons_FrecExtDiasDecenal         := 5;
    SET Cons_FrecExtDiasCatorcenal      := 10;
    SET Cons_FrecExtDiasQuincenal       := 10;
    SET Cons_FrecExtDiasMensual         := 20;
    SET Cons_FrecExtDiasBimestral       := 40;
    SET Cons_FrecExtDiasTrimestral      := 60;
    SET Cons_FrecExtDiasTetrames        := 80;
    SET Cons_Var_FrecExtDiasSemestral   := 120;
    SET Cons_FrecExtDiasAnual           := 240;
    SET Llave_CobraAccesorios			:= 'CobraAccesorios'; -- Llave para Consultar Si Cobra Accesorios
    SET OperaSimulador					:= 1; 		-- Indica Opera Simulador


	-- asignacion de variables
	SET Contador			:= 1;
	SET ContadorInt			:= 1;
	SET FechaInicio			:= Par_FechaInicio;
	SET FechaInicioInt		:= Par_FechaInicio;
	SET Var_FrecuPago		:= 0;

    ManejoErrores:BEGIN     #bloque para manejar los posibles errores no controlados del codigo
	    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
	        SET Par_NumErr    := 999;
	        SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	        'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGLIBAMORPRO');
	        SET Var_Control := 'SQLEXCEPTION';
	    END;
	    SET Var_IVA                         := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);

		 -- Se obtiene el valor de si se realiza o no el cobro de accesorios
		SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
		SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);


        SET Var_CobraAccesorios := (SELECT CobraAccesorios FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);
        SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios, Cadena_Vacia);

		-- se guarda el valor de dias de gracia y margen de pagos iguales en las variables
        /*PARAMETRIZACION DE DIAS EXTRAS PARA LAS AMORITZACIONES*/
        SET Var_FrecExtDiasSemanal              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemanal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasCatorcenal           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoCatorcenal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasQuincenal            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoQuincenal AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasMensual              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoMensual AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasPeriodo              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoPeriodo AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasBimestral            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoBimestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTrimestral           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTrimestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTetrames             :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTetrames AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasSemestral            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemestral AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAnual                :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAnual AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasFinMes               :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoFinMes AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAniver               :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAniver AND ProducCreditoID = Par_ProducCreditoID ORDER BY FechaActual DESC LIMIT 1);

        -- SE SETEAN LOS SIGUIENTES VALORES SI ES QUE EL CLIENTE NO LO HA PARAMETRIZADO
        SET Var_FrecExtDiasSemanal              :=IFNULL(Var_FrecExtDiasSemanal, Cons_FrecExtDiasSemanal);
        SET Var_FrecExtDiasCatorcenal           :=IFNULL(Var_FrecExtDiasCatorcenal, Cons_FrecExtDiasCatorcenal);
        SET Var_FrecExtDiasQuincenal            :=IFNULL(Var_FrecExtDiasQuincenal, Cons_FrecExtDiasQuincenal);
        SET Var_FrecExtDiasMensual              :=IFNULL(Var_FrecExtDiasMensual, Cons_FrecExtDiasMensual);
        SET Var_FrecExtDiasPeriodo              :=IFNULL(Var_FrecExtDiasPeriodo, Cons_FrecExtDiasPeriodo);
        SET Var_FrecExtDiasBimestral            :=IFNULL(Var_FrecExtDiasBimestral, Cons_FrecExtDiasBimestral);
        SET Var_FrecExtDiasTrimestral           :=IFNULL(Var_FrecExtDiasTrimestral, Cons_FrecExtDiasTrimestral);
        SET Var_FrecExtDiasTetrames             :=IFNULL(Var_FrecExtDiasTetrames, Cons_FrecExtDiasTetrames);
        SET Var_FrecExtDiasSemestral            :=IFNULL(Var_FrecExtDiasSemestral, Cons_Var_FrecExtDiasSemestral);
        SET Var_FrecExtDiasAnual                :=IFNULL(Var_FrecExtDiasAnual, Cons_FrecExtDiasAnual);
        SET Var_FrecExtDiasFinMes               :=IFNULL(Var_FrecExtDiasFinMes, Cons_FrecExtDiasFinMes);
        SET Var_FrecExtDiasAniver               :=IFNULL(Var_FrecExtDiasAniver, Cons_FrecExtDiasAniver);
        /* FIN PARAMETRIZACION DE DIAS EXTRAS PARA LAS AMORITZACIONES*/

		IF ( Par_PagoCuota = PagoPeriodo) THEN
			IF(IFNULL(Par_Frecu, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Especificar Frecuencia Pago.';
				LEAVE ManejoErrores;
			END IF ;
		END IF ;


		IF ( Par_PagoInter = PagoPeriodo) THEN
			IF(IFNULL(Par_FrecuInt, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Especificar Frecuencia Pago.';
				LEAVE ManejoErrores;
			END IF ;
		END IF ;

		SET Par_CobraSeguroCuota := IFNULL(Par_CobraSeguroCuota, Var_No);

        IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra Seguro por Cuota.';
            LEAVE ManejoErrores;
          ELSE
            IF(Par_CobraSeguroCuota = Var_SI) THEN
                IF(IFNULL(Par_CobraIVASeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
                    SET Par_NumErr := 005;
                    SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra IVA por Seguro por Cuota.';
                    LEAVE ManejoErrores;
                END IF;
                IF(IFNULL(Par_MontoSeguroCuota,Entero_Cero)= Entero_Cero) THEN
                    SET Par_NumErr := 006;
                    SET Par_ErrMen := 'El Monto para el Seguro por Cuota Esta Vacio.';
                    LEAVE ManejoErrores;
                END IF;
              ELSE
                SET Par_MontoSeguroCuota := Decimal_Cero;
                SET Var_TotalSeguroCuota := Decimal_Cero;
                SET Var_TotalIVASeguroCuota := Decimal_Cero;
            END IF;
        END IF;


		-- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
		CASE Par_PagoCuota
			WHEN PagoSemanal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecSemanal DAY));
			WHEN PagoCatorcenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecCator DAY));
			WHEN PagoQuincenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecQuin DAY));
			WHEN PagoMensual	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas MONTH));
			WHEN PagoPeriodo	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu DAY));
			WHEN PagoBimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*2 MONTH));
			WHEN PagoTrimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*3 MONTH));
			WHEN PagoTetrames	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*4 MONTH));
			WHEN PagoSemestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*6 MONTH));
			WHEN PagoAnual		THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas YEAR));
			WHEN PagoUnico		THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu  DAY));
		END CASE;

        /*Compara el valor de pago de la cuota para asiganrle un valor en dias*/
        CASE Par_PagoCuota
            WHEN PagoSemanal            THEN SET Fre_Dias :=  FrecSemanal;          SET Var_DiasExtra  := Var_FrecExtDiasSemanal;
            WHEN PagoDecenal            THEN SET Fre_Dias :=  FrecDecenal;          SET Var_DiasExtra  := Var_FrecExtDiasDecenal;
            WHEN PagoCatorcenal         THEN SET Fre_Dias :=  FrecCator;            SET Var_DiasExtra  := Var_FrecExtDiasCatorcenal;
            WHEN PagoQuincenal          THEN SET Fre_Dias :=  FrecQuin;             SET Var_DiasExtra  := Var_FrecExtDiasQuincenal;
            WHEN PagoMensual            THEN SET Fre_Dias :=  FrecMensual;          SET Var_DiasExtra  := Var_FrecExtDiasMensual;
            WHEN PagoPeriodo            THEN SET Fre_Dias :=  Par_Frecu;
            WHEN PagoBimestral          THEN SET Fre_Dias :=  FrecBimestral;        SET Var_DiasExtra  := Var_FrecExtDiasBimestral;
            WHEN PagoTrimestral         THEN SET Fre_Dias :=  FrecTrimestral;       SET Var_DiasExtra  := Var_FrecExtDiasTrimestral;
            WHEN PagoTetrames           THEN SET Fre_Dias :=  FrecTetrames;         SET Var_DiasExtra  := Var_FrecExtDiasTetrames;
            WHEN PagoSemestral          THEN SET Fre_Dias :=  FrecSemestral;        SET Var_DiasExtra  := Var_FrecExtDiasSemestral;
            WHEN PagoAnual              THEN SET Fre_Dias :=  FrecAnual;            SET Var_DiasExtra  := Var_FrecExtDiasAnual;
            WHEN PagoUnico              THEN SET Fre_Dias :=  Par_Frecu; SET Var_DiasExtra:= 0;
        END CASE;

		SET  Var_FrecuPago = Fre_Dias;
		        -- ASIGNA EL VALOR QUE LE CORRESPONDE EN FRECUENCIA EN DIAS SEGUN EL TIPO DE PAGO PARA INTERESES
        CASE Par_PagoInter
            WHEN PagoSemanal        THEN SET Fre_DiasInt    :=  FrecSemanal;        SET Var_DiasExtra:= Var_FrecExtDiasSemanal;
            WHEN PagoCatorcenal     THEN SET Fre_DiasInt    :=  FrecCator;          SET Var_DiasExtra:= Var_FrecExtDiasCatorcenal;
            WHEN PagoQuincenal      THEN SET Fre_DiasInt    :=  FrecQuin;           SET Var_DiasExtra:= Var_FrecExtDiasQuincenal;
            WHEN PagoMensual        THEN SET Fre_DiasInt    :=  FrecMensual;        SET Var_DiasExtra:= Var_FrecExtDiasMensual;
            WHEN PagoPeriodo        THEN SET Fre_DiasInt    :=  IFNULL(Par_FrecuInt, Entero_Cero);
            WHEN PagoBimestral      THEN SET Fre_DiasInt    :=  FrecBimestral;      SET Var_DiasExtra:= Var_FrecExtDiasBimestral;
            WHEN PagoTrimestral     THEN SET Fre_DiasInt    :=  FrecTrimestral;     SET Var_DiasExtra:= Var_FrecExtDiasTrimestral;
            WHEN PagoTetrames       THEN SET Fre_DiasInt    :=  FrecTetrames;       SET Var_DiasExtra:= Var_FrecExtDiasTetrames;
            WHEN PagoSemestral      THEN SET Fre_DiasInt    :=  FrecSemestral;      SET Var_DiasExtra:= Var_FrecExtDiasSemestral;
            WHEN PagoAnual          THEN SET Fre_DiasInt    :=  FrecAnual;          SET Var_DiasExtra:= Var_FrecExtDiasAnual;
            WHEN PagoUnico          THEN SET Fre_DiasInt    :=  IFNULL(Par_Frecu, Entero_Cero);	SET Var_DiasExtra:= 0;
        END CASE;

		SET Var_Cuotas:=Par_NumeroCuotas;

		IF(Fre_DiasInt != Entero_Cero)THEN
			SET Var_CuotasInt:=CAST((DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_DiasInt) AS SIGNED);
		ELSE
			SET Var_CuotasInt:=Entero_Cero;
		END IF;

		/***CALCULANDO IVA PARA SEGURO POR CUOTA***/
        IF(Par_CobraIVASeguroCuota = Var_Si) THEN
            SET Var_IVASeguroCuota :=  ROUND(Par_MontoSeguroCuota * Var_IVA,2);
          ELSE
            SET Var_IVASeguroCuota := Decimal_Cero;
        END IF;
         /***CALCULANDO IVA PARA SEGURO POR CUOTA***/

		DROP TABLE IF EXISTS Tmp_Amortizacion;
		DROP TABLE IF EXISTS Tmp_AmortizacionInt;

		-- tabla temporal donde inserta las fechas de pago de capital
		CREATE TEMPORARY TABLE Tmp_Amortizacion(
			Tmp_Consecutivo	INT,
			Tmp_Dias		INT,
			Tmp_FecIni		DATE,
			Tmp_FecFin		DATE,
			Tmp_FecVig		DATE,
			Tmp_Capital		DECIMAL(12,2),
			Tmp_Interes		DECIMAL(12,4),
			Tmp_iva			DECIMAL(12,4),
			Tmp_SubTotal	DECIMAL(12,2),
			Tmp_Insoluto	DECIMAL(12,2),
			Tmp_CapInt		CHAR(1),
			Tmp_InteresAco 	DECIMAL(12,2),
		    PRIMARY KEY  (Tmp_Consecutivo));

		-- tabla temporal donde inserta las fechas de pago de intereses
		CREATE TEMPORARY TABLE Tmp_AmortizacionInt(
			Tmp_Consecutivo	INT,
			Tmp_Dias		INT,
			Tmp_FecIni		DATE,
			Tmp_FecFin		DATE,
			Tmp_FecVig		DATE,
			Tmp_Capital		DECIMAL(12,2),
			Tmp_Interes		DECIMAL(12,4),
			Tmp_iva			DECIMAL(12,4),
			Tmp_SubTotal	DECIMAL(12,2),
			Tmp_Insoluto	DECIMAL(12,2),
			Tmp_CapInt		CHAR(1),
			Tmp_InteresAco 	DECIMAL(12,2),
		    PRIMARY KEY  (Tmp_Consecutivo));


		-- -- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE CAPITAL
		WHILE (Contador <= Var_Cuotas) DO
			-- pagos quincenales
			IF (Par_PagoCuota = PagoQuincenal) THEN
				IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) = FrecQuin) THEN
					SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
				ELSE
					IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
						SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
											CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					ELSE
						SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinal <= FechaInicio) THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						END	IF;
					END IF;
				END IF;
			ELSE
				-- Pagos Mensuales
				IF (Par_PagoCuota = PagoMensual) THEN
						-- Para pagos que se haran cada 30 dias
						IF (Par_PagoFinAni != PagoFinMes) THEN
								IF(Par_DiaMesCap>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

										ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
						ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									/* se obtiene el final del mes.*/
									SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
								END IF;
						END IF;

				ELSE
					IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
						SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
					ELSE
						IF (Par_PagoCuota = PagoBimestral ) THEN
							IF (Par_PagoFinAni != PagoFinMes ) THEN
								IF(Par_DiaMesCap>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesCap)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran en fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
										SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
										SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
									ELSE
										SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
									END IF;
								END IF;
							END IF;
						ELSE
							IF (Par_PagoCuota = PagoTrimestral ) THEN
								-- Para pagos que se haran cada 90 dias
								IF (Par_PagoFinAni != PagoFinMes) THEN
		--
									IF(Par_DiaMesCap>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesCap)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
		--
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
											SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
											SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
										END IF;
									END IF;
								END IF;

							ELSE
								IF (Par_PagoCuota = PagoTetrames ) THEN
									-- Para pagos que se haran cada 120 dias
									IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMesCap>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
												SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;

								ELSE
									IF (Par_PagoCuota = PagoSemestral ) THEN
										-- Para pagos que se haran cada 180 dias
										IF (Par_PagoFinAni != PagoFinMes) THEN
											IF(Par_DiaMesCap>28)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesCap)THEN
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

												ELSE
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												END IF;
											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;

										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAni = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
													SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
													SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;
									ELSE
										IF (Par_PagoCuota = PagoAnual ) THEN
											-- Para pagos que se haran cada 360 dias
											SET FechaFinal 	:= CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			-- hace un ciclo para comparar los dias de gracia
			WHILE ((CAST(DATEDIFF(FechaVig, FechaInicio) AS SIGNED)*1) <= Var_DiasExtra ) DO
				IF (Par_PagoCuota = PagoQuincenal ) THEN
					IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
						SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
					ELSE
						IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						ELSE
							SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
							IF  (FechaFinal <= FechaInicio) THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							END	IF;
						END IF;
					END IF;
				ELSE
				-- Pagos Mensuales
					IF (Par_PagoCuota = PagoMensual  ) THEN
						IF (Par_PagoFinAni != PagoFinMes) THEN
							IF(Par_DiaMesCap>28)THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesCap)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran cada fin de mes
							IF (Par_PagoFinAni = PagoFinMes) THEN
								IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
									SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
									SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
								ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
									SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
								END IF;
							END IF;
						END IF ;
					ELSE
						IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
							SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
						END IF;
					END IF;
				END IF;
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinal,			Entero_Cero,		FechaVig,			Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
											Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL( FechaFinal,			Entero_Cero,			FechaVig,		Par_EmpresaID,		Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END WHILE;

			/* si el valor de la fecha final es mayoy a la de vencimiento en se ajusta */
			IF (Par_AjustaFecAmo = Var_SI)THEN
				IF (Par_FechaVenc <=  FechaFinal) THEN
					SET FechaFinal 	:= Par_FechaVenc;
				END IF;
				IF (Contador = Var_Cuotas )THEN
					SET FechaFinal 	:= Par_FechaVenc;
				END IF;
			END IF;

			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			/* valida si se ajusta a fecha de exigibilidad o no*/
			IF (Par_AjusFecExiVen= Var_SI)THEN
				SET FechaFinal:= FechaVig;
			END IF;

			SET CapInt:= Var_Capital;

			SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1
							FROM Tmp_Amortizacion);

			SET Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

			INSERT INTO Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
							VALUES	(	Consecutivo,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);
			SET FechaInicio := FechaFinal;/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
			IF (Par_AjustaFecAmo = Var_SI)THEN
				IF (Par_FechaVenc <=  FechaFinal) THEN
					SET Contador 	:= Var_Cuotas+1;
				END IF;
			END IF;

			IF((Contador+1) = Var_Cuotas )THEN

				#Ajuste Saldo
				-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
				IF (Par_AjustaFecAmo = Var_SI)THEN
					SET FechaFinal 	:= Par_FechaVenc;
				ELSE
					-- pagos quincenales
					IF (Par_PagoCuota = PagoQuincenal) THEN
						IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) = FrecQuin) THEN
							SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
						ELSE
							IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							ELSE
								SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
								IF  (FechaFinal <= FechaInicio) THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								END	IF;
							END IF;
						END IF;
					ELSE 		-- Pagos Mensuales
						IF (Par_PagoCuota = PagoMensual) THEN
							-- Para pagos que se haran cada 30 dias
							IF (Par_PagoFinAni != PagoFinMes) THEN
								IF(Par_DiaMesCap>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesCap)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
										SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 2 MONTH),CHAR(12));
										SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
									ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
										SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
									END IF;
								END IF;
							END IF;
						ELSE
							IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
								SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
							ELSE
								IF (Par_PagoCuota = PagoBimestral ) THEN
									IF (Par_PagoFinAni != PagoFinMes ) THEN
										IF(Par_DiaMesCap>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
												SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoCuota = PagoTrimestral ) THEN
										-- Para pagos que se haran cada 90 dias
										IF (Par_PagoFinAni != PagoFinMes) THEN
											IF(Par_DiaMesCap>28)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesCap)THEN
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												END IF;
											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAni = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
													SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
													SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;

									ELSE
										IF (Par_PagoCuota = PagoTetrames ) THEN
											-- Para pagos que se haran cada 120 dias
											IF (Par_PagoFinAni != PagoFinMes) THEN
												IF(Par_DiaMesCap>28)THEN
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesCap)THEN
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

													ELSE
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
													END IF;
												ELSE
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												END IF;
											ELSE
												-- Para pagos que se haran en fin de mes
												IF (Par_PagoFinAni = PagoFinMes) THEN
													IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
														SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
														SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;

										ELSE
											IF (Par_PagoCuota = PagoSemestral ) THEN
												-- Para pagos que se haran cada 180 dias
												IF (Par_PagoFinAni != PagoFinMes) THEN
													IF(Par_DiaMesCap>28)THEN
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
														SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
														IF(Var_UltDia < Par_DiaMesCap)THEN
															SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

														ELSE
															SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
														END IF;
													ELSE
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
													END IF;
												ELSE
													-- Para pagos que se haran en fin de mes
													IF (Par_PagoFinAni = PagoFinMes) THEN
														IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
															SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
															SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
														ELSE
															SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
														END IF;
													END IF;
												END IF;

											ELSE
												IF (Par_PagoCuota = PagoAnual ) THEN
													-- Para pagos que se haran cada 360 dias
													SET FechaFinal 	:= CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
												END IF;
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;

					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
											Aud_NumTransaccion);
					ELSE
						CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
					END IF;
					-- hace un ciclo para comparar los dias de gracia
					WHILE ((DATEDIFF(FechaVig, FechaInicio)*1) <= Var_DiasExtra ) DO
						IF (Par_PagoCuota = PagoQuincenal ) THEN
							IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
								SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
							ELSE
								IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								ELSE
									SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
									IF  (FechaFinal <= FechaInicio) THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
									END	IF;
								END IF;
							END IF;
						ELSE
						-- Pagos Mensuales
							IF (Par_PagoCuota = PagoMensual  ) THEN
								IF (Par_PagoFinAni != PagoFinMes) THEN
									IF(Par_DiaMesCap>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesCap)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran cada fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
											SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
											SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
										ELSE
										-- si no indica que es un numero menor y se obtiene el final del mes.
											SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
										END IF;
									END IF;
								END IF ;
							ELSE
								IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
									SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
								END IF;
							END IF;
						END IF;

						IF(Par_DiaHabilSig = Var_SI) THEN
							CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
												Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
												Aud_NumTransaccion);

						ELSE
							CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
					END WHILE;
				END IF;

				-- Obtiene el dia habil siguiente o anterior
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);

				ELSE
					CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
				/* valida si se ajusta a fecha de exigibilidad o no*/
				IF (Par_AjusFecExiVen= Var_SI)THEN
					SET FechaFinal:= FechaVig;
				END IF;
				SET CapInt:= Var_Capital;
				SET Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

				INSERT INTO Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
							VALUES	(	Consecutivo+1,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
				IF (Par_AjustaFecAmo = Var_SI)THEN
					IF (Par_FechaVenc <=  FechaFinal) THEN
						SET Contador 	:= Var_Cuotas+1;
					END IF;
				END IF;
				SET Contador = Contador+1;
			END IF;
			SET Contador = Contador+1;
		END WHILE;







		-- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE LOS INTERESES
		WHILE (ContadorInt <= Var_CuotasInt ) DO

			-- pagos quincenales
			IF (Par_PagoInter = PagoQuincenal) THEN
				IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) = FrecQuin) THEN
					SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
				ELSE
					IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
						SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
											CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					ELSE
						SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinalInt <= FechaInicioInt) THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						END	IF;
					END IF;
				END IF;
			ELSE
				-- Pagos Mensuales
				IF (Par_PagoInter = PagoMensual) THEN
					-- Para pagos que se haran cada 30 dias de Intereses
					IF (Par_PagoFinAniInt != PagoFinMes) THEN
						IF(Par_DiaMesInt>28)THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
							SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
							IF(Var_UltDia < Par_DiaMesInt)THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
							ELSE
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
							END IF;
						ELSE
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
						END IF;

					ELSE
						-- Para pagos que se haran cada fin de mes
						IF (Par_PagoFinAniInt = PagoFinMes) THEN
							/* obtiene el final del mes.*/
							SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
						END IF;
					END IF;
				ELSE
					IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
						SET FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
					ELSE
						IF ( Par_PagoInter = PagoBimestral) THEN
							-- Para pagos que se haran cada 60 dias Intereses
							IF (Par_PagoFinAniInt != PagoFinMes ) THEN
								IF(Par_DiaMesInt>28)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesInt)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran en fin de mes
								IF (Par_PagoFinAniInt = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
									ELSE
										SET FechaFinalInt	:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
									END IF;
								END IF;
							END IF;
						ELSE
							IF (Par_PagoInter = PagoTrimestral) THEN
								-- Para pagos que se haran cada 90 dias IntereseS
								IF (Par_PagoFinAniInt != PagoFinMes) THEN
									IF(Par_DiaMesInt>28)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesInt)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAniInt = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
										END IF;

									END IF;
								END IF;

							ELSE
								IF ( Par_PagoInter = PagoTetrames) THEN
									-- Para pagos que se haran cada 120 dias interes
									IF (Par_PagoFinAniInt != PagoFinMes) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAniInt = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoInter = PagoSemestral) THEN
										-- Para pagos que se haran cada 180 dias Interes
										IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesInt)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAniInt = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;
									ELSE
										IF ( Par_PagoInter = PagoAnual) THEN
											-- Para pagos que se haran cada 360 diasInteres
											SET FechaFinalInt	:= CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF(Par_DiaHabilSig = Var_SI) THEN

				CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);

			ELSE
				CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			-- hace un ciclo para comparar los dias de gracia
			WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_DiasExtra ) DO
				IF (Par_PagoInter = PagoQuincenal ) THEN
					IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
						SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
					ELSE
						IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						ELSE
							SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
							IF  (FechaFinalInt <= FechaInicioInt) THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							END	IF;
						END IF;
					END IF;
				ELSE
				-- Pagos Mensuales
					IF (Par_PagoInter = PagoMensual  ) THEN
						IF (Par_PagoFinAniInt != PagoFinMes) THEN
							IF(Par_DiaMesInt>28)THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesInt)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran cada fin de mes
							IF (Par_PagoFinAniInt = PagoFinMes) THEN
								IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
								ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
									SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
								END IF;
							END IF;
						END IF ;
					ELSE
						IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
							SET FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
						END IF;
					END IF;
				END IF;
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END WHILE;
			/*si la fecha final es mayor a la de vencimiento se ajusta */
			IF (Par_AjustaFecAmo = Var_SI)THEN
				IF (Par_FechaVenc <=  FechaFinalInt) THEN
					SET ContadorInt = Var_CuotasInt+1;
					SET FechaFinalInt 	:= Par_FechaVenc;
				END IF;
				IF (ContadorInt = Var_CuotasInt )THEN
					SET FechaFinalInt 	:= Par_FechaVenc;
				END IF;
			END IF;

			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			/* valida si se ajusta a fecha de exigibilidad o no*/
			IF (Par_AjusFecExiVen= Var_SI)THEN
				SET FechaFinalInt:= FechaVig;
			END IF;
			SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1 FROM Tmp_AmortizacionInt);
			SET CapInt:= Var_Interes;
			SET Fre_DiasIntTab		:= (DATEDIFF(FechaFinalInt,FechaInicioInt));

			INSERT INTO Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
							VALUES	(	Consecutivo,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab, CapInt);

			SET FechaInicioInt := FechaFinalInt;

			IF( (ContadorInt+1) = Var_CuotasInt )THEN
				#Ajuste Saldo
				-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
				IF (Par_AjustaFecAmo = Var_SI)THEN
					SET FechaFinalInt	:= Par_FechaVenc;
				ELSE
					-- pagos quincenales
					IF (Par_PagoInter = PagoQuincenal) THEN
						IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) = FrecQuin) THEN
							SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
						ELSE
							IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							ELSE
								SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
								IF  (FechaFinalInt <= FechaInicioInt) THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								END	IF;
							END IF;
						END IF;
					ELSE
						-- Pagos Mensuales
						IF (Par_PagoInter = PagoMensual) THEN
							-- Para pagos que se haran cada 30 dias de Intereses
							IF (Par_PagoFinAniInt != PagoFinMes) THEN
								IF(Par_DiaMesInt>28)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesInt)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAniInt = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH),CHAR(12));
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
									ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
										SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
									END IF;
								END IF;
							END IF;
						ELSE
							IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico) THEN
								SET FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
							ELSE
								IF ( Par_PagoInter = PagoBimestral) THEN
									-- Para pagos que se haran cada 60 dias Intereses
									IF (Par_PagoFinAniInt != PagoFinMes ) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAniInt = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinalInt	:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoInter = PagoTrimestral) THEN
										-- Para pagos que se haran cada 90 dias IntereseS
										IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesInt)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAniInt = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;

									ELSE
										IF ( Par_PagoInter = PagoTetrames) THEN
											-- Para pagos que se haran cada 120 dias interes
											IF (Par_PagoFinAniInt != PagoFinMes) THEN
												IF(Par_DiaMesInt>28)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesInt)THEN
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

													ELSE
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												-- Para pagos que se haran en fin de mes
												IF (Par_PagoFinAniInt = PagoFinMes) THEN
													IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;
										ELSE
											IF (Par_PagoInter = PagoSemestral) THEN
												-- Para pagos que se haran cada 180 dias Interes
												IF (Par_PagoFinAniInt != PagoFinMes) THEN
													IF(Par_DiaMesInt>28)THEN
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
														SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
														IF(Var_UltDia < Par_DiaMesInt)THEN
															SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

														ELSE
															SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
														END IF;
													ELSE
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
													-- Para pagos que se haran en fin de mes
													IF (Par_PagoFinAniInt = PagoFinMes) THEN
														IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
															SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
														ELSE
															SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
														END IF;
													END IF;
												END IF;
											ELSE
												IF ( Par_PagoInter = PagoAnual) THEN
													-- Para pagos que se haran cada 360 diasInteres
													SET FechaFinalInt	:= CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
												END IF;
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;

					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
											Aud_NumTransaccion);

					ELSE
						CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
					END IF;


			-- hace un ciclo para comparar los dias de gracia
			WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_DiasExtra ) DO

						IF (Par_PagoInter = PagoQuincenal ) THEN
							IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
								SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
							ELSE
								IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								ELSE
									SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
									IF  (FechaFinalInt <= FechaInicioInt) THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
									END	IF;
								END IF;
							END IF;
						ELSE
						-- Pagos Mensuales
							IF (Par_PagoInter = PagoMensual  ) THEN
									IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																			 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesCap)THEN
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																			 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

													ELSE
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																			 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
											ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
																		 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
									ELSE
											-- Para pagos que se haran cada fin de mes
											IF (Par_PagoFinAniInt = PagoFinMes) THEN
													IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
													ELSE
													-- si no indica que es un numero menor y se obtiene el final del mes.
														SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
													END IF;
											END IF;
									END IF ;
							ELSE
								IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoInter = PagoUnico ) THEN
										SET FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
								ELSE --  kzo;
										# Pagos biemestral
										IF ( Par_PagoInter = PagoBimestral) THEN
											-- Para pagos que se haran cada 60 dias Intereses
												IF (Par_PagoFinAniInt != PagoFinMes ) THEN
														IF(Par_DiaMesInt>28)THEN
																SET FechaFinalInt := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
																SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
																IF(Var_UltDia < Par_DiaMesInt)THEN
																	SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

																ELSE
																	SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
																END IF;
														ELSE
																SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
														END IF;
												ELSE
													-- Para pagos que se haran en fin de mes
													IF (Par_PagoFinAniInt = PagoFinMes) THEN
															IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
																SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
																SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
															ELSE
																SET FechaFinalInt	:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
															END IF;
													END IF;
											END	IF;

										ELSE
												IF (Par_PagoInter = PagoTrimestral) THEN
													-- Para pagos que se haran cada 90 dias IntereseS
													IF (Par_PagoFinAniInt != PagoFinMes) THEN
															IF(Par_DiaMesInt>28)THEN
																	SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
																	SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
																	IF(Var_UltDia < Par_DiaMesInt)THEN
																			SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

																	ELSE
																			SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																				CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
																	END IF;
															ELSE
																	SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
																			CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
															END IF;

														-- Para pagos que se haran en fin de mes
														ELSE
																IF (Par_PagoFinAniInt = PagoFinMes) THEN
																	IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
																		SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
																		SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
																	ELSE
																		SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
																	END IF;
															END IF;
													END IF;
												END IF; -- fin trimestral
										END IF; -- fin bimestral
								END IF;
							END IF;
						END IF;

						IF(Par_DiaHabilSig = Var_SI) THEN

							CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
															Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
															Aud_NumTransaccion);
						ELSE
							CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
												Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
			-- 		end if;
					END WHILE;

				END IF;

				-- Obtiene el dia habil siguiente o anterior
				IF(Par_DiaHabilSig = Var_SI) THEN

					CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				SET CapInt:= Var_Interes;
				/* valida si se ajusta a fecha de exigibilidad o no*/
				IF (Par_AjusFecExiVen= Var_SI)THEN
					SET FechaFinalInt:= FechaVig;
				END IF;
				SET Fre_DiasIntTab	:= (DATEDIFF(FechaFinalInt,FechaInicioInt));
				INSERT INTO Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
							VALUES	(	Consecutivo+1,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab,	CapInt);
				SET ContadorInt = ContadorInt+1;
			END IF;
			SET ContadorInt = ContadorInt+1;
		END WHILE;

		-- INICIALIZO VARIABLES DE CONTROL
		SET Contador := 1;
		SET ContadorCap := 1;
		SET ContadorInt := 1;
		SET Consecutivo := 1;

		-- COMPARO EL NUMERO DE LAS CUOTAS PARA SABER CUAL ES LA MAYOR
		IF (Var_Cuotas >= Var_CuotasInt) THEN
			SET Var_Amor := Var_Cuotas;
		ELSE
			SET Var_Amor := Var_CuotasInt;
		END IF;





		SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicio, FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = Contador;
		SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicioInt, FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

		-- INICIO UN CICLO PARA REACOMODAR LAS FECHAS PARA GENERAR UN CALENDARIO PARA MOSTRAR AL CLIENTE
		WHILE (Contador <= Var_Amor) DO
			IF (FechaFinal<FechaFinalInt)THEN
					SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

					IF (ContadorInt = Var_CuotasInt)THEN
							SET Var_TipoCap	:= Var_CapInt;
					ELSE
							SET Var_TipoCap	:= Var_Capital;
					END IF;

					INSERT INTO TMPPAGAMORSIM (
							Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt,			NumTransaccion)
					SELECT	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Var_TipoCap,		Aud_NumTransaccion
					FROM	Tmp_Amortizacion
					WHERE Tmp_Consecutivo = ContadorCap;

					SET FechaInicio := FechaFinal;

					IF (ContadorInt <= Var_CuotasInt)THEN
						IF (ContadorInt>1)THEN SET ContadorInt := ContadorInt-1;ELSE SET ContadorInt :=0 ; END IF;
					END IF;
			ELSE
				IF (FechaFinal=FechaFinalInt)THEN
						SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

						INSERT INTO TMPPAGAMORSIM (
								Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,			NumTransaccion)
						SELECT	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,			Aud_NumTransaccion
						FROM	Tmp_Amortizacion
						WHERE Tmp_Consecutivo = ContadorCap;
						SET FechaInicio := FechaFinal;
				ELSE
					IF (FechaFinal> FechaFinalInt)THEN

							SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
							IF (ContadorInt = Var_CuotasInt)THEN
								SET Var_TipoCap	:= Var_CapInt;
							ELSE
								SET Var_TipoCap	:= Var_Interes;
							END IF;

							INSERT INTO TMPPAGAMORSIM (
									Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,			NumTransaccion)
							SELECT 	Consecutivo,		Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									-- case  when Contador+1 > Var_Amor then Var_CapInt else Tmp_CapInt end ,			Aud_NumTransaccion
									Tmp_CapInt ,		Aud_NumTransaccion
							FROM	Tmp_AmortizacionInt
							WHERE	Tmp_Consecutivo = ContadorInt;

							IF (ContadorCap <= Var_Cuotas)THEN
								IF (ContadorCap>1)THEN SET ContadorCap := ContadorCap-1;ELSE SET ContadorCap :=0 ; END IF;
							END IF;
							SET FechaInicio := FechaFinalInt;
					END IF;
				END IF;
			END IF;



			SET Contador := Contador+1;
			SET ContadorCap := ContadorCap+1;
			SET ContadorInt := ContadorInt+1;
			SET Consecutivo := Consecutivo+1;

			IF (Contador>Var_Amor) THEN
				IF (ContadorCap < Var_Cuotas) THEN
					SET Contador:= ContadorCap;
				ELSE IF (ContadorInt < Var_CuotasInt) THEN
						SET Contador:= ContadorInt;
					END IF;
				END IF;
			END IF;

			IF (ContadorCap <= Var_Cuotas) THEN
				SELECT Tmp_FecFin INTO  FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
				ELSE SET FechaFinal:= '2100-12-31';
			END IF;
			IF (ContadorInt <= Var_CuotasInt)THEN
				SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
			ELSE
				SET FechaFinalInt:= '2100-12-31';
			END IF;
		END WHILE;







		-- AJUSTE DE FECHAS, INSERTA EL ULTIMO REGISTRO DE LA TABLA.
		IF (ContadorCap = Var_Cuotas) THEN /* si el contador de capital es = al numero de cuotas consideradas */
			IF(ContadorInt = Var_CuotasInt) THEN /* si el contador de interes  es = al numero de cuotas de interes  consideradas */
				SELECT  Tmp_FecFin INTO FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo =ContadorCap;
				SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

				IF (FechaFinal<FechaFinalInt)THEN/* si la fecha final  de capital es menor que la de  interes  */
					SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
						SELECT Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,	Aud_NumTransaccion
							FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
					SET FechaInicio := FechaFinal;
					SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
					SET Consecutivo := Consecutivo+1;
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt, 		NumTransaccion)
								SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
										Var_CapInt,	Aud_NumTransaccion
									FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
				ELSE /* si la fecha final  de capital no  es menor que la de  interes  */
					IF (FechaFinal=FechaFinalInt)THEN
						SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
						INSERT INTO 	TMPPAGAMORSIM (	Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
													Tmp_CapInt,		NumTransaccion)
							SELECT	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
						SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
						SET FechaInicio := FechaFinal;
						SET Consecutivo := Consecutivo+1;
						INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
												Tmp_CapInt,		NumTransaccion)
									SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
											Var_CapInt,	Aud_NumTransaccion
										FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
					END IF;
				END IF; /* fin de si la fecha final  de capital es menor que la de  interes  */

				IF (FechaFinal> FechaFinalInt)THEN
					SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
								SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
										Var_CapInt,	Aud_NumTransaccion
									FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
					SET FechaInicio := FechaFinal;
					SET Consecutivo := Consecutivo+1;
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
									SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
											Var_CapInt,	Aud_NumTransaccion
										FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
				END IF;
			ELSE /* si el contador de interes  no es igual al numero de cuotas de interes  consideradas */
				SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
					SELECT Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Var_CapInt,	Aud_NumTransaccion
						FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
				SET FechaInicio := FechaFinal;
			END IF;
		ELSE
			IF(ContadorInt = Var_CuotasInt) THEN
				SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
								SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
										Var_CapInt,	Aud_NumTransaccion
									FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
			END IF;

		END IF;
		-- se determina cual es la fecha de vencimiento
		SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE 	NumTransaccion = Aud_NumTransaccion);
		SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
		SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);

		IF (Var_CuotasInt > Var_Cuotas) THEN
			SELECT MAX(Tmp_Consecutivo) INTO Var_Amor
				FROM TMPPAGAMORSIM WHERE 	NumTransaccion = Aud_NumTransaccion;
			DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion AND Tmp_Consecutivo = Var_Amor
				AND Tmp_CapInt = Var_Interes;
			SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE 	NumTransaccion = Aud_NumTransaccion);
			SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
			SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
		END IF;

		/*se actualiza el numero de cuotas de capital y de interes */
		UPDATE TMPPAGAMORSIM SET
			Tmp_CuotasCap	= Var_Cuotas,
			Tmp_CuotasInt	= Var_CuotasInt,
			Tmp_MontoSeguroCuota = Par_MontoSeguroCuota,
			Tmp_IVASeguroCuota = Var_IVASeguroCuota
		WHERE NumTransaccion = Aud_NumTransaccion;


		IF(Var_CobraAccesoriosGen = Var_SI AND Var_CobraAccesorios = Var_SI) THEN

			SELECT		SolicitudCreditoID,		CreditoID,		PlazoID
				INTO	Var_SolicitudCreditoID,	Var_CreditoID,	Var_PlazoID
				FROM DETALLEACCESORIOS
				WHERE NumTransacSim = Aud_NumTransaccion
                AND MontoAccesorio = Decimal_Cero LIMIT 1;

			SET Var_SolicitudCreditoID 	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
			SET Var_CreditoID 			:= IFNULL(Var_CreditoID, Entero_Cero);
			SET Var_PlazoID 			:= IFNULL(Var_PlazoID, Entero_Cero);


			# SE DAN DE ALTA LOS ACCESORIOS COBRADOS POR EL CREDITO PARA GRABARLOS DEFINITIVAMENTE
			CALL DETALLEACCESORIOSALT(
				Var_CreditoID,				Var_SolicitudCreditoID, 	Par_ProducCreditoID,	Par_ClienteID,		Aud_NumTransaccion,
				Var_PlazoID,				OperaSimulador,				Par_Monto,				Entero_Cero,		Var_No,
				Par_NumErr,					Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			# SE CALCULA EL VALOR DE LAS COMISIONES COBRADAS POR EL CREDITO
			CALL CALCOTRASCOMISIONESPRO(
				Aud_NumTransaccion,		Par_ClienteID,		Par_ProducCreditoID,		Par_Monto,			Entero_Cero,
				Var_No,					Par_NumErr,			Par_ErrMen,					Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

	    SELECT SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota),	SUM(Tmp_OtrasComisiones),	SUM(Tmp_IVAOtrasComisiones)
	        INTO Var_TotalSeguroCuota, Var_TotalIVASeguroCuota,		Var_SaldoOtrasComisiones,	Var_SaldoIVAOtrasComisiones
	        FROM TMPPAGAMORSIM
	        WHERE   NumTransaccion = Aud_NumTransaccion;

        SET Var_TotalSeguroCuota 		:= IFNULL(Var_TotalSeguroCuota,Decimal_Cero);
        SET Var_TotalIVASeguroCuota 	:= IFNULL(Var_TotalIVASeguroCuota, Decimal_Cero);
		SET Var_SaldoOtrasComisiones 	:= IFNULL(Var_SaldoOtrasComisiones, Decimal_Cero);
        SET Var_SaldoIVAOtrasComisiones 	:= IFNULL(Var_SaldoIVAOtrasComisiones, Decimal_Cero);

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= 'Cuotas generadas';
		SET Par_NumTran	:= Aud_NumTransaccion;
		SET Par_MontoCuo	:= Entero_Cero;
		SET Par_FechaVen	:= Par_FechaVenc;

		 DROP TABLE Tmp_Amortizacion;
		 DROP TABLE Tmp_AmortizacionInt;
    END ManejoErrores;
    IF (Par_Salida = Salida_SI) THEN
        IF(Par_NumErr = Entero_Cero) THEN
			SELECT	Tmp_Consecutivo,	Tmp_FecIni,			Tmp_FecFin,			Tmp_FecVig,			Tmp_Capital,
				Tmp_Interes,		Tmp_Iva,			Tmp_SubTotal,		Tmp_Insoluto,		Tmp_Dias,
				Tmp_CapInt,			Tmp_CuotasCap,		Tmp_CuotasInt,		NumTransaccion,		Par_FechaVenc,
				Par_FechaInicio,	Entero_Cero AS MontoCuota,
				Par_CobraSeguroCuota AS CobraSeguroCuota,
				FORMAT(Tmp_MontoSeguroCuota,2) AS MontoSeguroCuota,
                FORMAT(Tmp_IVASeguroCuota,2) AS IVASeguroCuota,
                Var_TotalSeguroCuota AS TotalSeguroCuota,
                Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
				Tmp_OtrasComisiones	AS OtrasComisiones,
				Tmp_IVAOtrasComisiones	AS IVAOtrasComisiones,
                Var_SaldoOtrasComisiones AS TotalOtrasComisiones,
                Var_SaldoIVAOtrasComisiones AS TotalIVAOtrasComisiones,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen
				FROM	TMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion;
          ELSE
			SELECT
				Entero_Cero  AS Tmp_Consecutivo,
				Cadena_Vacia AS Tmp_FecIni,
				Cadena_Vacia AS Tmp_FecFin,
				Cadena_Vacia AS Tmp_FecVig,
				Entero_Cero  AS Tmp_Capital,
				Entero_Cero  AS Tmp_Interes,
				Entero_Cero  AS Tmp_Iva,
				Entero_Cero  AS Tmp_SubTotal,
				Entero_Cero  AS Tmp_Insoluto,
				Entero_Cero  AS Tmp_Dias,
				Entero_Cero  AS Tmp_CapInt,
				Entero_Cero  AS Tmp_CuotasCap,
				Entero_Cero  AS Tmp_CuotasInt,
				Entero_Cero  AS NumTransaccion,
				Cadena_Vacia AS Par_FechaVenc,
				Cadena_Vacia AS Par_FechaInicio,
				Entero_Cero AS MontoCuota,
				Cadena_Vacia AS CobraSeguroCuota,
				Entero_Cero AS MontoSeguroCuota,
                Entero_Cero  AS IVASeguroCuota,
                Entero_Cero  AS TotalSeguroCuota,
                Entero_Cero  AS TotalIVASeguroCuota,
				Entero_Cero	AS OtrasComisiones,
				Entero_Cero AS IVAOtrasComisiones,
				Entero_Cero AS TotalOtrasComisiones,
				Entero_Cero AS TotalIVAOtrasComisiones,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen;
        END IF;
    END IF;
END TerminaStore$$