-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOINTERESCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOINTERESCREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOINTERESCREPRO`(
-- -----------------------------------------------------------------------------------------------------------------------
# ========== REALIZA EL PAGO DEL TOTAL DE INTERESES DE UN CREDITO ( Interes Vencido, Atrasado, Ordinario, Provisionado,
#								 y No contabilizado)============
-- -----------------------------------------------------------------------------------------------------------------------
    Par_CreditoID       BIGINT(12),			# ID de credito al que se le efectuara el pago
    Par_MontoPagar	    DECIMAL(12,2),		# Monto del pago que esta realizando
	Par_ModoPago		CHAR(1),			# Forma de pago Efectivo o con cargo a cuenta
	Par_CuentaAhoID     BIGINT(12),			# ID de la cuenta de ahorro sobre la cual se haran los movimientos
	Par_Poliza			BIGINT,				# Numero de poliza
	Par_OrigenPago		CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE varControl 		    		VARCHAR(100);	# almacena el elmento que es incorrecto
	DECLARE Var_FechaSistema    		DATE;			# Almacena la fecha actual del sistema
	DECLARE Var_FecAplicacion   		DATE;			# Fecha en la que se aplica el pago
	DECLARE Var_MontoSaldo	    		DECIMAL(12,2);	# Guarda el saldo que va quedando despues de los pagos que se van haciendo
	DECLARE Var_MontoPagar     			DECIMAL(14, 4);	# Guarda el monto que se va a pagar en cada amortizacion
	DECLARE Var_MontoIVAPagar	 		DECIMAL(12, 2);	# Cantidad de IVA a pagar
	DECLARE Var_IVA						DECIMAL(12,2);	# porcentaje de iva general
	DECLARE Var_IVAInteresOrdi			DECIMAL(12,2);	# Porcentaje de iva aplicado a interes ordinario
	DECLARE Var_IVAInteresMora			DECIMAL(12,2);	# Porcentaje de iva aplicado a interes moratorio
	DECLARE Var_PagaIVA					CHAR(1); 		# Indica si el cliente paga iva
	DECLARE Var_CobraIVAInteres			CHAR(1);		# Indica si cobra iva por interes ordinario
	DECLARE Var_CobraIVAMora			CHAR(1);		# Indica si cobra iva por interes moratorio
	DECLARE Var_SucursalID      		INT(11);		# ID de la sucursal del cliente
	DECLARE Var_ClienteID				INT(11);		# ID del cliente
	DECLARE Var_MonedaID	    		INT(11);		# Tipo de moneda con la que realiza el pago
	DECLARE Var_ProducCreditoID			INT(11);		# Producto de credito
	DECLARE Var_ClasificaCredito		CHAR(1);		# Clasificacion del credito, comercial, consumo, hipotecario
	DECLARE Var_SubClasifCredito		INT(11);		# Subclasificacion del credito
	DECLARE Var_CuentaAhoStr			VARCHAR(20);	# Gurada el ID de la cuenta de ahorro en VARCHAR
	DECLARE Var_CreditoStr				VARCHAR(20);	# Gurada el ID del credito en VARCHAR
	DECLARE Var_Consecutivo				BIGINT;			# consecutivo de movimiento guardado en la tabla de movimientos de credito
	DECLARE Var_ProyInteresPagAde		CHAR(1);		# Indica si el producto de credito proyecta interes
	DECLARE Var_EstatusCredito			CHAR(1);		# Estatus del credito
	DECLARE Var_EsReestructura			CHAR(1);		# Si es el producto de credito indica que es un credito reestructura
	DECLARE Var_EstatusCreacion			CHAR(1);		# Estatus con el que nace el credito (vigente o vencido)
	DECLARE Var_Regularizado			CHAR(1);		# Indica si el credito ya fue regulizado
	DECLARE Var_TasaFija				DECIMAL(12,4);	# Tasa de interes aplicado al credito
	DECLARE Var_DiasCredito     		INT(11);		# Dias considerados para un aÃ±o (util en el calculo de interes)
	DECLARE Var_InteresProyectado   	DECIMAL(14,4);	# Monto de interes proyectado
	DECLARE Var_DivideIngresoInteres 	CHAR(1);		# Dividir Ingresos por Interes de Cartera Vigente y Vencida S=Si, N=No
	DECLARE Var_CueClienteID			BIGINT(12);		# Cuenta del cliente
	DECLARE Var_CueSaldo				DECIMAL(12,2);	# Saldo actual disponible en la cuenta
	DECLARE Var_CueMoneda				INT(11);		# Tipo de moneda de la cuenta
	DECLARE Var_CueEstatus				CHAR(1);		# Estatus de la cuenta
	DECLARE Var_EsGrupal        		CHAR(1);		# Indica si el producto de credito es grupal
	DECLARE Var_SolicitudCreditoID  	BIGINT;			# Id de la solicitud de credito de la cual nacio el credito
	DECLARE Var_GrupoID         		INT(11);		# ID del grupo de credito
	DECLARE Var_CicloActual     		INT(11);		# Ciclo actual del grupo
	DECLARE Var_GrupoCtaID      		INT(11);		# ID de la cuenta de ahorro cuando es grupal
	DECLARE Var_CicloGrupo      		INT(11);		# Ciclo del grupo al que pertenece el credito grupal
	DECLARE Var_TotalInteres			DECIMAL(14,2);	# Total de intereses adeudado por el credito a la fecha
	DECLARE Var_MontoPago				DECIMAL(12,2);	# Guarda el monto de pago
	DECLARE Var_PagoIntVertical			CHAR(1);		# Si exige el total adeudo de intereses o permite pago en parcialidades

	DECLARE Var_AmortizacionID  		INT(4);  		# ID de la amortizacion
	DECLARE Var_SaldoInteresOrd			DECIMAL(12, 4);	# Saldo de interes ordinario de una amortizacion
	DECLARE Var_SaldoInteresAtr			DECIMAL(12, 4);	# Saldo de interes atrasado de una amortizacion
	DECLARE Var_SaldoInteresVen			DECIMAL(12, 4);	# Saldo de interes vencido de una amortizacion
	DECLARE Var_SaldoInteresPro			DECIMAL(12, 4);	# Saldo de interes provisionado de una amortizacion
	DECLARE Var_SaldoIntNoConta			DECIMAL(12, 4);	# Saldo de interes no contabilizado de una amortizacion
	DECLARE Var_FechaInicio     		DATE;			# Fecha de inicio de la amortizacion
	DECLARE Var_FechaVencim     		DATE;			# Fecha de vencimiento de la amortizacion
	DECLARE Var_FechaExigible   		DATE;			# Fecha de exigible de la amortizacion
	DECLARE Var_SaldoMoraVenci			DECIMAL(12, 2);	# Sado de interes moratorio vencido
	DECLARE Var_SaldoMoraCarVen			DECIMAL(12, 2);	# Saldo de interes moratorio de cartera vencida
	DECLARE Var_SaldoMoratorios			DECIMAL(12, 2); # Saldo de interes moratorio de cartera vigente

    DECLARE Var_NumeroAmort				INT(11);		# Numero de Amortizaciones
	DECLARE Var_FechaMinAtraso			DATE;			# Fecha de Atraso de la primera amortizacion que se encuentre atrasada
	DECLARE Var_FechaActPago			DATETIME;		# Fecha del pago más reciente.
	DECLARE Var_DifDiasPago				INT;			# Diferencia entre fechas de pago en días.

	# Declaracion de constantes
	DECLARE Cadena_Vacia    			CHAR(1);		# Cadena vacia
	DECLARE Entero_Cero     			INT(11);		# Entero cero
	DECLARE Decimal_Cero				DECIMAL(4,2);	# DECIMAL cero
	DECLARE SalidaNO        			CHAR(1);		# El store NO arroja una salida
	DECLARE SalidaSI        			CHAR(1);		# El store SI arroja una salida
	DECLARE Estatus_Inactivo   			CHAR(1);		# Estatus inactivo
	DECLARE Estatus_Vigente    			CHAR(1);		# Estatus vigente
	DECLARE Estatus_Atrasado  			CHAR(1);		# Estatus Atrasado
	DECLARE Estatus_Vencido    			CHAR(1);		# Estatus vencido
	DECLARE Estatus_Activo				CHAR(1);		# Estatus Activo
	DECLARE Monto_MinimoPago    		DECIMAL(12,2);	# Monto minimo permitido para efectar un pago
	DECLARE SiPagaIVA       			CHAR(1);        # Si paga IVA
	DECLARE Des_PagoCredito				VARCHAR(50);	# Descripcion del pago de credito
	DECLARE ProyectaInt_NO				CHAR(1);		# No proyecta interes
	DECLARE ProyectaInt_SI				CHAR(1);		# Si proyecta interes
	DECLARE Reestructura_SI				CHAR(1);		# Si es un credito reestructura
	DECLARE Regularizado_NO				CHAR(1);		# No es un credito regualizado (no ha comprobo pago sostenido)
	DECLARE EsGrupal_NO					CHAR(1);		# Es un credito grupal
	DECLARE Naturaleza_Cargo    		CHAR(1);		# Naturaleza Cargo
	DECLARE Naturaleza_Abono    		CHAR(1);		# Naturaleza abono
	DECLARE Aho_PagoCred    			CHAR(4);		# Concepto de Ahorro: Pago de Credito
	DECLARE AltaPoliza_NO   			CHAR(1);		# Indica que no de alta una nueva poliza contable
	DECLARE AltaMovAho_SI   			CHAR(1);		# Alta de los Movimientos de Ahorro: SI.
	DECLARE Con_AhoCapital  			INT(11);			# Concepto Contable de Ahorro: Pasivo
	DECLARE Constante_SI				CHAR(1);		# Valor SI
	DECLARE Mov_Referencia				VARCHAR(50);	# Referencia para la tabla de CREDITOSMOVS
	DECLARE Var_NumRecPago				INT(11);
	DECLARE Fecha_Vacia     			DATE;			# Fecha Vacia
	DECLARE Estatus_Suspendido			CHAR(1);			-- Estatus Suspendido


	DECLARE CURSORAMORTIZACIONES CURSOR FOR
		SELECT  AmortizacionID, 		Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresVen,
			Amo.SaldoInteresPro,	Amo.SaldoIntNoConta,	Amo.SaldoMoraVencido,	Amo.SaldoMoraCarVen,
			Amo.SaldoMoratorios,	Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible
		FROM AMORTICREDITO Amo
			INNER JOIN CREDITOS Cre ON (Amo.CreditoID = Cre.CreditoID)
			INNER JOIN CLIENTES Cli ON (Cre.ClienteID = Cli.ClienteID)
		WHERE Cre.CreditoID      = 	Par_CreditoID
			AND (Amo.Estatus	 =  Estatus_Vigente
				OR Amo.Estatus =  Estatus_Atrasado
				OR Amo.Estatus =  Estatus_Vencido)
			AND (Cre.Estatus	   =  Estatus_Vigente
				OR Cre.Estatus =  Estatus_Vencido
				OR Cre.Estatus = Estatus_Suspendido)
		ORDER BY Amo.FechaInicio;

	# Asignacion  de constantes
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaNO       		:= 'N';
	SET SalidaSI        	:= 'S';
	SET Estatus_Inactivo	:= 'P';
	SET Estatus_Vigente 	:= 'V';
	SET Estatus_Atrasado  	:= 'A';
	SET Estatus_Vencido 	:= 'B';
	SET Estatus_Activo		:= 'A';
	SET Monto_MinimoPago	:= 0.01;
	SET SiPagaIVA			:= 'S';
	SET Des_PagoCredito     := 'PAGO DE CREDITO';
	SET ProyectaInt_SI		:= 'S';
	SET Reestructura_SI		:= 'S';
	SET Regularizado_NO		:= 'N';
	SET EsGrupal_NO			:= 'N';
	SET Naturaleza_Cargo 	:= 'C';
    SET Naturaleza_Abono 	:= 'A';
	SET Aho_PagoCred    	:= '101';
	SET AltaPoliza_NO   	:= 'N';
	SET AltaMovAho_SI   	:= 'S';
	SET Con_AhoCapital  	:= 1;
	SET Constante_SI		:= 'S';
	SET Mov_Referencia		:= 'PAGO DE INTERES CON CARGO A CTA';
	SET Aud_ProgramaID  	:= 'PAGOCREDITOPRO';
	SET Var_NumRecPago		:= 0;
    SET Fecha_Vacia			:= '1900-01-01';
	SET Estatus_Suspendido	:= 'S';			-- Estatus Suspendido


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOINTERESCREPRO');
			   SET varControl  = 'SQLEXCEPTION';
			END;

	# Asignacion de variables
	SET Var_MontoSaldo		:= Par_MontoPagar;

	SELECT FechaSistema,		DiasCredito,		DivideIngresoInteres,		PagoIntVertical
		INTO   Var_FechaSistema,	Var_DiasCredito,	Var_DivideIngresoInteres,	Var_PagoIntVertical
			FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	SET Var_FecAplicacion		:= Var_FechaSistema;
	SET Var_CuentaAhoStr    	:= CONVERT(Par_CuentaAhoID, CHAR(15));
	SET Var_CreditoStr      	:= CONVERT(Par_CreditoID, CHAR(15));

	SELECT  Cli.ClienteID,		Cli.SucursalOrigen,		Cli.PagaIVA,			Pro.CobraIVAInteres,    Pro.CobraIVAMora,
			Cre.MonedaID,		Pro.ProducCreditoID,	Des.Clasificacion,		Des.SubClasifID,		Pro.ProyInteresPagAde,
			Cre.Estatus,		Cre.TasaFija,			Res.EstatusCreacion,	Pro.EsReestructura,		Res.Regularizado,
			Pro.EsGrupal,		Cre.GrupoID,			Cre.SolicitudCreditoID,	Cre.CicloGrupo
	INTO 	Var_ClienteID,		Var_SucursalID,			Var_PagaIVA,			Var_CobraIVAInteres,	Var_CobraIVAMora,
			Var_MonedaID,		Var_ProducCreditoID,	Var_ClasificaCredito,	Var_SubClasifCredito,	Var_ProyInteresPagAde,
			Var_EstatusCredito,	Var_TasaFija,			Var_EstatusCreacion,	Var_EsReestructura,		Var_Regularizado,
			Var_EsGrupal,		Var_GrupoID,			Var_SolicitudCreditoID,	Var_CicloGrupo
	FROM CLIENTES Cli
		INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
		INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
		INNER JOIN DESTINOSCREDITO Des ON (Cre.DestinoCreID = Des.DestinoCreID)
		LEFT  JOIN REESTRUCCREDITO Res ON (Res.CreditoDestinoID = Cre.CreditoID)
	WHERE Cre.CreditoID = Par_CreditoID;

	IF (Var_PagaIVA = SiPagaIVA) THEN
		SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);

		IF (Var_CobraIVAInteres = SiPagaIVA) THEN
			SET Var_IVAInteresOrdi  := Var_IVA;
		ELSE
			SET Var_IVAInteresOrdi  := Decimal_Cero;
		END IF;

		IF (Var_CobraIVAMora = SiPagaIVA) THEN
			SET Var_IVAInteresMora  := Var_IVA;
		ELSE
			SET Var_IVAInteresMora  := Decimal_Cero;
		END IF;
	END IF;

	SET Var_IVA				:= IFNULL(Var_IVA,  Decimal_Cero);
	SET Var_IVAInteresOrdi	:= IFNULL(Var_IVAInteresOrdi,  Decimal_Cero);
	SET Var_IVAInteresMora	:= IFNULL(Var_IVAInteresMora,  Decimal_Cero);
	SET Aud_FechaActual		:= NOW();

	-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
	# SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
	SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID AND FechaPago = Var_FechaSistema);
	SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

	# SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
	SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
	SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

	# SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
	IF(Var_DifDiasPago=Entero_Cero)THEN
		IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= time('00:01:00'))THEN
			SET Par_NumErr		:= '001';
			SET Par_ErrMen		:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
			SET varControl  := 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;
# ===================================================  SECCION DE VALIDACIONES ANTES DE ENTRAR AL CICLO DE PAGOS  ==================================================
	IF(IFNULL(Par_CreditoID,  Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
		SET varControl  := 'creditoID' ;
		LEAVE ManejoErrores;

	ELSE
		IF(Var_EstatusCredito != Estatus_Vigente AND Var_EstatusCredito != Estatus_Vencido AND Var_EstatusCredito != Estatus_Suspendido) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'El Credito debe estar Vigente, Vencido o Suspendido.';
			SET varControl  := 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_MontoPagar,  Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr  := '003';
		SET Par_ErrMen  := 'El Monto a Pagar esta Vacio.';
		SET varControl  := 'montoPagar' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ModoPago,  Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr  := '004';
		SET Par_ErrMen  := 'Indique el Modo de Pago.';
		SET varControl  := 'modoPago' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Poliza,  Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr  := '005';
		SET Par_ErrMen  := 'El Numero de Poliza esta Vacio.';
		SET varControl  := 'polizaID' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr  := '006';
		SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
		SET varControl  := 'cuentaAhoID' ;
		LEAVE ManejoErrores;
	END IF;

	CALL SALDOSAHORROCON(Var_CueClienteID, 	Var_CueSaldo,	 Var_CueMoneda, 	Var_CueEstatus,	 Par_CuentaAhoID);

	IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr		:= '007';
		SET Par_ErrMen		:= 'La Cuenta no Existe.';
		SET varControl		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF( IFNULL(Var_CueClienteID, Entero_Cero) != Var_ClienteID) THEN

		IF (Var_EsGrupal = EsGrupal_NO) THEN
			SET Par_NumErr		:= '008';
			SET Par_ErrMen		:= CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),' No Pertenece al Socio ', CONVERT(Var_ClienteID, CHAR), '.');
			SET varControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		ELSE
			# En un Credito grupal si se puede pagar con la cuenta de otro cliente siempre y cuando ese cliente pertenezca al grupo
			SET Var_SolicitudCreditoID  := IFNULL(Var_SolCreditoID, Entero_Cero);
			SET Var_GrupoID 	 		:= IFNULL(Var_GrupoID, Entero_Cero);

			SELECT CicloActual INTO Var_CicloActual
				FROM 	GRUPOSCREDITO
				WHERE GrupoID = Var_GrupoID;

			# Verificamos el ciclo del grupo, si es el ciclo actual o si es un ciclo anterior entonces buscamos los integrantes en el historico
			IF(Var_CicloGrupo = Var_CicloActual) THEN
				SELECT GrupoID INTO Var_GrupoCtaID
					FROM INTEGRAGRUPOSCRE
					WHERE GrupoID = Var_GrupoID
						AND Estatus = Estatus_Activo
						AND ClienteID = Var_CueClienteID
					LIMIT 1;
			ELSE
				SELECT GrupoID INTO Var_GrupoCtaID
					FROM `HIS-INTEGRAGRUPOSCRE` Ing
					WHERE GrupoID = Var_GrupoID
						AND Estatus = Estatus_Activo
						AND ClienteID = Var_CueClienteID
						AND Ing.Ciclo = Var_CicloGrupo
					LIMIT 1;
			END IF;

			IF (Var_GrupoCtaID = Entero_Cero) THEN
				SET Par_NumErr		:= '009';
				SET Par_ErrMen		:= CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),' No Pertenece al Socio ', CONVERT(Var_ClienteID, CHAR), '.');
				SET varControl		:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Var_CueMoneda, Entero_Cero) != Var_MonedaID) THEN
		SET Par_NumErr		:= '010';
		SET Par_ErrMen		:= 'La Moneda no corresponde con la Cuenta.';
		SET varControl		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_CueSaldo, Decimal_Cero) < Par_MontoPagar) THEN
		SET Par_NumErr		:= '011';
		SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Socio.';
		SET varControl		:= 'cuentaAhoID';
		LEAVE ManejoErrores;
	END IF;

	# Consultar el total de intereses + iva adeudado a la fecha por el credito
	SELECT FNTOTALINTERESCREDITO(Par_CreditoID) INTO Var_TotalInteres;

	IF(IFNULL(Var_TotalInteres, Decimal_Cero) != Par_MontoPagar AND Var_PagoIntVertical = Constante_SI) THEN
		SET Par_NumErr		:= '012';
		SET Par_ErrMen		:= 'El Monto a Pagar debe ser Igual al Total de Intereses Adeudado.';
		SET varControl		:= 'montoPagar';
		LEAVE ManejoErrores;
	END IF;


	# Respaldamos las tablas de CREDITOS, AMORTICREDITO, CREDITOSMOVS antes de realizar el pago (usado para la reversa)
	CALL RESPAGCREDITOPRO(
		Par_CreditoID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	# =============================================================================================================================================================
	#													INICIA EL PAGO DE LOS INTERESES DEL CREDITO
	# =============================================================================================================================================================

	OPEN CURSORAMORTIZACIONES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOFETCH: LOOP

			FETCH CURSORAMORTIZACIONES INTO
				Var_AmortizacionID,		Var_SaldoInteresOrd,	Var_SaldoInteresAtr,	Var_SaldoInteresVen,
				Var_SaldoInteresPro,	Var_SaldoIntNoConta,	Var_SaldoMoraVenci,		Var_SaldoMoraCarVen,
				Var_SaldoMoratorios,	Var_FechaInicio,		Var_FechaVencim,		Var_FechaExigible;


			# ===================================  SE REALIZA EL PAGO DE SALDO DE INTERES MORATORIO VENCIDO  ======================================
			IF (Var_SaldoMoraVenci >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar := ROUND((ROUND(Var_SaldoMoraVenci, 2) *  Var_IVAInteresOrdi), 2);
				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes moratorio vencido con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoMoraVenci, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoMoraVenci;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes moratorio vencido con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				CALL PAGCREMORATOVENCPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,     	Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
					Par_ErrMen,			Var_Consecutivo,		Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

			# ===================================  SE REALIZA EL PAGO DE SALDO DE INTERES MORATORIO DE CARTERA VENCIDA (Cuentas de Orden)  ======================================
			IF (Var_SaldoMoraCarVen >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar = ROUND((ROUND(Var_SaldoMoraCarVen, 2) *  Var_IVAInteresOrdi), 2);

				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes moratorio de cartera vencida con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoMoraCarVen, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoMoraCarVen;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes moratorio de cartera vencida con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				CALL PAGCREMORACARVENPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,    		Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,				Par_OrigenPago,			Par_NumErr,
					Par_ErrMen,			Var_Consecutivo,		Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

			# ===================================  SE REALIZA EL PAGO DE SALDO DE INTERES MORATORIO DE CARTERA VIGENTE  ======================================
			IF (Var_SaldoMoratorios >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar := ROUND((ROUND(Var_SaldoMoratorios, 2) *  Var_IVAInteresOrdi), 2);

				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes moratorio de cartera vigente con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoMoratorios, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoMoratorios;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes moratorio de cartera vigente con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				CALL  PAGCREMORAPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,    		Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Var_SaldoMoratorios,	Par_Poliza,				Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,		Par_EmpresaID,			Par_ModoPago,
					Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

			# ===================================  SE REALIZA EL PAGO DE INTERES VENCIDO  ======================================
			IF (Var_SaldoInteresVen >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar	 := ROUND(ROUND(Var_SaldoInteresVen,2) *  Var_IVAInteresOrdi, 2);

				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes vencido con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoInteresVen,2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoInteresVen;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes vencido con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
												ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);

				END IF;

				# Efectua el pago
				CALL PAGCREINTVENPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    		Var_FechaVencim,    	Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  		Var_MontoPagar,     	Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,      	Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,         		Par_OrigenPago,			Par_NumErr,
					Par_ErrMen,			Var_Consecutivo,		Par_EmpresaID,				Par_ModoPago,				Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,       		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF; # Termina pago de interes vencidos

			# ===================================  SE REALIZA EL PAGO DE INTERES ATRASADO  ======================================
			IF (Var_SaldoInteresAtr >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar := ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_IVAInteresOrdi), 2);
				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes atrasado con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoInteresAtr, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoInteresAtr;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes atrasado con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				# Efectua el pago
				CALL PAGCREINTATRPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,   		Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,    		Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
					Par_ErrMen,			Var_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo, 2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

			# ===================================  SE REALIZA EL PAGO DE INTERES ORDINARIO (No proyecta)  ======================================
			# 2) Si existe un monto a pagar se efectua dicho pago
			IF (Var_SaldoInteresPro >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar := ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_IVAInteresOrdi), 2);
				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes provisionado con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoInteresPro;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes provisionado con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				# Efectua el pago
				CALL PAGCREINTPROPRO (
					Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,	    	Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,				Par_OrigenPago,			Par_NumErr,
					Par_ErrMen,			Var_Consecutivo,    	Par_EmpresaID,     		Par_ModoPago,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo, 2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

			# ===================================  SE REALIZA EL PAGO DE INTERES NO CONTABILIZADO  ======================================
			IF (Var_SaldoIntNoConta >= Monto_MinimoPago) THEN

				SET	Var_MontoIVAPagar := ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_IVAInteresOrdi), 2);
				# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes no contabilizado con su respectivo IVA
				IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoIntNoConta, 2) + Var_MontoIVAPagar)) THEN
					SET	Var_MontoPagar		:=  Var_SaldoIntNoConta;
				ELSE
					# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes no contabilizado con su respectivo IVA
					SET	Var_MontoPagar		:= Var_MontoSaldo -
											   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
				END IF;

				CALL PAGCREINTNOCPRO (
					Par_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,    	Var_FechaVencim,    		Par_CuentaAhoID,
					Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,  	Var_MontoPagar,     		Var_MontoIVAPagar,
					Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   	Var_SucursalID,
					Des_PagoCredito,    Mov_Referencia,       	Par_Poliza,         	Var_DivideIngresoInteres,	Par_OrigenPago,
					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,    	Par_EmpresaID,				Par_ModoPago,
					Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLOFETCH;
				END IF;

				# Verifica si aun hay dinero en la bolsa para continuar pagando o se sale del ciclo
				SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);

				IF(ROUND(Var_MontoSaldo, 2)	<= Decimal_Cero) THEN
					LEAVE CICLOFETCH;
				END IF;

			END IF;

		END LOOP;
	END;
	CLOSE CURSORAMORTIZACIONES;

	# Si hubo Errores en el CURSOR Previo, entonces termina y marca error
	IF (Par_NumErr <> Entero_Cero) THEN
		LEAVE ManejoErrores;
	ELSE
		IF(IFNULL(Var_MontoSaldo, Decimal_Cero) > Decimal_Cero) THEN
			SET Par_NumErr		:= '013';
			SET Par_ErrMen		:= CONCAT('No se Efectuo el Pago Total, Adeudo Pendiente: ', Var_MontoSaldo);
			SET varControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SET	Var_MontoPago	 := Par_MontoPagar - ROUND(Var_MontoSaldo,2);

		CALL CONTAAHORROPRO (
			Par_CuentaAhoID,	Var_CueClienteID,	Aud_NumTransaccion,		Var_FechaSistema,	Var_FecAplicacion,
			Naturaleza_Cargo,	Var_MontoPago,		Des_PagoCredito,		Var_CreditoStr,		Aho_PagoCred,
			Var_MonedaID,		Var_SucursalID,		AltaPoliza_NO,			Entero_Cero,		Par_Poliza,
			AltaMovAho_SI,		Con_AhoCapital,		Naturaleza_Cargo,		Par_NumErr,			Par_ErrMen,
			Var_Consecutivo,	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

         # Se obtiene el total de amortizaciones atrasadas que tiene un credito
		SET Var_NumeroAmort		:= (SELECT COUNT(*) FROM AMORTICREDITO
									WHERE Estatus = Estatus_Atrasado
									AND CreditoID = Par_CreditoID
                                    AND SaldoInteresAtr != Entero_Cero);
		SET Var_NumeroAmort 	:= IFNULL(Var_NumeroAmort, Entero_Cero);

        # Si el numero de amortizaciones es mayor a cero
        IF(Var_NumeroAmort > Entero_Cero) THEN
			# Se obtiene la fecha minima de atraso de una amortizacion
			SET Var_FechaMinAtraso 	:= (SELECT MIN(FechaExigible) FROM AMORTICREDITO
										WHERE CreditoID =  Par_CreditoID
										AND Estatus = Estatus_Atrasado
										AND SaldoInteresAtr != Entero_Cero);

			SET Var_FechaMinAtraso 	:= IFNULL(Var_FechaMinAtraso, Fecha_Vacia);

			# Se actualiza la fecha de atraso de interes con la fecha minima de atraso de interes de la amortizacion
			UPDATE CREDITOS SET
				FechaAtrasoInteres	= Var_FechaMinAtraso
				WHERE CreditoID 	= Par_CreditoID;

            ELSE
				# Si la amortizacion ya no tiene atrasos de interes, la fecha se inicializa a fecha vacia
				 UPDATE CREDITOS SET
					FechaAtrasoInteres	= Fecha_Vacia
					WHERE CreditoID		= Par_CreditoID;
            END IF;

		# Se respalda el pago efectuado para complementar los datos necesarios para la reversa de pago de credito
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion,	Par_CuentaAhoID,	Par_CreditoID,	Var_MontoPago,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Pago Realizado Exitosamente.';
		SET varControl := 'creditoID';

	END IF;


	END ManejoErrores;  # END del Handler de Errores

	IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$