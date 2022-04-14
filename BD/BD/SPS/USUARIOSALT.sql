-- USUARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSALT`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSALT`(
	Par_ClavepuestoID		VARCHAR(10),	-- ID de Clave o Puesto del usuario
	Par_Nombre				VARCHAR(50),	-- Nombre del Usuario
	Par_ApPaterno			VARCHAR(50),	-- Apellido Paterno del Usuario
	Par_ApMaterno			VARCHAR(50),	-- Apellido Materno del Usuario
	Par_Clave				VARCHAR(50),	-- Clave de Acceso del Usuario

	Par_Contrasenia			VARCHAR(50),	-- Contrasenia del Usuario
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

	-- Declaracion de Variables
	DECLARE		NumeroUsuario	INT(11);		-- ID de Usuario
	DECLARE		NombComp		VARCHAR(160);	-- Nombre completo
	DECLARE		minCaracContra	INT(11);		-- Longitud Minima de Contrasenia
	DECLARE		varRolID		INT(11);		-- ID de Rol
	DECLARE		varSucursalID	INT(11);		-- ID de Sucursal
	DECLARE		varClave		VARCHAR(50);	-- Clave de Usuario
	DECLARE		varCorreo		VARCHAR(50);	-- Correo de Usuario
	DECLARE		varClavePuesto	VARCHAR(10);	-- ID de Calve o Puesto de Usuario
	DECLARE 	Var_FechaAlta  	DATE;			-- Variable para obtener la fecha de alta del usuario
	DECLARE 	Var_Control		VARCHAR(100);	-- Control de Retorno en pantalla
	DECLARE 	Var_EmpleadoID	BIGINT(20);		-- ID del empleado
	DECLARE 	Var_UsaApliNO	CHAR(1);		-- Usa Aplicacion N = NO
	DECLARE 	Var_UsaApliSI	CHAR(1);		-- Usa Aplicacion S = SI
    
	-- Declaracion de Constantes
	DECLARE		Estatus_Activo	CHAR(1);	-- estatus Activo
	DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
	DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
	DECLARE		Entero_Cero		INT(11);	-- entero en cero
	DECLARE		Est_SesInactivo	CHAR(1);	-- sesion inactiva
	DECLARE 	Con_CirculoNO   CHAR(1);   	-- No realiza Consultas a Circulo de Credito
	DECLARE 	Con_CirculoSI   CHAR(1);   	-- Si realiza Consultas a Circulo de Credito
	DECLARE 	Con_BuroSI		CHAR(1);   	-- Si realiza Consultas a Buro de Credito
	DECLARE 	Con_BuroNO		CHAR(1);   	-- NO realiza Consultas a Buro de Credito
	DECLARE 	Salida_SI 		CHAR(1);	-- Salida SI
	DECLARE		Var_ConsSI		CHAR(1);	-- Constante S
	DECLARE		Var_ConsNO		CHAR(1);	-- Constante N

	-- Asignacion de Constantes
	SET	Estatus_Activo	:= 'A';
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Est_SesInactivo := 'I';
	SET Con_CirculoNO	:= 'N';
	SET Con_CirculoSI	:= 'S';
	SET Con_BuroSI		:= 'S';
	SET Con_BuroNO		:= 'N';
	SET Var_Control		:= '';
	SET Salida_SI		:= 'S';
	SET Var_UsaApliSI	:= 'S';
	SET Var_UsaApliNO 	:= 'N';
	SET	Var_ConsSI		:= 'S';
	SET	Var_ConsNO		:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-USUARIOSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		-- Asignacion de Variables
		SET	NumeroUsuario	:= 0;
		-- se guarda el valor para el numero minimos de caracteres en la contrasenia
		SET minCaracContra  := (SELECT LonMinCaracPass FROM PARAMETROSSIS);
		-- se guarda el valor del rol id para validar que  exista
		SET varRolID		:= (SELECT RolID FROM ROLES WHERE RolID = Par_RolID);
		-- se guarda el valor de la sucursal para validar que  exista
		SET varSucursalID	:= (SELECT SucursalID FROM SUCURSALES WHERE  SucursalID = Par_SucurUsu );
		-- se guardo el valor del puesto para validar que exista
		SET varClavePuesto  := (SELECT ClavePuestoID FROM PUESTOS WHERE ClavePuestoID = Par_ClavepuestoID);

		SET Par_Notificacion 	:= IFNULL(Par_Notificacion,'N');
		SET Par_Nombre       	:= RTRIM(LTRIM(IFNULL(Par_Nombre, Cadena_Vacia)));
		SET Par_ApPaterno    	:= RTRIM(LTRIM(IFNULL(Par_ApPaterno, Cadena_Vacia)));
		SET Par_ApMaterno    	:= RTRIM(LTRIM(IFNULL(Par_ApMaterno, Cadena_Vacia)));
		SET Var_FechaAlta 	 	:= CURDATE();
		SET Par_UsaAplicacion	:= IFNULL(Par_UsaAplicacion, Cadena_Vacia);
		SET Par_IMEI			:=	IFNULL(Par_IMEI, Cadena_Vacia);


		IF(IFNULL(Par_Nombre,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Nombre de Usuario esta Vacio.';
			SET Var_Control	:= 'nombre';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Clave, Cadena_Vacia) =Cadena_Vacia )THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= 'La Clave esta Vacia.';
			SET Var_Control	:= 'clave';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Contrasenia,Cadena_Vacia) =Cadena_Vacia ) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'La Contrasena esta Vacia.';
			SET Var_Control	:= 'contrasenia';
			LEAVE ManejoErrores;
		ELSE
			IF(LENGTH(Par_Contrasenia) < minCaracContra) THEN
				SET Par_NumErr 	:= 004;
				SET Par_ErrMen 	:= CONCAT('La contrasenia debe tener minimo:',minCaracContra, ' caracteres.');
				SET Var_Control	:= 'contrasenia';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(IFNULL(varRolID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'El Rol indicado no existe.';
			SET Var_Control	:= 'rolID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(varSucursalID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'La sucursal indicada no existe.';
			SET Var_Control	:= 'sucursalUsuario';
			LEAVE ManejoErrores;
		END IF;

		-- se guarda el valor de la clave para validar que no exista
		SELECT 	Clave  INTO	varClave
		FROM USUARIOS
		WHERE Clave LIKE Par_Clave LIMIT 1;

		IF(IFNULL(varClave,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr  := 007;
			SET Par_ErrMen  := 'La clave indicada corresponde a otro usuario. ';
			SET Var_Control	:= 'clave';
			LEAVE ManejoErrores;
		END IF;

		-- se guarda el valor del correo
		SELECT 	Correo  INTO varCorreo
		FROM USUARIOS
		WHERE  Correo LIKE Par_Correo LIMIT 1;

		IF(IFNULL(varCorreo,Cadena_Vacia) <> Cadena_Vacia) THEN
			SET Par_NumErr  := 008;
			SET Par_ErrMen  := 'El correo indicado corresponde a otro usuario. ';
			SET Var_Control	:= 'correo';
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
				SET Par_ErrMen 	:= 'La Contrasena de Circulo viene Vacia.';
				SET Var_Control	:= 'contrasenaCirculo';
				LEAVE ManejoErrores;
			END IF;
		END IF;

        IF(IFNULL(Par_AccederAutorizar,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 012;
			SET Par_ErrMen  := 'Indique el metodo usado para acceder al sistema.';
			SET Var_Control	:= 'accederAutorizar';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_RFC,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 013;
			SET Par_ErrMen  := 'Indique el RFC del Usuario.';
			SET Var_Control	:= 'rfc';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para las Consultas a Buro de Credito
		SET Par_ConsultaBC := IFNULL(Par_ConsultaBC,Con_BuroNO);
		SET Par_UsuarioBuroCredito := IFNULL(Par_UsuarioBuroCredito,Cadena_Vacia);
		SET Par_ContrasenaBuroCredito := IFNULL(Par_ContrasenaBuroCredito, Cadena_Vacia);

		IF( Par_ConsultaBC = Con_BuroSI ) THEN

			IF( Par_UsuarioBuroCredito = Cadena_Vacia ) THEN
				SET Par_NumErr 	:= 014;
				SET Par_ErrMen 	:= 'El usuario de Buro de Credito esta Vacio.';
				SET Var_Control	:= 'usuarioBuroCredito';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ContrasenaBuroCredito = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 015;
				SET Par_ErrMen 	:= 'La Contrasena de Buro de Credito esta Vacia.';
				SET Var_Control	:= 'contrasenaBuroCredito';
				LEAVE ManejoErrores;
			END IF;
		END IF;
        
        IF(Par_UsaAplicacion = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen 	:= 'Usa Aplicacion esta Vacia.';
			SET Var_Control	:= 'usaAplicacion';
			LEAVE ManejoErrores;
        
        END IF;
        
        
		IF(Par_UsaAplicacion NOT IN(Var_UsaApliSI, Var_UsaApliNO)) THEN
        
			SET Par_NumErr 	:= 017;
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
                                    WHERE EmpleadoID = Par_EmpleadoID);
			IF(IFNULL(Var_EmpleadoID,Entero_Cero) > Entero_Cero)THEN
				SET Par_NumErr 	:= 021;
				SET Par_ErrMen 	:= 'El empleado ya tiene asignado un Usuario.';
				SET Var_Control	:= 'empleadoID';
				LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(Par_NotificaCierre NOT IN(Var_ConsSI, Var_ConsNO)) THEN
        
			SET Par_NumErr 	:= 022;
			SET Par_ErrMen 	:= 'El Formato de Notifica Cierre Aut.';
			SET Var_Control	:= 'notificaCierre';
			LEAVE ManejoErrores;
        END IF;

		SET NumeroUsuario := (SELECT IFNULL(MAX(UsuarioID),Entero_Cero) + 1  FROM USUARIOS);
		SET NombComp := CONCAT(RTRIM(LTRIM(IFNULL(Par_Nombre, '')))
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApPaterno, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApPaterno, '')))) ELSE '' END
			,CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApMaterno, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApMaterno, '')))) ELSE '' END
		);

		SET Aud_FechaActual := NOW();

		INSERT INTO USUARIOS (
			UsuarioID,					ClavePuestoID,				Nombre,						ApPaterno,						ApMaterno,
			NombreCompleto,				Clave,						Contrasenia,				RolID,							Estatus,
			LoginsFallidos,				Correo,						SucursalUsuario,			EstatusSesion,					FechaAlta,
			FechUltimAcces,				FechUltPass,				IPsesion,					RealizaConsultasCC,				UsuarioCirculo,
			ContrasenaCirculo,			RealizaConsultasBC,			UsuarioBuroCredito,			ContrasenaBuroCredito,			AccesoMonitor,
			Notificacion,				AccederAutorizar,			RFC,			   			CURP,							DireccionCompleta,
            FolioIdentificacion,		FechaExpedicion,			FechaVencimiento,			UsaAplicacion,					IMEI,	
            EmpleadoID,			
			EmpresaID,					Usuario,					FechaActual,				DireccionIP,					ProgramaID,					
            Sucursal,					NumTransaccion,				Semilla,					NotificaCierre)
		VALUES(
			NumeroUsuario,				Par_ClavepuestoID,			Par_Nombre,					Par_ApPaterno,					Par_ApMaterno,
			NombComp,					Par_Clave,					Par_Contrasenia,			Par_RolID,						Estatus_Activo,
			Entero_Cero,				Par_Correo,					Par_SucurUsu,				Est_SesInactivo,				Var_FechaAlta,
			Fecha_Vacia,				Fecha_Vacia,				Par_IPSesion,				Par_ConsultaCC,					Par_UsuarioCirculo,
			Par_ContraCirculo,			Par_ConsultaBC,				Par_UsuarioBuroCredito,		Par_ContrasenaBuroCredito,		Par_AccesoMonitor,
			Par_Notificacion,			Par_AccederAutorizar,		Par_RFC,					Par_CURP,						Par_DireccionCompleta,
            Par_FolioIdentificacion,	Par_FechaExpedicion,		Par_FechaVencimiento,		Par_UsaAplicacion,				Par_IMEI,
            Par_EmpleadoID,
            Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,				
            Aud_Sucursal,				Aud_NumTransaccion,			Cadena_Vacia,				Par_NotificaCierre);


		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT("Usuario Agregado Exitosamente: ", CONVERT(NumeroUsuario, CHAR));
		SET Var_Control	:= 'usuarioID';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			NumeroUsuario AS Consecutivo;
	END IF;

END TerminaStore$$
