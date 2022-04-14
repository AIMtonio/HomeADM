DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_REVCONSULTACOMISIONPRO`;
DELIMITER $$

CREATE PROCEDURE `TD_REVCONSULTACOMISIONPRO`(
	-- Store Procedure de Consulta con Comision por ATM Para tarjetas de debito por medio de Web Service
	-- Tarjetas de Debito --> Web Service
	Par_NumberTransaction			CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator				CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode					CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Debito
	Par_TransactionAmount			DECIMAL(12,2),	-- Monto en pesos de la transaccion

	Par_AuthorizationNumber			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(PROSA))
	Par_ReferenceTransaction		CHAR(12),		-- Referencia de la operacion original
	Par_ApplicationDate				DATETIME,		-- Fecha de Aplicacion de la reversa
	Par_AmountDispensed				DECIMAL(12,2),	-- Para reversar parciales de ATM
	Par_CodigoTransaccionID			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(SAFI))

	Par_MonedaID					INT(11),		-- Codigo de Moneda
	Par_TarDebMovID					INT(11),		-- ID del movimiento de tarjeta
	INOUT Par_FolioDevolucionID		BIGINT(20),		-- ID de Respaldo de Informacion(Usado en la operacion de Ajuste )

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
	DECLARE Var_BloquearATM			CHAR(1);			-- Valor bloqueo: ATM
	DECLARE Var_EstatusCtaAho		CHAR(1);			-- Estatus de la cta; A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada
	DECLARE Var_TarjetaDebitoID		CHAR(16);			-- Numero de Tarjeta de Debito

	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal de cliente
	DECLARE Var_ClienteID			INT(11);			-- Valor del numero de cliente
	DECLARE Var_TarDebMovID			INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD

	DECLARE Var_CuentaAhoID			INT(20);			-- Identificador de la Cuenta de Ahorro
	DECLARE Var_PolizaID			BIGINT(20);			-- ID de Poliza Contable
	DECLARE Var_Consecutivo			BIGINT(20);			-- ID de Consecutivo
	DECLARE Var_Referencia			VARCHAR(50);		-- Valor del numero de tarjeta
	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla

	DECLARE Var_DesPoliza			VARCHAR(150);		-- Descripcion por compra con tarjeta
	DECLARE Var_MontoDisponible		DECIMAL(12,2);		-- Monto Disponible de la Cuenta

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;				-- Constante Fecha Vacia
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Salida_NO				CHAR(1);			-- Constante Salida SI
	DECLARE Salida_SI				CHAR(1);			-- Constante Salida NO
	DECLARE Con_NO					CHAR(1);			-- Constante SI

	DECLARE Con_SI					CHAR(1);			-- Constante NO
	DECLARE Alta_Enc_Pol_NO			CHAR(1);			-- Constante Alta Encabezado Poliza NO
	DECLARE Alta_Enc_Pol_SI			CHAR(1);			-- Constante Alta Encabezado Poliza SI
	DECLARE AltaPol_NO				CHAR(1);			-- Constante Alta Poliza NO
	DECLARE AltaPol_SI				CHAR(1);			-- Constante Alta Poliza SI

	DECLARE AltaMov_SI				CHAR(1);			-- Constante Alta Movimiento SI
	DECLARE AltaMovBitacoraNO		CHAR(1);			-- Constante Alta Movimiento Bitacora NO

	DECLARE AltaMovBitacoraSI		CHAR(1);			-- Constante Alta Movimiento Bitacora SI
	DECLARE Nat_Cargo				CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Est_Activa				CHAR(1);			-- Constante Estatus Activa de la Cuenta de Ahorro de la Tarjeta
	DECLARE BloqATM_SI				CHAR(1);			-- Constante Bloqueo ATM

	DECLARE BloqATM_NO				CHAR(1);			-- Constante Bloqueo ATM NO
	DECLARE Prod_ATM 				CHAR(2);			-- Constante Indicador de Producto 01 - ATM
	DECLARE Code_Consulta			CHAR(2);			-- Constante 31 ISO= Consulta de Saldos (Corresponsales Bancarios)
	DECLARE Con_SubClasificacion	CHAR(3);			-- Constante Subclasificacion de Producto
	DECLARE Con_GiroATM				CHAR(4);			-- Constante Giro Generico ATM

	DECLARE Entero_MenosUno			INT(11);			-- Constante Entero Menos Uno
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno
	DECLARE Mov_CapOrdinario		INT(11);			-- Constante Movimiento de Capital Ordinario
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

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Con_NO					:= 'N';

	SET Con_SI					:= 'S';
	SET Alta_Enc_Pol_NO			:= 'N';
	SET Alta_Enc_Pol_SI			:= 'S';
	SET AltaPol_NO				:= 'N';
	SET AltaPol_SI				:= 'S';

	SET AltaMov_SI				:= 'S';
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
	SET Mov_CapOrdinario		:= 94;

	SET Con_OperacATM			:= 1;
	SET Con_DispoDiario			:= 1;
	SET Con_DispoMes			:= 2;
	SET Con_TarjetaActiva		:= 7;
	SET LongitudTarjeta			:= 16;

	SET Mov_ComisionDisp		:= 53;
	SET ConConta_TarDeb			:= 300;
	SET Decimal_Cero			:= 0.00;
	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

	-- Asignacion de Actualizaciones
	SET Act_Procesado			:= 1;
	SET Act_MovRetiro			:= 2;
	SET Act_MovConsulta			:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_NumCodigoErr = 12;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 				'esto le ocasiona. Ref: SP-TD_REVCONSULTACOMISIONPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Valores Default para los Parametros de Entrada
		SET Par_NumberTransaction	:= IFNULL(Par_NumberTransaction, Cadena_Vacia);
		SET Par_ProdIndicator		:= IFNULL(Par_ProdIndicator, Cadena_Vacia);
		SET Par_TranCode			:= IFNULL(Par_TranCode, Cadena_Vacia);
		SET Par_CardNumber			:= IFNULL(Par_CardNumber, Cadena_Vacia);
		SET Par_TransactionAmount	:= IFNULL(Par_TransactionAmount, Decimal_Cero);

		SET Par_AuthorizationNumber	:= IFNULL(Par_AuthorizationNumber, Cadena_Vacia);
		SET Par_ReferenceTransaction:= IFNULL(Par_ReferenceTransaction, Cadena_Vacia);
		SET Par_ApplicationDate		:= IFNULL(Par_ApplicationDate, NOW());
		SET Par_AmountDispensed		:= IFNULL(Par_AmountDispensed, Decimal_Cero);
		SET Par_CodigoTransaccionID	:= IFNULL(Par_CodigoTransaccionID, Cadena_Vacia);

		SET Par_MonedaID			:= IFNULL(Par_MonedaID, Entero_Uno);
		SET Par_TarDebMovID			:= IFNULL(Par_TarDebMovID, Entero_Cero);
		SET Par_FolioDevolucionID	:= Entero_Cero;

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Aud_FechaActual 		:= NOW();

		SELECT 	CuentaAhoID,		ClienteID,		TarjetaDebID,			Estatus,
				IFNULL(TD_FUNCIONLIMITEBLOQ(Tar.TarjetaDebID, Tar.ClienteID, Tar.TipoTarjetaDebID, Con_BloqATM), Cadena_Vacia)
		INTO 	Var_CuentaAhoID,	Var_ClienteID,	Var_TarjetaDebitoID,	Var_EstatusTarjeta,
				Var_BloquearATM
		FROM TARJETADEBITO Tar
		WHERE Tar.TarjetaDebID = Par_CardNumber;

		SET Var_TarjetaDebitoID		:= IFNULL(Var_TarjetaDebitoID, Cadena_Vacia);
		SET Var_EstatusTarjeta		:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
		SET Var_CuentaAhoID			:= IFNULL(Var_CuentaAhoID, Entero_Cero);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_BloquearATM			:= IFNULL(Var_BloquearATM, BloqATM_NO);

		-- Validacion de la Cuenta de Ahorro
		SELECT	Estatus, 			SaldoDispon
		INTO	Var_EstatusCtaAho,	Var_MontoDisponible
		FROM CUENTASAHO
		WHERE CuentaAhoID = Var_CuentaAhoID;

		SET Var_EstatusCtaAho		:= IFNULL(Var_EstatusCtaAho, Cadena_Vacia);
		SET Var_MontoDisponible		:= IFNULL(Var_MontoDisponible, Entero_Cero);

		-- Validador del ID de Bitacora
		SELECT TarDebMovID
		INTO Var_TarDebMovID
		FROM TARDEBBITACORAMOVS
		WHERE TarDebMovID = Par_TarDebMovID	;

		SET Var_TarDebMovID 	 := IFNULL(Var_TarDebMovID, Entero_Cero);

		-- Se obtiene el numero de Respaldo de la Operacion de acuerdo a los parametros de entrada
		SELECT RespaldoID
		INTO Par_FolioDevolucionID
		FROM TD_BITACORAOPERACION
		WHERE ProdIndicator = Prod_ATM
		  AND TranCode = Code_Consulta
		  AND CardNumber = Par_CardNumber
		  AND (TransactionAmount + CashbackAmount +AdditionalAmount + SurchargeAmounts) = Par_TransactionAmount
		  AND MerchantType = Con_GiroATM
		  AND Reference = Par_ReferenceTransaction
		  AND DraftCapture = Cadena_Vacia
		  AND CodigoTransaccionID = Par_AuthorizationNumber
		  AND FolioDevolucionID = Entero_Cero
		  AND EsReversa = Con_NO;

		SET Par_FolioDevolucionID := IFNULL(Par_FolioDevolucionID, Entero_Cero);

		-- Segmento de Validaciones de la Operacion de Reversa de Consulta con Comision
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
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Reversa por Consulta con Comision.';
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
			SET Par_ErrMen	:= 'Codigo de transaccion no es Valido para la Operacion de Reversa por Consulta con Comision.';
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

		IF( Par_TransactionAmount = Decimal_Cero ) THEN
			SET Par_NumErr	:= 1309;
			SET Par_ErrMen	:= 'El Monto de la Operacion esta Vacio.';
			SET Var_Control	:= 'transactionAmount';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AuthorizationNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1210;
			SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ReferenceTransaction = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1211;
			SET Par_ErrMen	:= 'La Referencia de la Operacion esta Vacia.';
			SET Var_Control	:= 'referenceTransaction';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ApplicationDate = FechaHora_Vacia ) THEN
			SET Par_NumErr	:= 1212;
			SET Par_ErrMen	:= 'La Fecha de Aplicacion esta Vacia.';
			SET Var_Control	:= 'applicationDate';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AmountDispensed < Decimal_Cero OR Par_AmountDispensed > Decimal_Cero ) THEN
			SET Par_NumErr	:= 1313;
			SET Par_ErrMen	:= 'El Monto de Reversa Parcial no es Valido en la Reversa de Consulta con Comision.';
			SET Var_Control	:= 'amountDispensed';
			SET Par_NumCodigoErr := 13;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Segmento de Validaciones de la Cuenta de Ahorro asociado a la Tarjeta de Debito
		IF( Var_TarjetaDebitoID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1415;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Debito no Existe: ',Par_CardNumber,'.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1416;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CuentaAhoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1217;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Debito: ',Par_CardNumber,' no esta asociado a una cuenta de ahorro.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusCtaAho <> Est_Activa ) THEN
			SET Par_NumErr	:= 1218;
			SET Par_ErrMen	:= CONCAT('La Cuenta de Ahorro Asociado a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 14;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarDebMovID	 = Entero_Cero ) THEN
			SET Par_NumErr	:= 1219;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarDebMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FolioDevolucionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1221;
			SET Par_ErrMen	:= 'No Existe una Referencia para la Operacion de Reversa Consulta Comision.';
			SET Var_Control	:= 'folioDevolucionID';
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Bloqueos por parametros de tarjetas
		IF( Var_BloquearATM = BloqATM_SI ) THEN
			SET Par_NumErr	:= 1223;
			SET Par_ErrMen	:= 'Tarjeta Bloqueada para Consulta ATM.';
			SET Var_Control	:= 'cardNumber';
			SET Par_NumCodigoErr := 62;
			LEAVE ManejoErrores;
		END IF;

		-- Inicio de Polizas Contables
		SET Var_Referencia	:= CONCAT("TAR **** ", SUBSTRING(Par_CardNumber,13, 4));
		SET Var_DesPoliza	:= CONCAT("REVERSA COMISION POR CONSULTA ATM ",Var_Referencia);
		SET Var_DesPoliza	:= CONCAT(Var_DesPoliza,' ',Par_ReferenceTransaction);


		-- Llamada Cargo Cuenta Contable de Cartera
		-- Monto de Operacion
		CALL TD_CONTACTAAHORROPRO (
			Var_CuentaAhoID,		Par_CardNumber,				Var_ClienteID,			Var_FechaAplicacion,	Var_FechaAplicacion,
			Par_TransactionAmount,	Par_MonedaID,				Var_DesPoliza,			Var_Referencia,			Alta_Enc_Pol_SI,
			ConConta_TarDeb,		Var_PolizaID,				AltaPol_SI,				AltaMov_SI,				Mov_CapOrdinario,
			Nat_Abono,				Par_AuthorizationNumber,	AltaMovBitacoraNO,		Cadena_Vacia,			Par_TranCode,
			Salida_NO,				Par_NumErr,					Par_ErrMen,				Var_Consecutivo,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Poliza de Tarjeta por Transaccion ATM
		CALL POLIZATARJETAPRO (
			Var_PolizaID,				Par_EmpresaID,		Var_FechaAplicacion,	Par_CardNumber,			Var_ClienteID,
			Con_OperacATM,				Par_MonedaID,		Par_TransactionAmount,	Entero_Cero,			Var_DesPoliza,
			Par_ReferenceTransaction,	Entero_Cero,
			Salida_NO,					Par_NumErr,			Par_ErrMen,				Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Disposiciones por Dia, por Mes y Montos de Disposicion por Dia y Mes
		CALL TD_TARJETADEBITOACT (
			Par_CardNumber,		Par_TransactionAmount,	Nat_Abono,			Act_MovRetiro,
			Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Consulta por Dia y Mes
		CALL TD_TARJETADEBITOACT (
			Par_CardNumber,		Entero_Cero,		Nat_Abono,			Act_MovConsulta,
			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			SET Par_NumCodigoErr := 12;
			LEAVE ManejoErrores;
		END IF;

		-- Se actualiza la bitacora a procesado
		CALL TARDEBBITACORAMOVSACT(
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
		SET Par_ErrMen := CONCAT('Reversa de Comision por Consulta ATM realizada Correctamente: ',Par_CodigoTransaccionID,'.');

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CodigoTransaccionID AS AuthorizationNumber;
	END IF;

END TerminaStore$$
