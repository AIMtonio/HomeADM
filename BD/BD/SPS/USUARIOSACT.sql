-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSACT`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSACT`(
# =====================================================================================
# ------- STORE PARA ACTUALIZAR LOS DATOS DEL USUARIO ---------
# =====================================================================================
	Par_NumUsuario		INT(11),			-- ID del usuario
	Par_Clave			VARCHAR(45),		-- Clave del usuario
	Par_Estatus			CHAR(1),			-- Estatus del usuario
	Par_MotivBloq		VARCHAR(200),		-- Motivo del bloqueo
	Par_FechBloq		DATE,				-- Fecha en que se bloquea

	Par_MotivCancel		VARCHAR(200),		-- Motivo de cancelacion
	Par_FechCancel		DATE,				-- Fecha de la cancelacion
	Par_Contrasenia		VARCHAR(45),		-- Contrasenia del usuario
	Par_UsuarioIDRespon	INT(11),			-- ID del usuario que realiza la cancelacion o reactivacion del usuario
	Par_MotivoReactiva	VARCHAR(200),		-- Motivo de reactivacion

    Par_FechaReactiva	DATE,				-- Fecha de la reactivacion
	Par_NumAct			TINYINT UNSIGNED,	-- Numero de actualizacion que realizara

    Par_Salida			CHAR(1),			-- Campo a la qu hace referencia
    INOUT Par_NumErr	INT,				-- Parametro del numero de Error
    INOUT Par_ErrMen	VARCHAR(400),		-- Parametro del Mensaje de Error

    Par_EmpresaID      	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario        	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual    	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP    	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID     	VARCHAR(50),		-- Parametro de auditoria Programa

    Aud_Sucursal       	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion 	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_HabilitaConfPass	CHAR(1);		-- Variable para Guardar Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Var_UltimasContra		INT(11);		-- Variable para Guardar las ultimas contraseñas permitidas
	DECLARE Var_ContContra			INT(11);		-- Variable para hacer el contador de Contrasenia de Usuario en el ciclo While para validacion d elas ultimas contrasenia permitidas
	DECLARE Var_CantUsuaContra		INT(11);		-- Variable para saber la cantidad total de Contraseña del usuario Utilizada ultimamente con la que se hará el cilo While
	DECLARE Var_Contrasenia			VARCHAR(100);	-- Variable para guardar contrasenia
	DECLARE Var_NumIntentos			INT(11);		-- Variable para guardar la cantidad de intento Parametrizado que debe de logueo por usuario para ser bloqueado
	DECLARE Var_CantIntentoBloq		INT(11);		-- Variable para guardar la cantidad de intentos para bloqueo de Usuarios
	DECLARE Var_EstatusAnalisis     CHAR(1);        -- Variable para el estatus de analisis de credito
	DECLARE Var_EstatusAnalisisA    CHAR(1);        -- Variable para almacenar el estatus temporal de un usuario de tipo analista de credito
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE	Num_LogInc			INT;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Act_LogInc			INT;
	DECLARE	Sta_Bloquea			CHAR(1);
	DECLARE	Sta_Cancel			CHAR(1);
	DECLARE	Act_EstBloqDesbloq	INT;
	DECLARE	Act_EstCancel		INT;
	DECLARE	Act_ResetPass		INT;
	DECLARE	Act_StatSesAct		INT;
	DECLARE	Act_StatSesInac		INT;
	DECLARE Act_NuevoPass		INT;
	DECLARE	Sta_SesActiva		CHAR(1);
	DECLARE	Sta_SesInactiva		CHAR(1);
	DECLARE	ContraAct 			VARCHAR(45);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Act_ReactivaUsu		INT;
	DECLARE	Sta_Activo			CHAR(1);
	DECLARE Con_SalidaSI		CHAR(1);
	DECLARE MotivoBloqueo			VARCHAR(45);
	DECLARE HabilitaConfPass		VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Cons_SI					CHAR(1);		-- Constante Si
	DECLARE Cons_NO					CHAR(1);		-- Constante No
	DECLARE Act_EstatusAnalisis		 INT(11); 		-- Actualiza el esatus de tipo analisis de credito
	DECLARE	Sta_Inactivo			CHAR(1);
	DECLARE Act_CambioContraApp		INT(11);		-- Cambio de Contrasenia desde la aplicacion movil
	DECLARE Act_InactivaCierre		INT(11);		-- Actulizacion de estatus por el cierre
	DECLARE Act_ActivaCierre		INT(11);		-- Actulizacion de estatus por el cierre

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	Act_LogInc				:= 1;				--
	SET	Sta_Bloquea				:= 'B';				-- Estatus Bloqueado
	SET	Sta_Cancel				:= 'C';				-- Estatus Cancelado
	SET	Act_EstBloqDesbloq		:= 2;  	 			-- Actualizacion para desbloquear y bloquear Usuario
	SET	Act_EstCancel			:= 3;  				-- Actualizacion para Cancelar
	SET	Act_ResetPass			:= 4;  				-- Actualizacion para resetear el password
	SET Act_StatSesAct			:= 5;				-- Actualizacion para Activar la Sesion
	SET	Act_StatSesInac			:= 6;				-- Actualizacion para Inactivar la Sesion
	SET Act_NuevoPass			:= 8;				-- Actualizacion para Cambiar la Contrasena
	SET Sta_SesActiva			:= 'A';				-- Estatus Activa
	SET Sta_SesInactiva			:='I';				-- Estatus Sesion Inactiva
	SET Act_ReactivaUsu			:= 9;				-- Actualizacion para Reactivar un usuario
	SET	Sta_Activo				:= 'A';				-- Estatus Activo
	SET	Sta_Inactivo		    := 'I';				-- Estatus Inactivo
	SET Con_SalidaSI			:= 'S';
    SET MotivoBloqueo			:= 'Intentos Excedidos';
	SET HabilitaConfPass		:= "HabilitaConfPass";		-- Llave Parametro: Indica si la contrasenia requiere configuracion
	SET Cons_SI					:= 'S';						-- Constante Si
	SET Cons_NO					:= 'N';						-- Constante No
	SET Act_EstatusAnalisis		:= 10;						-- Constante entero 10
	SET Act_CambioContraApp		:= 11;						-- Cambio de Contrasenia desde la aplicacion movil
	SET Act_InactivaCierre		:= 12;						-- Actulizacion de estatus (Inavcitivo) por el proceso de cierre
	SET Act_ActivaCierre		:= 13;						-- Actulizacion de estatus (Activo) por el proceso de cierre

	SET Par_EmpresaID	:= IFNULL(Par_EmpresaID, Entero_Cero);

	IF(Par_EmpresaID = Entero_Cero) THEN
		SET Par_EmpresaID = 1;
	END IF;

ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-USUARIOSACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


	IF(Par_NumAct = Act_LogInc) THEN

		CALL TRANSACCIONESPRO(Aud_NumTransaccion);
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Num_LogInc := (SELECT IFNULL(LoginsFallidos,Entero_Cero)
							FROM USUARIOS Usu
							WHERE Usu.Clave = Par_Clave);

		-- COnsultamos si la contraseña requiere Validacion por configuracion
		SET Var_HabilitaConfPass := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass := IFNULL(Var_HabilitaConfPass,'N');

		-- COnsultamos los numeros de Intentos parametrizados
		SELECT NumIntentos
			INTO Var_NumIntentos
			FROM PARAMETROSSIS
			LIMIT 1;

		SET Var_NumIntentos	:= IFNULL(Var_NumIntentos, Entero_Cero);

		-- SI la configuracion del pasword se encuentra marcada como S=  Se realiza la validacion con el parametro configurado
		-- por el usuario para Indicar a cuanto Intentos se Bloquea el Usuario
		IF(Var_HabilitaConfPass = Cons_SI) THEN
			SET Var_CantIntentoBloq		:= Var_NumIntentos;
		END IF;

		-- SI la configuracion del pasword se encuentra marcada como N =  se mantiene la validacion existente en safi
		-- Para la validacion de numeros de intentos de Bloqueos a iniciar sesion
		IF(Var_HabilitaConfPass = Cons_NO) THEN
			SET Var_CantIntentoBloq		:= 2; -- RLAVIDA_TICKET_11621
		END IF;

		IF (Num_LogInc <> Var_CantIntentoBloq) THEN
			UPDATE USUARIOS SET
				LoginsFallidos	= LoginsFallidos + 1,

				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Clave = Par_Clave;
		END IF;

		IF (Num_LogInc = Var_CantIntentoBloq) THEN
			UPDATE USUARIOS SET
				LoginsFallidos	= LoginsFallidos + 1,
				Estatus			= Sta_Bloquea,
				FechaBloqueo	= Aud_FechaActual,
				MotivoBloqueo	= MotivoBloqueo,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE Clave = Par_Clave;
		END IF;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	'Usuario Actualizado';
		SET Var_Control		:=	'numero';
		LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_EstBloqDesbloq) THEN
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		UPDATE USUARIOS SET
			Estatus		 	= Par_Estatus,
			MotivoBloqueo	= Par_MotivBloq,
			FechaBloqueo	= Par_FechBloq,
			LoginsFallidos 	= Entero_Cero,
			EmpresaID	 	= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('Usuario Actualizado: ',CONVERT(Par_NumUsuario, CHAR));
		SET	Var_Control		:=	'usuarioID';
        LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_EstCancel) THEN
		IF ( RTRIM(LTRIM(Par_MotivCancel)) = Cadena_Vacia)THEN
			SET Par_NumErr		:=	1;
			SET Par_ErrMen		:=	'Agregue el Motivo de Cancelacion.';
			SET	Var_Control		:=	'motivoCancel';

            LEAVE ManejoErrores;
		END IF;

		SET Var_Estatus:=(SELECT Estatus FROM CAJASVENTANILLA WHERE UsuarioID=Par_NumUsuario);

		IF Var_Estatus="A" THEN
			SET Par_NumErr		:=	2;
			SET Par_ErrMen		:=	'El Usuario tiene Caja Asignada.';
			SET Var_Control		:=	'usuarioID';

			LEAVE ManejoErrores;
		END IF;

		IF Par_UsuarioIDRespon = Par_NumUsuario THEN
			SET Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'El usuario a cancelar no puede ser el mismo que el usuario que se encuentra logueado';
			SET Var_Control		:=	'usuarioID';

			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE USUARIOS SET
				Estatus		 	= Sta_Cancel,
				UsuarioIDCancel	= Par_UsuarioIDRespon,
				MotivoCancel	= Par_MotivCancel,
				FechaCancel	 	= Par_FechCancel,

				UsuarioIDReactiva	= Entero_Cero,
				MotivoReactiva		= Cadena_Vacia,
				FechaReactiva	 	= Fecha_Vacia,

				EmpresaID	 	= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET	Par_ErrMen		:=	CONCAT( 'Usuario Cancelado: ',CONVERT(Par_NumUsuario, CHAR));
		SET	Var_Control		:=	'usuarioID';

        LEAVE ManejoErrores;
	END IF;

	-- Reset de Password pantalla de Menu Principal
	IF(Par_NumAct = Act_ResetPass) THEN
		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET ContraAct := (SELECT Contrasenia FROM USUARIOS WHERE UsuarioID = Par_NumUsuario);

		IF (ContraAct = Par_Contrasenia)THEN
			SET Par_NumErr		:=	4;
			SET Par_ErrMen		:=	'Contrasenia Utilizada Actualmente, Introducir una Diferente';
			SET Var_Control		:=	'contrasenia';
			LEAVE ManejoErrores;
		END IF;

		-- COnsultamos si la contraseña requiere Validacion por configuracion
		SET Var_HabilitaConfPass := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass := IFNULL(Var_HabilitaConfPass,'N');

		-- SI la configuracion del pasword se encuentra marcada como S=  Se realiza la validacion con el parametro configurado
		-- por el usuario
		IF(Var_HabilitaConfPass = Cons_SI) THEN

			SELECT UltimasContra
				INTO Var_UltimasContra
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_UltimasContra	:= IFNULL(Var_UltimasContra, Entero_Cero);

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

			INSERT INTO TMPHISTORCONTRAUSU (	UsuarioID,		Contrasenia,	EmpresaID,		Usuario,			FechaActual,
												DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	his.UsuarioID,			his.Contrasenia,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					FROM HISTORCONTRAUSU his
					WHERE his.UsuarioID = Par_NumUsuario
					ORDER BY his.FechaActual DESC
					LIMIT Var_UltimasContra;

			SELECT	MIN(TmpHistorContraUsuID), MAX(TmpHistorContraUsuID)
				INTO Var_ContContra, Var_CantUsuaContra
				FROM TMPHISTORCONTRAUSU
				WHERE UsuarioID = Par_NumUsuario
				AND NumTransaccion = Aud_NumTransaccion;

			-- Hacemos un loop while para ir Validando por cada contrasenia
			WHILE Var_ContContra <= Var_CantUsuaContra DO
				SET Var_Contrasenia		:= '';

				SELECT Contrasenia
					INTO Var_Contrasenia
					FROM TMPHISTORCONTRAUSU
					WHERE TmpHistorContraUsuID = Var_ContContra
					AND UsuarioID = Par_NumUsuario
					AND NumTransaccion = Aud_NumTransaccion;

				SET Var_Contrasenia		:= IFNULL(Var_Contrasenia, Cadena_Vacia);

				IF(Var_Contrasenia <> Cadena_Vacia) THEN
					IF (Var_Contrasenia = Par_Contrasenia) THEN
						SET Par_NumErr		:=	5;
						SET Par_ErrMen		:=	'Contrasenia Utilizada Anterioridad, Introducir una Diferente';
						SET Var_Control		:=	'contrasenia';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SET Var_ContContra := Var_ContContra + 1;
			END WHILE;

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

		END IF;

		-- SI la configuracion del pasword se encuentra marcada como N =  se mantiene la validacion existente en safi
		-- Para la validacion d ela contraseña utilizada ultimamente
		IF(Var_HabilitaConfPass = Cons_NO) THEN
			IF EXISTS(SELECT Contrasenia FROM HISTORCONTRAUSU WHERE Contrasenia = Par_Contrasenia AND UsuarioID = Par_NumUsuario  )THEN
				SET Par_NumErr		:=	6;
				SET Par_ErrMen		:=	'Contrasenia Utilizada con Anterioridad, Introducir una Diferente';
				SET Var_Control		:= 	'contrasenia';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT INTO HISTORCONTRAUSU VALUES (Par_NumUsuario,		ContraAct,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
											Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		UPDATE USUARIOS SET
			Contrasenia		= Par_Contrasenia,
			FechUltPass		= NOW(),
			EmpresaID		= Par_EmpresaID,

			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('El Password del Usuario:',CONVERT(Par_NumUsuario, CHAR),' ha sido cambiado correctamente. ');
		SET Var_Control		:=	'usuarioID';

		LEAVE ManejoErrores;
	END IF;

	-- Nuevo Password pantalla Reseteo de Contrasenia
	IF(Par_NumAct = Act_NuevoPass) THEN
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET ContraAct := (SELECT Contrasenia FROM USUARIOS WHERE UsuarioID = Par_NumUsuario);

		IF (ContraAct= Par_Contrasenia)THEN
			SET Par_NumErr		:=	7;
			SET Par_ErrMen		:=	'Contrasenia Utilizada Actualmente, Introducir una Diferente';
			SET Var_Control		:=	'contrasenia';
			LEAVE ManejoErrores;
		END IF;

		-- COnsultamos si la contraseña requiere Validacion por configuracion
		SET Var_HabilitaConfPass := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass := IFNULL(Var_HabilitaConfPass,'N');

		-- SI la configuracion del pasword se encuentra marcada como S=  Se realiza la validacion con el parametro configurado
		-- por el usuario
		IF(Var_HabilitaConfPass = Cons_SI) THEN

			SELECT UltimasContra
				INTO Var_UltimasContra
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_UltimasContra	:= IFNULL(Var_UltimasContra, Entero_Cero);

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

			INSERT INTO TMPHISTORCONTRAUSU (	UsuarioID,		Contrasenia,	EmpresaID,		Usuario,			FechaActual,
												DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	his.UsuarioID,			his.Contrasenia,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					FROM HISTORCONTRAUSU his
					WHERE his.UsuarioID = Par_NumUsuario
					ORDER BY his.FechaActual DESC
					LIMIT Var_UltimasContra;

			SELECT	MIN(TmpHistorContraUsuID), MAX(TmpHistorContraUsuID)
				INTO Var_ContContra, Var_CantUsuaContra
				FROM TMPHISTORCONTRAUSU
				WHERE UsuarioID = Par_NumUsuario
				AND NumTransaccion = Aud_NumTransaccion;

			-- Hacemos un loop while para ir Validando por cada contrasenia
			WHILE Var_ContContra <= Var_CantUsuaContra DO
				SET Var_Contrasenia		:= '';

				SELECT Contrasenia
					INTO Var_Contrasenia
					FROM TMPHISTORCONTRAUSU
					WHERE TmpHistorContraUsuID = Var_ContContra
					AND UsuarioID = Par_NumUsuario
					AND NumTransaccion = Aud_NumTransaccion;

				SET Var_Contrasenia		:= IFNULL(Var_Contrasenia, Cadena_Vacia);

				IF(Var_Contrasenia <> Cadena_Vacia) THEN
					IF (Var_Contrasenia = Par_Contrasenia) THEN
						SET Par_NumErr		:=	8;
						SET Par_ErrMen		:=	'Contrasenia Utilizada Anterioridad, Introducir una Diferente';
						SET Var_Control		:=	'contrasenia';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SET Var_ContContra := Var_ContContra + 1;
			END WHILE;

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

		END IF;

		-- SI la configuracion del pasword se encuentra marcada como N =  se mantiene la validacion existente en safi
		-- Para la validacion d ela contraseña utilizada ultimamente
		IF(Var_HabilitaConfPass = Cons_NO) THEN
			IF EXISTS(SELECT Contrasenia FROM HISTORCONTRAUSU WHERE Contrasenia = Par_Contrasenia AND UsuarioID = Par_NumUsuario  )THEN
				SET Par_NumErr		:=	9;
				SET Par_ErrMen		:=	'Contrasenia Utilizada con Anterioridad, Introducir una Diferente';
				SET Var_Control		:=	'contrasenia';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT INTO HISTORCONTRAUSU VALUES (Par_NumUsuario,		ContraAct,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
											Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		UPDATE USUARIOS SET
			Contrasenia		= Par_Contrasenia,
			FechUltPass		= Fecha_Vacia,
			EmpresaID		= Par_EmpresaID,

			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('El Password del Usuario:',CONVERT(Par_NumUsuario, CHAR),' ha sido cambiado correctamente. ');
		SET	Var_Control		:=  'usuarioID';

		LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_StatSesAct) THEN
		UPDATE USUARIOS SET
			FechUltimAcces	= NOW()
		WHERE Clave =Par_Clave;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	'Usuario Actualizado';
		SET Var_Control		:=	'numero';

        LEAVE ManejoErrores;
	END IF;


	IF(Par_NumAct = Act_StatSesInac) THEN
		UPDATE USUARIOS SET
			EstatusSesion		= Sta_SesInactiva
		WHERE Clave =Par_Clave;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	'Sesion de usuario finalizada';
		SET Var_Control		:=	'numero';

        LEAVE ManejoErrores;
	END IF;

	-- ACtualizacion para reactivar un usuario
	IF(Par_NumAct = Act_ReactivaUsu) THEN
		IF ( RTRIM(LTRIM(Par_MotivoReactiva)) = Cadena_Vacia)THEN

            SET Par_NumErr		:=	0;
			SET Par_ErrMen		:=	'Agregue el Motivo de Reactivacion.';
			SET Var_Control		:=	'motivoReactiva';

			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE USUARIOS SET
				Estatus		 		= Sta_Activo,
				UsuarioIDReactiva	= Par_UsuarioIDRespon,
				MotivoReactiva		= Par_MotivoReactiva,
				FechaReactiva	 	= Par_FechaReactiva,

				EmpresaID	 	= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT( 'Usuario Reactivado: ',CONVERT(Par_NumUsuario, CHAR));
		SET Var_Control		:=	'usuarioID';

        LEAVE ManejoErrores;
	END IF;

    -- Actualiza el estatus del usuario de tipo analista de credito
	IF(Par_NumAct = Act_EstatusAnalisis) THEN
	   	SET Var_EstatusAnalisis		:='';
        SET Var_EstatusAnalisisA	:= '';
        SET Var_EstatusAnalisis:=(SELECT EstatusAnalisis FROM USUARIOS WHERE UsuarioID = Par_NumUsuario AND EstatusAnalisis=Sta_Inactivo);


		IF(IFNULL(Var_EstatusAnalisis,Cadena_Vacia) <> Cadena_Vacia) THEN
          SET  Var_EstatusAnalisisA := Sta_Activo;
	        ELSE
			SET  Var_EstatusAnalisisA		:= Sta_Inactivo;
        END IF;
		CALL BITACORAACCESANALISTAALT(
				Par_NumUsuario,            Var_EstatusAnalisisA,           Cons_NO, 			      Par_NumErr,           Par_ErrMen,
				Par_EmpresaID,             Aud_Usuario,                    Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,
				Aud_Sucursal,              Aud_NumTransaccion   );

		 		IF(Par_NumErr <> Entero_Cero)THEN
		    	LEAVE ManejoErrores;
		    	END IF;

        UPDATE USUARIOS
                SET
		    	EstatusAnalisis		= Var_EstatusAnalisisA
		WHERE UsuarioID     =Par_NumUsuario;

 	    SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	'Estatus Analisis Actualizado';
		SET Var_Control		:=	'estatusAnalisis';

        LEAVE ManejoErrores;
	END IF;

	-- Nuevo Password desde la aplicacion movil
	IF(Par_NumAct = Act_CambioContraApp) THEN
		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET ContraAct := (SELECT Contrasenia FROM USUARIOS WHERE UsuarioID = Par_NumUsuario);

		SELECT 		FechaSistema
			INTO 	Var_FechaSistema
			FROM PARAMETROSSIS;

		IF (ContraAct= Par_Contrasenia)THEN
			SET Par_NumErr		:=	7;
			SET Par_ErrMen		:=	'Contrasenia Utilizada Actualmente, Introducir una Diferente';
			SET Var_Control		:=	'contrasenia';
			LEAVE ManejoErrores;
		END IF;

		-- COnsultamos si la contraseña requiere Validacion por configuracion
		SET Var_HabilitaConfPass := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass := IFNULL(Var_HabilitaConfPass,'N');

		-- SI la configuracion del pasword se encuentra marcada como S=  Se realiza la validacion con el parametro configurado
		-- por el usuario
		IF(Var_HabilitaConfPass = Cons_SI) THEN

			SELECT UltimasContra
				INTO Var_UltimasContra
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_UltimasContra	:= IFNULL(Var_UltimasContra, Entero_Cero);

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

			INSERT INTO TMPHISTORCONTRAUSU (	UsuarioID,		Contrasenia,	EmpresaID,		Usuario,			FechaActual,
												DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
				SELECT	his.UsuarioID,			his.Contrasenia,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					FROM HISTORCONTRAUSU his
					WHERE his.UsuarioID = Par_NumUsuario
					ORDER BY his.FechaActual DESC
					LIMIT Var_UltimasContra;

			SELECT	MIN(TmpHistorContraUsuID), MAX(TmpHistorContraUsuID)
				INTO Var_ContContra, Var_CantUsuaContra
				FROM TMPHISTORCONTRAUSU
				WHERE UsuarioID = Par_NumUsuario
				AND NumTransaccion = Aud_NumTransaccion;

			-- Hacemos un loop while para ir Validando por cada contrasenia
			WHILE Var_ContContra <= Var_CantUsuaContra DO
				SET Var_Contrasenia		:= '';

				SELECT Contrasenia
					INTO Var_Contrasenia
					FROM TMPHISTORCONTRAUSU
					WHERE TmpHistorContraUsuID = Var_ContContra
					AND UsuarioID = Par_NumUsuario
					AND NumTransaccion = Aud_NumTransaccion;

				SET Var_Contrasenia		:= IFNULL(Var_Contrasenia, Cadena_Vacia);

				IF(Var_Contrasenia <> Cadena_Vacia) THEN
					IF (Var_Contrasenia = Par_Contrasenia) THEN
						SET Par_NumErr		:=	8;
						SET Par_ErrMen		:=	'Contrasenia Utilizada Anterioridad, Introducir una Diferente';
						SET Var_Control		:=	'contrasenia';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SET Var_ContContra := Var_ContContra + 1;
			END WHILE;

			-- Borramos la tabla temporal por  numero transacion
			DELETE FROM TMPHISTORCONTRAUSU WHERE NumTransaccion = Aud_NumTransaccion;

		END IF;

		-- SI la configuracion del pasword se encuentra marcada como N =  se mantiene la validacion existente en safi
		-- Para la validacion d ela contraseña utilizada ultimamente
		IF(Var_HabilitaConfPass = Cons_NO) THEN
			IF EXISTS(SELECT Contrasenia FROM HISTORCONTRAUSU WHERE Contrasenia = Par_Contrasenia AND UsuarioID = Par_NumUsuario  )THEN
				SET Par_NumErr		:=	9;
				SET Par_ErrMen		:=	'Contrasenia Utilizada con Anterioridad, Introducir una Diferente';
				SET Var_Control		:=	'contrasenia';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT INTO HISTORCONTRAUSU VALUES (Par_NumUsuario,		ContraAct,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
											Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		UPDATE USUARIOS SET
			Contrasenia		= Par_Contrasenia,
			FechUltPass		= Var_FechaSistema,
			EmpresaID		= Par_EmpresaID,

			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Par_NumUsuario;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT('El Password del Usuario:',CONVERT(Par_NumUsuario, CHAR),' ha sido cambiado correctamente. ');
		SET	Var_Control		:=  'usuarioID';

		LEAVE ManejoErrores;
	END IF;

	-- Inactiva usarios para el proceso de cierre para
	IF(Par_NumAct = Act_InactivaCierre) THEN
		UPDATE USUARIOS SET
			Estatus = Sta_Inactivo,

			EmpresaID	 	= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		Where Estatus = Sta_Activo;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	"Usuarios Inactivados";
		SET Var_Control		:=	'usuarioID';
		LEAVE ManejoErrores;

	END IF;

	-- Activa usarios para el proceso de cierre para
	IF(Par_NumAct = Act_ActivaCierre) THEN
		UPDATE USUARIOS SET
			Estatus = Sta_Activo,

			EmpresaID	 	= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE Estatus = Sta_Inactivo;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	"Usuarios Reactivados";
		SET Var_Control		:=	'usuarioID';
		LEAVE ManejoErrores;

	END IF;

 END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Par_NumUsuario	AS Consecutivo;
    END IF;

END TerminaStore$$
