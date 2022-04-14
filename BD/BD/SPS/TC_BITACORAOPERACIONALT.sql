-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAOPERACIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORAOPERACIONALT`;

DELIMITER $$
CREATE PROCEDURE `TC_BITACORAOPERACIONALT`(
	-- Store Procedura para el Alta de las operaciones de tarjetas de credito por medio de Web Service
	-- Tarjetas de Credito --> Web Service
	INOUT Par_RespaldoID		BIGINT(20),		-- ID de Tabla
	Par_TipoMensaje				CHAR(4),		-- Tipo Mensaje de la Transaccion:\n1200 \n1210 Transacción Normal ATMs y POS\n1220\n1230  Transacción Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transacción Reverso ATMs\n1420\n1430 Transacción Reverso ATMs y POS (Prosa)
	Par_NumberTransaction		CHAR(6),		-- Numero de transaccion generada por la operación.
	Par_ProdIndicator			CHAR(2),		-- Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))
	Par_TranCode				CHAR(2),		-- Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)

	Par_CardNumber				CHAR(16),		-- Numero de Tarjeta de Credito
	Par_TransactionAmount		DECIMAL(12,2),	-- Monto en pesos de la transaccion
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
	Par_ReferenceTransaction	CHAR(12),		-- Referencia de la operacion original
	Par_ApplicationDate			DATETIME,		-- Fecha de Aplicacion de la reversa

	Par_AmountDispensed			DECIMAL(12,2),	-- Para reversar parciales de ATM
	Par_CodigoTransaccionID		CHAR(6),		-- Numero de referencia de autorizacion(limitado a 6 caracteres.)
	Par_FechaHrRespuesta		DATETIME,		-- Fecha y Hora de Respuesta de Transaccion
	Par_NumTransResp			BIGINT(20),		-- Numero de Transaccion generado por el core
	Par_Balance					DECIMAL(12,2),	-- Saldo Contable de la Linea de Crédito

	Par_BalanceAvailable		DECIMAL(12,2),	-- Saldo Disponible de la Linea de Crédito
	Par_FolioDevolucionID		BIGINT(20),		-- ID de Respaldo de Informacion(Usado en la operacion de Devolucion )
	Par_EsCheckIn				CHAR(1),		-- Es una Operacion de Check In o ReCheck In
	Par_EsReversa				CHAR(1),		-- Es una Operacion de Reversa

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- ID de la empresa
	Aud_Usuario					INT(11),		-- Parámetro de auditoría ID del usuario
	Aud_FechaActual				DATETIME,		-- Parámetro de auditoría Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parámetro de auditoría Dirección IP
	Aud_ProgramaID				VARCHAR(50),	-- Parámetro de auditoría Programa
	Aud_Sucursal				INT(11),		-- Parámetro de auditoría ID de la Sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parámetro de auditoría Número de la Transacción
)
TerminaStore: BEGIN

	-- declaracion de variables
	DECLARE Var_Control			VARCHAR(100);	-- Retorno en pantalla
	DECLARE Var_RespaldoID		INT(11);		-- Numero de Respaldo

	-- declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida en Pantalla SI
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida en Pantalla NO
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Cero

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Decimal_Cero			:= 0.00;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_BITACORAOPERACIONALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Valores Default para los Parametros de Entrada
		SET Par_RespaldoID			:= Entero_Cero;
		SET Par_TipoMensaje			:= IFNULL(Par_TipoMensaje, Cadena_Vacia);
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
		SET Par_CodigoTransaccionID	:= IFNULL(Par_CodigoTransaccionID, Cadena_Vacia);
		SET Par_FechaHrRespuesta	:= IFNULL(Par_FechaHrRespuesta, NOW());
		SET Par_NumTransResp		:= IFNULL(Par_NumTransResp, Entero_Cero);
		SET Par_Balance				:= IFNULL(Par_Balance, Decimal_Cero);

		SET Par_BalanceAvailable	:= IFNULL(Par_BalanceAvailable, Decimal_Cero);
		SET Par_FolioDevolucionID	:= IFNULL(Par_FolioDevolucionID, Entero_Cero);
		SET Par_EsCheckIn			:= IFNULL(Par_EsCheckIn, Cadena_Vacia);
		SET Par_EsReversa			:= IFNULL(Par_EsReversa, Cadena_Vacia);

		SET Aud_EmpresaID			:= IFNULL(Aud_EmpresaID, Entero_Cero);
		SET Aud_Usuario				:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Aud_FechaActual			:= IFNULL(Par_FechaHrRespuesta, NOW());
		SET Aud_DireccionIP			:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
		SET Aud_ProgramaID			:= IFNULL(Aud_ProgramaID, Cadena_Vacia);

		SET Aud_Sucursal			:= IFNULL(Aud_Sucursal, Entero_Cero);
		SET Aud_NumTransaccion		:= IFNULL(Aud_NumTransaccion, Entero_Cero);

		-- ID de Tabla
		SET Par_RespaldoID 	:= (SELECT IFNULL(MAX(RespaldoID),Entero_Cero)+1 FROM TC_BITACORAOPERACION FOR UPDATE);

		INSERT INTO TC_BITACORAOPERACION (
			RespaldoID,				TipoMensaje,				NumberTransaction,		ProdIndicator,				TranCode,
			CardNumber,				TransactionAmount,			CashbackAmount,			AdditionalAmount,			SurchargeAmounts,
			TransactionDate,		MerchantType,				Reference,				TerminalID,					TerminalName,
			TerminalLocation,		AuthorizationNumber,		DraftCapture,			ReferenceTransaction,		ApplicationDate,
			AmountDispensed,		CodigoTransaccionID,		FechaHrRespuesta,		NumTransResp,				Balance,
			BalanceAvailable,		FolioDevolucionID,			EsCheckIn,				EsReversa,
			EmpresaID,				Usuario,					FechaActual,			DireccionIP,				ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES (
			Par_RespaldoID,			Par_TipoMensaje,			Par_NumberTransaction,	Par_ProdIndicator,			Par_TranCode,
			Par_CardNumber,			Par_TransactionAmount,		Par_CashbackAmount,		Par_AdditionalAmount,		Par_SurchargeAmounts,
			Par_TransactionDate,	Par_MerchantType,			Par_Reference,			Par_TerminalID,				Par_TerminalName,
			Par_TerminalLocation,	Par_AuthorizationNumber,	Par_DraftCapture,		Par_ReferenceTransaction,	Par_ApplicationDate,
			Par_AmountDispensed,	Par_CodigoTransaccionID,	Par_FechaHrRespuesta,	Par_NumTransResp,			Par_Balance,
			Par_BalanceAvailable,	Entero_Cero,				Par_EsCheckIn,			Par_EsReversa,
			Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		-- Si el Numero de Respaldo es Mayor a Cero se Ajusta el Numero de Operacion a Reversa
		IF( Par_FolioDevolucionID > Entero_Cero ) THEN

			SELECT RespaldoID
			INTO Var_RespaldoID
			FROM TC_BITACORAOPERACION
			WHERE RespaldoID = Par_FolioDevolucionID;

			SET Var_RespaldoID := IFNULL(Var_RespaldoID, Entero_Cero);

			IF( Var_RespaldoID = Entero_Cero) THEN
				SET Par_NumErr:= 1201;
				SET Par_ErrMen:= 'El Numero de Respaldo de Tarjeta de Credito No Existe';
				LEAVE ManejoErrores;
			END IF;

			UPDATE TC_BITACORAOPERACION SET
				FolioDevolucionID = Par_RespaldoID
			WHERE RespaldoID = Par_FolioDevolucionID;

		END IF;


		SET Par_ErrMen	:= CONCAT('Respaldo de Operacion Realizado Correctamente: ',Par_RespaldoID,'.');
		SET Par_NumErr	:= Entero_Cero;
		SET Var_Control	:= 'respaldoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_RespaldoID AS Consecutivo;
	END IF;

END TerminaStore$$