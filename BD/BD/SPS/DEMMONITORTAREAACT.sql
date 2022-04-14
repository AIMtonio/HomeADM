-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMMONITORTAREAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMMONITORTAREAACT`;DELIMITER $$

CREATE PROCEDURE `DEMMONITORTAREAACT`(
	-- SP para actualizar el estatus de una tarea a activo
	Par_TareaID 					INT(11), 				-- Identificador de la tarea

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
	DECLARE Var_ActActivo			TINYINT;
	DECLARE STA_ACTIVO				CHAR(1);				-- Estatus activo
	DECLARE STA_RECARGAR			CHAR(1);				-- Estatus de recarga
	DECLARE STA_BAJA				CHAR(1);				-- Estatus de Baja

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de control
	DECLARE Var_MenPersUno			VARCHAR(100);			-- Mensaje personalizado para la tabla de MENSAJESISTEMA para el campo MensajeDev
	DECLARE Var_Num_Act				INT(11);				-- Numero de actualizacion
	DECLARE Var_TareaID				INT(11);				-- ID de la tarea
	DECLARE Var_PIDTarea 			VARCHAR(50); 			-- Identificador unico del hilo de ejecucion de la tarea
	DECLARE Var_TotalRegRec			INT;
	DECLARE Var_EstatusTar			CHAR(1);				-- Variable para guardar el estatus de una tarea;
	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Var_SalidaSI				:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Var_ActActivo				:= 1 ;					-- Actualizacion que cambia el estatus de R a A
	SET STA_ACTIVO					:= 'A';					-- Asignacion de de estatus Activo
	SET STA_RECARGAR				:= 'R';					-- Asignacion de de estatus recarga
	SET STA_BAJA					:= 'B';					-- Asignacion de estatus de baja

	-- Valores por default
	SET Par_TareaID 				:= IFNULL(Par_TareaID, Entero_Cero);

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
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMMONITORTAREAACT');
			SET Var_Control = 'sqlException';
		END;

		IF(Par_NumAct = Var_ActActivo) THEN
			SELECT	TareaID,     Estatus
			INTO Var_TareaID,    Var_EstatusTar
			FROM DEMTAREA
			WHERE	TareaID = Par_TareaID;

			SET Var_TareaID := IFNULL(Var_TareaID, Entero_Cero);
			SET Var_EstatusTar  := IFNULL(Var_EstatusTar,Cadena_Vacia);

			IF(Var_TareaID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET	Par_ErrMen	:='ID de la tarea no valido';
				SET Var_Control :='TareaID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusTar = STA_BAJA ) THEN
				SET Par_NumErr	:= 2;
				SET	Par_ErrMen	:= CONCAT('La tarea con ID[',Par_TareaID,'] no se puede actualizar por que  tiene un estatus de Baja');
				SET Var_Control :='TareaID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE DEMTAREA SET
				Estatus = STA_ACTIVO
			WHERE TareaID = Par_TareaID ;

			SET Par_NumErr		:= 0;
			SET Par_ErrMen	:= CONCAT('El estatus de la tarea[',Par_TareaID,'] ha sido actualizado por que esta dada de baja');
			SET Par_Consecutivo := Entero_Cero;
			SET Par_Consecutivo := Entero_Cero;
		END IF;

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