-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWPARAMETROSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWPARAMETROSMOD`;

DELIMITER $$
CREATE PROCEDURE `APPWPARAMETROSMOD`(

	Par_EmpresaID 				INT(20),
	Par_NombreCortoInstit 		VARCHAR(100),
	Par_TextoCodigoActSMS 		VARCHAR(200),
	Par_IvaPorPagarSPEI			DECIMAL(16,2),
	Par_UsuarioEnvioSPEI 		VARCHAR(30),
	Par_RutaArchivos			VARCHAR(45),
	Par_AsuntoNotiAltaTar		VARCHAR(200),
	Par_AsuntNotiCambioTar		VARCHAR(200),
	Par_AsuntoNotiPagosTar		VARCHAR(200),
	Par_AsuntNotiSesionTar		VARCHAR(200),
	Par_AsuntNotiTransfTar		VARCHAR(200),
	Par_TiempoValidezSMS		VARCHAR(45),
	Par_RemitenteTar			VARCHAR(45),
	Par_LonMinCaracPass			INT(11),
	Par_UrlFreja				VARCHAR(150),
	Par_TituloTransaccion		VARCHAR(150),
	Par_PeriodoValidez			INT(11),
	Par_TiempoMaxEspera			INT(11),
	Par_TiempoAprovision		INT(11),

	Par_Salida              	CHAR(1),
    INOUT Par_NumErr        	INT(11),
    INOUT Par_ErrMen        	VARCHAR(400),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME ,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN


    DECLARE Var_Consecutivo		VARCHAR(100);
	DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_NumeroID		INT(11);


	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Salida_SI       	CHAR(1);

	DECLARE Salida_NO       	CHAR(1);
	DECLARE Entero_Uno      	INT(11);
	DECLARE Cons_SI       		CHAR(1);


	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-APPWPARAMETROSMOD');
			SET Var_Control = 'sqlException';
		END;

	    IF(IFNULL(Par_EmpresaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Numero de empresa esta vacio.';
			SET Var_Control		:= 'empresaID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NombreCortoInstit, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'El Nombre de institucion esta vacio.';
			SET Var_Control		:= 'nombreInstitucion';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TextoCodigoActSMS, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'El texto activacion sms esta vacio';
			SET Var_Control		:= 'textActivacion';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_UsuarioEnvioSPEI, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'El usuario que envia SPEI esta vacio.';
			SET Var_Control		:= 'usuarioEvioSPEI';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RutaArchivos, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 6;
			SET Par_ErrMen 		:= 'La ruta de archivos esta vacio.';
			SET Var_Control		:= 'rutaArchivos';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AsuntoNotiAltaTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 7;
			SET Par_ErrMen 		:= 'El campo asunto notificacion de alta esta vacio.';
			SET Var_Control		:= 'notifiAlt';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AsuntNotiCambioTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 8;
			SET Par_ErrMen 		:= 'El campo asunto notificacion cambio esta vacio.';
			SET Var_Control		:= 'notifCambio';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AsuntoNotiPagosTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 9;
			SET Par_ErrMen 		:= 'El campo de asunto de notificacion para pagos esta vacio.';
			SET Var_Control		:= 'notifiPagos';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AsuntNotiSesionTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 10;
			SET Par_ErrMen 		:= 'El campo asunto de notificacion para sesion esta vacio.';
			SET Var_Control		:= 'notifiSesion';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_AsuntNotiTransfTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 11;
			SET Par_ErrMen 		:= 'El campo asunto de notificacion para transferencia esta vacio.';
			SET Var_Control		:= 'notifiTransferencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiempoValidezSMS, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 12;
			SET Par_ErrMen 		:= 'El campo tiempo de valides de SMS esta vacio.';
			SET Var_Control		:= 'tiempoValSMS';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RemitenteTar, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 13;
			SET Par_ErrMen 		:= 'El Remitente de wallet esta vacio.';
			SET Var_Control		:= 'remitente';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LonMinCaracPass, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr 		:= 14;
			SET Par_ErrMen 		:= 'El numero de caracteres minimos para contrasenia esta vacio.';
			SET Var_Control		:= 'minCaracteres';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_UrlFreja, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 15;
			SET Par_ErrMen 		:= 'URL de freja esta vacio.';
			SET Var_Control		:= 'urlFreja';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TituloTransaccion, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 		:= 16;
			SET Par_ErrMen 		:= 'Titulo de la transaccion freja esta vacio.';
			SET Var_Control		:= 'tituloTransaccion';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PeriodoValidez, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr 		:= 17;
			SET Par_ErrMen 		:= 'Periodo de validez es obligatorio.';
			SET Var_Control		:= 'periodoValidez';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiempoMaxEspera, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr 		:= 18;
			SET Par_ErrMen 		:= 'Tiempo maximo de espera es obligatorio.';
			SET Var_Control		:= 'tiempoMaxEspera';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TiempoAprovision, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr 		:= 19;
			SET Par_ErrMen 		:= 'Tiempo de aprovisionamiento es obligatorio.';
			SET Var_Control		:= 'tiempoAprovision';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := NOW();

        UPDATE APPWPARAMETROS SET
			EmpresaID			=   Par_EmpresaID,
			NombreCortoInstit	=   Par_NombreCortoInstit,
			TextoCodigoActSMS	=   Par_TextoCodigoActSMS,
			IvaPorPagarSPEI		=   Par_IvaPorPagarSPEI,
			UsuarioEnvioSPEI	=   Par_UsuarioEnvioSPEI,
			RutaArchivos		=   Par_RutaArchivos,
			AsuntoNotiAltaTar	=   Par_AsuntoNotiAltaTar,
			AsuntNotiCambioTar	=   Par_AsuntNotiCambioTar,
			AsuntoNotiPagosTar	=   Par_AsuntoNotiPagosTar,
			AsuntNotiSesionTar	=   Par_AsuntNotiSesionTar,
			AsuntNotiTransfTar	=   Par_AsuntNotiTransfTar,
			TiempoValidezSMS	=   Par_TiempoValidezSMS,
			RemitenteTar		=   Par_RemitenteTar,
			LonMinCaracPass		=   Par_LonMinCaracPass,
			URLFreja			=   Par_UrlFreja,
			TituloTransaccion	=   Par_TituloTransaccion,
			PeriodoValidez		=   Par_PeriodoValidez,
			TiempoMaxEspera		=   Par_TiempoMaxEspera,
			TiempoAprovision	=   Par_TiempoAprovision,
			Usuario				=   Aud_Usuario,
			FechaActual			=   Aud_FechaActual,
			DireccionIP			=   Aud_DireccionIP,
			ProgramaID			=   Aud_ProgramaID,
			Sucursal			=   Aud_Sucursal,
			NumTransaccion		=   Aud_NumTransaccion
		WHERE EmpresaID = Par_EmpresaID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Registro Modificado Exitosamente: ', Par_EmpresaID);
		SET Var_Control		:= 'empresaID';
		SET Var_Consecutivo	:= Par_EmpresaID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$