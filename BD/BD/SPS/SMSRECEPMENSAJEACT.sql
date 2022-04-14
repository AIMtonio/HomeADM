-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSRECEPMENSAJEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSRECEPMENSAJEACT`;DELIMITER $$

CREATE PROCEDURE `SMSRECEPMENSAJEACT`(
# ========================================================
# -SP PARA ACTUALIZAR VALORES EN LA TABLA SMSRECEPMENSAJE-
# ========================================================
    Par_RecepcionID			INT(11),
	Par_NumAct				INT(11),

	Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ValorParametro  CHAR(1);
	DECLARE Var_Control         VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT(11);
	DECLARE	ActEstaProce		INT(11);
	DECLARE	ActEstaCanel		INT(11);
	DECLARE	Salida_SI			CHAR(1);
    DECLARE EstProcesado		CHAR(1);
    DECLARE EstCancelado		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia        	:= '';					-- Cadena Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET ActEstaProce	 		:= 1;					-- Actualizacion a estatus preocesado
    SET ActEstaCanel	 		:= 2;					-- Actualizacion a estatus cancelado
	SET	Salida_SI				:= 'S';					-- Salida SI
    SET EstProcesado			:= 'P';					-- Estatus Procesado
	SET	EstCancelado			:= 'C';					-- Estatus Cancelado
    SET Aud_FechaActual 		:= CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSRECEPMENSAJEACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

        IF(Par_NumAct = ActEstaProce)THEN

			IF(IFNULL(Par_RecepcionID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'El ID del Mensaje esta Vacio.';
				SET Var_Control := 'recepcionID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE	SMSRECEPMENSAJE SET
				Estatus			= EstProcesado ,
                FechaRealEnvio	= Aud_FechaActual
			WHERE	RecepMensajeID	= Par_RecepcionID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'SMS Actualizado.';
			SET Var_Control := 'recepcionID';

		END IF;

        IF(Par_NumAct = ActEstaCanel)THEN

			IF(IFNULL(Par_RecepcionID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'El ID del Mensaje esta Vacio.';
				SET Var_Control := 'recepcionID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE	SMSRECEPMENSAJE SET
				Estatus			= EstCancelado
			WHERE	RecepMensajeID	= Par_RecepcionID;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'SMS Actualizado.';
			SET Var_Control := 'recepcionID';

		END IF;



	END ManejoErrores;

		IF(Par_Salida = Salida_SI)THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Entero_Cero AS consecutivo;
		END IF;

END TerminaStore$$