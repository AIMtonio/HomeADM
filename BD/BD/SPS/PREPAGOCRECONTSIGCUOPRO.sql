-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCRECONTSIGCUOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOCRECONTSIGCUOPRO`;
DELIMITER $$


CREATE PROCEDURE `PREPAGOCRECONTSIGCUOPRO`(
/* SP DE PROCESO QUE REALIZA EL PREPAGO CUOTAS SIGUIENTES INMEDIATAS */
	Par_CreditoID     	BIGINT(12),
	Par_CuentaAhoID   	BIGINT(12),
	Par_MontoPagar    	DECIMAL(14,2),
	Par_MonedaID      	INT(11),
	Par_EmpresaID     	INT(11),

	Par_Salida        	CHAR(1),
	Par_AltaEncPoliza	CHAR(1),
	OUT Par_MontoPago	DECIMAL(12,2),
	INOUT Var_Poliza	BIGINT,
	INOUT Par_NumErr	INT(11),

	INOUT Par_ErrMen	VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT,
	Par_ModoPago        CHAR(1),
	/* Parametros de Auditoria */
	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,

	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE ConcepCtaOrdenDeu		INT;
	DECLARE ConcepCtaOrdenCor		INT;
	DECLARE VarSucursalLin			INT;
	DECLARE Var_AltaPoliza			CHAR(1);
	DECLARE Var_FechaSistema    	DATE;
	DECLARE Var_FecAplicacion   	DATE;
	DECLARE Var_DiasCredito     	INT;
	DECLARE Var_SucCliente      	INT;
	DECLARE Var_ClienteID			BIGINT;
	DECLARE Var_ProdCreID			INT;
	DECLARE Var_ClasifCre			CHAR(1);
	DECLARE Var_EstatusCre      	CHAR(1);
	DECLARE Var_CliPagIVA   		CHAR(1);
	DECLARE Var_IVAIntOrd   		CHAR(1);
	DECLARE Var_EsGrupal        	CHAR(1);
	DECLARE Var_SolCreditoID    	BIGINT;
	DECLARE Var_CreTasa         	DECIMAL(12,4);
	DECLARE Var_MonedaID        	INT;
	DECLARE Var_GrupoID         	INT;
	DECLARE Var_SubClasifID     	INT;

	DECLARE Var_CreditoID       	BIGINT(12);           			-- Variables para los Cursores
	DECLARE Var_AmortizacionID  	INT;
	DECLARE Var_SaldoCapVigente 	DECIMAL(14,2);
	DECLARE Var_SaldoCapVenNExi 	DECIMAL(14,2);
	DECLARE Var_FechaInicio     	DATE;
	DECLARE Var_FechaVencim     	DATE;
	DECLARE Var_FechaExigible   	DATE;
	DECLARE Var_AmoEstatus      	CHAR(1);
	DECLARE Var_SaldoInteresPro		DECIMAL(14,4);
	DECLARE	Var_SaldoIntNoConta		DECIMAL(14,4);
	DECLARE Var_SaldoSeguroCuota  	DECIMAL(14,2);			-- Saldo del seguro por cuota
	DECLARE Var_ProvisionAcum   	DECIMAL(14,4);
	DECLARE Var_NumAmoPag			INT;
	DECLARE Var_NumAmorti			INT;
	DECLARE Var_MontoCredito		DECIMAL(14,2);		--  Monto Original del Credito
	DECLARE Var_PorcMontoCred		DECIMAL(14,2);		--  Monto correspondiente al 20% del Monto Original del Credito
	DECLARE Var_MontoPagado			DECIMAL(14,2);		--  Monto pagado del Credito
	DECLARE Var_CapitalVigente		DECIMAL(14,2);		--  Saldo Capital Vigente
	DECLARE Var_Frecuencia      	CHAR(1);
	DECLARE Var_EstCreacion			CHAR(1);
	DECLARE Var_FrecInteres			CHAR(1);			--  Frecuencia de Interes
	DECLARE Var_FechaInicioCred		DATE;				--  Fecha de Inicio del Credito
	DECLARE Var_DiasTrans			INT(11);			--  Dias transcurridos
	DECLARE Var_IntNoCont			DECIMAL(14,2);		--  Saldo Interes no contabilizado

	DECLARE Var_IVASucurs   		DECIMAL(8, 4);
	DECLARE Var_ValIVAIntOr 		DECIMAL(12,2);
	DECLARE Var_TotDeuda    		DECIMAL(14,2);
	DECLARE Var_NumAtrasos  		INT;
	DECLARE Var_EsHabil     		CHAR(1);
	DECLARE Var_CueEstatus			CHAR(1);
	DECLARE Var_CueClienteID    	BIGINT;
	DECLARE Var_CueSaldo			DECIMAL(14,2);
	DECLARE Var_CueMoneda			INT;
	DECLARE Var_CicloActual     	INT;
	DECLARE Var_CicloGrupo      	INT;
	DECLARE Var_GrupoCtaID      	INT;
	DECLARE Var_CuentaAhoStr		VARCHAR(20);
	DECLARE Var_CreditoStr			VARCHAR(20);
	DECLARE Var_SaldoPago       	DECIMAL(14,2);
	DECLARE Var_CantidPagar     	DECIMAL(14,2);
	DECLARE Var_SaldoCapita     	DECIMAL(14,2);
	DECLARE Var_CalInteresID    	INT;
	DECLARE Var_Dias            	INT;
	DECLARE Var_TotCapital      	DECIMAL(14,2);
	DECLARE Var_Interes         	DECIMAL(14,4);
	DECLARE Var_MaxAmoCapita    	INT;
	DECLARE Var_IVACantidPagar  	DECIMAL(12, 2);
	DECLARE	Var_FechaIniCal			DATE;
	DECLARE	Var_EstAmorti			CHAR(1);
	DECLARE	Var_DivContaIng			CHAR(1);

	DECLARE Var_ManejaLinea			CHAR(1);			/*variable para guardar el valor de si o no maneja linea el producto de credito*/
	DECLARE Var_EsRevolvente		CHAR(1);			/* Variable para saber si es revolvente la linea */
	DECLARE Var_LineaCredito		BIGINT;				/* Variable para guardar la linea de credito*/
	DECLARE Var_MontoSeguro			DECIMAL(14,2);
	DECLARE Var_MontoSeguroOp		DECIMAL(14,2);		--  Monto del Seguro Operativo
	DECLARE Var_MontoSeguroCont		DECIMAL(14,2);		--  Monto del Seguro Contable
	DECLARE Var_MontoIVASeguroOp	DECIMAL(14,2);		--  Monto del IVA del Seguro Operativo
	DECLARE Var_MontoIVASeguroCont	DECIMAL(14,2);		--  Monto del IVA del Seguro Contable
	/*COMISION ANUAL*/
	DECLARE Var_CobraComAnual		CHAR(1);
	DECLARE Var_SaldoComAnual		DECIMAL(14,2);
	/*FIN COMISION ANUAL*/
	DECLARE Var_Refinancia			CHAR(1);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT;
	DECLARE Decimal_Cero    		DECIMAL(12, 2);
	DECLARE SiPagaIVA       		CHAR(1);
	DECLARE SalidaSI        		CHAR(1);
	DECLARE SalidaNO        		CHAR(1);
	DECLARE Esta_Pagado     		CHAR(1);
	DECLARE Esta_Activo     		CHAR(1);
	DECLARE Esta_Vencido    		CHAR(1);
	DECLARE Esta_Vigente    		CHAR(1);
	DECLARE Esta_Atrasado			CHAR(1);

	DECLARE NO_EsGrupal     		CHAR(1);
	DECLARE AltaPoliza_SI   		CHAR(1);
	DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE Pol_Automatica  		CHAR(1);
	DECLARE Mon_MinPago     		DECIMAL(12,2);
	DECLARE Tol_DifPago     		DECIMAL(10,4);
	DECLARE Nat_Cargo       		CHAR(1);
	DECLARE Nat_Abono       		CHAR(1);
	DECLARE Aho_PagoCred    		CHAR(4);
	DECLARE Con_AhoCapital  		INT;
	DECLARE AltaMovAho_SI   		CHAR(1);
	DECLARE Tasa_Fija       		INT;

	DECLARE Coc_PagoCred    		INT;
	DECLARE Ref_PagAnti     		VARCHAR(50);
	DECLARE Con_PagoCred    		VARCHAR(50);

	DECLARE NoManejaLinea			CHAR(1);		/* NO maneja linea */
	DECLARE SiManejaLinea			CHAR(1);		/* Si maneja linea */
	DECLARE SiEsRevolvente			CHAR(1);		/* Si Es Revolvente */
	DECLARE NoEsRevolvente			CHAR(1);		/* NO Es Revolvente */
	DECLARE AltaMov_NO				CHAR(1);		/* Alta de Movimientos: NO */
	DECLARE TipoActInteres			INT(11);
	DECLARE SiCobSeguroCuota		CHAR(1);
	DECLARE SiCobIVASeguroCuota		CHAR(1);
	DECLARE Cons_Si					CHAR(1);
	DECLARE Cons_No					CHAR(1);
	DECLARE Var_ValIVAGen			DECIMAL(14,2);
	DECLARE Frec_Unico				CHAR(1);
	DECLARE Var_EsReestruc			CHAR(1);
	DECLARE Si_EsReestruc			CHAR(1);
	DECLARE FechaReal				CHAR(1);

	DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoID,      Amo.AmortizacionID, 	Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,
				Cre.MonedaID,       Amo.FechaInicio,    	Amo.FechaVencim,        Amo.FechaExigible,
				Amo.Estatus,		Amo.SaldoInteresPro,	Amo.SaldoIntNoConta,	Amo.SaldoSeguroCuota,
				Cre.CobraComAnual,	Amo.SaldoComisionAnual/*COMISION ANUAL*/
		FROM AMORTICREDITOCONT Amo
		INNER JOIN CREDITOSCONT Cre ON Amo.CreditoID = Cre.CreditoID
		WHERE Cre.CreditoID = Par_CreditoID
		  AND Cre.Estatus = Esta_Vigente
		  AND Amo.Estatus = Esta_Vigente
		  AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

	DECLARE CURSORFECHAS CURSOR FOR
		SELECT  Amo.CreditoID,      Amo.AmortizacionID, 	Amo.FechaInicio,    	Amo.FechaVencim,        Amo.FechaExigible
		FROM AMORTICREDITOCONT Amo
		INNER JOIN CREDITOSCONT Cre ON Amo.CreditoID = Cre.CreditoID
		WHERE Cre.CreditoID = Par_CreditoID
		  AND (Cre.Estatus = Esta_Vigente OR Cre.Estatus = Esta_Vencido)
		  AND Amo.Estatus = Esta_Vigente
		  AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';              	-- Cadena Vacia
	SET Fecha_Vacia     	:= '1900-01-01';    	-- Fecha Vacia
	SET Entero_Cero			:= 0;					-- Entero en Cero
	SET Decimal_Cero    	:= 0.00;            	-- DECIMAL en Cero
	SET SiPagaIVA       	:= 'S';             	-- El Cliente si Paga IVA
	SET SalidaSI        	:= 'S';             	-- El Store si Regresa una Salida
	SET SalidaNO        	:= 'N';             	-- El Store no Regresa una Salida
	SET Esta_Pagado     	:= 'P';             	-- Estatus del Credito: Pagado
	SET Esta_Activo     	:= 'A';             	-- Estatus: Activo
	SET Esta_Vencido    	:= 'B';             	-- Estatus del Credito: Vencido
	SET Esta_Vigente    	:= 'V';             	-- Estatus del Credito: Vigente
	SET Esta_Atrasado		:= 'A';

	SET NO_EsGrupal     	:= 'N';             	-- El Credito No es Grupal
	SET AltaPoliza_SI   	:= 'S';             	-- SI dar de alta la Poliza Contable
	SET AltaPoliza_NO   	:= 'N';             	-- NO dar de alta la Poliza Contable
	SET Pol_Automatica  	:= 'A';             	-- Tipo de Poliza: Automatica
	SET Mon_MinPago     	:= 0.01;            	-- Monto Minimo para Aceptar un Pago
	SET Tol_DifPago     	:= 0.02;            	-- Minimo de la deuda para marcarlo como Pagado
	SET Nat_Cargo       	:= 'C';             	-- Naturaleza de Cargo
	SET Nat_Abono       	:= 'A';					-- Naturaleza de Abono
	SET Aho_PagoCred    	:= '101';           	-- Concepto de Pago de Credito
	SET Con_AhoCapital  	:= 1;               	-- Concepto de Ahorro: Capital
	SET AltaMovAho_SI   	:= 'S';             	-- Alta del Movimiento de Ahorro: SI
	SET Tasa_Fija       	:= 1;               	-- Tipo de Tasa de Interes: Fija
	SET Coc_PagoCred    	:= 54;              	-- Concepto Contable: Pago de Credito
	SET ConcepCtaOrdenDeu	:= 53;		/* Linea Credito Cta. Orden */
	SET ConcepCtaOrdenCor	:= 54;		/* Linea Credito Corr. Cta Orden */

	SET Ref_PagAnti     	:= 'PAGO ANTICIPADO CREDITO';
	SET Con_PagoCred    	:= 'PAGO DE CREDITO CONTINGENTE';
	SET Aud_ProgramaID  	:= 'PAGOCREDITOCONTPRO';
	SET NoManejaLinea		:= 'N';	            /* No maneja linea */
	SET SiManejaLinea		:= 'S';	            /* Si maneja linea */
	SET SiEsRevolvente		:= 'S';	            /* Si Es Revolvente */
	SET NoEsRevolvente		:= 'N';	            /* No Es Revolvente */
	SET AltaMov_NO      	:= 'N';          	/* Alta de Movimientos: NO */
	SET TipoActInteres		:= 1;				-- Tipo de Actualizacion (intereses)
	SET SiCobSeguroCuota	:= 'S';
	SET SiCobIVASeguroCuota := 'S';
	SET Cons_Si				:= 'S';
	SET Cons_No				:= 'N';
	SET Frec_Unico			:= 'U';			-- Frecuencia Unica
	SET Si_EsReestruc   	:= 'S';
	SET FechaReal			:= 'R';

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PREPAGOCRECONTSIGCUOPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

		SELECT FechaSistema, 	DiasCredito, 	DivideIngresoInteres
			INTO Var_FechaSistema, Var_DiasCredito, Var_DivContaIng
		FROM PARAMETROSSIS LIMIT 1;

	SET	Var_DivContaIng	:= IFNULL(Var_DivContaIng, Cadena_Vacia);


	SELECT  Cli.SucursalOrigen,     Cre.ClienteID,          Pro.ProducCreditoID,    	Des.Clasificacion,
			Cre.NumAmortizacion,	Cre.Estatus,            Cli.PagaIVA,            	Pro.CobraIVAInteres,
			Cre.TasaFija,           Cre.MonedaID,     		Des.SubClasifID,        	Cre.CalcInteresID,
			Pro.EsRevolvente,		Cre.MontoCredito,
            Pro.EsReestructura,		Cre.FrecuenciaCap,		Cre.FrecuenciaInt,			Cre.FechaInicio,
            Cre.Refinancia
	INTO
		Var_SucCliente,     	Var_ClienteID, 			Var_ProdCreID,      		Var_ClasifCre,
		Var_NumAmorti,			Var_EstatusCre, 		Var_CliPagIVA,  			Var_IVAIntOrd,
		Var_CreTasa,    		Var_MonedaID,      		Var_SubClasifID,    		Var_CalInteresID,
		Var_EsRevolvente,		Var_MontoCredito,
        Var_EsReestruc,			Var_Frecuencia,			Var_FrecInteres,			Var_FechaInicioCred,
        Var_Refinancia
	FROM CREDITOSCONT Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
	LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
	WHERE Cre.CreditoID = Par_CreditoID;

		-- Inicializaciones
		SET Var_SucCliente  	:= IFNULL(Var_SucCliente,Entero_Cero);
		SET Var_ClienteID   	:= IFNULL(Var_ClienteID,Entero_Cero);
		SET Var_ProdCreID   	:= IFNULL(Var_ProdCreID,Entero_Cero);
		SET Var_ClasifCre   	:= IFNULL(Var_ClasifCre,Cadena_Vacia);
		SET Var_EstatusCre  	:= IFNULL(Var_EstatusCre,Cadena_Vacia);
		SET Var_CliPagIVA   	:= IFNULL(Var_CliPagIVA,SiPagaIVA);
		SET Var_IVAIntOrd   	:= IFNULL(Var_IVAIntOrd,SiPagaIVA);
		SET Var_CreTasa     	:= IFNULL(Var_CreTasa,Entero_Cero);
		SET Var_MonedaID    	:= IFNULL(Var_MonedaID,Entero_Cero);
		SET Var_SubClasifID 	:= IFNULL(Var_SubClasifID,Entero_Cero);
		SET Var_EsRevolvente   	:= IFNULL(Var_EsRevolvente,Cadena_Vacia);
	    SET Var_TotDeuda  		:= FUNCIONTOTDEUDACRECONT(Par_CreditoID);
	    SET Var_MontoCredito    := IFNULL(Var_MontoCredito, Decimal_Cero);
		SET Var_TotDeuda    	:= IFNULL(Var_TotDeuda,Entero_Cero);


		SELECT IVA INTO Var_IVASucurs
			FROM SUCURSALES
			WHERE SucursalID = Var_SucCliente;

		SET Var_IVASucurs  := IFNULL(Var_IVASucurs, Decimal_Cero);
		SET Var_ValIVAIntOr := Entero_Cero;

		IF (Var_CliPagIVA = SiPagaIVA) THEN
			IF(Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr := Var_IVASucurs;
			END IF;
		END IF;

		IF(Par_MontoPagar >= Var_TotDeuda) THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(AmortizacionID) INTO Var_NumAtrasos
			FROM AMORTICREDITOCONT
				WHERE CreditoID = Par_CreditoID
					AND FechaExigible <= Var_FechaSistema
					AND Estatus != Esta_Pagado;

		SET Var_NumAtrasos := IFNULL(Var_NumAtrasos, Entero_Cero);

		IF(Var_NumAtrasos > Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Antes de Realizar un PrePago, Por Favor realice el Pago de lo Exigible y en Atraso.' ;
			LEAVE ManejoErrores;
		END IF;

		CALL DIASFESTIVOSCAL(
			Var_FechaSistema,   Entero_Cero,		Var_FecAplicacion,  Var_EsHabil,    Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion);

		CALL SALDOSAHORROCON(
			Var_CueClienteID, Var_CueSaldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

		IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != Esta_Activo THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'La Cuenta de Pago no Existe o no Esta Activa .' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
							' no pertenece al Cliente ', CONVERT(Var_ClienteID, CHAR),
							'Cliente al que Pertence ' , CONVERT(Var_CueClienteID, CHAR));
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
			SET Par_NumErr      := 6;
			SET Par_ErrMen      := 'La Moneda no corresponde con la Cuenta.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueSaldo, Decimal_Cero)) < Par_MontoPagar THEN
			SET Par_NumErr      := 7;
			SET Par_ErrMen      := 'Saldo Insuficiente en la Cuenta del Cliente';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCre = Cadena_Vacia ) THEN
			SET Par_NumErr      := 8;
			SET Par_ErrMen      := 'El Credito no Existe';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCre != Esta_Vigente) THEN
			SET Par_NumErr  := 9;
			SET Par_ErrMen  := 'Estatus del Credito Incorrecto';
			LEAVE ManejoErrores;
		END IF;

		-- Respaldo de las Tablas de Creditos, para su posible posterior reversa
		CALL RESPAGCREDITOCONTPRO(
			Par_CreditoID,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Alta del Maestro de la Poliza

		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Var_FecAplicacion, 	 	Pol_Automatica,     Coc_PagoCred,
				Con_PagoCred,		SalidaNO,       	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,   	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_SaldoPago       := Par_MontoPagar;
		SET Var_CuentaAhoStr    := CONVERT(Par_CuentaAhoID, CHAR(15));
		SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));

		-- Monto correspondiente al 20% del Monto del Credito
		SET Var_PorcMontoCred := ((Var_MontoCredito * 20)/100);

		OPEN CURSORAMORTI;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP

			FETCH CURSORAMORTI INTO
				Var_CreditoID,      	Var_AmortizacionID, 	Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
				Var_FechaInicio,    	Var_FechaVencim,    	Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoInteresPro,
				Var_SaldoIntNoConta, 	Var_SaldoSeguroCuota,	Var_CobraComAnual,		Var_SaldoComAnual;

				-- Inicializacion
				SET	Var_SaldoSeguroCuota := IFNULL(Var_SaldoSeguroCuota, Decimal_Cero);
				SET Var_CantidPagar		:= Decimal_Cero;
				SET Var_IVACantidPagar	:= Decimal_Cero;

				IF(Var_SaldoPago<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

				-- Pago de Comision x Anualidad
				IF(Var_CobraComAnual = Cons_Si) THEN/*COMISION ANUAL*/
					SET Var_IVACantidPagar	:= Entero_Cero;
					SET Var_CantidPagar 	:= Entero_Cero;

					IF(Var_ValIVAGen > Entero_Cero) THEN
						SET Var_IVACantidPagar 		:= ROUND((Var_SaldoComAnual * Var_ValIVAGen), 2);
					ELSE
						SET Var_IVACantidPagar 		:= Decimal_Cero;
					END IF;

					-- Se obtiene el Monto a Pagar
					IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoComAnual + Var_IVACantidPagar)) THEN
						SET Var_CantidPagar		:= Var_SaldoComAnual;
					  ELSE
						SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
					END IF;

					CALL PAGCRECOMANUALCONTPRO (
						Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
						Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
						Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
						Con_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			SalidaNO,			Par_NumErr,
						Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLO;
					END IF;

					-- Se actualiza el Numero de Transaccion en AMORTICREDITOCONT
					UPDATE AMORTICREDITOCONT Tem
						SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
					IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;/*COMISION ANUAL*/
				END IF; -- FIN Pago Comision x Anualidad

				-- Pago de Interes Provisionado
				IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

					SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

					IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
						SET	Var_CantidPagar		:=  Var_SaldoInteresPro;
					ELSE
						SET	Var_CantidPagar		:= Var_SaldoPago -
												   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

						SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
					END IF;

					CALL PAGCREINTPROCONTPRO (
						Var_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_CantidPagar,    	Var_IVACantidPagar,
						Var_MonedaID,       Var_ProdCreID,      	Var_ClasifCre,      	Var_SubClasifID,    	Var_SucCliente,
						Con_PagoCred,       Var_CuentaAhoStr,   	Var_Poliza,         	SalidaNO,				Par_NumErr,
						Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,       	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLO;
					END IF;

					UPDATE AMORTICREDITOCONT Tem
						SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

					SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

					IF(Var_SaldoPago	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;


				IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

					IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
						SET Var_CantidPagar := Var_SaldoCapVigente;
					ELSE
						SET Var_CantidPagar := Var_SaldoPago;
					END IF;

					CALL PAGCRECAPVIGCONTPRO (
						Var_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_CantidPagar,    	Decimal_Cero,
						Var_MonedaID,       Var_ProdCreID,      	Var_ClasifCre,      	Var_SubClasifID,    	Var_SucCliente,
						Con_PagoCred,       Var_CuentaAhoStr,   	Var_Poliza,         	SalidaNO,				Par_NumErr,
						Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,       	Aud_Usuario,
						Aud_FechaActual, 	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLO;
					END IF;

					-- Ajuste para el proceso de pago revolvente en lineas de credito contigentes
					SET Var_CantidPagar := ROUND(Var_CantidPagar,2);

					CALL PAGCRELINCONTPRO(
						Var_CreditoID,		Var_AmortizacionID,		Var_CantidPagar,	Var_Poliza,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLO;
					END IF;

					UPDATE AMORTICREDITOCONT Tem
						SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

					SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

					IF(Var_SaldoPago	<= Decimal_Cero) THEN
						LEAVE CICLO;
					END IF;

				END IF;

			END LOOP CICLO;
		END;
		CLOSE CURSORAMORTI;

		IF( Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_MontoPago	 := Par_MontoPagar - Var_SaldoPago;

		IF (Par_MontoPago<= Decimal_Cero) THEN
			SET Par_NumErr      := 10;
			SET Par_ErrMen      := 'El Credito no Presenta Adeudos.';
			LEAVE ManejoErrores;
		ELSE

			-- Marcamos como Pagadas las Amortizaciones que hayan sido afectadas en el Prepago y
			-- Que no Presenten adeudos
			UPDATE AMORTICREDITOCONT Amo  SET
				Estatus      = Esta_Pagado,
				FechaLiquida = Var_FechaSistema
			WHERE (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
				  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
				  SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
				  SaldoComFaltaPa + SaldoOtrasComis ) <= Tol_DifPago
				AND Amo.CreditoID 	= Par_CreditoID
				AND FechaExigible > Var_FechaSistema
			  	AND Estatus 	!= Esta_Pagado
				AND Amo.NumTransaccion = Aud_NumTransaccion;

			--  Consulta las amortizaciones que no estan pagadas
			SELECT COUNT(DISTINCT(AmortizacionID)) INTO Var_NumAmorti
				FROM AMORTICREDITOCONT
			WHERE CreditoID	= Par_CreditoID
				AND Estatus	IN(Esta_Vigente, Esta_Atrasado, Esta_Vencido );


			SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);
			--  Verifica que no se haya prepagado el total del credito
			IF (Var_NumAmorti = Entero_Cero) THEN
				SET Par_NumErr      := 11;
				SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
				LEAVE ManejoErrores;
			END IF;

			CALL CONTAAHORROPRO (
				Par_CuentaAhoID,    Var_CueClienteID,  		Aud_NumTransaccion, 	Var_FechaSistema,		Var_FecAplicacion,
				Nat_Cargo,          Par_MontoPago,  		Ref_PagAnti,        	Var_CreditoStr,     	Aho_PagoCred,
				Var_MonedaID,       Var_SucCliente, 		AltaPoliza_NO,      	Entero_Cero,        	Var_Poliza,
				AltaMovAho_SI,      Con_AhoCapital,			Nat_Cargo,          	Par_NumErr,         	Par_ErrMen,
				Par_Consecutivo,    Par_EmpresaID,  		Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,   		Aud_NumTransaccion);

			IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			/*	Comentado porque se confirmara su uso para reversas
			CALL DEPOSITOPAGOCREPRO (
				Par_CreditoID,      Par_MontoPago,		Var_FechaSistema,		Par_EmpresaID,		SalidaNO,
				Par_NumErr,         Par_ErrMen,     	Par_Consecutivo,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion);
			*/
		END IF;

		SET	Var_FechaIniCal := Var_FechaSistema;

		-- CURSOR para ReCalendarizar las Fechade Inicio de las Cuotas, para poder devengar correctamente los intereses
		OPEN CURSORFECHAS;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOFECHAS:LOOP

			FETCH CURSORFECHAS INTO
				Var_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible;

				SET	Var_EstAmorti	:= Cadena_Vacia;

				IF(Var_FechaInicio >= Var_FechaSistema) THEN

					SET Var_EstAmorti := (SELECT Estatus
								FROM AMORTICREDITOCONT
								WHERE CreditoID = Var_CreditoID
								 AND FechaVencim = Var_FechaInicio );

					SET Var_EstAmorti := IFNULL(Var_EstAmorti, Cadena_Vacia);

					IF(Var_EstAmorti = Esta_Pagado) THEN

						UPDATE AMORTICREDITOCONT SET
							FechaInicio = Var_FechaIniCal
						WHERE CreditoID = Var_CreditoID
							AND AmortizacionID = Var_AmortizacionID;

						SET	Var_FechaIniCal := Var_FechaVencim;
					END IF;
				END IF;
			END LOOP CICLOFECHAS;
		END;
		CLOSE CURSORFECHAS;

		-- Actualizacion de los intereses
		IF(Var_Refinancia = Cons_Si) THEN
			--  Recalculo de intereses con refinanciamiento
			CALL AMORTICREDCONTAGROACT(
				Par_CreditoID,		TipoActInteres,			FechaReal,				SalidaNo,			Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		ELSE
			--  Recalculo de intereses sin refinanciamiento
			CALL AMORTICREDITOCONTACT(
				Par_CreditoID,		TipoActInteres,    	SalidaNO,			Par_NumErr, 		Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		CALL RESPAGCREDITOCONTALT(
			Aud_NumTransaccion,	Par_CuentaAhoID,	Par_CreditoID,		Par_MontoPagar,		SalidaNO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen 	:= 'PrePago de Credito Aplicado Exitosamente.';

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Poliza AS control,
			Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$