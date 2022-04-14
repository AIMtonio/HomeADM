-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARBITASPEIREMESASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARBITASPEIREMESASACT`;

DELIMITER $$
CREATE PROCEDURE `TARBITASPEIREMESASACT`(

	Par_SpeiRemID						BIGINT(20),
	Par_PIDTarea						VARCHAR(50),
	Par_Observacion						VARCHAR(500),

	Par_NumAct							TINYINT UNSIGNED,

	Par_Salida							CHAR(1),
	INOUT Par_NumErr					INT(11),
	INOUT Par_ErrMen					VARCHAR(400),

	Par_EmpresaID 						INT(11),
	Aud_Usuario							INT(11),
	Aud_FechaActual						DATETIME,
	Aud_DireccionIP						VARCHAR(15),
	Aud_ProgramaID						VARCHAR(50),
	Aud_Sucursal						INT(11),
	Aud_NumTransaccion					BIGINT(20)
)

TerminaStore: BEGIN

	DECLARE Var_Control					VARCHAR(50);


	DECLARE Entero_Cero					INT(11);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Fecha_Vacia					DATE;
	DECLARE Var_SalidaSI				CHAR(1);
	DECLARE Var_SalidaNO				CHAR(1);
	DECLARE Var_EstProcesada			CHAR(1);
	DECLARE Var_ActProcesada			TINYINT UNSIGNED;
	DECLARE Var_ActObservac				TINYINT UNSIGNED;


	SET Entero_Cero						:= 0;
	SET Cadena_Vacia					:= '';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Var_SalidaSI					:= 'S';
	SET Var_SalidaNO					:= 'N';
	SET Var_EstProcesada				:= 'R';
	SET Var_ActProcesada				:= 1;
	SET Var_ActObservac					:= 2;


	SET Par_SpeiRemID					:= IFNULL(Par_SpeiRemID, Entero_Cero);
	SET Par_PIDTarea					:= IFNULL(Par_PIDTarea, Cadena_Vacia);
	SET Par_Observacion					:= IFNULL(Par_Observacion, Cadena_Vacia);

	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TARBITASPEIREMESASACT');
			SET Var_Control = 'sqlException';
		END;

		IF (Par_NumAct = Var_ActProcesada) THEN

			IF (Par_SpeiRemID = Entero_Cero) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El identificador de la remesa';
				SET Var_Control	:= 'pIDTarea';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_PIDTarea = Cadena_Vacia) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El identificador del hilo de ejecucion esta vacio';
				SET Var_Control	:= 'pIDTarea';
				LEAVE ManejoErrores;
			END IF;

			UPDATE TARBITASPEIREMESASACT SET
				Estatus			= Var_EstProcesada,
				PIDTarea		= Par_PIDTarea,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE SpeiRemID = Par_SpeiRemID;


			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Registro de la bitacora Actualizado exitosamente : ', CAST(Par_SpeiRemID AS CHAR));
			SET Var_Control	:= 'speiRemID';

		END IF;

		IF (Par_NumAct = Var_ActObservac) THEN

			IF (Par_SpeiRemID = Entero_Cero) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El identificador de la remesa';
				SET Var_Control	:= 'pIDTarea';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_PIDTarea = Cadena_Vacia) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El identificador del hilo de ejecucion esta vacio';
				SET Var_Control	:= 'pIDTarea';
				LEAVE ManejoErrores;
			END IF;

			UPDATE TARBITASPEIREMESASACT SET
				PIDTarea		= Par_PIDTarea,
				Observacion		= Par_Observacion,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE SpeiRemID = Par_SpeiRemID;


			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Registro de la bitacora Actualizado exitosamente : ', CAST(Par_SpeiRemID AS CHAR));
			SET Var_Control	:= 'speiRemID';

		END IF;

	END ManejoErrores;


	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_SpeiRemID			AS consecutivo;
	END IF;


END TerminaStore$$