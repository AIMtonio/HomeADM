-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESTAMODOCGRDVALORESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS PRESTAMODOCGRDVALORESACT;

DELIMITER $$
CREATE PROCEDURE `PRESTAMODOCGRDVALORESACT`(
	-- Store Procedure: De Actualizacion de Prestamo de Documentos en Guarda Valores
	-- Modulo Guarda Valores
	Par_PrestamoDocGrdValoresID	BIGINT(20),		-- ID de tabla PRESTAMODOCGRDVALORES
	Par_UsuarioRegistroID		INT(11),		-- Usuario que Realiza la Operacion del Documento
	Par_Observaciones			VARCHAR(500),	-- Observaciones
	Par_NumeroActualizacion		TINYINT UNSIGNED,-- Numero de Actualizacion

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
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_ControlValidacion	VARCHAR(100);	-- Variable de Retorno en Pantalla del SP Validacion

		-- Declaracion de Parametros
	DECLARE Par_FechaRegistro		DATE;			-- Fecha de Registro del Prestamo
	DECLARE Par_HoraRegistro		TIME;			-- Hpra de Registro del Prestamo

	-- Declaracion de constantes
	DECLARE Hora_Vacia				TIME;			-- Constante de Hora Vacia
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE Est_Finalizado			CHAR(1);		-- Estatus Finalizado
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Tipos de Actualizacion
	DECLARE Act_PrestamoFinalizado	TINYINT UNSIGNED;-- Numero de Actualizacion 1.- Pase a Finalizado

	-- Tipos de Validacion
	DECLARE Val_DevolucionPrestamo	TINYINT UNSIGNED;-- Numero de Validacion 2.- Pase a Finalizado

	-- Asignacion  de constantes
	SET Hora_Vacia				:= '00:00:00';
	SET Fecha_Vacia				:= '1900-01-01';
	SET	Cadena_Vacia			:= '';
	SET	Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';

	SET Est_Finalizado			:= 'F';
	SET	Entero_Cero				:= 0;
	SET	Decimal_Cero			:= 0.0;

	-- Asignacion de Tipos de Actualizacion
	SET Act_PrestamoFinalizado	:= 1;

	-- Asignacion de Tipos de Validacion
	SET Val_DevolucionPrestamo	:= 2;

	-- Asignacion General
	SET Var_Control				:= Cadena_Vacia;
	SELECT IFNULL( FechaSistema, Fecha_Vacia )
	INTO Par_FechaRegistro
	FROM PARAMETROSSIS
	LIMIT 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRESTAMODOCGRDVALORESACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		-- Numero de Actualizacion 1.- Pase a Finalizado
		IF( Par_NumeroActualizacion = Act_PrestamoFinalizado ) THEN

			-- Validacion de Actualizacion
			CALL PRESTAMODOCGRDVALORESVAL(
				Par_PrestamoDocGrdValoresID,	Entero_Cero,			Entero_Cero,		Entero_Cero,		Entero_Cero,
				Entero_Cero,					Par_UsuarioRegistroID,	Cadena_Vacia,		Entero_Cero,		Var_ControlValidacion,
				Val_DevolucionPrestamo,			Salida_NO,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				SET Var_Control := Var_ControlValidacion;
				LEAVE ManejoErrores;
			END IF;

			SET Par_Observaciones := IFNULL(Par_Observaciones, Cadena_Vacia);
			SET Aud_FechaActual	  := NOW();
			SET Par_HoraRegistro  := IFNULL(TIME(NOW()), Hora_Vacia);

			UPDATE PRESTAMODOCGRDVALORES SET
				UsuarioDevolucionID	= Par_UsuarioRegistroID,
				FechaDevolucion		= Par_FechaRegistro,
				HoraDevolucion		= Par_HoraRegistro,
				Observaciones		= Par_Observaciones,
				Estatus				= Est_Finalizado,
				EmpresaID 			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE PrestamoDocGrdValoresID = Par_PrestamoDocGrdValoresID;

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('El Prestamo: ', Par_PrestamoDocGrdValoresID, ' ha Finalizado Correctamente.');
			SET Var_Control	:= 'prestamoDocGrdValoresID';
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_PrestamoDocGrdValoresID AS Consecutivo;
	END IF;

END TerminaStore$$