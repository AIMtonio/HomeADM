-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMUSUARIOSMOD`;
DELIMITER $$


CREATE PROCEDURE `BAMUSUARIOSMOD`(

-- SP Para modificar los datos de un usuario de banca movil
    Par_ClienteID			 INT(11),			-- Cliente usuario de banca movil que modificaremos
	Par_Telefono 			 VARCHAR(20),			-- Nuevo numero de telefono
	Par_Email				 VARCHAR(50),			-- Nuevo Email
    Par_RespuestaPregSecreta VARCHAR(100),			-- Nueva respuesta de pregunta secreta
	Par_FraseBienvenida 	 VARCHAR(45),			-- Nueva frase de bienvenida

    Par_PerfilID 			 BIGINT(20),			-- Nuevo perfil del usuario
    Par_PreguntaSecretaID 	 BIGINT(20),			-- Id de la preg. secreta del usuario.
    Par_TokenID 			 BIGINT(20),   			-- Token ID del usuario
    Par_ImagenLoginID 		 BIGINT(20),			-- Imagen login del usuario
	Par_Salida          	 CHAR(1),				-- Si el SP genera o no una salida.

    INOUT Par_NumErr    	 INT(11),				-- Parametro de salida con numero de error
    INOUT Par_ErrMen    	 VARCHAR(400),			-- Parametro de salida con el mensaje de error
	Par_EmpresaID			 INT(11),				-- Auditoria
	Aud_Usuario				 INT(11),				-- Auditoria
	Aud_FechaActual			 DATETIME,				-- Auditoria

	Aud_DireccionIP			 VARCHAR(15),			-- Auditoria
	Aud_ProgramaID			 VARCHAR(50),			-- Auditoria
	Aud_Sucursal			 INT(11),				-- Auditoria
	Aud_NumTransaccion		 BIGINT(20)				-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control     VARCHAR(50);			-- Variable de Control

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT;				-- Entero 0
	DECLARE SalidaSI        	CHAR(1);			-- Salida SI

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';			-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha vacia
	SET	Entero_Cero			:= 0;			-- Entero cero
	SET SalidaSI        	:= 'S'; 		-- El Store SI genera una Salida

	ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMUSUARIOSMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_Email, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Email Esta Vacio';
				SET Var_Control := 'email';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Telefono, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'El Telefono Esta Vacio';
				SET Var_Control := 'telefono';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_RespuestaPregSecreta, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'La Respuesta Secreta Esta Vacia';
				SET Var_Control := 'respuestaSecreta';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FraseBienvenida , Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= 'La Frase de Bienvenida Esta Vacia';
				SET Var_Control := 'fraseBienvenida';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_PerfilID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 005;
				SET	Par_ErrMen	:= 'El PerfilID Esta Vacio';
				SET Var_Control := 'perfilID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 006;
				SET	Par_ErrMen	:= 'El ClienteID Esta Vacio';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_PreguntaSecretaID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 007;
				SET	Par_ErrMen	:= 'La Pregunta Secreta Esta Vacia';
				SET Var_Control := 'preguntaSecretaID';
				LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT  PerfilID
				FROM BAMPERFILES
					WHERE PerfilID = Par_PerfilID) THEN
			SET	Par_NumErr 	:= 008;
			SET	Par_ErrMen	:= 'El PerfilID No Existe en la Tabla BAMPERFILES';
			SET Var_Control := 'perfilID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT  ClienteID
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID) THEN
			SET	Par_NumErr 	:= 009;
			SET	Par_ErrMen	:= 'El ClienteID No Existe en la Tabla Clientes';
			SET Var_Control := 'cienteID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT  PreguntASecretaID
				FROM BAMPREGSECRETAS
					WHERE PreguntASecretaID = Par_PreguntASecretaID) THEN
			SET	Par_NumErr 	:= 010;
			SET	Par_ErrMen	:= 'La Pregunta Secreta No Existe en la Tabla BAMPREGTASSECRETAS';
			SET Var_Control := 'preguntaSecretaID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT  ImagenLoginID
				FROM BAMIMAGENLOGIN
					WHERE ImagenLoginID = Par_ImagenLoginID) THEN
			SET	Par_NumErr 	:= 011;
			SET	Par_ErrMen	:= 'La ImagenLoginID No Existe en la Tabla BAMIMAGENLOGIN';
			SET Var_Control := 'imagenLoginID';
			LEAVE ManejoErrores;
		END IF;


	SET Aud_FechaActual	:= NOW();


		UPDATE BAMUSUARIOS SET
			Email					= Par_Email,
			Telefono  			    = Par_Telefono,
			RespuestaPregSecreta	= Par_RespuestaPregSecreta,
			FraseBienvenida		    = Par_FraseBienvenida,
			PerfilID				= Par_PerfilID,
			PreguntASecretaID       = Par_PreguntaSecretaID,
			TokenID					= Par_TokenID,
			ImagenLoginID			= Par_ImagenLoginID,

			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
			WHERE ClienteID         = Par_ClienteID;

				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Usuario Modificado Exitosamente';
				SET Var_Control := 'clienteID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT   Par_NumErr AS NumErr,
				 Par_ErrMen AS ErrMen,
				 Var_Control AS control,
				 IFNULL (Par_ClienteID, Entero_Cero) AS consecutivo;
	END IF;

END TerminaStore$$