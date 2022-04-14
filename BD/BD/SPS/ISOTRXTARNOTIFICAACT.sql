-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXTARNOTIFICAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXTARNOTIFICAACT;

DELIMITER $$
CREATE PROCEDURE `ISOTRXTARNOTIFICAACT`(
	-- Store Procedure: Actualizacion de Notificaciones para la tarea de Notificacion de Saldos a ISOTRX
	-- Modulo Tarjetas de Debito - WS ISOTRX
	Par_FechaOperacion			DATE,				-- ID de Tabla
	Par_RegistroID				BIGINT(20),			-- ID de Tabla
	Par_PIDTarea 				VARCHAR(50),		-- PID Tarea
	Par_NumeroError				INT(11),			-- Numero de Error
	Par_MensajeError			TEXT,				-- Descripcion del Error
	Par_Transaccion				BIGINT(20),			-- Numero de transaccion

	Par_NumeroActualizacion		TINYINT UNSIGNED,	-- Numero de Actualizacion

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

	-- Declaracion de Variables
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_RegistroID					BIGINT(20);		-- ID de  Registro
	DECLARE Var_NumeroIntentos				INT(11);		-- Numero de Intentos
	DECLARE Var_NumIntentosConWSAutoriza	INT(11);		-- Numero de Intentos
	DECLARE Var_EsCierreDia					INT(11);		-- Es Cierre de Dia

	-- Declaracion de Constantes
	DECLARE Entero_Cero						INT(11);		-- Constante de Entero Cero
	DECLARE Entero_Uno						INT(11);		-- Constante Entero Uno
	DECLARE Con_TarjetaDebito				INT(11);		-- Tipo Tarjeta Debito
	DECLARE Con_NumIntentos					INT(11);		-- Numero de Intentos Default
	DECLARE Decimal_Cero					DECIMAL(14,2);	-- Constante de Decimal Cero

	DECLARE Fecha_Vacia						DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia					CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Salida_SI						CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO						CHAR(1);		-- Constante Salida NO
	DECLARE Con_SI							CHAR(1);		-- Constante SI

	DECLARE Con_NO 							CHAR(1);		-- Constante NO
	DECLARE Est_Pendiente					CHAR(1);		-- Estatus Pendiente
	DECLARE Est_Enviado						CHAR(1);		-- Estatus Enviado
	DECLARE Est_Fallo						CHAR(1);		-- Estatus Fallido
	DECLARE Llave_NumIntentosConWSAutoriza	VARCHAR(50);	-- Llave NumIntentosConWSAutoriza
	DECLARE Con_OperacionCierreDia			TINYINT UNSIGNED;	-- Tipo de Operacion Cierre de Día

	-- Declaracion de Actualizaciones
	DECLARE Act_PIDTarea					TINYINT UNSIGNED;	-- Numero de Actualizacion 1
	DECLARE Act_NumeroIntentos				TINYINT UNSIGNED;	-- Numero de Actualizacion 2
	DECLARE Act_NotificacionExitosa			TINYINT UNSIGNED;	-- Numero de Actualizacion 3

	-- Asignacion de Constantes
	SET Entero_Cero 					:= 0;
	SET Entero_Uno						:= 1;
	SET Con_TarjetaDebito				:= 1;
	SET Con_NumIntentos					:= 3;
	SET Decimal_Cero					:= 0.00;

	SET Fecha_Vacia 					:= '1900-01-01';
	SET Cadena_Vacia					:= '';
	SET Salida_SI						:= 'S';
	SET Salida_NO						:= 'N';
	SET Con_SI							:= 'S';

	SET Con_NO 							:= 'N';
	SET Est_Pendiente					:= 'P';
	SET Est_Enviado						:= 'E';
	SET Est_Fallo						:= 'F';
	SET Llave_NumIntentosConWSAutoriza	:= 'NumIntentosConWSAutoriza';
	SET Con_OperacionCierreDia			:= 20;

	-- Asignacion de Actualizaciones
	SET Act_PIDTarea					:= 1;
	SET Act_NumeroIntentos				:= 2;
	SET Act_NotificacionExitosa			:= 3;
	SET Var_Control						:= Cadena_Vacia;
	SET Par_MensajeError 				:= LEFT(UPPER(IFNULL(Par_MensajeError, Cadena_Vacia)), 500);

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-ISOTRXTARNOTIFICAACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		IF( Par_NumeroActualizacion = Act_PIDTarea ) THEN

			IF( IFNULL(Par_PIDTarea, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El ID de la Tarea no puede ser Vacio.';
				LEAVE ManejoErrores;
			END IF;

			-- Segmento de Validacion para la lista por cierre de Dia
			SELECT IFNULL(COUNT(OperacionPeticionID), Entero_Cero)
			INTO Var_EsCierreDia
			FROM ISOTRXTARNOTIFICA
			WHERE OperacionPeticionID = Con_OperacionCierreDia;

			IF( Var_EsCierreDia > Entero_Cero ) THEN
				UPDATE ISOTRXTARNOTIFICA SET
					PIDTarea 		= Par_PIDTarea,

					EmpresaID		= Aud_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE TipoTarjeta = Con_TarjetaDebito
				  AND OperacionPeticionID = Con_OperacionCierreDia
				  AND Estatus = Est_Pendiente
				  AND PIDTarea = Cadena_Vacia;
			ELSE
				UPDATE ISOTRXTARNOTIFICA SET
					PIDTarea 		= Par_PIDTarea,

					EmpresaID		= Aud_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE TipoTarjeta = Con_TarjetaDebito
				  AND Estatus = Est_Pendiente
				  AND PIDTarea = Cadena_Vacia;
			END IF;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Registro de Operacion realizado Correctamente.';
		END IF;


		IF( Par_NumeroActualizacion = Act_NumeroIntentos ) THEN

			SET Var_NumIntentosConWSAutoriza := IFNULL( FNPARAMTARJETAS(Llave_NumIntentosConWSAutoriza), Con_NumIntentos);

			IF( IFNULL(Par_RegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El Numero de Registro No puede ser Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF( IFNULL(Par_FechaOperacion, Fecha_Vacia) = Fecha_Vacia ) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'La Fecha de Operacion No puede ser Vacia.';
				LEAVE ManejoErrores;
			END IF;

			SELECT RegistroID
			INTO Var_RegistroID
			FROM ISOTRXTARNOTIFICA
			WHERE FechaOperacion = Par_FechaOperacion
			  AND RegistroID = Par_RegistroID;

			IF( IFNULL(Var_RegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Numero de Registro No Existe.';
				LEAVE ManejoErrores;
			END IF;


			UPDATE ISOTRXTARNOTIFICA SET
				NumeroIntentos = NumeroIntentos + Entero_Uno,
				PIDTarea 		= CASE WHEN NumeroIntentos = Var_NumIntentosConWSAutoriza THEN PIDTarea
									  ELSE Cadena_Vacia
								  END,
				Estatus 		= CASE WHEN NumeroIntentos = Var_NumIntentosConWSAutoriza THEN Est_Fallo
									  ELSE Est_Pendiente
								  END,
				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FechaOperacion = Par_FechaOperacion
			  AND RegistroID = Par_RegistroID;

			-- Si falla el Proceso de bitacora de error no es impedimento para reversear la operacion
			CALL ISOTRXBITAFALLOSALT(
				Par_RegistroID,		Par_PIDTarea, 		Par_NumeroError,	Par_MensajeError,	Par_Transaccion,
				Salida_NO,			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT NumeroIntentos
			INTO Var_NumeroIntentos
			FROM ISOTRXTARNOTIFICA
			WHERE FechaOperacion = Par_FechaOperacion
			  AND RegistroID = Par_RegistroID;

			IF( Var_NumeroIntentos = Var_NumIntentosConWSAutoriza ) THEN

				CALL HISISOTRXTARNOTIFICAPRO(
					Par_FechaOperacion,	Par_RegistroID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Registro de Operacion realizado Correctamente.';

		END IF;

		IF( Par_NumeroActualizacion = Act_NotificacionExitosa ) THEN

			IF( IFNULL(Par_RegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El Numero de Registro No puede ser Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF( IFNULL(Par_FechaOperacion, Fecha_Vacia) = Fecha_Vacia ) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'La Fecha de Operacion No puede ser Vacia.';
				LEAVE ManejoErrores;
			END IF;

			SELECT RegistroID
			INTO Var_RegistroID
			FROM ISOTRXTARNOTIFICA
			WHERE FechaOperacion = Par_FechaOperacion
			  AND RegistroID = Par_RegistroID;

			IF( IFNULL(Var_RegistroID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Numero de Registro No Existe.';
				LEAVE ManejoErrores;
			END IF;

			UPDATE ISOTRXTARNOTIFICA SET
				Estatus 		= Est_Enviado,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FechaOperacion = Par_FechaOperacion
			  AND RegistroID = Par_RegistroID;

			CALL HISISOTRXTARNOTIFICAPRO(
				Par_FechaOperacion,	Par_RegistroID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 	Entero_Cero;
			SET Par_ErrMen	:= 'Registro de Operacion realizado Correctamente.';
		END IF;

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$