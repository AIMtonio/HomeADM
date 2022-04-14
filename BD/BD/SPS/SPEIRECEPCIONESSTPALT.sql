DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESSTPALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESSTPALT`(
	-- STORED PROCEDURE QUE REALIZA EL ALTA DE LAS RECEPCIONES DE STP
	INOUT Par_FolioSpei			BIGINT(20),			-- Folio e identificador unico del registro
	Par_TipoPago				INT(2),				-- Tipo de Pago correspondiente a la tabla TIPOSPAGOSPEI
	Par_TipoCuentaOrd			INT(2),				-- Tipo de Cuenta del Ordenante correspondiente a la tabla TIPOSCUENTASPEI
	Par_CuentaOrd				VARCHAR(20),		-- Numero de Cuenta del Ordenante
	Par_NombreOrd				VARCHAR(40),		-- Nombre del Ordenante

	Par_RFCOrd					VARCHAR(18),		-- RFC del Ordenante
	Par_TipoOperacion			INT(2),				-- Tipo de Operacion
	Par_MontoTransferir			DECIMAL(16,2),		-- Monto a Transferir
	Par_IVA						DECIMAL(16,2),		-- IVA aplicado a la recepcion
	Par_InstiRemitente			INT(5),				-- Institucion del Remitente correspondiente a la tabla INSTITUCIONESSPEI

	Par_InstiReceptora			INT(5),				-- Institucion del Receptor/Beneficiario correspondiente a la tabla INSTITUCION
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
	Par_FolioBanxico			BIGINT(20),			-- Folio Banxico (Aca se almacenara el Folio recibido por STP)

	Par_FolioPaquete			BIGINT(20),			-- Folio del Paquete
	Par_FolioServidor			BIGINT(20),			-- Folio del Servidor
	Par_Topologia				CHAR(1),			-- Topologia. T) Topologia T | V) Topologia V
	Par_Empresa					VARCHAR(50),		-- Empresa asignada por STP

	Par_Salida					CHAR(1), 			-- Salida
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(350),		-- Mensaje de error

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
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);			-- Entero Vacio
	DECLARE Decimal_Cero		DECIMAL(18,2);		-- Decimal Vacio
	DECLARE Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE Salida_SI			CHAR(1);			-- Indica un valor SI
	DECLARE Salida_NO			CHAR(1);			-- Indica un valor NO
	DECLARE Num_Uno				INT(1);				-- Numero 1
	DECLARE RepOper				CHAR(1);			-- Indica que no se ha reportado la operacion a Banxico
	DECLARE Est_Reg				CHAR(1);			-- Estatus registrada
	DECLARE Fecha_Sist			DATE;				-- Fecha del Sistema

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_CantNega		DECIMAL(18,2);		-- Cantidad negativa
	DECLARE Var_FechaOpe		DATE;				-- Fecha operacion
	DECLARE Var_Estatus			CHAR(1);			-- Estatus SAFI
	DECLARE ImporteMaximo		DECIMAL(18,2);		-- Importe maximo para transferir spei
	DECLARE Var_ClaveRasExist	VARCHAR(30);		-- Almacena la Clave de Rastreo en caso de que ya se encuentre en la tabla

	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';						-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero		:= 0;						-- Entero Cero
	SET Decimal_Cero	:= 0.0;						-- DECIMAL cero
	SET Salida_SI		:= 'S';						-- Salida SI
	SET Salida_NO		:= 'N';						-- Salida NO
	SET Num_Uno 		:= 1;						-- Numero uno
	SET ImporteMaximo	:= 999999999999.99;			-- Importe maximo para las transferencias spei
	SET RepOper			:= 'N';						-- No se ha reportado la operacion a Banxico
	SET Est_Reg			:= 'R';						-- Estatus registrada

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESSTPALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SET Fecha_Sist := (SELECT FechaSistema FROM PARAMETROSSIS);

		-- Si el tipo de pago es 4 entonces se valida que el tipo de operacion no sea vacio
		SET Var_ClaveRasExist	:= (SELECT ClaveRastreo
										FROM SPEIRECEPCIONES
										WHERE ClaveRastreo = Par_ClaveRastreo
										AND FechaOperacion = Fecha_Sist);

		SET Var_ClaveRasExist	:= IFNULL(Var_ClaveRasExist, Cadena_Vacia);

		IF(Var_ClaveRasExist != Cadena_Vacia) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:='Clave de Rastreo ya existe';
			SET Var_Control	:=  'claveRastreo' ;
			LEAVE ManejoErrores;
		END IF;

		-- VALIDACION QUE EL MONTO A TRANSFERIR SEA MAYOR AL PERMITIDO POR SPEI
		IF (Par_MontoTransferir > ImporteMaximo) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:='El Monto es mayor al monto permitido.';
			SET Var_Control	:= 'montoTransferir' ;
			LEAVE ManejoErrores;
		END IF;

		-- Si la referencia cobranza viene nula se setea con un valor vacio.
		SET Par_ReferenciaCobranza	:= IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

		-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);

		-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
		SET Par_CuentaBenefiDos		:= IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos 	:= IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos		:= IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos	:= IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos		:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);
		SET Par_ClaveRastreoDos		:= IFNULL(Par_ClaveRastreoDos, Cadena_Vacia);

		-- Si la clave de pago viene nula se setea con un valor vacio
		SET Par_ClavePago	:= IFNULL(Par_ClavePago, Cadena_Vacia);

		-- Se setea la fecha de operacion  fecha del sistema
		SET Var_FechaOpe	:= Fecha_Sist;

		-- Se setea estatus recepcion con 1
		SET Var_Estatus		:= Est_Reg;

		-- Se setea causa devolucion con valor cero
		SET Par_CausaDevol	:= IFNULL(Par_CausaDevol, Entero_Cero);

		-- Si la inf adicional viene nula se setea con un valor vacio
		SET Par_InfAdicional:= IFNULL(Par_InfAdicional, Cadena_Vacia);

		SET Aud_FechaActual	:= CURRENT_TIMESTAMP();

		-- SE SETEA EL VALOR DEL FOLIO DE PARAMETROS INCREMENTANDO EN 1
		SET Par_FolioSpei	:= (SELECT IFNULL(MAX(FolioEnvio),Entero_Cero) + 1 FROM PARAMETROSSPEI);

		-- Se actualiza el campo en la tabla PARAMETROSSPEI
		UPDATE PARAMETROSSPEI SET
		FolioEnvio	= Par_FolioSpei;

		INSERT INTO SPEIRECEPCIONES (
			FolioSpeiRecID,						TipoPagoID,								TipoCuentaOrd,							CuentaOrd,							NombreOrd,
			RFCOrd,								TipoOperacion,							MontoTransferir,						IVAComision,						InstiRemitenteID,
			InstiReceptoraID,					CuentaBeneficiario,						NombreBeneficiario,						RFCBeneficiario,					TipoCuentaBen,
			ConceptoPago,						ClaveRastreo,							CuentaBenefiDos,						NombreBenefiDos,					RFCBenefiDos,
			TipoCuentaBenDos,					ConceptoPagoDos,						ClaveRastreoDos,						ReferenciaCobranza,					ReferenciaNum,
			Estatus,							Prioridad,								FechaOperacion,							FechaCaptura,						ClavePago,
			AreaEmiteID,						EstatusRecep,							CausaDevol,								InfAdicional,						RepOperacion,
			Firma,								Folio,									FolioBanxico,							FolioPaquete,						FolioServidor,
			Topologia,							Empresa,								EmpresaID,								Usuario,							FechaActual,
			DireccionIP,						ProgramaID,								Sucursal,								NumTransaccion)
		VALUES(
			Par_FolioSpei,						Par_TipoPago,							Par_TipoCuentaOrd,						FNENCRYPTSAFI(Par_CuentaOrd),		FNENCRYPTSAFI(Par_NombreOrd),
			FNENCRYPTSAFI(Par_RFCOrd),			Par_TipoOperacion,						FNENCRYPTSAFI(Par_MontoTransferir),		Par_IVA,							Par_InstiRemitente,
			Par_InstiReceptora,					FNENCRYPTSAFI(Par_CuentaBeneficiario),	FNENCRYPTSAFI(Par_NombreBeneficiario),	FNENCRYPTSAFI(Par_RFCBeneficiario),	Par_TipoCuentaBen,
			FNENCRYPTSAFI(Par_ConceptoPago),	Par_ClaveRastreo,						Par_CuentaBenefiDos,					Par_NombreBenefiDos,				Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,				Par_ConceptoPagoDos,					Par_ClaveRastreoDos,					Par_ReferenciaCobranza,				Par_ReferenciaNum,
			Var_Estatus,						Par_Prioridad,							Var_FechaOpe,							Par_FechaCaptura,					Par_ClavePago,
			Par_AreaEmiteID,					Par_EstatusRecep,						Par_CausaDevol,							Par_InfAdicional,					RepOper,
			Par_Firma,							Par_Folio,								Par_FolioBanxico,						Par_FolioPaquete,					Par_FolioServidor,
			Par_Topologia,						Par_Empresa,							Aud_EmpresaID,							Aud_Usuario,						Aud_FechaActual,
			Aud_DireccionIP,					Aud_ProgramaID,							Aud_Sucursal,							Aud_NumTransaccion);

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Recepcion SPEI Agregado Exitosamente: ', CONVERT(Par_FolioSpei, CHAR));
		SET Var_Control	:= 'numero' ;
		SET Var_Consecutivo	:=Par_FolioSpei;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$