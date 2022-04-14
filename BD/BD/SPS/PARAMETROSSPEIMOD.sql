-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEIMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEIMOD`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSSPEIMOD`(
	-- STORE PARA MODIFICAR LOS PARAMETROS SPEI
	Par_EmpresaID					INT(11),			-- ID de empresa
	Par_Clabe						VARCHAR(18),		-- Numero de clabe
	Par_CtaSpei						VARCHAR(20),		-- Numero de cuenta SPEI
	Par_ParticipanteSpei			INT(5),				-- Codigo de participacion en SPEI
	Par_HorarioInicio				TIME,				-- Horario de inicio de operacion SPEI

	Par_HorarioFin					TIME,				-- Horario de fin de operacion SPEI
	Par_HorarioFinVen				TIME,				-- Horario de fin para recepcion de ordenes con fecha del dia actual
	Par_ParticipaPagoMovil			CHAR(1),			-- Si la institucion participa en la recepcion y envio de pagos por movil (S=Si, N=No )
	Par_FrecuenciaEnvio				TIME,				-- Frecuencia de envio automatica
	Par_Topologia					CHAR(1),			-- Topologia

	Par_Prioridad					INT(1),				-- Prioridad de envio
	Par_MonMaxSpeiVen				DECIMAL(18,2),		-- Monto maximo permito de SPEI en Ventanilla
	Par_MonReqAutTeso				DECIMAL(18,2),		-- Monto maximo permito de SPEI por Banca Movil
	Par_MonMaxSpeiBcaMovil			DECIMAL(18,2),
	Par_SpeiVenAutTeso				CHAR(1),

	Par_BloqueoRecepcion			CHAR(1),			-- Parametro para determinar si se bloque el saldo de cuenta
	Par_MontoMinimoBloq				DECIMAL(14,2),		-- Parametro para determinar el monto minimo de saldo a bloquear
	Par_CtaContableTesoreria		VARCHAR(25),		-- Cuenta de Tesoreria para el uso en recepciones SPEI Participante a Participante
	Par_SaldoMinimoCuentaSTP		DECIMAL(19,2),		-- Saldo minimo que deberá de tener la cuenta de STP del SAFI
	Par_RutaKeystoreStp				VARCHAR(200),		-- Ruta local del archivo .jks

	Par_AliasCertificadoStp			VARCHAR(50),		-- Nombre del Alias del Certificado almacenado en el archivo .jks
	Par_PasswordKeystoreStp			VARCHAR(250),		-- Contraseña del archivo .jks
	Par_EmpresaSTP					VARCHAR(15),		-- Nombre de la empresa configurada en STP
	Par_TipoOperacion				CHAR(1),			-- Indica el tipo de Salida de la Transferencia (S = STP B = Banxico)
	Par_IntentosMaxEnvio			INT(11),			-- Intentos máximos para realizar el envio de la orden de pago a STP

	Par_NotificacionesCorreo 		CHAR(1),			-- Indica si se notificara por correo
	Par_CorreoNotificacion			VARCHAR(500),		-- Indica el remitente en caso de generar un error
	Par_RemitenteID 				INT(11),			-- Remitentes de correo referente a la tabla TARENVIOCORREOPARAM
	Par_URLWS						VARCHAR(200),		-- Url de ws para STP
	Par_UsuarioContraseniaWS		VARCHAR(500),		-- Usuario y contraseña de ws para STP

	Par_Habilitado					CHAR(1),			-- Parametro que indica si el SPEI esta habilitado
	Par_MonReqAutDesem				DECIMAL(16,2),		-- Monto a partir del cual un desembolso por SPEI requerira autorizacon
	Par_URLWSPM						VARCHAR(200),		-- URL del Hub de Servicios para el alta de Cuentas Clabe para Personas Morales
	Par_URLWSPF						VARCHAR(200),		-- URL del Hub de Servicios para el alta de Cuentas Clabe para Personas Fisiscas

	Par_Salida						CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),		-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_Usuario						INT(11),			-- Parametros de auditoria
	Aud_FechaActual					DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(20),		-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal					INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);		-- Variable de control

	-- Declaracion de Constantes
	DECLARE NumEmpresaID			INT(11);			-- Numero de empresa vacio
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha vacia
	DECLARE Hora_Vacia				TIME;				-- Hora vacia
	DECLARE Entero_Cero				INT(11);			-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal vacio
	DECLARE Salida_SI				CHAR(1);			-- Salida SI
	DECLARE Salida_NO				CHAR(1);			-- Salida NO
	DECLARE Con_Banxico				CHAR(1);			-- Conexion por Banxico
	DECLARE Con_STP					CHAR(1);			-- Conexion por STP
	DECLARE Con_PrioridadUno		INT(1);				-- Constante de Prioridad uno
	DECLARE Con_TopologiaV			CHAR(1);			-- Constante topologia V
	DECLARE Con_SiNotifica			CHAR(1);			-- Constante que indica que SI sera notificado por correo
	DECLARE Con_NoNotifica			CHAR(1);			-- Constante que indica que NO sera notificado por correo
	DECLARE Con_MinIntentos			INT(11);			-- Indica que el numero minimos de intentos para realizar el envio de la orden de pago por default es 5
	DECLARE Var_UsuarioID			INT(11);			-- ID del usuario con el que se realizaran los desbloqueos de saldos
	DECLARE Var_Contrasenia     	VARCHAR(500);		-- Contrasenia del usuario con que se realizaran los desbloqueos de saldos

	-- Asignacion de Constantes
	SET NumEmpresaID				:= 0;				-- Asignacion numero de empresa
	SET Cadena_Vacia				:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Hora_Vacia					:= '00:00:00';		-- Asignacion de hora vacia
	SET Entero_Cero					:= 0;				-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0;				-- Asignacion de decimal vacio
	SET Salida_SI					:= 'S';				-- Asignacion de salida si
	SET Salida_NO					:= 'N';				-- Asignacion de salida no
	SET Con_Banxico					:= 'B';				-- Asignacion de constante banxico
	SET Con_STP						:= 'S';				-- Asignacion de constante STP
	SET Con_SiNotifica				:= 'S';				-- Constante que indica que SI sera notificado por correo
	SET Con_NoNotifica				:= 'N';				-- Constante que indica que NO sera notificado por correo
	SET Con_PrioridadUno			:= 1;				-- Asignacion de Prioridad uno
	SET Con_TopologiaV				:= 'V';				-- Asignacion de topologia V
	SET Con_MinIntentos				:= 5;				-- Intentos máximos para realizar el envio de la orden de pago a STP

	-- Inicializacion de los Parametros
	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Par_Clabe					:= IFNULL(Par_Clabe, Cadena_Vacia);
	SET Par_CtaSpei					:= IFNULL(Par_CtaSpei, Cadena_Vacia);
	SET Par_ParticipanteSpei		:= IFNULL(Par_ParticipanteSpei, Entero_Cero);
	SET Par_HorarioInicio			:= IFNULL(Par_HorarioInicio, Hora_Vacia);
	SET Par_HorarioFin				:= IFNULL(Par_HorarioFin, Hora_Vacia);
	SET Par_HorarioFinVen			:= IFNULL(Par_HorarioFinVen, Hora_Vacia);
	SET Par_ParticipaPagoMovil		:= IFNULL(Par_ParticipaPagoMovil, Cadena_Vacia);
	SET Par_FrecuenciaEnvio			:= IFNULL(Par_FrecuenciaEnvio, Hora_Vacia);
	SET Par_Topologia				:= IFNULL(Par_Topologia, Cadena_Vacia);
	SET Par_Prioridad				:= IFNULL(Par_Prioridad, Entero_Cero);
	SET Par_MonMaxSpeiVen			:= IFNULL(Par_MonMaxSpeiVen, Decimal_Cero);
	SET Par_MonReqAutTeso			:= IFNULL(Par_MonReqAutTeso, Decimal_Cero);
	SET Par_MonMaxSpeiBcaMovil		:= IFNULL(Par_MonMaxSpeiBcaMovil, Decimal_Cero);
	SET Par_SpeiVenAutTeso			:= IFNULL(Par_SpeiVenAutTeso, Cadena_Vacia);
	SET Par_BloqueoRecepcion		:= IFNULL(Par_BloqueoRecepcion, Cadena_Vacia);
	SET Par_MontoMinimoBloq			:= IFNULL(Par_MontoMinimoBloq, Decimal_Cero);
	SET Par_CtaContableTesoreria	:= IFNULL(Par_CtaContableTesoreria, Cadena_Vacia);
	SET Par_SaldoMinimoCuentaSTP	:= IFNULL(Par_SaldoMinimoCuentaSTP, Decimal_Cero);
	SET Par_RutaKeystoreStp			:= IFNULL(Par_RutaKeystoreStp, Cadena_Vacia);
	SET Par_AliasCertificadoStp		:= IFNULL(Par_AliasCertificadoStp, Cadena_Vacia);
	SET Par_PasswordKeystoreStp		:= IFNULL(Par_PasswordKeystoreStp, Cadena_Vacia);
	SET Par_EmpresaSTP				:= IFNULL(Par_EmpresaSTP, Cadena_Vacia);
	SET Par_TipoOperacion			:= IFNULL(Par_TipoOperacion, Cadena_Vacia);
	SET Par_NotificacionesCorreo	:= IFNULL(Par_NotificacionesCorreo, Cadena_Vacia);
	SET Par_CorreoNotificacion		:= IFNULL(Par_CorreoNotificacion, Cadena_Vacia);
	SET Par_RemitenteID				:= IFNULL(Par_RemitenteID, Entero_Cero);
	SET Par_Salida					:= IFNULL(Par_Salida, Salida_SI);
	SET Par_IntentosMaxEnvio		:= IFNULL(Par_IntentosMaxEnvio, Con_MinIntentos);
	SET Par_URLWS					:= IFNULL(Par_URLWS,Cadena_Vacia);
	SET Par_UsuarioContraseniaWS	:= IFNULL(Par_UsuarioContraseniaWS,Cadena_Vacia);
	SET Par_Habilitado				:= IFNULL(Par_Habilitado, Cadena_Vacia);
	SET Par_MonReqAutDesem			:= IFNULL(Par_MonReqAutDesem, Decimal_Cero);
	SET Par_URLWSPM					:= IFNULL(Par_URLWSPM,Cadena_Vacia);
	SET Par_URLWSPF					:= IFNULL(Par_URLWSPF,Cadena_Vacia);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSSPEIMOD');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_EmpresaID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El numero de empresa esta vacio.';
			SET Var_Control := 'empresaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT	EmpresaID
			FROM PARAMETROSSPEI
			WHERE	EmpresaID	= Par_EmpresaID)THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El ID de la empresa no se ecuentra registrado.';
				SET Var_Control	:= 'empresaID';
				LEAVE ManejoErrores;
		END IF;

		IF (Par_Habilitado = Salida_SI) THEN
			IF(Par_Clabe = Cadena_Vacia) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= 'La clabe esta vacia.';
				SET Var_Control	:= 'clabe';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CtaSPei, Cadena_Vacia) != Cadena_Vacia) THEN
				-- valida la Cuenta Constable Especificada
				CALL CUENTASCONTABLESVAL(	Par_CtaSPei,		Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											Aud_NumTransaccion);
				-- Validamos la respuesta
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr := 005;
					SET Par_ErrMen := CONCAT(Par_ErrMen, ', Cta. Contable SPEI');
					SET Var_Control:= 'ctaSpei' ;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= 'La Cuenta Contable  SPEI esta vacia.';
				SET Var_Control	:= 'ctaSpei';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_HorarioInicio = Hora_Vacia) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= 'La  hora inicio de SPEI esta vacia.';
				SET Var_Control	:= 'horaInicio';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_HorarioFin = Hora_Vacia) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'La  hora fin de SPEI esta vacia.';
				SET Var_Control	:= 'horaFin';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_HorarioFinVen = Hora_Vacia) THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= 'La  hora inicio de SPEI esta vacia.';
				SET Var_Control	:= 'horaFinVen';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ParticipaPagoMovil = Cadena_Vacia) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'Si participa pago movil esta vacio.';
				SET Var_Control	:= 'participaPagoMovil';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FrecuenciaEnvio = Hora_Vacia) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= 'La frecuencia de envio de SPEI esta vacia.';
				SET Var_Control	:= 'frecuenciaEnvio';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Topologia = Cadena_Vacia) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= 'La topologia esta vacia.';
				SET Var_Control	:= 'topologia';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MonMaxSpeiVen = Decimal_Cero) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= 'El monto maximo para SPEI en ventanilla esta vacio.';
				SET Var_Control	:= 'monMaxSpeiVen';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_MonReqAutTeso = Decimal_Cero) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= 'El monto requerido para autorizacion de tesoreria esta vacio.';
				SET Var_Control	:= 'monReqAutTeso';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_SpeiVenAutTeso = Cadena_Vacia) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen	:= 'Tesoreria autoriza la aplicacion SPEI esta vacia.';
				SET Var_Control	:= 'speiVenAutTes';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_BloqueoRecepcion = Cadena_Vacia) THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen	:= 'El parametro de bloqueo de recepcion SPEI esta vacio.';
				SET Var_Control	:= 'bloqueoRecepcion1';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CtaContableTesoreria, Cadena_Vacia) != Cadena_Vacia) THEN
				-- valida la Cuenta Constable Especificada
				CALL CUENTASCONTABLESVAL(	Par_CtaContableTesoreria,	Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											Aud_NumTransaccion);
				-- Validamos la respuesta
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr := 016;
					SET Par_ErrMen := CONCAT(Par_ErrMen, ', Cta. Contable Tesoreria SPEI');
					SET Var_Control:= 'ctaContableTesoreria' ;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'La Cuente de Tesoreria no puede estar vacia.';
				SET Var_Control	:= 'ctaContableTesoreria';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoOperacion = Cadena_Vacia) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= 'El tipo de conexion esta vacio.';
				SET Var_Control	:= 'tipoOperacion';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoOperacion != Con_Banxico AND Par_TipoOperacion != Con_STP) THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen	:= CONCAT('El tipo de conexion [', Par_TipoOperacion, '] no es valido');
				SET Var_Control	:= 'tipoOperacion';
				LEAVE ManejoErrores;
			END IF;
			
			IF(Par_MonReqAutDesem < Decimal_Cero) THEN
				SET Par_NumErr	:= 019;
				SET Par_ErrMen	:= 'El monto requerido para autorizacion de desembolso no puede ser negativo.';
				SET Var_Control	:= 'monReqAutDesem';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_TipoOperacion = Con_STP) THEN

				SET Par_Prioridad	:= Con_PrioridadUno;
				SET Par_Topologia	:= Con_TopologiaV;

				IF(Par_SaldoMinimoCuentaSTP = Decimal_Cero) THEN
					SET Par_NumErr	:= 020;
					SET Par_ErrMen	:= 'El saldo de minimo de STP esta vacio.';
					SET Var_Control	:= 'SaldoMinimoCuentaSTP';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_RutaKeystoreStp = Cadena_Vacia) THEN
					SET Par_NumErr	:= 021;
					SET Par_ErrMen	:= 'La ruta de la Keystore esta vacia.';
					SET Var_Control	:= 'PasswordKeystoreStp';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_AliasCertificadoStp = Cadena_Vacia) THEN
					SET Par_NumErr	:= 022;
					SET Par_ErrMen	:= 'El alias del certificado esta vacio.';
					SET Var_Control	:= 'AliasCertificadoStp';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_PasswordKeystoreStp = Cadena_Vacia) THEN
					SET Par_NumErr	:= 023;
					SET Par_ErrMen	:= 'La contraseña de la Keystore esta vacia.';
					SET Var_Control	:= 'PasswordKeystoreStp';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_EmpresaSTP = Cadena_Vacia) THEN
					SET Par_NumErr	:= 024;
					SET Par_ErrMen	:= 'El tipo de conexion esta vacio.';
					SET Var_Control	:= 'empresaSTP';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_NotificacionesCorreo!= Con_SiNotifica AND Par_NotificacionesCorreo!= Con_NoNotifica) THEN
					SET Par_NumErr	:= 025;
					SET Par_ErrMen	:= CONCAT('El tipo de notificacion [', Par_NotificacionesCorreo, '] no es valido');
					SET Var_Control	:= 'notificacionesCorreo';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_NotificacionesCorreo = Con_SiNotifica) THEN
					IF(Par_CorreoNotificacion = Cadena_Vacia) THEN
						SET Par_NumErr	:= 026;
						SET Par_ErrMen	:= 'El correo esta vacio.';
						SET Var_Control	:= 'correoNotificacion';
						LEAVE ManejoErrores;
					END IF;

					IF(Par_RemitenteID = Entero_Cero) THEN
						SET Par_NumErr	:= 027;
						SET Par_ErrMen	:= 'El remitente esta vacio.';
						SET Var_Control	:= 'remitenteID';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF(Par_IntentosMaxEnvio < Con_MinIntentos) THEN
					SET Par_IntentosMaxEnvio	:= Con_MinIntentos;
				END IF;

				IF(Par_URLWS = Cadena_Vacia) THEN
					SET Par_NumErr	:= 028;
					SET Par_ErrMen	:= 'La URL esta vacia.';
					SET Var_Control	:= 'URLWS';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_UsuarioContraseniaWS = Cadena_Vacia) THEN
					SET Par_NumErr	:= 029;
					SET Par_ErrMen	:= 'El Usuario/Contraseña esta vacio.';
					SET Var_Control	:= 'usuarioContrasenia';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_URLWSPM = Cadena_Vacia) THEN
					SET Par_NumErr	:= 028;
					SET Par_ErrMen	:= 'Especifique La URL para el Alta de personas morales en STP.';
					SET Var_Control	:= 'URLWS';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_URLWSPF = Cadena_Vacia) THEN
					SET Par_NumErr	:= 028;
					SET Par_ErrMen	:= 'Especifique La URL para el Alta de personas fisicas en STP.';
					SET Var_Control	:= 'URLWS';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_IntentosMaxEnvio	:= Entero_Cero;
			END IF;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE PARAMETROSSPEI SET
			EmpresaID				= Par_EmpresaID,
			Clabe					= Par_Clabe,
			CtaSpei					= Par_CtaSPei,
			ParticipanteSpei		= Par_ParticipanteSpei,
			HorarioInicio			= Par_HorarioInicio,

			HorarioFin				= Par_HorarioFin,
			HorarioFinVen			= Par_HorarioFinVen,
			ParticipaPagoMovil		= Par_ParticipaPagoMovil,
			FrecuenciaEnvio			= Par_FrecuenciaEnvio,
			Topologia				= Par_Topologia,

			Prioridad				= Par_Prioridad,
			MonMaxSpeiBcaMovil		= Par_MonMaxSpeiBcaMovil,
			MonMaxSpeiVen			= Par_MonMaxSpeiVen,
			MonReqAutTeso			= Par_MonReqAutTeso,
			SpeiVenAutTes			= Par_SpeiVenAutTeso,

			BloqueoRecepcion		= Par_BloqueoRecepcion,
			MontoMinimoBloq			= Par_MontoMinimoBloq,
			CtaContableTesoreria	= Par_CtaContableTesoreria,
			SaldoMinimoCuentaSTP	= Par_SaldoMinimoCuentaSTP,
			RutaKeystoreStp			= Par_RutaKeystoreStp,

			AliasCertificadoStp		= Par_AliasCertificadoStp,
			PasswordKeystoreStp		= Par_PasswordKeystoreStp,
			EmpresaSTP				= Par_EmpresaSTP,
			TipoOperacion			= Par_TipoOperacion,
			IntentosMaxEnvio		= Par_IntentosMaxEnvio,

			URLWS					= Par_URLWS,
			UsuarioContraseniaWS	= Par_UsuarioContraseniaWS,
			NotificacionesCorreo	= Par_NotificacionesCorreo,
			CorreoNotificacion		= Par_CorreoNotificacion,
			RemitenteID				= Par_RemitenteID,

			Habilitado				= Par_Habilitado,
			MonReqAutDesem			= Par_MonReqAutDesem,
			URLWSPM 				= Par_URLWSPM,
			URLWSPF 				= Par_URLWSPF,

			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	EmpresaID			= Par_EmpresaID;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Parametros SPEI Modificados Exitosamente.';
		SET Var_Control	:= 'empresaID';

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen	AS ErrMen,
					Var_Control AS control,
					Par_EmpresaID AS consecutivo;
		END IF;

-- Fin del SP
END TerminaStore$$
