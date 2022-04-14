-- USUARIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSMOD`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSMOD`(
	Par_UsuarioID			INT(11),		-- ID de Usuario
	Par_ClavePuestoID		VARCHAR(10),	-- ID de Clave o Puesto del usuario
	Par_Nombre				VARCHAR(50),	-- Nombre del Usuario
	Par_ApPaterno			VARCHAR(50),	-- Apellido Paterno del Usuario
	Par_ApMaterno			VARCHAR(50),	-- Apellido Materno del Usuario

	Par_Clave				VARCHAR(50),	-- Clave de Acceso del Usuario
	Par_Correo				VARCHAR(50),	-- Correo del Usuario
	Par_SucurUsu			INT(11),		-- ID de Sucursal del Usuario
	Par_RolID				INT(11),		-- ID de Rol del Usuario
	Par_IPSesion			VARCHAR(15),	-- IP de Sesion del Usuario

	Par_ConsultaCC			CHAR(1),		-- Consulta Circulo Credito 1.- N: NO 2.- S: SI
	Par_UsuarioCirculo		CHAR(12),		-- Usuario de Circulo de Credito
	Par_ContraCirculo		CHAR(16),		-- Contrasecio de Circulo de Credito
	Par_ConsultaBC			CHAR(1),		-- Consulta Buro Credito 1.- N: NO 2.- S: SI
	Par_UsuarioBuroCredito	CHAR(12),		-- Usuario de Buro de Credito

	Par_ContrasenaBuroCredito	CHAR(16),	-- Contrasecio de Buro de Credito
	Par_AccesoMonitor		CHAR(1),		-- Acceso a Monitor
	Par_Notificacion		CHAR(1),		-- Indica si el usuario se les muestran las notificaciones
	Par_AccederAutorizar	CHAR(1),		-- Indica como se puede acceder al sistema, por contrasena o por huella
	Par_RFC					VARCHAR(13), 	-- RFC del usuario

	Par_CURP				CHAR(18),		-- CURP del Usuario
    Par_DireccionCompleta	VARCHAR(200),	-- Direccion Completa del Usuario
    Par_FolioIdentificacion	VARCHAR(18),	-- Folio de Identificacion del Usuario
    Par_FechaExpedicion		DATE,			-- Fecha de Expedicion de la Identificacion del Usuario
    Par_FechaVencimiento	DATE,			-- Fecha de Vencimiento de la Identificacion del Usuario
 
	Par_UsaAplicacion		VARCHAR(1),		-- Usa aplicacion S=Si N=No
	Par_IMEI				VARCHAR(32),	-- IMEI del telefono del usuario
	Par_EmpleadoID			BIGINT(20),		-- ID del empleado tabla EMPLEADOS
	Par_NotificaCierre		CHAR(1),		-- Indica si se notiica al usuario el cierre de dia.

	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE		NumeroUsuario		INT(11);		-- ID de Usuario
	DECLARE		NombComp			VARCHAR(160);	-- Nombre completo
	DECLARE		varRolID			INT(11);		-- ID de Rol
	DECLARE		varSucursalID		INT(11);		-- ID de Sucursal
	DECLARE		varClave			VARCHAR(50);	-- Clave de Usuario
	DECLARE		varCorreo			VARCHAR(50);	-- Correo de Usuario
	DECLARE		varClavePuesto		VARCHAR(10);	-- ID de Calve o Puesto de Usuario
	DECLARE 	Var_Usuario			INT(11);		-- Usuario de Ventanilla
	DECLARE 	Var_EmpleadoID	BIGINT(20);		-- ID del empleado
	DECLARE 	Var_UsaApliNO	CHAR(1);		-- Usa Aplicacion N = NO
	DECLARE 	Var_UsaApliSI	CHAR(1);		-- Usa Aplicacion S = SI

	-- Declaracion de constantes
	DECLARE		Cadena_Vacia		CHAR(1);		-- cadena vacia
	DECLARE		Fecha_Vacia			DATE;			-- fecha vacia
	DECLARE		Entero_Cero			INT;			-- entero en cero
	DECLARE		Con_CirculoNO		CHAR(1);		-- No realiza Consultas a Circulo de Credito
	DECLARE		Con_CirculoSI		CHAR(1);		-- Si realiza Consultas a Circulo de Credito
	DECLARE		Salida_SI 			CHAR(1);		-- Salida SI
	DECLARE		Var_Control			VARCHAR(100);	-- Control de Retorno en pantalla
	DECLARE		Var_SucursalAnterior	INT(11);	-- Sucursal Anterior
	DECLARE		Con_BuroSI			CHAR(1);		-- Si realiza Consultas a Buro de Credito
	DECLARE		Con_BuroNO			CHAR(1);		-- NO realiza Consultas a Buro de Credito
	DECLARE		Var_ConsSI		CHAR(1);	-- Constante S
	DECLARE		Var_ConsNO		CHAR(1);	-- Constante N

	-- Asignacion de constantes
	SET		Cadena_Vacia	:= '';
	SET		Fecha_Vacia		:= '1900-01-01';
	SET		Entero_Cero		:= 0;
	SET		Con_CirculoNO	:= 'N';
	SET		Con_CirculoSI	:= 'S';
	SET		Con_BuroSI		:= 'S';
	SET		Con_BuroNO		:= 'N';
	SET		Var_Control		:= '';
	SET		Salida_SI		:= 'S';
	SET 	Var_UsaApliSI	:= 'S';
	SET 	Var_UsaApliNO 	:= 'N';
	SET	Var_ConsSI			:= 'S';
	SET	Var_ConsNO			:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-USUARIOSMOD');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- asignacion de variables
		-- se guarda el valor del rol id para validar que  exista
		SET varRolID		:= (SELECT RolID FROM ROLES WHERE RolID = Par_RolID);
		-- se guarda el valor de la sucursal para validar que  exista
		SET varSucursalID	:= (SELECT SucursalID FROM SUCURSALES WHERE SucursalID= Par_SucurUsu );
		-- se guardo el valor del puesto para validar que exista
		SET varClavePuesto	:= (SELECT ClavePuestoID FROM PUESTOS WHERE ClavePuestoID = Par_ClavePuestoID);
		SET Par_Notificacion := IFNULL(Par_Notificacion,'N');
		SET Par_Nombre		:= RTRIM(LTRIM(IFNULL(Par_Nombre, Cadena_Vacia)));
		SET Par_ApPaterno	:= RTRIM(LTRIM(IFNULL(Par_ApPaterno, Cadena_Vacia)));
		SET Par_ApMaterno	:= RTRIM(LTRIM(IFNULL(Par_ApMaterno, Cadena_Vacia)));

		SET Var_Usuario		:=(SELECT IFNULL(UsuarioID,0) FROM CAJASVENTANILLA WHERE UsuarioID=Par_UsuarioID);
		SET Var_SucursalAnterior:=(SELECT SucursalUsuario FROM USUARIOS WHERE UsuarioID=Par_UsuarioID);

		-- se guarda el valor de la clave para validar que no exista
		SELECT	Clave  ,	UsuarioID ,		SucursalUsuario,		Correo
		INTO	varClave,	NumeroUsuario,	Var_SucursalAnterior,	varCorreo
			FROM USUARIOS
		WHERE UsuarioID=Par_UsuarioID;

		IF Var_SucursalAnterior<>Par_SucurUsu THEN
			IF Var_Usuario>Entero_Cero THEN
				SET Par_NumErr 	:= 012;
				SET Par_ErrMen 	:= 'El Usuario tiene Caja Asignada.';
				SET Var_Control	:= 'numero';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(NumeroUsuario, Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Numero de Usuario no existe.';
			SET Var_Control	:= 'numero';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nombre, Cadena_Vacia) = Cadena_Vacia )THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= 'El Nombre esta Vacio.';
			SET Var_Control	:= 'nombre';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'La Clave esta Vacia.';
			SET Var_Control	:= 'clave';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(varRolID,Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen 	:= 'El Rol indicado no existe.';
			SET Var_Control	:= 'rolID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(varSucursalID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen 	:= 'La sucursal indicada no existe.' ;
			SET Var_Control	:= 'sucursalUsuario';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(varClave,Cadena_Vacia) <> Par_Clave) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen 	:= 'La clave indicada corresponde a otro usuario. ';
			SET Var_Control	:= 'clave';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(varClavePuesto,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 	:= 009;
			SET Par_ErrMen 	:= 'La clave de puesto indicada no existe.';
			SET Var_Control	:= 'clavePuestoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ConsultaCC=Con_CirculoSI) THEN
			SET Par_UsuarioCirculo := IFNULL(Par_UsuarioCirculo,Cadena_Vacia);
			IF(Par_UsuarioCirculo=Cadena_Vacia) THEN
				SET Par_NumErr 	:= 010;
				SET Par_ErrMen 	:= 'El usuario de Circulo viene Vacio.';
				SET Var_Control	:= 'usuarioCirculo';
				LEAVE ManejoErrores;
			END IF;

			SET Par_ContraCirculo := IFNULL(Par_ContraCirculo, Cadena_Vacia);
			IF(Par_ContraCirculo = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 011;
				SET Par_ErrMen 	:='La Contrasena de Circulo viene Vacia.';
				SET Var_Control	:= 'contrasenaCirculo';
				LEAVE ManejoErrores;
			END IF;
		ELSE IF (Par_ConsultaCC=Con_CirculoNO) THEN
				SET Par_ContraCirculo := Cadena_Vacia;
				SET Par_UsuarioCirculo:= Cadena_Vacia;
			END IF;
		END IF;

        IF(IFNULL(Par_AccederAutorizar,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 012;
			SET Par_ErrMen  := 'Indique el metodo usado para acceder al sistema.';
			SET Var_Control	:= 'accederAutorizar';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para las Consultas a Buro de Credito
		SET Par_ConsultaBC := IFNULL(Par_ConsultaBC,Con_BuroNO);
		SET Par_UsuarioBuroCredito := IFNULL(Par_UsuarioBuroCredito,Cadena_Vacia);
		SET Par_ContrasenaBuroCredito := IFNULL(Par_ContrasenaBuroCredito, Cadena_Vacia);

		IF( Par_ConsultaBC = Con_BuroSI ) THEN

			IF( Par_UsuarioBuroCredito = Cadena_Vacia ) THEN
				SET Par_NumErr 	:= 013;
				SET Par_ErrMen 	:= 'El usuario de Buro de Credito esta Vacio.';
				SET Var_Control	:= 'usuarioBuroCredito';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ContrasenaBuroCredito = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 014;
				SET Par_ErrMen 	:= 'La Contrasena de Buro de Credito esta Vacia.';
				SET Var_Control	:= 'contrasenaBuroCredito';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		
		        
        IF(Par_UsaAplicacion = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 015;
			SET Par_ErrMen 	:= 'Usa Aplicacion esta Vacia.';
			SET Var_Control	:= 'usaAplicacion';
			LEAVE ManejoErrores;
        
        END IF;
		IF(Par_UsaAplicacion NOT IN(Var_UsaApliSI, Var_UsaApliNO)) THEN
        
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen 	:= 'El Formato de Usa Aplicacion es Inconrrecto.';
			SET Var_Control	:= 'usaAplicacion';
			LEAVE ManejoErrores;
        END IF;
        IF(Par_UsaAplicacion = Var_UsaApliSI) THEN
        
			IF(Par_IMEI <> Cadena_Vacia) THEN
				IF(CHAR_LENGTH(Par_IMEI) < 1) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'El IMEI contiene menos caracteres de lo requerido. Minimo 1';
					SET Var_Control	:= 'imei';
					LEAVE ManejoErrores;
				END IF;
				IF(CHAR_LENGTH(Par_IMEI) > 32) THEN
					SET Par_NumErr 	:= 020;
					SET Par_ErrMen 	:= 'El IMEI contiene mas caracteres de lo requerido. Maximo 32';
					SET Var_Control	:= 'imei';
					LEAVE ManejoErrores;
				END IF;
			END IF;
			
		END IF;
		
		IF(IFNULL(Par_EmpleadoID,Entero_Cero) > Entero_Cero)THEN
			SET Var_EmpleadoID :=(SELECT EmpleadoID 
									FROM USUARIOS 
                                    WHERE EmpleadoID = Par_EmpleadoID
										AND UsuarioID <> Par_UsuarioID);
			IF(IFNULL(Var_EmpleadoID,Entero_Cero) > Entero_Cero)THEN
				SET Par_NumErr 	:= 020;
				SET Par_ErrMen 	:= 'El empleado ya tiene asignado un Usuario.';
				SET Var_Control	:= 'empleadoID';
				LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NotificaCierre NOT IN(Var_ConsSI, Var_ConsNO)) THEN
        
			SET Par_NumErr 	:= 021;
			SET Par_ErrMen 	:= 'El Formato de Notifica Cierre Aut.';
			SET Var_Control	:= 'notificaCierre';
			LEAVE ManejoErrores;
        END IF;

		SET NombComp := CONCAT(RTRIM(LTRIM(IFNULL(Par_Nombre, '')))
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApPaterno, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApPaterno, '')))) ELSE '' END
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApMaterno, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApMaterno, '')))) ELSE '' END
		);

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE USUARIOS SET
			ClavePuestoID		= Par_ClavePuestoID,
			Nombre				= Par_Nombre,
			ApPaterno			= Par_ApPaterno,
			ApMaterno			= Par_ApMaterno,
			NombreCompleto		= NombComp,
			Clave				= Par_Clave,
			EmpresaID			= Par_EmpresaID,
			Correo				= Par_Correo,
			SucursalUsuario 	= Par_SucurUsu,
			RolID				= Par_RolID,
			RealizaConsultasCC 	= Par_ConsultaCC,
			UsuarioCirculo		= Par_UsuarioCirculo,
			ContrasenaCirculo 	= Par_ContraCirculo,
			RealizaConsultasBC	= Par_ConsultaBC,
			UsuarioBuroCredito	= Par_UsuarioBuroCredito,
			ContrasenaBuroCredito	= Par_ContrasenaBuroCredito,
			IPsesion			= Par_IPSesion,
			AccesoMonitor		= Par_AccesoMonitor,
			Notificacion		= Par_Notificacion,
			AccederAutorizar	= Par_AccederAutorizar,
            RFC 				= Par_RFC,
            CURP				= Par_CURP,
            DireccionCompleta	= Par_DireccionCompleta,
            FolioIdentificacion	= Par_FolioIdentificacion,
            FechaExpedicion		= Par_FechaExpedicion,
            FechaVencimiento	= Par_FechaVencimiento,
            UsaAplicacion		= Par_UsaAplicacion,
            IMEI				= Par_IMEI,
            NotificaCierre		= Par_NotificaCierre,
            EmpleadoID			= Par_EmpleadoID,
			EmpresaID			= Par_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE UsuarioID			= Par_UsuarioID;

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT("Usuario Modificado Exitosamente: ", CONVERT(Par_UsuarioID, CHAR));
		SET Var_Control	:= 'usuarioID';
        
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				NumeroUsuario AS Consecutivo;
	END IF;

END TerminaStore$$
