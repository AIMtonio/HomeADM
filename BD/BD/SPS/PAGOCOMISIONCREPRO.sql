-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCOMISIONCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCOMISIONCREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOCOMISIONCREPRO`(
-- -----------------------------------------------------------------------------------------------------------------------
# ========== REALIZA EL PAGO INDIVIDUAL DE COMISIONES DE UN CREDITO ( Comision por Falta de Pago, Comision por Seguro,
#								 y Comision por Apertura de Credito)============
-- -----------------------------------------------------------------------------------------------------------------------
	Par_TipoCobro		CHAR(1),			# Tipo Cobro I:Individual   M:Masivo
    Par_TipoComision	CHAR(2),			# Tipo de Pago de Comision
    Par_AccesorioID		INT(11),			# ID del Accesorio
    Par_CreditoID       BIGINT(12),			# ID de credito al que se le efectuara el pago
    Par_MontoPagar	    DECIMAL(12,2),		# Monto del pago que esta realizando

	Par_ModoPago		CHAR(1),			# Forma de pago Efectivo o con cargo a cuenta
	Par_CuentaAhoID     BIGINT(12),			# ID de la cuenta de ahorro sobre la cual se haran los movimientos
	Par_Poliza			BIGINT,				# Numero de poliza
	Par_OrigenPago		CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    INOUT Par_Consecutivo	BIGINT,
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
	DECLARE varControl 		    		VARCHAR(100);	# Almacena el elemento que es incorrecto
	DECLARE Var_FechaSistema    		DATE;			# Almacena la fecha actual del sistema
	DECLARE Var_FecAplicacion   		DATE;			# Fecha en la que se aplica el pago
	DECLARE Var_MontoSaldo	    		DECIMAL(12,2);	# Guarda el saldo que va quedando despues de los pagos que se van haciendo
	DECLARE Var_MontoPagar     			DECIMAL(14, 4);	# Guarda el monto que se va a pagar en cada amortizacion
	DECLARE Var_MontoIVAPagar	 		DECIMAL(12, 2);	# Cantidad de IVA a pagar
	DECLARE Var_IVA						DECIMAL(12,2);	# porcentaje de iva general
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
	DECLARE Var_DiasCredito     		INT(11);		# Dias considerados para un año (util en el calculo de interes)
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

    DECLARE Var_SaldoComFaltP			DECIMAL(14,2);	# Saldo de la Comision por Falta de Pago
    DECLARE Var_SaldoComAdmon			DECIMAL(14,2);	# Saldo de la Comision por Administracion
    DECLARE Var_SaldoOtrasCom			DECIMAL(14,2);	# Saldo de Otras Comisiones
    DECLARE Var_SaldoComAper			DECIMAL(14,2);	# Saldo de Comision por Apertura de Credito
    DECLARE Var_SaldoSegCuota			DECIMAL(14,2);	# Saldo de Comision de Seguro por Cuota

    DECLARE Var_CobraSeguroCuota		CHAR(1);
	DECLARE Var_CobraIVASeguroCuota		CHAR(1);
    DECLARE Var_ForCobroComAper			CHAR(1);		# Forma de Cobro de la Comision por Apertura
    /*COMISION ANUAL*/
	DECLARE Var_CobraComAnual			CHAR(1);
	DECLARE Var_SaldoComAnual			DECIMAL(14,2);
	/*FIN COMISION ANUAL*/
    DECLARE Var_MontoSeguro				DECIMAL(14,2);
    DECLARE Var_MontoSeguroOp			DECIMAL(14,2);	# Monto del Seguro Operativo
	DECLARE Var_MontoSeguroCont			DECIMAL(14,2);	# Monto del Seguro Contable
	DECLARE Var_MontoIVASeguroOp		DECIMAL(14,2);	# Monto del IVA del Seguro Operativo
	DECLARE Var_MontoIVASeguroCont		DECIMAL(14,2);	# Monto del IVA del Seguro Contable
	DECLARE Var_ParamCobraAcc			CHAR(1);		# Indica si se realizara el cobro de accesorios

    DECLARE Var_LineaCreditoID			BIGINT(20);		-- Identificador de la linea de crédoto
    DECLARE Var_CobraComAnualLin			CHAR(1);	-- Indica si cobra comisión anual de linea de crédito
    DECLARE Var_ComisionCobradaLin			CHAR(1);	-- Indica si la comisión anual de linea ya fue cobrada
	DECLARE Var_FechaActPago				DATETIME;
	DECLARE Var_DifDiasPago					INT;

	# Declaracion de constantes
	DECLARE Cadena_Vacia    			CHAR(1);		# Cadena vacia
	DECLARE Entero_Cero     			INT(11);		# Entero cero
	DECLARE Decimal_Cero				DECIMAL(4,2);	# DECIMAL cero
	DECLARE Cons_No	        			CHAR(1);		# Constante no
	DECLARE Cons_Si	        			CHAR(1);		# Constante si
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
    DECLARE SiCobSeguroCuota			CHAR(1);		# Cobra Seguro por Cuota
    DECLARE SiCobIVASeguroCuota			CHAR(1);		# Cobra IVA del Seguro por Cuota
    DECLARE ComAperCredito				CHAR(2);		# Cobra Comision por Apertura de Credito
    DECLARE ComFaltaPago				CHAR(2);		# Cobra Comision por Falta de Pago
    DECLARE ComSeguroCuota				CHAR(2);		# Cobra Comision de Seguro por Cuota
    DECLARE ComAnual					CHAR(2);		# Cobra Comision Anual
    DECLARE TipoIndividual				CHAR(1);		# Tipo Individual
    DECLARE ForCobroAnticipada			CHAR(1);		# Forma de Cobro de Accesorios: ANTICIPADA
    DECLARE LlaveCobraAccesorios		VARCHAR(200);	# Llave que indica el cobro Accesorios
    DECLARE ComAnualLin					CHAR(2);		-- Cobra Comosión Anualildad Linea Crédito
	DECLARE Fecha_Vacia					DATE;			-- Declaración de la Fecha Vacia

	DECLARE CURSORAMORTIZACIONES CURSOR FOR
		SELECT  AmortizacionID, Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Amo.SaldoSeguroCuota,
        Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible,		Cre.CobraComAnual,
        Amo.SaldoComisionAnual
		FROM AMORTICREDITO Amo
			INNER JOIN CREDITOS Cre ON (Amo.CreditoID = Cre.CreditoID)
			INNER JOIN CLIENTES Cli ON (Cre.ClienteID = Cli.ClienteID)
		WHERE Cre.CreditoID      = 	Par_CreditoID
			AND (Amo.Estatus	 =  Estatus_Vigente
				OR Amo.Estatus =  Estatus_Atrasado
				OR Amo.Estatus =  Estatus_Vencido)
			AND (Cre.Estatus	   =  Estatus_Vigente
				OR Cre.Estatus =  Estatus_Vencido)
		ORDER BY Amo.FechaInicio;

	# Asignacion  de constantes
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaNO       		:= 'N';
	SET Cons_No       		:= 'N';
	SET Cons_Si       		:= 'S';
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
    SET SiCobSeguroCuota	:= 'S';
	SET SiCobIVASeguroCuota := 'S';
	SET ComAperCredito		:= 'CA';
    SET ComFaltaPago		:= 'FP';
    SET ComSeguroCuota		:= 'PS';
    SET ComAnual			:= 'AN';
    SET ComAnualLin			:= 'CL';			-- Tipo de Comisión Anual Linea
    SET TipoIndividual		:= 'I';
    SET ForCobroAnticipada	:= 'A'; 					-- Constante Forma Cobra Acnticipada
    SET LlaveCobraAccesorios	:= 'CobraAccesorios';	-- Llave para Consultar Cobro de Accesorios
    SET	Fecha_Vacia			:= '1900-01-01';	-- Asignacion del Valor de la Fecha Vacia

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCOMISIONCREPRO');
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

	SELECT  Cli.ClienteID,				Cli.SucursalOrigen,		Cli.PagaIVA,			Pro.CobraIVAInteres,    Pro.CobraIVAMora,
			Cre.MonedaID,				Pro.ProducCreditoID,	Des.Clasificacion,		Des.SubClasifID,		Pro.ProyInteresPagAde,
			Cre.Estatus,				Cre.TasaFija,			Res.EstatusCreacion,	Pro.EsReestructura,		Res.Regularizado,
			Pro.EsGrupal,				Cre.GrupoID,			Cre.SolicitudCreditoID,	Cre.CicloGrupo,			Cre.CobraSeguroCuota,
            Cre.CobraIVASeguroCuota,	Cre.ForCobroComAper,	Cre.MontoComApert,		Cre.LineaCreditoID
	INTO 	Var_ClienteID,				Var_SucursalID,			Var_PagaIVA,			Var_CobraIVAInteres,	Var_CobraIVAMora,
			Var_MonedaID,				Var_ProducCreditoID,	Var_ClasificaCredito,	Var_SubClasifCredito,	Var_ProyInteresPagAde,
			Var_EstatusCredito,			Var_TasaFija,			Var_EstatusCreacion,	Var_EsReestructura,		Var_Regularizado,
			Var_EsGrupal,				Var_GrupoID,			Var_SolicitudCreditoID,	Var_CicloGrupo, 		Var_CobraSeguroCuota,
            Var_CobraIVASeguroCuota,	Var_ForCobroComAper,	Var_SaldoComAper,		Var_LineaCreditoID
	FROM CLIENTES Cli
		INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
		INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
		INNER JOIN DESTINOSCREDITO Des ON (Cre.DestinoCreID = Des.DestinoCreID)
		LEFT  JOIN REESTRUCCREDITO Res ON (Res.CreditoDestinoID = Cre.CreditoID)
	WHERE Cre.CreditoID = Par_CreditoID;

	IF (Var_PagaIVA = SiPagaIVA) THEN
		SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);



	END IF;

	SET Var_IVA				:= IFNULL(Var_IVA,  Decimal_Cero);
	SET Aud_FechaActual		:= NOW();

	SELECT ValorParametro INTO Var_ParamCobraAcc FROM PARAMGENERALES WHERE LlaveParametro = LlaveCobraAccesorios;

	-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
	# SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
	SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID AND FechaPago = Var_FechaSistema);
	SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

	# SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
	SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
	SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

	IF (Par_TipoCobro = TipoIndividual) THEN
		# SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
		IF(Var_DifDiasPago=Entero_Cero)THEN
			IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= time('00:01:00'))THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
				SET varControl 	 	:= 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

# ===================================================  SECCION DE VALIDACIONES ANTES DE ENTRAR AL CICLO DE PAGOS  ==================================================
	IF(IFNULL(Par_CreditoID,  Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr  := '001';
		SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
		SET varControl  := 'creditoID' ;
		LEAVE ManejoErrores;

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

    IF (Par_TipoCobro = TipoIndividual) THEN
		IF(IFNULL(Var_CueSaldo, Decimal_Cero) < Par_MontoPagar) THEN
			SET Par_NumErr		:= '011';
			SET Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Socio.';
			SET varControl		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	# Respaldamos las tablas de CREDITOS, AMORTICREDITO, CREDITOSMOVS antes de realizar el pago (usado para la reversa)
	CALL RESPAGCREDITOPRO(
		Par_CreditoID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

    IF(Var_CueSaldo<Var_MontoSaldo) THEN
		SET Var_MontoSaldo := Var_CueSaldo;
        SET Par_MontoPagar := Var_CueSaldo;
    END IF;

     # ===================================  SE REALIZA EL RESPALDO DE LOS ACCESORIOS DE CREDITO  ======================================
	IF(Var_ParamCobraAcc = Cons_Si) THEN
		IF(Par_AccesorioID > Entero_Cero) THEN
			CALL RESDETACCESORIOSPRO(
				Par_CreditoID,		Par_AccesorioID,	Entero_Cero,		SalidaNO, 			Par_NumErr,    		Par_ErrMen,
                Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
                Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
        END IF;
	END IF;

    # ===================================  SE REALIZA EL PAGO DE LA COMISION POR APERTURA DE CREDITO  ======================================
	IF(Par_TipoComision = ComAperCredito) THEN
		IF (Var_SaldoComAper >= Monto_MinimoPago) THEN

			CALL COBROCOMAPERCREPRO (
				Par_CreditoID,		Par_CuentaAhoID,	Var_ClienteID,			Var_MonedaID,		Var_ProducCreditoID,
				Var_MontoSaldo,		Var_MontoSaldo,		Var_ForCobroComAper,	Par_Poliza,			Par_OrigenPago,
				Par_Salida,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
        END IF;
	END IF;

    # ===================================  SE REALIZA EL PAGO DE LOS ACCESORIOS DE CREDITO  ======================================
	IF(Var_ParamCobraAcc = Cons_Si) THEN
		IF(Par_AccesorioID > Entero_Cero) THEN
				CALL COBROACCESORIOSCREPRO (
					Par_CreditoID,			Par_AccesorioID,	Par_CuentaAhoID,		Var_ClienteID,			Var_MonedaID,
					Var_ProducCreditoID,	Var_MontoSaldo,		Var_MontoSaldo,			ForCobroAnticipada,		Par_Poliza,
					Par_OrigenPago,			Par_Salida, 		Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);
				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;
	END IF;

    -- ===================== Inicio Comisión Anual Linea de Crédito ============================
    SELECT 	CobraComAnual, 		ComisionCobrada
		INTO Var_CobraComAnualLin,	Var_ComisionCobradaLin
	FROM LINEASCREDITO
	WHERE LineaCreditoID = Var_LineaCreditoID;

	IF( IFNULL(Var_LineaCreditoID,Entero_Cero)<>Entero_Cero AND
		IFNULL(Var_CobraComAnualLin,Cadena_Vacia)=Cons_Si AND
        IFNULL(Var_ComisionCobradaLin,Cadena_Vacia)=Cons_No) THEN

        CALL COBROCOMANUALLINEAPRO(
			Par_CreditoID,		Var_ClienteID,		Var_MontoSaldo,		Par_CuentaAhoID,		Par_Poliza,
            Var_MonedaID,		Par_Salida,			Par_NumErr,    		Par_ErrMen,				Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,    		Aud_Sucursal,
            Aud_NumTransaccion);
    END IF;
    -- ===================== Fin Comisión Anual Linea de Crédito ============================

	# =============================================================================================================================================================
	#													INICIA EL PAGO DE LAS COMISIONES
	# =============================================================================================================================================================

	OPEN CURSORAMORTIZACIONES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOFETCH: LOOP

			FETCH CURSORAMORTIZACIONES INTO
				Var_AmortizacionID,		Var_SaldoComFaltP,	Var_SaldoOtrasCom,	Var_SaldoSegCuota,
                Var_FechaInicio,		Var_FechaVencim,	Var_FechaExigible,	Var_CobraComAnual,
                Var_SaldoComAnual;

            SET Var_CobraComAnual	:= IFNULL(Var_CobraComAnual, Cons_No);/*COMISION ANUAL*/
			SET Var_SaldoComAnual	:= IFNULL(Var_SaldoComAnual, Entero_Cero);/*COMISION ANUAL*/

            # ===================================  SE REALIZA EL PAGO DE SEGURO POR CUOTA  ======================================
            IF(Par_TipoComision = ComSeguroCuota) THEN
				SET Var_MontoSeguro := Var_SaldoSegCuota;

				IF(Var_SaldoSegCuota >= Monto_MinimoPago AND Var_CobraSeguroCuota = SiCobSeguroCuota) THEN
					-- Se verifica el cobro del IVA de Seguro por Cuota
					IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
						SET Var_MontoIVAPagar 		:= ROUND((Var_SaldoSegCuota * Var_IVA), 2);
					ELSE
						SET Var_MontoIVAPagar 		:= Decimal_Cero;
                         -- CONTABLE
						SET Var_MontoSeguroCont 	:=  ROUND((Var_SaldoSegCuota/(1+Var_IVA)),2);
						SET Var_MontoIVASeguroCont 	:= 	ROUND(Var_MontoSeguro-Var_MontoSeguroCont,2);

					END IF;

					-- Se obtiene el Monto a Pagar
					IF(ROUND(Var_MontoSaldo,2) >= (Var_SaldoSegCuota + Var_MontoIVAPagar)) THEN
						SET Var_MontoPagar		:= Var_SaldoSegCuota;


					ELSE

						IF (Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
							SET	Var_MontoPagar		:= ROUND(Var_MontoSaldo,2) -
													   ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);

							SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
						ELSE
							-- OPERATIVO
							SET	Var_MontoPagar		:= ROUND(Var_MontoSaldo,2) -
														ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
							SET	Var_MontoIVAPagar  := Decimal_Cero;
							-- CONTABLE
							SET	Var_MontoSeguroCont		:= ROUND(Var_MontoSaldo,2) -
													   ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
							SET	Var_MontoIVASeguroCont   := ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
						END IF;
					END IF;

					-- Proceso para el Pago de Seguro por Cuota
					SET Var_MontoSeguroOp 		:= Var_MontoPagar;
					SET Var_MontoIVASeguroOp	:= Var_MontoIVAPagar;
					IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
					CALL PAGCRESEGCUOTAPRO (
						Par_CreditoID,	    Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,		Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,		Var_MontoPagar,    		Var_MontoIVAPagar,
						Var_MonedaID,       Var_ProducCreditoID,	Var_ClasificaCredito, 	Var_SubClasifCredito,   Var_SucursalID,
						Des_PagoCredito,	Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
						Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,     	 	Par_ModoPago,			Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
					ELSE
						CALL PAGCRESEGCUOTASINIVAPRO (
							Par_CreditoID,	    	Var_AmortizacionID, 		Var_FechaInicio,    	Var_FechaVencim,		Par_CuentaAhoID,
							Var_ClienteID,      	Var_FechaSistema,   		Var_FecAplicacion,      Var_MontoSeguroOp,  	Var_MontoIVASeguroOp,
							Var_MontoSeguroCont,	Var_MontoIVASeguroCont,		Var_MonedaID,       	Var_ProducCreditoID,	Var_ClasificaCredito,
                            Var_SubClasifCredito,   Var_SucursalID,				Des_PagoCredito,		Mov_Referencia,   		Par_Poliza,
                            Par_OrigenPago,			Par_NumErr,         		Par_ErrMen,				Par_Consecutivo,    	Par_EmpresaID,
                            Par_ModoPago,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
                            Aud_Sucursal,			Aud_NumTransaccion);

					END IF;

					-- Se obtiene el monto disponible para realizar los pagos siguientes
					SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
					IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
						LEAVE CICLOFETCH;
					END IF;
				END IF; -- FIN Pago Seguro por Cuota
            END IF;

            -- Pago de Comision x Anualidad
		IF(Var_CobraComAnual = Cons_Si AND Par_TipoComision = ComAnual) THEN/*COMISION ANUAL*/
			SET Var_MontoIVAPagar	:= Entero_Cero;
			SET Var_MontoPagar 	:= Entero_Cero;

			IF(Var_IVA > Entero_Cero) THEN
				SET Var_MontoIVAPagar 		:= ROUND((Var_SaldoComAnual * Var_IVA), 2);
			ELSE
				SET Var_MontoIVAPagar 		:= Decimal_Cero;
			END IF;

			-- Se obtiene el Monto a Pagar
			IF(ROUND(Var_MontoSaldo,2) >= (Var_SaldoComAnual + Var_MontoIVAPagar)) THEN
				SET Var_MontoPagar		:= Var_SaldoComAnual;
			  ELSE
				SET	Var_MontoPagar		:= ROUND(Var_MontoSaldo,2) - ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
				SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo)/(1+Var_IVA)) * Var_IVA, 2);
			END IF;

			CALL PAGCRECOMANUALIDADPRO (
				Par_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,		Var_FechaVencim,		Par_CuentaAhoID,
				Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,		Var_MontoPagar,			Var_MontoIVAPagar,
				Var_MonedaID,		Var_ProducCreditoID,	Var_ClasificaCredito,	Var_SubClasifCredito,	Var_SucursalID,
				Des_PagoCredito,	Mov_Referencia,			Par_Poliza,				Cons_No,				Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			-- Se actualiza el Numero de Transaccion en AMORTICREDITO
			UPDATE AMORTICREDITO Tem
			SET NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoID = Par_CreditoID;

			-- Se obtiene el monto disponible para realizar los pagos siguientes
			SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
			IF(ROUND(Var_MontoSaldo,2)	<= Decimal_Cero) THEN
				LEAVE CICLOFETCH;
			END IF;/*COMISION ANUAL*/
		END IF; -- FIN Pago Comision x Anualidad

            # ===================================  SE REALIZA EL PAGO DE SALDO DE COMISION POR FALTA DE PAGO  ======================================
            IF(Par_TipoComision = ComFaltaPago) THEN

				IF (Var_SaldoComFaltP >= Monto_MinimoPago) THEN

					SET	Var_MontoIVAPagar := ROUND(Var_SaldoComFaltP *  Var_IVA, 2);

					# Si aun hay saldo disponible suficiente en la bolsa se paga el total de interes moratorio vencido con su respectivo IVA
					IF(ROUND(Var_MontoSaldo,2)	>= (Var_SaldoComFaltP + Var_MontoIVAPagar)) THEN
						SET	Var_MontoPagar		:=  Var_SaldoComFaltP;
					ELSE
						# Si el saldo en la bolsa no es suficiente solo se pagara una parte del interes moratorio vencido con su respectivo IVA
						SET	Var_MontoPagar		:= Var_MontoSaldo -
												   ROUND(((Var_MontoSaldo) / (1 + Var_IVA)) * Var_IVA, 2);
						SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVA)) * Var_IVA, 2);
					END IF;

				CALL  PAGCOMFALPAGOPRO (
						Par_CreditoID,	    Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,		Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,		Var_MontoPagar,    		Var_MontoIVAPagar,
						Var_MonedaID,		Var_ProducCreditoID,	Var_ClasificaCredito,   Var_SubClasifCredito,	Var_SucursalID,
						Des_PagoCredito,	Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
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
