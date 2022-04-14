-- SP SPEIENVIOSALT

DELIMITER ;

DROP PROCEDURE IF EXISTS SPEIENVIOSALT;

DELIMITER $$

CREATE PROCEDURE SPEIENVIOSALT(
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
	Par_InstiRemitente			INT(5),			-- Institucion del Remitente

	Par_TotalCargoCuenta		DECIMAL(18,2),	-- Total del Cargo a la Cuenta
	Par_InstiReceptora			INT(5),			-- Institucion Receptora
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
	Par_AreaEmiteID				INT(2),			-- Area que emite la transferencia

	Par_Estatus					CHAR(1),		-- Estatus del envio definido por el SAFI. P)Pendiente por autorizar, A)Autorizada, C)Cancelada, T)Detenida, V)Verificada para Envio, E)Enviada, D)Devuelta
	Par_FechaRecepcion			DATETIME,		-- Fecha de recepcion
	Par_FechaEnvio				DATETIME,		-- Fecha de envio
	Par_CausaDevol				INT(2),			-- Descripcion de la causa de devolucion
	Par_Firma					VARCHAR(1000),	-- Firma encriptada por la transferencia

	Par_OrigenOperacion			CHAR(1),		-- Indica si la Operacion se Origina en Ventanilla,Banca Movil o ClienteSpei
	Par_FolioSTP				INT(11),		-- Folio regresado por el ws del envio de la orden de pago
	Par_TipoConexion			CHAR(1),		-- Indica si el Tipo de Conexion es por B)Banxico o S)STP
	Par_Salida					CHAR(1),		-- Indica si el SP devuelve una el resultado de la operacion
	INOUT Par_NumErr			INT,			-- Numero de error

	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje del error
	Par_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),	-- Parametro de Auditoria

	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Consecutivo		BIGINT(20);		-- Variable consecutivo
	DECLARE Var_Control			VARCHAR(200);	-- Variable de control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
	DECLARE	Decimal_Cero		DECIMAL(18, 2);	-- Decimal Cero
	DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE Salida_SI			CHAR(1);		-- Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Salida NO
	DECLARE Con_Banxico			CHAR(1);		-- Conexion por Banxico
	DECLARE Con_STP				CHAR(1);		-- Conexion por STP

	-- Asignación de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Salida_SI			:= 'S';				-- Salida SI
	SET Salida_NO			:= 'N';				-- Salida NO
	SET Con_Banxico			:= 'B';				-- Conexion por Banxico
	SET Con_STP				:= 'S';				-- Conexion por STP

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion.',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIENVIOSALT');
				SET Var_Control	= 'sqlException';
			END;

		-- Se valida el tipo de conexion
		SET Par_TipoConexion	:= IFNULL(Par_TipoConexion, Cadena_Vacia);

		IF(Par_TipoConexion = Cadena_Vacia) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Tipo de Conexion se encuentra Vacio';
			SET Var_Control	:= 'TipoConexion';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoConexion != Con_Banxico AND Par_TipoConexion != Con_STP) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Tipo de Conexion [', Par_TipoConexion, '] no es valido');
			SET Var_Control	:= 'TipoConexion';
			LEAVE ManejoErrores;
		END IF;

		-- Si el tipo de conexion es Banxico
		IF(Par_TipoConexion = Con_Banxico) THEN
			CALL SPEIBANXICOENVIOALT(
				Par_Folio,				Par_ClaveRastreo,			Par_TipoPago,				Par_CuentaAhoID,				Par_TipoCuentaOrd,
				Par_CuentaOrd,			Par_NombreOrd,				Par_RFCOrd,					Par_MonedaID,					Par_TipoOperacion,
				Par_MontoTransferir,	Par_IVAPorPagar,			Par_ComisionTrans,			Par_IVAComision,				Par_InstiRemitente,
				Par_TotalCargoCuenta,	Par_InstiReceptora,			Par_CuentaBeneficiario,		Par_NombreBeneficiario,			Par_RFCBeneficiario,
				Par_TipoCuentaBen,		Par_ConceptoPago,			Par_CuentaBenefiDos,		Par_NombreBenefiDos,			Par_RFCBenefiDos,
				Par_TipoCuentaBenDos,	Par_ConceptoPagoDos,		Par_ReferenciaCobranza,		Par_ReferenciaNum,				Par_PrioridadEnvio,
				Par_FechaAutorizacion,	Par_EstatusEnv,				Par_ClavePago,				Par_UsuarioEnvio,				Par_AreaEmiteID,
				Par_Estatus,			Par_FechaRecepcion,			Par_FechaEnvio,				Par_CausaDevol,					Par_Firma,
				Par_OrigenOperacion,	Salida_NO,					Par_NumErr,					Par_ErrMen,						Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,					Aud_Sucursal,
				Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Si el tipo de conexion es STP
		IF(Par_TipoConexion = Con_STP) THEN
			CALL SPEIENVIOSSTPALT(
				Par_Folio,				Par_ClaveRastreo,			Par_TipoPago,				Par_CuentaAhoID,				Par_TipoCuentaOrd,
				Par_CuentaOrd,			Par_NombreOrd,				Par_RFCOrd,					Par_MonedaID,					Par_TipoOperacion,
				Par_MontoTransferir,	Par_IVAPorPagar,			Par_ComisionTrans,			Par_IVAComision,				Par_InstiRemitente,
				Par_TotalCargoCuenta,	Par_InstiReceptora,			Par_CuentaBeneficiario,		Par_NombreBeneficiario,			Par_RFCBeneficiario,
				Par_TipoCuentaBen,		Par_ConceptoPago,			Par_CuentaBenefiDos,		Par_NombreBenefiDos,			Par_RFCBenefiDos,
				Par_TipoCuentaBenDos,	Par_ConceptoPagoDos,		Par_ReferenciaCobranza,		Par_ReferenciaNum,				Par_PrioridadEnvio,
				Par_FechaAutorizacion,	Par_EstatusEnv,				Par_ClavePago,				Par_UsuarioEnvio,				Par_AreaEmiteID,
				Par_Estatus,			Par_FechaRecepcion,			Par_FechaEnvio,				Par_CausaDevol,					Par_Firma,
				Par_FolioSTP,			Par_OrigenOperacion,		Salida_NO,					Par_NumErr,						Par_ErrMen,
				Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,				Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr			:= 000;
		SET Par_ErrMen			:= CONCAT('Orden de Pago Registrada con Exito: ', Par_Folio);
		SET Var_Control			:= '';
		SET Var_Consecutivo		:= Par_Folio;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo,
				Par_ClaveRastreo AS CampoGenerico;
	END IF;

-- Fin del SP
END TerminaStore$$