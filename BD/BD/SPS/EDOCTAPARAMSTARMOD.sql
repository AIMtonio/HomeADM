-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPARAMSTARMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPARAMSTARMOD`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAPARAMSTARMOD`(
	-- SP para Parametrizar el Estado de Cuenta
	Par_MontoMin			DECIMAL(16,2),		-- Monto Minimo para generar CFDI
	Par_RutaExpPDF			VARCHAR(250),		-- Ruta para el Alojamiento del Estado de Cuenta
	Par_RutaReporte			VARCHAR(250),		-- Ruta del Reporte que genera el Estado de Cuenta (.prpt)
	Par_CiudadUEAUID		INT(11),			-- Numero de la Entidad Federativa Unidad Especializada de Atencion a Usuarios (UEAU)
	Par_CiudadUEAU			CHAR(45),			-- Nombre de la Entidad Federativa Unidad Especializada de Atencion a Usuarios (UEAU)

	Par_TelefonoUEAU		VARCHAR(45),		-- Numero Telefono de la Unidad Especializada de Atencion a Usuarios (UEAU)
	Par_OtrasCiuUEAU		VARCHAR(45),		-- Numero Telefono otra Ciudad de la Unidad Especializada de Atencion a Usuarios (UEAU)
	Par_HorarioUEAU			VARCHAR(45),   		-- Horario de Atencion de la Unidad Especializada de Atencion a Usuarios (UEAU)
	Par_DireccionUEAU		VARCHAR(250),   	-- Direccion de la Unidad Especializada de Atencion a Usuarios (UEAU)
	Par_CorreoUEAU			VARCHAR(45),		-- Correo Electronico de la Unidad Especializada de Atencion a Usuarios (UEAU)

    Par_RutaCBB				VARCHAR(60),		-- Ruta Alojamiento Codigo Binario (CBB)
	Par_RutaCFDI			VARCHAR(60),      	-- Ruta Alojamiento CFDI (.xml)
	Par_RutaLogo			VARCHAR(90),		-- Ruta de Alojamiento del Logo para mostrar en Estado de Cuenta
	Par_TipoCuentas			VARCHAR(45),		-- Tipo de Cuentas
	Par_ExtTelefonoPart		VARCHAR(6),			-- Numero de Extension del Telefono de la Unidad Especializada de Atencion a Usuarios (UEAU)

    Par_ExtTelefono			VARCHAR(6),			-- Numero de Extension del Telefono otra Ciudad de la Unidad Especializada de Atencion a Usuarios (UEAU)

	Par_EnvioAutomatico		CHAR(1),			-- Indica si la funcionalidad de Envio por correo de Estados de cuenta esta activada o desactivada
	Par_CorreoRemitente		VARCHAR(50),		-- Cuenta de correo electronico desde donde se enviaran los mails para Estados de Cuenta
	Par_ServidorSMTP		VARCHAR(50),		-- Nombre del servidor SMTP para el envio de correos
	Par_PuertoSMTP			INT(11),			-- Numero de puerto de salida para el envio de correo
	Par_UsuarioRemitente	VARCHAR(50),		-- Usuario del correo remitente, del cual se enviaran los mails
	Par_Contrasenia			VARCHAR(50),		-- Clave del correo remitente, del cual se enviaran los mails
	Par_Asunto				VARCHAR(100),		-- Asunto del correo electronico
	Par_CuerpoTexto			TEXT,				-- Cuerpo del correo donde ira todo el texto, puede ser texto plano o HTML
	Par_RequiereAut			CHAR(1),			-- Indica si se requiere una autentificacion segura
	Par_TipoAut				VARCHAR(10),		-- Tipo de autentificacion para el envio de correo

	Par_Salida				CHAR(1),			-- Descripcion de Salida
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Descripcion del Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT

	)

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);	-- Control de Errores
	DECLARE	Var_NumInstitucion  INT;			-- Numero de Institucion de la tabla PARAMETROSSIS

	DECLARE Cadena_Vacia	CHAR;				-- Cadena Vacia
	DECLARE Entero_Cero		INT;				-- Entero Cero
	DECLARE SalidaSI		CHAR(1);			-- Tipo Salida: SI


	SET Cadena_Vacia		:='';		-- Cadena Vacia
	SET Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:='S';		-- Tipo Salida: SI

	ManejoErrores: BEGIN
			IF (IFNULL(Par_MontoMin,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := "El monto minimo no debe de estar vacio";
				SET Var_Control	:='montoMin';
				LEAVE ManejoErrores;
			END IF;
			IF (IFNULL(Par_RutaExpPDF,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := "La ruta para exportar PDF esta vacia";
				SET Var_Control	:='rutaExpPDF';
				LEAVE ManejoErrores;
			END IF;
			IF (IFNULL(Par_RutaReporte,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := "La ruta del reporte esta vacia";
				SET Var_Control	:='rutaReporte';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_CiudadUEAUID,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=5;
				SET Par_ErrMen	:="Numero de la Ciudad esta Vacio";
				SET Var_Control	:='CiudadUEAUID';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_CiudadUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=6;
				SET Par_ErrMen	:="El valor de la Ciudad esta vacia";
				SET Var_Control	:='ciudadUEAU';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_HorarioUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=9;
				SET Par_ErrMen	:="Horario vacio";
				SET Var_Control	:='horarioUEAU';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_DireccionUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=10;
				SET Par_ErrMen	:="La direccion esta vacia";
				SET Var_Control	:='direccionUEAU';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_CorreoUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=11;
				SET Par_ErrMen	:="Campo correo debe contener un valor";
				SET Var_Control	:='correoUEAU';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_RutaCBB,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=12;
				SET Par_ErrMen	:="La ruta CBB esta vacia";
				SET Var_Control	:='rutaCBB';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_RutaCFDI,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=13;
				SET Par_ErrMen	:="La ruta CFDI esta vacia";
				SET Var_Control	:='rutaCFDI';
				LEAVE ManejoErrores;
			END IF;
		IF(IFNULL(Par_RutaLogo,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:=14;
				SET Par_ErrMen	:="La ruta del logo esta vacia";
				SET Var_Control	:='rutaLogo';
				LEAVE ManejoErrores;
			END IF;

		-- Validaciones de campos de envio de correo. Cardinal Sistemas Inteligentes
		IF(IFNULL(Par_EnvioAutomatico,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 15;
			SET Par_ErrMen	:= 'El valor de envio de correo esta vacio';
			SET Var_Control	:= 'envioAutomatico';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EnvioAutomatico = SalidaSI)THEN
			IF(IFNULL(Par_CorreoRemitente,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 17;
				SET Par_ErrMen	:= 'El correo remitente esta vacio';
				SET Var_Control	:= 'correoRemitente';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ServidorSMTP,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 18;
				SET Par_ErrMen	:= 'El servidor SMTP esta vacio';
				SET Var_Control	:= 'servidorSMTP';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PuertoSMTP,Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 19;
				SET Par_ErrMen	:= 'El puerto SMTP esta vacio';
				SET Var_Control	:= 'puertoSMTP';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_UsuarioRemitente,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 20;
				SET Par_ErrMen	:= 'El usuario remitente esta vacio';
				SET Var_Control	:= 'usuarioRemitente';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Contrasenia,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 21;
				SET Par_ErrMen	:= 'La clave del remitente esta vacia';
				SET Var_Control	:= 'contraseniaRemitente';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Asunto,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 12;
				SET Par_ErrMen	:= 'El asunto está vacio';
				SET Var_Control	:='asunto';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CuerpoTexto,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 23;
				SET Par_ErrMen	:= 'El cuerpo del texto esta vacio';
				SET Var_Control	:= 'cuerpoTexto';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_RequiereAut,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 24;
				SET Par_ErrMen	:= 'Especifique si se requiere autentificacion';
				SET Var_Control	:= 'requiereAut';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoAut,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr	:= 25;
				SET Par_ErrMen	:= 'El tipo de autentificacion esta vacio';
				SET Var_Control	:= 'tipoAut';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- Fin de validaciones de campos de envio de correo. Cardinal Sistemas Inteligentes

			-- Se obtiene el Numero de Institucion de la tabla PARAMETROSSIS
			SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM PARAMETROSSIS);

			-- Se obtiene la Fecha Actual
			SET Aud_FechaActual := NOW();

			-- Se actualiza la parametrizacion del estado de cuenta
			SET Aud_FechaActual := CURRENT_TIMESTAMP();
			-- Modificacion al UPDATE de EDOCTAPARAMS para incluir los campos de envio de correo. Cardinal Sistemas Inteligentes
			UPDATE EDOCTATDCPARAMS SET
				MontoMin				= Par_MontoMin,
				RutaExpPDF				= Par_RutaExpPDF,
				RutaReporte				= Par_RutaReporte,
				InstitucionID			= Var_NumInstitucion,
				CiudadUEAUID			= Par_CiudadUEAUID,
				CiudadUEAU				= Par_CiudadUEAU,
				TelefonoUEAU			= Par_TelefonoUEAU,
				OtrasCiuUEAU			= Par_OtrasCiuUEAU,
				HorarioUEAU				= Par_HorarioUEAU,
				DireccionUEAU			= Par_DireccionUEAU,
				CorreoUEAU				= Par_CorreoUEAU,
				RutaCBB					= Par_RutaCBB,
				RutaCFDI				= Par_RutaCFDI,
				RutaLogo				= Par_RutaLogo,
				TipoCuentaID			= Par_TipoCuentas,
				ExtTelefonoPart			= Par_ExtTelefonoPart,
				ExtTelefono 			= Par_ExtTelefono,
				EnvioAutomatico			= Par_EnvioAutomatico,
				CorreoRemitente			= Par_CorreoRemitente,
				ServidorSMTP			= Par_ServidorSMTP,
				PuertoSMTP				= Par_PuertoSMTP,
				UsuarioRemitente 		= Par_UsuarioRemitente,
				ContraseniaRemitente	= Par_Contrasenia,
				Asunto					= Par_Asunto,
				CuerpoTexto				= Par_CuerpoTexto,
				RequiereAut				= Par_RequiereAut,
				TipoAut					= Par_TipoAut,

				EmpresaID				= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion;
			-- Fin de modificacion al UPDATE de EDOCTAPARAMS para incluir los campos de envio de correo. Cardinal Sistemas Inteligentes

				SET Par_NumErr := 0;
				SET Par_ErrMen := CONCAT("Parametros Modificados Correctamente");
				SET Var_Control	:='ciudadUEAUID';


		END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
				SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_RutaReporte AS consecutivo;
		END IF;
END TerminaStore$$