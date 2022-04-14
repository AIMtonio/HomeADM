-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_TRANSACCIONESWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_TRANSACCIONESWSPRO`;

DELIMITER $$
CREATE PROCEDURE `TC_TRANSACCIONESWSPRO`(
	-- Procesa las operaciones de tarjetas de credito por medio de Web Service
	-- Tarjetas de Credito --> Web Service
	Par_NumberTransaction			CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator				CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode					CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Credito
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
	Par_ReferenceTransaction		CHAR(12),		-- Referencia de la operacion original
	Par_ApplicationDate				DATETIME,		-- Fecha de Aplicacion de la reversa
	Par_AmountDispensed				DECIMAL(12,2),	-- Para reversar parciales de ATM
	INOUT Par_CodigoTransaccionID	CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(SAFI))

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(500),	-- Mensaje de Error

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
	DECLARE Var_Hora				TIME;				-- Hora de la Operacion
	DECLARE Var_FechaAplicacion		DATE;				-- Fecha de Aplicacion de la operacion(Fecha de sistema)
	DECLARE Var_FechaOperacion		DATE;				-- Fecha de Aplicacion
	DECLARE Var_EsReversa			CHAR(1);			-- Indica si la Operacion es Reversa
	DECLARE Var_Naturaleza			CHAR(1);			-- Naturaleza de la Operacion
	DECLARE Var_EstatusLinea		CHAR(1);			-- Estatus de la linea R: Registrada, V: Vigente, B: Bloqueada, C: Cancelada

	DECLARE Var_TransLinea			CHAR(1);			-- Indica si transaccion en linea
	DECLARE Var_EsCheckIn			CHAR(1);			-- Indica si transaccion es por check in o re check in
	DECLARE Var_CodigoRespuesta		CHAR(3);			-- Codigo de respuesta
	DECLARE Var_Reference			CHAR(12);			-- Referencia de la operacion
	DECLARE Var_TarjetaCreditoID	CHAR(16);			-- Numero de Linea de Credito

	DECLARE Var_TarCredMovID		INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
	DECLARE Var_NumErr				INT(11);			-- Numero de Error
	DECLARE Var_LineaTarCredID		INT(20);			-- Identificador de la Linea de Credito
	DECLARE Var_FechaHora			DATETIME;			-- Fecha y Hora de la Operacion

	DECLARE Var_Fecha				DATETIME;			-- Fecha del Sistema
	DECLARE Var_NumTransaccion		BIGINT(20);			-- Se obtiene el numero de transaccion
	DECLARE Var_RespaldoID			BIGINT(20);			-- ID de Tabla TC_BITACORAOPERACION
	DECLARE Var_FolioDevolucionID	BIGINT(20);			-- Folio de Devolucion
	DECLARE Var_ValorDivisa			DECIMAL(12,2);		-- Valor de la divisa (TC - DOlares)

	DECLARE Var_MontoOperacionMx	DECIMAL(12,2);		-- Monto de operacion en pesos
	DECLARE Var_MontoCashBackMx		DECIMAL(12,2);		-- Monto de cashback en pesos
	DECLARE Var_MontoComisionMx		DECIMAL(12,2);		-- Monto de Comision en pesos
	DECLARE Var_AdditionalAmountMx	DECIMAL(12,2);		-- Monto de Adicionales en Pesos
	DECLARE Var_Balance				DECIMAL(12,2);		-- Monto deudor de la cuenta.

	DECLARE Var_BalanceAvailable	DECIMAL(12,2);		-- Monto disponible
	DECLARE Var_BalanceOri			DECIMAL(12,2);		-- Monto Original deudor de la cuenta.
	DECLARE Var_BalanceAvailableOri	DECIMAL(12,2);		-- Monto Original disponible
	DECLARE Var_TotalCompra			DECIMAL(16,2);		-- Total de Compra
	DECLARE Var_SaldoContableAct	DECIMAL(16,2);		-- Saldo Contable

	DECLARE Var_SaldoDisponibleAct	DECIMAL(16,2);		-- Saldo disponible
	DECLARE Var_IRD					VARCHAR(4);			-- Clave IRD
	DECLARE Var_Pais				VARCHAR(6);			-- Pais del comercio
	DECLARE Var_Ciudad				VARCHAR(20);		-- Ciudad del comercio
	DECLARE Var_DatosTiempoAire		VARCHAR(70);		-- Datos de tiempo aire

	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla
	DECLARE Var_ErrMen				VARCHAR(500);		-- Mensaje de Error
	DECLARE Var_OperacionID			TINYINT UNSIGNED;	-- Numero de Operacion

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Salida_NO				CHAR(1);			-- Constante Salida SI
	DECLARE Salida_SI				CHAR(1);			-- Constante Salida NO
	DECLARE Con_NO					CHAR(1);			-- Constante SI

	DECLARE Con_SI					CHAR(1);			-- Constante NO
	DECLARE Nat_Cargo				CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Origen_WebService		CHAR(1);			-- Constante Origen Web Service
	DECLARE Est_Vigente				CHAR(1);			

	DECLARE POSEnLineaSI			CHAR(1);			-- Constante Si transacciona en linea
	DECLARE Con_ReversaParcialSI	CHAR(1);			-- Constante es Reversal Parcial SI
	DECLARE Con_ReversaParcialNO	CHAR(1);			-- Constante es Reversal Parcial NO
	DECLARE Cadena_Cero				CHAR(1);			-- Constante Cadena Cero
	DECLARE Cadena_Uno				CHAR(1);			-- Constante Cadena Uno
	DECLARE Prod_ATM				CHAR(2);			-- Constante Indicador de Producto 01 - ATM
	DECLARE Prod_POS				CHAR(2);			-- Constante Indicador de Producto 02 - POS

	DECLARE Code_Preautorizacion	CHAR(2);			-- Constante 00 ISO = Normal Purchase, Preauthorization purchase1
	DECLARE Code_CashAdvance		CHAR(2);			-- Constante 01 ISO = Cash Advance or Withdrawal
	DECLARE Code_DebitAdjustment	CHAR(2);			-- Constante 02 ISO = Debit Adjustment
	DECLARE Code_Returns			CHAR(2);			-- Constante 20 ISO = Returns
	DECLARE Code_Consulta			CHAR(2);			-- Constante 31 ISO= Consulta de Saldos (Corresponsales Bancarios)

	DECLARE Code_PagoServicio		CHAR(2);			-- Constante 65 ISO= Pago de servicios
	DECLARE Con_CodigoMexTex		CHAR(3);			-- Constante Codigo Mexico Texto
	DECLARE Con_CodigoMexNum		CHAR(3);			-- Constante Codigo Mexico Numero de Operacion Mexico
	DECLARE Con_GiroATM				CHAR(4);			-- Constante Giro Generico ATM
	DECLARE Con_TranATMPOS			CHAR(4);			-- Constante Transaccion Atm POS
	DECLARE Codigo_Vacio			CHAR(6);			-- Constante Codigo de Autorizacion Vacio

	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno
	DECLARE Con_MonedaMexico		INT(11);			-- Constante Moneda Pesos
	DECLARE Con_TarjetaActiva		INT(11);			-- Constante Estatus Activo de Tarjetas
	DECLARE LongitudTarjeta			INT(11);			-- Constante Longitud Tarjeta

	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero

	-- Declaracion de Operaciones
	DECLARE Con_CheckIn				TINYINT UNSIGNED;-- Operacion Check IN
	DECLARE Con_ReCheckIn			TINYINT UNSIGNED;-- Operacion Re Check IN
	DECLARE Con_CheckOut			TINYINT UNSIGNED;-- Operacion Check OUT
	DECLARE Con_ReversaCheckIn		TINYINT UNSIGNED;-- Operacion Reversa Check IN
	DECLARE Con_CompraPos			TINYINT UNSIGNED;-- Operacion Consulta POS

	DECLARE Con_Devolucion			TINYINT UNSIGNED;-- Operacion Devolucion
	DECLARE Con_Ajuste				TINYINT UNSIGNED;-- Operacion Ajuste
	DECLARE Con_ReversaCompra		TINYINT UNSIGNED;-- Operacion Reversa de Compra
	DECLARE Con_RetiroATM			TINYINT UNSIGNED;-- Operacion Retiro ATM
	DECLARE Con_ReversaTotalRetiro	TINYINT UNSIGNED;-- Operacion Reversa Total Retiro

	DECLARE Con_ReversaParcialRetiro	TINYINT UNSIGNED;-- Operacion Reversa Parcial
	DECLARE Con_VentaGenericaATM		TINYINT UNSIGNED;-- Operacion Venta Generica ATM
	DECLARE Con_ConsultaSaldoATM		TINYINT UNSIGNED;-- Operacion Consulta Saldo ATM
	DECLARE Con_ConsultaSaldoCom		TINYINT UNSIGNED;-- Operacion Consulta Saldo con Comision
	DECLARE Con_ReversaConsulta			TINYINT UNSIGNED;-- Operacion Reversa de Consulta Surcharge

	-- Declaracion de Actualizaciones
	DECLARE Act_MovConsulta			INT(11);	-- Constante Movimiento Consulta ATM

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Con_NO					:= 'N';

	SET Con_SI					:= 'S';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET Origen_WebService		:= 'W';
	SET Est_Vigente				:= 'V';

	SET POSEnLineaSI			:= 'S';
	SET Con_ReversaParcialSI	:= 'S';
	SET Con_ReversaParcialNO	:= 'N';
	SET Cadena_Cero				:= '0';
	SET Cadena_Uno				:= '1';
	SET Prod_ATM				:= '01';
	SET Prod_POS				:= '02';

	SET Code_Preautorizacion	:= '00';
	SET Code_CashAdvance		:= '01';
	SET Code_DebitAdjustment	:= '02';
	SET Code_Returns			:= '20';
	SET Code_Consulta			:= '31';

	SET Code_PagoServicio		:= '65';
	SET Con_CodigoMexNum		:= '484';
	SET Con_CodigoMexTex		:= 'MEX';
	SET Con_GiroATM				:= '0000';
	SET Con_TranATMPOS			:= '1200';

	SET Codigo_Vacio			:= '000000';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Con_MonedaMexico		:= 1;
	SET Con_TarjetaActiva		:= 7;

	SET LongitudTarjeta			:= 16;
	SET Decimal_Cero			:= 0.00;

	-- Asignacion de Operaciones
	SET Con_CheckIn				:= 1;
	SET Con_ReCheckIn			:= 2;
	SET Con_CheckOut			:= 3;
	SET Con_ReversaCheckIn		:= 4;
	SET Con_CompraPos			:= 5;

	SET Con_Devolucion			:= 6;
	SET Con_Ajuste				:= 7;
	SET Con_ReversaCompra		:= 8;
	SET Con_RetiroATM			:= 9;
	SET Con_ReversaTotalRetiro	:= 10;

	SET Con_ReversaParcialRetiro	:= 11;
	SET Con_VentaGenericaATM		:= 12;
	SET Con_ConsultaSaldoATM		:= 13;
	SET Con_ConsultaSaldoCom		:= 14;
	SET Con_ReversaConsulta			:= 15;

	-- Asignacion de Actualizaciones
	SET Act_MovConsulta			:= 3;

	SET Var_Balance				:= Decimal_Cero;
	SET Var_BalanceAvailable	:= Decimal_Cero;
	SET Var_BalanceOri			:= Decimal_Cero;
	SET Var_BalanceAvailableOri	:= Decimal_Cero;

	SET Var_FechaAplicacion		:= DATE(Par_TransactionDate);
	SET Par_CodigoTransaccionID	:= Codigo_Vacio;
	SET Var_FechaHora			:= Par_TransactionDate;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr	= 12;
			SET Par_ErrMen	= 'Invalid transaction';
			SET Var_NumErr	= 999;
			SET Var_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-TC_TRANSACCIONESWSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
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
		SET Par_ReferenceTransaction:= IFNULL(Par_ReferenceTransaction, Cadena_Vacia);
		SET Par_ApplicationDate		:= IFNULL(Par_ApplicationDate, NOW());
		SET Par_AmountDispensed		:= IFNULL(Par_AmountDispensed, Decimal_Cero);

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_ValorDivisa			:= Entero_Uno;
		SET Var_MontoOperacionMx	:= Par_TransactionAmount;
		SET Var_MontoCashBackMx		:= Par_CashbackAmount;
		SET Var_MontoComisionMx		:= Par_SurchargeAmounts;
		SET Var_AdditionalAmountMx	:= Par_AdditionalAmount;
		SET Var_IRD 				:= Cadena_Vacia;
		SET Var_Ciudad				:= Cadena_Vacia;
		SET Var_Pais 				:= Con_CodigoMexTex;
		SET Var_DatosTiempoAire		:= Cadena_Vacia;
		SET Aud_FechaActual 		:= NOW();
		SET Var_Hora				:= TIME(NOW());

		SELECT	TarjetaCredID,			Estatus,			LineaTarCredID
		INTO 	Var_TarjetaCreditoID,	Var_EstatusTarjeta,	Var_LineaTarCredID
		FROM TARJETACREDITO
		WHERE TarjetaCredID = Par_CardNumber;

		SET Var_TarjetaCreditoID := IFNULL(Var_TarjetaCreditoID, Cadena_Vacia);
		SET Var_LineaTarCredID   := IFNULL(Var_LineaTarCredID, Entero_Cero);

		SET Var_FolioDevolucionID := IFNULL(Var_FolioDevolucionID, Entero_Cero);

		-- Validacion de la Linea de Credito
		SELECT	Estatus,
				IFNULL(SaldoCapVigente,Decimal_Cero) + IFNULL(SalOrtrasComis,Decimal_Cero),
				IFNULL(MontoDisponible, Decimal_Cero)
		INTO	Var_EstatusLinea,
				Var_BalanceOri,
				Var_BalanceAvailableOri
		FROM LINEATARJETACRED
		WHERE LineaTarCredID = Var_LineaTarCredID;

		-- Segmento de Validaciones Generales
		IF( Par_NumberTransaction = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1201;
			SET Var_ErrMen	:= 'El Numero de Transaccion esta Vacio.';
			SET Var_Control	:= 'numberTransaction';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CardNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1402;
			SET Var_ErrMen	:= 'El Numero de la Tarjeta de Credito esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( CHAR_LENGTH(Par_CardNumber) != LongitudTarjeta ) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1403;
			SET Var_ErrMen	:= 'El Numero de la Tarjeta de Credito esta Incorrecto.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarjetaCreditoID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1404;
			SET Var_ErrMen	:= CONCAT('El Numero de Tarjeta de Credito no Existe: ',Par_CardNumber);
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_LineaTarCredID = Entero_Cero ) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1205;
			SET Var_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber,' no cuenta con Linea de Credito.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1406;
			SET Var_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber, ' No esta Activa');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusLinea != Est_Vigente ) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
			SET Var_NumErr	:= 1207;
			SET Var_ErrMen	:= CONCAT('La Linea de la Credito Asociada a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProdIndicator <> Cadena_Vacia ) THEN

			IF( Par_ProdIndicator NOT IN (Prod_ATM, Prod_POS) ) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
				SET Var_NumErr	:= 1208;
				SET Var_ErrMen	:= 'El Indicador de Producto no es Valido.';
				SET Var_Control	:= 'prodIndicator';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_TranCode = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
				SET Var_NumErr	:= 1209;
				SET Var_ErrMen	:= 'El Codigo de transaccion esta Vacio.';
				SET Var_Control	:= 'tranCode';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_TranCode NOT IN (Code_Preautorizacion, Code_CashAdvance, Code_DebitAdjustment,
									 Code_Returns, Code_Consulta, Code_PagoServicio) ) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
				SET Var_NumErr	:= 1210;
				SET Var_ErrMen	:= 'El Codigo de transaccion no es Valido.';
				SET Var_Control	:= 'tranCode';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_DraftCapture NOT IN (Cadena_Vacia, Cadena_Cero, Cadena_Uno)) THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Prod_ATM);
				SET Var_NumErr	:= 1212;
				SET Var_ErrMen	:= 'El Valor del DraftCapture no es Valido.';
				SET Var_Control	:= 'draftCapture';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Se Calcula la operacion a realizar
		CALL TC_ASIGNAOPERACIONCAL (
			Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
			Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
			Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
			Par_DraftCapture,		Par_ReferenceTransaction,	Par_ApplicationDate,	Par_AmountDispensed,	Var_OperacionID,
			Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_NumErr	:= Par_NumErr;
			SET Var_ErrMen	:= Par_ErrMen;
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			LEAVE ManejoErrores;
		END IF;

		IF ( Var_OperacionID = Entero_Cero ) THEN
			SET Var_NumErr	:= 1212;
			SET Var_ErrMen	:= 'El numero de Operacion no es Valido.';
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el numero de Autorizacion para la operacion
		CALL TC_CODIGOAUTORIZACIONPRO (
			Par_CodigoTransaccionID,	Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_NumErr	:= Par_NumErr;
			SET Var_ErrMen	:= Par_ErrMen;
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Codigo_Vacio ) THEN
			SET Var_NumErr	:= 1213;
			SET Var_ErrMen	:= 'El Codigo de Autorizacion en SAFI esta Vacio.';
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene los datos requeditos para realizar el alta de la bitacora de operacion
		CASE WHEN Var_OperacionID IN (Con_CheckIn,	 Con_ReCheckIn, Con_CheckOut,
									  Con_CompraPos, Con_RetiroATM, Con_VentaGenericaATM,
									  Con_ConsultaSaldoCom) THEN
				SET Var_Naturaleza := Nat_Cargo;
			 WHEN Var_OperacionID IN (Con_ReversaCheckIn,	Con_Devolucion,			Con_Ajuste,
									  Con_ReversaCompra,	Con_ReversaTotalRetiro,	Con_ReversaParcialRetiro,
									  Con_ReversaConsulta) THEN
				SET Var_Naturaleza := Nat_Abono;
			 WHEN Var_OperacionID IN (Con_ConsultaSaldoATM) THEN
				SET Var_Naturaleza := Cadena_Vacia;
		END CASE;

		-- Se ajusta la operacion en Linea si el Producto indicador es POR
		SET Var_TransLinea := Con_NO;
		IF( Par_ProdIndicator = Prod_POS ) THEN
			SET Var_TransLinea := Con_SI;
		END IF;

		SET Var_TransLinea := IFNULL(Var_TransLinea, POSEnLineaSI);

		-- Si la operacion es check In o Re Check In la asignamos el tipo chec IN para la validacion de una reversa
		SET Var_EsCheckIn := Con_NO;
		IF( Var_OperacionID IN (Con_CheckIn, Con_ReCheckIn) ) THEN
			SET Var_EsCheckIn := Con_SI;
		END IF;

		-- Si la Operacion es una Reversa se reasigna la Referencia de la Bitacora
		SET Var_Reference := Par_Reference;
		IF( Var_OperacionID IN (Con_ReversaCheckIn, Con_ReversaCompra, Con_ReversaTotalRetiro, Con_ReversaParcialRetiro, Con_ReversaConsulta) ) THEN
			SET Var_Reference := Par_ReferenceTransaction;
		END IF;

		-- Se asigna la constante es Reversa para control de Bitacora
		SET Var_EsReversa	:= Con_NO;
		IF( Var_OperacionID IN (Con_ReversaCheckIn, Con_Devolucion, Con_ReversaCompra, Con_ReversaTotalRetiro, Con_ReversaParcialRetiro, Con_ReversaConsulta) ) THEN
			SET Var_EsReversa := Con_SI;
		END IF;

		-- Se registra la operacion en la bitacora de transacciones
		CALL TC_BITACORAMOVSALT (
			Origen_WebService,		Con_TranATMPOS,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
			Par_CashbackAmount,		Par_SurchargeAmounts,	Entero_Cero,			Par_AdditionalAmount,	Con_CodigoMexNum,
			Var_MontoOperacionMx,	Var_MontoCashBackMx,	Var_MontoComisionMx,	Entero_Cero,			Var_AdditionalAmountMx,
			Var_FechaAplicacion,	Var_Hora,				Par_MerchantType,		Var_IRD,				Par_TerminalName,
			Var_Ciudad,				Var_Pais,				Var_Reference,			Var_DatosTiempoAire,	Par_CodigoTransaccionID,
			Var_TransLinea,			Var_EsCheckIn,			Var_Naturaleza,			Var_ValorDivisa,		Var_TarCredMovID,
			Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_NumErr	:= 1213;
			SET Var_ErrMen	:= CONCAT('TC_BITACORAMOVSALT - ',Par_ErrMen);
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			LEAVE ManejoErrores;
		END IF;

		-- Si la operacion es compra post o por check out el monto total es la suma de los cuatro parametros de compra
		IF( Var_OperacionID IN (Con_CheckOut, Con_CompraPos) ) THEN
			SET Var_TotalCompra := Par_TransactionAmount + Par_CashbackAmount + Par_AdditionalAmount + Par_SurchargeAmounts;
		END IF;

		-- Se realizan las operaciones ATM o POS
		CASE Var_OperacionID

			WHEN Con_CheckIn THEN
				

				CALL TC_BLOQUEOSPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Var_TarCredMovID,		Con_CheckIn,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_BLOQUEOSPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReCheckIn THEN
				-- Se realiza la operacion de Re Check IN

				CALL TC_BLOQUEOSPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Var_TarCredMovID,		Con_ReCheckIn,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_BLOQUEOSPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_CheckOut THEN
				-- Se realiza la operacion de Check OUT

				CALL TC_BLOQUEOSPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Var_TarCredMovID,		Con_CheckOut,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_BLOQUEOSPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

				CALL TC_COMPRANORMALRPRO (
					Par_TranCode,			Par_CardNumber,			Par_Reference,			Var_TotalCompra,		Entero_Cero,
					Entero_Cero,			Par_MerchantType,		Con_MonedaMexico,		Aud_NumTransaccion,		Var_TransLinea,
					Var_FechaAplicacion,	Origen_WebService,		Par_TerminalName,		Var_NumTransaccion,		Var_SaldoContableAct,
					Var_SaldoDisponibleAct,	Var_CodigoRespuesta,	Var_FechaOperacion,		Var_TarCredMovID,		Par_AuthorizationNumber,
					Entero_Cero,
					Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_COMPRANORMALRPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReversaCheckIn THEN
				-- Se realiza de Reversa de Check In

				CALL TC_BLOQUEOSPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,			Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_ApplicationDate,	Par_MerchantType,
					Par_ReferenceTransaction,	Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,			Par_CodigoTransaccionID,	Var_TarCredMovID,		Con_ReversaCheckIn,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_BLOQUEOSPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_CompraPos THEN
				-- Se realiza de Compra Pos

				CALL TC_COMPRANORMALRPRO(
					Par_TranCode,			Par_CardNumber,			Par_Reference,		Var_TotalCompra,	Entero_Cero,
					Entero_Cero,			Par_MerchantType,		Con_MonedaMexico,	Aud_NumTransaccion,	Var_TransLinea,
					Var_FechaAplicacion,	Origen_WebService,		Par_TerminalName,	Var_NumTransaccion,	Var_SaldoContableAct,
					Var_SaldoDisponibleAct,	Var_CodigoRespuesta,	Var_FechaOperacion,	Var_TarCredMovID,	Par_CodigoTransaccionID,
					Entero_Cero,
					Salida_NO,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_COMPRANORMALRPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_Devolucion THEN
				-- Se realiza la Devolucion del efectivo

				CALL TC_DEVOLUCIONPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Con_MonedaMexico,		Var_FolioDevolucionID,	Var_TarCredMovID,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_DEVOLUCIONPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_Ajuste THEN
				-- Se realiza el Ajuste de una Compra

				CALL TC_AJUSTEPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Con_MonedaMexico,		Var_FolioDevolucionID,	Var_TarCredMovID,
					Var_TransLinea,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_AJUSTEPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReversaCompra THEN
				-- Se realiza el Reversa de Compra de Pos

				CALL TC_REVERSACOMPRAPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_AuthorizationNumber,	Par_ReferenceTransaction,	Par_ApplicationDate,	Par_AmountDispensed,	Par_CodigoTransaccionID,
					Con_MonedaMexico,			Var_TarCredMovID,			Var_FolioDevolucionID,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_REVERSACOMPRAPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_RetiroATM THEN
				-- Se realiza el Retiro de ATM

				CALL TC_RETIROATMPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName, 		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Con_MonedaMexico,		Var_TarCredMovID,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_RETIROATMPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReversaTotalRetiro THEN
				-- Se Realiza la Reversa Total del Retiro ATM

				CALL TC_REVERSARETIROATMPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_AuthorizationNumber,	Par_ReferenceTransaction,	Par_ApplicationDate,	Par_AmountDispensed,	Par_CodigoTransaccionID,
					Con_MonedaMexico,			Var_TarCredMovID,			Var_FolioDevolucionID,	Con_ReversaParcialNO,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_REVERSARETIROATMPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReversaParcialRetiro THEN
				-- Se Realiza la Reversa Parcial del Retiro ATM

				CALL TC_REVERSARETIROATMPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_AuthorizationNumber,	Par_ReferenceTransaction,	Par_ApplicationDate,	Par_AmountDispensed,	Par_CodigoTransaccionID,
					Con_MonedaMexico,			Var_TarCredMovID,			Var_FolioDevolucionID,	Con_ReversaParcialSI,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_REVERSARETIROATMPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_VentaGenericaATM THEN
				-- Se realiza la consulta de Saldo

				CALL TC_VENTAGENERICAATMPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,			Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,				Par_TerminalID,				Par_TerminalName,		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,			Par_CodigoTransaccionID,	Con_MonedaMexico,		Var_TarCredMovID,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_VENTAGENERICAATMPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ConsultaSaldoATM THEN
				-- Se realiza la consulta de Saldo

				CALL TARJETACREDITOACT (
					Par_CardNumber,		Entero_Cero,		Nat_Cargo,		Act_MovConsulta,
					Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TARJETACREDITOACT - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ConsultaSaldoCom THEN
				-- Se Realiza la Consulta de Saldo con Cobro de Comision

				CALL TC_CONSULTACOMISIONPRO (
					Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,	Par_TransactionDate,	Par_MerchantType,
					Par_Reference,			Par_TerminalID,				Par_TerminalName, 		Par_TerminalLocation,	Par_AuthorizationNumber,
					Par_DraftCapture,		Par_CodigoTransaccionID,	Con_MonedaMexico,		Var_TarCredMovID,
					Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_CONSULTACOMISIONPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

			WHEN Con_ReversaConsulta THEN
				-- Se Realiza la Reversa de la Consulta de Saldo con Cobro de Comision

				CALL TC_REVCONSULTACOMISIONPRO (
					Par_NumberTransaction,		Par_ProdIndicator,			Par_TranCode,			Par_CardNumber,			Par_TransactionAmount,
					Par_AuthorizationNumber,	Par_ReferenceTransaction,	Par_ApplicationDate,	Par_AmountDispensed,	Par_CodigoTransaccionID,
					Con_MonedaMexico,			Var_TarCredMovID,			Var_FolioDevolucionID,
					Salida_NO,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					SET Var_NumErr	:= Par_NumErr;
					SET Var_ErrMen	:= CONCAT('TC_REVCONSULTACOMISIONPRO - ',Par_ErrMen);
					SET Par_NumErr	:= 12;
					SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
					LEAVE ManejoErrores;
				END IF;

		END CASE;

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT 	IFNULL(SaldoCapVigente,Decimal_Cero) + IFNULL(SalOrtrasComis,Decimal_Cero),
				IFNULL(MontoDisponible, Decimal_Cero)
		INTO 	Var_Balance,
				Var_BalanceAvailable
		FROM LINEATARJETACRED
		WHERE LineaTarCredID = Var_LineaTarCredID;

		SET Var_Fecha		:= (CONCAT(DATE(Var_FechaAplicacion),' ',CONVERT(CURTIME(),CHAR(8))));
		SET Var_FechaHora	:= (SELECT CAST(Var_Fecha AS DATETIME));
		SET Var_FolioDevolucionID := IFNULL(Var_FolioDevolucionID, Entero_Cero);

		-- Respaldo de la Operacion
		CALL TC_BITACORAOPERACIONALT (
			Var_RespaldoID,			Con_TranATMPOS,				Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,
			Par_CardNumber,			Par_TransactionAmount,		Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,
			Par_TransactionDate,	Par_MerchantType,			Par_Reference,			Par_TerminalID,				Par_TerminalName,
			Par_TerminalLocation,	Par_AuthorizationNumber,	Par_DraftCapture,		Par_ReferenceTransaction,	Par_ApplicationDate,
			Par_AmountDispensed,	Par_CodigoTransaccionID,	Var_FechaHora,			Aud_NumTransaccion,			Var_Balance,
			Var_BalanceAvailable,	Var_FolioDevolucionID,		Var_EsCheckIn,			Var_EsReversa,
			Salida_NO,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_NumErr	:= Par_NumErr;
			SET Var_ErrMen	:= CONCAT('TC_BITACORAOPERACIONALT - ',Par_ErrMen);
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
			LEAVE ManejoErrores;
		END IF;

		-- Mensaje de Salida
		SET Var_NumErr := Entero_Cero;
		SET Var_ErrMen := CONCAT('Operacion realizada correctamente: ',Par_CodigoTransaccionID,'.');
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := FNCATCODRESPROSA(LPAD(Par_NumErr,2,'0'), Par_ProdIndicator);

	END ManejoErrores;

	IF (Par_NumErr != Entero_Cero) THEN
		SET Par_CodigoTransaccionID	:= Codigo_Vacio;
		SET Var_Balance 			:= Var_BalanceOri;
		SET Var_BalanceAvailable	:= Var_BalanceAvailableOri;
		SET Var_FechaHora			:= (SELECT CAST((CONCAT(DATE(Var_FechaAplicacion),' ',CONVERT(CURTIME(),CHAR(8)))) AS DATETIME));
	END IF;

	IF Par_Salida = Salida_SI THEN
		SELECT 	Par_NumberTransaction AS NumberTransaction,
				LPAD(Par_NumErr,2,'0') AS ResponseCode,
				Par_ErrMen AS ResponseMessage,
				Var_Balance AS Balance,
				Var_BalanceAvailable AS BalanceAvailable,
				Var_FechaAplicacion AS ApplicationDate,
				Par_CodigoTransaccionID AS AuthorizationNumber,
				CONVERT(Var_FechaHora, CHAR) AS Fecha,
				Var_NumErr AS NumErr,
				Var_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
