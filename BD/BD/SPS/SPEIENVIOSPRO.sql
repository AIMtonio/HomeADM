-- SP SPEIENVIOSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSPRO`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSPRO`(
# =====================================================================================
# ------- STORE PARA QUE REALIZA EL ALTA DE ENVIO SPEI ---------
# =====================================================================================
	INOUT Par_Folio			BIGINT(20),						-- Folio de SPEI
	INOUT Par_ClaveRas		VARCHAR(30),					-- Clave de rastreo
	Par_TipoPago			INT(2),							-- Tipo de pago
	Par_CuentaAho			BIGINT(12),						-- Numero de cuenta de ahorro
	Par_TipoCuentaOrd		INT(2),							-- Tipo de cuenta ordenante corresponde al Catálogo de tipos cuentas

	Par_CuentaOrd			VARCHAR(20),					-- Numero de CLABE, Numero de tarjeta o Numero de celular.
	Par_NombreOrd			VARCHAR(100),					-- Nombre del ordenante
	Par_RFCOrd				VARCHAR(18),					-- RFC del ordenante
	Par_MonedaID			INT(11),						-- Numero de la moneda Catalogo Monedas
	Par_TipoOperacion		INT(2),							-- Tipo de Operacion Corresponde al Catálogo Tipo de Operación

	Par_MontoTransferir		DECIMAL(16,2),					-- Monto de la transferencia
	Par_IVAPorPagar			DECIMAL(16,2),					-- Monto del iva
	Par_ComisionTrans		DECIMAL(16,2),					-- Comision SPEI dependiendo el tipo de persona (Fisica/Moral)
	Par_IVAComision			DECIMAL(16,2),					-- Iva Comision
	Par_TotalCargoCuenta	DECIMAL(18,2),					-- Monto total de cargo a cuenta

	Par_InstiReceptora		INT(5),							-- Institucion receptoria referencia a la tabla INSTITUCIONESSPEI
	Par_CuentaBeneficiario	VARCHAR(20),					-- Cuenta beneficiario
	Par_NombreBeneficiario	VARCHAR(100),					-- Nombre del beneficiario
	Par_RFCBeneficiario		VARCHAR(18),					-- RFC del beneficiario
	Par_TipoCuentaBen		INT(2),							-- Tipo de Cuenta Corresponde al Catálogo Tipo de Cuenta

	Par_ConceptoPago		VARCHAR(40),					-- Concepto de pago
	Par_CuentaBenefiDos		VARCHAR(20),					-- Cuenta del beneficiario dos
	Par_NombreBenefiDos		VARCHAR(100),					-- Nombre del beneficiario dos
	Par_RFCBenefiDos		VARCHAR(18),					-- RFC del beneficiario dos
	Par_TipoCuentaBenDos	INT(2),							-- Tipo de Cuenta Corresponde al Catálogo Tipo de Cuenta dos

	Par_ConceptoPagoDos		VARCHAR(40),					-- Concepto de Pago Dos
	Par_ReferenciaCobranza	VARCHAR(40),					-- Referencia de cobranza
	Par_ReferenciaNum		INT(7),							-- Referencia Numero
	Par_UsuarioEnvio		VARCHAR(30),					-- Usuario que realiza la operacion
	Par_AreaEmiteID			INT(2),							-- Area que emite la operacion referencia a la tabla AREASEMITESPEI

	Par_OrigenOperacion		CHAR(1),						-- Indica si la Operacion se Origina en Ventanilla,Banca Movil o ClienteSpei
	Par_Salida				CHAR(1),						-- Parametro para salida de datos
	INOUT Par_NumErr		INT,							-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),					-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Par_EmpresaID			INT(11),						-- Parametro de auditoria

	Aud_Usuario				INT(11),						-- Parametro de auditoria
	Aud_FechaActual			DATETIME,						-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(20),					-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),					-- Parametro de auditoria
	Aud_Sucursal			INT(11),						-- Parametro de auditoria

	Aud_NumTransaccion		BIGINT(20)						-- Parametro de auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);					-- Cadena vacia
	DECLARE	Entero_Cero			INT(11);					-- Entero vacio
	DECLARE	Decimal_Cero		DECIMAL(18,2);				-- Decimal vacio
	DECLARE	Fecha_Vacia			DATE;						-- Fecha vacia
	DECLARE Salida_SI 			CHAR(1);					-- Salida si
	DECLARE	Salida_NO			CHAR(1);					-- Salida no
	DECLARE Ban_True			CHAR(1);					-- Bandera es TRUE
	DECLARE Ban_False			CHAR(1);					-- Bandera es FALSE
	DECLARE Est_Pen				CHAR(1);					-- Estatus pendiente
	DECLARE Est_Aut				CHAR(1);					-- Estatus autorizada
	DECLARE Est_Ver				CHAR(1);					-- Estatus pendiente
	DECLARE	Num_Uno				INT(11);					-- Entero uno
	DECLARE CtoCon_Spei			INT(11);					-- Concepto Contable de ENVIO SPEI
	DECLARE	TipoMovAhoCom_Spei	INT(11);					-- Tipo Movimiento Comision Spei
	DECLARE	TipoMovAhoIva_Spei	INT(11);					-- Tipo Movimiento de ahorro con iva
	DECLARE	CtoAho_Spei			INT(11);					-- Pasivo
	DECLARE CtoAhoComSpei		INT(11);					-- Concepto Ahorro Comision por Envio Spei
	DECLARE CtoAhoComSpeiIva	INT(11);					-- Concepto Ahorro Iva Comision por Envio Spei
	DECLARE	AltaPoliza_NO		CHAR(1);					-- No Alta de Poliza
	DECLARE	AltaPoliza_SI		CHAR(1);					-- Si Alta de Poliza
	DECLARE	Nat_Cargo			CHAR(1);					-- Naturaleza Cargo
	DECLARE Nat_Abono			CHAR(1);					-- Naturaleza abono
	DECLARE SeparadorComa		CHAR(1);					-- Separador ","
	DECLARE	AltaMovAhorro_SI	CHAR(1);					-- Si Alta Movimientos Ahorro
	DECLARE	Val_HoraOpera		INT(11);					-- Valida horario de operacion
	DECLARE TipoCuentaClabe		INT(11);					-- Tipo de Cuenta CLABE

	-- Declaracion de Variables
	DECLARE Var_NumEnvio		BIGINT(20);					-- Numero de envio
	DECLARE Var_Control			VARCHAR(400);				-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);					-- Variable consecutivo
	DECLARE Var_ClaveRas		VARCHAR(30);				-- Clave de rastreo SPEI
	DECLARE fecha				CHAR(8);					-- fecha
	DECLARE claveEmisor			INT(3);						-- Clave del emisor
	DECLARE claveEmiCom			INT(5);						-- clave del emisor a 5 digitos
	DECLARE LongfolRefNum		CHAR(17);					-- Longitud del folio y el numero de referencia
	DECLARE RefNumFol			CHAR(17);					-- Longitud del folio y el numero de referencia
	DECLARE Var_PrioEnvio		INT(1);						-- prioridad de envio
	DECLARE Var_FechaAuto		DATETIME;					-- Fecha de autorizacion
	DECLARE Var_EstatusEnv		INT(3);						-- Estatus de envio
	DECLARE Var_ClavePago		VARCHAR(10);				-- Clave de pago
	DECLARE Var_Estatus			CHAR(1);					-- estatus del safi
	DECLARE Var_FechaRecep		DATETIME;					-- fecha de recepcion
	DECLARE Var_FechaEnvio		DATETIME;					-- fecha envio
	DECLARE Var_CausaDevol		INT(2);						-- causa devolucion
	DECLARE Var_InstiRemi		INT(5);						-- Institucion remitente
	DECLARE Var_AutTeso			CHAR(1);					-- si el spei necesita autorizacion de tesoreria
	DECLARE Var_MonReqVen		DECIMAL(18,2) ;				-- Monto a partir del cual spei necesita autorizacion de tesoreria
	DECLARE Var_ClienteID		INT(11);					-- Numero de Cliente
	DECLARE	Var_Poliza			BIGINT;						-- Numero de poliza
	DECLARE	Var_DescMov			VARCHAR(150);				-- Descripcion de Movimiento
	DECLARE	Var_DesInsRecep		VARCHAR(100);				-- Nombre de Intitucion Receptora
	DECLARE Var_Referencia		VARCHAR(50);				-- Referencia
	DECLARE Var_Firma			VARCHAR(1000);				-- firma
	DECLARE Var_FechaSis		DATE;						-- fecha sistema
	DECLARE Var_FolioSTP		INT(11);					-- Folio que regresa STP
	DECLARE Var_TipoConexion	CHAR(1);					-- Tipo de Conexion
	DECLARE Var_CliSTPOrd		VARCHAR(10);				-- Institucion remitente
	DECLARE Var_CliSTPRecep 	VARCHAR(10);				-- Institucion receptora

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';							-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01 00:00:00';		-- Fecha Vacia
	SET Entero_Cero			:= 0;							-- Entero Cero
	SET Decimal_Cero		:= 0.0;							-- DECIMAL cero
	SET Salida_SI			:= 'S';							-- Salida SI
	SET Salida_NO			:= 'N';							-- Salida NO
	SET Var_NumEnvio		:= 0;							-- Numero de Envio
	SET Ban_True			:= 'S';							-- Bandera es TRUE
	SET Ban_False			:= 'N';							-- Bandera es FALSE
	SET Est_Pen				:= 'P';							-- Estatus pendiente
	SET Est_Aut				:= 'A';							-- Estatus autorizada
	SET Est_Ver				:= 'V';							-- Estatus verificado
	SET Num_Uno				:= 1;							-- Entero uno
	SET CtoCon_Spei			:= 808;							-- Concepto Contable de ENVIO SPEI
	SET TipoMovAhoCom_Spei	:= 212;							-- Tipo Movimiento Comision Spei
	SET TipoMovAhoIva_Spei	:= 213;							-- Tipo Movimiento Iva de Comision Spei
	SET CtoAho_Spei			:= 1;							-- Pasivo
	SET Var_Poliza			:= 0;							-- Inicializar Poliza
	SET CtoAhoComSpei		:= 24;							-- Concepto Ahorro Comision por Envio Spei
	SET CtoAhoComSpeiIva	:= 25;							-- Concepto Ahorro Iva Comision por Envio Spei
	SET AltaPoliza_NO		:= 'N';							-- No Alta de Poliza
	SET AltaPoliza_SI		:= 'S';							-- Si Alta de Poliza
	SET Nat_Cargo			:= 'C';							-- Naturaleza Cargo
	SET Nat_Abono			:= 'A';							-- Naturaleza abono
	SET SeparadorComa		:= ',';							-- Separador ,
	SET AltaMovAhorro_SI	:= 'S';							-- Si Alta Movimientos Ahorro
	SET Val_HoraOpera		:= 1;							-- Validacion del Horario SPEI
	SET TipoCuentaClabe		:= 40;							-- Tipo de Cuenta CLABE

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSPRO');
				SET Var_Control	= 'SQLEXCEPTION';
			END;

		-- SE VALIDA EL HORARIO DE SPEI LLAMANDO AL STORE HORARIOSPEIVAL
		CALL HORARIOSPEIVAL(
			Par_EmpresaID,		0,					Val_HoraOpera,		Salida_NO,			Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- SE OBTIENE PARTICIPANTESPEI,FECHA, MONTO REQUERIDO PARA AUTORIZACION DE TESORERIA Y SI REQUIERE AUTORIZACION DE TESORERIA
		-- DE PARAMETROSSPEI

		SELECT	ParticipanteSpei,	DATE_FORMAT(FechaApertura,'%Y%m%d'),	MonReqAutTeso,SpeiVenAutTes
			INTO	claveEmisor,		fecha, 									Var_MonReqVen,Var_AutTeso
			FROM PARAMETROSSPEI;

		-- INSTITUCION REMITENTE
		SET Var_InstiRemi := (SELECT ParticipanteSpei FROM PARAMETROSSPEI);

		-- SI LA INSTITUCION RECEPTORA EXISTE EN LA INSTITUCIONESSPEI

		IF NOT EXISTS (SELECT	InstitucionID
			FROM INSTITUCIONESSPEI
			WHERE	InstitucionID = Var_InstiRemi) THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := CONCAT('La Institucion Remitente ',Var_InstiRemi, ' no Existe');
				SET Var_Control:= 'instiRemi' ;
				LEAVE ManejoErrores;
		END IF;

		-- VALIDAMOS QUE EL CLIENTE ANTE STP NO SEA EL MISMO PARA EL REMITENTE Y RECEPTOR
		IF(Par_TipoCuentaOrd = TipoCuentaClabe AND Par_TipoCuentaBen = TipoCuentaClabe) THEN
			SET Var_CliSTPOrd := SUBSTRING(Par_CuentaOrd, 1, 10);
			SET Var_CliSTPRecep := SUBSTRING(Par_CuentaBeneficiario, 1, 10);

			IF(IFNULL(Var_CliSTPOrd, Cadena_Vacia) = IFNULL(Var_CliSTPRecep, Cadena_Vacia)) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('La institucion remitente y receptora no pueden ser la misma [', Var_CliSTPRecep, "].");
				SET Var_Control:= 'instiRemi' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		
		-- PRIORIDAD DE ENVIO DE PARAMETROS SPEI
		SET Var_PrioEnvio := (SELECT Prioridad FROM PARAMETROSSPEI);
		-- ESTATUS DE ENVIO
		SET Var_EstatusEnv := Entero_Cero;
		-- CLAVE PAGO
		SET Var_ClavePago := Cadena_Vacia;

		-- ESTATUS
		-- FECHA AUTORIZACION DEPENDE DE PARAMETROSSPEI SPEI NECESITA AUTORIZACION DE TESORERIA

		IF ((Var_AutTeso = Ban_True ) || (Par_MontoTransferir > Var_MonReqVen) ) THEN
			SET Var_FechaAuto := Fecha_Vacia;
			SET Var_Estatus := Est_Pen;
		ELSE
			SET Var_Estatus := Est_Ver;
			SET Var_FechaAuto := CURRENT_TIMESTAMP();
		END IF;

		-- FECHA RECEPCION
		SET Var_FechaRecep := CURRENT_TIMESTAMP();
		-- FECHA ENVIO
		SET Var_FechaEnvio := Fecha_Vacia;
		-- CAUSA DEVOLUCION
		SET Var_CausaDevol := Entero_Cero;
		-- Firma
		SET Var_Firma := Cadena_Vacia;
		-- FolioSTP
		SET Var_FolioSTP := Entero_Cero;
		-- Tipo de Conexion
		SELECT TipoOperacion
			INTO Var_TipoConexion
			FROM PARAMETROSSPEI;

		CALL SPEIENVIOSALT(
			Par_Folio,				Par_ClaveRas,			Par_TipoPago,			Par_CuentaAho,			Par_TipoCuentaOrd,
			Par_CuentaOrd,			Par_NombreOrd,			Par_RFCOrd,				Par_MonedaID,			Par_TipoOperacion,
			Par_MontoTransferir,	Par_IVAPorPagar,		Par_ComisionTrans,		Par_IVAComision,		Var_InstiRemi,
			Par_TotalCargoCuenta,	Par_InstiReceptora,		Par_CuentaBeneficiario, Par_NombreBeneficiario,	Par_RFCBeneficiario,
			Par_TipoCuentaBen,		Par_ConceptoPago,		Par_CuentaBenefiDos,	Par_NombreBenefiDos,	Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,	Par_ConceptoPagoDos,	Par_ReferenciaCobranza,	Par_ReferenciaNum,		Var_PrioEnvio,
			Var_FechaAuto,			Var_EstatusEnv,			Var_ClavePago,			Par_UsuarioEnvio,		Par_AreaEmiteID,
			Var_Estatus,			Var_FechaRecep,			Var_FechaEnvio,			Var_CausaDevol,			Var_Firma,
			Par_OrigenOperacion,	Var_FolioSTP,			Var_TipoConexion,		Salida_NO,				Par_NumErr,
			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'numero';
			SET Var_Consecutivo := Par_Folio;
			LEAVE ManejoErrores;
		END IF;

		SELECT	Descripcion	 INTO Var_DesInsRecep
			FROM INSTITUCIONESSPEI
			WHERE	InstitucionID = Par_InstiReceptora;

		-- SET	Var_DescMov := CONCAT('ENVIO SPEI',SeparadorComa,rtrim(Var_DesInsRecep),SeparadorComa,Par_CuentaBeneficiario,SeparadorComa,Par_NombreBeneficiario,SeparadorComa,Var_ClaveRas,SeparadorComa,ltrim(rtrim(CONVERT(Par_ReferenciaNum,CHAR(7)))),SeparadorComa,Par_ConceptoPago);

		SET Var_Poliza := Entero_Cero;

		SELECT	ClienteID	INTO	Var_ClienteID
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Par_CuentaAho;

		-- se setea la fecha de operaciona fecha del sistema
		SELECT	FechaSistema 	INTO	Var_FechaSis
			FROM	PARAMETROSSIS;

		IF(Par_ReferenciaNum != Entero_Cero) THEN
			SET Var_Referencia	:= RTRIM(CONVERT(SUBSTRING(Par_ReferenciaNum,1,7),CHAR(7)));
		ELSE
			SET Var_Referencia	:= RTRIM(CONVERT(SUBSTRING(Par_Folio,1,7),CHAR(7)));
		END IF;

		-- Contabilidad para SPEI

		CALL CONTASPEISPRO(
			Par_Folio,				Aud_Sucursal,		Par_MonedaID,		Var_FechaSis,		Var_FechaSis,
			Par_MontoTransferir,	Par_ComisionTrans,	Par_IVAComision,	Par_ClaveRas,		Var_Referencia,
			Par_CuentaAho,			AltaPoliza_SI, 		Var_Poliza,			CtoCon_Spei, 		Nat_Abono,
			AltaMovAhorro_SI,		Par_CuentaAho, 		Var_ClienteID, 		Nat_Cargo,			CtoAho_Spei,
			Entero_Cero,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control		:= 'numero';
			SET Var_Consecutivo := Par_Folio;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT("Envio SPEI Agregado Exitosamente: ", CONVERT(Par_Folio, CHAR));
		SET Var_Control		:= 'numero';
		SET Var_Consecutivo	:= Par_Folio;
		SET Var_ClaveRas	:= Par_ClaveRas;

	END ManejoErrores;

		-- Si Par_Salida = S (SI)
		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr ,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo,
					Var_ClaveRas AS campoGenerico;
		END IF;

-- Fin de SP
END TerminaStore$$
