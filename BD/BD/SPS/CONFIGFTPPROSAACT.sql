-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONFIGFTPPROSAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS CONFIGFTPPROSAACT;

DELIMITER $$
CREATE PROCEDURE `CONFIGFTPPROSAACT`(
	-- Store Procedure: De Modificacion para la configuracion FTP
	Par_ConfigFTPProsaID			INT(11),		-- 'ID de Tabla',
	Par_Servidor					VARCHAR(50),	-- 'Direccion servidor ftp',
	Par_Usuario						VARCHAR(50),	-- 'Usuario de acceso al servidor ftp',
	Par_Contrasenia					VARCHAR(50),	-- 'Contrasenia de acceso al servidor ftp',
	Par_Puerto						VARCHAR(50),	-- 'Puerto del servidor ftp',

	Par_NumAct						INT(11),		-- Numero de actualizar	
	Par_Ruta						VARCHAR(50),	-- 'Ruta del archivo ftp',
	Par_HoraInicio					INT(11),		-- 'Hora inicio de la lectura del archivo ftp',
	Par_IntervaloMin				INT(11),		-- Intervalo minutos
	Par_NumIntentos					INT(11),		-- 'Numero de intentos de lectura del archivo ftp',

	Par_Mensaje						VARCHAR(800),	-- 'Mensaje resultado de las operaciones',
	Par_UsuarioRemiten				INT(11),		-- Usuario remitente que envia el correo en caso de fallo.
	Par_Salida						CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr				INT(11),			-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID					INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_UsuarioID					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual					DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP					VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID					VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal					INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion				BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_HoraEjec		VARCHAR(2);		-- Variable para almacenar la hora que se ejcutará la tarea
	DECLARE Var_MinEjecj		VARCHAR(3);		-- Varable que indica el intervalo de intentos
	DECLARE Var_ExpresionCron	VARCHAR(50);	-- Constante para la expresion que se ejecuta en el tiempo del scechdule
	DECLARE Var_Consecutivo		BIGINT(20);		-- Variable consecutivo del cron
	DECLARE Var_NombreJar		VARCHAR(400);	-- NOMBRE JAR
	DECLARE Var_TarID			INT(11);		-- Variable tarea id

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Constante de Salida NO
	DECLARE Fecha_Vacia			DATE;			-- Constante de fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
    DECLARE Hora_Vacia			TIME;			-- Constante de hora vacia
	DECLARE ActConf_FTP			INT(11);		-- Constante para la actualizacion de informacion del servidor ftp
	DECLARE ActConf_Horario		INT(11);		-- Constante para la actualizacion de la informacion del horario de ejecucion
	DECLARE ActConf_Correos		INT(11);		-- Constante para envio de correos

	DECLARE ExpresionDef		VARCHAR(50);	-- Constantes para la expresion que ejecuta el tiempo del scechdule

	-- Asignacion  de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET Hora_Vacia				:= '00:00:00';		-- Hora vacia
	SET	Salida_SI				:= 'S';				-- Salida si
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET Fecha_Vacia     		:= '1900-01-01';	-- Fecha vacia
	SET ActConf_FTP				:= 1;				-- Act Conf ftp
	SET ActConf_Horario			:= 2;				-- Act conf horario
	SET ActConf_Correos 		:= 3;
	SET ExpresionDef			:= ' 0 0 0 ? * * *';
	SET Var_NombreJar 			:= 'TAREA_TRANSACCIONES_PROSA/TAREA_TRANSACCIONES_PROSA.jar';	-- Nombre jar

	-- Asignacion de variables
	SET Var_Control				:= Cadena_Vacia;	-- Control
	SET Var_ExpresionCron 		:= '';
	SET Aud_FechaActual 		:= NOW();

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONFIGFTPPROSAACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el ID de la configuracion este Vacio
		IF( IFNULL(Par_ConfigFTPProsaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de la configuracion esta Vacio.';
			SET Var_Control	:= 'configFTPProsaID';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_NumAct = ActConf_FTP ) THEN

			UPDATE CONFIGFTPPROSA SET
				Servidor		= Par_Servidor,
				Usuario			= Par_Usuario,
				Contrasenia		= Par_Contrasenia,
				Puerto			= Par_Puerto,
				Ruta			= Par_Ruta,
				EmpresaID		= Aud_EmpresaID,
				UsuarioID		= Aud_UsuarioID,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ConfigFTPProsaID = Par_ConfigFTPProsaID;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Configuraci&oacute;n ftp Modificado Correctamente.';
			SET Var_Control	:= 'configFTPProsaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = ActConf_Horario ) THEN
			-- 10:20:00
			-- Validacion de minutos
			IF(Par_IntervaloMin > 60 )THEN
				SET Par_NumErr	:= 	02;
				SET Par_ErrMen	:= 'Los Minutos de intervalo es incorrecto.';
				SET Var_Control	:= 'intervaloMin';
				LEAVE ManejoErrores;
			END IF;
			IF(Par_IntervaloMin < Entero_Cero )THEN
				SET Par_NumErr	:= 	03;
				SET Par_ErrMen	:= 'Los Minutos de intervalo es incorrecto.';
				SET Var_Control	:= 'intervaloMin';
				LEAVE ManejoErrores;
			END IF;

			SET Var_ExpresionCron := CONCAT('0 0/',Par_IntervaloMin,' ',SUBSTR(Par_HoraInicio,1,2), '/1 ? * * *');

			SELECT TareaID
			INTO Var_TarID
			FROM  DEMTAREA WHERE TareaID = 7;
			
			CALL DEMTAREAACT(Var_TarID,		 	Cadena_Vacia, 		Cadena_Vacia, 		Cadena_Vacia, 		Cadena_Vacia, 
							Cadena_Vacia, 		Cadena_Vacia, 		Var_ExpresionCron,	ActConf_Horario,	Salida_NO, 
							Par_NumErr, 		Par_ErrMen, 		Var_Consecutivo,			Aud_EmpresaID,		Aud_UsuarioID,	
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			
			
		
			SET Aud_FechaActual := NOW();
			UPDATE CONFIGFTPPROSA SET
				HoraInicio		= Par_HoraInicio,
				IntervaloMin	= Par_IntervaloMin,
				NumIntentos		= Par_NumIntentos,
				EmpresaID		= Aud_EmpresaID,
				UsuarioID		= Aud_UsuarioID,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ConfigFTPProsaID = Par_ConfigFTPProsaID;


			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Configuraci&oacute;n de Horarios Modificado Correctamente.';
			SET Var_Control	:= 'configFTPProsaID';
		END IF;
		IF(Par_NumAct = ActConf_Correos) THEN
			SET Aud_FechaActual := NOW();
			-- SELECT Correo FROM USUARIOS
			UPDATE CONFIGFTPPROSA SET
				Mensaje			= Par_Mensaje,
				UsuarioRemiten 	= Par_UsuarioRemiten,
				EmpresaID		= Aud_EmpresaID,
				UsuarioID		= Aud_UsuarioID,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE ConfigFTPProsaID = Par_ConfigFTPProsaID;
			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Configuracion de Correo Modificado Correctamente.';
			SET Var_Control	:= 'usuarioDestina';
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_ConfigFTPProsaID AS Consecutivo;
	END IF;
END TerminaStore$$
