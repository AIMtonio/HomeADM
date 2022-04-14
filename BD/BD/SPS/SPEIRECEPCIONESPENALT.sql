-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPENALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPENALT`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPENALT`(
	-- STORED PROCEDURE QUE SE ENCARGA DE REGISTRAR EN UNA TABLA DE PASO LA INFORMACION DE UNA RECEPCION DE SPEI.
	INOUT Par_SpeiRecPenID		BIGINT(20),			-- Folio e identificador unico que es generado por el SP SPEIRECEPCIONESPENALT
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
	DECLARE Est_Reg				CHAR(1);			-- Estatus registrada
	DECLARE RepOper				CHAR(1);			-- Indica que no se ha reportado la operacion a Banxico

	-- Declaracion de Variables
	DECLARE Fecha_Sist			DATE;				-- Fecha del Sistema
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_FechaOpe		DATE;				-- Fecha operacion
	DECLARE Var_Estatus			CHAR(1);			-- Estatus SAFI

	-- Asignacion de Constantes.
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- Decimal cero
	SET Salida_SI				:= 'S';				-- Salida SI
	SET Salida_NO				:= 'N';				-- Salida NO
	SET Est_Reg			:= 'R';						-- Estatus registrada
	SET RepOper			:= 'N';						-- No se ha reportado la operacion a Banxico

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESPENALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SET Fecha_Sist := (SELECT FechaSistema FROM PARAMETROSSIS);

		-- Si la referencia cobranza viene nula se setea con un valor vacio.
		SET Par_ReferenciaCobranza := IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

		-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
		SET Par_TipoOperacion := IFNULL(Par_TipoOperacion, Entero_Cero);

		-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
		SET Par_CuentaBenefiDos	:= IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos := IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos := IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos := IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos	:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);
		SET Par_ClaveRastreoDos	 := IFNULL(Par_ClaveRastreoDos, Cadena_Vacia);

		SET Par_ClavePago := IFNULL(Par_ClavePago, Cadena_Vacia);
		SET Var_FechaOpe := Fecha_Sist;
		SET Var_Estatus	:= Est_Reg;
		SET Par_CausaDevol	:= IFNULL(Par_CausaDevol, Entero_Cero);
		SET Par_InfAdicional:= IFNULL(Par_InfAdicional, Cadena_Vacia);
		SET Aud_FechaActual	:= CURRENT_TIMESTAMP();

		SELECT MAX(SpeiRecepcionPenID)
			INTO Par_SpeiRecPenID
			FROM SPEIRECEPCIONESPEN;

		-- SE SETEA EL VALOR DEL FOLIO DE PARAMETROS INCREMENTANDO EN 1
		SET Par_SpeiRecPenID := (SELECT IFNULL(MAX(FolioRecepcionPen),Entero_Cero) + 1 FROM PARAMETROSSPEI);

		-- Se actualiza el campo en la tabla PARAMETROSSPEI
		UPDATE PARAMETROSSPEI SET
			FolioRecepcionPen = Par_SpeiRecPenID;

		INSERT INTO SPEIRECEPCIONESPEN (
				SpeiRecepcionPenID,					TipoPagoID,								TipoCuentaOrd,							CuentaOrd,							NombreOrd,
				RFCOrd,								TipoOperacion,							MontoTransferir,						IVAComision,						InstiRemitenteID,
				InstiReceptoraID,					CuentaBeneficiario,						NombreBeneficiario,						RFCBeneficiario,					TipoCuentaBen,
				ConceptoPago,						ClaveRastreo,							CuentaBenefiDos,						NombreBenefiDos,					RFCBenefiDos,
				TipoCuentaBenDos,					ConceptoPagoDos,						ClaveRastreoDos,						ReferenciaCobranza,					ReferenciaNum,
				Estatus,							Prioridad,								FechaOperacion,							FechaCaptura,						ClavePago,
				AreaEmiteID,						EstatusRecep,							CausaDevol,								InfAdicional,						RepOperacion,
				Firma,								Folio,									FolioBanxico,							FolioPaquete,						FolioServidor,
				Topologia,							Empresa,								NumTransaccionReg,						NumTransaccionRec,					FolioSpeiRecID,
				PIDTarea,							FechaProceso,							EmpresaID,								Usuario,							FechaActual,
				DireccionIP,						ProgramaID,								Sucursal,								NumTransaccion
			)
			VALUES(
				Par_SpeiRecPenID,					Par_TipoPago,							Par_TipoCuentaOrd,						FNENCRYPTSAFI(Par_CuentaOrd),		FNENCRYPTSAFI(Par_NombreOrd),
				FNENCRYPTSAFI(Par_RFCOrd),			Par_TipoOperacion,						FNENCRYPTSAFI(Par_MontoTransferir),		Par_IVA,							Par_InstiRemitente,
				Par_InstiReceptora,					FNENCRYPTSAFI(Par_CuentaBeneficiario),	FNENCRYPTSAFI(Par_NombreBeneficiario),	FNENCRYPTSAFI(Par_RFCBeneficiario),	Par_TipoCuentaBen,
				FNENCRYPTSAFI(Par_ConceptoPago),	Par_ClaveRastreo,						Par_CuentaBenefiDos,					Par_NombreBenefiDos,				Par_RFCBenefiDos,
				Par_TipoCuentaBenDos,				Par_ConceptoPagoDos,					Par_ClaveRastreoDos,					Par_ReferenciaCobranza,				Par_ReferenciaNum,
				Var_Estatus,						Par_Prioridad,							Var_FechaOpe,							Par_FechaCaptura,					Par_ClavePago,
				Par_AreaEmiteID,					Par_EstatusRecep,						Par_CausaDevol,							Par_InfAdicional,					RepOper,
				Par_Firma,							Par_Folio,								Par_FolioBanxico,						Par_FolioPaquete,					Par_FolioServidor,
				Par_Topologia,						Par_Empresa,							Aud_NumTransaccion,						Entero_Cero,						Entero_Cero,
				Cadena_Vacia, 						Fecha_Vacia,							Aud_EmpresaID,							Aud_Usuario,						Aud_FechaActual,
				Aud_DireccionIP,					Aud_ProgramaID,							Aud_Sucursal,							Aud_NumTransaccion
			);

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Recepcion SPEI Agregado Exitosamente: ', CONVERT(Par_SpeiRecPenID, CHAR));
		SET Var_Control	:= 'numero' ;
		SET Var_Consecutivo	:= Par_SpeiRecPenID;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
