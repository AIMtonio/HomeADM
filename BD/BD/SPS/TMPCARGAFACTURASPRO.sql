-- SP TMPCARGAFACTURASPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `TMPCARGAFACTURASPRO`;

DELIMITER $$

CREATE PROCEDURE `TMPCARGAFACTURASPRO`(
# ===================================================================================
# STORED PARA VALIDAR LOS REGISTROS DE LA CARGA MASIVA DE FACTURAS POR ETL
# ===================================================================================
	Par_RutaArchivo					VARCHAR(250),		-- Ruta del archivo cargado

    Par_Salida						CHAR(1),			-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),			-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),		-- Parametro de entrada/salida de mensaje de error
	Aud_EmpresaID 					INT(11), 			-- Parametros de auditoria
	Aud_Usuario						INT(11),			-- Parametros de auditoria

    Aud_FechaActual					DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal					INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Entero_Uno				INT(1);				-- Entero Uno
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante para fecha vacia
    DECLARE FechaSist				DATE;				-- Constante Fecha del Sistema
	DECLARE SalidaSI				CHAR(1);			-- Salida Si
	DECLARE SalidaNO				CHAR(1);			-- Salida No
    DECLARE ErroInfVacia			INT(11);			-- Numero de error para identificar informacion vacia
	DECLARE ErroMesDif				INT(11);			-- Numero de error para identificar mes diferente
    DECLARE ErroProvNoExis			INT(11);			-- Numero de error para identificar que el error proveedor no existe
    DECLARE ErrUUID					INT(11);			-- Identificador único universal "Folio Fiscal"
    DECLARE Con_EstatusC			CHAR(1);			-- Estatus cerrado

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE Var_FolioCargaID		INT(11);			-- Consecutivo siguiente al ultimo ID de la tabla ARCHIVOSCARGAFACT
	DECLARE Var_NumRegistros		BIGINT(12);			-- Numero de registros de la tabla TMPCARGAFACTURAS
    DECLARE Var_Contador			BIGINT(12);			-- Variable contador para el ciclo while
    DECLARE Var_ProvExistente		INT(11);			-- Variable para almacenar el identificador de un proveedor existente

	DECLARE Var_ContadorExito		BIGINT(12);			-- Contador de cargas exitosas
	DECLARE Var_ContadorError		BIGINT(12);			-- Contador de cargas fallidas
	DECLARE Var_Exito				CHAR(1);			-- Variable para almacenar bandera de exito o error
	DECLARE Var_MensajeResult		VARCHAR(200);		-- Valores NumRegistros, ContadorExito, ContadorError y MontoTotal concatenados
	DECLARE Error_Key				INT(11);			-- Numero de error en la transaccion

    DECLARE Var_FechaCarga			DATE; 				-- Fecha de carga de la factura
    DECLARE Var_MesSubirFact		INT(11);		    -- Mes seleccionado para subir las facturas, 1 - 12
    DECLARE Var_UUID				VARCHAR(1000);	    -- Folio UUID de la factura
    DECLARE Var_Estatus				VARCHAR(100);       -- Estatus de la factura

    DECLARE Var_EsCancelable		VARCHAR(500);       -- Descripcion si la factura es cancelable o no
    DECLARE Var_EstatusCance		VARCHAR(100);       -- Estatus de la concelacion
    DECLARE Var_Tipo				VARCHAR(100);	    -- I-INGRESO, P-PAGO
    DECLARE Var_Anio				INT(11);		    -- Anio de la factura
    DECLARE Var_Mes					INT(11);		    -- Mes de la factura

    DECLARE Var_Dia					INT(11);		    -- Dia de la factura
    DECLARE Var_FechaEmision		DATETIME;		    -- Fecha emision de la factura
    DECLARE Var_FechaTimbrado		DATETIME;		    -- Fecha timbrado de la factura
    DECLARE Var_Serie				VARCHAR(100);	    -- Serie de la factura
    DECLARE Var_Folio				BIGINT(20);		    -- Folio de la factura

    DECLARE Var_LugarExpedicion		BIGINT(20);		    -- Lugar de expedicion de la factura
    DECLARE Var_Confirmacion		VARCHAR(1000);	    -- Confirmacion de la factura
    DECLARE Var_CfdiRelacionados	VARCHAR(1000);	    -- CFDI relacionados de la factura
    DECLARE Var_FormaPago			VARCHAR(500);	    -- Forma de pago de la factura
    DECLARE Var_MetodoPago			VARCHAR(500);	    -- Metodo de pago de la factura

    DECLARE Var_CondicionesPago		VARCHAR(500);	    -- Condiciones de pago de la factura
    DECLARE Var_TipoCambio			INT(11);		    -- Tipo de cambio de la factura
    DECLARE Var_Moneda				VARCHAR(500);	    -- Moneda de la factura
    DECLARE Var_SubTotal			DECIMAL(14,2);	    -- Subtotal de la factura
    DECLARE Var_Descuento			DECIMAL(14,2);	    -- Descuento de la factura

    DECLARE Var_Total				DECIMAL(14,2);	    -- Total de la factura
    DECLARE Var_ISRRetenido			DECIMAL(14,2);	    -- ISR Retenido de la factura
    DECLARE Var_ISRTrasladado		DECIMAL(14,2);	    -- ISR Trasladado de la factura
    DECLARE Var_IVARetenidoGlobal	DECIMAL(14,2);	    -- IVA Retenido Global de la factura
    DECLARE Var_IVARetenido6		DECIMAL(14,2);	    -- IVA Retenido 6 de la factura

    DECLARE Var_IVATrasladado16		DECIMAL(14,2);	    -- IVA Trasladado 16 de la factura
    DECLARE Var_IVATrasladado8		DECIMAL(14,2);	    -- IVA Trasladado 8 de la factura
    DECLARE Var_IVAExento			VARCHAR(10);	    	-- IVA Exento de la factura
    DECLARE Var_BaseIVAExento		DECIMAL(14,2);	    -- Base IVA Exento de la factura
    DECLARE Var_IVATasaCero			VARCHAR(10);		    -- IVA Tasa cero de la factura

    DECLARE Var_BaseIVATasaCero		DECIMAL(14,2);	    -- Base IVA Tasa cero de la factura
    DECLARE Var_IEPSRetenidoTasa	DECIMAL(14,2);	    -- IEPS Retenido Tasa de la factura
    DECLARE Var_IEPSTrasladadoTasa	DECIMAL(14,2);	    -- IEPS Trasladado Tasa de la factura
    DECLARE Var_IEPSRetenidoCuota	DECIMAL(14,2);	    -- IEPS Retenido Cuota de la factura
    DECLARE Var_IEPSTrasladadoCuota	DECIMAL(14,2);	    -- IEPS Trasladado Cuota de la factura

    DECLARE Var_TotalImpRetenidos	DECIMAL(14,2);	    -- Total de impuestos retenidos de la factura
    DECLARE Var_TotalImpTrasladados	DECIMAL(14,2);	    -- Total de impuestos trasladados de la factura
    DECLARE Var_TotalRetenLocales	DECIMAL(14,2);	    -- Total retenciones locales de la factura
    DECLARE Var_TotalTraslaLocales	DECIMAL(14,2);	    -- Total traslados locales de la factura
    DECLARE Var_ImpuestoLocRetenido	DECIMAL(14,2);	    -- Impuesto local retenido de la factura

    DECLARE Var_TasadeRetenLocal	DECIMAL(14,2);	    -- Tasa de Retencion Local de la factura
    DECLARE Var_ImporteRetenLocal	DECIMAL(14,2);	    -- Importe de Retencion Local de la factura
    DECLARE Var_ImpLocalTrasladado	DECIMAL(14,2);	    -- Impuesto Local Trasladado de la factura
    DECLARE Var_TasadeTrasladoLocal	DECIMAL(14,2);	    -- Tasa de Traslado Local de la factura
    DECLARE Var_ImporteTrasLocal	DECIMAL(14,2);	    -- Importe de Traslado Local de la factura

    DECLARE Var_RfcEmisor			VARCHAR(20);	    -- Tasa de Retencion Local de la factura
    DECLARE Var_NombreEmisor		VARCHAR(500);	    -- Importe de Retencion Local de la factura
    DECLARE Var_RegimenFisEmisor	VARCHAR(500);	    -- Impuesto Local Trasladado de la factura
    DECLARE Var_RfcReceptor			VARCHAR(20);	    -- Tasa de Traslado Local de la factura
    DECLARE Var_NombreReceptor		VARCHAR(500);	    -- Importe de Traslado Local de la factura

    DECLARE Var_UsoCFDIReceptor		VARCHAR(200);	    -- Uso CFDI Receptor de la factura
    DECLARE Var_ResidenciaFiscal	VARCHAR(500);	    -- Residencia Fisal receptor de la factura
    DECLARE Var_NumRegIdTrib		VARCHAR(200);	    -- Numero Regimen Tributario CFDI Receptorde la factura
    DECLARE Var_ListaNegra			VARCHAR(500);	    -- Nombre Receptor de la factura
    DECLARE Var_Conceptos			TEXT;	    -- Uso CFDI Receptor de la factura

    DECLARE Var_PACCertifico		VARCHAR(500);	    -- Residencia Fisal receptor de la factura
    DECLARE Var_RutadelXML			VARCHAR(1000);	    -- Uso CFDI Receptorde la factura
    DECLARE Var_EstatusPro			CHAR(1);		    -- P=Procesado N=No Procesado
    DECLARE Var_EsExitoso			CHAR(1);		    -- S- Registro exitoso N- Registro erroneo
    DECLARE Var_TipoError			INT(11);		    -- Numero de error 1- informacion vacia, 2 meses diferentes, 3 proveedor no existe
	DECLARE Var_FechaFactura		DATE;				-- Fecha de la factura
    DECLARE Var_DescripcionError	VARCHAR(200);       -- Descripcion del error en la carga de archivo de Facturas
	DECLARE Var_EjercioCont			INT(11);			-- Ejercicio contable actual
    DECLARE Var_NumPeriodosAbiertos INT(11);			-- Numero de periodos abiertos
    DECLARE Var_EstatusProv		    CHAR(1);			-- Estatus del Proveedor

   	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Entero_Uno					:= 1;				-- Entero Uno
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET SalidaSI					:= 'S';				-- Salida Si
	SET SalidaNO					:= 'N';				-- Salida No
	SET Con_EstatusC				:= 'C';
    SET ErroInfVacia				:= 1;
    SET ErroMesDif					:= 2;
    SET ErroProvNoExis				:= 3;
    SET ErrUUID						:= 4;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TMPCARGAFACTURASPRO');
			SET Var_Control = 'sqlException';
		END;

		SELECT		MesSubirFact
			INTO	Var_MesSubirFact
			FROM	TMPCARGAFACTURAS
			LIMIT	1;

		SET Var_MesSubirFact := IFNULL(Var_MesSubirFact,Entero_Cero);

		IF (Par_RutaArchivo = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'Especifique la Ruta del archivo a Cargar';
			SET Var_Control := 'rutaArchivo';
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones
		IF (Var_MesSubirFact = Entero_Cero) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'Especifique el Mes de Carga de las Facturas';
			SET Var_Control := 'mes';
			LEAVE ManejoErrores;
		END IF;


		SELECT		COUNT(`ID`)
			INTO	Var_NumRegistros
			FROM	TMPCARGAFACTURAS;

		-- Valores por default
		SET Par_RutaArchivo		:= IFNULL(Par_RutaArchivo, Cadena_Vacia);
		SET Aud_EmpresaID		:= IFNULL(Aud_EmpresaID, Entero_Cero);
		SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Aud_FechaActual		:= NOW();
		SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
		SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
		SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
		SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);
		SET FechaSist 			:= (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Var_FolioCargaID 	:= Entero_Cero;
        SET Var_NumRegistros	:= IFNULL(Var_NumRegistros,Entero_Cero);

		-- Alta a tabla de registro de archivos de carga masiva de facturas
		CALL ARCHIVOSCARGAFACTALT (
			Entero_Cero,		Var_MesSubirFact,	Aud_Usuario, 			FechaSist,			Var_NumRegistros,
			Entero_Cero,		Entero_Cero,		Par_RutaArchivo,		Var_FolioCargaID,	SalidaNO,
            Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		SET Var_Contador		:= Entero_Uno;
		SET Var_ContadorExito	:= Entero_Cero;
		SET Var_ContadorError	:= Entero_Cero;

		IteraFacturas: WHILE Var_Contador <= Var_NumRegistros DO

			SET Var_MesSubirFact			:= Entero_Cero;
			SET Var_ProvExistente			:= Entero_Cero;
			SET Var_EsExitoso				:= Cadena_Vacia;
            SET Var_TipoError				:= Entero_Cero;
			SET Var_DescripcionError		:= Cadena_Vacia;


			SELECT	FechaSistema,				MesSubirFact,			UUID,						Estatus,				EsCancelable,
					EstatusCancelacion,			Tipo,					Anio,						Mes,					Dia,
                    FechaEmision,				FechaTimbrado,			Serie,						Folio,					LugarExpedicion,
                    Confirmacion,				CfdiRelacionados,		FormaPago,					MetodoPago,				CondicionesPago,
                    TipoCambio,					Moneda,					SubTotal,					Descuento,				Total,
                    ISRRetenido,				ISRTrasladado,			IVARetenidoGlobal,			IVARetenido6,			IVATrasladado16,
                    IVATrasladado8,				IVAExento,				BaseIVAExento,				IVATasaCero,			BaseIVATasaCero,
                    IEPSRetenidoTasa,			IEPSTrasladadoTasa,		IEPSRetenidoCuota,			IEPSTrasladadoCuota,	TotalImpuestosRetenidos,
                    TotalImpuestosTrasladados,	TotalRetencionesLocales,TotalTrasladosLocales,		ImpuestoLocalRetenido,	TasadeRetencionLocal,
                    ImportedeRetencionLocal,	ImpuestoLocalTrasladado,TasadeTrasladoLocal,		ImportedeTrasladoLocal,	RfcEmisor,
                    NombreEmisor,				RegimenFiscalEmisor,	RfcReceptor,				NombreReceptor,			UsoCFDIReceptor,
                    ResidenciaFiscal, 			NumRegIdTrib,			ListaNegra,					Conceptos,				PACCertifico,
                    RutadelXML
			INTO	Var_FechaCarga,				Var_MesSubirFact,		Var_UUID,					Var_Estatus,			Var_EsCancelable,
					Var_EstatusCance,			Var_Tipo,				Var_Anio,					Var_Mes,				Var_Dia,
					Var_FechaEmision,			Var_FechaTimbrado,		Var_Serie,					Var_Folio,				Var_LugarExpedicion,
					Var_Confirmacion,			Var_CfdiRelacionados,	Var_FormaPago,				Var_MetodoPago,			Var_CondicionesPago,
					Var_TipoCambio,				Var_Moneda,				Var_SubTotal,				Var_Descuento,			Var_Total,
					Var_ISRRetenido,			Var_ISRTrasladado,		Var_IVARetenidoGlobal,		Var_IVARetenido6,		Var_IVATrasladado16,
					Var_IVATrasladado8,			Var_IVAExento,			Var_BaseIVAExento,			Var_IVATasaCero,		Var_BaseIVATasaCero,
					Var_IEPSRetenidoTasa,		Var_IEPSTrasladadoTasa,	Var_IEPSRetenidoCuota,		Var_IEPSTrasladadoCuota,Var_TotalImpRetenidos,
					Var_TotalImpTrasladados,	Var_TotalRetenLocales,	Var_TotalTraslaLocales,		Var_ImpuestoLocRetenido,Var_TasadeRetenLocal,
					Var_ImporteRetenLocal,		Var_ImpLocalTrasladado,	Var_TasadeTrasladoLocal,	Var_ImporteTrasLocal,	Var_RfcEmisor,
					Var_NombreEmisor,			Var_RegimenFisEmisor,	Var_RfcReceptor,			Var_NombreReceptor,		Var_UsoCFDIReceptor,
					Var_ResidenciaFiscal,		Var_NumRegIdTrib,		Var_ListaNegra,				Var_Conceptos,			Var_PACCertifico,
					Var_RutadelXML
				FROM	TMPCARGAFACTURAS
				WHERE 	ID = Var_Contador;

			SET Var_FolioCargaID     		:= IFNULL(Var_FolioCargaID,Entero_Cero);
			SET Var_FechaCarga      		:= IFNULL(Var_FechaCarga,Fecha_Vacia);
			SET Var_MesSubirFact    		:= IFNULL(Var_MesSubirFact,Entero_Cero);
			SET Var_UUID            		:= IFNULL(Var_UUID,Cadena_Vacia);
			SET Var_Estatus         		:= IFNULL(Var_Estatus,Cadena_Vacia);
			SET Var_EsCancelable    		:= IFNULL(Var_EsCancelable,Cadena_Vacia);
			SET Var_EstatusCance    		:= IFNULL(Var_EstatusCance,Cadena_Vacia);
			SET Var_Tipo            		:= IFNULL(Var_Tipo,Entero_Cero);
			SET Var_Anio            		:= IFNULL(Var_Anio,Entero_Cero);
			SET Var_Mes             		:= IFNULL(Var_Mes,Entero_Cero);
			SET Var_Dia             		:= IFNULL(Var_Dia,Entero_Cero);
			SET Var_FechaEmision    		:= IFNULL(Var_FechaEmision,Fecha_Vacia);
			SET Var_FechaTimbrado   		:= IFNULL(Var_FechaTimbrado,Fecha_Vacia);
			SET Var_Serie           		:= IFNULL(Var_Serie,Cadena_Vacia);
			SET Var_Folio           		:= IFNULL(Var_Folio,Entero_Cero);
			SET Var_LugarExpedicion 		:= IFNULL(Var_LugarExpedicion,Entero_Cero);
			SET Var_Confirmacion    		:= IFNULL(Var_Confirmacion,Cadena_Vacia);
			SET Var_CfdiRelacionados		:= IFNULL(Var_CfdiRelacionados,Cadena_Vacia);
			SET Var_FormaPago       		:= IFNULL(Var_FormaPago,Cadena_Vacia);
			SET Var_MetodoPago      		:= IFNULL(Var_MetodoPago,Cadena_Vacia);
			SET Var_CondicionesPago 		:= IFNULL(Var_CondicionesPago,Cadena_Vacia);
			SET Var_TipoCambio      		:= IFNULL(Var_TipoCambio,Entero_Cero);
			SET Var_Moneda          		:= IFNULL(Var_Moneda,Cadena_Vacia);
			SET Var_SubTotal            	:= IFNULL(Var_SubTotal,Entero_Cero);
			SET Var_Descuento           	:= IFNULL(Var_Descuento,Entero_Cero);
			SET Var_Total           		:= IFNULL(Var_Total,Entero_Cero);
			SET Var_ISRRetenido             := IFNULL(Var_ISRRetenido,Entero_Cero);
			SET Var_ISRTrasladado           := IFNULL(Var_ISRTrasladado,Entero_Cero);
			SET Var_IVARetenidoGlobal       := IFNULL(Var_IVARetenidoGlobal,Entero_Cero);
			SET Var_IVARetenido6            := IFNULL(Var_IVARetenido6,Entero_Cero);
			SET Var_IVATrasladado16         := IFNULL(Var_IVATrasladado16,Entero_Cero);
			SET Var_IVATrasladado8          := IFNULL(Var_IVATrasladado8,Entero_Cero);
			SET Var_IVAExento           	:= IFNULL(Var_IVAExento,Cadena_Vacia);
			SET Var_BaseIVAExento           := IFNULL(Var_BaseIVAExento,Entero_Cero);
			SET Var_IVATasaCero             := IFNULL(Var_IVATasaCero,Cadena_Vacia);
			SET Var_BaseIVATasaCero         := IFNULL(Var_BaseIVATasaCero,Entero_Cero);
			SET Var_IEPSRetenidoTasa        := IFNULL(Var_IEPSRetenidoTasa,Entero_Cero);
			SET Var_IEPSTrasladadoTasa      := IFNULL(Var_IEPSTrasladadoTasa,Entero_Cero);
			SET Var_IEPSRetenidoCuota       := IFNULL(Var_IEPSRetenidoCuota,Entero_Cero);
			SET Var_IEPSTrasladadoCuota     := IFNULL(Var_IEPSTrasladadoCuota,Entero_Cero);
			SET Var_TotalImpRetenidos       := IFNULL(Var_TotalImpRetenidos,Entero_Cero);
			SET Var_TotalImpTrasladados     := IFNULL(Var_TotalImpTrasladados,Entero_Cero);
			SET Var_TotalRetenLocales       := IFNULL(Var_TotalRetenLocales,Entero_Cero);
			SET Var_TotalTraslaLocales      := IFNULL(Var_TotalTraslaLocales,Entero_Cero);
			SET Var_ImpuestoLocRetenido     := IFNULL(Var_ImpuestoLocRetenido,Entero_Cero);
			SET Var_TasadeRetenLocal        := IFNULL(Var_TasadeRetenLocal,Entero_Cero);
			SET Var_ImporteRetenLocal       := IFNULL(Var_ImporteRetenLocal,Entero_Cero);
			SET Var_ImpLocalTrasladado      := IFNULL(Var_ImpLocalTrasladado,Entero_Cero);
			SET Var_TasadeTrasladoLocal     := IFNULL(Var_TasadeTrasladoLocal,Entero_Cero);
			SET Var_ImporteTrasLocal        := IFNULL(Var_ImporteTrasLocal,Entero_Cero);
			SET Var_RfcEmisor           	:= IFNULL(Var_RfcEmisor,Cadena_Vacia);
			SET Var_NombreEmisor        	:= IFNULL(Var_NombreEmisor,Cadena_Vacia);
			SET Var_RegimenFisEmisor    	:= IFNULL(Var_RegimenFisEmisor,Cadena_Vacia);
			SET Var_RfcReceptor         	:= IFNULL(Var_RfcReceptor,Cadena_Vacia);
			SET Var_NombreReceptor      	:= IFNULL(Var_NombreReceptor,Cadena_Vacia);
			SET Var_UsoCFDIReceptor     	:= IFNULL(Var_UsoCFDIReceptor,Cadena_Vacia);
			SET Var_ResidenciaFiscal    	:= IFNULL(Var_ResidenciaFiscal,Cadena_Vacia);
			SET Var_NumRegIdTrib        	:= IFNULL(Var_NumRegIdTrib,Cadena_Vacia);
			SET Var_ListaNegra          	:= IFNULL(Var_ListaNegra,Cadena_Vacia);
			SET Var_Conceptos           	:= IFNULL(Var_Conceptos,Cadena_Vacia);
			SET Var_PACCertifico        	:= IFNULL(Var_PACCertifico,Cadena_Vacia);
			SET Var_RutadelXML          	:= IFNULL(Var_RutadelXML,Cadena_Vacia);

			-- INICIO Validaciones

			Validaciones: BEGIN

				IF (Var_RfcEmisor = Cadena_Vacia) THEN
					SET Var_DescripcionError:= 'EL RFC DEL EMISOR ESTA VACIO';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= ErroInfVacia;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				SELECT		ProveedorID,		Estatus
					INTO	Var_ProvExistente,	Var_EstatusProv
					FROM	PROVEEDORES
                    WHERE 	(IFNULL(RFC, Cadena_Vacia) = Var_RfcEmisor AND IFNULL(RFC, Cadena_Vacia)!=Cadena_Vacia)
					OR (IFNULL(RFCpm, Cadena_Vacia) = Var_RfcEmisor AND IFNULL(RFCpm, Cadena_Vacia)!=Cadena_Vacia)
					LIMIT	1;

				SET Var_ProvExistente		:= IFNULL(Var_ProvExistente, Entero_Cero);
				SET Var_EstatusProv			:= IFNULL(Var_EstatusProv, "B");

				IF (Var_ProvExistente = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL PROVEEDOR NO EXISTE';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= ErroProvNoExis;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				IF (Var_UUID = Cadena_Vacia) THEN
					SET Var_DescripcionError:= 'EL IDENTIFICADOR UNICO UNIVERSAL ESTA VACIO.';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= ErrUUID;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF (LENGTH(Var_UUID) != 36) THEN
					SET Var_DescripcionError:= 'EL IDENTIFICADOR UNICO UNIVERSAL ES INCORRECTO.';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= ErrUUID;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF (Var_MesSubirFact = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL MES PARA SUBIR EL ARCHIVO ESTA VACIO';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= 11;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				IF (Var_Mes = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL MES DE EMISION DE LA FACTURA ESTA VACIO';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= 12;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF (Var_Mes != Var_MesSubirFact OR Var_MesSubirFact=Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL MES DE EMISION DE LA FACTURA ES DIFERENTE AL MES SELECCIONADO';
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= ErroMesDif;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;



                IF (Var_EstatusProv != "A") THEN
					SET Var_DescripcionError:= CONCAT('EL ESTATUS DEL PROVEEDOR NO ES ACTIVO. [',Var_ProvExistente,'-',Var_RfcEmisor,']');
					SET Var_EsExitoso		:= SalidaNO;
                    SET Var_TipoError		:= 5;
                    SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				IF(Var_Anio = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL AÑO DE EMISION DE LA FACTURA ESTA VACIO.';
					SET Var_EsExitoso		:= SalidaNO;
					SET Var_TipoError		:= 6;
					SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				IF(Var_Mes = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL MES DE EMISION DE LA FACTURA ESTA VACIO.';
					SET Var_EsExitoso		:= SalidaNO;
					SET Var_TipoError		:= 7;
					SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF(Var_Dia = Entero_Cero) THEN
					SET Var_DescripcionError:= 'EL DIA DE EMISION DE LA FACTURA ESTA VACIO.';
					SET Var_EsExitoso		:= SalidaNO;
					SET Var_TipoError		:= 8;
					SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF(Var_Mes < 10)THEN
					SET Var_Mes :=  LPAD(Var_Mes,1,'0');
                END IF;

                IF(Var_Dia < 10)THEN
					SET Var_Dia :=  LPAD(Var_Dia,1,'0');
                END IF;

                SET Var_FechaFactura := CONCAT(Var_Anio,"-",Var_Mes,"-",Var_Dia);

                SELECT Eje.EjercicioID INTO Var_EjercioCont
				FROM  EJERCICIOCONTABLE Eje,
					PARAMETROSSIS Par
				WHERE Eje.EjercicioID 	 = Par.EjercicioVigente;

                SET Var_EjercioCont := IFNULL(Var_EjercioCont, Entero_Cero);

                SELECT 	COUNT(EjercicioID) INTO Var_NumPeriodosAbiertos
					FROM PERIODOCONTABLE
					WHERE EjercicioID = Var_EjercioCont
					AND Estatus!=Con_EstatusC
					AND Var_FechaFactura between Inicio AND Fin;

                 IF(Var_NumPeriodosAbiertos <= Entero_Cero) THEN
					SET Var_DescripcionError:= CONCAT('NO EXISTE UN PERIODO CONTABLE ABIERTO PARA LA FECHA: [',Var_FechaFactura,"]");
					SET Var_EsExitoso		:= SalidaNO;
					SET Var_TipoError		:= 9;
					SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

                IF(Var_Total <= Entero_Cero) THEN
					SET Var_DescripcionError:= CONCAT('EL TOTAL DE LA FACTURA ES : [',Var_Total,"]");
					SET Var_EsExitoso		:= SalidaNO;
					SET Var_TipoError		:= 10;
					SET Var_ContadorError	:= Var_ContadorError + Entero_Uno;
					LEAVE Validaciones;
				END IF;

				-- Si no nos detuvo alguna validacion
				SET Var_EsExitoso	:= SalidaSI;
				SET Var_TipoError	:= Entero_Cero;
                SET Var_ContadorExito:= Var_ContadorExito + Entero_Uno;

			END Validaciones;
			-- FIN Validaciones

			START TRANSACTION;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				SET Error_Key				:= Entero_Cero;
				SET Par_NumErr 				:= Entero_Cero;

				CALL BITACORACARGAFACTALT (
					Var_FolioCargaID,			Var_FechaCarga,			Var_MesSubirFact,			Var_UUID,				Var_Estatus,
                    Var_EsCancelable,			Var_EstatusCance,		Var_Tipo,					Var_Anio,				Var_Mes,
                    Var_Dia,					Var_FechaEmision,		Var_FechaTimbrado,			Var_Serie,				Var_Folio,
                    Var_LugarExpedicion,		Var_Confirmacion,		Var_CfdiRelacionados,		Var_FormaPago,			Var_MetodoPago,
                    Var_CondicionesPago,		Var_TipoCambio,			Var_Moneda,					Var_SubTotal,			Var_Descuento,
                    Var_Total,					Var_ISRRetenido,		Var_ISRTrasladado,			Var_IVARetenidoGlobal,	Var_IVARetenido6,
                    Var_IVATrasladado16,		Var_IVATrasladado8,		Var_IVAExento,				Var_BaseIVAExento,		Var_IVATasaCero,
                    Var_BaseIVATasaCero,		Var_IEPSRetenidoTasa,	Var_IEPSTrasladadoTasa,		Var_IEPSRetenidoCuota,	Var_IEPSTrasladadoCuota,
                    Var_TotalImpRetenidos,		Var_TotalImpTrasladados,Var_TotalRetenLocales,		Var_TotalTraslaLocales,	Var_ImpuestoLocRetenido,
                    Var_TasadeRetenLocal,		Var_ImporteRetenLocal,	Var_ImpLocalTrasladado,		Var_TasadeTrasladoLocal,Var_ImporteTrasLocal,
                    Var_RfcEmisor,				Var_NombreEmisor,		Var_RegimenFisEmisor,		Var_RfcReceptor,		Var_NombreReceptor,
                    Var_UsoCFDIReceptor,		Var_ResidenciaFiscal,	Var_NumRegIdTrib,			Var_ListaNegra,			Var_Conceptos,
                    Var_PACCertifico,			Var_RutadelXML,			SalidaNO,					Var_EsExitoso,			Var_TipoError,
                    Var_DescripcionError, 		SalidaNO,            	Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,
                    Aud_Usuario,         		Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
                    Aud_NumTransaccion);

				IF(Par_NumErr !=Entero_Cero)THEN
					LEAVE IteraFacturas;
				END IF;

			END;

			IF (Error_Key = 0 AND Par_NumErr = 0) THEN
				COMMIT;
			ELSE
				IF (Var_EsExitoso = SalidaSI) THEN
					SET Var_ContadorExito := Var_ContadorExito - 1;
				ELSE
					SET Var_ContadorError := Var_ContadorError - 1;
				END IF;

				ROLLBACK;
			END IF;

			SET Var_Contador := Var_Contador + Entero_Uno;
		END WHILE IteraFacturas;

		UPDATE ARCHIVOSCARGAFACT SET
			NumFacturasExito = Var_ContadorExito,
			NumFacturasError = Var_ContadorError
		 WHERE FolioCargaID = Var_FolioCargaID;

		SET Var_MensajeResult	:= '';
		SET Var_MensajeResult	:= CONCAT(Var_NumRegistros, '-', Var_ContadorExito, '-', Var_ContadorError);

		-- El registro se inserto exitosamente
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Folio Carga de Archivo Cargado Exitosamente';
		SET Var_Control	:= 'mes';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Var_FolioCargaID		AS consecutivo,
				Var_MensajeResult		AS campoGenerico;
	END IF;

END TerminaStore$$
