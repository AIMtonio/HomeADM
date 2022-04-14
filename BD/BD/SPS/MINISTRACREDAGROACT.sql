-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREDAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREDAGROACT`;

DELIMITER $$
CREATE PROCEDURE `MINISTRACREDAGROACT`(
	/* SP PARA ACTUALIZAR EL CALENDARIO DE MINISTRACIONES DE UN CREDITO */
	Par_TransaccionID			BIGINT(11), 			# Numero de Transaccion con la que se registra
	Par_Numero					INT(11), 				# Número Consecutivo de la Ministración.
	Par_SolicitudCreditoID		BIGINT(11), 			# Numero de Solicitud de Crédito
	Par_CreditoID				BIGINT(11), 			# Numero de Credito
	Par_ClienteID				INT(11), 				# Numero de Cliente

	Par_ProspectoID				INT(11), 				# Numero de Prospecto
	Par_FechaPagoMinis			DATE, 					# Fecha de Pago de la Ministracion
	Par_Capital					DECIMAL(18,2), 			# Monto de Capital de la ministracion
	Par_FechaMinistracion		DATE, 					# Fecha Real en la que se realiza la ministración.
	Par_Estatus					CHAR(1), 				# Estatus de la Ministración: I.- Inactivo P.- Pendiente C.- Cancelada D.- Desembolsada

	Par_UsuarioAutoriza			INT(11), 				# ID del Usuario que realiza la autorización dependiendo del Estatus de la Operación.
	Par_FechaAutoriza			DATE, 					# Fecha en la que se realiza la autorización dependiendo del Estatus de la Operación.
	Par_ComentariosAutoriza		VARCHAR(500), 			# Comentarios que hace el usuario que autoriza, depende del Estatus de la Operación.
	Par_ForPagComGarantia		CHAR(1),				-- Forma de pago Comision por Garantia \n"".- No aplica \nA.- Anticipada \nD.- Deducida \nV.- Al Vencimiento
	Par_NumAct					TINYINT UNSIGNED,		# Numero de Actualizacion

	Par_Salida					CHAR(1),				# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr			INT(11),				# Numero de Error
	INOUT	Par_ErrMen			VARCHAR(400),			# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					# Fecha Actual del Sistema
	DECLARE Var_FechaPrimeraMinis	DATE;					# Fecha de la primera ministraciones
	DECLARE Var_Estatus				CHAR(1);				# Estatus de la ministracion
	DECLARE Var_EsConsolidacionAgro	CHAR(1);			-- Es Credito Consolidado Agro
	DECLARE Var_LineaCreditoID		BIGINT(20);			-- Linea de Credito Agro
	DECLARE Var_EsAgropecuario 		CHAR(1);			-- Es Credito Agro
	DECLARE Var_ManejaComGarantia	CHAR(1);			-- Maneja Comision por Garantia

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE	Entero_Uno				INT;					# Entero Uno
	DECLARE	Decimal_Cero			DECIMAL;				# Decimal Cero
	DECLARE	Act_Desembolso			INT;					# Actualización para desembolso de una ministración
	DECLARE	Act_Cancelacion			INT;					# Actualización para la cancelación de una ministración
	DECLARE	Act_Credito				INT;					# Actualización el Numero de Credito de la Ministración
	DECLARE	SalidaNo				CHAR(1);				# Constante SI
	DECLARE	SalidaSi				CHAR(1);				# Constante NO
	DECLARE	EstatusInactivo			CHAR(1);				# Estatus Inactivo
	DECLARE	EstatusDesembolsado		CHAR(1);				# Estatus Desembolsado
	DECLARE	EstatusCancelado		CHAR(1);				# Estatus Cancelado
	DECLARE	EstatusPendiente		CHAR(1);				# Estatus Pendiente
	DECLARE	Con_NO					CHAR(1);				-- Constante NO
	DECLARE	Con_SI					CHAR(1);				-- Constante SI
	DECLARE Con_PagComAnticipada	CHAR(1);				-- Fomar de Cobro Anticipada (A)
	DECLARE Con_PagComDeducida		CHAR(1);				-- Fomar de Cobro Deducida (D)
	DECLARE Con_PagComVencimiento	CHAR(1);				-- Fomar de Cobro Al Vencimiento (V)

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	Entero_Uno					:= 1;
	SET	Act_Desembolso				:= 1;
	SET	Act_Cancelacion				:= 2;
	SET Act_Credito					:= 3;
	SET	SalidaNo					:= 'N';
	SET	SalidaSi					:= 'S';
	SET	EstatusInactivo				:= 'I';
	SET	EstatusDesembolsado			:= 'D';
	SET	EstatusCancelado			:= 'C';
	SET	EstatusPendiente			:= 'P';
	SET Con_NO						:= 'N';
	SET Con_SI						:= 'S';
	SET Var_FechaSistema 			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Con_PagComAnticipada		:= 'A';
	SET Con_PagComDeducida			:= 'D';
	SET Con_PagComVencimiento		:= 'V';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREDAGROACT');
			SET Var_Control := 'sqlException';
		END;

		SET Aud_FechaActual := NOW();

		SELECT EsConsolidacionAgro,		LineaCreditoID,		ManejaComGarantia
		INTO Var_EsConsolidacionAgro,	Var_LineaCreditoID,	Var_ManejaComGarantia
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_EsConsolidacionAgro	:= IFNULL(Var_EsConsolidacionAgro, Con_NO);
		SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);
		SET Var_ManejaComGarantia	:= IFNULL(Var_ManejaComGarantia, Con_NO);

		IF(IFNULL(Par_NumAct,Entero_Cero)=Act_Desembolso)THEN

			IF(IFNULL(Par_CreditoID, Entero_Cero)= Entero_Cero)THEN
				SET Par_NumErr	:= 01;
				SET Par_ErrMen	:=CONCAT('El Numero de Credito se encuentra vacio.');
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Numero, Entero_Cero)= Entero_Cero)THEN
				SET Par_NumErr	:= 02;
				SET Par_ErrMen	:=CONCAT('El Numero de la Ministracion se encuentra vacio.');
				LEAVE ManejoErrores;
			END IF;

			SET Var_Estatus := (SELECT Estatus FROM MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID AND Numero = Par_Numero);
			IF(IFNULL(Var_Estatus, Cadena_Vacia) NOT IN (EstatusInactivo, EstatusPendiente))THEN
				SET Par_NumErr	:= 03;
				SET Par_ErrMen	:=CONCAT('La Ministracion No se Encuentra Inactiva o Pendiente.');
				LEAVE ManejoErrores;
			END IF;

			SET Par_UsuarioAutoriza := IFNULL(Par_UsuarioAutoriza, Aud_Usuario);
			SET Par_UsuarioAutoriza := IFNULL(Par_UsuarioAutoriza, Entero_Cero);
			SET Par_ForPagComGarantia := IFNULL(Par_ForPagComGarantia, Cadena_Vacia);

			IF( Var_LineaCreditoID <> Entero_Cero AND Par_Numero > Entero_Uno ) THEN

				SELECT EsAgropecuario
				INTO 	Var_EsAgropecuario
				FROM LINEASCREDITO
				WHERE LineaCreditoID = Var_LineaCreditoID;

				SET Var_EsAgropecuario := IFNULL(Var_EsAgropecuario, Con_NO);

				IF( Var_EsAgropecuario = Con_SI AND Var_ManejaComGarantia = Con_SI ) THEN

					IF( Par_ForPagComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 05;
						SET Par_ErrMen	:= CONCAT('La Forma de Pago de Comision por Garantia para la Ministracion', Par_Numero, ' se Encuentra Vacia.');
						LEAVE ManejoErrores;
					END IF;

					IF( Par_ForPagComGarantia NOT IN (Con_PagComAnticipada, Con_PagComDeducida, Con_PagComVencimiento)) THEN
						SET Par_NumErr	:= 05;
						SET Par_ErrMen	:= CONCAT('La Forma de Pago de Comision por Garantia para la Ministracion', Par_Numero, ' No es Valida.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			UPDATE MINISTRACREDAGRO SET
				Estatus				= EstatusDesembolsado,
				FechaMinistracion	= Var_FechaSistema,
				UsuarioAutoriza		= Par_UsuarioAutoriza,
				FechaAutoriza		= Var_FechaSistema,
				ComentariosAutoriza = Par_ComentariosAutoriza,

				ForPagComGarantia	= Par_ForPagComGarantia,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID
			  AND Numero = Par_Numero;

			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:=CONCAT('Ministracion Desembolsada Exitosamente.');
			LEAVE ManejoErrores;

		END IF;

		IF(IFNULL(Par_NumAct,Entero_Cero)=Act_Cancelacion)THEN

			IF(IFNULL(Par_CreditoID, Entero_Cero)= Entero_Cero)THEN
				SET Par_NumErr	:= 01;
				SET Par_ErrMen	:=CONCAT('El Numero de Credito se encuentra vacio.');
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Numero, Entero_Cero)= Entero_Cero)THEN
				SET Par_NumErr	:= 02;
				SET Par_ErrMen	:=CONCAT('El Numero de la Ministracion se encuentra vacio.');
				SET Var_Control := 'desembolsar';
				LEAVE ManejoErrores;
			END IF;

			SET Var_Estatus := (SELECT Estatus FROM MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID AND Numero = Par_Numero);
			IF(IFNULL(Var_Estatus, Cadena_Vacia) NOT IN (EstatusInactivo, EstatusPendiente))THEN
				SET Par_NumErr	:= 03;
				SET Par_ErrMen	:=CONCAT('La Ministracion No se Encuentra Inactiva o Pendiente.');
				SET Var_Control := 'desembolsar';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_UsuarioAutoriza, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 04;
				SET Par_ErrMen	:= CONCAT('EL Usuario de Autorizacion se encuentra vacio.');
				SET Var_Control := 'usuarioAutoriza';
				LEAVE ManejoErrores;
			END IF;

			UPDATE MINISTRACREDAGRO SET
				Estatus 			= EstatusCancelado,
				FechaMinistracion 	= Var_FechaSistema,
				UsuarioAutoriza 	= Par_UsuarioAutoriza,
				FechaAutoriza 		= Var_FechaSistema,
				ComentariosAutoriza = Par_ComentariosAutoriza,

				EmpresaID 			= Aud_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,

				ProgramaID 			= Aud_ProgramaID,
				Sucursal 			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE CreditoID 		= Par_CreditoID
				AND Numero 			= Par_Numero;

			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:=CONCAT('Ministracion Cancelada Exitosamente.');
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;

		END IF;

		IF(Par_NumAct = Act_Credito) THEN

			IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 01;
				SET Par_ErrMen	:=CONCAT('El Numero de Solicitud esta Vacio.');
				SET Var_Control := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero)THEN
				SET Par_NumErr	:= 02;
				SET Par_ErrMen	:= CONCAT('El Numero de Credito esta Vacio.');
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE MINISTRACREDAGRO SET
					CreditoID 					= Par_CreditoID,

					EmpresaID 					= Aud_EmpresaID,
					Usuario 					= Aud_Usuario,
					FechaActual 				= Aud_FechaActual,
					DireccionIP 				= Aud_DireccionIP,

					ProgramaID 					= Aud_ProgramaID,
					Sucursal 					= Aud_Sucursal,
					NumTransaccion 				= Aud_NumTransaccion
				WHERE SolicitudCreditoID 		= Par_SolicitudCreditoID;

			SET Var_FechaPrimeraMinis := (SELECT FechaPagoMinis FROM MINISTRACREDAGRO
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID AND Numero = Entero_Uno);
			/*SI LA FECHA DE LA PRIMERA MINISTRACION ES DIFERENTE A LA FECHA DEL SISTEMA SE ACTUALIZA*/
			-- Cuando no es una Consolidacion Agro
			IF( Var_EsConsolidacionAgro = Con_NO ) THEN
				IF(Var_FechaPrimeraMinis != Var_FechaSistema) THEN
					UPDATE MINISTRACREDAGRO SET
						FechaPagoMinis 			= Var_FechaSistema
					WHERE SolicitudCreditoID 	= Par_SolicitudCreditoID
					  AND Numero = Entero_Uno;
				END IF;
			END IF;

			SET Par_NumErr	:= 0;
			SET Par_ErrMen	:=CONCAT('Ministracione(s) Actualizada(s) Exitosamente.');
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CreditoID AS Consecutivo,
				Var_Control AS Control;
	END IF;

END TerminaStore$$