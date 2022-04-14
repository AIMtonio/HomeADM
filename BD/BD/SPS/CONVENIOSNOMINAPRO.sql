-- SP CONVENIOSNOMINAPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONVENIOSNOMINAPRO;

DELIMITER $$

CREATE PROCEDURE CONVENIOSNOMINAPRO (
	-- Stored procedure para modificar un registro de convenio de una empresa de nomina dar de alta los valores anteriores en una tabla historica
	Par_ConvenioNominaID			BIGINT UNSIGNED,		-- Identificador del convenio
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
    Par_CobraComisionApert		    CHAR(1),				-- Indica si cobra comisión por apertura S.-SI, N.-NO
	Par_CobraMora			        CHAR(1),				-- Indica si cobra un interés moratorio S.-SI, N.-NO
	Par_NoCuotasCobrar				INT(11),				-- Indica hasta cuantas cuotas puede cobrar cuando un credito tenga amortizaciones (facturas) atrasadas

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
	DECLARE Var_ConvenioNominaID		BIGINT UNSIGNED;	-- Variable para el identificador del convenio
	DECLARE Var_Referencia				VARCHAR(20);		-- Valor para el campo Referencia de CONVENIOSNOMINA
	DECLARE Var_FechaSistema			DATE;				-- Variable para la fecha del sistema

	DECLARE Var_InstitNominaID			BIGINT(20);
	DECLARE Var_Descripcion 			VARCHAR(150);		-- Valor para el campo Descripcion de CONVENIOSNOMINA
	DECLARE Var_FechaRegistro			DATE;				-- Valor para el campo FechaRegistro de CONVENIOSNOMINA
	DECLARE Var_ManejaVencimiento		CHAR(1);			-- Valor para el campo ManejaVencimiento de CONVENIOSNOMINA
	DECLARE Var_FechaVencimiento		DATE;				-- Valor para el campo FechaVencimiento de CONVENIOSNOMINA
	DECLARE Var_DomiciliacionPagos		CHAR(1);			-- Valor para el campo DomiciliacionPagos de CONVENIOSNOMINA
	DECLARE Var_ClaveConvenio			VARCHAR(20);		-- Valor para el campo DomiciliacionPagos de CONVENIOSNOMINA
	DECLARE Var_Estatus					CHAR(1);			-- Valor para el campo ClaveConvenio de CONVENIOSNOMINA
	DECLARE Var_Resguardo				DECIMAL(12,2);		-- Valor para el campo Resguardo de CONVENIOSNOMINA
	DECLARE Var_RequiereFolio			CHAR(1);			-- Valor para el campo RequiereFolio de CONVENIOSNOMINA
	DECLARE Var_ManejaQuinquenios		CHAR(1);			-- Valor para el campo ManejaQuinquenios de CONVENIOSNOMINA
	DECLARE Var_NumActualizaciones		INT(11);			-- Valor para el campo NumActualizaciones de CONVENIOSNOMINA
	DECLARE Var_UsuarioID				INT(11);			-- Valor para el campo UsuarioID de CONVENIOSNOMINA
	DECLARE Var_CorreoEjecutivo			TEXT;				-- Valor para el campo CorreoEjecutivo de CONVENIOSNOMINA
	DECLARE Var_Comentario				TEXT;				-- Valor para el campo Comentario de CONVENIOSNOMINA
	DECLARE Var_ManejaCapPago			CHAR(1);			-- Valor para el campo ManejaCapPago de CONVENIOSNOMINA
	DECLARE Var_FormCapPago 			VARCHAR(200);		-- Valor para el campo FormCapPago  de CONVENIOSNOMINA
	DECLARE Var_FormCapPagoRes			VARCHAR(200);		-- Valor para el campo FormCapPagoRes de CONVENIOSNOMINA
	DECLARE Var_ManejaCalendario		CHAR(1);			-- Valor para el campo ManejaCalendario de CONVENIOSNOMINA
	DECLARE Var_ReportaIncidencia		CHAR(1);			-- Valor para el campo ReportaIncidencia de CONVENIOSNOMINA
	DECLARE Var_ManejaFechaIniCal		CHAR(1);			-- Valor para el campo ManejaFechaIniCal de CONVENIOSNOMINA
    DECLARE Var_CobraComisionAper		CHAR(1);			-- Valor para el campo ManejaCalendario de CONVENIOSNOMINA
	DECLARE Var_CobraMora       		CHAR(1);			-- Valor para el campo ManejaFechaIniCal de CONVENIOSNOMINA
	DECLARE Var_DesFormCapPago			VARCHAR(500);		-- Descripcion del Formula para las solictudes del flujo individual
	DECLARE Var_DesFormCapPagoRes		VARCHAR(500);		-- Descripcion del Formula para las solictudes del flujo renovacion, restructura o consolidacion
	DECLARE Var_NoCuotasCobrar			INT(11);			-- Valor para el campo NoCuotasCobrar de CONVENIOSNOMINA


	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Entero_Uno					INT(1);				-- Entero uno
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);			-- Salida no
	DECLARE Cons_No						CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Entero_Uno						:= 1;				-- Asignacion de entero uno
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Var_SalidaNO					:= 'N';				-- Salida si
	SET Cons_No							:= 'N';

	-- Valores por default
	SET Par_ConvenioNominaID 			:= IFNULL(Par_ConvenioNominaID, Entero_Cero);
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_ManejaVencimiento			:= IFNULL(Par_ManejaVencimiento, Cadena_Vacia);
	SET Par_FechaVencimiento			:= IFNULL(Par_FechaVencimiento, Fecha_Vacia);
    SET Par_CobraComisionApert			:= IFNULL(Par_CobraComisionApert, Cadena_Vacia);
   	SET Par_CobraMora       			:= IFNULL(Par_CobraMora, Cadena_Vacia);
	SET Par_DomiciliacionPagos			:= IFNULL(Par_DomiciliacionPagos, Cadena_Vacia);
	SET Par_Estatus						:= IFNULL(Par_Estatus, Cadena_Vacia);
	SET Par_UsuarioID					:= IFNULL(Par_UsuarioID, Entero_Cero);
	SET Par_Comentario					:= IFNULL(Par_Comentario, Cadena_Vacia);

	SET Par_ManejaCapPago				:= IFNULL(Par_ManejaCapPago, Cadena_Vacia);
	SET Par_FormCapPago 				:= IFNULL(Par_FormCapPago, Cadena_Vacia);
	SET Par_DesFormCapPago				:= IFNULL(Par_DesFormCapPago, Cadena_Vacia);
	SET Par_FormCapPagoRes				:= IFNULL(Par_FormCapPagoRes, Cadena_Vacia);
	SET Par_DesFormCapPagoRes			:= IFNULL(Par_DesFormCapPagoRes, Cadena_Vacia);
	SET Par_NoCuotasCobrar				:= IFNULL(Par_NoCuotasCobrar, Entero_Cero);
	SET Par_ManejaQuinquenios			:= IFNULL(Par_ManejaQuinquenios, Cons_No);

	ManejoErrores: BEGIN


		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN

			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONVENIOSNOMINAPRO');
			SET Var_Control = 'sqlException';

		END;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		SELECT		ConvenioNominaID,			InstitNominaID,				Descripcion,				FechaRegistro,				ManejaVencimiento,
					FechaVencimiento,			DomiciliacionPagos,			ClaveConvenio,				Estatus,					Resguardo,
					RequiereFolio,				ManejaQuinquenios,			NumActualizaciones,			UsuarioID,					CorreoEjecutivo,
					Comentario,					ManejaCapPago,				FormCapPago,				FormCapPagoRes,				ManejaCalendario,
					ManejaFechaIniCal,			CobraComisionApert,         CobraMora,                  DesFormCapPago,				DesFormCapPagoRes,
					NoCuotasCobrar,				Referencia,					ReportaIncidencia
			INTO	Var_ConvenioNominaID,		Var_InstitNominaID,			Var_Descripcion,			Var_FechaRegistro,			Var_ManejaVencimiento,
					Var_FechaVencimiento,		Var_DomiciliacionPagos,		Var_ClaveConvenio,			Var_Estatus,				Var_Resguardo,
					Var_RequiereFolio,			Var_ManejaQuinquenios,		Var_NumActualizaciones,		Var_UsuarioID,				Var_CorreoEjecutivo,
					Var_Comentario,				Var_ManejaCapPago,			Var_FormCapPago,			Var_FormCapPagoRes,			Var_ManejaCalendario,
					Var_ManejaFechaIniCal,      Var_CobraComisionAper,      Var_CobraMora,         		Var_DesFormCapPago,			Var_DesFormCapPagoRes,
					Var_NoCuotasCobrar,			Var_Referencia,				Var_ReportaIncidencia
			FROM CONVENIOSNOMINA
			WHERE	ConvenioNominaID	= Par_ConvenioNominaID;

		CALL HISCONVENIOSNOMINAALT (	Var_ConvenioNominaID,		Var_InstitNominaID,			Var_Descripcion,			Var_FechaRegistro,			Var_ManejaVencimiento,
										Var_FechaVencimiento,		Var_DomiciliacionPagos,		Var_Estatus,				Var_ClaveConvenio,			Var_Resguardo,
										Var_RequiereFolio,			Var_ManejaQuinquenios,		Var_NumActualizaciones,		Var_UsuarioID,				Var_CorreoEjecutivo,
										Var_Comentario,				Var_ManejaCapPago,			Var_FormCapPago,			Var_FormCapPagoRes,			Var_ManejaCalendario,
										Var_ReportaIncidencia,		Var_ManejaFechaIniCal,      Var_CobraComisionAper,      Var_CobraMora,        		Var_NoCuotasCobrar,
										Var_Referencia,				Var_SalidaNO,				Par_NumErr,                 Par_ErrMen,					Aud_EmpresaID,
										Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,            Aud_ProgramaID,				Aud_Sucursal,
										Aud_NumTransaccion);


		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL CONVENIOSNOMINAMOD (	Par_ConvenioNominaID,			Par_InstitNominaID,				Par_Descripcion	,				Par_ManejaVencimiento,			Par_FechaVencimiento,
									Par_DomiciliacionPagos,			Par_Estatus, 					Par_ClaveConvenio,				Par_Resguardo,					Par_RequiereFolio,
									Par_ManejaQuinquenios,			Par_UsuarioID,					Par_CorreoEjecutivo	,			Par_Comentario ,				Par_ManejaCapPago,
									Par_FormCapPago,				Par_DesFormCapPago,				Par_FormCapPagoRes,				Par_DesFormCapPagoRes,			Par_ManejaCalendario,
									Par_ReportaIncidencia,			Par_ManejaFechaIniCal,			Par_CobraComisionApert,         Par_CobraMora,                  Par_NoCuotasCobrar,
									Var_SalidaNO,					Par_NumErr,						Par_ErrMen,						Aud_EmpresaID,					Aud_Usuario,
									Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,                 Aud_Sucursal,					Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;



		-- El registro se modifico exitosamente
		IF (Par_NumErr = Entero_Cero) THEN
			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Convenio modificado exitosamente: ', CAST(Par_ConvenioNominaID AS CHAR));
			SET Var_Control	:= 'convenioNominaID';
		END IF;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_ConvenioNominaID	AS consecutivo;
	END IF;
-- Fin del SP
END TerminaStore$$
