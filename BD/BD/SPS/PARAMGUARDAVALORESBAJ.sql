-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMGUARDAVALORESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMGUARDAVALORESBAJ;

DELIMITER $$
CREATE PROCEDURE `PARAMGUARDAVALORESBAJ`(
	-- Store Procedure: De Alta para los Parametros del menu de Guarda Valores
	-- Modulo Guarda Valores
	Par_ParamGuardaValoresID	INT(11),		-- ID de Tabla PARAMGUARDAVALORES

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
	DECLARE Var_UsuarioAdmon			INT(11);		-- Numero de Usuario Admon
	DECLARE Var_DocumentoID				INT(11);		-- Numero de Documento
	DECLARE Var_EmpleadoID				BIGINT(20);		-- ID de Empleado

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO			CHAR(1);		-- Constante de Salida NO
	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Salida_NO		:= 'N';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMGUARDAVALORESBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el numero de Empleado de Administracion esta Vacio
		IF( IFNULL(Par_ParamGuardaValoresID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El numero de Parametro de Guarda Valores esta Vacio.';
			SET Var_Control	:= 'paramGuardaValoresID';
			LEAVE ManejoErrores;
		END IF;

		CALL USRGUARDAVALORESBAJ(
			Par_ParamGuardaValoresID,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL DOCGUARDAVALORESBAJ(
			Par_ParamGuardaValoresID,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM PARAMGUARDAVALORES WHERE ParamGuardaValoresID = Par_ParamGuardaValoresID;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Configuracion Eliminada Correctamente.';
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