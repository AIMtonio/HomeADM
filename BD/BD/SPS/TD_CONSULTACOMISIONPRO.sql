-- TD_CONSULTACOMISIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_CONSULTACOMISIONPRO`;

DELIMITER $$
CREATE PROCEDURE `TD_CONSULTACOMISIONPRO`(
	-- Store Procedure de Consulta con Comision por ATM Para tarjetas de debito por medio de Web Service
	-- Tarjetas de Debito --> Web Service
	Par_NumberTransaction			CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator				CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode					CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Debito
	Par_TransactionAmount			DECIMAL(12,2),	-- Monto en pesos de la transaccion

	Par_CashbackAmount				DECIMAL(12,2),	-- Montos de CashBack
	Par_AdditionalAmount			DECIMAL(12,2),	-- Montos de Comisiones
	Par_SurchargeAmounts			DECIMAL(12,2),	-- Monto de Recargos, para retiros de Efectivo
	Par_TransactionDate				DATETIME,		-- Fecha y Hora de la operacion
	Par_MerchantType				CHAR(4),		-- Giro del comercio valores aceptados(Catalogo)

	Par_Reference					CHAR(12),		-- Referencia de la operacion
	Par_TerminalID					CHAR(16),		-- ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))
	Par_TerminalName				CHAR(50),		-- Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))
	Par_TerminalLocation			CHAR(50),		-- Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))
	Par_AuthorizationNumber			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(PROSA))

	Par_DraftCapture 				CHAR(1),		-- Indicador de Captura de la transaccion
	Par_CodigoTransaccionID			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(SAFI))
	Par_MonedaID					INT(11),		-- Codigo de Moneda
	Par_TarDebMovID					INT(11),		-- ID del movimiento de tarjeta

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),
	INOUT Par_NumCodigoErr			INT(11),

	Par_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaAplicacion		DATE;				-- Fecha de Aplicacion de la operacion(Fecha de sistema)
	DECLARE Var_BloquearATM			CHAR(1);			-- Valor bloqueo: ATM
	DECLARE Var_EstatusCtaAho		CHAR(1);			-- Estatus de la cta; A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada
	DECLARE Var_TarjetaDebID		CHAR(16);			-- Numero de Tarjeta de debito

	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal de cliente
	DECLARE Var_ClienteID			INT(11);			-- Valor del numero de cliente
	DECLARE Var_TarDebMovID			INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
	DECLARE Var_NoDispoDiario		INT(11);			-- Numero de Disposiciones al Dia
	DECLARE Var_LimiteDisponDiario	INT(11);			-- Limite de Disposiciones al

	DECLARE Var_CuentaAhoID			INT(20);			-- Identificador de la Cuenta de Ahorro
	DECLARE Var_PolizaID			BIGINT(20);			-- ID de Poliza Contable
	DECLARE Var_Consecutivo			BIGINT(20);			-- ID de Consecutivo
	DECLARE Var_Referencia			VARCHAR(50);		-- Valor del numero de tarjeta
	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla

	DECLARE Var_DesPoliza			VARCHAR(150);		-- Descripcion por compra con tarjeta
	DECLARE Var_MontoDisponible		DECIMAL(12,2);		-- Monto Disponible de la Cuenta
	DECLARE Var_MontoDispuestoLibre	DECIMAL(12,2);		-- Monto Dispuesto libre, usado para la validar la operacion
	DECLARE Var_MontoDispuesto		DECIMAL(12,2);		-- Monto Dispuesto al mes

	DECLARE Var_LimiteDispuestoMes		DECIMAL(12,2);	-- Monto Limite de limite de compras al mes
	DECLARE Var_MontoDispuestoDiario	DECIMAL(12,2);	-- Monto Dispuesto Diario
	DECLARE Var_LimiteDispuestoDiario	DECIMAL(12,2);	-- Monto Limite de Compra Diario
	DECLARE Var_TotalCompra				DECIMAL(16,2);	-- Total de Compra

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Salida_NO				CHAR(1);			-- Constante Salida SI
	DECLARE Salida_SI				CHAR(1);			-- Constante Salida NO
	DECLARE Con_NO					CHAR(1);			-- Constante SI

	DECLARE Con_SI					CHAR(1);			-- Constante NO
	DECLARE Alta_Enc_Pol_NO			CHAR(1);			-- Constante Alta Encabezado Poliza NO
	DECLARE Alta_Enc_Pol_SI			CHAR(1);			-- Constante Alta Encabezado Poliza SI

	DECLARE AltaMovDeb_SI			CHAR(1);			-- Constante Alta Movimiento SI
	DECLARE AltaPolDeb_SI			CHAR(1);			-- Constante Alta Poliza Cuenta Ahorro SI
	DECLARE AltaMovBitacoraNO		CHAR(1);			-- Constante Alta Movimiento Bitacora NO

	DECLARE AltaMovBitacoraSI		CHAR(1);			-- Constante Alta Movimiento Bitacora SI
	DECLARE Nat_Cargo				CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Est_Activa				CHAR(1);			-- Constante Estatus Activa de la Cuenta de Ahorro en la Tarjeta
	DECLARE BloqATM_SI				CHAR(1);			-- Constante Bloqueo ATM SI

	DECLARE BloqATM_NO				CHAR(1);			-- Constante Bloqueo ATM NO
	DECLARE Prod_ATM 				CHAR(2);			-- Constante Indicador de Producto 01 - ATM
	DECLARE Code_Consulta			CHAR(2);			-- Constante 31 ISO= Consulta de Saldos (Corresponsales Bancarios)
	DECLARE Con_SubClasificacion	CHAR(3);			-- Constante Subclasificacion de Producto
	DECLARE Con_GiroATM				CHAR(4);			-- Constante Giro Generico ATM

	DECLARE Entero_MenosUno			INT(11);			-- Constante Entero Menos Uno
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno
	DECLARE Con_BloqATM				INT(11);			-- Constante de Consulta para obtener si se bloquea ATM
	DECLARE Con_OperacATM			INT(11);			-- Constante Concepto operacion: ATM

	DECLARE Con_DispoDiario			INT(11);			-- Constante de Consulta para obtener el limite de monto diario para disposicion
	DECLARE Con_DispoMes			INT(11);			-- Constante de Consulta para obtener el limite de monto mensual para disposicion
	DECLARE Con_TarjetaActiva		INT(11);			-- Constante Estatus Activo de Tarjetas
	DECLARE LongitudTarjeta			INT(11);			-- Constante Longitud Tarjeta
	DECLARE Mov_ComisionDisp		INT(11);			-- Constante Movimiento de Disposicion de Comision

	DECLARE ConConta_TarDeb			INT(11);			-- Constante Contable Tarjeta de Debito
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero
	DECLARE FechaHora_Vacia			DATETIME;			-- Constante Fecha Hora Vacia

	-- Declaracion de Actualizaciones
	DECLARE Act_Procesado			INT(11);			-- Constante Actualiza a Estatus Procesado el Registro de Bitacora
	DECLARE Act_MovRetiro			INT(11);			-- Constante Actualiza Movimiento Retiro
	DECLARE Act_MovConsulta			INT(11);			-- Constante Actualiza Movimiento Consulta ATM

	-- Declaracion de Operaciones
	DECLARE Con_OpeDisposicion	INT(11);	-- Consulta para obtener Numero de Disposiciones al Dia

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Con_NO					:= 'N';

	SET Con_SI					:= 'S';
	SET Alta_Enc_Pol_NO			:= 'N';
	SET Alta_Enc_Pol_SI			:= 'S';
	
	SET AltaMovDeb_SI			:= 'S';
	SET AltaPolDeb_SI			:= 'S';
	SET AltaMovBitacoraNO		:= 'N';

	SET AltaMovBitacoraSI		:= 'S';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET Est_Activa				:= 'A';
	SET BloqATM_SI				:= 'S';

	SET BloqATM_NO				:= 'N';
	SET Prod_ATM				:= '01';
	SET Code_Consulta			:= '31';
	SET Con_SubClasificacion	:= '201';
	SET Con_GiroATM				:= '0000';

	SET Entero_MenosUno			:= -1;
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Con_BloqATM				:= 1;
	SET Con_OperacATM			:= 1;

	SET Con_DispoDiario			:= 1;
	SET Con_DispoMes			:= 2;
	SET Con_TarjetaActiva		:= 7;
	SET LongitudTarjeta			:= 16;
	SET Mov_ComisionDisp		:= 53;

	SET ConConta_TarDeb			:= 86;
	SET Decimal_Cero			:= 0.00;
	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

	-- Asignacion de Actualizaciones
	SET Act_Procesado			:= 1;
	SET Act_MovRetiro			:= 2;
	SET Act_MovConsulta			:= 3;

	-- Asignacion de Operaciones
	SET Con_OpeDisposicion		:= 2;


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_NumCodigoErr = 12;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 				'esto le ocasiona. Ref: SP-TD_CONSULTACOMISIONPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Valores Default para los Parametros de Entrada
		SET Par_NumberTransaction	:= IFNULL(Par_NumberTransaction, Cadena_Vacia);
		SET Par_ProdIndicator		:= IFNULL(Par_ProdIndicator, Cadena_Vacia);
		SET Par_TranCode			:= IFNULL(Par_TranCode, Cadena_Vacia);
		SET Par_CardNumber			:= IFNULL(Par_CardNumber, Cadena_Vacia);
		SET Par_TransactionAmount	:= IFNULL(Par_TransactionAmount, Decimal_Cero);

		SET Par_CashbackAmount		:= IFNULL(Par_CashbackAmount, Decimal_Cero);
		SET Par_AdditionalAmount	:= IFNULL(Par_AdditionalAmount, Decimal_Cero);
		SET Par_SurchargeAmounts	:= IFNULL(Par_SurchargeAmounts, Decimal_Cero);
		SET Par_TransactionDate		:= IFNULL(Par_TransactionDate, NOW());
		SET Par_MerchantType		:= IFNULL(Par_MerchantType, Cadena_Vacia);

		SET Par_Reference			:= IFNULL(Par_Reference, Cadena_Vacia);
		SET Par_TerminalID			:= IFNULL(Par_TerminalID, Cadena_Vacia);
		SET Par_TerminalName		:= IFNULL(Par_TerminalName, Cadena_Vacia);
		SET Par_TerminalLocation	:= IFNULL(Par_TerminalLocation, Cadena_Vacia);
		SET Par_AuthorizationNumber	:= IFNULL(Par_AuthorizationNumber, Cadena_Vacia);

		SET Par_DraftCapture		:= IFNULL(Par_DraftCapture, Cadena_Vacia);
		SET Par_CodigoTransaccionID	:= IFNULL(Par_CodigoTransaccionID, Cadena_Vacia);
		SET Par_MonedaID			:= IFNULL(Par_MonedaID, Entero_Uno);
		SET Par_TarDebMovID		:= IFNULL(Par_TarDebMovID, Entero_Cero);

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Aud_FechaActual 		:= NOW();

		SELECT 	CuentaAhoID,		ClienteID,		TarjetaDebID,			Estatus,
				IFNULL(TD_FUNCIONLIMITEBLOQ(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_BloqATM), Cadena_Vacia),
				IFNULL(Tar.MontoDispoDiario, Decimal_Cero ),
				IFNULL(TD_FUNCIONLIMITEMONTO(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_DispoDiario), Decimal_Cero),
				IFNULL(Tar.MontoDispoMes, Decimal_Cero),
				IFNULL(TD_FUNCIONLIMITEMONTO(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_DispoMes), Decimal_Cero),
				IFNULL(Tar.NoDispoDiario, Entero_Cero),
				IFNULL(TD_FNNUMCONSULTAS(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_OpeDisposicion), Entero_Cero)
		INTO 	Var_CuentaAhoID,	Var_ClienteID,	Var_TarjetaDebID,		Var_EstatusTarjeta,
				Var_BloquearATM,
				Var_MontoDispuestoDiario,
				Var_LimiteDispuestoDiario,
				Var_MontoDispuesto,
				Var_LimiteDispuestoMes,
				Var_NoDispoDiario,
				Var_LimiteDisponDiario
		FROM TARJETADEBITO Tar
		WHERE Tar.TarjetaDebID = Par_CardNumber;

		SET Var_CuentaAhoID				:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_ClienteID				:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_TarjetaDebID			:= IFNULL(Var_TarjetaDebID, Cadena_Vacia);
		SET Var_EstatusTarjeta			:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
		SET Var_BloquearATM				:= IFNULL(Var_BloquearATM, BloqATM_NO);
		SET Var_MontoDispuestoDiario	:= IFNULL(Var_MontoDispuestoDiario, Entero_Cero);
		SET Var_LimiteDispuestoDiario	:= IFNULL(Var_LimiteDispuestoDiario, Entero_Cero);
		SET Var_MontoDispuesto			:= IFNULL(Var_MontoDispuesto, Entero_Cero);
		SET Var_LimiteDispuestoMes		:= IFNULL(Var_LimiteDispuestoMes, Entero_Cero);
		SET Var_NoDispoDiario			:= IFNULL(Var_NoDispoDiario, Entero_Cero);
		SET Var_LimiteDisponDiario		:= IFNULL(Var_LimiteDisponDiario, Entero_Cero);

		-- Validacion de la Cuenta de Ahorro
		SELECT	Estatus, 			SaldoDispon
		INTO	Var_EstatusCtaAho,	Var_MontoDisponible
		FROM CUENTASAHO
		WHERE CuentaAhoID = Var_CuentaAhoID;

		SET Var_EstatusCtaAho		:= IFNULL(Var_EstatusCtaAho, Cadena_Vacia);
		SET Var_MontoDisponible		:= IFNULL(Var_MontoDisponible, Entero_Cero);

		SELECT TarDebMovID
		INTO Var_TarDebMovID
		FROM TARDEBBITACORAMOVS
		WHERE TarDebMovID = Par_TarDebMovID;

		SET Var_TarDebMovID 	 := IFNULL(Var_TarDebMovID, Entero_Cero);

		-- Segmento de Validaciones de la Operacion de Consulta con Comision por ATM
		IF( Par_NumberTransaction = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1201;
			SET Par_ErrMen	:= 'El Numero de Transaccion esta Vacio.';
			SET Var_Control	:= 'numberTransaction';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProdIndicator = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1202;
			SET Par_ErrMen	:= 'El Indicador de Producto esta Vacio.';
			SET Var_Control	:= 'prodIndicator';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProdIndicator <> Prod_ATM ) THEN
			SET Par_NumErr	:= 1203;
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Consulta con Comision.';
			SET Var_Control	:= 'prodIndicator';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1204;
			SET Par_ErrMen	:= 'Codigo de transaccion.';
			SET Var_Control	:= 'tranCode';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode <> Code_Consulta ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'Codigo de transaccion no es Valido para la Operacion de Consulta con Comision.';
			SET Var_Control	:= 'tranCode';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CardNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1406;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta de Debito esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( CHAR_LENGTH(Par_CardNumber) <> LongitudTarjeta ) THEN
			SET Par_NumErr	:= 1407;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta de Debito esta Incorrecto.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TransactionAmount < Decimal_Cero OR Par_TransactionAmount > Decimal_Cero ) THEN
			SET Par_NumErr	:= 1308;
			SET Par_ErrMen	:= 'El Monto de Transaccion no es Valido en la Operacion de Consulta con Comision.';
			SET Var_Control	:= 'transactionAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CashbackAmount < Decimal_Cero OR Par_CashbackAmount > Decimal_Cero ) THEN
			SET Par_NumErr	:= 1309;
			SET Par_ErrMen	:= 'El Monto Cash Back no es Valido en la Operacion de Consulta con Comision.';
			SET Var_Control	:= 'cashbackAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AdditionalAmount < Decimal_Cero OR Par_AdditionalAmount > Decimal_Cero ) THEN
			SET Par_NumErr	:= 1310;
			SET Par_ErrMen	:= 'El Monto Adicional no es Valido en la Operacion de Consulta con Comision.';
			SET Var_Control	:= 'additionalAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_SurchargeAmounts < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1311;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'surchargeAmounts';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_SurchargeAmounts = Entero_Cero ) THEN
			SET Par_NumErr	:= 1312;
			SET Par_ErrMen	:= 'El Monto de la Operacion esta Vacio.';
			SET Var_Control	:= 'surchargeAmounts';
			SET Par_NumCodigoErr := 13;
		END IF;

		IF( Par_TransactionDate = FechaHora_Vacia ) THEN
			SET Par_NumErr	:= 1313;
			SET Par_ErrMen	:= 'La Fecha de la Operacion esta Vacia.';
			SET Var_Control	:= 'transactionAmount';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;
		
		IF( Par_Reference = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1215;
			SET Par_ErrMen	:= 'La Referencia de Operacion esta Vacia.';
			SET Var_Control	:= 'reference';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1216;
			SET Par_ErrMen	:= 'El Identificador de la Terminal esta Vacio.';
			SET Var_Control	:= 'terminalID';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalName = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1217;
			SET Par_ErrMen	:= 'El Nombre de la Terminal esta Vacio.';
			SET Var_Control	:= 'terminalName';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalLocation = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1218;
			SET Par_ErrMen	:= 'La Ubicacion de la Terminal esta Vacia.';
			SET Var_Control	:= 'terminalLocation';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_DraftCapture <> Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1219;
			SET Par_ErrMen	:= 'El Valor del DraftCapture no es Valido';
			SET Var_Control	:= 'daftCapture';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Segmento de Validaciones de la Cuenta de Ahorro asociado a la Tarjeta de Debito
		IF( Var_TarjetaDebID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1421;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Debito no Existe: ',Par_CardNumber,'.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1422;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CuentaAhoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1223;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber,' no esta asociado a una cuenta de ahorro.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusCtaAho <> Est_Activa ) THEN
			SET Par_NumErr	:= 1224;
			SET Par_ErrMen	:= CONCAT('La Cuenta de Ahorro Asociado a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1225;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1226;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_MontoDisponible <= Decimal_Cero ) THEN
			SET Par_NumErr	:= 1227;
			SET Par_ErrMen	:= CONCAT('La Cuenta de Ahorro Asociado al Tarjeta: ',Par_CardNumber,' no cuenta con saldo disponible.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 51;
			LEAVE ManejoErrores;
		END IF;

		IF( (Var_MontoDisponible - Par_SurchargeAmounts) < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1328;
			SET Par_ErrMen	:= 'El Monto de la Operacion Excede el Disponible de la Tarjeta.';
			SET Var_Control	:= 'surchargeAmounts';
			SET Par_NumCodigoErr := 51;
			LEAVE ManejoErrores;
		END IF;

		-- Limites de Monto Dispuesto Diario
		IF( Var_LimiteDispuestoDiario > Decimal_Cero ) THEN

			-- Ha excedido el limite de Monto Dispuesto Diario
			IF( (Par_SurchargeAmounts + Var_MontoDispuestoDiario) > Var_LimiteDispuestoDiario) THEN
				SET Par_NumErr	:= 1229;
				SET Par_ErrMen	:= 'Ha excedido el limite de Disposicion Diario.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 61;
				LEAVE ManejoErrores;
			END IF;

			SET Var_MontoDispuestoLibre = Var_LimiteDispuestoDiario - Var_MontoDispuestoDiario ;

			IF( Par_SurchargeAmounts > Var_MontoDispuestoLibre ) THEN
				SET Par_NumErr	:= 1230;
				SET Par_ErrMen	:= 'Ha excedido el limite de Disposicion Diario.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 61;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Limites de Monto Dispuesto Mensual
		IF (Var_LimiteDispuestoMes > Decimal_Cero) THEN

			IF( (Par_SurchargeAmounts + Var_MontoDispuesto) > Var_LimiteDispuestoMes) THEN
				SET Par_NumErr	:= 1231;
				SET Par_ErrMen	:= 'Ha excedido el limite de Disposicion Mensual.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 61;
				LEAVE ManejoErrores;
			END IF;

			SET Var_MontoDispuestoLibre := Var_LimiteDispuestoMes - Var_MontoDispuesto;

			IF( Par_SurchargeAmounts > Var_MontoDispuestoLibre) THEN
				SET Par_NumErr	:= 1232;
				SET Par_ErrMen	:= 'Ha excedido el limite de Disposicion Mensual.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 61;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Limite de Disposiciones al Dia
		IF( Var_LimiteDisponDiario > Entero_Cero ) THEN

			IF( (Var_NoDispoDiario + Entero_Uno) > Var_LimiteDisponDiario ) THEN
				SET Par_NumErr	:= 1233;
				SET Par_ErrMen	:= 'Ha excedido el Numero de Disposiciones al Dia.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 65;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Bloqueos por parametros de tarjetas
		IF( Var_BloquearATM = BloqATM_SI ) THEN
			SET Par_NumErr	:= 1234;
			SET Par_ErrMen	:= 'Tarjeta Bloqueada para Consulta ATM.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 62;
			LEAVE ManejoErrores;
		END IF;

		-- Inicio de Polizas Contables
		SET Var_Referencia	:= CONCAT("TAR **** ", SUBSTRING(Par_CardNumber,13, 4));
		SET Var_DesPoliza	:= CONCAT("COMISION POR CONSULTA ATM ",Var_Referencia);
		SET Var_DesPoliza	:= CONCAT(Var_DesPoliza,' ',Par_TerminalName);

		-- Llamada Cargo Cuenta Contable de Cartera
		-- Monto de Operacion
		CALL TD_CONTACTAAHORROPRO (
			Var_CuentaAhoID,		Par_CardNumber,				Var_ClienteID,		Var_FechaAplicacion,	Var_FechaAplicacion,
			Par_SurchargeAmounts,	Par_MonedaID,				Var_DesPoliza,		Var_Referencia,			Alta_Enc_Pol_SI,
			ConConta_TarDeb,		Var_PolizaID,				AltaPolDeb_SI,		AltaMovDeb_SI,			ConConta_TarDeb,
			Nat_Cargo,				Par_CodigoTransaccionID,	AltaMovBitacoraNO,	Cadena_Vacia,
			Par_TranCode,
			Salida_NO,				Par_NumErr,					Par_ErrMen,			Var_Consecutivo,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Poliza de Tarjeta por Transaccion ATM
		CALL POLIZATARJETAPRO (
			Var_PolizaID,		Par_EmpresaID,		Var_FechaAplicacion,	Par_CardNumber,			Var_ClienteID,
			Con_OperacATM,		Par_MonedaID,		Entero_Cero,			Par_SurchargeAmounts,	Var_DesPoliza,
			Par_Reference,		Entero_Cero,
			Salida_NO,			Par_NumErr,			Par_ErrMen,				Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Disposiciones por Dia, por Mes y Montos de Disposicion por Dia y Mes
		CALL TD_TARJETADEBITOACT (
			Par_CardNumber,		Par_SurchargeAmounts,	Nat_Cargo,			Act_MovRetiro,
			Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Consulta por Dia y Mes
		CALL TD_TARJETADEBITOACT (
			Par_CardNumber,		Entero_Cero,		Nat_Cargo,			Act_MovConsulta,
			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Se actualiza la bitacora a procesado
		CALL TARDEBBITACORAMOVSACT (
			Par_TarDebMovID,	Entero_Cero, 		Entero_Cero, 	Act_Procesado,
			Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_NumCodigoErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Comision por Consulta ATM realizada Correctamente: ',Par_CodigoTransaccionID,'.');

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CodigoTransaccionID AS AuthorizationNumber;
	END IF;

END TerminaStore$$
