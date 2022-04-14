-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMLOGTAREAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMLOGTAREAALT`;DELIMITER $$

CREATE PROCEDURE `DEMLOGTAREAALT`(
	-- Store procedure para dar de alta el log de una tarea
	Par_PIDTarea 					VARCHAR(50), 			-- Identificador del hilo de ejecucion de la tarea
	Par_TareaID 					INT(11), 				-- Identificador de la tarea
	Par_FechaHoraEjec 				DATETIME, 				-- Fecha y hora de ejecucion
	Par_CodigoRespuesta 			VARCHAR(50),			-- Codigo de respuesta
	Par_MensajeRespuesta 			TEXT,		 			-- Mensaje de respuesta

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo			BIGINT,					-- Parametro de entrada/salida de para indicar el id que se a generado

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

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_MenPersUno			VARCHAR(100);			-- Mensaje personalizado para la tabla de MENSAJESISTEMA para el campo MensajeDev
	DECLARE Var_Num_Act				INT(11);				-- Numero de actualizacion
	DECLARE Var_TareaID				INT(11);				-- ID de la tareaPar_NumErr
	DECLARE Var_PIDTarea 			VARCHAR(20); 			-- Identificador unico del hilo de ejecucion de la tarea

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no

	-- Valores por default
	SET Par_PIDTarea 				:= IFNULL(Par_PIDTarea, Cadena_Vacia);
	SET Par_TareaID 				:= IFNULL(Par_TareaID, Entero_Cero);
	SET Par_FechaHoraEjec			:= IFNULL(Par_FechaHoraEjec, Fecha_Vacia);
	SET Par_CodigoRespuesta 		:= IFNULL(Par_CodigoRespuesta, Cadena_Vacia);
	SET Par_MensajeRespuesta 		:= IFNULL(Par_MensajeRespuesta, Cadena_Vacia);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion	        := IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMLOGTAREAALT');
			SET Var_Control = 'sqlException';
		END;

		-- Inician validaciones
		IF(Par_PIDTarea = Cadena_Vacia) THEN
			SET Par_NumErr	:= 1;
			SET	Par_ErrMen	:= 'Especifique el PID de la tarea';
			SET Var_Control := 'PIDTarea';
			LEAVE ManejoErrores;
		END IF;

		SELECT	TareaID
			INTO Var_TareaID
			FROM DEMTAREA
			WHERE	TareaID = Par_TareaID;

		SET Var_TareaID := IFNULL(Var_TareaID, Entero_Cero);

		IF(Var_TareaID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET	Par_ErrMen	:= 'ID de tarea no valido';
			SET Var_Control := 'TareaID';
			LEAVE ManejoErrores;
		END IF;

		-- Fin de validaciones

		INSERT INTO DEMLOGTAREA(	PIDTarea, 				TareaID, 				FechaHoraEjec, 			CodigoRespuesta, 		MensajeRespuesta,
									EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
									SucursaL,				NumTransaccion
							)
							VALUES(	Par_PIDTarea,			Par_TareaID,			Par_FechaHoraEjec,		Par_CodigoRespuesta,	Par_MensajeRespuesta,
									Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
									Aud_Sucursal,			Aud_NumTransaccion
							);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= '000000';
		SET Par_ErrMen		:= 'Registro de tarea agregado exitosamente';
		SET Par_Consecutivo	:= Entero_Cero;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Par_Consecutivo	AS consecutivo,
				Var_Control		AS control;
	END IF;

-- Fin del SP
END TerminaStore$$