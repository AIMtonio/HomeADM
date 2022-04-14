-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGCRECONTAVIGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGCRECONTAVIGPRO`;
DELIMITER $$

CREATE PROCEDURE `PREPAGCRECONTAVIGPRO`(
/* SP DE PROCESO CONTABLE PARA EL PREPAGO CAPITAL VIGENTE */
    Par_CreditoID     	BIGINT(12),
	Par_CuentaContable	VARCHAR(25),
    Par_MontoPagar    	DECIMAL(14,2),
    Par_MonedaID      	INT(11),
    Par_EmpresaID     	INT(11),

	Par_PagarIVA		CHAR(1),
	INOUT Var_MontoIVAInt	DECIMAL(12,2),
    Par_Salida        	CHAR(1),
    Par_AltaEncPoliza	CHAR(1),
    Par_AltaDetPoliza	CHAR(1),

	OUT Par_MontoPago	DECIMAL(12,2),
	INOUT Var_Poliza	BIGINT,
	Par_OrigenPago		CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr	INT(11),
	OUT	Par_ErrMen		VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT,

    Par_Respaldar		CHAR(1),
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
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecAplicacion   DATE;
DECLARE Var_DiasCredito     INT;
DECLARE Var_SucCliente      INT;
DECLARE Var_ClienteID		BIGINT;
DECLARE Var_ProdCreID		INT;
DECLARE Var_ClasifCre		CHAR(1);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_CliPagIVA   	CHAR(1);
DECLARE Var_IVAIntOrd   	CHAR(1);
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_MonedaID        INT;
DECLARE Var_SubClasifID     INT;
DECLARE Var_MonPagoOri		DECIMAL(12,2);

DECLARE Var_CreditoID       BIGINT(12);           			-- Variables para los Cursores
DECLARE Var_AmortizacionID  INT;
DECLARE Var_SalCapitales	DECIMAL(14,2);
DECLARE Var_SaldoCapVigente DECIMAL(14,2);
DECLARE Var_SaldoCapVenNExi DECIMAL(14,2);
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);
DECLARE Var_SaldoInteresPro	DECIMAL(14,4);
DECLARE	Var_SaldoIntNoConta	DECIMAL(14,4);
DECLARE Var_ProvisionAcum   DECIMAL(14,4);

DECLARE Var_IVASucurs   	DECIMAL(8, 4);
DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
DECLARE Var_TotDeuda    	DECIMAL(14,2);
DECLARE Var_NumAtrasos  	INT;
DECLARE Var_EsHabil     	CHAR(1);
DECLARE Var_CreditoStr		VARCHAR(20);
DECLARE Var_SaldoPago       DECIMAL(14,2);
DECLARE Var_CantidPagar     DECIMAL(14,2);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_CalInteresID    INT;
DECLARE Var_Dias            INT;
DECLARE Var_TotCapital      DECIMAL(14,2);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_MaxAmoCapita    INT;
DECLARE Var_IVACantidPagar  DECIMAL(12, 2);
DECLARE	Var_FechaIniCal		DATE;
DECLARE	Var_EstAmorti		CHAR(1);
DECLARE Var_TotDeudaCap		DECIMAL(14,2);
DECLARE Var_MaxAmorti		INT;
DECLARE Var_PorcentajePag	DECIMAL(12,8);
DECLARE	Var_DivContaIng		CHAR(1);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero		DECIMAL(12, 2);
DECLARE SiPagaIVA			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Esta_Pagado     	CHAR(1);
DECLARE Esta_Activo     	CHAR(1);
DECLARE Esta_Vencido    	CHAR(1);
DECLARE Esta_Vigente    	CHAR(1);

DECLARE AltaPoliza_SI		CHAR(1);
DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE Pol_Automatica  	CHAR(1);
DECLARE Mon_MinPago     	DECIMAL(12,2);
DECLARE Tol_DifPago     	DECIMAL(10,4);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);
DECLARE Aho_PagoCred		CHAR(4);
DECLARE Con_AhoCapital  	INT;
DECLARE AltaMovAho_SI   	CHAR(1);
DECLARE Tasa_Fija       	INT;
DECLARE	SI_Respaldar		CHAR(1);

DECLARE Coc_PagoCred    	INT;
DECLARE Ref_PagAnti     	VARCHAR(50);
DECLARE Con_PagoCred    	VARCHAR(50);
DECLARE TipoActInteres		INT(11);

DECLARE CURSORAMORTI CURSOR FOR
    SELECT  Amo.CreditoID,      Amo.AmortizacionID, 	Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,
            Cre.MonedaID,       Amo.FechaInicio,    	Amo.FechaVencim,        Amo.FechaExigible,
            Amo.Estatus,		Amo.SaldoInteresPro,	Amo.SaldoIntNoConta
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
SET Cadena_Vacia    := '';              	-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
SET Entero_Cero		:= 0;					-- Entero en Cero
SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
SET Esta_Activo     := 'A';             	-- Estatus: Activo
SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
SET Esta_Vigente    := 'V';             	-- Estatus del Credito: Vigente

SET AltaPoliza_SI   := 'S';             	-- SI dar de alta la Poliza Contable
SET AltaPoliza_NO   := 'N';             	-- NO dar de alta la Poliza Contable
SET Pol_Automatica  := 'A';             	-- Tipo de Poliza: Automatica
SET Mon_MinPago     := 0.01;            	-- Monto Minimo para Aceptar un Pago
SET Tol_DifPago     := 0.02;            	-- Minimo de la deuda para marcarlo como Pagado
SET Nat_Cargo       := 'C';             	-- Naturaleza de Cargo
SET Nat_Abono       := 'A';					-- Naturaleza de Abono
SET Aho_PagoCred    := '101';           	-- Concepto de Pago de Credito
SET Con_AhoCapital  := 1;               	-- Concepto de Ahorro: Capital
SET AltaMovAho_SI   := 'S';             	-- Alta del Movimiento de Ahorro: SI
SET Tasa_Fija       := 1;               	-- Tipo de Tasa de Interes: Fija
SET Coc_PagoCred    := 54;              	-- Concepto Contable: Pago de Credito
SET SI_Respaldar	:= 'S';					-- Si hacer el Respaldo del Credito
SET TipoActInteres	:= 1;					-- Tipo de Actualizacion (intereses)

SET Ref_PagAnti     := 'PAGO ANTICIPADO CREDITO';
SET Con_PagoCred    := 'PAGO DE CREDITO';
SET Aud_ProgramaID 	:= 'PAGOCREDITOPRO';

SET Aud_FechaActual	:= NOW();
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PREPAGCRECONTAVIGPRO');
		END;

	SET	Par_NumErr			:= Entero_Cero;
	SET Var_FechaSistema	:= (SELECT FechaSistema 	FROM PARAMETROSSIS);
    SET Var_DiasCredito		:= (SELECT DiasCredito		FROM PARAMETROSSIS);
    SET Var_DivContaIng		:= (SELECT DivideIngresoInteres FROM PARAMETROSSIS);
	SET	Var_DivContaIng		:= IFNULL(Var_DivContaIng, Cadena_Vacia);

    SET Var_ClienteID		:= (SELECT Cre.ClienteID 			FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_ProdCreID		:= (SELECT Cre.ProductoCreditoID 	FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_EstatusCre		:= (SELECT Cre.Estatus 				FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_CreTasa			:= (SELECT Cre.TasaFija 			FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_MonedaID		:= (SELECT Cre.MonedaID 			FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_CalInteresID	:= (SELECT Cre.CalcInteresID 		FROM CREDITOS Cre 			WHERE Cre.CreditoID 	= Par_CreditoID);
    SET Var_SucCliente		:= (SELECT Cli.SucursalOrigen		FROM CLIENTES Cli			WHERE Cli.ClienteID 	= Var_ClienteID);
    SET Var_CliPagIVA		:= (SELECT Cli.PagaIVA				FROM CLIENTES Cli			WHERE Cli.ClienteID 	= Var_ClienteID);
    SET Var_IVAIntOrd		:= (SELECT Pro.CobraIVAInteres		FROM PRODUCTOSCREDITO Pro 	WHERE Pro.ProducCreditoID = Var_ProdCreID);
    SET Var_ClasifCre		:= (SELECT Des.Clasificacion
									FROM DESTINOSCREDITO Des, CREDITOS Cre
										WHERE Cre.CreditoID			= Par_CreditoID
										AND Cre.DestinoCreID       = Des.DestinoCreID);
    SET Var_SubClasifID		:= (SELECT Des.SubClasifID
									FROM DESTINOSCREDITO Des, CREDITOS Cre
										WHERE Cre.CreditoID			= Par_CreditoID
										AND Cre.DestinoCreID       = Des.DestinoCreID);
    SET Var_TotDeuda		:= FUNCIONTOTDEUDACRE(Par_CreditoID);

	-- Inicializaciones
	SET Var_SucCliente  := IFNULL(Var_SucCliente,Entero_Cero);
	SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero);
	SET Var_ProdCreID   := IFNULL(Var_ProdCreID,Entero_Cero);
	SET Var_ClasifCre   := IFNULL(Var_ClasifCre,Cadena_Vacia);
	SET Var_EstatusCre  := IFNULL(Var_EstatusCre,Cadena_Vacia);
	SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA,SiPagaIVA);
	SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd,SiPagaIVA);
	SET Var_CreTasa     := IFNULL(Var_CreTasa,Entero_Cero);
	SET Var_MonedaID    := IFNULL(Var_MonedaID,Entero_Cero);
	SET Var_SubClasifID := IFNULL(Var_SubClasifID,Entero_Cero);
	SET Var_TotDeuda    := IFNULL(Var_TotDeuda,Entero_Cero);

	SET Var_IVASucurs	:= (SELECT IVA FROM SUCURSALES WHERE SucursalID	= Var_SucCliente);
	SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
	SET Var_ValIVAIntOr := Entero_Cero;
	SET Par_NumErr  	:= Entero_Cero;
	SET Par_ErrMen 		:= 'PrePago de Credito Aplicado Exitosamente.';

	IF (Var_CliPagIVA = SiPagaIVA) THEN
		IF (Var_IVAIntOrd = SiPagaIVA) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;
	END IF;

	IF(Par_MontoPagar >= Var_TotDeuda) THEN
		SET Par_NumErr      := 1;
		SET Par_ErrMen      := 'Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opcion Finiquito' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_NumAtrasos	:= (SELECT COUNT(AmortizacionID)
								FROM AMORTICREDITO
								WHERE CreditoID = Par_CreditoID
								  AND FechaExigible <= Var_FechaSistema
								  AND Estatus != Esta_Pagado);
	SET Var_NumAtrasos := IFNULL(Var_NumAtrasos, Entero_Cero);

	IF(Var_NumAtrasos > Entero_Cero) THEN
		SET Par_NumErr      := 2;
		SET Par_ErrMen      := 'Antes de Realizar un PrePago, Por Favor realice el Pago de lo Exigible y en Atraso.' ;
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,   Entero_Cero,		Var_FecAplicacion,  Var_EsHabil,    Par_EmpresaID,
		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);


	IF(Var_EstatusCre = Cadena_Vacia ) THEN
		SET Par_NumErr      := 8;
		SET Par_ErrMen      := 'El Credito no Existe';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCre != Esta_Vigente AND
	   Var_EstatusCre != Esta_Vencido ) THEN

		SET Par_NumErr      := 9;
		SET Par_ErrMen      := 'Estatus del Credito Incorrecto';
		LEAVE ManejoErrores;

	END IF;

	-- Obtenemos el Saldo de Capital
	SET Var_TotDeudaCap	:= (SELECT SUM(IFNULL(Amo.SaldoCapVigente, Entero_Cero) + IFNULL(Amo.SaldoCapVenNExi, Entero_Cero))
								FROM AMORTICREDITO Amo
									WHERE Amo.CreditoID	= Par_CreditoID
									  AND Amo.Estatus	= Esta_Vigente);
	SET	Var_TotDeudaCap	:= IFNULL(Var_TotDeudaCap, Entero_Cero);

	-- Obtenemos la Ultima Amortizacion Vigente
	SET Var_MaxAmorti :=	(SELECT  MAX(Amo.AmortizacionID)
								FROM AMORTICREDITO Amo
									WHERE Amo.CreditoID   = Par_CreditoID
										AND Amo.Estatus		= Esta_Vigente
										AND Amo.FechaExigible > Var_FechaSistema);

	SET	Var_MaxAmorti	:= IFNULL(Var_MaxAmorti, Entero_Cero);

	-- Respaldo de las Tablas de Creditos, para su posible posterior reversa
	IF(Par_Respaldar = SI_Respaldar) THEN
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	END IF;

	-- Alta del Maestro de la Poliza
	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZAALT(
			Var_Poliza,		Par_EmpresaID,	Var_FecAplicacion,  Pol_Automatica,     Coc_PagoCred,
			Con_PagoCred,	SalidaNO,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
	END IF;


	SET Var_SaldoPago       := Par_MontoPagar;
	SET Var_MonPagoOri		:= Par_MontoPagar;
	SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));

	OPEN CURSORAMORTI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTI INTO
			Var_CreditoID,      Var_AmortizacionID, Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
			Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoInteresPro,
			Var_SaldoIntNoConta;

		-- Inicializacion
		SET Var_CantidPagar		:= Decimal_Cero;
		SET Var_IVACantidPagar	:= Decimal_Cero;
		SET Var_PorcentajePag	:= IF(Var_TotDeudaCap != Decimal_Cero, ROUND((Var_SaldoCapVigente + Var_SaldoCapVenNExi)/Var_TotDeudaCap,8), Decimal_Cero);
		SET Var_SalCapitales	:= (Var_SaldoCapVigente + Var_SaldoCapVenNExi);

		IF(Var_SaldoPago	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

		-- Pago de Interes Provisionado
		IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoInteresPro;

				-- Verificamos si el Parametro del Store indica que se paga el IVA o NO, independienemente de lo que diga el Producto
				-- Por ejemplo en un fallecimiento del Cliente, se aplica el Seguro y el Seguro podria no cubrir los IVAS
				IF(Par_PagarIVA != SiPagaIVA) THEN
					SET	Var_MontoIVAInt	:= Var_MontoIVAInt + Var_IVACantidPagar;
					SET	Var_IVACantidPagar	:=  Entero_Cero;
				END IF;

			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				-- Verificamos si el Parametro del Store indica que se paga el IVA o NO, independienemente de lo que diga el Producto
				-- Por ejemplo en un fallecimiento del Cliente, se aplica el Seguro y el Seguro podria no cubrir los IVAS
				IF(Par_PagarIVA != SiPagaIVA) THEN
					SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
					SET	Var_MontoIVAInt	:= Var_MontoIVAInt + Var_IVACantidPagar;
					SET	Var_IVACantidPagar	:=  Entero_Cero;
				END IF;

			END IF;

			CALL PAGCREINTPROPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,       Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;


			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			SET	Var_MonPagoOri	:= Var_MonPagoOri - (Var_CantidPagar + Var_IVACantidPagar);

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		-- Pago de Interes Calculado no Contabilizado
		IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoIntNoConta, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoIntNoConta;

				-- Verificamos si el Parametro del Store indica que se paga el IVA o NO, independienemente de lo que diga el Producto
				-- Por ejemplo en un fallecimiento del Cliente, se aplica el Seguro y el Seguro podria no cubrir los IVAS
				IF(Par_PagarIVA != SiPagaIVA) THEN
					SET	Var_MontoIVAInt	:= Var_MontoIVAInt + Var_IVACantidPagar;
					SET	Var_IVACantidPagar	:=  Entero_Cero;
				END IF;

			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				-- Verificamos si el Parametro del Store indica que se paga el IVA o NO, independienemente de lo que diga el Producto
				-- Por ejemplo en un fallecimiento del Cliente, se aplica el Seguro y el Seguro podria no cubrir los IVAS
				IF(Par_PagarIVA != SiPagaIVA) THEN
					SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
					SET	Var_MontoIVAInt	:= Var_MontoIVAInt + Var_IVACantidPagar;
					SET	Var_IVACantidPagar	:=  Entero_Cero;
				END IF;

			END IF;

			CALL PAGCREINTNOCPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,	Var_Poliza,         Var_DivContaIng,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;


			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			SET	Var_MonPagoOri	:= Var_MonPagoOri - (Var_CantidPagar + Var_IVACantidPagar);

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;


		IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

			IF(Var_AmortizacionID = Var_MaxAmorti) THEN
				SET Var_CantidPagar	:= Var_SaldoPago;
			ELSE
				SET Var_CantidPagar := ROUND(Var_PorcentajePag * Var_MonPagoOri, 2);
			END IF;

			IF(Var_CantidPagar > Var_SaldoCapVigente) THEN
				SET	Var_CantidPagar	:= Var_SaldoCapVigente;
			END IF;

			CALL PAGCRECAPVIGPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,	Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;


		SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
		IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

			IF(Var_AmortizacionID = Var_MaxAmorti) THEN
				SET Var_CantidPagar	:= Var_SaldoPago;
			ELSE
				SET Var_CantidPagar := ROUND(Var_PorcentajePag * Var_MonPagoOri, 2);
			END IF;

			IF(Var_CantidPagar > Var_SaldoCapVenNExi) THEN
				SET	Var_CantidPagar	:= Var_SaldoCapVenNExi;
			END IF;

			CALL PAGCRECAPVNEPRO (
				Var_CreditoID,	    Var_AmortizacionID, Var_FechaInicio,	Var_FechaVencim,    Entero_Cero,
				Var_ClienteID,	    Var_FechaSistema,   Var_FecAplicacion,	Var_CantidPagar,    Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,		Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,	Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

			IF(Var_SaldoPago <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		END LOOP CICLO;
	END;
	CLOSE CURSORAMORTI;

	SET Par_MontoPago	 := Par_MontoPagar - Var_SaldoPago;

	IF (Par_MontoPago	<= Decimal_Cero) THEN
		SET Par_NumErr      := 10;
		SET Par_ErrMen      := 'El Credito no Presenta Adeudos.';
		LEAVE ManejoErrores;
	ELSE

		-- Marcamos como Pagadas las Amortizaciones que hayan sido afectadas en el Prepago y
		-- Que no Presenten adeudos
		UPDATE AMORTICREDITO Amo SET
			Estatus      = Esta_Pagado,
			FechaLiquida = Var_FechaSistema
			WHERE (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
				  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
				  SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
				  SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) <= Tol_DifPago
			  AND Amo.CreditoID 	= Par_CreditoID
			AND FechaExigible > Var_FechaSistema
			  AND Estatus 	!= Esta_Pagado
			AND Amo.NumTransaccion = Aud_NumTransaccion;

	END IF;

	SET	Var_FechaIniCal := Var_FechaSistema;

	-- Actualizacion de los intereses
	CALL AMORTICREDITOACT(
		Par_CreditoID,		TipoActInteres,    	SalidaNO,			Par_NumErr, 		Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Respaldar = SI_Respaldar) THEN
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion,	Entero_Cero,	Par_CreditoID,	Par_MontoPagar,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
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