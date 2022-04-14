-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMMONITORTAREAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMMONITORTAREAPRO`;DELIMITER $$

CREATE PROCEDURE `DEMMONITORTAREAPRO`(
	-- STORED PROCEDURE PARA DAR DE BAJA LAS TAREAS DE DEMMONITORTAREA E INSERTARLES EN LA BITACORA DE TAREAS
	Par_PIDTarea					VARCHAR(50),			-- Identificador del hilo de ejecucion de la tarea
	Par_TareaID						INT(11),				-- Identificador de la tarea
	Par_FechaHoraIni				DATETIME,				-- Fecha y hora de ejecucion

	Par_Salida						CHAR(1),				-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr				INT(11),				-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen				VARCHAR(10000),			-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo			BIGINT(20),				-- Parametro de entrada/salida de para indicar el ID que se ha generado

	Par_EmpresaID					INT(11),				-- Parametros de Auditoria
	Aud_Usuario						INT(11),				-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal					INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_TareaID				INT(11);				-- ID de la tarea
	DECLARE Var_PIDTarea			VARCHAR(50);			-- Identificador unico del hilo de ejecucion de la tarea
	DECLARE Var_FechaHoraIni		DATETIME;				-- Fecha y hora en la que se inicio la tarea
	DECLARE Var_RegistroActual		INT(11);				-- Variable para el registro en el cual se encuente iterando el ciclo WHILE
	DECLARE Var_MaxRegistros		INT(11);				-- Variable para el maximo de registros que contendra la tabla temporal
	DECLARE Var_ErrMen				VARCHAR(10000);			-- Variable para concatenar los ID's de tareas
	DECLARE Var_NombreClase			VARCHAR(150);			-- Nombre completo de la clase de la tarea incluyendo paquetes

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Entero_Uno				INT(11);				-- Entero uno
	DECLARE Decimal_Cero			DECIMAL(14,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_SalidaSI			CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Var_CodigoRespuesta		VARCHAR(10);			-- Codigo de respuesta
	DECLARE Var_MensajeRespuesta	VARCHAR(500);			-- Mensaje de respuesta
	DECLARE Var_ActCodResp			TINYINT UNSIGNED;		-- Actualizacion para el codigo y mensaje de respuesta

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;																					-- Asignacion de entero vacio
	SET Entero_Uno					:= 1;																					-- Asignacion de entero uno
	SET Decimal_Cero 				:= 0.0;																					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';																					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';																		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';																					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';																					-- Asignacion de salida no
	SET Var_CodigoRespuesta			:= '99';																				-- Codigo de respuesta
	SET Var_MensajeRespuesta		:= 'No se pudo completar la tarea debido a que el Scheduler termino inesperadamente';	-- Mensaje de respuesta
	SET Var_ActCodResp				:= 1;																					-- Actualizacion para el codigo y mensaje de respuesta

	-- Valores por default
	SET Par_PIDTarea				:= IFNULL(Par_PIDTarea, Cadena_Vacia);
	SET Par_TareaID					:= IFNULL(Par_TareaID, Entero_Cero);
	SET Par_FechaHoraIni			:= IFNULL(Par_FechaHoraIni, Fecha_Vacia);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMMONITORTAREAPRO');
			SET Var_Control = 'sqlException';
		END;

		DROP TABLE IF EXISTS TMPDEMTAREAS;
		CREATE TEMPORARY TABLE TMPDEMTAREAS(
			Tmp_DemTareaID			INT(11)		AUTO_INCREMENT,		-- Identificador para la tabla
			Tmp_PIDTarea			VARCHAR(50),					-- Identificador del hilo de ejecucion de la tarea
			Tmp_TareaID				INT(11),						-- Identificador de la tarea
			Tmp_FechaHoraIni		DATETIME,						-- Fecha y hora en la que se inicio la tarea
			PRIMARY KEY (Tmp_DemTareaID)
		);

		-- Lista tareas que se quedaron registradas en DEMMONITORTAREA
		INSERT INTO TMPDEMTAREAS (	Tmp_PIDTarea,	Tmp_TareaID,	Tmp_FechaHoraIni)
							SELECT	PIDTarea,		TareaID,		FechaHoraIni
								FROM DEMMONITORTAREA;

		SELECT		MAX(Tmp_DemTareaID)
			INTO	Var_MaxRegistros
			FROM	TMPDEMTAREAS;

		SET Var_RegistroActual := Entero_Uno;
		SET Var_ErrMen := Cadena_Vacia;

		-- Se guarda en DEMTAREASEJECUTADAS la lista de tareas que se quedaron en DEMMONITORTAREA
		IteraRegistros: WHILE (Var_RegistroActual <= Var_MaxRegistros) DO
			SELECT		tmp.Tmp_PIDTarea,	tmp.Tmp_TareaID,	tmp.Tmp_FechaHoraIni,	tar.NombreClase
				INTO	Var_PIDTarea,		Var_TareaID,		Var_FechaHoraIni,		Var_NombreClase
				FROM TMPDEMTAREAS AS tmp
				INNER JOIN DEMTAREA AS tar ON tmp.Tmp_TareaID = tar.TareaID
				WHERE	Tmp_DemTareaID = Var_RegistroActual;

			CALL DEMTAREASEJECUTADASACT(	Var_TareaID,		Var_CodigoRespuesta,	Var_MensajeRespuesta,	Var_PIDTarea,		Var_FechaHoraIni,
											Fecha_Vacia,		Var_ActCodResp,			Var_SalidaNO,			Par_NumErr,			Par_ErrMen,
											Par_Consecutivo,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				SET Var_Control		:= 'DEMTAREASEJECUTADASACT';
				SET Par_Consecutivo	:= Var_TareaID;
				LEAVE ManejoErrores;
			END IF;

			-- Se eliminan las tareas de DEMMONITORTAREA
			CALL DEMMONITORTAREABAJ(	Var_PIDTarea,		Var_TareaID,		Var_FechaHoraIni,	Var_SalidaNO,		Par_NumErr,
										Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
										Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				SET Var_Control		:= 'DEMMONITORTAREABAJ';
				SET Par_Consecutivo	:= Var_TareaID;
				LEAVE ManejoErrores;
			END IF;

			IF (Var_ErrMen <> Cadena_Vacia) THEN
				SET Var_ErrMen := CONCAT(Var_ErrMen, ',');
			END IF;

			SET Var_ErrMen := CONCAT(Var_ErrMen, CAST(Var_TareaID AS CHAR), '-', Var_NombreClase);

			SET Var_RegistroActual := Var_RegistroActual + Entero_Uno;
		END WHILE IteraRegistros;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= Var_ErrMen;
		SET Var_Control		:= Cadena_Vacia;
		SET Par_Consecutivo	:= Entero_Cero;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Par_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$