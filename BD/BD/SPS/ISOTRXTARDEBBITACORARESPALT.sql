DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARDEBBITACORARESPALT;
DELIMITER $$

CREATE PROCEDURE ISOTRXTARDEBBITACORARESPALT(
	-- Descripcion: Proceso operativo que realiza el alta de la bitacora de respuesta de tarjetas de debito
	-- Modulo: Procesos de ISOTRX
	Par_NumeroTarjeta			VARCHAR(16),	-- Numero de Tarjeta del SAFI
	Par_TipoMensaje				CHAR(4),		-- Tipo de mensaje, para isotrx 1200
	Par_TipoOperacionID			INT(11),		-- Catalogo CATTIPOPERACIONISOTRX
	Par_FechaHrOpe 				DATETIME,		-- Fecha y hora de la operacion
	Par_MontoTransaccion		DECIMAL(12,2),	-- Monto total de la transacción

	Par_TerminalID 				VARCHAR(50),	-- Para isotrx es Par_NumeroAfiliacion
	Par_Referencia				VARCHAR(12),	-- Numero de la referencia
	Par_NumTransResp			BIGINT(20),		-- Numero de transaccion de respuesta
	Par_SaldoContableAct 		VARCHAR(13),	-- Saldo contable actual
	Par_SaldoDispoAct			VARCHAR(13),	-- Saldo disponible actual

	Par_CodigoRespuesta			VARCHAR(10),	-- Codigo de respuesta
	Par_MensajeRespuesta		VARCHAR(400),	-- Mensaje de respuesta del ws de ISOTRX
	Par_FechaOperacion			VARCHAR(8),		-- Fecha en formato AAAAMMDD
	Par_HoraOperacion			VARCHAR(6),		-- Hora en formato HHMMSS

	Par_Salida					CHAR(1),		-- Especifica salida o no del sp: Si:'S' y No:'N'
	INOUT Par_NumErr			INT(11),		-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de error descripctivo

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)

TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_RespID			INT(11);		-- Identificador del numero de respuesta
	DECLARE Var_Control			VARCHAR(30);	-- Variable de control
	DECLARE Var_FechaRespuesta	DATETIME;		-- Fecha de la respuesta
	DECLARE Var_FechaHraOpe		DATETIME;		-- Fecha de la operacion

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE SalidaSI			CHAR(1);		-- Salida SI

	-- Declaracion de constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET SalidaSI				:= 'S';
	SET Var_FechaRespuesta		:= DATE_FORMAT(NOW(), '%Y-%m-%d %h:%i:%s');

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXTARDEBBITACORARESPALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	-- SE CONVIERTE LA FECHA DE LA OPERACION
	SET Var_FechaHraOpe := STR_TO_DATE( CONCAT(Par_FechaOperacion," ",Par_HoraOperacion), "%Y%m%d %H%i%s");

	CALL FOLIOSAPLICAACT('TARDEBBITACORESP', Var_RespID);

	INSERT INTO TARDEBBITACORESP(
		RespID,					TarjetaDebID,			TipoMensaje,			TipoOperacionID,		FechaOperacion,
		MontoTransaccion,		TerminalID,				Referencia, 			FechaHrRespuesta,		NumTransResp,
		SaldoContableAct,		SaldoDisponibleAct,		CodigoRespuesta,		MensajeRespuesta,		EmpresaID,
		Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
		NumTransaccion
		)
	VALUES(
		Var_RespID,				Par_NumeroTarjeta,		Par_TipoMensaje,		Par_TipoOperacionID, 	Var_FechaHraOpe,
		Par_MontoTransaccion,	Par_TerminalID,			Par_Referencia, 		Var_FechaRespuesta,		Par_NumTransResp,
		Par_SaldoContableAct,	Par_SaldoDispoAct,		Par_CodigoRespuesta, 	Par_MensajeRespuesta,	Par_EmpresaID,
		Aud_Usuario,			Var_FechaRespuesta,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion
		);

	SET	Par_NumErr	:= 0;
	SET Var_Control	:= 'TarjetaDebID';
	SET Par_ErrMen	:= 'Bitacora de Respuesta Registrado de Forma Correcta.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control;
	END IF;

END TerminaStore$$