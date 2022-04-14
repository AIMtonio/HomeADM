-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVPRO`;

DELIMITER $$
CREATE PROCEDURE `DISPERSIONMOVPRO`(
# ==========================================================
# ----- SP PARA REALIZAR AUTORIZACION DE DISPERSIONES-------
# ==========================================================
	Par_ClaveDispMov	INT(11),		-- Clave de la dispersion
    Par_DispersionID	INT(11),		-- Folio de la dispersion
    Par_CuentaCheque	VARCHAR(25),    -- Numero de Cheque
    Par_Estatus			CHAR(1),        -- A: Autorizado, P: Pendiente o no Autoizado
    Par_Poliza			BIGINT,

	Par_Fecha			DATE,
    Par_TipoChequera	CHAR(2),
    Par_Monto 			DECIMAL(12,2),	-- Monto del Movimiento. Aplica para las Dispersiones Multiples
    Par_Salida          CHAR(1),
	OUT Par_NumErr      INT(11),
	OUT Par_ErrMen      VARCHAR(400),
	OUT Par_Consecutivo BIGINT,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CuentaAhoID			BIGINT(12);			-- ID de la cuenta de ahorro
	DECLARE Var_FechaOpeDis			DATE;				-- Fecha de operacion disponible
	DECLARE Var_MontoMov			DECIMAL(12,2);		-- Monto del movimientoo
	DECLARE Var_DescripcionMov		VARCHAR(150);		-- Descripcion del movimiento
	DECLARE Var_ReferenciaMov		VARCHAR(35);		-- Referencia del movimiento
	DECLARE No_Conciliado			CHAR(1);			-- Movimiento no Conciliado
	DECLARE Par_NatMovimiento		CHAR(1);			-- Naturaleza de movimiento
	DECLARE Desbloquear				CHAR(1);			-- Tipo Bloqueo en Cta Ahorro: Desbloqueo
	DECLARE Tipo_DesbDisper			INT;				-- Tipo DesBloqueo: Por Dispersion
	DECLARE CtaAhoID				BIGINT(12);			-- ID de la cuenta de ahorro
	DECLARE Var_InstitucionID		INT(11);			-- ID de la institucion
	DECLARE Var_CuentaBancaria		VARCHAR(20);		-- Cuenta Bancaria
	DECLARE Mon_Base				INT;				-- Moneda Base
	DECLARE Fecha_Sistema			DATE;				-- Fecha del sistema
	DECLARE Fecha_Valida			DATE;				-- Fecha Valida
	DECLARE DiaHabil				CHAR(1);			-- Dia Habil
	DECLARE Des_Contable			VARCHAR(150);		-- Deescripcion Contable
	DECLARE DesContableCargoDisp	VARCHAR(150);		-- Descripcion contable cargo por disposicion de credito
	DECLARE Var_ClienteID			INT(12);			-- ID del cliente
	DECLARE Var_TipoMovimiento		INT;				-- Tipo de movimiento
	DECLARE Var_AltaMovAho			CHAR(1);			-- Alta del movimiento de ahorro
	DECLARE Tip_MovAho				CHAR(4);			-- Tipo de movimiento de ahorro
	DECLARE Var_Refere				VARCHAR(100);		-- contiene la referencia

	DECLARE Var_Cue_Saldo			DECIMAL(12,2);		-- Saldo de la cuenta de ahorro
	DECLARE Var_CueMoneda			INT;				-- Moneda de la cuenta
	DECLARE Var_CueEstatus			CHAR(1);			-- Estatus de la cuenta
	DECLARE Char_NumErr				CHAR(3);			-- Numero de errir
	DECLARE Var_Consecutivo			INT;				-- Numero Consecutivo

	DECLARE Var_CreditoID			BIGINT(12);			-- ID del credito
	DECLARE Var_ProveedorID			INT;				-- Id del proveedor
	DECLARE Var_NoFactura			VARCHAR(20);		-- Numero de factura
	DECLARE Var_FacturaID			VARCHAR(20);		-- ID de la factura
	DECLARE Var_DetReqGasID			INT;				-- Detalle de la requisicion de gastos
	DECLARE Var_TipoGasto			INT;				-- Tipo de gasto
	DECLARE Var_AnticipoFact		CHAR(11);			-- Anticipo de la factura
	DECLARE Var_EstatusAntFac		CHAR(1);			-- Estatus del anticipo de la factura

	DECLARE Var_IVA					DECIMAL(14,2);		-- IVA
	DECLARE Var_RetencIVA			DECIMAL(14,2);		-- Retencion IVA
	DECLARE Var_RetencISR			DECIMAL(14,2);		-- Retencion ISR
	DECLARE Var_EstFact				CHAR(1);			-- Estatus de la factura
	DECLARE Var_TotFactura			DECIMAL(14,2);		-- Totañ de la factura
	DECLARE Var_ReqGasID			INT(11);			-- ID de la requisicion de gastos
	DECLARE Var_CenCostoID			INT(11);			-- ID del centro de costos
	DECLARE Var_CuentaConta			VARCHAR(25);		-- Cuenta contable
	DECLARE Var_FolioBlo			INT(11);			-- Folio de bloqueo
	DECLARE Var_CatalogoServID		INT(11);			-- ID del catalogo de servicios
	DECLARE Var_Aplicado			CHAR(1);			-- Estatus del pago
	DECLARE Var_SucursalID			INT(11);			-- ID de la sucursal
	DECLARE Var_SucursalCliente		INT(11);
	DECLARE Var_MonedaID			INT(11);			-- ID de la moneda
	DECLARE Var_FormaPago			INT(1);				-- Forma de pago
	DECLARE Var_ProrrateaImp		CHAR(1); 			-- Prorrateo de Impuestos en Facturacion Proveedores
	DECLARE	Var_TipoGastoDF			INT;				-- Tipo de gasto de factura
	DECLARE Var_DescripcionDF		CHAR(100);			-- Descripcion de factura
	DECLARE Var_ImporteDF			DECIMAL(13,2);		-- importe de la factura
	DECLARE	Var_CenCostoIDDF		INT;				-- Centro de costos
	DECLARE Var_IvaCenCostoDF		DECIMAL(13,2);		-- IVa del centro de costos
	DECLARE Var_RetIvaCenCostoDF	DECIMAL(13,2);		-- Iva retenido del centro de costos
	DECLARE	Var_RetISRCenCostoDF 	DECIMAL(13,2);		-- ISR retenido
	DECLARE Var_CenCostoManualID   	INT;				-- Centro de costos manual
	DECLARE Var_Control         	VARCHAR(100);		-- Variable de control
	DECLARE Var_ImporteImp			DECIMAL(14,2);		-- Importe
	DECLARE Var_ImpID				INT(11);			-- ID del impuesto
	DECLARE Var_ImporteImpuesto		DECIMAL(14,2);		-- Importe impuesto
	DECLARE Var_ImpuestoID			INT(11);			-- ID del impuesto
	DECLARE Var_NatConta			CHAR(2);			-- Naturaleza contable
	DECLARE Var_CtaAntProv			VARCHAR(25);		-- Cuenta anticipo proveedor
	DECLARE Var_CtaProvee			VARCHAR(25);		-- Cuenta proveedor
	DECLARE Var_CueGasto    		CHAR(25);			-- Cuenta de gastos
	DECLARE Var_TraCue   			VARCHAR(25);		-- Cuenta en transito
	DECLARE Var_ReaCue				VARCHAR(25);		-- Cuenta Realizado
	DECLARE Var_TipoImp				CHAR(1);			-- Cuenta Grava Retiene
	DECLARE Var_SaldoFactura		DECIMAL(14,2);		-- Saldo de la factura
	DECLARE Var_DescriMov   		VARCHAR(250);		-- Descripcion del movimiento
	DECLARE Var_MontoCargoDisp		DECIMAL(14,2);		-- Monto del cargo disponible
	DECLARE Var_PorcenCargoDisp		DECIMAL(14,2);		-- Porcentaje deñ cargo disponible
	DECLARE Var_TipoDispersion		CHAR(1);			-- Tipo de dispersion
	DECLARE Var_ProductoCreditoID	INT(11);			-- ID del producto de credito
	DECLARE Var_NivelID				INT(11);			-- Nivel de credito
	DECLARE Var_MontoCredito		DECIMAL(14,2);		-- Monto de credito
	DECLARE Var_TipoCargo			CHAR(1);			-- Tipo Cargo
	DECLARE Var_BonificacionID		BIGINT(20);			-- ID de Bonificacion
	DECLARE Var_IDControl			INT(11);			-- ID de Control de Dispersion
	DECLARE Var_MontoOperacion		DECIMAL(14,2);		-- Monto de Operacion

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Var_Autorizada			CHAR(1);
	DECLARE Var_Automatico			CHAR(1);
	DECLARE Cue_Activa				CHAR(1);
	DECLARE Var_SI					CHAR(1);
	DECLARE Var_NO					CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Salida_NO				CHAR(1);
	DECLARE Est_Pendiente			CHAR(1);
	DECLARE Est_Pagado				CHAR(1);
	DECLARE	Act_DisperCance			INT(11);
	DECLARE	Act_PagadoAnti			INT(11);

	DECLARE Var_TipoSpeiDesemb  	CHAR(4);
	DECLARE Var_TipoSpeiIndivi  	CHAR(4);
	DECLARE Var_TipoChequeDesem 	CHAR(4);
	DECLARE Var_TipoOrdenDesem 		CHAR(4);
	DECLARE Var_TipoChequeIndiv 	CHAR(4);
	DECLARE Var_SPEIProveeFact  	CHAR(4);
	DECLARE Var_CheqProveeFact  	CHAR(4);
	DECLARE Var_SPEIProvee      	CHAR(4);
	DECLARE Var_ChequeProvee    	CHAR(4);
	DECLARE Var_SPEIPagoServ    	CHAR(4);	/* Tipo de movimiento SPEI por pago de servicios - tabla TIPOSMOVTESO*/
	DECLARE Var_TipoTransSanta  	CHAR(4);	-- TIPO DE MOVIMIENTO TRANSFERENCIA SANTANDER

	DECLARE Var_TipoBanESinFac  	CHAR(4);
	DECLARE Var_TipoBanEFac 		CHAR(4);
	DECLARE Var_TipoTarESinFac  	CHAR(4);
	DECLARE Var_TipoTarEFac     	CHAR(4);
	DECLARE Var_SiHabilita			CHAR(1);

	DECLARE Var_SPEIProvAntFact 	CHAR(4);
	DECLARE Var_CheqProvAntFact		CHAR(4);
	DECLARE Var_TipoBanEAntFac		CHAR(4);
	DECLARE Var_TipoTarEAntFac		CHAR(4);
	DECLARE Var_ClasifCred			CHAR(1);
	DECLARE Var_SubClasifID			INT(11);
	DECLARE Var_SucCliente			INT(11);

	DECLARE Act_FolDisCred      	INT(11);
	DECLARE Act_FolDisReq       	INT(11);
	DECLARE Act_Aplicado			INT(11);
	DECLARE Act_FolioDis			INT(11);
	DECLARE Act_SaldoFact			INT(11);
	DECLARE Dis_FolioVacio      	INT(11);

	DECLARE Nat_Cargo           	CHAR(1);
	DECLARE Nat_Abono           	CHAR(1);
	DECLARE Var_TipoActEstatus  	INT(11);
	DECLARE No_EmitePoliza      	CHAR(1);
	DECLARE Tip_MovAhoSPEI      	CHAR(4);
	DECLARE Tip_MovAhoCHEQ      	CHAR(4);
	DECLARE Tip_MovAhoCargoDisp    	CHAR(4);
	DECLARE SI_AltaMovAho       	CHAR(1);
	DECLARE NO_AltaMovAho       	CHAR(1);
	DECLARE NumActPagada        	INT(11);
	DECLARE Des_Desbloqueo    		VARCHAR(50);
	DECLARE Des_CanceDisper     	VARCHAR(50);
	DECLARE Des_PagProvSinFac   	VARCHAR(50);
	DECLARE Tipo_PagFact        	CHAR(1);
	DECLARE Tipo_PagAntFact     	CHAR(1); 		/* tipo de pago de anticipo de factura */
	DECLARE Fact_Liquidada      	CHAR(1);
	DECLARE Fact_Cancelada      	CHAR(1);
	DECLARE AltaDetPol_Si			CHAR(1);
	DECLARE AltaEncPol_NO			CHAR(1);
	DECLARE AltaPagoServ_NO			CHAR(1);
	DECLARE AltaMovsTeso_Si			CHAR(1);
	DECLARE Var_TipoTarjeta			CHAR(4);
	DECLARE Var_TipoMovDisSPEIBon 	CHAR(4);		-- Constante Movimiento de Tipo Dispersion SPEI
	DECLARE Var_TipoMovDisCheqBon 	CHAR(4);		-- Constante Movimiento de Tipo Dispersion Cheque
	DECLARE Var_TipoMovDisOrdenBon	CHAR(4);		-- Constante Movimiento de Tipo Dispersion Orden Pago
	DECLARE Tipo_MovAhoTar			CHAR(4);
	DECLARE var_RefCuentCheq		VARCHAR(150);
	DECLARE Pago_Ventanilla			CHAR(1);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE Procedimiento			VARCHAR(30);
	DECLARE Con_ProrrateaSI			CHAR(1);
	DECLARE Con_ProrrateaNO			CHAR(1);
	DECLARE Con_PagoAntNO			CHAR(1);
	DECLARE Cheque					INT(1);
	DECLARE OrdenPago				INT(1);
	DECLARE Tipo_pagoSpei  			INT(1);
	DECLARE Fecha					DATE;
	DECLARE SiHabilita				CHAR(1);
	DECLARE ValorParam				VARCHAR(100);
	DECLARE FechaValida				DATE;
	DECLARE FechaSis				DATE;
	DECLARE CentroCostos   			INT(2);
	DECLARE Var_FolioUUID       	VARCHAR(100);
	DECLARE Var_ProvRFC				VARCHAR(13);
	DECLARE Con_PagoFactura 		INT(11);
	DECLARE Con_AntFactura  		INT(11);
	DECLARE Des_PagoFactura 		VARCHAR(100);
	DECLARE Des_AntFactPag			VARCHAR(100);
	DECLARE Cuenta_Vacia    		VARCHAR(15);
	DECLARE Imp_Gravado				CHAR(1);
	DECLARE Imp_Retenido			CHAR(1);
    DECLARE TipoDisperOrden			CHAR(1);
    DECLARE TipoDisperEfectivo	CHAR(1);
    DECLARE ConceptoCartera			INT(11);
	DECLARE DesCargoDisposicion		VARCHAR(100);
	DECLARE TipoMonto	 			CHAR(1);
	DECLARE TipoPorcentaje			CHAR(1);
	DECLARE NivelTodas				INT(11);
	DECLARE Var_CentroCostosID		INT(11);
	DECLARE Act_EstAutorizada		TINYINT UNSIGNED;-- Numero de Actualizacion
	DECLARE Mov_BonificacionID		INT(11);		-- ID del movimiento de Bonificacion hace referencia a la tabla TIPOSMOVSAHO
	DECLARE ConcepContaAbono		INT(11);		-- Concepto Contable tipo ABONO
	DECLARE AhorroBonifica			INT(11);		-- ID del concepto de ahorro gace referencia a la tabla CONCEPTOSAHORRO
	DECLARE Bloq_Bonificacion	INT(11);			-- Constante Bloqueo Bonificacion
	DECLARE Mov_Bloqueo        	CHAR(1);			-- Constante Movimiento de Bloqueo
	DECLARE Var_TipoMovAportacion	INT(11);
	DECLARE Var_DispMultiple		CHAR(1);		-- Permite Dispersiones Multiples
	DECLARE Con_DispTransSanta	VARCHAR(50);		-- Llave parametro para el tipo de movimiento contable de Transferecnias Santander
	DECLARE Entero_Dos			INT(11);			-- Entero 2;

	DECLARE Var_Intrumento 				INT(11);			-- Tipo de Instrumento (Cuenta de Ahorro, Inversion, Cede, Credito)
	DECLARE Var_NumeroInstrumento 		BIGINT(20);			-- Numero de Instrumento (CuentaAhoID, InversionID, CedeID, CreditoID)
	DECLARE Inst_CuentaAhorro			TINYINT UNSIGNED;	-- Instrumento Cuenta Ahorro
	DECLARE Inst_Credito				TINYINT UNSIGNED;	-- Instrumento de Credito
	DECLARE Pro_BonificacionID			TINYINT UNSIGNED;	-- Proceso de Bonificacion
	DECLARE Pro_DispersionID			TINYINT UNSIGNED;	-- Proceso de Dispersion Credito
	DECLARE Var_OperacionPeticionID		TINYINT UNSIGNED;	-- Proceso de Notificacion de Saldo
	DECLARE Estatus_Dispersado      CHAR(1);                -- Estatus Dispersado spei
	DECLARE CantMovCre			DECIMAL(12,2);


	-- Declaracion del cursor de cancelacion de detalles de la factura
	DECLARE CURSORDETFACT CURSOR FOR
		SELECT	Det.TipoGastoID,		Det.Descripcion,	Det.Importe,	Det.CentroCostoID,	Fac.FolioUUID,
				DetIm.ImporteImpuesto,	DetIm.ImpuestoID
			FROM	DETALLEIMPFACT	DetIm
			INNER JOIN	DETALLEFACTPROV	 Det ON	DetIm.NoFactura		= Det.NoFactura
											AND	DetIm.ProveedorID 	= Det.ProveedorID
											AND	DetIm.NoPartidaID 	= Det.NoPartidaID
			INNER JOIN  FACTURAPROV Fac		 ON	Det.ProveedorID		= Fac.ProveedorID
											AND	Det.NoFactura		= Fac.NoFactura
			WHERE		DetIm.ProveedorID	= Var_ProveedorID
			  AND 		DetIm.NoFactura		= Var_NoFactura;


	-- Declaracion de cursor de cancelacion de importes de impuestos
	DECLARE CURSORDETIMPUESTOS CURSOR FOR
		SELECT	ImporteImpuesto,ImpuestoID
			FROM	DETALLEIMPFACT DI
			WHERE 	DI.ProveedorID	= Var_ProveedorID
			AND 	DI.NoFactura 	= Var_NoFactura;

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero en Cero
	SET Decimal_Cero		:= 0.00;			-- Constante Decimal CERO
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia

	SET Var_Autorizada		:= 'A';				-- Estatus:Autorizada
	SET Var_Automatico		:= 'A';				-- Tipo: Automatica
	SET Cue_Activa			:= 'A';				-- Estatus de la Cuenta: Activa
	SET Est_Pendiente		:= 'P';				-- Estatus Pendinte; corresponde con el Estatus de la tabla DISPERSIONMOV
	SET Est_Pagado			:= 'P';				-- Estatus Pagado; corresponde con el Estatus de la tabla ANTICIPOFACTURACT

	SET Var_TipoSpeiDesemb	:= '2';				-- TIPOSMOVTESO: SPEI por Desembolso de Credito
	SET Var_TipoChequeDesem	:= '12';			-- TIPOSMOVTESO: Cheque por Desembolso de Credito
	SET Var_TipoOrdenDesem	:= '700';			-- TIPOSMOVTESO: Orden de pago por Desembolso de Credito
	SET Var_TipoSpeiIndivi	:= '3';				-- TIPOSMOVTESO: Salida Recursos del Cliente por SPEI Individual
	SET Var_TipoChequeIndiv	:= '4';				-- TIPOSMOVTESO: Salida Recursos del Cliente por Cheque
	SET Var_SPEIProveeFact	:= '5';				-- TIPOSMOVTESO: Salida SPEI por Pago a Provedores Factura
	SET Var_CheqProveeFact	:= '6';				-- TIPOSMOVTESO: Salida Cheque por Pago a Provedores Factura
	SET Var_SPEIProvee		:= '15';			-- TIPOSMOVTESO: SPEI por Pago a Provedores sin Factura
	SET Var_ChequeProvee	:= '16';			-- TIPOSMOVTESO: Cheque por Pago a Provedores sin Factura
	SET Var_TipoBanESinFac	:= '17';			-- TIPOSMOVTESO Salida de Recursos Banca Electronica por Pago a Provedores sin Factura
	SET Var_TipoBanEFac		:= '18';			-- TIPOSMOVTESO Salida de Recursos Banca Electronica por Pago a Provedores Factura
	SET Var_TipoTarESinFac	:= '19';			-- TIPOSMOVTESO Salida de Recursos Tarjeta Empresarial por Pago a Provedores sin Factura
	SET Var_TipoTarEFac		:= '20';			-- TIPOSMOVTESO Salida de Recursos Tarjeta Empresarial por Pago a Provedores Factura
	SET Var_SPEIPagoServ	:= '21';			-- TIPOSMOVTESO  Tipo de movimiento SPEI por pago de servicios
	SET Var_SPEIProvAntFact	:= '22';			-- TIPOSMOVTESO: Salida SPEI por Anticipo Pago a Provedores Factura
	SET Var_CheqProvAntFact	:= '23';			-- TIPOSMOVTESO: Salida Cheque por Anticipo Pago a Provedores Factura
	SET Var_TipoBanEAntFac	:= '24';			-- TIPOSMOVTESO Salida de Recursos Banca Electronica por Anticipo  Pago a Provedores Factura
	SET Var_TipoTarEAntFac	:= '25';			-- TIPOSMOVTESO Salida de Recursos Tarjeta Empresarial por Anticipo  Pago a Provedores Factura
	SET Var_TipoTarjeta		:= '26';			-- TIPOSMOVTESO Salida de Recursos del Cliente por Tarjeta Individual*/
	SET Var_TipoMovDisSPEIBon   := '27';		-- Constante Movimiento de Tipo Dispersion SPEI
	SET Var_TipoMovDisCheqBon   := '123';		-- Constante Movimiento de Tipo Dispersion Cheque
	SET Var_TipoMovDisOrdenBon  := '708';		-- Constante Movimiento de Tipo Dispersion Orden Pago

	SET Act_Aplicado		:= 2;				-- para actualizar campo aplicado cuando la  dispersion se autoriza.*/
	SET Act_FolioDis		:= 1;				-- para actualizar campo folio cuando la  dispersion no se autoriza.*/
	SET Act_FolDisCred		:= 5;				-- Tipo Actualizacion de Credito: Folio de Dipersion
	SET Act_FolDisReq		:= 2;				-- Tipo Actualizacion de Requisicion: Folio de Dipersion
	SET Act_SaldoFact		:= 6;				-- Tipo Actualizacion de Requisicion: Folio de Dipersion
	SET Dis_FolioVacio		:= 0;				-- Folio de Dispersion Vacio

	SET Nat_Cargo			:= 'C';				-- Naturaleza del Movimiento: Cargo
	SET Nat_Abono			:= 'A';				-- Naturaleza del Movimiento: Abono
	SET Var_TipoActEstatus	:= 1;				-- Tipo de Actualizacion: Estatus
	SET Act_DisperCance		:= 4;				-- actualizacion para no autorizacion de anticipos
	SET Act_PagadoAnti		:= 2;				-- actualizacion para cambio de estatus a pagado en anticipos

	SET AltaDetPol_Si		:= 'S';				-- SI al alta del detalle de la poliza
	SET AltaEncPol_NO		:= 'N';				-- NO al alrta del encabezado de la poliza
	SET AltaPagoServ_NO		:= 'N';				-- NO al alta de pago de servicios
	SET AltaMovsTeso_Si		:= 'S';				-- Si al alta de movimiento de tesoreria

	SET No_Conciliado       := 'N';				-- Movimiento no Conciliado
	SET Desbloquear         := 'D';				-- Tipo Bloqueo en Cta Ahorro: Desbloqueo
	SET Tipo_DesbDisper     := 1;				-- Tipo DesBloqueo: Por Dispersion

	SET No_EmitePoliza      := 'N';				-- NO Genera Encabezado de la Poliza Contable
	SET SI_AltaMovAho       := 'S';				-- Alta del Movimiento de Ahorro: SI
	SET NO_AltaMovAho       := 'N';				-- Alta del Movimiento de Ahorro: NO

	SET Salida_SI           := 'S';				-- Llamada a Store sin Select de Salida
	SET Var_SI				:= 'S';				-- Constante SI
	SET Var_NO				:= 'N';				-- Constante NO
	SET Salida_NO           := 'N';				-- Llamada a Store Con Select de Salida
	SET Tip_MovAhoSPEI      := '224';			-- Tipo de Movimiento de Ahorro: Envi­o de SPEI
	SET Tip_MovAhoCHEQ      := '15';			-- Tipo de Movimiento de Ahorro: Entrega de Cheque
	SET Tip_MovAhoCargoDisp := '228';			-- Tipo de Movimiento de Ahorro: CARGO POR DISPOSICION DE CREDITO
	SET NumActPagada        := 4;				-- Actualizacion de Factura Pagada o Liquidada
	SET Tipo_PagFact        := 'P';				-- Tipo de Registro: Pago de Factura
	SET Tipo_PagAntFact     := 'O';				-- Tipo de Registro: Pago anticipo de Factura
	SET Tipo_MovAhoTar		:= '227';			-- Tipo de Movimiento de Ahorro: Dispersion por Tarjeta

	SET Fact_Liquidada      := 'L';				-- Estatus de la Factura: Liquidada o Pagada
	SET Fact_Cancelada      := 'C';				-- Estatus de la Factura: Cancelada

	SET Des_Desbloqueo      := 'DESBLOQUEO POR DISPERSION';						-- Descripcion del Bloqueo
	SET Des_CanceDisper     := 'DESBLOQUEO POR CANCELACION DE DISPERSION';		-- Descripcion de la cancelacion de la dispersion

	SET Des_PagProvSinFac   := 'PAGO A PROVEEDOR SIN FACTURA';					-- Descripcion pago a proveedor
	SET Pago_Ventanilla		:= 'V';				-- PAGO EN VENTANILLA --
	SET TipoInstrumentoID	:= 19;				-- TIPO DE INSTRUMENTO CUENTA BANCARIA --
	SET Procedimiento		:= 'DISPERSIONMOVPRO'; -- Procedimiento que se ejecuta --
	SET Con_ProrrateaSI		:= 'S';				-- Constante para validar que NO se hizo prorrateo en Facturacion de Proveedores
	SET Con_ProrrateaNO		:= 'N';				-- Constante para validar que SI se hizo prorrateo en Facturacion de Proveedores
	SET Con_PagoAntNO 		:= 'N';				-- NO apgo anticipado
	SET Cheque				:= 2;				-- ID de la forma de pago por cheque
	SET OrdenPago			:= 5;				-- ID de la forma de pago por orden de pago
	SET Tipo_pagoSpei 		:= 1;
	-- Inicializacion
	SET Var_Consecutivo			:= 0;			-- Variable consecutiva
	SET Des_Contable        	:= '';			-- Descripcion contable
	SET DesContableCargoDisp	:= 'CARGO POR DISPOSICION DE CREDITO';	-- Descripcion del cargo por dispersion
	SET DesCargoDisposicion		:= 'CARGO POR DISPOSICION DE CREDITO';	-- Descripcion del cargo por dispersion
	SET Aud_FechaActual 		:= NOW();		-- Fecha actual
	SET SiHabilita				:= "S";			-- Constante SI habilita
	SET ValorParam				:= "HabilitaFechaDisp";	-- Valor del parametro
	SET Con_PagoFactura 		:= 72;			-- Concepto Contable: Pago de Factura
	Set Con_AntFactura  		:= 79;			-- Concepto Contable: Pago de anticipo
	SET Des_PagoFactura 		:= 'PAGO DE FACTURA';				-- Descripcion del Movimiento: Pago de Fact
	SET Des_AntFactPag			:= 'PAGO DE ANTICIPO DE FACTURA';	-- Descripcion del Movimiento: PAGO DE aNTICIPO  de FactURA
	SET Cuenta_Vacia 			:= '000000000000000';				-- Cuenta Contable Vacia
	SET Imp_Gravado				:= 'G';			-- Impuesto Gravado
	SET Imp_Retenido			:= 'R';			-- Impuesto Retenido
    SET TipoDisperOrden   		:= 'O';			-- Tipo de Dispersion por Orden de Pago
    SET TipoDisperEfectivo 		:= 'E';			-- Tipo de Dispersion por Efectivo
    SET ConceptoCartera			:= 59;			-- CONCEPTOSCARTERA: Cargo por Disposicion de Credito
	SET TipoMonto	 			:= 'M';			-- Tipo cargo por Monto.
	SET TipoPorcentaje			:= 'P';			-- Tipo cargo por Porcentaje.
	SET NivelTodas				:= 0;			-- Todos los niveles NIVELCREDITO.

	SET Var_CentroCostosID		:= 0;			-- ID del centro de costos
	SET Act_EstAutorizada		:= 1;			-- Estatus autoriza dispersion
	SET Mov_BonificacionID		:= 31;
	SET ConcepContaAbono		:= 45;
	SET AhorroBonifica			:= 33;
	SET Bloq_Bonificacion		:= 22;
	SET Mov_Bloqueo 			:= 'B';
	SET Var_CentroCostosID		:= 0;
	SET Var_TipoMovAportacion	:= 709;			-- Salida de SPEI pago de Aportaciones
	SET Var_DispMultiple		:= (SELECT PermitirMultDisp FROM PARAMETROSSIS LIMIT 1);
    SET Con_DispTransSanta		:= 'DispTransSantander';
	SET Inst_CuentaAhorro		:= 1;
	SET Inst_Credito			:= 4;
	SET Pro_BonificacionID		:= 15;
	SET Pro_DispersionID		:= 12;
	SET Entero_Dos				:= 2;
	SET Estatus_Dispersado      := 'P';                 -- Estatus Dispersado via spei


    SELECT ValorParametro INTO Var_TipoTransSanta
		FROM PARAMGENERALES
		WHERE LlaveParametro=Con_DispTransSanta;

    SET Var_TipoTransSanta := IFNULL(Var_TipoTransSanta, Cadena_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DISPERSIONMOVPRO');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

		SET Fecha_Sistema 	:=(SELECT  FechaSistema FROM PARAMETROSSIS);
		SET Mon_Base 		:= (SELECT  MonedaBaseID FROM PARAMETROSSIS);

		SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Par_Fecha;
		ELSE
			SET Fecha :=Fecha_Sistema;

		END IF;

		IF(IFNULL(Par_ClaveDispMov, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'No existe el Movimiento de Dispersion.';
            SET Var_Control		:= 'ClaveDispMov';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT	Dis.CuentaAhoID,			Dis.FechaOperacion,		Dis.InstitucionID,	Teso.NumCtaInstit,		DisMov.CuentaCargo,
				DisMov.Monto,				DisMov.Descripcion,		DisMov.Referencia,	DisMov.TipoMovDIspID,	DisMov.CreditoID,
				DisMov.ProveedorID,			DisMov.FacturaProvID,	DisMov.DetReqGasID,	DisMov.TipoGastoID,		DisMov.CuentaContable,
				DisMov.CatalogoServID,		DisMov.SucursalID,
				CASE WHEN DisMov.TipoMovDIspID = Var_TipoChequeIndiv OR DisMov.TipoMovDIspID = Var_TipoChequeDesem OR DisMov.TipoMovDIspID = Var_CheqProveeFact
                OR DisMov.TipoMovDIspID = Var_ChequeProvee OR DisMov.TipoMovDIspID = Var_CheqProvAntFact
				THEN  CONCAT(DisMov.Referencia,"/CHEQUE:",Par_CuentaCheque)
				ELSE DisMov.Referencia END, DisMov.AnticipoFact,	DisMov.FormaPago
		INTO	CtaAhoID,					Var_FechaOpeDis,		Var_InstitucionID,	Var_CuentaBancaria,		Var_CuentaAhoID,
				Var_MontoMov,				Var_DescripcionMov,		Var_ReferenciaMov,	Var_TipoMovimiento,		Var_CreditoID,
				Var_ProveedorID,			Var_FacturaID,			Var_DetReqGasID,	Var_TipoGasto,			Var_CuentaConta,
				Var_CatalogoServID,			Var_SucursalID,			var_RefCuentCheq,	Var_AnticipoFact,		Var_FormaPago
			FROM DISPERSION Dis,
				 DISPERSIONMOV DisMov,
				 CUENTASAHOTESO Teso
			WHERE DisMov.DispersionID   = Par_DispersionID
			  AND DisMov.ClaveDispMov   = Par_ClaveDispMov
			  AND Dis.FolioOperacion    = DisMov.DispersionID
			  AND Teso.InstitucionID    = Dis.InstitucionID
			  AND Teso.NumCtaInstit     = Dis.NumCtaInstit;

			IF(Var_FormaPago = Cheque)THEN
				UPDATE DISPERSIONMOV SET
							CuentaDestino	= Par_CuentaCheque,
							TipoChequera	= Par_TipoChequera
					WHERE 	ClaveDispMov 	= Par_ClaveDispMov;
			END IF;

		IF IFNULL(Var_CuentaAhoID,Entero_Cero)>Entero_Cero THEN
			SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01') INTO FechaSis
				FROM PARAMETROSSIS;
			IF YEAR(Par_Fecha)<=YEAR(FechaSis)THEN
				IF MONTH(Par_Fecha)<MONTH(FechaSis) THEN
					SET Par_NumErr      := 8;
					SET Par_ErrMen      := 'El Mes no Puede ser Menor al del Sistema' ;
					SET Var_Control		:= 'fechaActual';
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- Validaciones Generales
		SET Var_TipoMovimiento  := IFNULL(Var_TipoMovimiento, Entero_Cero);
		SET Var_MontoMov  := IFNULL(Var_MontoMov, Entero_Cero);

		IF(Var_TipoMovimiento = Entero_Cero) THEN
			SET Par_NumErr      := 2;
			SET Par_ErrMen      := 'No existe el Tipo de Movimiento de Dispersion.';
            SET Var_Control		:= 'ClaveDispMov';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF( Var_TipoMovimiento != Var_TipoSpeiDesemb	AND
			Var_TipoMovimiento != Var_TipoChequeDesem	AND
			Var_TipoMovimiento != Var_TipoOrdenDesem	AND
			Var_TipoMovimiento != Var_TipoSpeiIndivi	AND
			Var_TipoMovimiento != Var_TipoChequeIndiv	AND
			Var_TipoMovimiento != Var_SPEIProveeFact	AND
			Var_TipoMovimiento != Var_CheqProveeFact	AND
			Var_TipoMovimiento != Var_ChequeProvee		AND
			Var_TipoMovimiento != Var_SPEIProvee		AND
			Var_TipoMovimiento != Var_TipoBanESinFac	AND
			Var_TipoMovimiento != Var_TipoBanEFac		AND
			Var_TipoMovimiento != Var_TipoTarESinFac	AND
			Var_TipoMovimiento != Var_TipoTarEFac		AND
			Var_TipoMovimiento != Var_SPEIPagoServ		AND
			Var_TipoMovimiento != Var_SPEIProvAntFact	AND
			Var_TipoMovimiento != Var_CheqProvAntFact	AND
			Var_TipoMovimiento != Var_TipoBanEAntFac	AND
			Var_TipoMovimiento != Var_TipoTarEAntFac 	AND

			Var_TipoMovimiento != Var_TipoTarjeta 		AND
			Var_TipoMovimiento != Var_TipoMovDisSPEIBon AND
			Var_TipoMovimiento != Var_TipoMovDisCheqBon AND
			Var_TipoMovimiento != Var_TipoMovDisOrdenBon AND
			Var_TipoMovimiento != Var_TipoTarjeta		AND
			Var_TipoMovimiento != Var_TipoMovAportacion AND
            Var_TipoMovimiento != Var_TipoTransSanta) THEN


			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'El Tipo de Movimiento de Dispersion es Incorrecto';
            SET Var_Control		:= 'ClaveDispMov';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MontoMov = Entero_Cero) THEN
				SET Par_NumErr      := 4;
				SET Par_ErrMen      := 'Monto de la Dispersion Incorrecto.';
                SET Var_Control		:= 'ClaveDispMov';
				SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_DispMultiple = Var_SI AND Par_Estatus = Var_Autorizada) THEN

			IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
				Var_TipoMovimiento =  Var_TipoChequeDesem OR
				Var_TipoMovimiento =  Var_TipoOrdenDesem ) THEN

				-- Se valida el Parametro de Monto
				SET Par_Monto := IFNULL(Par_Monto,Entero_Cero);

				IF(Par_Monto = Entero_Cero) THEN
						SET Par_NumErr      := 4;
						SET Par_ErrMen      := 'Monto de la Dispersion Incorrecto.';
		                SET Var_Control		:= 'ClaveDispMov';
						SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				IF(Par_Monto > Var_MontoMov)THEN
					SET Par_NumErr      := 5;
					SET Par_ErrMen      := 'El Monto es Mayor de la Dispersion.';
		            SET Var_Control		:= 'ClaveDispMov';
					SET Par_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;


                IF(Fecha_Sistema > Par_Fecha) THEN
                    SET Par_NumErr      := 6;
                    SET Par_ErrMen      := 'La Fecha para la Dispersion es Menor a la Fecha del Sistema';
                    SET Var_Control		:= 'ClaveDispMov';
                    SET Par_Consecutivo := Entero_Cero;
                    LEAVE ManejoErrores;
                END IF;



				SET Var_MontoMov := Par_Monto;

				-- Se ajusta el Monto en Dispersiones con el nuevo ingresado por la pantalla
				UPDATE DISPERSIONMOV SET
					Monto = Par_Monto
				WHERE ClaveDispMov = Par_ClaveDispMov
					AND DispersionID = Par_DispersionID;

			END IF;
		END IF;

		-- Calculo del dia Habil
		CALL DIASFESTIVOSCAL(
			Fecha_Sistema,  Entero_Cero,        Fecha_Valida,       DiaHabil,       Aud_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion  );


		IF Var_SiHabilita=SiHabilita THEN
			SET FechaValida:=Par_Fecha;
		ELSE
			SET FechaValida:=Fecha_Valida;

		END IF;


		-- El Tipo de Movimiento es de una Dispersion de Bonificaciones, Cheque o SPEI
		IF (Var_TipoMovimiento =  Var_TipoMovDisSPEIBon OR
			Var_TipoMovimiento =  Var_TipoMovDisCheqBon OR
			Var_TipoMovimiento =  Var_TipoMovDisOrdenBon ) THEN

			SELECT blo.BloqueoID
			INTO Var_FolioBlo
			FROM BLOQUEOS blo,
				DISPERSIONMOV disMov
			WHERE blo.CuentaAhoID = disMov.CuentaCargo
			  AND blo.MontoBloq   = disMov.Monto
			  AND IFNULL(blo.FolioBloq, Entero_Cero) = Entero_Cero
			  AND blo.NatMovimiento = Mov_Bloqueo
			  AND blo.TiposBloqID = Bloq_Bonificacion
			  AND disMov.Referencia = blo.Referencia
			  AND disMov.DispersionID = Par_DispersionID
			  AND disMov.ClaveDispMov = Par_ClaveDispMov
			LIMIT 1;

			IF( Par_Estatus = Var_Autorizada ) THEN
				IF(Var_CuentaAhoID != Entero_Cero)THEN
					CALL BLOQUEOSPRO(
						Var_FolioBlo,		Desbloquear,		Var_CuentaAhoID,		Fecha,				Var_MontoMov,
						Fecha,				Tipo_DesbDisper,	Des_Desbloqueo,			Var_CreditoID,		Cadena_Vacia,
						Cadena_Vacia,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SET Var_BonificacionID := (SELECT Referencia FROM BLOQUEOS WHERE BloqueoID = Var_FolioBlo);
				SET Var_ClienteID := (SELECT ClienteID FROM BONIFICACIONES WHERE BonificacionID = Var_BonificacionID);

				SELECT MonedaID
				INTO Var_CueMoneda
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

				SET Var_MontoOperacion		:= Var_MontoMov;
				SET Var_OperacionPeticionID	:= Pro_BonificacionID;
				SET Var_Intrumento 			:= Inst_CuentaAhorro;
				SET Var_NumeroInstrumento 	:= Var_CuentaAhoID;
				SET Var_SucursalCliente := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID );

				CALL CARGOABONOCUENTAPRO(
					Var_CuentaAhoID,		Var_ClienteID,			Aud_NumTransaccion, 	Fecha, 					Fecha,
					Nat_Cargo,				Var_MontoMov,			Des_Desbloqueo,			Var_CuentaAhoID,		Mov_BonificacionID,
					Var_CueMoneda,			Var_SucursalCliente,	No_EmitePoliza,			ConcepContaAbono,		Par_Poliza,
					Var_SI, 				AhorroBonifica,			Nat_Cargo, 				Entero_Cero,			Var_NO,
					Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL BONIFICACIONESACT(
					Var_BonificacionID,		Par_DispersionID,		Act_EstAutorizada,	Salida_NO,			Par_NumErr,
					Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;


		-- El Tipo de Movimiento es de una Dispersion de Credito, Cheque o SPEI
		IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
			Var_TipoMovimiento =  Var_TipoChequeDesem OR
			Var_TipoMovimiento =  Var_TipoOrdenDesem OR
			Var_TipoMovimiento =  Var_TipoSpeiIndivi OR
			Var_TipoMovimiento =  Var_TipoChequeIndiv OR
			Var_TipoMovimiento =  Var_TipoTarjeta OR
			Var_TipoMovimiento =  Var_TipoMovAportacion OR
            Var_TipoMovimiento =  Var_TipoTransSanta) THEN


			# Actualizar estatus dispersado
			IF(Var_CreditoID>Entero_Cero) THEN
				CALL ESTATUSSOLCREDITOSALT(
					Entero_Cero,               Var_CreditoID,        Estatus_Dispersado,        Cadena_Vacia,             Cadena_Vacia,
					Salida_NO, 			       Par_NumErr,           Par_ErrMen,                Aud_EmpresaID,            Aud_Usuario,
					Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);	
					
				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- El Tipo de Movimiento es de una Dispersion de Credito, Cheque o SPEI
			IF (Var_TipoMovimiento =  Var_TipoSpeiIndivi OR
				Var_TipoMovimiento =  Var_TipoChequeIndiv  OR
				Var_TipoMovimiento =  Var_TipoTarjeta ) THEN /* se desbloquea aunque no este autorizada.*/

					SET Var_FolioBlo := (SELECT blo.BloqueoID
											FROM BLOQUEOS blo,
												DISPERSIONMOV disMov
											WHERE	blo.CuentaAhoID		= disMov.CuentaCargo
											AND 	blo.Referencia		= disMov.NumTransaccion
											AND 	blo.NumTransaccion	= disMov.NumTransaccion
											AND 	blo.MontoBloq		= disMov.Monto
											AND 	IFNULL(blo.FolioBloq,0) = 0
											AND 	blo.NatMovimiento	= 'B'
											AND 	disMov.DispersionID	= Par_DispersionID
											AND 	disMov.ClaveDispMov	= Par_ClaveDispMov LIMIT 1);

					SET Var_FolioBlo := IFNULL(Var_FolioBlo, Entero_Cero);

					IF(Par_Estatus != Var_Autorizada) THEN
						SET Des_Desbloqueo  := Des_CanceDisper;
					END IF;

					IF(Var_CuentaAhoID != Entero_Cero)THEN
						CALL BLOQUEOSPRO(
							Var_FolioBlo,		Desbloquear,		Var_CuentaAhoID,		Fecha,				Var_MontoMov,
							Fecha,				Tipo_DesbDisper,	Des_Desbloqueo,			Var_CreditoID,		Cadena_Vacia,
							Cadena_Vacia,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
                    END IF;

			END IF;
			IF(Var_TipoMovimiento = Var_TipoMovAportacion) THEN -- DESBLOQUEO UNICAMENTE PARA APORTACIONES

					SET Var_FolioBlo := (SELECT blo.BloqueoID
											FROM BLOQUEOS blo,
												DISPERSIONMOV disMov
											WHERE	blo.CuentaAhoID		= disMov.CuentaCargo
											AND 	blo.Referencia		= disMov.NumTransaccion
											AND 	blo.NumTransaccion	= disMov.NumTransaccion
											AND 	blo.MontoBloq		= disMov.Monto
											AND 	IFNULL(blo.FolioBloq,0) = 0
											AND 	blo.NatMovimiento	= 'B'
											AND 	disMov.DispersionID	= Par_DispersionID
											AND 	disMov.ClaveDispMov	= Par_ClaveDispMov LIMIT 1);

					SET Var_FolioBlo := IFNULL(Var_FolioBlo, Entero_Cero);

					IF(Par_Estatus = Var_Autorizada) THEN

						    IF(Var_CuentaAhoID != Entero_Cero)THEN
								CALL BLOQUEOSPRO(
									Var_FolioBlo,		Desbloquear,		Var_CuentaAhoID,		Fecha,				Var_MontoMov,
									Fecha,				Tipo_DesbDisper,	Des_Desbloqueo,			Var_CreditoID,		Cadena_Vacia,
									Cadena_Vacia,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);

								IF (Par_NumErr <> Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
		                    END IF;


					END IF;

            END IF;

			IF(Par_Estatus = Var_Autorizada) THEN
				-- si la cuenta contable viene vacia se des
				SET CantMovCre := IFNULL((SELECT MontoPorDesemb FROM CREDITOS WHERE CreditoID = Var_CreditoID),Var_MontoMov);
				IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) = Cadena_Vacia THEN
					-- El Tipo de Movimiento es de una Dispersion de Credito, Cheque o SPEI
					IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
						Var_TipoMovimiento =  Var_TipoChequeDesem OR
				        Var_TipoMovimiento =  Var_TipoOrdenDesem OR
						Var_TipoMovimiento =  Var_TipoTransSanta) THEN
						SET Var_FolioBlo := (SELECT	Blo.BloqueoID
							FROM CREDITOS Cre,
							   BLOQUEOS Blo
							WHERE Cre.CreditoID 	= Var_CreditoID
							AND Cre.CreditoID       = Blo.Referencia
							AND Blo.TiposBloqID     = Tipo_DesbDisper
							AND Blo.NatMovimiento   = 'B'
							AND Blo.FolioBloq = Entero_Cero
							AND Cre.CuentaID = Blo.CuentaAhoID
							  AND FIND_IN_SET(Cre.TipoDispersion, 'S,C,O,A,E')
							  AND Blo.MontoBloq >= CantMovCre
                              LIMIT 1);

						SET Var_FolioBlo := IFNULL(Var_FolioBlo, Entero_Cero);
						SET Var_Intrumento 			:= Inst_Credito;
						SET Var_NumeroInstrumento 	:= Var_CreditoID;
						SET Var_OperacionPeticionID	:= Pro_DispersionID;
						SET Var_MontoOperacion		:= Entero_Cero;

						IF(Var_CuentaAhoID != Entero_Cero)THEN
							CALL BLOQUEOSPRO(
								Var_FolioBlo,		Desbloquear,		Var_CuentaAhoID,	Fecha,				Var_MontoMov,
								Fecha,				Tipo_DesbDisper,	Des_Desbloqueo,		Var_CreditoID,		Cadena_Vacia,
								Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							CALL CTRINSTRUCCIONESDISPACT (
								Entero_Cero,		Entero_Cero,		Par_DispersionID,	Par_ClaveDispMov,	Cadena_Vacia,
								Entero_Cero,		Aud_FechaActual,	Fecha_Vacia,		Salida_SI,			Cadena_Vacia,
								Entero_Dos,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

						END IF;
					END IF;-- modificado
				END IF;

				-- si la cuenta contable viene vacia se des
				IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) = Cadena_Vacia THEN
					-- Consultamos la Cuenta de Ahorro donde se realizara el Cargo
					CALL SALDOSAHORROCON(
						Var_ClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Var_CuentaAhoID);

					-- Validar Estatus de la Cuenta
					IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != Cue_Activa THEN
						SET Par_NumErr		:= 5;
						SET Par_ErrMen		:= 'La Cuenta no Existe o no Esta Activa ';
                        SET Var_Control		:= 'cuentaAhoID';
						SET Par_Consecutivo	:= Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

				
					IF(IFNULL(Var_Cue_Saldo, Decimal_Cero)) < CantMovCre THEN
						SET Par_NumErr      := 6;
						SET Par_ErrMen      := 'Saldo Insuficiente en la Cuenta del Cliente';
						SET Var_Control		:= 'monto';
						SET Par_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
					SET Var_AltaMovAho  := SI_AltaMovAho;
				ELSE
					SET Var_AltaMovAho  := NO_AltaMovAho;
				END IF;
			END IF;

			-- Seleccionamos el Tipo de Movimiento en la Cta de Ahorro
			IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
				Var_TipoMovimiento =  Var_TipoSpeiIndivi OR
                Var_TipoMovimiento =  Var_TipoTransSanta) THEN
				SET Tip_MovAho  := Tip_MovAhoSPEI;
			ELSE
				SET Tip_MovAho  := Tip_MovAhoCHEQ;
			END IF;
			IF (Var_TipoMovimiento =  Var_TipoTarjeta)THEN
				SET Tip_MovAho :=Tipo_MovAhoTar;
			END IF;

			IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb) THEN
				SET Des_Contable := 'SPEI POR DESEMBOLSO DE CREDITO';
			END IF;

			IF (Var_TipoMovimiento =  Var_TipoChequeDesem) THEN
				SET Des_Contable := 'CHEQUE POR DESEMBOLSO DE CREDITO';
				SET Var_DescripcionMov := CONCAT('CHEQUE PAGADO NO. ',Par_CuentaCheque, ' DESEMBOLSO');
			END IF;

			IF (Var_TipoMovimiento =  Var_TipoOrdenDesem) THEN
				SET Des_Contable := 'ORDEN PAGO POR DESEMBOLSO DE CREDITO';
				SET Var_DescripcionMov := CONCAT('ORDEN PAGO POR DESEMBOLSO DE CREDITO');
			END IF;

			IF ( Var_TipoMovimiento =  Var_TipoSpeiIndivi OR
				 Var_TipoMovimiento =  Var_TipoChequeIndiv OR
				 Var_TipoMovimiento =  Var_TipoTarjeta OR
				 Var_TipoMovimiento =  Var_TipoMovAportacion OR
                 Var_TipoMovimiento =  Var_TipoTransSanta) THEN
				SET Des_Contable := Var_DescripcionMov;
			END IF;

		ELSE        -- Es Dispersion por Pago a Proveedor (Con Factura o sin Factura)


			IF( Var_TipoMovimiento = Var_SPEIProveeFact	OR
				Var_TipoMovimiento = Var_CheqProveeFact	OR
				Var_TipoMovimiento = Var_ChequeProvee	OR
				Var_TipoMovimiento = Var_SPEIProvee		OR
				Var_TipoMovimiento = Var_TipoBanESinFac	OR
				Var_TipoMovimiento = Var_TipoBanEFac	OR
				Var_TipoMovimiento = Var_TipoTarESinFac	OR
				Var_TipoMovimiento = Var_TipoTarEFac	) THEN
				SET Var_AltaMovAho  := NO_AltaMovAho;
				SET Tip_MovAho      := Cadena_Vacia;
				SET Des_Contable    := Var_DescripcionMov;

				IF(Par_Estatus = Var_Autorizada) THEN

					IF (Var_TipoMovimiento =  Var_SPEIProveeFact OR
						Var_TipoMovimiento =  Var_CheqProveeFact OR
						Var_TipoMovimiento =  Var_TipoBanEFac OR
						Var_TipoMovimiento =  Var_TipoTarEFac ) THEN -- Es un Pago al Proveedor con Factura

						SELECT	Estatus,    	TotalFactura,	NoFactura,		ProrrateaImp, 		CenCostoManualID, 		FolioUUID
						 INTO	Var_EstFact,    Var_TotFactura,	Var_NoFactura, 	Var_ProrrateaImp, 	Var_CenCostoManualID, 	Var_FolioUUID
							FROM FACTURAPROV
							WHERE FacturaProvID = Var_FacturaID
							  AND ProveedorID = Var_ProveedorID;

						SET Var_EstFact := IFNULL(Var_EstFact, Cadena_Vacia);
						-- Validar Estatus de la Factura
						IF(Var_EstFact = Fact_Liquidada OR Var_EstFact = Fact_Cancelada ) THEN
							SET Par_NumErr		:= 7;
							SET Par_ErrMen		:= 'La factura ya fue Cancelada o se encuentra Liquidada.';
                            SET Var_Control		:= 'cuentaAhoID';
							SET Par_Consecutivo	:= Entero_Cero;
							LEAVE ManejoErrores;
						END IF;

						-- Actualizamos la Factura como Pagada.
						CALL FACTURAPROVACT(
							Var_ProveedorID,    Var_NoFactura,  	Cadena_Vacia,      	Cadena_Vacia ,		Cadena_Vacia,
							Decimal_Cero,		NumActPagada,		Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen ,
							Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP	,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion  );

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

							-- Contabilidad de la Factura
						SET Var_ProvRFC := (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
											FROM PROVEEDORES
											WHERE ProveedorID = Var_ProveedorID);

						SELECT CuentaAnticipo,CuentaCompleta
							INTO Var_CtaAntProv, Var_CtaProvee
							FROM PROVEEDORES
							WHERE ProveedorID = Var_ProveedorID;

						SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
						SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

						SET Var_NatConta :=	Nat_Cargo;

						CALL CONTAFACTURAPRO(
							Var_ProveedorID,   	Var_NoFactura,		Tipo_PagFact,  			Con_PagoAntNO,		No_EmitePoliza,
							Par_Poliza,			FechaValida,   		Var_MontoMov,			Entero_Cero,		Var_CenCostoManualID,
							Var_CtaProvee,		Entero_Cero,		Var_ProvRFC,			Var_FolioUUID,		Var_NatConta,
							Con_PagoFactura,	Des_PagoFactura,	IFNULL(Par_CuentaCheque,Entero_Cero),		Salida_NO, Par_NumErr,
							Par_ErrMen,       	Aud_EmpresaID,  	Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

						OPEN CURSORDETFACT;
							BEGIN
								DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
								DETFACT:LOOP

									FETCH CURSORDETFACT INTO
									Var_TipoGastoDF,	Var_DescripcionDF,		Var_ImporteDF, Var_CenCostoIDDF, Var_FolioUUID,
									Var_ImporteImp,		Var_ImpID;

									BEGIN

										SET Var_ProvRFC := (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
										  						FROM PROVEEDORES
										 						WHERE ProveedorID = Var_ProveedorID);

										SELECT	CtaEnTransito, 	CtaRealizado, 	GravaRetiene
										  INTO	Var_TraCue,		Var_ReaCue,		Var_TipoImp
											FROM IMPUESTOS
											WHERE 	ImpuestoID	= Var_ImpID;

										SET Var_TraCue := IFNULL(Var_TraCue, Cuenta_Vacia);
										SET Var_ReaCue := IFNULL(Var_ReaCue, Cuenta_Vacia);

										IF(Var_TipoImp = Imp_Gravado)THEN
											SET Var_NatConta :=	Nat_Abono;
										ELSE
											IF(Var_TipoImp = Imp_Retenido)THEN
												SET Var_NatConta :=	Nat_Cargo;
											END IF;

										END IF;

										CALL CONTAFACTURAPRO(
											Var_ProveedorID,	Var_NoFactura,	Tipo_PagFact,	Con_PagoAntNO,			No_EmitePoliza,
											Par_Poliza,			FechaValida,  	Var_ImporteImp,	Entero_Cero,			Var_CenCostoIDDF,
											Var_TraCue,			Entero_Cero,	Var_ProvRFC,	Var_FolioUUID,			Var_NatConta,
											Con_PagoFactura,	Des_PagoFactura,IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,
											Par_NumErr,			Par_ErrMen,    	Aud_EmpresaID,  Aud_Usuario,	Aud_FechaActual,
											Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion  );

									   IF (Par_NumErr <> Entero_Cero)THEN
											LEAVE DETFACT;
										END IF;

										IF(Var_TipoImp = Imp_Gravado)THEN
											SET Var_NatConta :=	Nat_Cargo;
										ELSE
											IF(Var_TipoImp = Imp_Retenido)THEN
												SET Var_NatConta :=	Nat_Abono;
											END IF;

										END IF;
										CALL CONTAFACTURAPRO(
											Var_ProveedorID,   		Var_NoFactura,		Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
											Par_Poliza,				FechaValida,  		Var_ImporteImp,		Entero_Cero,		Var_CenCostoIDDF,
											Var_ReaCue,				Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
											Con_PagoFactura,		Des_PagoFactura,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
											Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
											Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

										IF (Par_NumErr <> Entero_Cero)THEN
											LEAVE DETFACT;
										END IF;

									END;
								END LOOP DETFACT;
							END;
						CLOSE CURSORDETFACT;

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE   -- Es un pago al Proveedor sin Factura
						-- se obtiene el valor del id de la req de gastos para obtener el centro de costos
						SELECT DetReqGasID INTO Var_ReqGasID
							FROM DISPERSIONMOV
							WHERE DispersionID = Par_DispersionID
							AND ClaveDispMov   = Par_ClaveDispMov;
						-- se obtiene el numero de centro de costos del detalle
						SELECT CentroCostoID INTO Var_CenCostoID
							FROM REQGASTOSUCURMOV
							WHERE DetReqGasID  = Var_ReqGasID;


						SELECT CuentaCompleta INTO Var_CueGasto
						FROM TESOCATTIPGAS
						WHERE TipoGastoID = Var_TipoGasto;

						SET Var_CueGasto := IFNULL(Var_CueGasto, Cuenta_Vacia);

						SET Var_NatConta :=	Nat_Cargo;

						-- Contabilidad del Pago al Proveedor por el Tipo de Gasto
						IF(Par_CuentaCheque != Cadena_Vacia) THEN	-- si el pago es por cheque se manda el numero de cheque como referencia
							CALL CONTAFACTURAPRO(
								Var_ProveedorID,   		Par_CuentaCheque,	Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
								Par_Poliza,				FechaValida,  		Var_MontoMov,		Entero_Cero,		Var_CenCostoID,
								Var_CueGasto,			Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
								Con_PagoFactura,		Des_PagProvSinFac,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
								Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion );

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

						ELSE
							CALL CONTAFACTURAPRO(
								Var_ProveedorID,   		Cadena_Vacia,		Tipo_PagFact,  		Con_PagoAntNO,		No_EmitePoliza,
								Par_Poliza,				FechaValida,  		Var_MontoMov,		Entero_Cero,		Var_CenCostoID,
								Var_CueGasto,			Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
								Con_PagoFactura,		Des_PagProvSinFac,	IFNULL(Par_CuentaCheque,Entero_Cero),	Salida_NO,     	Par_NumErr,
								Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

						END IF;
					END IF;

				END IF;
			END IF;
		END IF;

		/**** Si se trata de un tipo de dispersion por pago de servicios ***/
		IF (Var_TipoMovimiento =  Var_SPEIPagoServ ) THEN -- Es un Pago de servicios por spei
			IF(Par_Estatus = Var_Autorizada) THEN
				SELECT	Pag.Aplicado,	Pag.MonedaID,	Cat.CatalogoServID
				 INTO	Var_Aplicado, 	Var_MonedaID,	Var_CatalogoServID
					FROM CATALOGOSERV Cat,
						PAGOSERVICIOS Pag
					WHERE 	Pag.CatalogoServID 	= Var_CatalogoServID
					 AND	Pag.CatalogoServID  = Cat.CatalogoServID
					 AND 	Pag.FolioDispersion	= Par_DispersionID
					 LIMIT 1;

				SET Var_Aplicado := IFNULL(Var_Aplicado, Cadena_Vacia);

				IF(Var_Aplicado = Var_SI) THEN	/*se Valida que no se haya aplicado el servicio indicado */
					SET Par_NumErr		:= 7;
					SET Par_ErrMen		:= 'El pago de servicio ya se encuentra aplicado.';
                    SET Var_Control		:= 'cuentaAhoID';
					SET Par_Consecutivo	:= Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SET Des_Contable := 'SPEI POR PAGO DE SERVICIOS';

				-- Se actualiza el estatus de APlicado a SI "S"
				CALL PAGOSERVICIOSACT(
					Var_CatalogoServID,		Par_DispersionID,	Var_SI,				Act_Aplicado,		Salida_NO,
					Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CONTAPAGOSERVPRO(	/* sp para movimientos operativos y contables  de tesoreria y pago de servicios*/
					Var_CatalogoServID,	Entero_Cero,			Var_SucursalID,		Entero_Cero,		FechaValida,/*ok*/
					Var_ReferenciaMov,	Cadena_Vacia,			Var_MonedaID,		Var_MontoMov,		Decimal_Cero,
					Decimal_Cero,		Decimal_Cero,			Decimal_Cero,		Entero_Cero,		Entero_Cero,
					Entero_Cero,		AltaPagoServ_NO,		AltaEncPol_NO,		AltaDetPol_Si,		Nat_Cargo,
					Pago_Ventanilla,	Salida_NO,				Par_Poliza,			Par_NumErr,			Par_ErrMen,
					Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF;/**** fin de dispersion por pago de servicios ***/
		/* **** Si se trata de una dispersion por pago anticipado de servicios *******/
		IF (Var_TipoMovimiento = Var_SPEIProvAntFact	OR
			Var_TipoMovimiento = Var_CheqProvAntFact	OR
			Var_TipoMovimiento = Var_TipoBanEAntFac		OR
			Var_TipoMovimiento = Var_TipoTarEAntFac) THEN
			IF(Par_Estatus = Var_Autorizada) THEN

				SELECT	  Estatus,    	TotalFactura,	NoFactura, 		FolioUUID
				 INTO	  Var_EstFact,  Var_TotFactura,	Var_NoFactura,  Var_FolioUUID
					FROM FACTURAPROV
					WHERE FacturaProvID = Var_FacturaID
					  AND ProveedorID	= Var_ProveedorID;


				SET Var_ProvRFC = (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
				  FROM PROVEEDORES
				 WHERE ProveedorID = Var_ProveedorID);

				SET  Des_Contable := CONCAT('PAGO DE ANTICIPO DE FACTURA: ',Var_NoFactura);
				/* se llama sp para actualizar cada anticipo de factura y marcarlas con estatus pagado */

				CALL ANTICIPOFACTURACT(
					Entero_Cero,			Par_DispersionID,	Var_ProveedorID,	Var_NoFactura,		Var_FormaPago,
					Act_PagadoAnti,			Salida_NO,			Par_NumErr, 		Par_ErrMen,			Aud_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				/* Actualizamos la Factura como Parcialmente Pagada. o Liquidada si fuera el caso   */

				CALL FACTURAPROVACT(
					Var_ProveedorID,    Var_NoFactura,  	Cadena_Vacia,      	Cadena_Vacia ,		Cadena_Vacia,
					Var_MontoMov,		Act_SaldoFact,		Cadena_Vacia,		Salida_NO,			Par_NumErr,
					Par_ErrMen ,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP	,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion  );

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				/* Tipo de Registro: O- PAGO ANTICIPO
					* Contabilidad del anticipo de la Factura */

				SET CentroCostos:= (SELECT CenCostoManualID FROM FACTURAPROV
							WHERE ProveedorID=Var_ProveedorID
								AND NoFactura=Var_NoFactura );

				SELECT CuentaAnticipo,CuentaCompleta
				  INTO Var_CtaAntProv, Var_CtaProvee
					FROM PROVEEDORES
					WHERE ProveedorID = Var_ProveedorID;

				SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
				SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

				SET Var_NatConta :=	Nat_Cargo;

				CALL CONTAFACTURAPRO(
					Var_ProveedorID,    	Var_NoFactura,		Tipo_PagAntFact,	Con_PagoAntNO,		No_EmitePoliza,
					Par_Poliza,				FechaValida,		Var_MontoMov,		Entero_Cero,		CentroCostos,
					Var_CtaAntProv,			Entero_Cero,		Var_ProvRFC,		Var_FolioUUID,		Var_NatConta,
					Con_AntFactura,			Des_AntFactPag,	IFNULL(Par_CuentaCheque,Entero_Cero),		Salida_NO, Par_NumErr,
					Par_ErrMen,  			Aud_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
					Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion );

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


							/* se obtiene el saldo de la factura para saber si ya fue liquidada*/
				SET Var_SaldoFactura := (SELECT SaldoFactura
											FROM FACTURAPROV
											WHERE	ProveedorID = Var_ProveedorID
												AND NoFactura	= Var_NoFactura );

				OPEN CURSORDETIMPUESTOS;
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						DETIMPUESTOS:LOOP

							FETCH CURSORDETIMPUESTOS INTO	Var_ImporteImpuesto,Var_ImpuestoID;

							BEGIN
								IF (Var_SaldoFactura = Entero_Cero) THEN /*si la factura fue liquidada con el anticipo */
									SET Var_DescriMov   :=	Des_PagoFactura;

									SET Var_ProvRFC = (SELECT CASE TipoPersona WHEN 'M' THEN RFCpm ELSE RFC END
									  FROM PROVEEDORES
									 WHERE ProveedorID = Var_ProveedorID);

									SELECT CtaEnTransito, CtaRealizado, GravaRetiene
									INTO   Var_TraCue, 	  Var_ReaCue, 	Var_TipoImp
									FROM IMPUESTOS
									WHERE ImpuestoID = Var_ImpuestoID;


									SET Var_TraCue := IFNULL(Var_TraCue, Cuenta_Vacia);
									SET Var_ReaCue := IFNULL(Var_ReaCue, Cuenta_Vacia);

									IF(Var_TipoImp = Imp_Gravado)THEN
										SET Var_NatConta :=	Nat_Abono;
									ELSE
										IF(Var_TipoImp = Imp_Retenido)THEN
											SET Var_NatConta :=	Nat_Cargo;
										END IF;

									END IF;

									CALL CONTAFACTURAPRO(
										Var_ProveedorID,   		Var_NoFactura,		Tipo_PagAntFact,  				Con_PagoAntNO,		No_EmitePoliza,
										Par_Poliza,				FechaValida,  		Var_ImporteImpuesto,			Entero_Cero,		CentroCostos,
										Var_TraCue,				Entero_Cero,		Var_ProvRFC,					Var_FolioUUID,		Var_NatConta,
										Con_PagoFactura,		Var_DescriMov,	IFNULL(Par_CuentaCheque,Entero_Cero),Salida_NO,     	Par_NumErr,
										Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,					Aud_FechaActual,    Aud_DireccionIP,
										Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion);

									IF (Par_NumErr <> Entero_Cero)THEN
										LEAVE DETIMPUESTOS;
									END IF;

									IF(Var_TipoImp = Imp_Gravado)THEN
										SET Var_NatConta :=	Nat_Cargo;
									ELSE
										IF(Var_TipoImp = Imp_Retenido)THEN
											SET Var_NatConta :=	Nat_Abono;
										END IF;

									END IF;

									CALL CONTAFACTURAPRO(
										Var_ProveedorID,   		Var_NoFactura,		Tipo_PagAntFact,  					Con_PagoAntNO,		No_EmitePoliza,
										Par_Poliza,				FechaValida,  		Var_ImporteImpuesto,				Entero_Cero,		CentroCostos,
										Var_ReaCue,				Entero_Cero,		Var_ProvRFC,						Var_FolioUUID,		Var_NatConta,
										Con_PagoFactura,		Var_DescriMov,		IFNULL(Par_CuentaCheque,Entero_Cero),Salida_NO,     	Par_NumErr,
										Par_ErrMen,    			Aud_EmpresaID,  	Aud_Usuario,						Aud_FechaActual,    Aud_DireccionIP,
										Aud_ProgramaID, 		Aud_Sucursal,		Aud_NumTransaccion );

									IF (Par_NumErr <> Entero_Cero)THEN
										LEAVE DETIMPUESTOS;
									END IF;
								END IF;
							END;
						End LOOP DETIMPUESTOS;
					END;
				CLOSE CURSORDETIMPUESTOS;

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
		/* **** Fin de  dispersion por pago anticipado de servicios *******/
		-- Si el movimiento de Dispersion SI se Autorizo

		IF (Par_Estatus  = Var_Autorizada) THEN
            SELECT Cli.SucursalOrigen,Cre.ProductoCreditoID, Cre.TipoDispersion, Des.Clasificacion, Des.SubClasifID

				INTO Var_SucCliente,Var_ProductoCreditoID, Var_TipoDispersion, Var_ClasifCred, Var_SubClasifID

			FROM CREDITOS Cre INNER JOIN
				CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID INNER JOIN
				DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
			WHERE CreditoID = Var_CreditoID;

            SET Var_MontoCredito := (SELECT Cre.MontoCredito FROM CREDITOS Cre
										WHERE CreditoID = Var_CreditoID);

			SET Var_NivelID := (SELECT Cre.NivelID FROM CREDITOS Cre
										WHERE CreditoID = Var_CreditoID);


			IF (IFNULL(Var_TipoDispersion,Cadena_Vacia)!=TipoDisperEfectivo)THEN

				IF(EXISTS(SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
												AND InstitucionID = Var_InstitucionID
												AND TipoDispersion = Var_TipoDispersion
												AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1))THEN
					# Se obtiene el tipo de cargo (monto o porcentaje).
					SET Var_TipoCargo		:= (SELECT TipoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
													AND InstitucionID = Var_InstitucionID
													AND TipoDispersion = Var_TipoDispersion
													AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
					IF(IFNULL(Var_TipoCargo, Cadena_Vacia) = TipoMonto)THEN
						/* SE OBTIENE EL MONTO POR CARGO DEL ESQUEMA POR PRODUCTO DE CREDITO */
						SET Var_MontoCargoDisp := (SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
														AND InstitucionID = Var_InstitucionID
														AND TipoDispersion = Var_TipoDispersion
														AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
					ELSEIF(IFNULL(Var_TipoCargo, Cadena_Vacia) = TipoPorcentaje)THEN
						# Se obtiene el porcentaje y se calcula sobre el monto del crédito.
						SET Var_PorcenCargoDisp := (SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
														AND InstitucionID = Var_InstitucionID
														AND TipoDispersion = Var_TipoDispersion
														AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
						SET Var_MontoCargoDisp	:= IFNULL(Var_MontoCredito, Entero_Cero)*(IFNULL(Var_PorcenCargoDisp, Entero_Cero)/100);

					END IF;
					SET Var_MontoCargoDisp	:= IFNULL(Var_MontoCargoDisp, Entero_Cero);

                    SET Var_MontoMov := Var_MontoMov - Var_MontoCargoDisp;

				END IF;


			END IF;

			-- Actualiza el Estatus de el movimiento de Dispersion
			SET Par_CuentaCheque :=  IFNULL(Par_CuentaCheque,Cadena_Vacia);
			CALL DISPERSIONMOVACT(
				Par_ClaveDispMov,   Par_DispersionID,   Par_Estatus,    	Par_CuentaCheque ,	Var_TipoActEstatus,		Entero_Cero,
				Salida_NO,          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,	Aud_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP ,   Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion  );

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/* Alta del Movimiento Operativo de la Cuenta Nostro de Tesoreria */
			SET var_RefCuentCheq := IFNULL(var_RefCuentCheq,Var_ReferenciaMov);
			CALL TESORERIAMOVSALT(
				CtaAhoID,		FechaValida,		Var_MontoMov,		Var_DescripcionMov,		var_RefCuentCheq,
				No_Conciliado,	Nat_Cargo,			Var_Automatico,		Var_TipoMovimiento,		Entero_Cero,
				Salida_NO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Aud_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion  );

			IF (Par_NumErr <> Entero_Cero)THEN
				SET Par_ErrMen := CONCAT(Par_ErrMen,' TESORERIAMOVSALT');
				LEAVE ManejoErrores;
			END IF;

			IF(Var_FormaPago = Cheque )THEN
				SET Var_Refere := Par_CuentaCheque;
			ELSE
				IF(Var_FormaPago = OrdenPago)THEN
					SET Var_Refere := Var_ReferenciaMov;
				ELSE
					SET Var_Refere := CONCAT(Var_ReferenciaMov,'-',Par_CuentaCheque);
				END IF;
			END IF;

			IF( Var_BonificacionID <> Entero_Cero ) THEN

				SELECT CentroCostoID
				INTO Var_CentroCostosID
				FROM CUENTASAHO Cue
				INNER JOIN SUCURSALES Suc ON Cue.SucursalID = Suc.SucursalID
				WHERE Cue.CuentaAhoID = CtaAhoID;

				IF (Var_FormaPago =  Tipo_pagoSpei) THEN
					SET Des_Contable := 'SPEI PAGO POR BONIFICACION';
				END IF;

				IF (Var_FormaPago =  Cheque) THEN
					SET Des_Contable := 'CHEQUE PAGADO POR BONIFICACION';
				END IF;

				IF (Var_FormaPago =  OrdenPago) THEN
					SET Des_Contable := 'ORDEN PAGO POR BONIFICACION';
				END IF;
			END IF;

			CALL CONTATESOREPRO(
				Entero_Cero,       	Mon_Base,           Var_InstitucionID,  Var_CuentaBancaria,		Entero_Cero,
				Var_ProveedorID,    Entero_Cero,        FechaValida,		FechaValida,       		Var_MontoMov,
				Des_Contable,       Var_Refere,			Var_CuentaBancaria, No_EmitePoliza,     	Par_Poliza,
				Entero_Cero,		Entero_Cero,        Nat_Abono,          Var_AltaMovAho,     	Var_CuentaAhoID,
				Var_ClienteID,      Tip_MovAho,         Nat_Cargo,			Salida_NO,          	Par_NumErr,
				Par_ErrMen,			Var_Consecutivo,    Aud_EmpresaID,      Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			-- si la cuenta contable viene vacia se des

			IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) <> Cadena_Vacia THEN

				IF(Var_FormaPago = Cheque )THEN
					SET Var_ReferenciaMov := Par_CuentaCheque;
				ELSE
					SET Var_ReferenciaMov := Var_ReferenciaMov;
				END IF;

				SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);

				CALL DETALLEPOLIZASALT(
					Aud_EmpresaID,		Par_Poliza,			FechaValida,		Var_CentroCostosID,	Var_CuentaConta,
					Var_CuentaBancaria,	Mon_Base,			Var_MontoMov,		Entero_Cero,		Des_Contable,
					Var_ReferenciaMov,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
					Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			/* Actualizacion del Saldo de la Cuenta de Bancos */
			CALL SALDOSCTATESOACT(
				Var_CuentaBancaria, Var_InstitucionID,   Var_MontoMov,       Nat_Cargo,      Salida_NO,
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/* SE OBTIENE EL TIPO DE DISPERSION DEL CREDITO */

			SELECT Cli.SucursalOrigen,Cre.ProductoCreditoID, Cre.TipoDispersion, Des.Clasificacion, Des.SubClasifID

				INTO Var_SucCliente,Var_ProductoCreditoID, Var_TipoDispersion, Var_ClasifCred, Var_SubClasifID

			FROM CREDITOS Cre INNER JOIN
				CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID INNER JOIN
				DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
			WHERE CreditoID = Var_CreditoID;

			SET Var_MontoCredito := (SELECT Cre.MontoCredito FROM CREDITOS Cre
										WHERE CreditoID = Var_CreditoID);

			SET Var_NivelID := (SELECT Cre.NivelID FROM CREDITOS Cre
										WHERE CreditoID = Var_CreditoID);

			IF(IFNULL(Var_TipoDispersion,Cadena_Vacia)!=TipoDisperEfectivo)THEN
				/* SI EXISTE UN ESQUEMA DE CARGOS POR DISPERSION POR PRODUCTO, INSTITUCION, TIPO DE DISPERSION Y NIVEL
				 * ENTONCES SE REALIZA EL COBRO. */
				IF(EXISTS(SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
												AND InstitucionID = Var_InstitucionID
												AND TipoDispersion = Var_TipoDispersion
												AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1))THEN
					# Se obtiene el tipo de cargo (monto o porcentaje).
					SET Var_TipoCargo		:= (SELECT TipoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
													AND InstitucionID = Var_InstitucionID
													AND TipoDispersion = Var_TipoDispersion
													AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
					IF(IFNULL(Var_TipoCargo, Cadena_Vacia) = TipoMonto)THEN
						/* SE OBTIENE EL MONTO POR CARGO DEL ESQUEMA POR PRODUCTO DE CREDITO */
						SET Var_MontoCargoDisp := (SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
														AND InstitucionID = Var_InstitucionID
														AND TipoDispersion = Var_TipoDispersion
														AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
					ELSEIF(IFNULL(Var_TipoCargo, Cadena_Vacia) = TipoPorcentaje)THEN
						# Se obtiene el porcentaje y se calcula sobre el monto del crédito.
						SET Var_PorcenCargoDisp := (SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
														AND InstitucionID = Var_InstitucionID
														AND TipoDispersion = Var_TipoDispersion
														AND Nivel IN (Var_NivelID, NivelTodas) LIMIT 1);
						SET Var_MontoCargoDisp	:= IFNULL(Var_MontoCredito, Entero_Cero)*(IFNULL(Var_PorcenCargoDisp, Entero_Cero)/100);

					END IF;
					SET Var_MontoCargoDisp	:= IFNULL(Var_MontoCargoDisp, Entero_Cero);
					CALL CONTACREDITOSPRO (
						Var_CreditoID,			Entero_Cero,				Var_CuentaAhoID,		Var_ClienteID,			Fecha_Sistema,
						Fecha_Sistema,			Var_MontoCargoDisp,			Mon_Base,				Var_ProductoCreditoID,	Var_ClasifCred,
						Var_SubClasifID, 		Var_SucCliente,				DesCargoDisposicion,	DesCargoDisposicion,	No_EmitePoliza,
						Entero_Cero,			Par_Poliza, 				AltaDetPol_Si,			Var_NO,					ConceptoCartera,
						Entero_Cero,			Nat_Abono,					Var_AltaMovAho,			Tip_MovAhoCargoDisp,	Nat_Cargo,
						Cadena_Vacia,			Salida_NO,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
						Aud_EmpresaID,			Cadena_Vacia, 				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,		 		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					IF(IFNULL(  Var_CuentaConta, Cadena_Vacia)) <> Cadena_Vacia THEN
						SET Var_ReferenciaMov := Var_ReferenciaMov;
						SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);

						CALL DETALLEPOLIZASALT(
							Aud_EmpresaID,		Par_Poliza,			FechaValida,		Var_CentroCostosID,	Var_CuentaConta,
							Var_CuentaBancaria,	Mon_Base,			Var_MontoCargoDisp,	Entero_Cero,		Des_Contable,
							Var_ReferenciaMov,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
							Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

					/* SE GUARDA EL MOVIMIENTO DEL CARGO POR DISPOSICION DEL CREDITO */
					CALL CARGOXDISPOSCREDALT(
						Var_CreditoID,		Var_CuentaAhoID,	Var_ClienteID,		Var_MontoCargoDisp,		Fecha_Sistema,
						Var_InstitucionID,	Cadena_Vacia,		Nat_Cargo,			Salida_NO,				Par_NumErr,
                        Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
                        Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

		ELSE    -- El movimiento de Dispersion NO se Autorizo

			-- Si es un Cheque o SPEI por Desembolso de Credito
			--
			IF ( Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
				 Var_TipoMovimiento =  Var_TipoChequeDesem OR
				 Var_TipoMovimiento =  Var_TipoOrdenDesem OR
                 Var_TipoMovimiento =  Var_TipoTransSanta) THEN

				-- Elimina el Folio de Dispersion
				CALL CREDITOSACT(
					Var_CreditoID,      Entero_Cero,        Fecha_Vacia,    Entero_Cero,    Act_FolDisCred,
					Fecha_Vacia,        Fecha_Vacia,        Entero_Cero,    Entero_Cero,    Entero_Cero,
					Cadena_Vacia,       Cadena_Vacia,       Entero_Cero,	Salida_NO,      Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal,       Aud_NumTransaccion  );

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
			-- Si la No Autorizacion es de un Pago a Proveedor con Factura o Sin Factura
			IF ( Var_TipoMovimiento =  Var_SPEIProveeFact OR
				 Var_TipoMovimiento =  Var_CheqProveeFact OR
				 Var_TipoMovimiento =  Var_SPEIProvee OR
				 Var_TipoMovimiento =  Var_ChequeProvee OR
				 Var_TipoMovimiento =  Var_TipoBanESinFac OR
				 Var_TipoMovimiento =  Var_TipoBanEFac OR
				 Var_TipoMovimiento =  Var_TipoTarESinFac OR
				 Var_TipoMovimiento =  Var_TipoTarEFac ) THEN

				-- Elimina el Folio de Dispersion de la Requisicion de Gasto
				CALL REQGASTOSUCMOVACT(
					Var_DetReqGasID,    Entero_Cero,    	Entero_Cero,        Cadena_Vacia,		Entero_Cero,
					Entero_Cero,    	Entero_Cero,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
					Cadena_Vacia,       Dis_FolioVacio, 	Entero_Cero,		Var_ProveedorID,	Act_FolDisReq,
					Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Var_TipoMovimiento =  Var_SPEIPagoServ ) THEN -- Es un Pago de servicios por spei
				CALL PAGOSERVICIOSACT(
					Var_CatalogoServID,		Par_DispersionID,	Var_NO,				Act_Aplicado,		Salida_NO,
					Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Var_TipoMovimiento =  Var_TipoMovAportacion ) THEN -- Es un Pago por spei

				 UPDATE HISAPORTBENEFICIARIOS
				  SET ClaveDispMov	= NULL
				  		WHERE  ClaveDispMov	= Par_ClaveDispMov;

				 UPDATE TMPDISPERSIONAPOR
				  SET ClaveDispMov	= NULL
				  		WHERE  ClaveDispMov	= Par_ClaveDispMov;

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Var_TipoMovimiento = Var_SPEIProvAntFact	OR
				Var_TipoMovimiento = Var_CheqProvAntFact	OR
				Var_TipoMovimiento = Var_TipoBanEAntFac		OR
				Var_TipoMovimiento = Var_TipoTarEAntFac) THEN
				/*se llama al sp que genera los movimientos contables .*/

				/* se llama sp para actualizar cada anticipo de factura que fueron cargadas para dispersar y borrarles el folio de dispersion
					y puedan ser tomadas nuevamente */
				CALL ANTICIPOFACTURACT(
					Entero_Cero,			Par_DispersionID,	Var_ProveedorID,	Var_NoFactura,			Var_FormaPago,
					Act_DisperCance,		Salida_NO,			Par_NumErr, 		Par_ErrMen,				Aud_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

		   -- Elimina el movimiento de Dispersion
			CALL DISPERSIONMOVBAJ(
				Par_ClaveDispMov,		Par_DispersionID,	Salida_NO, 			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,			Aud_Usuario,     	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,     		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Var_DispMultiple = Var_SI) THEN

			IF (Var_TipoMovimiento =  Var_TipoSpeiDesemb OR
				Var_TipoMovimiento =  Var_TipoChequeDesem OR
				Var_TipoMovimiento =  Var_TipoOrdenDesem OR
                Var_TipoMovimiento =  Var_TipoTransSanta ) THEN

				CALL BLOQCARTAPRO (
					Var_CreditoID,		Par_DispersionID,		Par_ClaveDispMov,	Var_MontoMov,			Par_Estatus,
					Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF;

		IF (Var_TipoMovimiento IN (	Var_TipoMovDisSPEIBon, Var_TipoMovDisCheqBon, Var_TipoMovDisOrdenBon,
									Var_TipoSpeiDesemb,	   Var_TipoChequeDesem,   Var_TipoOrdenDesem,
									Var_TipoTransSanta) ) THEN

			CALL ISOTRXTARNOTIFICAALT(
				Var_Intrumento,		Var_NumeroInstrumento,	Aud_NumTransaccion,		Var_OperacionPeticionID,	Var_MontoOperacion,
				Var_NO,				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr  	:= 0;
		SET Par_ErrMen  	:= CONCAT("La Dispersion No: ", CONVERT(Par_DispersionID, CHAR)," a sido Autorizada");
		SET Var_Control  	:= 'folioOperacion' ;
        SET Par_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control,
			   		Par_Consecutivo AS consecutivo,  --
			   		Par_Poliza AS campoGenerico; -- NO BORRAR SE UTILIZA PARA OBTENER EL VALOR DE POLIZAID
		END IF;

END TerminaStore$$
