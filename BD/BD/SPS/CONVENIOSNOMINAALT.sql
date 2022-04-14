-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SP CONVENIOSNOMINAALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `CONVENIOSNOMINAALT`;
DELIMITER $$

CREATE PROCEDURE `CONVENIOSNOMINAALT`(
-- ======================================================================================
-- STORED PROCEDURE PARA DAR DE ALTA LOS REGISTROS LOS CONVENIOS DE UNA EMPRESA DE NOMINA
-- ======================================================================================

	Par_InstitNominaID				INT(11),					-- Empresa de nomina a la cual pertenece el convenio
	Par_Descripcion					VARCHAR(150),				-- Descripcion del convenio de Nomina
	Par_FechaRegistro				DATE,						-- Fecha de registro del convenio
	Par_ManejaVencimiento			CHAR(1),					-- Indica si se manejara o no una fecha de vencimiento para el convenio S = "S" , N= "NO"
	Par_FechaVencimiento			DATE,						-- Fecha de vencimiento del convenio si el campo ManejaVencimiento tiene el valor S

	Par_DomiciliacionPagos			CHAR(1),					-- Forma de cobro para la aplicacion de pagos a facturas de un credito. S - Los creditos otorgados a este convenio se les cobrara comision por falta de pago si el producto de credito tiene parametrizado un esquema de comision por falta de pago N - No se cobrara comision por falta de pago
	Par_ClaveConvenio				VARCHAR(20),				-- Clave o numero de convenio contratado
	Par_Resguardo					DECIMAL(12,2),				-- campo utilizado para la capacidad de pago
	Par_RequiereFolio				CHAR(1),					-- Requiere Folio de la solicitud de Credito
	Par_ManejaQuinquenios			CHAR(1),					-- Se validan los quinquenios que lleva trabajado el cliente, S="SI", N="NO"

	Par_UsuarioID					INT(11),					-- Nombre del ejecutivo encargado del convenio
	Par_CorreoEjecutivo				TEXT,						-- Correo del ejecutivo
	Par_Comentario 					TEXT(150),					-- comentarios adicionales al convenio
	Par_ManejaCapPago				CHAR(1),					-- Considera la capacidad de pago para el convenio que se esté parametrizando, S= "SI", N="NO
	Par_FormCapPago 				VARCHAR(200),				-- Formula para las solictudes del flujo individual

	Par_DesFormCapPago				VARCHAR(500),				-- Descripcion del Formula para las solictudes del flujo individual
	Par_FormCapPagoRes				VARCHAR(200),				-- Formula para las solictudes del flujo renovacion, restructura o consolidacion
	Par_DesFormCapPagoRes			VARCHAR(500),				-- Descripcion del Formula para las solictudes del flujo renovacion, restructura o consolidacion
	Par_ManejaCalendario			CHAR(1),					-- Indica si maneja calendario S.-SI, N.-NO
	Par_ReportaIncidencia			CHAR(1),					-- Indica si reporta incidencias. S. SI. N- NO.

	Par_ManejaFechaIniCal			CHAR(1),					-- Indica si maneja fecha inicial S.-SI, N.-NO
	Par_CobraComisionApert		    CHAR(1),					-- Indica si cobra comisión por apertura S.-SI, N.-NO
	Par_CobraMora			        CHAR(1),					-- Indica si cobra un interés moratorio S.-SI, N.-NO
	Par_NoCuotasCobrar				INT(11),					-- Indica hasta cuantas cuotas puede cobrar cuando un credito tenga amortizaciones (facturas) atrasadas

	Par_Salida						CHAR(1),					-- Tipo de Salida
	INOUT Par_NumErr				INT(11),					-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error


	/* Parametros de Auditoria */
	Aud_EmpresaID 					INT(11),					-- Campo de Auditoria
	Aud_Usuario 					INT(11),					-- Campo de Auditoria
  	Aud_FechaActual 				DATETIME,					-- Campo de Auditoria
  	Aud_DireccionIP 				VARCHAR(15),				-- Campo de Auditoria
  	Aud_ProgramaID 					VARCHAR(50),				-- Campo de Auditoria
  	Aud_Sucursal 					INT(11),					-- Campo de Auditoria
  	Aud_NumTransaccion 				BIGINT(20)					-- Campo de Auditoria

)
TerminaStore:BEGIN

-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de control
	DECLARE Var_ConvenioNominaID		BIGINT UNSIGNED;	-- Variable para el identificador del convenio
	DECLARE Var_FechaSistema			DATE;				-- Fecha de sistema de PARAMETROSSIS
	DECLARE Var_UsuarioID				INT(11);			-- Numero de usuario de la tabla de USUARIOS
	DECLARE Var_Estatus					CHAR(1);
    DECLARE Var_Referencia				VARCHAR(20);			-- Numero Referencia para la recepcion de los depositos del convenio

	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(11);			-- Entero cero
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;				-- Fecha vacia
	DECLARE Var_SI						CHAR(1);			-- Salida si
	DECLARE Var_NO						CHAR(1);			-- Salida no
	DECLARE Est_Activo					CHAR(1);			-- Estatus activo
	DECLARE Var_NumIdentNomina			INT(11);			-- Numero que identifica si una empresa es de nomina

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;				-- Asignacion de entero cero
	SET Cadena_Vacia					:= '';				-- Asignacion de cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de fecha vacia
	SET Var_SI							:= 'S';				-- Salida si
	SET Var_NO							:= 'N';				-- Salida no
	SET Est_Activo						:= 'A';				-- Estatus activo
	SET Var_NumIdentNomina				:= 9;				-- Numero que identifica si una empresa es de nomina

	-- Valores por default
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Par_FechaRegistro				:= IFNULL(Par_FechaRegistro, Fecha_Vacia);
	SET Par_ManejaVencimiento			:= IFNULL(Par_ManejaVencimiento, Cadena_Vacia);
	SET Par_FechaVencimiento			:= IFNULL(Par_FechaVencimiento, Fecha_Vacia);
	SET Par_DomiciliacionPagos			:= IFNULL(Par_DomiciliacionPagos, Cadena_Vacia);

	SET Par_UsuarioID					:= IFNULL(Par_UsuarioID, Entero_Cero);
	SET Par_Comentario					:= IFNULL(Par_Comentario, Cadena_Vacia);

	SET Par_ManejaCapPago				:= IFNULL(Par_ManejaCapPago, Cadena_Vacia);
	SET Par_FormCapPago 				:= IFNULL(Par_FormCapPago, Cadena_Vacia);
	SET Par_DesFormCapPago				:= IFNULL(Par_DesFormCapPago, Cadena_Vacia);
	SET Par_FormCapPagoRes				:= IFNULL(Par_FormCapPagoRes, Cadena_Vacia);
	SET Par_DesFormCapPagoRes			:= IFNULL(Par_DesFormCapPagoRes, Cadena_Vacia);
   	SET Par_NoCuotasCobrar				:= IFNULL(Par_NoCuotasCobrar, Entero_Cero);
   	SET Par_CobraComisionApert			:= IFNULL(Par_CobraComisionApert, Cadena_Vacia);
   	SET Par_CobraMora       			:= IFNULL(Par_CobraMora, Cadena_Vacia);

    SET Var_Referencia					:= Var_NumIdentNomina;		-- Se agrega el Numero que identifica si una empresa es de nomina a la referencia

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CONVENIOSNOMINAALT');
			SET Var_Control = 'sqlException';
		END;

		-- Validaciones
		IF (Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El numero de empresa se encuentra vacio';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaRegistro = Fecha_Vacia) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'La fecha de registro se encuentra vacia';
			SET Var_Control := 'fechaRegistro';
			LEAVE ManejoErrores;
		END IF;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM PARAMETROSSIS;

		IF (Par_FechaRegistro <> Var_FechaSistema) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'La fecha de registro no coincide con la fecha de sistema';
			SET Var_Control := 'fechaRegistro';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ManejaVencimiento = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'Especifique si se manejara o no fecha de vencimiento';
			SET Var_Control := 'manejaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaVencimiento = Fecha_Vacia AND Par_ManejaVencimiento = Var_SI) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'La fecha de vencimiento esta vacia';
			SET Var_Control := 'manejaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaVencimiento < Var_FechaSistema AND Par_ManejaVencimiento = Var_SI) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen	:= 'La fecha de vencimiento no debe se menor que la fecha de sistema';
			SET Var_Control := 'fechaVencimiento';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_DomiciliacionPagos = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 008;
			SET Par_ErrMen	:= 'Especifique si se domiciliaran o no los pagos';
			SET Var_Control := 'domiciliacionPagos';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_UsuarioID = Entero_Cero) THEN
			SET Par_NumErr 	:= 010;
			SET Par_ErrMen	:= 'El numero de usuario se encuentra vacio';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;

		SELECT		UsuarioID
			INTO	Var_UsuarioID
			FROM USUARIOS
			WHERE	UsuarioID = Par_UsuarioID;

		IF (Par_UsuarioID <> Var_UsuarioID) THEN
			SET Par_NumErr 	:= 011;
			SET Par_ErrMen	:= 'El numero de usuario especificado no existe en la base de datos';
			SET Var_Control := 'ejecutivo';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_RequiereFolio = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 015;
			SET Par_ErrMen	:= 'Especifique si Requiere Folio';
			SET Var_Control := 'requiereFolio';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen	:= 'Especifique si Maneja Capacidad de Pago.';
			SET Var_Control := 'manejaCapacidad';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago NOT IN(Var_SI,Var_NO))THEN
			SET Par_NumErr 	:= 017;
			SET Par_ErrMen	:= 'Especifique el Campo Maneja Capacidad de Pago Valido.';
			SET Var_Control := 'manejaCapacidad';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ManejaCapPago = Var_SI) THEN
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

		IF(Par_CobraComisionApert = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen	:= 'Especifique si Cobra Comision por apertura.';
			SET Var_Control := 'cobraComisionApert';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CobraMora = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 016;
			SET Par_ErrMen	:= 'Especifique si Cobra Interés Moratorio.';
			SET Var_Control := 'cobraMora';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_DomiciliacionPagos = Var_SI AND Par_NoCuotasCobrar <= Entero_Cero) THEN
			SET Par_NumErr 	:= 020;
			SET Par_ErrMen	:= 'Especifique el numero de cuotas a cobrar';
			SET Var_Control := 'fechaProgramada';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ReportaIncidencia NOT IN(Var_SI,Var_NO))THEN
			SET Par_NumErr 	:= 021;
			SET Par_ErrMen	:= 'Especifique el Campo Reporta Incidencia.';
			SET Var_Control := 'reportaIncidencia';
			LEAVE ManejoErrores;
		END IF;


		CALL FOLIOSAPLICAACT('CONVENIOSNOMINA', Var_ConvenioNominaID);

        SET Var_Referencia := CONCAT(Var_Referencia,(SELECT LPAD(Par_InstitNominaID, 4, 0)),(SELECT LPAD(Var_ConvenioNominaID, 2, 0)));

		INSERT INTO CONVENIOSNOMINA (	ConvenioNominaID,		InstitNominaID,			FechaRegistro,			ManejaVencimiento,		FechaVencimiento,
										DomiciliacionPagos,		ClaveConvenio,			Estatus,				Resguardo,				RequiereFolio,
										ManejaQuinquenios,		UsuarioID,				CorreoEjecutivo,		Comentario,				ManejaCapPago,
										FormCapPago,			DesFormCapPago,			FormCapPagoRes,			DesFormCapPagoRes,		ManejaCalendario,
										ReportaIncidencia,		CobraComisionApert,     CobraMora,              ManejaFechaIniCal,		NumActualizaciones,
										Descripcion,			NoCuotasCobrar,			Referencia,             EmpresaID,				Usuario,
										FechaActual,			DireccionIP,			ProgramaID,             Sucursal,				NumTransaccion)

							 VALUES (	Var_ConvenioNominaID,	Par_InstitNominaID,		Par_FechaRegistro,		Par_ManejaVencimiento,	Par_FechaVencimiento,
										Par_DomiciliacionPagos,	Par_ClaveConvenio,		Est_Activo,				Par_Resguardo,			Par_RequiereFolio,
										Par_ManejaQuinquenios,	Par_UsuarioID,			Par_CorreoEjecutivo,	Par_Comentario,			Par_ManejaCapPago,
										Par_FormCapPago,		Par_DesFormCapPago,		Par_FormCapPagoRes,		Par_DesFormCapPagoRes,	Par_ManejaCalendario,
										Par_ReportaIncidencia,	Par_CobraComisionApert, Par_CobraMora,          Par_ManejaFechaIniCal,	Entero_Cero,
										Par_Descripcion,		Par_NoCuotasCobrar,		Var_Referencia,         Aud_EmpresaID,			Aud_Usuario,
										Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		-- El registro se inserto exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Convenio registrado exitosamente: ', CAST(Var_ConvenioNominaID AS CHAR));
		SET Var_Control	:= 'convenioNominaID';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Var_ConvenioNominaID	AS consecutivo;
	END IF;
-- Fin del SP

END TerminaStore$$
