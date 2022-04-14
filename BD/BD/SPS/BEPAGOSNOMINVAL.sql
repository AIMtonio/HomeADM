-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSNOMINVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS BEPAGOSNOMINVAL;

DELIMITER $$
CREATE PROCEDURE `BEPAGOSNOMINVAL`(
	-- Store Procedure: De Actualizacion de la baja de la poliza de Pagos Aplicados de Nomina
	-- Modulo Creditos Nomina --> Proceso --> Aplicacion Pagos Credito Nomina
	Par_PolizaID			BIGINT(20),		-- ID de Tabla POLIZACONTABLE

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla

	DECLARE Var_DetallePolizaID		INT(11);		-- Numero de Polizas
	DECLARE Var_NumErrPol			INT(11);		-- Numero de Error
	DECLARE Var_ErrMenPol			VARCHAR(400);	-- Mensaje de Error

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno				INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	DECLARE	Fecha_Vacia				DATE;			-- Constante de Decimal Cero

	-- Declaracion de Actualizaciones
	DECLARE Act_Registros			TINYINT UNSIGNED;-- Numero de Actualizacion
	DECLARE Var_TipoPoliza			TINYINT UNSIGNED;-- Tipo de Borrado por medio de Numero de Poliza

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Salida_NO		:= 'N';
	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;

	SET	Fecha_Vacia		:= '1900-01-01';
	SET Var_Control		:= Cadena_Vacia;

	-- Asignacion de Actualizaciones
	SET Act_Registros	:= 1;
	SET Var_TipoPoliza	:= 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-BEPAGOSNOMINVAL');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Si la poliza no tiene detalles se realiza la baja de poliza
		SELECT COUNT(PolizaID)
		INTO Var_DetallePolizaID
		FROM DETALLEPOLIZA
		WHERE PolizaID = Par_PolizaID;

		IF( IFNULL(Var_DetallePolizaID, Entero_Cero) = Entero_Cero ) THEN
			SET Var_NumErrPol  := 000;
			SET Var_ErrMenPol  := CONCAT('No existen Movimientos Contables para la poliza: ',Par_PolizaID,'.');
			CALL MAESTROPOLIZABAJ(
				Par_PolizaID,		Aud_NumTransaccion,	Var_TipoPoliza,	Var_NumErrPol,	Var_ErrMenPol,
				Aud_ProgramaID,
				Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control	:= 'polizaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Validacion de Poliza para la aplicacion de pagos de nomina.';
		SET Var_Control	:= 'polizaID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_PolizaID AS Consecutivo;
	END IF;
END TerminaStore$$