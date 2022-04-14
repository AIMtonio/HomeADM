-- TC_TARJETASLIMITESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS TC_TARJETASLIMITESVAL;

DELIMITER $$
CREATE PROCEDURE TC_TARJETASLIMITESVAL(
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

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_OperacionID			TINYINT UNSIGNED;	-- Numero de Operacion
	DECLARE Var_NumErr				INT(11);			-- Numero de Error
	DECLARE Var_ErrMen				VARCHAR(500);		-- Mensaje de Error
	DECLARE Var_NumSubBIN			CHAR(2);			-- Numero del SubBIN
	DECLARE Var_NumBIN 				CHAR(6);			-- Numero de BIN
	DECLARE Var_TipoTarjeta			INT(11);			-- Numero de tipo de tarjata
	DECLARE Var_NoDisposiDia		INT(11);			-- Numero de disposionoes por dia
	DECLARE Var_DisposiDiaNac		DECIMAL(14,2);		-- Mmonto de disposion al dia
	DECLARE Var_ComprasDiaNac		DECIMAL(14,2);		-- Monto maximo para combara al dia
	DECLARE Var_Folio				INT(11);			-- Variable para el folio de dispociones al dia
	DECLARE Var_Control           	VARCHAR(50);	-- Variable de control

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Entero_Cero			INT(11);			-- Constante Entero cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante para decimal cero
	DECLARE Salida_SI			CHAR(1);			-- Constante de salida SI
	DECLARE Salida_NO			CHAR(1);			-- Constante de salida NO
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO

	-- Declaracion de Operaciones
	DECLARE Con_CompraPos			TINYINT UNSIGNED;	-- Operacion Consulta POS
	DECLARE Con_Ajuste				TINYINT UNSIGNED;	-- Operacion Ajuste
	DECLARE Con_RetiroATM			TINYINT UNSIGNED;	-- Operacion Retiro ATM
	DECLARE Con_VentaGenericaATM	TINYINT UNSIGNED;	-- Operacion Venta Generica ATM

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0.00;
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';

	-- Asignacion de Operaciones
	SET Con_CompraPos			:= 5;
	SET Con_Ajuste				:= 7;
	SET Con_RetiroATM			:= 9;
	SET Con_VentaGenericaATM	:= 12;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr	= 12;
			SET Par_ErrMen	= 'Invalid transaction';
			SET Var_NumErr	= 999;
			SET Var_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-TC_TARJETASLIMITESVAL','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
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

		SET Var_NumSubBIN := SUBSTRING(Par_CardNumber,7,2);
		SET Var_NumBIN := SUBSTRING(Par_CardNumber,1,6);

		SELECT TT.TipoTarjetaDebID INTO Var_TipoTarjeta
			FROM TIPOTARJETADEB TT
				INNER JOIN TARBINPARAMS TB ON TB.TarBinParamsID = TT.TarBinParamsID
			WHERE TT.NumSubBIN = Var_NumSubBIN
				AND TB.NumBIN = Var_NumBIN
				LIMIT 1;

		SELECT NoDisposiDia, DisposiDiaNac, ComprasDiaNac
			INTO Var_NoDisposiDia,	Var_DisposiDiaNac,	Var_ComprasDiaNac
			FROM TARDEBLIMITESXTIPO
			WHERE TipoTarjetaDebID = Var_TipoTarjeta
			LIMIT 1;

		IF (Var_OperacionID IN (Con_CompraPos,Con_Ajuste,Con_RetiroATM,Con_VentaGenericaATM))THEN
			CASE Var_OperacionID

				WHEN Con_CompraPos THEN

					IF(Par_TransactionAmount > Var_ComprasDiaNac) THEN
						SET Var_NumErr	:= 4;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
						LEAVE ManejoErrores;
					END IF;

					IF(Par_TransactionAmount > Var_DisposiDiaNac) THEN
						SET Var_NumErr	:= 4;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
						LEAVE ManejoErrores;
					END IF;

				WHEN Con_Ajuste THEN

					IF(Par_TransactionAmount > Var_ComprasDiaNac) THEN
						SET Var_NumErr	:= 7;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
						LEAVE ManejoErrores;
					END IF;

					IF(Par_TransactionAmount > Var_DisposiDiaNac) THEN
						SET Var_NumErr	:= 8;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Par_ProdIndicator);
						LEAVE ManejoErrores;
					END IF;

				WHEN Con_RetiroATM THEN

					SELECT IFNULL(NoDisposiDia,Entero_Cero) INTO Var_Folio FROM TC_TARJETASLIMITES WHERE TarjetaID = Par_CardNumber LIMIT 1;

					IF(Var_Folio >= Var_NoDisposiDia) THEN
						SET Var_NumErr	:= 9;
						SET Var_ErrMen	:= 'Se ha pasado al numero de transacciones disponibles por dia';
						SET Par_NumErr	:= 65;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
						LEAVE ManejoErrores;
					END IF;

					IF(Par_TransactionAmount > Var_ComprasDiaNac) THEN
						SET Var_NumErr	:= 10;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
						LEAVE ManejoErrores;
					END IF;

					IF(Par_TransactionAmount > Var_DisposiDiaNac) THEN
						SET Var_NumErr	:= 11;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
						LEAVE ManejoErrores;
					END IF;

					CALL TC_TARJETASLIMITESPRO(Par_CardNumber, Var_Folio);

				WHEN Con_VentaGenericaATM THEN

					SELECT IFNULL(NoDisposiDia,Entero_Cero) INTO Var_Folio FROM TC_TARJETASLIMITES WHERE TarjetaID = Par_CardNumber LIMIT 1;

					IF(Var_Folio >= Var_NoDisposiDia) THEN
						SET Var_NumErr	:= 12;
						SET Var_ErrMen	:= 'Se ha pasado al numero de transacciones disponibles por dia';
						SET Par_NumErr	:= 65;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
						LEAVE ManejoErrores;
					END IF;

					IF(Par_TransactionAmount > Var_ComprasDiaNac) THEN
						SET Var_NumErr	:= 10;
						SET Var_ErrMen	:= 'El monto es mayor a lo permitido por dia';
						SET Par_NumErr	:= 61;
						SET Par_ErrMen	:= FNCATCODRESPROSA(Par_NumErr, Entero_Cero);
						LEAVE ManejoErrores;
					END IF;

					CALL TC_TARJETASLIMITESPRO(Par_CardNumber, Var_Folio);

			END CASE;
		END IF;

		-- Mensaje de Salida
		SET Var_NumErr := Entero_Cero;
		SET Var_ErrMen := 'Operacion realizada correctamente.';
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := FNCATCODRESPROSA(LPAD(Par_NumErr,2,'0'), Par_ProdIndicator);

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	LPAD(Par_NumErr,2,'0') AS ResponseCode,
				Par_ErrMen AS ResponseMessage,
				Var_NumErr AS NumErr,
				Var_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
