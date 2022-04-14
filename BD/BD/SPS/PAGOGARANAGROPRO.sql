-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOGARANAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOGARANAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOGARANAGROPRO`(
	# ==============================================================
	# ---- SP PARA REALIZAR PAGO DE CREDITO AGRO VS CTA CONTABLE----
	# ==============================================================
	Par_CreditoID			BIGINT(12),			-- Numero de credito
	Par_CuentaContable		VARCHAR(25),		-- Cuenta contable con se realizara el pago de credito
	Par_CenCosto			INT(11),			-- Centro de costos con el que se registrara el movimiento
	Par_MontoPagar			DECIMAL(16,2),		-- Monto para pagar el credito
	Par_MonedaID			INT(11),			-- ID de la moneda

	Par_Finiquito			CHAR(1),			-- Si es finiquito del credito
	Par_PagarIVA			CHAR(1),			-- Si se pagara IVA
	Par_AltaEncPoliza		CHAR(1), 			-- Indica si registrara encabezado de poliza o no
	INOUT Par_Poliza		BIGINT(12),			-- Numero de poliza
	INOUT Var_MontoPago		DECIMAL(16,2),		-- Monto pagado aplicado

	INOUT Var_MontoIVAInt	DECIMAL(16,2),    	-- Monto de iva interes pagado
	INOUT Var_MontoIVAMora	DECIMAL(16,2),		-- Monto de iva moratorio pagado
	INOUT Var_MontoIVAComi	DECIMAL(16,2),    	-- Monto de iva comisiones pagado
	INOUT Par_Consecutivo	BIGINT(12),			-- Parametro inout que regresa valor consecutivo
	Par_OrigenPago			CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService,
												-- O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
												-- A: Aplicacion de Garantias Agropecuaria

	Par_Salida				CHAR(1),			-- Parametro de salida
	INOUT Par_NumErr		INT(11),			-- Parametro numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro mensaje de error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CreditoID 		BIGINT(12);		-- Variable que guarda el numero de credito
	DECLARE Var_AmortizacionID	INT(11);		-- Variable que guarda numero de amortizacion
	DECLARE Var_SaldoCapVigente	DECIMAL(16,2);	-- Variable que guarda el saldo de capital vigente
	DECLARE Var_SaldoCapAtrasa	DECIMAL(16,2);	-- Variable que guarda el saldo de capital atrasado
	DECLARE Var_SaldoCapVencido	DECIMAL(16,2);	-- Variable que guarda el saldo de capital vencido
	DECLARE Var_SaldoCapVenNExi	DECIMAL(16,2);	-- Variable que guarda el saldo de capital vencido no exigible
	DECLARE Var_SaldoInteresOrd	DECIMAL(16,4);	-- Variable que guarda el saldo de interes ordinario
	DECLARE Var_SaldoInteresAtr	DECIMAL(16,4);	-- Variable que guarda el saldo de interes atrasado
	DECLARE Var_SaldoInteresVen	DECIMAL(16,4);	-- Variable que guarda el saldo de interes vencido
	DECLARE Var_SaldoInteresPro	DECIMAL(16,4);	-- Variable que guarda el saldo de interes provisionado
	DECLARE Var_SaldoIntNoConta	DECIMAL(16,4);	-- Variable que guarda el saldo de interes no contabilizado
	DECLARE Var_SaldoMoratorios	DECIMAL(16,2); 	-- Variable que guarda el saldo de moratorios
	DECLARE Var_SaldoMoraVenci	DECIMAL(16,2);	-- Variable que guarda el saldo de moratorio vencido
	DECLARE Var_SaldoMoraCarVen	DECIMAL(16,2);	-- Variable que guarda el saldo de moratorios de cartera vencida
	DECLARE Var_SaldoComFaltaPa	DECIMAL(16,2);	-- Variable que guarda el saldo de comision por falta de pago
	DECLARE Var_SaldoOtrasComis	DECIMAL(16,2);	-- Variable que guarda el saldo de otras comisiones
	DECLARE Var_EstatusCre      CHAR(1);		-- Variable que guarda estatus de credito
	DECLARE Var_MonedaID        INT(11);		-- Variable que guarda el tipo de moneda
	DECLARE Var_FechaInicio     DATE;			-- Variable que guarda la fecha de inicio de credito
	DECLARE Var_FechaVencim     DATE;			-- Variable que guarda la fecha de vencimiento de credito
	DECLARE Var_FechaExigible   DATE;			-- Variable que guarda la fecha exigible de credito
	DECLARE Var_AmoEstatus      CHAR(1);		-- Variable que guarda el estatus de la amortizacion
	DECLARE Var_SaldoPago       DECIMAL(16, 4);	-- Variable que guarda el monto de pago
	DECLARE Var_CantidPagar     DECIMAL(16, 4);	-- Variable que guarda la cantidad a pagar
	DECLARE Var_IVACantidPagar  DECIMAL(16, 2);	-- Variable que guarda la cantidad de iva a pagar
	DECLARE Var_FechaSistema    DATE;			-- Variable que guarda la fecha del sistema
	DECLARE Var_FecAplicacion   DATE;			-- Variable que guarda la fecha de aplicacion
	DECLARE Var_EsHabil			CHAR(1);		-- Variable que guarda si un dia es habil
	DECLARE Var_IVASucurs       DECIMAL(8,4);	-- Variable que guarda el iva de sucursal
	DECLARE Var_SucCliente      INT(11);		-- Variable que guarda la sucursal del cliente
	DECLARE Var_ClienteID		INT(11);		-- Variable que guarda el numero de cliente
	DECLARE Var_ProdCreID		INT(11);		-- Variable que guarda el producto de credito
	DECLARE Var_ClasifCre		CHAR(1);		-- Variable que guarda la clasficiacion del credito
	DECLARE Var_CreditoStr		VARCHAR(20);	-- Variable que guarda el numero de credito Cadena
	DECLARE Var_NumAmorti		INT(11);		-- Variable que guarda el numero de amortizacion
	DECLARE Var_NumAmoPag		INT(11);		-- Variable que guarda el numero de amortizacion pagada
	DECLARE Var_NumAmoExi		INT(11);		-- Variable que guarda el numero de amortizacion exigible
	DECLARE Var_CliPagIVA		CHAR(1);		-- Variable que guarda si el cliente paga IVA
	DECLARE Var_IVAIntOrd		CHAR(1);     	-- Variable que guarda el iva de interes ordinario
	DECLARE Var_IVAIntMor		CHAR(1);		-- Variable que guarda el iva de interes moratorio
	DECLARE Var_ValIVAIntOr		DECIMAL(16,2);	-- Variable que guarda el valor de iva interes
	DECLARE Var_ValIVAIntMo		DECIMAL(16,2);	-- Variable que guarda el valor de iva interes moratorio
	DECLARE Var_ValIVAGen		DECIMAL(16,2);	-- Variable que guada el valor de iva generado
	DECLARE Var_EsReestruc		CHAR(1);        -- Variable que guarda si el credito es reestructura
	DECLARE Var_EstCreacion		CHAR(1);		-- Variable que guarda el estatus
	DECLARE Var_Regularizado	CHAR(1);		-- Variable que guarda el valor si se regulariza el credito
	DECLARE Var_ResPagAct       INT(11);		-- Variable que guarda el valor si se respalda el credito
	DECLARE Var_NumPagSos       INT(11);		-- Variable que guarda numero de pagos sostenido
	DECLARE Var_SubClasifID     INT(11);		-- Variable que guarda la subclasificacion del credito
	DECLARE Var_ManejaLinea		CHAR(1);		-- variable que guardar el valor de si o no maneja linea el producto de credito
	DECLARE Var_EsRevolvente	CHAR(1);		-- Variable que saber si es revolvente la linea
	DECLARE Var_LineaCredito	BIGINT(20);		-- Variable que guardar la linea de credito
	DECLARE	Var_DivContaIng		CHAR(1);		-- Variable que guardar el valor si divide ingresos de intereses
	DECLARE Var_InverEnGar      INT(11);		-- Variable que guarda si el credito tiene inversiones en garantia
	DECLARE Var_NumErrChar		VARCHAR(10);	-- Variable que guarda numero de error
    DECLARE Var_FechaIniCal		DATE;			-- Variable que guarda la fecha inicial
    DECLARE	Var_EstAmorti		CHAR(1);		-- Variable que guarda el estatus de la amortizacion
	DECLARE Var_SalCapitales    DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(14,2);
	DECLARE Esta_Vencido    	CHAR(1);
	DECLARE Esta_Vigente    	CHAR(1);
	DECLARE Esta_Atrasado   	CHAR(1);
	DECLARE Esta_Pagado     	CHAR(1);
	DECLARE Par_SalidaNO    	CHAR(1);
	DECLARE Par_SalidaSI    	CHAR(1);
	DECLARE AltaPoliza_SI   	CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE Finiquito_SI    	CHAR(1);
	DECLARE Finiquito_NO    	CHAR(1);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE SiPagaIVA      		CHAR(1);
	DECLARE Coc_PagoCred    	INT;
	DECLARE Tol_DifPago			DECIMAL(10,4);
	DECLARE Des_PagoCred		VARCHAR(50);
	DECLARE Con_PagoCred		VARCHAR(50);
	DECLARE No_EsReestruc		CHAR(1);
	DECLARE Si_EsReestruc		CHAR(1);
	DECLARE Si_Regulariza		CHAR(1);
	DECLARE No_Regulariza		CHAR(1);
	DECLARE SiManejaLinea		CHAR(1);
	DECLARE NoManejaLinea		CHAR(1);
	DECLARE SiEsRevolvente		CHAR(1);
	DECLARE NoEsRevolvente		CHAR(1);
	DECLARE Act_PagoSost		INT;
	DECLARE Mon_MinPago     	DECIMAL(12,2);
	DECLARE Ins_Credito			INT;
	DECLARE Act_LiberarPagCre	INT;
	DECLARE Pago_Efectivo		CHAR(1);
    DECLARE Procedimiento		VARCHAR(30);
	DECLARE Var_EsConsolidacionAgro  CHAR(1);  -- Es Credito Consolidado
	DECLARE Var_EstatusConsolidacion CHAR(1);  -- Estatus del credito al momento de la consolidacion
	DECLARE Var_EsRegularizado       CHAR(1);  -- Si la conlidacion es Regularizada
	DECLARE Var_NumPagosSostenidos	 INT(11);  -- Numero de Pagos Sostenidos
	DECLARE Con_SI 					 CHAR(1);  -- Constante SI
	DECLARE Con_NO 					 CHAR(1);  -- Constante NO
	DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);	-- Es Linea de Credito Agro Revolvente
	DECLARE Var_PagoLineaCredito				CHAR(1);	-- Origen del pago de una linea de credito
	DECLARE Con_CargoCta						CHAR(1);	-- Constante Origen de Pago con Cargo a Cuenta
	DECLARE Con_PagoApliGarAgro					CHAR(1);	-- Constante Origen de Pago de Aplicacion por Garantias Agro (A)

	/* DECLARACION DE CURSORES */
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT	Amo.CreditoID,			Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,		Amo.SaldoCapVencido,
				Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresVen,	Amo.SaldoInteresPro,
				Amo.SaldoIntNoConta,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Cre.MonedaID,
				Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible,		Amo.Estatus,			Amo.SaldoMoraVencido,
				Amo.SaldoMoraCarVen
			FROM	AMORTICREDITO	Amo,
					CREDITOS		Cre
			WHERE	Amo.CreditoID 	= Cre.CreditoID
			  AND	Cre.CreditoID	= Par_CreditoID
			  AND	(Cre.Estatus	= Esta_Vigente
			   OR		Cre.Estatus	= Esta_Vencido)
			  AND	(Amo.Estatus	= Esta_Vigente
			  OR		Amo.Estatus	= Esta_Vencido
			  OR		Amo.Estatus	= Esta_Atrasado)
			ORDER BY FechaExigible;

    DECLARE CURSORFECHAS CURSOR FOR
	SELECT  Amo.CreditoID,      Amo.AmortizacionID, 	Amo.FechaInicio,    	Amo.FechaVencim,        Amo.FechaExigible
		FROM AMORTICREDITO Amo,
			  CREDITOS	 Cre
		WHERE Amo.CreditoID   = Cre.CreditoID
		  AND Cre.CreditoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente
			OR Cre.Estatus    = Esta_Vencido)
		  AND Amo.Estatus	  = Esta_Vigente
		AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;


	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';              -- String Vacio
	SET Fecha_Vacia     	:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     	:= 0;               -- Entero en Cero
	SET Decimal_Cero    	:= 0.00;            -- Decimal Cero
	SET Esta_Vencido    	:= 'B';             -- Estatus Vencido
	SET Esta_Vigente    	:= 'V';             -- Estatus Vigente
	SET Esta_Atrasado   	:= 'A';             -- Estatus Atrasado
	SET Esta_Pagado     	:= 'P';             -- Estatus Pagado
	SET Par_SalidaNO    	:= 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
	SET Par_SalidaSI    	:= 'S';	            -- Ejecutar Store Con Regreso o Mensaje de Salida
	SET AltaPoliza_SI   	:= 'S';             -- Alta de la Poliza Contable: SI
	SET AltaPoliza_NO   	:= 'N';             -- Alta de la Poliza Contable: NO
	SET Finiquito_SI    	:= 'S';             -- SI es un Finiquito o Liquidacion Total Anticipada
	SET Finiquito_NO    	:= 'N';             -- NO es un Finiquito o Liquidacion Total Anticipada
	SET Pol_Automatica  	:= 'A';             -- Tipo de Poliza: Automatica
	SET SiPagaIVA       	:= 'S';             -- El Cliente si Paga IVA
	SET Coc_PagoCred    	:= 54;              -- Concepto Contable de Cartera: Pago de Credito
	SET Tol_DifPago     	:= 0.05;			-- Total de diferencia de pago
	SET Des_PagoCred    	:= 'PAGO DE CREDITO';-- Descripcion de pago de credito
	SET Con_PagoCred    	:= 'PAGO DE CREDITO';-- Descripcion constante de pago de credito
	SET No_EsReestruc   	:= 'N'; 			-- No es reestructura
	SET Si_EsReestruc   	:= 'S'; 			-- Si es reestructura
	SET Si_Regulariza   	:= 'S'; 			-- Si se regulariza
	SET No_Regulariza   	:= 'N';  			-- No se regulariza
	SET SiManejaLinea		:= 'S';	            -- Si maneja linea
	SET NoManejaLinea		:= 'N';	            -- NO maneja linea
	SET SiEsRevolvente		:= 'S';	            -- Si Es Revolvente
	SET NoEsRevolvente		:= 'N';	            -- NO Es Revolvente
	SET Act_PagoSost    	:= 2;				-- Numero de Actualizacion para pago sostenido
	SET Mon_MinPago			:= 0.01;           	-- Monto minimo de pago
	SET Ins_Credito			:= 11;				-- Tipo de Instrumento: Credito
	SET Act_LiberarPagCre	:= 3;          		-- Numero de actualizacion para liberar las inversiones en garantia
	SET Pago_Efectivo		:= 'E';				-- Tipo de pago en efectivo
    SET Procedimiento		:= 'PAGOGARANAGROPRO'; -- Procedimiento para registrar en la poliza
	SET Aud_FechaActual		:= NOW();			-- Fecha actual
    SET Aud_ProgramaID  	:= 'PAGOCREDITOPRO';
	SET Con_SI 				:= 'S';
	SET Con_NO 				:= 'N';
	SET Con_PagoApliGarAgro	:= 'A';
	SET Con_CargoCta		:= 'C';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOGARANAGROPRO');
		END;

		-- Si el Origen del pago es por Aplicacion de garantias Agro revolventes  se asgina como el tipo de pago de linea como aplicacion de garantias
		-- y el origen se ajusta a cargo a cuenta para respetar el pago con cargo a cuenta de la narrativa original
		IF( Par_OrigenPago = Con_PagoApliGarAgro ) THEN
			SET Var_PagoLineaCredito 	:= Con_PagoApliGarAgro;
			SET Par_OrigenPago 			:= Con_CargoCta;
		END IF;

		SET Var_PagoLineaCredito 	:= IFNULL(Var_PagoLineaCredito, Con_CargoCta);
		SET Par_OrigenPago 			:= IFNULL(Par_OrigenPago, Con_CargoCta);

		-- Inicializacion
		SET	Var_MontoIVAInt		:= Entero_Cero;
		SET	Var_MontoIVAMora	:= Entero_Cero;
		SET	Var_MontoIVAComi	:= Entero_Cero;
		SET Par_Consecutivo		:= Entero_Cero;

		/* SE REALIZAN LAS ASIGNACIONES SIN EL INTO YA QUE SE MANDA A LLAMAR DENTRO DE UN CURSOR */
		SET Var_FechaSistema	:= (SELECT FechaSistema			FROM PARAMETROSSIS);
		SET Var_DivContaIng		:= (SELECT DivideIngresoInteres FROM PARAMETROSSIS);
		SET Var_ClienteID		:= (SELECT Cre.ClienteID			FROM CREDITOS Cre	WHERE Cre.CreditoID	= Par_CreditoID);
		SET Var_ProdCreID		:= (SELECT Cre.ProductoCreditoID	FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		SET Var_NumAmorti		:= (SELECT Cre.NumAmortizacion		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		SET Var_EstatusCre		:= (SELECT Cre.Estatus				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		SET Var_MonedaID		:= (SELECT Cre.MonedaID				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		SET Var_LineaCredito	:= (SELECT Cre.LineaCreditoID		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		SET Var_SucCliente		:= (SELECT Cli.SucursalOrigen		FROM CLIENTES Cli	WHERE Cli.ClienteID = Var_ClienteID);
		SET Var_CliPagIVA		:= (SELECT Cli.PagaIVA				FROM CLIENTES Cli	WHERE Cli.ClienteID = Var_ClienteID);
		SET Var_ClasifCre		:= (SELECT Des.Clasificacion 		FROM DESTINOSCREDITO Des, CREDITOS Cre
																	WHERE	Cre.CreditoID	= Par_CreditoID	AND Cre.DestinoCreID	= Des.DestinoCreID);
		SET Var_SubClasifID		:= (SELECT Des.SubClasifID 			FROM DESTINOSCREDITO Des, CREDITOS Cre
																	WHERE	Cre.CreditoID	= Par_CreditoID	AND Cre.DestinoCreID	= Des.DestinoCreID);
		SET Var_IVAIntOrd		:= (SELECT Pro.CobraIVAInteres		FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
		SET Var_IVAIntMor		:= (SELECT Pro.CobraIVAMora			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID 	= Var_ProdCreID);
		SET Var_EsReestruc		:= (SELECT Pro.EsReestructura		FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
		SET Var_ManejaLinea		:= (SELECT Pro.ManejaLinea			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
		SET Var_EsRevolvente	:= (SELECT Pro.EsRevolvente			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
		SET Var_EstCreacion		:= (SELECT Res.EstatusCreacion		FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);
		SET Var_Regularizado	:= (SELECT Res.Regularizado			FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);
		SET Var_ResPagAct		:= (SELECT Res.NumPagoActual		FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);

		SET	Var_DivContaIng		:= IFNULL(Var_DivContaIng,	Cadena_Vacia);
		SET Var_EstCreacion     := IFNULL(Var_EstCreacion,	Cadena_Vacia);
		SET Var_Regularizado    := IFNULL(Var_Regularizado,	Cadena_Vacia);
		SET Var_ResPagAct		:= IFNULL(Var_ResPagAct, 	Entero_Cero);
		SET Var_SubClasifID		:= IFNULL(Var_SubClasifID,	Entero_Cero);
		SET Var_LineaCredito	:= IFNULL(Var_LineaCredito, Entero_Cero);
		SET Var_ManejaLinea		:= IFNULL(Var_ManejaLinea, NoManejaLinea);
		SET Var_EsRevolvente	:= IFNULL(Var_EsRevolvente, NoEsRevolvente);

		IF( Var_LineaCredito <> Entero_Cero ) THEN
			SET Var_EsLineaCreditoAgroRevolvente := ( SELECT EsRevolvente
													  FROM LINEASCREDITO
													  WHERE LineaCreditoID = Var_LineaCredito
														AND EsAgropecuario = Con_SI);
		END IF;

		SET Var_EsLineaCreditoAgroRevolvente := IFNULL(Var_EsLineaCreditoAgroRevolvente, Cadena_Vacia);

		SET Var_EsConsolidacionAgro	:= (SELECT Cre.EsConsolidacionAgro	FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
		IF( Var_EsConsolidacionAgro = Con_SI ) THEN
			SET Var_EstatusConsolidacion := IFNULL((SELECT EstatusCreacion FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Cadena_Vacia);
			SET Var_EsRegularizado       := IFNULL((SELECT Regularizado FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Con_NO);
			SET Var_NumPagosSostenidos   := IFNULL((SELECT NumPagoActual FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Entero_Cero);
		END IF;

		IF(Var_EstCreacion = Cadena_Vacia) THEN
			SET Var_EsReestruc  := No_EsReestruc;
		ELSE
			SET Var_EsReestruc  := SI_EsReestruc;
		END IF;

		SET Var_IVASucurs	:=	(SELECT IVA	FROM SUCURSALES	WHERE SucursalID = Var_SucCliente);

		SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
		SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
		SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
		SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

		-- Inicializaciones
		SET Var_ValIVAIntOr := Entero_Cero;
		SET Var_ValIVAIntMo := Entero_Cero;
		SET Var_ValIVAGen   := Entero_Cero;
		SET Var_NumPagSos   := Entero_Cero;


		IF (Var_CliPagIVA = SiPagaIVA) THEN
			SET Var_ValIVAGen  := Var_IVASucurs;

			IF (Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr  := Var_IVASucurs;
			END IF;

			IF (Var_IVAIntMor = SiPagaIVA) THEN
				SET Var_ValIVAIntMo  := Var_IVASucurs;
			END IF;
		END IF;


        /* Respaldamos las tablas de CREDITOS, AMORTICREDITO, CREDITOSMOVS antes de realizar el pago (usado para la reversa)*/
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


		-- Revisamos si es una Liquidacion Anticipada o Finiquito
		IF( Par_Finiquito = Finiquito_SI) THEN
			SET Con_PagoCred 	:= "LIQUIDACION ANT.CREDITO";

		END IF;

		CALL DIASFESTIVOSCAL(
			Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= 1;
			SET Par_ErrMen		:= 'El Credito no Existe';
			SET Par_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_EmpresaID,		Var_FecAplicacion,	Pol_Automatica,		Coc_PagoCred,
				Con_PagoCred,		Par_SalidaNO,		Par_NumErr,         Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		SET Var_SaldoPago       := Par_MontoPagar;
		SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));


		OPEN CURSORAMORTI;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP

			FETCH CURSORAMORTI INTO
				Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoCapVigente,    Var_SaldoCapAtrasa,		Var_SaldoCapVencido,
				Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,    Var_SaldoInteresAtr,    Var_SaldoInteresVen,    Var_SaldoInteresPro,
				Var_SaldoIntNoConta,    Var_SaldoMoratorios,    Var_SaldoComFaltaPa,    Var_SaldoOtrasComis,    Var_MonedaID,
				Var_FechaInicio,        Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoMoraVenci,
				Var_SaldoMoraCarVen;

			-- Inicializaciones
			SET Var_CantidPagar		:= Decimal_Cero;
			SET Var_IVACantidPagar	:= Decimal_Cero;
			SET Var_NumPagSos       := Entero_Cero;
			SET	Var_SaldoMoraVenci	:= IFNULL(Var_SaldoMoraVenci, Entero_Cero);
			SET	Var_SaldoMoraCarVen	:= IFNULL(Var_SaldoMoraCarVen, Entero_Cero);
			SET Var_SalCapitales	:= Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi;

			IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;


			-- Comision por Falta de Pago
			IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:= Var_SaldoComFaltaPa;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAComi	:= Var_MontoIVAComi + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAComi	:= Var_MontoIVAComi + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				END IF;

				CALL  PAGCRECOMFALPRO (
					Var_CreditoID,	    Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,	Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,	Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,		Par_CuentaContable,	Par_Poliza,         Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			-- Saldo de Interes Moratorio Vencido
			IF (Var_SaldoMoraVenci >= Mon_MinPago) THEN
				SET	Var_IVACantidPagar = ROUND((Var_SaldoMoraVenci *  Var_ValIVAIntMo), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoraVenci + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoMoraVenci;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				END IF;

				CALL  PAGCREMORATOVENCPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,         Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,      Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;
			END IF;

			/* Saldo de Interes Moratorio de Cartera Vencida (Cuentas de Orden)*/
			IF (Var_SaldoMoraCarVen >= Mon_MinPago) THEN
				SET	Var_IVACantidPagar = ROUND((Var_SaldoMoraCarVen *  Var_ValIVAIntMo), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoraCarVen + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoMoraCarVen;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				END IF;

				CALL  PAGCREMORACARVENPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,			Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Pago_Efectivo,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;
			END IF;

			-- Pago de Interes Moratorio Vigente
			IF (Var_SaldoMoratorios >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND((Var_SaldoMoratorios *  Var_ValIVAIntMo), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoMoratorios;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;
				END IF;

				CALL  PAGCREMORAPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Var_SaldoMoratorios,Par_Poliza,			Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoInteresVen >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND(ROUND(Var_SaldoInteresVen,2) *  Var_ValIVAIntOr, 2);

				IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresVen,2) + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoInteresVen;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				ELSE
					SET	Var_CantidPagar		:= Var_SaldoPago -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				END IF;

				CALL PAGCREINTVENPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,			Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_ValIVAIntOr), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresAtr, 2) + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoInteresAtr;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				ELSE
					SET	Var_CantidPagar		:= Var_SaldoPago -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				END IF;

				CALL PAGCREINTATRPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,         Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoInteresPro;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				ELSE
					SET	Var_CantidPagar		:= Var_SaldoPago -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				END IF;

				CALL PAGCREINTPROPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,			Par_OrigenPago,		Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			-- Pago de Interes no Contabilizado, Cuentas de Orden
			IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

				SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_ValIVAIntOr), 2);

				IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoIntNoConta, 2) + Var_IVACantidPagar)) THEN
					SET	Var_CantidPagar		:=  Var_SaldoIntNoConta;

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				ELSE
					SET	Var_CantidPagar		:= Var_SaldoPago -
											   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

					/* Se Verifica si el Parametro del Store indica que se paga el IVA o NO*/
					IF(Par_PagarIVA != SiPagaIVA) THEN
						SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
						SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
						SET	Var_IVACantidPagar	:=  Entero_Cero;
					END IF;

				END IF;

				CALL PAGCREINTNOCPRO (
					Var_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
					Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,		Par_Poliza,         Var_DivContaIng,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion	);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoCapVencido >= Mon_MinPago) THEN

				IF(ROUND(Var_SaldoPago,2)	>= Var_SaldoCapVencido) THEN
					SET	Var_CantidPagar		:= Var_SaldoCapVencido;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
				END IF;

				CALL PAGCRECAPVENPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,         Var_SalCapitales,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  /* si el credito tiene linea de credito*/
					IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si maneja linea de credito*/
						IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si es revolvente */
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						ELSE
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						END IF;
					END IF;
				END IF;

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

				IF(ROUND(Var_SaldoPago,2)	>= Var_SaldoCapAtrasa) THEN
					SET	Var_CantidPagar		:= Var_SaldoCapAtrasa;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
				END IF;

				CALL PAGCRECAPATRPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,		Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  	Var_CantidPagar,    Decimal_Cero,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      	Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,         	Var_SalCapitales,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				IF( Var_LineaCredito !=  Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  /* si el credito tiene linea de credito*/
					IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si maneja linea de credito*/
						IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si es revolvente */
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						ELSE
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						END IF;
					END IF;
				END IF;

				SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

				IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
					SET	Var_CantidPagar		:= Var_SaldoCapVigente;
				ELSE
					SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
				END IF;

				CALL PAGCRECAPVIGPRO (
					Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,         Var_SalCapitales,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

				IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  /* si el credito tiene linea de credito*/
					IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si maneja linea de credito*/
						IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si es revolvente */
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + ROUND(Var_CantidPagar,2),
								SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + ROUND(Var_CantidPagar,2) ,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						ELSE
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						END IF;
					END IF;
				END IF;

				SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
			IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

				IF(Var_SaldoPago	>= Var_SaldoCapVenNExi) THEN
					SET	Var_CantidPagar := Var_SaldoCapVenNExi;
				ELSE
					SET	Var_CantidPagar := ROUND(Var_SaldoPago,2);
				END IF;

				CALL PAGCRECAPVNEPRO (
					Var_CreditoID,	    Var_AmortizacionID, Var_FechaInicio,		Var_FechaVencim,    Entero_Cero,
					Var_ClienteID,	    Var_FechaSistema,   Var_FecAplicacion,		Var_CantidPagar,    Decimal_Cero,
					Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,			Var_SubClasifID,    Var_SucCliente,
					Des_PagoCred,       Par_CuentaContable,	Par_Poliza,        	 	Var_SalCapitales,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Pago_Efectivo,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				/* Se registra la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si se marca como Pagada*/
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;


				IF( Var_LineaCredito != Cadena_Vacia AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  /* si el credito tiene linea de credito*/
					IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si maneja linea de credito*/
						IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si es revolvente */
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
								SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						ELSE
							UPDATE LINEASCREDITO SET
								Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE LineaCreditoID	= Var_LineaCredito;
						END IF;
					END IF;
				END IF;


				IF ((Var_SaldoCapVenNExi - Var_CantidPagar) <= Tol_DifPago AND
					(Var_FechaExigible <= Var_FechaSistema AND
					 Var_AmoEstatus = Esta_Vigente) ) THEN

					IF( (Var_EsReestruc = SI_EsReestruc AND Var_EstCreacion  = Esta_Vencido  AND Var_Regularizado = No_Regulariza) OR
						(Var_EsConsolidacionAgro = Con_SI AND Var_EstatusConsolidacion = Esta_Vencido AND Var_EsRegularizado = No_Regulariza) ) THEN

						SET Var_NumPagSos = Var_ResPagAct + 1;
						IF( Var_EsConsolidacionAgro = Con_SI ) THEN
							SET Var_NumPagSos := Var_NumPagosSostenidos + 1;
						END IF;

						CALL REESTRUCCREDITOACT (
							Var_FechaSistema,   Var_CreditoID,      Entero_Cero,    	Cadena_Vacia,   	Cadena_Vacia,
							Entero_Cero,        Entero_Cero,        Var_NumPagSos,  	Par_Poliza,     	Act_PagoSost,
							Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,  	Pago_Efectivo,
							Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,
							Aud_NumTransaccion  );

						IF( Par_NumErr <> Entero_Cero ) THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

				IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
					LEAVE CICLO;
				END IF;

			END IF;

			END LOOP CICLO;
		END;
		CLOSE CURSORAMORTI;

		SET Var_SaldoPago   := IFNULL(Var_SaldoPago, Entero_Cero);

		IF(Var_SaldoPago < Entero_Cero) THEN
			SET Var_SaldoPago   := Entero_Cero;
		END IF;

		SET	Var_MontoPago	 := Par_MontoPagar - ROUND(Var_SaldoPago,2);

		IF (Var_MontoPago > Decimal_Cero) THEN

		/* Amortizaciones que hayan Sido Afectada con el Pago Para evitar Marcar Como Pagadas, aquellas Amortizaciones
		   Futuras que no Tienen Capital que son de Solo Interes*/
			UPDATE AMORTICREDITO Amo SET
				Amo.Estatus		= Esta_Pagado,
				Amo.FechaLiquida	= Var_FechaSistema
				WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi +
					  Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro +
					  Amo.SaldoIntNoConta + Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen +
					  Amo.SaldoComFaltaPa + Amo.SaldoComServGar + Amo.SaldoOtrasComis ) <= Tol_DifPago
				  AND Amo.CreditoID 	= Par_CreditoID
				  AND Amo.Estatus 	!= Esta_Pagado
				AND Amo.NumTransaccion = Aud_NumTransaccion;

			-- Si es un Finiquito Marcamos las cuotas como Pagadas
			IF( Par_Finiquito = Finiquito_SI) THEN
				UPDATE AMORTICREDITO Amo SET
					Amo.Estatus		= Esta_Pagado,
					Amo.FechaLiquida	= Var_FechaSistema
					WHERE Amo.CreditoID 	= Par_CreditoID
					  AND Amo.Estatus 	!= Esta_Pagado;
			END IF;

			SET Var_NumAmoPag	:=	(SELECT COUNT(AmortizacionID)
										FROM AMORTICREDITO
										WHERE CreditoID	= Par_CreditoID
										  AND Estatus		= Esta_Pagado);

			SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

			IF (Var_NumAmorti = Var_NumAmoPag) THEN
				UPDATE CREDITOS SET
					Estatus			= Esta_Pagado,
					FechTerminacion	= Var_FechaSistema,

					Usuario		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID  	= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion

					WHERE CreditoID = Par_CreditoID;
				/* se revisa si estaba comprometida con creditos se liberan anticipadamente */
				SET Var_InverEnGar	:= (SELECT COUNT(CreditoID)
											FROM CREDITOINVGAR
											WHERE CreditoID = Par_CreditoID);
				SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);

				IF(Var_InverEnGar >Entero_Cero)THEN /* si la inversion esta respaldando algun credito se liberan*/
					CALL CREDITOINVGARACT(
						Entero_Cero,		Par_CreditoID,		Entero_Cero,	Par_Poliza,			Act_LiberarPagCre,
						Par_SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
					);
					IF(Par_NumErr <> Entero_Cero)THEN
						SET Par_NumErr		:= 101;
						SET Par_ErrMen		:= Par_ErrMen;
						SET Par_Consecutivo	:= 0;
						LEAVE ManejoErrores;
					ELSE
						SET Par_NumErr		:= 0;
						SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
					END IF;
				END IF;


			ELSEIF (Var_EstatusCre = Esta_Vencido) THEN				-- Consideraciones para ver si Regularizamos el Credito que esta Vencido

				SET Var_NumAmoExi	:=	(SELECT	COUNT(AmortizacionID)
											FROM AMORTICREDITO
											WHERE CreditoID		= Par_CreditoID
											  AND Estatus			!= Esta_Pagado
											  AND FechaExigible	< Var_FechaSistema);

				SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);


				IF (Var_NumAmoExi = Entero_Cero) THEN

					IF ( ( Var_EsReestruc = No_EsReestruc ) OR

						 ( Var_EsReestruc   = SI_EsReestruc AND
						   Var_EstCreacion  = Esta_Vigente) OR

						 ( Var_EsReestruc   = SI_EsReestruc AND
						   Var_EstCreacion  = Esta_Vencido AND
						   Var_Regularizado = Si_Regulariza) OR

						 ( Var_EsConsolidacionAgro = Con_SI AND
						   Var_EstatusConsolidacion = Esta_Vencido AND
						   Var_EsRegularizado = Si_Regulariza) ) THEN

						CALL REGULARIZACREDPRO (
							Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,  	Par_Poliza,     Par_EmpresaID,
							Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Pago_Efectivo,  Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
					END IF;
				END IF;
			END IF;

		END IF;

		SET	Var_FechaIniCal := Var_FechaSistema;

		/* Cursor para ReCalendarizar las Fechade Inicio de las Cuotas, para poder devengar correctamente los intereses*/
		OPEN CURSORFECHAS;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOFECHAS:LOOP

			FETCH CURSORFECHAS INTO
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible;

			SET	Var_EstAmorti	:= Cadena_Vacia;

			IF(Var_FechaInicio >= Var_FechaSistema) THEN

				SET Var_EstAmorti := (SELECT Estatus
										FROM AMORTICREDITO
										WHERE CreditoID = Var_CreditoID
										 AND FechaVencim = Var_FechaInicio );

				SET Var_EstAmorti := IFNULL(Var_EstAmorti, Cadena_Vacia);

				IF(Var_EstAmorti = Esta_Pagado) THEN
					UPDATE AMORTICREDITO SET
						FechaInicio = Var_FechaIniCal

						WHERE CreditoID = Var_CreditoID
						 AND AmortizacionID = Var_AmortizacionID;

					SET	Var_FechaIniCal := Var_FechaVencim;
				END IF;

			END IF;


			END LOOP CICLOFECHAS;
		END;
		CLOSE CURSORFECHAS;

		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion,	Par_CuentaContable,	Par_CreditoID,	Var_MontoPago,	Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;


		-- Alta de la Poliza Contable a la Cuenta Directa
		IF(Var_MontoPago > Entero_Cero) THEN
			SET	Des_PagoCred	:= 'PAGO DE CREDITO CON CUENTA CONTABLE';

			SET	Par_CenCosto	:= IFNULL(Par_CenCosto, FNCENTROCOSTOS(Aud_Sucursal));

			CALL DETALLEPOLIZASALT(
				Par_EmpresaID,		Par_Poliza,			Var_FecAplicacion, 		Par_CenCosto,		Par_CuentaContable,
				Var_CreditoStr,		Par_MonedaID,		Var_MontoPago,			Decimal_Cero,		Des_PagoCred,
				Var_CreditoStr,		Procedimiento,		Ins_Credito,			Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		Par_SalidaNO,		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente.';
		SET Par_Consecutivo	:= Entero_Cero;

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = Par_SalidaSI) THEN
		SELECT 	CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen AS ErrMen,
				'creditoID' AS control,
				Entero_Cero AS consecutivo;
	END IF;


END TerminaStore$$