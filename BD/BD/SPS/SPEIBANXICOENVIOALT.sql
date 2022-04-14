DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIBANXICOENVIOALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIBANXICOENVIOALT`(
	-- STORED PROCEDURE QUE SE ENCARGA DE REGISTRAR NUEVAS ORDENES DE PAGO DE SPEI
	INOUT Par_Folio			BIGINT(20),				-- Clave identificadora del Registro
	INOUT Par_ClaveRastreo	VARCHAR(30),			-- Clave de Rastreo que genera el SP
	Par_TipoPago			INT(2),					-- Tipo de Pago correspondiente a la tabla TIPOSPAGOSPEI
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de Ahorro correspondiente a la tabla CUENTASAHO
	Par_TipoCuentaOrd		INT(2),					-- Tipo de Cuenta del Ordenante correspondiente a la tabla TIPOSCUENTASPEI

	Par_CuentaOrd			VARCHAR(20),			-- Cuenta del Ordenante
	Par_NombreOrd			VARCHAR(100),			-- Nombre del Ordenante
	Par_RFCOrd				VARCHAR(18),			-- RFC del Ordenante
	Par_MonedaID			INT(11),				-- Tipo de Moneda correspondiente a la tabla de MONEDAS
	Par_TipoOperacion		INT(2),					-- Tipo de Operacion correspondiente a la tabla TIPOSOPERACIONSPEI

	Par_MontoTransferir		DECIMAL(16,2),			-- Monto a Transferir
	Par_IVAPorPagar			DECIMAL(16,2),			-- Monto del IVA que pagara el Cliente al Beneficiario del SPEI
	Par_ComisionTrans		DECIMAL(16,2),			-- Comision SPEI dependiendo el tipo de persona (Fisica/Moral)
	Par_IVAComision			DECIMAL(16,2),			-- IVA Comision SPEI
	Par_InstiRemitente		INT(5),					-- Institucion del Remitente correspondiente a la tabla INSTITUCIONESSPEI

	Par_TotalCargoCuenta	DECIMAL(18,2),			-- Monto total de cargo a cuenta
	Par_InstiReceptora		INT(5),					-- Institucion Receptora correspondiente a la tabla INSTITUCIONESSPEI
	Par_CuentaBeneficiario	VARCHAR(20),			-- Cuenta del Beneficiario
	Par_NombreBeneficiario	VARCHAR(100),			-- Nombre del Beneficiario
	Par_RFCBeneficiario		VARCHAR(18),

	Par_TipoCuentaBen		INT(2),					-- Tipo de Cuenta del Beneficiario correspondiente a la tabla TIPOSCUENTASPEI
	Par_ConceptoPago		VARCHAR(40),			-- Concepto de Pago
	Par_CuentaBenefiDos		VARCHAR(20),			-- Cuenta del segundo Beneficiario
	Par_NombreBenefiDos		VARCHAR(100),			-- Nombre del segundo Beneficiario
	Par_RFCBenefiDos		VARCHAR(18),			-- RFC del segundo Beneficiario

	Par_TipoCuentaBenDos	INT(2),					-- Tipo de Cuenta del segundo Beneficiario correspondiente a la tabla TIPOSCUENTASPEI
	Par_ConceptoPagoDos		VARCHAR(40),			-- Concepto de Pago para el segundo Beneficiario
	Par_ReferenciaCobranza	VARCHAR(40),			-- Referencia de Cobranza
	Par_ReferenciaNum		INT(7),					-- Referencia Numerica
	Par_PrioridadEnvio		INT(1),					-- Prioridad del Envio

	Par_FechaAutorizacion	DATETIME,				-- Fecha de Autorizacion del Envio
	Par_EstatusEnv			INT(3),					-- Estatus del Envio correspondiente a la tabla ESTADOSENVIOSPEI
	Par_ClavePago			VARCHAR(10),			-- Clave de Pago
	Par_UsuarioEnvio		VARCHAR(30),			-- Usuario que realiza el Envio
	Par_AreaEmiteID			INT(2),					-- Area que Emite el Envio correspondiente a la tabla AREASEMITESPEI

	Par_Estatus				CHAR(1),				-- Estatus del Envio definido por el SAFI. P) Pendiente por autorizar, A) Autorizada, C) Cancelada, T) Detenida, V) Verificada para Envio, E) Enviada, D) Devuelta
	Par_FechaRecepcion		DATETIME,				-- Fecha de Recepcion
	Par_FechaEnvio			DATETIME,				-- Fecha de Envio
	Par_CausaDevol			INT(2),					-- Causa de Devolucion correspondiente a la tabla CAUSASDEVSPEI
	Par_Firma				VARCHAR(1000),			-- Firma

	Par_OrigenOperacion		CHAR(1),				-- Indica si la Operacion se Origina en Ventanilla,Banca Movil o ClienteSpei
	Par_Salida				CHAR(1),				-- Indica si el SP regresa una salida o no. S) SI, N) No
	INOUT Par_NumErr		INT(11),				-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje del Error
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),				-- Parametro de Auditoria

	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria

	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);				-- Cadena vacia
	DECLARE Entero_Cero		INT(11);				-- Entero Cero
	DECLARE Decimal_Cero	DECIMAL(18,2);			-- Decimal _cero
	DECLARE Fecha_Vacia		DATE;					-- Fecha Vacia
	DECLARE Salida_SI		CHAR(1);				-- Salida si
	DECLARE Salida_NO		CHAR(1);				-- Salida no
	DECLARE tipoCtaClabe	INT(2);					-- Cuenta tipo CLABE
	DECLARE tipoCtaTar		INT(2);					-- Cuenta tipo tarjeta debito
	DECLARE tipoCtaTel		INT(2);					-- Cuenta tipo numero de telefonia movil
	DECLARE LongitudCta		INT(18);				-- Longitud de la cuenta del beneficiario
	DECLARE LongClabe		INT(2);					-- Longitud de la CLABE
	DECLARE LongTarjeta		INT(2);					-- Longitud de la tarjeta
	DECLARE LongCel			INT(2);					-- Longitud del numero telefonico movil
	DECLARE ImporteMaximo	DECIMAL(20,2);			-- Importe maximo para tranferir spei
	DECLARE tipoPagoCua		INT(2);					-- Tipo pago sea 4
	DECLARE Tp_tt			INT(2);					-- Tipo de pago tercero a tercero
	DECLARE Tp_pp			INT(2);					-- Tipo de pago participante a participante
	DECLARE Tp_pt			INT(2);					-- Tipo de pago participante a tercero
	DECLARE Fecha_Sist		DATE;					-- Fecha Sistema
	DECLARE Est_Activo		CHAR(1);				-- Estatus activo
	DECLARE TipoCta_Clabe	INT(11);				-- Tipo de cuenta clabe

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(200);			-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);				-- Variable consecutivo
	DECLARE Var_FechaCan	DATETIME;				-- Fecha de cancelacion
	DECLARE Var_Comentario	VARCHAR(100);			-- Comentario de cancelacion
	DECLARE Var_FolRefNum	VARCHAR(17);			-- Folio y referencia numerica entero
	DECLARE Var_RefNum		VARCHAR(17);			-- Folio y referencia numerica entero
	DECLARE fecha			CHAR(8);				-- Fecha
	DECLARE claveEmisor		INT(3);					-- Clave del emisor
	DECLARE Var_MonReqVen	DECIMAL(18,2);			-- Monto a partir del cual spei necesita autorizacion de tesoreria
	DECLARE Var_AutTeso		CHAR(1);				-- Si el spei necesita autorizacion de tesoreria
	DECLARE Var_FechaOpe	DATE;					-- Fecha operacion
	DECLARE Var_UsuarioAut	INT(11);				-- Usuario autoriza
	DECLARE Var_UsuarioVer	INT(11);				-- Usuario Verifica
	DECLARE Var_FechaVer	DATETIME;				-- Fecha de verificacion
	DECLARE Var_EstatusPago	CHAR(1);				-- Estatus de tipo de pago

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Decimal_Cero		:= 0.0;					-- Decimal cero
	SET Salida_SI			:= 'S';					-- Salida SI
	SET Salida_NO			:= 'N';					-- Salida NO
	SET Par_NumErr			:= 0;					-- Parametro numero de error
	SET Par_ErrMen			:= '';					-- Parametro Mensaje de error
	SET LongClabe			:= 18;					-- Longitud de la CLABE
	SET LongTarjeta			:= 16;					-- Longitud de la tarjeta
	SET LongCel				:= 10;					-- Longitud del numero telefonico movil
	SET ImporteMaximo		:= 999999999999.99;		-- Importe maximo para las transferencias spei
	SET tipoPagoCua			:= 4;					-- Tipo de pago sea 4
	SET Tp_tt				:= 1;					-- Tipo de pago tercero a tercero
	SET Tp_pp				:= 7;					-- Tipo de pago Participante a participante
	SET Tp_pt				:= 5;					-- Tipo de pago de participante a tercero
	SET Est_Activo			:= 'A';					-- Estatus Activo
	SET tipoCtaClabe		:= 40;					-- Tipo de cuenta clabe
	SET tipoCtaTar			:= 3;					-- Tipo de cuenta tarjeta
	SET tipoCtaTel			:= 10;					-- Tipo de cuenta numero de cel.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIBANXICOENVIOALT');
				SET Var_Control	:= 'sqlException';
			END;

		-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
		SET Par_CuentaBenefiDos 	:= IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos 	:= IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos 		:= IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos 	:= IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos		:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);
		-- Si los RFC'S del ordenante o beneficiario viene vacio se setea con cadena vacia

		SET Par_RFCOrd 			:= IFNULL(Par_RFCOrd, Cadena_Vacia);
		SET Par_RFCBeneficiario := IFNULL(Par_RFCBeneficiario, Cadena_Vacia);

		IF NOT EXISTS (SELECT	TipoPagoID
			FROM TIPOSPAGOSPEI
			WHERE	TipoPagoID = Par_TipoPago) THEN
				SET Par_NumErr := 070;
				SET Par_ErrMen := 'Tipo de pago No existe';
				SET Var_Control:= 'tipoPago';
				LEAVE ManejoErrores;
		END IF;

		-- validacion que el tipo de pago este activo
		SET Var_EstatusPago :=(SELECT Estatus FROM TIPOSPAGOSPEI WHERE TipoPagoID = Par_TipoPago);

		IF(Var_EstatusPago != Est_Activo) THEN
			SET Par_NumErr := 071;
			SET Par_ErrMen := 'Tipo de pago inactivo';
			SET Var_Control:= 'EstatusPago';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	InstitucionID
			FROM INSTITUCIONESSPEI
			WHERE	InstitucionID = Par_InstiRemitente) THEN
				SET Par_NumErr	:= 72;
				SET Par_ErrMen	:= 'La institucion remitente no existe';
				SET Var_Control	:= 'InstiRemitente';
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	InstitucionID
			FROM INSTITUCIONESSPEI
			WHERE	InstitucionID = Par_InstiReceptora) THEN
				SET Par_NumErr	:= 073;
				SET Par_ErrMen	:= 'La institucion receptora no existe';
				SET Var_Control	:= 'InstiReceptora';
				LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT	AreaEmiteID
			FROM AREASEMITESPEI
			WHERE	AreaEmiteID = Par_AreaEmiteID) THEN
				SET Par_NumErr	:= 074;
				SET Par_ErrMen	:= 'El area que emite no existe';
				SET Var_Control	:= 'AreaEmite';
				LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPago != Entero_Cero) THEN

			IF(IFNULL(Par_CuentaAhoID,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'La cuenta esta Vacia.';
				SET Var_Control:= 'cuentaAho';
				LEAVE ManejoErrores;
			END IF;

			-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASAHO
			IF NOT EXISTS (SELECT	CuentaAhoID
				FROM CUENTASAHO
				WHERE	CuentaAhoID = Par_CuentaAhoID) THEN
					SET Par_NumErr := 002;
					SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentaAhoID, 'no Existe');
					SET Var_Control:= 'cuentaAhoID';
					LEAVE ManejoErrores;
			END IF;

			-- QUE EL CLIENTE EN LA TABLA CLIENTES
			IF NOT EXISTS (SELECT	CL.ClienteID
				FROM CUENTASAHO CA
					INNER JOIN CLIENTES CL ON CA.ClienteID = CL.ClienteID
				WHERE	CuentaAhoID = Par_CuentaAhoID) THEN
					SET Par_NumErr := 003;
					SET Par_ErrMen := 'El cliente no Existe';
					SET Var_Control:= 'cuentaAhoID';
					LEAVE ManejoErrores;
			END IF;

			-- LLAMADA A LA FUNCION DE VALIDACION DE CARACTERES SPEI
			-- VALIDACIONES PARA EL ORDENANTE
			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreOrd);
			IF(Par_NumErr = 100) THEN
				SET Par_NumErr = 004;
				SET Par_ErrMen = 'Caracter invalido';
				SET Var_Control= 'NombreOrd';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCOrd);
			IF( Par_NumErr= 100) THEN
				SET Par_NumErr = 004;
				SET Par_ErrMen = 'Caracter invalido';
				SET Var_Control= 'RFCOrd';
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES PARA ELBENEFICIARIO UNO
			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBeneficiario);
			IF(Par_NumErr = 100) THEN
				SET Par_NumErr = 004;
				SET Par_ErrMen = 'Caracter invalido';
				SET Var_Control= 'NombreBeneficiario';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBeneficiario);
			IF(Par_NumErr = 100) THEN
				SET Par_NumErr = 004;
				SET Par_ErrMen = 'Caracter invalido';
				SET Var_Control= 'RFCBeneficiario';
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPago);
			IF(Par_NumErr = 100) THEN
				SET Par_NumErr = 004;
				SET Par_ErrMen = 'Caracter invalido';
				SET Var_Control= 'conceptoPago';
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES DEL BENEFICIARIO DOS
			IF(Par_NombreBenefiDos != Cadena_Vacia AND Par_RFCBenefiDos!= Cadena_Vacia AND Par_ConceptoPagoDos != Cadena_Vacia) THEN
				SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBenefiDos);
				IF(Par_NumErr = 100) THEN
					SET Par_NumErr = 004;
					SET Par_ErrMen = 'Caracter invalido';
					SET Var_Control= 'NombreBenefiDos';
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBenefiDos);
				IF(Par_NumErr = 100) THEN
					SET Par_NumErr = 004;
					SET Par_ErrMen = 'Caracter invalido';
					SET Var_Control= 'RFCBenefiDos';
					LEAVE ManejoErrores;
				END IF;

				SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPagoDos);
				IF(Par_NumErr = 100) THEN
					SET Par_NumErr = 004;
					SET Par_ErrMen = 'Caracter invalido';
					SET Var_Control= 'conceptoPagoDos';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- BENEFECIARIO DOS

			-- VALIDACIONES DE COMISIONES E IVA'S
			IF(ISNULL(Par_IVAPorPagar)) THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen := 'El IVA por pagar esta vacio.';
				SET Var_Control:= 'ivaporpagar';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_IVAPorPagar != Decimal_Cero) THEN
				IF(Par_IVAPorPagar < Decimal_Cero) THEN
					SET Par_NumErr := 006;
					SET Par_ErrMen := 'El IVA por pagar no puede ser negativo.';
					SET Var_Control:= 'ivaporpagar';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Si el IVA por pagar viene nulo se seteo con decimal cero
			SET Par_IVAPorPagar := IFNULL(Par_IVAPorPagar, Decimal_Cero);

			IF(ISNULL(Par_ComisionTrans)) THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'La Comision por Transferencia esta Vacia.';
				SET Var_Control:= 'comisionTrans';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_ComisionTrans != Decimal_Cero) THEN
				IF(Par_ComisionTrans < Decimal_Cero) THEN
					SET Par_NumErr := 008;
					SET Par_ErrMen := 'La comision por transferencia no puede ser negativa.';
					SET Var_Control:= 'comisionTrans';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Si la comision transferencia viene nulo se seteo con decimal cero
			SET Par_ComisionTrans := IFNULL(Par_ComisionTrans, Decimal_Cero);

			IF(ISNULL(Par_IVAComision)) THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen :='El IVA por Comision esta Vacio.';
				SET Var_Control:= 'IVAComision';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_IVAComision != Decimal_Cero) THEN
				IF(Par_IVAComision < Decimal_Cero) THEN
					SET Par_NumErr := 010;
					SET Par_ErrMen := 'El IVA comision no puede ser negativo.';
					SET Var_Control:= 'IVAComision';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- VALIDACIONES DEL TIPO DE PAGO ES TERCERO A TERCERO
			IF(Par_TipoPago = Tp_tt) THEN
				IF(IFNULL(Par_NombreOrd,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 011;
					SET Par_ErrMen := 'El Nombre del Ordenante esta Vacio.';
					SET Var_Control:= 'nombreOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_TipoCuentaOrd)) THEN
					SET Par_NumErr := 012;
					SET Par_ErrMen := 'El Tipo de Cuenta Ordenante esta Vacio.';
					SET Var_Control:= 'tipoCuentaOrd';
					LEAVE ManejoErrores;
				END IF;

				-- QUE EL TIPO DE CUENTA DEL ORDENANTE EXISTA EN LA TABLA TIPOSCUENTASPEI
				IF NOT EXISTS (SELECT	TipoCuentaID
					FROM TIPOSCUENTASPEI
					WHERE	TipoCuentaID = Par_TipoCuentaOrd) THEN
						SET Par_NumErr := 013;
						SET Par_ErrMen := CONCAT('El tipo de cuenta ',Par_TipoCuentaOrd, ' no Existe');
						SET Var_Control:= 'tipoCuentaOrd';
						LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CuentaOrd, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 014;
					SET Par_ErrMen := 'La Cuenta Ordenante esta Vacia.';
					SET Var_Control:= 'cuentaOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_RFCOrd)) THEN
					SET Par_NumErr := 015;
					SET Par_ErrMen := 'El RFC del Ordenante esta Vacio.';
					SET Var_Control:= 'RFCOrd';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_NombreBeneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 016;
					SET Par_ErrMen := 'El Nombre del Beneficiario esta Vacio.';
					SET Var_Control:= 'nombreBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CuentaBeneficiario,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 017;
					SET Par_ErrMen := 'La Cuenta del Beneficiario esta Vacia.';
					SET Var_Control:= 'cuentaBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoCuentaBen,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 018;
					SET Par_ErrMen := 'El Tipo de Cuenta del Beneficiario esta Vacio.';
					SET Var_Control:= 'tipoCuentaBen';
					LEAVE ManejoErrores;
				END IF;

				-- SI EL TIPO DE CUENTA EXISTE EN LA TABLA TIPOSCUENTASPEI
				IF NOT EXISTS (SELECT	TipoCuentaID
					FROM TIPOSCUENTASPEI
					WHERE	TipoCuentaID = Par_TipoCuentaBen) THEN
						SET Par_NumErr := 019;
						SET Par_ErrMen := CONCAT('El tipo de cuenta ',Par_TipoCuentaBen, ' del beneficiario no Existe');
						SET Var_Control:= 'tipoCuentBen';
						LEAVE ManejoErrores;
				END IF;

				-- validacion tipo de cuenta y cuenta del beneficiario uno
				IF((Par_TipoCuentaBen !=Entero_Cero AND LENGTH(Par_CuentaBeneficiario) !=Entero_Cero)) THEN
					-- SI LA CUENTA ES CUENTA CLABE
					IF(Par_TipoCuentaBen = tipoCtaClabe) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,char(18)))));
						IF(LongitudCta != LongClabe) THEN
							SET Par_NumErr := 020;
							SET Par_ErrMen := CONCAT('El numero de caracteres no coincide para la CLABE. ',Par_CuentaBeneficiario);
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TARJETA
					IF(Par_TipoCuentaBen = tipoCtaTar) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(16)))));
						IF(LongitudCta != LongTarjeta) THEN
							SET Par_NumErr := 021;
							SET Par_ErrMen := 'El numero de caracteres no coincide para el numero de Tarjeta.';
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
					IF(Par_TipoCuentaBen = tipoCtaTel) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(10)))));
						IF(LongitudCta != LongCel) THEN
							SET Par_NumErr := 022;
							SET Par_ErrMen := 'El numero de caracteres no coincide con el numero de tel. movil.';
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				IF(ISNULL(Par_RFCBeneficiario)) THEN
					SET Par_NumErr := 023;
					SET Par_ErrMen := 'El RFC del Beneficiario esta Vacio.';
					SET Var_Control:= 'RFCBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_AreaEmiteID)) THEN
					SET Par_NumErr := 024;
					SET Par_ErrMen := 'El Area que Emite esta Vacia.';
					SET Var_Control:= 'areaEmiteID';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_ConceptoPago)) THEN
					SET Par_NumErr := 025;
					SET Par_ErrMen := 'El Concepto de Pago esta Vacio.';
					SET Var_Control:= 'conceptoPago';
					LEAVE ManejoErrores;
				END	IF;


				IF(IFNULL(Par_MontoTransferir,Decimal_Cero)) = Decimal_Cero THEN
					SET Par_NumErr := 026;
					SET Par_ErrMen :='El Monto a Transferir esta Vacio.';
					SET Var_Control:=  'montoTransferir';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_MontoTransferir !=Decimal_Cero) THEN
					IF(Par_MontoTransferir > ImporteMaximo) THEN
						SET Par_NumErr := 027;
						SET Par_ErrMen := 'El Monto a Transferir es mayor al monto permitido.';
						SET Var_Control:= 'montoTransferir';
						LEAVE ManejoErrores;
					ELSE
						IF(Par_MontoTransferir < Decimal_Cero) THEN
							SET Par_NumErr := 028;
							SET Par_ErrMen := 'El Monto a Transferir no puede ser negativo.';
							SET Var_Control:= 'montoTransferir';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				-- Si la referencia cobranza viene nula se setea con cero
				SET Par_ReferenciaNum := IFNULL(Par_ReferenciaNum, Entero_Cero);

				-- Si la referencia cobranza viene nula se setea con un valor vacio
				SET Par_ReferenciaCobranza := IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

				IF(ISNULL(Par_TipoPago)) THEN
					SET Par_NumErr := 029;
					SET Par_ErrMen := 'El Tipo de Pago esta Vacio.';
					SET Var_Control:= 'tipoPago';
					LEAVE ManejoErrores;
				END IF;

				-- PRIORIDAD DE ENVIO DE PARAMETROS SPEI
				SET Par_PrioridadEnvio := (SELECT	Prioridad	FROM	PARAMETROSSPEI);

				IF(IFNULL(Par_InstiReceptora,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 030;
					SET Par_ErrMen := 'La Institucion Receptora esta Vacia.';
					SET Var_Control:= 'instiReceptora';
					LEAVE ManejoErrores;
				END IF;

				-- SI LA INSTITUCION RECEPTORA EXISTE EN LA INSTITUCIONESSPEI
				IF NOT EXISTS (SELECT	InstitucionID
					FROM INSTITUCIONESSPEI
					WHERE	InstitucionID = Par_InstiReceptora) THEN
						SET Par_NumErr := 031;
						SET Par_ErrMen := CONCAT('La Institucion Receptora ',Par_InstiReceptora, ' no Existe');
						SET Var_Control:= 'instiReceptora';
						LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_UsuarioEnvio,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 032;
					SET Par_ErrMen := 'El Usuario que envio la Operacion esta vacio.';
					SET Var_Control:=  'usuarioEnvio';
					LEAVE ManejoErrores;
				END IF;

				-- SI EL USUARIO EXISTE EN LA TABLA USUARIOS
				IF NOT EXISTS (SELECT	UsuarioID
					FROM USUARIOS
					WHERE	UsuarioID = Aud_Usuario) THEN
						SET Par_NumErr := 033;
						SET Par_ErrMen := CONCAT('El usuario ',Par_UsuarioEnvio, ' no Existe');
						SET Var_Control:= 'usuarioEnvio';
						LEAVE ManejoErrores;
				END IF;
			END IF;-- fin del tipo de pago tercero a tercero

			-- VALIDA SI EL TIPO DE PAGO ES PARTICIPANTE A PARTICIPANTE
			IF(Par_TipoPago = Tp_pp) THEN
				IF(ISNULL(Par_AreaEmiteID)) THEN
					SET Par_NumErr := 034;
					SET Par_ErrMen := 'El Area que Emite esta Vacia.';
					SET Var_Control:= 'areaEmiteID';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_ConceptoPago)) THEN
					SET Par_NumErr := 035;
					SET Par_ErrMen := 'El Concepto de Pago esta Vacio.';
					SET Var_Control:= 'conceptoPago';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_MontoTransferir,Decimal_Cero)) = Decimal_Cero THEN
					SET Par_NumErr := 036;
					SET Par_ErrMen := 'El Monto a Transferir esta Vacio.';
					SET Var_Control:= 'montoTransferir';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_MontoTransferir !=Decimal_Cero) THEN
					IF(Par_MontoTransferir > ImporteMaximo) THEN
						SET Par_NumErr := 037;
						SET Par_ErrMen := 'El Monto a Transferir es mayor al monto permitido.';
						SET Var_Control:= 'montoTransferir';
						LEAVE ManejoErrores;
					ELSE
						IF(Par_MontoTransferir < Decimal_Cero) THEN
							SET Par_NumErr := 038;
							SET Par_ErrMen := 'El Monto a Transferir no puede ser negativo.';
							SET Var_Control:= 'montoTransferir';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				-- Si la referencia cobranza viene nula se setea con cero
				SET Par_ReferenciaNum := IFNULL(Par_ReferenciaNum, Entero_Cero);

				IF(ISNULL(Par_TipoPago)) THEN
					SET Par_NumErr := 039;
					SET Par_ErrMen := 'El Tipo de Pago esta Vacio.';
					SET Var_Control:= 'tipoPago';
					LEAVE ManejoErrores;
				END IF;

				-- PRIORIDAD DE ENVIO DE PARAMETROS SPEI
				SET Par_PrioridadEnvio := (SELECT	Prioridad	FROM	PARAMETROSSPEI);

				-- CLAVE PAGO
				SET Par_ClavePago  := Cadena_Vacia;

				-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
				SET Par_TipoOperacion := IFNULL(Par_TipoOperacion, Entero_Cero);

				-- SI LA INSTITUCION RECEPTORA EXISTE EN LA INSTITUCIONESSPEI
				IF(IFNULL(Par_InstiReceptora,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 040;
					SET Par_ErrMen := 'La Institucion Receptora esta Vacia.';
					SET Var_Control:=  'instiReceptora';
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS (SELECT	InstitucionID
					FROM INSTITUCIONESSPEI
					WHERE	InstitucionID = Par_InstiReceptora)then
						SET Par_NumErr := 041;
						SET Par_ErrMen := CONCAT('La Institucion Receptora ',Par_InstiReceptora, ' no Existe');
						SET Var_Control:= 'instiReceptora';
						LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_UsuarioEnvio,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 042;
					SET Par_ErrMen := 'El Usuario que envio la Operacion esta vacio.';
					SET Var_Control:= 'usuarioEnvio';
					LEAVE ManejoErrores;
				END IF;

				-- SI EL USUARIO EXISTE EN LA TABLA USUARIOS
				IF NOT EXISTS (SELECT	UsuarioID
					FROM USUARIOS
					WHERE	UsuarioID = Aud_Usuario) THEN
						SET Par_NumErr := 043;
						SET Par_ErrMen := CONCAT('El usuario ',Par_UsuarioEnvio, ' no Existe');
						SET Var_Control:= 'usuarioEnvio';
						LEAVE ManejoErrores;
				END IF;
			END IF; -- si el tipo de pago es participante a participante

			-- VALIDA SI EL TIPO DE PAGO ES PARTICIPANTE A TERCERO
			IF(Par_TipoPago = Tp_pt) THEN
				IF(IFNULL(Par_NombreBeneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 044;
					SET Par_ErrMen := 'El Nombre del Beneficiario esta Vacio.';
					SET Var_Control:=  'nombreBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_CuentaBeneficiario,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 045;
					SET Par_ErrMen := 'La Cuenta del Beneficiario esta Vacia.';
					SET Var_Control:= 'cuentaBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_TipoCuentaBen,Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 046;
					SET Par_ErrMen := 'El Tipo de Cuenta del Beneficiario esta Vacio.';
					SET Var_Control:=  'tipoCuentaBen';
					LEAVE ManejoErrores;
				END IF;

				-- SI EL TIPO DE CUENTA EXISTE EN LA TABLA TIPOSCUENTASPEI
				IF NOT EXISTS (SELECT	TipoCuentaID
					FROM TIPOSCUENTASPEI
					WHERE	TipoCuentaID = Par_TipoCuentaBen) THEN
						SET Par_NumErr := 047;
						SET Par_ErrMen := CONCAT('El tipo de cuenta ',Par_TipoCuentaBen, ' del beneficiario no Existe');
						SET Var_Control:= 'tipoCuentBen';
						LEAVE ManejoErrores;
				END IF;

				-- validacion tipo de cuenta y cuenta del beneficiario uno
				IF((Par_TipoCuentaBen !=Entero_Cero AND LENGTH(Par_CuentaBeneficiario) !=Entero_Cero)) THEN
					-- SI LA CUENTA ES CUENTA CLABE
					IF(Par_TipoCuentaBen = tipoCtaClabe) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(18)))));
						IF(LongitudCta != LongClabe) THEN
							SET Par_NumErr := 048;
							SET Par_ErrMen := CONCAT('El numero de caracteres no coincide para la CLABE. ',Par_CuentaBeneficiario);
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TARJETA
					IF(Par_TipoCuentaBen = tipoCtaTar) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(16)))));
						IF(LongitudCta != LongTarjeta) THEN
							SET Par_NumErr := 049;
							SET Par_ErrMen := 'El numero de caracteres no coincide para el numero de Tarjeta.';
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;

					-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
					IF(Par_TipoCuentaBen = tipoCtaTel) THEN
						SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(10)))));
						IF(LongitudCta != LongCel) THEN
							SET Par_NumErr := 050;
							SET Par_ErrMen := 'El numero de caracteres no coincide con el numero de tel. movil.';
							SET Var_Control:= 'cuentaBeneficiario';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				IF(ISNULL(Par_RFCBeneficiario)) THEN
					SET Par_NumErr := 051;
					SET Par_ErrMen := 'El RFC del Beneficiario esta Vacio.';
					SET Var_Control:= 'RFCBeneficiario';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_AreaEmiteID)) THEN
					SET Par_NumErr := 052;
					SET Par_ErrMen := 'El Area que Emite esta Vacia.';
					SET Var_Control:= 'areaEmiteID';
					LEAVE ManejoErrores;
				END IF;

				IF(ISNULL(Par_ConceptoPago)) THEN
					SET Par_NumErr := 053;
					SET Par_ErrMen := 'El Concepto de Pago esta Vacio.';
					SET Var_Control:=  'conceptoPago';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_MontoTransferir,Decimal_Cero)) = Decimal_Cero THEN
					SET Par_NumErr := 054;
					SET Par_ErrMen := 'El Monto a Transferir esta Vacio.';
					SET Var_Control:= 'montoTransferir';
					LEAVE ManejoErrores;
				END IF;

				IF(Par_MontoTransferir !=Decimal_Cero) THEN
					IF(Par_MontoTransferir > ImporteMaximo) THEN
						SET Par_NumErr := 055;
						SET Par_ErrMen :='El Monto a Transferir es mayor al monto permitido.';
						SET Var_Control:=  'montoTransferir';
						LEAVE ManejoErrores;
					END IF;
				ELSE
					IF(Par_MontoTransferir < Decimal_Cero) THEN
						SET Par_NumErr := 056;
						SET Par_ErrMen := 'El Monto a Transferir no puede ser negativo.';
						SET Var_Control:=  'montoTransferir';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- Si la referencia cobranza viene nula se setea con cero
				SET Par_ReferenciaNum := IFNULL(Par_ReferenciaNum, Entero_Cero);

				IF(ISNULL(Par_TipoPago)) THEN
					SET Par_NumErr := 057;
					SET Par_ErrMen := 'El Tipo de Pago esta Vacio.';
					SET Var_Control:= 'tipoPago';
					LEAVE ManejoErrores;
				END IF;

				-- PRIORIDAD DE ENVIO DE PARAMETROS SPEI
				SET Par_PrioridadEnvio := (SELECT Prioridad FROM PARAMETROSSPEI);

				IF(IFNULL(Par_InstiReceptora,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 058;
					SET Par_ErrMen := 'La Institucion Receptora esta Vacia.';
					SET Var_Control:= 'instiReceptora';
					LEAVE ManejoErrores;
				END IF;

				-- SI LA INSTITUCION RECEPTORA EXISTE EN LA INSTITUCIONESSPEI
				IF NOT EXISTS (SELECT	InstitucionID
					FROM INSTITUCIONESSPEI
					WHERE	InstitucionID = Par_InstiReceptora) THEN
						SET Par_NumErr := 059;
						SET Par_ErrMen := CONCAT('La Institucion Receptora ',Par_InstiReceptora, ' no Existe');
						SET Var_Control:= 'instiReceptora';
						LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_UsuarioEnvio,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 060;
					SET Par_ErrMen := 'El Usuario que envio la Operacion esta vacio.';
					SET Var_Control:= 'usuarioEnvio';
					LEAVE ManejoErrores;
				END IF;

				-- SI EL USUARIO EXISTE EN LA TABLA USUARIOS
				IF NOT EXISTS (SELECT	UsuarioID
					FROM USUARIOS
					WHERE	UsuarioID = Aud_Usuario) THEN
						SET Par_NumErr := 061;
						SET Par_ErrMen := CONCAT('El usuario ',Par_UsuarioEnvio, ' no Existe');
						SET Var_Control:= 'usuarioEnvio';
						LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_MonedaID,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 062;
					SET Par_ErrMen :='La Moneda esta Vacia.';
					SET Var_Control:=  'monedaID';
					LEAVE ManejoErrores;
				END IF;
			END IF; -- end del tipo pago tercero a participante

			-- si el tipo de pago es 4 entonces se valida que el tipo de operacion no sea vacio
			IF(Par_TipoPago = tipoPagoCua) THEN
				IF(IFNULL(Par_TipoOperacion,Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 063;
					SET Par_ErrMen :='El Tipo de Operacion esta Vacio.';
					SET Var_Control:=  'tipoOperacion';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_TotalCargoCuenta,Decimal_Cero))= Decimal_Cero THEN
				SET Par_NumErr := 064;
				SET Par_ErrMen := 'El Total Cargo a Cuenta esta Vacio.';
				SET Var_Control:=  'totalCargoCuenta';
				LEAVE ManejoErrores;
			END IF;

			-- SI EL TIPO DE CUENTA EXISTE EN LA TABLA TIPOSCUENTASPEI
			IF(Par_TipoCuentaBenDos != Entero_Cero) THEN
				IF NOT EXISTS (SELECT	TipoCuentaID
					FROM TIPOSCUENTASPEI
					WHERE	TipoCuentaID = Par_TipoCuentaBenDos) THEN
						SET Par_NumErr := 065;
						SET Par_ErrMen := CONCAT('El tipo de cuenta ',Par_TipoCuentaBenDos, ' del beneficiario no Existe');
						SET Var_Control:= 'tipoCuentBenDos';
						LEAVE ManejoErrores;
				END IF;
			END IF;

			-- validacion tipo de cuenta y cuenta del beneficiario dos
			IF((Par_TipoCuentaBenDos!=Entero_Cero AND LENGTH(Par_CuentaBenefiDos)!=Entero_Cero)) THEN
				-- SI LA CUENTA ES CUENTA CLABE
				IF(Par_TipoCuentaBenDos = tipoCtaClabe) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBenefiDos,CHAR(18)))));
					IF(LongitudCta != LongClabe) THEN
						SET Par_NumErr := 066;
						SET Par_ErrMen := 'El numero de caracteres no coincide para la CLABE.';
						SET Var_Control:= 'cuentaBenefiDos';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TARJETA
				IF(Par_TipoCuentaBenDos = tipoCtaTar) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBenefiDos,CHAR(16)))));
					IF(LongitudCta != LongTarjeta) then
						SET Par_NumErr := 067;
						SET Par_ErrMen :='El numero de caracteres no coincide para el numero de Tarjeta.';
						SET Var_Control:=  'cuentaBenefiDos';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
				IF(Par_TipoCuentaBenDos = tipoCtaTel) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBenefiDos,CHAR(10)))));
					IF(LongitudCta != LongCel) THEN
						SET Par_NumErr := 068;
						SET Par_ErrMen :='El numero de caracteres no coincide con el numero de tel. movil.';
						SET Var_Control:=  'cuentaBeneficiDos';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			SET Par_Firma := Cadena_Vacia;

		END IF;-- end if del tipo de pago diferente de 0

		-- VALIDACIONES SI EL TIPO DE PAGO ES 0 (DEVOLUCION)
		IF(Par_TipoPago = Entero_Cero) THEN
			IF EXISTS (SELECT	ClaveRastreo
				FROM SPEIENVIOS
				WHERE	ClaveRastreo = Par_ClaveRastreo) THEN
					SET Par_NumErr	:= 069;
					SET Par_ErrMen	:= 'La Clave de Rastreo ya existe';
					SET Var_Control	:= 'claveRastreo';
					LEAVE ManejoErrores;
			END IF;
		END IF;

		-- FECHA DE CANCELACION
		SET Var_FechaCan := Fecha_Vacia;

		-- COMENTARIO DE CANCELACION
		SET Var_Comentario := Cadena_Vacia;

		-- SE SETEA EL VALOR DEL FOLIO DE PARAMETROS INCREMENTANDO EN 1
		SET Par_Folio := (SELECT IFNULL(MAX(FolioEnvio),Entero_Cero) + 1 FROM	PARAMETROSSPEI);

		-- Se actualiza el campo en la tabla PARAMETROSSPEI
		UPDATE	PARAMETROSSPEI SET
		FolioEnvio	= Par_Folio;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		-- se setea la fecha de operaciona  fecha del sistema
		SELECT	FechaSistema		INTO	Fecha_Sist
			FROM PARAMETROSSIS;
		SET Var_FechaOpe := Fecha_Sist;

		-- FORMA CLAVE DE RASTREO  SOLO CUANDO EL TIPO DE PAGO NO SEA UNA DEVOLUCION
		IF(Par_TipoPago != Entero_Cero) THEN
			SELECT	ParticipanteSpei,	DATE_FORMAT(FechaApertura,'%Y%m%d'),	MonReqAutTeso,	SpeiVenAutTes
			  INTO	claveEmisor,		fecha, 									Var_MonReqVen,	Var_AutTeso
				FROM PARAMETROSSPEI;

			SET Var_FolRefNum := LTRIM(RTRIM(CONVERT(Par_Folio,CHAR(17))));

			-- SI LA REFERENCIA NUMERICA ES DIFERENTE DE VACIA ENTONCES AGREGA A LA CLAVE DE RASTREO -N DESPUES DEL FOLIO
			IF(Par_ReferenciaNum != Entero_Cero) THEN
				-- Si le longitud es mayor a 17 digitos se obtiene con un substring solo 17
				SET Var_FolRefNum := SUBSTRING(CONCAT(Var_FolRefNum,'-N',Par_ReferenciaNum),1,17);
				SET Var_RefNum := Par_ReferenciaNum;
			ELSE
				SET Var_FolRefNum := SUBSTRING(CONCAT(Var_FolRefNum,'-N',Par_ReferenciaNum),1,17);
				SET Var_RefNum := Par_Folio;
			END IF;

			SET Par_ClaveRastreo  := CONCAT(fecha,(LPAD(CONVERT(claveEmisor,CHAR(5)),5,0)),Var_FolRefNum);
		ELSE
			SET Var_RefNum := Par_ReferenciaNum;
		END IF;

		SET Var_UsuarioAut 			:= Entero_Cero;
		SET Var_UsuarioVer 			:= Entero_Cero;
		SET Var_FechaVer  			:= Fecha_Vacia;
		SET Var_RefNum 				:= IFNULL(Var_RefNum,Par_Folio);

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
			Comentario,				FechaOPeracion,			Firma,					UsuarioAutoriza,        UsuarioVerifica,
			FechaVerifica,      	OrigenOperacion,		NumIntentos,			FolioSTP,				PIDTarea,
			EmpresaID,				Usuario,            	FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES(
			Par_Folio,              Par_ClaveRastreo,       Par_TipoPago,           Par_CuentaAhoID,     	Par_TipoCuentaOrd,
			Par_MonedaID,           Par_TipoOperacion,
			FNENCRYPTSAFI(Par_CuentaOrd),					FNENCRYPTSAFI(Par_NombreOrd),					FNENCRYPTSAFI(Par_RFCOrd),
			FNENCRYPTSAFI(Par_MontoTransferir),				FNENCRYPTSAFI(Par_TotalCargoCuenta),			FNENCRYPTSAFI(Par_CuentaBeneficiario),
			FNENCRYPTSAFI(Par_NombreBeneficiario),			FNENCRYPTSAFI(Par_RFCBeneficiario),				FNENCRYPTSAFI(Par_ConceptoPago),
			Par_IVAPorPagar,        Par_ComisionTrans,      Par_IVAComision,        Par_InstiRemitente,		Par_InstiReceptora,
			Par_TipoCuentaBen,		Par_CuentaBenefiDos,	Par_NombreBenefiDos,    Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,   Par_ConceptoPagoDos,	Par_ReferenciaCobranza,	Var_RefNum,      		Par_PrioridadEnvio,
			Par_FechaAutorizacion,	Par_EstatusEnv,		    Par_ClavePago,	        Par_UsuarioEnvio,       Par_AreaEmiteID,
			Par_Estatus,		    Par_FechaRecepcion,     Par_FechaEnvio,         Par_CausaDevol,			Var_FechaCan,
			Var_Comentario,         Var_FechaOpe,           Par_Firma,              Var_UsuarioAut,         Var_UsuarioVer,
			Var_FechaVer,           Par_OrigenOperacion,	Entero_Cero,			Entero_Cero,			Cadena_Vacia,
			Par_EmpresaID,			Aud_Usuario,            Aud_FechaActual,		Aud_DireccionIP, 		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT("Envio SPEI Agregado Exitosamente: ", CONVERT(Par_Folio, CHAR));
		SET Var_Control:= 'cuentaAhoID';
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