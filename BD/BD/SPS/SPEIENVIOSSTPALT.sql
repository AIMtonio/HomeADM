DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSSTPALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSSTPALT`(
	-- STORED PROCEDURE ENCARGADO DE REALIZAR EL ALTA DE LAS ORDENES DE PAGO PARA STP
	INOUT Par_Folio				BIGINT(20),		-- Identificador unico de los registros de la tabla
	INOUT Par_ClaveRastreo		VARCHAR(30),	-- Clave de rastreo generada para el envio de la orden de pago
	Par_TipoPago				INT(2),			-- Tipo de Pago segun el Catalogo TIPOSPAGOSPEI
	Par_CuentaAhoID				BIGINT(12),		-- Cuenta de ahorro del beneficiario segun el Catalogo CUENTASAHO
	Par_TipoCuentaOrd			INT(2),			-- Tipo de Cuenta del Ordenante segun el Catalogo TIPOSCUENTASPEI

	Par_CuentaOrd				VARCHAR(20),	-- Cuenta Clabe del Ordenante
	Par_NombreOrd				VARCHAR(100),	-- Nombre del Ordenante
	Par_RFCOrd					VARCHAR(18),	-- RFC del Ordenante
	Par_MonedaID				INT(11),		-- Tipo de Moneda de la Cuenta de Ahorro segun el Catalogo MONEDAS
	Par_TipoOperacion			INT(2),			-- Tipo de Operacion

	Par_MontoTransferir			DECIMAL(16,2),	-- Monto a transferir
	Par_IVAPorPagar				DECIMAL(16,2),	-- IVA por Pagar. Para STP debera ser 0
	Par_ComisionTrans			DECIMAL(16,2),	-- Comision de transferencia
	Par_IVAComision				DECIMAL(16,2),	-- IVA de la comision de transferencia
	Par_InstiRemitente			INT(5),			-- Institucion del Remitente segun el Catalogo INSTITUCIONESSPEI

	Par_TotalCargoCuenta		DECIMAL(18,2),	-- Total del Cargo a la Cuenta
	Par_InstiReceptora			INT(5),			-- Institucion Receptora segun el Catalogo INSTITUCIONESSPEI
	Par_CuentaBeneficiario		VARCHAR(20),	-- Cuenta Clabe del Beneficiario
	Par_NombreBeneficiario		VARCHAR(100),	-- Nombre del Beneficiario
	Par_RFCBeneficiario			VARCHAR(18),	-- RFC del Beneficiario

	Par_TipoCuentaBen			INT(2),			-- Tipo de Cuenta del Beneficiario segun el Catalogo TIPOSCUENTASPEI
	Par_ConceptoPago			VARCHAR(40),	-- Concepto de pago
	Par_CuentaBenefiDos			VARCHAR(20),	-- Cuenta del segundo beneficiario
	Par_NombreBenefiDos			VARCHAR(100),	-- Nombre del segundo beneficiario
	Par_RFCBenefiDos			VARCHAR(18),	-- RFC del segundo beneficiario

	Par_TipoCuentaBenDos		INT(2),			-- Tipo de Cuenta del segundo beneficiario segun el Catalogo TIPOSCUENTASPEI
	Par_ConceptoPagoDos			VARCHAR(40),	-- Concepto de pago para el segundo beneficiario
	Par_ReferenciaCobranza		VARCHAR(40),	-- Referencia de Cobranza
	Par_ReferenciaNum			INT(7),			-- Referencia numerica
	Par_PrioridadEnvio			INT(1),			-- Prioridad de envio. En caso de STP siempre sera 1

	Par_FechaAutorizacion		DATETIME,		-- Fecha de autorizacion
	Par_EstatusEnv				INT(3),			-- Estatus del envio segun el Catalogo ESTADOSENVIOSPEI
	Par_ClavePago				VARCHAR(10),	-- Clave de pago
	Par_UsuarioEnvio			VARCHAR(30),	-- Usuario que realiza la tranferencia
	Par_AreaEmiteID				INT(2),			-- Area que emite la transferencia segun el Catalogo AREASEMITESPEI

	Par_Estatus					CHAR(1),		-- Estatus del envio definido por el SAFI. P)Pendiente por autorizar, A)Autorizada, C)Cancelada, T)Detenida, V)Verificada para Envio, E)Enviada, D)Devuelta
	Par_FechaRecepcion			DATETIME,		-- Fecha de recepcion
	Par_FechaEnvio				DATETIME,		-- Fecha de envio
	Par_CausaDevol				INT(2),			-- Causa de la Devolucion segun el Catalogo CAUSASDEVSPEI
	Par_Firma					VARCHAR(1000),	-- Firma encriptada por la transferencia

	Par_FolioSTP				BIGINT(20),		-- Folio regresado por el ws del envio de la orden de pago a STP
	Par_OrigenOperacion			CHAR(1),		-- Indica si la Operacion se Origina en V) Ventanilla, B) Banca Movil o C) ClienteSpei
	Par_Salida					CHAR(1),		-- Indica si el SP devuelve el resultado de la operacion
	INOUT Par_NumErr			INT,			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje del error

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria

	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero			INT;			-- Entero Cero
	DECLARE Decimal_Cero		DECIMAL(18,2);	-- Decimal _cero
	DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE Salida_SI			CHAR(1);		-- Salida si
	DECLARE Salida_NO			CHAR(1);		-- Salida no
	DECLARE PrioridadUno		INT(1);			-- Prioridad con Valor 1
	DECLARE Tp_tt				INT(2);			-- Tipo de Pago Tercero a Tercero
	DECLARE tipoCtaClabe		INT(2);			-- Tipo de cuenta clabe
	DECLARE tipoCtaTar			INT(2);			-- Tipo de cuenta tarjeta debito
	DECLARE tipoCtaTel			INT(2);			-- Tipo de cuenta telefonia movil
	DECLARE Fecha_Sist			DATE;			-- Fecha Sistema
	DECLARE ImporteMaximo		DECIMAL(20,2);	-- Importe maximo para tranferir spei
	DECLARE LongitudCta			INT(18);		-- Longitud de la cuenta del beneficiario
	DECLARE LongClabe			INT(2);			-- Longitud de la CLABE
	DECLARE LongTarjeta			INT(2);			-- Longitud de la tarjeta
	DECLARE LongCel				INT(2);			-- Longitud del numero telefonico movil
	DECLARE Var_TipoPerFis		CHAR(1);		-- Tipo de Persona fisica
	DECLARE Var_TipoPerAct		CHAR(1);		-- Tipo de Persona fisica con Actividad empresarial
	DECLARE Var_TipoPerMor		CHAR(1);		-- Tipo de Persona moral
	DECLARE Est_clabeAut		CHAR(1);		-- Estatus de Cuenta CLABE Autorizada

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(200);	-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);		-- Variable consecutivo
	DECLARE Var_FechaCan		DATETIME;		-- Fecha de cancelacion
	DECLARE Var_Comentario		VARCHAR(500);	-- Comentario de cancelacion
	DECLARE Var_FolRefNum		VARCHAR(17);	-- Folio y referencia numerica entero
	DECLARE Var_RefNum			VARCHAR(17);	-- Folio y referencia numerica entero
	DECLARE fecha				CHAR(8);		-- Fecha
	DECLARE claveEmisor			INT(3);			-- Clave del emisor
	DECLARE Var_MonReqVen		DECIMAL(18,2);	-- Monto a partir del cual spei necesita autorizacion de tesoreria
	DECLARE Var_AutTeso			CHAR(1);		-- Si el spei necesita autorizacion de tesoreria
	DECLARE Var_FechaOpe		DATE;			-- Fecha operacion
	DECLARE Var_UsuarioAut		INT(11);		-- Usuario autoriza
	DECLARE Var_UsuarioVer		INT(11);		-- Usuario Verifica
	DECLARE Var_FechaVer		DATETIME;		-- Fecha de verificacion
	DECLARE Var_TipoPago		INT(2);			-- Tipo de Pago - Catalogo TIPOSPAGOSPEI
	DECLARE Var_EstatusPago		CHAR(1);		-- Estatus de tipo de pago
	DECLARE Est_Activo			CHAR(1);		-- Estatus activo
	DECLARE Est_Pendiente		CHAR(1);		-- Estatus Pendiente por autorizar
	DECLARE Est_Autorizado		CHAR(1);		-- Estatus Autorizado
	DECLARE Est_Cancelado		CHAR(1);		-- Estatus Cancelado
	DECLARE Est_Detenido		CHAR(1);		-- Estatus Detenido
	DECLARE Est_Verificado		CHAR(1);		-- Estatus Verificado para Envio
	DECLARE Est_Enviado			CHAR(1);		-- Estatus Enviado
	DECLARE Est_Devuelto		CHAR(1);		-- Estatus Devuelto
	DECLARE Var_InstRemite		INT(5);			-- Institucion del Remitente - Catalogo INSTITUCIONESSPEI
	DECLARE Var_InstRecep		INT(5);			-- Institucion Receptora - Catalogo INSTITUCIONESSPEI
	DECLARE Var_AreaEmite		INT(2);			-- Area que emite el pago - Catalogo AREASEMITESPEI
	DECLARE Var_CuentaAhoExist	BIGINT(12);		-- Indicador de que existe la Cuenta de Ahorro
	DECLARE Var_ClienteExist	INT(11);		-- Indicador de que existe el cliente de la Cuenta de Ahorro
	DECLARE Var_TipoCtaOrdExis	INT(2);			-- Indicador de que existe el Tipo de Cuenta Ordenante - Catalogo TIPOSCUENTASPEI
	DECLARE Var_TipoCtaBenExis	INT(2);			-- Indicador de que existe el Tipo de Cuenta Receptora - Catalogo TIPOSCUENTASPEI
	DECLARE Var_TipoMonedaExis	INT(11);		-- Indicador de que existe el tipo de moneda - Catalogo MONEDAS
	DECLARE Var_MonedaCtaAho	INT(11);		-- Valida que el tipo de moneda corresponde a la cuenta de ahorro ingresada
	DECLARE Var_CuentaClabe		VARCHAR(18);	-- Cuenta Clabe
	DECLARE Var_TipoPersonaCli	VARCHAR(1);		-- Tipo de Persona
	DECLARE Var_EstatusClabe	CHAR(1);		-- Estatus de la cuenta CLABE
	DECLARE Var_FolioEnvio		BIGINT(20);		-- FolioID de envio

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal cero
	SET Salida_SI 	   		:= 'S';				-- Salida SI
	SET Salida_NO			:= 'N';				-- Salida NO
	SET Par_NumErr			:= 0;				-- Parametro numero de error
	SET Par_ErrMen			:= '';				-- Parametro Mensaje de error
	SET Est_Activo			:= 'A';				-- Estatus Activo del Tipo de Pago
	SET Est_Pendiente		:= 'P';				-- Estatus Pendiente por autorizar
	SET Est_Autorizado		:= 'A';				-- Estatus Autorizado
	SET Est_Cancelado		:= 'C';				-- Estatus Cancelado
	SET Est_Detenido		:= 'T';				-- Estatus Detenido
	SET Est_Verificado		:= 'V';				-- Estatus Verificado para Envio
	SET Est_Enviado			:= 'E';				-- Estatus Enviado
	SET Est_Devuelto		:= 'D';				-- Estatus Devuelto
	SET PrioridadUno		:= 1;				-- Prioridad con Valor 1
	SET Tp_tt				:= 1;				-- Tipo de Pago Tercero a Tercero
	SET tipoCtaClabe		:= 40;				-- tipo de cuenta clabe
	SET tipoCtaTar			:= 3;				-- tipo de cuenta tarjeta debito
	SET tipoCtaTel			:= 10;				-- tipo de cuenta telefonia movil
	SET ImporteMaximo   	:= 999999999999.99;	-- importe maximo para las transferencias spei
	SET LongClabe			:= 18;				-- Longitud de la CLABE
	SET LongTarjeta			:= 16;				-- Longitud de la tarjeta
	SET LongCel				:= 10;				-- Longitud del numero telefonico movil
	SET Var_TipoPerFis		:= 'F';				-- Tipo de Persona fisica
	SET Var_TipoPerAct		:= 'A';				-- Tipo de Persona fisica con actividad empresarial
	SET Var_TipoPerMor		:= 'M';				-- Tipo de Persona moral
	SET Est_clabeAut		:= 'A';				-- Estatus de Cuenta CLABE Autorizada

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSSTPALT');
				SET Var_Control	:= 'sqlException';
			END;

		-- Se inicializan todos los parametros
		SET Par_TipoPago			:= IFNULL(Par_TipoPago, Entero_Cero);
		SET Par_CuentaAhoID			:= IFNULL(Par_CuentaAhoID, Entero_Cero);
		SET Par_TipoCuentaOrd		:= IFNULL(Par_TipoCuentaOrd, Entero_Cero);
		SET Par_CuentaOrd			:= IFNULL(Par_CuentaOrd, Cadena_Vacia);
		SET Par_NombreOrd			:= IFNULL(Par_NombreOrd, Cadena_Vacia);
		SET Par_MonedaID			:= IFNULL(Par_MonedaID, Entero_Cero);
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);
		SET Par_MontoTransferir		:= IFNULL(Par_MontoTransferir, Decimal_Cero);
		SET Par_ComisionTrans		:= IFNULL(Par_ComisionTrans, Decimal_Cero);
		SET Par_IVAComision			:= IFNULL(Par_IVAComision, Decimal_Cero);
		SET Par_InstiRemitente		:= IFNULL(Par_InstiRemitente, Entero_Cero);
		SET Par_TotalCargoCuenta	:= IFNULL(Par_TotalCargoCuenta, Decimal_Cero);
		SET Par_InstiReceptora		:= IFNULL(Par_InstiReceptora, Entero_Cero);
		SET Par_CuentaBeneficiario	:= IFNULL(Par_CuentaBeneficiario, Cadena_Vacia);
		SET Par_NombreBeneficiario	:= IFNULL(Par_NombreBeneficiario, Cadena_Vacia);
		SET Par_TipoCuentaBen		:= IFNULL(Par_TipoCuentaBen, Entero_Cero);
		SET Par_ConceptoPago		:= IFNULL(Par_ConceptoPago, Cadena_Vacia);
		SET Par_ReferenciaNum		:= IFNULL(Par_ReferenciaNum, Entero_Cero);
		SET Par_FechaAutorizacion	:= IFNULL(Par_FechaAutorizacion, Fecha_Vacia);
		SET Par_EstatusEnv			:= IFNULL(Par_EstatusEnv, Entero_Cero);
		SET Par_UsuarioEnvio		:= IFNULL(Par_UsuarioEnvio, Cadena_Vacia);
		SET Par_AreaEmiteID			:= IFNULL(Par_AreaEmiteID, Entero_Cero);
		SET Par_Estatus				:= IFNULL(Par_Estatus, Cadena_Vacia);
		SET Par_FechaRecepcion		:= IFNULL(Par_FechaRecepcion, Fecha_Vacia);
		SET Par_FechaEnvio			:= IFNULL(Par_FechaEnvio, Fecha_Vacia);
		SET Par_CausaDevol			:= IFNULL(Par_CausaDevol, Entero_Cero);
		SET Par_Firma				:= IFNULL(Par_Firma, Cadena_Vacia);
		SET Par_FolioSTP			:= IFNULL(Par_FolioSTP, Entero_Cero);
		SET Par_OrigenOperacion		:= IFNULL(Par_OrigenOperacion, Cadena_Vacia);
		SET Par_Salida				:= IFNULL(Par_Salida, Salida_SI);

		-- Los Datos del Beneficiario Dos siempre se enviaran vacios
		SET Par_CuentaBenefiDos 	:= IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos 	:= IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos 		:= IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos 	:= IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos		:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);

		-- El IVA siempre se enviara como vacio
		SET Par_IVAPorPagar			:= IFNULL(Par_IVAPorPagar, Decimal_Cero);

		-- La Referencia de Cobranza siempre se enviara vacio
		SET Par_ReferenciaCobranza	:= IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

		-- La Prioridad de Envio para STP siempre sera 1
		SET Par_PrioridadEnvio		:= IFNULL(Par_PrioridadEnvio, PrioridadUno);

		-- La Clabe de Pago siempre se enviara vacia
		SET Par_ClavePago			:= IFNULL(Par_ClavePago, Cadena_Vacia);

		-- Si los RFC'S del ordenante o beneficiario viene vacio se setea con cadena vacia
		SET Par_RFCOrd 			:= IFNULL(Par_RFCOrd, Cadena_Vacia);
		SET Par_RFCBeneficiario := IFNULL(Par_RFCBeneficiario, Cadena_Vacia);

		IF(Par_TipoPago = Entero_Cero) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Tipo de Pago esta Vacio.';
			SET Var_Control	:= 'tipoPago';
			LEAVE ManejoErrores;
		END IF;

		-- Se valida que exista el Tipo de Pago
		SET Var_TipoPago	:= (SELECT	TipoPagoID
									FROM TIPOSPAGOSPEI
									WHERE	TipoPagoID = Par_TipoPago);

		SET Var_TipoPago	:= IFNULL(Var_TipoPago, Entero_Cero);

		IF(Var_TipoPago = Entero_Cero) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Tipo de Pago [', Par_TipoPago, ']no Existe');
			SET Var_Control	:= 'tipoPago';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPago != Tp_tt) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Tipo de Pago para STP solo puede ser de Tercero a Tercero';
			SET Var_Control	:= 'tipoPago';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Estatus != Est_Pendiente AND Par_Estatus != Est_Autorizado AND Par_Estatus != Est_Cancelado AND Par_Estatus != Est_Detenido AND
			Par_Estatus != Est_Verificado AND Par_Estatus != Est_Enviado AND Par_Estatus != Est_Devuelto) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= CONCAT('El Estatus [', Par_Estatus, '] no esta permitido');
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Var_EstatusPago	:= (SELECT Estatus
									FROM TIPOSPAGOSPEI
									WHERE TipoPagoID = Par_TipoPago);
		SET Var_EstatusPago	:= IFNULL(Var_EstatusPago, Cadena_Vacia);

		IF(Var_EstatusPago != Est_Activo) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen 	:= CONCAT('Tipo de pago [', Par_TipoPago, '] no esta activo.');
			SET Var_Control	:= 'EstatusPago';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de las Instituciones
		SET Var_InstRemite	:= (SELECT InstitucionID
									FROM INSTITUCIONESSPEI
									WHERE InstitucionID = Par_InstiRemitente);
		SET Var_InstRemite	:= IFNULL(Var_InstRemite, Entero_Cero);

		IF(Var_InstRemite = Entero_Cero) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= 'La Institucion Remitente no existe en el catalogo[INSTITUCIONESSPEI].';
			SET Var_Control	:= 'InstiRemitente';
			LEAVE ManejoErrores;
		END IF;

		SET Var_InstRecep	:= (SELECT InstitucionID
									FROM INSTITUCIONESSPEI
									WHERE InstitucionID = Par_InstiReceptora);
		SET Var_InstRecep	:= IFNULL(Var_InstRecep, Entero_Cero);

		IF(Var_InstRecep = Entero_Cero) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= 'La Institucion Receptora no existe en el catalogo[INSTITUCIONESSPEI].';
			SET Var_Control	:= 'InstiReceptora';
			LEAVE ManejoErrores;
		END IF;

		SET Var_AreaEmite	:= (SELECT AreaEmiteID
									FROM AREASEMITESPEI
									WHERE AreaEmiteID = Par_AreaEmiteID);
		SET Var_AreaEmite	:= IFNULL(Var_AreaEmite, Entero_Cero);

		IF(Var_AreaEmite = Entero_Cero) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'El Area que Emite no existe en el catalogo[AREASEMITESPEI].';
			SET Var_Control	:= 'AreaEmite';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPago != Entero_Cero) THEN
			-- Se valida la CuentaAho
			IF(Par_CuentaAhoID = Entero_Cero) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'La Cuenta de Ahorro esta Vacia.';
				SET Var_Control	:= 'cuentaAho';
				LEAVE ManejoErrores;
			END IF;

			-- Que la cuenta Exista en la tabla CuentasAho
			SET Var_CuentaAhoExist	:= (SELECT CuentaAhoID
											FROM CUENTASAHO
											WHERE CuentaAhoID = Par_CuentaAhoID);
			SET Var_CuentaAhoExist	:= IFNULL(Var_CuentaAhoExist, Entero_Cero);

			IF(Var_CuentaAhoExist = Entero_Cero) THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= CONCAT('La Cuenta [', Par_CuentaAhoID, '] no Existe');
				SET Var_Control	:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para el tipo de moneda
			SET Var_TipoMonedaExis	:= (SELECT MonedaID
											FROM MONEDAS
											WHERE MonedaID = Par_MonedaID);
			SET Var_TipoMonedaExis	:= IFNULL(Var_TipoMonedaExis, Entero_Cero);

			IF(Var_TipoMonedaExis = Entero_Cero) THEN
				SET Par_NumErr	:= 011;
				SET Par_ErrMen	:= 'El Tipo de Moneda no existe en el catalogo[MONEDAS]';
				SET Var_Control	:= 'MonedaID';
				LEAVE ManejoErrores;
			END IF;

			-- Se valida que el tipo de moneda corresponde al tipo de moneda de la cuenta de ahorro
			SELECT 		Mon.MonedaID,				Cue.Clabe
				INTO 	Var_MonedaCtaAho,			Var_CuentaClabe
				FROM CUENTASAHO Cue
				INNER JOIN MONEDAS Mon ON Cue.MonedaID = Mon.MonedaID
				WHERE Cue.CuentaAhoID = Par_CuentaAhoID;
			SET Var_MonedaCtaAho	:= IFNULL(Var_MonedaCtaAho, Entero_Cero);

			IF(Var_MonedaCtaAho = Entero_Cero OR Var_MonedaCtaAho <> Par_MonedaID) THEN
				SET Par_NumErr	:= 012;
				SET Par_ErrMen	:= 'La Moneda no corresponde con la de la Cuenta de Ahorro';
				SET Var_Control	:= 'MonedaID';
				LEAVE ManejoErrores;
			END IF;

			-- Que el cliente Exista en la tabla Clientes
			SELECT 		CL.ClienteID,			CL.TipoPersona
				INTO 	Var_ClienteExist,		Var_TipoPersonaCli
				FROM CUENTASAHO CA
				INNER JOIN CLIENTES CL ON CA.ClienteID = CL.ClienteID
				WHERE CuentaAhoID = Par_CuentaAhoID;
			SET Var_ClienteExist := IFNULL(Var_ClienteExist, Entero_Cero);

			IF(Var_ClienteExist = Entero_Cero) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= 'El Cliente no Existe';
				SET Var_Control	:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPersonaCli IN (Var_TipoPerFis, Var_TipoPerAct)) THEN
				SELECT 		Estatus
					INTO 	Var_EstatusClabe
					FROM SPEICUENTASCLABEPFISICA
					WHERE CuentaClabe = Var_CuentaClabe;

				IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:= 013;
					SET Par_ErrMen	:= 'No se encontro informacion de la Cuenta CLABE ligada a la cuenta de ahorro.';
					SET Var_Control	:= 'MonedaID';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) <> Est_clabeAut) THEN
					SET Par_NumErr	:= 014;
					SET Par_ErrMen	:= 'La Cuenta CLABE ligada a la cuenta de ahorro no se encuentra autorizada.';
					SET Var_Control	:= 'MonedaID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Var_TipoPersonaCli = Var_TipoPerMor) THEN
				SELECT 		Estatus
					INTO 	Var_EstatusClabe
					FROM SPEICUENTASCLABPMORAL
					WHERE CuentaClabe = Var_CuentaClabe;

				IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr	:= 013;
					SET Par_ErrMen	:= 'No se encontro informacion de la Cuenta CLABE ligada a la cuenta de ahorro.';
					SET Var_Control	:= 'MonedaID';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) <> Est_clabeAut) THEN
					SET Par_NumErr	:= 014;
					SET Par_ErrMen	:= 'La Cuenta CLABE ligada a la cuenta de ahorro no se encuentra autorizada.';
					SET Var_Control	:= 'MonedaID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Llamada a la Funcion de Validacion de Caracteres Spei
			-- Validaciones para el Ordenante
			SET Par_NumErr	:= FNVALIDACARACSPEI(Par_NombreOrd);

			IF(Par_NumErr = 100) THEN
				SET Par_NumErr	:= 015;
				SET Par_ErrMen	:= 'Caracter invalido';
				SET Var_Control	:= 'NombreOrd';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= FNVALIDACARACSPEI(Par_RFCOrd);

			IF( Par_NumErr = 100) THEN
				SET Par_NumErr	:= 016;
				SET Par_ErrMen	:= 'Caracter invalido';
				SET Var_Control	:= 'RFCOrd';
				LEAVE ManejoErrores;
			END IF;

			-- Validaciones para el Beneficiario Uno
			SET Par_NumErr	:= FNVALIDACARACSPEI(Par_NombreBeneficiario);

			IF(Par_NumErr = 100) THEN
				SET Par_NumErr	:= 017;
				SET Par_ErrMen	:= 'Caracter invalido';
				SET Var_Control	:= 'NombreBeneficiario';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= FNVALIDACARACSPEI(Par_RFCBeneficiario);

			IF(Par_NumErr = 100) THEN
				SET Par_NumErr	:= 018;
				SET Par_ErrMen	:= 'Caracter invalido';
				SET Var_Control	:= 'RFCBeneficiario';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= FNVALIDACARACSPEI(Par_ConceptoPago);
			IF(Par_NumErr = 100) THEN
				SET Par_NumErr	:= 019;
				SET Par_ErrMen	:= 'Caracter invalido';
				SET Var_Control	:= 'conceptoPago';
				LEAVE ManejoErrores;
			END IF;

			-- Validaciones para el Tipo de Pago Tercero a Tercero
			IF(Par_TipoPago = Tp_tt) THEN
				IF(Par_NombreOrd = Cadena_Vacia) THEN
					SET Par_NumErr	:= 020;
					SET Par_ErrMen	:= 'El Nombre del Ordenante esta Vacio.';
					SET Var_Control	:= 'nombreOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_TipoCuentaOrd = Entero_Cero) THEN
					SET Par_NumErr	:= 021;
					SET Par_ErrMen	:= 'El Tipo de Cuenta Ordenante esta Vacio.';
					SET Var_Control	:= 'tipoCuentaOrd';
					LEAVE ManejoErrores;
				END IF;

				-- Que el Tipo de Cuenta del Ordenante Exista en la tabla TiposCuentaSpei
				SET Var_TipoCtaOrdExis	:= (SELECT TipoCuentaID
												FROM TIPOSCUENTASPEI
												WHERE TipoCuentaID = Par_TipoCuentaOrd);
				SET Var_TipoCtaOrdExis	:= IFNULL(Var_TipoCtaOrdExis, Entero_Cero);

				IF(Var_TipoCtaOrdExis = Entero_Cero) THEN
					SET Par_NumErr	:= 022;
					SET Par_ErrMen	:= CONCAT('El Tipo de Cuenta [', Par_TipoCuentaOrd, '] no existe en el catalogo[TIPOSCUENTASPEI]');
					SET Var_Control	:= 'tipoCuentaOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_CuentaOrd = Cadena_Vacia) THEN
					SET Par_NumErr	:= 023;
					SET Par_ErrMen	:= 'La Cuenta Ordenante esta Vacio.';
					SET Var_Control	:= 'cuentaOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_RFCOrd = Cadena_Vacia) THEN
					SET Par_NumErr	:= 024;
					SET Par_ErrMen	:= 'El RFC del Ordenante esta Vacio.';
					SET Var_Control	:= 'RFCOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_NombreBeneficiario = Cadena_Vacia) THEN
					SET Par_NumErr	:= 025;
					SET Par_ErrMen	:= 'El Nombre del Beneficiario esta Vacio.';
					SET Var_Control	:= 'nombreBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_CuentaBeneficiario = Entero_Cero) THEN
					SET Par_NumErr	:= 026;
					SET Par_ErrMen	:= 'La Cuenta del Beneficiario esta Vacia.';
					SET Var_Control	:= 'cuentaBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_TipoCuentaBen = Entero_Cero) THEN
					SET Par_NumErr	:= 027;
					SET Par_ErrMen	:= 'El Tipo de Cuenta del Beneficiario esta Vacio.';
					SET Var_Control	:= 'tipoCuentaBen';
					LEAVE ManejoErrores;
				END IF;

				-- Si el Tipo De Cuenta Existe en la tabla TiposCuentaSpei
				SET Var_TipoCtaBenExis	:= (SELECT TipoCuentaID
												FROM TIPOSCUENTASPEI
												WHERE TipoCuentaID = Par_TipoCuentaBen);
				SET Var_TipoCtaBenExis	:= IFNULL(Var_TipoCtaBenExis, Entero_Cero);

				IF(Var_TipoCtaBenExis = Entero_Cero) THEN
					SET Par_NumErr	:= 028;
					SET Par_ErrMen	:= CONCAT('El Tipo de Cuenta [', Par_TipoCuentaBen, '] no Existe');
					SET Var_Control	:= 'tipoCuentBen';
					LEAVE ManejoErrores;
				END IF;

				-- Validacion Tipo de Cuenta y Cuenta del Beneficiario Uno
				IF((Par_TipoCuentaBen != Entero_Cero AND LENGTH(Par_CuentaBeneficiario) != Entero_Cero)) THEN
					-- Si la Cuenta es Cuenta Clabe
					IF(Par_TipoCuentaBen = tipoCtaClabe) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,char(18)))));
						IF(LongitudCta != LongClabe) THEN
							SET Par_NumErr	:= 029;
							SET Par_ErrMen	:= CONCAT('El numero de caracteres no coincide para la CLABE. [', Par_CuentaBeneficiario, ']');
							SET Var_Control	:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TARJETA
					IF(Par_TipoCuentaBen = tipoCtaTar) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(16)))));
						IF(LongitudCta != LongTarjeta) THEN
							SET Par_NumErr	:= 030;
							SET Par_ErrMen	:= 'El numero de caracteres no coincide para el numero de Tarjeta.';
							SET Var_Control	:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
					IF(Par_TipoCuentaBen = tipoCtaTel) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(10)))));
						IF(LongitudCta != LongCel) THEN
							SET Par_NumErr	:= 031;
							SET Par_ErrMen	:= 'El numero de caracteres no coincide con el numero de tel. movil.';
							SET Var_Control	:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				IF(Par_ConceptoPago = Cadena_Vacia) THEN
					SET Par_NumErr	:= 032;
					SET Par_ErrMen	:= 'El Concepto de Pago esta Vacio.';
					SET Var_Control	:= 'conceptoPago';
					LEAVE ManejoErrores;
				END IF;


				IF(Par_MontoTransferir = Decimal_Cero) THEN
					SET Par_NumErr	:= 033;
					SET Par_ErrMen	:='El Monto a Transferir esta Vacio.';
					SET Var_Control	:=  'montoTransferir';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_MontoTransferir != Decimal_Cero) THEN
					IF(Par_MontoTransferir > ImporteMaximo) THEN
						SET Par_NumErr	:= 034;
						SET Par_ErrMen	:= 'El Monto a Transferir es mayor al monto permitido.';
						SET Var_Control	:= 'montoTransferir';
						LEAVE ManejoErrores;
					ELSE
						IF(Par_MontoTransferir < Decimal_Cero) THEN
							SET Par_NumErr	:= 035;
							SET Par_ErrMen	:= 'El Monto a Transferir no puede ser negativo.';
							SET Var_Control	:= 'montoTransferir';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				IF(Par_UsuarioEnvio = Cadena_Vacia) THEN
					SET Par_NumErr	:= 036;
					SET Par_ErrMen	:= 'El Usuario que envia la Operacion esta vacio.';
					SET Var_Control	:=  'usuarioEnvio';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- Fecha de Cancelacion
		SET Var_FechaCan := Fecha_Vacia;

		-- Comentario de Cancelacion
		SET Var_Comentario := Cadena_Vacia;

		-- Se setea el Valor del Folio de Parametros Incrementando en 1
		SET Par_Folio	:= (SELECT IFNULL(MAX(FolioSpeiID),Entero_Cero) + 1
								FROM SPEIENVIOS);

		SET Var_FolioEnvio	:= (SELECT IFNULL(MAX(FolioEnvio),Entero_Cero) + 1
								FROM PARAMETROSSPEI);

		-- Se actualiza el campo en la tabla PARAMETROSSPEI
		IF(Par_Folio < Var_FolioEnvio) THEN
			SET Par_Folio := Var_FolioEnvio;
		END IF;


		UPDATE PARAMETROSSPEI
			SET FolioEnvio = Par_Folio;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		-- se setea la fecha de operacion fecha del sistema
		SELECT	FechaSistema
		INTO	Fecha_Sist
			FROM PARAMETROSSIS;
		SET Var_FechaOpe := Fecha_Sist;

		-- Forma Clave de Rastreo  solo cuando el Tipo de Pago no sea una Devolucion
		IF(Par_TipoPago != Entero_Cero) THEN
			SELECT	ParticipanteSpei,	DATE_FORMAT(FechaApertura,'%Y%m%d'),	MonReqAutTeso,	SpeiVenAutTes
			INTO	claveEmisor,		fecha, 									Var_MonReqVen,	Var_AutTeso
				FROM PARAMETROSSPEI;

			SET Var_FolRefNum := LTRIM(RTRIM(CONVERT(Par_Folio,CHAR(17))));

			-- SI LA REFERENCIA NUMERICA ES DIFERENTE DE VACIA ENTONCES AGREGA A LA CLAVE DE RASTREO -N DESPUES DEL FOLIO
			IF(Par_ReferenciaNum != Entero_Cero) THEN
				-- Si le longitud es mayor a 17 digitos se obtiene con un substring solo 17
				SET Var_FolRefNum := SUBSTRING(CONCAT(Var_FolRefNum,'N',Par_ReferenciaNum),1,17);
				SET Var_RefNum := Par_ReferenciaNum;
			ELSE
				SET Var_FolRefNum := SUBSTRING(CONCAT(Var_FolRefNum,'N',Par_ReferenciaNum),1,17);
				SET Var_RefNum := Par_Folio;
			END IF;

			SET Par_ClaveRastreo  := CONCAT(fecha,(LPAD(CONVERT(claveEmisor,CHAR(5)),5,0)),Var_FolRefNum);
		ELSE
			SET Var_RefNum := Par_ReferenciaNum;
		END IF;

		SET Var_UsuarioAut			:= Entero_Cero;
		SET Var_UsuarioVer			:= Entero_Cero;
		SET Var_FechaVer			:= Fecha_Vacia;
		SET Var_RefNum				:= IFNULL(Var_RefNum,Par_Folio);

		IF(LENGTH(Par_NombreOrd) > 40) THEN
			SET Par_NombreOrd		:= SUBSTRING(Par_NombreOrd,1,40);
		END IF;

		IF(LENGTH(Par_NombreBeneficiario) > 40) THEN
			SET Par_NombreBeneficiario	:= SUBSTRING(Par_NombreBeneficiario,1,40);
		END IF;

		IF(LENGTH(Par_NombreBenefiDos) > 40) THEN
			SET Par_NombreBenefiDos		:= SUBSTRING(Par_NombreBenefiDos,1,40);
		END IF;

		INSERT INTO SPEIENVIOS (
			FolioSpeiID,			ClaveRastreo,			TipoPagoID,				CuentaAho,				TipoCuentaOrd,
			MonedaID,				TipoOperacion,
			CuentaOrd,										NombreOrd,										RFCOrd,
			MontoTransferir,								TotalCargoCuenta,								CuentaBeneficiario,
			NombreBeneficiario,								RFCBeneficiario,								ConceptoPago,
			IVAPorPagar,			ComisionTrans,			IVAComision,			InstiRemitenteID,		InstiReceptoraID,
			TipoCuentaBen,			CuentaBenefiDos,		NombreBenefiDos,		RFCBenefiDos,
			TipoCuentaBenDos,		ConceptoPagoDos,		ReferenciaCobranza,		ReferenciaNum,			PrioridadEnvio,
			FechaAutorizacion,		EstatusEnv,				ClavePago,				UsuarioEnvio,			AreaEmiteID,
			Estatus,				FechaRecepcion,			FechaEnvio,				CausaDevol,				FechaCan,
			Comentario,				FechaOPeracion,			Firma,					UsuarioAutoriza,		UsuarioVerifica,
			FechaVerifica,			OrigenOperacion,		NumIntentos,			FolioSTP,				PIDTarea,
			EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES(
			Par_Folio,				Par_ClaveRastreo,		Par_TipoPago,			Par_CuentaAhoID,		Par_TipoCuentaOrd,
			Par_MonedaID,			Par_TipoOperacion,
			FNENCRYPTSAFI(Par_CuentaOrd),					FNENCRYPTSAFI(Par_NombreOrd),					FNENCRYPTSAFI(Par_RFCOrd),
			FNENCRYPTSAFI(Par_MontoTransferir),				FNENCRYPTSAFI(Par_TotalCargoCuenta),			FNENCRYPTSAFI(Par_CuentaBeneficiario),
			FNENCRYPTSAFI(Par_NombreBeneficiario),			FNENCRYPTSAFI(Par_RFCBeneficiario),				FNENCRYPTSAFI(Par_ConceptoPago),
			Par_IVAPorPagar,		Par_ComisionTrans,		Par_IVAComision,		Par_InstiRemitente,		Par_InstiReceptora,
			Par_TipoCuentaBen,		Par_CuentaBenefiDos,	Par_NombreBenefiDos,	Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,	Par_ConceptoPagoDos,	Par_ReferenciaCobranza,	Var_RefNum,				Par_PrioridadEnvio,
			Par_FechaAutorizacion,	Par_EstatusEnv,			Par_ClavePago,			Par_UsuarioEnvio,		Par_AreaEmiteID,
			Par_Estatus,			Par_FechaRecepcion,		Par_FechaEnvio,			Par_CausaDevol,			Var_FechaCan,
			Var_Comentario,			Var_FechaOpe,			Par_Firma,				Var_UsuarioAut,			Var_UsuarioVer,
			Var_FechaVer,			Par_OrigenOperacion,	Entero_Cero,			Par_FolioSTP,			Cadena_Vacia,
			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP, 		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Envio SPEI Agregado Exitosamente: ", CONVERT(Par_Folio, CHAR));
		SET Var_Control:= 'cuentaAhoID' ;
		SET Var_Consecutivo:= Par_Folio;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Aud_NumTransaccion AS consecutivo,
				Par_ClaveRastreo AS campoGenerico;
	END IF;

END TerminaStore$$
