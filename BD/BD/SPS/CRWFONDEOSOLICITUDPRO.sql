-- SP CRWFONDEOSOLICITUDPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS CRWFONDEOSOLICITUDPRO;

DELIMITER $$
CREATE PROCEDURE CRWFONDEOSOLICITUDPRO(
	Par_SolicitudCreditoID		BIGINT(20),				-- Numero de solicitud de credito
	Par_CreditoID				BIGINT(12),				-- Numero de credito
	Par_ClienteID				INT(11),				-- Numero de cliente
	Par_CuentaAhoID				BIGINT(12),				-- Numero de cuenta de ahorro
	Par_MontoFondeo				DECIMAL(12,2),			-- Monto del fondeo

	Par_TasaPasiva				DECIMAL(8,4),			-- Tasa pasiva del fondeo
	Par_TipoFondeo				CHAR(1),            	-- S: Fondeo por Solicitud, C: Fondeo por Credito

	Par_Salida					CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr			INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen			VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID				INT(11),				-- Parametro de Auditoria EmpresaID
	Aud_Usuario					INT(11),				-- Parametro de Auditoria Usuario
	Aud_FechaActual				DATETIME,				-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(11),				-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore : BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control de errores
	DECLARE Var_PrimerNombre		VARCHAR(50);		-- Variable para almacenar el primer nombre del cliente
	DECLARE Var_SegundoNombre		VARCHAR(50);		-- Variable para almacenar el segundo nombre del cliente
	DECLARE Var_TercerNombre		VARCHAR(50);		-- Variable para almacenar el tercer nombre del cliente
	DECLARE Var_ApellidoPaterno		VARCHAR(50);		-- Variable para almacenar el apellido paterno del cliente
	DECLARE Var_ApellidoMaterno		VARCHAR(50);		-- Variable para almacenar el apellido materno del cliente
	DECLARE Var_RFCOficial			CHAR(13);			-- Variable para almacenar el rfc oficial del cliente
	DECLARE Var_FechaNacimiento		DATE;				-- Variable para almacenar la fecha de nacimiento del cliente
	DECLARE Var_PaisID				INT(11);			-- Variable para almacenar el pais de nacimiento del cliente
	DECLARE Var_EstadoID			INT(11);			-- Variable para almacenar el estado del cliente
	DECLARE Var_TipoPersona			CHAR(1);			-- Variable para almacenar el tipo de persona del cliente
	DECLARE Var_FechaSis			DATE;				-- Variable para almacenar la fecha del sistema
	DECLARE Var_MonedaBase			INT(11);			-- Variable para almacenar la moneda base
	DECLARE Var_ClienteInstit		INT(11);			-- Variable para almacenar el cliente de la institucion
	DECLARE Var_CredFondeo			BIGINT(20);			-- Variable para validar si el credito esta en proceso de pago
	DECLARE Var_EstCredito			CHAR(1);			-- Variable para obtener el estatus del credito
	DECLARE Var_SaldoInsoluto		DECIMAL(12,4);		-- Variable para obtener el saldo insoluto
	DECLARE Var_ProductCredID		INT(11);			-- Variable para obtener Var_SigFecGrael producto de credito
	DECLARE Var_DiasAtraAct     	INT(11);			-- Variable para obtener los dias de atraso
	DECLARE Var_CadenaNO			CHAR(1);			-- Cadena NO
	DECLARE Var_TipoCte				CHAR(4);			-- Tipo persona SAFI : Cliente
	DECLARE Var_CadenaSi			CHAR(1);			-- Cadena Si
	DECLARE Var_TipFondeoSol		CHAR(1);			-- Tipo de fondeo : Solicitud
	DECLARE Var_TipFondeoCred		CHAR(1);			-- Tipo de fondeo : Credito
	DECLARE Var_SigFecGra       	DATE;				-- Variable para obtener siguiente fecha de gracia
	DECLARE Var_FecSigVenc      	DATE;				-- Variable para obtener fecha sig vencida
	DECLARE Var_MontoCred       	DECIMAL(14,2);		-- Variable para obtener el monto del credito
	DECLARE Var_NumAmorti       	INT(11);			-- Variable para obtener los nuemeros de amortizaciones
	DECLARE Var_FrecuenCap     		CHAR(1);			-- Variable para obtener la frecuencia capital
	DECLARE Var_DiaPagoCap     		CHAR(1);			-- Variable para obtener dua oagi capital
	DECLARE Var_DiaMesCap      		INT(11);			-- Variable para obtener dia mes capital
	DECLARE Var_ProdCreID      		INT(11);			-- Variable para obtener producto credito id
	DECLARE Var_FechaInhabil   		CHAR(1);			-- Variable para obtener fecha inhabil
	DECLARE Var_AjFecUlVenAmo  		CHAR(1);			-- Variable para obtener si ajusta la ultima fecha de vencimiento de la amortizacion
	DECLARE Var_AjFecExiVen   		CHAR(1);			-- Variable para obtener si ajusta la fecha exigible de vencimiento
	DECLARE Var_TasaActiva			DECIMAL(8,4);		-- Variable para obtener la tasa activa
	DECLARE Var_SaldoCre			DECIMAL(14,2);		-- Variable para obtener los saldos de credito
	DECLARE Var_MontoSolici     	DECIMAL(12,2);		-- Variable para obtener el monto de la solicitud
	DECLARE	Var_DisponFondeo		DECIMAL(12,2);		-- Variable para obtener lo Disponible del fondeo
	DECLARE Var_MontoFondea			DECIMAL(12,2);		-- Variable para obtener el monto fondeado
	DECLARE Var_PorFonAct       	DECIMAL(10,6);		-- Variable para obtener el porcentaje fondeado activo
	DECLARE Var_PorceFondeo     	DECIMAL(10,6);		-- Variable para obtener el porcentaje de fondeo
	DECLARE Var_CredSol     		BIGINT(20);			-- Variable para obtener la solicitud de credito
	DECLARE Var_CliPros	 			INT(11);			-- variable para guardar el Numero de Cliente o Prospecto
	DECLARE Var_CliCuenta   		BIGINT(20);			-- Variable para obtener la cliente de la cuenta
	DECLARE Var_CueDispon 		  	DECIMAL(12, 2);		-- Variable para obtener la cuenta ahorro Disponible
	DECLARE Var_CueMoneda   		INT(11);			-- Variable para obtener moneda de la cuenta
	DECLARE Var_CueEstatus			CHAR(1);			-- Variable para obtener el estatus de la cuenta
	DECLARE Var_PorActPago      	DECIMAL(10,2);		-- Variable para obtener el porcentaje actual de pago
	DECLARE Var_MonedaID			INT(11);			-- Variable para obtener el ID de la moneda
	DECLARE Var_TipoFondID  		INT(11);			-- Variable para obtener el ID del tipo de fondeadoR
	DECLARE Var_GAT					DECIMAL(12,2);		-- Variable para obtener el valor de GAT
	DECLARE Var_GATReal				DECIMAL(12,2);		-- Variable para obtener el valor de GAT real
	DECLARE Var_DiasInversion		INT(11);			-- Variable para obtener el valor de dias de inversion
	DECLARE Var_FechaInicio			DATE;				-- Variable para obtener el valor de la fecha de inicio
	DECLARE Var_MontoPorComAper		DECIMAL(12,4);		-- Variable para obtener el valor del monto por comision de apertura
	DECLARE Var_CobraSeguroCuota	CHAR(1);			-- Variable para obtener el valor si cobra cuota de seguro
	DECLARE Var_CobraIVASegCuota	CHAR(1);			-- Variable para obtener el valor si cobra cuota de iva seguro
	DECLARE Var_MontoSeguroCuota	DECIMAL(12,2);		-- Variable para obtener el valor del Monto por Seguro por Cuota
	DECLARE Var_NumTranSimulador	BIGINT(20);			-- Variable para obtener el valor del Numero de transaccion del simulador
	DECLARE Var_Cuotas        		INT(11);			-- Variable para obtener el valor de cuotas
	DECLARE Var_NumSolFon			INT(11);			-- Variable para obtener el valor de Numero de solicitud de fondeo
	DECLARE Var_TipoBloqID  		INT(11);			-- Variable para obtener el valor de tipo de bloqeo ID
	DECLARE Var_DescripBlo      	VARCHAR(50) ;		-- Variable para obtener la decripcion de bloqueo
	DECLARE Var_Poliza          	BIGINT(12);			-- Variable para almacenar la poliza
	DECLARE Var_NumRetMes       	INT(11);			-- Numero de retiros al mes
	DECLARE Par_Consecutivo     	INT(11);			-- Variable para almacenar el consecutivo
	DECLARE Var_PolCargos			DECIMAL(16,2);		-- Variable par la suma de los cargos
	DECLARE Var_PolAbonos			DECIMAL(16,2);		-- Variable para la suma de los abonos
	DECLARE Var_CargosOpe			DECIMAL(16,2);		-- Variable para los cargos operativos
	DECLARE	Var_FondeoID			BIGINT(20);			-- Variable para almacenar el fondeo
	DECLARE	Var_NumAmortiCero		INT(11);			-- Variable para numero de amorti credito
	DECLARE Var_PrimAmorti			INT(11);			-- Variable para la Primera amortizacion
	DECLARE Var_UltimaAmorti		INT(11);			-- Variable para la ultima amortizacion
	DECLARE Var_CapPrimAmor			DECIMAL(14,2);		-- Capital Primera Amortizacion
	DECLARE Var_CapUltAmorti		DECIMAL(14,2);		-- Capital de la Ultima Amortizacion
	DECLARE Var_DifAmorti			DECIMAL(14,2);		-- Diferencia de las amortizaciones
	DECLARE Var_MargenPagos			DECIMAL(10,2);		-- Variable para el margen de pagos
	DECLARE	Var_CuentaExcenta		BIGINT(20);			-- Variable para la cuenta excenta
	DECLARE Var_Consecutivo			BIGINT(20);			-- Vairable consecutivo
	DECLARE Var_FecIni				DATE;				-- Variable para obtener la fecha de incicio
	DECLARE Var_FecFin				DATE;				-- Variable para obtener la fecha de fin
	DECLARE Var_FecVig				DATE;				-- Variable para obtener la fecha de vigencia
	DECLARE Var_Capital				DECIMAL(12,2);		-- Variable para obtener la capital
	DECLARE Var_Interes				DECIMAL(12,2);		-- Variable para obtener los intereses
	DECLARE Var_ISR				 	DECIMAL(14,2);		-- Variable para obtener la isr
	DECLARE Var_SubTotal			DECIMAL(12,2);		-- Variable para obtener el subtotal
	DECLARE Var_MinPorFon       	DECIMAL(10,2);		-- Variable para obtener el minimo porcentaje fondeado
	DECLARE Var_MaxPorPag       	DECIMAL(12,2);		-- Variable para obtener el maximo porcentaje pagos
	DECLARE Var_MaxDiasAtr     		INT(11);			-- Variable para obetner el maximo de dias de atraso
	DECLARE Var_DiasGraVen      	INT(11);			-- Variable para obtener el numero de dias de gracia para vencimiento
	DECLARE Var_TasaISR     	 	DECIMAL(8,4);		-- Variable para obtener la tasa isr
	DECLARE Var_FormReten  	 		CHAR(1);			-- Variable para obtener la formula de rentencion
	DECLARE Var_ClienteID		 	INT(11);			-- Variable para obtener el cliente id
	DECLARE Var_ProspectoID	 		INT(11);			-- Variable para obtener el prospecto id
	DECLARE Var_EstaSol				CHAR(1);			-- Variable para obtener el estatus de la solicitud
	DECLARE Var_NumSolFond			BIGINT(20);			-- Variable para obtener el numero de solicitud de fondeo
	DECLARE Var_LlaveCRW			VARCHAR(50);		-- Llave para filtro de modulo crowdfunding
	DECLARE Var_CrwActivo			CHAR(1);			-- Variable para almacenar el valor de habilitacion de modulo crowdfunding
	DECLARE Var_IVA					DECIMAL(12,2);		-- Variable para almacenar el valor del iva
	DECLARE Var_Insoluto			DECIMAL(12,2);		-- Variable para almacenar el valor de insoluto
	DECLARE Var_NumTransaccion		BIGINT(20);			-- Variable para almacenar el valor del numero de transaccion
	DECLARE Var_FrecuPago			INT(11);			-- Variable para almacenar el valor de la frecuencia de pago
	DECLARE Var_CAT         	 	DECIMAL(14,4);		-- Variable para almacenar el valor del CAT
	DECLARE Var_MontoCuota			DECIMAL(14,4);      -- corresponde con la cuota promedio a pagar
	DECLARE Var_FechaVen			DATE;  	            -- corresponde con la fecha final que genere el cotizador
	DECLARE Var_SolFondeoID			BIGINT(20);			-- Variable para almacenar el valor de solicitud de fondeo id
	DECLARE Var_FechaRegistro		DATE;				-- Variable para almacenar el valor de la fecha  de registro de  la solicitud de credito
	DECLARE Var_NombreCompleto		VARCHAR(500);		-- Nombre Completo o Razon Social del cliente

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE SalidaSI				CHAR(1);			-- Salida SI
	DECLARE Salida_NO				CHAR(1);			-- Salida NO
	DECLARE Fecha_Vacia     		DATE;				-- Fecha vacia
	DECLARE Est_CredVigente			CHAR(1);			-- Estatus del credito : Vigente
	DECLARE Estatus_Pagado 			CHAR(1);			-- Estatus pagado P
	DECLARE Es_DiaHabil         	CHAR(1);			-- Es dia habil
	DECLARE FechVencCred       		DATE;				-- Fecha vencimiento del creedito
	DECLARE Sol_Autoriza    		CHAR(1);			-- Estatus autorizado
	DECLARE Estatus_Autori  		CHAR(1);			-- Estatus cuenta Autorizada
	DECLARE Porcien_Cien    		DECIMAL(6,2);		-- Cien porciento
	DECLARE Mov_Bloqueo     		CHAR(1);			-- Movimiento de bloqueo
	DECLARE Pol_Automatica  		CHAR(1);			-- Poliza Automatica
	DECLARE ConcepSolFondeo 		INT(11);			-- COncepto de solicitud de fondeo
	DECLARE Descri_SolFon   		VARCHAR(100);		-- Descripcion de solicitud de fondeo
	DECLARE Fre_Semanal      		CHAR(1);			-- Frecuencia semanal
	DECLARE Fre_Catorce      		CHAR(1);			-- Frecuencia Catorcenal
	DECLARE Fre_Quince      		CHAR(1);			-- Frecuencia Quincenal
	DECLARE Fre_Mensual      		CHAR(1);			-- Frecuencia Mensual
	DECLARE NatCargo      			CHAR(1);			-- Naturalidad Movimiento de Cargo
	DECLARE Constante_No			CHAR(1);			-- Constante NO='N'
	DECLARE Estatus_Vigen   		CHAR(1);			-- Estatus vigente

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET SalidaSI					:= 'S';				-- Salida SI
	SET Salida_NO					:= 'N';				-- Salida NO
	SET Estatus_Pagado 				:= 'P';             -- Estatus de la Amortizacion: Pagada
	SET Fecha_Vacia    				:= '1900-01-01';	-- Fecha vacia
	SET Est_CredVigente				:= 'V';				-- Estatus del credito : Vigente
	SET Sol_Autoriza   				:= 'A';             -- Estatus de la Solicitud: Autorizada
	SET Estatus_Autori 			 	:= 'A';             -- Estatus de la Cuenta de Ahorro Vigente o Autorizada
	SET Porcien_Cien   				:= 100.0;           -- Porcentaje con Valor de Cien
	SET Mov_Bloqueo     			:= 'B';				-- Movimiento de bloqueo
	SET Pol_Automatica  			:= 'A';             -- Tipo de Alta de la Poliza Contable: Automatica
	SET ConcepSolFondeo 			:= 23;              -- Concepto Contable: Fondeo de Credito
	SET Fre_Semanal     			:= 'S';             -- Frecuencia de Pago: Semanal
	SET Fre_Catorce     			:= 'C';            	-- Frecuencia de Pago: Catorcenal
	SET Fre_Quince     				:= 'Q';             -- Frecuencia de Pago: Quincenal
	SET Fre_Mensual     			:= 'M'; 			-- Frecuencia de Pago: Mensual
	SET NatCargo					:= 'C';				-- Naturalidad de movimiento de cargo
	SET Constante_No				:= 'N';				-- Constante NO
	SET Estatus_Vigen   			:= 'N';				-- Estatus vigente

	SET Var_CadenaNO				:= 'N';				-- Cadena NO
	SET Var_TipoCte					:= 'CTE';			-- Tipo persona SAFI : Cliente
	SET Var_CadenaSi				:= 'S';				-- Cadena Si
	SET Var_TipFondeoSol			:= 'S';				-- Tipo de fondeo : Solicitud
	SET Var_TipFondeoCred			:= 'C';				-- Tipo de fondeo : Credito
	SET Var_TipoFondID 				:= 1;				-- Tipo fondeador
	SET Var_TipoBloqID  			:= 7;				-- Tipo de bloqueo
	SET Var_LlaveCRW				:= 'ActivoModCrowd'; 	-- Filtro para variable de modulo crowdfunding



	-- Asignacion de valores por defecto
	SET Par_SolicitudCreditoID		:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	SET Par_CreditoID				:= IFNULL(Par_CreditoID, Entero_Cero);
	SET Par_ClienteID				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaAhoID				:= IFNULL(Par_CuentaAhoID, Entero_Cero);
	SET Par_MontoFondeo				:= IFNULL(Par_MontoFondeo, Decimal_Cero);
	SET Par_TasaPasiva				:= IFNULL(Par_TasaPasiva, Decimal_Cero);
	SET Par_TipoFondeo				:= IFNULL(Par_TipoFondeo, Cadena_Vacia);
	SET Descri_SolFon   			:= 'SOLICITUD DE FONDEO DE CREDITO';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-CRWFONDEOSOLICITUDPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	-- Se obtiene el valor de la parametrizacion para fondeos de crowdfunding
	SELECT ValorParametro
	INTO  Var_CrwActivo
	FROM PARAMGENERALES WHERE LlaveParametro = Var_LlaveCRW;

	IF(Var_CrwActivo = Constante_No)THEN
		SET Par_NumErr := 021;
		SET Par_ErrMen := 'Para ejecutar el proceso, se requiere habilitar el modulo de crowdfunding';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;


	IF (Par_TipoFondeo NOT IN(Var_TipFondeoSol,Var_TipFondeoCred)) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'Especificar si el tipo de fondeo es por solicitud(S) o credito(C)';
		SET Var_Control := 'tipoFondeo';
		LEAVE ManejoErrores;
	END IF;

	IF (Par_TipoFondeo =  Var_TipFondeoSol AND Par_SolicitudCreditoID  = Entero_Cero ) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'Especificar un numero de solicitud de credito';
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (Par_TipoFondeo =  Var_TipFondeoCred AND Par_CreditoID  = Entero_Cero ) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'Especificar un numero de credito';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 012;
		SET Par_ErrMen := 'Especificar un numero de solicitud de credito.';
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ClienteID = Entero_Cero ) THEN
		SET Par_NumErr := 013;
		SET Par_ErrMen := 'Especificar un numero de cliente';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoFondeo, Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr := 014;
		SET Par_ErrMen := 'Especificar el monto de fondeo';
		SET Var_Control := 'montoFondeo';
		LEAVE ManejoErrores;
	END IF;

	IF (Par_TasaPasiva <= Entero_Cero ) THEN
        SET Par_NumErr := 021;
		SET Par_ErrMen := 'Especifique una tasa pasiva valida.';
		SET Var_Control := 'tasaFija';
		LEAVE ManejoErrores;
	END IF;


	-- Llamada al SP para consultar el saldo Disponible para aplicar el Bloqueo
	CALL SALDOSAHORROCON(Var_CliCuenta, Var_CueDispon, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);
	SET Var_CueEstatus  := IFNULL(Var_CueEstatus, Cadena_Vacia);

	IF(Var_CueEstatus = Cadena_Vacia)THEN
		SET Par_NumErr 			:= 015;
		SET Par_ErrMen 			:= 'La cuenta de ahorro no cuenta con estatus.';
		SET Var_Control 		:= 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_CueEstatus != Estatus_Autori) THEN
		SET Par_NumErr 			:= 017;
		SET Par_ErrMen 			:= 'La Cuenta de Ahorro debe ser Autorizada.';
		SET Var_Control 		:= 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_CueDispon < Par_MontoFondeo) THEN
		SET Par_NumErr 			:= 018;
		SET Par_ErrMen 			:= 'La Cuenta de Ahorro no Tiene Saldo Suficiente.';
		SET Var_Control 		:= 'saldoDispon';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_CliCuenta != Par_ClienteID ) THEN
		SET Par_NumErr 			:= 019;
		SET Par_ErrMen 			:= 'El numero de Cuenta no pertenece al Cliente Especificado.';
		SET Var_Control 		:= 'clienteID';
		LEAVE ManejoErrores;
	END IF;


	-- Parametros Generales de la Aplicacion
	SELECT  FechaSistema,   MonedaBaseID,   ClienteInstitucion
	INTO 	Var_FechaSis,   Var_MonedaBase, Var_ClienteInstit
	FROM PARAMETROSSIS;

	-- Se obtiene el fondeo de la institucion
	SELECT 	SolFondeoID
	INTO	Var_SolFondeoID
	FROM 	CRWFONDEOSOLICITUD
	WHERE 	SolicitudCreditoID = Par_SolicitudCreditoID
	AND ClienteID = Var_ClienteInstit;

	-- Validar si existe fondeo para la institucion con la solicitud de credito
	IF(IFNULL(Var_SolFondeoID, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr := 023;
		SET Par_ErrMen := 'No existe fondeos para la solicitud de credito de la institucion.';
		SET Var_Control := 'creditoID';
		LEAVE ManejoErrores;
	END IF;


	-- Obtenemos el credito para la solicitud de credito
	IF(Par_TipoFondeo = Var_TipFondeoSol) THEN

		SELECT 	CreditoID,		FechaRegistro
		INTO	Par_CreditoID,	Var_FechaRegistro
		FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		IF(IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 022;
			SET Par_ErrMen := 'Especfique una solicitud de credito con credito registrado.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		-- Se inserta el valor para el flujo de credito
		SET Par_TipoFondeo := Var_TipFondeoCred;
	END IF;

	SELECT TRIM(UPPER(PrimerNombre)),		TRIM(UPPER(SegundoNombre)),		TRIM(UPPER(TercerNombre)),		TRIM(UPPER(ApellidoPaterno)),
			TRIM(UPPER(ApellidoMaterno)),	TRIM(UPPER(RFCOficial)),		FechaNacimiento,				LugarNacimiento,
			EstadoID,						TipoPersona,					TRIM(UPPER(NombreCompleto))
	INTO 	Var_PrimerNombre,				Var_SegundoNombre,				Var_TercerNombre,				Var_ApellidoPaterno,
			Var_ApellidoMaterno,			Var_RFCOficial,					Var_FechaNacimiento,			Var_PaisID,
			Var_EstadoID,					Var_TipoPersona,				Var_NombreCompleto
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

	CALL PLDDETECCIONPRO(
		Par_ClienteID,			Var_PrimerNombre,		Var_SegundoNombre,	 	Var_TercerNombre,		Var_ApellidoPaterno,
		Var_ApellidoMaterno,	Var_TipoPersona,		Cadena_Vacia,			Var_RFCOficial,			Var_RFCOficial,
		Var_FechaNacimiento,	Entero_Cero,			Var_PaisID,				Var_EstadoID,			Var_NombreCompleto,
		Var_TipoCte,			Var_CadenaSi,			Var_CadenaSi,			Var_CadenaSi,			Var_CadenaNO,
		Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF (Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;


	IF (Par_TipoFondeo =  Var_TipFondeoCred) THEN

		SELECT	CreditoID
		INTO 	Var_CredFondeo
		FROM	CRWCREDITOFONDEO
		WHERE 	CreditoID = Par_CreditoID
		AND 	CreditoEnEjec = 'S';

		SET Var_CredFondeo := IFNULL(Var_CredFondeo, Entero_Cero);

		IF (Var_CredFondeo > Entero_Cero) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El credito esta en proceso de pago, intente mas tarde';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE		CRWCREDITOFONDEO CF
			SET		CF.SaldoFondeo		= CF.SaldoFondeo + Par_MontoFondeo,
					CF.FondeoEnEjec		= CF.FondeoEnEjec + 1
		WHERE 		CreditoID = Par_CreditoID;

		SELECT	Estatus,			(IFNULL(SaldoCapVigent,Decimal_Cero) + IFNULL(SaldoCapAtrasad,Decimal_Cero) +	IFNULL(SaldoCapVencido,Decimal_Cero) + IFNULL(SaldCapVenNoExi,Decimal_Cero)),
				ProductoCreditoID
		INTO 	Var_EstCredito, 	Var_SaldoInsoluto,
				Var_ProductCredID
		FROM  CREDITOS
		WHERE CreditoID =  Par_CreditoID;

		SET Var_EstCredito := IFNULL(Var_EstCredito,Cadena_Vacia);
		SET Var_SaldoInsoluto := IFNULL(Var_SaldoInsoluto,Decimal_Cero);
		SET Var_ProductCredID := IFNULL(Var_ProductCredID,Entero_Cero);

		IF (Var_EstCredito != Est_CredVigente) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'Especificar un credito vigente';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	MinPorcFonProp, 	MaxPorcPagCre,  	MaxDiasAtraso,  	DiasGraciaPrimVen,	TasaISR,
				FormulaRetencion,	MargenPagos
		INTO	Var_MinPorFon,  	Var_MaxPorPag,  	Var_MaxDiasAtr, 	Var_DiasGraVen,		Var_TasaISR,
				Var_FormReten,		Var_MargenPagos
		FROM PARAMETROSCRW
		WHERE ProductoCreditoID =  Var_ProductCredID;

		IF(IFNULL(Var_FormReten, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 021;
			SET Par_ErrMen := 'El producto de credito no cuenta con soporte para fondeo.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		-- Dias de atraso de un credito
		SELECT DiasAtraso
		INTO Var_DiasAtraAct
		FROM SALDOSCREDITOS
		WHERE CreditoID = Par_CreditoID
		ORDER BY FechaCorte DESC
		LIMIT 1;

		SET Var_DiasAtraAct	:= IFNULL(Var_DiasAtraAct, Entero_Cero);

		IF Var_DiasAtraAct > Var_MaxDiasAtr THEN

			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El Credito presenta un numero de dias de Atraso mayor al Permitido.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT  IFNULL(MIN(FechaExigible), Fecha_Vacia) INTO Var_FecSigVenc
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Par_CreditoID
          AND Amo.Estatus != Estatus_Pagado
          AND Amo.FechaExigible >= Var_FechaSis;

		CALL DIASFESTIVOSCAL(
			Var_FechaSis,   Var_DiasGraVen,     Var_SigFecGra,      Es_DiaHabil,    Aud_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion);

		 IF (Var_SigFecGra > Var_FecSigVenc AND Var_FecSigVenc != Fecha_Vacia) THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'El siguiente Vencimiento del Credito esta muy proximo de acuerdo a lo Establecido.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		 SELECT Cre.MontoCredito,		Cre.SolicitudCreditoID,		Cre.FechaVencimien,		Cre.NumAmortizacion,		Cre.FrecuenciaCap,
				Cre.DiaPagoCapital,		Cre.DiaMesCapital,			Cre.ProductoCreditoID,	Cre.FechaInhabil,			Cre.AjusFecUlVenAmo,
				Cre.AjusFecExiVen,      Cre.TasaFija,				(IFNULL(SaldoCapVigent, Decimal_Cero)  +	IFNULL(SaldoCapAtrasad, Decimal_Cero)   + 	IFNULL(SaldoCapVencido, Decimal_Cero)   +
                IFNULL(SaldCapVenNoExi, Decimal_Cero)   ),			Cre.MonedaID
		INTO
				Var_MontoCred,			Par_SolicitudCreditoID,		FechVencCred,			Var_NumAmorti,				Var_FrecuenCap,
				Var_DiaPagoCap,			Var_DiaMesCap,      		Var_ProdCreID,      	Var_FechaInhabil,			Var_AjFecUlVenAmo,
				Var_AjFecExiVen,    	Var_TasaActiva,				Var_SaldoCre,			Var_MonedaID
		FROM CREDITOS Cre,
			PRODUCTOSCREDITO Pro
		WHERE Cre.CreditoID = Par_CreditoID
		AND Cre.ProductoCreditoID	= Pro.ProducCreditoID;


		SET Par_SolicitudCreditoID := IFNULL(Par_SolicitudCreditoID, Entero_Cero);
		SET Var_MontoSolici := Var_MontoCred;

		  -- Obtenemos los Montos de Fondeo Propio y Porcentajes actuales
		SELECT SUM(IFNULL(SaldoCapVigente, 0) + IFNULL(SaldoCapExigible,0))
			INTO Var_MontoFondea
			FROM CRWFONDEO Fon
			WHERE CreditoID = Par_CreditoID
			AND Estatus IN ('N', 'V');

		SET Var_MontoFondea := IFNULL(Var_MontoFondea, Entero_Cero);
		SET Var_PorFonAct   := IFNULL(Var_PorFonAct, Entero_Cero);

		IF(Var_MontoFondea >  Var_SaldoInsoluto) THEN
			SET Var_DisponFondeo = Entero_Cero;
		ELSE
			SET Var_DisponFondeo := Var_SaldoInsoluto - Var_MontoFondea - ROUND(Var_SaldoInsoluto * Var_MinPorFon, 2);
		END IF;

		-- Valida que el Monto de la Solicitud de Fondeo no sea mayor al Monto de Fondeo Propio
		IF (Par_MontoFondeo > Var_DisponFondeo ) THEN

			SET Par_NumErr 			:= 007;
			SET Par_ErrMen 			:= 'El monto del Fondeo es mayor al Monto Disponible para ser Fondeado.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
		END IF;

		-- Calculamos el Porcentaje de Fondeo
		SET Var_PorceFondeo := ROUND(Par_MontoFondeo / Var_SaldoInsoluto * 100, 6);


		-- Calculamos el porcentaje actual de lo Ya pagado
		-- Se calcula solo para tipo de fondeo credito
		SET Var_PorActPago = ROUND((Var_MontoCred - Var_SaldoCre) / Var_MontoCred * Porcien_Cien, 2);

		IF(Var_PorActPago > Var_MaxPorPag)  THEN
			SET Par_NumErr 			:= 020;
			SET Par_ErrMen 			:= 'El Credito presenta un Avance en los Pagos mayor a lo Establecido por la Inst.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
		END IF;

		SET	Var_GAT			:= 0.0;
		SET Var_GATReal		:= 0.0;

		-- Alta de la Solicitud de Fondeo
		-- INFO: TasaFija = TasaActiva
		CALL CRWFONDEOSOLICITUDALT(
			Par_SolicitudCreditoID,	Par_ClienteID,		Par_CuentaAhoID,			Var_ProductCredID,		Var_FechaSis,
			Par_MontoFondeo,		Var_PorceFondeo,	Var_MonedaID,				Var_TasaActiva,			Par_TasaPasiva,
			Var_TipoFondID,			Par_TipoFondeo,		Salida_NO,					Par_NumErr,				Par_ErrMen,
			Var_NumSolFond,			Var_GAT,			Var_GATReal,				Aud_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
			);
		-- Validacion de registro de fondeo
		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


			 -- Alta del Maestro de la Poliza Contable
		CALL MAESTROPOLIZASALT(
			Var_Poliza,      	 Aud_EmpresaID,      Var_FechaSis,       Pol_Automatica, ConcepSolFondeo,
			Descri_SolFon,    	 Salida_NO,      	 Par_NumErr,     	 Par_ErrMen,   	 Aud_Usuario,
			Aud_FechaActual, 	 Aud_DireccionIP, 	 Aud_ProgramaID, 	 Aud_Sucursal, 	 Aud_NumTransaccion);


		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Calculamos el Numero de Retiros en el Mes usado en la Contabilidad
		IF(Var_FrecuenCap = Fre_Semanal) THEN
			SET Var_NumRetMes	:= 4;
		ELSEIF(Var_FrecuenCap = Fre_Catorce) THEN
			SET Var_NumRetMes	:= 2;
		ELSEIF(Var_FrecuenCap = Fre_Quince) THEN
			SET Var_NumRetMes	:= 2;
		ELSEIF(Var_FrecuenCap = Fre_Mensual) THEN
			SET Var_NumRetMes	:= 1;
		ELSE
			SET Var_NumRetMes	:= 1;
		END IF;

		-- Contabilidad y Calculo de las Amortizaciones Pasivas del Inversionista
		CALL CRWFONDEOPRO(
			Par_SolicitudCreditoID,  Par_CreditoID,  	 Var_FechaSis, 	 		 Var_FechaSis, 	 		 Var_FechaSis,
			FechVencCred, 	 		 Var_NumAmorti,  	 Var_FrecuenCap,     	 Var_NumRetMes,       	 Var_DiaPagoCap,
			Var_DiaMesCap,        	 Var_Poliza,     	 Var_ProdCreID,  	 	 Var_FechaInhabil,    	 Var_AjFecUlVenAmo,
			Var_AjFecExiVen,      	 Var_TipFondeoCred,  Salida_NO,          	 Par_NumErr,        	 Par_ErrMen,
			Var_Consecutivo,		 Aud_EmpresaID,  	 Aud_Usuario,        	 Aud_FechaActual,     	 Aud_DireccionIP,
			Aud_ProgramaID,       	 Aud_Sucursal,   	 Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Revision de Cuadre de la Transaccion
		SELECT SUM(Cargos), SUM(Abonos) INTO Var_PolCargos, Var_PolAbonos
			FROM DETALLEPOLIZA Pol
			WHERE Pol.PolizaID = Var_Poliza
				AND Pol.Fecha = Var_FechaSis
				AND Pol.NumTransaccion = Aud_NumTransaccion;

		SET Var_PolCargos := IFNULL(Var_PolCargos, Entero_Cero);
		SET Var_PolAbonos := IFNULL(Var_PolAbonos, Entero_Cero);

		IF( (Var_PolCargos =  Entero_Cero) OR (Var_PolAbonos = Entero_Cero)) THEN
			SET Par_NumErr 			:= 500;
			SET Par_ErrMen 			:= 'La inversion no se pudo completar. Intentalo de nuevo.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
		END IF;

		SELECT SUM(CantidadMov) INTO Var_CargosOpe
			FROM CUENTASAHOMOV Mov
			WHERE Mov.CuentaAhoID = Par_CuentaAhoID
			AND Mov.Fecha = Var_FechaSis
			AND Mov.NumeroMov = Aud_NumTransaccion
			AND Mov.NatMovimiento = NatCargo;

		SET Var_CargosOpe := IFNULL(Var_CargosOpe, Entero_Cero);

		IF( Var_CargosOpe != Var_PolCargos) THEN
			SET Par_NumErr 			:= 501;
			SET Par_ErrMen 			:= 'La inversion no se pudo completar. Intentalo de nuevo.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
		END IF;

		-- Si la Institucion Tenia un Monto Fondeado
		-- Actualizamos la Posicion de Fondeo de la Propia Institucion
		IF (Var_MontoFondea > Entero_Cero) THEN

			UPDATE CRWFONDEOSOLICITUD SET
				MontoFondeo         = MontoFondeo - Par_MontoFondeo,
				PorcentajeFondeo    = PorcentajeFondeo - Var_PorceFondeo,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND ClienteID = Var_ClienteInstit;
		END IF;

		SELECT		Gat,  		ValorGatReal, 		SolFondeoID
		INTO		Var_GAT,	Var_GATReal,		Var_FondeoID
		FROM 	CRWFONDEO
		WHERE NumTransaccion =	Aud_NumTransaccion LIMIT 1;

	END IF;
	-- Fin fondeo creditos

	-- Fondeo por solicitud
	IF (Par_TipoFondeo = Var_TipFondeoSol) THEN

		-- INFO:Tasa Fija = Tasa Activa
		SELECT  Sol.FrecuenciaCap,		Sol.NumAmortizacion,			Sol.ProductoCreditoID,		Sol.ClienteID,			Sol.ProspectoID,
				Sol.CreditoID,     		Sol.Estatus,					Sol.TasaFija,				Sol.MontoAutorizado,	Sol.DiaPagoCapital,
				Sol.DiaMesCapital,		Sol.FechaInhabil,				Sol.AjusFecUlVenAmo,		Sol.AjusFecExiVen,		Sol.MonedaID,
				Cre.Dias,				Sol.FechaInicio,				Sol.MontoPorComAper,		Pro.CobraSeguroCuota,	Pro.CobraIVASeguroCuota,
				Sol.MontoSeguroCuota

		INTO	Var_FrecuenCap,    		Var_NumAmorti,  				Var_ProdCreID,				Var_ClienteID,			Var_ProspectoID,
				Var_CredSol,    		Var_EstaSol,    				Var_TasaActiva,				Var_MontoSolici,		Var_DiaPagoCap,
				Var_DiaMesCap,			Var_FechaInhabil,				Var_AjFecUlVenAmo,			Var_AjFecExiVen,		Var_MonedaID,
				Var_DiasInversion,		Var_FechaInicio,				Var_MontoPorComAper,		Var_CobraSeguroCuota,	Var_CobraIVASegCuota,
				Var_MontoSeguroCuota
		FROM SOLICITUDCREDITO Sol
		INNER JOIN CREDITOSPLAZOS Cre ON Cre.PlazoID = Sol.PlazoID
		INNER JOIN PRODUCTOSCREDITO	Pro ON Pro.ProducCreditoID = Sol.ProductoCreditoID
		WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


		SET Var_ProdCreID   := IFNULL(Var_ProdCreID, Entero_Cero);
		SET Var_CredSol     := IFNULL(Var_CredSol, Entero_Cero);

		 IF (Var_ProdCreID = Entero_Cero) THEN
			SET Par_NumErr 			:= 008;
			SET Par_ErrMen 			:= 'El numero de producto de credito de la solicitud no Existe.';
			SET Var_Control 		:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_CredSol != Entero_Cero) THEN
			SET Par_NumErr 			:= 009;
			SET Par_ErrMen 			:= 'La Solicitud ya tiene Credito, Especificar el Credito en lugar de la Solicitud.';
			SET Var_Control 		:= 'SolicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	MinPorcFonProp, 	MaxPorcPagCre,  	MaxDiasAtraso,  	DiasGraciaPrimVen,	TasaISR,
				FormulaRetencion,	MargenPagos
		INTO	Var_MinPorFon,  	Var_MaxPorPag,  	Var_MaxDiasAtr, 	Var_DiasGraVen,		Var_TasaISR,
				Var_FormReten,		Var_MargenPagos
			FROM PARAMETROSCRW
		WHERE ProductoCreditoID =  Var_ProdCreID;

		SET Var_MontoCred = Par_MontoFondeo;

		IF(IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
			SET Var_CliPros := IFNULL(Var_ProspectoID,Entero_Cero);
		ELSE
			SET Var_CliPros := IFNULL(Var_ClienteID,Entero_Cero);
		END IF;

		-- Se asignan valores que no se obtienen de la solicitud de credito
		SET Var_DiaPagoCap		:= IFNULL( Var_DiaPagoCap, 'A');		-- aniversario
		SET Var_DiaMesCap		:= IFNULL( Var_DiaMesCap, DAY(Var_FechaSis));
		SET Var_FechaInhabil	:= IFNULL( Var_FechaInhabil, 'S');
		SET Var_AjFecUlVenAmo	:= IFNULL( Var_AjFecUlVenAmo, 'S');
		SET Var_AjFecExiVen		:= IFNULL( Var_AjFecExiVen, 'N');

		-- Obtenemos los Montos de fondeo y Porcentajes actuales
		-- (En el porcentaje de Fondeo excluimos a la Institucion)
		SELECT SUM(MontoFondeo),
			SUM(CASE WHEN (ClienteID = Var_ClienteInstit) THEN
					Entero_Cero
				ELSE
					PorcentajeFondeo
				END) INTO
				Var_MontoFondea, Var_PorFonAct
			FROM CRWFONDEOSOLICITUD
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
			AND Estatus = Estatus_Vigen;

		SET Var_MontoFondea := IFNULL(Var_MontoFondea, Entero_Cero);
		SET Var_PorFonAct   := IFNULL(Var_PorFonAct, Entero_Cero);

		 -- Si es la propia institucion la que esta Fondeando no tomamos en cuenta el minimo de Fondeo
		IF (Par_ClienteID = Var_ClienteInstit) THEN
			SET Var_MinPorFon   := Entero_Cero;
		END IF;

		-- Si el monto de Fondeo Excede el Monto de la Solicitud de Credito
		IF (Par_MontoFondeo > Var_MontoSolici) THEN
			SET Par_NumErr 			:= 016;
			SET Par_ErrMen 			:= 'La Solicitud de Credito no esta Autorizada.';
			SET Var_Control 		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		 -- Si el monto de Fondeo Actual + el Nuevo Fondeo Excede el Monto de la Solicitud de Credito
		IF ((Var_MontoFondea + Par_MontoFondeo) > Var_MontoSolici ) THEN


			SET Par_NumErr 			:= 010;
			SET Par_ErrMen 			:= 'El monto del Fondeo es mayor al solicitado.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
		END IF;

		 --  Validamos el Estatus de la Solicitud
		IF ( Var_EstaSol != Sol_Autoriza) THEN

			SET Par_NumErr 			:= 011;
			SET Par_ErrMen 			:= 'La Solicitud de Credito no esta Autorizada.';
			SET Var_Control 		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;


		SELECT  Descripcion INTO Var_DescripBlo
		    FROM TIPOSBLOQUEOS
		    WHERE TiposBloqID   = Var_TipoBloqID;

		-- Calculamos el Porcentaje de Fondeo
		SET Var_PorceFondeo := ROUND(Par_MontoFondeo / Var_MontoSolici * 100, 6);
		SET	Var_GAT			:= 0.0;
		SET Var_GATReal		:= 0.0;

		CALL CRWFONDEOSOLICITUDALT(
			Par_SolicitudCreditoID,		Par_ClienteID,		Par_CuentaAhoID,			Var_ProdCreID,		Var_FechaSis,
			Par_MontoFondeo,			Var_PorceFondeo,	Var_MonedaID,				Var_TasaActiva,			Par_TasaPasiva,
			Var_TipoFondID,				Par_TipoFondeo,		Salida_NO,					Par_NumErr,				Par_ErrMen,
			Var_NumSolFon,				Var_GAT,			Var_GATReal,				Aud_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
			);
		-- Validacion de registro de fondeo
		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		-- Solo por solicitud

		-- Cotizar el Calendario de Pagos
		CALL CREPAGCRECAMORPRO(
			Entero_Cero,			Par_MontoFondeo,		Var_TasaActiva,					Var_DiasInversion,			Var_FrecuenCap,
			Var_DiaPagoCap,			DAY(Var_FechaSis),		Var_FechaInicio,				Var_NumAmorti,				Var_ProdCreID,
			Var_CliPros,			Var_FechaInhabil,		Var_AjFecUlVenAmo,				Var_AjFecExiVen,			Var_MontoPorComAper,
			Decimal_Cero,			Var_CobraSeguroCuota,	Var_CobraIVASegCuota,			Var_MontoSeguroCuota,		Decimal_Cero,
			Salida_NO,				Par_NumErr,				Par_ErrMen,						Var_NumTranSimulador,		Var_Cuotas,
			Var_CAT,				Var_MontoCuota,			Var_FechaVen,					Aud_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_GAT := Var_CAT;
		-- Calculo del GAT REAL tomando como parametro el GAT Nominal
		SET Var_GATReal := FUNCIONCALCGATREAL(Var_GAT,(SELECT InflacionProy AS ValorGatHis
														FROM INFLACIONACTUAL
														ORDER BY FechaActualizacion DESC LIMIT 1));

		UPDATE CRWFONDEOSOLICITUD SET
			Gat				= Var_GAT,
			ValorGatReal	= Var_GATReal
		WHERE SolFondeoID 	= Var_NumSolFon;

		IF (Par_ClienteID != Var_ClienteInstit) THEN
			-- la referencia del movimiento del bloqueo es el ID de  la tabla FONDEOSOLICITUD . Var_NumSolFon
			CALL BLOQUEOSPRO(
				Entero_Cero,		Mov_Bloqueo,		Par_CuentaAhoID,		Var_FechaSis,		Par_MontoFondeo,
				Fecha_Vacia,		Var_TipoBloqID,		Var_DescripBlo,			Var_NumSolFon, 		Cadena_Vacia,
				Cadena_Vacia,		Salida_NO,          Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion  );


			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

	END IF;	-- Fin tipo solicitud

	SET Var_NumAmortiCero := Entero_Cero;

	-- Verificamos Inconsistencias en el plan de Amortizaciones
	SELECT  COUNT(Tmp_Consecutivo) INTO Var_NumAmortiCero
	    FROM CRWTMPPAGAMORSIM Tmp
	    WHERE Tmp.NumTransaccion = Aud_NumTransaccion
		  AND (Tmp_Capital = Entero_Cero
		   OR Tmp_Interes = Entero_Cero );

	SET Var_NumAmortiCero := IFNULL(Var_NumAmortiCero, Entero_Cero);

	IF (Var_NumAmortiCero > Entero_Cero) THEN
		SET Par_NumErr 			:= 020;
		SET Par_ErrMen 			:= 'El crédito está fondeado por completo por el momento, por favor elige otro.';
		SET Var_Control 		:= 'montoFondeo';
		LEAVE ManejoErrores;
	ELSE
		-- Validamos que la Primer Cuota de Inversion vs la Ultima Cuota no sean demasiado grandes
		-- De acuerdo a lo parametrizado
		SELECT  MIN(Tmp_Consecutivo), MAX(Tmp_Consecutivo) INTO Var_PrimAmorti, Var_UltimaAmorti
			FROM CRWTMPPAGAMORSIM Tmp
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion;

		SET Var_PrimAmorti		:= IFNULL(Var_PrimAmorti, Entero_Cero);
		SET Var_UltimaAmorti	:= IFNULL(Var_UltimaAmorti, Entero_Cero);

		SELECT  Tmp.Tmp_Capital INTO Var_CapPrimAmor
			FROM CRWTMPPAGAMORSIM Tmp
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			  AND Tmp.Tmp_Consecutivo = Var_PrimAmorti;

		SELECT  Tmp.Tmp_Capital INTO Var_CapUltAmorti
			FROM CRWTMPPAGAMORSIM Tmp
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			  AND Tmp.Tmp_Consecutivo = Var_UltimaAmorti;

		SET Var_CapPrimAmor		:= IFNULL(Var_CapPrimAmor, Entero_Cero);
		SET Var_CapUltAmorti	:= IFNULL(Var_CapUltAmorti, Entero_Cero);

		SET Var_DifAmorti = abs(Var_CapUltAmorti - Var_CapPrimAmor);

		IF(Var_DifAmorti > ROUND(Var_CapPrimAmor * Var_MargenPagos, 2)) THEN

			-- Verificamos si no es una Cuenta de un Cliente o Persona Excenta
			SELECT Mar.CuentaAhoID INTO Var_CuentaExcenta
				FROM CRWCTAEXCEMARGENPAGOS Mar
				WHERE Mar.CuentaAhoID = Par_CuentaAhoID;

			SET Var_CuentaExcenta := IFNULL(Var_CuentaExcenta, Entero_Cero);

			IF (Var_CuentaExcenta = Entero_Cero) THEN
				SET Par_NumErr 			:= 020;
				SET Par_ErrMen 			:= 'No se puede Realizar la Inversion, la Diferencia en el Simulador entre la 1er Cuota y la Ultima es muy grande.';
				SET Var_Control 		:= 'montoFondeo';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		UPDATE 		CRWAMORTICREFONDEO  AO
		INNER JOIN 	CRWFONDEO FK
				ON	AO.CreditoID = FK.CreditoID
		INNER JOIN	AMORTICRWFONDEO AF
				ON 	FK.SolFondeoID 	= AF.SolFondeoID
				AND	AO.FechaVencimiento = AF.FechaVencimiento
			SET		AO.SaldoFondeo		= AO.SaldoFondeo + IFNULL((AF.SaldoCapVigente + AF.SaldoCapExigible), Decimal_Cero),
					AO.NumFondeos		= AO.NumFondeos + 1
		WHERE 		AO.CreditoID 		= Par_CreditoID
			AND 	FK.SolFondeoID	 	= Var_FondeoID;

		UPDATE		CRWCREDITOFONDEO CF
		SET			CF.FondeoEnEjec		= CF.FondeoEnEjec - 1
		WHERE 		CreditoID 			= Par_CreditoID;

		SET Var_GAT				:= IFNULL(Var_GAT,Decimal_Cero);
		SET Var_GATReal			:= IFNULL(Var_GATReal,Decimal_Cero);
		SET Var_Consecutivo		:= IFNULL(Var_Consecutivo, Entero_Cero);
		SET Var_CAT				:= IFNULL(Var_CAT, Decimal_Cero);
		SET Var_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Fondeo registrado correctamente: ',CAST(Var_Consecutivo AS CHAR) );
		SET Var_Control		:= 'montoFondeo';
		SET Var_Consecutivo	:= Var_Consecutivo;

	END IF;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr, 		Par_ErrMen AS ErrMen,						Var_Control AS Control,			Var_Consecutivo AS Consecutivo,			Var_GAT AS GAT,
				Var_GATReal AS GATReal,		Var_NumTransaccion AS NumTransaccion;

	END IF;

END TerminaStore$$
