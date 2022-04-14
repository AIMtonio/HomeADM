-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_DEVOLUCIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_DEVOLUCIONPRO`;

DELIMITER $$
CREATE PROCEDURE `TC_DEVOLUCIONPRO`(
	-- Store Procedure de Devolucion de tarjetas de credito por medio de Web Service
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
	Par_CodigoTransaccionID			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(SAFI))
	Par_MonedaID					INT(11),		-- Codigo de Moneda
	INOUT Par_FolioDevolucionID		BIGINT(20),		-- ID de Respaldo de Informacion(Usado en la operacion de Devolucion )
	Par_TarCredMovID				INT(11),		-- ID del movimiento de tarjeta

	Par_Salida						CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr				INT(11),		-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),	-- Mensaje de Error

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
	DECLARE Var_EstatusLinea		CHAR(1);			-- Estatus de la linea R: Registrada, V: Vigente, B: Bloqueada, C: Cancelada
	DECLARE Var_Clasificacion		CHAR(1);			-- Clasificacion del Producto de Credito
	DECLARE Var_BloquearPos			CHAR(1);			-- Valor bloqueo: POS
	DECLARE Var_BloquearCashBack	CHAR(1);			-- Valor bloqueo: CasBack

	DECLARE Var_TarjetaCreditoID	CHAR(16);			-- Numero de Linea de Credito
	DECLARE Var_ClienteID			INT(11);			-- Valor del numero de cliente
	DECLARE Var_ProductoCreditoID	INT(11);			-- Numero de Producto de Credito
	DECLARE Var_TarCredMovID		INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD

	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal de cliente
	DECLARE Var_LineaTarCredID		INT(20);			-- Identificador de la Linea de Credito
	DECLARE Var_Consecutivo			BIGINT(20);			-- ID de Consecutivo
	DECLARE Var_PolizaID			BIGINT(20);			-- ID de Poliza Contable
	DECLARE Var_Referencia			VARCHAR(50);		-- Valor del numero de tarjeta

	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla
	DECLARE Var_DesPoliza			VARCHAR(150);		-- Descripcion por compra con tarjeta
	DECLARE Var_MontoDisponible		DECIMAL(12,2);		-- Monto Disponible de la Linea
	DECLARE Var_MontoLinea			DECIMAL(12,2);		-- Monto de la Linea
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
	DECLARE AltaPolCre_NO			CHAR(1);			-- Constante Alta Poliza Credito NO
	DECLARE AltaPolCre_SI			CHAR(1);			-- Constante Alta Poliza Credito SI

	DECLARE AltaMovLin_NO			CHAR(1);			-- Constante Alta Movimiento Linea NO
	DECLARE AltaMovLin_SI			CHAR(1);			-- Constante Alta Movimiento Linea SI
	DECLARE AltaPolLinCre_NO		CHAR(1);			-- Constante Alta Poliza Linea Credito NO
	DECLARE AltaPolLinCre_SI		CHAR(1);			-- Constante Alta Poliza Linea Credito SI
	DECLARE AltaMovBitacoraNO		CHAR(1);			-- Constante Alta Movimiento Bitacora NO

	DECLARE AltaMovBitacoraSI		CHAR(1);			-- Constante Alta Movimiento Bitacora SI
	DECLARE Nat_Cargo				CHAR(1);			-- Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1);			-- Constante Naturaleza Abono
	DECLARE Est_Vigente				CHAR(1);			
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
	DECLARE ConConta_TarCred		INT(11);			-- Constante Concepto Contable Tarjeta de Credito
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
	SET AltaPolCre_NO			:= 'N';
	SET AltaPolCre_SI			:= 'S';

	SET AltaMovLin_NO			:= 'N';
	SET AltaMovLin_SI			:= 'S';
	SET AltaPolLinCre_NO		:= 'N';
	SET AltaPolLinCre_SI		:= 'S';
	SET AltaMovBitacoraNO		:= 'N';

	SET AltaMovBitacoraSI		:= 'S';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET Est_Vigente				:= 'V';
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
	SET Mov_CapOrdinario		:= 1;
	SET Con_OperacPOS			:= 2;
	SET Con_BloqPOS				:= 2;

	SET Con_BloqCashBack		:= 3;
	SET Con_TarjetaActiva		:= 7;
	SET LongitudTarjeta			:= 16;
	SET ConConta_TarCred		:= 1100;
	SET Decimal_Cero			:= 0.00;

	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

	-- Declaracion de Actualizaciones
	SET Act_Procesado			:= 1;
	SET Act_MovCompra			:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-TC_DEVOLUCIONPRO');
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
		SET Par_TarCredMovID		:= IFNULL(Par_TarCredMovID, Entero_Cero);
		SET Var_TotalDevolucion		:= Par_TransactionAmount + Par_CashbackAmount + Par_AdditionalAmount + Par_SurchargeAmounts;

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Aud_FechaActual 		:= NOW();

		SELECT	TarjetaCredID,			Estatus,			LineaTarCredID,		ClienteID,
				IFNULL(TC_FUNCIONLIMITEBLOQ(Tar.TarjetaCredID, Tar.ClienteID, Tar.TipoTarjetaCredID, Con_BloqPOS), Cadena_Vacia),
				IFNULL(TC_FUNCIONLIMITEBLOQ(Tar.TarjetaCredID, Tar.ClienteID, Tar.TipoTarjetaCredID, Con_BloqCashBack), Cadena_Vacia)
		INTO 	Var_TarjetaCreditoID,	Var_EstatusTarjeta,	Var_LineaTarCredID,	Var_ClienteID,
				Var_BloquearPos,
				Var_BloquearCashBack
		FROM TARJETACREDITO Tar
		WHERE TarjetaCredID = Par_CardNumber;

		SET Var_TarjetaCreditoID	:= IFNULL(Var_TarjetaCreditoID, Cadena_Vacia);
		SET Var_EstatusTarjeta		:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
		SET Var_LineaTarCredID		:= IFNULL(Var_LineaTarCredID, Entero_Cero);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_BloquearPos			:= IFNULL(Var_BloquearPos, BloqPOS_NO);
		SET Var_BloquearCashBack	:= IFNULL(Var_BloquearCashBack, BloqCashBack_NO);

		-- Validacion de la Linea de Credito
		SELECT	Estatus,			ProductoCredID,			MontoDisponible,		MontoLinea
		INTO	Var_EstatusLinea,	Var_ProductoCreditoID,	Var_MontoDisponible,	Var_MontoLinea
		FROM LINEATARJETACRED
		WHERE LineaTarCredID = Var_LineaTarCredID;

		SET Var_EstatusLinea		:= IFNULL(Var_EstatusLinea, Cadena_Vacia);
		SET Var_ProductoCreditoID	:= IFNULL(Var_ProductoCreditoID, Entero_Cero);
		SET Var_MontoDisponible		:= IFNULL(Var_MontoDisponible, Entero_Cero);
		SET Var_MontoLinea			:= IFNULL(Var_MontoLinea, Entero_Cero);

		SELECT TarCredMovID
		INTO Var_TarCredMovID
		FROM TC_BITACORAMOVS
		WHERE TarCredMovID = Par_TarCredMovID;

		SET Var_TarCredMovID 	 := IFNULL(Var_TarCredMovID, Entero_Cero);

		-- Se obtiene el numero de Respaldo de la Operacion de acuerdo a los parametros de entrada
		SELECT RespaldoID,			CashbackAmount
		INTO Par_FolioDevolucionID,	Var_CashbackAmount
		FROM TC_BITACORAOPERACION
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
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProdIndicator = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1202;
			SET Par_ErrMen	:= 'El Indicador de Producto esta Vacio.';
			SET Var_Control	:= 'prodIndicator';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ProdIndicator <> Prod_POS ) THEN
			SET Par_NumErr	:= 1203;
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Ajustes POS.';
			SET Var_Control	:= 'prodIndicator';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1204;
			SET Par_ErrMen	:= 'Codigo de transaccion.';
			SET Var_Control	:= 'tranCode';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode <> Code_Returns ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'Codigo de transaccion no es Valido para la Operacion de Ajustes POS.';
			SET Var_Control	:= 'tranCode';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CardNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1406;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta de Credito esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( CHAR_LENGTH(Par_CardNumber) <> LongitudTarjeta ) THEN
			SET Par_NumErr	:= 1407;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta de Credito esta Incorrecto.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TransactionAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1308;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'transactionAmount';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CashbackAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1309;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'cashbackAmount';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AdditionalAmount < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1310;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'additionalAmount';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_SurchargeAmounts < Decimal_Cero ) THEN
			SET Par_NumErr	:= 1311;
			SET Par_ErrMen	:= 'El Monto de la Operacion no es Valido.';
			SET Var_Control	:= 'surchargeAmounts';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TransactionDate = FechaHora_Vacia ) THEN
			SET Par_NumErr	:= 1313;
			SET Par_ErrMen	:= 'La Fecha de la Operacion esta Vacia.';
			SET Var_Control	:= 'transactionDate';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MerchantType = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= 'El Giro de la Operacion esta Vacio.';
			SET Var_Control	:= 'merchantType';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Reference = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1215;
			SET Par_ErrMen	:= 'La Referencia de Operacion esta Vacia.';
			SET Var_Control	:= 'reference';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1216;
			SET Par_ErrMen	:= 'El Identificador de la Terminal esta Vacio.';
			SET Var_Control	:= 'terminalID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalName = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1217;
			SET Par_ErrMen	:= 'El Nombre de la Terminal esta Vacio.';
			SET Var_Control	:= 'terminalName';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TerminalLocation = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1218;
			SET Par_ErrMen	:= 'La Ubicacion de la Terminal esta Vacia.';
			SET Var_Control	:= 'terminalLocation';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AuthorizationNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1219;
			SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_DraftCapture <> Cadena_Uno ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Valor del DraftCapture no es Valido';
			SET Var_Control	:= 'daftCapture';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1221;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		-- Segmento de Validaciones de la Linea de Credito asociada a la Tarjeta de Credito
		IF( Var_TarjetaCreditoID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1422;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Credito no Existe: ',Par_CardNumber, '.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1423;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_LineaTarCredID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1224;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber,' no cuenta con Linea de Credito.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusLinea != Est_Vigente ) THEN
			SET Par_NumErr	:= 1225;
			SET Par_ErrMen	:= CONCAT('La Linea de la Credito Asociada a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarCredMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1226;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarCredMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1227;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FolioDevolucionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1228;
			SET Par_ErrMen	:= 'No Existe una Referencia para la Operacion de Devolucion.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( (Var_MontoDisponible + Var_TotalDevolucion) > Var_MontoLinea ) THEN
			SET Par_NumErr	:= 1329;
			SET Par_ErrMen	:= 'El Monto Disponible mas el Monto de Devolucion superan el Monto asignado a la Linea de Credito de la Tarjeta.';
			SET Var_Control	:= 'transactionAmount';
			LEAVE ManejoErrores;
		END IF;

		-- Bloqueos por parametros de tarjetas
		IF( Var_BloquearPos = BloqPOS_SI ) THEN
			SET Par_NumErr	:= 1230;
			SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones POS.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CashbackAmount > Decimal_Cero ) THEN
			IF( Var_BloquearCashBack = BloqCashBack_SI ) THEN
				SET Par_NumErr	:= 1231;
				SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones CashBack.';
				SET Var_Control	:= 'cardNumber';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Inicio de Polizas Contables
		SET Var_ClienteID		 := IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_Referencia		 := CONCAT("TAR **** ", SUBSTRING(Par_CardNumber,13, 4));
		SET Var_DesPoliza		 := CONCAT("REVERSA ",Var_Referencia);

		SELECT	Tipo AS Clasificacion
		INTO	Var_Clasificacion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Var_ProductoCreditoID;

		SELECT  SucursalOrigen
		INTO Var_SucursalOrigen
		FROM CLIENTES
		WHERE ClienteID = Var_ClienteID;

		-- Registro de Movimiento Operativos para la reversa de operacion
		-- Llamada Abono Cuenta Contable de Cartera
		CALL TC_CONTALINEAPRO (
			Var_LineaTarCredID,		Par_CardNumber,		Var_ClienteID,				Var_FechaAplicacion,	Var_FechaAplicacion,
			Var_TotalDevolucion,	Par_MonedaID,		Var_ProductoCreditoID,		Var_Clasificacion,		Con_SubClasificacion,
			Var_SucursalOrigen,		Var_DesPoliza,		Var_Referencia,				Alta_Enc_Pol_SI,		ConConta_TarCred,
			Var_PolizaID,			AltaPolCre_SI,		AltaPolLinCre_NO,			AltaMovLin_SI,			Con_CapitalVigente,
			Mov_CapOrdinario,		Nat_Abono,			Par_AuthorizationNumber,	AltaMovBitacoraNO,		Cadena_Vacia,
			Par_TranCode,
			Salida_NO,				Par_NumErr,			Par_ErrMen,					Var_Consecutivo,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		-- Llamada a cuenta de Orden
		CALL TC_CONTALINEAPRO (
			Var_LineaTarCredID,		Par_CardNumber,		Var_ClienteID,				Var_FechaAplicacion,	Var_FechaAplicacion,
			Var_TotalDevolucion,	Par_MonedaID,		Var_ProductoCreditoID,		Var_Clasificacion,		Con_SubClasificacion,
			Var_SucursalOrigen,		Var_DesPoliza,		Var_Referencia,				Alta_Enc_Pol_NO,		ConConta_TarCred,
			Var_PolizaID,			AltaPolCre_NO,		AltaPolLinCre_SI,			AltaMovLin_NO,			Entero_Cero,
			Entero_Cero,			Nat_Abono,			Par_AuthorizationNumber,	AltaMovBitacoraNO,		Cadena_Vacia,
			Par_TranCode,
			Salida_NO,				Par_NumErr,			Par_ErrMen,					Var_Consecutivo,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
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
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
		CALL TARJETACREDITOACT (
			Par_CardNumber,		Var_TotalDevolucion,	Nat_Abono,		Act_MovCompra,
			Salida_NO,			Par_NumErr,				Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		-- Se actualiza la bitacora a procesado
		CALL TC_BITACORAMOVSACT (
			Par_TarCredMovID,	Act_Procesado,
			Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Devolucion realizada Correctamente: ',Par_CodigoTransaccionID,'.');

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS ResponseCode,
				Par_ErrMen AS ResponseMessage,
				Par_CodigoTransaccionID AS AuthorizationNumber;
	END IF;

END TerminaStore$$
