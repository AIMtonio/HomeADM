DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_DEVOLUCIONPRO`;
DELIMITER $$

CREATE PROCEDURE `TD_DEVOLUCIONPRO`(
	-- Store Procedure de Devolucion de tarjetas de debito por medio de Web Service
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
	INOUT Par_FolioDevolucionID		BIGINT(20),		-- ID de Respaldo de Informacion(Usado en la operacion de Devolucion )
	Par_TarDebMovID					INT(11),		-- ID del movimiento de tarjeta

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error
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
	DECLARE Var_EstatusCtaAho		CHAR(1);			-- Estatus de la cta; A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada
	DECLARE Var_BloquearPos			CHAR(1);			-- Valor bloqueo: POS
	DECLARE Var_BloquearCashBack	CHAR(1);			-- Valor bloqueo: CasBack

	DECLARE Var_TarjetaDebID		CHAR(16);			-- Numero de Cuenta de Ahorro de la Tarjeta Debito
	DECLARE Var_ClienteID			INT(11);			-- Valor del numero de cliente
	DECLARE Var_TarDebMovID			INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD

	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal de cliente
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- Identificador de la Cuenta de Ahorro
	DECLARE Var_Consecutivo			BIGINT(20);			-- ID de Consecutivo
	DECLARE Var_PolizaID			BIGINT(20);			-- ID de Poliza Contable
	DECLARE Var_Referencia			VARCHAR(50);		-- Valor del numero de tarjeta

	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla
	DECLARE Var_DesPoliza			VARCHAR(150);		-- Descripcion por compra con tarjeta
	DECLARE Var_MontoDisponible		DECIMAL(12,2);		-- Monto Disponible de la Cuenta
	DECLARE Var_CashbackAmount		DECIMAL(12,2);		-- Montos de CashBack

	DECLARE Var_TotalDevolucion		DECIMAL(16,2);		-- Total de Devolucion

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Salida_NO				CHAR(1);			-- Constante Salida SI
	DECLARE Salida_SI				CHAR(1);			-- Constante Salida NO
	DECLARE Con_NO					CHAR(1);			-- Constante SI

	DECLARE Con_SI					CHAR(1);			-- Constante NO
	DECLARE Alta_Enc_Pol_NO			CHAR(1);			-- Constante Alta Encabezado Poliza NO
	DECLARE Alta_Enc_Pol_SI			CHAR(1);			-- Constante Alta Encabezado Poliza SI
	DECLARE AltaPol_SI				CHAR(1);			-- Constante Alta Poliza SI

	DECLARE AltaMov_NO				CHAR(1);			-- Constante Alta Movimiento NO
	DECLARE AltaMov_SI				CHAR(1);			-- Constante Alta Movimiento SI
	DECLARE AltaMovBitacoraNO		CHAR(1);			-- Constante Alta Movimiento Bitacora NO

	DECLARE AltaMovBitacoraSI		CHAR(1);			-- Constante Alta Movimiento Bitacora SI
	DECLARE Nat_Cargo				CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Est_Activa				CHAR(1);			-- Constante Estatus Activa en Cuenta de Ahorro de la Tarjeta
	DECLARE Con_DraftCapture		CHAR(1);			-- Constante DraftCapture Autorizado

	DECLARE Cadena_Uno				CHAR(1);			-- Constante Cadena Uno
	DECLARE BloqPOS_SI				CHAR(1);			-- Constante Bloqueo POS: SI
	DECLARE BloqPOS_NO				CHAR(1);			-- Constante Bloqueo POS: NO
	DECLARE BloqCashBack_SI			CHAR(1);			-- Constante Bloqueo CashBack SI
	DECLARE BloqCashBack_NO			CHAR(1);			-- Constante Bloqueo CashBack NO

	DECLARE Code_Preautorizacion	CHAR(2);			-- Constante 00 ISO = Normal Purchase, Preauthorization purchase1
	DECLARE Prod_POS				CHAR(2);			-- Constante Indicador de Producto 02 - POS
	DECLARE Code_Returns			CHAR(2);			-- Constante  ISO = Returns
	DECLARE Con_SubClasificacion	CHAR(3);			-- Constante Subclasificacion de Producto
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero

	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno
	DECLARE Con_CapitalVigente		INT(11);			-- Constante Concepto Contable Vigente
	DECLARE Mov_CapOrdinario		INT(11);			-- Constante Movimiento de Reversa de Check IN(Capital Ordinario)
	DECLARE Con_OperacPOS			INT(11);			-- Constante Concepto operacion: POS
	DECLARE Con_BloqPOS				INT(11);			-- Constante Consulta para obtener si se bloquea POS

	DECLARE Con_BloqCashBack		INT(11);			-- Constante Consulta para obtener si se bloquea CashBack
	DECLARE Con_TarjetaActiva		INT(11);			-- Constante Estatus Activo de Tarjetas
	DECLARE LongitudTarjeta			INT(11);			-- Constante Longitud Tarjeta
	DECLARE ConConta_TarDeb			INT(11);			-- Constante Concepto Contable Tarjeta de Debito
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero

	DECLARE FechaHora_Vacia			DATETIME;			-- Fecha y Hora Vacia

	-- Declaracion de Actualizaciones
	DECLARE Act_Procesado			INT(11);			-- Constante Actualiza a Estatus Procesado el Registro de Bitacora
	DECLARE Act_MovCompra			INT(11);			-- Constante Movimiento Compra POS

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Con_NO					:= 'N';

	SET Con_SI					:= 'S';
	SET Alta_Enc_Pol_NO			:= 'N';
	SET Alta_Enc_Pol_SI			:= 'S';
	SET AltaPol_SI				:= 'S';

	SET AltaMov_NO			:= 'N';
	SET AltaMov_SI				:= 'S';
	SET AltaMovBitacoraNO		:= 'N';

	SET AltaMovBitacoraSI		:= 'S';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET Est_Activa				:= 'A';
	SET Con_DraftCapture		:= '1';

	SET BloqPOS_SI				:= 'S';
	SET BloqPOS_NO				:= 'N';
	SET BloqCashBack_SI			:= 'S';
	SET BloqCashBack_NO			:= 'N';
	SET Cadena_Uno				:= '1';

	SET Code_Preautorizacion	:= '00';
	SET Prod_POS				:= '02';
	SET Code_Returns			:= '20';
	SET Con_SubClasificacion	:= '201';
	SET Entero_Cero				:= 0;

	SET Entero_Uno				:= 1;
	SET Con_CapitalVigente		:= 1;
	SET Mov_CapOrdinario		:= 90;
	SET Con_OperacPOS			:= 2;
	SET Con_BloqPOS				:= 2;

	SET Con_BloqCashBack		:= 3;
	SET Con_TarjetaActiva		:= 7;
	SET LongitudTarjeta			:= 16;
	SET ConConta_TarDeb			:= 300;
	SET Decimal_Cero			:= 0.00;

	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

	-- Declaracion de Actualizaciones
	SET Act_Procesado			:= 1;
	SET Act_MovCompra			:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_NumCodigoErr = 12;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-TD_DEVOLUCIONPRO');
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
		SET Par_FolioDevolucionID	:= Entero_Cero;
		SET Par_TarDebMovID			:= IFNULL(Par_TarDebMovID, Entero_Cero);
		SET Var_TotalDevolucion		:= Par_TransactionAmount + Par_CashbackAmount + Par_AdditionalAmount + Par_SurchargeAmounts;

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Aud_FechaActual 		:= NOW();

		SELECT 	TarjetaDebID, 		Estatus, 			CuentaAhoID, 		ClienteID,
				IFNULL(TD_FUNCIONLIMITEBLOQ(TarjetaDebID, ClienteID, CuentaAhoID, Con_BloqPOS), Cadena_Vacia),
				IFNULL(TD_FUNCIONLIMITEBLOQ(TarjetaDebID, ClienteID, CuentaAhoID, Con_BloqCashBack), Cadena_Vacia)
		INTO 	Var_TarjetaDebID,	Var_EstatusTarjeta,	Var_CuentaAhoID,	Var_ClienteID,
				Var_BloquearPos,
				Var_BloquearCashBack
		FROM TARJETADEBITO
		WHERE TarjetaDebID = Par_CardNumber;

		SET Var_TarjetaDebID		:= IFNULL(Var_TarjetaDebID, Cadena_Vacia);
		SET Var_EstatusTarjeta		:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
		SET Var_CuentaAhoID			:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_BloquearPos			:= IFNULL(Var_BloquearPos, BloqPOS_NO);
		SET Var_BloquearCashBack	:= IFNULL(Var_BloquearCashBack, BloqCashBack_NO);

		-- Validacion de la Cuenta de Ahorro
		SELECT 	Estatus, 			SaldoDispon
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

		-- Se obtiene el numero de Respaldo de la Operacion de acuerdo a los parametros de entrada
		SELECT RespaldoID,			CashbackAmount
		INTO Par_FolioDevolucionID,	Var_CashbackAmount
		FROM TD_BITACORAOPERACION
		WHERE ProdIndicator = Prod_POS
		  AND TranCode = Code_Preautorizacion
		  AND CardNumber = Par_CardNumber
		  AND (TransactionAmount + CashbackAmount + AdditionalAmount + SurchargeAmounts) = Var_TotalDevolucion
		  AND MerchantType = Par_MerchantType
		  AND CodigoTransaccionID = Par_AuthorizationNumber
		  AND DraftCapture = Con_DraftCapture
		  AND FolioDevolucionID = Entero_Cero
		  AND EsReversa = Con_NO;

		SET Par_FolioDevolucionID := IFNULL(Par_FolioDevolucionID, Entero_Cero);
		SET Var_CashbackAmount	  := IFNULL(Var_CashbackAmount, Entero_Cero);

		-- Segmento de Validaciones de la Operacion de Ajuste
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

		IF( Par_ProdIndicator <> Prod_POS ) THEN
			SET Par_NumErr	:= 1203;
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Ajustes POS.';
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

		IF( Par_TranCode <> Code_Returns ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'Codigo de transaccion no es Valido para la Operacion de Ajustes POS.';
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

		IF( Par_TransactionAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1308;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'transactionAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CashbackAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1309;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'cashbackAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AdditionalAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1310;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
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

		IF( Par_TransactionDate = FechaHora_Vacia ) THEN
			SET Par_NumErr	:= 1313;
			SET Par_ErrMen	:= 'La Fecha de la Operacion esta Vacia.';
			SET Var_Control	:= 'transactionDate';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MerchantType = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= 'El Giro de la Operacion esta Vacio.';
			SET Var_Control	:= 'merchantType';
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

		IF( Par_AuthorizationNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1219;
			SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_DraftCapture <> Cadena_Uno ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Valor del DraftCapture no es Valido';
			SET Var_Control	:= 'daftCapture';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1221;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Segmento de Validaciones de la Cuenta de Ahorro Asociado a la Tarjeta de Debito
		IF( Var_TarjetaDebID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1422;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Debito no Existe: ',Par_CardNumber, '.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1423;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CuentaAhoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1224;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber,' no cuenta con Cuenta de Ahorro.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusCtaAho != Est_Activa ) THEN
			SET Par_NumErr	:= 1225;
			SET Par_ErrMen	:= CONCAT('La Cuenta de Ahorro Asociado a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1226;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1227;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FolioDevolucionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1228;
			SET Par_ErrMen	:= 'No Existe una Referencia para la Operacion de Devolucion.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Bloqueos por parametros de tarjetas
		IF( Var_BloquearPos = BloqPOS_SI ) THEN
			SET Par_NumErr	:= 1230;
			SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones POS.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 62;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CashbackAmount > Decimal_Cero ) THEN
			IF( Var_BloquearCashBack = BloqCashBack_SI ) THEN
				SET Par_NumErr	:= 1231;
				SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones CashBack.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 62;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Inicio de Polizas Contables
		SET Var_ClienteID		 := IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_Referencia		 := CONCAT("TAR **** ", SUBSTRING(Par_CardNumber,13, 4));
		SET Var_DesPoliza		 := CONCAT("REVERSA ",Var_Referencia);

		-- Registro de Movimiento Operativos para la reversa de operacion
		-- Llamada Abono Cuenta Contable de Cartera -- 90-REVERSO COMPRA CON TARJETA DE DEBITO
		CALL TD_CONTACTAAHORROPRO (
			Var_CuentaAhoID,		Par_CardNumber,				Var_ClienteID,				Var_FechaAplicacion,	Var_FechaAplicacion,
			Var_TotalDevolucion,	Par_MonedaID,				Var_DesPoliza,				Var_Referencia,			Alta_Enc_Pol_SI,
			ConConta_TarDeb,		Var_PolizaID,				AltaPol_SI,					AltaMov_SI,				Mov_CapOrdinario,		
			Nat_Abono,				Par_AuthorizationNumber,	AltaMovBitacoraNO,			Cadena_Vacia,			Par_TranCode,
			Salida_NO,				Par_NumErr,					Par_ErrMen,					Var_Consecutivo,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Poliza de Tarjeta por Transaccion POS
		CALL POLIZATARJETAPRO (
			Var_PolizaID,		Par_EmpresaID,		Var_FechaAplicacion,	Par_CardNumber,		Var_ClienteID,
			Con_OperacPOS,		Par_MonedaID,		Var_TotalDevolucion,	Entero_Cero,		Var_DesPoliza,
			Par_Reference,		Entero_Cero,
			Salida_NO,			Par_NumErr,			Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
		CALL TD_TARJETADEBITOACT (
			Par_CardNumber,		Var_TotalDevolucion,	Nat_Abono,		Act_MovCompra,
			Salida_NO,			Par_NumErr,				Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

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
		SET Par_ErrMen := CONCAT('Devolucion realizada Correctamente: ',Par_CodigoTransaccionID,'.');

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS ResponseCode,
				Par_ErrMen AS ResponseMessage,
				Par_CodigoTransaccionID AS AuthorizationNumber;
	END IF;

END TerminaStore$$