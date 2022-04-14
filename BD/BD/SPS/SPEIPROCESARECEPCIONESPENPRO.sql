-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIPROCESARECEPCIONESPENPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIPROCESARECEPCIONESPENPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEIPROCESARECEPCIONESPENPRO`(
	-- STORED PROCEDURE ENCARGADO DE PROCESAR UNA RECEPCION PENDIENTE
	Par_SpeiRecPenID					BIGINT(20),			-- Folio de una recepcion pendiente por procesar
	INOUT Par_FolioSpei 				BIGINT(20),			-- Folio del spei recepcionado

	Par_Salida							CHAR(1),			-- Indica si el SP regresa una salida o no. S) SI, N) No
	INOUT Par_NumErr					INT(11),			-- Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),		-- Mensaje del Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),			-- Parametro de Auditoria
	Aud_Usuario							INT(11),			-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal						INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);			-- Indica una Cadena Vacia
	DECLARE Entero_Cero					INT(11);			-- Indica un Entero Vacio
	DECLARE Decimal_Cero				DECIMAL(18,2);		-- Indica un Decimal Vacio
	DECLARE Fecha_Vacia					DATE;				-- Indica una Fecha Vacia
	DECLARE Salida_SI					CHAR(1);			-- Indica un valor SI
	DECLARE Salida_NO					CHAR(1);			-- Indica un valor NO
	DECLARE Est_Regist					CHAR(1);			-- Estatus registrado

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo				BIGINT(20);			-- Variable consecutivo
	DECLARE Var_SpeiRecPenID 			BIGINT(20);			-- Variable consecutivo
	DECLARE Fecha_Sist					DATE;				-- Fecha del Sistema
	DECLARE Var_Estatus 				VARCHAR(2);			-- Estatus de la recepcion pendiente.
	DECLARE Var_FolioSpei			    BIGINT(20);			-- Folio e identificador unico que es generado por el SP SPEIRECEPCIONESSTPALT
	DECLARE Var_TipoPago				INT(2);				-- Tipo de Pago correspondiente a la tabla TIPOSPAGOSPEI
	DECLARE Var_TipoCuentaOrd			INT(2);				-- Tipo de Cuenta del Ordenante correspondiente a la tabla TIPOSCUENTASPEI
	DECLARE Var_CuentaOrd				VARCHAR(20);		-- Numero de Cuenta del Ordenante
	DECLARE Var_NombreOrd				VARCHAR(100);		-- Nombre del Ordenante
	DECLARE Var_RFCOrd					VARCHAR(18);		-- RFC del Ordenante
	DECLARE Var_TipoOperacion			INT(2);				-- Tipo de Operacion
	DECLARE Var_MontoTransferir			DECIMAL(16,2);		-- Monto a Transferir
	DECLARE Var_IVAComision				DECIMAL(16,2);		-- IVA aplicado a la recepcion
	DECLARE Var_InstiRemitente			INT(5);				-- Institucion del Remitente correspondiente a la tabla INSTITUCIONESSPEI
	DECLARE Var_InstiReceptora			INT(5);				-- Institucion del Receptor/Beneficiario correspondiente a la tabla INSTITUCIONESSPEI
	DECLARE Var_CuentaBeneficiario		VARCHAR(20);		-- Numero de Cuenta del Beneficiario
	DECLARE Var_NombreBeneficiario		VARCHAR(40);		-- Nombre del Beneficiario
	DECLARE Var_RFCBeneficiario			VARCHAR(18);		-- RFC del Beneficiario
	DECLARE Var_TipoCuentaBen			INT(2);				-- Tipo de Cuenta del Beneficiario correspondiente a la tabla TIPOSCUENTASPEI
	DECLARE Var_ConceptoPago			VARCHAR(210);		-- Concepto de Pago
	DECLARE Var_ClaveRastreo			VARCHAR(30);		-- Clave de Rastreo enviada por STP
	DECLARE Var_CuentaBenefiDos			VARCHAR(20);		-- Cuenta del segundo Beneficiario
	DECLARE Var_NombreBenefiDos			VARCHAR(40);		-- Nombre del segundo Beneficiario
	DECLARE Var_RFCBenefiDos			VARCHAR(18);		-- RFC del segundo Beneficiario
	DECLARE Var_TipoCuentaBenDos		INT(2);				-- Tipo de Cuenta del segundo Beneficiario correspondiente a la tabla TIPOSCUENTASPEI
	DECLARE Var_ConceptoPagoDos			VARCHAR(40);		-- Concepto de Pago para el segundo Beneficiario
	DECLARE Var_ClaveRastreoDos			VARCHAR(30);		-- Clave de Rastreo enviada por STP del segundo Beneficiario
	DECLARE Var_ReferenciaCobranza		VARCHAR(40);		-- Referencia de Cobranza
	DECLARE Var_ReferenciaNum			INT(7);				-- Referencia Numerica
	DECLARE Var_Prioridad				INT(1);				-- Prioridad
	DECLARE Var_FechaOperacion			DATETIME;			-- Fecha de Operacion
	DECLARE Var_FechaCaptura			DATETIME;			-- Fecha de Captura
	DECLARE Var_ClavePago				VARCHAR(10);		-- Clave de Pago
	DECLARE Var_AreaEmiteID				INT(2);				-- Area que Emite correspondiente a la tabla AREASEMITESPEI
	DECLARE Var_EstatusRecep			INT(3);				-- Estatus de la Recepcion
	DECLARE Var_CausaDevol				INT(2);				-- Causa de Devolucion correspondiente a la tabla CAUSASDEVSPEI
	DECLARE Var_InfAdicional			VARCHAR(100);		-- Informacion Adicional
	DECLARE Var_Firma					VARCHAR(250);		-- Firma
	DECLARE Var_Folio					BIGINT(20);			-- Folio Emisor
	DECLARE Var_FolioBanxico			BIGINT(20);			-- Folio Banxico (Aca se almacenara el Folio recibido por STP[idAbono])
	DECLARE Var_FolioPaquete			BIGINT(20);			-- Folio del Paquete
	DECLARE Var_FolioServidor			BIGINT(20);			-- Folio del Servidor
	DECLARE Var_Topologia				CHAR(1);			-- Topologia (T = Topologia T, V = Topologia V)
	DECLARE Var_Empresa					VARCHAR(50);		-- Empresa asignada por STP
	DECLARE Var_RepOperacion 			CHAR(1);			-- Indica si ya fue reportada la operacion a banxico(S = Si, Ya se reporto si fue abonada o devuelta, N = No, No se ha reportado)

	-- Asignacion de Constantes.
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Decimal_Cero					:= 0.0;				-- Decimal cero
	SET Salida_SI						:= 'S';				-- Salida SI
	SET Salida_NO						:= 'N';				-- Salida NO
	SET Est_Regist						:= 'R';				-- Estatus registrado

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIPROCESARECEPCIONESPENPRO');
				SET Var_Control = 'SQLEXCEPTION';
				SET Var_Consecutivo := Entero_Cero;
			END;

		SET Fecha_Sist := (SELECT FechaSistema FROM PARAMETROSSIS);

		SELECT SpeiRecepcionPenID,		Estatus
			INTO Var_SpeiRecPenID,		Var_Estatus
			FROM SPEIRECEPCIONESPEN
			WHERE SpeiRecepcionPenID = Par_SpeiRecPenID;

		IF(IFNULL(Var_SpeiRecPenID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'No se encontro la recepcion a procesar.';
			SET Var_Control	:= 'SpeiRecepcionPenID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus <> Est_Regist) THEN
			SET Par_NumErr 	:= 2;
			SET Par_ErrMen 	:= 'La recepcion ha sido procesada previamente.';
			SET Var_Control	:= 'SpeiRecepcionPenID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 	SpeiRecepcionPenID,								TipoPagoID,				TipoCuentaOrd,			FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,						FNDECRYPTSAFI(NombreOrd) AS NombreOrd,
				IVAComision,									TipoOperacion,			InstiRemitenteID,		FNDECRYPTSAFI(MontoTransferir) as MontoTransferir,			FNDECRYPTSAFI(RFCOrd) RFCOrd,
				FNDECRYPTSAFI(RFCBeneficiario) RFCBeneficiario,	InstiReceptoraID,		TipoCuentaBen,			FNDECRYPTSAFI(CuentaBeneficiario) as CuentaBeneficiario,	FNDECRYPTSAFI(NombreBeneficiario) as NombreBeneficiario,
				FNDECRYPTSAFI(ConceptoPago) ConceptoPago,		ClaveRastreo,			CuentaBenefiDos,		NombreBenefiDos,											RFCBenefiDos,
				TipoCuentaBenDos,								ConceptoPagoDos,		ClaveRastreoDos,		ReferenciaCobranza,											ReferenciaNum,
				Estatus,										Prioridad,				FechaOperacion,			FechaCaptura,												ClavePago,
				AreaEmiteID,									EstatusRecep,			CausaDevol,				InfAdicional,												RepOperacion,
				Firma,											Folio,					FolioBanxico,			FolioPaquete,												FolioServidor,
				Topologia,										Empresa
			INTO
				Var_SpeiRecPenID,								Var_TipoPago,			Var_TipoCuentaOrd,		Var_CuentaOrd,												Var_NombreOrd,
				Var_IVAComision,								Var_TipoOperacion,		Var_InstiRemitente,		Var_MontoTransferir,										Var_RFCOrd,
				Var_RFCBeneficiario,							Var_InstiReceptora,		Var_TipoCuentaBen,		Var_CuentaBeneficiario,										Var_NombreBeneficiario,
				Var_ConceptoPago,								Var_ClaveRastreo,		Var_CuentaBenefiDos,	Var_NombreBenefiDos,										Var_RFCBenefiDos,
				Var_TipoCuentaBenDos,							Var_ConceptoPagoDos,	Var_ClaveRastreoDos,	Var_ReferenciaCobranza,										Var_ReferenciaNum,
				Var_Estatus,									Var_Prioridad,			Var_FechaOperacion,		Var_FechaCaptura,											Var_ClavePago,
				Var_AreaEmiteID,								Var_EstatusRecep,		Var_CausaDevol,			Var_InfAdicional,											Var_RepOperacion,
				Var_Firma,										Var_Folio,				Var_FolioBanxico,		Var_FolioPaquete,											Var_FolioServidor,
				Var_Topologia,									Var_Empresa
			FROM SPEIRECEPCIONESPEN
			WHERE SpeiRecepcionPenID = Par_SpeiRecPenID;

		CALL SPEIRECEPCIONESSTPPRO(
			Par_FolioSpei,				Var_TipoPago,				Var_TipoCuentaOrd,			Var_CuentaOrd,				Var_NombreOrd,
			Var_RFCOrd,					Var_TipoOperacion,			Var_MontoTransferir,		Var_IVAComision,			Var_InstiRemitente,
			Var_InstiReceptora,			Var_CuentaBeneficiario,		Var_NombreBeneficiario,		Var_RFCBeneficiario,		Var_TipoCuentaBen,
			Var_ConceptoPago,			Var_ClaveRastreo,			Var_CuentaBenefiDos,		Var_NombreBenefiDos,		Var_RFCBenefiDos,
			Var_TipoCuentaBenDos,		Var_ConceptoPagoDos,		Var_ClaveRastreoDos,		Var_ReferenciaCobranza,		Var_ReferenciaNum,
			Var_Prioridad,				Var_FechaCaptura,			Var_ClavePago,				Var_AreaEmiteID,			Var_EstatusRecep,
			Var_CausaDevol,				Var_InfAdicional,			Var_Firma,					Var_Folio,					Var_FolioBanxico,
			Var_FolioPaquete,			Var_FolioServidor,			Var_Topologia,				Var_Empresa,				Salida_NO,
			Par_NumErr,					Par_ErrMen,					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion
		);

		IF (Par_NumErr <> Entero_Cero) THEN
			SET Var_Control	:= 'SpeiRecepcionPendID';
			SET Par_FolioSpei := Entero_Cero;
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_Consecutivo := Par_FolioSpei;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
