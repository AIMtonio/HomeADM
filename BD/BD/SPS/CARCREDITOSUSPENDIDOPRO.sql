-- SP CARCREDITOSUSPENDIDOPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CARCREDITOSUSPENDIDOPRO;

DELIMITER $$


CREATE PROCEDURE CARCREDITOSUSPENDIDOPRO(
	-- Stored Procedure para realizar el Pase de Credito a Suspendido
	Par_CreditoID						BIGINT(12),		-- ID Del Numero de Credito del cliente.
	Par_FechaDefuncion					DATE,			-- Indicar la fecha en que el cliente fallecio.
	Par_FolioActa						VARCHAR(30),	-- Indicar el folio del acta de defuncion.
	Par_ObservDefuncion					VARCHAR(250),	-- Campo para que el usuario que realice la suspensión pueda agregar cualquier tipo de comentarios.
	Par_TotalAdeudo						DECIMAL(12,2),	-- Indicar el Total Adeudo del credito al momento de Realizar el pase a defuncion.

	Par_TotalSalCapital					DECIMAL(12,2),	-- Indicar el Total de Saldo Capital del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalInteres					DECIMAL(12,2),	-- Indicar el Total de Saldo Interes del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalMoratorio				DECIMAL(12,2),	-- Indicar el Total de Saldo Moratorio del credito al momento de Realizar el pase a defuncion.
	Par_TotalSalComisiones				DECIMAL(12,2),	-- Indicar el Total de Saldo Comisiones del credito al momento de Realizar el pase a defuncion.

	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);		-- Entero vacio
	DECLARE	Decimal_Cero				INT(11);		-- Decimal vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si
	DECLARE Var_EstatusAplic			CHAR(1);		-- Estatus Defuncion R= Registrado/Aplicado,
	DECLARE Amo_EstPagado				CHAR(1);		-- Estatus Pago de Amorticredito
	DECLARE EstatuSuspendido			CHAR(1);		-- Estatus Suspendido Del credito
	DECLARE EstatuPagado				CHAR(1);		-- Estatus Pagado Del credito
	DECLARE EstatuCancelado				CHAR(1);		-- Estatus Cnacelado Del credito
	DECLARE EstatuCastigado				CHAR(1);		-- Estatus Castigado Del credito

	DECLARE Var_DescripSusp				VARCHAR(80);	-- Descripcion del Traspaso al Suspendido
	DECLARE Var_Referencia				VARCHAR(80);	-- Referencia del Traspaso al Suspendido
	DECLARE AltaPoliza_NO				CHAR(1);		-- Alta del Encabezado de la Poliza: NO
	DECLARE AltaPolCre_SI				CHAR(1);		-- Alta de la Poliza de Credito: SI
	DECLARE AltaMovCre_SI				CHAR(1);		-- Alta del Movimiento de Credito: NO
	DECLARE AltaMovCre_NO				CHAR(1);		-- Alta del Movimiento de Credito: SI
	DECLARE AltaMovAho_NO				CHAR(1);		-- Alta del Movimiento de Ahorro: NO
	DECLARE Nat_Cargo					CHAR(1);		-- Naturaleza de Cargo
	DECLARE Nat_Abono					CHAR(1);		-- Naturaleza de Abono
	DECLARE Con_PasoCarSusp				INT(11);		-- Concepto Contable: Traspaso a Cartera Suspendida
	DECLARE Pol_Automatica				CHAR(1);		-- Tipo de Poliza Contable: Automatica
	DECLARE Mora_CtaOrden				CHAR(1);		-- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden
	DECLARE Con_CapVigente				INT(11);		-- Concepto Contable: Capital Vigente
	DECLARE Con_CapAtrasado				INT(11);		-- Tipo de Movimiento de Credito: Capital Atrasado
	DECLARE Con_CapVencido				INT(11);		-- Concepto Contable: Capital Vencido
	DECLARE Con_CapVenNoEx				INT(11);		-- Concepto Contable: Capital Vencido no Exigible
	DECLARE Con_CapVigenteSup			INT(11);		-- Concepto Contable: Capital Vigente Suspendido
	DECLARE Con_CapAtrasadoSup			INT(11);		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
	DECLARE Con_CapVencidoSup			INT(11);		-- Concepto Contable: Capital Vencido Suspendido
	DECLARE Con_CapVenNoExSup			INT(11);		-- Concepto Contable: Capital Vencido no Exigible Suspendido

	DECLARE Con_IntDeven				INT(11);		-- Concepto Contable Interes Devengado
	DECLARE Con_IntAtrasado				INT(11);		-- Concepto Contable: Interes Atrasado
	DECLARE Con_IntVencido				INT(11);		-- Concepto Contable: Interes Vencido
	DECLARE Con_CtaOrdInt				INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	DECLARE Con_CorIntOrd				INT(11);		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

	DECLARE Con_MoraDeven				INT(11);		-- Concepto Contable: Interes Moratorio Devengado
	DECLARE Con_MoraVencido				INT(11);		-- Concepto Contable: Interes Moratorio Vencido
	DECLARE	Con_CtaOrdMor				INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Moratorio
	DECLARE	Con_CorIntMor				INT(11);		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio

	DECLARE Con_MoraDevenSup			INT(11);		-- Concepto Contable: Interes Moratorio Devengado Suspendido
	DECLARE Con_MoraVencidoSup			INT(11);		-- Concepto Contable: Interes Moratorio Vencido Suspendido
	DECLARE	Con_CtaOrdMorSup			INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
	DECLARE	Con_CorIntMorSup			INT(11);		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido

	DECLARE Con_IntDevenSup				INT(11);		-- Concepto Contable Interes Devengado Supencion
	DECLARE Con_IntAtrasadoSup			INT(11);		-- Concepto Contable: Interes Atrasado Suspendido
	DECLARE Con_IntVencidoSup			INT(11);		-- Concepto Contable: Interes Vencido Suspendido
	DECLARE Con_CtaOrdIntSup			INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	DECLARE Con_CorIntOrdSup			INT(11);		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_CarCreditoSuspendidoID	BIGINT(12);		-- Variable Para guardar  el consecutivo de la tabla
	DECLARE Var_CreditoID				BIGINT(12);		-- Variable de numero de Credito
	DECLARE Var_EstatusCredito			CHAR(1);		-- Estatus Actual del Creditos
	DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
	DECLARE Var_ProductoCreditoID		INT(11);		-- Producto credito
	DECLARE Var_MonedaID				INT(11);		-- Moneda del Credito
	DECLARE Var_SucursalCliente			INT(11);		-- Sucursal del cliente
	DECLARE Var_Clasificacion			CHAR(1);		-- Clasificacion del credito
	DECLARE Var_SubClasif				INT(11);		-- Sub clasificacion
	DECLARE Var_Poliza					BIGINT;			-- Numero de Poliza
	DECLARE	Var_TipoContaMora			CHAR(1);		-- Variable del Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden
	DECLARE Var_ClienteID				INT(11);		-- Variable del cliente
	DECLARE Var_SaldoCapVigente			DECIMAL(12,2);	-- Variable de Saldo Total Capital Vigente del Credito
	DECLARE Var_SaldoCapAtrasa			DECIMAL(12,2);	-- Variable de Saldo Total Capital Atrasado del Credito
	DECLARE Var_SaldoCapVencido			DECIMAL(12,2);	-- Variable de Saldo Total Capital Vencido del Credito
	DECLARE Var_SaldoCapVenNExi			DECIMAL(12,2);	-- Variable de Saldo Total Capital Vencido No Exigible del Credito

	DECLARE Var_SaldoInteresOrd			DECIMAL(12,2);	-- Variable de Saldo Total Interes Vigente del Credito
	DECLARE Var_SaldoInteresAtr			DECIMAL(12,2);	-- Variable de Saldo Total Interes Atrasado del Credito
	DECLARE Var_SaldoInteresVen			DECIMAL(12,2);	-- Variable de Saldo Total Interes Vencido No Exigible del Credito
	DECLARE Var_SaldoIntNoConta			DECIMAL(12,2);	-- Variable de Saldo Total Interes No contabilizado del Credito

	DECLARE Var_SaldoMoratorios			DECIMAL(12,2);	-- Variable de Saldo Total de Moratorios
	DECLARE Var_SaldoMoraVencido		DECIMAL(12,2);	-- Variable de Saldo Total de Moratorios Vencido
	DECLARE Var_SaldoMoraCarVen			DECIMAL(12,2);	-- Variable de Saldo Total de Moratorios de cartera Vencida


	-- Asignacion de Constantes
	SET Entero_Cero						= 0;			-- Asignacion de Entero Vacio
	SET Decimal_Cero					= 0.0;			-- Asignacion de Decimal Vacio
	SET	Cadena_Vacia					= '';			-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';			-- Asignacion de Salida SI
	SET Cons_SI							= 'S';			-- Salida Si
	SET Cons_NO							= 'N';			-- Salida Si
	SET Var_EstatusAplic				= 'A';			-- Estatus Defuncion R= Registrado/Aplicado,
	SET Amo_EstPagado					= 'P';			-- Estatus Pago de Amorticredito
	SET EstatuSuspendido				= 'S';			-- Estatus Suspendido Del credito
	SET EstatuPagado					= 'P';			-- Estatus Pagado Del credito
	SET EstatuCancelado					= 'C';			-- Estatus Cnacelado Del credito
	SET EstatuCastigado					= 'K';			-- Estatus Castigado Del credito

	SET Var_DescripSusp					:= "SUSPENCION DEL CREDITO";		-- Descripcion del Traspaso al Suspendido
	SET Var_Referencia					:= "TRASPASO A CARTERA SUSPENDIDA";	-- Referencia del Traspaso al Suspendido
	SET AltaPoliza_NO					:= 'N';			-- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI					:= 'S';			-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO					:= 'N';			-- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI					:= 'S';			-- Alta del Movimiento de Credito: SI
	SET AltaMovAho_NO					:= 'N';			-- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo						:= 'C';			-- Naturaleza de Cargo
	SET Nat_Abono						:= 'A';			-- Naturaleza de Abono
	SET Pol_Automatica					:= 'A';			-- Tipo de Poliza Contable: Automatica
	SET Mora_CtaOrden					:= 'C';			-- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

	SET Con_PasoCarSusp					:= 1104;		-- Concepto Contable: Traspaso a Cartera Suspendida

	SET Con_CapVigente					:= 1;			-- Concepto Contable: Capital Vigente
	SET Con_CapAtrasado					:= 2;			-- Tipo de Movimiento de Credito: Capital Atrasado
	SET Con_CapVencido					:= 3;			-- Concepto Contable: Capital Vencido
	SET Con_CapVenNoEx					:= 4;			-- Concepto Contable: Capital Vencido no Exigible

	SET Con_CapVigenteSup				:= 110;			-- Concepto Contable: Capital Vigente Suspendido
	SET Con_CapAtrasadoSup				:= 111;			-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
	SET Con_CapVencidoSup				:= 112;			-- Concepto Contable: Capital Vencido Suspendido
	SET Con_CapVenNoExSup				:= 113;			-- Concepto Contable: Capital Vencido no Exigible Suspendido

	SET Con_IntDeven					:= 19;			-- Concepto Contable Interes Devengado
	SET Con_IntAtrasado					:= 20;			-- Concepto Contable: Interes Atrasado
	SET Con_IntVencido					:= 21;			-- Concepto Contable: Interes Vencido
	SET Con_CtaOrdInt					:= 11;			-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	SET Con_CorIntOrd					:= 12;			-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

	SET Con_MoraDeven 					:= 33;			-- Concepto Contable: Interes Moratorio Devengado
	SET Con_MoraVencido					:= 34;			-- Concepto Contable: Interes Moratorio Vencido
	SET	Con_CtaOrdMor					:= 13;			-- Concepto Contable: Cuenta de Orden de Interes Moratorio
	SET	Con_CorIntMor					:= 14;			-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio

	SET Con_IntDevenSup					:= 114;			-- Concepto Contable Interes Devengado Ssupencion
	SET Con_IntAtrasadoSup				:= 115;			-- Concepto Contable: Interes Atrasado Suspendido
	SET Con_IntVencidoSup				:= 116;			-- Concepto Contable: Interes Vencido
	SET Con_CtaOrdIntSup				:= 119;			-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	SET Con_CorIntOrdSup				:= 120;			-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

	SET Con_MoraDevenSup				:= 117;		-- Concepto Contable: Interes Moratorio Devengado Suspendido
	SET Con_MoraVencidoSup				:= 118;		-- Concepto Contable: Interes Moratorio Vencido Suspendido
	SET	Con_CtaOrdMorSup				:= 121;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
	SET	Con_CorIntMorSup				:= 122;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido

	-- Declaracion de Valores Default
	SET Par_CreditoID			:= IFNULL(Par_CreditoID ,Entero_Cero);
	SET Par_TotalAdeudo			:= IFNULL(Par_TotalAdeudo ,Decimal_Cero);
	SET Par_TotalSalCapital		:= IFNULL(Par_TotalSalCapital ,Decimal_Cero);
	SET Par_TotalSalInteres		:= IFNULL(Par_TotalSalInteres ,Decimal_Cero);
	SET Par_TotalSalMoratorio	:= IFNULL(Par_TotalSalMoratorio ,Decimal_Cero);
	SET Par_TotalSalComisiones	:= IFNULL(Par_TotalSalComisiones ,Decimal_Cero);

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-CARCREDITOSUSPENDIDOPRO");
		SET Var_Control = 'sqlException';
	END;

	SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

	IF(Par_CreditoID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique el Numero de Credito.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	SELECT CRED.CreditoID,	CRED.Estatus,	CRED.ProductoCreditoID,	CRED.MonedaID,	CLI.SucursalOrigen,		DES.Clasificacion,	DES.SubClasifID,	CRED.ClienteID
		INTO Var_CreditoID,	Var_EstatusCredito,	Var_ProductoCreditoID,	Var_MonedaID,	Var_SucursalCliente,	Var_Clasificacion,	Var_SubClasif,	Var_ClienteID
		FROM CREDITOS CRED
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRED.ClienteID
		INNER JOIN DESTINOSCREDITO DES ON DES.DestinoCreID = CRED.DestinoCreID
		WHERE CRED.CreditoID = Par_CreditoID;

	SET Var_EstatusCredito := IFNULL(Var_EstatusCredito,Cadena_Vacia);

	IF(IFNULL(Var_CreditoID , Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Numero de Credito Especificado No Existe.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCredito = EstatuSuspendido) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Numero de Credito Especificado ya se Encuentra Suspendido.';
		SET Var_Control := 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCredito IN (EstatuPagado, EstatuCancelado,EstatuCastigado)) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'El Numero de Credito Especificado ya se Encuentra Pagado,Castigado o Cancelado.';
		SET Var_Control := 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalAdeudo = Decimal_Cero) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique el Total Adeudo del Credito.';
		SET Var_Control := 'totalAdeudo';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalCapital = Decimal_Cero) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Especifique el Total Saldo Capital del Credito.';
		SET Var_Control := 'totalSalCapital';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalInteres < Decimal_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'Especifique el Total Saldo Interes del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalInteres';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalMoratorio < Decimal_Cero) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'Especifique el Total Saldo Moratorio del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalMoratorio';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TotalSalComisiones < Decimal_Cero) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'Especifique el Total Saldo Comisiones del Credito Mayor o Igual a Cero.';
		SET Var_Control := 'totalSalComisiones';
		LEAVE ManejoErrores;
	END IF;

	SET Var_SaldoCapVigente		:= Decimal_Cero;
	SET Var_SaldoCapAtrasa		:= Decimal_Cero;
	SET Var_SaldoCapVencido		:= Decimal_Cero;
	SET Var_SaldoCapVenNExi		:= Decimal_Cero;

	SET Var_SaldoInteresOrd		:= Decimal_Cero;
	SET Var_SaldoInteresAtr		:= Decimal_Cero;
	SET Var_SaldoInteresVen		:= Decimal_Cero;
	SET Var_SaldoIntNoConta		:= Decimal_Cero;

	SET Var_SaldoMoratorios		:= Entero_Cero;
	SET Var_SaldoMoraVencido	:= Entero_Cero;
	SET Var_SaldoMoraCarVen		:= Entero_Cero;

	-- Consultar Saldo actual del credito para realizar el pase  Suspendido
	SELECT 	ROUND(IFNULL(SUM(ROUND(SaldoCapVigente,2)),Entero_Cero),2) AS SaldoCapVigente, ROUND(IFNULL(SUM(ROUND(SaldoCapAtrasa ,2)),Entero_Cero),2) AS SaldoCapAtrasa,
			ROUND(IFNULL(SUM(ROUND(SaldoCapVencido,2)),Entero_Cero),2) AS SaldoCapVencido, ROUND(IFNULL(SUM(ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS SaldoCapVenNExi,

			SUM( IFNULL(ROUND(SaldoInteresOrd,2), Entero_Cero) + IFNULL(ROUND(SaldoInteresPro,2), Entero_Cero)) AS SaldoInteresOrd,
			ROUND(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero), 2) AS SaldoInteresAtr,
			ROUND(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero), 2) AS SaldoInteresVen,
			ROUND(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero), 2) AS SaldoIntNoConta,

			ROUND(IFNULL(SUM(ROUND(SaldoMoratorios,2)), Entero_Cero), 2) AS SaldoMoratorios,
			ROUND(IFNULL(SUM(ROUND(SaldoMoraVencido,2)), Entero_Cero), 2) AS SaldoMoraVencido,
			ROUND(IFNULL(SUM(ROUND(SaldoMoraCarVen,2)), Entero_Cero), 2) AS SaldoMoraCarVen

			INTO	Var_SaldoCapVigente,	Var_SaldoCapAtrasa,		Var_SaldoCapVencido,	Var_SaldoCapVenNExi,
					Var_SaldoInteresOrd,	Var_SaldoInteresAtr,	Var_SaldoInteresVen,	Var_SaldoIntNoConta,
					Var_SaldoMoratorios,	Var_SaldoMoraVencido,	Var_SaldoMoraCarVen

		FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Par_CreditoID
			AND Amo.Estatus <> Amo_EstPagado;


	SET Var_SaldoCapVigente			:= IFNULL(Var_SaldoCapVigente, Decimal_Cero);
	SET Var_SaldoCapAtrasa			:= IFNULL(Var_SaldoCapAtrasa, Decimal_Cero);
	SET Var_SaldoCapVencido			:= IFNULL(Var_SaldoCapVencido, Decimal_Cero);
	SET Var_SaldoCapVenNExi			:= IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);

	SET Var_SaldoInteresOrd			:=IFNULL(Var_SaldoInteresOrd,Decimal_Cero);
	SET Var_SaldoInteresAtr			:=IFNULL(Var_SaldoInteresAtr,Decimal_Cero);
	SET Var_SaldoInteresVen			:=IFNULL(Var_SaldoInteresVen,Decimal_Cero);
	SET Var_SaldoIntNoConta			:=IFNULL(Var_SaldoIntNoConta,Decimal_Cero);

	SET Var_SaldoMoratorios			:=IFNULL(Var_SaldoMoratorios,Decimal_Cero);
	SET Var_SaldoMoraVencido		:=IFNULL(Var_SaldoMoraVencido, Decimal_Cero);
	SET Var_SaldoMoraCarVen			:=IFNULL(Var_SaldoMoraCarVen, Decimal_Cero);

	CALL MAESTROPOLIZAALT(	Var_Poliza,			Aud_EmpresaID,		Var_FechaSistema,	Pol_Automatica,		Con_PasoCarSusp,
							Var_Referencia,		Cons_NO,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	-- Realizamos el Traspaso del Saldo Capital Vigente del Credito al Suspendido
	IF(Var_SaldoCapVigente > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de capital  vigente
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVigente,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVigente,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Capital Vigente a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVigente,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVigenteSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el Traspaso del Saldo Capital Atrasado del Credito al Suspendido
	IF(Var_SaldoCapAtrasa > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Atrasado  vigente
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapAtrasa,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapAtrasado,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Capital Atrasado a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapAtrasa,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapAtrasadoSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el Traspaso del Saldo Capital Vencido del Credito al Suspendido
	IF(Var_SaldoCapVencido > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Vencido  vigente
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVencido,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVencido,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Capital Vencido a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVencido,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVencidoSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el Traspaso del Saldo Capital Vencido no Exigible a Suspendido
	IF(Var_SaldoCapVenNExi > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Capital Vencido no Exigible
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVenNExi,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVenNoEx,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Capital Vencido no Exigible a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoCapVenNExi,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CapVenNoExSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el traspaso del saldo del interes ordinario del credito a suspendido
	IF(Var_SaldoInteresOrd > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Interes Ordinario
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresOrd,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntDeven,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Interes Ordinario a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresOrd,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntDevenSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el traspaso del saldo del interes Atrasado del credito a suspendido
	IF(Var_SaldoInteresAtr > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Interes Atrasado
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresAtr,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntAtrasado,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Interes Atrasado a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresAtr,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntAtrasadoSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el traspaso del saldo del interes Vencido del credito a suspendido
	IF(Var_SaldoInteresVen > Entero_Cero) THEN
		-- Realizamos el Abonamos por el monto de Interes Vencido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntVencido,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Interes Vencido a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoInteresVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_IntVencidoSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el traspaso del saldo del interes no contabilizado del credito
	IF(Var_SaldoIntNoConta > Entero_Cero) THEN
		-- Realizamos el Abono por el monto de Interes No Contabilizado en la cuenta de orden de cartera vencido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoIntNoConta,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdInt,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Cargo por el monto de Interes No Contabilizado en la cuenta correlativa de cartera vencido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoIntNoConta,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntOrd,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Cargo por el monto de Interes No Contabilizado en la cuenta de orden de cartera Suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoIntNoConta,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdIntSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Abono por el monto de Interes No Contabilizado en la cuenta correlativa de cartera vencido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoIntNoConta,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntOrdSup,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_TipoContaMora	:= (SELECT TipoContaMora from PARAMETROSSIS);
	SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);

	-- Realizamos el Traspaso del Saldo Moratorio del Credito
	IF(Var_SaldoMoratorios > Entero_Cero) THEN
		-- Verificamos como regitrar Operativamente y contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
		-- Si se Contabiliza en cuentas de Orden
		IF (Var_TipoContaMora  = Mora_CtaOrden ) THEN
			-- Realizamos el Cargo por el monto Total de Moratorio en la Cuenta de orden
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdMor,
									Entero_Cero,			Nat_Abono,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Realizamos el Movimiento de Abono a la cuenta correlativa de interes de Moratorio.
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntMor,
									Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Realizamos el Abono por el monto Total de Moratorio en la Cuenta de orden de Suspencion
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdMorSup,
									Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Realizamos el Movimiento de Cargo a la cuenta correlativa de interes de Moratorio por suspencion
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntMorSup,
									Entero_Cero,			Nat_Abono,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Si se Contabiliza en en cuentas de Ingresos
		IF (Var_TipoContaMora  != Mora_CtaOrden ) THEN
			-- Realizamos el Abono por el monto Total de Moratorio
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_MoraDeven,
									Entero_Cero,			Nat_Abono,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Cargamos el Monto de Moratorio a suspendido
			CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
									Var_FechaSistema,		Var_SaldoMoratorios,		Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
									Var_SubClasif,			Var_SucursalCliente,		Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
									Entero_Cero,			Var_Poliza,					AltaPolCre_SI,		AltaMovCre_NO,			Con_MoraDevenSup,
									Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
									Cadena_Vacia,			/*Cons_NO,*/					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
									Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	-- Realizamos el Traspaso del Saldo Moratorio Vencido del credito
	IF(Var_SaldoMoraVencido > Entero_Cero) THEN
		-- Realizamos el Abono por el monto Total de Moratorio Suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraVencido,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_MoraVencido,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cargamos el Monto de Saldo Moratorio Vencido a suspendido
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraVencido,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_MoraVencidoSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Realizamos el Traspaso de  saldo Moratorio de cartera vencida del credito
	IF(Var_SaldoMoraCarVen > Entero_Cero) THEN
		-- Realizamos el Abono por el monto Total de  Moratorio de cartera vencida  en la Cuenta de orden
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraCarVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdMor,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Movimiento de Cargo a la cuenta correlativa de  Moratorio de cartera vencida .
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraCarVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntMor,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Cargo por el monto Total de Moratorio en la Cuenta de orden de Suspencion
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraCarVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CtaOrdMorSup,
								Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Realizamos el Movimiento de abono a la cuenta correlativa de interes de Moratorio por suspencion
		CALL CONTACREDITOPRO (	Par_CreditoID,			Entero_Cero,			Entero_Cero,		Var_ClienteID,			Var_FechaSistema,
								Var_FechaSistema,		Var_SaldoMoraCarVen,	Var_MonedaID,		Var_ProductoCreditoID,	Var_Clasificacion,
								Var_SubClasif,			Var_SucursalCliente,	Var_DescripSusp,	Var_Referencia,			AltaPoliza_NO,
								Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Con_CorIntMorSup,
								Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
								Cadena_Vacia,			/*Cons_NO,*/				Par_NumErr,			Par_ErrMen,				Var_Consecutivo,
								Aud_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- REGISTRAMOS LA INFORMACION DEL CREDITO A SUPENDER
	CALL CARCREDITOSUSPENDIDOALT (	Par_CreditoID,			Var_EstatusCredito,		Par_FechaDefuncion,		Var_FechaSistema,		Par_FolioActa,
									Par_ObservDefuncion,	Par_TotalAdeudo,		Par_TotalSalCapital,	Par_TotalSalInteres,	Par_TotalSalMoratorio,
									Par_TotalSalComisiones,	Cons_NO,				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,
									Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
									Aud_NumTransaccion);

	IF(Par_NumErr <> Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	-- Reaslizamos el cambio de estatus a paso suspencion
	UPDATE CREDITOS SET
		Estatus			= EstatuSuspendido,

		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE CreditoID = Par_CreditoID;

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:='Proceso de Supension Realizado Exitosamente.';
		SET Var_Consecutivo	:= Par_CreditoID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	Control,
				Var_Consecutivo			AS	Consecutivo;
	END IF;
END TerminaStore$$
