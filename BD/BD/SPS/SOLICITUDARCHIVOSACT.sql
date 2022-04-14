DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDARCHIVOSACT;
DELIMITER $$

CREATE PROCEDURE SOLICITUDARCHIVOSACT(
	-- Proceso para actualizar solicitud de archivos.
	-- Modulo: Bandeja de Solicitudes
	Par_SolicitudCreditoID	BIGINT(20),			-- ID de la solicitud de credito
	Par_TipoDocumentoID		INT(11),			-- ID del tipo documento
	Par_DigSolCreditoID 	INT(11),			-- ID del documento de la tabla SOLICITUDARCHIVOS
	Par_VoBoAnalista		CHAR(1),			-- Visto bueno del documento
	Par_ComentarioAnalista	VARCHAR(200),		-- Comentario del documento

	Par_NumAct				TINYINT UNSIGNED,	-- Numero de actualizacion

	Par_Salida				CHAR(1),			-- Salida S:Si N:No
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	-- Parametros de Auditoria --
	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
		)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);	-- Variable de control

	-- Declaracion de   Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATETIME;		-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE	Con_Str_SI			CHAR(1);		-- Constante si
	DECLARE	Con_Str_NO			CHAR(1);		-- Constante no

	-- Declaracion de numero de actualizaciones
	DECLARE Act_Analista		INT(11);		-- Actualizacion para el visto bueno y comentario del analista

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Con_Str_SI				:= 'S';
	SET Con_Str_NO				:= 'N';
	SET Aud_FechaActual			:= NOW();
	SET Par_ComentarioAnalista	:= IFNULL(Par_ComentarioAnalista, Cadena_Vacia);
	SET Par_VoBoAnalista		:= IFNULL(Par_VoBoAnalista, Con_Str_NO);

	-- Asignacion de numero de Actualizacion
	SET Act_Analista			:= 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						 'esto le ocasiona. Ref: SP-SOLICITUDARCHIVOSACT');
				SET Var_Control = 'sqlException';
			END;

			-- 1.- Actualizacion
			IF(Par_NumAct = Act_Analista)THEN
				IF(NOT EXISTS(SELECT SolicitudCreditoID FROM SOLICITUDCREDITO
								WHERE SolicitudCreditoID	= Par_SolicitudCreditoID)) THEN
							SET Par_NumErr	:= 001;
							SET Par_ErrMen	:= 'El Numero de Solicitud no existe';
							SET Var_Control	:= 'solicitudCreditoID';
							LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS(SELECT ClasificaTipDocID FROM CLASIFICATIPDOC
								WHERE ClasificaTipDocID = Par_TipoDocumentoID) THEN
							SET Par_NumErr	:= 002;
							SET Par_ErrMen	:='El Tipo de documento no Existe.';
							SET Var_Control	:='clasificaTipDocID';
							LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS(SELECT DigSolID FROM SOLICITUDARCHIVOS
								WHERE SolicitudCreditoID = Par_SolicitudCreditoID
									AND DigSolID = Par_DigSolCreditoID) THEN
							SET Par_NumErr	:= 002;
							SET Par_ErrMen	:='El Documento no se encuentra Registrado.';
							SET Var_Control	:='digSolID';
							LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_ComentarioAnalista, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr	:= 003;
					SET Par_ErrMen	:= 'El Comentario del Analista est&aacute; Vac&iacute;o.';
					SET Var_Control	:= 'comentarioAnalista';
					LEAVE ManejoErrores;
				END IF;

				-- Actualizacion del analista para el visto bueno y comentario
				UPDATE SOLICITUDARCHIVOS SET
					VoBoAnalista 		= Par_VoBoAnalista,
					ComentarioAnalista	= Par_ComentarioAnalista,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
					AND DigSolID = Par_DigSolCreditoID;
			END IF;

			SET Par_NumErr := 000;
			SET Par_ErrMen := 'Proceso de Actualizaci&oacute;n Realizada Exitosamente';
			SET	Var_Control := 'solicitudCreditoID';

	END ManejoErrores;

	IF(Par_Salida = Con_Str_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_SolicitudCreditoID AS Consecutivo;
	END IF;

END TerminaStore$$