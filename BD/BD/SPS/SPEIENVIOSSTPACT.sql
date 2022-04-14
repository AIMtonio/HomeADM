DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSSTPACT`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSSTPACT`(
	-- STORED PROCEDURE ENCARGADO DE REALIZAR LA ACTUALIZACION DE LA TABLA SPEIENVIOS VALIDANDO SI ES ACTUALIZACION POR STP
	Par_Folio						BIGINT(20),				-- Folio de la orden de pago registrada en el SAFI referente a la Tabla SPEIENVIOS
	Par_ClaveRastreo				VARCHAR(30),			-- Clave de rastreo generada para la orden de pago
	Par_EstatusEnv					INT(3),					-- Estatus de Envio segun la tabla ESTADOSENVIOSPEI
	Par_FolioSTP					INT(11),				-- Folio que regresa el envio de la orden de pago a los WS de STP
	Par_Firma						VARCHAR(1000),			-- Firma con la cual se envio la Orden de Pago

	Par_PIDTarea					VARCHAR(50),			-- Numero referente a la tarea
	Par_NumIntentos					INT(11),				-- Numero de intentos realizados para enviar la orden de pago
	Par_CausaDevol					INT(2),					-- Causa de devolucion de la orden de pago referente a la Tabla de CAUSASDEVSPEI
	Par_Comentario					VARCHAR(500),			-- Comentario de la causa de la devolucion
	Par_UsuarioEnvio				VARCHAR(30),			-- Usiario que realizo el envio de la orden de pago

	Par_UsuarioAutoriza				INT(11),				-- Usuario que autoriza la orden de pago
	Par_UsuarioVerifica				INT(11),				-- Usuario que realiza la verificacion de la orden de pago

	Par_NumAct						INT(11),				-- Numero de actualziacion

	Par_Salida						CHAR(1),				-- Indica si el SP devuelve una el resultado de la operacion
	INOUT Par_NumErr				INT(11),				-- Numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Mensaje de error

	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),				-- Parametro de Auditoria
	Aud_Usuario						INT(11),				-- Parametro de Auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP					VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal					INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Var_SpeiOriginal		INT(11);				-- Variable que se encarga de evaluar si se ejecutara el el SP SPEIENVIOSACT
	DECLARE Cadena_Vacia			CHAR(1);				-- constante cadena vacia
	DECLARE Entero_Cero				INT(11);				-- Constante entero cero
	DECLARE Decimal_Cero			DECIMAL(14,2);			-- Constante decimal cero
	DECLARE Salida_Si				CHAR(1);				-- Constante salida si
	DECLARE Salida_No				CHAR(1);				-- Constante salida NO
	DECLARE Act_FolioSTP			INT(11);				-- Actualización del FolioSTP
	DECLARE Act_PIDTarea			INT(11);				-- Actualiza el PIDTarea
	DECLARE Act_CancelaEnvioSTP		INT(11);				-- Actualiza a los Estatus definidos despues de que STP realiza la devolucion
	DECLARE Act_Firma				INT(11);				-- Actualiza la Firma de la Orden de Pago
	DECLARE Act_NumIntentos			INT(11);				-- Numero de intentos de envio de la orden pago realizados
	DECLARE Estatus_Pendiente		CHAR(1);				-- Estatus Pendiente
	DECLARE Estatus_Autorizado		CHAR(1);				-- Estatus Autorizado
	DECLARE Estatus_Env				CHAR(1);				-- Estatus Enviada
	DECLARE Estatus_Ver				CHAR(1);				-- Estatus Verificada para Envio
	DECLARE Estatus_Can				CHAR(1);				-- Estatus Cancelado
	DECLARE Estatus_Dev				CHAR(1);				-- Estatus Devuelto
	DECLARE EstatusEnv_OrdError		INT(11);				-- Estatus de STP - Orden Con Errores
	DECLARE OperacionSTP			CHAR(1);				-- Indica que las transferencias seran por STP
	DECLARE Var_ActFirmaRem			INT(11);				-- Actualizacion de firma y estatus de Remesa

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(200);			-- Variable de control
	DECLARE Var_Consecutivo			BIGINT(20);				-- Variable consecutivo
	DECLARE Var_Estatus				CHAR(1);				-- Estatus del envio utilizado en el SAFI
	DECLARE Var_IntentosMaxEnv		INT(11);				-- Numero de intentos maximos para realizar el envio de la orden de pago
	DECLARE Var_Habilitado			CHAR(1);				-- Indica si el SPEI esta habilitado. S =  Si, N = No
	DECLARE Var_TipoOperacion		CHAR(1);				-- Indica el tipo de Salida de la Transferencia. S = STP, B = Banxico

	-- Asignacion de Constantes
	SET Cadena_Vacia				:='';					-- Cadena Vacia
	SET Entero_Cero					:=0;					-- Entero Cero
	SET Decimal_Cero				:=0.00;					-- Decimal Cero
	SET Salida_Si					:='S';					-- Salida SI
	SET Salida_No					:='N';					-- Salida NO
	SET Par_NumErr					:= 0;					-- Parametro numero de error
	SET Par_ErrMen					:= '';					-- Parametro mensaje de error
	SET Act_FolioSTP				:= 500;					-- Agrega el Folio de STP
	SET Act_NumIntentos				:= 501;					-- Actualiza el Numero de Intentos
	SET Act_PIDTarea				:= 502;					-- Actualiza el PIDTarea
	SET Act_CancelaEnvioSTP			:= 503;					-- Actualiza a los Estatus definidos despues de que STP realiza la devolucion
	SET Act_Firma					:= 504;					-- Actualiza la Firma de la Orden de Pago
	SET Estatus_Pendiente			:= 'P';					-- Estatus Pendiente
	SET Estatus_Autorizado			:= 'A';					-- Estatus Autorizado
	SET Estatus_Env					:= 'E';					-- Estatus Enviada
	SET Estatus_Ver					:= 'V';					-- Estatus Verificada para Envio
	SET Estatus_Can					:= 'C';					-- Estatus Cancelado
	SET Estatus_Dev					:= 'D';					-- Estatus Devuelto
	SET EstatusEnv_OrdError			:= 9;					-- Estatus de STP - Orden Con Errores
	SET Var_SpeiOriginal			:= 500;					-- Indicador de que se haran actualizaciones por STP
	SET OperacionSTP				:= 'S';					-- Indica que las transferencias seran por STP
	SET Var_ActFirmaRem				:= 600;					-- Actualizacion de firma y estatus de Remesa

	-- Apartado De Validaciones
	SET Par_Folio					:= IFNULL(Par_Folio, Entero_Cero);
	SET Par_ClaveRastreo			:= IFNULL(Par_ClaveRastreo, Cadena_Vacia);
	SET Par_EstatusEnv				:= IFNULL(Par_EstatusEnv, Entero_Cero);
	SET Par_FolioSTP				:= IFNULL(Par_FolioSTP, Entero_Cero);
	SET Par_CausaDevol				:= IFNULL(Par_CausaDevol, Entero_Cero);
	SET Par_Comentario				:= IFNULL(Par_Comentario, Cadena_Vacia);
	SET Par_UsuarioEnvio			:= IFNULL(Par_UsuarioEnvio, Cadena_Vacia);
	SET Par_UsuarioAutoriza			:= IFNULL(Par_UsuarioAutoriza, Entero_Cero);
	SET Par_UsuarioVerifica			:= IFNULL(Par_UsuarioVerifica, Entero_Cero);

	-- Se obtiene el ESTATUS actual de la orden de pago
	SET Var_Estatus	:= (SELECT Estatus
							FROM SPEIENVIOS
							WHERE FolioSpeiID = Par_Folio);

	SELECT	IntentosMaxEnvio,		Habilitado,			TipoOperacion
	INTO	Var_IntentosMaxEnv,		Var_Habilitado,		Var_TipoOperacion
		FROM PARAMETROSSPEI
		LIMIT 1;

	-- Comienza apartado de errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSSTPACT');
			SET Var_Control	:= 'sqlException';
		END;

		-- Si el Numero de Actualziacion es 500 0 mas se realizan actualizaciones por STP
		IF(Par_NumAct >= Var_SpeiOriginal) THEN
			-- Se actualiza el FolioSTP y la Firma despues de la dispersion del saldo
			IF(Par_NumAct = Act_FolioSTP) THEN
				IF(Var_Estatus = Estatus_Env) THEN
					IF(Par_Folio=Entero_Cero) THEN
						SET Par_NumErr	:= 501;
						SET Par_ErrMen	:= 'El Folio se encuentra vacio';
						SET Var_Control	:= 'Folio';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_FolioSTP = Entero_Cero) THEN
						SET Par_NumErr	:= 502;
						SET Par_ErrMen	:= 'El Folio de STP se encuentra vacio';
						SET Var_Control	:= 'FolioSTP';
						LEAVE ManejoErrores;
					END IF;

					UPDATE SPEIENVIOS SET
						FolioSTP		= Par_FolioSTP,
						Firma			= Par_Firma,

						EmpresaID		= Aud_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE FolioSpeiID = Par_Folio;

					SET Par_NumErr	:= 0;
					SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
					SET Var_Control	:= 'FolioSTP';
				ELSE
					SET Par_NumErr 	:= 503;
					SET Par_ErrMen	:= CONCAT('SPEI ',Par_Folio,' Tiene Estatus diferente de Enviado');
					SET Var_Control	:= 'EstatusEnv';
				END IF;
			END IF;

			-- Se actuliza el numero de intentos y el pidtarea en caso de que falle el envio de la orden de pago a STP
			IF(Par_NumAct = Act_NumIntentos) THEN
				IF(Var_Estatus = Estatus_Ver) THEN
					IF(Par_NumIntentos <= Var_IntentosMaxEnv) THEN
						IF(Par_Folio=Entero_Cero) THEN
							SET Par_NumErr	:= 504;
							SET Par_ErrMen	:= 'El Folio se encuentra vacio';
							SET Var_Control	:= 'Folio';
							LEAVE ManejoErrores;
						END IF;

						IF(Par_NumIntentos <= Entero_Cero) THEN
							SET Par_NumErr	:= 505;
							SET Par_ErrMen	:= 'El Numero de Intentos se encuentra vacio';
							SET Var_Control	:= 'NumIntentos';
							LEAVE ManejoErrores;
						END IF;

						UPDATE SPEIENVIOS SET
							NumIntentos		= Par_NumIntentos,
							PIDTarea		= Cadena_Vacia,

							EmpresaID		= Aud_EmpresaID,
							Usuario			= Aud_Usuario,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
						WHERE FolioSpeiID = Par_Folio;

						SET Par_NumErr	:= 0;
						SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
						SET Var_Control	:= 'FolioSTP';
					END IF;
				ELSE
					SET Par_NumErr 	:= 506;
					SET Par_ErrMen	:= CONCAT('SPEI ',Par_Folio,' tiene Estatus diferente de Verificado');
					SET Var_Control	:= 'Estatus';
				END IF;
			END IF;

			IF(Par_NumAct = Act_PIDTarea) THEN
				IF(Par_PIDTarea = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 507;
					SET Par_ErrMen	:= CONCAT('El PIDTarea se encuentra vacio');
					SET Var_Control	:= 'PIDTarea';
					LEAVE ManejoErrores;
				END IF;

				UPDATE SPEIENVIOS SET
					PIDTarea		= Par_PIDTarea,

					EmpresaID		= Aud_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE Estatus = Estatus_Ver AND PIDTarea = Cadena_Vacia;

				SET Par_NumErr	:= 0;
				SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
				SET Var_Control	:= 'FolioSTP';
			END IF;

			IF(Par_NumAct = Act_CancelaEnvioSTP) THEN
				IF(Var_Estatus = Estatus_Can) THEN
					IF(Par_Folio=Entero_Cero) THEN
						SET Par_NumErr	:= 508;
						SET Par_ErrMen	:= 'El Folio se encuentra vacio';
						SET Var_Control	:= 'Folio';
						LEAVE ManejoErrores;
					END IF;

					UPDATE SPEIENVIOS SET
						Estatus		= Estatus_Dev,
						EstatusEnv	= EstatusEnv_OrdError,
						Comentario	= Par_Comentario,

						EmpresaID	= Aud_EmpresaID,
						Usuario		= Aud_Usuario,
						FechaActual	= Aud_FechaActual,
						DireccionIP	= Aud_DireccionIP,
						ProgramaID	= Aud_ProgramaID,
						Sucursal	= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE FolioSpeiID	= Par_Folio;

					SET Par_NumErr	:= 0;
					SET Par_ErrMen	:= CONCAT('SPEI Cancelado Exitosamente');
					SET Var_Control	:= 'FolioSTP';
				ELSE
					SET Par_NumErr 	:= 509;
					SET Par_ErrMen	:= CONCAT('SPEI ',Par_Folio,' tiene Estatus diferente de Cancelado');
					SET Var_Control	:= 'Estatus';
				END IF;
			END IF;

			-- Actualización de la Firma
			IF(Par_NumAct = Act_Firma) THEN
				IF(Var_Habilitado = Salida_Si AND Var_TipoOperacion = OperacionSTP) THEN
					IF(Var_Estatus = Estatus_Pendiente OR Var_Estatus = Estatus_Autorizado OR Var_Estatus = Estatus_Ver) THEN
						IF(Par_Folio=Entero_Cero) THEN
							SET Par_NumErr	:= 510;
							SET Par_ErrMen	:= 'El Folio se encuentra vacio';
							SET Var_Control	:= 'Folio';
							LEAVE ManejoErrores;
						END IF;

						IF(Par_Firma = Cadena_Vacia) THEN
							SET Par_NumErr	:= 511;
							SET Par_ErrMen	:= 'La Firma se encuentra vacia';
							SET Var_Control	:= 'Firma';
							LEAVE ManejoErrores;
						END IF;

						UPDATE SPEIENVIOS SET
							Firma			= Par_Firma,

							EmpresaID		= Aud_EmpresaID,
							Usuario			= Aud_Usuario,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
						WHERE FolioSpeiID = Par_Folio;

						SET Par_NumErr	:= 0;
						SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
						SET Var_Control	:= 'FolioSTP';
					ELSE
						SET Par_NumErr 	:= 512;
						SET Par_ErrMen	:= CONCAT('SPEI ',Par_Folio,' Tiene Estatus diferente de Pendiente, Autorizado o Verificado');
						SET Var_Control	:= 'EstatusEnv';
					END IF;
				END IF;
			END IF;

			-- Actualización de la Firma
			IF(Par_NumAct = Var_ActFirmaRem) THEN
				IF(Var_Estatus = Estatus_Pendiente OR Var_Estatus = Estatus_Autorizado OR Var_Estatus = Estatus_Ver) THEN
					IF(Par_Folio=Entero_Cero) THEN
						SET Par_NumErr	:= 510;
						SET Par_ErrMen	:= 'El Folio se encuentra vacio';
						SET Var_Control	:= 'Folio';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_Firma = Cadena_Vacia) THEN
						SET Par_NumErr	:= 511;
						SET Par_ErrMen	:= 'La Firma se encuentra vacia';
						SET Var_Control	:= 'Firma';
						LEAVE ManejoErrores;
					END IF;

					UPDATE SPEIENVIOS SET
						Firma			= Par_Firma,
						Estatus			= Estatus_Ver,

						EmpresaID		= Aud_EmpresaID,
						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE FolioSpeiID = Par_Folio;

					SET Par_NumErr	:= 0;
					SET Par_ErrMen	:= CONCAT('SPEI Actualizado Exitosamente');
					SET Var_Control	:= 'FolioSTP';
				ELSE
					SET Par_NumErr 	:= 512;
					SET Par_ErrMen	:= CONCAT('SPEI ',Par_Folio,' Tiene Estatus diferente de Pendiente, Autorizado o Verificado');
					SET Var_Control	:= 'EstatusEnv';
				END IF;
			END IF;
		ELSE
			CALL SPEIENVIOSACT(
				Par_Folio,				Par_ClaveRastreo,			Par_EstatusEnv,				Par_CausaDevol,				Par_Comentario,
				Par_UsuarioEnvio,		Par_UsuarioAutoriza,		Par_UsuarioVerifica,		Par_NumAct,					Salida_No,
				Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_Consecutivo		:= Par_Folio;
		SET Var_Control			:= 'FolioSpeiID';
	END ManejoErrores;

	-- Preguntar si se va a setear S o N de este resultado
	IF(Par_Salida = Salida_Si) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$