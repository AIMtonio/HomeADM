-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMMONITORTAREAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMMONITORTAREAALT`;DELIMITER $$

CREATE PROCEDURE `DEMMONITORTAREAALT`(
	-- Store procedure para dar de alta el registro de una tarea en ejecucion actual
	Par_PIDTarea 					VARCHAR(50), 			-- Identificador del hilo de ejecucion de la tarea
	Par_TareaID 					INT(11), 				-- Identificador de la tarea
	Par_FechaHoraIni 				DATETIME, 				-- Fecha y hora de ejecucion

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo			BIGINT(20),				-- Parametro de entrada/salida de para indicar el id que se a generado

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
	DECLARE Var_TareaID				INT(11);				-- ID de la tarea
	DECLARE Var_PIDTarea 			VARCHAR(50); 			-- Identificador unico del hilo de ejecucion de la tarea

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
	SET Par_FechaHoraIni 			:= IFNULL(Par_FechaHoraIni, Fecha_Vacia);


    SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMMONITORTAREAALT');
			SET Var_Control = 'sqlException';
		END;

		-- Inician validaciones
		IF(Par_PIDTarea = Cadena_Vacia) THEN
			SET Par_NumErr	:= 1;
			SET	Par_ErrMen	:= 'Especifique el PID de la tarea';
			SET Var_Control := 'PIDTarea';
			LEAVE ManejoErrores;
		END IF;

		SELECT	PIDTarea
			INTO Var_PIDTarea
			FROM DEMMONITORTAREA
			WHERE	PIDTarea = Par_PIDTarea;

		SET Var_PIDTarea := IFNULL(Var_PIDTarea, Cadena_Vacia);

		IF(Var_PIDTarea <> Cadena_Vacia) THEN
			SET Par_NumErr	:= 2;
			SET	Par_ErrMen	:='Otra tarea con el mismo PID se encuentra actualmente en ejecucion';
			SET Var_Control :='PIDTarea';
			LEAVE ManejoErrores;
		END IF;

		SELECT	TareaID
			INTO Var_TareaID
			FROM DEMTAREA
			WHERE	TareaID = Par_TareaID;

		SET Var_TareaID := IFNULL(Var_TareaID, Entero_Cero);

		IF(Var_TareaID = Entero_Cero) THEN
			SET Par_NumErr	:= 3;
			SET	Par_ErrMen	:='ID de tarea no valido';
			SET Var_Control :='PIDTarea';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaHoraIni = Fecha_Vacia) THEN
			SET Par_NumErr	:= 4;
			SET	Par_ErrMen	:='Fecha de ejecucion de la tarea no valida';
			SET Var_Control :='FechaHoraIni';
			LEAVE ManejoErrores;
		END IF;
		-- Fin de validaciones

		CALL DEMTAREASEJECUTADASALT (Par_TareaID,	Cadena_Vacia,	Cadena_Vacia,	Par_PIDTarea,	Aud_FechaActual,
									 Fecha_Vacia,	Var_SalidaSI,	Par_NumErr,		Par_ErrMen,		Par_Consecutivo,
									 Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
									 Aud_Sucursal,	Aud_NumTransaccion);


		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO DEMMONITORTAREA(	PIDTarea, 				TareaID, 				FechaHoraIni, 			EmpresaID,				Usuario,
										FechaActual,			DireccionIP,			ProgramaID,				SucursaL,				NumTransaccion
							)
							VALUES(		Par_PIDTarea,			Par_TareaID,			Par_FechaHoraIni,		Par_EmpresaID,			Aud_Usuario,
										Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
							);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Var_MenPersUno	:= 'Registro de tarea agregado exitosamente';
		SET Par_Consecutivo := Entero_Cero;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Par_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$