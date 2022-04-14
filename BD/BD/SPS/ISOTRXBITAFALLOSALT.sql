-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXBITAFALLOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXBITAFALLOSALT;

DELIMITER $$
CREATE PROCEDURE `ISOTRXBITAFALLOSALT`(
	-- Store Procedure: Alta de Fallos en Notificaciones para la tarea de Notificacion de Saldos a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
	Par_RegistroID				BIGINT(20),			-- ID de Tabla ISOTRXTARNOTIFICA
	Par_PIDTarea 				VARCHAR(50),		-- PID Tarea
	Par_NumeroError				INT(11),			-- Numero de Error
	Par_MensajeError			VARCHAR(400),		-- Descripcion del Error
	Par_Transaccion				BIGINT(20),			-- Numero de transaccion

	Par_Salida					CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Paramentros
	DECLARE Par_BitacoraID			BIGINT(20);		-- Numero de Registro
	DECLARE Par_FechaOperacion		DATE;			-- Fecha de Sistema

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno				INT(11);		-- Constante Entero Uno
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia

	DECLARE Salida_SI				CHAR(1);		-- Constante Salida SI

	-- Asignacion de Constantes
	SET Entero_Cero 				:= 0;
	SET Entero_Uno					:= 1;
	SET Decimal_Cero				:= 0.00;
	SET Fecha_Vacia 				:= '1900-01-01';
	SET Cadena_Vacia				:= '';

	SET Salida_SI					:= 'S';
	SET Var_Control					:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-ISOTRXBITAFALLOSALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SELECT IFNULL(MAX(BitacoraID), Entero_Cero) + Entero_Uno
		INTO Par_BitacoraID
		FROM ISOTRXBITAFALLOS FOR UPDATE;

		SET Par_FechaOperacion	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		INSERT INTO ISOTRXBITAFALLOS (
			BitacoraID,			RegistroID,			FechaOperacion,			PIDTarea,			NumeroError,
			MensajeError,		Transaccion,
			EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES(
			Par_BitacoraID,		Par_RegistroID,		Par_FechaOperacion,		Par_PIDTarea,		Par_NumeroError,
			Par_MensajeError,	Par_Transaccion,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Registro de Bitacora realizado Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$