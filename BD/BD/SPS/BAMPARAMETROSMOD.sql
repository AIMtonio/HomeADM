-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPARAMETROSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPARAMETROSMOD`;DELIMITER $$

CREATE PROCEDURE `BAMPARAMETROSMOD`(
-- Store para actualizar parametros de la baca movil

	Par_MensajeCodigoActSMS 		VARCHAR(45),		-- Especifica el texto que contendra el SMS de activacion
	Par_PasswordCorreoBancaMovil 	VARCHAR(45),		-- Password de correo de notificaciones de banca electronica
	Par_PuertoCorreoBancaMovil		VARCHAR(45),		-- Puerto del correo de banca  electronica
	Par_RutaArchivos 				VARCHAR(45),		-- Ruta de archivos de banca  electronica

	Par_RutaCorreosBancaMovil		VARCHAR(45),		-- Ruta de ktr para envio de correos de banca electronica
	Par_ServidorCorreoBancaMovil	VARCHAR(45),		-- Servidor de correos de banca electronia
	Par_SubjectAltaBancaMovil 		VARCHAR(200),		-- Asunto cuando se registra un cliente a la banca electronica
	Par_SubjectCambiosBancaMovil	VARCHAR(200),		-- Asunto cuando se hace un cambio de configurcion en banca electronica
	Par_SubjectPagosBancaMovil		VARCHAR(200),		-- Asunto cuando se realiza un pago en banca electronica

	Par_SubjectSessionBancaMovil	VARCHAR(200),		-- Asunto cuando se inicia sesion en banca electronia
	Par_SubjectTransferBancaMovil 	VARCHAR(200),		-- Asunto cuando se hace una transferencia en banca movil
	Par_TiempoValidezSMS 			VARCHAR(45),		-- Tiempo de validez de SMS con codigo de activacion B movil
	Par_UsuarioCorreoBancaMovil	 	VARCHAR(45),		-- Usuario para correo de notificaciones con banca electronica
    Par_RemitenteCorreo				VARCHAR(45),		-- Nombre del correo de notificaciones
    Par_NombreInstitucion			VARCHAR(20),		-- Nombre que se mostrara en las opciones de cuenta de la Banca Movil

	Par_Salida          			CHAR(1),			-- Indica si el SP genera una salida
    INOUT Par_NumErr    			INT(11),			-- Auditoria
    INOUT Par_ErrMen    			VARCHAR(400),		-- Auditoria
    Par_EmpresaID       			INT(11),			-- Auditoria
    Aud_Usuario         			INT(11),			-- Auditoria

    Aud_FechaActual     			DATETIME,			-- Auditoria
	Aud_DireccionIP     			VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      			VARCHAR(50),		-- Auditoria
    Aud_Sucursal        			INT(11),			-- Auditoria
    Aud_NumTransaccion  			BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control     		VARCHAR(50);			-- Devuelve el campo de control js

    -- Declaracion de constantes
    DECLARE Cadena_Vacia    		CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero     		INT; 				-- Entero 0
	DECLARE SalidaSI        		CHAR(1);			-- Salida SI

	-- Asignacion  de constantes
	SET Cadena_Vacia    			:='' ;              -- Cadena o string vacio
	SET Entero_Cero     			:= 0 ;              -- Entero en cero
	SET SalidaSI        			:='S';              -- El Store SI genera una Salida

	ManejoErrores: BEGIN
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMPARAMETROSMOD');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        IF(IFNULL(Par_MensajeCodigoActSMS, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Mensaje de Codigo Activacion esta Vacio';
			SET Var_Control := 'mensajeCodAct';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_PasswordCorreoBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 002;
			SET	Par_ErrMen	:= 'La contrasena esta Vacia';
			SET Var_Control := 'passCorreo';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_PuertoCorreoBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 003;
			SET	Par_ErrMen	:= 'El numero de Puerto esta Vacio';
			SET Var_Control := 'numPuerto';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_RutaArchivos, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 004;
			SET	Par_ErrMen	:= 'La Ruta de Archivos esta Vacio';
			SET Var_Control := 'rutaArchivos';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_RutaCorreosBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 005;
			SET	Par_ErrMen	:= 'La Ruta de Correo esta Vacio';
			SET Var_Control := 'servidorCorreo';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_ServidorCorreoBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 006;
			SET	Par_ErrMen	:= 'El  Servidor de Correo esta Vacio';
			SET Var_Control := 'servidorCorreo';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_SubjectAltaBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 007;
			SET	Par_ErrMen	:= 'El Asunto de Alta esta Vacio';
			SET Var_Control := 'asuntoAlta';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_SubjectCambiosBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 008;
			SET	Par_ErrMen	:= 'El Asunto de Cambios esta Vacio';
			SET Var_Control := 'asuntoCambio';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_SubjectPagosBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 009;
			SET	Par_ErrMen	:= 'El Asunto de Pagos esta Vacio';
			SET Var_Control := 'asuntoPagos';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_SubjectSessionBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 001;
			SET	Par_ErrMen	:= 'El Asunto de Sesion esta Vacio';
			SET Var_Control := 'asuntoSesion';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_SubjectTransferBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 010;
			SET	Par_ErrMen	:= 'El Asunto de Transferencia esta Vacio';
			SET Var_Control := 'asuntoTransferencia';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_TiempoValidezSMS, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 011;
			SET	Par_ErrMen	:= 'El Tiempo de Validez esta Vacio';
			SET Var_Control := 'tiempoValidez';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_UsuarioCorreoBancaMovil, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 012;
			SET	Par_ErrMen	:= 'El Usuario de Correo esta Vacio';
			SET Var_Control := 'usuarioCorreo';
			LEAVE ManejoErrores;
		END IF;
        IF(IFNULL(Par_RemitenteCorreo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 013;
			SET	Par_ErrMen	:= 'El Remitente de Correo esta Vacio';
			SET Var_Control := 'remitenteCorreo';
			LEAVE ManejoErrores;
		END IF;
         IF(IFNULL(Par_NombreInstitucion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 014;
			SET	Par_ErrMen	:= 'El Nombre de la Institucion esta Vacio';
			SET Var_Control := 'nombInstitucion';
			LEAVE ManejoErrores;
		END IF;

			UPDATE BAMPARAMETROS SET
				MensajeCodigoActSMS 		=	Par_MensajeCodigoActSMS,
				PasswordCorreoBancaMovil	=	Par_PasswordCorreoBancaMovil,
				PuertoCorreoBancaMovil		=	Par_PuertoCorreoBancaMovil	,
				RutaArchivos				=	Par_RutaArchivos,
				RutaCorreosBancaMovil		=	Par_RutaCorreosBancaMovil,
				ServidorCorreoBancaMovil	=	Par_ServidorCorreoBancaMovil,
				SubjectAltaBancaMovil		=	Par_SubjectAltaBancaMovil,
				SubjectCambiosBancaMovil	=	Par_SubjectCambiosBancaMovil,
				SubjectPagosBancaMovil		=	Par_SubjectPagosBancaMovil,
				SubjectSessionBancaMovil	=	Par_SubjectSessionBancaMovil,
				SubjectTransferBancaMovil	=	Par_SubjectTransferBancaMovil,
				TiempoValidezSMS			=	Par_TiempoValidezSMS,
				UsuarioCorreoBancaMovil		=	Par_UsuarioCorreoBancaMovil,
                RemitenteCorreo				=	Par_RemitenteCorreo,
                NombreInstitucion 			=   Par_NombreInstitucion

				WHERE EmpresaID = Par_EmpresaID;
				SET Par_NumErr  := 000;
				SET Par_ErrMen  := 'Parametros Modificados Exitosamente';
				SET Var_Control := 'nombreInstitucion';

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Aud_NumTransaccion  AS consecutivo;

	END IF;


END TerminaStore$$