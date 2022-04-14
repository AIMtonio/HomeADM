-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSACT`;DELIMITER $$

CREATE PROCEDURE `RATIOSACT`(
	/*SP para Actualizar los comentarios y estatus de autorizacion del proceso de ratios*/
	Par_SolicitudCreditoID		INT(11),				# Numero de Solicitud de credito
	Par_Usuario					INT(11),				# Usuario que Rechaza, Regresa, Procesa;Autoriza
	Par_Motivo 					VARCHAR(800),			# Comentario (El tamaño del mensaje no puede ser mayor a 800 a  menos que cambie el tamaño del comentario de la solicitud de credito)
	Par_NumAct					TINYINT UNSIGNED,		# Numero de Actualizacion 1: Rechazar 2:Regresar 3:Procesar

	Par_Salida					CHAR(1),				# Salida S:Si No:No
	INOUT Par_NumErr			INT(11),				# Numero de error
	INOUT Par_ErrMen			VARCHAR(400),			# Mensaje de error
	/*Auditoria*/
	Aud_EmpresaID				INT(11),				# Auditoria
	Aud_Usuario					INT(11),				# Auditoria

	Aud_FechaActual				DATETIME,				# Auditoria
	Aud_DireccionIP				VARCHAR(15),			# Auditoria
	Aud_ProgramaID				VARCHAR(50),			# Auditoria
	Aud_Sucursal				INT(11),				# Auditoria
	Aud_NumTransaccion			BIGINT(20)				# Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE SalidaSI			CHAR(1);		# Salida Si
	DECLARE Cadena_Vacia		CHAR(1);		# Salida Si
	DECLARE Act_Rechazo			INT(11);
	DECLARE Act_Regreso			INT(11);
	DECLARE Act_Procesar		INT(11);
	DECLARE Estatus_Rechazo		CHAR(1);		# Estatus de Rechazo
	DECLARE Estatus_Calculado	CHAR(1);		# Estatus de Ratios Calculado
	DECLARE Estatus_GuardadoCal	CHAR(1);		# Estatus de Ratios Calculado y Guardado
	DECLARE Estatus_Procesado	CHAR(1);		# Estatus de ratios Procesado; Autorizado
	DECLARE Estatus_Regresado	CHAR(1);		# Estatus cuando se regresa la solicitud al ejecutivo

	-- Declaracion de variables
	DECLARE Var_FechaActual		DATE;				-- Fecha del sistema
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_NombreUSuario	VARCHAR(100);		-- Nombre del usuario



	-- Asignacion de constantes
	SET SalidaSI				:= 'S';				-- Salida Si
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Act_Regreso				:= 3;				-- Actualizcion de Regreso
	SET Act_Rechazo				:= 4;				-- Actualizacion de rechazo
	SET Act_Procesar			:= 5;				-- Actualizacion de proceso (autorizacion)
	SET Estatus_Rechazo			:= 'R';				-- Estatus de Rechazo
	SET Estatus_Calculado		:= 'C';				-- Estatus de Ratios Calculado
	SET Estatus_GuardadoCal		:= 'G';				-- Estatus de Ratios Calculado y Guardado
	SET Estatus_Procesado		:= 'P';				-- Estatus de ratios Procesado; Autorizado
	SET Estatus_Regresado		:= 'E';				-- Estatus cuando se regresa la solicitud al ejecutivo
    SET Aud_FechaActual			:= NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-RATIOSACT');
			SET Var_Control := 'sqlException' ;
		END;

		SELECT
			FechaSistema INTO Var_FechaActual
			FROM PARAMETROSSIS
				LIMIT 1;
		SELECT	Usu.NombreCompleto
			INTO 	Var_NombreUSuario
			FROM USUARIOS Usu
				WHERE Usu.UsuarioID = Aud_Usuario;
	 	/* Actualizacion 1:  Rechazo de la solicitud de credito desde la pantalla de ratios*/
		IF(Par_NumAct = Act_Rechazo) THEN

			UPDATE RATIOS SET
				UsuarioRechazo		= Par_Usuario,
				FechaRechazo		= Var_FechaActual,
				ComentarioRech		= Par_Motivo,
				Estatus 			= Estatus_Rechazo,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE SolicitudCreditoID 	= Par_SolicitudCreditoID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Se Rechazo la Solicitud de Credito:', Par_SolicitudCreditoID);
			SET Var_Control	:= 'solicitudCreditoID' ;
			SET Var_Consecutivo := Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;

		/* Actualizacion 2: Actualizacion cuando se regresa la solicitud al ejecutivo*/
		IF(Par_NumAct = Act_Regreso) THEN
			UPDATE RATIOS SET
				ComentarioEjecutivo		= CONCAT('--> ', CAST( NOW() AS CHAR),' -- ',Var_NombreUSuario,' ----- ',  TRIM(Par_Motivo)),
				Estatus 				= Estatus_Regresado,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE SolicitudCreditoID 	= Par_SolicitudCreditoID;
			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('La Solicitud Fue Enviada de Regreso al Ejecutivo con Exito.');
			SET Var_Control	:= 'solicitudCreditoID' ;
			SET Var_Consecutivo := Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;

		/* Actualizacion 3: Actualizacion de Proceso;Autorizacion de la solicitud*/
		IF(Par_NumAct = Act_Procesar) THEN

			UPDATE RATIOS SET
				UsuarioAutoriza				= Par_Usuario,
				FechaAutoriza				= Var_FechaActual,
				ComentarioMesaControl		= Par_Motivo,
				Estatus 					= Estatus_Procesado,

				EmpresaID					= Aud_EmpresaID,
				Usuario						= Aud_Usuario,
				FechaActual					= Aud_FechaActual,
				DireccionIP					= Aud_DireccionIP,
				ProgramaID					= Aud_ProgramaID,
				Sucursal					= Aud_Sucursal,
				NumTransaccion				= Aud_NumTransaccion
				WHERE SolicitudCreditoID 	= Par_SolicitudCreditoID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Se Autoriza el Proceso de la Solicitud de Credito: ', Par_SolicitudCreditoID);
			SET Var_Control	:= 'solicitudCreditoID' ;
			SET Var_Consecutivo := Par_SolicitudCreditoID;
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$