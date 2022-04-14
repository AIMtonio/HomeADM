-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREPRO`;
DELIMITER $$

CREATE PROCEDURE `MINISTRACREPRO`(
# ==============================================================================================
#------------- REALIZA EL DESEMBOLSO LOGICO DE UN CREDITO --------------------------------------
# ==============================================================================================
	Par_CreditoID			BIGINT(12),		# ID de credito a desembolsar
	INOUT Par_PolizaID		BIGINT(20),		# Numero de	poliza para registrar los detalles contables
	Par_Salida          	CHAR(1),
    INOUT Par_NumErr   		INT(11),
    INOUT Par_ErrMen   		VARCHAR(400),

    -- Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control    		VARCHAR(100);   		-- Variable de Control
	DECLARE ConcepCtaOrdenDeu	INT(11);
	DECLARE ConcepCtaOrdenCor	INT(11);
	DECLARE Var_CreditoID       BIGINT(12);		 	-- Variables para el CURSOR
	DECLARE VarSucursalLin      INT(11);		 		-- Variables para el CURSOR

    DECLARE Var_AmortizID       INT(11);
	DECLARE Var_NumTransac      BIGINT;
	DECLARE Var_Cantidad        DECIMAL(14,2);		-- Fin Variable para el CURSOR
	DECLARE Var_ClienteID       BIGINT;				-- Numero de Cliente
	DECLARE Var_NomCliente      VARCHAR(200);		-- Nombre del Cliente

    DECLARE lineaCredito        BIGINT(20);
	DECLARE Var_CuentaAhoID     BIGINT(12);			-- Cuenta de Ahorro
	DECLARE Var_EstatusCre      CHAR(1);			-- Estatus del Credito
	DECLARE Var_SucCliente      INT(11);			-- Sucursal del Cliente
	DECLARE Var_ProdCreID       INT(11);			-- Clave del Producto de Credito

    DECLARE Var_ClasifCre       CHAR(1);			-- Clasificacion del Producto de Credito
	DECLARE Var_CuentaAhoStr    VARCHAR(20);
	DECLARE ManjeaLinea         CHAR(1);
	DECLARE FechVencLinea       DATE;
	DECLARE FechVencCred        DATE;

    DECLARE FechUltiAmort       DATE;
	DECLARE FechPrimAmort       DATE;
	DECLARE FechSistema         DATE;
	DECLARE MontoCred           DECIMAL(14,2);
	DECLARE SaldoDisp          	DECIMAL(14,2);

    DECLARE NumCredit           INT(11);
	DECLARE NTranSim            BIGINT(20);
	DECLARE MonedaLinea         INT(11);
	DECLARE PagImpCred          CHAR(1);
	DECLARE EstatusLinea        CHAR(1);

    DECLARE Var_FechaOper       DATE;
	DECLARE Var_FechaApl        DATE;
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_MonedaCta       INT(11);
	DECLARE Var_EsHabil         CHAR(1);

    DECLARE Var_SoliciCredID    BIGINT(20);
	DECLARE Var_FecIniCred      DATE;
	DECLARE Var_NumAmorti       INT(11);
	DECLARE Var_FrecuenCap      CHAR(1);
	DECLARE Var_NumRetMes       INT(11);

    DECLARE Var_TipPagCapita    CHAR(1);
	DECLARE Var_Poliza          BIGINT(20);
	DECLARE Str_NumErr          CHAR(3);
	DECLARE Par_Consecutivo     BIGINT(20);
	DECLARE Var_TipoDisper		CHAR(1);

    DECLARE Var_SolCredito		INT(11);
	DECLARE Var_CtaInstitu		INT(11);
	DECLARE FolioOperac         INT(11);
	DECLARE VarCuentaCLABE      VARCHAR(18);
	DECLARE VarRFCcte          	CHAR(13);

    DECLARE VarRFCPMcte         CHAR(13);
	DECLARE VarTipoPerson       CHAR(1);
	DECLARE Var_ManCapta        CHAR(1);
	DECLARE Var_MontoComAp      DECIMAL(12,2);
	DECLARE Var_IVAComAp        DECIMAL(12,2);

    DECLARE Var_PagIVA          CHAR(1);
	DECLARE Var_ForComApe       CHAR(1);
	DECLARE Var_TelefonoCel     VARCHAR(30);
	DECLARE Var_MsgDesemb       VARCHAR(80);
	DECLARE Var_TelCelInst      VARCHAR(20);

    DECLARE Var_DiaPagoCap      CHAR(1);
	DECLARE Var_DiaMesCap       INT(11);
	DECLARE Var_FechaInhabil    CHAR(1);
	DECLARE Var_AjFecUlVenAmo 	CHAR(1);
	DECLARE Var_AjFecExiVen    	CHAR(1);

    DECLARE Var_MontoBloqueo   	DECIMAL(14,2);
	DECLARE Var_MontoPago       DECIMAL(14,2);
	DECLARE Var_Relacionado     BIGINT(12);
	DECLARE Var_PagoAplica      DECIMAL(14,2);
	DECLARE Var_MontoADesem     DECIMAL(14, 2);

    DECLARE Var_SubClasifID     INT(11);
	DECLARE Var_Dispuesto		DECIMAL(14,2);
	DECLARE Var_FechaInicioAmor	DATE;
	DECLARE Var_AvalesRechazados INT(11);			-- Cantidad de Avales que no cumplen condiciones del Producto Credito
	DECLARE Var_IntercamAvales 	INT(11);			-- Cantidad de Avales que No Permiten Intecambio Avales

    DECLARE Var_RequiereAvales	CHAR(11);			-- Almacena Requiere Avales de Producto de Credito
	DECLARE Var_TipoCredito		CHAR(1);
	DECLARE Res_SaldoCredAnteri DECIMAL(12,2);      -- Variables para el Manejo de Reestructuras
	DECLARE Res_EstatusCredAnt  CHAR(1);			-- Saldo del Credito Anterior
	DECLARE Res_NumDiasAtraOri 	INT(11);			-- Numero de Atrasos

    DECLARE Res_PeriodCap       INT(11);			-- Periodicidad del Capital del Credito anterior
	DECLARE Res_EstatusCrea     CHAR(1);			-- Estatus del Credito anterior
	DECLARE Res_SaldoExigi      DECIMAL(12,2);		-- Exigible del Saldo
	DECLARE Res_NumPagoSos      INT(11);			-- Numero de Pagos Sostenidos
	DECLARE Tipo_MovConta       INT(11);			-- Tipo de movimiento contable

    DECLARE Var_TipoMovCred		INT(11);			-- Tipo de movimiento de contabilidad
	DECLARE Var_RelaEstatus 	CHAR(1);			--
	DECLARE Var_EsReestructura  CHAR(1);
	DECLARE Var_PeriodCap       INT(11);
	DECLARE Cre_EsRestruct      CHAR(1);

    DECLARE Var_AltaPoliza      CHAR(1);
	DECLARE Var_SalInteres      DECIMAL(14,2);
	DECLARE Var_Reserva         DECIMAL(14,2);
	DECLARE Var_MontoSegVida    DECIMAL(14,2);
	DECLARE Var_ForCobSegVida   CHAR(1);

    DECLARE Var_MontoCredito	DOUBLE(14,2);
	DECLARE Var_LineaCredito	BIGINT(20);
	DECLARE Var_SaldoCapital	DECIMAL(14,2);
	DECLARE Var_TotalInteres	DECIMAL(12,2);
    DECLARE Var_ReqValidaCred	CHAR(1);
	DECLARE Var_FechaVencim		DATE;
	DECLARE Var_FechaLimitRecep	DATE;
	DECLARE Var_InstitNominaID 	INT(11);

    DECLARE Var_CreditoIDCNBV		VARCHAR(29);
    DECLARE Var_TipoLiquidacion		CHAR(1);		# Tipo de Liquidacion con el que se pagará un credito
    DECLARE Var_CantidadPagar		DECIMAL(12,2);	# Cantidad a pagar
    DECLARE Var_FrecInteres			CHAR(1);		# Almacena la frecuencia de Interes
    DECLARE Var_PeriodInt			INT(11);		# Almacena la Periodicidad del Interes

    DECLARE	Var_LiquidaInteres		CHAR(1);
    DECLARE Var_MontoTotCom			DECIMAL(14,2);	# Monto Total del la Comision por Apertura
    DECLARE Var_FechaInicio			DATE;			# Fecha de inicio del credito
    DECLARE Var_FechaFinMes			DATE;			# Fecha Fin de Mes
    DECLARE Var_NumMes				INT(11);		# Numero de Mes
    DECLARE Var_FechaCobroCom		DATE;			# Fecha de Cobro de la Comision por apertura
    DECLARE Var_MesFechaInicio		INT(11);		# Mes de la fecha de inicio del credito
    DECLARE Var_MesFechaCobCom		INT(11);		# Mes fecha de cobro de la comision por apertura
    DECLARE Var_ParticipaSpei   	CHAR(1);		-- Almacena el producto de credito participa en SPEI
    DECLARE Var_ProductoCLABE   	CHAR(3);		-- Almacena la CLABE SPEI del producto de credito
    DECLARE Var_Clabe   			VARCHAR(18);	-- Almacena la CLABE del Credito
	DECLARE Var_FechaReservas 		DATE;

    #CREDITOS AUTOMATICOS
    DECLARE Var_InversionID			INT(11);		# Numero de Inversion Relacionada al Credito
    #COBRO ACCESORIOS
    DECLARE Var_NumRegistros		INT(11);			# Numero de Registros
	DECLARE Contador				INT(11);			# Auxiliar para ciclo WHILE
    DECLARE Var_AccesorioID			INT(11);			# Identificador del accesorio
	DECLARE Var_MontoIVACuota		DECIMAL(14,2);		# Monto a cobrar del accesorio
	DECLARE Var_AbrevAccesorio		VARCHAR(20);		# Abreviatura del accesorio
	DECLARE Var_ConceptoCartera		INT(11);			# Concepto de Cartera al que corresponde el accesorio
    DECLARE Var_ConceptoIVACartera	INT(11);			# Concepto de Cartera al que corresponde el accesorio
	DECLARE Var_MontoCuota			DECIMAL(12,2);		# Monto Fijo de la Cuota
    DECLARE Var_CobraIVAAc			CHAR(1);			# Indica si el accesorio cobra o no cobra IVA
    DECLARE Var_TotalAccesorios		DECIMAL(14,2);		# Indica el Monto Total a cobrar de Accesorios
    DECLARE Var_TotalIVAAccesorio	DECIMAL(14,2);	# Indica el Monto Total de IVA de Accesorios a cobrar
	DECLARE Var_MontoCuotaAc 		DECIMAL(12,2);		# Variable para el monto de Accesorios
    DECLARE MontoIVACuotaAc			DECIMAL(12,2); 		# Variable para monto de IVA de Accesorios

    DECLARE Var_CobraComAnual		CHAR(1);			-- Indica si cobra comisión anual de linea de crédito
    DECLARE Var_TipoComAnual 		CHAR(1);			-- Indica el tipo de corbo de comisión anual de la linea de crédito
    DECLARE Var_ValorComAnual		DECIMAL(14,2);		-- Indica el valor a cobrar por anualidad de la linea de crédito
    DECLARE Var_ComisionCobrada 	CHAR(1);			-- Indica si ya ha cobrado la comisión anual la linea
	DECLARE Var_SaldoLinea			DECIMAL(14,2);		-- Indica el Saldo Disponible en la linea de crédito
    DECLARE Var_SaldoComAnual		DECIMAL(14,2); 		-- Monto Pendiente de la comisión anual

    DECLARE Var_MontoComAnual		DECIMAL(14,2);		-- Monto a Cobrar por la comisión de la linea de crédito
    DECLARE Var_MontoIVAComAnual	DECIMAL(14,2);		-- Monto del IVA por la comisión de la linea de crédito
    DECLARE Var_IVA					DECIMAL(14,2);		-- Porcentaje de IVA
    DECLARE Var_CobraGarFin			CHAR(1);
    DECLARE Var_RequiereGarFOGAFI	CHAR(1);
	DECLARE Var_ModalidadFOGAFI		CHAR(1);
	DECLARE Var_NumCuotas			INT(11);
    DECLARE Var_FechaExigible		DATE;
    DECLARE Var_MontoFOGAFI			DECIMAL(14,2);
    DECLARE Var_SaldoFOGAFI			DECIMAL(14,2);
    DECLARE Var_MontoCuotaFOGAFI	DECIMAL(14,2);
    DECLARE Var_SPEIHabilitado		CHAR(1);			-- Variable para obtener si esta habilitado SPEI
    DECLARE Var_FolioEnvio			BIGINT(20);			-- Variable para obtener el folio de envio
    DECLARE Var_ClaveRastreo		VARCHAR(30);		-- Variable para obtener la clave de rastreo
    DECLARE Var_ComSpeiPerMor		DECIMAL(18,2);		-- Variable para obtener la comision de persona moral SPEI
	DECLARE Var_ComSpeiPerFis		DECIMAL(18,2);		-- Variable para obtener la comision de persona fisica SPEI
    DECLARE Var_ComisionTrans		DECIMAL(16,2);		-- Variable para almacenar la comision de tranferencia
    DECLARE Var_ComisionIVA			DECIMAL(16,2);		-- Variable para almacenar le IVA de comision
    DECLARE Var_TipoCuentaID		INT(11);			-- Variable para obtener el tipo cuenta de la cuenta de ahorro del ordenante
    DECLARE Var_TotalCargoCuenta	DECIMAL(18,2);		-- Variable para almacenar el cargo total
    DECLARE Var_ClabeOrdenante		VARCHAR(20);		-- Variable para obtener la cable de la cuenta ordenante
    DECLARE Var_NombreOrdenante		VARCHAR(100);		-- Variable para obtener el nombre del ordenante
    DECLARE Var_RFCOrdenante		VARCHAR(18);		-- Variable para obtener el rfc del ordenante
    DECLARE Var_InstitRecep			INT(5);				-- Variable para obtener la institucion receptora
    DECLARE Var_TipoCuentaBen		INT(2);				-- Variable para obtener el tipo cuenta del beneficiario
    DECLARE Var_NombreBenefi		VARCHAR(100);		-- Variable para obtener el nombre del beneficiario
    DECLARE Var_RFCBenefi			VARCHAR(100);		-- Variable para obtener el rfc del beneficiario
    DECLARE Var_CliCuentaTrans		INT(11);			-- Variable para obtener el cliente de la cuenta CLABE del credito
    DECLARE Var_ReferenciaNum		INT(7);				-- Variable para almacenar la referencia numerica del envio SPEI
    DECLARE Var_UsuEnvioSPEI		VARCHAR(30);		-- Variable para almacenar el usuario de envio SPEI
    DECLARE Var_FechaSinGuion		VARCHAR(7);			-- Variable para almacenar la fecha sin guiones
    DECLARE Var_InstiRemi			INT(11);			-- Variable para almacenar la institucion remitente
    DECLARE Var_PrioEnvio			INT(1);				-- Variable para obtener la prioridad de envio
    DECLARE Var_FechaAuto			DATETIME;			-- Variable para almacenar la fecha de autorizacion
    DECLARE Var_FechaRecep			DATETIME;			-- Variable para almacenar la fecha de recepcion
    DECLARE Var_FolioSTP			INT(11);			-- Variable para almacenar el folio de STP
    DECLARE Var_TipoConexion		CHAR(1);			-- Variable para almacenar el tipo conexion de SPEI
	DECLARE Var_montoReqAuTesor		DECIMAL(14,2);		-- variable para almacenar el monto de autorizacion de tesoreria
	DECLARE Var_BloqueoID			INT(11);			-- ID de Bloqueo referente a la tabla de BLOQUEOS
	DECLARE Var_MontoCliente		DECIMAL(14,2);		-- Monto Correspondiente al Cliente con respecto a las Cartas de Liq
	DECLARE Var_MontoCartasPend		DECIMAL(18,2);		-- Monto de Cartas Pendiente por Procesar
	DECLARE Var_LlaveCRW			VARCHAR(50);		-- Llave para filtro de modulo crowdfunding
	DECLARE Var_CrwActivo			CHAR(1);			-- Variable para almacenar el valor de habilitacion de modulo crowdfunding
	DECLARE	Var_SaldoFondeo			DECIMAL(14,4);		-- Variable para almacenar el valor del saldo fondeo
	DECLARE	Var_SaldoCreInsol		DECIMAL(12,2);		-- Variable para almacenar el valor de saldo credito insoluto
	DECLARE Var_EjecucionNo			CHAR(1);			-- Variable para almacenar el valor de credito en ejecucion N
	DECLARE Var_EstCuentaClabe		CHAR(1);			-- Estatus de la cuenta clabe.
	DECLARE Var_ClabeOrdPF			VARCHAR(18);		-- Cuenta Clabe de la institucion para persona fisica
	DECLARE Var_ClabeOrdPM			VARCHAR(18);		-- Cuenta Clabe de la institucion para persona moral
	DECLARE Var_ConvenioNominaID	BIGINT UNSIGNED;	-- Variable para almacenar el identificador de un convenio de nomina
	DECLARE Var_ManejaCalendario	CHAR(1);			-- Variable para almacenar si un convenio de nomina maneja calendario de ingresos
	DECLARE Var_ManejaFechaIniCal	CHAR(1);			-- Variable para almacenar si un convenio de nomina ajusta la fecha de inicio del credito
	DECLARE Var_ManejaConvenio		CHAR(1);			-- Variable para almacenar si el sistema usa convenios
	DECLARE Var_EstatusLinea        CHAR(1);            -- Variable de Estatus de linea de credito

	DECLARE Var_NumCartasInt		INT(11);
	DECLARE Var_EstConsolidacion	VARCHAR(1);			-- Variable que alamcena el estatus de la consolidacion
	DECLARE Var_ConvNomID			BIGINT UNSIGNED;	-- Variable para identificador de un convenio
	DECLARE Var_ReportaIncid		CHAR(1);			-- Indica si un convenio de nomina reporta incidencias
	DECLARE Var_AplicacionSpei 		CHAR(1);			-- Aplica para de Cuentas Transfer

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Entero_Cero         INT(11);
	DECLARE Fecha_Vacia         DATE;
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Estatus_Inactivo    CHAR(1);

    DECLARE EstatusVigente   	CHAR(1);
	DECLARE EstatusVencido   	CHAR(1);
	DECLARE EstatusDesemb       CHAR(1);
	DECLARE EstatusPagado       CHAR(1);
    DECLARE Estatus_Procesado	CHAR(1);

    DECLARE SiManejaLinea       CHAR(1);
	DECLARE PagareImp           CHAR(1);
	DECLARE NumPrimAmort        INT(11);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);

    DECLARE AltaPoliza_SI       CHAR(1);
	DECLARE AltaPoliza_NO       CHAR(1);
	DECLARE AltaPolCre_SI       CHAR(1);
	DECLARE AltaMovAho_SI       CHAR(1);
	DECLARE AltaMovAho_NO       CHAR(1);

    DECLARE AltaMovCre_NO       CHAR(1);
	DECLARE AltaPolCre_NO       CHAR(1);
	DECLARE DispersionSPEI      CHAR(1);
	DECLARE DispersionCheque    CHAR(1);
    DECLARE DispersionOrden		CHAR(1);

    DECLARE Mov_CapVigente      INT(11);
	DECLARE Mov_CapVencido      INT(11);
	DECLARE Mov_CapVeNoExi      INT(11);
	DECLARE Con_ContDesem       INT(11);
	DECLARE Con_ContCapCre      INT(11);

    DECLARE Con_ContCapVen      INT(11);
	DECLARE Con_ContCapVNE      INT(11);
	DECLARE Con_ContComApe      INT(11); -- Concepto contable cartera  comision por apertura
	DECLARE Con_ContIVACApe     INT(11); -- Concepto contable cartera IVA comision por apertura.
	DECLARE Tip_MovAhoDesem     CHAR(3);

    DECLARE Tip_MovAhoComAp     CHAR(3);
	DECLARE Tip_MovIVAAhCAp     CHAR(3);
	DECLARE Tip_MovAhoSegVid    CHAR(3);
	DECLARE Pag_Libres          CHAR(1);
	DECLARE Fre_Semanal         CHAR(1);

    DECLARE Fre_Catorce         CHAR(1);
	DECLARE Fre_Quince          CHAR(1);
	DECLARE Fre_Mensual         CHAR(1);
	DECLARE Var_Descripcion     VARCHAR(100);
	DECLARE Var_DescComAper     VARCHAR(100);

    DECLARE Var_DescSegVida     VARCHAR(100);
	DECLARE Var_DcIVAComApe     VARCHAR(100);
	DECLARE SalidaNo            CHAR(1);
	DECLARE NatMovBloqueo       CHAR(1);
	DECLARE DescripBloqueo      VARCHAR(100);

    DECLARE DescripBloqSPEI     VARCHAR(40);
	DECLARE DescripBloqCheq     VARCHAR(40);
    DECLARE DescripBloqOrden    VARCHAR(100);
	DECLARE TipoBloqueo         INT(11);
	DECLARE ManCaptacionSi      CHAR(1);

    DECLARE ManCaptacionNo      CHAR(1);
	DECLARE SiPagaIVA           CHAR(1);
	DECLARE ForComApDeduc       CHAR(1); -- Forma de Cobro de Comision por apertura : D(Deduccion)
	DECLARE ForComApFinanc      CHAR(1); -- Forma de Cobro de Comision por apertura : F (Financiamento)
	DECLARE Tip_FonSolici       CHAR(1);

    DECLARE No_EsReestruc       CHAR(1);
	DECLARE Si_EsReestruc       CHAR(1);
	DECLARE Finiquito_SI        CHAR(1);
	DECLARE PrePago_NO          CHAR(1);
	DECLARE Num_PagRegula       INT(11);

    DECLARE Salida_SI           CHAR(1); -- Indica una salida en pantalla
	DECLARE Var_CargoCuenta		CHAR(1); -- Indica que se trata de un pago con cargo a cuenta
	DECLARE SMS_CamMinistra     INT(11);
	DECLARE Act_Desembolso      INT(11);
	DECLARE Con_EstBalance      INT(11);

    DECLARE Con_EstResultados   INT(11);
	DECLARE Con_PagoSegVida     INT(11);
	DECLARE Act_SegVigente      INT(11);
	DECLARE Des_Reserva         VARCHAR(100);
	DECLARE ForCobroApDeduc		CHAR(1); -- Forma de Cobro de Comision por apertura : D(Deduccion)

    DECLARE ForCobroApFinanc	CHAR(1); -- Forma de Cobro de Comision por apertura : F (Financiamento)
	DECLARE Var_EsqSeguroID		DECIMAL(12,2);	# ID del Esquema de Seguro de Vida
	DECLARE EstatusAvalesSol 	CHAR(1);		-- Estatus de  Avales por Solicitudes, Asignado.
	DECLARE IntercamAvales_NO	CHAR(1);	-- Producto de Credito No Intercambia Avales
	DECLARE RequiereAvales_SI	CHAR(1);	-- Producto de Credito Si Requiere Avales

    DECLARE RequiereAvales_IN	CHAR(1);	-- Producto de Credito Requiere Avales Indistinto
	DECLARE EstatusDesembolsada	CHAR(1);	-- Estatus de la solicitud: Desembolsada
	DECLARE Con_AvalID			INT(1);		-- Consulta por AvalID
	DECLARE Con_ClienteID		INT(1);		-- Consulta por ClienteID
	DECLARE Con_ProspectoID		INT(1);		-- Consulta por ProspectoID

    DECLARE CreReestructura		CHAR(1);
	DECLARE CreRenovacion		CHAR(1);
	DECLARE CreNuevo			CHAR(1);
    DECLARE Var_SaldoCredAnt    DECIMAL(12,2);
    DECLARE Var_PagaInteres		CHAR(1);

    DECLARE Var_SI				CHAR(1);
    DECLARE LiquidacionTotal	CHAR(1);
    DECLARE LiquidacionParcial	CHAR(1);
    DECLARE FrecUnico			CHAR(1);
    DECLARE FrecLibre			CHAR(1);

    DECLARE Con_TipoPFisica			CHAR(1);
	DECLARE Con_TipoPMoral			CHAR(1);
	DECLARE Con_ContratoPFisica		CHAR(3);
	DECLARE Con_ContratoPMoral		CHAR(3);
	DECLARE Var_TipoContrato		CHAR(3);

	/*Esquema de Seguro de Vida*/
	DECLARE Var_EsquemaSeguro	INT(11);
	DECLARE Var_ProdCredID		INT(11);
	DECLARE Var_TipPagSegu		CHAR(1);
	DECLARE Var_FactRiSeg		DECIMAL(12,6);
	DECLARE Var_DescSegu		DECIMAL(12,2);

    DECLARE Var_MontoPolSeg 	DECIMAL(12,2);
	DECLARE Var_TipoProd 		INT(11);
    DECLARE Con_ContGastos		INT(11); -- Concepto Contable Cartera: Cuenta Gastos
	DECLARE Con_Origen			CHAR(1);

    DECLARE Cons_FrecLibre		CHAR(1); -- Frecuencia Libre
    DECLARE Cons_FrecUnico		CHAR(1); -- Frecuencia Unico
    DECLARE Cons_Periodo		CHAR(1); -- Frecuencia Periodo
    DECLARE Cons_NO				CHAR(1); -- Constante NO

    DECLARE Var_DescAccesorios  	VARCHAR(100);
	DECLARE Var_DescIVAAccesorios	VARCHAR(100);
    DECLARE Tip_MovAhoAccesorios     CHAR(3);
	DECLARE Tip_MovIVAAccesorios     CHAR(3);
    DECLARE ForCobroDeduccion		CHAR(1);

    DECLARE ConstDescipLinea	VARCHAR(500); 		-- Descripción para los movimientos de linea de crédito
    DECLARE Con_ContComAnual		INT(11);			-- Concepto de Cartera para la Comisión Anual de Linea de Crédito
    DECLARE Con_ContIVAComAnual		INT(11);			-- Concepto de Cartera para IVA de la Comisión Anual de Linea de Crédito
    DECLARE TipoMovAhoComAnual		VARCHAR(4);		-- Tipo de Movimiento de Ahorro Comisión Anual
    DECLARE TipoMovAhoIVAComAnual	VARCHAR(4);		-- Tipo de Movimiento de Ahorro IVA Comisión Anual
    DECLARE LlaveGarFinanciada	VARCHAR(100);
    DECLARE ModPeriodico		CHAR(1);
    DECLARE Var_TipoPagoTercer		INT(1);			-- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
    DECLARE Var_TipoCuentaOrd		INT(2);			-- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
    DECLARE Var_PersonaMoral		CHAR(1);		-- Tipo persona moral
    DECLARE Var_PersFisConAct		CHAR(1);		-- Tipo persona fisica con actividad empresarial
    DECLARE Var_PersFisSinAct		CHAR(1);		-- Tipo persona fisica sin actividad empresarial
    DECLARE Var_PorcentajeIVA		DECIMAL(14,2);	-- Porcentaje de IVA para la comision
    DECLARE Var_ConceptoPago		VARCHAR(40);	-- Concepto del pago SPEI
    DECLARE Var_AreaBanco			INT(1);			-- Area emite banco SPEI
    DECLARE Var_OrigenOperVent		CHAR(1);		-- Origen operacion ventanilla
    DECLARE Var_ActVerificSPEI		TINYINT UNSIGNED;	-- Actualizacion de verificacion de envio SPEI
    DECLARE Est_Verif				CHAR(1);		-- Estatus verificado SPEI ENVIO
	DECLARE Est_Pend				CHAR(1);		-- estatus pendiente spei envio
	DECLARE Est_FinalEstatus		CHAR(1);		-- Estatus final con el que sera guardado el Envio de SPEI
	DECLARE Act_EstatusDesemPen		INT(11);		-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso

	DECLARE Var_ParticipanteID		BIGINT(20);			-- Numero de Participante
	DECLARE Var_TipoParticipante	CHAR(1);			-- Tipo de Participante
	DECLARE Var_MensajeNotificacion	VARCHAR(400);		-- Mensaje de Notificacion
	DECLARE Var_RequiereCheckList 	CHAR(1);			-- Requiere Check List
	DECLARE Ope_Participante		TINYINT UNSIGNED;	-- Numero de Operacion para obtener el ID del participante
	DECLARE Inst_Credito			INT(11);			-- Instrumento Solicitud de Credito
	DECLARE RespaldaCredSI			CHAR(1);
	DECLARE MultipleDisp			CHAR(1);			-- Permite Multiple Dispersiones
	DECLARE DispersionEfectivo		CHAR(1);			-- Dispersion EFECTIVO
	DECLARE DescripBloqSantan		VARCHAR(40);
	DECLARE DispersionSantan		CHAR(1);			-- Dispersion Tran santander
	DECLARE OriPago_Reest			CHAR(1);			-- Dispersion EFECTIVO
	DECLARE Con_TipoCarta			CHAR(1);
	DECLARE Con_EstatusCarta		CHAR(1);
	DECLARE Var_ReqInsDispersion 	CHAR(1);			-- Para conocer si el producto Requiere Instrucciones de Dispersion.
	DECLARE Var_EsConsolidado		VARCHAR(1);			-- Variable para almacenar si el credito es consolidado.
	DECLARE Est_CueClabeAut			CHAR(1);			-- EStatus de cuenta clabe Autorizada
	DECLARE Est_CueClabeBaj			CHAR(1);			-- EStatus de cuenta clabe Baja
	DECLARE Est_CueClabeIna			CHAR(1);			-- EStatus de cuenta clabe Inactiva
	DECLARE Est_CueClabePen			CHAR(1);			-- EStatus de cuenta clabe Pendiente de Autorizacion
	DECLARE Est_DesCueClabeBaj		VARCHAR(20);		-- Descripcion del Estatus de cuenta clabe Baja
	DECLARE Est_DesCueClabeIna		VARCHAR(20);		-- Descripcion del Estatus de cuenta clabe Inactiva
	DECLARE Est_DesCueClabePen		VARCHAR(30);		-- Descripcion del Estatus de cuenta clabe Pendiente
	DECLARE Var_EstNoEnviado		CHAR(1);			-- Estatus N : No Enviado del flujo de instalacion de nomina
	DECLARE Est_Bloqueado	        CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
	DECLARE EstLinea_Vencido 	    CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nE.- Vencido
	DECLARE Var_CtaReqCreAmbas		CHAR(1);
	DECLARE LlaveCtaCreDesembolso	VARCHAR(50);

	DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoID,  Amo.AmortizacionID, Aud_NumTransaccion, Amo.Capital
			FROM 	AMORTICREDITO Amo
					INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
			WHERE	Cre.CreditoID   = Par_CreditoID
			AND 	Amo.Estatus   	= EstatusVigente
			AND 	(Cre.Estatus  	= EstatusVigente
					OR  Cre.Estatus	= EstatusVencido )
			AND 	Amo.Capital 	> Entero_Cero ;

	-- Asignacion de Constantes
	SET Cadena_Vacia        	:= '';              -- String Vacio
	SET Fecha_Vacia         	:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         	:= 0;               -- Entero en Cero
    SET Decimal_Cero			:= 0.00;			-- DECIMAL Cero
	SET Estatus_Activo      	:= 'A';             -- Estatus Activo
	SET Estatus_Inactivo    	:= 'I';             -- Estatus Inactivo

    SET SiManejaLinea       	:= 'S';             -- El Credito si Maneja Linea
	SET PagareImp           	:= 'S';             -- El pagare esta Impreso
	SET NumPrimAmort        	:= 1;               -- Numero de la Primera Amortizacion
	SET EstatusVigente      	:= 'V';	            -- Estatus de Vigente
	SET EstatusVencido      	:= 'B';	            -- Estatus de Vencido

    SET EstatusDesemb       	:= 'D';		        -- Estatus de Desembolsado
	SET EstatusPagado       	:= 'P';		        -- Estatus de Pagado
    SET Estatus_Procesado		:= 'M';				-- Estatus Procesado
	SET Nat_Cargo           	:= 'C';             -- Naturaleza de Cargo
	SET Nat_Abono           	:= 'A';             -- Naturaleza de Abono.

    SET Mov_CapVigente      	:= 1;  		        -- Tipo del Movimiento de Credito: Capital Vigente (TIPOSMOVSCRE)
	SET Mov_CapVencido      	:= 3;  		        -- Tipo del Movimiento de Credito: Capital Vencido (TIPOSMOVSCRE)
	SET Mov_CapVeNoExi      	:= 4;  		        -- Tipo del Movimiento de Credito: Capital Vencido No Exigible
	SET DispersionSPEI      	:= 'S';             -- Tipo de Dispersion por SPEI
	SET DispersionCheque    	:= 'C';             -- Tipo de Dispersion por Cheque

    SET DispersionOrden			:= 'O';				-- Tipo de Dispersion por Orden de Pago
    SET DispersionSantan		:= 'A';				-- Tipo de Dispersion por Tran Santander
	SET AltaPoliza_SI       	:= 'S';	          	-- Alta de Poliza Contable General: SI
	SET AltaPoliza_NO       	:= 'N';	          	-- Alta de Poliza Contable General: NO
	SET AltaPolCre_SI       	:= 'S';		       	-- Alta de Poliza Contable de Credito: SI
	SET AltaPolCre_NO       	:= 'N';            	-- Alta de Poliza Contable de Credito: NO

    SET AltaMovAho_SI       	:= 'S';		       	-- Alta de Movimiento de Ahorro: SI
	SET AltaMovAho_NO       	:= 'N';		       	-- Alta de Movimiento de Ahorro: NO
	SET AltaMovCre_NO       	:= 'N';		       	-- Alta de Movimiento de Credito: NO
	SET Con_ContDesem       	:= 50;              -- Concepto Contable de Desembolso (CONCEPTOSCONTA)
	SET Con_ContCapCre      	:= 1;               -- Concepto Contable de Credito: Capital (CONCEPTOSCARTERA)

    SET Con_ContCapVen      	:= 3;               -- Concepto Contable de Credito: Capital Vencido (CONCEPTOSCARTERA)
	SET Con_ContCapVNE      	:= 4;               -- Concepto Contable de Credito: Capital Vencido No Exigible
	SET Con_ContComApe      	:= 22;              -- Concepto Contable de Credito: Com x Apertura (CONCEPTOSCARTERA)
	SET Con_ContIVACApe     	:= 23;              -- Concepto Contable de Credito: IVA Com Apertura (CONCEPTOSCARTERA)
	SET Tip_MovAhoDesem    	 	:= '100';	        -- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)

    SET Tip_MovAhoComAp     	:= '83';            -- Tipo de Movimiento en Cta de Ahorro: Com Apertura (TIPOSMOVSAHO)
	SET Tip_MovIVAAhCAp     	:= '84';            -- Tipo de Movimiento en Cta de Ahorro: IVA Com Apert (TIPOSMOVSAHO)
	SET Tip_MovAhoSegVid    	:= '85';            -- Tipo de Movimiento en Cta de Ahorro: Pago de Seguro de Vida
	SET Pag_Libres          	:= 'L';             -- Tipo de Calendario: Amortizaciones con Pagos Libres
	SET Fre_Semanal         	:= 'S';             -- Frecuencia de Pagos Semanales

    SET Fre_Catorce         	:= 'C';             -- Frecuencia de Pagos Catorcenales
	SET Fre_Quince          	:= 'Q';             -- Frecuencia de Pagos Quincenal
	SET Fre_Mensual         	:= 'M';             -- Frecuencia de Pagos Mensual
	SET SalidaNo            	:= 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
	SET NatMovBloqueo  			:= 'B';             -- Tipo de Movimiento de Bloqueo de Saldo en Cta de Ahorro

    SET TipoBloqueo 			:= 1;               -- Tipo de Movimiento de Bloqueo
	SET ManCaptacionSi      	:= 'S';             -- La institucion si Maneja Captacion
	SET ManCaptacionNo      	:= 'N';             -- La institucion no Maneja Captacion
	SET SiPagaIVA           	:= 'S';             -- El Cliente si Paga IVA
	SET ForComApDeduc       	:= 'D';             -- La Comision por Apertura en por Deduccion

    SET ForComApFinanc      	:= 'F';             -- La Comision por Apertura en por Financiamiento
	SET Tip_FonSolici       	:= 'S';             -- Tipo de Fondeo en base a la Solicitud
	SET No_EsReestruc       	:= 'N';             -- El Producto de Credito no es para Reestructuras
	SET Si_EsReestruc       	:= 'S';             -- El credito si es una Reestructura
	SET Finiquito_SI        	:= 'S';             -- El Tipo de Pago SI es Finiquito

    SET PrePago_NO          	:= 'N';             -- El Tipo de Pago No es PrePago
	SET Num_PagRegula       	:= 3;                -- Numero de Pagos Para Regularizacion Reestructura: 3
	SET Act_Desembolso      	:= 1;               -- Tipo de Actualizacion de la Reest: Desembolso
	SET Con_EstBalance      	:= 17;               -- Balance. Estimacion Prev. Riesgos Crediticios
	SET Con_EstResultados   	:= 18;               -- Resultados. Estimacion Prev. Riesgos Crediticios

    SET Con_PagoSegVida     	:= 25;               -- Concepto Contable de Cobertura de Seguro de Vida
	SET Act_SegVigente      	:= 1;               -- Tipo de Actualizacion del Seguro: Vigente (Pagado por el Cliente)
	SET ForCobroApDeduc			:= 'D';
	SET ForCobroApFinanc		:= 'F';
	SET Des_Reserva         	:= 'ESTIMACION CAPITALIZACION INTERES';

	SET Var_Descripcion     	:= 'DESEMBOLSO DE CREDITO';
	SET Var_DescComAper     	:= 'COMISION POR APERTURA';
	SET Var_DescSegVida     	:= 'SEGURO DE VIDA';
	SET Var_DcIVAComApe     	:= 'IVA COMISION POR APERTURA';
	SET DescripBloqSPEI     	:= 'BLOQUEO DE SALDO POR SPEI';

	SET DescripBloqCheq     	:= 'BLOQUEO DE SALDO POR CHEQUE';
    SET DescripBloqOrden		:= 'BLOQUEO DE SALDO POR ORDEN DE PAGO';
    SET DescripBloqSantan		:= 'BLOQUEO DE SALDO POR TRAN. SANTANDER';
	SET Salida_SI           	:= 'S';
	SET Var_CargoCuenta			:= 'C';
	SET SMS_CamMinistra     	:= 1010;  -- Campaña de Ministracion

	SET ConcepCtaOrdenDeu		:= 53;		/* Linea Credito Cta. Orden */
	SET ConcepCtaOrdenCor		:= 54;		/* Linea Credito Corr. Cta Orden */
	SET EstatusAvalesSol		:= 'U';		-- Estatus Avales por Solicitud:	Asignado
	SET IntercamAvales_NO		:= 'N';		-- Producto Credito Intercambia Avales:		No
	SET RequiereAvales_SI		:= 'S';		-- Producto Credito Requiere Avales:	Si

	SET RequiereAvales_IN		:= 'I';		-- Producto Credito Requiere Avales:	Indistinto
	SET EstatusDesembolsada     := 'D';     -- Estatus de la Solicitud: Desembolsada
	SET Con_AvalID				:= 1;		-- Consulta por AvalID
	SET Con_ClienteID			:= 2;		-- Consulta por ClienteID
	SET Con_ProspectoID			:= 3;		-- Consulta por ProspectoID

	SET CreReestructura			:= 'R';		-- Credito reestructurador
	SET CreRenovacion			:= 'O';		-- Credito Renovador
	SET CreNuevo				:= 'N';		-- Credito Nuevo
	SET Var_SaldoCredAnt        :=0.0;
	SET	Var_SI					:= 'S';

    SET Var_TipoProd			:= 2; 		-- Creditos sin Linea de Credito
    SET LiquidacionTotal		:= 'T';		-- Liquidacion Total(Renovaciones)
	SET LiquidacionParcial		:= 'P';		-- Liquidacion Parcial(Renovaciones)
    SET FrecUnico				:= 'U';		-- Frecuencua Unica
    SET FrecLibre				:= 'L';		-- Frecuencia Libre
    SET Con_ContGastos			:=58 ;		-- Cuenta Puente para la Comision por Apertura
	SET Con_Origen				:= 'S';		-- Constante Origen donde se llama el SP (S= safy, W=WS)

    SET Cons_FrecLibre			:= 'L';
    SET Cons_FrecUnico			:= 'U';
    SET Cons_Periodo			:= 'P';
    SET Cons_NO					:= 'N';


	SET Tip_MovAhoAccesorios	:= '108';						-- Tipo de Movimiento en Cta de Ahorro: Accesorios (TIPOSMOVSAHO)
	SET Tip_MovIVAAccesorios	:= '109';						-- Tipo de Movimiento en Cta de Ahorro: IVA de Accesorios (TIPOSMOVSAHO)
    SET ForCobroDeduccion		:= 'D';							-- Forma de cobro de Accesorios: DEDUCCION

    SET Con_ContComAnual		:= 100;			-- Concepto de Cartera para la Comisión Anual de Linea de Crédito
    SET Con_ContIVAComAnual		:= 101;			-- Concepto de Cartera para IVA de la Comisión Anual de Linea de Crédito

    SET TipoMovAhoComAnual		:= '208';		-- Tipo de Movimiento de Ahorro Comisión Anual
    SET TipoMovAhoIVAComAnual	:= '209';		-- Tipo de Movimiento de Ahorro IVA Comisión Anual
    	SET LlaveGarFinanciada		:= 'CobraGarantiaFinanciada';
    SET ModPeriodico			:= 'P';
    SET Var_TipoPagoTercer		:= 1;			-- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
    SET Var_TipoCuentaOrd		:= 40;			-- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
	SET Var_PersonaMoral		:= 'M';			-- Tipo persona moral
	SET Var_PersFisConAct		:= 'A';			-- Tipo persona fisica con actividad empresarial
	SET Var_PersFisSinAct		:= 'F';			-- Tipo persona fisica sin actividad empresarial
    SET Var_PorcentajeIVA		:= 0.16;		-- Porcentaje de IVA para la comision
	SET Var_ConceptoPago		:= 'DESEMBOLSO DE CREDITO';	 -- Concepto del pago SPEI
	SET Var_AreaBanco			:= 8;			-- Area emite banco SPEI
    SET Var_OrigenOperVent		:= 'V';			-- Origen operacion ventanilla
	SET Var_ActVerificSPEI		:= 11;			-- Actualizacion de verificacion de envio SPEI
	SET Est_Verif				:= 'V';			-- Estatus verificado SPEI ENVIO
	SET Est_Pend				:= 'P';			-- Estatus de pendiente en SPEI envio
	SET Act_EstatusDesemPen		:= 11;			-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
	SET Ope_Participante		:= 1;
	SET Inst_Credito			:= 6;
	SET RespaldaCredSI			:= 'S';
	SET Var_MontoCliente		:= 0.0;
	SET MultipleDisp 			:= (SELECT PermitirMultDisp FROM PARAMETROSSIS LIMIT 1);
	SET DispersionEfectivo		:= 'E';
	SET Var_LlaveCRW			:= 'ActivoModCrowd'; 	-- Filtro para variable de modulo crowdfunding
	SET Var_EjecucionNo			:= 'N';					-- Credito en ejecucion No
	SET OriPago_Reest			:= 'E';					-- Pago de Crédito por reestructura
	SET Con_TipoCarta			= 'I';
	SET Con_EstatusCarta		= 'A';
	SET Est_CueClabeAut			:= 'A';								-- EStatus de cuenta clabe Autorizada
	SET Est_CueClabeBaj			:= 'B';								-- EStatus de cuenta clabe Baja
	SET Est_CueClabeIna			:= 'I';								-- EStatus de cuenta clabe Inactiva
	SET Est_CueClabePen			:= 'P';								-- EStatus de cuenta clabe Pendiente de Autorizacion
	SET Est_DesCueClabeBaj		:= 'Baja';							-- Descripcion del Estatus de cuenta clabe Baja
	SET Est_DesCueClabeIna		:= 'Inactivo';						-- Descripcion del Estatus de cuenta clabe Inactiva
	SET Est_DesCueClabePen		:= 'Pendiente por autorizar';		-- Descripcion del Estatus de cuenta clabe Pendiente
	SET Est_Bloqueado           := 'B';
	SET EstLinea_Vencido        := 'E';



	SET Con_TipoPFisica		:= 'F';				-- Persona fisica
	SET Con_TipoPMoral		:= 'M';				-- Persona moral
	SET Con_ContratoPFisica := 'CPF';			-- Tipo de contrato persona fisica
	SET Con_ContratoPMoral	:= 'CPM';			-- tipo de contrato persona moral
	SET Var_EstNoEnviado		:= 'N';					-- Estatus N : No Enviado del flujo de instalacion de nomina

	SET Var_CtaReqCreAmbas		:= 'N';
	SET LlaveCtaCreDesembolso	:= 'ReqCtaParaCreditoDesembolso';

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  			'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREPRO');
			   SET Var_Control = 'SQLEXCEPTION';
			END;

		SET Var_CtaReqCreAmbas :=(SELECT IFNULL(ValorParametro, Cons_NO)
								FROM PARAMGENERALES
								WHERE LlaveParametro=LlaveCtaCreDesembolso);

		SET Var_FechaOper :=(SELECT FechaSucursal FROM SUCURSALES WHERE SucursalID=Aud_Sucursal);
		SET Con_Origen		:= OriPago_Reest;
		SET Var_ReqValidaCred := (SELECT ReqValidaCred FROM PARAMETROSSIS);

        SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
		SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);
		CALL DIASFESTIVOSCAL(
			Var_FechaOper,  Entero_Cero,        Var_FechaApl,       Var_EsHabil,    Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion);

		-- Inicializacion
		SET Cre_EsRestruct 	:= No_EsReestruc;
		SET Str_NumErr      := '0';
		SET Var_Poliza      := Entero_Cero;

		-- Se valida que el el numero de credito no venga nulo
        IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT  Cre.LineaCreditoID, 	Cre.ClienteID,          Cre.CuentaID,           Cre.MonedaID, 			Cre.Estatus,
				Cli.SucursalOrigen,     Cre.ProductoCreditoID,  Des.Clasificacion,  	Pro.ManejaLinea,    	Cre.MontoCredito,
				Cre.PagareImpreso,      Cre.FechaVencimien,     Cre.NumTransacSim,  	SolicitudCreditoID,     Cre.FechaInicio,
				Cre.FrecuenciaCap, 		TipoPagoCapital,    	Cta.MonedaID,           Cre.SolicitudCreditoID, Cli.NombreCompleto,
				Cli.RFC,            	Cli.RFCpm,              Cli.TipoPersona,        Cre.MontoComApert, 		Cre.IVAComApertura,
				Pro.ForCobroComAper,    Cre.DiaPagoCapital,     Cre.DiaMesCapital, 		Cre.FechaInhabil,   	AjusFecUlVenAmo,
				AjusFecExiVen,          Cre.Relacionado, 		EsReestructura,     	Cre.PeriodicidadCap,    Cre.MontoSeguroVida,
				Cre.ForCobroSegVida, 	Cli.PagaIVA,        	Des.SubClasifID,        Cli.TelefonoCelular,	Cre.FechaInicioAmor,
				Pro.EsquemaSeguroID,	Pro.RequiereAvales,		Cre.TipoCredito,		Cre.TipoLiquidacion,	Cre.CantidadPagar,
				Cre.FrecuenciaInt,		Cre.PeriodicidadInt,	Cre.FechaCobroComision,	Cre.InvCredAut,			Pro.ParticipaSpei,
				Pro.ProductoCLABE,		Pro.RequiereCheckList,	Cta.TipoCuentaID,		Pro.ReqInsDispersion,	Cre.ConvenioNominaID,
				Cre.EsConsolidado
		INTO
				lineaCredito,       	Var_ClienteID,      	Var_CuentaAhoID,    	Var_MonedaID, 			Var_EstatusCre,
				Var_SucCliente,     	Var_ProdCreID,      	Var_ClasifCre, 			ManjeaLinea,       	 	MontoCred,
				PagImpCred,         	FechVencCred, 			NTranSim,           	Var_SoliciCredID,   	Var_FecIniCred,
				Var_FrecuenCap, 		Var_TipPagCapita,   	Var_MonedaCta,      	Var_SolCredito,     	Var_NomCliente,
				VarRFCcte,				VarRFCPMcte,        	VarTipoPerson,      	Var_MontoComAp, 		Var_IVAComAp,
				Var_ForComApe,      	Var_DiaPagoCap,     	Var_DiaMesCap, 			Var_FechaInhabil,   	Var_AjFecUlVenAmo,
				Var_AjFecExiVen,    	Var_Relacionado, 		Var_EsReestructura, 	Var_PeriodCap,      	Var_MontoSegVida,
				Var_ForCobSegVida, 		Var_PagIVA,         	Var_SubClasifID,    	Var_TelefonoCel,		Var_FechaInicioAmor,
				Var_EsqSeguroID,		Var_RequiereAvales,		Var_TipoCredito,		Var_TipoLiquidacion,	Var_CantidadPagar,
				Var_FrecInteres,		Var_PeriodInt,			Var_FechaCobroCom,		Var_InversionID,		Var_ParticipaSpei,
				Var_ProductoCLABE,		Var_RequiereCheckList,	Var_TipoCuentaID,		Var_ReqInsDispersion,	Var_ConvenioNominaID,
				Var_EsConsolidado
		FROM CREDITOS Cre,
				CLIENTES Cli,
				PRODUCTOSCREDITO Pro,
				CUENTASAHO Cta,
				DESTINOSCREDITO Des
		WHERE CreditoID 			= Par_CreditoID
		  AND Cre.ClienteID			= Cli.ClienteID
		  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
		  AND Cta.ClienteID			= Cre.ClienteID
		  AND Cta.CuentaAhoID		= Cre.CuentaID
		  AND Cre.DestinoCreID      = Des.DestinoCreID;

		SELECT  Cre.ConvenioNominaID
		INTO	Var_ConvNomID
		FROM CREDITOS Cre,
				CLIENTES Cli,
				PRODUCTOSCREDITO Pro,
				CUENTASAHO Cta,
				DESTINOSCREDITO Des
		WHERE CreditoID 			= Par_CreditoID
		  AND Cre.ClienteID			= Cli.ClienteID
		  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
		  AND Cta.ClienteID			= Cre.ClienteID
		  AND Cta.CuentaAhoID		= Cre.CuentaID
		  AND Cre.DestinoCreID      = Des.DestinoCreID;

		SET Var_RequiereAvales	:= IFNULL(Var_RequiereAvales, Cadena_Vacia);
		SET Var_MontoComAp      := IFNULL(Var_MontoComAp, Entero_Cero);
		SET Var_IVAComAp        := IFNULL(Var_IVAComAp, Entero_Cero);
		SET Var_MontoSegVida    := IFNULL(Var_MontoSegVida, Entero_Cero);
		SET Var_ForCobSegVida   := IFNULL(Var_ForCobSegVida, Cadena_Vacia);
		SET Var_PagIVA          := IFNULL(Var_PagIVA, Cadena_Vacia);
		SET Var_SubClasifID     := IFNULL(Var_SubClasifID, Entero_Cero);
		SET Var_EsqSeguroID		:= IFNULL(Var_EsqSeguroID, Entero_Cero);
		SET Var_TipoCuentaID	:= IFNULL(Var_TipoCuentaID, Entero_Cero);
		SET Var_ConvenioNominaID:= IFNULL(Var_ConvenioNominaID, Entero_Cero);
		SET Var_ConvNomID		:= IFNULL(Var_ConvNomID, Entero_Cero);
		SET lineaCredito		:= IFNULL(lineaCredito, Entero_Cero);
		SET ManjeaLinea 		:= IFNULL(ManjeaLinea, Cons_NO);

		SELECT RequiereGarFOGAFI,	ModalidadFOGAFI INTO Var_RequiereGarFOGAFI, Var_ModalidadFOGAFI
        FROM DETALLEGARLIQUIDA
		WHERE CreditoID = Par_CreditoID;
		SET Var_RequiereGarFOGAFI := IFNULL(Var_RequiereGarFOGAFI, Cons_NO);
		SET Var_ModalidadFOGAFI   := IFNULL(Var_ModalidadFOGAFI, Cons_NO);

		SELECT EsquemaSeguroID, 	ProducCreditoID, 	TipoPagoSeguro,		FactorRiesgoSeguro,		DescuentoSeguro,
			   MontoPolSegVida
		INTO  Var_EsquemaSeguro,	Var_ProdCredID, 	Var_TipPagSegu, 	Var_FactRiSeg, 			Var_DescSegu,
			  Var_MontoPolSeg
			FROM  	ESQUEMASEGUROVIDA
			WHERE 	ProducCreditoID = Var_ProdCreID
			AND 	TipoPagoSeguro 	= Var_ForCobSegVida;

		SET Var_EsquemaSeguro := IFNULL(Var_EsquemaSeguro, Entero_Cero);

        SELECT SUM(MontoCuota), SUM(MontoIVACuota) INTO Var_MontoCuotaAc, MontoIVACuotaAc
		FROM DETALLEACCESORIOS
		WHERE CreditoID = Par_CreditoID
		AND TipoFormaCobro = ForCobroDeduccion;

        SET Var_MontoCuotaAc 	:= IFNULL(Var_MontoCuotaAc, Decimal_Cero);
        SET MontoIVACuotaAc 	:= IFNULL(MontoIVACuotaAc, Decimal_Cero);

		SELECT	FechaSistema,			ManejaCaptacion, 	PagoIntVertical
			INTO	FechSistema,		Var_ManCapta, 		Var_PagaInteres
			FROM 	PARAMETROSSIS
			WHERE 	EmpresaID = Par_EmpresaID;

		SELECT 	MAX(FechaVencim),	MIN(FechaInicio), 	COUNT(*)
			INTO  	FechUltiAmort,	FechPrimAmort,		Var_NumAmorti
			FROM 	AMORTICREDITO
			WHERE 	CreditoID	= Par_CreditoID
			GROUP BY CreditoID;

		SELECT TipoDispersion,  	CuentaCLABE,			Clabe
			INTO Var_TipoDisper,	VarCuentaCLABE,			Var_Clabe
			FROM 	CREDITOS
			WHERE 	CreditoID	= Par_CreditoID;

		IF(Var_FrecuenCap = Cons_FrecUnico OR Var_FrecuenCap = Cons_FrecLibre OR Var_FrecuenCap = Cons_Periodo) THEN
			UPDATE CREDITOS
				SET FechaCobroComision = FechSistema
                WHERE CreditoID = Par_CreditoID;
        END IF;

        SELECT 		Par.Clabe,				Par.Habilitado,			Inst.NombreCorto,				Inst.RFC,					Par.ParticipanteSpei,
					Par.Prioridad,			Par.TipoOperacion,		Par.MonReqAutTeso
			INTO 	Var_ClabeOrdenante,		Var_SPEIHabilitado,		Var_NombreOrdenante,			Var_RFCOrdenante,			Var_InstiRemi,
					Var_PrioEnvio,			Var_TipoConexion,		Var_montoReqAuTesor
			FROM PARAMETROSSPEI Par
			LEFT JOIN INSTITUCIONES Inst ON Par.ParticipanteSpei = Inst.ClaveParticipaSpei
			LIMIT 1;

		SET Var_ClabeOrdenante	:=  IFNULL(Var_ClabeOrdenante, Cadena_Vacia);
		SET Var_SPEIHabilitado := IFNULL(Var_SPEIHabilitado, SalidaNo);
		SET Var_NombreOrdenante := IFNULL(Var_NombreOrdenante, Cadena_Vacia);
		SET Var_RFCOrdenante := IFNULL(Var_RFCOrdenante, Cadena_Vacia);
		SET Var_InstiRemi	:= IFNULL(Var_InstiRemi, Entero_Cero);
		SET Var_PrioEnvio	:= IFNULL(Var_PrioEnvio, Entero_Cero);
		SET Var_TipoConexion	:= IFNULL(Var_TipoConexion, Cadena_Vacia);
		SET Var_montoReqAuTesor	:=IFNULL(Var_montoReqAuTesor,Entero_Cero);

		IF (Var_ConvenioNominaID <> Entero_Cero) THEN

			SELECT		ManejaCalendario,		ManejaFechaIniCal
				INTO	Var_ManejaCalendario,	Var_ManejaFechaIniCal
				FROM	CONVENIOSNOMINA
				WHERE	ConvenioNominaID = Var_ConvenioNominaID;

		END IF;

		SET Var_ManejaCalendario	:= IFNULL(Var_ManejaCalendario, Cons_NO);
		SET Var_ManejaFechaIniCal	:= IFNULL(Var_ManejaFechaIniCal, Cons_NO);

		SET Var_ManejaConvenio		:= FNPARAMGENERALES('ManejaCovenioNomina');
		SET Var_ManejaConvenio		:= IFNULL(Var_ManejaConvenio, Cons_NO);

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_ClienteID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El cliente no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'La Cuenta no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'La Moneda no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_EstatusCre, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'El Credito No Existe o No esta Autorizado.';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_ReqValidaCred = 'N')THEN
			IF(Var_EstatusCre != Estatus_Activo) THEN
				SET Par_NumErr	:= 6;
				SET Par_ErrMen	:= 'El Credito No Existe o No esta Autorizado.';
				LEAVE ManejoErrores;
			END IF;
        ELSE
            IF(Var_EstatusCre != Estatus_Procesado) THEN
				SET Par_NumErr	:= 6;
				SET Par_ErrMen	:= 'El Credito No Existe o No esta Procesado.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_MonedaCta <> Var_MonedaID )THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'La Moneda de la Cuenta es Diferente de la Moneda del Credito.';
			LEAVE ManejoErrores;
		END IF;

		IF(PagImpCred != PagareImp)THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'El Pagare No ha Sido Impreso.';
			LEAVE ManejoErrores;
		END IF;

		IF DATEDIFF(FechVencCred,FechUltiAmort)  <Entero_Cero THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'La Fecha de la Ultima Amortizacion no esta Dentro de la Vigencia del Credito.';
			LEAVE ManejoErrores;
		END IF;
		IF(FechPrimAmort < FechSistema)THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= 'La Fecha de la Primera Amortizacion No Debe Ser Menor a la Fecha del Sistema.';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_ManejaConvenio = Var_SI AND Var_ManejaCalendario = Var_SI) THEN

			IF ((Var_ManejaFechaIniCal <> Var_SI AND FechSistema != Var_FecIniCred) OR (FechSistema > Var_FecIniCred)) THEN
				SET Par_NumErr	:= 11;
				SET Par_ErrMen	:= 'La Fecha del Sistema es Diferente a la de Inicio del Credito. Genere de Nuevo el Pagare.';
				LEAVE ManejoErrores;
			END IF;

		ELSE

			IF(FechSistema != Var_FecIniCred)THEN
				SET Par_NumErr	:= 11;
				SET Par_ErrMen	:= 'La Fecha del Sistema es Diferente a la de Inicio del Credito. Genere de Nuevo el Pagare.';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Var_RequiereAvales = Cadena_Vacia) THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= 'El Producto de Credito, No especifica si Requiere Avales.';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_FechaCobroCom < FechSistema)THEN
			SET Par_NumErr	:= 13;
			SET Par_ErrMen	:= 'La Fecha del Sistema es Diferente a la de Inicio del Credito. Genere de Nuevo el Pagare.';
			LEAVE ManejoErrores;
		END IF;

		# ============================================ VALIDACIONES PARA LINEA DE CREDITO =================================================
		IF(ManjeaLinea = SiManejaLinea)THEN

			SELECT	LineaCreditoID,		MonedaID,	FechaVencimiento,	SaldoDisponible,Dispuesto,	Estatus,
					NumeroCreditos,		SucursalID, Estatus
			INTO    Var_LineaCredito, 	MonedaLinea,	FechVencLinea,	SaldoDisp,	Var_Dispuesto,	EstatusLinea,
					NumCredit,			VarSucursalLin,  Var_EstatusLinea
				FROM  LINEASCREDITO
				WHERE LineaCreditoID = lineaCredito;

			IF( IFNULL(Var_LineaCredito, Entero_Cero) != Entero_Cero ) THEN

	    	    IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
					SET Par_NumErr	:= 310;
					SET Par_ErrMen	:= 'La Linea de Credito se encuentra Bloqueada/Vencida.';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(MonedaLinea, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr	:= 20;
					SET Par_ErrMen	:= 'La Moneda de la Linea No Existe.';
					LEAVE ManejoErrores;
				END IF;

				IF( lineaCredito = Entero_Cero ) THEN

					IF(SaldoDisp < MontoCred OR EstatusLinea != Estatus_Activo ) THEN
						SET Par_NumErr	:= 21;
						SET Par_ErrMen	:= 'La Linea No esta Activa o No tiene Saldo Disponible.';
						LEAVE ManejoErrores;
					END IF;

				END IF;

				IF DATEDIFF(FechVencLinea, FechVencCred)  < Entero_Cero THEN
					SET Par_NumErr	:= 22;
					SET Par_ErrMen	:= 'El Credito No esta Dentro de la Vigencia de la Linea.';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_MonedaID != MonedaLinea) THEN
					SET Par_NumErr	:= 23;
					SET Par_ErrMen	:= 'La Moneda del Credito No Coincide con la de la Linea.';
					LEAVE ManejoErrores;
				END IF;

				IF(MontoCred >SaldoDisp ) THEN
					SET Par_NumErr	:= 24;
					SET Par_ErrMen	:= CONCAT('El Monto debe de ser Menor o Igual al Monto Disponible de la Linea de Credito: ',lineaCredito);
					LEAVE ManejoErrores;
				END IF;

				UPDATE LINEASCREDITO SET
					Dispuesto 			= IFNULL(Dispuesto,Entero_Cero) + MontoCred,
					SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) - MontoCred,
					SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) + MontoCred,
					NumeroCreditos		= NumeroCreditos + 1,
					UltFechaDisposicion = FechSistema,
					UltMontoDisposicion = MontoCred,

					Usuario				= Aud_Usuario,
					FechaActual 		= Aud_FechaActual,
					DireccionIP 		= Aud_DireccionIP,
					ProgramaID  		= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE LineaCreditoID	= lineaCredito;

					/* se manda a llamar a sp que genera los detalles contables de lineas de credito .*/
				CALL CONTALINEACREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					lineaCredito,		Entero_Cero,			FechSistema,		FechSistema,		MontoCred,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,		Var_Descripcion,	lineaCredito,
					AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,		AltaMovCre_NO,		ConcepCtaOrdenDeu,
					Cadena_Vacia,		Nat_Abono,				Nat_Abono,			Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CONTALINEACREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					lineaCredito,		Entero_Cero,			FechSistema,		FechSistema,		MontoCred,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,		Var_Descripcion,	lineaCredito,
					AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,		AltaMovCre_NO,		ConcepCtaOrdenCor,
					Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

		END IF;  -- EndIf de la Linea de Credito

		# ============================================== VALIDACIONES PARA AVALES ===================================================
  		IF(Var_SolCredito > Entero_Cero AND (Var_RequiereAvales = RequiereAvales_SI OR Var_RequiereAvales = RequiereAvales_IN)) THEN

			-- LIMPIAR REGISTROS DE LA TABLA
	        DELETE FROM TMPAVALESVALIDA WHERE NumeroTransaccion=Aud_NumTransaccion;

	        -- INSERTAR REGISTROS NUEVOS EN TABLA DE PASO
	        INSERT INTO TMPAVALESVALIDA (AvalID, ClienteID,   ProspectoID,    CantidadAvales,  IntercambiaAvales,
	                                ProducCreditoID, ClienteCre, NumCreditosAvalados, NumeroTransaccion)
	        SELECT Sol.AvalID, Sol.ClienteID, Sol.ProspectoID, Entero_Cero, Cadena_Vacia,
	                Cre.ProductoCreditoID, Cre.ClienteID,
	                CASE
	                    WHEN Sol.AvalID > Entero_Cero
	                        THEN FNNUMCREDITOSAVALADOS(Sol.AvalID , Con_AvalID)
	                    WHEN Sol.ClienteID > Entero_Cero
	                        THEN FNNUMCREDITOSAVALADOS(Sol.ClienteID , Con_ClienteID)
	                    WHEN Sol.ProspectoID > Entero_Cero
	                        THEN FNNUMCREDITOSAVALADOS(Sol.ProspectoID , Con_ProspectoID)
	                    END AS NumCreditosAvalados , Aud_NumTransaccion
	        FROM AVALESPORSOLICI Sol
	        INNER JOIN CREDITOS Cre
	        ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID AND Sol.Estatus = EstatusAvalesSol
	        WHERE Cre.CreditoID = Par_CreditoID;

	        UPDATE TMPAVALESVALIDA Tmp
	        INNER JOIN PRODUCTOSCREDITO Pro
	        ON  Tmp.ProducCreditoID = Pro.ProducCreditoID
	        SET Tmp.CantidadAvales	 = Pro.CantidadAvales,
	            Tmp.IntercambiaAvales = Pro.IntercambiaAvales;

	        -- Verificar que el Aval No Supere los Creditos Avalados
	        SELECT COUNT(NumeroTransaccion)
	        INTO Var_AvalesRechazados
	        FROM TMPAVALESVALIDA
	        WHERE CantidadAvales < NumCreditosAvalados
	        AND NumeroTransaccion=Aud_NumTransaccion ;

	        IF(Var_AvalesRechazados > Entero_Cero)THEN
	            SET Par_NumErr  := 30;
	            SET Par_ErrMen  := 'El(los) Aval(es) No Cumplen las Condiciones del Producto de Credito.';
	            LEAVE ManejoErrores;
	        END IF;

	        --  Validad Intercambio Avales
	        SELECT COUNT(Tmp.NumeroTransaccion)
	        	INTO Var_IntercamAvales
		        FROM TMPAVALESVALIDA Tmp
			        INNER JOIN SOLICITUDCREDITO Sol
			        ON Tmp.ClienteID = Sol.ClienteID AND Sol.Estatus = EstatusDesembolsada
	        		INNER JOIN AVALESPORSOLICI Ava
	        		ON Sol.SolicitudCreditoID =  Ava.SolicitudCreditoID AND Ava.ClienteID = Tmp.ClienteCre,
					CREDITOS Cre
                 WHERE Tmp.ClienteID = Sol.ClienteID  AND Tmp.IntercambiaAvales = IntercamAvales_NO
					AND Cre.CreditoID= Sol.CreditoID AND Cre.Estatus <>EstatusPagado
					AND Tmp.NumeroTransaccion=Aud_NumTransaccion;

			IF(Var_IntercamAvales > Entero_Cero)THEN
				SET Par_NumErr	:= 31;
				SET Par_ErrMen	:= 'El Producto de Credito No Permite Intercambio Avales.';
				LEAVE ManejoErrores;
			END IF;

	        -- QUITAR REGISTROS INSERTADOS
	        DELETE FROM TMPAVALESVALIDA WHERE NumeroTransaccion=Aud_NumTransaccion;

		END IF;-- Fin de validacion para avales

		-- Identificamos el Monto a Desembolsar
		IF(Var_ForComApe = ForCobroApDeduc OR Var_ForComApe = ForCobroApFinanc) THEN
			SET Var_MontoADesem := MontoCred - (Var_MontoComAp + Var_IVAComAp );
		ELSE
			SET Var_MontoADesem := MontoCred;
			SET Var_MontoComAp  := Entero_Cero;
			SET Var_IVAComAp    := Entero_Cero;
		END IF;

		-- Restamos del Monto a Desembolsar el Monto del Seguro de Vida, Si este fue Financiado o por Deduccion
		IF(Var_EsqSeguroID = Entero_Cero)THEN
			IF(Var_ForCobSegVida = ForCobroApDeduc OR Var_ForCobSegVida = ForCobroApFinanc) THEN
				SET Var_MontoADesem := Var_MontoADesem - Var_MontoSegVida;
			ELSE
				SET Var_MontoSegVida := Entero_Cero;
			END IF;

		ELSE

			IF(Var_TipPagSegu = ForCobroApDeduc OR Var_TipPagSegu = ForCobroApFinanc) THEN
				SET Var_MontoADesem := Var_MontoADesem - Var_MontoSegVida;
			ELSE
				SET Var_MontoSegVida := Entero_Cero;
			END IF;
		END IF;

		SET Var_Relacionado := IFNULL(Var_Relacionado, Entero_Cero);

        -- SE MARCAN COMO PAGADAS LAS CUOTAS DE LA TABLA REAL
        -- SI ES REESTRUCTURA O RENOVACION
        IF(Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura )THEN
            IF EXISTS (SELECT * FROM AMORTCRENOMINAREAL WHERE CreditoID = Var_Relacionado)THEN
                UPDATE AMORTCRENOMINAREAL
                    SET Estatus = EstatusPagado,
                        NumTransaccion  = Aud_NumTransaccion
                WHERE CreditoID = Var_Relacionado
                AND Estatus <> EstatusPagado;
            END IF;
        END IF;

		# ===================================================================================================================
		# =================================== CONSIDERACIONES PARA DESEMBOLSO DE CREDITO RENOVACION =========================
		IF(Var_TipoCredito = CreRenovacion AND Var_Relacionado != Entero_Cero) THEN
			SELECT  ( DATEDIFF(FechSistema,IFNULL(MIN(FechaExigible), FechSistema)))
			INTO  Res_NumDiasAtraOri
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_Relacionado
			  AND Amo.Estatus != EstatusPagado
			  AND Amo.FechaExigible <= FechSistema;

			-- Consultamos el Credito Origen a Renovar (Datos del Credito Original)
			SELECT  FUNCIONTOTDEUDACRE(Cre.CreditoID),
					FUNCIONEXIGIBLE(Cre.CreditoID),
					Cre.Estatus, Cre.PeriodicidadCap,
					ROUND(IFNULL(SaldoIntNoConta, Entero_Cero), 2)
			INTO    Res_SaldoCredAnteri,    Res_SaldoExigi, Res_EstatusCredAnt, Res_PeriodCap,  Var_SalInteres
			FROM CREDITOS Cre
			WHERE Cre.CreditoID = Var_Relacionado;

			SET Res_SaldoCredAnteri := IFNULL(Res_SaldoCredAnteri, Entero_Cero);
			SET Res_SaldoExigi      := IFNULL(Res_SaldoExigi, Entero_Cero);
			SET Res_EstatusCredAnt  := IFNULL(Res_EstatusCredAnt, Cadena_Vacia);
			SET Res_NumDiasAtraOri  := IFNULL(Res_NumDiasAtraOri, Entero_Cero);
			SET Res_PeriodCap       := IFNULL(Res_PeriodCap, Entero_Cero);
			SET Var_SalInteres      := IFNULL(Var_SalInteres, Entero_Cero);

			SELECT  IFNULL(SUM(SaldoCapVigente),Entero_Cero) +
					IFNULL(SUM(SaldoCapAtrasa),Entero_Cero) +
					IFNULL(SUM(SaldoCapVencido),Entero_Cero) +
					IFNULL(SUM(SaldoCapVenNExi),Entero_Cero)
			INTO Var_SaldoCapital
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_Relacionado
			AND Amo.Estatus <> EstatusPagado;

			SELECT FNTOTALINTERESCREDITO(Var_Relacionado) INTO Var_TotalInteres;

			IF (Res_SaldoCredAnteri <= Entero_Cero) THEN
				SET Par_NumErr	:= 200;
				SET Par_ErrMen	:= 'El Credito a Renovar no Presenta Adeudos.';
				LEAVE ManejoErrores;
			END IF;

			-- Se obtiene el valor de PagoIntVertical de los aprametros generales apra saber si se cobrará el interes exigible
			SELECT  PagoIntVertical INTO Var_LiquidaInteres FROM PARAMETROSSIS;

			-- Validar que cubre el Saldo adeudado
            IF (Var_TipoLiquidacion = LiquidacionTotal AND Var_LiquidaInteres=Var_SI) THEN
				IF (MontoCred < Res_SaldoCredAnteri ) THEN
					SET Par_NumErr	:= 201;
					SET Par_ErrMen	:= 'El Monto del Credito debe Cubrir el Saldo del Credito a Renovar. ';
					LEAVE ManejoErrores;
				END IF;
            END IF;

            IF(Var_EsReestructura = No_EsReestruc) THEN
				SET Par_NumErr	:= 202;
				SET Par_ErrMen	:= 'El Producto de Credito No Permite Renovaciones.';
				LEAVE ManejoErrores;
			END IF;

			IF(Res_EstatusCredAnt != EstatusVigente AND Res_EstatusCredAnt != EstatusVencido) THEN
				SET Par_NumErr	:= 203;
				SET Par_ErrMen	:= 'El Credito a Renovar debe estar Vigente o Vencido.';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_PagaInteres = Var_SI) THEN
				IF(IFNULL(Var_TotalInteres, Entero_Cero) > Entero_Cero) THEN
					SET Par_NumErr	:= 205;
					SET Par_ErrMen	:= 'El Credito a Renovar Tiene Adeudo de Intereses.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			/***** VALIDACION PARA ASIGNAR EL ESTATUS AL CREDITO REESTRUCTURADO *****/

			-- Calculo de las Condiciones para el Credito Reestructura

           CALL ESTATUSCREDITOACT(
				Var_Relacionado,	Res_EstatusCredAnt,	Res_EstatusCrea,	SalidaNo,					Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- Revision del Numero de Pagos Sostenidos para ser Regularizado
			# Se valida si el Tipo Frecuencia es diferente de Unica y Libre
			IF(Var_FrecuenCap != FrecUnico) THEN
				# Si la periodicidad del Capital es mayor a 60 dias el numero de pagos sostenidos sera 1
				IF(Var_PeriodCap >60) THEN
					SET Res_NumPagoSos  := 1;
				ELSE
                 -- Res_PeriodCap: Periodicidad de Capital del Credito Anterior
                 -- Var_PeriodCap: Periodicidad de Capital del Credito Nuevo
					IF(Var_FrecuenCap != FrecLibre) THEN
						SET Res_NumPagoSos  := CEILING((Res_PeriodCap/Var_PeriodCap) * Num_PagRegula);
					ELSE
						SET Res_NumPagoSos  := Num_PagRegula;
                    END IF;

				END IF;
			ELSE
				IF(Var_FrecuenCap = FrecUnico AND  Var_FrecInteres = FrecUnico) THEN
					SET Res_NumPagoSos  = 1;
				ELSE
                -- Var_PeriodInt: Periodicidad de Interes: Credito Nuevo
                    IF(Var_FrecInteres != Cons_Periodo) THEN
						SET Res_NumPagoSos  = CEILING((90/Var_PeriodInt));
					ELSE
						SET Res_NumPagoSos  = 1;
					END IF;
				END IF;
			END IF;


			CALL REESTRUCCREDITOACT (
				FechSistema,        Par_CreditoID,      Res_SaldoCredAnteri,    Res_EstatusCredAnt, Res_EstatusCrea,
				Res_NumDiasAtraOri, Res_NumPagoSos,     Entero_Cero,            Entero_Cero,        Act_Desembolso,
				SalidaNo,           Par_NumErr,         Par_ErrMen,             Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario, 		Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion  );

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Actualizamos la Estimacion por los Intereses a Capitalizar
			UPDATE REESTRUCCREDITO SET
				ReservaInteres  = Var_SalInteres,
				SaldoInteres    = Var_SalInteres
			WHERE CreditoDestinoID    = Par_CreditoID;

			IF(Var_SalInteres > Entero_Cero) THEN

				-- >> TICKET 14291
	       		SET Var_FechaReservas := (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= FechSistema);
	        	SET Var_FechaReservas := IFNULL(Var_FechaReservas,Fecha_Vacia);
	        	UPDATE CALRESCREDITOS SET
	          		SaldoResCapital  = SaldoResCapital + Var_SalInteres
	        	WHERE CreditoID    = Var_Relacionado
	        	AND Fecha = Var_FechaReservas;
        		-- << FIN TICKET 14291

				-- Abono Estimacion Balance
				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_SalInteres,     Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Des_Reserva,        Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalance,
					Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Nat_Abono,
					Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				-- Cargo Estimacion Resultados (Gasto)
				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_SalInteres,     Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Des_Reserva,        Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstResultados,
					Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Nat_Cargo,
					Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF; -- END de la Renovacion de credito

		-- Damos de alta el credito consolidado en la tabla de consolidaciones
		IF( Var_EsConsolidado = Var_SI ) THEN

			-- Store Procedure Para consolidar un credito y actulizar el estatus con el que nace el credito
			CALL CONSOLIDACIONCARTALIQPRO (
				Par_CreditoID,		Par_PolizaID,
				SalidaNo, 			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT 	EstatusCreacion
			INTO 	Var_EstConsolidacion
			FROM 	CONSOLIDACIONCARTALIQ
			WHERE 	CreditoID	= Par_CreditoID;

			SET Res_EstatusCrea := IFNULL(Var_EstConsolidacion, EstatusVigente);
			SET Var_EstatusCre 	:= IFNULL(Var_EstConsolidacion, EstatusVigente);

		END IF;

		SET Aud_FechaActual := NOW();

		-- Actualizamos el Credito
		IF ((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura) AND  Res_EstatusCrea = EstatusVencido) THEN

			UPDATE CREDITOS SET
				Estatus         	= EstatusVencido,
				NumAmortizacion 	= Var_NumAmorti,
				FechaMinistrado 	= FechSistema,
				MontoPorDesemb  	= Var_MontoADesem,
				ComAperPagado   	= ComAperPagado +  Var_MontoComAp,
				SeguroVidaPagado 	= SeguroVidaPagado + Var_MontoSegVida,

				Usuario         	= Aud_Usuario,
				FechaActual     	= Aud_FechaActual,
				DireccionIP     	= Aud_DireccionIP,
				ProgramaID      	= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal,
				NumTransaccion  	= Aud_NumTransaccion

			WHERE CreditoID	= Par_CreditoID;
		ELSE
			UPDATE CREDITOS SET
				Estatus 			= CASE WHEN Var_EsConsolidado = Var_SI THEN Var_EstConsolidacion
										   ELSE EstatusVigente
									  END,
				NumAmortizacion		= Var_NumAmorti,
				FechaMinistrado		= FechSistema,
				MontoPorDesemb		= Var_MontoADesem,
				ComAperPagado		= ComAperPagado +  Var_MontoComAp,
				SeguroVidaPagado	= SeguroVidaPagado + Var_MontoSegVida,

				Usuario				= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID  		= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE CreditoID	= Par_CreditoID;

		END IF;


		-- Actualizamos las Amortizaciones
		UPDATE AMORTICREDITO SET
			Estatus 			= EstatusVigente,

			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE CreditoID	= Par_CreditoID;

		SET Var_CuentaAhoStr := CONVERT(Var_CuentaAhoID, CHAR);

		-- Si la Institucion Maneja el Concepto de Cuentas de Ahorro
		IF(Var_ManCapta = ManCaptacionSi) THEN
			-- Verificamos si el credito es Reestructura o Renovacion y  nace como Vencido
			IF ((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura OR Var_EsConsolidado = Var_SI) AND Res_EstatusCrea = EstatusVencido) THEN
				SET Tipo_MovConta   := Con_ContCapVNE;
			ELSE
				SET Tipo_MovConta   := Con_ContCapCre;
			END IF;

			/* Movimientos del Desembolso del credito*/
			SET Var_Descripcion     	:= 'DESEMBOLSO DE CREDITO';
			-- Movimientos del Desembolso del credito
			CALL  CONTACREDITOPRO (
				Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
				Var_FechaApl,       MontoCred,          Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,		Var_Descripcion,    Var_CuentaAhoStr,   AltaPoliza_NO,
				Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Tipo_MovConta,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      Tip_MovAhoDesem,	Nat_Abono,
				Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Movimientos de Comision por Apertura
			IF(Var_MontoComAp != Entero_Cero) THEN

				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
                    Var_FechaApl,       Var_MontoComAp,     Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
                    Var_SubClasifID,    Var_SucCliente,		Var_DescComAper,    Var_CuentaAhoStr,	AltaPoliza_NO,
                    Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_ContGastos,
					Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      Tip_MovAhoComAp,	Nat_Cargo,
                    Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
                    Par_EmpresaID,		Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			IF(Var_PagIVA = SiPagaIVA) THEN

				IF(Var_IVAComAp != Entero_Cero) THEN
					-- movimientos de IVA  de comision por apertura
					CALL  CONTACREDITOPRO (
						Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
						Var_FechaApl,       Var_IVAComAp,       Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Var_DcIVAComApe,    Var_CuentaAhoStr,   AltaPoliza_NO,
						Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_ContIVACApe,
						Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      Tip_MovIVAAhCAp,	Nat_Cargo,
						Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

					SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;
			END IF; -- EndIf del Manejo de IVA

			-- Contabilidad y Movimientos del Cobro del Seguro de Vida
			IF(Var_MontoSegVida != Entero_Cero) THEN

				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_MontoSegVida,   Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Var_DescSegVida,    Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_PagoSegVida,
					Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      Tip_MovAhoSegVid,	Nat_Cargo,
					Cadena_Vacia,		/*Cons_NO,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- Actualizamos el Seguro de Vida como Pagado
				CALL  SEGUROVIDAACT (
					Entero_Cero,        Par_CreditoID,  Var_CuentaAhoID,    Act_SegVigente, 	SalidaNo,
					Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,    	Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

            -- ==================== Inicio Cobro Comisión Anual Linea de Crédito ====================
			SELECT 	CobraComAnual,		TipoComAnual,		ValorComAnual,		ComisionCobrada,		Autorizado,
					SaldoComAnual
				INTO Var_CobraComAnual,	Var_TipoComAnual,	Var_ValorComAnual,	Var_ComisionCobrada,	Var_SaldoLinea,
					Var_SaldoComAnual
			FROM LINEASCREDITO
			WHERE LineaCreditoID = lineaCredito;

			IF(ManjeaLinea = SiManejaLinea AND Var_CobraComAnual=Var_SI AND Var_ComisionCobrada=Cons_NO)THEN

				SET Var_MontoComAnual := Var_SaldoComAnual;

				SET ConstDescipLinea := CONCAT('CARGO POR ANUALIDAD DE LA LINEA No.',lineaCredito);

				-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
				CALL CONTALINEACREPRO(
					lineaCredito,		Entero_Cero,			FechSistema,		FechSistema,		Var_MontoComAnual,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,		ConstDescipLinea,	lineaCredito,
					AltaPoliza_NO,		Entero_Cero,			AltaPolCre_SI,		AltaMovAho_SI,		Con_ContComAnual,
					TipoMovAhoComAnual,	Nat_Abono,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF(Var_PagIVA = SiPagaIVA) THEN

					SELECT IVA INTO Var_IVA
					FROM SUCURSALES
					WHERE SucursalID = Var_SucCliente;
					SET Var_IVA := IFNULL(Var_IVA,Decimal_Cero);

					SET Var_MontoIVAComAnual := (Var_MontoComAnual * Var_IVA);
					SET ConstDescipLinea := CONCAT('CARGO IVA POR ANUALIDAD DE LA LINEA No.',lineaCredito);
					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE IVA DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
					CALL CONTALINEACREPRO(
						lineaCredito,			Entero_Cero,			FechSistema,		FechSistema,		Var_MontoIVAComAnual,
						Var_MonedaID,			Var_ProdCreID,			VarSucursalLin,		ConstDescipLinea,	lineaCredito,
						AltaPoliza_NO,			Entero_Cero,			AltaPolCre_SI,		AltaMovAho_SI,		Con_ContIVAComAnual,
						TipoMovAhoIVAComAnual,	Nat_Abono,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
                        Par_PolizaID,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                        Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

                UPDATE LINEASCREDITO SET
					ComisionCobrada = 'S',
                    SaldoComAnual = SaldoComAnual - Var_MontoComAnual
				WHERE LineaCreditoID = lineaCredito;

			END IF;
			-- ==================== FIN Cobro Comisión Anual Linea de Crédito ====================

            # Se eliminan registros de la tabla Temporal
            DELETE FROM TMPACCESORIOSPROD
            WHERE CreditoID = Par_CreditoID;


            # Se eliminan registros por si existio un respaldo anteriormente
            DELETE FROM RESDETACCESORIOS
            WHERE CreditoID  = Par_CreditoID;


            -- ==================== COBRO DE ACCESORIOS ==============================
            SET @Cont := 0;
			# SE LLENA LA  TABLA CON LOS ACCESORIOS QUE COBRA EL CREDITO
			INSERT INTO TMPACCESORIOSPROD(
						Consecutivo,			CreditoID,					AccesorioID,			MontoCuota,			MontoIVACuota,
                        Prelacion,				Abreviatura,				CobraIVA,				ConceptoCartera,	EmpresaID,
                        Usuario,				FechaActual,				DireccionIP,			ProgramaID,         Sucursal,
                        NumTransaccion)
			 SELECT  	(@Cont:=@Cont+1) AS Consecutivo,MAX(D.CreditoID),	MAX(D.AccesorioID),		MAX(MontoCuota),		MAX(MontoIVACuota),
						MAX(A.Prelacion),		MAX(A.NombreCorto),			MAX(D.CobraIVA),		MAX(C.ConceptoCarID),	Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,       		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                        Aud_NumTransaccion
				FROM	DETALLEACCESORIOS D
				INNER JOIN ACCESORIOSCRED A
				ON D.AccesorioID = A.AccesorioID
				INNER JOIN CONCEPTOSCARTERA C
				ON A.NombreCorto = C.Descripcion
				WHERE D.CreditoID = Par_CreditoID
				AND TipoFormaCobro = ForCobroDeduccion
				GROUP BY D.AccesorioID
				ORDER BY A.Prelacion ASC;



			# SE OBTIENE EL NUMERO DE ACCESORIOS COBRADOS POR EL CREDITO
			SET Var_NumRegistros := (SELECT COUNT(*) FROM TMPACCESORIOSPROD WHERE CreditoID = Par_CreditoID AND MontoCuota > Decimal_Cero);
            SET Var_TotalAccesorios 	:= Decimal_Cero;
            SET Var_TotalIVAAccesorio	:= Decimal_Cero;

			SET Contador := 1;

			# INICIA CICLO PARA EL COBRO DE ACCESORIOS
		   CICLO: WHILE(Contador <= Var_NumRegistros) DO

				# SE OBTIENEN LOS DATOS NECESARIOS PARA LA APLICACION DEL PAGO
				SELECT AccesorioID, 	MontoCuota,		MontoIVACuota, 		Abreviatura,		CobraIVA,		ConceptoCartera
				INTO Var_AccesorioID,	Var_MontoCuota,	Var_MontoIVACuota,	Var_AbrevAccesorio,	Var_CobraIVAAc,	Var_ConceptoCartera
				FROM TMPACCESORIOSPROD
				WHERE CreditoID =  Par_CreditoID
                AND Consecutivo = Contador;

				SET Var_DescAccesorios		:= CONCAT('ACCESORIOS CREDITO ', Var_AbrevAccesorio);		-- Descripcion de Movimiento de Accesorios
				SET Var_DescIVAAccesorios	:= CONCAT('IVA ACCESORIOS CREDITO ', Var_AbrevAccesorio) ;	-- Descripcion de Movimientos de IVA de Accesorios

                IF(Var_CobraIVAAc = SiPagaIVA) THEN
					SET Var_ConceptoIVACartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA ', Var_AbrevAccesorio) );
                END IF;
                # ===================================  SE REALIZA EL RESPALDO DE LOS ACCESORIOS DE CREDITO  ======================================

                CALL RESDETACCESORIOSPRO(
					Par_CreditoID,		Var_AccesorioID,	Entero_Cero,		SalidaNo, 			Par_NumErr,
                    Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				# INGRESO POR CONCEPTO DE OTRA COMISIONES(ACCESORIOS)
				IF (Var_MontoCuota > Decimal_Cero) THEN

					# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
				   CALL CONTACCESORIOSCREDPRO (
						Par_CreditoID,			Entero_Cero,				Var_AccesorioID,		Var_CuentaAhoID,		Var_ClienteID,
						Var_FechaOper,			Var_FechaApl,				Var_MontoCuota,			Var_MonedaID,			Var_ProdCreID,
						Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescAccesorios, 	Cadena_Vacia,
						AltaPoliza_NO,			Entero_Cero,				Par_PolizaID, 			AltaPolCre_SI,			AltaMovCre_NO,
						Var_ConceptoCartera,	Entero_Cero, 				Nat_Abono,				AltaMovAho_SI,			Tip_MovAhoAccesorios,
						Nat_Cargo, 				Cadena_Vacia,		SalidaNo,				Par_NumErr,				Par_ErrMen,
						Par_Consecutivo,		Par_EmpresaID,		Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	 		Aud_NumTransaccion);

					SET Var_TotalAccesorios := Var_TotalAccesorios + Var_MontoCuota;
					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF(Var_PagIVA = SiPagaIVA) THEN

					IF(Var_MontoIVACuota != Decimal_Cero) THEN
						# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
						   CALL CONTACCESORIOSCREDPRO (
								Par_CreditoID,			Entero_Cero,				Var_AccesorioID,		Var_CuentaAhoID,		Var_ClienteID,
								Var_FechaOper,			Var_FechaApl,				Var_MontoIVACuota,		Var_MonedaID,			Var_ProdCreID,
								Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescIVAAccesorios, 	Cadena_Vacia,
								AltaPoliza_NO,			Entero_Cero,				Par_PolizaID, 			AltaPolCre_SI,			AltaMovCre_NO,
								Var_ConceptoIVACartera,	Entero_Cero, 				Nat_Abono,				AltaMovAho_SI,			Tip_MovIVAAccesorios,
							Nat_Cargo, 				Cadena_Vacia,				SalidaNo,				Par_NumErr,				Par_ErrMen,
							Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);
							END IF;

                            SET Var_TotalIVAAccesorio := Var_TotalIVAAccesorio + Var_MontoIVACuota;
							IF (Par_NumErr <> Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
                END IF;


				-- Actualizamos el Monto Pagado de Accesorios
				UPDATE DETALLEACCESORIOS SET
					SaldoVigente	= SaldoVigente - Var_MontoCuota,
					SaldoIVAAccesorio = SaldoIVAAccesorio - Var_MontoIVACuota,
					MontoPagado		= MontoPagado + Var_MontoCuota,
					FechaLiquida	= CASE WHEN (SaldoVigente + SaldoAtrasado) = Decimal_Cero THEN Var_FechaOper
										ELSE Fecha_Vacia END,
					Usuario         = Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
					WHERE CreditoID	= Par_CreditoID
					AND TipoFormaCobro = ForCobroDeduccion
					AND AccesorioID = Var_AccesorioID;


				SET Contador := Contador + 1;
			END WHILE CICLO;

           -- Se actualizan estos valores para que no permita hacer un desembolso fisico del dinero en ventanilla
			-- Ya que el monto del credito se utiliza para liquidar al que se le esta dando tratamiento
			UPDATE CREDITOS SET
				MontoPorDesemb	= MontoPorDesemb - (Var_TotalAccesorios + Var_TotalIVAAccesorio)
			WHERE CreditoID = Par_CreditoID;

			-- Para Hacer la Dispersion revisamos primero que no sea un Credito Reestructura o Renovacion
			-- Ya que si es una Reestructura o renovacion el monto del Credito sera utilizado para Liquidar el Anterior
			IF(Var_ReqInsDispersion = Cons_NO AND Var_TipoCredito = CreNuevo  AND  ((Var_TipoDisper = DispersionSPEI AND Var_SPEIHabilitado =  SalidaNo) OR (Var_TipoDisper = DispersionCheque) OR (Var_TipoDisper = DispersionOrden) OR (Var_TipoDisper = DispersionSantan))) THEN

				IF (Var_TipoDisper  = DispersionSPEI) THEN
					SET DescripBloqueo := DescripBloqSPEI;
				END IF;

				IF (Var_TipoDisper  = DispersionCheque) THEN
					SET DescripBloqueo := DescripBloqCheq;
				END IF;

                IF (Var_TipoDisper  = DispersionOrden) THEN
					SET DescripBloqueo := DescripBloqOrden;
				END IF;

				IF (Var_TipoDisper = DispersionSantan) THEN
					SET DescripBloqueo := DescripBloqSantan;
				END IF;


				SET Var_MontoBloqueo := MontoCred - (Var_MontoComAp + Var_IVAComAp) - Var_MontoSegVida;


				 IF(Var_MontoCuotaAc>Decimal_Cero)THEN
					SET Var_MontoBloqueo  := Var_MontoBloqueo - (Var_MontoCuotaAc + MontoIVACuotaAc);
				END IF;

				CALL BLOQUEOSPRO(
					Entero_Cero,    	NatMovBloqueo,  	Var_CuentaAhoID,    FechSistema,        Var_MontoBloqueo,
					Fecha_Vacia,    	TipoBloqueo,    	DescripBloqueo,     Par_CreditoID,      Cadena_Vacia,
					Cadena_Vacia,   	SalidaNo,       	Par_NumErr, 		Par_ErrMen, 		Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    	Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF; -- Endif del Tipo de Dispersion

		END IF;  -- END del IF si maneja Captacion la institucion

		# CURSOR para registrar el saldo de capital de las amortizaciones en capital vigente o en vencido no exigible
		OPEN CURSORAMORTI;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP

				FETCH CURSORAMORTI INTO
					Var_CreditoID, 	Var_AmortizID,	Aud_NumTransaccion,	Var_Cantidad;

					-- Verificamos si el credito es Reestructura y  nace como Vencido
					IF ((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura OR Var_EsConsolidado = Var_SI) AND Res_EstatusCrea = EstatusVencido) THEN
						SET Var_TipoMovCred   := Mov_CapVeNoExi;
					ELSE
						SET Var_TipoMovCred   := Mov_CapVigente;
					END IF;

					CALL  CREDITOSMOVSALT (
						Var_CreditoID,      Var_AmortizID,      Aud_NumTransaccion, Var_FechaOper,		Var_FechaApl,
						Var_TipoMovCred,    Nat_Cargo,          Var_MonedaID,		Var_Cantidad,       Var_Descripcion,
						Var_CuentaAhoStr,   Par_PolizaID,		Con_Origen,			Par_NumErr,			Par_ErrMen,
						Par_Consecutivo,	Cadena_Vacia,		Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				END LOOP;
			END;
		CLOSE CURSORAMORTI;

		-- si se trata de un calendario con pagos libres, se eliminan las amortizaciones
		IF(Var_TipPagCapita = Pag_Libres) THEN
			CALL TMPPAGAMORSIMBAJ(
				NTranSim,		SalidaNo,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Actualizamos la Solicitud de Credito
		UPDATE SOLICITUDCREDITO SET
			CreditoID			= Var_CreditoID,
			Estatus				= EstatusDesemb,
			FechaFormalizacion	= FechSistema,

			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE SolicitudCreditoID = Var_SoliciCredID;

		CALL ESTATUSSOLCREDITOSALT(
		Var_SoliciCredID,          Var_CreditoID,        EstatusDesemb,             Cadena_Vacia,            Cadena_Vacia,
		SalidaNo, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,
		Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
		END IF;
		-- Verificar si tiene cartas internas por pagar

		SELECT COUNT(DET.CartaLiquidaID)
		INTO Var_NumCartasInt
		FROM CONSOLIDACIONCARTALIQ			AS CONS
		INNER JOIN CONSOLIDACARTALIQDET		AS DET	ON CONS.ConsolidaCartaID	= DET.ConsolidaCartaID	AND DET.TipoCarta	= Con_TipoCarta
		INNER JOIN CARTALIQUIDACION			AS CLIQ	ON DET.CartaLiquidaID		= CLIQ.CartaLiquidaID	AND CLIQ.Estatus	= Con_EstatusCarta
		WHERE CONS.SolicitudCreditoID = Var_SoliciCredID;

		SET Var_NumCartasInt = IFNULL(Var_NumCartasInt, Entero_Cero);
		-- Si es Reestructura o Renovacion Hacemos la Liquidacion del Credito Anterior
		IF (Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura OR Var_NumCartasInt > 0) THEN

			-- Valida si existen crtas internas relacionadas con la solicitud
			IF EXISTS (SELECT DET.CartaLiquidaID
						 FROM CONSOLIDACIONCARTALIQ			AS CONS
						INNER JOIN CONSOLIDACARTALIQDET		AS DET	ON CONS.ConsolidaCartaID	= DET.ConsolidaCartaID	AND DET.TipoCarta	= Con_TipoCarta
						INNER JOIN CARTALIQUIDACION			AS CLIQ	ON DET.CartaLiquidaID		= CLIQ.CartaLiquidaID	AND CLIQ.Estatus	= Con_EstatusCarta
						WHERE CONS.SolicitudCreditoID = Var_SoliciCredID) THEN

				CALL PAGOCRECARTALIQINTPRO(
						Var_SoliciCredID,	Var_CuentaAhoID,	Var_MonedaID,		PrePago_NO,			Finiquito_SI,
						Var_PagoAplica,		Par_PolizaID,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
						Var_CargoCuenta,	Con_Origen,			RespaldaCredSI,		SalidaNo,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr > Entero_Cero) THEN
						SET Par_NumErr := Par_NumErr;
						SET Par_ErrMen := Par_ErrMen;
						SET Var_Control:= 'creditoID';

						LEAVE ManejoErrores;
					END IF;

				SET  Var_MontoPago := Var_PagoAplica;

			ELSE

				IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
					  SET  Var_MontoPago := Res_SaldoCredAnteri;
	            ELSE
					SET Var_MontoPago := Var_CantidadPagar;
	            END IF;

				SET Var_PagoAplica  := Entero_Cero;
				SET Par_Consecutivo := Entero_Cero;
				SET Aud_ProgramaID  := 'MINISTRACREPRO';

				CALL PAGOCREDITOPRO(
					Var_Relacionado,    Var_CuentaAhoID,    Var_MontoPago,  	Var_MonedaID,       PrePago_NO,
					Finiquito_SI,       Par_EmpresaID,      SalidaNo,       	AltaPoliza_NO,      Var_PagoAplica,
					Par_PolizaID,       Str_NumErr,         Par_ErrMen,     	Par_Consecutivo,	Var_CargoCuenta,
					Con_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

					SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);
					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

			END IF;

			-- Se actualizan estos valores para que no permita hacer un desembolso fisico del dinero en ventanilla
			-- Ya que el monto del credito se utiliza para liquidar al que se le esta dando tratamiento
			UPDATE CREDITOS SET
				MontoDesemb		= MontoCred,
				MontoPorDesemb	= MontoCred - Var_MontoPago- (Var_MontoComAp + Var_IVAComAp) - Var_MontoSegVida
			WHERE CreditoID = Par_CreditoID;



			IF (Var_PagoAplica <= Entero_Cero) THEN
				SET Par_NumErr	:= 301;
				SET Par_ErrMen	:= CONCAT('No se pudo Realizar el Pago del Credito: ', CONVERT(Var_Relacionado, CHAR),'.');
				LEAVE ManejoErrores;
			END IF;

			-- Consultamos el Credito Origen a Reestructurar o Renovar
			SELECT  Cre.Estatus INTO Var_RelaEstatus
			FROM CREDITOS Cre
			WHERE Cre.CreditoID = Var_Relacionado;

			SET Var_RelaEstatus := IFNULL(Var_RelaEstatus, Cadena_Vacia);
			IF (Var_TipoLiquidacion = LiquidacionTotal) THEN
				IF (Var_RelaEstatus != EstatusPagado) THEN
					SET Par_NumErr	:= 302;
					SET Par_ErrMen	:= CONCAT('El Credito: ', CONVERT(Var_Relacionado, CHAR), ', No fue Liquidado por Completo.');
					LEAVE ManejoErrores;
				END IF;
            END IF;

		END IF; -- Endif del Pago de Credito cuando es Reestructura

		CALL PAGARECREDITOALT(
			Par_CreditoID,		SalidaNo,       	Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;

        /* ********************************************
        * Se registra el Identificador CNBV para SOFIPOS
        *********************************************** */
        CALL GENERACREDIDCNBVPRO(
				Par_CreditoID,			Var_TipoProd,		SalidaNo,		Par_NumErr,			Par_ErrMen,
				Var_CreditoIDCNBV,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;

        /* *** Fin genera Iden CNBV ****** */
		UPDATE CREGARPRENHIPO
        SET CreditoID=Par_CreditoID
        WHERE SolicitudCreditoID=Var_SoliciCredID;


		SET Var_FechaInicio := Var_FecIniCred;
		SET Var_FechaFinMes := (SELECT LAST_DAY(Var_FechaInicio));
		SET Var_MesFechaInicio := (SELECT MONTH(Var_FechaInicio));
		SET Var_MesFechaCobCom	:= (SELECT MONTH(Var_FechaCobroCom));

        IF(Var_MesFechaInicio <> Var_MesFechaCobCom) THEN
			SET Var_FechaFinMes := (SELECT LAST_DAY(Var_FechaCobroCom));
        END IF;

		SET Var_NumMes := 1;

		WHILE Var_FechaFinMes < FechVencCred DO

			CALL CRECOBCOMMENSUALALT(
				Par_CreditoID,			Var_NumMes,		Var_FechaFinMes,	Var_TipoCredito,	SalidaNo,
                Par_NumErr,				Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_FechaInicio := (SELECT DATE_ADD(Var_FechaFinMes,INTERVAL 1 DAY));
            SET Var_FechaFinMes := (SELECT LAST_DAY(Var_FechaInicio));
            SET Var_NumMes := Var_NumMes + 1;
		END WHILE;
		IF(Var_CobraGarFin = Var_SI AND Var_RequiereGarFOGAFI = Var_SI AND Var_ModalidadFOGAFI = ModPeriodico) THEN

			SET Var_NumCuotas := (SELECT COUNT(*) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
            SET Var_MontoFOGAFI := (SELECT MontoGarFOGAFI FROM DETALLEGARLIQUIDA WHERE CreditoID = Par_CreditoID);
            SET Var_MontoCuotaFOGAFI := (Var_MontoFOGAFI / Var_NumCuotas );

            SET Var_SaldoFOGAFI := IFNULL(Var_SaldoFOGAFI, Decimal_Cero);
            SET Var_MontoFOGAFI	:= IFNULL(Var_MontoFOGAFI, Decimal_Cero);
            SET Var_MontoCuotaFOGAFI := IFNULL(Var_MontoCuotaFOGAFI, Decimal_Cero);

            INSERT INTO DETALLEGARFOGAFI (
				SolicitudCreditoID,	CreditoID,			ProductoCreditoID,	AmortizacionID,		Estatus,
				FechaPago,			FechaLiquida,		MontoCuota,			EmpresaID,			Usuario,
                FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

            SELECT
				Var_SoliciCredID,	Par_CreditoID, 		Var_ProdCreID,		AmortizacionID,		EstatusVigente,
                FechaExigible,		Fecha_Vacia,		Decimal_Cero,		Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
            Decimal_Cero
            FROM AMORTICREDITO
            WHERE CreditoID = Par_CreditoID;


            SET Contador := 1;

            WHILE(Contador <= Var_NumCuotas) DO

				IF(Contador < Var_NumCuotas) THEN
					UPDATE DETALLEGARFOGAFI
					SET MontoCuota = Var_MontoCuotaFOGAFI,
						SaldoFOGAFI  = Var_MontoCuotaFOGAFI
					WHERE AmortizacionID = Contador
					AND CreditoID = Par_CreditoID;

                ELSE


                    SET Var_MontoCuotaFOGAFI := Var_MontoFOGAFI - Var_SaldoFOGAFI;

					UPDATE DETALLEGARFOGAFI
					SET MontoCuota = Var_MontoCuotaFOGAFI,
						SaldoFOGAFI  = Var_MontoCuotaFOGAFI
					WHERE AmortizacionID = Contador
					AND CreditoID = Par_CreditoID;


                END IF;


                SET Var_SaldoFOGAFI := Var_SaldoFOGAFI + Var_MontoCuotaFOGAFI;

                SET Contador := Contador + 1;
            END WHILE;


		END IF;


		IF(Var_RequiereCheckList = Var_SI) THEN
			-- Notificacion de Documentos de Guarda Valores
			SET Var_ParticipanteID := IFNULL(FNPARTICIPANTEGRDVALORES(Inst_Credito, Par_CreditoID, Ope_Participante), Entero_Cero);
			SET Var_TipoParticipante := IFNULL(FNTIPOPARTICIPANTEGRDVALORES(Inst_Credito, Par_CreditoID), Cadena_Vacia);

			CALL NOTIFCACORREOGRDVALPRO (
				Var_ParticipanteID,		Var_TipoParticipante,	Cons_NO,			Par_NumErr, 		Var_MensajeNotificacion,
				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);
				SET Par_NumErr := Entero_Cero;

		END IF;

		IF(Var_InversionID <> Entero_Cero) THEN
			UPDATE INVERSIONES
			SET Reinvertir = Cons_NO
			WHERE InversionID = Var_InversionID;

        END IF;

		IF(MultipleDisp = Var_SI) THEN
			CALL ASIGSALDOCLIENTEACT (
				Par_CreditoID,			Var_MontoCliente,		SalidaNo,			Par_NumErr,			Par_ErrMen,
				Par_EmpresaID,       	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,        	Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
			END IF;

		END IF;


		IF(Var_ParticipaSpei = Var_SI AND Var_TipoDisper = Var_SI /*T_15396 by Hussein Chan*/) THEN
			IF(VarTipoPerson NOT IN (Var_PersFisConAct, Var_PersFisSinAct, Var_PersonaMoral)) THEN
				SET Par_NumErr := 307;
				SET Par_ErrMen := 'No se encontro la informacion del tipo de persona (F = Fisica, A = Fisica con actividad Empresarial, M = Moral).';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion de Cuenta Clabe para persona fisica
			IF(VarTipoPerson IN (Var_PersFisConAct, Var_PersFisSinAct)) THEN
				SELECT Estatus
					INTO Var_EstCuentaClabe
					FROM SPEICUENTASCLABEPFISICA
					WHERE CuentaClabe = Var_Clabe;

				IF(IFNULL(Var_EstCuentaClabe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 308;
					SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe del credito a dispersar.';
					SET Var_Control := 'creditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Var_EstCuentaClabe, Cadena_Vacia) <> Est_CueClabeAut) THEN
					SET Par_NumErr := 309;
					SET Par_ErrMen := CONCAT('La Cuenta Clabe del credito a dispersar se encuentra con estatus ',
							CASE
								WHEN Var_EstCuentaClabe = Est_CueClabeIna THEN Est_DesCueClabeIna
								WHEN Var_EstCuentaClabe = Est_CueClabePen THEN Est_DesCueClabePen
								WHEN Var_EstCuentaClabe = Est_CueClabeBaj THEN Est_DesCueClabeBaj
							END
						);
					SET Var_Control := 'creditoID';
					LEAVE ManejoErrores;
				END IF;
			ELSE -- Validacion de Cuenta Clabe para persona moral
				SELECT Estatus
					INTO Var_EstCuentaClabe
					FROM SPEICUENTASCLABPMORAL
					WHERE CuentaClabe = Var_Clabe;

				IF(IFNULL(Var_EstCuentaClabe, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr := 308;
					SET Par_ErrMen := 'No se encontro informacion de la cuenta clabe para persona moral.';
					SET Var_Control := 'creditoID';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Var_EstCuentaClabe, Cadena_Vacia) <> Est_CueClabeAut) THEN
					SET Par_NumErr := 309;
					SET Par_ErrMen := CONCAT('La Cuenta Clabe del credito a dispersar se encuentra con estatus ',
							CASE
								WHEN Var_EstCuentaClabe = Est_CueClabeIna THEN Est_DesCueClabeIna
								WHEN Var_EstCuentaClabe = Est_CueClabePen THEN Est_DesCueClabePen
								WHEN Var_EstCuentaClabe = Est_CueClabeBaj THEN Est_DesCueClabeBaj
							END
						);
					SET Var_Control := 'creditoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- INSTRUCCIONES DE DISPERSION
		-- IF (Var_SPEIHabilitado =  Salida_SI AND Var_ReqInsDispersion = Salida_SI AND MultipleDisp = Var_SI) THEN
		IF (Var_ReqInsDispersion = Salida_SI AND MultipleDisp = Var_SI) THEN
				CALL INSTRUCDISPERSIONCREPRO(
						Par_CreditoID,	Var_CuentaAhoID,	SalidaNo,			Par_NumErr,			Par_ErrMen,
						Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,	Aud_NumTransaccion);
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;
		IF (Var_TipoDisper = DispersionSPEI AND Var_SPEIHabilitado =  Salida_SI AND Var_ReqInsDispersion = Cons_NO) THEN

			SET Var_ComisionTrans := Decimal_Cero;
			SET Var_ComisionIVA := Decimal_Cero;

			SET Var_TotalCargoCuenta := Var_MontoADesem + Var_ComisionTrans + Var_ComisionIVA;

			-- Se obtiene toda la informacion desde la primera consulta a cuentas transfer
			SELECT		ClienteID, 				AplicaPara,				Beneficiario, 		TipoCuentaSpei, 		RFCBeneficiario,
						InstitucionID
				INTO 	Var_CliCuentaTrans,		Var_AplicacionSpei,		Var_NombreBenefi,	Var_TipoCuentaBen,		Var_RFCBenefi,
						Var_InstitRecep
				FROM CUENTASTRANSFER
				WHERE Clabe = VarCuentaCLABE
				AND ClienteID	= Var_ClienteID
				AND Estatus		= Estatus_Activo
				LIMIT 1;
			SET Var_CliCuentaTrans := IFNULL(Var_CliCuentaTrans, Entero_Cero);
			SET Var_NombreBenefi := IFNULL(Var_NombreBenefi, Cadena_Vacia);
			SET Var_TipoCuentaBen := IFNULL(Var_TipoCuentaBen, Entero_Cero);
			SET Var_RFCBenefi := IFNULL(Var_RFCBenefi, Cadena_Vacia);
			SET Var_InstitRecep := IFNULL(Var_InstitRecep, Entero_Cero);
			SET Var_AplicacionSpei := IFNULL(Var_AplicacionSpei, Cadena_Vacia);

			IF ( Var_CliCuentaTrans != Var_ClienteID) THEN
				SET Par_NumErr := 306;
				SET Par_ErrMen := CONCAT('La cuenta CLABE[', VarCuentaCLABE,'] no esta registrada en las cuenta destino del cliente.');
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF ( Var_AplicacionSpei NOT IN ('A', 'C') AND Var_CtaReqCreAmbas = Var_SI) THEN
				SET Par_NumErr := 307;
				SET Par_ErrMen := CONCAT('La cuenta CLABE destino no aplica para Creditos [', VarCuentaCLABE, '].');
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT SUBSTRING(NombreCompleto, 1, 30)
				INTO Var_UsuEnvioSPEI
				FROM USUARIOS
				WHERE UsuarioID =  Aud_Usuario;

			SET Var_UsuEnvioSPEI := IFNULL(Var_UsuEnvioSPEI, Cadena_Vacia);

			SELECT SUBSTRING(DATE_FORMAT(FechaSistema, '%y%m%d'), 1, 7)
				INTO Var_FechaSinGuion
				FROM PARAMETROSSIS
				LIMIT 1;

			SET Var_FechaSinGuion := IFNULL(Var_FechaSinGuion, Cadena_Vacia);
			SET Var_ReferenciaNum := CAST(Var_FechaSinGuion AS UNSIGNED);

			SET Var_FechaAuto := CURRENT_TIMESTAMP();
			SET Var_FechaRecep := CURRENT_TIMESTAMP();

			-- SE REALIZA LA VALIDACION DE ESTATUS AUTORIZADO O PENDIENTE SEGUN EL MONTO A DESEMBOLSAR
			IF(Var_MontoADesem >= Var_montoReqAuTesor)	THEN
				SET	Est_FinalEstatus	:=	Est_Pend;
			ELSE
				SET	Est_FinalEstatus	:=	Est_Verif;
			END IF;

			-- SE REGISTRA EL SPEI ENVIO
			CALL SPEIENVIOSPRO (	Var_FolioEnvio, 		Var_ClaveRastreo, 		Var_TipoPagoTercer,		Var_CuentaAhoID,		Var_TipoCuentaOrd,
									Var_ClabeOrdenante, 	Var_NombreOrdenante,	Var_RFCOrdenante,		Var_MonedaID,			Entero_Cero,
									Var_MontoADesem,		Decimal_Cero,			Var_ComisionTrans,		Var_ComisionIVA,		Var_TotalCargoCuenta,
									Var_InstitRecep,		VarCuentaCLABE,			Var_NombreBenefi,		Var_RFCBenefi,			Var_TipoCuentaBen,
									Var_ConceptoPago,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,
									Cadena_Vacia,			Cadena_Vacia,			Var_ReferenciaNum,		Var_UsuEnvioSPEI,		Var_AreaBanco,
									Var_OrigenOperVent,		SalidaNo,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
									Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
									Aud_NumTransaccion);


			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL SPEIENVIOSDESEMBOLSOALT(
				Var_FolioEnvio,		Par_CreditoID,		Var_BloqueoID,			SalidaNo,				Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL SPEIENVIOSACT(
				Var_FolioEnvio,		Cadena_Vacia,		Entero_Cero,			Entero_Cero,			Cadena_Vacia,
				Cadena_Vacia,		Entero_Cero,		Entero_Cero,			Act_EstatusDesemPen,	SalidaNo,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
			);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Se obtiene el valor de la parametrizacion para fondeos de crowdfunding
		SELECT ValorParametro
		INTO  Var_CrwActivo
		FROM PARAMGENERALES WHERE LlaveParametro = Var_LlaveCRW;

		IF(Var_CrwActivo = Salida_SI) THEN


			-- Insercion o actualizacion del saldo para fondear el credito Fer.CRW
			SET	Var_SaldoFondeo		:= IFNULL((SELECT	SUM(SaldoCapExigible + SaldoCapVigente)
												FROM 	CRWFONDEO
												WHERE	CreditoID = Par_CreditoID),Decimal_Cero);

			SET	Var_SaldoCreInsol	:= IFNULL((SELECT SUM(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi)
												FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID AND Estatus <> EstatusPagado),Decimal_Cero);

			SET	Var_EstatusCre		:= (SELECT Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);


			INSERT INTO CRWAMORTICREFONDEO(
					CreditoID,		AmortizacionID,	Estatus,		FechaInicio,	FechaVencimiento,
					FechaExigible,	SaldoCapital,	SaldoFondeo,	NumFondeos )

			SELECT 	CreditoID, 		AmortizacionID,			Estatus, 		FechaInicio,	FechaVencim,
					FechaExigible,	SUM(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi),	Decimal_Cero,	Entero_Cero
			FROM 	AMORTICREDITO AC
			WHERE 	AC.CreditoID = Par_CreditoID
			GROUP BY AmortizacionID;

			UPDATE 		CRWAMORTICREFONDEO AO
			INNER JOIN (
				SELECT		CreditoID, AF.FechaVencimiento,		SUM(AF.SaldoCapVigente + AF.SaldoCapExigible)SaldoFondeo, 	COUNT(FK.SolFondeoID) NumFondeos
				FROM 		CRWFONDEO FK
				INNER JOIN	AMORTICRWFONDEO AF
					ON 		FK.SolFondeoID = AF.SolFondeoID
				WHERE 		FK.CreditoID = Par_CreditoID
				GROUP BY	AF.FechaVencimiento) FK
				ON 		AO.CreditoID = FK.CreditoID
				AND		AO.FechaVencimiento = FK.FechaVencimiento
				SET		AO.SaldoFondeo = IFNULL(FK.SaldoFondeo,Decimal_Cero),
						AO.NumFondeos  = IFNULL(FK.NumFondeos, Entero_Cero);

			INSERT INTO CRWCREDITOFONDEO(
				CreditoID,		SaldoCre,		SaldoFondeo, 	MontoCredito,	EstatusCre,
				CreditoEnEjec,	FondeoEnEjec,	Estatus, 		FechaActual,	NumTransaccion)

			VALUES(
				Par_CreditoID,				Var_SaldoCreInsol,	Var_SaldoFondeo,	MontoCred,	Var_EstatusCre,
				Var_EjecucionNo,			Entero_Cero,		CASE WHEN Var_EstatusCre IN(EstatusPagado,'K') THEN 'I' ELSE 'A' END,
				NOW(),			Aud_NumTransaccion);

		END IF;

		IF (Var_ConvNomID <> Entero_Cero) THEN

			SELECT		ReportaIncidencia
				INTO	Var_ReportaIncid
				FROM	CONVENIOSNOMINA
				WHERE	ConvenioNominaID = Var_ConvNomID
				  AND	ManejaCalendario = Var_SI;

			SET Var_ReportaIncid	:= IFNULL(Var_ReportaIncid, Cons_NO);

			-- Si el convenio del credito reporta incidencias, el credito debe pasar por el flujo de instalacion de nomina para poder generar intereses
			IF (Var_ReportaIncid = Var_SI) THEN

				SELECT	FechaVencim
				  INTO	Var_FechaVencim
				  FROM	AMORTICREDITO
				 WHERE	CreditoID = Par_CreditoID
				ORDER BY FechaVencim ASC LIMIT 1;

				SELECT	InstitNominaID, 	ConvenioNominaID
				  INTO 	Var_InstitNominaID,	Var_ConvenioNominaID
				  FROM	CREDITOS
				 WHERE	CreditoID = Par_CreditoID;

				SELECT	FechaLimiteRecep
				  INTO 	Var_FechaLimitRecep
				  FROM 	CALENDARIOINGRESOS
				 WHERE	InstitNominaID 		= 	Var_InstitNominaID
				   AND	ConvenioNominaID 	= 	Var_ConvenioNominaID
				   AND	FechaPrimerDesc		= 	Var_FechaVencim;

				UPDATE CREDITOS SET
					EstatusNomina	= Var_EstNoEnviado,
					DevengaNomina	= Cons_NO,
					FechaRecepLim	= Var_FechaLimitRecep
				WHERE CreditoID = Par_CreditoID;

			END IF;

		END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := CONCAT('El Credito: ', CONVERT(Par_CreditoID, CHAR), ' Ha sido Desembolsado Exitosamente.');

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$
