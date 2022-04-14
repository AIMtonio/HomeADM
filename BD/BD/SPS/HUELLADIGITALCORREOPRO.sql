-- HUELLADIGITALCORREOPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALCORREOPRO`;

DELIMITER $$
CREATE PROCEDURE `HUELLADIGITALCORREOPRO`(
	-- SP DE PROCESO PARA EL ENVIO DE CORREOS DE HUELLA DIGITAL.
	Par_HuellaDigitalID		INT(11),			-- Parámetro número de la huella digital.
	Par_TipoPersona			CHAR(1),			-- Parámetro tipo de persona C.- Cliente, U.- Usuario, F.- Firmante
	Par_PersonaID			INT(11),			-- Parámetro identificador de la persona UsuarioID, ClienteID.
	Par_NumCorreo			TINYINT UNSIGNED,	-- Parámetro Número de proceso a realizar.

	Par_Salida          	CHAR(1),			-- Parámetro de salida S=si, N=no.
    INOUT Par_NumErr    	INT(11),			-- Parámetro de salida número de error.
    INOUT Par_ErrMen    	VARCHAR(400),		-- Parámetro de salida mensaje de error.

	Aud_EmpresaID         	INT(11),			-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),			-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,			-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),		-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),		-- Parámetro de auditoría ID del programa.
	Aud_Sucursal        	INT(11),			-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)			-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

	-- Declaración de variables
	DECLARE Var_UsuarioRegistro 	INT;
	DECLARE Var_Control         	VARCHAR(50);
	DECLARE Var_RemitenteID			INT(11);
	DECLARE Var_LayoutRepetida		TEXT;
	DECLARE Var_LayoutAutoriza		TEXT;

	DECLARE Var_NombreCompleto		VARCHAR(500);
	DECLARE Var_CorreoUsuario		VARCHAR(300);
	DECLARE Var_CorreoCliente		VARCHAR(300);
	DECLARE Var_Asunto				VARCHAR(100);
	DECLARE Var_FechaSistema		DATE;

	DECLARE Var_UsuarioRegDup		INT;
	DECLARE Var_UsuarioRegEval		INT;
	DECLARE Var_NomUsuRegDup		VARCHAR(500);
	DECLARE Var_NomUsuRegEval		VARCHAR(500);
	DECLARE Var_FechaRegDup			DATETIME;

	DECLARE Var_FechaRegEval		DATETIME;
	DECLARE Var_SucRegDup			INT;
	DECLARE Var_SucRegEval 			INT;
	DECLARE Var_NomSucRegDup		VARCHAR(500);
	DECLARE Var_NomSucRegEval		VARCHAR(500);

	DECLARE Var_ClienRegDup			INT;
	DECLARE Var_ClienRegEval 		INT;
	DECLARE Var_TipoPerDup			CHAR(1);
	DECLARE Var_TipoPerEval 		CHAR(1);
	DECLARE Var_NomClienDup			VARCHAR(500);

	DECLARE Var_NomClilenEval		VARCHAR(500);

	-- Delcaración de constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE Salida_SI				CHAR(1);
	DECLARE Salida_NO				CHAR(1);

	DECLARE Tipo_Usuario			CHAR(1);
	DECLARE Tipo_Cliente			CHAR(1);
	DECLARE Tipo_Firmante			CHAR(1);
	DECLARE Tipo_UsuarioServicios	CHAR(1);
	DECLARE Proceso_Huella			VARCHAR(50);

	DECLARE Correo_Repetida			INT;
	DECLARE Coreo_Autorizada		INT;

	-- Asignación de constantes.
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Salida_SI				:= "S";
	SET Salida_NO				:= "N";

	SET Tipo_Usuario 			:= 'U';
	SET Tipo_Cliente 			:= 'C';
	SET Tipo_Firmante 			:= 'F';
	SET Tipo_UsuarioServicios	:= 'S';
	SET Proceso_Huella			:= 'VALIDACION HUELLA REPETIDA';

	SET Correo_Repetida			:= 1;
	SET Coreo_Autorizada 		:= 2;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-HUELLADIGITALCORREOPRO');
			SET Var_Control = 'sqlException' ;
		END;

		IF (IFNULL(Par_HuellaDigitalID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'Numero de huella digital vacío.';
			SET Var_Control := 'huellaDigitalID';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'Especificar Tipo de Persona.';
			SET Var_Control := 'tipoPersona';
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_PersonaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'Especificar el ID de la Persona.';
			SET Var_Control := 'personaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	LayoutCorreoRepetida,	LayoutCorreoAutorizada,	RemitenteID
		INTO	Var_LayoutRepetida,		Var_LayoutAutoriza,		Var_RemitenteID
		FROM HUELLADIGITALPARAM
		WHERE ParametroID = 1;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_CorreoCliente := Cadena_Vacia;

		IF Par_TipoPersona = Tipo_Usuario THEN

			SET Var_NombreCompleto := (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Par_PersonaID);
			SET Var_CorreoCliente :=  (SELECT Correo FROM USUARIOS WHERE UsuarioID = Par_PersonaID);

		END IF;

		IF Par_TipoPersona = Tipo_Cliente THEN

			SET Var_NombreCompleto := (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Par_PersonaID);
			SET Var_CorreoCliente :=  (SELECT Correo FROM CLIENTES WHERE ClienteID = Par_PersonaID);
		END IF;

		IF Par_TipoPersona = Tipo_Firmante THEN

			SET Var_NombreCompleto := (SELECT NombreCompleto FROM CUENTASPERSONA WHERE PersonaID = Par_PersonaID);
			SET Var_CorreoCliente :=  (SELECT Correo FROM CUENTASPERSONA WHERE PersonaID = Par_PersonaID);

		END IF;

		IF (Par_TipoPersona = Tipo_UsuarioServicios) THEN

			SELECT	NombreCompleto,		Correo
			INTO	Var_NombreCompleto,	Var_CorreoCliente
			FROM USUARIOSERVICIO WHERE UsuarioServicioID = Par_PersonaID;
		END IF;

		IF Par_NumCorreo = Correo_Repetida THEN
			SET Var_CorreoUsuario := Cadena_Vacia;
			SET Var_Asunto := 'Duplicidad de Huella Digital Detectada';

			SET Var_UsuarioRegistro := (SELECT Usuario FROM HUELLADIGITAL
											WHERE AutHuellaDigitalID = Par_HuellaDigitalID LIMIT 1);


			IF IFNULL(Var_UsuarioRegistro,Entero_Cero) != Entero_Cero THEN
				SET Var_CorreoUsuario := (SELECT Correo FROM USUARIOS
											WHERE UsuarioID = Var_UsuarioRegistro);

				SELECT	TipoPersonaEvaluada,	PersonaIDEvaluada,	TipoPersonaDuplicidad,	PersonaIDDuplicidad
				INTO	Var_TipoPerEval,		Var_ClienRegEval,	Var_TipoPerDup,			Var_ClienRegDup
				FROM HUELLADUPLICIDAD
				WHERE TipoPersonaEvaluada = Par_TipoPersona
				AND PersonaIDEvaluada = Par_PersonaID
				AND NumTransaccion = Aud_NumTransaccion
				LIMIT 1;

				SET Var_NomClilenEval = CASE Var_TipoPerEval
											WHEN Tipo_Cliente THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienRegEval LIMIT 1)
											WHEN Tipo_Usuario THEN (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Var_ClienRegEval LIMIT 1)
											WHEN Tipo_Firmante THEN (SELECT NombreCompleto FROM CUENTASFIRMA WHERE CuentaFirmaID = Var_ClienRegEval LIMIT 1)
											WHEN Tipo_UsuarioServicios THEN (SELECT NombreCompleto FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_ClienRegEval LIMIT 1)
											ELSE Cadena_Vacia END;


				SET Var_NomClienDup = CASE Var_TipoPerDup
											WHEN Tipo_Cliente THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienRegDup LIMIT 1)
											WHEN Tipo_Usuario THEN (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Var_ClienRegDup LIMIT 1)
											WHEN Tipo_Firmante THEN (SELECT NombreCompleto FROM CUENTASFIRMA WHERE CuentaFirmaID = Var_ClienRegDup LIMIT 1)
											WHEN Tipo_UsuarioServicios THEN (SELECT NombreCompleto FROM USUARIOSERVICIO WHERE UsuarioServicioID = Var_ClienRegDup LIMIT 1)
											ELSE Cadena_Vacia END;

				SELECT	Usuario,			Sucursal,		FechaActual
				INTO	Var_UsuarioRegEval,	Var_SucRegEval,	Var_FechaRegEval
				FROM HUELLADIGITAL
				WHERE AutHuellaDigitalID = Par_HuellaDigitalID LIMIT 1;

				SELECT	Usuario,			Sucursal,		FechaActual
				INTO	Var_UsuarioRegDup,	Var_SucRegDup,	Var_FechaRegDup
				FROM HUELLADIGITAL
				WHERE AutHuellaDigitalID = Par_HuellaDigitalID LIMIT 1;


				SET Var_NomUsuRegDup = (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Var_UsuarioRegDup LIMIT 1);
				SET Var_NomUsuRegEval = (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID = Var_UsuarioRegEval LIMIT 1);


				SET Var_NomSucRegDup	= (SELECT NombreSucurs FROM SUCURSALES WHERE SucursalID = Var_SucRegDup LIMIT 1);
				SET Var_NomSucRegEval	= (SELECT NombreSucurs FROM SUCURSALES WHERE SucursalID = Var_SucRegEval LIMIT 1);

				SET Var_UsuarioRegDup		:= IFNULL(Var_UsuarioRegDup,Entero_Cero);
				SET Var_UsuarioRegEval		:= IFNULL(Var_UsuarioRegEval,Entero_Cero);
				SET Var_NomUsuRegDup		:= IFNULL(Var_NomUsuRegDup,Cadena_Vacia);
				SET Var_NomUsuRegEval		:= IFNULL(Var_NomUsuRegEval,Cadena_Vacia);
				SET Var_FechaRegDup			:= IFNULL(Var_FechaRegDup,Fecha_Vacia);
				SET Var_FechaRegEval		:= IFNULL(Var_FechaRegEval,Fecha_Vacia);
				SET Var_SucRegDup			:= IFNULL(Var_SucRegDup,Entero_Cero);
				SET Var_SucRegEval			:= IFNULL(Var_SucRegEval,Entero_Cero);
				SET Var_NomSucRegDup		:= IFNULL(Var_NomSucRegDup,Cadena_Vacia);
				SET Var_NomSucRegEval		:= IFNULL(Var_NomSucRegEval,Cadena_Vacia);
				SET Var_ClienRegDup			:= IFNULL(Var_ClienRegDup,Entero_Cero);
				SET Var_ClienRegEval		:= IFNULL(Var_ClienRegEval,Entero_Cero);
				SET Var_TipoPerDup			:= IFNULL(Var_TipoPerDup,Cadena_Vacia);
				SET Var_TipoPerEval			:= IFNULL(Var_TipoPerEval,Cadena_Vacia);
				SET Var_NomClienDup			:= IFNULL(Var_NomClienDup,Cadena_Vacia);
				SET Var_NomClilenEval		:= IFNULL(Var_NomClilenEval,Cadena_Vacia);

				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${UsuarioRegDup}',Var_UsuarioRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${UsuarioRegEval}',Var_UsuarioRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomUsuRegDup}',Var_NomUsuRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomUsuRegEval}',Var_NomUsuRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${FechaRegDup}',Var_FechaRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${FechaRegEval}',Var_FechaRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${SucRegDup}',Var_SucRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${SucRegEval}',Var_SucRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomSucRegDup}',Var_NomSucRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomSucRegEval}',Var_NomSucRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${ClienRegDup}',Var_ClienRegDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${ClienRegEval}',Var_ClienRegEval);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${TipoPerDup}',CASE  Var_TipoPerDup
																						WHEN Tipo_Cliente THEN 'CLIENTE'
																						WHEN Tipo_Usuario THEN 'USUARIO'
																						WHEN Tipo_Firmante THEN 'FIRMANTE'
																						WHEN Tipo_UsuarioServicios THEN 'USUARIO SERVICIOS'
																						ELSE '' END);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${TipoPerEval}',CASE Var_TipoPerEval
																						WHEN Tipo_Cliente THEN 'CLIENTE'
																						WHEN Tipo_Usuario THEN 'USUARIO'
																						WHEN Tipo_Firmante THEN 'FIRMANTE'
																						WHEN Tipo_UsuarioServicios THEN 'USUARIO SERVICIOS'
																						ELSE '' END);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomClienDup}',Var_NomClienDup);
				SET Var_LayoutRepetida := REPLACE(Var_LayoutRepetida,'${NomClilenEval}',Var_NomClilenEval);

				IF Var_CorreoUsuario <> Cadena_Vacia THEN
					CALL TARENVIOCORREOALT(
								Var_RemitenteID,	Var_CorreoUsuario,	Var_Asunto,	 	Var_LayoutRepetida, Entero_Cero,
								Var_FechaSistema,	Var_FechaSistema,	Proceso_Huella,	Cadena_Vacia,		Salida_NO,
								Par_NumErr,			Par_ErrMen, 		Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					IF Par_NumErr <> Entero_Cero THEN

						SET Par_NumErr  := 3;
						SET Par_ErrMen  := CONCAT('Error al Ingresar Correo de Huella Repetida. ',Par_ErrMen);
						SET Var_Control  := 'personaID' ;
						LEAVE ManejoErrores;

					END IF;
				END IF;
			END IF;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Correo Registrado Exitosamente.';
			SET Var_Control := 'personaID' ;
			LEAVE ManejoErrores;

		END IF;

		IF Par_NumCorreo = Coreo_Autorizada THEN

			SET Var_Asunto := 'Autorización de Huella Digital';
			SET Var_LayoutAutoriza := REPLACE(Var_LayoutAutoriza,'${NombreCliente}',Var_NombreCompleto);

			IF Var_CorreoCliente <> Cadena_Vacia THEN
				CALL TARENVIOCORREOALT(
							Var_RemitenteID,	Var_CorreoCliente,	Var_Asunto,	 	Var_LayoutAutoriza, Entero_Cero,
							Var_FechaSistema,	Var_FechaSistema,	Proceso_Huella,	Cadena_Vacia,		Salida_NO,
							Par_NumErr,			Par_ErrMen, 		Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				IF Par_NumErr <> Entero_Cero THEN

					SET Par_NumErr  := 3;
					SET Par_ErrMen  := 'Error al Ingresar Correo de Huella Autorizada.';
					SET Var_Control  := 'personaID' ;
					LEAVE ManejoErrores;

				END IF;
			END IF;


			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'Correo Registrado Exitosamente.';
			SET Var_Control  := 'personaID' ;
			LEAVE ManejoErrores;

		END IF;

		SET Par_NumErr  := 901;
		SET Par_ErrMen  := 'Tipo de Correo No Soportado.';
		SET Var_Control  := 'personaID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
			 	Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$