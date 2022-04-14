-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOAGROACT`;
DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOAGROACT`(
/* SP QUE RECALCULA LOS INTERESES DE LOS CREDITOS AGRO EN PAGOS LIBRES */

    Par_CreditoID     	BIGINT(12),		# Numero de Credito
    Par_TipoAct			INT(11),		# Tipo de Actualizacion
	Par_TipoCalculoInteres	CHAR(1),	# Tipo de Calculo de interes P:FechaPactada: R:FechaReal
    Par_Salida        	CHAR(1),  		# Salida
	INOUT Par_NumErr	INT(11),		# Numero de error
	INOUT Par_ErrMen	VARCHAR(400),	# Mensaje de Error

    /*Parametros de Auditoria*/
    Par_EmpresaID     	INT(11),
	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CreditoID      		BIGINT(12);
	DECLARE Var_AmortizacionID  	INT(11);
	DECLARE Var_SaldoCapVigente 	DECIMAL(14,4);
	DECLARE Var_SaldoCapVenNExi 	DECIMAL(14,4);
	DECLARE Var_FechaInicio     	DATE;
	DECLARE Var_FechaVencim     	DATE;
	DECLARE Var_FechaExigible   	DATE;
	DECLARE Var_AmoEstatus      	CHAR(1);
	DECLARE Var_SaldoInteresPro		DECIMAL(14,4);
	DECLARE	Var_SaldoIntNoConta		DECIMAL(14,4);
	DECLARE Var_ProvisionAcum   	DECIMAL(14,4);
	DECLARE Var_MonedaID        	INT(11);
	DECLARE Var_CalInteresID    	INT(11);
	DECLARE Var_Dias            	INT(11);
	DECLARE Var_TotCapital      	DECIMAL(14,4);
	DECLARE Var_Interes         	DECIMAL(14,4);
	DECLARE Var_IvaInt	        	DECIMAL(10,2);
	DECLARE Var_CreTasa         	DECIMAL(14,4);
	DECLARE Var_DiasCredito     	INT(11);
	DECLARE Var_ValIVAIntOr 		DECIMAL(14,4);
	DECLARE Var_SaldoCapital 		DECIMAL(14,4);
	DECLARE Insoluto		 		DECIMAL(14,4);
	DECLARE Var_FechaSistema    	DATE;
	DECLARE Var_SucCliente     	 	INT(11);
	DECLARE Var_IVAIntOrd   		CHAR(1);
	DECLARE Var_IVASucurs   		DECIMAL(8,4);
	DECLARE Var_CliPagIVA   		CHAR(1);
	DECLARE Var_TipoCalInteres		INT(11);
	DECLARE Var_Cuotas				INT(11);

	DECLARE Var_FechaCorte			DATE;
	DECLARE Var_FechaMinistrado		DATE;
	DECLARE Var_FechaFinMes			DATE;			# Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
	DECLARE Var_FechaInicioMes		DATE;			# Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
	DECLARE Var_InteresAcumulado 	DECIMAL(18,2);	# Interes Acumulado
	DECLARE Var_MontoPendDesem		DECIMAL(18,2);	# Monto pendiente por desembolsar
	DECLARE Var_InteresIdeal		DECIMAL(14,2);	# Interese del Calendario ideal
    DECLARE Var_InteresInd			DECIMAL(14,2);	# Interes Individual
    DECLARE Var_MontoMinistrado		DECIMAL(14,2);	# Monto Ministrado
    DECLARE Var_SaldInsolAnt		DECIMAL(18,2);	# Saldo Insoluto
	DECLARE Var_FechaVencMinis		DATE;			# Fecha de Vencimiento(Fecha del Sistema.)
    DECLARE Var_ProdCreID       	INT(11);
	DECLARE Var_ClasifCre       	CHAR(1);
    DECLARE Var_SubClasifID 		INT(11);
    DECLARE Var_Poliza     			BIGINT;			# Numero de Poliza
    DECLARE Mov_AboConta    		INT(11);
	DECLARE Mov_CarConta    		INT(11);
	DECLARE Mov_CarOpera    		INT(11);
	DECLARE Par_Consecutivo 		BIGINT;
    DECLARE Var_Estatus				CHAR(1);		# Estatus del Credito
    DECLARE Var_SucursalCred		INT(11);		# Sucursal Credito
    DECLARE Var_InteresAcumAnt		DECIMAL(18,2);	# Interes acumulado anterior
    DECLARE Var_IntAcumMesAnt		DECIMAL(18,2);	# Interes acumulado mes anterior
    DECLARE Var_FechMinisReal		DATE;			# Fecha real de la ministracionm
    DECLARE Var_NumAmortMinis		INT(11);		# Numero de la ultima amortizacion ministrada
    DECLARE Var_EstatusAmor			CHAR(1);		# Esatus de la amortizacion
   	DECLARE Var_InteresAtraAcum   	DECIMAL(14,4);  # Interes atrasado acumulado
    DECLARE Var_NuevoIntProv		DECIMAL(14,2);	# Nuevo Interes Provision despues de la actualizacion
	DECLARE Var_InteresRefinanciar	DECIMAL(18,2);	# Interes a Refinanciar(Meses anteriores)
    DECLARE Var_InteresAcumuladoR	DECIMAL(18,2);	# Interes Acumulado Real a la fecha actual
    DECLARE Var_AmortizacionPrep	INT(11);
	DECLARE Var_NumAmortVig			INT(11);		# Numero de la Amortizacion en Curso

	 -- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT(11);
	DECLARE Decimal_Cero    		DECIMAL(14,4);
	DECLARE SiPagaIVA       		CHAR(1);
	DECLARE SalidaSI        		CHAR(1);
	DECLARE SalidaNO        		CHAR(1);
	DECLARE Esta_Pagado     		CHAR(1);
	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Esta_Vencido    		CHAR(1);
	DECLARE Esta_Vigente    		CHAR(1);
	DECLARE Esta_Atrasado			CHAR(1);
    DECLARE Cre_Vencido				CHAR(1);
	DECLARE TipoActInteres			INT(11);
	DECLARE CalculoSalInsol 		INT(11);
	DECLARE CalculoSalGlob  		INT(11);
	DECLARE Tasa_Fija       		INT(11);
	DECLARE Contador				INT(11);
	DECLARE FechaPactada			CHAR(1);
    DECLARE DescMinis				VARCHAR(100);
    DECLARE Ref_GenInt				VARCHAR(100);
    DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE AltaPoliza_SI			CHAR(1);
	DECLARE AltaPolCre_SI   		CHAR(1);
	DECLARE AltaMovCre_SI   		CHAR(1);
	DECLARE AltaMovCre_NO   		CHAR(1);
	DECLARE AltaMovAho_NO   		CHAR(1);
    DECLARE Nat_Cargo       		CHAR(1);
	DECLARE Nat_Abono       		CHAR(1);
    DECLARE Mov_IntPro      		INT(11);
	DECLARE Mov_IntNoConta  		INT(11);
	DECLARE Mov_IntAtras    		INT(11);
    DECLARE Mov_IntVencido 		 	INT(11);
    DECLARE Mov_CapVencido			INT(11);
	DECLARE Con_IntDeven    		INT(11);
	DECLARE Con_IntAtrasado 		INT(11);
	DECLARE Con_IntVencido  		INT(11);
	DECLARE Con_IngreInt    		INT(11);
	DECLARE Con_CueOrdInt   		INT(11);
	DECLARE Con_CorOrdInt   		INT(11);
    DECLARE Est_Inactivo			CHAR(1);




-- Declaracion del Cursor para actualizar los intereses de las amortizaciones
DECLARE CURSORAMOINTERES CURSOR FOR
    SELECT  Amo.CreditoID,      	Amo.AmortizacionID, Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,        Cre.MonedaID,
			Amo.FechaInicio,    	Amo.FechaVencim,    Amo.FechaExigible,      (IFNULL(Amo.SaldoInteresPro, 0.00) + IFNULL(Amo.SaldoIntNoConta, 0.00)) AS Provision,
            Ag.MontoPendDesembolso,	Ag.Interes,			Amo.Estatus,			 (IFNULL(Amo.SaldoInteresAtr, 0.00))
		 FROM AMORTICREDITO Amo
		INNER JOIN AMORTICREDITOAGRO Ag ON Amo.CreditoID = Ag.CreditoID
										AND Amo.AmortizacionID = Ag.AmortizacionID
		INNER JOIN CREDITOS Cre ON Cre.CreditoID =Ag.CreditoID AND Cre.CreditoID =Amo.CreditoID
		  WHERE Cre.CreditoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente  OR Cre.Estatus = Esta_Vencido)
		  AND (Amo.Estatus	  = Esta_Vigente OR Amo.Estatus	  = Esta_Atrasado OR Amo.Estatus	= Esta_Vencido)
         AND (Amo.FechaExigible >= Var_FechaSistema OR Amo.AmortizacionID >= Var_NumAmortMinis)
		ORDER BY FechaExigible;

	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              	-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
	SET Entero_Cero		:= 0;					-- Entero en Cero
	SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
	SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
	SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
	SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
	SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
	SET Esta_Activo     := 'A';             	-- Estatus: Activo
    SET Esta_Atrasado	:= 'A';					-- Estatus: Atrasado
	SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
	SET Esta_Vigente    := 'V';             	-- Estatus del Credito: Vigente
    SET Cre_Vencido		:= 'B';					-- Estatus del Credito Vencido
	SET TipoActInteres	:= 1;             		-- Tipo de Actualizacion: actualiza los intereses
	SET CalculoSalInsol	:= 1;					-- Calculo de Interes por Saldos Insolutos
	SET CalculoSalGlob	:= 2;					-- Calculo de Interes por Saldos Globales (Monto Original)
	SET Tasa_Fija       := 1;					-- CalInteresID para tasa fija
	SET FechaPactada	:= 'P';					-- Fecha pactada: P
    SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
    SET AltaPoliza_SI	:= 'S';					-- Alta de Poliza Contable General: SI
	SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: SI
	SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
    SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
	SET Nat_Abono       := 'A';                 -- Naturaleza de Abono
	SET Mov_IntNoConta  := 13;                  -- Tipo de Movimiento de Credito: Interes Provisionado
    SET Mov_IntAtras    := 11;                  -- Tipo de Movimiento de Credito: Interes Atrasado
	SET Mov_IntVencido  := 12;                  -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_IntPro      := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado

	SET Con_IntDeven    := 19;                  -- Concepto Contable: Interes Devengado
    SET Con_IntAtrasado := 20;                  -- Concepto Contable: Interes Atrasado
	SET Con_IntVencido  := 21;                  -- Concepto Contable: Interes Vencido
	SET Con_IngreInt    := 5;                   -- Concepto Contable: Ingreso por Intereses
	SET Con_CueOrdInt   := 11;                  -- Concepto Contable: Orden Intereses
	SET Con_CorOrdInt   := 12;                  -- Concepto Contable: Correlativa Intereses

    SET DescMinis		:= 'DESEMBOLSO DE CREDITO';	-- Descripcion del proceso Ministracion
	SET Ref_GenInt		:= 'GENERACION INTERES';	-- Decripcion de Generacion de Interes
    SET Est_Inactivo	:= 'I';						-- Estatus Inactivo

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOAGROACT');
		END;

	SELECT 	FechaSistema, 		DiasCredito
	INTO 	Var_FechaSistema, 	Var_DiasCredito
		FROM PARAMETROSSIS;

	IF(IFNULL(Par_TipoAct,Entero_Cero)=TipoActInteres)THEN
		SELECT  Cli.SucursalOrigen,	Cre.TasaFija,			Cre.MonedaID,			Cli.PagaIVA,		Cre.CalcInteresID,
				Pro.TipoCalInteres,	Pro.CobraIVAInteres,	Cre.ProductoCreditoID,  Des.Clasificacion,	Des.SubClasifID,
                Cre.Estatus,		Cre.SucursalID,			InteresAcumulado,		Cre.InteresRefinanciar
			INTO
				Var_SucCliente,		Var_CreTasa,			Var_MonedaID,			Var_CliPagIVA,		Var_CalInteresID,
                Var_TipoCalInteres,	Var_IVAIntOrd,			Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,
                Var_Estatus,		Var_SucursalCred,		Var_InteresAcumuladoR,	Var_InteresRefinanciar
			FROM CLIENTES Cli
				INNER JOIN CREDITOS Cre 		ON Cre.ClienteID 		 = Cli.ClienteID
                INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
                INNER JOIN DESTINOSCREDITO Des 	ON Cre.DestinoCreID   	 = Des.DestinoCreID
			WHERE Cre.CreditoID	= Par_CreditoID;

		SET Var_SucCliente  := IFNULL(Var_SucCliente,Entero_Cero);

		SELECT IVA INTO Var_IVASucurs
			FROM SUCURSALES
			WHERE SucursalID = Var_SucCliente;

		SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
		SET Var_ValIVAIntOr := Entero_Cero;

		IF(Var_CliPagIVA = SiPagaIVA) THEN
			IF (Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr  := Var_IVASucurs;
			END IF;
		END IF;


		SELECT  SUM(IFNULL(SaldoCapVigente, Entero_Cero) +
				IFNULL(SaldoCapVenNExi, Entero_Cero) ) INTO Var_SaldoCapital
		  FROM AMORTICREDITO Amo
			WHERE CreditoID = Par_CreditoID
			  AND Amo.Estatus != Esta_Pagado;

		SET Var_SaldoCapital := IFNULL(Var_SaldoCapital,Decimal_Cero);

        # Monto de capital que no fue desembolsado en la fecha pactada
		SET Var_SaldInsolAnt := (SELECT Minis.Capital
									FROM MINISTRACREDAGRO Minis
									WHERE Minis.FechaMinistracion = Var_FechaSistema
									AND Minis.CreditoID = Par_CreditoID
									LIMIT 1);

		# Se obtiene la fecha en que se lleva acabo la ministración
		SET Var_FechMinisReal:= (SELECT  MAX(FechaMinistracion) FROM
									MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID
									AND FechaMinistracion = Var_FechaSistema
                                    AND Numero != 1
                                    AND Estatus != Est_Inactivo
                                    );

        SET Var_FechMinisReal := IFNULL(Var_FechMinisReal, Fecha_Vacia);

        # Se obtiene el numero de la primer amortizacion vigente.
		SET Var_NumAmortVig := (SELECT MIN(AmortizacionID)
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoID
									AND  Estatus = Esta_Vigente);

		SET Var_NumAmortVig := IFNULL(Var_NumAmortVig, Entero_Cero);

		IF(Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres=CalculoSalInsol) THEN

			OPEN CURSORAMOINTERES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOAMORTI:LOOP

				FETCH CURSORAMOINTERES INTO
					Var_CreditoID,      Var_AmortizacionID, 	Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
					Var_FechaInicio,    Var_FechaVencim,    	Var_FechaExigible,      Var_ProvisionAcum,		Var_MontoPendDesem,
                    Var_InteresIdeal,	Var_EstatusAmor,		Var_InteresAtraAcum;

				SET Var_ProvisionAcum		:= IFNULL(Var_ProvisionAcum, 	Decimal_Cero);
                SET Var_InteresAtraAcum		:= IFNULL(Var_InteresAtraAcum, 	Decimal_Cero);
				SET Var_SaldoCapVenNExi 	:= IFNULL(Var_SaldoCapVenNExi, 	Decimal_Cero);
				SET Var_SaldoCapVigente 	:= IFNULL(Var_SaldoCapVigente, 	Decimal_Cero);
                SET Var_InteresInd			:= Decimal_Cero;
                SET Var_InteresAcumulado 	:= Decimal_Cero;
                SET Var_InteresAcumAnt		:= Decimal_Cero;
				SET Var_Interes 			:= Decimal_Cero;
				SET Var_InteresAcumAnt 		:= Decimal_Cero;
                SET Var_IntAcumMesAnt 		:= Decimal_Cero;
                SET Var_NuevoIntProv		:= Decimal_Cero;

				SET Var_InteresRefinanciar 	:= IFNULL(Var_InteresRefinanciar, 	Decimal_Cero);
                SET Var_InteresAcumuladoR 	:= IFNULL(Var_InteresAcumuladoR, 	Decimal_Cero);

				    /* Si ocurrió una ministración: Se inicializa el Interés a Refinanciar  y el Interés Acumulado
                 de las amortizaciones posteriores a la que se ve afectada por la ministración o
                 Si  ocurre un prepago: Se inicializa el Interés a Refinanciar  y el Interés Acumulado
                 de las amortizaciones posteriores a la que se ve afectada por el prepago.*/

                IF(Var_AmortizacionID <> Var_NumAmortVig OR Var_FechMinisReal = Var_FechaInicio OR Var_FechaInicio = Var_FechaSistema) THEN
						SET Var_InteresRefinanciar := Decimal_Cero;
						SET Var_InteresAcumuladoR := Decimal_Cero;
					END IF;

				SET Var_TotCapital  	:= Var_SaldoCapVigente + Var_SaldoCapVenNExi;
                # Si la fecha de inicio de amortizacion es menor a la fecha del sistema
				IF(Var_FechaInicio  < Var_FechaSistema) THEN
					# Si el tipo de calculo de interes es a la Fecha pactada
					IF(Par_TipoCalculoInteres = FechaPactada) THEN

                        # Se obtiene la fecha pactada de la ministracion
						SET Var_FechaMinistrado	 := (SELECT M.FechaPagoMinis
														FROM MINISTRACREDAGRO M
														WHERE M.FechaMinistracion = Var_FechaSistema
                                                        AND M.FechaMinistracion = Var_FechaInicio
                                                        AND FechaMinistracion < Var_FechaVencim
														AND M.CreditoID = Var_CreditoID
                                                        LIMIT 1);

						# Se valida si la fecha de inicio de la amortizacion es mayor a la fecha pactada de la ministracion
						IF(Var_FechaInicio > Var_FechaMinistrado) THEN
							# La fecha de inicio sera la fecha de inicio
							SET Var_FechaInicio := Var_FechaInicio;
							SET Var_SaldInsolAnt := Var_SaldInsolAnt;
                        ELSE
							# La fecha de inicio sera la fecha pactada de la ministracion
							SET Var_FechaInicio := Var_FechaMinistrado;
                            SET Var_SaldInsolAnt := Var_SaldInsolAnt;
                        END IF;

                        SET Var_FechaVencMinis 	:= Var_FechaSistema;

                        # Se valida si la fecha Real de la ministracion es mayor a la fecha de vencimiento de la amortizacion
                         IF (Var_FechaVencMinis > Var_FechaVencim) THEN
							# Si la fecha real de la ministracion es mayor a la fecha de vencimiento de la amortizacion,
                            # La fecha corte es la fecha de vencimiento de la amortizacion
							SET Var_FechaVencMinis := Var_FechaVencim;
						ELSE
							# Si la fecha real de la ministracion es menor o igual que la fecha de vencimiento de la amortizacion,
                            # La fecha de corte es la fecha real de la ministracion
							SET Var_FechaVencMinis := Var_FechaVencMinis;
						END IF;

                        SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));
						# Se verifica si la fecha es Inicio de Mes para aumentar al monto base(Saldo de Capital) el interes acumulado)
						SET Var_FechaFinMes := (SELECT LAST_DAY(Var_FechaInicio));
						SET Var_FechaFinMes := IFNULL(Var_FechaFinMes, Fecha_Vacia);

						# Se obtiene la fecha de inicio del siguiente mes
						SET Var_FechaInicioMes := (SELECT DATE_ADD(Var_FechaFinMes, INTERVAL 1 DAY));
						SET Var_FechaInicioMes := IFNULL(Var_FechaInicioMes, Fecha_Vacia);

						WHILE (Var_FechaInicio < Var_FechaVencMinis) DO
							# Si la fecha de corte es menor a la fecha de vencimiento
							IF (Var_FechaCorte > Var_FechaVencMinis) THEN
								SET Var_FechaCorte := Var_FechaVencMinis;	# Fecha de corte es la fecha de vencimiento
							ELSE
								SET Var_FechaCorte := Var_FechaCorte;	# Fecha de corte es la fecha de corte obtenida
							END IF;


						   # Si la fecha de corte es igual a la fecha de vencimiento
							IF(Var_FechaCorte = Var_FechaVencMinis) THEN
								# Se realiza el calculo para obtener el numero de dias
								SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);
							ELSE
								# Se realiza el calculo para obtener el numero de dias y se le suma 1 para que el numero de  dias sea exacto
								SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
							END IF;

						   # Si la fecha de inicio es mayor a la fecha del primer inicio de mes de la amortizacion
							IF(Var_FechaInicio >= Var_FechaInicioMes) THEN
								# El saldo capital es el Saldo del Capital + el interes acumulado del mes anterior

								SET Var_InteresInd := ROUND((Var_InteresAcumAnt + Var_SaldInsolAnt) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
								SET Var_InteresAcumAnt := Var_InteresAcumAnt + Var_InteresInd;
								SET Var_IntAcumMesAnt := Var_InteresAcumAnt;
							ELSE

								SET Var_InteresInd := ROUND(Var_SaldInsolAnt * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
								SET Var_InteresAcumAnt := Var_InteresInd;
                                SET Var_IntAcumMesAnt := Var_InteresInd;
							END IF;

							# Se obtiene el siguiente rango de fechas
							SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));
							SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));

							IF (Var_FechaCorte > Var_FechaVencim) THEN
								SET Var_FechaCorte := Var_FechaVencim;
							ELSE
								 SET Var_FechaCorte := Var_FechaCorte;
							END IF;
						END WHILE;


                         -- Verifica si el Credito esta Vencido diferenciar Los Asientos Contables del Interes
						IF (Var_Estatus = Cre_Vencido ) THEN

							SET	Mov_AboConta	:= Con_CorOrdInt;
							SET	Mov_CarConta	:= Con_CueOrdInt;
							SET	Mov_CarOpera	:= Mov_IntNoConta;
						ELSE

							IF(Var_EstatusAmor = Esta_Vigente) THEN
								SET	Mov_AboConta	:= Con_IngreInt;
								SET	Mov_CarConta	:= Con_IntDeven;
								SET	Mov_CarOpera	:= Mov_IntPro;
							END IF;
                            IF(Var_EstatusAmor = Esta_Atrasado) THEN
								SET	Mov_AboConta	:= Con_IngreInt;
								SET	Mov_CarConta	:= Con_IntAtrasado;
								SET	Mov_CarOpera	:= Mov_IntAtras;
							END IF;
                            IF(Var_EstatusAmor = Esta_Vencido) THEN
								SET	Mov_AboConta	:= Con_IngreInt;
								SET	Mov_CarConta	:= Con_IntVencido;
								SET	Mov_CarOpera	:= Mov_IntAtras;
							END IF;

						END IF;

						# Se hacen los asientos contables por la diferencia
						CALL  CONTACREDITOSPRO (
							Var_CreditoID,		Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
							Var_FechaSistema,	Var_InteresAcumAnt,		Var_MonedaID,    	Var_ProdCreID,		Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,     	DescMinis,     		Ref_GenInt,			AltaPoliza_SI,
							Entero_Cero,		Var_Poliza,     		AltaPolCre_SI,		AltaMovCre_SI,		Mov_CarConta,
							Mov_CarOpera,		Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,       Cadena_Vacia,
							Cadena_Vacia,		Par_Salida,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
							Par_EmpresaID,      Cadena_Vacia,      		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                            Aud_ProgramaID,     Var_SucursalCred,  		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
				        END IF;

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,		Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
                            Var_FechaSistema,	Var_InteresAcumAnt,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
                            Var_SubClasifID,    Var_SucCliente,			DescMinis,     		Ref_GenInt,			AltaPoliza_NO,
                            Entero_Cero,		Var_Poliza,     		AltaPolCre_SI,		AltaMovCre_NO,		Mov_AboConta,
							Entero_Cero,    	Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
                            Cadena_Vacia,		Par_Salida,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
                            Par_EmpresaID,      Cadena_Vacia,       	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
				        END IF;

						-- Se obtienen los nuevos intereses provisionados despues de el devengamiento de intereses.
						 SET Var_NuevoIntProv := (SELECT SaldoInteresPro
											FROM AMORTICREDITO
												WHERE CreditoID = Var_CreditoID
                                                AND AmortizacionID = Var_AmortizacionID);

                     END IF;
					# Si la fecha de inicio es menor a la fecha del sistema, entonces la fecha de inicio es la fecha del sistema.
					SET Var_FechaInicio := Var_FechaSistema;

				ELSE
					# Si la fecha de inicio no es menor a la fecha del sistema, entonces la fecha de inicio no cambia.
					SET Var_FechaInicio := Var_FechaInicio;
				END IF;

				SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));
                SET Var_FechaCorte 	:= IFNULL(Var_FechaCorte, Fecha_Vacia);
                SET Var_FechaInicioMes := (SELECT DATE_ADD(Var_FechaCorte, INTERVAL 1 DAY));

				SET Var_SaldoCapital := Var_SaldoCapital;

                WHILE (Var_FechaInicio<Var_FechaVencim) DO

					# Si la fecha de corte es menor a la fecha de vencimiento
					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;	# Fecha de corte es la fecha de vencimiento
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;	# Fecha de corte es la fecha de corte obtenida
					END IF;

                   # Si la fecha de corte es igual a la fecha de vencimiento
					IF(Var_FechaCorte = Var_FechaVencim) THEN
						# Se realiza el calculo para obtener el numero de dias
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);
					ELSE
						# Se realiza el calculo para obtener el numero de dias y se le suma 1 para que el numero de  dias sea exacto
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
					END IF;

                # SIEMPRE CUANDO SE EVALÚE EL INICIO DE UNA AMORTIZACIÓN, EL PRIMER CORTE ENTRARÁ EN EL (ELSE)
                   # Si la fecha de inicio es mayor a la fecha del primer inicio de mes de la amortizacion
					IF(Var_FechaInicio >= Var_FechaInicioMes) THEN
						# ENTRA EN EL SEGUNDO CORTE

                        # El saldo capital es el Saldo del Capital + el interes acumulado del mes anterior
                        SET Var_InteresInd := ROUND((Var_InteresAcumulado + Var_SaldoCapital) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
                        SET Var_InteresAcumulado := Var_InteresAcumulado + Var_InteresInd;

					ELSE
						# SOLO ENTRA EN EL PRIMER CORTE

						# SI EXISTE UN PREPAGO. LA BASE DE CÁLCULO SERÁ EL SALDO DE CAPITAL + INTERES A REFINANCIAR(Que es lo que se ha acumulado hasta el fin de mes anterior)
                        SET Var_InteresInd := ROUND((Var_SaldoCapital + Var_InteresRefinanciar) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);

                       # EL NUEVO INTERÉS ACUMULADO VA A SER EL INTERÉS GENERADO DEL PRIMER CORTE, MÁS EL ACUMULADO HASTA LA FECHA ACTUAL
						SET Var_InteresAcumulado := Var_InteresInd + Var_InteresAcumuladoR;

					END IF;



                    # Se obtiene el siguiente rango de fechas
                    SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));
					SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));

					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;
					END IF;
                END WHILE;

              	# Si existe monto pendiente por desembolsar, el Interes sera el calculado anteriormente mas la provision acumulada
				SET Var_InteresAcumulado := ROUND(Var_InteresAcumulado + Var_InteresAcumAnt + Var_InteresAtraAcum,2);
                # Se actualizan los intereses en la tabla de AMORTICREDITO

			   UPDATE AMORTICREDITO SET
						Interes 	= Var_InteresAcumulado,
						IVAInteres 	= ROUND(ROUND(Var_InteresAcumulado,2) * Var_ValIVAIntOr, 2)
						WHERE	CreditoID   = Var_CreditoID
						  AND	AmortizacionID  = Var_AmortizacionID;

				SET Var_SaldoCapital := Var_SaldoCapital - Var_TotCapital;

				END LOOP CICLOAMORTI;
			END;
			CLOSE CURSORAMOINTERES;

		END IF;
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Los Intereses han sido Actualizados Correctamente. Credito: ',CONVERT(Par_CreditoID, CHAR(12)));

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$