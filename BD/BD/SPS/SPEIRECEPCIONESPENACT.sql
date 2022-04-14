-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPENACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPENACT`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPENACT`(
	-- STORED PROCEDURE ENCARGADA DE LA ACTUALIZACION DE UNA RECEPCION PENDIENTE.
	Par_SpeiRecPenID			BIGINT(20),			-- Folio e identificador unico que es generado por el SP SPEIRECEPCIONESPENALT,
	Par_NumTransaccionRec 		BIGINT(20),			-- Numero de Transaccion de la recepcion
	Par_FolioSpeiRecID			BIGINT(20),			-- Folio de la recepcion
	Par_PIDTarea				VARCHAR(50),		-- ID de la tarea encargada del proceso de recepcion
	Par_NumAct					TINYINT,			-- Numero de actualizacion

	Par_Salida					CHAR(1),			-- Indica si el SP regresa una salida o no. S) SI, N) No
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje del Error

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Indica una Cadena Vacia
	DECLARE Entero_Cero			INT(11);			-- Indica un Entero Vacio
	DECLARE Decimal_Cero		DECIMAL(18,2);		-- Indica un Decimal Vacio
	DECLARE Fecha_Vacia			DATE;				-- Indica una Fecha Vacia
	DECLARE Salida_SI			CHAR(1);			-- Indica un valor SI
	DECLARE Salida_NO			CHAR(1);			-- Indica un valor NO
	DECLARE Est_Reg				CHAR(1);			-- Estatus registrada
	DECLARE Est_Aut				CHAR(1);			-- Estatus autorizado
	DECLARE Est_NoAut			CHAR(2);			-- Estatus no autorizado
	DECLARE Act_EstAut			TINYINT;			-- Actualizacion de estatus a autorizado
	DECLARE Act_EstNA			TINYINT;			-- Actualizacion de estatus a NO autorizado
	DECLARE Act_PIDTarea 		TINYINT;			-- Actualizacion del PIDTarea

	-- Declaracion de Variables
	DECLARE Fecha_Sist			DATE;				-- Fecha del Sistema
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_FechaOpe		DATE;				-- Fecha operacion
	DECLARE Var_SpeiRecPenID	BIGINT(20);			-- ID del registro a borrar
	DECLARE Var_Estatus 		VARCHAR(2);			-- Estatus de la recepcion
	DECLARE Hora_Act 			TIME;				-- Hora actual

	-- Asignacion de Constantes.
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- Decimal cero
	SET Salida_SI				:= 'S';				-- Salida SI
	SET Salida_NO				:= 'N';				-- Salida NO
	SET Est_Reg					:= 'R';				-- Estatus registrada
	SET Est_Aut					:= 'A';				-- Estatus autorizado
	SET Est_NoAut				:= 'NA';			-- Estatus no autorizado
	SET Act_EstAut				:= 1;				-- Actualizacion de estatus a autorizado
	SET Act_EstNA				:= 2;				-- Actualizacion de estatus a NO autorizado
	SET Act_PIDTarea 			:= 3;				-- Actualizacion del PIDTarea

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESPENACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(Par_NumAct = Act_EstAut) THEN
			IF(IFNULL(Par_NumTransaccionRec, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 1;
				SET Par_ErrMen 	:= 'Especifique el numero de transaccion de la recepcion.';
				SET Var_Control	:= 'NumTransaccionRec';
				SET Var_Consecutivo	:= Par_NumTransaccionRec;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FolioSpeiRecID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 2;
				SET Par_ErrMen 	:= 'Especifique el folio de la recepcion.';
				SET Var_Control	:= 'FolioSpeiRecID';
				SET Var_Consecutivo	:= Par_FolioSpeiRecID;
				LEAVE ManejoErrores;
			END IF;

			SELECT 		SpeiRecepcionPenID, 	Estatus
				INTO 	Var_SpeiRecPenID,		Var_Estatus
				FROM SPEIRECEPCIONESPEN
				WHERE SpeiRecepcionPenID = Par_SpeiRecPenID;

			IF(IFNULL(Var_SpeiRecPenID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 3;
				SET Par_ErrMen 	:= 'No se encontro la recepcion por actualizar.';
				SET Var_Control	:= 'SpeiRecepcionPenID';
				SET Var_Consecutivo	:= Par_SpeiRecPenID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Reg) THEN
				SET Par_NumErr 	:= 4;
				SET Par_ErrMen 	:= 'La recepcion ha sido procesada previamente.';
				SET Var_Control	:= 'SpeiRecepcionPenID';
				SET Var_Consecutivo	:= Par_SpeiRecPenID;
				LEAVE ManejoErrores;
			END IF;

			SET Fecha_Sist := (SELECT FechaSistema FROM PARAMETROSSIS);
			SET Hora_Act := CURRENT_TIME;

			UPDATE SPEIRECEPCIONESPEN
				SET Estatus = Est_Aut,
					NumTransaccionRec = Par_NumTransaccionRec,
					FolioSpeiRecID = Par_FolioSpeiRecID,
					FechaProceso = CAST(CONCAT(Fecha_Sist, ' ', Hora_Act) AS DATETIME),

					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiRecepcionPenID = Par_SpeiRecPenID; 

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Recepcion actualizada correctamente:', CONVERT(Par_SpeiRecPenID, CHAR));
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:= Par_SpeiRecPenID;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_EstNA) THEN
			SELECT 		SpeiRecepcionPenID, 	Estatus
				INTO 	Var_SpeiRecPenID,		Var_Estatus
				FROM SPEIRECEPCIONESPEN
				WHERE SpeiRecepcionPenID = Par_SpeiRecPenID;

			IF(IFNULL(Var_SpeiRecPenID, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr 	:= 1;
				SET Par_ErrMen 	:= 'No se encontro la recepcion por actualizar.';
				SET Var_Control	:= 'SpeiRecepcionPenID';
				SET Var_Consecutivo	:= Par_SpeiRecPenID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Est_Reg) THEN
				SET Par_NumErr 	:= 2;
				SET Par_ErrMen 	:= 'La recepcion ha sido procesada previamente.';
				SET Var_Control	:= 'SpeiRecepcionPenID';
				SET Var_Consecutivo	:= Par_SpeiRecPenID;
				LEAVE ManejoErrores;
			END IF;

			SET Fecha_Sist := (SELECT FechaSistema FROM PARAMETROSSIS);
			SET Hora_Act := CURRENT_TIME;

			UPDATE SPEIRECEPCIONESPEN
				SET Estatus = Est_NoAut,
					FechaProceso = CAST(CONCAT(Fecha_Sist, ' ', Hora_Act) AS DATETIME),

					EmpresaID = Aud_EmpresaID,
					Usuario = Aud_Usuario,
					FechaActual = Aud_FechaActual,
					DireccionIP = Aud_DireccionIP,
					ProgramaID = Aud_ProgramaID,
					Sucursal = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiRecepcionPenID = Par_SpeiRecPenID; 

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Recepcion actualizada correctamente: ', CONVERT(Par_SpeiRecPenID, CHAR));
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:= Par_SpeiRecPenID;
			LEAVE ManejoErrores;
		END IF;

		-- Actualizacion para la tarea de recepciones 
		IF(Par_NumAct = Act_PIDTarea) THEN
			IF(IFNULL(Par_PIDTarea, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr 	:= 1;
				SET Par_ErrMen 	:= 'Especifique el PID de la tarea.';
				SET Var_Control	:= 'PIDTarea';
				SET Var_Consecutivo	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			UPDATE SPEIRECEPCIONESPEN
				SET PIDTarea = Par_PIDTarea,
					FechaActual = Aud_FechaActual,
					NumTransaccion = Aud_NumTransaccion
				WHERE Estatus = Est_Reg AND PIDTarea = Cadena_Vacia; 

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Recepciones actualizadas correctamente.');
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:= Par_SpeiRecPenID;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'No se encontro la opcion de actualizacion';
		SET Var_Control	:= 'numAct' ;
		SET Var_Consecutivo	:= Par_NumAct;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
