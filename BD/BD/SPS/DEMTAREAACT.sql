-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTAREAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMTAREAACT`;
DELIMITER $$


CREATE PROCEDURE `DEMTAREAACT`(
	-- SP para actualizacion del estatus de una tarea
	Par_TareaID						INT(11),			-- ID de la tarea
	Par_NombreClase					VARCHAR(150),		-- Nombre de la clase
	Par_NombreJar					VARCHAR(100),		-- Nombre del jar que contienen la logica de la tarea(job)
	Par_NombreTarea					VARCHAR(100),		-- Nombre de la tarea
	Par_Descripcion					TEXT,				-- descripcion de lo que hace la tarea
	Par_Estatus						CHAR(1),			-- Estatus de la tarea
	Par_EjecucionMultiple			CHAR(1),			-- Ejecucion multiple
	Par_CronEjecucion				VARCHAR(200),		-- Expresion cron, que indica la ejecucion de la tarea

	Par_NumAct						TINYINT UNSIGNED,	-- Numero de actualizacion

	Par_Salida						CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	INOUT Par_Consecutivo			BIGINT(20),			-- Parametro de entrada/salida de para indicar el ID que se ha generado

	Par_EmpresaID					INT(11),			-- Parametros de Auditoria
	Aud_Usuario						INT(11),			-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal					INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_ActEstActivo		TINYINT UNSIGNED;	-- Actualizacion a estatus activo
	DECLARE Var_SalidaSI			CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);			-- Salida no
	DECLARE Var_ActCron				INT(1);			-- Actualizacion del cron ejecucion

	-- Declaracion de constantes
	DECLARE Est_Activo				CHAR(1);			-- Estatus activo
	DECLARE Est_Recarga				CHAR(1);			-- Estatus activo
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Entero_Cero				INT(11);			-- Entero cero
	DECLARE Con_ProgramaID			VARCHAR(50);		-- Constante de programa auditoriria

	-- Asignacion de constantes
	SET Est_Activo					:= 'A';				-- Estatus activo
	SET Est_Recarga					:= 'R';				-- Estatus recarga
	SET Cadena_Vacia				:= '';				-- Cadena vacia
	SET Entero_Cero					:= 0;				-- Entero cero
	SET Con_ProgramaID				:= 'DemTareaActDAO.demTareaAct01';
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Con_ProgramaID);
	
	-- Asignacion de varables
	SET	Var_ActEstActivo			:= 1;				-- Actualizacion a estatus activo
	SET Var_ActCron					:= 2;				-- Actualizacion del cron ejecucion
	SET Var_SalidaSI				:= 'S';				-- Salida si
	SET Var_SalidaNO				:= 'N';				-- Salida no
	
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-DEMTAREAACT');
			SET Var_Control = 'sqlException';
		END;

		-- Se actualizan a estatus activo todas las tareas que tengan estatus de recarga
		IF (Par_NumAct = Var_ActEstActivo) THEN
			UPDATE DEMTAREA SET
				Estatus			= Est_Activo,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE	TareaID = Par_TareaID;

			SET Par_NumErr		:= Entero_Cero;
			SET Par_ErrMen		:= 'Tareas actualizadas exitosamente';
			SET Var_Control		:= Cadena_Vacia;
			SET Par_Consecutivo	:= Entero_Cero;
		END IF;
		-- Se actualizacion de cron ejecucion
		IF(Par_NumAct = Var_ActCron) THEN
			UPDATE DEMTAREA SET
				CronEjecucion	= Par_CronEjecucion,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE	TareaID = Par_TareaID;

			SET Par_NumErr		:= Entero_Cero;
			SET Par_ErrMen		:= 'Tareas actualizadas exitosamente';
			SET Var_Control		:= Cadena_Vacia;
			SET Par_Consecutivo	:= Entero_Cero;
				
		END IF;
		
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Par_Consecutivo	AS consecutivo;
	END IF;
END TerminaStore$$
