-- SP HISCONVENIOSNOMINAALT

DELIMITER ;

DROP PROCEDURE IF EXISTS HISCONVENIOSNOMINAALT;

DELIMITER $$

CREATE PROCEDURE HISCONVENIOSNOMINAALT (
	-- Stored procedure para dar de alta en historico los registros los convenios de una empresa de nomina junto con los valores que tenia previamente
	Par_ConvenioNominaID			BIGINT UNSIGNED,		-- Identificador del convenio
	Par_InstitNominaID				INT(11),				-- Empresa de nomina a la cual pertenece el convenio
	Par_Descripcion					VARCHAR(150),			-- Descripcion del convenio de Nomina
	Par_FechaRegistro				DATE,					-- Fecha de registro del convenio
	Par_ManejaVencimiento			CHAR(1),				-- Indica si se manejara o no una fecha de vencimiento para el convenio S = "S" , N= "NO"

	Par_FechaVencimiento			DATE,					-- Fecha de vencimiento del convenio si el campo ManejaVencimiento tiene el valor S
	Par_DomiciliacionPagos			CHAR(1),				-- Forma de cobro para la aplicacion de pagos a facturas de un credito. S - Los creditos otorgados a este convenio se les cobrara comision por falta de pago si el producto de credito tiene parametrizado un esquema de comision por falta de pago N - No se cobrara comision por falta de pago
	Par_Estatus 					CHAR(1),				-- Estatus del convenio
	Par_ClaveConvenio				VARCHAR(20),			-- Clave o numero de convenio contratado
	Par_Resguardo					DECIMAL(12,2),			-- campo utilizado para la capacidad de pago

	Par_RequiereFolio				CHAR(1),				-- Requiere Folio de la solicitud de Credito
	Par_ManejaQuinquenios			CHAR(1),				-- Se validan los quinquenios que lleva trabajado el cliente, S="SI", N="NO"
	Par_NumActualizaciones			INT(11),				-- Numero de Actualizaciones
	Par_UsuarioID					INT(11),				-- Nombre del ejecutivo encargado del convenio
	Par_CorreoEjecutivo				TEXT,					-- Correo del ejecutivo

	Par_Comentario 					TEXT(150),				-- comentarios adicionales al convenio
	Par_ManejaCapPago				CHAR(1),				-- Considera la capacidad de pago para el convenio que se esté parametrizando, S= "SI", N="NO
	Par_FormCapPago 				TEXT,					-- Formula para las solictudes del flujo individual
	Par_FormCapPagoRes				TEXT,					-- Formula para las solictudes del flujo renovacion, restructura o consolidacion
	Par_ManejaCalendario			CHAR(1),				-- Indica si maneja calendario S.-SI, N.-NO

	Par_ReportaIncidencia			CHAR(1),				-- Indica si reporta incidencias. S. SI. N- NO.
	Par_ManejaFechaIniCal			CHAR(1),				-- Indica si maneja fecha inicial S.-SI, N.-NO
	Par_CobraComisionApert		    CHAR(1),				-- Indica si cobra comisión por apertura S.-SI, N.-NO
	Par_CobraMora			        CHAR(1),				-- Indica si cobra un interés moratorio S.-SI, N.-NO
	Par_NoCuotasCobrar				INT(11),				-- Valor que se tenia previemente en el campo NoCuotasCobrar

	Par_Referencia					VARCHAR(20),			-- Numero de referencia. Se compone del valor 9 para las empresas de nomina concatenado con el ID de la empresa de nomina y el ID del convenio

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11),				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Var_FechaSistema			DATE;				-- Fecha de sistema de PARAMETROSSIS
	DECLARE Var_UsuarioID				INT(11);			-- Numero de usuario de la tabla de USUARIOS
	DECLARE Var_Estatus					CHAR(1);			-- Estatus actual del convenio
	DECLARE Var_ManejaVencimiento		CHAR(1);			-- Maneja vencimiento
	DECLARE Var_FechaVencimiento		DATE;				-- Fecha de vencimiento actual
	DECLARE Var_HisConvenioNomID		BIGINT(20);			-- Identificador del historico en alta
    DECLARE Var_FechaCambio				DATETIME;

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SalidaSI				CHAR(1);			-- Salida si
	DECLARE Est_Activo					CHAR(1);			-- Estatus activo
	DECLARE Var_SI						CHAR(1);			-- Salida si
	DECLARE Var_NO						CHAR(1);			-- Salida no

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SalidaSI					:= 'S';				-- Salida si
	SET Est_Activo						:= 'A';				-- Estatus activo
	SET Var_SI							:= 'S';				-- Salida si
	SET Var_NO							:= 'N';				-- Salida no

	-- Valores por default
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_FechaRegistro				:= IFNULL(Par_FechaRegistro, Fecha_Vacia);
	SET Par_ManejaVencimiento			:= IFNULL(Par_ManejaVencimiento, Cadena_Vacia);
	SET Par_FechaVencimiento			:= IFNULL(Par_FechaVencimiento, Fecha_Vacia);
	SET Par_DomiciliacionPagos			:= IFNULL(Par_DomiciliacionPagos, Cadena_Vacia);
	SET Par_Estatus						:= IFNULL(Par_Estatus, Cadena_Vacia);
	SET Par_NumActualizaciones			:= IFNULL(Par_NumActualizaciones, Entero_Cero);
	SET Par_UsuarioID					:= IFNULL(Par_UsuarioID, Entero_Cero);
	SET Par_Comentario					:= IFNULL(Par_Comentario, Cadena_Vacia);
	SET Par_NoCuotasCobrar				:= IFNULL(Par_NoCuotasCobrar, Entero_Cero);
    SET Par_Referencia					:= IFNULL(Par_Referencia, Cadena_Vacia);
    SET Par_CobraComisionApert			:= IFNULL(Par_CobraComisionApert, Cadena_Vacia);
   	SET Par_CobraMora       			:= IFNULL(Par_CobraMora, Cadena_Vacia);

	SET Var_FechaCambio 				:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-HISCONVENIOSNOMINAALT');
			SET Var_Control = 'sqlException';
		END;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

		-- Validaciones
		IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El numero de empresa se encuentra vacio';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'La descripcion del convenio se encuentra vacia';
			SET Var_Control := 'descripcion';
			LEAVE ManejoErrores;
		END IF;

		SELECT		Estatus,		ManejaVencimiento,		FechaVencimiento
			INTO	Var_Estatus,	Var_ManejaVencimiento,	Var_FechaVencimiento
			FROM CONVENIOSNOMINA
			WHERE ConvenioNominaID = Par_ConvenioNominaID;

		IF (Par_Estatus = Var_Estatus AND Var_Estatus = Est_Activo AND (Par_ManejaVencimiento <> Var_ManejaVencimiento OR Par_FechaVencimiento <> Var_FechaVencimiento)) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'No se puede modificar el vencimiento mientras el convenio esta activo';
			SET Var_Control := 'manejaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ManejaVencimiento = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'Especifique si se manejara o no fecha de vencimiento';
			SET Var_Control := 'manejaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaVencimiento = Fecha_Vacia AND Par_ManejaVencimiento = Var_SalidaSI) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'La fecha de vencimiento esta vacia';
			SET Var_Control := 'manejaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_DomiciliacionPagos = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'Especifique si se domiciliaran o no los pagos';
			SET Var_Control := 'domiciliacionPagos';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Estatus = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen	:= 'El estatus del convenio se encuentra vacio';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_UsuarioID = Entero_Cero) THEN
			SET Par_NumErr 	:= 008;
			SET Par_ErrMen	:= 'El numero de usuario se encuentra vacio';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;

		SELECT		UsuarioID
			INTO	Var_UsuarioID
			FROM USUARIOS
			WHERE	UsuarioID = Par_UsuarioID;

		IF (Par_UsuarioID <> Var_UsuarioID) THEN
			SET Par_NumErr 	:= 010;
			SET Par_ErrMen	:= 'El numero de usuario especificado no existe en la base de datos';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CobraComisionApert NOT IN(Var_SI,Var_NO)) THEN
			SET Par_NumErr	:= 011;
			SET Par_ErrMen	:= 'El Indicador Cobra Comisión por Apertura no es válido.';
			SET Var_Control	:= 'cobraComisionApert';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CobraMora NOT IN(Var_SI,Var_NO)) THEN
			SET Par_NumErr	:= 012;
			SET Par_ErrMen	:= 'El Indicador Cobra Interés Moratorio no es válido.';
			SET Var_Control	:= 'cobraMora';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ReportaIncidencia NOT IN(Var_SI,Var_NO))THEN
			SET Par_NumErr 	:= 013;
			SET Par_ErrMen	:= 'Especifique el Campo Reporta Incidencia.';
			SET Var_Control := 'reportaIncidencia';
			LEAVE ManejoErrores;
		END IF;

		SET Var_FechaCambio := CONCAT(Var_FechaSistema,' ',date_format(NOW(),'%H:%i:%s'));

		CALL FOLIOSAPLICAACT('HISCONVENIOSNOMINA', Var_HisConvenioNomID);

		INSERT INTO HISCONVENIOSNOMINA (HisConvenioNomID, 		FechaSistema, 			Hora, 					ConvenioNominaID, 		InstitNominaID,
										Descripcion, 			FechaRegistro, 			ManejaVencimiento, 		FechaVencimiento, 		DomiciliacionPagos,
										ClaveConvenio, 			Estatus, 				Resguardo, 				RequiereFolio, 			ManejaQuinquenios,
										NumActualizaciones, 	UsuarioID, 				CorreoEjecutivo, 		Comentario, 			ManejaCapPago,
										FormCapPago, 			FormCapPagoRes, 		ManejaCalendario, 		ReportaIncidencia,		ManejaFechaIniCal,
										CobraComisionApert,		CobraMora,              NoCuotasCobrar,			Referencia,				EmpresaID,
										Usuario,				FechaActual, 			DireccionIP, 			ProgramaID,				Sucursal,
										NumTransaccion)

			VALUES (					Var_HisConvenioNomID,	Var_FechaCambio,		date_format(Var_FechaCambio,'%H:%i:%s'),		Par_ConvenioNominaID,		Par_InstitNominaID,
										Par_Descripcion,		Par_FechaRegistro,		Par_ManejaVencimiento,	Par_FechaVencimiento,	Par_DomiciliacionPagos,
										Par_ClaveConvenio,		Par_Estatus,			Par_Resguardo,			Par_RequiereFolio,		Par_ManejaQuinquenios,
										Par_NumActualizaciones,	Par_UsuarioID,			Par_CorreoEjecutivo,	Par_Comentario,			Par_ManejaCapPago,
										Par_FormCapPago,		Par_FormCapPagoRes,		Par_ManejaCalendario,	Par_ReportaIncidencia,	Par_ManejaFechaIniCal,
										Par_CobraComisionApert,	Par_CobraMora,          Par_NoCuotasCobrar,		Par_Referencia,			Aud_EmpresaID,
										Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
										Aud_NumTransaccion
					);

		-- El registro se inserto exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Convenio registrado exitosamente: ', CAST(Par_ConvenioNominaID AS CHAR));
		SET Var_Control	:= 'convenioNominaID';
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
