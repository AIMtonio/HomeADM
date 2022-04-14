-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGUARDAVALORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMGUARDAVALORESALT;

DELIMITER $$
CREATE PROCEDURE `PARAMGUARDAVALORESALT`(
	-- Store Procedure: De Alta para los Parametros del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_UsuarioAdmon			INT(11),		-- Usuario que puede Cambiar el Estatus de los Documentos en Custodia
	Par_CorreoRemitente			VARCHAR(50),	-- Correo Remitente de Notificacion
	Par_ServidorCorreo			VARCHAR(30),	-- Servidor de Correo de Notificacion
	Par_Puerto					VARCHAR(10),	-- Puerto de Envio de Notificacion
	Par_UsuarioServidor 		VARCHAR(50),	-- Usuario del Servidor de Correos

	Par_Contrasenia				VARCHAR(50),	-- Contraseña del Correo de Notificacion

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_RemitenteID				INT(11);		-- Correo remitente de la tabla
	DECLARE Var_UsuarioAdmon			INT(11);		-- Numero de Usuario Admon
	DECLARE Par_ParamGuardaValoresID	INT(11);		-- ID de Tabla
	DECLARE Var_NombreEmpresa			VARCHAR(50);	-- Nombre de la Empresa

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMGUARDAVALORESALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el numero de Empleado de Administracion esta Vacio
		IF( IFNULL(Par_UsuarioAdmon, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El numero de Empleado de Administracion esta Vacio.';
			SET Var_Control	:= 'usuarioAdmon';
			LEAVE ManejoErrores;
		END IF;

		SELECT UsuarioID
		INTO Var_UsuarioAdmon
		FROM USUARIOS
		WHERE UsuarioID = Par_UsuarioAdmon;
		SET Var_UsuarioAdmon := IFNULL(Var_UsuarioAdmon, Entero_Cero);

		IF( Var_UsuarioAdmon = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Empleado de Administracion No Existe';
			SET Var_Control := 'usuarioFacultadoID';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion Correo Remitente
		IF( IFNULL(Par_CorreoRemitente, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= CONCAT('El Correo Remitente esta Vacio.');
			SET Var_Control	:= 'correoRemitente';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion el Servidor de Correo
		IF( IFNULL(Par_ServidorCorreo, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El servidor esta Vacio.');
			SET Var_Control	:= 'servidorCorreo';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de Puerto
		IF( IFNULL(Par_Puerto, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El Puerto del Correo esta Vacio.';
			SET Var_Control	:= 'puerto';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de la Contrasenia
		IF( IFNULL(Par_Contrasenia, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'La Contraseña del Correo esta Vacia.';
			SET Var_Control	:= 'contrasenia';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de la usuario del Servidor
		IF( IFNULL(Par_UsuarioServidor, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'El Usuario del Servidor esta Vacio.';
			SET Var_Control	:= 'usuarioServidor';
			LEAVE ManejoErrores;
		END IF;

		SELECT INS.Nombre
		INTO Var_NombreEmpresa
		FROM PARAMETROSSIS	PS,	INSTITUCIONES INS
		WHERE INS.InstitucionID	= PS.InstitucionID;
		SET Aud_FechaActual := NOW();

		SELECT IFNULL(MAX(ParamGuardaValoresID), Entero_Cero) + Entero_Uno
		INTO Par_ParamGuardaValoresID
		FROM PARAMGUARDAVALORES;

		INSERT INTO PARAMGUARDAVALORES (
			ParamGuardaValoresID,		UsuarioAdmon,			CorreoRemitente,		ServidorCorreo,		Puerto,
			Contrasenia,				UsuarioServidor,		NombreEmpresa,			EmpresaID,			Usuario,
			FechaActual,				DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
		VALUES(
			Par_ParamGuardaValoresID,	Par_UsuarioAdmon,		Par_CorreoRemitente,	Par_ServidorCorreo,	Par_Puerto,
			Par_Contrasenia,			Par_UsuarioServidor,	Var_NombreEmpresa,		Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Configuracion Registrada Correctamente.';
		SET Var_Control	:= 'paramGuardaValoresID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_ParamGuardaValoresID AS Consecutivo;
	END IF;

END TerminaStore$$