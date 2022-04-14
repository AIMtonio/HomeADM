-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSALT`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSALT`(
	# =============================================================================================================================
	# ----------- SP PARA DAR DE ALTA UN CREDITO NUEVO O UN CREDITO RENOVACION ----------------------------
	# =============================================================================================================================
    Par_ClienteID       INT(11),					-- Número de cliente
    Par_LinCreditoID    INT(11),					-- Número de Linea de Crédito
    Par_ProduCredID     INT(11),					-- Número del producto de crédito
    Par_CuentaID        BIGINT(12),					-- Número de la cuenta
	Par_TipoCredito     CHAR(1),					-- Tipo de crédito (Renovación o Reestructura)
    Par_Relacionado     BIGINT(12),					-- Número del Crédito
    Par_SolicCredID     INT(11),					-- Número de la Solicitud de Crédito
    Par_MontoCredito    DECIMAL(12,2),				-- Monto del Crédito
    Par_MonedaID        INT(11),					-- Número de MonedaID
    Par_FechaInicio     DATE,						-- Fecha de Inicio

    Par_FechaVencim     DATE,						-- Fecha de Vencimiento
    Par_FactorMora      DECIMAL(12,2),				-- Factor Moratorio
    Par_CalcInterID     INT(11),					-- Calculo de Interes
    Par_TasaBase        INT(11),					-- Tasa Base
    Par_TasaFija        DECIMAL(12,4),				-- Tasa Fija
    Par_SobreTasa       DECIMAL(12,4),				-- Sobre Tasa
    Par_PisoTasa        DECIMAL(12,2),				-- Piso Tasa
    Par_TechoTasa       DECIMAL(12,2),				-- Techo Tasa
    Par_FrecuencCap     CHAR(1),					-- Fecuencia de Capital
    Par_PeriodCap       INT(11),					-- Periodicidad del capital

    Par_FrecuencInt     CHAR(1),					-- Frecuencia de Interes
    Par_PeriodicInt     INT(11),					-- Periodicidad del Interes
    Par_TPagCapital     VARCHAR(10),				-- Tipo de Pago capital
    Par_NumAmortiza     INT(11),					-- Número de Amortizaciones
    Par_FecInhabil      CHAR(1),					-- Fecha Inhabil
    Par_CalIrregul      CHAR(1),					-- Calculo Irregular
    Par_DiaPagoInt      CHAR(1),					-- Dia de pago de Interes
    Par_DiaPagoCap      CHAR(1),					-- Dia de pago de capital
    Par_DiaMesInt       INT(11),					-- Dia mes Interes
    Par_DiaMesCap       INT(11),					-- Dia mes capital

    Par_AjFUlVenAm      CHAR(1),					-- Ajuste de fecha de Vencimiento de Amortizacion
    Par_AjuFecExiVe     CHAR(1),					-- Ajuste de fehca de exigible de vencimiento
    Par_NumTransacSim   BIGINT(20),					-- Numero de transaccion de simulador
    Par_TipoFondeo      CHAR(1),					-- Tipo de fondeo
    Par_MonComApe       DECIMAL(12,2),				-- Monto de comision por apertura
    Par_IVAComApe       DECIMAL(12,2),				-- Iva de comision por apertura
    Par_ValorCAT        DECIMAL(12,4),				-- Valor de CAT
    Par_Plazo           VARCHAR(20),				-- Plazo
    Par_TipoDisper      CHAR(1),					-- Tipo de Dispersion
	Par_CuentaCABLE		CHAR(18), --  Cuenta Clabe para cuando el tipo de Dispersion sea por SPEI

    Par_TipoCalInt      INT(11),					-- Tipo de calculo de interes
    Par_DestinoCreID    INT(11),					-- destino de credito
    Par_InstitFondeoID  INT(11),					-- institucion de fondeo
    Par_LineaFondeo     INT(11),					-- linea de fondeo
    Par_NumAmortInt     INT(11),					-- Numero de amortizaciones de interes
    Par_MontoCuota      DECIMAL(12,2),				-- Monto de la cuota
    Par_MontoSegVida    DECIMAL(12,2),				-- Monto del seguro de Vida
    Par_AportaCliente	DECIMAL(12,2),				-- Aportacion del cliente
    Par_ClasiDestinCred CHAR(1),					-- Clasificacion de destino de credito
	Par_TipoPrepago     CHAR(1),					-- Tipo de prepago

	Par_FechaInicioAmor	DATE,						-- Fecha de inicio de las amortizaciones
 	Par_ForCobroSegVida	CHAR(1),					-- Fecha de Cobro de Seguro de Vida
 	Par_DescSeguro		DECIMAL(12,2),				-- seguro
	Par_MontoSegOri		DECIMAL(12,2),				-- Monto seguro

	Par_TipoConsultaSIC CHAR(2),					-- ConsultaSIC
    Par_FolioConsultaBC VARCHAR(30),				-- Folio Consulta BC
	Par_FolioConsultaCC VARCHAR(30),				-- Folio Consulta CC
    Par_FechaCobroComision DATE,					-- Fecha Cobro Comision
    Par_ReferenciaPago	VARCHAR(20),				-- Referencia de Pago

    Par_Salida          CHAR(1),
    OUT   NumCreditoID  BIGINT(12),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_empresa 		INT(11) ,					-- Auditoria
    Par_Usuario 		INT(11) ,					-- Auditoria
    Par_FechaActual 	DATETIME,					-- Auditoria
    Par_DireccionIP 	VARCHAR(15),				-- Auditoria
    Par_ProgramaID 		VARCHAR(50),				-- Auditoria
    Par_SucursalID 		INT(11) ,					-- Auditoria
    Par_NumTransaccion 	BIGINT(20)					-- Auditoria
						)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_ManejaLinea 	CHAR(1);
	DECLARE Var_TipPagoSeg  	CHAR(1);
	DECLARE Var_TipPagComAp 	CHAR(1);
	DECLARE Var_SolSegVida  	DECIMAL(12,2);
	DECLARE VarSumaCapital  	DECIMAL(12,2);
	DECLARE Var_FuncionHuella 	CHAR(1);
	DECLARE Decimal_Cero  		DECIMAL(12,2);
	DECLARE Var_MonedaCta   	BIGINT;
	DECLARE FechaTermLin    	DATE;
	DECLARE FechaIniLin     	DATE;
	DECLARE Var_Cliente     	INT;
	DECLARE FechSistem      	DATE;
	DECLARE DiaPagCapi      	INT;
	DECLARE Var_EstFondeo   	CHAR(1);
	DECLARE Var_SaldoFondo  	DECIMAL(14,2);
	DECLARE Var_i           	INT;
	DECLARE Var_j           	INT;
	DECLARE Verifica        	INT;
	DECLARE Var_NomControl  	VARCHAR(50);
	DECLARE Var_GrupoID     	INT;
	DECLARE Var_CicloGrupo  	INT;
	DECLARE Var_SalCapConta     DECIMAL(14,2);
	DECLARE Var_ValidaCapConta  CHAR(1);
	DECLARE Var_PorcMaxCapConta DECIMAL(12,4);
	DECLARE Var_MonMaxPer       DECIMAL(12,2);
	DECLARE Var_EstatusCta		CHAR(1);
	DECLARE Var_EstatusCliente	CHAR(1);
	DECLARE Var_RequiereGL		CHAR(1);
	DECLARE Var_PorcGarLiq		DECIMAL(12,2);
	DECLARE Var_ReqHuellaProductos	CHAR(1);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_DiaPagoProd		CHAR(1);
	DECLARE Var_NumDiasAtraOri	INT(11);
	DECLARE Var_NumRenovacion	INT(5);
	DECLARE Var_SaldoExigible	DECIMAL(14,2);
	DECLARE Var_EstatusCrea		CHAR(1);
	DECLARE Var_NumPagoSostenido INT(5);
	DECLARE Var_EstRelacionado	CHAR(1);
	DECLARE Var_PeriodCap		INT(11);
	DECLARE Var_DestinoCre		INT;
	DECLARE Var_SalCredAnt      DECIMAL(12,2);  -- Saldo del Credito Anterior( a Renovar).
	DECLARE Var_TipCobComMorato	CHAR(1);
	DECLARE Var_Control             VARCHAR(100);
	DECLARE Var_MontoSeguroCuota	DECIMAL(12,2);
	DECLARE Var_CobraSeguroCuota    CHAR(1);                    -- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);                    -- Cobra el producto IVA por seguro por cuota
	DECLARE Var_IVA                 DECIMAL(14,2);              -- IVA de la sucursal
	DECLARE Var_IVASeguroCuota      DECIMAL(12,2);              -- Monto que cobrara por IVA
    DECLARE Var_NumSolicitud      	BIGINT(20);					-- Variable Solicitud Credito en la tabla de solicitudes
    DECLARE Var_NumCredito			BIGINT(12);					-- Variable soicitud Credito en la tabla de creditos
    DECLARE Var_ReferenciaGrupo		VARCHAR(20);
	DECLARE Var_ConvenioNominaID	BIGINT UNSIGNED;					-- ID DEL CONVENIO DE NOMINA
	DECLARE Var_FlujoOrigen			CHAR(1);					-- Flujo origen
	DECLARE Var_EsConsolidado		CHAR(1);					-- Es consolidado
    DECLARE Var_EstatusLinea        CHAR(1);


	#COMISION ANUAL
	DECLARE Var_CobraComisionComAnual			VARCHAR(1);				-- Cobra Comision S:Si N:No
	DECLARE Var_TipoComisionComAnual			VARCHAR(1);				-- Tipo de Comision P:Porcentaje M:Monto
	DECLARE Var_BaseCalculoComAnual				VARCHAR(1);				-- Base del Calculo M:Monto del credito Original S:Saldo Insoluto
	DECLARE Var_MontoComisionComAnual			DECIMAL(14,2);			-- Monto de la Comision en caso de que el tipo de comision sea M
	DECLARE Var_PorcentajeComisionComAnual		DECIMAL(14,4);			-- Porcentaje de la comision en caso de que el tipo de comision sea P
	DECLARE Var_DiasGraciaComAnual				INT(11);				-- Dias de gracia que se dan antes de cobrar la comision

	#FIN COMISION ANUAL
	DECLARE Var_CantidadPagar	DECIMAL(12,2);			-- Cantidad a Pagar(Renovacion)
    DECLARE Var_TipoLiquidacion	CHAR(1);
    DECLARE Var_MontoComAp		DECIMAL(14,2);		-- Monto Comision por Apertura
    DECLARE Var_MontoIVAComAp	DECIMAL(14,2);		-- Monto IVA Comision por Apertura

    #CREDITOS AUTOMATICOS
    DECLARE Var_InvCredAut			INT(11);			-- Inversion relacionada al credito
    DECLARE Var_CtaCredAut			BIGINT(12);			-- Cuenta de Ahorro relacionada al credito
    DECLARE Var_EsAutomatico		CHAR(1);			-- Indica si el producto de credito es automatico
    DECLARE Var_TipoAutomatico		CHAR(1);			-- Indica el tipo automatico del producto de credito

    DECLARE Var_Reacreditado		CHAR(1);			-- Indica si el credito es Reacreditado
 	DECLARE Var_TipoComXApertura	CHAR(1);			-- Tipo de Comision por apertura (Tasa o Monto)(PRODUCTOSCREDITO)
    DECLARE Var_MontoComXApertura	DECIMAL(12,2);		-- Monto Comision por apertura (PRODUCTOSCREDITO)
   	DECLARE Var_DiasAtrasoMin		INT(11);			-- Numero de dias atraso min para realizar el castigo
	DECLARE Var_NivelID				INT(11);			-- Nivel del crédito (NIVELCREDITO).
	DECLARE Var_CobraAccesorios		CHAR(1);			-- Indica si la solicitud cobra accesorios
	DECLARE Var_ParamCobraAcc		CHAR(1);			-- Indica si se realizara el cobro de accesorios
	DECLARE Var_PantallaGrupal		VARCHAR(30);		-- Indica el programa de auditoria
	DECLARE Var_CobraGarFin			CHAR(1);
    DECLARE Var_DetecNoDeseada	    CHAR(1);			-- Validacion del proceso de personas no deseadas
    DECLARE Var_RFCOficial			CHAR(13);			-- RFC de la persona
    DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de persona Fisica, Fisica Act. Empresarial y Moral

	-- Servicios Adicionales
	DECLARE Var_AplicaDescServicio	CHAR(1);			-- Variable que indica si la solicitud de crédito tiene servicios adicionales
	DECLARE Var_Contador			INT(11);			-- Variable contador
	DECLARE Var_ServicioDesc		VARCHAR(100);		-- Variable para describir el servicio adicional
	DECLARE Var_ValidaDocs			CHAR(1);			-- Variable que indica si es necesario validar el documento para el servicio adicional
	DECLARE Var_DocDesc				VARCHAR(100);		-- Variable para describir el nombre del documento para validar el servicio adicional
	DECLARE Var_Adjuntado			CHAR(1);			-- Variable que indica si el archivo a validar ya se ha adjuntado

	DECLARE Var_PermitePrepago		CHAR(1);			-- Permite Prepago
	DECLARE Var_EsConsolidacionAgro	CHAR(1);			-- Es Solicitud de Credito Consolidada Agro
	DECLARE Var_FolioConsolidacionID	BIGINT(12);		-- Numero de Folio de consolidacion
	DECLARE Var_Mensaje				VARCHAR(1000);		-- MENSAJE
	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Entero_Cero         INT;
	DECLARE Fecha_Vacia         DATE;
	DECLARE NumCredito          CHAR(11);
	DECLARE Fecha               DATE;
	DECLARE Modulo2             INT;
	DECLARE consecutivo         BIGINT(12);
	DECLARE NumVerificador      CHAR(1);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Estatus_Cancelado	CHAR(1);
	DECLARE Estatus_Inactivo    CHAR(1);
	DECLARE PagareNoImp			CHAR(1);
	DECLARE SiManejaLinea		CHAR(1);
	DECLARE NombreProceso       VARCHAR(16);
	DECLARE Rec_Propios         CHAR(1);
	DECLARE Rec_Fondeo          CHAR(1);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SalidaNO            CHAR(1);
	DECLARE saldoCapVigent  	DECIMAL(12,2);
	DECLARE saldoCapAtrasad 	DECIMAL(12,2);
	DECLARE saldoCapVencido 	DECIMAL(12,2);
	DECLARE saldCapVenNoExi 	DECIMAL(12,2);
	DECLARE saldoInterOrdin 	DECIMAL(12,2);
	DECLARE saldoInterAtras 	DECIMAL(12,2);
	DECLARE saldoInterVenc  	DECIMAL(12,2);
	DECLARE saldoInterProvi 	DECIMAL(12,2);
	DECLARE saldoIVAInteres 	DECIMAL(12,2);
	DECLARE saldoMoratorios 	DECIMAL(12,2);
	DECLARE saldoIVAMorator 	DECIMAL(12,2);
	DECLARE saldComFaltPago 	DECIMAL(12,2);
	DECLARE salIVAComFalPag 	DECIMAL(12,2);
	DECLARE saldoComServGar 	DECIMAL(12,2);
	DECLARE saldoIVAComSerGar 	DECIMAL(12,2);
	DECLARE saldoOtrasComis 	DECIMAL(12,2);
	DECLARE saldoIVAComisi  	DECIMAL(12,2);
	DECLARE PagoCreciente   	CHAR(1);
	DECLARE Var_TipPagCapL   	CHAR(1);
	DECLARE TipoValiAltaCre  	INT;
	DECLARE Si_ValidaCapConta   CHAR(1);
	DECLARE Var_CalificaCredito	CHAR(1);
	DECLARE No_Asignada			CHAR(1);
	DECLARE Huella_SI			CHAR(1);
	DECLARE MenorEdad			CHAR(1);
	DECLARE FrecuencCapLib		CHAR(1);
	DECLARE FrecuencIntLib		CHAR(1);
	DECLARE TPagCapitalLib		CHAR(1);
	DECLARE CreRenovacion		CHAR(1);
	DECLARE Constante_NO		CHAR(1);
	DECLARE Constante_SI		CHAR(1);
	DECLARE Num_PagRegula		INT(5);
	DECLARE Estatus_Alta		CHAR(1);
	DECLARE Estatus_Pagado		CHAR(1);
	DECLARE OrigenRenovacion	CHAR(1);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_Cancela			CHAR(1);
	DECLARE Est_Desembolso		CHAR(1);
	DECLARE PersonaCliente		CHAR(1);
	DECLARE Entero_Uno			INT(11);
    DECLARE Per_Moral			CHAR(1);
    DECLARE Per_Emp				CHAR(1);
	DECLARE Per_Fisica			CHAR(1);
	DECLARE TipoSpei            CHAR(1);
	DECLARE Con_EstatusNomina	CHAR(1); 			-- Estatus Nomina A por defecto.
	DECLARE Con_DevengaNomina	CHAR(1);			-- Estatus de si Devenga por Default S.
    DECLARE Est_Bloqueado       CHAR(1);            -- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
    DECLARE EstLinea_Vencido    CHAR(1);            -- Indica si se encuentra bloqueada la linea \nE.- Vencido

    DECLARE Var_RequiereCheckList	CHAR(1);
    DECLARE Est_AutorizaGar			CHAR(1);
    DECLARE Var_RequiereReferencia	CHAR(1);
	DECLARE Var_TipoGeneraInteres	CHAR(1);		-- Tipo de Monto Original (Saldos Globales): I.- Iguales  D.- Dias Transcurridos
	DECLARE TipoMontoIguales		CHAR(1);		-- Tipo de Monto Original (Saldos Globales): I.- Iguales
	DECLARE TipoMontoDiasTrans		CHAR(1);		-- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
	DECLARE TipoCalculoMontoOriginal	INT(11);	-- Tipo de Calculo de Interes por el Monto Original (Saldos Globales)

	#COMISION ANUAL
	DECLARE TipoCalMontoComAnual	VARCHAR(1);				-- Tipo de cobro por monto
	DECLARE TipoCalPorcenComAnual	VARCHAR(1);				-- Tipo de cobro por porcentaje
	#FIN COMISION ANUAL

    DECLARE LlaveCobraAccesorios	VARCHAR(200);	 -- Llave par Consulta si Cobra Accesorios
    DECLARE ProgramaGrupal			VARCHAR(50);
    DECLARE LlaveGarFinanciada		VARCHAR(100);
    DECLARE Var_EsAgropecuario		CHAR(1);
    DECLARE Var_SaldoRenovar		DECIMAL(16,2);
	DECLARE Var_ClabeCtaDomici		VARCHAR(20);	-- CUENTA CLABE DE DOMICILIACION DE PAGOS
	DECLARE Var_InstitucionNominaID		INT(11);
    DECLARE Var_ParticipaSpei		CHAR(1);			-- Variable para almacenar el valor de ParticipaSpei

    DECLARE Var_CuentasClabes		INT(11);
    DECLARE Var_CuentaClabe 		VARCHAR(20);	-- cuenta clabe que se utiliza para la dispersion del credito
	DECLARE Var_ClabeCredito		VARCHAR(20);  -- Cuenta clabe que se genera al credito cuando el producto de credito participa en spei
	DECLARE Var_NumCuentaClabe 		INT(11);
	DECLARE Var_NumIntentos			INT(11);
	DECLARE Var_CuotaCompProyectada CHAR(1);		-- Tipo de Prepago Cuota Completas Proyectadas 'P'



	DECLARE Var_NCobraComAper		CHAR(1);		-- Variable para almacenar si convenio cobra comisión por apertura
	DECLARE Var_NManejaEsqConvenio	CHAR(1);		-- Variable para almacenar si convenio maneja esquemas de cobro de comisión por apertura
	DECLARE Var_NEsqComApertID		INT(11);		-- Variable para almacenar ID de esquema de cobro de comisión por apertura del convenio
	DECLARE Var_NTipoComApert		CHAR(1);		-- Variable para almacenar Tipo de cobro de comision por apertura del esquema del convenio
	DECLARE Var_NTipoCobMora		CHAR(1);		-- Variable para almacenar Tipo de cobro de interés moratorio del convenio
	DECLARE Var_NFormCobroComAper	CHAR(1);		-- Variable para almacenar Forma de cobro de comision por apertura del esquema por convenio
	DECLARE Var_NValor				DECIMAL(12,4);	-- Variable para almacenar el valor de comisión por apertura del esquema por convenio
	DECLARE Var_NCobraMora			CHAR(1);		-- Variable para almacenar si el convenio cobra mora
	DECLARE Var_NValorMora			DECIMAL(12,4);	-- Variable para alamcenar el valor de interés moratorio configurado para el convenio
	DECLARE Var_MoraPorConvenio		INT(1);			-- Variable para identificar si se encontró valor de interes moratorio configurado por convenio
	DECLARE Act_NumCredito			TINYINT UNSIGNED;

	DECLARE Var_LineaCreditoID			BIGINT(20);		-- Linea Credito ID
	DECLARE Var_SaldoDisponible			DECIMAL(12,2);	-- Saldo de la Linea, nace con saldo = autorizado
	DECLARE Var_FechaVencimiento		DATE;			-- Fecha de Vencimiento de la Linea de Credito

	DECLARE Var_ManejaComAdmon			CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq		CHAR(1);		-- comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon			CHAR(1);		-- Forma Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_ForPagComAdmon			CHAR(1);		-- Forma Pago Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_PorcentajeComAdmon		DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Var_ManejaComGarantia		CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq		CHAR(1);		-- comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComGarantia		CHAR(1);		-- Forma Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_ForPagComGarantia		CHAR(1);		-- Forma Pago Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_PorcentajeComGarantia	DECIMAL(6,2);	-- permite un valor de 0% a 100%

	DECLARE Con_Deduccion				CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado				CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DecimalCien				DECIMAL(12,2);	-- Constante Decimal Cien
	DECLARE Tip_Disposicion				CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total					CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota					CHAR(1);		-- Constante Cada Cuota
	DECLARE Var_MontoPagComAdmon		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administracion
	DECLARE Var_MontoPagComGarantia		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_Comisiones				DECIMAL(14,2);	-- Monto de Comisiones
	DECLARE Var_AutorizadoLinea			DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Var_PolizaID				BIGINT(20);		-- Poliza de Ajuste
	DECLARE Var_FechaInicioLinea		DATE;			-- Fecha de Inicio de la Linea
	DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente Paga IVA
	DECLARE Var_ComisionTotal			DECIMAL(14,2);	-- Monto Total de la Comision por manejo de Linea

	/* Asignacion de Constantes */
	SET Estatus_Activo      := 'A';             -- Estatus Activo
	SET Estatus_Cancelado	:= 'C';
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Decimal_Cero        := 0.0;             -- DECIMAL Cero
	SET Estatus_Inactivo    := 'I';             -- Estatus del Credito: Iactivo
	SET PagareNoImp         := 'N';             -- Estatus del Pagare NO Impreso
	SET SiManejaLinea       := 'S';             -- SI maneja Linea de Fondeo
	SET PagoCreciente       := 'C';             -- Tipo de Pago de Capital: Crecientes
	SET Var_TipPagCapL      := 'L';             -- Tipo de Pago de Capital: Crecientes
	SET NombreProceso       := 'CREDITOXSOLICITU';
	SET Rec_Propios         := 'P';             -- Tipo de Recursos: Propios
	SET Rec_Fondeo          := 'F';             -- Tipo de Recursos: Con Institucion de Fondeo
	SET SalidaSI            := 'S';             -- El store si Regresa una Salida
	SET SalidaNO            := 'N';             -- El store no Regresa una Salida
	SET TipoValiAltaCre     := 1;               -- Tipo de Validacion: Alta de Credito
	SET Si_ValidaCapConta   := 'S';             -- SI Valida el Capital Contable
	SET No_Asignada			:= 'N';				-- calificacion NO asignada al cliente
	SET FrecuencCapLib		:= 'L';				-- Frecuencia de capital: Libre
	SET FrecuencIntLib		:= 'L';				-- Frecuencia de interes: LIbre
	SET TPagCapitalLib		:= 'L';             -- Tipo Pago Capital: Libre
	SET saldoCapVigent      := 0.00;
	SET saldoCapAtrasad     := 0.00;
	SET saldoCapVencido     := 0.00;
	SET saldCapVenNoExi     := 0.00;
	SET saldoInterOrdin     := 0.00;
	SET saldoInterAtras     := 0.00;
	SET saldoInterVenc      := 0.00;
	SET saldoInterProvi     := 0.00;
	SET saldoIVAInteres     := 0.00;
	SET saldoMoratorios     := 0.00;
	SET saldoIVAMorator     := 0.00;
	SET saldComFaltPago     := 0.00;
	SET salIVAComFalPag     := 0.00;
	SET saldoComServGar     := 0.00;
	SET saldoIVAComSerGar   := 0.00;
	SET saldoOtrasComis     := 0.00;
	SET saldoIVAComisi      := 0.00;
	SET CreRenovacion		:= 'O';
	SET Constante_NO		:= 'N';			-- Constante NO
	SET Constante_SI		:= 'S';			-- Constante SI
	SET TipoSpei            := 'S';         -- tipoDIspersionSPEI
	SET Con_EstatusNomina	:= 'A';
	SET Con_DevengaNomina	:= 'S';
    SET Est_Bloqueado       := 'B';         -- Estatus Linea Bloqueada
    SET EstLinea_Vencido    := 'E';         -- Estatus Linea Vencida

	SET Num_PagRegula		:= 3;  			-- Numero de pagos sostenidos requerido segun CNBV
	SET Estatus_Alta		:= 'A';			-- Estatus de Alta para la renovacion
	SET Estatus_Pagado		:= 'P';			-- Estatus pagado
	SET OrigenRenovacion	:= 'O';			-- Indica que es un credito renovacion en la tabla de reestructuras
	SET Est_Vigente			:= 'V';			-- Estatus vigente
	SET Est_Vencido			:= 'B';			-- Estatus vencido
	SET Est_Cancela			:= 'C';			-- Estatus cancelado
	SET Est_Desembolso		:= 'D';			-- Estatus desembolsado
	SET PersonaCliente		:= 'C';			-- Tipo de persona: cliente
	SET Entero_Uno			:= 1;
    SET Est_AutorizaGar		:= 'U';			-- Estatus Autorizado de Garantia
	#COMISION ANUAL
	SET TipoCalMontoComAnual	:= 'M';			# Base de Calculo por Monto para comision por anualidad
	SET TipoCalPorcenComAnual	:= 'P';			# Base de Calculo por Porcentaje para comision por anualidad
	#FIN COMISION ANUAL

	SET LlaveCobraAccesorios	:= 'CobraAccesorios';	-- Llave que indica el cobro Accesorios
	SET ProgramaGrupal			:= '/microfin/creditoGrupalCatalogoVista.htm';
	SET TipoMontoIguales		:= 'I';
	SET TipoMontoDiasTrans		:= 'D';
	SET TipoCalculoMontoOriginal := 2;
	SET LlaveGarFinanciada		:= 'CobraGarantiaFinanciada';
	SET	Per_Moral				:= 'M';
    SET Per_Emp					:= 'A';
	SET Per_Fisica				:= 'F';
	SET Var_NumIntentos			:= 3;
	SET Var_CuotaCompProyectada	:= 'P';
	SET Act_NumCredito			:= 3;				-- Actualizacion de Numero de Credito
	SET Con_Deduccion			:= 'D';
	SET Con_Financiado			:= 'F';
	SET Con_DecimalCien			:= 100.00;
	SET Tip_Disposicion			:= 'D';
	SET Tip_Total				:= 'T';
	SET Tip_Cuota				:= 'C';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Par_NumErr          := Entero_Cero;
		SET Par_ErrMen          := Cadena_Vacia;
		SET NumCreditoID        := Entero_Cero;
		SET Verifica            := 0;
		SET Var_i               := 1;
		SET Var_j               := 5;
		SET Var_NomControl      := 'creditoID';
		SET Huella_SI			:="S";
		SET MenorEdad			:='S';
        SET Var_DestinoCre		:=Entero_Cero;
        SET Var_SalCredAnt      :=0.0;

        # Destino de Credito
        SET Var_DestinoCre:=(SELECT ProductoCreditoID
                            FROM DESTINOSCREDPROD
                            WHERE ProductoCreditoID = Par_ProduCredID
                            AND DestinoCreID = Par_DestinoCreID);

        SET Var_DestinoCre		:=IFNULL(Var_DestinoCre,Entero_Cero);
		SET Var_MontoComAp 		:= Par_MonComApe;
        SET Var_MontoIVAComAp 	:= Par_IVAComApe;
        SET Var_MontoComAp		:= IFNULL(Var_MontoComAp,Decimal_Cero);
		SET Var_MontoIVAComAp	:= IFNULL(Var_MontoIVAComAp,Decimal_Cero);

		SELECT 	SaldoCapContable,	FuncionHuella,		ReqHuellaProductos,		FechaSistema INTO
				Var_SalCapConta,	Var_FuncionHuella,	Var_ReqHuellaProductos,	Var_FechaSistema
		FROM PARAMETROSSIS;

		SELECT Estatus, TipoPersona INTO Var_EstatusCliente,Var_TipoPersona
		FROM CLIENTES WHERE ClienteID=Par_ClienteID;

		SET Var_SalCapConta := IFNULL(Var_SalCapConta, Entero_Cero);

		SELECT DiaPagoCapital  INTO  Var_DiaPagoProd FROM CALENDARIOPROD WHERE ProductoCreditoID = Par_ProduCredID;

        -- Seccion para validar que la solicitud exista
        SELECT SolicitudCreditoID, ConvenioNominaID,ClabeCtaDomici,InstitucionNominaID, FlujoOrigen, EsConsolidado,
        	EsConsolidacionAgro
        INTO Var_NumSolicitud, Var_ConvenioNominaID,Var_ClabeCtaDomici, Var_InstitucionNominaID, Var_FlujoOrigen, Var_EsConsolidado,
        	Var_EsConsolidacionAgro
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;

        SET Var_NumSolicitud := IFNULL(Var_NumSolicitud , Entero_Cero);
        SET Var_ClabeCtaDomici := IFNULL(Var_ClabeCtaDomici , Cadena_Vacia);
        SET Var_ConvenioNominaID := IFNULL(Var_ConvenioNominaID , Entero_Cero);
        SET Var_InstitucionNominaID := IFNULL(Var_InstitucionNominaID, Entero_cero);
		SET Var_EsConsolidacionAgro := IFNULL(Var_EsConsolidacionAgro, Constante_NO);

        SELECT ValorParametro INTO Var_ParamCobraAcc FROM PARAMGENERALES WHERE LlaveParametro = LlaveCobraAccesorios;
        /* Se valida que exista la solicitud*/
		SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
		SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);
        IF(Var_NumSolicitud = Entero_Cero  )THEN
			SET Par_NumErr      := 24;
			SET Par_ErrMen      := 'No existe la Solicitud de Credito.';
			SET Var_NomControl  := 'solicitudID';
			LEAVE ManejoErrores;
		END IF;

        SELECT CreditoID INTO Var_NumCredito
			FROM CREDITOS
			WHERE SolicitudCreditoID = Par_SolicCredID;

        SET Var_NumCredito := IFNULL(Var_NumCredito , Entero_Cero);

        IF( Var_NumCredito <> Entero_Cero)THEN
			SET Par_NumErr      := 25;
			SET Par_ErrMen      := CONCAT("La solicitud de Credito ya esta asociada al Credito ", Var_NumCredito);
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCliente= Estatus_Inactivo) THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'El safilocale.cliente Indicado se Encuentra Inactivo.';
			SET Var_NomControl  := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_FuncionHuella = Huella_SI AND Var_ReqHuellaProductos = Huella_SI) THEN
			IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona= PersonaCliente AND Hue.PersonaID=Par_ClienteID )THEN
				SET Par_NumErr      := 2;
				SET Par_ErrMen      := 'El safilocale.cliente No tiene Huella Registrada.';
				SET Var_NomControl  := 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SELECT
			ManejaLinea, 			TipoPagoSeguro, 			ForCobroComAper, 		ValidaCapConta, 		PorcMaxCapConta,
			CobraSeguroCuota, 		CobraIVASeguroCuota,		TipoComXapert,			MontoComXapert,
			DiasAtrasoMin,			CobraAccesorios,			TipoGeneraInteres
			INTO
			Var_ManejaLinea,  		Var_TipPagoSeg, 			Var_TipPagComAp, 		Var_ValidaCapConta, 	Var_PorcMaxCapConta,
			Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_TipoComXApertura,	Var_MontoComXApertura,
			Var_DiasAtrasoMin,		Var_CobraAccesorios,		Var_TipoGeneraInteres
		FROM PRODUCTOSCREDITO
		WHERE	 ProducCreditoID = Par_ProduCredID;

			#Validaciones de esquemas para comision apertura y mora por convneio de nómina
			SET Var_MoraPorConvenio := 0;
			IF(Var_InstitucionNominaID > Entero_Cero AND Var_ConvenioNominaID > Entero_Cero) THEN

			#Verifica si el convenio cobra comisión por apertura e interes moratorio;
				SELECT CobraComisionApert,CobraMora INTO Var_NCobraComAper,Var_NCobraMora FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Var_ConvenioNominaID;
			#Busca esquemas configurados para comision apertura
				IF(Var_NCobraComAper = 'S') THEN

					SELECT 	EsqComApertID,		ManejaEsqConvenio
					INTO 	Var_NEsqComApertID,	Var_NManejaEsqConvenio
					FROM 	ESQCOMAPERNOMINA
					WHERE 	InstitNominaID 		= Var_InstitucionNominaID
					AND		ProducCreditoID		= Par_ProduCredID
					LIMIT 1;

					IF(Var_NManejaEsqConvenio = 'S') THEN
						SELECT 		FormCobroComAper,			TipoComApert,			Valor
						INTO 		Var_NFormCobroComAper,		Var_NTipoComApert,		Var_NValor
						FROM	COMAPERTCONVENIO
						WHERE		EsqComApertID = Var_NEsqComApertID
						AND		(ConvenioNominaID = Var_ConvenioNominaID OR ConvenioNominaID = Entero_Cero)
						AND 	PlazoID = Par_Plazo
						AND		MontoMin <= Par_MontoCredito
						AND		MontoMax >= Par_MontoCredito LIMIT 1;

						IF( IFNULL(Var_NFormCobroComAper, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NTipoComApert, Cadena_Vacia) = Cadena_Vacia) THEN
									SET Par_NumErr	:= 051;
									SET Par_ErrMen	:= 'No existe esquema configurado para comisión por apertura, empresa-convenio-plazo-monto';
									SET Var_Control	:= 'plazoID';
									LEAVE ManejoErrores;
						ELSE
							SET Var_TipoComXApertura := Var_NTipoComApert;
							SET Var_TipPagComAp := Var_NFormCobroComAper;
							SET Var_MontoComXApertura := Var_NValor;
						END IF;
					END IF;

				END IF;
			#Busca esquemaa configurado para cobro Mora
				IF(Var_NCobraMora = 'S') THEN
					SELECT		TipoCobMora,		ValorMora
					INTO		Var_NTipoCobMora,	Var_NValorMora
					FROM 	NOMCONDICIONCRED
					WHERE 	InstitNominaID 		= Var_InstitucionNominaID
					AND 	ConvenioNominaID 	= Var_ConvenioNominaID
					AND		ProducCreditoID		= Par_ProduCredID
					LIMIT	1;
					IF( IFNULL(Var_NTipoCobMora, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NValorMora, Decimal_Cero) = Decimal_Cero) THEN
						SET Par_NumErr	:= 052;
						SET Par_ErrMen	:= 'No existe esquema configurado para cobro mora, empresa-producto-convenio';
						SET Var_Control	:= 'convenioNominaID';
						LEAVE ManejoErrores;
					ELSE
                        SET Var_TipCobComMorato     := Var_NTipoCobMora;
						SET Par_FactorMora          := Var_NValorMora;
						SET Var_MoraPorConvenio 	:= 1;
					END IF;
				END IF;
			END IF;

		SET Var_ValidaCapConta  := IFNULL(Var_ValidaCapConta, Cadena_Vacia);
		SET Var_PorcMaxCapConta := IFNULL(Var_PorcMaxCapConta, Entero_Cero);
		SET Var_CicloGrupo  	:= Entero_Cero;
		SET Var_GrupoID     	:= Entero_Cero;
		SET Var_TipoComXApertura  	:= IFNULL(Var_TipoComXApertura, Cadena_Vacia);
		SET Var_MontoComXApertura	:= IFNULL(Var_MontoComXApertura, Entero_Cero);

        -- INICIO VALIDACION PERSONAS NO DESEADAS
		SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Constante_NO);
        IF(Var_DetecNoDeseada = Constante_SI) THEN
			IF(Var_TipoPersona = Per_Moral) THEN
				SELECT 	Cli.RFCpm
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Par_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;

			IF(Var_TipoPersona = Per_Fisica OR Var_TipoPersona = Per_Emp ) THEN
				SELECT 	Cli.RFC
				INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
				WHERE 	Cli.ClienteID 	= Par_ClienteID
				AND		Suc.SucursalID 	= Cli.SucursalOrigen;
			END IF;

			CALL PLDDETECPERSNODESEADASPRO(
				Entero_Cero,	Var_RFCOficial,	Var_TipoPersona,	SalidaNO,	Par_NumErr,
                Par_ErrMen,				Par_empresa,				Par_Usuario,	Par_FechaActual,
                Par_DireccionIP,		Par_ProgramaID,				Par_SucursalID,	Par_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- FIN VALIDACION PERSONAS NO DESEADAS
		# SEGUROS ----------------------------------------------------------------
		SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota, Constante_NO);
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota,Constante_NO);
		SET Var_CobraAccesorios		:= IFNULL(Var_CobraAccesorios, Constante_NO);



		IF(Par_SolicCredID != Entero_Cero)THEN
			SELECT Sol.ForCobroComAper, 	Sol.ForCobroSegVida, 	Sol.MontoSeguroVida, 	Sol.GrupoID ,
					TipoLiquidacion,		CantidadPagar,			InvCredAut,				CtaCredAut,
                    EsAutomatico,			TipoAutomatico,			Reacreditado
			INTO   Var_TipPagComAp, 		Var_TipPagoSeg, 		Var_SolSegVida, 		Var_GrupoID,
					Var_TipoLiquidacion,	Var_CantidadPagar,		Var_InvCredAut,			Var_CtaCredAut,
					Var_EsAutomatico,		Var_TipoAutomatico,		Var_Reacreditado
			FROM SOLICITUDCREDITO Sol
			WHERE Sol.SolicitudCreditoID = Par_SolicCredID;



			SET Var_TipPagComAp 	:= IFNULL(Var_TipPagComAp, Cadena_Vacia);
			SET Var_TipPagoSeg 		:= IFNULL(Var_TipPagoSeg, Cadena_Vacia);
			SET Var_SolSegVida		:= IFNULL(Var_SolSegVida, Entero_Cero);
			SET Var_GrupoID    		:= IFNULL(Var_GrupoID, Entero_Cero);
            SET Var_InvCredAut		:= IFNULL(Var_InvCredAut, Entero_Cero);
            SET Var_CtaCredAut		:= IFNULL(Var_CtaCredAut, Entero_Cero);
			SET Var_Reacreditado	:= IFNULL(Var_Reacreditado, Constante_NO);

			CALL VALIDAPRODCREDPRO (
				Entero_Cero,        Par_SolicCredID,    TipoValiAltaCre,    SalidaNO,           Par_NumErr,
				Par_ErrMen,         Par_empresa,        Par_Usuario,        Par_FechaActual,    Par_DireccionIP,
				Par_ProgramaID,     Par_SucursalID,     Par_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_GrupoID != Entero_Cero) THEN
				SELECT Gru.CicloActual INTO Var_CicloGrupo
				FROM GRUPOSCREDITO Gru
				WHERE Gru.GrupoID = Var_GrupoID;

				SET Var_CicloGrupo  := IFNULL(Var_CicloGrupo, Entero_Cero);
			END IF;

		END IF; -- Termina: IF(Par_SolicCredID != Entero_Cero)THEN

		SELECT MonedaID,	Estatus INTO Var_MonedaCta,		Var_EstatusCta
		FROM CUENTASAHO
		WHERE   ClienteID   = Par_ClienteID
		  AND   CuentaAhoID = Par_CuentaID;
		SET Var_EstatusCta := IFNULL(Var_EstatusCta,Cadena_Vacia);

		IF(IFNULL(Par_SucursalID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'El Numero de Sucursal esta Vacio.' ;
			SET Var_NomControl  := 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClienteID, Entero_Cero)= Entero_Cero ) THEN
			SET Par_NumErr      := 4;
			SET Par_ErrMen      := 'El Numero de safilocale.cliente esta Vacio.';
			SET Var_NomControl  := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_LinCreditoID := IFNULL(Par_LinCreditoID, Entero_Cero);

		IF( Par_LinCreditoID <> Entero_Cero ) THEN
			SELECT	LineaCreditoID,		EsAgropecuario,      Estatus
			INTO	Var_LineaCreditoID,	Var_EsAgropecuario,    Var_EstatusLinea
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LinCreditoID;

			IF( IFNULL(Var_LineaCreditoID , Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr		:= 5;
				SET Par_ErrMen		:= 'La Linea de credito no Existe.';
				SET Var_NomControl	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

            IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
                SET Par_NumErr  := 067;
                SET Par_ErrMen  := 'La Linea de Credito se encuentra Bloqueada/Vencida.';
                SET Var_Control := 'lineaCreditoID';
                LEAVE ManejoErrores;
            END IF;


			SET Var_EsAgropecuario := IFNULL(Var_EsAgropecuario, Constante_NO);
		END IF;

		IF(Var_ManejaLinea = SiManejaLinea)THEN

			IF( Par_LinCreditoID != Entero_Cero AND Var_EsAgropecuario = Constante_NO ) THEN
				SELECT IFNULL(FechaVencimiento,Cadena_Vacia), IFNULL(FechaInicio,Cadena_Vacia),
					   IFNULL(ClienteID,Entero_Cero),   Estatus
				INTO FechaTermLin,    FechaIniLin,    Var_Cliente,   Var_EstatusLinea
				FROM LINEASCREDITO
				WHERE LineaCreditoID= Par_LinCreditoID;

				IF(Par_FechaVencim > FechaTermLin)THEN
					SET Par_NumErr      := 5;
					SET Par_ErrMen      := 'El Credito No esta Dentro de la Vigencia de la Linea.';
					SET Var_NomControl  := 'fechaVencimien';
					LEAVE ManejoErrores;
				END IF;
				IF(Par_FechaInicio < FechaIniLin) THEN
					SET Par_NumErr      := 6;
					SET Par_ErrMen      := 'El Credito No esta Dentro de la Vigencia de la Linea.';
					SET Var_NomControl  := 'fechaVencimien';
					LEAVE ManejoErrores;
				END IF;
				IF(Var_Cliente != Par_ClienteID)THEN
					SET Par_NumErr      := 7;
					SET Par_ErrMen      :='La Linea No Corresponde al safilocale.cliente.' ;
					SET Var_NomControl  := 'lineaCreditoID';
					LEAVE ManejoErrores;
				END IF;

                IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
                    SET Par_NumErr  := 068;
                    SET Par_ErrMen  := 'La Linea de Credito se encuentra Bloqueada/Vencida.';
                    SET Var_Control := 'lineaCreditoID';
                    LEAVE ManejoErrores;
                END IF;

			END IF;
		END IF; -- Fin de la validacion de linea de credito


		IF(Var_MonedaCta <> Par_MonedaID )THEN
			SET Par_NumErr      := 8;
			SET Par_ErrMen      :='La Moneda de la Cuenta es Diferente de la Moneda del Credito.'  ;
			SET Var_NomControl  := 'monedaID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CuentaID, Entero_Cero)= Entero_Cero) THEN
			SET Par_NumErr      := 9;
			SET Par_ErrMen      :='El Numero de Cuenta esta Vacio.';
			SET Var_NomControl  := 'cuentaID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_TipoFondeo  := IFNULL(Par_TipoFondeo, Cadena_Vacia);
		IF (Par_TipoFondeo = Rec_Fondeo) THEN
			SELECT  Ins.Estatus, Lin.SaldoLinea INTO Var_EstFondeo, Var_SaldoFondo
			FROM INSTITUTFONDEO Ins, LINEAFONDEADOR Lin
			WHERE   Ins.InstitutFondID  = Lin.InstitutFondID
			  AND   Ins.InstitutFondID  = Par_InstitFondeoID
			  AND   Lin.LineaFondeoID   = Par_LineaFondeo;

			SET Var_EstFondeo   := IFNULL(Var_EstFondeo, Cadena_Vacia);
			SET Var_SaldoFondo  := IFNULL(Var_SaldoFondo, Entero_Cero);

			IF (Var_EstFondeo != Estatus_Activo) THEN
				SET Par_NumErr := 10;
				SET	Par_ErrMen :='La Institucion de Fondeo No Existe o No esta Activa.' ;
				SET Var_NomControl  := 'institFondeoID';
				LEAVE ManejoErrores;
			END IF;
			IF (Var_SaldoFondo < Par_MontoCredito) THEN
				SET Par_NumErr      := 11;
				SET Par_ErrMen      :='Saldo de la Linea de Fondeo Insuficiente.' ;
				SET Var_NomControl  := 'institFondeoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Validacion que la Solicitud no Exceda el Capital Contable
        SELECT Mensaje INTO Var_Mensaje
			FROM OPERCAPITALNETO
			WHERE InstrumentoID = Par_SolicCredID
			AND OrigenOperacion = "S"
			AND PantallaOrigen  = "AS"
            AND EstatusOper !="A"
		LIMIT 1;
		SET Var_Mensaje := IFNULL(Var_Mensaje, Cadena_Vacia);

		IF(Var_ValidaCapConta = Si_ValidaCapConta AND Var_PorcMaxCapConta > Entero_Cero AND Var_Mensaje!=Cadena_Vacia) THEN
			SET Par_NumErr      := 012;
			SET Par_ErrMen      := Var_Mensaje;
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusCta != Estatus_Activo )THEN
			SET Par_NumErr      := 14;
			SET Par_ErrMen      := CONCAT('La Cuenta ',CONVERT(Par_CuentaID, CHAR),' No se Encuentra Vigente.' );
			SET Var_NomControl  := 'cuentaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TPagCapital = PagoCreciente) THEN
			SET Par_NumAmortInt :=  Par_NumAmortiza;
		END IF;

		IF(Par_TPagCapital = Var_TipPagCapL) THEN
			SET VarSumaCapital := (SELECT SUM(Tmp_Capital)  FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransacSim);
			SET VarSumaCapital := IFNULL(VarSumaCapital, Decimal_Cero);
			IF( VarSumaCapital != Par_MontoCredito )THEN
				SET Par_NumErr      := 15;
				SET Par_ErrMen      := 'Simule o Calcule Amortizaciones Nuevamente.';
				SET Var_NomControl  := 'simular';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- valida que el cliente no sea menor de edad
				IF EXISTS (SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID
					AND EsMenorEdad = MenorEdad)THEN
								SET Par_NumErr      := 16;
								SET Par_ErrMen      :='El safilocale.cliente es Menor, No es Posible Asignar Credito.' ;
								SET Var_NomControl  := 'clienteID';
								LEAVE ManejoErrores;
				END IF;

		-- Realiza las validacion para la Garantia Liquida
		SET Var_RequiereGL		:= (SELECT IFNULL(Garantizado,No_Asignada) FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProduCredID);

		# si el producto de credito no requiere GL, guardara ceros
		IF(Var_RequiereGL = No_Asignada)THEN
			SET	Var_PorcGarLiq	:= Decimal_Cero;
			SET Par_AportaCliente := Decimal_Cero;
		ELSE
			SET Var_CalificaCredito  :=(SELECT IFNULL(CalificaCredito,No_Asignada) FROM CLIENTES WHERE ClienteID = Par_ClienteID);
			SELECT Porcentaje
				FROM ESQUEMAGARANTIALIQ
				WHERE Clasificacion = Var_CalificaCredito
					AND ProducCreditoID = Par_ProduCredID
					AND Par_MontoCredito BETWEEN LimiteInferior AND LimiteSuperior
				LIMIT 1
			INTO Var_PorcGarLiq;
			SET Par_AportaCliente :=  ROUND((Par_MontoCredito * Var_PorcGarLiq) / 100,2);

		END IF;

		IF(IFNULL(Par_FechaInicioAmor, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr      := 19;
			SET Par_ErrMen      := 'Especifique la Fecha de Inicio de Amortizaciones.';
			SET Var_NomControl  := 'fechaInicioAmor';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT CreditoID FROM CREDITOS
					WHERE SolicitudCreditoID= Par_SolicCredID AND Par_SolicCredID > Entero_Cero
						AND Estatus != Estatus_Cancelado) THEN
			SET Par_NumErr      := 20;
			SET Par_ErrMen      := 'La Solicitud de Credito Indicada esta Relacionada a Otro Credito.';
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCredito, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr      := 21;
			SET Par_ErrMen      := 'Especifique el Tipo de Credito.';
			SET Var_NomControl  := 'tipoCredito';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_DestinoCre=Cadena_Vacia)THEN
            SET Par_NumErr	= 22;
            SET	Par_ErrMen	= 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion.';
            SET Var_NomControl  := 'destinoCreID';
            LEAVE ManejoErrores;
        END IF;

	  IF(Par_Plazo = Cadena_Vacia )THEN
			SET Par_NumErr      := 23;
			SET Par_ErrMen      := CONCAT('Especifique el Plazo del Credito.' );
			SET Var_NomControl  := 'plazoID';
			LEAVE ManejoErrores;
		END IF;

       	/**VALIDACION PARA COBRO POR SEGURO POR CUOTA**/
		IF(Var_CobraSeguroCuota = 'S') THEN
			SET Var_MontoSeguroCuota :=(SELECT Monto
						FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
							CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
							WHERE ProducCreditoID = Par_ProduCredID
							AND Frecuencia IN(Par_FrecuencCap, Par_FrecuencInt) ORDER BY Dias ASC LIMIT 1);

		    IF(IFNULL(Var_MontoSeguroCuota,Entero_Cero) = Entero_Cero) THEN
		        SET Par_NumErr  := 040;
		        SET Par_ErrMen  := 'El Monto por Seguro por Cuota esta Vacio.' ;
		        SET Var_Control := 'frecuenciaCap';
		        LEAVE ManejoErrores;
		      ELSE
		        IF(IFNULL(Var_CobraIVASeguroCuota,'N') = 'S') THEN
		            SET Var_IVA       := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
		            SET Var_IVASeguroCuota :=  ROUND(Var_MontoSeguroCuota * Var_IVA,2);
		        ELSE
		            SET Var_IVASeguroCuota := Entero_Cero;
		        END IF;
		    END IF;
		  ELSE
		        SET Var_MontoSeguroCuota := Entero_Cero;
		        SET Var_IVASeguroCuota := Entero_Cero;
		END IF;
		/**fin VALIDACION PARA COBRO POR SEGURO POR CUOTA**/


		IF(IFNULL(Par_MontoSegVida, Decimal_Cero) > Decimal_Cero) THEN
			SET Par_MontoSegOri	:= ROUND(Par_MontoSegVida / (1 - (Par_DescSeguro / 100)), 2);
		END IF;

		CALL FOLIOSSUCAPLICACT('CREDITOS', Par_SucursalID, consecutivo);

		SET NumCredito := CONCAT((SELECT LPAD(Par_SucursalID,3,0)),(SELECT LPAD(consecutivo,7,0)));

		WHILE Var_i <= 10 DO
			SET Verifica :=  Verifica +  (CONVERT((SUBSTRING(NumCredito,Var_i,1)),UNSIGNED INT) * Var_j);
			SET Var_j := Var_j - 1;
		    SET Var_i := Var_i + 1;
			IF (Var_j = 1) THEN
				SET Var_j := 7;
			END IF;
		END WHILE;

		SET Modulo2 := Verifica % 11;

		IF (Modulo2 = 0)THEN
			SET Verifica = 1;
		ELSE
			IF (Modulo2 = 1) THEN
				SET Verifica = 0;
			ELSE
				SET Verifica = 11 - Modulo2;
			END IF;
		END IF;

		SET NumVerificador := LTRIM(RTRIM(CONVERT(Verifica, CHAR)));
		SET NumCreditoID := CONCAT(NumCredito,NumVerificador);

		SET Par_FechaActual := CURRENT_TIMESTAMP();

		IF(Par_SolicCredID <> 0) THEN
			IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502) THEN
				UPDATE SOLICITUDCREDITO SET
					CreditoID = NumCreditoID
				WHERE SolicitudCreditoID = Par_SolicCredID;
			END IF;

			IF( Par_NumErr != Entero_Cero AND Par_NumErr != 502) THEN
				LEAVE ManejoErrores;
			 END IF;

			IF(Var_SolSegVida  != Entero_Cero) THEN
				UPDATE SEGUROVIDA SET
					CreditoID   = NumCreditoID,
					CuentaID    = Par_CuentaID
				WHERE SolicitudCreditoID = Par_SolicCredID;
			END IF;

		END IF;
		/** VALIDACION PARA COMISION ANUAL **/
		SELECT
			CobraComision,					TipoComision,				BaseCalculo,				MontoComision,				PorcentajeComision,
			DiasGracia
		INTO
			Var_CobraComisionComAnual,		Var_TipoComisionComAnual,	Var_BaseCalculoComAnual,	Var_MontoComisionComAnual,	Var_PorcentajeComisionComAnual,
			Var_DiasGraciaComAnual
		FROM ESQUEMACOMANUAL
				WHERE ProducCreditoID = Par_ProduCredID;

		SET Var_CobraComisionComAnual		:= IFNULL(Var_CobraComisionComAnual, Constante_NO);
		SET Var_TipoComisionComAnual		:= IFNULL(Var_TipoComisionComAnual, Cadena_Vacia);
		SET Var_BaseCalculoComAnual			:= IFNULL(Var_BaseCalculoComAnual, Cadena_Vacia);
		SET Var_MontoComisionComAnual		:= IFNULL(Var_MontoComisionComAnual, Entero_Cero);
		SET Var_PorcentajeComisionComAnual	:= IFNULL(Var_PorcentajeComisionComAnual, Decimal_Cero);
		SET Var_DiasGraciaComAnual			:= IFNULL(Var_DiasGraciaComAnual, Entero_Cero);

		IF(Var_CobraComisionComAnual = Constante_SI) THEN
			IF(Var_TipoComisionComAnual = Cadena_Vacia) THEN
				SET Par_NumErr  := 041;
				SET Par_ErrMen  := 'El Tipo de Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
				SET Var_NomControl := 'agregar';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_TipoComisionComAnual = TipoCalPorcenComAnual AND Var_BaseCalculoComAnual = Cadena_Vacia) THEN
				SET Par_NumErr  := 042;
				SET Par_ErrMen  := 'La Base de Calculo por Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
				SET Var_NomControl := 'agregar';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_TipoComisionComAnual = TipoCalMontoComAnual AND Var_MontoComisionComAnual = Entero_Cero) THEN
				SET Par_NumErr  := 043;
				SET Par_ErrMen  := CONCAT('El Monto para la Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.') ;
				SET Var_NomControl := 'agregar';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_TipoComisionComAnual = TipoCalPorcenComAnual AND Var_PorcentajeComisionComAnual = Entero_Cero) THEN
				SET Par_NumErr  := 044;
				SET Par_ErrMen  := 'El Porcentaje para la Comision por Anualidad esta Vacio, Revise la Parametrizacion del Producto.' ;
				SET Var_NomControl := 'agregar';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Var_RequiereReferencia	:=(SELECT ValorParametro
											FROM PARAMGENERALES WHERE LlaveParametro = 'PagosXReferencia');
		SET Par_ReferenciaPago		:= IFNULL(Par_ReferenciaPago, Cadena_Vacia);

        IF(Par_ProgramaID <> ProgramaGrupal) THEN
			IF(Var_RequiereReferencia = 'S') THEN
				IF(Var_CicloGrupo> Entero_Cero) THEN
					SET Var_ReferenciaGrupo := (SELECT ReferenciaPago
													FROM CREDITOS AS CRED WHERE GrupoID = Var_GrupoID AND CicloGrupo = Var_CicloGrupo LIMIT 1);
					SET Var_ReferenciaGrupo := IFNULL(Var_ReferenciaGrupo, Cadena_Vacia);
					IF(Var_ReferenciaGrupo!=Cadena_Vacia)THEN
						SET Par_ReferenciaPago := Var_ReferenciaGrupo;
					END IF;
				 ELSE
					IF EXISTS(SELECT ReferenciaPago FROM CREDITOS WHERE ReferenciaPago = Par_ReferenciaPago) THEN
						SET Par_NumErr  := 046;
						SET Par_ErrMen  := 'La Referencia ya Existe asiganda a otro Credito.' ;
						SET Var_NomControl := 'referenciaPago';
						SET Var_Consecutivo := '';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Var_RequiereReferencia = Constante_SI AND Par_ReferenciaPago = Cadena_Vacia ) THEN
				SET Par_NumErr  := 045;
				SET Par_ErrMen  := 'La Referencia se encuentra Vacia.' ;
				SET Var_NomControl := 'referenciaPago';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_TipoCalInt := IFNULL(Par_TipoCalInt, Entero_Cero);

		IF( IFNULL(Par_TipoCalInt, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 046;
			SET Par_ErrMen	:= 'Especifique el Tipo de Calculo de Interes.';
			SET Var_Control	:= 'tipoCalInteres';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoCalInt = TipoCalculoMontoOriginal) THEN

			-- Validacion si el Tipo de Calculo es Monto Original
			IF( Var_TipoGeneraInteres = Cadena_Vacia)THEN
				SET Par_NumErr	:= 047;
				SET Par_ErrMen	:= 'Especifique el Tipo de Generacion de Interes ';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para verificar que el tipo de Calculo sea lo parametrizado
			IF( Var_TipoGeneraInteres NOT IN (TipoMontoIguales, TipoMontoDiasTrans) )THEN
				SET Par_NumErr	:= 048;
				SET Par_ErrMen	:= 'Especifique un Tipo de Generacion de Interes valido';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- ===================== Validación si requiere documentos adjuntos de servicios adicionales
		-- Inicio validación servicios adicionales en caso de tenerlos
		SELECT AplicaDescServicio INTO Var_AplicaDescServicio
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;
		IF Var_AplicaDescServicio = Constante_SI THEN
		-- Obtener los Documentos que son requeridos y aun no se adjuntan
			SELECT 	sad.Descripcion,
					sad.ValidaDocs,
					tdo.Descripcion,
					CASE WHEN sar.DigSolID IS NULL
							THEN Constante_NO
							ELSE Constante_SI
					END AS Adjuntado
				INTO	Var_ServicioDesc,	Var_ValidaDocs,	Var_DocDesc,	Var_Adjuntado
			FROM SERVICIOSXSOLCRED  ssc
				INNER JOIN SERVICIOSADICIONALES sad on ssc.ServicioID = sad.ServicioID
					INNER JOIN TIPOSDOCUMENTOS as tdo on sad.TipoDocumento = tdo.TipoDocumentoID
						LEFT JOIN SOLICITUDARCHIVOS sar on ssc.SolicitudCreditoID = sar.SolicitudCreditoID
						AND tdo.TipoDocumentoID = sar.TipoDocumentoID
			WHERE sad.ValidaDocs 		= Constante_SI
			  AND sar.DigSolID 			IS NULL  -- Sin adjuntar el documento
			  AND ssc.SolicitudCreditoID = Par_SolicCredID
			  LIMIT 1;

			-- Verificamos que este adjunto
			IF Var_Adjuntado = Constante_NO THEN
				SET Par_NumErr := 112;
				SET Par_ErrMen := CONCAT('No se ha adjuntado el documento ', Var_DocDesc ,' requerido para validar el Servicios Adicional ', Var_ServicioDesc, '.');
				SET Var_Control:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- Fin validación servicios adicionales en caso de tenerlos

		SET Var_NivelID := (SELECT NivelID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicCredID);
		SET Var_NivelID := IFNULL(Var_NivelID,Entero_Cero);

		-- Se ajusta el parametro de TipoCalInteres para alta de Creditos desde el Web Service de alta de creditos para Pluriza
		-- endPoint "registrationCreditMilagro/registrationCreditMilagro"
		IF(Par_ProgramaID = 'CreditosTransacDAO.creditosAlt') THEN
            SELECT TipoCalInteres
                INTO Par_TipoCalInt
                FROM SOLICITUDCREDITO
                WHERE SolicitudCreditoID = Par_SolicCredID;
		END IF;

		SET Var_CuentaClabe := Par_CuentaCABLE;


		-- Validacion para el Tipo de Prepago de Proyecciones Completas
		IF(Par_TipoPrepago = Var_CuotaCompProyectada) THEN
			SET Var_PermitePrepago := (SELECT PermitePrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProduCredID);
			SET Var_PermitePrepago := IFNULL(Var_PermitePrepago, Constante_NO);

			IF(Var_PermitePrepago != Constante_SI OR Par_TipoCalInt != TipoCalculoMontoOriginal) THEN
				SET Par_NumErr      := 51;
				SET Par_ErrMen      := 'El valor asignado para Tipo de Prepago es Incorrecto, solo Aplica para Saldos Globales';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/** FIN VALIDACION PARA COMISION ANUAL **/
		IF( Var_MoraPorConvenio = 0 ) THEN
			SET Var_TipCobComMorato := (SELECT TipCobComMorato FROM PRODUCTOSCREDITO WHERE  ProducCreditoID =Par_ProduCredID);
		END IF;

		-- Seccion de validacion para lineas de credito agro
		IF( Par_LinCreditoID <> Entero_Cero AND Var_EsAgropecuario = Constante_SI ) THEN

			SELECT	LineaCreditoID,			SaldoDisponible,		FechaVencimiento,		ClienteID,		Autorizado,
                    Estatus
			INTO	Var_LineaCreditoID,		Var_SaldoDisponible,	Var_FechaVencimiento,	Var_Cliente,	Var_AutorizadoLinea,
                    Var_EstatusLinea
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LinCreditoID
			  AND Estatus = Estatus_Activo
			  AND EsAgropecuario = Constante_SI;

			SELECT	ManejaComAdmon,			ComAdmonLinPrevLiq,			ForCobComAdmon,			ForPagComAdmon,			PorcentajeComAdmon,
					ManejaComGarantia,		ComGarLinPrevLiq,			ForCobComGarantia,		ForPagComGarantia,		PorcentajeComGarantia,
					FechaInicio
			INTO	Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,		Var_ForPagComAdmon,		Var_PorcentajeComAdmon,
					Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,	Var_ForPagComGarantia,	Var_PorcentajeComGarantia,
					Var_FechaInicioLinea
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicCredID;

			SELECT PagaIVA
			INTO 	Var_PagaIVA
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

			SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);
			SET Var_SaldoDisponible		:= IFNULL(Var_SaldoDisponible, Decimal_Cero);
			SET Var_FechaVencimiento	:= IFNULL(Var_FechaVencimiento, Var_FechaSistema);
			SET Var_PagaIVA				:= IFNULL(Var_PagaIVA, Constante_NO);

			SET Var_ManejaComAdmon		:= IFNULL(Var_ManejaComAdmon, Constante_NO);
			SET Var_ComAdmonLinPrevLiq	:= IFNULL(Var_ComAdmonLinPrevLiq, Constante_NO);
			SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
			SET Var_ForPagComAdmon		:= IFNULL(Var_ForPagComAdmon, Cadena_Vacia);
			SET Var_PorcentajeComAdmon	:= IFNULL(Var_PorcentajeComAdmon, Decimal_Cero);

			SET Var_ManejaComGarantia		:= IFNULL(Var_ManejaComGarantia, Constante_NO);
			SET Var_ComGarLinPrevLiq		:= IFNULL(Var_ComGarLinPrevLiq, Constante_NO);
			SET Var_ForCobComGarantia		:= IFNULL(Var_ForCobComGarantia, Cadena_Vacia);
			SET Var_ForPagComGarantia		:= IFNULL(Var_ForPagComGarantia, Cadena_Vacia);
			SET Var_PorcentajeComGarantia	:= IFNULL(Var_PorcentajeComGarantia, Decimal_Cero);

			IF( Var_LineaCreditoID = Entero_Cero ) THEN
				SET Par_NumErr	:= 047;
				SET Par_ErrMen	:= 'La Linea de Credito Agro no existe.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Cliente != Par_ClienteID)THEN
				SET Par_NumErr	:= 048;
				SET Par_ErrMen	:='La Linea de Credito No Corresponde al Cliente.' ;
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_FechaInicioLinea > Var_FechaSistema)THEN
				SET Par_NumErr	:= 049;
				SET Par_ErrMen	:= CONCAT('La Fecha de Inicio de la Linea de Credito es menor a la fecha del sistema') ;
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusLinea IN (Est_Bloqueado, EstLinea_Vencido)) THEN
				SET Par_NumErr  := 069;
				SET Par_ErrMen  := 'La Linea de Credito Agro se encuentra Bloqueada/Vencida.';
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Segmento de Comision por Administracion
			IF( Var_ManejaComAdmon = Constante_NO ) THEN
				SET Var_ComAdmonLinPrevLiq		:= Cadena_Vacia;
				SET Var_ForPagComAdmon			:= Cadena_Vacia;
				SET Var_ForCobComAdmon			:= Cadena_Vacia;
				SET Var_PorcentajeComAdmon		:= Decimal_Cero;
				SET Var_MontoPagComAdmon		:= Decimal_Cero;
			ELSE
				IF( Var_ComAdmonLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 049;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComAdmonLinPrevLiq NOT IN (Constante_NO, Constante_SI) ) THEN
					SET Par_NumErr	:= 050;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComAdmonLinPrevLiq = Constante_SI ) THEN
					SET Var_ForPagComAdmon		:= Cadena_Vacia;
					SET Var_PorcentajeComAdmon	:= Decimal_Cero;
					SET Var_MontoPagComAdmon	:= Decimal_Cero;
				ELSE

					IF( Var_ForPagComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 051;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion esta vacia.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForPagComAdmon NOT IN (Con_Deduccion, Con_Financiado) ) THEN
						SET Par_NumErr	:= 052;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion no es Valida.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 053;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion esta vacio.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon NOT IN (Tip_Disposicion, Tip_Total)) THEN
						SET Par_NumErr	:= 054;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion no es valido.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 055;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 056;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Disposicion ) THEN
						SET Var_Comisiones := Par_MontoCredito;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Total ) THEN
						SET Var_Comisiones := Var_AutorizadoLinea;
					END IF;

					SET Var_MontoPagComAdmon := ROUND(((Var_Comisiones * Var_PorcentajeComAdmon) / Con_DecimalCien), 2);

					IF( Var_ForPagComAdmon = Con_Financiado ) THEN

						SET Var_MontoPagComAdmon := Entero_Cero;

						SELECT	MontoPagComAdmon
						INTO	Var_MontoPagComAdmon
						FROM SOLICITUDCREDITO
						WHERE SolicitudCreditoID = Par_SolicCredID;
					END IF;

					SET Var_MontoPagComAdmon := IFNULL(Var_MontoPagComAdmon, Decimal_Cero);

					IF( Var_MontoPagComAdmon = Entero_Cero ) THEN
						SET Par_NumErr	:= 057;
						SET Par_ErrMen	:= 'El Monto de Pago por Comision por Administracion no es valido.';
						SET Var_Control	:= 'montoComAdmon';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Segmento de comision por Garantia
			IF( Var_ManejaComGarantia = Constante_NO ) THEN
				SET Var_ComGarLinPrevLiq		:= Cadena_Vacia;
				SET Var_ForPagComGarantia		:= Cadena_Vacia;
				SET Var_ForCobComGarantia		:= Cadena_Vacia;
				SET Var_PorcentajeComGarantia	:= Decimal_Cero;
				SET Var_MontoPagComGarantia		:= Decimal_Cero;
			ELSE
				IF( Var_ComGarLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 057;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComGarLinPrevLiq NOT IN (Constante_NO, Constante_SI) ) THEN
					SET Par_NumErr	:= 058;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_ComGarLinPrevLiq = Constante_SI ) THEN
					SET Var_ForPagComGarantia		:= Cadena_Vacia;
					SET Var_PorcentajeComGarantia	:= Decimal_Cero;
					SET Var_MontoPagComGarantia		:= Decimal_Cero;
				ELSE

					IF( Var_ForPagComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 059;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia esta vacia.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForPagComGarantia NOT IN (Con_Deduccion) ) THEN
						SET Par_NumErr	:= 060;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia no es Valida.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 061;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia esta vacio.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia NOT IN (Tip_Cuota)) THEN
						SET Par_NumErr	:= 062;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia no es valido.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 063;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 064;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					CALL CRESIMPAGCOMSERGARPRO (
						Entero_Cero,				Par_SolicCredID,	Entero_Cero,		Entero_Cero,	Par_NumTransacSim,
						Var_MontoPagComGarantia,	Var_PolizaID,		Par_MontoCredito,	Fecha_Vacia,
						SalidaNO,					Par_NumErr,			Par_ErrMen,			Par_empresa ,	Par_Usuario,
						Par_FechaActual,			Par_DireccionIP,	Par_ProgramaID,		Par_SucursalID,	Par_NumTransacSim);

					SET Var_MontoPagComGarantia := IFNULL(Var_MontoPagComGarantia, Entero_Cero);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					IF( Var_MontoPagComGarantia = Entero_Cero ) THEN
						SET Par_NumErr	:= 065;
						SET Par_ErrMen	:= 'El Monto de Pago por Comision por Servicio de Garantia no es valido.';
						SET Var_Control	:= 'montoGarantia';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Validacion para evitar que el cobro de la comisión no supere al monto del crédito
			SET Var_ComisionTotal := Var_MontoPagComAdmon + Var_MontoPagComGarantia;

			IF( Var_PagaIVA = Constante_SI ) THEN

				SET Var_IVA := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
				SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
				SET Var_ComisionTotal := Var_MontoPagComAdmon + ROUND(Var_MontoPagComAdmon * Var_IVA, 2) +
										 Var_MontoPagComGarantia +  ROUND(Var_MontoPagComGarantia * Var_IVA, 2);
			END IF;

			-- Segmento de Validacion de General
			IF( Par_MontoCredito > Var_SaldoDisponible ) THEN
				SET Par_NumErr	:= 065;
				SET Par_ErrMen	:= 'El Monto solicitado es mayor al saldo disponible actual de la Linea de Credito seleccionada.';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_FechaVencim > Var_FechaVencimiento ) THEN
				SET Par_NumErr	:= 066;
				SET Par_ErrMen	:= 'La fecha de vencimiento de la Solicitud de Crédito excede a la fecha de vencimiento de la línea de Crédito.';
				SET Var_Control	:= 'fechaVencim';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_ComisionTotal > Par_MontoCredito ) tHEN
				SET Par_NumErr	:= 067;
				SET Par_ErrMen	:= 'Las Comisiones por manejo de Linea de Credito Agro superan el monto Solicitado del Credito';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;

			-- Actualizo el monto de Pago de Comision por Administracion(Si el monto que se autorizo es diferente del Solicitado)
			UPDATE SOLICITUDCREDITO SET
				MontoPagComAdmon = Var_MontoPagComAdmon
			WHERE SolicitudCreditoID = Par_SolicCredID;
		ELSE

			-- Comsion por Administracion
			SET Var_ManejaComAdmon			:= Constante_NO;
			SET Var_ComAdmonLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComAdmon			:= Cadena_Vacia;
			SET Var_ForPagComAdmon			:= Cadena_Vacia;
			SET Var_PorcentajeComAdmon		:= Decimal_Cero;
			SET Var_MontoPagComAdmon		:= Decimal_Cero;

			-- Comsion por Garantia
			SET Var_ManejaComGarantia		:= Constante_NO;
			SET Var_ComGarLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComGarantia		:= Cadena_Vacia;
			SET Var_ForPagComGarantia		:= Cadena_Vacia;
			SET Var_PorcentajeComGarantia	:= Decimal_Cero;
			SET Var_MontoPagComGarantia		:= Decimal_Cero;
		END IF;

		INSERT INTO CREDITOS(
				CreditoID,				ClienteID,				LineaCreditoID,			ProductoCreditoID,		CuentaID,
				Relacionado,			SolicitudCreditoID,		MontoCredito,			MonedaID,				FechaInicio,
				FechaVencimien,			TipCobComMorato,		FactorMora,				CalcInteresID,			TasaBase,
				TasaFija,				SobreTasa,				PisoTasa,				TechoTasa,				FrecuenciaCap,
				PeriodicidadCap,		FrecuenciaInt,			PeriodicidadInt,		TipoPagoCapital,		NumAmortizacion,
				InstitFondeoID, 		LineaFondeo,			Estatus,				FechTraspasVenc,		FechTerminacion,
				SaldoCapVigent,			SaldoCapAtrasad,		SaldoCapVencido,		SaldCapVenNoExi,		SaldoInterOrdin,
				SaldoInterAtras,		SaldoInterVenc,			SaldoInterProvi,		SaldoIntNoConta,		SaldoIVAInteres,
				SaldoMoratorios,		SaldoIVAMorator,		SaldComFaltPago,		SalIVAComFalPag,		SaldoOtrasComis,
				SaldoIVAComisi,			ProvisionAcum,			PagareImpreso,			FechaInhabil,			CalendIrregular,
				DiaPagoInteres,			DiaPagoCapital,			DiaMesInteres,			DiaMesCapital,			AjusFecUlVenAmo,
				AjusFecExiVen,			NumTransacSim,			FechaMinistrado,		FolioDispersion,		TipoFondeo,
				SucursalID,				ValorCAT,				MontoComApert,			IVAComApertura,			PlazoID,
				TipoDispersion,			CuentaCLABE,			TipoCalInteres,			TipoGeneraInteres,		DestinoCreID,
				MontoDesemb,			MontoPorDesemb,			NumAmortInteres,		AporteCliente,			PorcGarLiq,
				MontoCuota,				MontoSeguroVida,		SeguroVidaPagado,		ForCobroSegVida,		ComAperPagado,
				ForCobroComAper,		ClasiDestinCred,		CicloGrupo,				GrupoID,				TipoPrepago,
				SaldoMoraVencido,		SaldoMoraCarVen,		FechaInicioAmor,		DescuentoSeguro,		MontoSegOriginal,
				DiaPagoProd,			TipoCredito,			MontoSeguroCuota,		CobraSeguroCuota,		CobraIVASeguroCuota,
				IVASeguroCuota,			CobraComAnual,			TipoComAnual,			BaseCalculoComAnual,	MontoComAnual,
				PorcentajeComAnual,		DiasGraciaComAnual,		ComAperCont,			IVAComAperCont,			TipoConsultaSIC,
				FolioConsultaBC,		FolioConsultaCC,		FechaCobroComision,		EsAutomatico,			TipoAutomatico,
                InvCredAut,				CtaCredAut,				Reacreditado,			TipoComXApertura,		MontoComXApertura,
                DiasAtrasoMin,			ReferenciaPago,			NivelID,				CobraAccesorios,		ConvenioNominaID,
                AprobadoInfoComercial,	ClabeCtaDomici,			InstitNominaID,			EtiquetaFondeo,			FechaEtiqueta,
                FlujoOrigen,			EsConsolidado,			EsConsolidacionAgro,	Clabe,
				EstatusNomina,			DevengaNomina,			FechaRecepLim,
				ManejaComAdmon,			ComAdmonLinPrevLiq,		ForCobComAdmon,			ForPagComAdmon,			PorcentajeComAdmon,
				ManejaComGarantia,		ComGarLinPrevLiq,		ForCobComGarantia,		ForPagComGarantia,		PorcentajeComGarantia,
				MontoPagComAdmon,		MontoCobComAdmon,		MontoPagComGarantia,	MontoCobComGarantia,	MontoPagComGarantiaSim,
                EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
                Sucursal,				NumTransaccion)
			VALUES(
				NumCreditoID,					Par_ClienteID,				Par_LinCreditoID,			Par_ProduCredID,			Par_CuentaID,
				Par_Relacionado,				Par_SolicCredID,			Par_MontoCredito,			Par_MonedaID,				Par_FechaInicio,
				Par_FechaVencim,				Var_TipCobComMorato,		Par_FactorMora,				Par_CalcInterID,			Par_TasaBase,
				Par_TasaFija,					Par_SobreTasa,				Par_PisoTasa,				Par_TechoTasa,				Par_FrecuencCap,
				Par_PeriodCap,					Par_FrecuencInt,			Par_PeriodicInt,			Par_TPagCapital,			Par_NumAmortiza,
				Par_InstitFondeoID,				Par_LineaFondeo,			Estatus_Inactivo,			Fecha_Vacia,				Fecha_Vacia,
				saldoCapVigent,					saldoCapAtrasad,			saldoCapVencido,			saldCapVenNoExi,			saldoInterOrdin,
				saldoInterAtras,				saldoInterVenc,				saldoInterProvi,			Entero_Cero,				saldoIVAInteres,
				saldoMoratorios,				saldoIVAMorator,			saldComFaltPago,			salIVAComFalPag,			saldoOtrasComis,
				saldoIVAComisi,					Entero_Cero,				PagareNoImp,				Par_FecInhabil,				Par_CalIrregul,
				Par_DiaPagoInt,					Par_DiaPagoCap,				Par_DiaMesInt,				Par_DiaMesCap,				Par_AjFUlVenAm,
				Par_AjuFecExiVe,				Par_NumTransacSim,			Fecha_Vacia,				Entero_Cero,				Par_TipoFondeo,
				Par_SucursalID,					Par_ValorCAT,				Par_MonComApe,				Par_IVAComApe,				Par_Plazo,
				Par_TipoDisper,					Var_CuentaClabe,			Par_TipoCalInt,				Var_TipoGeneraInteres,		Par_DestinoCreID,
				Entero_Cero,					Entero_Cero,				Par_NumAmortInt,			Par_AportaCliente,			Var_PorcGarLiq,
				Par_MontoCuota,					Par_MontoSegVida,			Entero_Cero,				Par_ForCobroSegVida,		Entero_Cero,
				Var_TipPagComAp,				Par_ClasiDestinCred,		Var_CicloGrupo,				Var_GrupoID,				Par_TipoPrepago,
				Entero_Cero,					Entero_Cero,				Par_FechaInicioAmor,		Par_DescSeguro,				Par_MontoSegOri,
				Var_DiaPagoProd,				Par_TipoCredito,			Var_MontoSeguroCuota,		Var_CobraSeguroCuota,		Var_CobraIVASeguroCuota,
				Var_IVASeguroCuota,				Var_CobraComisionComAnual,	Var_TipoComisionComAnual,	Var_BaseCalculoComAnual,	Var_MontoComisionComAnual,
				Var_PorcentajeComisionComAnual,	Var_DiasGraciaComAnual,		Var_MontoComAp,				Var_MontoIVAComAp,			Par_TipoConsultaSIC,
				Par_FolioConsultaBC,			Par_FolioConsultaCC,		Par_FechaCobroComision,		Var_EsAutomatico,			Var_TipoAutomatico,
				Var_InvCredAut,					Var_CtaCredAut,				Var_Reacreditado,			Var_TipoComXApertura,		Var_MontoComXApertura,
				Var_DiasAtrasoMin,				Par_ReferenciaPago,			Var_NivelID,				Var_CobraAccesorios,		Var_ConvenioNominaID,
				Constante_NO,					Var_ClabeCtaDomici,			Var_InstitucionNominaID,	Constante_NO,				Fecha_Vacia,
				IFNULL(Var_FlujoOrigen,Cadena_Vacia),	IFNULL(Var_EsConsolidado,Cadena_Vacia),			Var_EsConsolidacionAgro,	Var_ClabeCredito,
				Con_EstatusNomina,				Con_DevengaNomina,			Fecha_Vacia,
				Var_ManejaComAdmon,				Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,			Var_ForPagComAdmon,			Var_PorcentajeComAdmon,
				Var_ManejaComGarantia,			Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,		Var_ForPagComGarantia,		Var_PorcentajeComGarantia,
				Var_MontoPagComAdmon,			Entero_Cero,				Var_MontoPagComGarantia,	Entero_Cero,				Var_MontoPagComGarantia,
                Par_empresa,					Par_Usuario,				Par_FechaActual,			Par_DireccionIP,			Par_ProgramaID,
				Par_SucursalID,					Par_NumTransaccion);


				# Actualizar estatus de credito
				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicCredID,           NumCreditoID,         Estatus_Inactivo,          Cadena_Vacia,             Cadena_Vacia,
				Constante_NO,		       Par_NumErr,           Par_ErrMen,                Par_empresa,            	Par_Usuario,
				Par_FechaActual,           Par_DireccionIP,      Par_ProgramaID,            Par_SucursalID,             Par_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;

        IF(Par_SolicCredID > Entero_Cero) THEN
			UPDATE  CREGARPRENHIPO
				SET CreditoID = NumCreditoID,
					ClienteID = Par_ClienteID
			 WHERE  SolicitudCreditoID =    Par_SolicCredID;

			UPDATE ASIGNAGARANTIAS
					SET CreditoID = NumCreditoID
				WHERE SolicitudCreditoID = Par_SolicCredID
				AND Estatus = Est_AutorizaGar;

           IF(Var_ParamCobraAcc = Constante_SI) THEN
				# SE ACTUALIZA EL NUMERO DE CREDITO GENERADO DE ACUERDO A LA SOLICITUD
				UPDATE DETALLEACCESORIOS
					SET CreditoID = NumCreditoID
					WHERE SolicitudCreditoID = Par_SolicCredID;
			END IF;
             IF(Var_CobraGarFin = Constante_SI) THEN
				UPDATE DETALLEGARLIQUIDA
					SET CreditoID = NumCreditoID
                    WHERE SolicitudCreditoID = Par_SolicCredID;
			END IF;

		END IF;
		# ======================================= VALIDACIONES PARA UN CREDITO RENOVACION ===========================================
		IF(Par_TipoCredito = CreRenovacion) THEN
				SELECT Estatus,				PeriodicidadCap
				INTO Var_EstRelacionado,	Var_PeriodCap
				FROM CREDITOS WHERE CreditoID = Par_Relacionado;

				-- Revision de Estatus de Nacimiento
				SELECT  FUNCIONEXIGIBLE(Par_Relacionado) INTO Var_SaldoExigible;
				SET Var_SaldoExigible  := IFNULL(Var_SaldoExigible, Entero_Cero);

				SELECT  FNTOTALADEUDORENOVACION(Par_Relacionado) INTO Var_SaldoRenovar;
				SET Var_SaldoRenovar  := IFNULL(Var_SaldoRenovar, Entero_Cero);

				IF(Par_MontoCredito < Var_SaldoRenovar) THEN
					SET Par_NumErr	:= 50;
					SET Par_ErrMen	:= CONCAT('El Monto del Credito ',FORMAT(Par_MontoCredito,2),' es Menor al Total del Adeudo ',FORMAT(Var_SaldoRenovar,2),' del Credito a Renovar.');
					LEAVE ManejoErrores;
				END IF;

				IF (Var_SaldoExigible <= Entero_Cero) THEN
					SET Var_EstatusCrea := Est_Vigente;
				ELSE
					SET Var_EstatusCrea := Est_Vencido;
				END IF;

				-- Revision del Numero de Pagos Sostenidos para ser Regularizado.
				IF (Var_EstatusCrea = Est_Vencido) THEN
					SET Var_NumPagoSostenido  = Num_PagRegula;
				END IF;


				-- Calculo de los Dias de Atraso
				SELECT  (DATEDIFF(Var_FechaSistema, IFNULL(MIN(FechaExigible), Var_FechaSistema)))
				INTO Var_NumDiasAtraOri
				FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID = Par_Relacionado
				  AND Amo.Estatus != Estatus_Pagado
				  AND Amo.FechaExigible <= Var_FechaSistema;


				-- Revision del Numero de Renovaciones sobre el Credito Original
				SELECT  NumeroReest
				INTO Var_NumRenovacion
				FROM REESTRUCCREDITO
				WHERE CreditoOrigenID = Par_Relacionado
					AND EstatusReest = Est_Desembolso;
				SET Var_NumRenovacion := IFNULL(Var_NumRenovacion, Entero_Cero) + 1;

                SET Var_SalCredAnt :=FUNCIONTOTDEUDACRE(Par_Relacionado);

                UPDATE CREDITOS
                SET	TipoLiquidacion = Var_TipoLiquidacion,
                CantidadPagar	= Var_CantidadPagar
				WHERE CreditoID = NumCreditoID;

				SET Var_EsAgropecuario = (SELECT EsAgropecuario FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicCredID);
				SET Var_EsAgropecuario = IFNULL(Var_EsAgropecuario,Constante_NO);

				IF(Var_EsAgropecuario <> Constante_NO) THEN

						CALL RENOVACCREDITOALT (
							Var_FechaSistema,  	Par_Usuario,      	Par_Relacionado,    	NumCreditoID,  			Var_SalCredAnt,
							Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri, 	Var_NumPagoSostenido, 	Entero_Cero,
							Constante_NO,      	Fecha_Vacia,        Var_NumRenovacion,    	Entero_Cero,			Entero_Cero,
							Entero_Cero,		Entero_Cero,		OrigenRenovacion,		Constante_NO,      		Par_NumErr,
							Par_ErrMen,         Par_empresa,        Par_Usuario,    		Par_FechaActual, 		Par_DireccionIP,
							Par_ProgramaID,     Par_SucursalID,     Par_NumTransaccion );

						IF (Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;
				ELSE
						CALL REESTRUCCREDITOALT (
							Var_FechaSistema,  	Par_Usuario,      	Par_Relacionado,    	NumCreditoID,  			Var_SalCredAnt,
							Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri, 	Var_NumPagoSostenido, 	Entero_Cero,
							Constante_NO,      	Fecha_Vacia,        Var_NumRenovacion,    	Entero_Cero,			Entero_Cero,
							Entero_Cero,		Entero_Cero,		OrigenRenovacion,		Constante_NO,      		Par_NumErr,
							Par_ErrMen,         Par_empresa,        Par_Usuario,    		Par_FechaActual, 		Par_DireccionIP,
							Par_ProgramaID,     Par_SucursalID,     Par_NumTransaccion );

						IF (Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

				END IF;


		END IF; -- Termina IF(Par_TipoCredito = CreRenovacion) THEN


		SELECT 	Pro.RequiereCheckList
		INTO 	Var_RequiereCheckList
		FROM PRODUCTOSCREDITO Pro,
			 SOLICITUDCREDITO Sol
		WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
		AND Sol.solicitudCreditoID = Par_SolicCredID;


		IF (IFNULL(Var_RequiereCheckList,SalidaSI) = SalidaSI)THEN
			CALL CREDITODOCENTALT(
				NumCreditoID,   SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_empresa,
				Par_Usuario,    Par_FechaActual,    Par_DireccionIP,    Par_ProgramaID, Par_SucursalID,
				Par_NumTransaccion  );

			IF Par_NumErr > Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		-- Creditos Consolidados Agro
		IF( Var_EsConsolidacionAgro = Constante_SI ) THEN

			SELECT FolioConsolida
			INTO Var_FolioConsolidacionID
			FROM CRECONSOLIDAAGROENC
			WHERE SolicitudCreditoID = Par_SolicCredID;

			CALL CRECONSOLIDAAGROACT (
				Var_FolioConsolidacionID,	Entero_Cero,		NumCreditoID,		Fecha_Vacia,		Act_NumCredito,
				SalidaNO,					Par_NumErr,			Par_ErrMen,			Par_empresa,		Par_Usuario,
				Par_FechaActual,			Par_DireccionIP,	Par_ProgramaID,		Par_SucursalID,		Par_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Credito Agregado Exitosamente: ', CONVERT(NumCreditoID, CHAR), '.');
		SET Var_Consecutivo := NumCreditoID;

	END ManejoErrores;



	 IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Var_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$