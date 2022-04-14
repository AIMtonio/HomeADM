-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWUSUARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWUSUARIOSALT`;

DELIMITER $$
CREATE PROCEDURE `APPWUSUARIOSALT`(


   Par_ClienteID 			 INT(11),
	Par_Telefono 			 VARCHAR(20),
   Par_PrimerNombre      VARCHAR(200),
   Par_SegundoNombre     VARCHAR(200),
   Par_TercerNombre      VARCHAR(200),
   Par_ApellidoPaterno   VARCHAR(200),
   Par_ApellidoMaterno   VARCHAR(200),
   Par_NombreCompleto    VARCHAR(200),
	Par_Correo   			 VARCHAR(200),
   Par_Contrasenia  	    VARCHAR(200),
	Par_CURP					 VARCHAR(25),
   Par_PrefijoTelefono   VARCHAR(100),
   Par_FechanNacimiento  VARCHAR(100),
   Par_FechanRegistro  VARCHAR(100),
   Par_ImagenPhishingNumber 	 int(5),
	Par_Salida          	 CHAR(1),
   INOUT Par_NumErr    	 INT(11),
   INOUT Par_ErrMen    	 VARCHAR(400),

   Par_EmpresaID       	 INT(11),
    Aud_Usuario         	 INT(11),
    Aud_FechaActual     	 DATETIME,
    Aud_DireccionIP     	 VARCHAR(15),
    Aud_ProgramaID      	 VARCHAR(50),
    Aud_Sucursal        	 INT(11),
    Aud_NumTransaccion  	 BIGINT(20)
	)

TerminaStore: BEGIN


	DECLARE var_Tiene_NIP    INT;
	DECLARE Var_UsuarioID	 BIGINT(20);
	DECLARE Var_ClienteID	 BIGINT(20);
    DECLARE Var_Control      VARCHAR(50);
    DECLARE Var_Consecutivo  INT;


	DECLARE Cadena_Vacia     CHAR(1);
	DECLARE Entero_Cero      INT;
	DECLARE SalidaSI         CHAR(1);
	DECLARE Fecha_Vacia		 DATE;
   DECLARE Est_Activo       CHAR(1);
   DECLARE Est_Sesion       CHAR(1);
   DECLARE	MinCaracContra	 INT(11);
   DECLARE	VarClienteID	 BIGINT(20);
   DECLARE	VarCorreo		 VARCHAR(50);
   DECLARE	VarTelefono		 VARCHAR(20);


	SET var_Tiene_NIP    :=1;
	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET SalidaSI        	:= 'S';
   SET Fecha_Vacia		:= '1900-01-01';
   SET Est_Activo   		:= 'A';
   SET Est_Sesion   		:= 'I';


    SET MinCaracContra := (SELECT LonMinCaracPass FROM PARAMETROSSIS);

	ManejoErrores: BEGIN
     	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-APPWUSUARIOSALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_Correo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Email Esta Vacio';
				SET Var_Control := 'email';
				LEAVE ManejoErrores;
		END IF;

			SELECT Correo INTO VarCorreo
					FROM APPWUSUARIOS
					WHERE Correo LIKE Par_Correo LIMIT 1;

		IF(IFNULL(VarCorreo,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr= 002;
			SET Par_ErrMen:='El Email Indicado Corresponde a Otro Usuario.';
			SET Var_Control :='email';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Contrasenia, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'La Contrasenia Esta Vacia';
				SET Var_Control := 'Contrasenia';
				LEAVE ManejoErrores;
			ELSE
		IF(length(Par_Contrasenia) < MinCaracContra) THEN
		SELECT 004 AS NumErr,
				CONCAT('La contrasenia debe Contener ', MinCaracContra, ' Caracteres.')  AS ErrMen,
				'Contrasenia' AS control,
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

        SELECT TelefonoCelular INTO VarTelefono
					FROM APPWUSUARIOS
					WHERE TelefonoCelular LIKE Par_Telefono LIMIT 1;

		IF(IFNULL(VarTelefono, Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr= 006;
			SET Par_ErrMen:='El Telefono Indicado Corresponde a Otro Usuario.';
			SET Var_Control :='Telefono';
			LEAVE ManejoErrores;
			END IF;

        IF(IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 008;
				SET	Par_ErrMen	:= 'El CURP esta vacio';
				SET Var_Control := 'CURP';
				LEAVE ManejoErrores;
		END IF;

      IF(IFNULL(Par_ClienteID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 009;
				SET	Par_ErrMen	:= 'El ClienteID esta vacio';
				SET   Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;

         SELECT 	ClienteID  INTO	Var_ClienteID
			FROM APPWUSUARIOS
			WHERE ClienteID = Par_ClienteID LIMIT 1;

			IF(IFNULL(Var_ClienteID,Cadena_Vacia) <> Cadena_Vacia) THEN
            SELECT 016 AS NumErr,
			'El usuario Ya Cuenta con el Servicio de Wallet Registrado. ' AS ErrMen,
			'clienteID' AS Control,
			Entero_Cero AS Consecutivo;
			LEAVE TerminaStore;
			END IF;


      IF(IFNULL(Par_ImagenPhishingNumber, Entero_Cero)) = Entero_Cero THEN
				SET	Par_NumErr 	:= 009;
				SET	Par_ErrMen	:= 'La Imagen Esta Vacia';
				SET   Var_Control := 'clienteID';
				LEAVE ManejoErrores;
		END IF;



		CALL FOLIOSAPLICAACT('APPWUSUARIOS', Var_UsuarioID);

		INSERT INTO APPWUSUARIOS (
			UsuarioID,			   ClienteID,		      Contrasenia,           		PrimerNombre,
         SegundoNombre,       TercerNombre,        ApellidoPaterno,       		ApellidoMaterno,
         NombreCompleto,      CURP,            		Estatus,               		FechaCreacion,
         TelefonoCelular,     PrefijoTelefonico,   ImagenAntiphishingNumber,  FechaNacimiento,
         LoginsFallidos,      EstatusSesion,       FechaCancel,           		MotivoCancel,        FechaBloqueo,        MotivoBloqueo,       DispositivoID,         		FechaUltAcceso,
			Correo, 					Tiene_NIP,     			EmpresaID,           		Usuario,
			FechaActual,         DireccionIP,      	ProgramaID,          		Sucursal,
			NumTransaccion)
		VALUES (
			Var_UsuarioID,		   Par_ClienteID,		   Par_Contrasenia,		   Par_PrimerNombre,
         Par_SegundoNombre,   Par_TercerNombre,    Par_ApellidoPaterno,    Par_ApellidoMaterno,
         Par_NombreCompleto,  Par_CURP,        Est_Activo,      			NOW(),
         Par_Telefono,        Par_PrefijoTelefono, Par_ImagenPhishingNumber,     Par_FechanNacimiento,
         Entero_Cero,        EstatusSesion,        Fecha_Vacia,            Cadena_Vacia,
         Fecha_Vacia,         Cadena_Vacia,        Cadena_Vacia,           Fecha_Vacia,
         Par_Correo,          var_Tiene_NIP,         Par_EmpresaID,       Aud_Usuario,
		 	Aud_FechaActual,        Aud_DireccionIP,  Aud_ProgramaID,      Aud_Sucursal,
			Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Usuario Agregado Exitosamente';
		SET Var_Control := 'clienteID';

	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					IFNULL(Par_ClienteID, Entero_Cero)AS Consecutivo,
                    CONCAT(FNFECHATEXTO(NOW()), " ", DATE_FORMAT(NOW(), '%T')) AS FechaOperacion;
		END IF;

END TerminaStore$$