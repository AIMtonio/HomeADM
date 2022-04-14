-- SP EDOCTAV2PARAMSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2PARAMSMOD;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2PARAMSMOD (
	-- SP para modificacion de los parametros de estado de cuenta
	Par_MontoMinTimbrado	DECIMAL(16,2),	-- Monto minimo para realizar el timbrado
	Par_RutaExpArchivos		VARCHAR(250),	-- Ruta donde se exportan los archivos XML y PDF
	Par_RutaPRPTPlantilla	VARCHAR(250),	-- Ruta en donde se encontrara el archivo PRPT para generar los PDF del estado de cuenta
	Par_CiudadUEAUID		INT(11),		-- Identificador de la ciudad
	Par_CiudadUEAU			VARCHAR(45),	-- Nombre de la ciudad
	Par_TelefonoUEAU		VARCHAR(45),	-- Numero de telefono
	Par_OtrasCiuUEAU		VARCHAR(45),	-- Numero de OtrasCiuUEAU
	Par_HorarioUEAU			VARCHAR(45),	-- Descripcion de horario
	Par_DireccionUEAU		VARCHAR(250),	-- Direccion de UEAU
	Par_CorreoUEAU			VARCHAR(45),	-- Correo electronico UEAU
	Par_RutaLogo			VARCHAR(250),	-- Ruta de Alojamiento del Logo para mostrar
	Par_ExtTelefonoPart		VARCHAR(6),		-- Contiene la extension  de telefono particular
	Par_ExtTelefono			VARCHAR(6),		-- Contiene el número de extensión de teléfono de otra ciudad
	Par_EnvioAutomatico		CHAR(1),		-- Envio automatico por correo de estados de cuenta
	Par_RemitenteID			INT(11),		-- Identificador del remitente correspondiente a la tabla TARENVIOCORREOPARAM
	Par_Asunto				VARCHAR(100),	-- Asunto del correo electronico
	Par_CuerpoTexto			TEXT,			-- Cuerpo del texto
	Par_ProveedorTimbrado	CHAR(2),		-- SW - SmarterWeb, FM - Facturacion Moderna, HS - Hub de Servicios
	Par_URLWSHub			VARCHAR(200),	-- URL del servicio web que se consumirá para timbrar los estados de cuenta en caso de que el campo ProveedorTimbrado tenga el valor HS
	Par_CredencialesHub		VARCHAR(200),	-- Credenciales para consumir el WS del Hub de Servicios. Se compone de la concatenacion del Usuario con el caracter : con el Password codificado en Base64
	Par_TokenWS				TEXT,			-- Token para la autentificacion con los servicios de SmartWeb
	Par_URLWSSmarterWeb		VARCHAR(200),	-- URL del servicio web que se consumirá para timbrar los estados de cuenta en caso de que el campo ProveedorTimbrado tenga el valor SW
	Par_Salida				CHAR(1),		-- Descripcion de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Descripcion del Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATE,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);	-- Control de Errores
	DECLARE Var_NumInstitucion  INT(11);		-- Numero de Institucion de la tabla PARAMETROSSIS

	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE SalidaSI			CHAR(1);		-- Tipo Salida: SI

	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Entero_Cero				:= 0;			-- Entero Cero
	SET SalidaSI				:= 'S';			-- Tipo Salida: SI

	ManejoErrores: BEGIN
		IF (IFNULL(Par_MontoMinTimbrado,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= "El monto minimo para realizar el timbrado no debe de estar vacio";
			SET Var_Control	:= 'montoMin';
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_RutaExpArchivos,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= "Especifique la ruta para exportar los archivos";
			SET Var_Control	:= 'rutaExpArchivos';
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_RutaPRPTPlantilla,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= "Especifique la ruta de la plantilla PRPT";
			SET Var_Control	:= 'rutaPRPTPlantilla';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CiudadUEAUID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= "Numero de la Ciudad esta Vacio";
			SET Var_Control	:= 'CiudadUEAUID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CiudadUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= "El valor de la Ciudad esta vacia";
			SET Var_Control	:= 'ciudadUEAU';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_HorarioUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= "Horario vacio";
			SET Var_Control	:= 'horarioUEAU';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_DireccionUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= "La direccion esta vacia";
			SET Var_Control	:= 'direccionUEAU';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CorreoUEAU,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= "Campo correo debe contener un valor";
			SET Var_Control	:= 'correoUEAU';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_RutaLogo,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= "La ruta del logo esta vacia";
			SET Var_Control	:= 'rutaLogo';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EnvioAutomatico,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 15;
			SET Par_ErrMen	:= 'El valor de envio de correo esta vacio';
			SET Var_Control	:= 'envioAutomatico';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EnvioAutomatico = SalidaSI)THEN
			IF(IFNULL(Par_RemitenteID,Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 17;
				SET Par_ErrMen	:= 'El remitente esta vacio';
				SET Var_Control	:= 'remitenteID';
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
		END IF;

		IF(IFNULL(Par_ProveedorTimbrado,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr	:= 24;
			SET Par_ErrMen	:= 'Especifique proveedor de timbrado';
			SET Var_Control	:= 'proveedorTimbrado';
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene la Fecha Actual
		SET Aud_FechaActual := NOW();

		UPDATE EDOCTAV2PARAMS SET
			MontoMinTimbrado		= Par_MontoMinTimbrado,
			RutaExpArchivos			= Par_RutaExpArchivos,
			RutaPRPTPlantilla		= Par_RutaPRPTPlantilla,
			CiudadUEAUID			= Par_CiudadUEAUID,
			CiudadUEAU				= Par_CiudadUEAU,
			TelefonoUEAU			= Par_TelefonoUEAU,
			OtrasCiuUEAU			= Par_OtrasCiuUEAU,
			HorarioUEAU				= Par_HorarioUEAU,
			DireccionUEAU			= Par_DireccionUEAU,
			CorreoUEAU				= Par_CorreoUEAU,
			RutaLogo				= Par_RutaLogo,
			ExtTelefonoPart			= Par_ExtTelefonoPart,
			ExtTelefono 			= Par_ExtTelefono,
			EnvioAutomatico			= Par_EnvioAutomatico,
			RemitenteID				= Par_RemitenteID,
			Asunto					= Par_Asunto,
			CuerpoTexto				= Par_CuerpoTexto,
			ProveedorTimbrado		= Par_ProveedorTimbrado,
			URLWSHub				= Par_URLWSHub,
			CredencialesHub			= Par_CredencialesHub,
			TokenWS					= Par_TokenWS,
			URLWSSmarterWeb			= Par_URLWSSmarterWeb,
			EmpresaID				= Par_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion;

			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:= CONCAT("Parametros Modificados Exitosamente");
			SET Var_Control	:= 'ciudadUEAUID';
		END ManejoErrores;

		IF Par_Salida = SalidaSI THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control;
		END IF;
END TerminaStore$$
