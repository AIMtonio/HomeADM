
-- TD_BLOQUEOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_BLOQUEOSPRO`;

DELIMITER $$
CREATE PROCEDURE `TD_BLOQUEOSPRO`(
	-- SP para el bloqueo y desbloqueo automatico de saldo de una tarjeta de debito
	-- Modulo Tarjetas Debito --> Registro
	Par_NumberTransaction			CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator				CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode					CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Debito
	Par_TransactionAmount			DECIMAL(12,2),	-- Monto de la Transaccion

	Par_CashbackAmount				DECIMAL(12,2),	-- Montos de CashBack
	Par_AdditionalAmount			DECIMAL(12,2),	-- Montos de Comisiones
	Par_SurchargeAmounts			DECIMAL(12,2),	-- Monto de Recargos, para retiros de Efectivo
	Par_TransactionDate				DATETIME,		-- Fecha y Hora de la operacion
	Par_MerchantType				CHAR(4),		-- Giro del comercio valores aceptados(Catalogo)

	Par_Reference					CHAR(12),		-- Referencia de la operacion
	Par_TerminalID					CHAR(16),		-- ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))
	Par_TerminalName				CHAR(50),		-- Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))
	Par_TerminalLocation			CHAR(50),		-- Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))
	Par_AuthorizationNumber			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres(Web Service))

	Par_DraftCapture 				CHAR(1),		-- Indicador de Captura de la transaccion
	Par_CodigoTransaccionID			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres(S)A)
	Par_TarDebMovID					INT(11),		-- ID del movimiento de tarjeta
	Par_NumeroOperacion				TINYINT UNSIGNED,-- Numero de Operacion

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error
	INOUT Par_NumCodigoErr			INT(11),

	Aud_EmpresaID					INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario						INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- declaracion de variables
	DECLARE Var_FechaSistema			DATE;			-- Fecha de Sistema
	DECLARE Var_BloqueoID				INT(11);		-- Numero de Bloqueo
	DECLARE Var_RegistroID				INT(11);		-- Numero de Registro
	DECLARE Var_MaxRegistroID			INT(11);		-- Numero Maximo de Registro
	DECLARE Var_ClienteID				INT(11);		-- Valor del numero de cliente

	DECLARE Var_TarDebMovID				INT(11);		-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta			INT(11);		-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
	DECLARE Var_CuentaAhoID    			BIGINT(12);		-- Identificador de la Cuenta Ahorro
	DECLARE Var_BloquearPos				CHAR(1);		-- Valor bloqueo: POS
	DECLARE Var_BloquearCashBack		CHAR(1);		-- Valor bloqueo: CasBack

	DECLARE Var_EstatusCta				CHAR(1);		-- Estatus de la cuenta A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada
	DECLARE Var_Referencia				CHAR(12);		-- Referencia
	DECLARE Var_TerminalID				CHAR(12);		-- ID de la terminal - TPV o ATM(limitado a 12 caracteres. ISO8583 - DE37 (PROSA))
	DECLARE Var_TarjetaDebID			CHAR(16);		-- Numero de Tarjeta de Debito
	DECLARE Var_NombreTerminal			CHAR(50);		-- Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))

	DECLARE Var_LocacionTerminal		CHAR(50);		-- Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))
	DECLARE Var_Control					VARCHAR(100);	-- Retorno en pantalla
	DECLARE Var_Descripcion				VARCHAR(150);	-- Descripcion
	DECLARE Var_MontoBloqueo			DECIMAL(12,2);	-- Monto de Bloqueo
	DECLARE Var_MontoDisponible			DECIMAL(12,2);	-- Monto Disponible de la Cuenta de Ahorro
	
	DECLARE Var_TotalCompra				DECIMAL(16,2);	-- Total de Compra
	DECLARE Var_TransaccionID			BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_TipoOperacion			TINYINT UNSIGNED;-- Numero de Operacion

	-- declaracion de constantes
	DECLARE Entero_Cero					INT(11);		-- Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Entero Uno
	DECLARE Con_BloqPOS					INT(11);		-- Constante Consulta para obtener si se bloquea POS
	DECLARE Con_BloqCashBack			INT(11);		-- Constante Consulta para obtener si se bloquea CashBack
	DECLARE Con_TarjetaActiva			INT(11);		-- Constante Estatus Activo de Tarjetas

	DECLARE LongitudTarjeta				INT(11);		-- Constante Longitud Tarjeta
	DECLARE Con_BloqueoTarjeta			INT(11);		-- Constante Tipo de Bloqueo por tarjeta de Debito corresponde con Tipos de bloqueos
	DECLARE Fecha_Vacia					DATE;			-- Constante Fecha Vacia
	DECLARE Cadena_Vacia				CHAR(1);		-- Constante Cadena Vacia
	DECLARE Nat_Bloqueo					CHAR(1);		-- Constante Naturaleza Bloqueo

	DECLARE Nat_Desbloqueo				CHAR(1);		-- Constante Naturaleza Desbloqueo
	DECLARE Salida_SI					CHAR(1);		-- Constante Salida en Pantalla SI
	DECLARE Salida_NO					CHAR(1);		-- Constante Salida en Pantalla NO
	DECLARE Con_SI						CHAR(1);		-- Constante SI
	DECLARE Con_NO						CHAR(1);		-- Constante NO

	DECLARE BloqPOS_SI					CHAR(1);		-- Constante Bloqueo POS: SI
	DECLARE BloqPOS_NO					CHAR(1);		-- Constante Bloqueo POS: NO
	DECLARE BloqCashBack_SI				CHAR(1);		-- Constante Bloqueo CashBack SI
	DECLARE BloqCashBack_NO				CHAR(1);		-- Constante Bloqueo CashBack NO
	DECLARE Est_Activa					CHAR(1);		-- Constante Estatus Activa en la Cuenta de Tarjeta

	DECLARE Cadena_Cero					CHAR(1);		-- Constante Cadena Cero
	DECLARE Code_Preautorizacion		CHAR(2);		-- Constante 00 ISO = Normal Purchase, Preauthorization purchase1
	DECLARE Prod_POS					CHAR(2);		-- Constante Indicador de Producto 02 - POS
	DECLARE Codigo_Vacio				CHAR(6);		-- Constante Codigo de Autorizacion Vacio
	DECLARE Con_BloqMontoTransaccion	VARCHAR(150);	-- Constante Descripcion Bloqueo Monto de la Transaccion

	DECLARE Con_BloqMontoCashBack		VARCHAR(150);	-- Constante Descripcion Bloqueo Montos de CashBack
	DECLARE Con_BloqMontoComision		VARCHAR(150);	-- Constante Descripcion Bloqueo Montos de Comisiones
	DECLARE Con_BloqMontoRecargo		VARCHAR(150);	-- Constante Descripcion Bloqueo Monto de Recargos, para retiros de Efectivo
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Constante Decimal Cero
	DECLARE FechaHora_Vacia				DATETIME;		-- Constante Fecha Hora

	-- Declaracion de Actualizaciones
	DECLARE Act_Procesado				INT(11);		-- Actualiza a Estatus Procesado el Registro de Bitacora

	-- Declaracion de Operaciones
	DECLARE Con_CheckIn					TINYINT UNSIGNED;-- Operacion Check IN
	DECLARE Con_ReCheckIn				TINYINT UNSIGNED;-- Operacion Re Check IN
	DECLARE Con_CheckOut				TINYINT UNSIGNED;-- Operacion Check OUT
	DECLARE Con_ReversaCheckIn			TINYINT UNSIGNED;-- Operacion Reversa Check IN

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;
	SET Entero_Uno					:= 1;
	SET Con_BloqPOS					:= 2;
	SET Con_BloqCashBack			:= 3;
	SET Con_TarjetaActiva			:= 7;

	SET LongitudTarjeta				:= 16;
	SET Con_BloqueoTarjeta			:= 23;
	SET Fecha_Vacia					:= '1900-01-01';
	SET Cadena_Vacia				:= '';
	SET Nat_Bloqueo					:= 'B';

	SET Nat_Desbloqueo				:= 'D';
	SET Salida_SI					:= 'S';
	SET Salida_NO					:= 'N';
	SET Con_SI						:= 'S';
	SET Con_NO 						:= 'N';

	SET BloqPOS_SI					:= 'S';
	SET BloqPOS_NO					:= 'N';
	SET BloqCashBack_SI				:= 'S';
	SET BloqCashBack_NO				:= 'N';
	SET Est_Activa					:= 'A';

	SET Cadena_Cero					:= '0';
	SET Code_Preautorizacion		:= '00';
	SET Prod_POS					:= '02';
	SET Codigo_Vacio				:= '000000';
	SET Con_BloqMontoTransaccion	:= 'BLOQUEO AUTOMATICO MONTO POR TRANSACCION.';

	SET Con_BloqMontoCashBack		:= 'BLOQUEO AUTOMATICO MONTO POR CASHBACK.';
	SET Con_BloqMontoComision		:= 'BLOQUEO AUTOMATICO MONTO POR COMISION.';
	SET Con_BloqMontoRecargo		:= 'BLOQUEO AUTOMATICO MONTO POR RECARGO.';
	SET Decimal_Cero				:= 0.00;
	SET FechaHora_Vacia				:= '1900-01-01 00:00:00';

	-- Declaracion de Actualizaciones
	SET Act_Procesado				:= 3;

	-- Asignacion de Operaciones
	SET Con_CheckIn					:= 1;
	SET Con_ReCheckIn				:= 2;
	SET Con_CheckOut				:= 3;
	SET Con_ReversaCheckIn			:= 4;

	-- Asignacion de Variables
	SET Aud_FechaActual				:= CURRENT_TIMESTAMP();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_NumCodigoErr = 12;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_BLOQUEOSPRO');
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
		SET Par_TransactionDate		:= IFNULL(Par_TransactionDate, FechaHora_Vacia);
		SET Par_MerchantType		:= IFNULL(Par_MerchantType, Cadena_Vacia);

		SET Par_Reference			:= IFNULL(Par_Reference, Cadena_Vacia);
		SET Par_TerminalID			:= IFNULL(Par_TerminalID, Cadena_Vacia);
		SET Par_TerminalName		:= IFNULL(Par_TerminalName, Cadena_Vacia);
		SET Par_TerminalLocation	:= IFNULL(Par_TerminalLocation, Cadena_Vacia);
		SET Par_AuthorizationNumber	:= IFNULL(Par_AuthorizationNumber, Cadena_Vacia);

		SET Par_DraftCapture		:= IFNULL(Par_DraftCapture, Cadena_Cero);
		SET Par_CodigoTransaccionID	:= IFNULL(Par_CodigoTransaccionID, Cadena_Vacia);
		SET Par_TarDebMovID		:= IFNULL(Par_TarDebMovID, Entero_Cero);
		SET Par_NumeroOperacion		:= IFNULL(Par_NumeroOperacion, Entero_Cero);

		
		SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		SELECT 	TarjetaDebID, 		Estatus, 			CuentaAhoID, 
				IFNULL(TD_FUNCIONLIMITEBLOQ(TarjetaDebID, ClienteID, TipoTarjetaDebID, Con_BloqPOS),BloqPOS_NO),
				IFNULL(TD_FUNCIONLIMITEBLOQ(TarjetaDebID, ClienteID, TipoTarjetaDebID, Con_BloqCashBack),BloqCashBack_NO)
		INTO 	Var_TarjetaDebID,	Var_EstatusTarjeta,	Var_CuentaAhoID,
				Var_BloquearPos,
				Var_BloquearCashBack
		FROM TARJETADEBITO 
			WHERE TarjetaDebID = Par_CardNumber;

		SET Var_TarjetaDebID		:= IFNULL(Var_TarjetaDebID, Cadena_Vacia);
		SET Var_EstatusTarjeta		:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
		SET Var_CuentaAhoID			:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_BloquearPos			:= IFNULL(Var_BloquearPos, BloqPOS_NO);
		SET Var_BloquearCashBack	:= IFNULL(Var_BloquearCashBack, BloqCashBack_NO);

		
		SELECT 	Estatus, 			SaldoDispon
		INTO	Var_EstatusCta,		Var_MontoDisponible
		FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAhoID;

		SET Var_EstatusCta			:= IFNULL(Var_EstatusCta, Cadena_Vacia);
		SET Var_MontoDisponible		:= IFNULL(Var_MontoDisponible, Entero_Cero);

		SELECT TarDebMovID
		INTO Var_TarDebMovID
		FROM TARDEBBITACORAMOVS
		WHERE TarDebMovID = Par_TarDebMovID;

		SET Var_TarDebMovID		:= IFNULL(Var_TarDebMovID, Entero_Cero);
		SET Var_TotalCompra		:= Par_TransactionAmount + Par_CashbackAmount + Par_AdditionalAmount + Par_SurchargeAmounts;

		-- Segmento de Validaciones de la Operacion Basicas para el bloqueo y desbloqueo
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
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Bloqueo POS.';
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

		IF( Par_TranCode <> Code_Preautorizacion ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'El Codigo de Transaccion no es Valido.';
			SET Var_Control	:= 'tranCode';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CardNumber = Cadena_Vacia )THEN
			SET Par_NumErr	:= 1406;
			SET Par_ErrMen	:= 'El Numero de Tarjeta de Debito esta vacio.';
			SET Var_Control	:= 'tarjetaDebitoID';
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

		IF( Par_NumeroOperacion IN ( Con_ReCheckIn, Con_CheckOut, Con_ReversaCheckIn)) THEN
			IF( Par_TransactionAmount < Decimal_Cero ) THEN
				SET Par_NumErr	:= 1308;
				SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
				SET Var_Control	:= 'transactionAmount';
				SET Par_NumCodigoErr := 13;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_CashbackAmount < Decimal_Cero OR Par_CashbackAmount > Decimal_Cero ) THEN
				SET Par_NumErr	:= 1309;
				SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
				SET Var_Control	:= 'cashbackAmount';
				SET Par_NumCodigoErr := 13;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_AdditionalAmount < Decimal_Cero OR Par_AdditionalAmount > Decimal_Cero ) THEN
				SET Par_NumErr	:= 1310;
				SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
				SET Var_Control	:= 'additionalAmount';
				SET Par_NumCodigoErr := 13;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_SurchargeAmounts < Decimal_Cero OR Par_SurchargeAmounts > Decimal_Cero ) THEN
				SET Par_NumErr	:= 1311;
				SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
				SET Var_Control	:= 'surchargeAmounts';
				SET Par_NumCodigoErr := 13;
				LEAVE ManejoErrores;
			END IF;

			IF( Par_TransactionAmount = Decimal_Cero ) THEN
				SET Par_NumErr	:= 1312;
				SET Par_ErrMen	:= 'El Monto de la Operacion esta Vacio.';
				SET Var_Control	:= 'transactionAmount';
				SET Par_NumCodigoErr := 13;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_TransactionDate = FechaHora_Vacia ) THEN
			SET Par_NumErr	:= 1313;
			SET Par_ErrMen	:= 'La Fecha de la Operacion esta Vacia.';
			SET Var_Control	:= 'transactionDate';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Reference = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= 'La Referencia de Operacion esta Vacia.';
			SET Var_Control	:= 'reference';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumeroOperacion IN ( Con_CheckIn, Con_ReCheckIn, Con_CheckOut) )THEN

			IF( Par_MerchantType = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 1215;
				SET Par_ErrMen	:= 'El Giro de la Operacion esta Vacio.';
				SET Var_Control	:= 'merchantType';
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

			IF( Par_DraftCapture = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 1219;
				SET Par_ErrMen	:= 'El Valor del DraftCapture no es Valido';
				SET Var_Control	:= 'daftCapture';
				SET Par_NumCodigoErr := 12;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumeroOperacion IN ( Con_ReCheckIn, Con_CheckOut)) THEN
			IF( Par_AuthorizationNumber = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 1221;
				SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio.';
				SET Var_Control	:= 'authorizationNumber';
				SET Par_NumCodigoErr := 12;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Segmento de Validaciones de la Cuenta de Ahorro asociado a la Tarjeta de Debito
		IF( Par_NumeroOperacion = Entero_Cero ) THEN
			SET Par_NumErr	:= 1222;
			SET Par_ErrMen	:= 'El Numero de Actualizacion esta Vacio.';
			SET Var_Control	:= 'numberOperation';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumeroOperacion NOT IN (Con_CheckIn, Con_ReCheckIn, Con_CheckOut, Con_ReversaCheckIn)) THEN
			SET Par_NumErr	:= 1223;
			SET Par_ErrMen	:= 'El Numero de Actualizacion no es Valido.';
			SET Var_Control	:= 'numberOperation';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarjetaDebID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1424;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Debito no Existe: ',Par_CardNumber,'.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1425;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusCta <> Est_Activa ) THEN
			SET Par_NumErr	:= 1227;
			SET Par_ErrMen	:= CONCAT('La Cuenta Asociada a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1228;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1229;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
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

		IF( Par_CashbackAmount > Decimal_Cero ) THEN
			IF( Var_BloquearCashBack = BloqCashBack_SI ) THEN
				SET Par_NumErr	:= 1231;
				SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones CashBack.';
				SET Var_Control	:= 'cardNumber';
				SET Par_NumCodigoErr := 62;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Operacion de Check In
		IF( Par_NumeroOperacion = Con_CheckIn ) THEN

			CALL TD_BLOQUEOSALT (
				Entero_Cero,		Nat_Bloqueo,			Par_CardNumber,				Var_FechaSistema,	Par_TransactionAmount,
				Fecha_Vacia,		Con_BloqueoTarjeta,		Con_BloqMontoTransaccion,	Par_Reference,		Par_TerminalID,
				Par_TerminalName,	Par_TerminalLocation,	Par_CodigoTransaccionID,	Entero_Cero,
				Salida_NO,			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumCodigoErr := 12;
				IF(Par_NumErr IN (1404,1408,1409,1210)) THEN
					SET Par_NumCodigoErr := 14;
				END IF;
				IF(Par_NumErr IN (1305,1312)) THEN
					SET Par_NumCodigoErr := 13;
				END IF;
				IF(Par_NumErr IN (1313,1317)) THEN
					SET Par_NumCodigoErr := 51;
				END IF;
				LEAVE ManejoErrores;
			END IF;

			-- Se actualiza la bitacora a procesado
			CALL TARDEBBITACORAMOVSACT (
				Par_TarDebMovID,	Entero_Cero, 		Entero_Cero, 	Act_Procesado,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 1299;
				SET Par_NumCodigoErr := 12;
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen	:= 'Bloqueo por Check IN Realizado Correctamente.';
			SET Par_NumErr	:= Entero_Cero;
			SET Par_NumCodigoErr := Entero_Cero;
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

		-- Operacion de  Re check IN
		IF( Par_NumeroOperacion = Con_ReCheckIn ) THEN

			-- Seccion de desbloqueo de saldos
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;
			SET @RegistroID := Entero_Cero;
			SET Var_TransaccionID = Aud_NumTransaccion;
			INSERT INTO TMPTD_BLOQUEOS (
				RegistroID,
				TransaccionID,		BloqueoID,			MontoBloqueo,		Descripcion,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			SELECT
				@RegistroID :=(@RegistroID+Entero_Uno),
				Var_TransaccionID,	BloqueoID,			MontoBloqueo,		Descripcion,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM TD_BLOQUEOS
			WHERE TarjetaDebID = Par_CardNumber
			  AND NatMovimiento = Nat_Bloqueo
			  AND FolioBloqueo = Entero_Cero
			  AND NumAutorizacionAct = Par_AuthorizationNumber;

			SELECT COUNT(RegistroID)
			INTO Var_MaxRegistroID
			FROM TMPTD_BLOQUEOS
			WHERE TransaccionID = Var_TransaccionID;

			SET Var_RegistroID := Entero_Uno;

			WHILE ( Var_RegistroID <= Var_MaxRegistroID ) DO

				SELECT	BloqueoID,		MontoBloqueo,		Descripcion
				INTO 	Var_BloqueoID,	Var_MontoBloqueo,	Var_Descripcion
				FROM TMPTD_BLOQUEOS
				WHERE RegistroID = Var_RegistroID
				  AND TransaccionID = Var_TransaccionID;

				SET Var_BloqueoID		:= IFNULL(Var_BloqueoID, Entero_Cero);
				SET Var_MontoBloqueo	:= IFNULL(Var_MontoBloqueo, Entero_Cero);
				SET Var_Descripcion		:= IFNULL(Var_Descripcion, Cadena_Vacia);

				SET Var_Descripcion 	:= REPLACE(Var_Descripcion, "BLOQUEO", "DESBLOQUEO");

				CALL TD_BLOQUEOSALT (
					Var_BloqueoID,		Nat_Desbloqueo,			Par_CardNumber,				Var_FechaSistema,		Var_MontoBloqueo,
					Var_FechaSistema,	Con_BloqueoTarjeta,		Var_Descripcion,			Par_Reference,			Par_TerminalID,
					Par_TerminalName,	Par_TerminalLocation,	Par_CodigoTransaccionID,	Par_AuthorizationNumber,
					Salida_NO,			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Par_NumCodigoErr := 12;
					IF(Par_NumErr IN (1404,1408,1409,1210)) THEN
						SET Par_NumCodigoErr := 14;
					END IF;
					IF(Par_NumErr IN (1305,1312)) THEN
						SET Par_NumCodigoErr := 13;
					END IF;
					IF(Par_NumErr IN (1313,1317)) THEN
						SET Par_NumCodigoErr := 51;
					END IF;
					LEAVE ManejoErrores;
				END IF;

				SET Var_RegistroID 		:= Var_RegistroID + Entero_Uno;
				SET Var_BloqueoID		:= Entero_Cero;
				SET Var_MontoBloqueo	:= Entero_Cero;
				SET Var_Descripcion		:= Cadena_Vacia;
			END WHILE;
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;

			CALL TD_BLOQUEOSALT (
				Entero_Cero,		Nat_Bloqueo,			Par_CardNumber,				Var_FechaSistema,	Par_TransactionAmount,
				Fecha_Vacia,		Con_BloqueoTarjeta,		Con_BloqMontoTransaccion,	Par_Reference,		Par_TerminalID,
				Par_TerminalName,	Par_TerminalLocation,	Par_CodigoTransaccionID,	Entero_Cero,
				Salida_NO,			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumCodigoErr := 12;
				IF(Par_NumErr IN (1404,1408,1409,1210)) THEN
					SET Par_NumCodigoErr := 14;
				END IF;
				IF(Par_NumErr IN (1305,1312)) THEN
					SET Par_NumCodigoErr := 13;
				END IF;
				IF(Par_NumErr IN (1313,1317)) THEN
					SET Par_NumCodigoErr := 51;
				END IF;
				LEAVE ManejoErrores;
			END IF;

			-- Se actualiza la bitacora a procesado
			CALL TARDEBBITACORAMOVSACT (
				Par_TarDebMovID,	Entero_Cero, 		Entero_Cero, 	Act_Procesado,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 1299;
				SET Par_NumCodigoErr := 12;
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen	:= 'Bloqueo por ReCheck IN Realizado Correctamente.';
			SET Par_NumErr	:= Entero_Cero;
			SET Par_NumCodigoErr := Entero_Cero;
			
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

		-- Operacion de Check OUT
		IF( Par_NumeroOperacion = Con_CheckOut ) THEN

			-- Seccion de desbloqueo de saldos
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;
			SET @RegistroID := Entero_Cero;
			SET Var_TransaccionID = Aud_NumTransaccion;
			INSERT INTO TMPTD_BLOQUEOS (
				RegistroID,
				TransaccionID,		BloqueoID,			MontoBloqueo,		Descripcion,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			SELECT
				@RegistroID :=(@RegistroID+Entero_Uno),
				Var_TransaccionID,	BloqueoID,			MontoBloqueo,		Descripcion,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM TD_BLOQUEOS
			WHERE TarjetaDebID = Par_CardNumber
			  AND NatMovimiento = Nat_Bloqueo
			  AND FolioBloqueo = Entero_Cero
			  AND NumAutorizacionAct = Par_AuthorizationNumber;

			SELECT COUNT(RegistroID)
			INTO Var_MaxRegistroID
			FROM TMPTD_BLOQUEOS
			WHERE TransaccionID = Var_TransaccionID;

			SET Var_RegistroID := Entero_Uno;

			WHILE ( Var_RegistroID <= Var_MaxRegistroID ) DO

				SELECT	BloqueoID,		MontoBloqueo,		Descripcion
				INTO 	Var_BloqueoID,	Var_MontoBloqueo,	Var_Descripcion
				FROM TMPTD_BLOQUEOS
				WHERE RegistroID = Var_RegistroID
				  AND TransaccionID = Var_TransaccionID;

				SET Var_BloqueoID		:= IFNULL(Var_BloqueoID, Entero_Cero);
				SET Var_MontoBloqueo	:= IFNULL(Var_MontoBloqueo, Entero_Cero);
				SET Var_Descripcion		:= IFNULL(Var_Descripcion, Cadena_Vacia);

				SET Var_Descripcion 	:= REPLACE(Var_Descripcion, "BLOQUEO", "DESBLOQUEO");

				CALL TD_BLOQUEOSALT (
					Var_BloqueoID,		Nat_Desbloqueo,			Par_CardNumber,				Var_FechaSistema,		Var_MontoBloqueo,
					Var_FechaSistema,	Con_BloqueoTarjeta,		Var_Descripcion,			Par_Reference,			Par_TerminalID,
					Par_TerminalName,	Par_TerminalLocation,	Par_CodigoTransaccionID,	Par_AuthorizationNumber,
					Salida_NO,			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Par_NumCodigoErr := 12;
					IF(Par_NumErr IN (1404,1408,1409,1210)) THEN
						SET Par_NumCodigoErr := 14;
					END IF;
					IF(Par_NumErr IN (1305,1312)) THEN
						SET Par_NumCodigoErr := 13;
					END IF;
					IF(Par_NumErr IN (1313,1317)) THEN
						SET Par_NumCodigoErr := 51;
					END IF;
					LEAVE ManejoErrores;
				END IF;

				SET Var_RegistroID 		:= Var_RegistroID + Entero_Uno;
				SET Var_BloqueoID		:= Entero_Cero;
				SET Var_MontoBloqueo	:= Entero_Cero;
				SET Var_Descripcion		:= Cadena_Vacia;

			END WHILE;
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;

			SET Par_ErrMen	:= 'Desbloqueo por Check Out Realizado Correctamente.';
			SET Par_NumErr	:= Entero_Cero;
			SET Par_NumCodigoErr := Entero_Cero;
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

		-- Operacion de Check OUT
		IF( Par_NumeroOperacion = Con_ReversaCheckIn ) THEN

			-- Seccion de desbloqueo de saldos
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;
			SET @RegistroID := Entero_Cero;
			SET Var_TransaccionID = Aud_NumTransaccion;
			INSERT INTO TMPTD_BLOQUEOS (
				RegistroID,
				TransaccionID,		BloqueoID,			MontoBloqueo,		Descripcion,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			SELECT
				@RegistroID :=(@RegistroID+Entero_Uno),
				Var_TransaccionID,	BloqueoID,			MontoBloqueo,		Descripcion,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM TD_BLOQUEOS
			WHERE TarjetaDebID = Par_CardNumber
			  AND NatMovimiento = Nat_Bloqueo
			  AND FolioBloqueo = Entero_Cero
			  AND NumAutorizacionAct = Par_AuthorizationNumber;

			SELECT COUNT(RegistroID)
			INTO Var_MaxRegistroID
			FROM TMPTD_BLOQUEOS
			WHERE TransaccionID = Var_TransaccionID;

			SET Var_RegistroID := Entero_Uno;

			WHILE ( Var_RegistroID <= Var_MaxRegistroID ) DO

				SELECT	BloqueoID,		MontoBloqueo,		Descripcion
				INTO 	Var_BloqueoID,	Var_MontoBloqueo,	Var_Descripcion
				FROM TMPTD_BLOQUEOS
				WHERE RegistroID = Var_RegistroID
				  AND TransaccionID = Var_TransaccionID;

				SET Var_BloqueoID		:= IFNULL(Var_BloqueoID, Entero_Cero);
				SET Var_MontoBloqueo	:= IFNULL(Var_MontoBloqueo, Entero_Cero);
				SET Var_Descripcion		:= IFNULL(Var_Descripcion, Cadena_Vacia);

				SELECT	TerminalID,		NombreTerminal,		LocacionTerminal
				INTO 	Var_TerminalID,	Var_NombreTerminal,	Var_LocacionTerminal
				FROM TD_BLOQUEOS
				WHERE BloqueoID = Var_BloqueoID;

				SET Var_TerminalID			:= IFNULL(Var_TerminalID, Cadena_Vacia);
				SET Var_NombreTerminal		:= IFNULL(Var_NombreTerminal, Cadena_Vacia);
				SET Var_LocacionTerminal	:= IFNULL(Var_LocacionTerminal, Cadena_Vacia);

				SET Var_Descripcion 	:= REPLACE(Var_Descripcion, "BLOQUEO", "DESBLOQUEO");

				CALL TD_BLOQUEOSALT (
					Var_BloqueoID,		Nat_Desbloqueo,			Par_CardNumber,				Var_FechaSistema,		Var_MontoBloqueo,
					Var_FechaSistema,	Con_BloqueoTarjeta,		Var_Descripcion,			Par_Reference,			Var_TerminalID,
					Var_NombreTerminal,	Var_LocacionTerminal,	Par_CodigoTransaccionID,	Par_AuthorizationNumber,
					Salida_NO,			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Par_NumCodigoErr := 12;
					IF(Par_NumErr IN (1404,1408,1409,1210)) THEN
						SET Par_NumCodigoErr := 14;
					END IF;
					IF(Par_NumErr IN (1305,1312)) THEN
						SET Par_NumCodigoErr := 13;
					END IF;
					IF(Par_NumErr IN (1313,1317)) THEN
						SET Par_NumCodigoErr := 51;
					END IF;
					LEAVE ManejoErrores;
				END IF;

				SET Var_RegistroID 			:= Var_RegistroID + Entero_Uno;
				SET Var_BloqueoID			:= Entero_Cero;
				SET Var_MontoBloqueo		:= Entero_Cero;
				SET Var_Descripcion			:= Cadena_Vacia;
				SET Var_TerminalID			:= Cadena_Vacia;
				SET Var_NombreTerminal		:= Cadena_Vacia;
				SET Var_LocacionTerminal	:= Cadena_Vacia;

			END WHILE;
			DELETE FROM TMPTD_BLOQUEOS WHERE TransaccionID = Var_TransaccionID;

			-- Se actualiza la bitacora a procesado
			CALL TARDEBBITACORAMOVSACT (
				Par_TarDebMovID,	Entero_Cero, 		Entero_Cero, 	Act_Procesado,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Par_NumErr := 1299;
				SET Par_NumCodigoErr := 12;
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen	:= 'Desbloqueo por Check Out Realizado Correctamente.';
			SET Par_NumErr	:= Entero_Cero;
			SET Par_NumCodigoErr := Entero_Cero;
			SET Var_Control	:= 'bloqueoID';
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_CodigoTransaccionID AS Consecutivo;
	END IF;

END TerminaStore$$