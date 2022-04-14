DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESSTPPRO`;

DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESSTPPRO`(
	-- STORED PROCEDURE QUE SE ENCARGA DE REALIZAR EL PROCESO DEL ALTA Y REGISTRO DE CONTABILIDAD DE LAS RECEPCIONES DE STP
	INOUT Par_FolioSpei			BIGINT(20),			-- Folio e identificador unico que es generado por el SP SPEIRECEPCIONESSTPALT
	Par_TipoPago				INT(2),				-- Tipo de Pago correspondiente a la tabla TIPOSPAGOSPEI
	Par_TipoCuentaOrd			INT(2),				-- Tipo de Cuenta del Ordenante correspondiente a la tabla TIPOSCUENTASPEI
	Par_CuentaOrd				VARCHAR(20),		-- Numero de Cuenta del Ordenante
	Par_NombreOrd				VARCHAR(100),		-- Nombre del Ordenante

	Par_RFCOrd					VARCHAR(18),		-- RFC del Ordenante
	Par_TipoOperacion			INT(2),				-- Tipo de Operacion
	Par_MontoTransferir			DECIMAL(16,2),		-- Monto a Transferir
	Par_IVA						DECIMAL(16,2),		-- IVA aplicado a la recepcion
	Par_InstiRemitente			INT(5),				-- Institucion del Remitente correspondiente a la tabla INSTITUCIONESSPEI

	Par_InstiReceptora			INT(5),				-- Institucion del Receptor/Beneficiario correspondiente a la tabla INSTITUCIONESSPEI
	Par_CuentaBeneficiario		VARCHAR(20),		-- Numero de Cuenta del Beneficiario
	Par_NombreBeneficiario		VARCHAR(40),		-- Nombre del Beneficiario
	Par_RFCBeneficiario			VARCHAR(18),		-- RFC del Beneficiario
	Par_TipoCuentaBen			INT(2),				-- Tipo de Cuenta del Beneficiario correspondiente a la tabla TIPOSCUENTASPEI

	Par_ConceptoPago			VARCHAR(210),		-- Concepto de Pago
	Par_ClaveRastreo			VARCHAR(30),		-- Clave de Rastreo enviada por STP
	Par_CuentaBenefiDos			VARCHAR(20),		-- Cuenta del segundo Beneficiario
	Par_NombreBenefiDos			VARCHAR(40),		-- Nombre del segundo Beneficiario
	Par_RFCBenefiDos			VARCHAR(18),		-- RFC del segundo Beneficiario

	Par_TipoCuentaBenDos		INT(2),				-- Tipo de Cuenta del segundo Beneficiario correspondiente a la tabla TIPOSCUENTASPEI
	Par_ConceptoPagoDos			VARCHAR(40),		-- Concepto de Pago para el segundo Beneficiario
	Par_ClaveRastreoDos			VARCHAR(30),		-- Clave de Rastreo enviada por STP del segundo Beneficiario
	Par_ReferenciaCobranza		VARCHAR(40),		-- Referencia de Cobranza
	Par_ReferenciaNum			INT(7),				-- Referencia Numerica

	Par_Prioridad				INT(1),				-- Prioridad
	Par_FechaCaptura			DATETIME,			-- Fecha de Captura
	Par_ClavePago				VARCHAR(10),		-- Clave de Pago
	Par_AreaEmiteID				INT(2),				-- Area que Emite correspondiente a la tabla AREASEMITESPEI
	Par_EstatusRecep			INT(3),				-- Estatus de la Recepcion

	Par_CausaDevol				INT(2),				-- Causa de Devolucion correspondiente a la tabla CAUSASDEVSPEI
	Par_InfAdicional			VARCHAR(100),		-- Informacion Adicional
	Par_Firma					VARCHAR(250),		-- Firma
	Par_Folio					BIGINT(20),			-- Folio Emisor
	Par_FolioBanxico			BIGINT(20),			-- Folio Banxico (Aca se almacenara el Folio recibido por STP[idAbono])

	Par_FolioPaquete			BIGINT(20),			-- Folio del Paquete
	Par_FolioServidor			BIGINT(20),			-- Folio del Servidor
	Par_Topologia				CHAR(1),			-- Topologia. T) Topologia T, V) Topologia V
	Par_Empresa					VARCHAR(50),		-- Empresa asignada por STP

	Par_Salida					CHAR(1),			-- Indica si el SP regresa una salida o no. S) SI, N) No
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje del Error

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Indica una Cadena Vacia
	DECLARE Entero_Cero			INT(11);			-- Indica un Entero Vacio
	DECLARE Decimal_Cero		DECIMAL(18,2);		-- Indica un Decimal Vacio
	DECLARE Fecha_Vacia			DATE;				-- Indica una Fecha Vacia
	DECLARE Salida_SI			CHAR(1);			-- Indica un valor SI

	DECLARE Salida_NO			CHAR(1);			-- Indica un valor NO
	DECLARE Num_Uno				INT(11);			-- Numero uno
	DECLARE Mon_Pesos			INT(11);			-- Clave de la Moneda Pesos segun la tabla MONEDAS
	DECLARE Str_Coma			CHAR(1);			-- Cadena que indica una coma como separador
	DECLARE AltaPoliza_NO		CHAR(1);			-- No realzia Alta de Poliza

	DECLARE AltaPoliza_SI		CHAR(1);			-- Si realiza Alta de Poliza
	DECLARE CtoConRec_Spei		INT(11);			-- Concepto Contable de Recepcion Spei
	DECLARE AltaMovAhorro_SI	CHAR(1);			-- Realzia Alta de Movimiento de Ahorro
	DECLARE Nat_Abono			CHAR(1);			-- Naturaleza Abono
	DECLARE Nat_Cargo			CHAR(1);			-- Naturaleza Cargo

	DECLARE CtoAho_Spei			INT(11);			-- Concepto Ahorro Pasivo
	DECLARE Est_Bloqueada		CHAR(1);			-- Estatus Bloqueda
	DECLARE Est_Cancelada		CHAR(1);			-- Estatus Cancelada
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Est_Aut				CHAR(1);			-- Estatus Aurorizada

	DECLARE ImporteMaximo		DECIMAL(20,2);		-- Importe Maximo para Tranferir Spei
	DECLARE TipoPago_Vacio		INT(11);			-- Tipo de Pago Vacio
	DECLARE Tp_tt				INT(2);				-- Tipo de Pago Tercero a Tercero
	DECLARE AltaMovAhorro_NO	CHAR(1);			-- No se Realiza Afectacion en las Cuentas de Ahorro
	DECLARE Cta_Fondeo			CHAR(1);			-- Tipo de Cuenta Fondeo

	DECLARE Cta_Aho				CHAR(1);			-- Tipo de Cuenta Ahorro
	DECLARE TipoCta_Clabe		INT(11);			-- Cuenta del Tipo Clabe
	DECLARE TipoCta_TarDeb		INT(11);			-- Cuenta del Tipo Tarjeta de Debito
	DECLARE TipoCta_Celular		INT(11);			-- Cuenta del Tipo Celular
	DECLARE Var_TipoPerFis		CHAR(1);			-- Tipo de Persona fisica
	DECLARE Var_TipoPerAct		CHAR(1);			-- Tipo de Persona fisica con Actividad empresarial
	DECLARE Var_TipoPerMor		CHAR(1);			-- Tipo de Persona moral
	DECLARE Est_clabeAut		CHAR(1);			-- Estatus de Cuenta CLABE Autorizada

	-- Declaracion de Variables
	DECLARE Var_NumEnvio		BIGINT(20);			-- Numero de envio
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_ClaveRas		VARCHAR(30);		-- Clave de rastreo del spei
	DECLARE Var_PrioEnvio		INT(1);				-- Prioridad de envio

	DECLARE Var_FechaAuto		DATETIME;			-- Fecha de autorizacion
	DECLARE Var_EstatusEnv		INT(3);				-- Estatus de envio
	DECLARE Var_ClavePago		VARCHAR(10);		-- Clave de pago
	DECLARE Var_Estatus			CHAR(1);			-- Estatus del safi
	DECLARE Var_FechaRecep		DATETIME;			-- Fecha de recepcion

	DECLARE Var_FechaEnvio		DATETIME;			-- Fecha envio
	DECLARE Var_CausaDevol		INT(2);				-- Causa devolucion
	DECLARE Var_InstiRemi		INT(5);				-- Institucion remitente
	DECLARE Var_AutTeso			CHAR(1);			-- Si el spei necesita autorizacion de tesoreria
	DECLARE Var_MonReqVen		DECIMAL(18,2);		-- Monto a partir del cual spei necesita autorizacion de tesoreria

	DECLARE Var_ClienteID		INT(11);			-- Numero de Cliente
	DECLARE Var_DesInsRem		VARCHAR(100);		-- Nombre de Intitucion Remitente
	DECLARE Var_Referencia		VARCHAR(50);		-- Referencia
	DECLARE Var_Poliza			BIGINT(20);			-- Numero de Poliza
	DECLARE Var_CuentaBenID		INT(12);			-- Numero de cuenta del Beneficiario

	DECLARE Var_DescMov			VARCHAR(150);		-- Descripcion de Movimiento
	DECLARE Var_CuentaAho		BIGINT(12);			-- Cuenta ahorro
	DECLARE Var_InstitucionID	INT(11);			-- Institucion ID
	DECLARE Var_CuentaBancos	VARCHAR(20);		-- Cuenta de bancos
	DECLARE Var_Banco			INT(11);			-- Banco

	DECLARE Var_MontoDev		DECIMAL(16,2);		-- Monto de la devolucion
	DECLARE Var_Moneda			INT(11);			-- Moneda de la cuenta
	DECLARE Var_ClabePartici	VARCHAR(18);		-- Clabe Spei del Participante
	DECLARE Var_InstPartici		INT(5);				-- ID de Institucion Participante
	DECLARE Var_EstCli			CHAR(1);			-- Estatus del CLiente

	DECLARE Var_TipoCuenta		CHAR(1);			-- Tipo Cuenta
	DECLARE Var_FechaSis		DATE;				-- Fecha sistema
	DECLARE Var_EstatusPago		CHAR(1);			-- Estatus de tipo de pago
	DECLARE Var_TipoPagoEnvio	INT(2);				-- Varibale tipo de pago de speienvios
	DECLARE Var_CreditoID		BIGINT(12);			-- CreditoID

	DECLARE Var_TipoPagoExist	INT(2);				-- Almacena el Tipo de Pago para validarlo
	DECLARE Var_ClaveRasExist	VARCHAR(30);		-- Almacena la Clave de Rastreo para validarla
	DECLARE Var_TipoCtaBenExist	INT(11);			-- Almacena el Tipo de Cuenta del Beneficiario para validarla
	DECLARE Var_InstiRemExist	INT(11);			-- ALmacena la Institucion del Remitente para validarla
	DECLARE Var_InstiRecExist	INT(11);			-- Almacena la Institucion Receptora para validarla

	DECLARE Var_CuentaBenExist	VARCHAR(20);		-- Almacena la Cuenta del Beneficiario para validarla
	DECLARE Var_FolioBanxExist	BIGINT(20);			-- Almacena el Folio de la Recepcion para validarlo
	DECLARE Var_CuentaAhoIDS	BIGINT(12);			-- Cuenta de Ahorro correspondiente a la Empresa con la Cuenta Clave PARAMETROSSPEI
	DECLARE Var_InstiIDS		INT(11);			-- Institucion correspondiente a la Empresa con la Cuenta Clave PARAMETROSSPEI
	DECLARE Var_NumCtaInstitS	VARCHAR(20);		-- Numero de Cuenta de Institucion correspondiente a la Empresa con la Cuenta Clave PARAMETROSSPEI

	DECLARE Var_FechaOpe		DATE;				-- Fecha operacion
	DECLARE Cons_SI				CHAR(1);			-- Constante SI
	DECLARE Blo_SPEI			INT(11);			-- Tipo de bloqueo SPEI
	DECLARE Var_BloqueoRecep	CHAR(1);			-- Bloqueo de Recepcion SPEI
	DECLARE Var_MontoMinBloqueo	DECIMAL(16,2);		-- Monto de Bloqueo de Recepcion SPEI

	DECLARE ConceptoRecepcion	VARCHAR(40);		-- Concepto de Recepcion SPEI
	DECLARE Cuenta_Vacia		VARCHAR(25);		-- Cuenta Contable Vacia
	DECLARE Var_CtaTesoreria	CHAR(25);			-- Cuenta Participante a Participate
	DECLARE Var_MovParticipante	INT(11);			-- Tipo de Movimiento SPEI
	DECLARE Var_Refere		  	VARCHAR(35);

	DECLARE Var_Automatico    	CHAR(1);			-- Automatico
	DECLARE Var_TipoMovIDC	  	INT;				-- Tipo de Movimiento Cargo
	DECLARE Par_Consecutivo	  	BIGINT;				-- Consecutivo
	DECLARE Var_TipoMovIDA	  	INT;				-- Tipo de Movimineto Abono
	DECLARE Var_Conse         	INT;				-- consecutivo

	DECLARE Var_EstatusCredito	CHAR(1);			-- Estatus del Credito
	DECLARE EstatusNoValido 	VARCHAR(10);		-- Estatus de Creditos no valido
	DECLARE Var_TipoPago 		CHAR(1);			-- Tipo de Pago, F= Fondeo, C = Credito, A = Cuenta de Ahorro
	DECLARE Var_ValorParametro	INT(11);			-- Valor del Cliente Especifico
	DECLARE CliProcEspecifico	VARCHAR(30);		-- Cliente especifico

    DECLARE Var_AplicaPagAutCre CHAR(1);			-- Aplica Pago automatico
	DECLARE Prepago				CHAR(1);			-- Prepago
	DECLARE Cons_NO				CHAR(1);			-- Constante NO
	DECLARE Cta_Credito			CHAR(1);			-- Cuenta de Credito
	DECLARE Cta_Tarjeta			CHAR(1);			-- Cuenta de Tarjeta
	DECLARE Var_TipoPersonaCli	VARCHAR(1);			-- Tipo de Persona
	DECLARE Var_EstatusClabe	CHAR(1);			-- Estatus de la cuenta CLABE

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- Decimal cero
	SET Salida_SI				:= 'S';				-- Salida SI

	SET Salida_NO				:= 'N';				-- Salida NO
	SET Num_Uno					:= 1;				-- Entero uno
	SET Mon_Pesos				:= 1;				-- Moneda Pesos
	SET Str_Coma				:= ',';				-- Separador
	SET AltaPoliza_NO			:= 'N';				-- No Alta de Poliza

	SET AltaPoliza_SI			:= 'S';				-- Si Alta de Poliza
	SET CtoConRec_Spei			:= 809;				-- Concepto Contable de RECEPCION SPEI
	SET AltaMovAhorro_SI		:= 'S';				-- Si Alta Movimientos Ahorro
	SET Nat_Abono				:= 'A';				-- Tipo Abono
	SET Nat_Cargo				:= 'C';				-- Tipo Cargo

	SET CtoAho_Spei				:= 1;				-- Concepto Ahorro Pasivo
	SET Est_Bloqueada			:= 'B';				-- Estatus bloqueado
	SET Est_Cancelada			:= 'C';				-- Estatus cancelada
	SET Est_Activo				:= 'A';				-- Estatus Activo
	SET Est_Aut					:= 'A';				-- Estatus autorizada

	SET ImporteMaximo			:= 999999999999.99;	-- Importe maximo para las transferencias spei
	SET TipoPago_Vacio			:= -1;				-- Tipo de Pago Vacio
	SET Tp_tt					:= 1;				-- Tipo de pago tercero a tercero
	SET AltaMovAhorro_NO		:= 'N';				-- No se realiza afectacion en las cuentas de ahorro
	SET Cta_Fondeo				:= 'F';				-- Tipo de cuenta fondeo

	SET Cta_Aho					:= 'A';				-- Tipo de cuenta ahorro
	SET Cta_Credito				:= 'C'; 			-- Tipo de cuenta Credito
	SET TipoCta_TarDeb			:= 3;				-- Cuenta del Tipo Tarjeta de Debito
	SET TipoCta_Clabe			:= 40;				-- Cuenta del Tipo Clabe
	SET TipoCta_Celular			:= 10;				-- Cuenta del Tipo Celular

	SET Var_Poliza				:= 0;				-- Inicializar Poliza
	SET Var_NumEnvio			:= 0;				-- Numero de Envio
	SET Cons_SI					:= 'S';				-- Constante SI
	SET Blo_SPEI				:= 16;				-- Tipo de bloqueo Automatico por SPEI
	SET ConceptoRecepcion		:= 'POLIZASPEIPRO';	-- Instrumento

	SET Cuenta_Vacia			:= '0000000000000000000000000';	-- Cuenta Contable Vacia
	SET Var_MovParticipante		:= 27;				-- Tipo de Movimiento para Detalle Poliza
	SET Var_Automatico 			:= 'A';
	SET Var_TipoMovIDC			:= 13;
	SET Var_TipoMovIDA			:= 14;

	SET Var_Conse       		:= 0;
	SET Var_FechaOpe			:= (SELECT FechaSistema
										FROM PARAMETROSSIS);
	SET Var_DescMov 			:= Cadena_Vacia;
	SET Cta_Tarjeta 			:= 'T';
	SET Var_TipoPerFis			:= 'F';				-- Tipo de Persona fisica
	SET Var_TipoPerAct			:= 'A';				-- Tipo de Persona fisica con actividad empresarial
	SET Var_TipoPerMor			:= 'M';				-- Tipo de Persona moral
	SET Est_clabeAut			:= 'A';				-- Estatus de Cuenta CLABE Autorizada

	-- Inicializacion de Parametros
	SET Par_TipoPago			:= IFNULL(Par_TipoPago, TipoPago_Vacio);
	SET Par_TipoCuentaOrd		:= IFNULL(Par_TipoCuentaOrd, Entero_Cero);
	SET Par_CuentaOrd			:= IFNULL(Par_CuentaOrd, Cadena_Vacia);
	SET Par_NombreOrd			:= IFNULL(Par_NombreOrd, Cadena_Vacia);

	SET Par_RFCOrd				:= IFNULL(Par_RFCOrd, Cadena_Vacia);
	SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);
	SET Par_MontoTransferir		:= IFNULL(Par_MontoTransferir, Decimal_Cero);
	SET Par_IVA					:= IFNULL(Par_IVA, Decimal_Cero);
	SET Par_InstiRemitente		:= IFNULL(Par_InstiRemitente, Entero_Cero);

	SET Par_InstiReceptora		:= IFNULL(Par_InstiReceptora, Entero_Cero);
	SET Par_CuentaBeneficiario	:= IFNULL(Par_CuentaBeneficiario, Cadena_Vacia);
	SET Par_NombreBeneficiario	:= IFNULL(Par_NombreBeneficiario, Cadena_Vacia);
	SET Par_RFCBeneficiario		:= IFNULL(Par_RFCBeneficiario, Cadena_Vacia);
	SET Par_TipoCuentaBen		:= IFNULL(Par_TipoCuentaBen, Entero_Cero);

	SET Par_ConceptoPago		:= IFNULL(Par_ConceptoPago, Cadena_Vacia);
	SET Par_ClaveRastreo		:= IFNULL(Par_ClaveRastreo, Cadena_Vacia);
	SET Par_CuentaBenefiDos		:= IFNULL(Par_CuentaBenefiDos, Cadena_Vacia);
	SET Par_NombreBenefiDos		:= IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
	SET Par_RFCBenefiDos		:= IFNULL(Par_RFCBenefiDos, Cadena_Vacia);

	SET Par_TipoCuentaBenDos	:= IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
	SET Par_ConceptoPagoDos		:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);
	SET Par_ClaveRastreoDos		:= IFNULL(Par_ClaveRastreoDos, Cadena_Vacia);
	SET Par_ReferenciaCobranza	:= IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);
	SET Par_ReferenciaNum		:= IFNULL(Par_ReferenciaNum, Entero_Cero);

	SET Par_Prioridad			:= IFNULL(Par_Prioridad, Entero_Cero);
	SET Par_FechaCaptura		:= IFNULL(Par_FechaCaptura, Fecha_Vacia);
	SET Par_ClavePago			:= IFNULL(Par_ClavePago, Cadena_Vacia);
	SET Par_AreaEmiteID			:= IFNULL(Par_AreaEmiteID, Entero_Cero);
	SET Par_EstatusRecep		:= IFNULL(Par_EstatusRecep, Entero_Cero);

	SET Par_CausaDevol			:= IFNULL(Par_CausaDevol, Entero_Cero);
	SET Par_InfAdicional		:= IFNULL(Par_InfAdicional, Cadena_Vacia);
	SET Par_Firma				:= IFNULL(Par_Firma, Cadena_Vacia);
	SET Par_Folio				:= IFNULL(Par_Folio, Entero_Cero);
	SET Par_FolioBanxico		:= IFNULL(Par_FolioBanxico, Entero_Cero);

	SET Par_FolioPaquete		:= IFNULL(Par_FolioPaquete, Entero_Cero);
	SET Par_FolioServidor		:= IFNULL(Par_FolioServidor, Entero_Cero);
	SET Par_Topologia			:= IFNULL(Par_Topologia, Cadena_Vacia);
	SET Par_Empresa				:= IFNULL(Par_Empresa, Cadena_Vacia);
	SET EstatusNoValido			:= 'C,P';

	SET CliProcEspecifico 		:= 'CliProcEspecifico';
	SET Prepago					:= "P";
	SET Cons_NO					:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESSTPPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		-- CAUSA DEVOLUCION 15 : TIPO DE PAGO ERRONEO
		-- Valida que el Tipo de Pago exista
		SET Var_TipoPagoExist	:= (SELECT TipoPagoID
										FROM TIPOSPAGOSPEI
										WHERE TipoPagoID = Par_TipoPago);

		SET Var_TipoPagoExist	:= IFNULL(Var_TipoPagoExist, TipoPago_Vacio);

		IF(Var_TipoPagoExist = TipoPago_Vacio) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'Tipo de Pago Erroneo.';
			SET Var_Control	:= 'Devolucion';
			LEAVE ManejoErrores;
		END IF;

		-- Valida que el Tipo de Pago sea de Terceo a Tercero
		IF (Par_TipoPago != Tp_tt) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'Tipo de Pago Erroneo.';
			SET Var_Control	:= 'Devolucion';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion que el tipo de pago este activo
		SET Var_EstatusPago	:= (SELECT Estatus
									FROM TIPOSPAGOSPEI
									WHERE TipoPagoID = Par_TipoPago);

		IF (Var_EstatusPago != Est_Activo) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'Tipo de Pago Erroneo.';
			SET Var_Control	:= 'Devolucion';
			LEAVE ManejoErrores;
		END IF;

		SELECT	PS.Clabe,				PS.ParticipanteSpei,	CO.CuentaAhoID,								CT.NumCtaInstit,		CT.InstitucionID,
				PS.BloqueoRecepcion,	PS.MontoMinimoBloq,		IFNULL(CtaContableTesoreria,Cuenta_Vacia)
		INTO	Var_ClabePartici,		Var_InstPartici,		Var_CuentaAhoIDS,							Var_NumCtaInstitS,		Var_InstiIDS,
				Var_BloqueoRecep,		Var_MontoMinBloqueo,	Var_CtaTesoreria
			FROM PARAMETROSSPEI PS
				JOIN CUENTASAHOTESO CT ON PS.Clabe		= CT.CueClave
				JOIN CUENTASAHO CO ON CT.CuentaAhoID	= CO.CuentaAhoID
				JOIN CLIENTES CTE ON CO.ClienteID		= CTE.ClienteID
			WHERE PS.EmpresaID = Aud_EmpresaID;

		IF(Par_TipoPago != Entero_Cero) THEN
			-- VALIDACIONES REQUERIDAS SEGUN LOS TIPOS DE PAGO
			IF (Par_TipoPago = Tp_tt) THEN
				-- CAUSA DEVOLUCION 1 : CUENTA INEXISTENTE
				-- CUENTA TIPO CLABE
				IF(Par_TipoCuentaBen = TipoCta_Clabe) THEN
				-- Buscar si es Fondeo
					IF (Var_ClabePartici = Par_CuentaBeneficiario) THEN
						-- ESTO VA PARA UNA CUENTA DE FONDEO
						SET Var_TipoCuenta := Cta_Fondeo;
						SET Var_TipoPago := Cta_Fondeo;
					END IF;

					-- SI NO ES UN FONDEO LA CUENTA CLABE ES DISTINTA A LA DEL BENEFICIARIO
					IF (Var_ClabePartici != Par_CuentaBeneficiario) THEN

						SELECT CreditoID INTO Var_CreditoID
							FROM CREDITOS
							WHERE Clabe = Par_CuentaBeneficiario;

                   		SET Var_CreditoID :=IFNULL(Var_CreditoID, Entero_Cero);
                   		-- SI Var_CreditoID ES DIFERENTE DE Entero_Cero EL SPEI VA PARA UN CREDITO

                   		IF(Var_CreditoID <> Entero_Cero)THEN
                   			-- PAGO PARA UN CREDITO
                   			SET Var_TipoCuenta := Cta_Aho;
							SET Var_TipoPago := Cta_Credito;

	                        -- Obtiene Id de la cuenta de ahorro
	  						SELECT CuentaID, Estatus INTO Var_CuentaAho, Var_EstatusCredito
	                        FROM CREDITOS
	                        WHERE Clabe = Par_CuentaBeneficiario;

	                       	IF(FIND_IN_SET(Var_EstatusCredito,EstatusNoValido) > Entero_Cero) THEN
								SET Par_NumErr 	:= 004;
								SET Par_ErrMen 	:= CONCAT('Credito Con Estatus Invalido: ',Var_CreditoID,'[',Var_EstatusCredito,']');
								SET Var_Control	:= 'Devolucion';
								LEAVE ManejoErrores;
							END IF;

                   		END IF;
                   		-- SI Var_CreditoID ES IGUAL A Entero_Cero EL SPEI VA PARA UNA CUENTA DE AHORRO
                   		IF(Var_CreditoID = Entero_Cero) THEN
                   			-- PAGO PARA UNA CUENTA DE AHORRO
							SET Var_TipoCuenta := Cta_Aho;
							SET Var_TipoPago := Cta_Aho;

							SELECT ClienteID, CuentaAhoID, MonedaID, Clabe
								INTO Var_ClienteID, Var_CuentaAho, Var_Moneda, Var_CuentaBenExist
								FROM CUENTASAHO
								WHERE  Clabe = Par_CuentaBeneficiario;

							SET Var_CuentaAho		:= IFNULL(Var_CuentaAho, Entero_Cero);
							SET Var_CuentaBenExist	:= IFNULL(Var_CuentaBenExist, Cadena_Vacia);

							IF(Var_CuentaBenExist = Cadena_Vacia) THEN
								SET Par_NumErr	:= 005;
								SET Par_ErrMen	:= 'La Cuenta No Existe';
								SET Var_Control	:= 'Devolucion';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;

				-- CUENTA TIPO TARJETA
				IF (Par_TipoCuentaBen = TipoCta_TarDeb) THEN
				    -- PAGO PARA UNA TARJETA DE DEBITO
				    SET Var_TipoPago := Cta_Tarjeta;

					SELECT TAR.TarjetaDebID, TAR.ClienteID, CUE.CuentaAhoID, CUE.MonedaID
					INTO Var_CuentaBenExist, Var_ClienteID, Var_CuentaAho, Var_Moneda
						FROM TARJETADEBITO TAR
							INNER JOIN CUENTASAHO CUE ON TAR.CuentaAhoID = CUE.CuentaAhoID
						WHERE TarjetaDebID = Par_CuentaBeneficiario;

					SET Var_CuentaAho		:= IFNULL(Var_CuentaAho, Entero_Cero);
					SET Var_CuentaBenExist	:= IFNULL(Var_CuentaBenExist, Cadena_Vacia);

					IF(Var_CuentaBenExist = Cadena_Vacia) THEN
						SET Par_NumErr 	:= 006;
						SET Par_ErrMen 	:= CONCAT('La Cuenta No Existe');
						SET Var_Control	:= 'Devolucion';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF (Var_TipoCuenta = Cta_Aho) THEN
					SELECT 		Cue.CuentaAhoID, 	Cue.Estatus, 			Cli.Estatus,			Cli.TipoPersona,			Cue.MonedaID
						INTO 	Var_CuentaAho, 		Var_Estatus, 			Var_EstCli,				Var_TipoPersonaCli,			Var_Moneda
							FROM CUENTASAHO Cue
							INNER JOIN CLIENTES Cli ON Cue.ClienteID = Cli.ClienteID
							WHERE Cue.CuentaAhoID = Var_CuentaAho;

					-- CAUSA DEVOLUCION 2 : CUENTA BLOQUEADA
					IF(Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Bloqueada) THEN
						SET Par_NumErr 	:= 007;
						SET Par_ErrMen 	:= CONCAT('Cuenta bloqueada');
						SET Var_Control	:= 'Devolucion';
						LEAVE ManejoErrores;
					END IF;

					-- CAUSA DEVOLUCION 3 : CUENTA CANCELADA
					IF((Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Cancelada) OR ( Var_EstCli != Est_Activo)) THEN
						SET Par_NumErr 	:= 008;
						SET Par_ErrMen 	:= CONCAT('Cuenta Cancelada');
						SET Var_Control	:= 'Devolucion';
						LEAVE ManejoErrores;
					END IF;

					-- CAUSA DEVOLUCION 5 : CUENTA CON OTRA DIVISA
					-- SI LA DIVISA NO CORRESPONDE CON EL DE LA CUENTA
					IF(Var_CuentaAho != Entero_Cero AND Var_Moneda != Mon_Pesos) THEN
						SET Par_NumErr 	:= 009;
						SET Par_ErrMen 	:='Cuenta en otra Divisa';
						SET Var_Control	:= 'Devolucion';
						LEAVE ManejoErrores;
					END IF;

					-- La Cuenta CLABE no se encuentra autorizada
					IF(Var_TipoPersonaCli IN (Var_TipoPerFis, Var_TipoPerAct)) THEN
						SELECT 		Estatus
							INTO 	Var_EstatusClabe
							FROM SPEICUENTASCLABEPFISICA
							WHERE CuentaClabe = Par_CuentaBeneficiario;

						IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) = Cadena_Vacia) THEN
							SET Par_NumErr	:= 010;
							SET Par_ErrMen	:= 'No se encontro informacion de la Cuenta CLABE.';
							SET Var_Control	:= 'MonedaID';
							LEAVE ManejoErrores;
						END IF;

						IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) <> Est_clabeAut) THEN
							SET Par_NumErr	:= 011;
							SET Par_ErrMen	:= 'La Cuenta CLABE no se encuentra autorizada.';
							SET Var_Control	:= 'MonedaID';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- La Cuenta CLABE no se encuentra autorizada
					IF(Var_TipoPersonaCli = Var_TipoPerMor) THEN
						SELECT 		Estatus
							INTO 	Var_EstatusClabe
							FROM SPEICUENTASCLABPMORAL
							WHERE CuentaClabe = Par_CuentaBeneficiario;

						IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) = Cadena_Vacia) THEN
							SET Par_NumErr	:= 010;
							SET Par_ErrMen	:= 'No se encontro informacion de la Cuenta CLABE.';
							SET Var_Control	:= 'MonedaID';
							LEAVE ManejoErrores;
						END IF;

						IF(IFNULL(Var_EstatusClabe, Cadena_Vacia) <> Est_clabeAut) THEN
							SET Par_NumErr	:= 011;
							SET Par_ErrMen	:= 'La Cuenta CLABE no se encuentra autorizada.';
							SET Var_Control	:= 'MonedaID';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				-- CAUSA DEVOLUCION 14 : FALTA INFORMACION MANDATORIA PARA COMPLETAR EL PAGO
				-- Valida que FolioBanxico no este repetido
				SET Var_FolioBanxExist	:= (SELECT FolioBanxico
												FROM SPEIRECEPCIONES
												WHERE FolioBanxico = Par_FolioBanxico);

				SET Var_FolioBanxExist := IFNULL(Var_FolioBanxExist, Entero_Cero);

				SET Var_ClaveRasExist	:= (SELECT ClaveRastreo
												FROM SPEIRECEPCIONES
												WHERE ClaveRastreo = Par_ClaveRastreo
													AND InstiRemitenteID = Par_InstiRemitente
													AND FechaOperacion = Var_FechaOpe);

				SET Var_ClaveRasExist	:= IFNULL(Var_ClaveRasExist, Cadena_Vacia);

				IF(Par_FolioBanxico = Entero_Cero) THEN
					SET Par_NumErr	:= 012;
					SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago[idAbono]. Folio no Valido';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_FolioBanxExist != Entero_Cero) THEN
					SET Par_NumErr	:= 013;
					SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago.[idAbono] duplicado';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_ClaveRastreo = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 014;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[claveRastreo]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_ClaveRasExist != Cadena_Vacia) THEN
					SET Par_NumErr	:= 015;
					SET Par_ErrMen	:= concat('Falta informacion mandatoria para completar el pago.[claveRastreo-',Var_ClaveRasExist,'] duplicada');
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_NombreBeneficiario = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 016;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[nombreBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_CuentaBeneficiario = Entero_Cero) THEN
					SET Par_NumErr 	:= 017;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[cuentaBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_TipoCuentaBen = Entero_Cero) THEN
					SET Par_NumErr 	:= 018;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[tipoCuentaBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_RFCBeneficiario = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 019;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[rfcCurpBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_ConceptoPago = Cadena_Vacia) THEN
					SET Par_NumErr 	:= 020;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[conceptoPago]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_MontoTransferir = Decimal_Cero) THEN
					SET Par_NumErr 	:= 021;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[monto]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACION QUE EL MONTO A TRANSFERIR SEA MAYOR AL PERMITIDO POR SPEI
				IF (Par_MontoTransferir > ImporteMaximo) THEN
					SET Par_NumErr 	:= 022;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[monto]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				IF (Par_ReferenciaNum = Entero_Cero) THEN
					SET Par_NumErr 	:= 023;
					SET Par_ErrMen 	:= 'Falta informacion mandatoria para completar el pago[referenciaNumerica]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACION QUE LA INSTITUCION REMITENTE Y RECEPTORA NO SEA LA MISMA
				SET Var_InstiRecExist	:= (SELECT InstitucionID
												FROM INSTITUCIONESSPEI
												WHERE InstitucionID = Par_InstiReceptora);

				SET Var_InstiRecExist	:= IFNULL(Var_InstiRecExist, Entero_Cero);

				IF(Var_InstiRecExist = Entero_Cero) THEN
					SET Par_NumErr	:= 024;
					SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago[institucionBeneficiaria]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				SET Var_InstiRemExist	:= (SELECT InstitucionID
											FROM INSTITUCIONESSPEI
											WHERE InstitucionID = Par_InstiRemitente);

				SET Var_InstiRemExist	:= IFNULL(Var_InstiRemExist, Entero_Cero);

				IF(Var_InstiRemExist = Entero_Cero) THEN
					SET Par_NumErr	:= 025;
					SET Par_ErrMen	:= 'Falta informacion mandatoria para completar el pago[institucionOrdenante]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

                IF (Par_CuentaOrd = Par_CuentaBeneficiario) THEN
					SET Par_NumErr 	:= 026;
					SET Par_ErrMen 	:= 'La cuenta Ordenante no puede ser igual a la cuenta del Beneficiario[cuentaBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- CAUSA DEVOLUCION 17 : TIPO DE CUENTA NO CORRESPONDE
				-- SI EL TIPO DE CUENTA NO EXISTE EN LA TABLA TIPOSCUENTASPEI
				SET Var_TipoCtaBenExist	:= (SELECT TipoCuentaID
												FROM TIPOSCUENTASPEI
												WHERE TipoCuentaID = Par_TipoCuentaBen);

				SET Var_TipoCtaBenExist	:= IFNULL(Var_TipoCtaBenExist, Entero_Cero);

				IF(Var_TipoCtaBenExist = Entero_Cero) THEN
					SET Par_NumErr 	:= 027;
					SET Par_ErrMen 	:= 'El tipo de cuenta no corresponde[tipoCuentaBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- Se agrega esta validacion para los tipo de cuenta vostro ya que falla CONTASPEIPRO
				IF ((Par_TipoCuentaBen <> TipoCta_TarDeb OR Par_TipoCuentaBen <> TipoCta_Clabe OR Par_TipoCuentaBen <> TipoCta_Celular) AND (Var_CuentaAho = Entero_Cero)) THEN
					SET Par_NumErr 	:= 028;
					SET Par_ErrMen 	:= 'El tipo de cuenta no corresponde[tipoCuentaBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- CAUSA DEVOLUCION 19 : CARACTER INVALIDO
			-- LLAMADA A LA FUNCION DE VALIDACION DE CARACTERES SPEI
			IF (Par_TipoPago = Tp_tt) THEN
				SET Par_NumErr := FNVALIDACARACSPEI(Par_NombreOrd);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 029;
					SET Par_ErrMen 	:= 'Caracter invalido[nombreOrdenante]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCOrd);
				IF (Par_NumErr= 100) THEN
					SET Par_NumErr 	:= 030;
					SET Par_ErrMen 	:= 'Caracter invalido[rfcCurpOrdenante]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				-- VALIDACIONES PARA ELBENEFICIARIO UNO
				SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBeneficiario);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 031;
					SET Par_ErrMen 	:= 'Caracter invalido[nombreBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				SET  Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBeneficiario);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 032;
					SET Par_ErrMen 	:= 'Caracter invalido[rfcCurpBeneficiario]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPago);
				IF (Par_NumErr = 100) THEN
					SET Par_NumErr 	:= 033;
					SET Par_ErrMen 	:= 'Caracter invalido[conceptoPago]';
					SET Var_Control	:= 'Devolucion';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		CALL SPEIRECEPCIONESSTPALT(
			Par_FolioSpei,				Par_TipoPago,				Par_TipoCuentaOrd,			Par_CuentaOrd,				Par_NombreOrd,
			Par_RFCOrd,					Par_TipoOperacion,			Par_MontoTransferir,		Par_IVA,					Par_InstiRemitente,
			Par_InstiReceptora,			Par_CuentaBeneficiario,		Par_NombreBeneficiario,		Par_RFCBeneficiario,		Par_TipoCuentaBen,
			Par_ConceptoPago,			Par_ClaveRastreo,			Par_CuentaBenefiDos,		Par_NombreBenefiDos,		Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,		Par_ConceptoPagoDos,		Par_ClaveRastreoDos,		Par_ReferenciaCobranza,		Par_ReferenciaNum,
			Par_Prioridad,				Par_FechaCaptura,			Par_ClavePago,				Par_AreaEmiteID,			Par_EstatusRecep,
			Par_CausaDevol,				Par_InfAdicional,			Par_Firma,					Par_Folio,					Par_FolioBanxico,
			Par_FolioPaquete,			Par_FolioServidor,			Par_Topologia,				Par_Empresa,				Salida_NO,
			Par_NumErr,					Par_ErrMen,					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control	:= 'FolioSpei';
			LEAVE ManejoErrores;
		END IF;

		-- MOVIMIENTOS CONTABLES
		-- se setea la fecha de operaciona  fecha del sistema
		SELECT		FechaSistema
			INTO	Var_FechaSis
			FROM	PARAMETROSSIS;

		-- SE VERIFICA SI ES UN FONDEO
		IF (Var_ClabePartici = Par_CuentaBeneficiario) THEN
			IF (Par_TipoPago != Entero_Cero) THEN
				SELECT	InstitucionID	INTO	Var_InstitucionID
					FROM	INSTITUCIONES
					WHERE	ClaveParticipaSpei	= Par_InstiRemitente;

				SET Var_InstitucionID	= IFNULL(Var_InstitucionID, Entero_Cero);

				IF ( Var_InstitucionID = Entero_Cero) THEN
					SET Par_NumErr := 034;
					SET Par_ErrMen := CONCAT('Error al registrar el fondeo, la institucion no existe: ',Par_InstiRemitente);
					LEAVE ManejoErrores;
				END IF;


				SELECT	cht.NumCtaInstit, 	ch.CuentaAhoID, 	ch.ClienteID
				INTO	Var_CuentaBancos,	Var_CuentaAho, 		Var_ClienteID
					FROM CUENTASAHOTESO cht
						JOIN	CUENTASAHO ch ON cht.CuentaAhoID = ch.CuentaAhoID
					WHERE	cht.InstitucionID	= Var_InstitucionID
						AND	cht.CueClave 		= Par_CuentaOrd;

				SET Var_CuentaBancos = IFNULL(Var_CuentaBancos, Cadena_Vacia);

				IF( Var_CuentaBancos = Cadena_Vacia) THEN
					SET Par_NumErr := 035;
					SET Par_ErrMen := CONCAT('La cuenta de bancos no existe: ',Par_CuentaOrd);
					LEAVE ManejoErrores;
				END IF;


				SET Var_DescMov	:= CONCAT('FONDEO SPEI',' ' , Par_ConceptoPago);
				-- REFERENCIA PARA LA PARTE OPERATIVA
				SET	Var_Refere := CONCAT('Tran: ', CONVERT(Aud_NumTransaccion,CHAR),', Suc:',CONVERT(Aud_Sucursal,CHAR));


				CALL TESORERIAMOVIMIALT(
					Var_CuentaAho,		Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
					Cadena_Vacia,     	Nat_Cargo,  		Var_Automatico, 		Var_TipoMovIDC,  	Entero_Cero,
					Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Aud_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			CALL TESORERIAMOVIMIALT(
				Var_CuentaAhoIDS,	Var_FechaSis,		Par_MontoTransferir,	Var_DescMov, 		Var_Refere,
				Cadena_Vacia,     	Nat_Abono,  		Var_Automatico, 		Var_TipoMovIDA,  	Entero_Cero,
				Par_Consecutivo,	Salida_NO,        	Par_NumErr,         	Par_ErrMen,     	Aud_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;

			CALL CONTASPEISPRO(
				Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,	    Var_FechaSis,
				Par_MontoTransferir,	Entero_Cero,		Entero_Cero,		Var_DescMov,		Par_ClaveRastreo,
				Entero_Cero,			AltaPoliza_SI, 		Var_Poliza,			CtoConRec_Spei, 	Nat_Cargo,
				AltaMovAhorro_NO,		Var_CuentaAho, 		Var_ClienteID, 		Nat_Abono,			CtoAho_Spei,
				Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoPago != Entero_Cero) THEN
				CALL POLIZASTESOREPRO(
					Var_Poliza,      	Aud_EmpresaID,      	Var_FechaSis,          	Par_CuentaBeneficiario,		Aud_Sucursal,
					Entero_Cero,        Decimal_Cero,			Par_MontoTransferir,	Mon_Pesos, 	    			Entero_Cero,
					Entero_Cero,    	Entero_Cero,       		Var_InstitucionID,      Var_CuentaBancos,  			Var_DescMov,
					Par_FolioSpei,  	Var_Conse,				Salida_NO,         		Par_NumErr,             	Par_ErrMen,
					Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,    			Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;

				-- afecta a la cuenta bancos
				CALL SALDOSCUENTATESOACT(
					Var_CuentaBancos,	Var_InstitucionID,	Par_MontoTransferir,	Nat_Cargo,			Par_Consecutivo,
					Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					SET Var_Control:= 'FolioSpei' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- afecta cuentas spei
			CALL SALDOSCUENTATESOACT(
				Var_NumCtaInstitS,	Var_InstiIDS,		Par_MontoTransferir,	Nat_Abono,			Par_Consecutivo,
				Salida_NO,			Par_NumErr,       	Par_ErrMen,     		Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 		Aud_Sucursal,     	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei' ;
				LEAVE ManejoErrores;
			END IF;



		ELSEIF (Par_TipoPago = Tp_tt) THEN
			SET Var_DescMov := CONCAT('Recepcion SPEI',' ' , Par_ClaveRastreo);

			SET Var_Referencia	:= (RTRIM(CONVERT(Par_ReferenciaNum,CHAR(7))));

			-- Alta de movientos a cuentas de Ahorro y contables
			CALL CONTASPEISPRO(
				Par_FolioSpei,			Aud_Sucursal,		Mon_Pesos,			Var_FechaSis,		Var_FechaSis,
				Par_MontoTransferir,	Decimal_Cero,		Decimal_Cero,		Var_DescMov,		Par_ClaveRastreo,
				Var_CuentaAho,			AltaPoliza_SI,		Var_Poliza,			CtoConRec_Spei,		Nat_Cargo,
				AltaMovAhorro_SI,		Var_CuentaAho,		Var_ClienteID,		Nat_Abono,			CtoAho_Spei,
				Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control:= 'FolioSpei';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_CuentaAho != Entero_Cero AND Var_BloqueoRecep = Cons_SI )THEN
				-- SE HACE BLOQUEO PARA CUENTAS DE AHORRO CUANDO EXCEDA EL MONTO MINIMO DE BLOQUEO
				IF (Par_MontoTransferir >= Var_MontoMinBloqueo AND Var_TipoPago = Cta_Aho) THEN
					-- Bloqueo del saldo en la cuenta
					SET Var_DescMov := CONCAT('RECEPCION SPEI ',Par_ClaveRastreo);

					CALL BLOQUEOSPRO(
						Entero_Cero,		Est_Bloqueada,		Var_CuentaAho,		Var_FechaSis,		Par_MontoTransferir,
						Fecha_Vacia,		Blo_SPEI,			Var_DescMov,		Par_FolioSpei,		Cadena_Vacia,
						Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						SET Var_Control := 'FolioSpei';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
	        -- Consulta de Parametros
	        SELECT AplicaPagAutCre
				INTO Var_AplicaPagAutCre
			FROM SPEIPARAMPAGOCRE;

	   		SET Var_AplicaPagAutCre := IFNULL(Var_AplicaPagAutCre, Cons_SI);

			-- SE BLOQUEA LA RECEPCION PARA LOS CREDITOS SOLO CUANDO NO REQUIERE PAGO AUTOMATICO Y SE DEJARÁ EN LA CUENTA EJE
			IF ( Var_AplicaPagAutCre = Cons_NO AND Var_TipoPago = Cta_Credito)THEN
					SET Var_DescMov := CONCAT('RECEPCION SPEI PAGO CREDITO ',Par_ClaveRastreo);

					CALL BLOQUEOSPRO(
						Entero_Cero,		Est_Bloqueada,		Var_CuentaAho,		Var_FechaSis,		Par_MontoTransferir,
						Fecha_Vacia,		Blo_SPEI,			Var_DescMov,		Par_FolioSpei,		Cadena_Vacia,
						Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						SET Var_Control := 'FolioSpei';
						LEAVE ManejoErrores;
					END IF;
			END IF;

		END IF;

		-- Se ajusta validacion por instruccion de Miguel Reyes en Revision del dia 2020-01-14
		IF(IFNULL(Var_CreditoID,Entero_Cero)<>Entero_Cero AND Var_AplicaPagAutCre = Cons_SI)THEN
		    CALL PAGOCREDITOSPEIPRO(
		        Var_CreditoID, 			Var_CuentaAho, 		Par_MontoTransferir, 	Var_FechaSis, 			Var_Poliza,
		        Salida_NO,				Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,
		        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
		    IF(Par_NumErr != Entero_Cero)THEN
		        SET Var_Consecutivo := Par_FolioSpei;
		        LEAVE ManejoErrores;
		    END IF;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Recepcion STP Agregado Exitosamente: ", CONVERT(Par_FolioSpei, CHAR));
		SET Var_Control	:= 'FolioSpei';
		SET Var_Consecutivo := Par_FolioSpei;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo,
				Var_ClaveRas AS campoGenerico;
	END IF;

END TerminaStore$$