-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCIONINTAGROCONSOLIDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECCIONINTAGROCONSOLIDAPRO`;
DELIMITER $$

CREATE PROCEDURE `PROYECCIONINTAGROCONSOLIDAPRO`(
/* SP QUE RECALCULA LOS INTERESES DE LOS CREDITOS AGRO PARA LA CONSOLIADCION */

    Par_CreditoID     	BIGINT(12),		--  Numero de Credito
    Par_FechaDesembolso DATE,           --  Fecha de Desembolso
	INOUT Par_MontoProy	DECIMAL(14,2),	--  Monto de Proyeccion

    Par_Salida        	CHAR(1),  		--  Salida
	INOUT Par_NumErr	INT(11),		--  Numero de error
	INOUT Par_ErrMen	VARCHAR(400),	--  Mensaje de Error

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
	DECLARE Var_FechaFinMes			DATE;			--  Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
	DECLARE Var_FechaInicioMes		DATE;			--  Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
	DECLARE Var_InteresAcumulado 	DECIMAL(18,2);	--  Interes Acumulado
	DECLARE Var_MontoPendDesem		DECIMAL(18,2);	--  Monto pendiente por desembolsar
	DECLARE Var_InteresIdeal		DECIMAL(14,2);	--  Interese del Calendario ideal
    DECLARE Var_InteresInd			DECIMAL(14,2);	--  Interes Individual
    DECLARE Var_MontoMinistrado		DECIMAL(14,2);	--  Monto Ministrado
    DECLARE Var_SaldInsolAnt		DECIMAL(18,2);	--  Saldo Insoluto
	DECLARE Var_FechaVencMinis		DATE;			--  Fecha de Vencimiento(Fecha del Sistema.)
    DECLARE Var_ProdCreID       	INT(11);
	DECLARE Var_ClasifCre       	CHAR(1);
    DECLARE Var_SubClasifID 		INT(11);
    DECLARE Var_Poliza     			BIGINT;			--  Numero de Poliza
    DECLARE Mov_AboConta    		INT(11);
	DECLARE Mov_CarConta    		INT(11);
	DECLARE Mov_CarOpera    		INT(11);
	DECLARE Par_Consecutivo 		BIGINT;
    DECLARE Var_Estatus				CHAR(1);		--  Estatus del Credito
    DECLARE Var_SucursalCred		INT(11);		--  Sucursal Credito
    DECLARE Var_InteresAcumAnt		DECIMAL(18,2);	--  Interes acumulado anterior
    DECLARE Var_IntAcumMesAnt		DECIMAL(18,2);	--  Interes acumulado mes anterior
    DECLARE Var_FechMinisReal		DATE;			--  Fecha real de la ministracionm
    DECLARE Var_NumAmortMinis		INT(11);		--  Numero de la ultima amortizacion ministrada
    DECLARE Var_EstatusAmor			CHAR(1);		--  Esatus de la amortizacion
   	DECLARE Var_InteresAtraAcum   	DECIMAL(14,4);  --  Interes atrasado acumulado
    DECLARE Var_NuevoIntProv		DECIMAL(14,2);	--  Nuevo Interes Provision despues de la actualizacion
	DECLARE Var_InteresRefinanciar	DECIMAL(18,2);	--  Interes a Refinanciar(Meses anteriores)
    DECLARE Var_InteresAcumuladoR	DECIMAL(18,2);	--  Interes Acumulado Real a la fecha actual
    DECLARE Var_IntProyectado		DECIMAL(18,2);	--  Interes Proyectado
    DECLARE Var_AmortizacionPrep	INT(11);
	DECLARE Var_NumAmortVig			INT(11);		--  Numero de la Amortizacion en Curso
	DECLARE Var_Contador			INT(11);
	DECLARE Var_NumRegistros		INT(11);
	DECLARE Var_Refinancia      	CHAR(1);      	-- Refinancia Intereses

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
	DECLARE Con_NO 					CHAR(1);

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

    SET Est_Inactivo	:= 'I';					-- Estatus Inactivo
	SET Con_NO			:= 'N';					-- Constante NO

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PROYECCIONINTAGROCONSOLIDAPRO');
		END;

	SELECT 	FechaSistema, 		DiasCredito
	INTO 	Var_FechaSistema, 	Var_DiasCredito
		FROM PARAMETROSSIS;

		SELECT  Cli.SucursalOrigen,	Cre.TasaFija,			Cre.MonedaID,			Cli.PagaIVA,		Cre.CalcInteresID,
				Pro.TipoCalInteres,	Pro.CobraIVAInteres,	Cre.ProductoCreditoID,  Des.Clasificacion,	Des.SubClasifID,
                Cre.Estatus,		Cre.SucursalID,			InteresAcumulado,		Cre.InteresRefinanciar,	Cre.Refinancia
			INTO
				Var_SucCliente,		Var_CreTasa,			Var_MonedaID,			Var_CliPagIVA,		Var_CalInteresID,
                Var_TipoCalInteres,	Var_IVAIntOrd,			Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,
                Var_Estatus,		Var_SucursalCred,		Var_InteresAcumuladoR,	Var_InteresRefinanciar, Var_Refinancia
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

         -- Se obtiene el numero de la primer amortizacion vigente.
		SET Var_NumAmortVig := (SELECT MIN(AmortizacionID)
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoID
									AND  Estatus = Esta_Vigente);

		SET Var_NumAmortVig := IFNULL(Var_NumAmortVig, Entero_Cero);

		SET Var_IntProyectado := Decimal_Cero;

		IF(Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres=CalculoSalInsol) THEN

			DELETE FROM PROYECTINTAGROCONSOLIDA
				WHERE CreditoID = Par_CreditoID
					AND NumTransaccion = Aud_NumTransaccion;

			SET @Contador := Entero_Cero;

			INSERT INTO PROYECTINTAGROCONSOLIDA (
				ProyeccionID,		CreditoID,			AmortizacionID,			SaldoCapVigente,		SaldoCapVenNExi,
				MonedaID,			FechaInicio,		FechaVencim,			FechaExigible,			SaldoInteresPro,
				MontoPendDesembolso,	Interes,		Estatus,				SaldoInteresAtr,		EmpresaID,
				Usuario,			FechaActual,		DireccionIP,			ProgramaID,				Sucursal,
				NumTransaccion)
			SELECT (@Contador := @Contador + 1),	 Amo.CreditoID,      	Amo.AmortizacionID, Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,
			    Cre.MonedaID,		Amo.FechaInicio,    	Amo.FechaVencim,    Amo.FechaExigible,      (IFNULL(Amo.SaldoInteresPro, Decimal_Cero) + IFNULL(Amo.SaldoIntNoConta, Decimal_Cero)) AS Provision,
				Ag.MontoPendDesembolso,	Ag.Interes,			Amo.Estatus,		IFNULL(Amo.SaldoInteresAtr, Decimal_Cero), Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion
			FROM AMORTICREDITO Amo
			INNER JOIN AMORTICREDITOAGRO Ag ON Amo.CreditoID = Ag.CreditoID
											AND Amo.AmortizacionID = Ag.AmortizacionID
			INNER JOIN CREDITOS Cre ON Cre.CreditoID =Ag.CreditoID AND Cre.CreditoID =Amo.CreditoID
			WHERE Cre.CreditoID   = Par_CreditoID
				AND (Cre.Estatus    = Esta_Vigente  OR Cre.Estatus = Esta_Vencido)
				AND (Amo.Estatus	  = Esta_Vigente OR Amo.Estatus	  = Esta_Atrasado OR Amo.Estatus	= Esta_Vencido)
				AND Amo.FechaInicio <= Par_FechaDesembolso
			ORDER BY FechaExigible;

			SELECT COUNT(*)
			INTO Var_NumRegistros
			FROM PROYECTINTAGROCONSOLIDA;

			SET Var_Contador := 1;

			WHILE(Var_Contador<=Var_NumRegistros)DO

				SELECT 
					CreditoID,			AmortizacionID,			SaldoCapVigente,		SaldoCapVenNExi,		MonedaID,
					FechaInicio,		FechaVencim,			FechaExigible,			SaldoInteresPro,		MontoPendDesembolso,
					Interes				Estatus,				SaldoInteresAtr
				INTO
					Var_CreditoID,      Var_AmortizacionID, 	Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
					Var_FechaInicio,    Var_FechaVencim,    	Var_FechaExigible,      Var_ProvisionAcum,		Var_MontoPendDesem,
                    Var_InteresIdeal,	Var_EstatusAmor,		Var_InteresAtraAcum
				FROM PROYECTINTAGROCONSOLIDA
				WHERE ProyeccionID = Var_Contador
					AND CreditoID = Par_CreditoID
					AND NumTransaccion = Aud_NumTransaccion;

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

                IF(Var_AmortizacionID <> Var_NumAmortVig OR Var_FechaInicio = Var_FechaSistema) THEN
						SET Var_InteresRefinanciar := Decimal_Cero;
						SET Var_InteresAcumuladoR := Decimal_Cero;
				END IF;

				IF(Var_Refinancia = Con_NO) THEN
					SET Var_InteresRefinanciar := Decimal_Cero;
					SET Var_InteresAcumuladoR := Decimal_Cero;
					SET Var_InteresAcumulado := Decimal_Cero;
				END IF;

				SET Var_TotCapital  	:= Var_SaldoCapVigente + Var_SaldoCapVenNExi;

                IF(Var_FechaInicio  < Var_FechaSistema) THEN
                -- Si la fecha de inicio es menor a la fecha del sistema, entonces la fecha de inicio es la fecha del sistema.
					SET Var_FechaInicio := Var_FechaSistema;

				ELSE
					-- Si la fecha de inicio no es menor a la fecha del sistema, entonces la fecha de inicio no cambia.
					SET Var_FechaInicio := Var_FechaInicio;
                END IF;

				SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));
                SET Var_FechaCorte 	:= IFNULL(Var_FechaCorte, Fecha_Vacia);
                SET Var_FechaInicioMes := (SELECT DATE_ADD(Var_FechaCorte, INTERVAL 1 DAY));

				SET Var_SaldoCapital := Var_SaldoCapital;

                WHILE (Var_FechaInicio<Var_FechaVencim AND Var_FechaInicio <= Par_FechaDesembolso) DO
					--  Si la fecha de corte es mayor que la del fecha Pactada
					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;	--  Fecha de corte es la fecha de vencimiento
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;	--  Fecha de corte es la fecha de corte obtenida
					END IF;

                   --  Si la fecha de corte es igual a la fecha de vencimiento
					IF(Var_FechaCorte = Var_FechaVencim) THEN
						--  Se realiza el calculo para obtener el numero de dias
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);
					ELSE
						--  Se realiza el calculo para obtener el numero de dias y se le suma 1 para que el numero de  dias sea exacto
						SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
					END IF;

                    --  SIEMPRE CUANDO SE EVALÚE EL INICIO DE UNA AMORTIZACIÓN, EL PRIMER CORTE ENTRARÁ EN EL (ELSE)
                     --  Si la fecha de inicio es mayor a la fecha del primer inicio de mes de la amortizacion
					IF(Var_FechaInicio >= Var_FechaInicioMes) THEN
                        --  El saldo capital es el Saldo del Capital + el interes acumulado del mes anterior
                        SET Var_InteresInd := ROUND((Var_InteresAcumulado + Var_SaldoCapital) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
                        SET Var_InteresAcumulado := Var_InteresAcumulado + Var_InteresInd;

					ELSE
						--  SI EXISTE UN PREPAGO. LA BASE DE CÁLCULO SERÁ EL SALDO DE CAPITAL + INTERES A REFINANCIAR(Que es lo que se ha acumulado hasta el fin de mes anterior)
                        SET Var_InteresInd := ROUND((Var_SaldoCapital + Var_InteresRefinanciar) * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);
                       --  EL NUEVO INTERÉS ACUMULADO VA A SER EL INTERÉS GENERADO DEL PRIMER CORTE, MÁS EL ACUMULADO HASTA LA FECHA ACTUAL
						SET Var_InteresAcumulado := Var_InteresInd + Var_InteresAcumuladoR;

					END IF;

                    --  Se obtiene el siguiente rango de fechas
                    SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));
					SET Var_FechaCorte 	:= (SELECT LAST_DAY(Var_FechaInicio));

					IF (Var_FechaCorte > Var_FechaVencim) THEN
						SET Var_FechaCorte := Var_FechaVencim;
					ELSE
						 SET Var_FechaCorte := Var_FechaCorte;
					END IF;

                    IF(Var_FechaInicio = Par_FechaDesembolso)THEN
						SET Var_FechaInicio := Par_FechaDesembolso;
                    END IF;
                END WHILE;
              	--  Si existe monto pendiente por desembolsar, el Interes sera el calculado anteriormente mas la provision acumulada
				SET Var_InteresAcumulado := ROUND(Var_InteresAcumulado + Var_InteresAcumAnt + Var_InteresAtraAcum,2);

				SET Var_IntProyectado := Var_IntProyectado + Var_InteresAcumulado;

				SET Var_Contador := Var_Contador + 1;

			END WHILE;

			DELETE FROM PROYECTINTAGROCONSOLIDA
				WHERE CreditoID = Par_CreditoID
					AND NumTransaccion = Aud_NumTransaccion;

		END IF;

		SET Par_MontoProy := IFNULL(Var_IntProyectado,Decimal_Cero);

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Los Intereses Proyectados Correctamente. Credito: ',CONVERT(Par_CreditoID, CHAR(12)));

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$