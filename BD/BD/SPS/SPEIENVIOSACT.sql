-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIENVIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIENVIOSACT`;
DELIMITER $$


CREATE PROCEDURE `SPEIENVIOSACT`(
# =====================================================================================
# ------- STORE PARA ACTUALIZAR UN ENVIOS SPEI ---------
# =====================================================================================
	Par_Folio						BIGINT(20),				-- Folio de Envio SPEI
	Par_ClaveRastreo				VARCHAR(30),			-- Clave de rastreo
	Par_EstatusEnv					INT(3),					-- Estatus de envio
	Par_CausaDevol					INT(2),					-- Estatus de devolucion
	Par_Comentario					VARCHAR(500),			-- Comentario de cancelacion

	Par_UsuarioEnvio				VARCHAR(30),			-- Usuario que realiza la operacion
	Par_UsuarioAutoriza				INT(11),				-- ID del usuario que autoriza el Envio
	Par_UsuarioVerifica				INT(11),				-- ID del usuario que verifica el Envio
	Par_NumAct						TINYINT UNSIGNED,		-- Numero de actualizacion

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(20),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(200);			-- Variable de control
	DECLARE Var_Estatus				CHAR(1);				-- estatus del envio
	DECLARE Var_AutTes				CHAR(1);				-- Verifica Envios Tesoreria
	DECLARE Var_MonReqAutDesem		DECIMAL(16,2);			-- Monto a partir del cual un desembolso por SPEI requerira autorizacon
	DECLARE Var_MontoTransferir		DECIMAL(16,2);			-- Monto de transferencia del SPEI
	DECLARE Var_EstatusFinal		CHAR(1);				-- Estatus final que tendra el SPEI por desembolso
	DECLARE Var_FechaAuto			DATETIME;				-- Fecha de autorizacion que tendra el SPEI por desembolso
    DECLARE Var_Credito             BIGINT(12);             -- ID de credito
    DECLARE Var_SolCreditoID        BIGINT(11);             -- ID de la solicitud de credito
    DECLARE Var_Aportaciones        BIGINT(20);             -- ID de aportaciones
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);				-- constante cadena vacia
	DECLARE Entero_Cero				INT(11);				-- Constante entero cero
	DECLARE Decimal_Cero			DECIMAL;				-- constante decimal cero
	DECLARE	Fecha_Vacia				DATE;					-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Constante salida si
	DECLARE SalidaNO				CHAR(1);				-- Constante salida NO
	DECLARE Act_Enviada				INT(11);				-- Actualizacion enviada
	DECLARE Act_Autorizada			INT(11);				-- actualizacion autorizada
	DECLARE Act_Cancelada			INT(11);				-- actualizacion cancelada
	DECLARE Act_NotiBan 			INT(11);				-- actualizacion notificacion
	DECLARE Act_FechaEnv			INT(11);				-- actualizacion fecha envio
	DECLARE Act_Devuelta			INT(11);				-- actualizacion devuelta
	DECLARE Act_SaldoTeso			INT(11);				-- actulaiza el estatus de pendiente a autorizado
	DECLARE Act_EstatusCancelado	INT(11);				-- actulaiza el estatus de pendiente a cancelado
	DECLARE Act_Ver				INT(11);				-- actualizacion a verificado
	DECLARE Act_CancelCone			INT(11);				-- actualizacion cancelada por conecta
	DECLARE Act_EstatusDesemPen		INT(11);				-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
	DECLARE Estatus_Pen				CHAR(1);				-- estatus pendiente
	DECLARE Estatus_Env				CHAR(1);				-- estatus enviada
	DECLARE Estatus_Aut				CHAR(1);				-- estatus autorizada
	DECLARE Estatus_Can				CHAR(1);				-- estatus cancelada
	DECLARE Estatus_Dev				CHAR(1);				-- estatus devuelto
	DECLARE Estatus_Ver				CHAR(1);				-- estatus verificado
	DECLARE EstatusEnv_Can			INT(11);				-- estatus cancelado de conecta
	DECLARE Var_FolioSpeiDesembolso	BIGINT(20);				-- Folio del SPEI por desembolso
    DECLARE Estatus_Dispersado      CHAR(1);                -- Estatus Dispersado spei
	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';					-- Cadena Vacia
	SET Entero_Cero					:= 0;					-- Entero Cero
	SET Decimal_Cero				:= 0.0;					-- Decimal Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET SalidaSI					:= 'S';					-- Salida SI
	SET SalidaNO					:= 'N';					-- Salida NO
	SET Par_NumErr					:= 0;					-- Parametro numero de error
	SET Par_ErrMen					:= '';					-- Parametro mensaje de error
	SET Act_Enviada					:= 1;					-- Actualizacion enviada
	SET Act_Autorizada				:= 2;					-- Actualizacion autorizada
	SET Act_Cancelada				:= 3;					-- Actualizacion cancelada
	SET Act_NotiBan					:= 4;					-- Actualizacion notificacion
	SET Act_FechaEnv				:= 5;					-- Actualizacion fecha de envio
	SET Act_Devuelta				:= 6;					-- Actualizacion estatus devuelta
	SET Act_SaldoTeso				:= 7;					-- actulaiza el estatus de pendiente a autorizado
	SET Act_EstatusCancelado		:= 8;					-- actulaiza el estatus de pendiente a cancelado
	SET Act_Ver						:= 9;					-- Cambia estatus a verificado
	SET Act_CancelCone				:= 10;					-- Cambia estatus y estatus env a cancelada
	SET Act_EstatusDesemPen			:= 11;					-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
	SET Estatus_Pen					:= 'P';					-- Estatus pendiente
	SET Estatus_Env					:= 'E';					-- Estatus enviada
	SET Estatus_Aut					:= 'A';					-- Estatus autorizada
	SET Estatus_Can					:= 'C';					-- Estatus cancelada
	SET Estatus_Dev					:= 'D';					-- Estatus devuelta
	SET Estatus_Ver					:= 'V';					-- Estatus verificado
	SET EstatusEnv_Can				:= 6;					-- Estatus cancelado de conecta
    SET Estatus_Dispersado          := 'P';                 -- Estatus Dispersado via spei
ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSACT');
			SET Var_Control = 'sqlException' ;
		END;

		IF(IFNULL(Par_Folio,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El numero de folio esta Vacio.';
			SET Var_Control:= 'folio' ;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET Var_Estatus := (SELECT Estatus FROM SPEIENVIOS WHERE FolioSpeiID = Par_Folio);

		-- Actualizacion de envios
		IF(Par_NumAct = Act_Enviada)THEN
			IF(Var_Estatus = Estatus_Env and Par_CausaDevol = Entero_Cero)THEN

				SET Var_Credito:=(SELECT CreditoID FROM SPEIENVIOSDESEMBOLSO WHERE FolioSPEI=Par_Folio LIMIT 1);
				SET Var_Credito:=(IFNULL(Var_Credito,Entero_Cero));
				SET Var_Aportaciones := (SELECT FolioSpeiID FROM SPEIAPORTACIONES WHERE FolioSpeiID = Par_Folio LIMIT 1);
				SET Var_Aportaciones := IFNULL(Var_Aportaciones, Entero_Cero);

				IF Var_Credito != Entero_Cero THEN
					SET Var_SolCreditoID:=(SELECT SolicitudCreditoID FROM CREDITOS where CreditoID=Var_Credito);
					SET Var_SolCreditoID:=(IFNULL(Var_SolCreditoID,Entero_Cero));

					# Actualizar estatus dispersado por SPEI
					CALL ESTATUSSOLCREDITOSALT(
					Var_SolCreditoID,          Var_Credito,          Estatus_Dispersado ,       Cadena_Vacia,             Cadena_Vacia,
					SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
					Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);
				  ELSEIF(Var_Aportaciones != Entero_Cero) THEN
					/*LLAMADA A LA ACTUALIZACION DE APORTACIONES*/
					CALL SPEIAPORTACIONESACT(
						Par_ClaveRastreo,			Par_Folio,			1,
						SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
						Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

				END IF;

				UPDATE SPEIENVIOS SET
					EstatusEnv		= Par_EstatusEnv,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE FolioSpeiID	= Par_Folio;


				SET Par_NumErr	:= 0;
				SET Par_ErrMen	:= concat('SPEI Enviado Exitosamente');
				SET Var_Control	:= 'folio';
			ELSE
				IF(Var_Estatus = Estatus_Env and Par_CausaDevol != Entero_Cero)THEN
					UPDATE SPEIENVIOS SET
						Estatus		= Estatus_Dev,
						EstatusEnv	= Par_EstatusEnv,

						EmpresaID	= Par_EmpresaID,
						Usuario		= Aud_Usuario,
						FechaActual	= Aud_FechaActual,
						DireccionIP	= Aud_DireccionIP,
						ProgramaID	= Aud_ProgramaID,
						Sucursal	= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE FolioSpeiID	= Par_Folio;
				END IF;

				SET Par_NumErr 	:= 000;
				SET Par_ErrMen	:= concat('SPEI Actualizado Exitosamente');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion de autorizacion
		IF(Par_NumAct = Act_Autorizada)THEN
			IF(Var_Estatus = Estatus_Pen)THEN
				UPDATE SPEIENVIOS SET
					Estatus				= Estatus_Aut,
					FechaAutorizacion	= CURRENT_TIMESTAMP(),
					Comentario			= Par_Comentario,
					UsuarioAutoriza		= Par_UsuarioAutoriza,

					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE FolioSpeiID		= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= concat('SPEI Autorizado Exitosamente');
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr 	:= 003;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' Tiene estatus diferente de Pendiente');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion de cancelacion
		IF(Par_NumAct = Act_Cancelada)THEN
		-- No se puede cancelar si ya esta enviada
			IF(Var_Estatus != Estatus_Env)THEN

				SET Var_Aportaciones := (SELECT FolioSpeiID FROM SPEIAPORTACIONES WHERE FolioSpeiID = Par_Folio LIMIT 1);
				SET Var_Aportaciones := IFNULL(Var_Aportaciones, Entero_Cero);
				IF(Var_Aportaciones != Entero_Cero) THEN
					/*LLAMADA A LA ACTUALIZACION DE APORTACIONES*/
					CALL SPEIAPORTACIONESACT(
						Par_ClaveRastreo,			Par_Folio,			2,
						SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
						Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

				END IF;

				UPDATE SPEIENVIOS SET
					Estatus			= Estatus_Can,
					FechaCan		= CURRENT_TIMESTAMP(),
					Comentario		= Par_Comentario,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE FolioSpeiID	= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= concat('SPEI Cancelado Exitosamente');
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr 	:= 004;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' No puede ser cancelado, Ya ha sido enviado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion de notificacion
		IF(Par_NumAct = Act_NotiBan)THEN
			UPDATE SPEIENVIOS SET
				EstatusEnv		= Par_EstatusEnv,
				CausaDevol		= Par_CausaDevol,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE FolioSpeiID	= Par_Folio;

			SET Par_NumErr 	:= 0;
			SET Par_ErrMen	:= concat('SPEI Notificado Exitosamente');
			SET Var_Control	:= 'folio';
		END IF;

		-- Actualizacion fecha de envio
		IF(Par_NumAct = Act_FechaEnv)THEN
			IF(Var_Estatus = Estatus_Ver)THEN
				UPDATE SPEIENVIOS SET
					Estatus			= Estatus_Env,
					FechaEnvio		= CURRENT_TIMESTAMP(),

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE FolioSpeiID	= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= concat('SPEI Actualizado Exitosamente');
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr 	:= 005;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' Tiene estatus diferente de Verificado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion de estatus de pendiente a autorizado
		IF(Par_NumAct = Act_SaldoTeso)THEN
			IF(Var_Estatus = Estatus_Pen)THEN
				SET Var_AutTes := (SELECT SpeiVenAutTes FROM PARAMETROSSPEI);

				IF (Var_AutTes = SalidaSI) THEN
					UPDATE SPEIENVIOS SET
						Estatus				= Estatus_Aut,
						FechaAutorizacion	= CURRENT_TIMESTAMP(),
						Comentario			= Par_Comentario,
						UsuarioAutoriza		= Par_UsuarioAutoriza,
						Comentario			= Par_Comentario,
						EmpresaID			= Par_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE	FolioSpeiID	= Par_Folio;
				ELSE
					UPDATE SPEIENVIOS SET
						Estatus				= Estatus_Ver,
						FechaAutorizacion	= CURRENT_TIMESTAMP(),
						Comentario			= Par_Comentario,
						UsuarioAutoriza		= Par_UsuarioAutoriza,
						UsuarioVerifica		= Par_UsuarioVerifica,
						FechaVerifica		= Aud_FechaActual,
						Comentario			= Par_Comentario,
						EmpresaID			= Par_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE FolioSpeiID = Par_Folio;
				END IF;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= concat('SPEI Autorizado Exitosamente');
				SET Var_Control	:= 'claveRastreo';
			ELSE
				SET Par_NumErr 	:= 007;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' Tiene estatus diferente de pendiente');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		IF(Par_NumAct = Act_EstatusCancelado)THEN
			IF(Var_Estatus != Estatus_Env)THEN
					UPDATE SPEIENVIOS SET
					Estatus			= Estatus_Can,
					Comentario		= Par_Comentario,
					FechaCan		= Aud_FechaActual,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE FolioSpeiID	= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= concat('SPEI Cancelado Exitosamente');
				SET Var_Control	:= 'claveRastreo';
			ELSE
				SET Par_NumErr 	:= 008;
				SET Par_ErrMen	:= concat('SPEI ',Par_ClaveRastreo,' No puede ser cancelado, Ya ha sido enviado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion cambio de estatus verificado
		IF(Par_NumAct = Act_Ver)THEN
			IF(Var_Estatus = Estatus_Aut)THEN
				UPDATE SPEIENVIOS SET
					Estatus				= Estatus_Ver,
					UsuarioVerifica		= Par_UsuarioVerifica,
					FechaVerifica		= Aud_FechaActual,

					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
					WHERE FolioSpeiID	= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= 'SPEI Verificado Exitosamente';
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr 	:= 009;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' No puede ser verificado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion cambio de estatus y estatus de envio a cancelado
		IF(Par_NumAct = Act_CancelCone)THEN
			IF(Var_Estatus = Estatus_Env)THEN
					UPDATE SPEIENVIOS SET
					Estatus			= Estatus_Can,
					EstatusEnv		= EstatusEnv_Can,
					FechaCan		= Aud_FechaActual,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE FolioSpeiID	= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= 'SPEI Cancelado Exitosamente';
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr 	:= 010;
				SET Par_ErrMen	:= concat('SPEI ',Par_Folio,' No puede ser cancelado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

		-- Actualizacion de Estatus SPEI por Desembolso
		IF(Par_NumAct = Act_EstatusDesemPen) THEN
			SET Var_FolioSpeiDesembolso := (SELECT FolioSpei FROM SPEIENVIOSDESEMBOLSO WHERE FolioSpei = Par_Folio);
			SET Var_FolioSpeiDesembolso := IFNULL(Var_FolioSpeiDesembolso, Entero_Cero);

			IF(Var_FolioSpeiDesembolso > Entero_Cero) THEN
				SET Var_MontoTransferir	:= (SELECT FNDECRYPTSAFI(MontoTransferir) FROM SPEIENVIOS WHERE FolioSpeiID = Par_Folio);
				SET Var_MontoTransferir	:= IFNULL(Var_MontoTransferir, Decimal_Cero);
				SET Var_MonReqAutDesem	:= (SELECT MonReqAutDesem FROM PARAMETROSSPEI);
				SET Var_MonReqAutDesem	:= IFNULL(Var_MonReqAutDesem, Decimal_Cero);

				IF(Var_MontoTransferir >= Var_MonReqAutDesem) THEN
					SET Var_EstatusFinal	:= Estatus_Pen;
					SET Var_FechaAuto		:= Fecha_Vacia;
				ELSE
					SET Var_EstatusFinal	:= Estatus_Ver;
					SET Var_FechaAuto		:= CURRENT_TIMESTAMP();
				END IF;

				UPDATE SPEIENVIOS SET
					Estatus				= Var_EstatusFinal,
					FechaAutorizacion	= Var_FechaAuto,

					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE FolioSpeiID		= Par_Folio;

				SET Par_NumErr 	:= 0;
				SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
				SET Var_Control	:= 'folio';
			ELSE
				SET Par_NumErr	:= 11;
				SET Par_ErrMen	:= CONCAT('El SPEI ', Par_Folio, ' No fue Realizado por Desembolso');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Entero_Cero as consecutivo;
	END IF;

	-- Fin de SP
END TerminaStore$$
