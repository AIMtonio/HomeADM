-- SP BITACORACARGAFACTALT

DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACARGAFACTALT`;
DELIMITER $$


CREATE PROCEDURE `BITACORACARGAFACTALT`(
# ==========================================================================
# ------- STORED PARA ALTA DE BITACORA DE CARGA MASIVA DE FACTURAS ---------
# ==========================================================================
    Par_FolioCargaID		INT(11), 		-- Folio del archivo de Carga
    Par_FechaCarga			DATE, 			-- Fecha de carga de la factura
	Par_MesSubirFact		INT(11),		-- Mes seleccionado para subir las facturas, 1 - 12
    Par_UUID				VARCHAR(1000),	-- Folio UUID de la factura
    Par_Estatus				VARCHAR(100),	-- Estatus de la factura

	Par_EsCancelable		VARCHAR(500), 	-- Descripcion si la factura es cancelable o no
    Par_EstatusCance		VARCHAR(100), 	-- Estatus de la concelacion
	Par_Tipo				VARCHAR(100),	-- I-INGRESO, P-PAGO
    Par_Anio				INT(11),		-- Anio de la factura
    Par_Mes					INT(11),		-- Mes de la factura

	Par_Dia					INT(11),		-- Dia de la factura
    Par_FechaEmision		DATETIME,		-- Fecha emision de la factura
    Par_FechaTimbrado		DATETIME,		-- Fecha timbrado de la factura
	Par_Serie				VARCHAR(100),	-- Serie de la factura
    Par_Folio				BIGINT(20),		-- Folio de la factura

	Par_LugarExpedicion		BIGINT(20),		-- Lugar de expedicion de la factura
    Par_Confirmacion		VARCHAR(1000),	-- Confirmacion de la factura
    Par_CfdiRelacionados	VARCHAR(1000),	-- CFDI relacionados de la factura
	Par_FormaPago			VARCHAR(500),	-- Forma de pago de la factura
    Par_MetodoPago			VARCHAR(500),	-- Metodo de pago de la factura

	Par_CondicionesPago		VARCHAR(500),	-- Condiciones de pago de la factura
    Par_TipoCambio			INT(11),		-- Tipo de cambio de la factura
    Par_Moneda				VARCHAR(500),	-- Moneda de la factura
	Par_SubTotal			DECIMAL(14,2),	-- Subtotal de la factura
    Par_Descuento			DECIMAL(14,2),	-- Descuento de la factura

	Par_Total				DECIMAL(14,2),	-- Total de la factura
    Par_ISRRetenido			DECIMAL(14,2),	-- ISR Retenido de la factura
    Par_ISRTrasladado		DECIMAL(14,2),	-- ISR Trasladado de la factura
	Par_IVARetenidoGlobal	DECIMAL(14,2),	-- IVA Retenido Global de la factura
    Par_IVARetenido6		DECIMAL(14,2),	-- IVA Retenido 6 de la factura

	Par_IVATrasladado16		DECIMAL(14,2),	-- IVA Trasladado 16 de la factura
    Par_IVATrasladado8		DECIMAL(14,2),	-- IVA Trasladado 8 de la factura
    Par_IVAExento			VARCHAR(10),	-- IVA Exento de la factura
	Par_BaseIVAExento		DECIMAL(14,2),	-- Base IVA Exento de la factura
    Par_IVATasaCero			VARCHAR(10),	-- IVA Tasa cero de la factura

	Par_BaseIVATasaCero		DECIMAL(14,2),	-- Base IVA Tasa cero de la factura
    Par_IEPSRetenidoTasa	DECIMAL(14,2),	-- IEPS Retenido Tasa de la factura
    Par_IEPSTrasladadoTasa	DECIMAL(14,2),	-- IEPS Trasladado Tasa de la factura
	Par_IEPSRetenidoCuota	DECIMAL(14,2),	-- IEPS Retenido Cuota de la factura
    Par_IEPSTrasladadoCuota	DECIMAL(14,2),	-- IEPS Trasladado Cuota de la factura

	Par_TotalImpRetenidos	DECIMAL(14,2),	-- Total de impuestos retenidos de la factura
    Par_TotalImpTrasladados	DECIMAL(14,2),	-- Total de impuestos trasladados de la factura
    Par_TotalRetenLocales	DECIMAL(14,2),	-- Total retenciones locales de la factura
	Par_TotalTraslaLocales	DECIMAL(14,2),	-- Total traslados locales de la factura
    Par_ImpuestoLocRetenido	DECIMAL(14,2),	-- Impuesto local retenido de la factura

	Par_TasadeRetenLocal	DECIMAL(14,2),	-- Tasa de Retencion Local de la factura
    Par_ImporteRetenLocal	DECIMAL(14,2),	-- Importe de Retencion Local de la factura
    Par_ImpLocalTrasladado	DECIMAL(14,2),	-- Impuesto Local Trasladado de la factura
	Par_TasadeTrasladoLocal	DECIMAL(14,2),	-- Tasa de Traslado Local de la factura
    Par_ImporteTrasLocal	DECIMAL(14,2),	-- Importe de Traslado Local de la factura

 	Par_RfcEmisor			VARCHAR(20),	-- Tasa de Retencion Local de la factura
    Par_NombreEmisor		VARCHAR(500),	-- Importe de Retencion Local de la factura
    Par_RegimenFisEmisor	VARCHAR(500),	-- Impuesto Local Trasladado de la factura
	Par_RfcReceptor			VARCHAR(20),	-- Tasa de Traslado Local de la factura
    Par_NombreReceptor		VARCHAR(500),	-- Importe de Traslado Local de la factura

 	Par_UsoCFDIReceptor		VARCHAR(200),	-- Uso CFDI Receptor de la factura
    Par_ResidenciaFiscal	VARCHAR(500),	-- Residencia Fisal receptor de la factura
    Par_NumRegIdTrib		VARCHAR(200),	-- Numero Regimen Tributario CFDI Receptorde la factura
	Par_ListaNegra			VARCHAR(500),	-- Nombre Receptor de la factura
    Par_Conceptos			TEXT,			-- Uso CFDI Receptor de la factura

	Par_PACCertifico		VARCHAR(500),	-- Residencia Fisal receptor de la factura
    Par_RutadelXML			VARCHAR(1000),	-- Uso CFDI Receptorde la factura
    Par_EstatusPro			CHAR(1),		-- P=Procesado N=No Procesado
	Par_EsExitoso			CHAR(1),		-- S- Registro exitoso N- Registro erroneo
    Par_TipoError			INT(11),		-- Numero de error 1- informacion vacia, 2 meses diferentes, 3 proveedor no existe

	Par_DescripcionError	VARCHAR(200),	-- Descripcion del error en la carga de archivo de Facturas

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Aud_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de variables
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FolioFactID		INT(11);			-- Variable para guardar consecutivo de carga masiva facturas

    -- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

    -- Asignacion de constantes
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORACARGAFACTALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Var_FolioFactID	:= (SELECT IFNULL(MAX(FolioFacturaID),Entero_Cero) + 1 FROM BITACORACARGAFACT);
		SET Aud_FechaActual := NOW();
        INSERT INTO BITACORACARGAFACT(
			FolioFacturaID,			FolioCargaID,			FechaCarga,					MesSubirFact,			UUID,
            Estatus,				EsCancelable,			EstatusCancelacion,			Tipo,					Anio,
            Mes,					Dia,					FechaEmision,				FechaTimbrado,			Serie,
            Folio,					LugarExpedicion,		Confirmacion,				CfdiRelacionados,		FormaPago,
            MetodoPago,				CondicionesPago,		TipoCambio,					Moneda,					SubTotal,
            Descuento,				Total,					ISRRetenido,				ISRTrasladado,			IVARetenidoGlobal,
            IVARetenido6,			IVATrasladado16,		IVATrasladado8,				IVAExento,				BaseIVAExento,
            IVATasaCero,			BaseIVATasaCero,		IEPSRetenidoTasa,			IEPSTrasladadoTasa,		IEPSRetenidoCuota,
            IEPSTrasladadoCuota,	TotalImpuestosRetenidos,TotalImpuestosTrasladados,	TotalRetencionesLocales,TotalTrasladosLocales,
            ImpuestoLocalRetenido,	TasadeRetencionLocal,	ImportedeRetencionLocal,	ImpuestoLocalTrasladado,TasadeTrasladoLocal,
            ImportedeTrasladoLocal,	RfcEmisor,				NombreEmisor,				RegimenFiscalEmisor,	RfcReceptor,
            NombreReceptor,			UsoCFDIReceptor,		ResidenciaFiscal, 			NumRegIdTrib,			ListaNegra,
            Conceptos,				PACCertifico,			RutadelXML,					EstatusPro,				EsExitoso,
            TipoError,				DescripcionError,		EmpresaID, 	           		Usuario,				FechaActual,
            DireccionIP, 			ProgramaID,				Sucursal, 	          	 	NumTransaccion
        )VALUES(
			Var_FolioFactID,		Par_FolioCargaID,		Par_FechaCarga,				Par_MesSubirFact,		Par_UUID,
            Par_Estatus,			Par_EsCancelable,		Par_EstatusCance,			Par_Tipo,				Par_Anio,
            Par_Mes,				Par_Dia,				Par_FechaEmision,			Par_FechaTimbrado,		Par_Serie,
            Par_Folio,				Par_LugarExpedicion,	Par_Confirmacion,			Par_CfdiRelacionados,	Par_FormaPago,
            Par_MetodoPago,			Par_CondicionesPago,	Par_TipoCambio,				Par_Moneda,				Par_SubTotal,
            Par_Descuento,			Par_Total,				Par_ISRRetenido,			Par_ISRTrasladado,		Par_IVARetenidoGlobal,
            Par_IVARetenido6,		Par_IVATrasladado16,	Par_IVATrasladado8,			Par_IVAExento,			Par_BaseIVAExento,
            Par_IVATasaCero,		Par_BaseIVATasaCero,	Par_IEPSRetenidoTasa,		Par_IEPSTrasladadoTasa,	Par_IEPSRetenidoCuota,
            Par_IEPSTrasladadoCuota,Par_TotalImpRetenidos,	Par_TotalImpTrasladados,	Par_TotalRetenLocales,	Par_TotalTraslaLocales,
            Par_ImpuestoLocRetenido,Par_TasadeRetenLocal,	Par_ImporteRetenLocal,		Par_ImpLocalTrasladado,	Par_TasadeTrasladoLocal,
            Par_ImporteTrasLocal,	Par_RfcEmisor,			Par_NombreEmisor,			Par_RegimenFisEmisor,	Par_RfcReceptor,
            Par_NombreReceptor,		Par_UsoCFDIReceptor,	Par_ResidenciaFiscal,		Par_NumRegIdTrib,		Par_ListaNegra,
            Par_Conceptos,			Par_PACCertifico,		Par_RutadelXML,				Par_EstatusPro,			Par_EsExitoso,
            Par_TipoError,			Par_DescripcionError,	Aud_EmpresaID,				Aud_Usuario,         	Aud_FechaActual,
            Aud_DireccionIP,     	Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Factura Agregada Exitosamente:',CAST(Var_FolioFactID AS CHAR) );
		SET Var_Control		:= 'mes';
		SET Var_Consecutivo	:= Var_FolioFactID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS Par_FolioCargaID;

	END IF;

END TerminaStore$$