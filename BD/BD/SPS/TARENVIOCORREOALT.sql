
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOALT`;


DELIMITER $$
CREATE PROCEDURE `TARENVIOCORREOALT`(
	-- Stored procedure que da de alta un envio de correo
	Par_RemitenteID					INT(11),				-- Identificador del remitente correspondiente a la tabla TARENVIOCORREOPARAM
	Par_EmailDestino				VARCHAR(500),			-- Correo electronico donde sera enviado el correo
	Par_Asunto						VARCHAR(100),			-- Asunto del correo electronico
	Par_Mensaje						TEXT,					-- Contenido del correo electronico
	Par_GrupoEmailID				INT(11),				-- Identificador de la tabla GRUPOSEMAIL en caso que se requiera mandar a varios correos

	Par_FechaProgramada				DATETIME,				-- Es la fecha con la cual se programa el envio de correo
	Par_FechaVencimiento			DATETIME,				-- Es la fecha con la cual se vence el correo
	Par_Proceso						VARCHAR(50),			-- Proceso al cual le pertenece el correo
	Par_EmailCC						VARCHAR(500),			-- Correo electronico para el envio con Copia CC
	Par_Salida						CHAR(1),				-- Parametro para salida de datos

	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(800),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria

	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(1);					-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(2, 1);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE CodigoExito				CHAR(6);				-- Codigo de exito
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Entero_Uno				INT(1);					-- Numero uno

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_Consecutivo			BIGINT(20);				-- Variable consecutivo
	DECLARE Var_Num_Act				INT(11);				-- Numero de actualizacion
	DECLARE Var_TareaID				INT(11);				-- ID de la tarea
	DECLARE Var_PIDTarea			VARCHAR(20);			-- Identificador unico del hilo de ejecucion de la tarea
	DECLARE Var_EstNoEnviado		CHAR(1);				-- Estatus Pendiente
	DECLARE Var_EnvioCorreoID		INT(11);				-- ID del correo
	DECLARE Var_CorreoGrupo			VARCHAR(500);			-- Correo de todos los grupo
	DECLARE Var_GrupoID				INT(11);				-- Almacena el id del grupo
	DECLARE Var_GrupoEmail			VARCHAR(200);			-- Grupo de email
	DECLARE Var_VigenciaDias		INT(11);				-- Dias de vigencia del correo
    DECLARE Var_DiaSigHabil			DATE;										-- Variable para almacenar la fecha del sia habil siguiente
	DECLARE Var_EsHabil				CHAR(1);									-- Variable para enviar a la comprobacion de dia habil

	-- Asignacion de constantes
	SET Entero_Uno					:= 1;					-- Asignacion de entero 1
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0;					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET CodigoExito					:= '000000';			-- Asignacion del codigo de exito
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_EstNoEnviado			:= 'N';					-- Asignacion de estatus enviado

	SET Par_RemitenteID				:= IFNULL(Par_RemitenteID,Entero_Cero);
	SET Par_EmailDestino			:= IFNULL(Par_EmailDestino,Cadena_Vacia);
	SET Par_Asunto					:= IFNULL(Par_Asunto,Cadena_Vacia);
	SET Par_Mensaje					:= IFNULL(Par_Mensaje,Cadena_Vacia);
	SET Par_GrupoEmailID			:= IFNULL(Par_GrupoEmailID,Entero_Cero);
	SET Par_FechaProgramada			:= IFNULL(Par_FechaProgramada,Fecha_Vacia);
	SET Par_FechaVencimiento		:= IFNULL(Par_FechaVencimiento,Fecha_Vacia);
	SET Par_Proceso					:= IFNULL(Par_Proceso,Cadena_Vacia);
	SET Par_EmailCC 				:= IFNULL(Par_EmailCC,Cadena_Vacia);


	SELECT CAST(ValorParametro AS UNSIGNED INT)
	INTO Var_VigenciaDias
		FROM PARAMGENERALES
		WHERE LlaveParametro='VigenciaCorreo';

	SET Var_VigenciaDias := IFNULL(Var_VigenciaDias,Entero_Cero) + Entero_Uno;

	SELECT FechaSistema
	INTO Par_FechaVencimiento
		FROM PARAMETROSSIS;

	SET Par_FechaVencimiento := DATE_ADD(Par_FechaVencimiento, INTERVAL Var_VigenciaDias DAY);

    CALL DIASFESTIVOSCAL(
		Par_FechaVencimiento,	Entero_Uno,			Var_DiaSigHabil,		Var_EsHabil,		Aud_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET Par_FechaVencimiento := Var_DiaSigHabil;
	SET Var_EnvioCorreoID := Entero_Cero;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TARENVIOCORREOALT');
				SET Var_Control := 'sqlException';
			END;

		-- Inician validaciones
			IF(Par_RemitenteID = Entero_Cero) THEN
				SET Par_NumErr			:= 001;
				SET Par_ErrMen			:= 'Es necesario indicar una remitente de correo';
				SET Var_Control			:= 'RemitenteID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_EmailDestino = Cadena_Vacia AND Par_GrupoEmailID = Entero_Cero
												AND Par_EmailCC = Cadena_Vacia) THEN
				SET Par_NumErr			:= 002;
				SET Par_ErrMen			:= 'Es necesario indicar una dirección de correo o un grupo para el envio del correo';
				SET Var_Control			:= 'EmailDestino';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Asunto = Cadena_Vacia ) THEN
				SET Par_NumErr			:= 003;
				SET Par_ErrMen			:= 'Es necesario indicar el asunto para el envio del correo';
				SET Var_Control			:= 'Asunto';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Mensaje = Cadena_Vacia ) THEN
				SET Par_NumErr			:= 004;
				SET Par_ErrMen			:= 'Es necesario indicar el mensaje para el envio del correo';
				SET Var_Control			:= 'Mensaje';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FechaProgramada = Fecha_Vacia ) THEN
				SET Par_NumErr			:= 005;
				SET Par_ErrMen			:= 'Es necesario indicar la fecha programada para el envio del correo';
				SET Var_Control			:= 'FechaProgramada';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FechaVencimiento = Fecha_Vacia ) THEN
				SET Par_NumErr			:= 006;
				SET Par_ErrMen			:= 'Es necesario indicar la fecha de vencimiento para el envio del correo';
				SET Var_Control			:= 'FechaVencimiento';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Proceso = Cadena_Vacia ) THEN
				SET Par_NumErr			:= 007;
				SET Par_ErrMen			:= 'El proceso se encuentra vacio';
				SET Var_Control			:= 'Proceso';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_GrupoEmailID <> Entero_Cero ) THEN
				-- Si se envio el grupo se verifica que el grupo exista en la tabla
				SET Var_GrupoID	:= (SELECT COUNT(GrupoEmailID)
										FROM TARGRUPOSEMAIL
										WHERE GrupoEmailID = Par_GrupoEmailID);

				IF(Var_GrupoID = Entero_Cero ) THEN
					SET Par_NumErr			:= 002;
					SET Par_ErrMen			:= 'El grupo ingresado no existe';
					SET Var_Control			:= 'GrupoEmailID';
					LEAVE ManejoErrores;
				END IF;

				-- Si se envio el grupo se verifica que el grupo exista en la tabla
				SET Var_GrupoEmail	:= (SELECT Destinatarios
											FROM TARGRUPOSEMAIL
											WHERE GrupoEmailID = Par_GrupoEmailID);

				IF(Var_GrupoEmail = Cadena_Vacia ) THEN
					SET Par_NumErr			:= 002;
					SET Par_ErrMen			:= 'El grupo ingresado no existe';
					SET Var_Control			:= 'GrupoEmailID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_EmailDestino != Cadena_Vacia AND Par_GrupoEmailID != Entero_Cero) THEN
				SET Var_CorreoGrupo := CONCAT(Par_EmailDestino, ',', Var_GrupoEmail);
			ELSEIF (Par_EmailDestino != Cadena_Vacia AND Par_GrupoEmailID = Entero_Cero) THEN
				SET Var_CorreoGrupo := Par_EmailDestino;
			ELSE
				SET Var_CorreoGrupo := Var_GrupoEmail;
			END IF;
			-- Fin de validaciones

			CALL FOLIOSAPLICAACT('TARENVIOCORREO', Var_EnvioCorreoID);

			INSERT INTO TARENVIOCORREO (
				EnvioCorreoID,		RemitenteID,		EmailDestino,		Asunto,					Mensaje,
				GrupoEmailID,		EstatusEnvio,		FechaEnvio,			FechaProgramada,		FechaVencimiento,
				Proceso,			PIDTarea,			DescripcionError,	EmailCC,				EmpresaID,
				Usuario,			FechaActual,		DireccionIP,		ProgramaID,				Sucursal,
				NumTransaccion)
			VALUES (
				Var_EnvioCorreoID,	Par_RemitenteID,	Var_CorreoGrupo,	Par_Asunto,				Par_Mensaje,
				Entero_Cero,		Var_EstNoEnviado,	Fecha_Vacia,		Par_FechaProgramada,	Par_FechaVencimiento,
				Par_Proceso,		Cadena_Vacia,		Cadena_Vacia,		Par_EmailCC,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

		-- El registro se inserto exitosamente
		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Alta envio correo exitoso.';
		SET Var_Control	:= 'EnvioCorreoID';
		SET Var_Consecutivo = Var_EnvioCorreoID;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$

