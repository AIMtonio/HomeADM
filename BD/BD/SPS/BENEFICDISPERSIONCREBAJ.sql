-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICDISPERSIONCREBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS BENEFICDISPERSIONCREBAJ;

DELIMITER $$
CREATE PROCEDURE BENEFICDISPERSIONCREBAJ(
	Par_SolicitudCreditoID	BIGINT(20),		-- Número de Solicitud

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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BENEFICDISPERSIONCREBAJ');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Validacion para el numero de Empleado de Administracion esta Vacio
		IF( Par_SolicitudCreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Solicitud de Crédito está vacía.';
			SET Var_Control	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		-- Elimina todos los beneficiarios asociados a la dispersión de la solicitud de crédito
		DELETE
		  FROM BENEFICDISPERSIONCRE
		 WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

		-- Actualiza el monto de la dsspersión de la instrucción de dispersión
		UPDATE INSTRUCDISPERSIONCRE
		   SET MontoDispersion = Decimal_Cero
		 WHERE SolicitudCreditoID = Par_SolicitudCreditoID;


		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'La dispersión se eliminó correctamente.';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_SolicitudCreditoID AS Consecutivo;
	END IF;

END TerminaStore$$