-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDCREDITOMOD;

DELIMITER $$
CREATE PROCEDURE SOLICITUDCREDITOMOD(
	/* SP PARA MODIFICAR UNA SOLICITUD DE CREDITO */
	Par_Solicitud       	INT,				-- ID Solicitud
	Par_ProspectoID     	BIGINT(20),			-- ID Prospecto
	Par_ClienteID       	INT,				-- ID Cliente
	Par_ProduCredID     	INT,				-- ID Producto de Credito
	Par_FechaReg        	DATE,				-- Fecha Registro

	Par_Promotor        	INT,				-- ID Promotor
	Par_TipoCredito     	CHAR(1),			-- Tipo de Credito
	Par_NumCreditos     	INT,				-- Numero de Creditos
	Par_Relacionado     	BIGINT(12),			-- Relacionado
	Par_AporCliente     	DECIMAL(12,2),		-- Aportacion del Cliente

	Par_Moneda          	INT,				-- ID Moneda
	Par_DestinoCre      	INT,				-- Destino de Credito
	Par_Proyecto        	VARCHAR(500),		-- Descripcionb Proyecto
	Par_SucursalID      	INT,				-- ID Sucursal
	Par_MontoSolic      	DECIMAL(12,2),		-- Monto Solicitado

	Par_PlazoID         	INT,				-- ID Plazo
	Par_FactorMora     		DECIMAL(8,4),		-- Factor Mora
	Par_ComApertura     	DECIMAL(12,4),		-- Comision por Apertura
	Par_IVAComAper      	DECIMAL(12,4),		-- IVA Comision por APertura
	Par_TipoDisper      	CHAR(1),			-- Tipo de Dispersion

	Par_CalcInteres     	INT,				-- Calculo de Interes
	Par_TasaBase        	DECIMAL(12,4),		-- Valor Tasa Base
	Par_TasaFija        	DECIMAL(12,4),		-- Valor Tasa Fija
	Par_SobreTasa       	DECIMAL(12,4),		-- Valor Sobre Tasa
	Par_PisoTasa       		DECIMAL(12,4),		-- Valor Tipo Tasa

	Par_TechoTasa       	DECIMAL(12,4),		-- Valor Techo Tasa
	Par_FechInhabil     	CHAR(1),			-- Fecha Inhabil
	Par_AjuFecExiVe     	CHAR(1),			-- Ajuste Fecha Exigible al Vencimiento
	Par_CalIrreg        	CHAR(1),			-- Calendario Irregular
	Par_AjFUlVenAm      	CHAR(1),			-- Ajuste Fecha Ultimo Vencimiento

	Par_TipoPagCap      	CHAR(1),			-- Tipo de Pago de Capital
	Par_FrecInter       	CHAR(1),			-- Frecuencia de Interes
	Par_FrecCapital     	CHAR(1),			-- Frecuencia de Capital
	Par_PeriodInt       	INT,				-- Periodicidad de Interes
	Par_PeriodCap       	INT,				-- Periodicidad de Capital

	Par_DiaPagInt       	CHAR(1),
	Par_DiaPagCap       	CHAR(1),			-- Dia de Pago de Capital
	Par_DiaMesInter     	INT,				-- Dia Mes Interes
	Par_DiaMesCap       	INT,				-- Dia Mes Capital
	Par_NumAmorti       	INT,				-- Numero de Amortizacion

	Par_NumTransacSim   	BIGINT(20),
	Par_CAT             	DECIMAL(12,4),		-- Valor del CAT
	Par_CuentaClabe    		CHAR(18),			-- Cuenta CLABE
	Par_TipoCalInt      	INT(11),			-- Tipo de Calculo de Interes
	Par_TipoFondeo      	CHAR(1),			-- Tipo Fondeo

	Par_InstitFondeoID  	INT(11),			-- ID Institucion de Fondeo
	Par_LineaFondeo     	INT(11),			-- Linea de Fondeo
	Par_NumAmortInt     	INT(11),			-- Numero de Amortizacion de Interes
	Par_MontoCuota      	DECIMAL(12,2),		-- Monto de la Cuota
	Par_GrupoID         	INT(11),			-- ID Grupo

	Par_TipoIntegr      	INT(11),			-- Tipo Integrante
	Par_FechaVencim     	DATE,				-- Fecha Vencimiento
	Par_FechaInicio     	DATE,				-- Fecha de Inicio
	Par_MontoSeguroVida 	DECIMAL(12,2),		-- Monto Seguro Vida
	Par_ForCobroSegVida 	CHAR(1),			-- Forma de Cobro de Seguro de Vida

	Par_ClasiDestinCred 	CHAR(1),			-- Clasificacion de Destino de Credito
	Par_InstitNominaID   	INT(11),			-- ID Institucion Nomina
	Par_FolioCtrl        	VARCHAR(20),		-- Numero de Folio
	Par_HorarioVeri      	VARCHAR(20),		-- Horario de Verificacion
	Par_PorcGarLiq       	DECIMAL(12,2),		-- Porcentaje de Garantia Liquida

	Par_FechaInicioAmor  	DATE,				-- Fecha de Inicio de la primera Amoritizacion
	Par_DescuentoSeguro  	DECIMAL(12,2),		-- Descuento de Seguro
	Par_MontoSegOriginal 	DECIMAL(12,2),		-- Monto Seguro Original
	Par_Comentario			VARCHAR(500),		-- Comentario
	Par_TipoConsultaSIC 	CHAR(2),			-- Tipo Consulta SIC

	Par_FolioConsultaBC 	VARCHAR(30),		-- Folio Consulta Buro de Credito
	Par_FolioConsultaCC 	VARCHAR(30),		-- Folio Consulta Circulo de Credito
	Par_FechaCobroComision 	DATE,				-- Fecha de Cobro de Comision
	Par_InvCredAut			INT(11),
    Par_CtaCredAut			BIGINT(12),


	Par_Cobertura			DECIMAL(14,2),		-- Monto que corresponde al seguro de vida.
    Par_Prima				DECIMAL(14,2),		-- Monto que el cliente paga/cubre respecto al seguro de vida
    Par_Vigencia			INT(11),			-- Meses en que es valido el seguro de vida a partir de su contratacion*/
	Par_ConvenioNominaID	BIGINT UNSIGNED,	-- Identificador del convenio
    Par_FolioSolici			VARCHAR(20),		-- Folio de solicitud convenio de nomina
    Par_QuinquenioID		INT(11),			-- Quinquenio que hace referencia al catalogo de "CATQUINQUENIOS"
	Par_ClabeDomiciliacion	VARCHAR(20),		-- Cuenta clabe de domiciliacion
	Par_TipoCtaSantander	CHAR(1),			-- Tipo de cuenta para Dispersion Santander A =Santander  O = Otro
	Par_CtaSantander 		VARCHAR(20),		-- Numero de cuenta Santander cuando la dispersion es TRAN. SANTNADER y TipoCtaSantander es Santander
	Par_CtaClabeDisp		VARCHAR(20),		-- Numero de cuenta Clabe cuando la dispersion es TRAN. SANTANDER y TipoCtaSantander es Otro

	Par_DeudorOriginalID	INT(11),			-- Numero de Cliente Origen de la consolidacion Agro
	Par_LineaCreditoID		BIGINT(20),			-- Numero de Linea de Credito
	Par_ManejaComAdmon		CHAR(1),			-- Maneja Comisión Administración \nS.- SI \nN.- NO
	Par_ComAdmonLinPrevLiq	CHAR(1),			-- comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	Par_ForPagComAdmon		CHAR(1),			-- Forma de pago Comision por Administración \n"".- No aplica \nD.- Deducción \nF.- Financiado

	Par_MontoPagComAdmon	DECIMAL(12,2),		-- Monto de Pago de  la Comision por Administración Solo valido para Financiado
	Par_ManejaComGarantia	CHAR(1),			-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	Par_ComGarLinPrevLiq	CHAR(1),			-- comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	Par_ForPagComGarantia	CHAR(1),			-- Forma de pago Comision por Garantia \n"".- No aplica \nD.- Deducción \nF.- Financiado

	Par_Salida          	CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr    	INT(11),			-- Control de Errores: Numero de Error
	INOUT Par_ErrMen    	VARCHAR(400),		-- Control de Errores: Descripcion del Error

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria
	Aud_Usuario         	INT(11),			-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal        	INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_ProspectoID     INT;                # Prospecto ID
	DECLARE Var_ClienteID       INT;                # Cliente ID
	DECLARE Var_SolicitudCre    INT;                # Solicitud de credito ID
	DECLARE Var_FormCobCom      CHAR(1);            # Forma de cobro
	DECLARE Var_EstFondeo       CHAR(1);
	DECLARE Var_SaldoFondo      DECIMAL(14,2);
	DECLARE Var_TasaPasiva      DECIMAL(14,4);
	DECLARE Fon_ClienteID       INT(11);
	DECLARE Var_FecIniLin       DATE;
	DECLARE Var_FecMaxVenL      DATE;
	DECLARE Var_FecMaxAmort     DATE;
	DECLARE Var_FecFinLin       DATE;
	DECLARE Var_PeIguIntCap     CHAR(1);
	DECLARE Var_ProductoSol     INT(11);
	DECLARE Var_AntCteID        BIGINT;
	DECLARE Var_AntProspeID     BIGINT;
	DECLARE Var_PonderaCiclo    CHAR(1);
	DECLARE Var_CicloActual     INT;
	DECLARE Var_Estatus         CHAR(1);
	DECLARE Var_CredNomina          CHAR(2);
	DECLARE Var_NumeroEmpleado      VARCHAR(20);
	DECLARE Var_NumeroEmpProspecto  VARCHAR(20);
	DECLARE Var_FechaSistema        DATE;
	DECLARE Var_DiaPagoProd         CHAR(1);            -- Dias de pago del producto
	DECLARE Var_ClasifiCli          CHAR(1);            -- Clasificacion del cliente
	DECLARE Var_DestinoCre          INT;                -- Destino de credito
	DECLARE Var_AutorizaComite      CHAR(1);            -- Permite autorizacion de comite
	DECLARE Var_ValidaAutComite     CHAR(1);            -- Permite validacion por comite
	DECLARE Var_Consecutivo         VARCHAR(20);        -- Valor consecutivo para el control de la pantalla
	DECLARE Var_Control             VARCHAR(100);       -- id de control de pantalla
	DECLARE Var_PermiteAutSolPros   CHAR(1);            -- Permite Autorizacion por solicitud de credito por prospecto
	DECLARE Var_NombreUsuario		VARCHAR(160);
	DECLARE ClaveUsuario			INT(11);
	DECLARE Var_NumRegSol			INT(11);
    DECLARE Var_MontoComApProd		DECIMAL(12,2);		-- Monto Comision por apertura (PRODUCTOSCREDITO)
	DECLARE Var_TipoComXapert		CHAR(1);		-- Tipo de cobro de la comision por apertura


	#SEGUROS
	DECLARE Var_MontoSeguroCuota    DECIMAL(12,2);
	DECLARE Var_CobraSeguroCuota    CHAR(1);                    -- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);                    -- Cobra el producto IVA por seguro por cuota
	DECLARE Var_IVA                 DECIMAL(14,2);              -- IVA de la sucursal
	DECLARE Var_IVASeguroCuota      DECIMAL(12,2);              -- Monto que cobrara por IVA
	#AGROPECUARIOS
	DECLARE Var_EsAgropecuario		CHAR(1);					-- Define si la solicitud de credito es de un producto de credito agropecuario

	DECLARE Var_ClienteEsp			VARCHAR(200);
	DECLARE Var_NumHabitantesLoc	INT(11);
	DECLARE Var_LlaveNumHabitantes	VARCHAR(30);
	DECLARE Var_MaxHabitantes		INT(11);
	DECLARE Inst_FondeoIDFIRA		INT(11);
	DECLARE Var_EstatusLinea        CHAR(1);

	#CREDITOS AUTOMATICOS
    DECLARE Var_EsAutomatico		CHAR(1);		# Indica si el producto de credito es automatico
    DECLARE Var_TipoAutomatico		CHAR(1);		# Indica el tipo automatico del producto de credito
    DECLARE Var_NumRiesgoPersRel	INT(11);		# Indica la cantidad de registros con riesgo en persona relacionada

    DECLARE Var_FinanciaRural		CHAR(1);
    DECLARE Var_CobraAccesorios		CHAR(1);		# Indica si la solicitud cobra accesorios
    DECLARE Var_SucursalCliente		INT(11);		# Indica la Sucursal del Cliente
    DECLARE Var_IVASucursal			DECIMAL(12,2);	# Indica el IVA de la Sucursal del Cliente

    DECLARE Var_TotalPorcentaje		DECIMAL(12,4);	# Total Porcentaje
	DECLARE Var_TipoGeneraInteres	CHAR(1);					-- Tipo de Monto Original (Saldos Globales): I.- Iguales  D.- Dias Transcurridos
	DECLARE Var_CobraGarFin			CHAR(1);
    DECLARE Var_TipoCredito			CHAR(1);		-- Identifica el tipo de crédito: N=Nuevo, R=Reestrucutra, O=Renovación
	DECLARE Var_ReqConsolidacionAgro	CHAR(1);	-- Indica si la solicitud de Credito es consolidacion Agropecuaria
	DECLARE Var_NumeroCreditos		INT(11);		-- Numero de Creditos
	DECLARE Est_Vigente				CHAR(1);		-- Indica Estatus Vigente
	DECLARE Est_Vencido				CHAR(1);		-- Indica Estatus Vencido
	DECLARE Var_LineaCreditoID			BIGINT(20);		-- Linea Credito ID
	DECLARE Var_ManejaComAdmon			CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ForCobComAdmon			CHAR(1);		-- Forma Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición \nC.- Cada Cuota
	DECLARE Var_PorcentajeComAdmon		DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_ManejaComGarantia		CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ForCobComGarantia		CHAR(1);		-- Forma Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_PorcentajeComGarantia	DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_SaldoDisponible			DECIMAL(12,2);	-- Saldo de la Linea, nace con saldo = autorizado
	DECLARE Var_FechaVencimiento		DATE;			-- Fecha de Vencimiento de la Linea de Credito

	DECLARE Var_EstatusProd			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion			VARCHAR(100);	-- Almacena la descripcion del producto de credito

	# Declaracion de Constantes
	DECLARE Entero_Cero         INT;
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SalidaNO            CHAR(1);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SiPagaIVA           CHAR(1);
	DECLARE NoPagaIVA           CHAR(1);
	DECLARE EstInactiva         CHAR(1);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Rec_Propios         CHAR(1);
	DECLARE Rec_Fondeo          CHAR(1);
	DECLARE Var_TipPagCapC      CHAR(1);
	DECLARE Var_TipPagCapL      CHAR(1);
	DECLARE PerIgualCapInt      CHAR(1);
	DECLARE Cred_Nomina         CHAR(2);
	DECLARE ActInstit           INT(11);
	DECLARE VarSumaCapital      DECIMAL(14,2);
	DECLARE ClienteInactivo     CHAR(1);
	DECLARE SiAutorizaComite    CHAR(1);
	DECLARE CliFuncionario      CHAR(1);        # Cliente Funcionario
	DECLARE CliEmpleado         CHAR(1);        # Cliente Empleado
	DECLARE RelacionGrado1      INT(2);         # Relacion de grado 1
	DECLARE RelacionGrado2      INT(2);         # Relacion de grado 2
	DECLARE MenorEdad           CHAR(1);        # Es menor de Edad
	DECLARE NoPermiteAutSolPros CHAR(1);        # No Permite Autorizacion de solicitud por prospecto
	DECLARE Cons_NO             CHAR(1);        # Constante NO
	DECLARE Cons_SI             CHAR(1);        # Constante SI
	DECLARE EstInactivo			INT(11);		# Tipo Estatus Inactivo
	DECLARE Porcentaje			CHAR(1);
    DECLARE MontoComision		CHAR(1);
	DECLARE Est_Bloqueado	    CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
	DECLARE EstLinea_Vencido 	CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nE.- Vencido
	DECLARE Estatus_Inactivo	CHAR(1);			-- Estatus Inactivo


    #RIESGOS
	DECLARE Var_NumRiesgosComun   INT(11);
	DECLARE Var_BusqRiesgoComun   CHAR(1);          -- Valida si realiza la Busqueda de Riesgos
	DECLARE ValidaBusqRiesComun   VARCHAR(25);
	DECLARE DescPersRelacionada   VARCHAR(25);

	DECLARE TipoPantalla      INT(11);    -- Tipo de Pantalla
	DECLARE Var_SiCobra       CHAR(1);    -- Variable Si Cobra IVA
	DECLARE Var_CobraIVA      CHAR(1);    -- Variable Cobra IVA Cliente
	DECLARE FormaFinanciada     CHAR(1);    # Forma de Cobro: FINANCIADA
	DECLARE Var_ValidaDestino       CHAR(1);      # Variable para valdiar que el destino de credito es correcto
	DECLARE TipoMontoIguales    CHAR(1);  -- Tipo de Monto Original (Saldos Globales): I.- Iguales
	DECLARE TipoMontoDiasTrans    CHAR(1);  -- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
	DECLARE TipoCalculoMontoOriginal  INT(11);  -- Tipo de Calculo de Interes por el Monto Original (Saldos Globales)
	DECLARE LlaveGarFinanciada    VARCHAR(100);
	DECLARE Cons_CreditoNuevo     CHAR(1);    -- Indica Credito Nuevo : N

	DECLARE Var_NCobraComAper		CHAR(1);
	DECLARE Var_NManejaEsqConvenio	CHAR(1);
	DECLARE Var_NEsqComApertID		INT(11);
	DECLARE Var_NTipoComApert		CHAR(1);
	DECLARE Var_NTipoCobMora		CHAR(1);
	DECLARE Var_NFormCobroComAper	CHAR(1);
	DECLARE Var_NValor				DECIMAL(12,4);
	DECLARE Var_NCobraMora			CHAR(1);
	DECLARE Var_NValorMora			DECIMAL(12,4);
	DECLARE Var_MontoCons 			DECIMAL(12,2); -- monto de consolidación de una solicitud de consolidación de créditos
	DECLARE Con_Deduccion			CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado			CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DecimalCien			DECIMAL(12,2);	-- Constante Decimal Cien
	DECLARE Tip_Disposicion			CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total				CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota				CHAR(1);		-- Constante Cada Cuota
	DECLARE Var_MontoPagComAdmon		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administracion
	DECLARE Var_MontoPagComGarantia		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_Comisiones				DECIMAL(14,2);	-- Monto de Comisiones
	DECLARE Var_AutorizadoLinea			DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Var_PolizaID				BIGINT(20);		-- Poliza de Ajuste
	DECLARE Var_MontoSimulacion			DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Var_Reestructura			CHAR(1);		-- Tipo Reestructura
	DECLARE Var_FechaInicioLinea		DATE;			-- Fecha de Inicio de la Linea
	DECLARE Var_TipoLineaAgroID			INT(11);		-- Tipo de Linea Credito Agro
	DECLARE Var_ProductosCreditoLin		VARCHAR(100);	-- Producto de Credito Asociados a un Tipo de Linea Credito Agro
	DECLARE Var_ProductoValido			INT(11);		-- Validador del Tipo de Linea Credito Agro
	DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente Paga IVA
	DECLARE Var_ComisionTotal			DECIMAL(14,2);	-- Monto Total de la Comision por manejo de Linea
	DECLARE Var_EsCreditoAgro 			CHAR(1);			-- Si el Credito es Agropecuario
	DECLARE Var_TasaFijaReestructura 	DECIMAL(12,4);		-- Valor Tasa Fija de Reespaldo para las Reestrucuras

	# Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Fecha_Vacia         := '1900-01-01';
	SET Cadena_Vacia        := '';
	SET SalidaSI            := 'S';
	SET SalidaNO            := 'N';
	SET SiPagaIVA           := 'S';
	SET NoPagaIVA           := 'N';
	SET EstInactiva         := 'I';
	SET Estatus_Activo      := 'A';
	SET Rec_Propios         := 'P';
	SET Rec_Fondeo          := 'F';
	SET Var_TipPagCapC      := 'C';
	SET Var_TipPagCapL      := 'L';
	SET PerIgualCapInt      := 'S';
	SET SiAutorizaComite    :='S';
	SET CliFuncionario      :='O';
	SET CliEmpleado         :='E';
	SET RelacionGrado1      :=1;
	SET RelacionGrado2      :=2;
	SET Cred_Nomina         := 'S';
	SET ActInstit           :=4;
	SET ClienteInactivo     := 'I';
	SET MenorEdad           := 'S';
	SET NoPermiteAutSolPros := 'N';
	SET Cons_NO             := 'N';
	SET Cons_SI             := 'S';
	SET EstInactivo     := 1;
	SET Porcentaje      := 'P';       # Constante: Porcentaje
	SET MontoComision   := 'M';       # Constante: Monto
	SET ValidaBusqRiesComun   := 'ValidaBusqRiesComun'; #Valida la Busqueda de Riesgo Comun
	SET DescPersRelacionada   := 'PERSONA RELACIONADA'; # Descripcion Persona Relacionada
	SET Var_LlaveNumHabitantes    := 'NumHabitantesLocalidad';
	SET Inst_FondeoIDFIRA     := 1;
	SET TipoPantalla      := 2;
	SET Var_SiCobra       := 'S';       -- Indica que si cobra IVA de Comision por Apertura
	SET FormaFinanciada     := 'F';       -- Forma de Cobro: FINANCIADA
	SET TipoMontoIguales    := 'I';
	SET TipoMontoDiasTrans    := 'D';
	SET TipoCalculoMontoOriginal := 2;
	SET LlaveGarFinanciada    := 'CobraGarantiaFinanciada';
	SET Cons_CreditoNuevo   := 'N';
	SET Est_Vigente				:= 'V';
	SET Est_Vencido				:= 'B';
	SET Con_Deduccion			:= 'D';
	SET Con_Financiado			:= 'F';
	SET Con_DecimalCien			:= 100.00;
	SET Tip_Disposicion			:= 'D';
	SET Tip_Total				:= 'T';
	SET Tip_Cuota				:= 'C';
	SET Est_Bloqueado           := 'B';
	SET EstLinea_Vencido        := 'E';
	SET Estatus_Inactivo 		:= 'I';		 -- Estatus Inactivo

	SET Var_Reestructura        := 'R';      -- Tipo de Credito Reestructura

	SET Par_TipoCtaSantander	:= IFNULL(Par_TipoCtaSantander,Cadena_Vacia);
	SET Par_CtaSantander 		:= IFNULL(Par_CtaSantander,Cadena_Vacia);
	SET Par_CtaClabeDisp		:= IFNULL(Par_CtaClabeDisp,Cadena_Vacia);
	SET Par_DeudorOriginalID	:= IFNULL(Par_DeudorOriginalID, Entero_Cero);
	SET Par_LineaCreditoID		:= IFNULL(Par_LineaCreditoID, Entero_Cero);

	SET Par_ComAdmonLinPrevLiq	:= IFNULL(Par_ComAdmonLinPrevLiq, Cons_NO);
	SET Par_ForPagComAdmon		:= IFNULL(Par_ForPagComAdmon, Cadena_Vacia);
	SET Par_ComGarLinPrevLiq	:= IFNULL(Par_ComGarLinPrevLiq, Cons_NO);
	SET Par_ForPagComGarantia	:= IFNULL(Par_ForPagComGarantia, Cadena_Vacia);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 'esto le ocasiona. Ref: SP-SOLICITUDCREDITOMOD');
				SET Var_Consecutivo := Entero_Cero;
				SET Var_Control := 'SQLEXCEPTION' ;
			END;


		# Inicializacion de variables
		SELECT FechaSistema  INTO Var_FechaSistema
					FROM PARAMETROSSIS LIMIT 1;

		SELECT IguaCalenIntCap,     AjusFecUlAmoVen,    AjusFecExigVenc,    DiaPagoCapital  INTO
			   Var_PeIguIntCap,     Par_AjFUlVenAm,     Par_AjuFecExiVe,    Var_DiaPagoProd
		FROM CALENDARIOPROD
		WHERE ProductoCreditoID = Par_ProduCredID;

		SELECT 	Pro.ForCobroComAper,		Pro.TasaPonderaGru,		EsAgropecuario,			MontoComXapert,			TipoComXapert,
				Pro.EsAutomatico,			Pro.TipoAutomatico,		FinanciamientoRural,	CobraAccesorios,		Pro.TipoGeneraInteres,
				Pro.ReqConsolidacionAgro,	Pro.Estatus,			Pro.Descripcion
		INTO   	Var_FormCobCom,         	Var_PonderaCiclo,		Var_EsAgropecuario,		Var_MontoComApProd,		Var_TipoComXapert,
				Var_EsAutomatico,			Var_TipoAutomatico,		Var_FinanciaRural,		Var_CobraAccesorios,	Var_TipoGeneraInteres,
				Var_ReqConsolidacionAgro,	Var_EstatusProd,		Var_Descripcion
		FROM PRODUCTOSCREDITO Pro
		WHERE ProducCreditoID = Par_ProduCredID;


		SET Var_FormCobCom      	:= IFNULL(Var_FormCobCom, Cadena_Vacia);
		SET Var_PonderaCiclo    	:= IFNULL(Var_PonderaCiclo, Cadena_Vacia);
		SET Var_EsAgropecuario		:= IFNULL(Var_EsAgropecuario, Cons_NO);
		SET Var_ReqConsolidacionAgro	:= IFNULL(Var_ReqConsolidacionAgro, Cons_NO);
        SET Var_CobraAccesorios		:= IFNULL(Var_CobraAccesorios, Cons_NO);
		SET Var_TipoGeneraInteres	:= IFNULL(Var_TipoGeneraInteres, TipoMontoIguales);

        SET Par_Cobertura			:= IFNULL(Par_Cobertura, Decimal_Cero);
		SET Par_Prima				:= IFNULL(Par_Prima, Decimal_Cero);
		SET Par_Vigencia			:= IFNULL(Par_Vigencia,	Entero_Cero);

		SELECT ProductoCreditoID,       ClienteID,          ProspectoID
		INTO   Var_ProductoSol,         Var_AntCteID,       Var_AntProspeID
		FROM SOLICITUDCREDITO
		WHERE  SolicitudCreditoID = Par_Solicitud;
		SET Var_ProductoSol := IFNULL(Var_ProductoSol, Entero_Cero);
		SET Var_AntCteID    := IFNULL(Var_AntCteID, Entero_Cero);
		SET Var_AntProspeID := IFNULL(Var_AntProspeID, Entero_Cero);

		-- Datos del Usuario
		SELECT	Usu.NombreCompleto,	Usu.UsuarioID
		INTO 	Var_NombreUsuario, 	ClaveUsuario
		FROM USUARIOS Usu
			LEFT JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
		WHERE Usu.UsuarioID = Aud_Usuario;

		-- Consulta si la Solicitud esta en la Tabla de Comentarios.
		 SET Var_NumRegSol := ( SELECT COUNT(SolicitudCreditoID)
								FROM COMENTARIOSSOL
								 WHERE SolicitudCreditoID = Par_Solicitud);

		# Destino de Credito
		IF(Par_TipoCredito = Var_Reestructura) THEN
			SET Var_DestinoCre:=(SELECT ProductoCreditoID
								FROM DESTINOSCREDPROD
								WHERE DestinoCreID = Par_DestinoCre
                                LIMIT 1);

			SET Var_DestinoCre:=IFNULL(Var_DestinoCre,Entero_Cero);
		ELSE
			SET Var_DestinoCre:=(SELECT ProductoCreditoID
								FROM DESTINOSCREDPROD
								WHERE ProductoCreditoID = Par_ProduCredID
								AND DestinoCreID = Par_DestinoCre);

			SET Var_DestinoCre:=IFNULL(Var_DestinoCre,Entero_Cero);
		END IF;

		# Asigna la letra correcta para destino de credito
		SELECT Clasificacion INTO Var_ValidaDestino
			FROM DESTINOSCREDITO
				WHERE DestinoCreID=Par_DestinoCre;

			/*Para Validar que realice la Busqueda*/
		SELECT ValorParametro
			INTO Var_BusqRiesgoComun
        FROM PARAMGENERALES WHERE LlaveParametro=ValidaBusqRiesComun;

        SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
		SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);

		IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Prospecto o safilocale.cliente estan Vacios.';
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		ELSE
			IF(Par_ClienteID <> Entero_Cero) THEN
					SELECT ClienteID ,      Estatus,        CalificaCredito,	SucursalOrigen,			PagaIVA
					INTO   Var_ClienteID,   Var_Estatus,    Var_ClasifiCli,		Var_SucursalCliente,	Var_CobraIVA
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID;

					IF(IFNULL(Var_ClienteID, Entero_Cero)= Entero_Cero) THEN
						SET Par_NumErr          := 002;
						SET Par_ErrMen          := 'El safilocale.cliente Indicado No Existe.';
						SET Var_Control         := 'clienteID' ;
						SET Var_Consecutivo     := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

					IF (Var_Estatus = ClienteInactivo) THEN
					SET Par_NumErr              := 003;
						SET Par_ErrMen          := 'El safilocale.cliente Indicado se Encuentra Inactivo.';
						SET Var_Control         := 'clienteID' ;
						SET Var_Consecutivo     := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

			ELSE
				IF(Par_ProspectoID <> Entero_Cero) THEN
						SELECT ProspectoID,         CalificaProspecto
							INTO   Var_ProspectoID,     Var_ClasifiCli
								FROM PROSPECTOS
									WHERE ProspectoID = Par_ProspectoID;

						-- Validamos si el producto de credito permite autorizacion por solicitud de prospect
					IF(IFNULL(Par_ProduCredID, Entero_Cero)<>Entero_Cero)THEN
						SET Var_PermiteAutSolPros = (SELECT PermiteAutSolPros
														FROM PRODUCTOSCREDITO
															WHERE ProducCreditoID = Par_ProduCredID);

						IF(IFNULL(Var_PermiteAutSolPros, NoPermiteAutSolPros) = NoPermiteAutSolPros) THEN
							SET Par_NumErr := 005;
							SET Par_ErrMen := 'El Producto de Credito No Permite Autorizacion por Prospecto para la Solicitud.';
							SET Var_Control := 'productoID';
							LEAVE ManejoErrores;
						END IF;

					END IF;

					IF(IFNULL(Var_ProspectoID, Entero_Cero))= Entero_Cero THEN
						SET Par_NumErr          := 004;
						SET Par_ErrMen          := 'El Prospecto Indicado No Existe.';
						SET Var_Control         := 'prospectoID' ;
						SET Var_Consecutivo     := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;

				END IF; -- IF(Par_ProspectoID <> Entero_Cero) THEN

			END IF; -- IF(Par_ClienteID <> Entero_Cero) THEN

		END IF; -- IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero) THEN

		IF EXISTS (SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID
					AND EsMenorEdad = MenorEdad)THEN
			SET Par_NumErr          := 006;
			SET Par_ErrMen          := 'El safilocale.cliente es Menor, No es Posible Asignar Credito.';
			SET Var_Control         := 'clienteID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaInicio, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr          := 007;
			SET Par_ErrMen          := 'La Fecha de Inicio esta Vacia.';
			SET Var_Control         := 'fechaInicio' ;
			SET Var_Consecutivo     := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoSolic, Decimal_Cero) = Decimal_Cero) THEN
			SET Par_NumErr          := 008;
			SET Par_ErrMen          := 'El Monto Solicitado esta Vacio.';
			SET Var_Control         := 'montoSolici' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ProduCredID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr          := 009;
			SET Par_ErrMen          := 'El Producto de Credito Solicitado esta Vacio.';
			SET Var_Control         := 'productoCreditoID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT PromotorID FROM PROMOTORES WHERE PromotorID = Par_Promotor) THEN
			SET Par_NumErr          := 010;
			SET Par_ErrMen          := 'El Promotor No existe.';
			SET Var_Control         := 'promotorID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT PromotorID FROM  PROMOTORES WHERE estatus = Estatus_Activo AND PromotorID = Par_Promotor) THEN
			SET Par_NumErr          := 011;
			SET Par_ErrMen          := 'El Promotor esta Inactivo.';
			SET Var_Control         := 'promotorID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_CredNomina := (SELECT ProductoNomina  FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProduCredID);
		IF (Var_CredNomina = Cred_Nomina) THEN
			SET Var_NumeroEmpleado := (SELECT NoEmpleado FROM CLIENTES WHERE ClienteID = Par_ClienteID);

			IF(Par_FolioCtrl=Cadena_Vacia OR Par_FolioCtrl != Cadena_Vacia AND
				Par_FolioCtrl<> CONVERT(Var_NumeroEmpleado, CHAR)) THEN
					UPDATE CLIENTES
					   SET NoEmpleado = Par_FolioCtrl
					WHERE ClienteID = Par_ClienteID;
			END IF;
			IF(Par_FolioCtrl > Entero_Cero AND Par_InstitNominaID <= Entero_Cero) THEN
				SET Par_NumErr          := 012;
				SET Par_ErrMen          := 'Indicar el Numero de Institucion de Nomina.';
				SET Var_Control         := 'institucionNominaID' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
			IF(Par_InstitNominaID > Entero_Cero AND Par_FolioCtrl <= Entero_Cero AND Par_FolioCtrl=Cadena_Vacia) THEN
				SET Par_NumErr          := 013;
				SET Par_ErrMen          := 'Indicar el Numero de Empleado de Nomina.';
				SET Var_Control         := 'folioCtrl' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			#Validaciones de esquemas para comision apertura y mora por convneio de nómina
			IF(IFNULL(Par_InstitNominaID, Entero_Cero) > Entero_Cero AND IFNULL(Par_ConvenioNominaID, Entero_Cero) > Entero_Cero) THEN

			#Verifica si el convenio cobra comisión por apertura e interes moratorio;
				SELECT CobraComisionApert,CobraMora INTO Var_NCobraComAper,Var_NCobraMora FROM CONVENIOSNOMINA WHERE ConvenioNominaID = Par_ConvenioNominaID;
			#Busca esquemas configurados para comision apertura
				IF(Var_NCobraComAper = 'S') THEN

					SELECT 	EsqComApertID,		ManejaEsqConvenio
					INTO 	Var_NEsqComApertID,	Var_NManejaEsqConvenio
					FROM 	ESQCOMAPERNOMINA
					WHERE 	InstitNominaID 		= Par_InstitNominaID
					AND		ProducCreditoID		= Par_ProduCredID
					LIMIT 1;

					IF(Var_NManejaEsqConvenio = 'S') THEN
						SELECT 		FormCobroComAper,			TipoComApert,			Valor
						INTO 		Var_NFormCobroComAper,		Var_NTipoComApert,		Var_NValor
						FROM	COMAPERTCONVENIO
						WHERE		EsqComApertID = Var_NEsqComApertID
						AND		(ConvenioNominaID = Par_ConvenioNominaID OR ConvenioNominaID = Entero_Cero)
						AND 	PlazoID = Par_PlazoID
						AND		MontoMin <= Par_MontoSolic
						AND		MontoMax >= Par_MontoSolic LIMIT 1;

						IF( IFNULL(Var_NFormCobroComAper, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NTipoComApert, Cadena_Vacia) = Cadena_Vacia) THEN
									SET Par_NumErr	:= 046;
									SET Par_ErrMen	:= 'No existe esquema configurado para comisión por apertura, empresa-convenio-plazo-monto';
									SET Var_Control	:= 'plazoID';
									LEAVE ManejoErrores;
						ELSE
							SET Var_TipoComXapert := Var_NTipoComApert;
							SET Var_FormCobCom := Var_NFormCobroComAper;
							SET Var_MontoComApProd := Var_NValor;
						END IF;
					END IF;

				END IF;
			#Busca esquemaa configurado para cobro Mora
				IF(Var_NCobraMora = 'S') THEN
					SELECT		TipoCobMora,		ValorMora
					INTO		Var_NTipoCobMora,	Var_NValorMora
					FROM 	NOMCONDICIONCRED
					WHERE 	InstitNominaID 		= Par_InstitNominaID
					AND 	ConvenioNominaID 	= Par_ConvenioNominaID
					AND		ProducCreditoID		= Par_ProduCredID
					LIMIT	1;
					IF( IFNULL(Var_NTipoCobMora, Cadena_Vacia) = Cadena_Vacia OR	IFNULL(Var_NValorMora, Decimal_Cero) = Decimal_Cero) THEN
						SET Par_NumErr	:= 047;
						SET Par_ErrMen	:= 'No existe esquema configurado para cobro mora, empresa-producto-convenio';
						SET Var_Control	:= 'convenioNominaID';
						LEAVE ManejoErrores;
					ELSE
						SET Par_FactorMora := Var_NValorMora;
					END IF;
				END IF;
			END IF;

		END IF; -- IF (Var_CredNomina = Cred_Nomina) THEN

		IF (Var_CredNomina=Cred_Nomina) THEN
			SET Var_NumeroEmpProspecto := (SELECT NoEmpleado FROM PROSPECTOS WHERE ProspectoID = Par_ProspectoID);

			IF(Par_FolioCtrl = Cadena_Vacia OR Par_FolioCtrl != Cadena_Vacia AND
				Par_FolioCtrl <> CONVERT(Var_NumeroEmpProspecto, CHAR)) THEN
					UPDATE PROSPECTOS
					   SET NoEmpleado = Par_FolioCtrl
					WHERE ProspectoID = Par_ProspectoID;
			END IF;
			IF(Par_FolioCtrl > Entero_Cero AND Par_InstitNominaID <= Entero_Cero) THEN
				SET Par_NumErr          := 014;
				SET Par_ErrMen          := 'Indicar el Numero de Institucion de Nomina.';
				SET Var_Control         := 'institucionNominaID' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
			IF(Par_InstitNominaID > Entero_Cero AND Par_FolioCtrl<=Entero_Cero AND Par_FolioCtrl=Cadena_Vacia) THEN
				SET Par_NumErr          := 015;
				SET Par_ErrMen          := 'Indicar el Numero de Empleado de Nomina.';
				SET Var_Control         := 'folioCtrl' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF; -- IF (Var_CredNomina=Cred_Nomina) THEN

		IF(Par_ProspectoID = Entero_Cero) THEN
			IF(IFNULL(Par_Promotor, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr          := 016;
				SET Par_ErrMen          := 'El Promotor esta Vacio.';
				SET Var_Control         := 'promotorID' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Moneda, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr          := 017;
			SET Par_ErrMen          := 'La Moneda esta Vacia.';
			SET Var_Control         := 'monedaID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DestinoCre, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr          := 018;
			SET Par_ErrMen          := 'El Destino  de Credito esta Vacio.';
			SET Var_Control         := 'destinoCreID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PlazoID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr          := 019;
			SET Par_ErrMen          := 'El Plazo  de Credito esta Vacio.';
			SET Var_Control         := 'destinoCreID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_TipoFondeo  := IFNULL(Par_TipoFondeo, Cadena_Vacia);
		IF(Par_TipoFondeo != Rec_Propios AND Par_TipoFondeo != Rec_Fondeo ) THEN
			SET Par_NumErr          := 020;
			SET Par_ErrMen          := 'Favor de Especificar el Origen de los Recursos.';
			SET Var_Control         := 'tipoFondeo' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoFondeo = Rec_Fondeo) THEN
			SELECT  Ins.Estatus,        Lin.SaldoLinea,     Lin.TasaPasiva,
					 Lin.FechInicLinea, Lin.FechaMaxVenci,  Lin.FechaFinLinea
			INTO    Var_EstFondeo,      Var_SaldoFondo,     Var_TasaPasiva,
					Var_FecIniLin,  Var_FecMaxVenL, Var_FecFinLin
			FROM INSTITUTFONDEO Ins,
					 LINEAFONDEADOR Lin
			WHERE   Ins.InstitutFondID  = Lin.InstitutFondID
				  AND   Ins.InstitutFondID  = Par_InstitFondeoID
				  AND   Lin.LineaFondeoID   = Par_LineaFondeo;

			SET Var_EstFondeo   := IFNULL(Var_EstFondeo, Cadena_Vacia);
			SET Var_SaldoFondo  := IFNULL(Var_SaldoFondo, Entero_Cero);
			IF (Var_EstFondeo != Estatus_Activo) THEN
					SET Par_NumErr          := 021;
					SET Par_ErrMen          := 'La institucion de Fondeo no Existe o no esta Activa.';
					SET Var_Control         := 'institFondeoID' ;
					SET Var_Consecutivo     := Entero_Cero;
					LEAVE ManejoErrores;
			ELSE
				IF (Var_SaldoFondo < Par_MontoSolic) THEN
					SET Par_NumErr          := 022;
					SET Par_ErrMen          := 'Saldo de la Linea de Fondeo Insuficiente.';
					SET Var_Control         := 'institFondeoID' ;
					SET Var_Consecutivo     := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_FechaReg < Var_FecIniLin) THEN
				SET Par_NumErr          := 023;
				SET Par_ErrMen          := 'La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.';
				SET Var_Control         := 'institFondeoID' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF (Par_FechaReg > Var_FecFinLin) THEN
				SET Par_NumErr          := 024;
				SET Par_ErrMen          := 'La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.';
				SET Var_Control         := 'institFondeoID' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT  MAX(Tmp_FecFin) INTO Var_FecMaxAmort
				FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Par_NumTransacSim;

			IF (Var_FecMaxAmort > Var_FecMaxVenL) THEN
					SET Par_NumErr          := 025;
					SET Par_ErrMen          := 'La Fecha de Vencimiento de la Ultima Amortizacion es Superior a la de la Linea de Fondeo.';
					SET Var_Control         := 'institFondeoID' ;
					SET Var_Consecutivo     := Entero_Cero;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_CicloActual  := Entero_Cero;
		IF(Par_GrupoID != Entero_Cero) THEN
			IF(IFNULL(Par_TipoIntegr, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr          := 027;
				SET Par_ErrMen          := 'El Tipo de Integrante esta Vacio.';
				SET Var_Control         := 'tipoIntegrante' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT Gru.CicloActual INTO Var_CicloActual
				FROM GRUPOSCREDITO Gru
				WHERE Gru.GrupoID = Par_GrupoID;
			SET Var_CicloActual  := IFNULL(Var_CicloActual, Entero_Cero);
		END IF;

		IF(Par_TipoPagCap = Var_TipPagCapC OR Var_PeIguIntCap = PerIgualCapInt) THEN
			SET Par_FrecInter   := Par_FrecCapital;
			SET Par_PeriodInt   := Par_PeriodCap;
			SET Par_DiaPagInt   := Par_DiaPagCap;
			SET Par_DiaMesInter     := Par_DiaMesCap;
		END IF;

		IF(Par_TipoPagCap = Var_TipPagCapL) THEN
			SET VarSumaCapital := (SELECT SUM(Tmp_Capital)  FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransacSim);
			SET VarSumaCapital := IFNULL(VarSumaCapital, Decimal_Cero);
			IF( VarSumaCapital != Par_MontoSolic )THEN
				SET Par_NumErr          := 028;
				SET Par_ErrMen          := 'Simule o Calcule Amortizaciones Nuevamente.';
				SET Var_Control         := 'simular' ;
				SET Var_Consecutivo     := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		# Validaciones para que se asigne un producto de credito correcto al cliente de acuerdo a su clasificacion
		SET Var_ValidaAutComite := (SELECT ValidaAutComite FROM PARAMETROSSIS);

		IF(IFNULL(Var_ValidaAutComite, Cadena_Vacia) = SiAutorizaComite)THEN
				IF(IFNULL(Par_ClienteID,Entero_Cero) > Entero_Cero)THEN
						# verifica SI el cliente es empleado o funcionario
						IF EXISTS (SELECT ClienteID FROM CLIENTES
									WHERE ClienteID = Par_ClienteID
										AND Estatus = Estatus_Activo
										AND (Clasificacion = CliFuncionario
										OR Clasificacion = CliEmpleado)) THEN
								IF NOT EXISTS (SELECT ProducCreditoID
													FROM PRODUCTOSCREDITO
													WHERE ProducCreditoID = Par_ProduCredID
														AND AutorizaComite = SiAutorizaComite)THEN
									SET Par_NumErr          := 029;
									SET Par_ErrMen          := 'El Producto de Credito No aplica para las Caracteristicas del safilocale.cliente Indicado.';
									SET Var_Control         := 'productoCreditoID' ;
									SET Var_Consecutivo     := Entero_Cero;
									LEAVE ManejoErrores;
								END IF;
						ELSE
							# Verifica si el cliente esta relacionado con un empleado o funcionario
							IF EXISTS(SELECT Cli.ClienteID,     Cli.Clasificacion
									FROM RELACIONCLIEMPLEADO Rel,
										 CLIENTES Cli,
										 TIPORELACIONES Tip
									WHERE Cli.ClienteID = Rel.RelacionadoID
										AND  Rel.ClienteID = Par_ClienteID
										AND Cli.Estatus = Estatus_Activo
										AND Rel.ParentescoID = Tip.TipoRelacionID
										AND (Tip.Grado = RelacionGrado1 OR Tip.Grado = RelacionGrado2)
										AND (Cli.Clasificacion = CliFuncionario OR Cli.Clasificacion = CliEmpleado)) THEN
											IF NOT EXISTS (SELECT ProducCreditoID
													FROM PRODUCTOSCREDITO
													WHERE ProducCreditoID = Par_ProduCredID
														AND AutorizaComite = SiAutorizaComite)THEN

												SET Par_NumErr          := 030;
												SET Par_ErrMen          := 'El Producto de Credito No aplica para las Caracteristicas del safilocale.cliente Indicado.';
												SET Var_Control         := 'productoCreditoID' ;
												SET Var_Consecutivo     := Entero_Cero;
												LEAVE ManejoErrores;

											END IF;
								END IF;
						END IF;
				# si se trata de un prospecto
				ELSE
						IF EXISTS (SELECT ProspectoID FROM PROSPECTOS
								WHERE ProspectoID = Par_ProspectoID
									AND (Clasificacion = CliFuncionario
									OR Clasificacion = CliEmpleado)) THEN
								IF NOT EXISTS (SELECT ProducCreditoID
													FROM PRODUCTOSCREDITO
													WHERE ProducCreditoID = Par_ProduCredID
														AND AutorizaComite = SiAutorizaComite)THEN
									SET Par_NumErr          := 031;
									SET Par_ErrMen          := 'El Producto de Credito No aplica para las Caracteristicas del Prospecto Indicado.';
									SET Var_Control         := 'productoCreditoID' ;
									SET Var_Consecutivo     := Entero_Cero;
									LEAVE ManejoErrores;
								 END IF;
						 END IF;
				END IF;
		END IF;

		SET Aud_FechaActual := NOW();
		SET Par_FolioCtrl  := IFNULL(Par_FolioCtrl, Cadena_Vacia);
		SET Par_HorarioVeri  := IFNULL(Par_HorarioVeri, Cadena_Vacia);

		IF(IFNULL(Par_FechaInicioAmor, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr          := 034;
			SET Par_ErrMen          := 'Especifique la Fecha de Inicio de Amortizaciones.';
			SET Var_Control         := 'fechaInicioAmor' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCredito, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr          := 035;
			SET Par_ErrMen          := 'Especifique el Tipo de Credito.';
			SET Var_Control         := 'tipoCredito' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_DestinoCre=Cadena_Vacia)THEN
			SET Par_NumErr          := 036;
			SET Par_ErrMen          := 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion';
			SET Var_Control         := 'destinoCreID' ;
			SET Var_Consecutivo     := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_ValidaDestino <> Par_ClasiDestinCred)THEN
		SET Par_NumErr  := 043;
		SET Par_ErrMen  := 'La clasificacion no corresponde con el destino de credito.' ;
		SET Var_Control := 'destinoCreID';
		LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_MontoSeguroVida, Decimal_Cero) > Decimal_Cero) THEN
			SET Par_MontoSegOriginal    := ROUND(Par_MontoSeguroVida / (1 - (Par_DescuentoSeguro / 100)), 2);
		END IF;
		SELECT
			CobraSeguroCuota, CobraIVASeguroCuota
		INTO
			Var_CobraSeguroCuota, Var_CobraIVASeguroCuota
		FROM PRODUCTOSCREDITO
		WHERE    ProducCreditoID = Par_ProduCredID;
		/**VALIDACION PARA COBRO POR SEGURO POR CUOTA**/
		IF(Var_CobraSeguroCuota = 'S') THEN
			SET Var_MontoSeguroCuota :=(SELECT Monto
						FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
							CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
							WHERE ProducCreditoID = Par_ProduCredID
							AND Frecuencia IN(Par_FrecCapital, Par_FrecInter) ORDER BY Dias ASC LIMIT 1);

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

		SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota := IFNULL(Var_MontoSeguroCuota, 0);
		/**fin VALIDACION PARA COBRO POR SEGURO POR CUOTA**/

        IF(Par_ClienteID <> Entero_Cero ) THEN
			SET Var_IVASucursal := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalCliente);
		ELSE
			SET Var_IVASucursal := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
		END IF;

        SET Var_CobraIVA := IFNULL(Var_CobraIVA, Var_SiCobra);

		IF(Var_CobraIVA = Var_SiCobra) THEN
			SET Var_IVASucursal := Var_IVASucursal;
		ELSE
			SET Var_IVASucursal := Decimal_Cero;
		END IF;

		SET Var_IVASucursal := IFNULL(Var_IVASucursal, Decimal_Cero);

        # Si cobra comision por apertura de credito
		IF(Var_MontoComApProd > Decimal_Cero) THEN
			# Si el cobro es por porcentaje
			IF(Var_TipoComXapert = Porcentaje) THEN
				IF(Var_FormCobCom = FormaFinanciada) THEN
					SET Var_TotalPorcentaje := (1 +	(Var_MontoComApProd/100) + ((Var_MontoComApProd/100) * Var_IVASucursal));
					SET Par_ComApertura 	:= ROUND((Par_MontoSolic / Var_TotalPorcentaje) * (Var_MontoComApProd/100),2);
				ELSE
					SET Par_ComApertura := ROUND((Par_MontoSolic * (Var_MontoComApProd/100)),2);
				END IF;
			ELSE
				# Si el cobro es por monto
				IF(Var_TipoComXapert = MontoComision) THEN
					SET Par_ComApertura := ROUND(Var_MontoComApProd,2);
				END IF;
			END IF;

		END IF;

		SET Var_ClienteEsp = (SELECT ValorParametro FROM PARAMGENERALES AS PAR
		WHERE PAR.LlaveParametro = 'CliProcEspecifico');
		SET Var_MaxHabitantes	:= CONVERT(IFNULL((SELECT ValorParametro
								FROM PARAMGENERALES
									WHERE LlaveParametro = Var_LlaveNumHabitantes),'0'),UNSIGNED INTEGER);

		IF(Par_TipoFondeo = Rec_Fondeo AND Var_FinanciaRural = Cons_SI) THEN

			SELECT LOC.NumHabitantes
					INTO Var_NumHabitantesLoc
						FROM CLIENTES AS CTE
							LEFT JOIN DIRECCLIENTE AS DIR ON CTE.ClienteID = DIR.ClienteID AND DIR.Oficial='S'
							LEFT JOIN LOCALIDADREPUB AS LOC ON
								DIR.EstadoID = LOC.EstadoID AND
								DIR.MunicipioID = LOC.MunicipioID AND
								DIR.LocalidadID = LOC.LocalidadID
					WHERE CTE.ClienteID = Par_ClienteID;

				IF (Var_NumHabitantesLoc IS NULL OR Var_NumHabitantesLoc =  Entero_Cero) THEN
					SET Par_NumErr 		:= 007;
					SET Par_ErrMen 		:= CONCAT('El safilocale.cliente no tiene registrada una Direccion Oficial.');
					SET Var_Control 	:= 'progEspecialFIRAID';
					LEAVE ManejoErrores;
				END IF;

				IF (Var_NumHabitantesLoc>Var_MaxHabitantes) THEN
					SET Par_NumErr 		:= 007;
					SET Par_ErrMen 		:= CONCAT('No se puede Otorgar la Solicitud al Cliente debido a que la Localidad no cumple con el requerimiento de Numero de Habitantes.');
					SET Var_Control 	:= 'progEspecialFIRAID';
					LEAVE ManejoErrores;
				END IF;
		END IF;

		SET Par_TipoCalInt := IFNULL(Par_TipoCalInt, Entero_Cero);

		IF( IFNULL(Par_TipoCalInt, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 043;
			SET Par_ErrMen	:= 'Especifique el Tipo de Calculo de Interes.';
			SET Var_Control	:= 'tipoCalInteres';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoCalInt = TipoCalculoMontoOriginal) THEN

			-- Validacion si el Tipo de Calculo es Monto Original
			IF( Var_TipoGeneraInteres = Cadena_Vacia)THEN
				SET Par_NumErr	:= 044;
				SET Par_ErrMen	:= 'Especifique el Tipo de Generacion de Interes ';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

			-- Validacion para verificar que el tipo de Calculo sea lo parametrizado
			IF( Var_TipoGeneraInteres NOT IN (TipoMontoIguales, TipoMontoDiasTrans) )THEN
				SET Par_NumErr	:= 045;
				SET Par_ErrMen	:= 'Especifique un Tipo de Generacion de Interes valido';
				SET Var_Control	:= 'tipoGeneraInteres';
				LEAVE ManejoErrores;
			END IF;

    END IF;

		IF(IFNULL(Par_CalcInteres, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 046;
            SET Par_ErrMen := 'El cálculo de Interes está vacío.';
            SET Var_Control := 'CalcInteresID';
            LEAVE ManejoErrores;
		END IF;

        SET Par_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema,Par_PeriodCap));
		SET Par_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Par_FechaCobroComision, 0, Par_EmpresaID));

		-- Si el Deudor original es diferente de cero la solicitud de credito es consolidada.
		IF( Par_DeudorOriginalID = Entero_Cero ) THEN
			SET Var_ReqConsolidacionAgro := Cons_NO;
		ELSE
			-- Validar que el deudor tiene creditos vigentes o vencidos
			SELECT 	 IFNULL(COUNT(Cre.ClienteID) , Entero_Cero)
			INTO Var_NumeroCreditos
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Cli.ClienteID = Par_DeudorOriginalID
			  AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
			  AND Cre.EsAgropecuario = Cons_SI;

			IF( Var_NumeroCreditos = Entero_Cero ) THEN
				SET Par_NumErr	:= 046;
				SET Par_ErrMen	:= 'El Deudor Original no posee creditos vigentes o vencidos en la cartera agropecuaria.';
				SET Var_Control	:= 'deudorOriginalID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Seccion de validacion para lineas de credito agro
		IF( Par_LineaCreditoID <> Entero_Cero ) THEN

			SELECT	LineaCreditoID,			SaldoDisponible,		FechaVencimiento,
					ManejaComAdmon,			ForCobComAdmon,			PorcentajeComAdmon,
					ManejaComGarantia,		ForCobComGarantia,		PorcentajeComGarantia,
					ClienteID,				Autorizado,				Estatus,
					FechaInicio,			TipoLineaAgroID
			INTO	Var_LineaCreditoID,		Var_SaldoDisponible,	Var_FechaVencimiento,
					Var_ManejaComAdmon,		Var_ForCobComAdmon,		Var_PorcentajeComAdmon,
					Var_ManejaComGarantia,	Var_ForCobComGarantia,	Var_PorcentajeComGarantia,
					Var_ClienteID,			Var_AutorizadoLinea,	Var_EstatusLinea,
					Var_FechaInicioLinea,	Var_TipoLineaAgroID
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LineaCreditoID
			  AND Estatus = Estatus_Activo
			  AND EsAgropecuario = Cons_SI;

			SELECT PagaIVA
			INTO 	Var_PagaIVA
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

			SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);
			SET Var_SaldoDisponible		:= IFNULL(Var_SaldoDisponible, Decimal_Cero);
			SET Var_FechaVencimiento	:= IFNULL(Var_FechaVencimiento, Var_FechaSistema);

			SET Par_ManejaComAdmon		:= IFNULL(Par_ManejaComAdmon, Cons_NO);
			SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
			SET Var_PorcentajeComAdmon	:= IFNULL(Var_PorcentajeComAdmon, Decimal_Cero);

			SET Par_ManejaComGarantia		:= IFNULL(Par_ManejaComGarantia, Cons_NO);
			SET Var_ForCobComGarantia		:= IFNULL(Var_ForCobComGarantia, Cadena_Vacia);
			SET Var_PorcentajeComGarantia	:= IFNULL(Var_PorcentajeComGarantia, Decimal_Cero);
			SET Var_TipoLineaAgroID			:= IFNULL(Var_TipoLineaAgroID, Entero_Cero);
			SET Var_PagaIVA					:= IFNULL(Var_PagaIVA, Cons_NO);

			SELECT ProductosCredito
			INTO Var_ProductosCreditoLin
			FROM TIPOSLINEASAGRO
			WHERE TipoLineaAgroID = Var_TipoLineaAgroID;

			SET Var_ProductosCreditoLin	:= IFNULL(Var_ProductosCreditoLin, Cadena_Vacia);
			SET Var_ProductoValido		:= FIND_IN_SET(Par_ProduCredID, Var_ProductosCreditoLin);

			IF( IFNULL(Var_ProductoValido, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr	:= 046;
				SET Par_ErrMen	:= 'El producto de Credito no es valido para el Tipo de Linea de Credito Agro.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_LineaCreditoID = Entero_Cero ) THEN
				SET Par_NumErr	:= 047;
				SET Par_ErrMen	:= 'La Linea de Credito Agro no existe.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ClienteID != Par_ClienteID)THEN
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
				SET Par_NumErr	:= 066;
				SET Par_ErrMen	:= 'La Linea de Credito Agro se encuentra Bloqueada/Vencida.';
				SET Var_Control	:= 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			-- Segmento de Comision por Administracion
			IF( Par_ManejaComAdmon = Cons_NO ) THEN
				SET Par_ComAdmonLinPrevLiq		:= Cadena_Vacia;
				SET Par_ForPagComAdmon			:= Cadena_Vacia;
				SET Var_ForCobComAdmon			:= Cadena_Vacia;
				SET Var_PorcentajeComAdmon		:= Decimal_Cero;
				SET Var_MontoPagComAdmon		:= Decimal_Cero;
			ELSE
				IF( Par_ComAdmonLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 048;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ComAdmonLinPrevLiq NOT IN (Cons_NO, Cons_SI) ) THEN
					SET Par_NumErr	:= 049;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ComAdmonLinPrevLiq = Cons_SI ) THEN
					SET Par_ForPagComAdmon		:= Cadena_Vacia;
					SET Var_PorcentajeComAdmon	:= Decimal_Cero;
					SET Var_MontoPagComAdmon	:= Decimal_Cero;
				ELSE

					IF( Par_ForPagComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 050;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion esta vacia.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Par_ForPagComAdmon NOT IN (Con_Deduccion, Con_Financiado) ) THEN
						SET Par_NumErr	:= 051;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion no es Valida.';
						SET Var_Control	:= 'forPagComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 052;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion esta vacio.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon NOT IN (Tip_Disposicion, Tip_Total)) THEN
						SET Par_NumErr	:= 053;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion no es valido.';
						SET Var_Control	:= 'forCobComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 054;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComAdmon > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 055;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComAdmon';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Disposicion ) THEN
						SET Var_Comisiones := Par_MontoSolic;
					END IF;

					IF( Var_ForCobComAdmon = Tip_Total ) THEN
						SET Var_Comisiones := Var_AutorizadoLinea;
					END IF;

					SET Var_MontoPagComAdmon := ROUND(((Var_Comisiones * Var_PorcentajeComAdmon) / Con_DecimalCien), 2);
					SET Var_MontoPagComAdmon := IFNULL(Var_MontoPagComAdmon, Decimal_Cero);

					IF( Par_ForPagComAdmon = Con_Financiado ) THEN
						SET Var_MontoPagComAdmon := Par_MontoPagComAdmon;
					END IF;

					IF( Var_MontoPagComAdmon = Entero_Cero ) THEN
						SET Par_NumErr	:= 057;
						SET Par_ErrMen	:= 'El Monto de Pago por Comision por Administracion no es valido.';
						SET Var_Control	:= 'montoComAdmon';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Segmento de comision por Garantia
			IF( Par_ManejaComGarantia = Cons_NO ) THEN
				SET Par_ComGarLinPrevLiq		:= Cadena_Vacia;
				SET Par_ForPagComGarantia		:= Cadena_Vacia;
				SET Var_ForCobComGarantia		:= Cadena_Vacia;
				SET Var_PorcentajeComGarantia	:= Decimal_Cero;
				SET Var_MontoPagComGarantia		:= Decimal_Cero;
			ELSE
				IF( Par_ComGarLinPrevLiq = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 056;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia esta vacia.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ComGarLinPrevLiq NOT IN (Cons_NO, Cons_SI) ) THEN
					SET Par_NumErr	:= 057;
					SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia no es Valida.';
					SET Var_Control	:= 'comAdmonLinPrevLiq';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ComGarLinPrevLiq = Cons_SI ) THEN
					SET Par_ForPagComGarantia		:= Cadena_Vacia;
					SET Var_PorcentajeComGarantia	:= Decimal_Cero;
					SET Var_MontoPagComGarantia		:= Decimal_Cero;
				ELSE

					IF( Par_ForPagComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 058;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia esta vacia.';
						SET Var_Control	:= 'forPagComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Par_ForPagComGarantia NOT IN (Con_Deduccion) ) THEN
						SET Par_NumErr	:= 059;
						SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia no es Valida.';
						SET Var_Control	:= 'forPagComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia = Cadena_Vacia ) THEN
						SET Par_NumErr	:= 060;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia esta vacio.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_ForCobComGarantia NOT IN (Tip_Cuota)) THEN
						SET Par_NumErr	:= 061;
						SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia no es valido.';
						SET Var_Control	:= 'forCobComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia <= Decimal_Cero ) THEN
						SET Par_NumErr	:= 062;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es menor o igual a cero.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					IF( Var_PorcentajeComGarantia > Con_DecimalCien ) THEN
						SET Par_NumErr	:= 063;
						SET Par_ErrMen	:= 'El Porcentaje de Comision por Garantia es mayor al 100%.';
						SET Var_Control	:= 'porcentajeComGarantia';
						LEAVE ManejoErrores;
					END IF;

					SET Var_MontoSimulacion := Par_MontoSolic;

					CALL CRESIMPAGCOMSERGARPRO (
						Entero_Cero,				Par_Solicitud,		Entero_Cero,			Entero_Cero,	Par_NumTransacSim,
						Var_MontoPagComGarantia,	Var_PolizaID,		Var_MontoSimulacion,	Par_FechaVencim,
						SalidaNO,					Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Par_NumTransacSim);

					SET Var_MontoPagComGarantia := IFNULL(Var_MontoPagComGarantia, Decimal_Cero);

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

			IF( Var_PagaIVA = Cons_SI ) THEN

				SET Var_IVA := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Par_SucursalID);
				SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
				SET Var_ComisionTotal := Var_MontoPagComAdmon + ROUND(Var_MontoPagComAdmon * Var_IVA, 2) +
										 Var_MontoPagComGarantia +  ROUND(Var_MontoPagComGarantia * Var_IVA, 2);
			END IF;

			-- Segmento de Validacion de General
			IF( Par_MontoSolic > Var_SaldoDisponible ) THEN
				SET Par_NumErr	:= 064;
				SET Par_ErrMen	:= 'El Monto solicitado es mayor al saldo disponible actual de la Linea de Credito seleccionada.';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_FechaVencim > Var_FechaVencimiento ) THEN
				SET Par_NumErr	:= 065;
				SET Par_ErrMen	:= 'La fecha de vencimiento de la Solicitud de Crédito excede a la fecha de vencimiento de la línea de Crédito.';
				SET Var_Control	:= 'fechaVencim';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_ComisionTotal > Par_MontoSolic ) tHEN
				SET Par_NumErr	:= 067;
				SET Par_ErrMen	:= 'Las Comisiones por manejo de Linea de Credito Agro superan el monto Solicitado del Credito';
				SET Var_Control	:= 'montoSolic';
				LEAVE ManejoErrores;
			END IF;
		ELSE

			SET Par_LineaCreditoID			:= Entero_Cero;
			-- Comsion por Administracion
			SET Par_ManejaComAdmon			:= Cons_NO;
			SET Par_ComAdmonLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComAdmon			:= Cadena_Vacia;
			SET Par_ForPagComAdmon			:= Cadena_Vacia;
			SET Var_PorcentajeComAdmon		:= Decimal_Cero;
			SET Var_MontoPagComAdmon		:= Decimal_Cero;
			-- Comsion por Garantia
			SET Par_ManejaComGarantia		:= Cons_NO;
			SET Par_ComGarLinPrevLiq		:= Cadena_Vacia;
			SET Var_ForCobComGarantia		:= Cadena_Vacia;
			SET Par_ForPagComGarantia		:= Cadena_Vacia;
			SET Var_PorcentajeComGarantia	:= Decimal_Cero;
			SET Var_MontoPagComGarantia		:= Decimal_Cero;
		END IF;

		IF EXISTS(SELECT ConsolidaCartaID
						FROM CONSOLIDACIONCARTALIQ
					   WHERE SolicitudCreditoID = Par_Solicitud) THEN

			SELECT MontoConsolida INTO Var_MontoCons
			  FROM CONSOLIDACIONCARTALIQ
			 WHERE SolicitudCreditoID = Par_Solicitud;

			IF (Par_MontoSolic < Var_MontoCons ) THEN
				SET Par_NumErr := 48;
				SET Par_ErrMen := 'El monto de la solicitud de crédito no puede ser menor al monto de las cartas de liquidación.';
				SET Var_Control:= 'montoSolic';

				LEAVE ManejoErrores;
			END IF;

		END IF;


         IF(IFNULL(Par_FechaVencim,Fecha_Vacia)  = Fecha_Vacia ) THEN
			SET Par_NumErr := 049;
			SET Par_ErrMen := 'La Fecha de Vencimiento esta Vacia.';
			SET Var_Control := 'fechaVencimien';
			LEAVE ManejoErrores;
		END IF;

		SET Var_TasaFijaReestructura := IFNULL(Par_TasaFija, Decimal_Cero);
		SET Par_Relacionado 		 := IFNULL(Par_Relacionado,Entero_Cero);

    	ValidaReestructuraAgro:BEGIN

			SELECT EsAgropecuario
			INTO Var_EsCreditoAgro
			FROM CREDITOS
			WHERE CreditoID = Par_Relacionado;

			SET Var_EsCreditoAgro := IFNULL(Var_EsCreditoAgro, Cons_NO);

			IF( Par_TipoCredito = Var_Reestructura AND Var_EsCreditoAgro = Cons_SI) THEN
				SET Par_TasaFija := Var_TasaFijaReestructura;

				IF( IFNULL(Par_TasaFija,Decimal_Cero) = Decimal_Cero)THEN
					SET Par_NumErr := 032;
					SET Par_ErrMen := 'La Tasa Fija asignada a la Reestructura no es Valida.';
					SET Var_Control := 'tasaFija';
					LEAVE ManejoErrores;
				END IF;
				LEAVE ValidaReestructuraAgro;
			END IF;
		END ValidaReestructuraAgro;

		IF(Par_TipoCredito != Var_Reestructura AND Var_EstatusProd = Estatus_Inactivo) THEN
			SET Par_NumErr := 050;
			SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
			SET Var_Control:= 'productoCreditoID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE  SOLICITUDCREDITO    SET
			ProspectoID             = Par_ProspectoID,
			ClienteID               = Par_ClienteID,
			FechaInicio             = Par_FechaInicio,
			MontoSolici             = Par_MontoSolic,
			MonedaID                = Par_Moneda,
			ProductoCreditoID       = Par_ProduCredID,
			PlazoID                 = Par_PlazoID,
			TipoDispersion          = Par_TipoDisper,
			CuentaCLABE             = Par_CuentaClabe,
			-- SucursalID           = Par_SucursalID,
			ForCobroComAper         = Var_FormCobCom,
			MontoPorComAper         = Par_ComApertura,
			IVAComAper              = Par_IVAComAper,
			DestinoCreID            = Par_DestinoCre,
			PromotorID              = Par_Promotor,
			TasaFija                = Par_TasaFija,
			TasaBase                = Par_TasaBase,
			SobreTasa               = Par_SobreTasa,
			PisoTasa                = Par_PisoTasa,
			TechoTasa               = Par_TechoTasa,
			FactorMora              = Par_FactorMora,
			FrecuenciaCap           = Par_FrecCapital,
			PeriodicidadCap         = Par_PeriodCap,
			FrecuenciaInt           = Par_FrecInter,
			PeriodicidadInt         = Par_PeriodInt,
			TipoPagoCapital         = Par_TipoPagCap,
			NumAmortizacion         = Par_NumAmorti,
			CalendIrregular         = Par_CalIrreg,
			DiaPagoInteres          = Par_DiaPagInt,
			DiaPagoCapital          = Par_DiaPagCap,
			DiaMesInteres           = Par_DiaMesInter,
			DiaMesCapital           = Par_DiaMesCap,
			AjusFecUlVenAmo         = Par_AjFUlVenAm,
			AjusFecExiVen           = Par_AjuFecExiVe,
			NumTransacSim           = Par_NumTransacSim,
			ValorCAT                = Par_CAT,
			FechaInhabil            = Par_FechInhabil,
			AporteCliente           = Par_AporCliente,
			TipoCredito             = Par_TipoCredito,
			NumCreditos             = Par_NumCreditos,
			Relacionado             = Par_Relacionado,
			Proyecto                = Par_Proyecto,
			TipoFondeo              = Par_TipoFondeo,
			InstitFondeoID          = Par_InstitFondeoID,
			LineaFondeo             = Par_LineaFondeo,
			TipoCalInteres          = Par_TipoCalInt,
			TipoGeneraInteres		= Var_TipoGeneraInteres,
			CalcInteresID           = Par_CalcInteres,
			NumAmortInteres         = Par_NumAmortInt,
			MontoCuota              = Par_MontoCuota,
			FechaVencimiento        = Par_FechaVencim,
			GrupoID                 = Par_GrupoID,
			MontoSeguroVida         = Par_MontoSeguroVida ,
			ForCobroSegVida         = Par_ForCobroSegVida ,
			ClasiDestinCred         = Par_ClasiDestinCred,
			CicloGrupo              = Var_CicloActual,
			InstitucionNominaID     = Par_InstitNominaID,
			FolioCtrl               = Par_FolioCtrl,
			HorarioVeri             = Par_HorarioVeri,
			PorcGarLiq              = Par_PorcGarLiq,
			FechaInicioAmor         = Par_FechaInicioAmor,
			DescuentoSeguro         = Par_DescuentoSeguro,
			MontoSegOriginal        = Par_MontoSegOriginal,
			CobraSeguroCuota        = Var_CobraSeguroCuota,
			CobraIVASeguroCuota     = Var_CobraIVASeguroCuota,
			MontoSeguroCuota        = Var_MontoSeguroCuota,
			IVASeguroCuota          = Var_IVASeguroCuota,
			CobraSeguroCuota        = Var_CobraSeguroCuota,
			CobraIVASeguroCuota     = Var_CobraIVASeguroCuota,
			ComentarioEjecutivo 	= CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
													THEN Cadena_Vacia
													ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUSuario," ----- ",  LTRIM(RTRIM(Par_Comentario)),
															" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  ),
			TipoConsultaSIC			= Par_TipoConsultaSIC,
			FolioConsultaBC			= Par_FolioConsultaBC,
			FolioConsultaCC         = Par_FolioConsultaCC,
			EsAgropecuario			= Var_EsAgropecuario,
            FechaCobroComision		= Par_FechaCobroComision,
            EsAutomatico			= Var_EsAutomatico,
            TipoAutomatico			= Var_TipoAutomatico,
            InvCredAut				= Par_InvCredAut,
            CtaCredAut				= Par_CtaCredAut,
            CobraAccesorios			= Var_CobraAccesorios,

			Cobertura				= Par_Cobertura,
            Prima					= Par_Prima,
            Vigencia				= Par_Vigencia,
            ConvenioNominaID		= Par_ConvenioNominaID,
            QuinquenioID			= Par_QuinquenioID,
			FolioSolici				= Par_FolioSolici,
            ClabeCtaDomici			= Par_ClabeDomiciliacion,
            TipoCtaSantander 		= Par_TipoCtaSantander,
            CtaSantander 			= Par_CtaSantander,
            CtaClabeDisp 			= Par_CtaClabeDisp,
            EsConsolidacionAgro 	= Var_ReqConsolidacionAgro,
            DeudorOriginalID 		= Par_DeudorOriginalID,

			LineaCreditoID			= Par_LineaCreditoID,
			ManejaComAdmon			= Par_ManejaComAdmon,
			ComAdmonLinPrevLiq		= Par_ComAdmonLinPrevLiq,
			ForCobComAdmon			= Var_ForCobComAdmon,
			ForPagComAdmon			= Par_ForPagComAdmon,
			PorcentajeComAdmon		= Var_PorcentajeComAdmon,
			MontoPagComAdmon		= Var_MontoPagComAdmon,

			ManejaComGarantia		= Par_ManejaComGarantia,
			ComGarLinPrevLiq		= Par_ComGarLinPrevLiq,
			ForCobComGarantia		= Var_ForCobComGarantia,
			ForPagComGarantia		= Par_ForPagComGarantia,
			PorcentajeComGarantia	= Var_PorcentajeComGarantia,
			MontoPagComGarantia 	= Var_MontoPagComGarantia,

			EmpresaID               = Par_EmpresaID,
			Usuario                 = Aud_Usuario,
			FechaActual             = Aud_FechaActual,
			DireccionIP             = Aud_DireccionIP,
			ProgramaID              = Aud_ProgramaID,
		   NumTransaccion           = Aud_NumTransaccion
			WHERE SolicitudCreditoID    = Par_Solicitud;

		 UPDATE COMENTARIOSSOL
				SET Comentario		= Par_Comentario,
					Fecha			= IFNULL(CONCAT(DATE(Par_FechaReg)," ",CURRENT_TIME), Fecha_Vacia),
					Usuario			= ClaveUsuario
				WHERE SolicitudCreditoID = Par_Solicitud
					AND Estatus = 'SI';


		IF (Var_ProductoSol <> Par_ProduCredID) THEN

			CALL SOLICIDOCENTBAJ(
				Par_Solicitud,  SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
				Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;


			CALL SOLICIDOCENTALT(Par_Solicitud,      SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
								 Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
								 Aud_NumTransaccion);


			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		# --------- SE ACTUALIZAN LOS DATOS DE LA SOLICITUD CREDITO DE NOMINA EN: NOMINAEMPLEADOS Y SOLICITUNOMINABE -----------
		IF(Var_CredNomina = Cred_Nomina)THEN
			 CALL SOLICITUDCREDITOBEMOD(
							Par_Solicitud,  Par_ProspectoID,    Par_ClienteID,      Par_InstitNominaID, Entero_Cero ,
							Par_FolioCtrl,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
							Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
							Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			 CALL NOMINAEMPLEADOSACT(
							Par_InstitNominaID, Par_ClienteID,  	Par_ProspectoID,    Cadena_Vacia,   	Par_ConvenioNominaID,
                            ActInstit,			SalidaNO,       	Par_NumErr,     	Par_ErrMen,     	Par_EmpresaID,
                            Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
                            Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;


		# ----------------- CONSIDERACIONES PARA SOLICITUD DE CREDITO GRUPAL NO SE MODIFICA GRUPOS AGRO------------------------------------------------
		IF(Par_GrupoID != Entero_Cero AND Var_EsAgropecuario = SalidaNO) THEN
			CALL INTEGRAGRUPOSMOD(
				Par_Solicitud,      Par_ProspectoID,    Par_ClienteID,      Par_ProduCredID,    Par_GrupoID,
				Entero_Cero,        Var_PonderaCiclo,   Var_AntCteID,       Var_AntProspeID,    Par_TipoIntegr,
				SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_CobraAccesorios = Cons_SI)THEN
			# SE DAN DE ALTA LOS ACCESORIOS QUE COBRA UN CREDITO CUANDO EL TIPO DE COBRO DEL ACCESORIO ES ANTICIPADA O DEDUCCION
			CALL `DETALLEACCESORIOSALT`(
				Entero_Cero,		Par_Solicitud,			Par_ProduCredID,		Par_ClienteID,			Par_NumTransacSim,
				Par_PlazoID,		TipoPantalla,			Par_MontoSolic,			Par_ConvenioNominaID,	SalidaNO,
				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
		END IF;
		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        SET Var_TipoCredito := (SELECT TipoCredito FROM SOLICITUDCREDITO
								WHERE SolicitudCreditoID = Par_Solicitud);

		IF(Var_CobraGarFin = Cons_SI AND Var_TipoCredito=Cons_CreditoNuevo) THEN
			CALL DETGARANTIALIQUIDAALT(
				Entero_Cero,		Par_Solicitud,			Par_ProduCredID,	Par_ClienteID,		SalidaNO,
				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := Par_NumErr;
				SET Par_ErrMen := Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		END IF;

	IF(IFNULL(Var_BusqRiesgoComun,Cadena_Vacia) = Cons_SI) THEN
		-- INICIO BUSQUEDA RIESGO COMUN
		CALL EVALUARIESGOCOMUNPRO(
			Par_Solicitud, 		Par_ClienteID, 		Par_ProspectoID,
			SalidaNO,			Par_NumErr,			Par_ErrMen,	       Par_EmpresaID,  	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,    Aud_Sucursal,   	Aud_NumTransaccion
		);
			IF(Par_NumErr != Entero_Cero) THEN
                    SET Par_NumErr := Par_NumErr;
                    SET Par_ErrMen := Par_ErrMen;
                    LEAVE ManejoErrores;
            END IF;

        -- FIN BUSQUEDA RIESGO COMUN
	END IF;

			SET Par_NumErr          := 00;
			SET Par_ErrMen          := CONCAT('Solicitud de Credito Modificada Exitosamente: ', CONVERT(Par_Solicitud, CHAR));
			SET Var_Control         := 'solicitudCreditoID' ;
			SET Var_Consecutivo     := Par_Solicitud;

	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
