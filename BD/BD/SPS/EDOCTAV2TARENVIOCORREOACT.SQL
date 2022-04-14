DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TARENVIOCORREOACT;
DELIMITER $$

CREATE PROCEDURE  EDOCTAV2TARENVIOCORREOACT(
	-- Stored procedure actualizar el estatus de las notificaciones
	Par_EnvioCorreoID			BIGINT,				-- Identificador de la notificacion de correo
	Par_EmailDestino 			VARCHAR(500),		-- Correo electronico donde sera enviado el correo
	Par_Asunto					VARCHAR(100), 		-- Asunto del correo electronico
	Par_Mensaje					VARCHAR(5000),		-- Contenido del correo electronico
	Par_GrupoEmailID			INT,				-- Identificador de la tabla GRUPOSEMAIL en caso que se requiera mandar a varios correos
	Par_EstatusEnvio			CHAR(1),			-- Estus de la notificacion, podra tener los valores N= No enviado P= Proceso E=Enviado F=Fallo C=Caducado
	Par_PIDTarea				VARCHAR(50),		-- Identificador de la tarea
	Par_FechaEnvio				DATETIME,			-- Fecha y hora de envio del correo
	Par_FechaProgramada			DATETIME,			-- Es la fecha con la cual se programa el envio de correo
	Par_FechaVencimiento		DATETIME,			-- Es la fecha con la cual se vence el correo
	Par_DescripcionError		VARCHAR(5000),		-- Es la descripcion por si ocurre un error al momento de enviar el correo
	Par_NumAct					TINYINT,			-- Numero de Actualizacion
	Par_Salida					CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr			INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen			VARCHAR(800),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Aud_EmpresaID 				INT(11), 			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal 				INT(11), 			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control

	-- Declaracion de constantes
	DECLARE CodigoExito			CHAR(6);			-- Codigo de exito
	DECLARE SalidaSI			CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO		CHAR(1);			-- Salida no
	DECLARE Entero_Cero			INT;				-- Entero vacio
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATETIME;			-- Fecha vacia
	DECLARE Decimal_Vacio		DECIMAL(8,2);		-- Decimal vacio
	DECLARE Var_SalidaSI		CHAR(1);			-- Salida si
	DECLARE Act_EstPendiete		TINYINT;			-- Actualizacion de estatus del correo a Proceso
	DECLARE Act_EstFallido		TINYINT;			-- Actualizacion de estatus del correo a fallado
	DECLARE Act_EstEnviado		TINYINT;			-- Actualizacion de estatus del correo a enviado
	DECLARE Act_EstCaducado		TINYINT;			-- Actualizacion de estatus del correo a caducado
	DECLARE Act_DescError		TINYINT;			-- Actualizacion de la descripcion del error
	DECLARE EstProceso		    CHAR(1);			-- Estatus Proceso
	DECLARE EstEnviado			CHAR(1);			-- Estatus Enviado
	DECLARE EstFallado			CHAR(1);			-- Estatus Fallado
	DECLARE EstCaducado			CHAR(1);			-- Estatus Caducado
	DECLARE Est_NoEnviado		CHAR(1);			-- Estatus no enviado

	-- Declaracion de variables
	DECLARE Var_EstatusActual		CHAR(1);			-- Almacena el estatus actual del campo esttausComprobante
	DECLARE Var_EnvioCorreoID		INT;					-- Almacenara el id del correo
	SET Entero_Cero			:= 0;				-- Asignacion de entero vacio
	SET Cadena_Vacia		:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Decimal_Vacio		:= 0.00;			-- Asignacion de decimal vacio
	SET SalidaSI			:= 'S';				-- Asignacion de salida si
	SET Var_SalidaNO		:= 'N';				-- Asignacion de salida no
	SET Act_EstPendiete		:= 1;				-- Asignacion de estatus a Proceso
	SET Act_EstFallido		:= 2;				-- Asignacion de estatus a fallado
	SET Act_EstEnviado		:= 3;				-- Asignacion de estatus a enviado
	SET Act_EstCaducado		:= 4;				-- Asignacion de estatus a caducado
	SET Act_DescError		:= 5;				-- Asignacion de la descripcion del error
	SET EstProceso		    := 'P';				-- Asignacion de valor para el estatus Proceso
	SET EstEnviado			:= 'E';				-- Asignacion de valor para el estatus Enviado
	SET EstFallado			:= 'F';				-- Asignacion de valor para el estatus Fallado
	SET EstCaducado			:= 'C';				-- Asignacion de valor para el estatus Caducado
	SET Est_NoEnviado		:= 'N';				-- Estatus no enviado
	SET Aud_EmpresaID 		:=	IFNULL(Aud_EmpresaID,	Entero_Cero);
	SET Aud_Usuario			:=	IFNULL(Aud_Usuario,	Entero_Cero);
	SET Aud_FechaActual		:=	IFNULL(Aud_FechaActual,	Fecha_Vacia);
	SET Aud_DireccionIP		:=	IFNULL(Aud_DireccionIP,	Cadena_Vacia);
	SET Aud_ProgramaID		:=	IFNULL(Aud_ProgramaID,	Cadena_Vacia);
	SET Aud_Sucursal 		:=	IFNULL(Aud_Sucursal,	Entero_Cero);
	SET Aud_NumTransaccion	:=	IFNULL(Aud_NumTransaccion,	Entero_Cero);

	ManejoErrores:BEGIN

 			-- Actualizacion para cambiar el estatus a proceso
			IF (Par_NumAct = Act_EstPendiete)THEN
					UPDATE	EDOCTAV2TARENVIOCORREO
						SET		EstatusEnvio			= EstProceso,
								PIDTarea				= Par_PIDTarea,
								EmpresaID 				= Aud_EmpresaID,
								Usuario 				= Aud_Usuario,
								FechaActual				= Aud_FechaActual,
								DireccionIP 			= Aud_DireccionIP,
								ProgramaID 				= Aud_ProgramaID,
								Sucursal 				= Aud_Sucursal,
								NumTransaccion 			= Aud_NumTransaccion
						WHERE	EstatusEnvio			= Est_NoEnviado
							AND	PIDTarea				= Cadena_Vacia;


					-- El registro se inserto exitosamente
					SET	Par_NumErr	:= 000;
					SET	Par_ErrMen	:= 'Se actualizado correctamente el estatus a proceso';
					SET Var_Control	:= Cadena_Vacia;

			END IF;


			-- Actualizacion para cambiar el estatus a fallado
			IF (Par_NumAct = Act_EstFallido)THEN
				SET	Par_EnvioCorreoID		:= IFNULL(Par_EnvioCorreoID,Entero_Cero);
				IF (Par_EnvioCorreoID		 = Entero_Cero)THEN
					SET	Par_NumErr			:= 001;
					SET	Par_ErrMen			:= 'El identificador de la notificacion se encuentra vacio';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				SET Var_EnvioCorreoID 	= (SELECT COUNT(EnvioCorreoID)
											FROM	EDOCTAV2TARENVIOCORREO
											WHERE EnvioCorreoID = Par_EnvioCorreoID);

				IF (Var_EnvioCorreoID			= Entero_Cero)THEN
					SET	Par_NumErr			:= 002;
					SET	Par_ErrMen			:= 'El registro que intenta actualizar no existe';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				UPDATE	EDOCTAV2TARENVIOCORREO
					SET	EstatusEnvio		= EstFallado,
						EmpresaID 			= Aud_EmpresaID,
						Usuario 			= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP 		= Aud_DireccionIP,
						ProgramaID 			= Aud_ProgramaID,
						Sucursal 			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE	EnvioCorreoID	= Par_EnvioCorreoID;

				SET	Par_NumErr	:= 000;
				SET	Par_ErrMen	:= 'Se actualizado correctamente el estatus a fallado';
				SET Var_Control	:= 'Par_EnvioCorreoID';
			END IF;

 			-- Actualizacion para cambiar el estatus a enviado
 			IF (Par_NumAct = Act_EstEnviado)THEN

				SET	Par_EnvioCorreoID			:= IFNULL(Par_EnvioCorreoID,Entero_Cero);

				IF (Par_EnvioCorreoID			= Entero_Cero)THEN
					SET	Par_NumErr			:= 001;
					SET	Par_ErrMen			:= 'El identificador de la notificacion se encuentra vacio';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				SET Var_EnvioCorreoID 	= (SELECT COUNT(EnvioCorreoID)
											FROM	EDOCTAV2TARENVIOCORREO
											WHERE EnvioCorreoID = Par_EnvioCorreoID);

				IF (Var_EnvioCorreoID			= Entero_Cero)THEN
					SET	Par_NumErr			:= 002;
					SET	Par_ErrMen			:= 'El registro que intenta actualizar no existe';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				UPDATE	EDOCTAV2TARENVIOCORREO
					SET			EstatusEnvio		= EstEnviado,
								FechaEnvio			= NOW(),
								EmpresaID 			= Aud_EmpresaID,
								Usuario 			= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP 		= Aud_DireccionIP,
								ProgramaID 			= Aud_ProgramaID,
								Sucursal 			= Aud_Sucursal,
								NumTransaccion 		= Aud_NumTransaccion
					WHERE	EnvioCorreoID			= Par_EnvioCorreoID;

				SET	Par_NumErr	:= 000;
				SET	Par_ErrMen	:= 'Se actualizado correctamente el estatus a enviado';
				SET Var_Control	:= 'Par_EnvioCorreoID';
			END IF;

 			-- Actualizacion para cambiar el estatus a caducado
 			IF (Par_NumAct = Act_EstCaducado)THEN

				-- Pone en estatus de caducado todas las fechas que sean menor o igual a la fecha del sistema
				UPDATE	EDOCTAV2TARENVIOCORREO
					SET	EstatusEnvio		= EstCaducado,
						EmpresaID 			= Aud_EmpresaID,
						Usuario 			= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP 		= Aud_DireccionIP,
						ProgramaID 			= Aud_ProgramaID,
						Sucursal 			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE FechaVencimiento	<= NOW();

				SET	Par_NumErr	:= 000;
				SET	Par_ErrMen	:= 'Se actualizado correctamente el estatus a caducado';
				SET Var_Control	:= 'Par_EnvioCorreoID';
			END IF;


 			-- Actualizacion de la descripcion del error
 			IF (Par_NumAct = Act_DescError)THEN

				SET	Par_EnvioCorreoID			:= IFNULL(Par_EnvioCorreoID,Entero_Cero);

				IF (Par_EnvioCorreoID			= Entero_Cero)THEN
					SET	Par_NumErr			:= 001;
					SET	Par_ErrMen			:= 'El identificador de la notificacion se encuentra vacio';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				SET Var_EnvioCorreoID 	= (SELECT COUNT(EnvioCorreoID)
											FROM	EDOCTAV2TARENVIOCORREO
											WHERE EnvioCorreoID = Par_EnvioCorreoID);

				IF (Var_EnvioCorreoID			= Entero_Cero)THEN
					SET	Par_NumErr			:= 002;
					SET	Par_ErrMen			:= 'El registro que intenta actualizar no existe';
					SET Var_Control			:= 'EnvioCorreoID';
					LEAVE ManejoErrores;
				END IF;

				UPDATE	EDOCTAV2TARENVIOCORREO
					SET		DescripcionError	= Par_DescripcionError,
							EmpresaID 			= Aud_EmpresaID,
							Usuario 			= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP 		= Aud_DireccionIP,
							ProgramaID 			= Aud_ProgramaID,
							Sucursal 			= Aud_Sucursal,
							NumTransaccion 		= Aud_NumTransaccion
					WHERE	EnvioCorreoID		= Par_EnvioCorreoID;

				SET	Par_NumErr	:= 0;
				SET	Par_ErrMen	:= 'Descripcion de error actualizado correctamente';
				SET Var_Control	:= 'Par_EnvioCorreoID';
			END IF;

	-- Fin de validaciones
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;


-- Fin del SP
END TerminaStore$$


