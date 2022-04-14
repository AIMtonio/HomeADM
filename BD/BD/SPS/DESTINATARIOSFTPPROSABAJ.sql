-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS DESTINATARIOSFTPPROSBAJ;

DELIMITER $$
CREATE PROCEDURE `DESTINATARIOSFTPPROSBAJ`(
	-- Store Procedure: DE BAJA DE DESTINATARIOS	
	Par_Usuario					INT(11),			-- ID del usuario destinatario,
	
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
									'Disculpe las molestias que esto le ocasiona. Ref:SP-DESTINATARIOSFTPPROSBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;
		-- Elimina destinatarios
		DELETE FROM DESTINATARIOSFTPPROSA;
		
		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Destinatarios Eliminados Exitosamente.';
		SET Var_Control:= 'usuario' ;


	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Usuario AS Consecutivo;
	END IF;

END TerminaStore$$
