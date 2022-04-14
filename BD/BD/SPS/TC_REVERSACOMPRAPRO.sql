-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_REVERSACOMPRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_REVERSACOMPRAPRO`;

DELIMITER $$
CREATE PROCEDURE `TC_REVERSACOMPRAPRO`(
	-- Store Procedure de Reversa Compra Pos Para tarjetas de credito por medio de Web Service
	-- Tarjetas de Credito --> Web Service
	Par_NumberTransaction			CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator				CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode					CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber					CHAR(16),		-- Numero de Tarjeta de Credito
	Par_TransactionAmount			DECIMAL(12,2),	-- Monto en pesos de la transaccion

	Par_AuthorizationNumber			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(PROSA))
	Par_ReferenceTransaction		CHAR(12),		-- Referencia de la operacion original
	Par_ApplicationDate				DATETIME,		-- Fecha de Aplicacion de la reversa
	Par_AmountDispensed				DECIMAL(12,2),	-- Para reversar parciales de ATM
	Par_CodigoTransaccionID			CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.(SAFI))

	Par_MonedaID					INT(11),		-- Codigo de Moneda
	Par_TarCredMovID				INT(11),		-- ID del movimiento de tarjeta
	INOUT Par_FolioDevolucionID		BIGINT(20),		-- ID de Respaldo de Informacion(Usado en la operacion de Ajuste )

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
	DECLARE Var_BloquearATM			CHAR(1);			-- Valor bloqueo: ATM
	DECLARE Var_EstatusLinea		CHAR(1);			-- Estatus de la linea R: Registrada, V: Vigente, B: Bloqueada, C: Cancelada
	DECLARE Var_Clasificacion		CHAR(1);			-- Clasificacion del Producto de Credito
	DECLARE Var_BloquearCashBack	CHAR(1);			-- Valor bloqueo: CasBack

	DECLARE Var_BloquearPos			CHAR(1);			-- Valor bloqueo: POS
	DECLARE Var_TarjetaCreditoID	CHAR(16);			-- Numero de Tarjeta de Credito
	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal de cliente
	DECLARE Var_ClienteID			INT(11);			-- Valor del numero de cliente
	DECLARE Var_TipoTarjetaDeb		INT(11);			-- Valor del tipo de tarjeta

	DECLARE Var_ProductoCreditoID	INT(11);			-- Numero de Producto de Credito
	DECLARE Var_TarCredMovID		INT(11);			-- ID del movimiento de tarjeta
	DECLARE Var_EstatusTarjeta		INT(11);			-- Estatus de la Tarjeta corresponde con tabla ESTATUSTD
	DECLARE Var_LineaTarCredID		INT(20);			-- Identificador de la Linea de Credito
	DECLARE Var_PolizaID			BIGINT(20);			-- ID de Poliza Contable

	DECLARE Var_Consecutivo			BIGINT(20);			-- ID de Consecutivo
	DECLARE Var_Referencia			VARCHAR(50);		-- Valor del numero de tarjeta
	DECLARE Var_Control				VARCHAR(100);		-- Control de Retorno en Pantalla
	DECLARE Var_DesPoliza			VARCHAR(150);		-- Descripcion por Rertiro con tarjeta
	DECLARE Var_MontoDisponible		DECIMAL(12,2);		-- Monto Disponible de la Linea

	DECLARE Var_MontoLinea			DECIMAL(12,2);		-- Monto de la Linea
	DECLARE Var_MontoReversa		DECIMAL(12,2);		-- Monto de Reversa
	DECLARE Var_CashbackAmount		DECIMAL(12,2);		-- Monto de Cashback

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
	DECLARE BloqPOS_SI				CHAR(1);			-- Constante Bloqueo Pos SI

	DECLARE BloqPOS_NO				CHAR(1);			-- Constante Bloqueo Pos NO
	DECLARE BloqCashBack_SI			CHAR(1);			-- Constante Bloqueo CashBack SI
	DECLARE BloqCashBack_NO			CHAR(1);			-- Constante Bloqueo CashBack NO
	DECLARE Con_ReversaParcialSI	CHAR(1);			-- Constante es Reversal Parcial SI
	DECLARE Con_ReversaParcialNO	CHAR(1);			-- Constante es Reversal Parcial NO

	DECLARE Con_DraftCapture		CHAR(1);			-- Constante DraftCapture Autorizado
	DECLARE Prod_POS				CHAR(2);			-- Constante Indicador de Producto 02 - POS
	DECLARE Code_Preautorizacion 	CHAR(2);			-- Constante 00 ISO = Normal Purchase, Preauthorization purchase1
	DECLARE Con_SubClasificacion	CHAR(3);			-- Constante Subclasificacion de Producto
	DECLARE Entero_Cero				INT(11);			-- Constante Entero Cero

	DECLARE Entero_Uno				INT(11);			-- Constante Entero Uno
	DECLARE Con_CapitalVigente		INT(11);			-- Constante Concepto Contable Vigente
	DECLARE Mov_CapOrdinario		INT(11);			-- Constante Movimiento de Capital Ordinario
	DECLARE Con_BloqATM				INT(11);			-- Constante Consulta para obtener si se bloquea ATM
	DECLARE Con_OperacATM			INT(11);			-- Constante Concepto operacion: ATM

	DECLARE Con_DispoDiario			INT(11);			-- Constante Consulta para obtener el limite de monto diario para disposicion
	DECLARE Con_DispoMes			INT(11);			-- Constante Consulta para obtener el limite de monto mensual para disposicion
	DECLARE Con_BloqPOS				INT(11);			-- Constante Consulta para obtener si se bloquea POS
	DECLARE Con_BloqCashBack		INT(11);			-- Constante Consulta para obtener si se bloquea CashBack
	DECLARE Con_TarjetaActiva		INT(11);			-- Constante Estatus Activo de Tarjetas

	DECLARE LongitudTarjeta			INT(11);			-- Constante Longitud Tarjeta
	DECLARE ConConta_TarCred		INT(11);			-- Constante Concepto Contable Tarjeta de Credito
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Constante Decimal Cero
	DECLARE FechaHora_Vacia			DATETIME;			-- Constante Fecha Hora Vacia

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
	SET BloqPOS_SI				:= 'S';

	SET BloqPOS_NO				:= 'N';
	SET BloqCashBack_SI			:= 'S';
	SET BloqCashBack_NO			:= 'N';
	SET Con_ReversaParcialSI	:= 'S';
	SET Con_ReversaParcialNO	:= 'N';

	SET Con_DraftCapture		:= '1';
	SET Prod_POS				:= '02';
	SET Code_Preautorizacion	:= '00';
	SET Con_SubClasificacion	:= '201';
	SET Entero_Cero				:= 0;

	SET Entero_Uno				:= 1;
	SET Con_BloqATM				:= 1;
	SET Con_CapitalVigente		:= 1;
	SET Mov_CapOrdinario		:= 1;
	SET Con_OperacATM			:= 1;

	SET Con_DispoDiario			:= 1;
	SET Con_DispoMes			:= 2;
	SET Con_BloqPOS				:= 2;
	SET Con_BloqCashBack		:= 3;
	SET Con_TarjetaActiva		:= 7;

	SET LongitudTarjeta			:= 16;
	SET ConConta_TarCred		:= 1100;
	SET Decimal_Cero			:= 0.00;
	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

	-- Asignacion de Actualizaciones
	SET Act_Procesado			:= 1;
	SET Act_MovCompra			:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 				'esto le ocasiona. Ref: SP-TC_REVERSACOMPRAPRO');
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
		SET Par_TarCredMovID		:= IFNULL(Par_TarCredMovID, Entero_Cero);
		SET Par_FolioDevolucionID	:= Entero_Cero;

		-- Asigaciones de Variables
		SET Var_FechaAplicacion 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Aud_FechaActual 		:= NOW();

		SELECT 	LineaTarCredID,		TipoTarjetaCredID,	ClienteID,		TarjetaCredID,			Estatus,
				IFNULL(TC_FUNCIONLIMITEBLOQ(Tar.TarjetaCredID, Tar.ClienteID, Tar.TipoTarjetaCredID, Con_BloqPOS), Cadena_Vacia),
				IFNULL(TC_FUNCIONLIMITEBLOQ(Tar.TarjetaCredID, Tar.ClienteID, Tar.TipoTarjetaCredID, Con_BloqCashBack), Cadena_Vacia)
		INTO 	Var_LineaTarCredID,	Var_TipoTarjetaDeb,	Var_ClienteID,	Var_TarjetaCreditoID,	Var_EstatusTarjeta,
				Var_BloquearATM,
				Var_BloquearCashBack
		FROM TARJETACREDITO Tar
		WHERE Tar.TarjetaCredID = Par_CardNumber;

		SET Var_LineaTarCredID		:= IFNULL(Var_LineaTarCredID, Entero_Cero);
		SET Var_TipoTarjetaDeb		:= IFNULL(Var_TipoTarjetaDeb, Entero_Cero);
		SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_TarjetaCreditoID	:= IFNULL(Var_TarjetaCreditoID, Cadena_Vacia);
		SET Var_EstatusTarjeta		:= IFNULL(Var_EstatusTarjeta, Entero_Cero);
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

		SET Var_TarCredMovID	:= IFNULL(Var_TarCredMovID, Entero_Cero);
		SET Var_MontoReversa	:= Par_TransactionAmount;

		-- Segmento de Validaciones de la Operacion de Reversa por Retiro Parcial/Total por ATM
		SELECT RespaldoID
		INTO Par_FolioDevolucionID
		FROM TC_BITACORAOPERACION
		WHERE ProdIndicator = Prod_POS
		  AND TranCode = Code_Preautorizacion
		  AND CardNumber = Par_CardNumber
		  AND (TransactionAmount + CashbackAmount + AdditionalAmount + SurchargeAmounts) = Par_TransactionAmount
		  AND Reference = Par_ReferenceTransaction
		  AND DraftCapture = Con_DraftCapture
		  AND CodigoTransaccionID = Par_AuthorizationNumber
		  AND FolioDevolucionID = Entero_Cero
		  AND EsReversa = Con_NO;

		SET Par_FolioDevolucionID := IFNULL(Par_FolioDevolucionID, Entero_Cero);

		SELECT 	CashbackAmount
		INTO 	Var_CashbackAmount
		FROM TC_BITACORAOPERACION
		WHERE RespaldoID = Par_FolioDevolucionID;

		SET Var_CashbackAmount := IFNULL(Var_CashbackAmount, Entero_Cero);

		-- Segmento de Validaciones de la Operacion de Reversa por Compra POS
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
			SET Par_ErrMen	:= 'El Indicador no es Valido para la Operacion de Reversa de Compra POS.';
			SET Var_Control	:= 'prodIndicator';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1204;
			SET Par_ErrMen	:= 'Codigo de transaccion.';
			SET Var_Control	:= 'tranCode';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TranCode <> Code_Preautorizacion ) THEN
			SET Par_NumErr	:= 1205;
			SET Par_ErrMen	:= 'Codigo de transaccion no es Valido para la Operacion de Reversa de Compra POS.';
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

		IF( Par_TransactionAmount = Decimal_Cero ) THEN
			SET Par_NumErr	:= 1309;
			SET Par_ErrMen	:= 'El Monto de la Operacion esta Vacio.';
			SET Var_Control	:= 'transactionAmount';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_AuthorizationNumber = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1210;
			SET Par_ErrMen	:= 'El Numero de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_ReferenceTransaction = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1211;
			SET Par_ErrMen	:= 'La Referencia de la Operacion esta Vacia.';
			SET Var_Control	:= 'referenceTransaction';
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
			SET Par_ErrMen	:= 'El Monto de Reversa no es Valido en la Operacion de Reversa Compra POS.';
			SET Var_Control	:= 'amountDispensed';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_CodigoTransaccionID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1214;
			SET Par_ErrMen	:= 'El Codigo de Autorizacion esta Vacio.';
			SET Var_Control	:= 'authorizationNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarjetaCreditoID = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1415;
			SET Par_ErrMen	:= CONCAT('El Numero de Tarjeta de Credito no Existe: ',Par_CardNumber,'.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusTarjeta <> Con_TarjetaActiva ) THEN
			SET Par_NumErr	:= 1416;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber, ' No esta Activa.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_LineaTarCredID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1217;
			SET Par_ErrMen	:= CONCAT('La Tarjeta de Credito: ',Par_CardNumber,' no cuenta con Linea de Credito.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusLinea <> Est_Vigente ) THEN
			SET Par_NumErr	:= 1218;
			SET Par_ErrMen	:= CONCAT('La Linea de la Credito Asociada a la Tarjeta: ',Par_CardNumber,' no esta activa.');
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TarCredMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1219;
			SET Par_ErrMen	:= 'El Registro de Movimiento de Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TarCredMovID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1220;
			SET Par_ErrMen	:= 'El Numero de Bitacora asociado a la Tarjeta esta Vacio.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FolioDevolucionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1221;
			SET Par_ErrMen	:= 'No Existe una Referencia para la Operacion de Compra.';
			SET Var_Control	:= 'folioDevolucionID';
			LEAVE ManejoErrores;
		END IF;

		IF( (Var_MontoDisponible + Var_MontoReversa) > Var_MontoLinea ) THEN
			SET Par_NumErr	:= 1322;
			SET Par_ErrMen	:= CONCAT('La suma del Monto Disponible y el Monto de Reversa superan al Monto asignado a la Linea de Credito de la Tarjeta.');
			SET Var_Control	:= 'transactionAmount';
			LEAVE ManejoErrores;
		END IF;

		-- Bloqueos por parametros de tarjetas
		IF( Var_BloquearPos = BloqPOS_SI ) THEN
			SET Par_NumErr	:= 1223;
			SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones POS.';
			SET Var_Control	:= 'cardNumber';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_CashbackAmount > Entero_Cero ) THEN
			IF( Var_BloquearCashBack = BloqCashBack_SI ) THEN
				SET Par_NumErr	:= 1224;
				SET Par_ErrMen	:= 'Tarjeta Bloqueada para Operaciones CashBack.';
				SET Var_Control	:= 'cardNumber';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Inicio de Polizas Contables
		SET Var_Referencia	:= CONCAT("TAR **** ", SUBSTRING(Par_CardNumber,13, 4));
		SET Var_DesPoliza	:= CONCAT("REVERSA COMPRA POS ",Var_Referencia);
		SET Var_DesPoliza	:= CONCAT(Var_DesPoliza,' ',Par_ReferenceTransaction);

		SELECT	Tipo AS Clasificacion
		INTO	Var_Clasificacion
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Var_ProductoCreditoID;

		SELECT  SucursalOrigen
		INTO Var_SucursalOrigen
		FROM CLIENTES
		WHERE ClienteID = Var_ClienteID;

		-- Llamada Cargo Cuenta Contable de Cartera
		-- Monto de Operacion
		CALL TC_CONTALINEAPRO (
			Var_LineaTarCredID,		Par_CardNumber,		Var_ClienteID,				Var_FechaAplicacion,	Var_FechaAplicacion,
			Var_MontoReversa,		Par_MonedaID,		Var_ProductoCreditoID,		Var_Clasificacion,		Con_SubClasificacion,
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
			Var_MontoReversa,		Par_MonedaID,		Var_ProductoCreditoID,		Var_Clasificacion,		Con_SubClasificacion,
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

		-- Poliza de Tarjeta por Transaccion ATM
		CALL POLIZATARJETAPRO (
			Var_PolizaID,				Par_EmpresaID,		Var_FechaAplicacion,	Par_CardNumber,		Var_ClienteID,
			Con_OperacATM,				Par_MonedaID,		Var_MontoReversa,		Entero_Cero,		Var_DesPoliza,
			Par_ReferenceTransaction,	Entero_Cero,
			Salida_NO,					Par_NumErr,			Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		-- Actualiza Numero de Compras por Dia, por Mes, y Montos de Compra por Dia y Mes
		CALL TARJETACREDITOACT (
			Par_CardNumber,		Var_MontoReversa,	Nat_Abono,		Act_MovCompra,
			Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		-- Se actualiza la bitacora a procesado
		CALL TC_BITACORAMOVSACT(
			Par_TarCredMovID,	Act_Procesado,
			Salida_NO,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Par_NumErr := 1299;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Reversa ATM realizada Correctamente: ',Par_CodigoTransaccionID,'.');

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CodigoTransaccionID AS AuthorizationNumber;
	END IF;

END TerminaStore$$
