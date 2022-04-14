-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ASIGNAOPERACIONCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ASIGNAOPERACIONCAL`;

DELIMITER $$
CREATE PROCEDURE `TC_ASIGNAOPERACIONCAL`(
	-- Store Procedure para la asignacion de Operaciones del Web Service
	-- Modulo Tarjetas Credito --> Web Service
	Par_NumberTransaction		CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator			CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode				CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)
	Par_CardNumber				CHAR(16),		-- Numero de Tarjeta de Credito
	Par_TransactionAmount		DECIMAL(12,2),	-- Monto de la Transaccion

	Par_CashbackAmount			DECIMAL(12,2),	-- Montos de CashBack
	Par_AdditionalAmount		DECIMAL(12,2),	-- Montos de Comisiones
	Par_SurchargeAmounts		DECIMAL(12,2),	-- Monto de Recargos, para retiros de Efectivo
	Par_TransactionDate			DATETIME,		-- Fecha y Hora de la operacion
	Par_MerchantType			CHAR(4),		-- Giro del comercio valores aceptados(Catalogo)

	Par_Reference				CHAR(12),		-- Referencia de la operacion
	Par_TerminalID				CHAR(16),		-- ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))
	Par_TerminalName			CHAR(50),		-- Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))
	Par_TerminalLocation		CHAR(50),		-- Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))
	Par_AuthorizationNumber		CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.)

	Par_DraftCapture 			CHAR(1),		-- Indicador de Captura de la transaccion
	-- Inicio Seccion de Reversa
	Par_ReferenceTransaction	CHAR(12),		-- Referencia de la operacion original
	Par_ApplicationDate			DATETIME,		-- Fecha de Aplicacion de la reversa
	Par_AmountDispensed			DECIMAL(12,2),	-- Para reversar parciales de ATM
	-- Fin Seccion de Reversa
	INOUT Par_NumeroOperacion	TINYINT UNSIGNED,-- Numero de Operacion

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- declaracion de variables
	DECLARE Var_EsCheckIn			CHAR(1);		-- Es Operacion por Check IN
	DECLARE Var_Control				VARCHAR(100);	-- Retorno en pantalla
	DECLARE Var_MontoOperacion		DECIMAL(16,2);	-- Monto de la Operacion

	-- declaracion de constantes
	DECLARE Entero_Cero				INT(11);		-- Entero Cero
	DECLARE Entero_Uno				INT(11);		-- Entero Uno
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Cadena_Cero				CHAR(1);		-- Constante Cadena Cero
	DECLARE Cadena_Uno				CHAR(1);		-- Constante Cadena Uno

	DECLARE Salida_SI				CHAR(1);		-- Constante Salida en Pantalla SI
	DECLARE Salida_NO				CHAR(1);		-- Constante Salida en Pantalla NO
	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE Con_SiEsCheckIn			CHAR(1);		-- Constante SI es Check IN

	DECLARE Con_NoEsCheckIn			CHAR(1);		-- Constante NO es Check IN
	DECLARE Code_Preautorizacion	CHAR(2);		-- Constante 00 ISO = Normal Purchase, Preauthorization purchase1
	DECLARE Code_CashAdvance		CHAR(2);		-- Constante 01 ISO = Cash Advance or Withdrawal
	DECLARE Code_DebitAdjustment	CHAR(2);		-- Constante 02 ISO = Debit Adjustment
	DECLARE Code_Returns			CHAR(2);		-- Constante 20 ISO = Returns

	DECLARE Code_Consulta			CHAR(2);		-- Constante 31 ISO= Consulta de Saldos (Corresponsales Bancarios)
	DECLARE Code_PagoServicio		CHAR(2);		-- Constante 65 ISO= Pago de servicios
	DECLARE Prod_ATM 				CHAR(2);		-- Indicador de Producto 01 - ATM
	DECLARE Prod_POS 				CHAR(2);		-- Indicador de Producto 02 - POS
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal Cero

	DECLARE Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE FechaHora_Vacia			DATETIME;		-- Constante Fecha Hora Vacio

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

	DECLARE Con_ReversaParcial		TINYINT UNSIGNED;-- Operacion Reversa Parcial
	DECLARE Con_VentaGenericaATM	TINYINT UNSIGNED;-- Operacion Venta Generica ATM
	DECLARE Con_ConsultaSaldoATM	TINYINT UNSIGNED;-- Operacion Consulta Saldo ATM
	DECLARE Con_ConsultaSaldoCom	TINYINT UNSIGNED;-- Operacion Consulta Saldo con Comision
	DECLARE Con_ReversaConsulta		TINYINT UNSIGNED;-- Operacion Reversa de Consulta Surcharge

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Cadena_Cero				:= '0';
	SET Cadena_Uno				:= '1';

	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO 					:= 'N';
	SET Con_SiEsCheckIn			:= 'S';

	SET Con_NoEsCheckIn			:= 'N';
	SET Prod_ATM				:= '01';
	SET Prod_POS				:= '02';
	SET Code_Preautorizacion	:= '00';
	SET Code_CashAdvance		:= '01';

	SET Code_DebitAdjustment	:= '02';
	SET Code_Returns			:= '20';
	SET Code_Consulta			:= '31';
	SET Code_PagoServicio		:= '65';
	SET Decimal_Cero			:= 0.00;

	SET Fecha_Vacia				:= '1900-01-01';
	SET FechaHora_Vacia			:= '1900-01-01 00:00:00';

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

	SET Con_ReversaParcial		:= 11;
	SET Con_VentaGenericaATM	:= 12;
	SET Con_ConsultaSaldoATM	:= 13;
	SET Con_ConsultaSaldoCom	:= 14;
	SET Con_ReversaConsulta		:= 15;

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_ASIGNAOPERACIONCAL');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

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

		SET Par_DraftCapture		:= IFNULL(Par_DraftCapture, Cadena_Vacia);
		SET Par_ReferenceTransaction:= IFNULL(Par_ReferenceTransaction, Cadena_Vacia);
		SET Par_ApplicationDate		:= IFNULL(Par_ApplicationDate, FechaHora_Vacia);
		SET Par_AmountDispensed		:= IFNULL(Par_AmountDispensed, Decimal_Cero);
		SET Par_NumeroOperacion		:= Entero_Cero;

		SET Var_MontoOperacion		:= Par_TransactionAmount + Par_CashbackAmount + Par_AdditionalAmount + Par_SurchargeAmounts;

		SELECT	EsCheckIn
		INTO	Var_EsCheckIn
		FROM TC_BITACORAOPERACION
		WHERE ProdIndicator = Par_ProdIndicator
		  AND TranCode = Par_TranCode
		  AND CardNumber = Par_CardNumber
		  AND (TransactionAmount + CashbackAmount + AdditionalAmount + SurchargeAmounts) = Var_MontoOperacion
		  AND Reference = Par_ReferenceTransaction
		  AND DraftCapture IN (Cadena_Vacia, Cadena_Cero, Cadena_Uno)
		  AND CodigoTransaccionID = Par_AuthorizationNumber
		  AND FolioDevolucionID = Entero_Cero;

		SET Var_EsCheckIn := IFNULL(Var_EsCheckIn, Con_NoEsCheckIn);

		-- Se realiza un el proceso de bloqueo del monto disponible (Check IN)
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion mayor a cero
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) = Entero_Cero AND
			Par_DraftCapture = Cadena_Cero ) THEN
			SET Par_NumeroOperacion := Con_CheckIn;
		END IF;

		-- Se realiza el proceso y desbloqueo del monto Disponible (ReCheck IN)
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion mayor a cero
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Cero ) THEN
			SET Par_NumeroOperacion := Con_ReCheckIn;
		END IF;

		-- Se realiza el proceso de Desbloqueo para realizar el pago de la operacion (Check OUT)
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion mayor a cero
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Uno ) THEN
			SET Par_NumeroOperacion := Con_CheckOut;
		END IF;

		-- Se realiza el Reversa Check IN
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion mayor a cero
		-- 4.- El DraftCapture es vacio
		-- 5.- La Referencia de transaccion es diferente de vacio
		-- 6.- Hay fecha de Aplicacion
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Vacia AND
			Par_ReferenceTransaction <> Cadena_Vacia AND
			Par_ApplicationDate <> FechaHora_Vacia AND
			Var_EsCheckIn = Con_SiEsCheckIn ) THEN
			SET Par_NumeroOperacion := Con_ReversaCheckIn;
		END IF;

		-- Se realiza el Compra Pos
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion es cero o vacio
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) = Entero_Cero AND
			Par_DraftCapture = Cadena_Uno ) THEN
			SET Par_NumeroOperacion := Con_CompraPos;
		END IF;

		-- Se realiza el Devolucion
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es Returns
		-- 3.- El Numero de Autorizacion es mayor a cero
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Returns AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Uno ) THEN
			SET Par_NumeroOperacion := Con_Devolucion;
		END IF;

		-- Se realiza el Ajuste
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es Debid Adjusment
		-- 3.- El Numero de Autorizacion es mayor a cero
		-- 4.- El DraftCapture es uno
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_DebitAdjustment AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Uno ) THEN
			SET Par_NumeroOperacion := Con_Ajuste;
		END IF;

		-- Se realiza el Reversa de Compra
		-- 1.- El Producto Indicador es POS
		-- 2.- Codigo es PreAutorizacion
		-- 3.- El Numero de Autorizacion mayor a cero
		-- 4.- El DraftCapture es vacio
		-- 5.- La Referencia de transaccion es diferente de vacio
		-- 6.- Hay fecha de Aplicacion
		IF( Par_ProdIndicator = Prod_POS AND
			Par_TranCode = Code_Preautorizacion AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_DraftCapture = Cadena_Vacia AND
			Par_ReferenceTransaction <> Cadena_Vacia AND
			Par_ApplicationDate <> FechaHora_Vacia  AND
			Var_EsCheckIn = Con_NoEsCheckIn ) THEN
			SET Par_NumeroOperacion := Con_ReversaCompra;
		END IF;

		-- Se realiza el Retiro ATM
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Cash Advance or Withdrawal
		-- 3.- El Numero de Autorizacion es vacio o cero
		-- 4.- El DraftCapture es Vacio
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_CashAdvance AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) = Entero_Cero) THEN
			SET Par_NumeroOperacion := Con_RetiroATM;
		END IF;

		-- Se realiza el Retiro ATM
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Cash Advance or Withdrawal
		-- 3.- El Numero de Autorizacion es mayor a cero
		-- 4.- El DraftCapture es Vacio
		-- 5.- La Referencia de transaccion es diferente de vacio
		-- 6.- Hay fecha de Aplicacion
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_CashAdvance AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_ReferenceTransaction <> Cadena_Vacia AND
			Par_ApplicationDate <> FechaHora_Vacia AND
			Par_AmountDispensed = Entero_Cero ) THEN
			SET Par_NumeroOperacion := Con_ReversaTotalRetiro;
		END IF;

		-- Se realiza el Reverso Parcial
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Cash Advance or Withdrawal
		-- 3.- El Numero de Autorizacion es mayor a cero
		-- 4.- El DraftCapture es Vacio
		-- 5.- La Referencia de transaccion es diferente de vacio
		-- 6.- Hay fecha de Aplicacion
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_CashAdvance AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_ReferenceTransaction <> Cadena_Vacia AND
			Par_ApplicationDate <> FechaHora_Vacia AND
			Par_AmountDispensed > Entero_Cero ) THEN
			SET Par_NumeroOperacion := Con_ReversaParcial;
		END IF;

		-- Se realiza Venta Generica ATM
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Pago de Servicio
		-- 3.- El Numero de Autorizacion es vacio o cero
		-- 4.- El DraftCapture es Vacio
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_PagoServicio AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) = Entero_Cero ) THEN
			SET Par_NumeroOperacion := Con_VentaGenericaATM;
		END IF;

		-- Se realiza Consulta de Saldo ATM
		-- 1.- El Producto Indicador es vacio
		-- 2.- Codigo es vacio
		IF( Par_ProdIndicator = Cadena_Vacia AND
			Par_TranCode = Cadena_Vacia ) THEN
			SET Par_NumeroOperacion := Con_ConsultaSaldoATM;
		END  IF;

		-- Se realiza Consulta de Saldo Comision ATM
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Consulta
		-- 3.- El Numero de Autorizacion es vacio o cero
		-- 4.- El DraftCapture es Vacio
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_Consulta AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) = Entero_Cero) THEN
			SET Par_NumeroOperacion := Con_ConsultaSaldoCom;
		END IF;

		-- Se realiza Consulta de Saldo Comision ATM
		-- 1.- El Producto Indicador es ATM
		-- 2.- Codigo es Consulta
		-- 3.- El Numero de Autorizacion es vacio o cero
		-- 4.- El DraftCapture es Vacio
		IF( Par_ProdIndicator = Prod_ATM AND
			Par_TranCode = Code_Consulta AND
			CAST(Par_AuthorizationNumber AS UNSIGNED INTEGER) > Entero_Cero AND
			Par_ReferenceTransaction <> Cadena_Vacia AND
			Par_ApplicationDate <> FechaHora_Vacia ) THEN
			SET Par_NumeroOperacion := Con_ReversaConsulta;
		END IF;

		SET Par_NumeroOperacion := IFNULL(Par_NumeroOperacion, Entero_Cero);
		SET Par_ErrMen	:= 'Asignacion de operacion Realizada Correctamente.';
		SET Par_NumErr	:= Entero_Cero;
		SET Var_Control	:= 'numeroOperacionID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_NumeroOperacion AS Consecutivo;
	END IF;

END TerminaStore$$
