-- SP CAMBIOESTATUSCONVPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CAMBIOESTATUSCONVPRO;

DELIMITER $$

CREATE PROCEDURE `CAMBIOESTATUSCONVPRO`(
-- SP PARA EL CAMBIO DE ESTATUS AUTOMATICO DE CONVENIOS DE EMPRESAS NOMINA
	Par_Salida							CHAR(1),									-- Salida Si o No
	INOUT Par_NumErr					INT(11),									-- Parametro de salida numero de error
	INOUT Par_ErrMen					VARCHAR(400),								-- Parametro de salida mensaje de error

	Aud_EmpresaID						INT(11),									-- Parametro de Auditoria
	Aud_Usuario							INT(11),									-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,									-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),								-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),								-- Parametro de Auditoria
	Aud_Sucursal						INT(11),									-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)									-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);									-- Constante para Cadena Vacia
	DECLARE Decimal_Cero				DECIMAL(12,2);								-- Constante para Decimal Cero
	DECLARE Fecha_Vacia					DATE;										-- Constante para Fecha Vacia
	DECLARE Entero_Cero					INT(1);										-- Constante entero cero
	DECLARE Entero_Uno					INT(1);										-- Constante entero uno
	DECLARE SalidaSI					CHAR(1);									-- Salida si
	DECLARE SalidaNO					CHAR(1);									-- Salida no
	DECLARE Est_Act						CHAR(1);									-- Constante de Estatus Activo de Convenio de Nomina
	DECLARE Est_Inac					CHAR(1);									-- Constante de Estatus Inactivo de Convenio de Nomina
	DECLARE Est_Venc					CHAR(1);									-- Constante de Estatus Vencido de Convenio de Nomina
	DECLARE Est_Susp					CHAR(1);									-- Constante de Estatus Suspendido de Convenio de Nomina
	DECLARE Var_ActAct					INT(1);										-- Constante del numero de actualizacion a estatus activo
	DECLARE Var_ActVenc					INT(1);										-- Constante del numero de actualizacion a estatus vencido
	DECLARE Var_MotivoEstAct			VARCHAR(33);								-- Constante Motivo de Estatus en Activacion Automatica
	DECLARE Var_MotivoEstVenc			VARCHAR(29);								-- Constante Motivo de Estatus en Vencimiento Automatico

	-- Declaracion de Variables
	DECLARE Var_ContWhile				INT(11);									-- Variable contador para el ciclo WHILE
	DECLARE Var_MaxConv					INT(11);									-- Variable para guardar la cantidad total de Convenios
	DECLARE Var_Control					VARCHAR(50);								-- Variable de control



	DECLARE Var_ConvenioNominaID		BIGINT UNSIGNED;							-- Valor para el campo ConvenioNominaID	de CONVENIOSNOMINA
	DECLARE Var_InstitNominaID			INT(11);									-- Valor para el campo InstitNominaID de CONVENIOSNOMINA
	DECLARE Var_Descripcion 			VARCHAR(150);								-- Valor para el campo Descripcion de CONVENIOSNOMINA
	DECLARE Var_FechaRegistro			DATE;										-- Valor para el campo FechaRegistro de CONVENIOSNOMINA
	DECLARE Var_ManejaVencimiento		CHAR(1); 									-- Valor para el campo ManejaVencimiento de CONVENIOSNOMINA

	DECLARE Var_FechaVencimiento		DATE;										-- Valor para el campo FechaVencimiento	de CONVENIOSNOMINA
	DECLARE Var_DomiciliacionPagos		CHAR(1);									-- Valor para el campo DomiciliacionPagos de CONVENIOSNOMINA
	DECLARE Var_ClaveConvenio			VARCHAR(20);								-- Valor para el campo ClaveConvenio de CONVENIOSNOMINA
	DECLARE Var_Estatus					CHAR(1);									-- Valor para el campo Estatus de CONVENIOSNOMINA
	DECLARE Var_Resguardo				DECIMAL(12,2);								-- Valor para el campo Resguardo de CONVENIOSNOMINA

	DECLARE Var_RequiereFolio			CHAR(1);									-- Valor para el campo RequiereFolio de CONVENIOSNOMINA
	DECLARE Var_ManejaQuinquenios		CHAR(1);									-- Valor para el campo ManejaQuinquenios de CONVENIOSNOMINA
	DECLARE Var_NumActualizaciones		INT(11);									-- Valor para el campo NumActualizaciones de CONVENIOSNOMINA
	DECLARE Var_UsuarioID				INT(11);									-- Valor para el campo UsuarioID de CONVENIOSNOMINA
	DECLARE Var_CorreoEjecutivo			TEXT;										-- Valor para el campo CorreoEjecutivo	de CONVENIOSNOMINA

	DECLARE Var_Comentario 				TEXT(150);									-- Valor para el campo Comentario de CONVENIOSNOMINA
	DECLARE Var_ManejaCapPago			CHAR(1);									-- Valor para el campo ManejaCapPago de CONVENIOSNOMINA
	DECLARE Var_FormCapPago 			TEXT;										-- Valor para el campo FormCapPago de CONVENIOSNOMINA
	DECLARE Var_FormCapPagoRes			TEXT;										-- Valor para el campo FormCapPagoRes de CONVENIOSNOMINA
	DECLARE Var_ManejaCalendario  		CHAR(1);									-- Valor para el campo ManejaCalendario	de CONVENIOSNOMINA

	DECLARE Var_ReportaIncidencia		CHAR(1);									-- Valor para el campo ReportaIncidencias de CONVENIOSNOMINA.
	DECLARE Var_ManejaFechaIniCal		CHAR(1);									-- Valor para el campo ManejaFechaIniCal de CONVENIOSNOMINA
	DECLARE Var_CobraComisionApert		CHAR(1);									-- Valor para el campo CobraComisionApert
	DECLARE Var_CobraMora				CHAR(1);									-- Valor para el campo CobraMora
	DECLARE Var_NoCuotasCobrar			INT(11);									-- Valor para el campo NoCuotasCobrar de CONVENIOSNOMINA

	DECLARE Var_FechaSistema			DATETIME;									-- Valor para el campo FechaSistema de PARAMETROSSIS
	DECLARE Var_DiaSigHabil				DATE;										-- Variable para almacenar la fecha del sia habil siguiente
	DECLARE Var_EsHabil					CHAR(1);									-- Variable para enviar a la comprobacion de dia habil

    -- VARIABLES DE ENVIO DE CORREO
    DECLARE Var_RemitenteID				INT(11);									-- Remitente de envio de correo de convenios de nomina
	DECLARE Var_Asunto					VARCHAR(100);								-- Asunto de envio de correo de convenios de nomina
	DECLARE Var_Mensaje					VARCHAR(5000);								-- Mensaje de envio de correo de convenios de nomina
	DECLARE Var_GrupoEmailID			INT(11);									-- Grupo de envio de correo
	DECLARE Var_FechaProgramada			DATETIME;									-- Fecha Programada de la tarea de envio de correo
	DECLARE Var_FechaVenProg	 		DATETIME;									-- Fecha de vencimiento de la tarea de envio de correo
	DECLARE Var_Proceso					VARCHAR(50);								-- Proceso que guarda en la tarea de envio de correo
    DECLARE Var_CorreoRemitente			VARCHAR(50);								-- Correo del remitente de envio de correo
    DECLARE Var_AlerVerificaConvenio	CHAR(2);									-- Verifica convenios
	DECLARE Var_NoDiasAntEnvioCorreo	INT(11);									-- Numero de dias de verificacion de convenios
	DECLARE Var_CorreoAdiDestino		VARCHAR(500);								-- Correos de los destinatarios de envio de notificacion
	DECLARE Var_DiasDif					INT(11);									-- Dias de diferencia
	DECLARE Var_NombreInsNomina			VARCHAR(100);								-- Nombre de la institucion de nomina que le pertenece el convenio
    DECLARE Var_NumConveniosVen			INT(11);									-- Contador de convenios proximos a vencer
    DECLARE Var_Referencia				VARCHAR(20);								-- Referencia viculada al convenio

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';										-- Cadena Vacia
	SET Decimal_Cero					:= 0.0;  									-- Decimal Cero
	SET Fecha_Vacia 					:= '1900-01-01';							-- Fecha Vacia
	SET Entero_Cero 					:= 0;										-- Entero Cero
	SET Entero_Uno						:= 1;										-- Entero Uno
	SET SalidaSI						:= 'S';										-- Asignacion de salida si
	SET SalidaNO						:= 'N';										-- Asignacion de salida no
	SET Est_Act							:= 'A';										-- Asignacion constante de Estatus Cancelada de Convenio de Nomina
	SET Est_Inac						:= 'I';										-- Asignacion constante de Estatus Inactivo de Convenio de Nomina
	SET Est_Venc						:= 'V';										-- Asignacion constante de Estatus Vencido de Convenio de Nomina
	SET Est_Susp						:= 'S';										-- Asignacion constante de Estatus Suspendido de Convenio de Nomina
	SET Var_ActAct						:= 1;										-- Asignacion de constante del numero de actualizacion a estatus activo
	SET Var_ActVenc						:= 2;										-- Asignacion de constante del numero de actualizacion a estatus vencido
	SET Var_Proceso						:= 'CAMBIOESTATUSCONVPRO';					-- Proceso que guarda en la tarea de envio de correo
    SET Var_Asunto						:= 'Convenios proximos a vencer.';
    SET Var_Mensaje						:= '<!DOCTYPE html><html><head><style>table {font-family: arial, sans-serif;border-collapse: collapse;width: 100%;}th{border: 1px solid #dddddd;text-align: left;padding: 8px;background-color: #4297d7;color:#fff;}td{
											border: 1px solid #dddddd;text-align: left;padding: 8px;}tr:nth-child(even) {background-color: #dddddd;}</style></head><body><h4>Estimado Usuario:<br> Se le informa que los pr&oacute;ximos convenios est&aacute;n por vencer,
											por lo que se sugiere realizar la gesti&oacute;n requerida para la renovaci&oacute;n de los mismos.</h4><table><tr><th>Instituci&oacute;n N&oacute;mina</th><th>Convenio</th><th>Fecha Vencimiento</th></tr>';
    SET Var_GrupoEmailID				:= 0;
    SET Var_NumConveniosVen				:= 0;
    -- Asignacion de valores por defecto
	SET Aud_EmpresaID					:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-CAMBIOESTATUSCONVPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;
			-- Se obtiene la fecha del sistema
			SELECT		CAST(FechaSistema AS DATE)
				INTO	Var_FechaSistema
				FROM	PARAMETROSSIS;

			-- Se obtiene el dia habil siguiente a la fecha del sistema
			CALL DIASFESTIVOSCAL(
				Var_FechaSistema,		Entero_Uno,			Var_DiaSigHabil,		Var_EsHabil,		Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

            -- VARIABLES DE ENVIO DE CORREO
            SELECT 	 AlerVerificaConvenio, 		NoDiasAntEnvioCorreo, 		CorreoRemitente, 		CorreoAdiDestino
				INTO Var_AlerVerificaConvenio,	Var_NoDiasAntEnvioCorreo,	Var_CorreoRemitente,	Var_CorreoAdiDestino
				FROM PARAMETROSSIS
				WHERE EmpresaID=1;

            SET Var_AlerVerificaConvenio :=IFNULL(Var_AlerVerificaConvenio, SalidaNO);
            SET Var_NoDiasAntEnvioCorreo :=IFNULL(Var_NoDiasAntEnvioCorreo, Entero_Cero);
            SET Var_CorreoRemitente :=IFNULL(Var_CorreoRemitente, Cadena_Vacia);
            SET Var_CorreoAdiDestino :=IFNULL(Var_CorreoAdiDestino, Cadena_Vacia);
			SET Var_FechaProgramada := Var_DiaSigHabil;
			SET Var_FechaVenProg := Var_DiaSigHabil;


            SELECT RemitenteID INTO Var_RemitenteID
				FROM TARENVIOCORREOPARAM
				WHERE CorreoSalida=Var_CorreoRemitente
				LIMIT 1;

            SET Var_RemitenteID :=IFNULL(Var_RemitenteID, Entero_Cero);
            -- FIN VARIABLES DE ENVIO DE CORREO


			-- INICIO VENCIMIENTO AUTOMATICO DE CONVENIOS DE EMPRESAS DE NOMINA
			-- Creacion de tabla temporal para almacenar los convenios de empresas de nomina que van a vencer
			DROP TEMPORARY TABLE IF EXISTS TMPVENCIDAS;

			CREATE TEMPORARY TABLE TMPVENCIDAS (
				TmpVencidasID			INT(11)		AUTO_INCREMENT,
				ConvenioNominaID		BIGINT UNSIGNED,
				InstitNominaID			INT(11),
				Descripcion				VARCHAR(150),
				FechaRegistro			DATE,
				ManejaVencimiento		CHAR(1),
				FechaVencimiento		DATE,
				DomiciliacionPagos		CHAR(1),
				ClaveConvenio 			VARCHAR(20),
				Estatus					CHAR(1),
				Resguardo				DECIMAL(12,2),
				RequiereFolio 			CHAR(1),
				ManejaQuinquenios 		CHAR(1),
				NumActualizaciones 		INT(11),
				UsuarioID				INT(11),
				CorreoEjecutivo     	TEXT,
				Comentario				TINYTEXT,
				ManejaCapPago       	CHAR(1),
				FormCapPago         	TEXT,
				FormCapPagoRes      	TEXT,
				ManejaCalendario    	CHAR(1),
				ReportaIncidencia		CHAR(1),
				ManejaFechaIniCal   	CHAR(1),
				CobraComisionApert		CHAR(1),
				CobraMora				CHAR(1),
				NoCuotasCobrar			INT(11),
                Referencia				VARCHAR(20),
				PRIMARY KEY (TmpVencidasID)
			);

			CREATE INDEX IDX_TMPVENCIDAS_Conv_01 ON TMPVENCIDAS(ConvenioNominaID);

			INSERT INTO TMPVENCIDAS (	ConvenioNominaID,	InstitNominaID, 	Descripcion, 		FechaRegistro, 		ManejaVencimiento,
										FechaVencimiento, 	DomiciliacionPagos, ClaveConvenio, 		Estatus, 			Resguardo,
										RequiereFolio, 		ManejaQuinquenios, 	NumActualizaciones, UsuarioID, 			CorreoEjecutivo,
										Comentario, 		ManejaCapPago, 		FormCapPago, 		FormCapPagoRes, 	ManejaCalendario,
										ReportaIncidencia,	ManejaFechaIniCal,	CobraComisionApert,	CobraMora,			NoCuotasCobrar,
										Referencia)
								SELECT	ConvenioNominaID,	InstitNominaID, 	Descripcion, 		FechaRegistro, 		ManejaVencimiento,
										FechaVencimiento, 	DomiciliacionPagos, ClaveConvenio, 		Estatus, 			Resguardo,
										RequiereFolio, 		ManejaQuinquenios, 	NumActualizaciones, UsuarioID, 			CorreoEjecutivo,
										Comentario, 		ManejaCapPago, 		DesFormCapPago, 	DesFormCapPagoRes, 	ManejaCalendario,
										ReportaIncidencia,	ManejaFechaIniCal,	CobraComisionApert,	CobraMora,			NoCuotasCobrar,
										Referencia
									FROM	CONVENIOSNOMINA
									WHERE	(Estatus = Est_Act OR Estatus = Est_Susp)
									  AND	(ManejaVencimiento = SalidaSI);

			SELECT COUNT(TmpVencidasID)
				INTO Var_MaxConv
				FROM TMPVENCIDAS;

			SET Var_ContWhile := 1;
			VenceConvenios: WHILE Var_ContWhile <= Var_MaxConv DO
				SET Var_DiasDif				:= Entero_Cero;
				SET Var_ConvenioNominaID	:= Entero_Cero;

				SELECT		ConvenioNominaID,		InstitNominaID, 		Descripcion, 			FechaRegistro, 			ManejaVencimiento,
							FechaVencimiento, 		DomiciliacionPagos, 	ClaveConvenio, 			Estatus, 				Resguardo,
							RequiereFolio, 			ManejaQuinquenios, 		NumActualizaciones, 	UsuarioID, 				CorreoEjecutivo,
							Comentario, 			ManejaCapPago, 			FormCapPago, 			FormCapPagoRes, 		ManejaCalendario,
							ReportaIncidencia,		ManejaFechaIniCal,		CobraComisionApert,		CobraMora,				NoCuotasCobrar,
							Referencia
					INTO	Var_ConvenioNominaID,	Var_InstitNominaID,		Var_Descripcion,		Var_FechaRegistro,		Var_ManejaVencimiento,
							Var_FechaVencimiento,	Var_DomiciliacionPagos,	Var_ClaveConvenio,		Var_Estatus	,			Var_Resguardo,
							Var_RequiereFolio,		Var_ManejaQuinquenios,	Var_NumActualizaciones,	Var_UsuarioID,			Var_CorreoEjecutivo,
							Var_Comentario,			Var_ManejaCapPago,		Var_FormCapPago,		Var_FormCapPagoRes,		Var_ManejaCalendario,
							Var_ReportaIncidencia,	Var_ManejaFechaIniCal,	Var_CobraComisionApert,	Var_CobraMora,			Var_NoCuotasCobrar,
							Var_Referencia
						FROM	TMPVENCIDAS
						WHERE	TmpVencidasID	= Var_ContWhile;

				SET Var_Referencia					:= IFNULL(Var_Referencia,Cadena_Vacia);

				IF(Var_FechaVencimiento<=Var_DiaSigHabil)THEN
					-- SE DA DE ALTA EN EL HISTORICO
					SET Var_NumActualizaciones	:= Var_NumActualizaciones + Entero_Uno;
					CALL HISCONVENIOSNOMINAALT (	Var_ConvenioNominaID,		Var_InstitNominaID,			Var_Descripcion,			Var_FechaRegistro,			Var_ManejaVencimiento,
													Var_FechaVencimiento,		Var_DomiciliacionPagos,		Var_Estatus,				Var_ClaveConvenio,			Var_Resguardo,
													Var_RequiereFolio,			Var_ManejaQuinquenios,		Var_NumActualizaciones,		Var_UsuarioID,				Var_CorreoEjecutivo,
													Var_Comentario,				Var_ManejaCapPago,			Var_FormCapPago,			Var_FormCapPagoRes,			Var_ManejaCalendario,
													Var_ReportaIncidencia,		Var_ManejaFechaIniCal,		Var_CobraComisionApert,		Var_CobraMora,				Var_NoCuotasCobrar,
													Var_Referencia,				SalidaNO,					Par_NumErr,					Par_ErrMen,					Aud_EmpresaID,
													Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,
													Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					-- ACTUALIZAMOS EL ESTATUS DEL CONVENIO
					CALL CONVENIOSNOMINAACT (	Var_ConvenioNominaID,	Var_ActVenc,		SalidaNO,			Par_NumErr,			Par_ErrMen,
												Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
												Aud_Sucursal,			Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
                END IF;


                IF(Var_AlerVerificaConvenio = SalidaSI)THEN
					SET Var_DiasDif := TIMESTAMPDIFF(DAY, Var_FechaSistema, Var_FechaVencimiento);
                    IF(Var_NoDiasAntEnvioCorreo > Var_DiasDif AND Var_DiasDif > Entero_Cero AND	Var_CorreoRemitente!= Cadena_Vacia)THEN
						SELECT NombreInstit INTO Var_NombreInsNomina
							FROM INSTITNOMINA
							WHERE InstitNominaID =Var_InstitNominaID;

                        SET Var_Mensaje := CONCAT(Var_Mensaje, '<tr><td>',Var_NombreInsNomina,'</td>');
                        SET Var_Mensaje := CONCAT(Var_Mensaje, '<td>',Var_Descripcion,'</td>');
                        SET Var_Mensaje := CONCAT(Var_Mensaje, '<td>',Var_FechaVencimiento,'</td></tr>');

                        -- Var_Descripcion, '</b> de la institucion <b>', Var_NombreInsNomina,'</b>,');
						SET Var_NumConveniosVen := Var_NumConveniosVen + Entero_Uno;
					END IF;
                END IF;

			SET Var_ContWhile := Var_ContWhile + Entero_Uno;

			END WHILE VenceConvenios;
			-- FIN VENCIMIENTO AUTOMATICO DE CONVENIOS DE EMPRESAS DE NOMINA

            -- ALTA DE TAREA DE ENVIO DE CORREO

            IF(Var_NumConveniosVen > Entero_Cero)THEN
				SET Var_Mensaje := CONCAT(Var_Mensaje, '</table><br><br><h4>Saludos cordiales.</h4></body></html>');
				CALL TARENVIOCORREOALT ( Var_RemitenteID,			Var_CorreoAdiDestino,		Var_Asunto,			Var_Mensaje,		Var_GrupoEmailID,
										 Var_FechaProgramada,		Var_FechaVenProg,			Var_Proceso,		Cadena_Vacia,
										 SalidaNO,					Par_NumErr,					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
										 Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
										);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
            END IF;
			-- ALTA DE TAREA DE ENVIO DE CORREO

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Los Convenios de Empresas de Nomina fueron Actualizados exitosamente.');
			SET Var_Control:= 'convenioNominaID';

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$
