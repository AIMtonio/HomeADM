-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDAOPEACTIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDAOPEACTIVOSBAJ`;

DELIMITER $$
CREATE PROCEDURE `VALIDAOPEACTIVOSBAJ`(
	-- Store Procedure para Validar que un activo no se modifique mientras, el mismo activo se esta ajustando
	-- Activos --> Registro --> Activos
	Par_ActivoID			INT(11), 		-- Identificador del activo

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		INT(11);		-- Consecutivo
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal cero
	DECLARE Salida_SI			CHAR(1);		-- Parametro de salida SI

	DECLARE Salida_NO			CHAR(1);		-- Parametro de salida NO
	DECLARE Entero_Uno			INT(11);		-- Constante Entero cero

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Entero_Uno				:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo	:= Par_ActivoID;
		SET Par_ActivoID 	:= IFNULL(Par_ActivoID, Entero_Cero);

		IF( Par_ActivoID = Entero_Cero ) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El Numero de Activo esta Vacio.';
			SET Var_Control		:= 'activoID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT ActivoID FROM VALIDAOPEACTIVOS WHERE ActivoID = Par_ActivoID) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'No existe el Activo.';
			SET Var_Control		:= 'activoID';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM VALIDAOPEACTIVOS WHERE ActivoID = Par_ActivoID;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Validador de Activo Eliminado Correctamente: ',CAST(Var_Consecutivo AS CHAR) );
		SET Var_Control	:= 'activoID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$