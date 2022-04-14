-- SP MODIFICACONVENIOSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS MODIFICACONVENIOSPRO;

DELIMITER $$

CREATE PROCEDURE `MODIFICACONVENIOSPRO`(
	-- Stored procedure para dar de alta los registros de las programaciones de convenios de una empresa de nomina
	Par_ConvenioNominaID			BIGINT UNSIGNED, 		-- Identificador del convenio
	Par_InstitNominaID				INT(11),				-- Empresa de nomina a la cual pertenece el convenio
	Par_Descripcion					VARCHAR(150),			-- Descripcion del convenio de Nomina
	Par_ManejaVencimiento			CHAR(1),				-- Indica si se manejara o no una fecha de vencimiento para el convenio
	Par_FechaVencimiento			DATE,					-- Fecha de vencimiento del convenio si el campo ManejaVencimiento tiene el valor S

	Par_DomiciliacionPagos			CHAR(1),				-- Forma de cobro para la aplicacion de pagos a facturas de un credito. S - Los creditos otorgados a este convenio se les cobrara comision por falta de pago si el producto de credito tiene parametrizado un esquema de comision por falta de pago N - No se cobrara comision por falta de pago
	Par_Estatus 					CHAR(1),				-- Estatus del convenio
	Par_ClaveConvenio				VARCHAR(20),			-- Clave o numero de convenio contratado
	Par_Resguardo					DECIMAL(12,2),			-- campo utilizado para la capacidad de pago
	Par_RequiereFolio				CHAR(1),				-- Requiere Folio de la solicitud de Credito

	Par_ManejaQuinquenios			CHAR(1),				-- Se validan los quinquenios que lleva trabajado el cliente, S="SI", N="NO"
	Par_UsuarioID					INT(11),				-- Nombre del ejecutivo encargado del convenio
	Par_CorreoEjecutivo				TEXT,					-- Correo del ejecutivo
	Par_Comentario 					TEXT(150),				-- comentarios adicionales al convenio
	Par_ManejaCapPago				CHAR(1),				-- Considera la capacidad de pago para el convenio que se esté parametrizando, S= "SI", N="NO

	Par_FormCapPago 				VARCHAR(200),			-- Formula para las solictudes del flujo individual
	Par_DesFormCapPago				VARCHAR(500),			-- Descripcion del Formula para las solictudes del flujo individual
	Par_FormCapPagoRes				VARCHAR(200),			-- Formula para las solictudes del flujo renovacion, restructura o consolidacion
	Par_DesFormCapPagoRes			VARCHAR(500),			-- Descripcion del Formula para las solictudes del flujo renovacion, restructura o consolidacion
	Par_ManejaCalendario			CHAR(1),				-- Indica si maneja calendario S.-SI, N.-NO

	Par_ReportaIncidencia			CHAR(1),				-- Indica si reporta incidencias. S. SI. N- NO.
	Par_ManejaFechaIniCal			CHAR(1),				-- Indica si maneja fecha inicial S.-SI, N.-NO
	Par_NoCuotasCobrar				INT(11),				-- Indica hasta cuantas cuotas puede cobrar cuando un credito tenga amortizaciones (facturas) atrasadas
	Par_CobraComisionApert		    CHAR(1),				-- Indica si cobra comisión por apertura S.-SI, N.-NO
	Par_CobraMora			        CHAR(1),				-- Indica si cobra un interés moratorio S.-SI, N.-NO

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11),				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Var_ConvenioNominaID		BIGINT UNSIGNED;	-- Identificador del convenio de nomina
	DECLARE Var_FechaSistema			DATE;				-- Fecha de sistema de PARAMETROSSIS
	DECLARE Var_UsuarioID				INT(11);			-- Numero de usuario de la tabla de USUARIOS
	DECLARE Var_Estatus					CHAR(1);			-- Variable para almacenar el estatus actual del convenio
	DECLARE Var_TextoExito				VARCHAR(300);		-- Variable para almacenar el mensaje de exito segun sea el caso
	DECLARE Var_InstitNominaID			INT(11);			-- Variable para almacenar el numero de empresa de nomina
	DECLARE Var_FechaVencido			DATE;				-- Variable para almacenar una fecha de vencimiento de programacion

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(1);				-- Entero cero
	DECLARE Entero_Uno					INT(1);				-- Entero uno
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);			-- Salida no
	DECLARE Est_Activo					CHAR(1);			-- Estatus activo
	DECLARE Est_Inactivo				CHAR(1);			-- Estatus inactivo
	DECLARE Est_Vencido					CHAR(1);			-- Estatus vencido
	DECLARE Est_Baja					CHAR(1);			-- Estatus baja
	DECLARE Est_Suspendido				CHAR(1);			-- Estatus suspendido

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Entero_Uno						:= 1;				-- Asignacion de entero uno
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Var_SalidaNO					:= 'N';				-- Salida no
	SET Est_Activo						:= 'A';				-- Estatus activo
	SET Est_Inactivo					:= 'I';				-- Estatus inactivo
	SET Est_Vencido						:= 'V';				-- Estatus vencido
	SET Est_Baja						:= 'B';				-- Estatus baja
	SET Est_Suspendido					:= 'S';				-- Estatus suspendido

	-- Valores por default
	SET Par_ConvenioNominaID			:= IFNULL(Par_ConvenioNominaID, Entero_Cero);
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_ManejaVencimiento			:= IFNULL(Par_ManejaVencimiento, Cadena_Vacia);
	SET Par_FechaVencimiento			:= IFNULL(Par_FechaVencimiento, Fecha_Vacia);
	SET Par_DomiciliacionPagos			:= IFNULL(Par_DomiciliacionPagos, Cadena_Vacia);
	SET Par_Estatus						:= IFNULL(Par_Estatus, Cadena_Vacia);
	SET Par_UsuarioID					:= IFNULL(Par_UsuarioID, Entero_Cero);
	SET Par_Comentario					:= IFNULL(Par_Comentario, Cadena_Vacia);
    SET Par_CobraComisionApert			:= IFNULL(Par_CobraComisionApert, Cadena_Vacia);
   	SET Par_CobraMora       			:= IFNULL(Par_CobraMora, Cadena_Vacia);

	SET Par_ManejaCapPago				:= IFNULL(Par_ManejaCapPago, Cadena_Vacia);
	SET Par_FormCapPago 				:= IFNULL(Par_FormCapPago, Cadena_Vacia);
	SET Par_DesFormCapPago				:= IFNULL(Par_DesFormCapPago, Cadena_Vacia);
	SET Par_FormCapPagoRes				:= IFNULL(Par_FormCapPagoRes, Cadena_Vacia);
	SET Par_DesFormCapPagoRes			:= IFNULL(Par_DesFormCapPagoRes, Cadena_Vacia);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-MODIFICACONVENIOSPRO');
			SET Var_Control = 'sqlException';
		END;

		-- Validaciones
		IF (Par_ConvenioNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El numero de convenio se encuentra vacio';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'El numero de empresa se encuentra vacio';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'La descripcion del convenio se encuentra vacia';
			SET Var_Control := 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_DomiciliacionPagos = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'Especifique si se domiciliaran o no los pagos';
			SET Var_Control := 'domiciliacionPagos';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Estatus = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'El estatus del convenio se encuentra vacio';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_UsuarioID = Entero_Cero) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'El numero de usuario se encuentra vacio';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;

		SELECT		UsuarioID
			INTO	Var_UsuarioID
			FROM	USUARIOS
			WHERE	UsuarioID = Par_UsuarioID;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		IF (Par_UsuarioID <> Var_UsuarioID) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen	:= 'El numero de usuario especificado no existe en la base de datos';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;



		SELECT		Estatus,				InstitNominaID
			INTO	Var_Estatus,			Var_InstitNominaID
			FROM	CONVENIOSNOMINA
			WHERE	ConvenioNominaID = Par_ConvenioNominaID;

		SET Var_ConvenioNominaID	:= Par_ConvenioNominaID;


		IF (Par_Estatus = Est_Vencido AND Var_Estatus = Est_Vencido) THEN
			SET Par_NumErr 	:= 009;
			SET Par_ErrMen	:= CONCAT('No se pueden realizar cambios a Estatus Vencido si el Convenio ya se encuentra en ese Estatus. ',
									'Primero debe cambiar el valor del campo Estatus a Activo');
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Estatus = Est_Suspendido AND Var_Estatus = Est_Suspendido) THEN
			SET Par_NumErr 	:= 010;
			SET Par_ErrMen	:= CONCAT('No se pueden realizar cambios a Estatus Suspendido si el Convenio ya se encuentra en ese Estatus. ',
									'Primero debe cambiar el valor del campo Estatus a Activo');
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ManejaVencimiento = Var_SalidaSI AND Par_FechaVencimiento < Var_FechaSistema ) THEN
			SET Par_NumErr 	:= 011;
			SET Par_ErrMen	:= 'La fecha de vencimiento no puede ser menor o igual que la fecha del sistema';
			SET Var_Control := 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_InstitNominaID <> Var_InstitNominaID) THEN
			SET Par_NumErr 	:= 012;
			SET Par_ErrMen	:= 'El Convenio no puede cambiar de Empresa de Nomina';
			SET Var_Control := 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 014;
			SET Par_ErrMen	:= 'Especifique si Maneja Capacidad de Pago.';
			SET Var_Control := 'manejaCapacidad';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago NOT IN(Var_SalidaSI,Var_SalidaNO))THEN
			SET Par_NumErr 	:= 015;
			SET Par_ErrMen	:= 'Especifique el Campo Maneja Capacidad de Pago Valido.';
			SET Var_Control := 'manejaCapacidad';
			LEAVE ManejoErrores;
		END IF;

	    IF(Par_CobraComisionApert = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen	:= 'Especifique si Cobra Comision por apertura.';
			SET Var_Control := 'cobraComisionApert';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CobraMora = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 017;
			SET Par_ErrMen	:= 'Especifique si Cobra Interés Moratorio.';
			SET Var_Control := 'cobraMora';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago = Var_SalidaSI) THEN
			IF(Par_FormCapPago = Cadena_Vacia AND Par_DesFormCapPago = Cadena_Vacia)THEN
				SET Par_NumErr 	:= 018;
				SET Par_ErrMen	:= 'Especifique la Formula de Capacidad de Pago.';
				SET Var_Control := 'formCapPago';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FormCapPagoRes = Cadena_Vacia AND Par_DesFormCapPagoRes = Cadena_Vacia)THEN
				SET Par_NumErr 	:= 019;
				SET Par_ErrMen	:= 'Especifique la Formula de Capacidad de Pago Para Renovacion/Restructura y Consolidacion.';
				SET Var_Control := 'formCapPagoRes';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ReportaIncidencia NOT IN(Var_SalidaSI,Var_SalidaNO))THEN
			SET Par_NumErr 	:= 020;
			SET Par_ErrMen	:= 'Especifique el Campo Reporta Incidencia.';
			SET Var_Control := 'reportaIncidencia';
			LEAVE ManejoErrores;
		END IF;

		-- Si es renovacion para el mismo dia del sistema e incluye cambio de estatus a vencido o inactivo llama al SP de modificacion y pase a historico
		CALL CONVENIOSNOMINAPRO (
							Par_ConvenioNominaID,	Par_InstitNominaID,		Par_Descripcion,		Par_ManejaVencimiento,	Par_FechaVencimiento,
							Par_DomiciliacionPagos,	Par_Estatus,			Par_ClaveConvenio,		Par_Resguardo,			Par_RequiereFolio,
							Par_ManejaQuinquenios,	Par_UsuarioID,			Par_CorreoEjecutivo,	Par_Comentario,			Par_ManejaCapPago,
							Par_FormCapPago,		Par_DesFormCapPago,		Par_FormCapPagoRes,		Par_DesFormCapPagoRes,	Par_ManejaCalendario,
							Par_ReportaIncidencia,	Par_ManejaFechaIniCal,	Par_CobraComisionApert, Par_CobraMora,          Par_NoCuotasCobrar,
							Var_SalidaNO,			Par_NumErr,				Par_ErrMen,             Aud_EmpresaID,			Aud_Usuario,
							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,         Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_TextoExito	:= CONCAT('Convenio modificado exitosamente: ', CAST(Par_ConvenioNominaID AS CHAR));


		-- Los cambios se realizaron con exito
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= Var_TextoExito;
		SET Var_Control	:= 'convenioNominaID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Var_ConvenioNominaID	AS consecutivo;
	END IF;
-- Fin del SP

END TerminaStore$$
