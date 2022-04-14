-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLRESPPAGOSERVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLRESPPAGOSERVALT`;DELIMITER $$

CREATE PROCEDURE `PSLRESPPAGOSERVALT`(
	-- Stored procedure para dar de alta la respuesta del WS del proveedor de servicios al realizar compra de tiempo aire y pago de servicios
	Par_CobroID 			BIGINT(20), 	-- ID del Cobro de Servicios en Linea
	Par_CodigoRespuesta		VARCHAR(10),	-- Codigo de respuesta del WS consumido
	Par_MensajeRespuesta	VARCHAR(2000),	-- Mensaje de respuesta del WS consumido
	Par_NumTransaccionP		VARCHAR(20),	-- Identificador de la transaccion del proveedor
	Par_NumAutorizacion		BIGINT(20),		-- Numero de autorizacion
	Par_Monto				DECIMAL(14,2),	-- Monto a pagar, solo para pago de servicios
	Par_Comision			DECIMAL(14,2),	-- Comision generada por la transaccion
	Par_Referencia 			VARCHAR(70), 	-- Referencia alfanumerica indicando en el recibo del servicio a pagar
	Par_SaldoRecarga		DECIMAL(14,2),	-- Saldo actual del distribuidor
	Par_SaldoServicio		DECIMAL(14,2),	-- Saldo actual del distribuidor

	Par_Salida				CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID 			INT(11), 		-- Parametros de auditoria
	Aud_Usuario				INT(11),		-- Parametros de auditoria
	Aud_FechaActual			DATETIME,		-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametros de auditoria
	Aud_Sucursal 			INT(11), 		-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_CobroID 			BIGINT(20); 			-- ID de cobro

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(14,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE Var_SalidaSI			CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no

	-- Valores por default
	SET Par_CobroID 				:= IFNULL(Par_CobroID, Decimal_Cero);
	SET Par_CodigoRespuesta 		:= IFNULL(Par_CodigoRespuesta, Cadena_Vacia);
	SET Par_MensajeRespuesta 		:= IFNULL(Par_MensajeRespuesta, Cadena_Vacia);
	SET Par_NumTransaccionP 		:= IFNULL(Par_NumTransaccionP, Cadena_Vacia);
	SET Par_NumAutorizacion			:= IFNULL(Par_NumAutorizacion, Entero_Cero);
	SET Par_Monto 					:= IFNULL(Par_Monto, Decimal_Cero);
	SET Par_Comision 				:= IFNULL(Par_Comision, Decimal_Cero);
	SET Par_Referencia				:= IFNULL(Par_Referencia, Cadena_Vacia);
	SET Par_SaldoRecarga 			:= IFNULL(Par_SaldoRecarga, Decimal_Cero);
	SET Par_SaldoServicio 			:= IFNULL(Par_SaldoServicio, Decimal_Cero);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		-- Validaciones
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLRESPPAGOSERVALT');
			SET Var_Control = 'sqlException';
		END;

		IF(Par_CobroID = Decimal_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El ID del Cobro de Servicios en Linea se encuentra vacio.';
			SET Var_Control	:= 'cobroID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CodigoRespuesta = Cadena_Vacia) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El codigo de respuesta esta vacio';
			SET Var_Control	:= 'codigoRespuesta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_MensajeRespuesta = Cadena_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El mensaje de respuesta esta vacio';
			SET Var_Control	:= 'mensajeRespuesta';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Monto < Decimal_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El monto no es valido';
			SET Var_Control	:= 'monto';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Comision < Decimal_Cero) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'La comision no es valida';
			SET Var_Control	:= 'comision';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SaldoRecarga < Decimal_Cero) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'El saldo de la recarga no es valido';
			SET Var_Control	:= 'saldo';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_SaldoServicio < Decimal_Cero) THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'El saldo del servicio no es valido';
			SET Var_Control	:= 'saldoCliente';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO PSLRESPPAGOSERV (	CobroID,			CodigoRespuesta,		MensajeRespuesta,		NumTransaccionP,		NumAutorizacion,
										Monto,				Comision,				Referencia, 			SaldoRecarga,			SaldoServicio,
										EmpresaID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
										Sucursal,			NumTransaccion
							)
							VALUES (	Par_CobroID,		Par_CodigoRespuesta,	Par_MensajeRespuesta,	Par_NumTransaccionP,	Par_NumAutorizacion,
										Par_Monto, 			Par_Comision, 			Par_Referencia, 		Par_SaldoRecarga,		Par_SaldoServicio,
										Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
										Aud_Sucursal,		Aud_NumTransaccion
							);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Respuesta de consumo de WS agregada exitosamente';
		SET Var_Control		:= 'cobroID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_CobroID	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$