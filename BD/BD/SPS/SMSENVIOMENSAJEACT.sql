-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVIOMENSAJEACT`;DELIMITER $$

CREATE PROCEDURE `SMSENVIOMENSAJEACT`(
# ========================================================
# ----------- SP PARA ACTUALIZAR LOS MENSAJES SMS---------
# ========================================================
	Par_CampaniaID		INT(11),
	Par_FechaCancel		DATETIME,
	Par_OpCancel		CHAR(1),  -- indica si se cancela solo mensajes o campania tambien
    Par_EnvioID			INT(11),
	Par_PIDTarea		VARCHAR(50),		-- Identificador del hilo de ejecucion de la tarea
	Par_NumAct			TINYINT UNSIGNED,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ValorParametro  CHAR(1);
	DECLARE Var_Control         VARCHAR(100);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT;
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Est_Cancelado		CHAR(1);
	DECLARE	Var_CodigoError		CHAR(1);	-- Codigo de error
	DECLARE CancelMensajes		CHAR(1);
	DECLARE CancelAmbos			CHAR(1);
	DECLARE NumCancelCam		INT;
	DECLARE	ActEstaEnvio		INT;
	DECLARE	Var_ActErrEnvio		INT(11);	--  Actualizacion a estatus de fallo de envío
    DECLARE EstEnviado			CHAR(1);
    DECLARE CodigoMsgExito		CHAR(1);
	DECLARE Est_NoEnviado		CHAR(1);	-- Estatus no enviado
	DECLARE	Var_ActProceso		TINYINT;	-- Actualizacion en proceso
	DECLARE	Est_Proceso			CHAR(1);	-- Estatus en proceso
	DECLARE	Var_ActNoEnv		TINYINT;	-- Actualizacion a no enviado, solo en caso de creditos insuficientes


	-- Asignacion de constantes
	SET	Entero_Cero		:= 0;			-- Entero Cero
	SET	SalidaSI		:= 'S';			-- Salida SI
	SET	SalidaNO		:= 'N';			-- Salida NO
	SET	Cadena_Vacia	:= '';			-- Cadena Vacía
	SET	Fecha_Vacia     := '1900-01-01';-- Fecha Default
	SET	Est_Cancelado	:= 'C';			-- Estatus Cancelado
	SET	Var_CodigoError	:= 'F';			-- Codigo de Error
	SET	CancelMensajes	:= 1;			-- Cancela Solo Mensajes
	SET	CancelAmbos		:= 2;			-- Cancela Mensajes y Campania
	SET NumCancelCam	:= 4;			-- Número de Actualizacion: Cancela Campania
	SET ActEstaEnvio	:= 3;			--  Actualizacion a estatus Enviado
	SET Var_ActErrEnvio	:= 5;			--  Actualizacion a estatus de fallo de envío
	SET EstEnviado		:= 'E';			--  Estatus Procesado
    SET CodigoMsgExito	:= 'E';			-- 	Codigo de Mensaje Exito
	SET Est_NoEnviado	:= 'N';			-- Estatus no enviado
	SET Var_ActProceso	:= 6;			-- Actualizacion en proceso
	SET Est_Proceso		:= 'P';			-- Estatus en proceso
	SET Var_ActNoEnv	:= 7;			-- Actualizacion a no enviado, solo en caso de creditos insuficientes
	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSENVIOMENSAJEACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_CampaniaID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'La Campania esta Vacia.';
			SET Var_Control := 'campaniaID';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_OpCancel = CancelMensajes OR Par_OpCancel = CancelAmbos) THEN

			IF(IFNULL(Par_FechaCancel, Fecha_Vacia))= Fecha_Vacia THEN
				SET	 Par_NumErr := 2;
				SET  Par_ErrMen := 'La Fecha de Cancelacion esta Vacia.';
				SET Var_Control := 'campaniaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_OpCancel = CancelMensajes) THEN

			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			UPDATE	SMSENVIOMENSAJE SET
					Estatus 		= Est_Cancelado,
					EmpresaID 		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE	CampaniaID 	= Par_CampaniaID
				AND 	FechaProgEnvio > Par_FechaCancel;

			SET	Par_NumErr 	:= 000;
			SET Par_ErrMen 	:= 'Mensajes Cancelados Exitosamente.';
            SET Var_Control := 'campaniaID';
		END IF;


		IF(Par_OpCancel = CancelAmbos) THEN
			SET Aud_FechaActual := CURRENT_TIMESTAMP();

			UPDATE 	SMSENVIOMENSAJE SET
					Estatus 		= Est_Cancelado,
					EmpresaID 		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE	CampaniaID 	= Par_CampaniaID
				AND 	FechaProgEnvio > Par_FechaCancel;

			CALL SMSCAMPANIASACT (
				Par_CampaniaID,	NumCancelCam,	SalidaNO,			Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

            SET	Par_NumErr 	:= 000;
			SET Par_ErrMen 	:= 'Mensajes Cancelados Exitosamente.';
            SET Var_Control := 'campaniaID';

		END IF;

		IF(Par_NumAct = ActEstaEnvio)THEN

			IF(IFNULL(Par_EnvioID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'El ID del Mensaje esta Vacio.';
				SET Var_Control := 'envioID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE	SMSENVIOMENSAJE SET
				Estatus			= EstEnviado,
                CodExitoErr		= CodigoMsgExito,
                FechaRealEnvio  = Aud_FechaActual,

                EmpresaID	   	= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal	   	= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE	EnvioID		= Par_EnvioID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'SMS Actualizado.';
			SET Var_Control := 'envioID';

		END IF;

		-- Actualizacion de codigo de mensaje a fallido
		IF(Par_NumAct = Var_ActErrEnvio) THEN
			UPDATE	SMSENVIOMENSAJE SET
				Estatus			= Est_NoEnviado,
				PIDTarea		= Cadena_Vacia,
				CodExitoErr		= Var_CodigoError,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE	EnvioID = Par_EnvioID;

			SET	Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus actualizado exitosamente';
            SET Var_Control	:= 'envioID';
		END IF;

		-- Actualizacion de estatus de mensaje a proceso
		IF(Par_NumAct = Var_ActProceso) THEN
			UPDATE	SMSENVIOMENSAJE SET
				Estatus			= Est_Proceso,
				PIDTarea		= Par_PIDTarea,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE	Estatus = Est_NoEnviado
				  AND	CodExitoErr = Cadena_Vacia
				  AND	PIDTarea = Cadena_Vacia
				  AND	FechaProgEnvio <= Aud_FechaActual;

			SET	Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus de envio actualizado exitosamente';
            SET Var_Control	:= 'envioID';
		END IF;

		-- Actualizacion de estatus de mensaje a no enviado, solo en caso de creditos insuficientes
		IF(Par_NumAct = Var_ActNoEnv) THEN
			IF(IFNULL(Par_EnvioID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'El ID del Mensaje esta Vacio.';
				SET Var_Control := 'envioID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE	SMSENVIOMENSAJE SET
				Estatus			= Est_NoEnviado,
				CodExitoErr		= Cadena_Vacia,
				PIDTarea		= Cadena_Vacia,
				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE	EnvioID	= Par_EnvioID;

			SET	Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Estatus de envio actualizado exitosamente';
            SET Var_Control	:= 'envioID';
		END IF;
	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$