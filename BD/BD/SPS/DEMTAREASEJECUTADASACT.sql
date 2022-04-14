-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREASEJECUTADASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMTAREASEJECUTADASACT`;DELIMITER $$

CREATE PROCEDURE `DEMTAREASEJECUTADASACT`(
	-- SP para actualizar el estatus de la tarea en la bitacora DEMTAREASEJECUTADAS
	Par_TareaID						INT(11),				-- Identificador de la tarea
	Par_CodigoResuesta				VARCHAR(10),			-- Codigo de respuesta
	Par_MensajeRespuesta			VARCHAR(500),			-- Mensaje de respuesta
	Par_PidTarea					VARCHAR(50),			-- Identificador del hilo de ejecucion
	Par_FechaInicio					DATETIME,				-- Fecha de inicio de la tarea
	Par_FechaFin					DATETIME,				-- Fecha de fin de la tarea

	Par_NumAct						TINYINT UNSIGNED,		-- Numero de actualizacion

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo			BIGINT(20),				-- Parametro de entrada/salida de para indicar el id que se ha generado

	Par_EmpresaID					INT(11),				-- Parametros de Auditoria
	Aud_Usuario						INT(11),				-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal					INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de Auditoria

)
TerminaStore: BEGIN
	     -- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(14,2); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_SalidaSI			CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Var_ActCodResp			INT(11);				-- Actualizacion para el codigo y MensajeRespuestade MensajeRespuesta
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_ActCodResp				:= 1;					-- Actualizacion para el codigo y MensajeRespuestade MensajeRespuesta

	-- Valores default
	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, curdate());
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	SET Par_TareaID					:= IFNULL(Par_TareaID, Entero_Cero);
	SET Par_CodigoResuesta			:= IFNULL(Par_CodigoResuesta, Cadena_Vacia);
	SET Par_MensajeRespuesta		:= IFNULL(Par_MensajeRespuesta , Cadena_Vacia);
	SET Par_PidTarea				:= IFNULL(Par_PidTarea , Cadena_Vacia);
	SET Par_FechaInicio				:= IFNULL(Par_FechaInicio, CURDATE());
	SET Par_FechaFin				:= IFNULL(Par_FechaFin, CURDATE());

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMTAREASEJECUTADASACT');
			SET Var_Control	= 'sqlException';
		END;

		IF(Par_NumAct = Var_ActCodResp) THEN
			IF(Par_CodigoResuesta = Cadena_Vacia) THEN
				SET Par_NumErr	:= 1;
				SET	Par_ErrMen	:= 'Para actualizar el estatus de la tarea en la bitacora, es necesario que el codigo de respuesta no este vacio';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_PidTarea = Cadena_Vacia) THEN
					SET Par_NumErr	:= 1;
					SET	Par_ErrMen	:= 'Para actualizar el estatus de la tarea en la bitacora, es necesario que se especifique el PID de la tarea';
					LEAVE ManejoErrores;
			END IF;

			UPDATE DEMTAREASEJECUTADAS SET
					CodigoResuesta 		= Par_CodigoResuesta,
					MensajeRespuesta	= Par_MensajeRespuesta,
					FechaFin			= Par_FechaFin,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE	PidTarea = Par_PidTarea;

			SET Par_NumErr		:= 0;
			SET	Par_ErrMen	:= CONCAT('La tarea con PID[',Par_PidTarea,'] se ha actualizado correctamente en la bitacora');
			SET Par_Consecutivo := Par_TareaID;

			LEAVE ManejoErrores;

		END IF;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Cadena_Vacia	AS control,
				Par_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$