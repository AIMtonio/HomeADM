-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMUSUARIOSALT`;
DELIMITER $$


CREATE PROCEDURE `BAMUSUARIOSALT`(

    -- SP para enrolar a un cliente del SAFI a la banca movil

    Par_ClienteID 			 INT(11), 			-- El id de cliente a enrolar
	Par_Telefono 			 VARCHAR(20),		-- El num. celular del cliente al cual se ASociara el servicio
	Par_Email				 VARCHAR(50),		-- El email al cual se le enviaran NOTIFicaciones
    Par_NIP					 VARCHAR(50),		-- Nip numerico
    Par_RespuestaPregSecreta VARCHAR(100),		-- Respuesta secreta del usuario

    Par_PerfilID 			 BIGINT(20),		-- Perfil que tenta el usuario en la BM
    Par_PreguntaSecretaID 	 BIGINT(20),		-- Pregunta secreta del usuario
    Par_ImagenPhishingID 	 BIGINT(20), 		-- Este id no se guarda solo se utiliza para obtener una imagen antiphishing y ASignarsela al usuario
    Par_TokenID 			 BIGINT(20),		-- Numero de token para transaccionar en la BM
    Par_ImagenLoginID 		 BIGINT(20),		-- Imagen que cambia cada momento del dia

    Par_FraseBienvenida 	 VARCHAR(50),		-- FrASe de seguridad mostrada en el inicio de sesion
	Par_Salida          	 CHAR(1),			-- S.- Si hay una salida .- No hay una saida
    INOUT Par_NumErr    	 INT(11),				-- Parametro de salida con numero de error
    INOUT Par_ErrMen    	 VARCHAR(400),		-- Parametro de salida con el mensaje de error
    Par_EmpresaID       	 INT(11),           -- Parametros de auditoria

    Aud_Usuario         	 INT(11),			-- Auditoria
    Aud_FechaActual     	 DATETIME,			-- Auditoria
    Aud_DireccionIP     	 VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	 VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	 INT(11),			-- Auditoria

    Aud_NumTransaccion  	 BIGINT(20)			-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_UsuarioID	 BIGINT(20);		-- Variable para ASignarle un id dentro de los usuarios de BM.
    DECLARE Var_Control      VARCHAR(50);		-- Control
    DECLARE Var_Consecutivo  INT;				-- Consecutivo

	-- Declaracion de constantes
	DECLARE Cadena_Vacia     CHAR(1);			-- Texto vacio
	DECLARE Entero_Cero      INT; 				-- Numero 0
	DECLARE SalidaSI         CHAR(1);			-- Indica que si habra una salida
	DECLARE Fecha_Vacia		 DATE;    			-- Fecha vacia
    DECLARE Est_Activo       CHAR(1);			-- Estado Activo
    DECLARE	MinCaracContra	 INT(11);			-- Minimo de Caracteres Contrasena
    DECLARE	VarClienteID	 BIGINT(20);		-- Varible para comprobar que el cliente no exista como usuario de a BM
    DECLARE	VarEmail		 VARCHAR(50);		-- Comprueba que el email no haya sido previamente registrado
    DECLARE	VarTelefono		 VARCHAR(20);		-- Comprueba que el telefono no haya sido previamente registrado
    DECLARE VarImagenBin	 MEDIUMBLOB; 		-- ASigna imagen binaria que toma del catalogo de imagenes

	-- Asignacion  de constantes
	SET Cadena_Vacia    	:= '';              	-- Cadena o string vacio
	SET Entero_Cero     	:= 0;              		-- Entero en cero
	SET SalidaSI        	:= 'S';             	-- El Store SI genera una Salida
    SET	Fecha_Vacia			:= '1900-01-01';    	-- Fecha vacia
    SET Est_Activo   		:= 'A';

    -- Se obtiene el valor para el numero minimo de caracteres en la contrasenia
    SET MinCaracContra := (SELECT LonMinCaracPass FROM PARAMETROSSIS);

	ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMUSUARIOSALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_Email, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Email Esta Vacio';
				SET Var_Control := 'email';
				LEAVE ManejoErrores;
		END IF;

			SELECT 	Email  INTO VarEmail
					FROM BAMUSUARIOS
					WHERE Email LIKE Par_Email LIMIT 1;

		IF(IFNULL(VarEmail,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr= 002;
			SET Par_ErrMen:='El Email Indicado Corresponde a Otro Usuario.';
			SET Var_Control :='email';
			LEAVE ManejoErrores;
			END IF;

        IF(IFNULL(Par_NIP, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'El NIP Esta Vacio';
				SET Var_Control := 'NIP';
				LEAVE ManejoErrores;
			ELSE
		IF(length(Par_NIP) < MinCaracContra) THEN
		SELECT 004 AS NumErr,
				CONCAT('El NIP debe Contener ', MinCaracContra, ' Caracteres.')  AS ErrMen,
				'NIP' AS control,
				Entero_Cero  AS consecutivo;
		LEAVE TerminaStore;
			END IF;
        END IF;

        IF(IFNULL(Par_Telefono, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 005;
				SET	Par_ErrMen	:= 'El Telefono Esta Vacio';
				SET Var_Control := 'telefono';
				LEAVE ManejoErrores;
		END IF;

        SELECT 	Telefono  INTO VarTelefono
					FROM BAMUSUARIOS
					WHERE Telefono LIKE Par_Telefono LIMIT 1;

		IF(IFNULL(VarTelefono, Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr= 006;
			SET Par_ErrMen:='El Telefono Indicado Corresponde a Otro Usuario.';
			SET Var_Control :='email';
			LEAVE ManejoErrores;
			END IF;

        IF(IFNULL(Par_RespuestaPregSecreta, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 007;
				SET	Par_ErrMen	:= 'La Respuesta Secreta Esta Vacia';
				SET Var_Control := 'respuestaSecreta';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_PerfilID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 008;
				SET	Par_ErrMen	:= 'El PerfilID esta vacio';
				SET Var_Control := 'perfilID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 009;
				SET	Par_ErrMen	:= 'El ClienteID esta vacio';
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_PreguntaSecretaID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 010;
				SET	Par_ErrMen	:= 'La Pregunta Secreta Esta Vacia';
				SET Var_Control := 'pregSecretaID';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_ImagenPhishingID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 011;
				SET	Par_ErrMen	:= 'Por favor cambia la Imagen de Seguridad';
				SET Var_Control := 'imgCliente';
				LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TokenID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 012;
				SET	Par_ErrMen	:= 'El TokenID Esta Vacio';
				SET Var_Control := 'tokenID';
				LEAVE ManejoErrores;
        END IF;

		IF(IFNULL(Par_FraseBienvenida, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 013;
				SET	Par_ErrMen	:= 'La Frase de Bienvenida Esta Vacia';
				SET Var_Control := 'frASeBienvenida';
				LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS(SELECT PerfilID
				FROM BAMPERFILES
					WHERE PerfilID = Par_PerfilID) THEN
			SET	Par_NumErr 	:= 014;
			SET	Par_ErrMen	:= 'El PerfilID no Existe en la Tabla BAMPERFILES';
			SET Var_Control := 'perfilID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ClienteID
				FROM CLIENTES
					WHERE ClienteID = Par_ClienteID) THEN
			SET	Par_NumErr 	:= 015;
			SET	Par_ErrMen	:= 'El ClienteID no Existe en la Tabla Clientes';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;
		END IF;

           SELECT 	ClienteID  INTO	varClienteID
					FROM BAMUSUARIOS
					WHERE ClienteID = Par_ClienteID LIMIT 1;

			IF(IFNULL(varClienteID,Cadena_Vacia) <> Cadena_Vacia) THEN
            SELECT 016 AS NumErr,
			'El usuario Ya Cuenta con el Servicio de Banca Movil Registrado. ' AS ErrMen,
			'clienteID' AS Control,
			Entero_Cero AS Consecutivo;
			LEAVE TerminaStore;
			END IF;

        IF NOT EXISTS(SELECT PreguntASecretaID
				FROM BAMPREGSECRETAS
					WHERE PreguntASecretaID = Par_PreguntaSecretaID) THEN
			SET	Par_NumErr 	:= 017;
			SET	Par_ErrMen	:= 'La Pregunta Secreta No Existe en la Tabla BAMPREGTASSECRETAS';
			SET Var_Control := 'preguntaSecretaID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ImagenPhishingID
				FROM BAMIMGANTIPHISHING
					WHERE ImagenPhishingID = Par_ImagenPhishingID) THEN
			SET	Par_NumErr 	:= 018;
			SET	Par_ErrMen	:= 'Cambia la Imagen de Seguridad';
			SET Var_Control := 'imgCliente';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT TokenID
				FROM BAMTOKENS
					WHERE TokenID = Par_TokenID) THEN
			SET	Par_NumErr 	:= 019;
			SET	Par_ErrMen	:= 'El TokenID no Existe en la Tabla BAMTOKENS';
			SET Var_Control := 'tokenID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT ImagenLoginID
				FROM BAMIMAGENLOGIN
					WHERE ImagenLoginID = Par_ImagenLoginID) THEN
			SET	Par_NumErr 	:= 020;
			SET	Par_ErrMen	:= 'La Imagen Login no Existe en la Tabla BAMIMAGENLOGIN';
			SET Var_Control := 'imagenLoginID';

			LEAVE ManejoErrores;
		END IF;

		-- Consecutivo
		CALL FOLIOSAPLICAACT('BAMUSUARIOS', Var_UsuarioID);
        SET  VarImagenBin := (SELECT ImagenBinaria  FROM BAMIMGANTIPHISHING WHERE ImagenPhishingID=Par_ImagenPhishingID );


		INSERT INTO BAMUSUARIOS (
			UsuarioID,			ClienteID,				NIP,					Telefono,			Email,
            FechaUltimoAcceso,	Estatus,				FechaCancelacion,		FechaBloqueo,		MotivoBloqueo,
            MotivoCancelacion,	FechaCreacion,			RespuestaPregSecreta,	FraseBienvenida,	PerfilID,
			PreguntASecretaID,	ImagenAntPhisPerson,	TokenID,				ImagenLoginID,		EmpresaID,
			Usuario,			FechaActual,   			DireccionIP,			ProgramaID,			Sucursal,
			NumTransaccion)
		VALUES (
			Var_UsuarioID,			Par_ClienteID,				Par_NIP,			 	 Par_Telefono,			Par_Email,
            Fecha_Vacia,			Est_Activo,					Fecha_Vacia,		     Fecha_Vacia,      	    Cadena_Vacia,
            Cadena_Vacia,			NOW(),						Par_RespuestaPregSecreta,Par_FraseBienvenida,	Par_PerfilID,
            Par_PreguntaSecretaID,	VarImagenBin, 			    Par_TokenID,			 Par_ImagenLoginID,	    Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,   		    Aud_DireccionIP,		 Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Usuario Agregado Exitosamente';
		SET Var_Control := 'clienteID';

	END ManejoErrores;  -- END del Handler de Errores

		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					IFNULL(Par_ClienteID, Entero_Cero)AS Consecutivo,
                    CONCAT(FNFECHATEXTO(NOW()), " ", DATE_FORMAT(NOW(), '%T')) AS FechaOperacion;
		END IF;

END TerminaStore$$