-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONFIGFTPPROSAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS CONFIGFTPPROSAMOD;

DELIMITER $$
CREATE PROCEDURE `CONFIGFTPPROSAMOD`(
	-- Store Procedure: De Modificacion para la configuracion FTP
	Par_ConfigFTPProsaID			INT(11),		-- 'ID de Tabla',
	Par_Servidor					VARCHAR(50),	-- 'Direccion servidor ftp',
	Par_Usuario						VARCHAR(50),	-- 'Usuario de acceso al servidor ftp',
	Par_Contrasenia					VARCHAR(50),	-- 'Contrasenia de acceso al servidor ftp',
	Par_Puerto						VARCHAR(50),	-- 'Puerto del servidor ftp',
	
	Par_Ruta						VARCHAR(50),	-- 'Ruta del archivo ftp',
	Par_HoraInicio					TIME,		-- 'Hora inicio de la lectura del archivo ftp',
	Par_HoraFin						TIME,		-- 'Hora fin de la lectura del archivo ftp',
	Par_IntervaloMin				INT(11),		-- Intervalo minutos
	Par_NumIntentos					INT(11),		-- 'Numero de intentos de lectura del archivo ftp',
	
	Par_Mensaje						VARCHAR(100),	-- 'Mensaje resultado de las operaciones',
	
	Par_Salida					CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_UsuarioID				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Retorno en Pantalla

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE Fecha_Vacia			DATE;			-- Constante de fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET Fecha_Vacia     := '1900-01-01';
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONFIGFTPPROSAMOD');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el ID de la configuracion este Vacio
		IF( IFNULL(Par_ConfigFTPProsaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de la configuracion esta Vacio.';
			SET Var_Control	:= 'configFTPProsaID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		UPDATE CONFIGFTPPROSA SET
			Servidor		= Par_Servidor,
			Usuario			= Par_Usuario,
			Contrasenia		= Par_Contrasenia,
			Puerto			= Par_Puerto,
			Ruta			= Par_Ruta,
			HoraInicio		= Par_HoraInicio,
			HoraFin			= Par_HoraFin,
			IntervaloMin	= Par_IntervaloMin,
			NumIntentos		= Par_NumIntentos,
			Mensaje			= Par_Mensaje,
			EmpresaID		= Aud_EmpresaID,
			UsuarioID		= Aud_UsuarioID,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion	
		WHERE ConfigFTPProsaID = Par_ConfigFTPProsaID;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Configuracion ftp Modificado Correctamente.';
		SET Var_Control	:= 'configFTPProsaID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_ConfigFTPProsaID AS Consecutivo;
	END IF;

END TerminaStore$$
