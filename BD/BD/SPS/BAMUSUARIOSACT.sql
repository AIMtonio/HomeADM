-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMUSUARIOSACT`;DELIMITER $$

CREATE PROCEDURE `BAMUSUARIOSACT`(
-- Store para actualizar un dato de un cliente usuario de la banca movil

    Par_ClienteID			INT(11),			-- Cliente usuario de la banca movil que se actualizara
    Par_NumAct				TINYINT(1),			-- Tipo de actualizacion a realizar
    Par_MotivoBloqueo		VARCHAR(200),		-- Si es una act. de bloqueo se especifica un motivo.
    Par_MotivoCancelacion	VARCHAR(200),		-- Si es una cancelacion. se especifica uun motivo.
    Par_NIP					VARCHAR(100),		-- Nuevo nip del usuario

    Par_PregSecreta			BIGINT(20),			-- Nueva pregunta secreta del usuario
    Par_Respuesta			VARCHAR(100),		-- Respuesta secreta del usuario
    Par_FraseBienvenida		VARCHAR(50),		-- Nueva frase de bienvenida del usario
    Par_ImagenAntPhisPerson MEDIUMBLOB,			-- Nueva imagen antiphishing en binario
	Par_Salida          	CHAR(1),			-- Especifica si se necesita una salida o no

    INOUT Par_NumErr    	INT(11),				-- Parametro de salida con numero de error
    INOUT Par_ErrMen    	VARCHAR(400),		-- Parametro de salida con mensaje de error
    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria

	Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control     		VARCHAR(50);	-- Devuelve al  usuario al usuario un campo de control

    -- Declaracion de constantes
    DECLARE Cadena_Vacia    		CHAR(1);		-- Cadena vacia
    DECLARE Fecha_Vacia     		VARCHAR(15);	-- Fecha vacia
	DECLARE Entero_Cero     		INT; 			-- Entero cero
	DECLARE SalidaSI        		CHAR(1);		-- Salida SI
    DECLARE Act_Activo        		INT(1);			-- Actualiza a activo el estatus del usuario
	DECLARE Act_Reactivo			INT(1);			-- Actualiza a activo el estatus del usuario cancelado
    DECLARE Act_Inactivo        	INT(1);			-- Actualiza a inactivo es estatus del usuario
    DECLARE Act_Bloqueado       	INT(1);			-- Actualiza a bloqueado el estatus del usuario
    DECLARE Act_Cancelado       	INT(1);			-- Actualiza a cancelado el estutus del usuario
	DECLARE Act_CambioNIP		  	INT(1);			-- Actualiza el nip del usuario
    DECLARE Act_PregSecreta   		INT(1);			-- Actualiza la pregunta secreta del usuario
    DECLARE Act_FraseBienvenida   	INT(1);			-- Actualiza la frase de bienvenida del usuario
    DECLARE Act_UltAcceso   		INT(1);			-- Actuliza el acceso a la banca movil del usuario.
	DECLARE Act_ImgAntiPhs   		INT(1);			-- Actualiza la imagen antiphishing del usuario
    DECLARE Est_Activo 				CHAR(1);		-- Estatus activo
    DECLARE Est_Inactivo			CHAR(1);		-- Estatus Inactivo
    DECLARE Est_Bloqueado			CHAR(1);		-- Estatus Bloquedo
    DECLARE Est_Cancelado			CHAR(1);		-- Estatus canceldao

	-- Asignacion  de constantes
	SET Cadena_Vacia    			:='' ;              -- Cadena o string vacio
	SET Entero_Cero     			:= 0 ;              -- Entero en cero
    SET Fecha_Vacia					:='1900-01-01';		-- Fecha vacia
	SET SalidaSI        			:='S';              -- El Store SI genera una Salida
    SET Act_Activo					:= 0 ;              -- Act usuario activo
    SET Act_Reactivo				:= 9 ;				-- Act usuario activo de cancelacion
    SET Act_Inactivo				:= 1 ;				-- Act usuario  n inactivo
    SET Act_Bloqueado				:= 2 ;				-- Act usuario  bloqueado
    SET Act_Cancelado				:= 3 ;				-- Act usuario  cancelado
	SET Act_CambioNIP				:= 4 ;				-- CAMBIO DE NIP
    SET Act_PregSecreta				:= 5 ;				-- CAMBIO DE PREG SECRETA
    SET Act_FraseBienvenida			:= 6 ;				-- CAMBIO DE FRASE
    SET Act_UltAcceso				:= 7 ;				-- Actualiza el acceso a la banca movil
    SET Act_ImgAntiPhs		   	    := 8 ;				-- Cambio Img Antiphising personalizada
	SET Est_Activo 					:='A';				-- Estatus activo
    SET Est_Inactivo				:='I';				-- Estatus Inactivo
    SET Est_Bloqueado				:='B';				-- Estatus Bloquedo
    SET Est_Cancelado				:='C';				-- Estatus canceldao
	SET Aud_FechaActual 		    := NOW() ;

	ManejoErrores: BEGIN
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMUSUARIOSACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El ClienteID  Esta Vacio';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_NumAct, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'El Tipo de Actualizacion Esta Vacio';
			SET Var_Control := 'tipoAct';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ClienteID
				FROM BAMUSUARIOS
					WHERE ClienteID = Par_ClienteID) THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'El Cliente no Existe en la Tabla Usuarios';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_NumAct = Act_Activo) THEN
			UPDATE BAMUSUARIOS SET
				Estatus = Est_Activo,
                MotivoBloqueo=Cadena_Vacia,
                FechaBloqueo=Fecha_Vacia,

                EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;

            SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Usuario Desbloqueado Exitosamente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NumAct = Act_Inactivo) THEN
			UPDATE BAMUSUARIOS SET
				Estatus = Est_Inactivo,
				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;

            SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Usuario Inactivado Correctamente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
  		END IF;

		IF (Par_NumAct = Act_Bloqueado) THEN
			UPDATE BAMUSUARIOS SET
				Estatus = Est_Bloqueado,
				MotivoBloqueo=Par_MotivoBloqueo,
                FechaBloqueo= Aud_FechaActual,

				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Usuario Bloqueado Exitosamente';
			SET Var_Control := 'clienteID';
       		LEAVE ManejoErrores;
       END IF;

       IF(Par_NumAct = Act_Reactivo) THEN
			UPDATE BAMUSUARIOS SET
				Estatus = Est_Activo,
                MotivoCancelacion=Cadena_Vacia,
                FechaCancelacion=Fecha_Vacia,

                EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Usuario Activado Exitosamente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
       END IF;

		IF (Par_NumAct = Act_Cancelado) THEN
			UPDATE BAMUSUARIOS SET
				Estatus = Est_Cancelado,
				MotivoCancelacion=Par_MotivoCancelacion,
                FechaCancelacion= Aud_FechaActual,

				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Usuario Cancelado Exitosamente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NumAct = Act_CambioNIP) THEN
			IF(IFNULL(Par_NIP, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= 'El NIP Esta Vacio';
				SET Var_Control := 'NIP';
				LEAVE ManejoErrores;
			END IF;
				UPDATE BAMUSUARIOS SET
					NIP = Par_NIP,
					EmpresaID	 		= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion

					WHERE ClienteID = Par_ClienteID;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Contraseña Actualizado Exitosamente';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;

		IF (Par_NumAct = Act_PregSecreta) THEN

				UPDATE BAMUSUARIOS SET
					PreguntaSecretaID 	=Par_PregSecreta,
                   RespuestaPregSecreta	=Par_Respuesta,
					EmpresaID	 		= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion

					WHERE ClienteID = Par_ClienteID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Pregunta y Respuesta Secreta Cambiadas Correctamente';
			SET Var_Control := 'preguntaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_NumAct = Act_FraseBienvenida) THEN
			IF(IFNULL(Par_FraseBienvenida, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 005;
				SET	Par_ErrMen	:= 'La Frase de Bienvenida Esta Vacia';
				SET Var_Control := 'fraseBienvenida';
				LEAVE ManejoErrores;
			END IF;

				UPDATE BAMUSUARIOS SET
					FraseBienvenida = Par_FraseBienvenida,

					EmpresaID	 		= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion

					WHERE ClienteID = Par_ClienteID;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Frase de Bienvenida Actualizada Correctamente';
				SET Var_Control := 'fraseBienvenida';
				LEAVE ManejoErrores;
			END IF;

		IF (Par_NumAct = Act_UltAcceso) THEN
			UPDATE BAMUSUARIOS SET
				FechaUltimoAcceso = Aud_FechaActual,
				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Acceso Exitoso';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
         END IF;

		IF (Par_NumAct = Act_ImgAntiPhs) THEN
			UPDATE BAMUSUARIOS SET
				ImagenAntPhisPerson = Par_ImagenAntPhisPerson,
				EmpresaID	 		= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

				WHERE ClienteID = Par_ClienteID;
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Imagen Antiphishing Actualizada Correctamente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
        END IF;

	 END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Aud_NumTransaccion  AS consecutivo,
				CONCAT(FNFECHATEXTO(NOW()), " ", DATE_FORMAT(NOW(), '%T')) AS FechaOperacion;
	END IF;


END TerminaStore$$