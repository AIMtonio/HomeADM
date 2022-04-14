-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS DESTINATARIOSFTPPROSAALT;

DELIMITER $$
CREATE PROCEDURE `DESTINATARIOSFTPPROSAALT`(
	-- Store Procedure: De alta para la configuracion FTP
	Par_Usuario					INT(11),			-- ID del usuario destinatario
	
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
	DECLARE Var_Usuario			INT(11);		-- Variable numero de usuario
	DECLARE Var_Estatus			CHAR(1);		-- Variable estatus del usuario

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE Fecha_Vacia			DATE;			-- Constante de fecha vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE Estatus_Activa		CHAR(1);		-- Constante estatus activa
	

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Entero_Cero		:= 0;
	SET Fecha_Vacia     := '1900-01-01';
	SET Estatus_Activa 	:= 'A';
	
	SET Var_Control		:= Cadena_Vacia;
    SET Var_Usuario		:= Entero_Cero;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DESTINATARIOSFTPPROSAALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el ID del usuario destinatario
		IF( IFNULL(Par_Usuario, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero del usuario destinatario esta Vacio.';
			SET Var_Control	:= 'usuario';
			LEAVE ManejoErrores;
		END IF;
		
		SELECT UsuarioID, Estatus
		INTO Var_Usuario, Var_Estatus
		FROM USUARIOS WHERE UsuarioID = Par_Usuario;
		
		-- Validacion de existencia para el ID del usuario destinatario
		IF( IFNULL(Var_Usuario, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Usuario Destinatario No Existe.';
			SET Var_Control	:= 'usuario';
			LEAVE ManejoErrores;
		END IF;
		
		-- Validacion de existencia para del estatus
		IF( Var_Estatus <> Estatus_Activa ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Usuario Destinatario No Se Encuentra Activo.';
			SET Var_Control	:= 'usuario';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT Usuario FROM DESTINATARIOSFTPPROSA WHERE Usuario = Par_Usuario) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Usuario ya se encuentra Registrado: ', Par_Usuario);
			SET Var_Control	:= 'usuarioDest';
			LEAVE ManejoErrores;
        END IF;

		SET Aud_FechaActual := NOW();
		INSERT INTO DESTINATARIOSFTPPROSA (
			Usuario,		EmpresaID,		UsuarioID,			FechaActual,			DireccionIP,
			ProgramaID,		Sucursal,		NumTransaccion)
		VALUES(
			Par_Usuario,		Aud_EmpresaID,		Aud_UsuarioID,		Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Usuario destinatario Registrado Correctamente.';
		SET Var_Control	:= 'usuario';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$
