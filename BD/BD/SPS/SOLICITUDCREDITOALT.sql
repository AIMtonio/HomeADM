-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOALT`;

DELIMITER $$
CREATE PROCEDURE `SOLICITUDCREDITOALT`(
	/* SP PARA DAR DE ALTA UNA SOLICITUD DE CREDITO */
	Par_ProspectoID     	BIGINT(20),			-- ID Prospecto
	Par_ClienteID       	INT(11),			-- ID Cliente
	Par_ProduCredID     	INT(11),			-- ID Producto de Credito
	Par_FechaReg        	DATE,				-- Fecha Registro
	Par_Promotor        	INT(11),			-- ID Promotor

	Par_TipoCredito     	CHAR(1),			-- Tipo de Credito
	Par_NumCreditos     	INT(11),			-- Numero de Creditos
	Par_Relacionado     	BIGINT(12),			-- Relacionado
	Par_AporCliente     	DECIMAL(12,2),		-- Aportacion del Cliente
	Par_Moneda          	INT(11),			-- ID Moneda

	Par_DestinoCre      	INT(11),			-- Destino de Credito
	Par_Proyecto        	VARCHAR(500),		-- Descripcionb Proyecto
	Par_SucursalID      	INT(11),			-- ID Sucursal
	Par_MontoSolic      	DECIMAL(12,2),		-- Monto Solicitado
	Par_PlazoID         	INT(11),			-- ID Plazo

	Par_FactorMora			DECIMAL(8,4),		-- Factor Mora
	Par_ComApertura     	DECIMAL(12,4),		-- Comision por Apertura
	Par_IVAComAper      	DECIMAL(12,4),		-- IVA Comision por APertura
	Par_TipoDisper      	CHAR(1),			-- Tipo de Dispersion
	Par_CalcInteres     	INT(11),			-- Calculo de Interes

	Par_TasaBase        	DECIMAL(12,4),		-- Valor Tasa Base
	Par_TasaFija        	DECIMAL(12,4),		-- Valor Tasa Fija
	Par_SobreTasa       	DECIMAL(12,4),		-- Valor Sobre Tasa
	Par_PisoTasa       	 	DECIMAL(12,4),		-- Valor Tipo Tasa
	Par_TechoTasa       	DECIMAL(12,4),		-- Valor Techo Tasa

	Par_FechInhabil     	CHAR(1),			-- Fecha Inhabil
	Par_AjuFecExiVe     	CHAR(1),			-- Ajuste Fecha Exigible al Vencimiento
	Par_CalIrreg        	CHAR(1),			-- Calendario Irregular
	Par_AjFUlVenAm      	CHAR(1),			-- Ajuste Fecha Ultimo Vencimiento
	Par_TipoPagCap      	CHAR(1),			-- Tipo de Pago de Capital

	Par_FrecInter       	CHAR(1),			-- Frecuencia de Interes
	Par_FrecCapital     	CHAR(1),			-- Frecuencia de Capital
	Par_PeriodInt       	INT(11),			-- Periodicidad de Interes
	Par_PeriodCap       	INT(11),			-- Periodicidad de Capital
	Par_DiaPagInt       	CHAR(1),

	Par_DiaPagCap       	CHAR(1),			-- Dia de Pago de Capital
	Par_DiaMesInter     	INT(11),			-- Dia Mes Interes
	Par_DiaMesCap       	INT(11),			-- Dia Mes Capital
	Par_NumAmorti       	INT(11),			-- Numero de Amortizacion
	Par_NumTransacSim   	BIGINT(20),			-- Numero de Transaccion

	Par_CAT             	DECIMAL(12,4),		-- Valor del CAT
	Par_CuentaClabe     	CHAR(18),			-- Cuenta CLABE
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
	Par_MontoSeguroVida 	DECIMAL(12,2),			-- Monto Seguro Vida
	Par_ForCobroSegVida 	CHAR(1),			-- Forma de Cobro de Seguro de Vida
	Par_ClasiDestinCred 	CHAR(1),			-- Clasificacion de Destino de Credito

	Par_InstitNominaID  	INT(11),			-- ID Institucion Nomina
	Par_FolioCtrl       	VARCHAR(20),		-- Numero de Folio
	Par_HorarioVeri     	VARCHAR(20),		-- Horario de Verificacion
	Par_PorcGarLiq      	DECIMAL(12,2),		-- Porcentaje de Garantia Liquida
	Par_FechaInicioAmor 	DATE,				-- Fecha de Inicio de la primera Amoritizacion

	Par_DescuentoSeguro 	DECIMAL(12,2),		-- Descuento de Seguro
	Par_MontoSegOriginal  	DECIMAL(12,2),		-- Monto Seguro Original
	Par_TipoLiquidacion 	CHAR(1),			-- Tipo Liquidacion
	Par_CantidadPagar   	DECIMAL(12,2),		-- Cantidad Pagar
	Par_TipoConsultaSIC 	CHAR(2),			-- Tipo Consulta SIC

	Par_FolioConsultaBC 	VARCHAR(30),		-- Folio Consulta Buro de Credito
	Par_FolioConsultaCC 	VARCHAR(30),		-- Folio Consulta Circulo de Credito
    Par_FechaCobroComision 	DATE,				-- Fecha de Cobro de Comision
    Par_InvCredAut			INT(11),
    Par_CtaCredAut			BIGINT(12),

    Par_Cobertura			DECIMAL(14,2),		-- Monto que corresponde al seguro de vida.
    Par_Prima				DECIMAL(14,2),		-- Monto que el cliente paga/cubre respecto al seguro de vida
    Par_Vigencia			INT(11),			-- Meses en que es valido el seguro de vida a partir de su contratacion
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

	Par_Salida          CHAR(1),				-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr    INT(11),				-- Control de Errores: Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),			-- Control de Errores: Descripcion del Error

	Par_EmpresaID       INT(11),				-- Parametro de Auditoria
	Aud_Usuario         INT(11),				-- Parametro de Auditoria
	Aud_FechaActual     DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP     VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID      VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal        INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion  BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_ProspectoID         INT;
	DECLARE Var_ClienteID           INT;
	DECLARE Var_SolicitudCre        INT;
	DECLARE Var_FormCobCom          CHAR(1);
	DECLARE Var_EstFondeo           CHAR(1);
	DECLARE Var_SaldoFondo          DECIMAL(14,2);
	DECLARE Var_TasaPasiva          DECIMAL(14,4);
	DECLARE Var_FecIniLin           DATE;
	DECLARE Var_FecMaxVenL          DATE;
	DECLARE Var_FecMaxAmort         DATE;
	DECLARE Var_FecFinLin           DATE;
	DECLARE Var_PeIguIntCap         CHAR(1);
	DECLARE Var_CicloActual         INT;
	DECLARE Var_CredNomina          CHAR(2);
	DECLARE Var_ClienteReg          INT(11);
	DECLARE Var_ProspectoReg        INT(11);
	DECLARE Var_FuncionHuella       CHAR(1);
	DECLARE Var_ReqHuellaProductos  CHAR(1);
	DECLARE Var_NumeroEmpleado      VARCHAR(20);
	DECLARE Var_NumeroEmpProspecto  VARCHAR(20);
	DECLARE Var_FechaSistema        DATE;
	DECLARE Var_DiaPagoProd         CHAR(1);
	DECLARE Var_SolicituAvales      INT(11);
	DECLARE Var_PermiteAutSolPros   CHAR(1);
	DECLARE Var_CalcInteres         INT(11);
	DECLARE Var_TipoGeneraInteres	CHAR(1);					-- Tipo de Monto Original (Saldos Globales): I.- Iguales  D.- Dias Transcurridos
	#SEGUROS
	DECLARE Var_MontoSeguroCuota    DECIMAL(12,2);
	DECLARE Var_CobraSeguroCuota    CHAR(1);					-- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);					-- Cobra el producto IVA por seguro por cuota
	DECLARE Var_IVA                 DECIMAL(14,2);				-- IVA de la sucursal
	DECLARE Var_IVASeguroCuota      DECIMAL(12,2);				-- Monto que cobrara por IVA
   	DECLARE Var_MontoComApProd		DECIMAL(12,2);				-- Monto Comision por apertura (PRODUCTOSCREDITO)
	DECLARE Var_TipoComXapert		CHAR(1);
	-- Tipo de cobro de la comision por apertura
	DECLARE Var_Aportacion      	DECIMAL(12,2); -- para validar la garantia liquida
	DECLARE Var_ClienteCalif        CHAR(1);
    #RIESGOS
	DECLARE Var_NumRiesgosComun		INT(11);
    DECLARE Var_BusqRiesgoComun		CHAR(1);					-- Valida si realiza la Busqueda de Riesgos
	DECLARE ValidaBusqRiesComun		VARCHAR(25);


	#AGROPECUARIOS
	DECLARE Var_EsAgropecuario		CHAR(1);					-- Define si la solicitud de credito es de un producto de credito agropecuario
    DECLARE Var_NumHabitantesLoc	INT(11);
	DECLARE Var_LlaveNumHabitantes	VARCHAR(30);
	DECLARE Var_MaxHabitantes		INT(11);
	DECLARE Var_TipoFondeo			CHAR(1);
	DECLARE Var_InstitucionFondeo	INT(11);
	DECLARE Var_EstatusLinea        CHAR(1);
    #CREDITOS AUTOMATICOS
    DECLARE Var_EsAutomatico		CHAR(1);		# Indica si el producto de credito es automatico
    DECLARE Var_TipoAutomatico		CHAR(1);		# Indica el tipo automatico del producto de credito

    DECLARE Var_NumRiesgoPersRel	INT(11);		# Indica la cantidad de registros con riesgo en persona relacionada
	DECLARE Var_NivelID				INT(11);		# Nivel del crédito (NIVELCREDITO).
    DECLARE Var_CobraAccesorios		CHAR(1);		# Indica si la solicitud cobra accesorios
    DECLARE Var_SucursalCliente		INT(11);		# Indica la Sucursal del Cliente
    DECLARE Var_IVASucursal			DECIMAL(12,2);	# Indica el IVA de la Sucursal del Cliente
    DECLARE Var_TotalPorcentaje		DECIMAL(12,4);	# Total Porcentaje
    DECLARE Var_CobraGarFin			CHAR(1);
    DECLARE Var_DetecNoDeseada		CHAR(1);		-- Valida la activacion del proceso de personas no deseadas
	DECLARE Var_RFCOficial			CHAR(13);		-- RFC de la persona
	DECLARE Var_AplicaTabla         CHAR(1);        -- Indica si aplica tabla real S:SI/N:NO

	DECLARE Var_EstatusProd			CHAR(2);		-- Almacena el estatus del producto de credito
	DECLARE Var_Descripcion			VARCHAR(100);	-- Almacena la descripcion del producto de credito

  # Declaracion de constantes
	DECLARE Entero_Cero             INT;
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Fecha_Vacia             DATE;
	DECLARE SalidaNO                CHAR(1);
	DECLARE Cons_NO                 CHAR(1);
	DECLARE Cons_SI                 CHAR(1);
	DECLARE SalidaSI                CHAR(1);
	DECLARE SiPagaIVA               CHAR(1);
	DECLARE NoPagaIVA               CHAR(1);
	DECLARE EstInactiva             CHAR(1);
	DECLARE Estatus_Activo          CHAR(1);
	DECLARE Rec_Propios             CHAR(1);
	DECLARE Rec_Fondeo              CHAR(1);
	DECLARE Var_TipoFond            INT;
	DECLARE Var_TipPagCapC          CHAR(1);
	DECLARE Var_TipPagCapL          CHAR(1);
	DECLARE PerIgualCapInt          CHAR(1);
	DECLARE PonderaCiclo_SI         CHAR(1);
	DECLARE Var_Estatus             CHAR(1);
	DECLARE ClienteInactivo         CHAR(1);
	DECLARE Var_Renovado            CHAR(1);
	DECLARE Var_Nuevo               CHAR(1);
	DECLARE Var_Reestructura        CHAR(1);
	DECLARE Entero_Uno              INT(11);
	DECLARE Cred_Nomina             CHAR(2);
	DECLARE VarSumaCapital          DECIMAL(14,2); /* VARIABLE PARA SUMA DE CAPITAL*/
	DECLARE SiAutorizaComite        CHAR(1);
	DECLARE CliFuncionario          CHAR(1);        # Cliente Funcionario
	DECLARE CliEmpleado             CHAR(1);        # Cliente Empleado
	DECLARE RelacionGrado1          INT(2);         # Relacion de grado 1
	DECLARE RelacionGrado2          INT(2);         # Relacion de grado 2
	DECLARE Var_ValidaAutComite     CHAR(1);
	DECLARE Var_AutorizaComite      CHAR(1);
	DECLARE SI_Huella               CHAR(1);
	DECLARE MenorEdad               CHAR(1);
	DECLARE UsuarioAltaSolicitud    INT(11);
	DECLARE Var_ClasifiCli          CHAR(1);        # Clasificacion del cliente
	DECLARE Var_Tasa                DECIMAL(12,4);
	DECLARE Persona_Cliente         CHAR(1);
	DECLARE TiposCreditos           VARCHAR(10);
	DECLARE Var_DestinoCre          INT;
	DECLARE Var_Control             VARCHAR(100);
	DECLARE Var_TipoPersona         CHAR(1);
	DECLARE Var_TipoPersonaCte      CHAR(1);
	DECLARE TipoPersAmbas           CHAR(1);
	DECLARE TipoPersFisicas         CHAR(1);
	DECLARE TipoPersMorales         CHAR(1);
	DECLARE PersFisActEmp           CHAR(1);
	DECLARE PersFisica              CHAR(1);
	DECLARE PersMoral               CHAR(1);
	DECLARE NoPermiteAutSolPros     CHAR(1);
	DECLARE TasaFijaID              INT(11);
	DECLARE Porcentaje				CHAR(1);
    DECLARE MontoComision			CHAR(1);
   	DECLARE Var_RequiereCheckList	CHAR(1);
    DECLARE Var_Relacionado			BIGINT(12);
    DECLARE Entero_Cien             INT(11);
	DECLARE EsAutomatico      		CHAR(1);
	DECLARE DescPersRelacionada   	VARCHAR(25);
	DECLARE Inst_FondeoIDFIRA   	INT(11);
	DECLARE Var_InstitucionID     	INT(11);
	DECLARE Var_ClienteEsp      	VARCHAR(200);
	DECLARE Var_ManejaConvenio     	VARCHAR(200);
	DECLARE Est_Bloqueado	        CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nB.- Bloqueada
	DECLARE EstLinea_Vencido 	    CHAR(1);		    -- Indica si se encuentra bloqueada la linea \nE.- Vencido
	DECLARE Estatus_Inactivo		CHAR(1);			-- Estatus Inactivo


	#CREDICLUB WS
	DECLARE Var_ValidaEsqTasa   	CHAR(1);
	DECLARE Key_ValidaEsqTasa   	VARCHAR(25);
	DECLARE Valida_SI       		CHAR(1);

	DECLARE Var_FinanciaRural   	CHAR(1);
	DECLARE Var_SiCobra       		CHAR(1);    # Variable Si Cobra IVA
	DECLARE TipoPantalla      		INT(11);    # Variable Tipo Pantalla
	DECLARE Var_CobraIVA      		CHAR(1);    # Variable Si Paga IVA

	DECLARE FormaFinanciada     	CHAR(1);    # Forma de Cobro: FINANCIADA
	DECLARE Var_ValidaDestino       CHAR(1);      # Variable para valdiar que el destino de credito es correcto
	DECLARE TipoMontoIguales    	CHAR(1);  -- Tipo de Monto Original (Saldos Globales): I.- Iguales
	DECLARE TipoMontoDiasTrans    	CHAR(1);  -- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
	DECLARE TipoCalculoMontoOriginal  INT(11);  -- Tipo de Calculo de Interes por el Monto Original (Saldos Globales)
	DECLARE LlaveGarFinanciada    	VARCHAR(100);
	DECLARE Var_SolicitudOrigen		BIGINT(20);
	DECLARE Var_NCobraComAper		CHAR(1);			-- Variable para almacenar si convenio cobra comisión por apertura
	DECLARE Var_NManejaEsqConvenio	CHAR(1);			-- Variable para almacenar si convenio maneja esquemas de cobro de comisión por apertura
	DECLARE Var_NEsqComApertID		INT(11);			-- Variable para almacenar ID de esquema de cobro de comisión por apertura del convenio
	DECLARE Var_NTipoComApert		CHAR(1);			-- Variable para almacenar Tipo de cobro de comision por apertura del esquema del convenio
	DECLARE Var_NTipoCobMora		CHAR(1);			-- Variable para almacenar Tipo de cobro de interés moratorio del convenio
	DECLARE Var_NFormCobroComAper	CHAR(1);			-- Variable para almacenar Forma de cobro de comision por apertura del esquema por convenio
	DECLARE Var_NValor				DECIMAL(12,4);		-- Variable para almacenar el valor de comisión por apertura del esquema por convenio
	DECLARE Var_NCobraMora			CHAR(1);			-- Variable para almacenar si el convenio cobra mora
	DECLARE Var_NValorMora			DECIMAL(12,4);		-- Variable para alamcenar el valor de interés moratorio configurado para el convenio
	DECLARE Var_ReqConsolidacionAgro	CHAR(1);			-- Indica si la solicitud de Credito es consolidacion Agropecuaria
	DECLARE Var_NumeroCreditos		INT(11);			-- Numero de Creditos
	DECLARE Est_Vigente				CHAR(1);			-- Indica Estatus Vigente
	DECLARE Est_Vencido				CHAR(1);			-- Indica Estatus Vencido
	DECLARE Var_LineaCreditoID			BIGINT(20);		-- Linea Credito ID
	DECLARE Var_ManejaComAdmon			CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ForPagComAdmon			CHAR(1);		-- Forma de Pago Comisión Administración\n"".- No aplica \nD.- Deducción \nF.- Financiado
	DECLARE Var_PorcentajeComAdmon		DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_ManejaComGarantia		CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ForPagComGarantia		CHAR(1);		-- Forma Pago Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_PorcentajeComGarantia	DECIMAL(6,2);	-- permite un valor de 0% a 100%
	DECLARE Var_ForCobComAdmon			CHAR(1);		-- Forma Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición
	DECLARE Var_ForCobComGarantia		CHAR(1);		-- Forma Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Con_Deduccion				CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado				CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DecimalCien				DECIMAL(12,2);	-- Constante Decimal Cien
	DECLARE Tip_Disposicion				CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total					CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota					CHAR(1);		-- Constante Cada Cuota
	DECLARE Var_SaldoDisponible			DECIMAL(12,2);	-- Saldo de la Linea, nace con saldo = autorizado
	DECLARE Var_FechaVencimiento		DATE;			-- Fecha de Vencimiento de la Linea de Credito
	DECLARE Var_MontoPagComAdmon		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administracion
	DECLARE Var_MontoPagComGarantia		DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_Comisiones				DECIMAL(14,2);	-- Monto de Comisiones
	DECLARE Var_AutorizadoLinea			DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Var_PolizaID				BIGINT(20);		-- Poliza de Ajuste
	DECLARE Var_MontoSimulacion			DECIMAL(14,2);	-- Monto de Autorizado Linea de Credito
	DECLARE Var_FechaInicioLinea		DATE;			-- Fecha de Inicio de la Linea
	DECLARE Var_TipoLineaAgroID			INT(11);		-- Tipo de Linea Credito Agro
	DECLARE Var_ProductosCreditoLin		VARCHAR(100);	-- Producto de Credito Asociados a un Tipo de Linea Credito Agro
	DECLARE Var_ProductoValido			INT(11);		-- Validador del Tipo de Linea Credito Agro
	DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente Paga IVA
	DECLARE Var_ComisionTotal			DECIMAL(14,2);	-- Monto Total de la Comision por manejo de Linea
	DECLARE Var_EsCreditoAgro 			CHAR(1);			-- Si el Credito es Agropecuario
	DECLARE Var_TasaFijaReestructura 	DECIMAL(12,4);		-- Valor Tasa Fija de Reespaldo para las Reestrucuras

	# Asignacion de Constantes
	SET Entero_Cero             := 0;               # Constante entero cero
	SET Decimal_Cero            := 0.0;             # Constante DECIMAL cero
	SET Fecha_Vacia             := '1900-01-01';    # Constante fecha vacia
	SET Cadena_Vacia            := '';              # Constante cadena vacia
	SET SalidaSI                := 'S';             # Constante salida si
	SET SalidaNO                := 'N';             # Constante salida no
	SET Cons_NO                 := 'N';             # Constante no
	SET Cons_SI                 := 'S';             # Constante si
	SET SiPagaIVA               := 'S';             # Constante si paga iva
	SET NoPagaIVA               := 'N';             # Constante no paga iva
	SET EstInactiva             := 'I';             # Estatus inactivo
	SET Estatus_Activo          := 'A';             # Estatus Activo
	SET Rec_Propios             := 'P';             # Tipo de Fonde Recursos Propios
	SET Rec_Fondeo              := 'F';             # Tipo de Fondeo
	SET Var_TipoFond            := 1;               # Variable Tipo de Fondeo
	SET Var_TipPagCapC          := 'C';             # Tipo de pago Constante
	SET Var_TipPagCapL          := 'L';             # Tipo de pago Libre
	SET PerIgualCapInt          := 'S';             # Tipo Semanal
	SET PonderaCiclo_SI         := 'S';             # Si pondera ciclo
	SET ClienteInactivo         := 'I';             # Cliente Inactivo
	SET Cred_Nomina             := 'S';             # Tipo de Crdito de Nomina
	SET Var_Renovado            := 'O';             # Tipo de Credito Renovado
	SET Var_Nuevo               := 'N';             # Tipo de Credito Nuevo
	SET Var_Reestructura        := 'R';             # Tipo de Credito Reestructura
	SET Entero_Uno              := 1;               # Constante Entero Uno
	SET SiAutorizaComite        :='S';              # Constante SI autoriza el comite
	SET CliFuncionario          :='O';              # Cliente Funcionario
	SET CliEmpleado             :='E';              # Cliente Empleado
	SET RelacionGrado1          :=1;                # Relacion de grado 1
	SET RelacionGrado2          :=2;                # Relacion de grado 2
	SET SI_Huella               :="S";              # Si registra huella
	SET Par_NumErr              := 0;               # Cosntante para nuemro de error
	SET Par_ErrMen              := '';              # Constante para el mensaje de error
	SET MenorEdad               := 'S';             # El cliente SI es menor de edad
	SET UsuarioAltaSolicitud    := Aud_Usuario;     # Usuario que hace el alta de la solicitud
	SET Persona_Cliente         := 'C';             # Tipo de persona: Cliente
	SET TiposCreditos           := 'N,R,O';         # Tipos de Dispersiones disponibles : N.- Nuevo R.- Reestructura O.- Renovacion
	SET TipoPersAmbas           := 'A';             # Tipo de personas que admite el producto de credito A.- AMBAS
	SET TipoPersFisicas         := 'F';             # Tipo de personas que admite el producto de credito F.- FISICAS
	SET TipoPersMorales         := 'M';             # Tipo de personas que admite el producto de credito M.- MORALES
	SET PersFisActEmp           := 'A';             # Persona Fisica con Actividad Empresarial
	SET PersFisica              := 'F';             # Persona Fisica
	SET PersMoral               := 'M';             # Persona Moral
	SET NoPermiteAutSolPros     := 'N';             # Si permite autorizacion por prospecto en la solicitud de credito
	SET TasaFijaID              := 1;               # ID de la formula para tasa fija (FORMTIPOCALINT)
	SET Porcentaje        		:= 'P';       # Constante: Porcentaje
	SET MontoComision     		:= 'M';       # Constante: Monto
	SET ValidaBusqRiesComun   	:= 'ValidaBusqRiesComun'; #Valida la Busqueda de Riesgo Comun
	SET Entero_Cien       		:= 100;
	SET EsAutomatico      		:= 'S';       # Indica si el credito es automatico
	SET DescPersRelacionada 	:= 'PERSONA RELACIONADA'; # Descripcion Persona Relacionada
	SET Var_LlaveNumHabitantes  := 'NumHabitantesLocalidad';
	SET Inst_FondeoIDFIRA   	:= 1;
	SET TipoPantalla      		:= 2;         # Tipo Pantalla
	/* ---  CREDICLUB WS ------------------------------------------------ */
	SET Valida_SI       		:= 'S';         -- Validar esquema de tasa
	SET Key_ValidaEsqTasa   	:= 'ValidaEsqTasa'; -- llave valida esquema
	SET Var_SiCobra       		:= 'S';       -- Indica que si cobra IVA de Comision por Apertura
	SET FormaFinanciada     	:= 'F';       -- Forma de Cobro: FINANCIADA
	SET TipoMontoIguales    	:= 'I';
	SET TipoMontoDiasTrans  	:= 'D';
	SET TipoCalculoMontoOriginal:= 2;
	SET LlaveGarFinanciada    	:= 'CobraGarantiaFinanciada';
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

	SET Par_TipoCtaSantander	:= IFNULL(Par_TipoCtaSantander,Cadena_Vacia);
	SET Par_CtaSantander 		:= IFNULL(Par_CtaSantander,Cadena_Vacia);
	SET Par_CtaClabeDisp		:= IFNULL(Par_CtaClabeDisp,Cadena_Vacia);
	SET Par_DeudorOriginalID	:= IFNULL(Par_DeudorOriginalID, Entero_Cero);
	SET Par_LineaCreditoID		:= IFNULL(Par_LineaCreditoID, Entero_Cero);

	SET Par_ComAdmonLinPrevLiq	:= IFNULL(Par_ComAdmonLinPrevLiq, Cons_NO);
	SET Par_ForPagComAdmon		:= IFNULL(Par_ForPagComAdmon, Cadena_Vacia);
	SET Par_ComGarLinPrevLiq	:= IFNULL(Par_ComGarLinPrevLiq, Cons_NO);
	SET Par_ForPagComGarantia	:= IFNULL(Par_ForPagComGarantia, Cadena_Vacia);

	SELECT ValorParametro
			INTO Var_ValidaEsqTasa
			FROM PARAMETROSCRCBWS
			WHERE LlaveParametro = Key_ValidaEsqTasa;

	SET Var_ValidaEsqTasa := IFNULL(Var_ValidaEsqTasa,Valida_SI);
	/* --- FIN  CREDICLUB WS ------------------------------------------------ */


	SELECT  IguaCalenIntCap,    AjusFecUlAmoVen,    AjusFecExigVenc,    DiaPagoCapital
	 INTO   Var_PeIguIntCap,    Par_AjFUlVenAm,     Par_AjuFecExiVe,    Var_DiaPagoProd
		FROM CALENDARIOPROD
		WHERE ProductoCreditoID = Par_ProduCredID;

	SELECT FuncionHuella,       ReqHuellaProductos,         FechaSistema,			InstitucionID
	INTO
		   Var_FuncionHuella,   Var_ReqHuellaProductos,     Var_FechaSistema,		Var_InstitucionID
	FROM PARAMETROSSIS LIMIT 1;

    SELECT ValorParametro INTO Var_ManejaConvenio
		FROM PARAMGENERALES AS PAR
		WHERE PAR.LlaveParametro = 'ManejaCovenioNomina';

    SET Var_ManejaConvenio := IFNULL(Var_ManejaConvenio, Cons_NO);
	SET Var_ClienteEsp = (SELECT ValorParametro FROM PARAMGENERALES AS PAR
		WHERE PAR.LlaveParametro = 'CliProcEspecifico');

	SELECT
		Pro.ForCobroComAper,	Pro.FactorMora,			TipoPersona,				CalcInteres,		EsAgropecuario,
		MontoComXapert,			TipoComXapert,			Pro.EsAutomatico,			Pro.TipoAutomatico,	FinanciamientoRural,
		Pro.CobraAccesorios,	Pro.TipoGeneraInteres,	Pro.ReqConsolidacionAgro,	Pro.Estatus,		Pro.Descripcion
		INTO
		Var_FormCobCom,			Par_FactorMora,			Var_TipoPersona,			Var_CalcInteres,	Var_EsAgropecuario,
        Var_MontoComApProd,		Var_TipoComXapert,		Var_EsAutomatico,			Var_TipoAutomatico,	Var_FinanciaRural,
        Var_CobraAccesorios,	Var_TipoGeneraInteres,	Var_ReqConsolidacionAgro,	Var_EstatusProd,	Var_Descripcion
		FROM PRODUCTOSCREDITO Pro
		WHERE Pro.ProducCreditoID = Par_ProduCredID;

	SET Var_EsAgropecuario		:= IFNULL(Var_EsAgropecuario, Cons_NO);
	SET Var_ReqConsolidacionAgro	:= IFNULL(Var_ReqConsolidacionAgro, Cons_NO);
    SET Var_CobraAccesorios		:= IFNULL(Var_CobraAccesorios, Cons_NO);
    SET Var_TipoGeneraInteres	:= IFNULL(Var_TipoGeneraInteres, TipoMontoIguales);
	SET Par_Cobertura			:= IFNULL(Par_Cobertura, Decimal_Cero);
    SET Par_Prima				:= IFNULL(Par_Prima, Decimal_Cero);
    SET Par_Vigencia			:= IFNULL(Par_Vigencia,	Entero_Cero);


	SELECT TipoPersona INTO Var_TipoPersonaCte
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;


    SET Par_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema,Par_PeriodCap));
    SET Par_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Par_FechaCobroComision, 0, Par_EmpresaID));

    SET Par_ConvenioNominaID   := (IFNULL(Par_ConvenioNominaID,Entero_Cero));

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-SOLICITUDCREDITOALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		/*Para Validar que realice la Busqueda*/
		SELECT ValorParametro
			INTO Var_BusqRiesgoComun
        FROM PARAMGENERALES WHERE LlaveParametro=ValidaBusqRiesComun;
		SET Var_MaxHabitantes	:= CONVERT(IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Var_LlaveNumHabitantes),'0'),UNSIGNED INTEGER);

	SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
	SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);

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

	 # Asigna letra correcta para destino de credito
    SELECT Clasificacion INTO Var_ValidaDestino
    	FROM DESTINOSCREDITO
			WHERE DestinoCreID=Par_DestinoCre;


	IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Prospecto o safilocale.cliente estan Vacios.';
			LEAVE ManejoErrores;
	ELSE
		IF(Par_ClienteID <> Entero_Cero) THEN
				SELECT ClienteID ,      Estatus,        CalificaCredito,	SucursalOrigen,			PagaIVA
				INTO   Var_ClienteID,   Var_Estatus,    Var_ClasifiCli,		Var_SucursalCliente,	Var_CobraIVA
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID;


				IF(IFNULL(Var_ClienteID, Entero_Cero)= Entero_Cero) THEN
					SET Par_NumErr := 002;
					SET Par_ErrMen := 'El safilocale.cliente Indicado No Existe.';
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				IF (Var_Estatus = ClienteInactivo) THEN
					SET Par_NumErr := 003;
					SET Par_ErrMen := 'El safilocale.cliente Indicado se Encuentra Inactivo.';
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_FuncionHuella = SI_Huella AND Var_ReqHuellaProductos=SI_Huella) THEN
					IF NOT EXISTS( SELECT PersonaID FROM HUELLADIGITAL Hue
									WHERE Hue.PersonaID = Par_ClienteID
										AND Hue.TipoPersona = Persona_Cliente) THEN
					SET Par_NumErr := 004;
					SET Par_ErrMen := 'El safilocale.cliente No tiene Huella Registrada.';
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
					END IF;
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
						SET Par_NumErr := 005;
						SET Par_ErrMen := 'El Prospecto Indicado No Existe.';
						SET Var_Control := 'prospectoID';
						LEAVE ManejoErrores;
					END IF;

			END IF; -- IF(Par_ProspectoID <> Entero_Cero) THEN

		END IF; -- IF(Par_ClienteID <> Entero_Cero) THEN

	END IF; -- IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero) THEN

	IF EXISTS (SELECT ClienteID
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID
				AND EsMenorEdad = MenorEdad)THEN
						SET Par_NumErr := 006;
						SET Par_ErrMen := 'El safilocale.cliente es Menor, No es Posible Asignar Credito.';
						SET Var_Control := 'clienteID';
						LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaReg, Fecha_Vacia) = Fecha_Vacia) THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := 'La Fecha de Registro esta Vacia.';
		SET Var_Control := 'fechaRegistro';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoSolic, Decimal_Cero) = Decimal_Cero) THEN
		SET Par_NumErr := 008;
		SET Par_ErrMen := 'El Monto Solicitado esta Vacio.';
		SET Var_Control := 'montoSolici';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ProduCredID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 009;
		SET Par_ErrMen := 'El Producto de Credito Solicitado esta Vacio.';
		SET Var_Control := 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT PromotorID FROM PROMOTORES WHERE PromotorID = Par_Promotor) THEN
		SET Par_NumErr := 010;
		SET Par_ErrMen := 'El Promotor No existe.';
		SET Var_Control := 'promotorID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT PromotorID FROM  PROMOTORES WHERE estatus = Estatus_Activo AND PromotorID = Par_Promotor) THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := 'El Promotor esta Inactivo.';
		SET Var_Control := 'promotorID';
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
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'Indicar el Numero de Institucion de Nomina.';
			SET Var_Control := 'institucionNominaID';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_InstitNominaID > Entero_Cero AND Par_FolioCtrl <= Entero_Cero AND Par_FolioCtrl=Cadena_Vacia) THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'Indicar el Numero de Empleado de Nomina.';
			SET Var_Control := 'folioCtrl';
			LEAVE ManejoErrores;
		END IF;
		SET Var_AplicaTabla := (SELECT AplicaTabla FROM  INSTITNOMINA WHERE InstitNominaID = Par_InstitNominaID);

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
    SET Var_AplicaTabla := IFNULL(Var_AplicaTabla,Cons_NO);


	IF (Var_CredNomina=Cred_Nomina) THEN
		SET Var_NumeroEmpProspecto := (SELECT NoEmpleado FROM PROSPECTOS WHERE ProspectoID = Par_ProspectoID);

		IF(Par_FolioCtrl = Cadena_Vacia OR Par_FolioCtrl != Cadena_Vacia AND
			Par_FolioCtrl <> CONVERT(Var_NumeroEmpProspecto, CHAR)) THEN
				UPDATE PROSPECTOS
				   SET NoEmpleado = Par_FolioCtrl
				WHERE ProspectoID = Par_ProspectoID;
		END IF;
		IF(Par_FolioCtrl > Entero_Cero AND Par_InstitNominaID <= Entero_Cero) THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'Indicar el Numero de Institucion de Nomina.';
			SET Var_Control := 'institucionNominaID';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_InstitNominaID > Entero_Cero AND Par_FolioCtrl<=Entero_Cero AND Par_FolioCtrl=Cadena_Vacia) THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'Indicar el Numero de Empleado de Nomina.';
			SET Var_Control := 'folioCtrl';
			LEAVE ManejoErrores;
		END IF;
	END IF; -- IF (Var_CredNomina=Cred_Nomina) THEN


	IF(Par_ProspectoID = Entero_Cero) THEN
		IF(IFNULL(Par_Promotor, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'El Promotor esta Vacio.';
			SET Var_Control := 'promotorID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Moneda, Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr := 017;
		SET Par_ErrMen := 'La Moneda esta Vacia.';
		SET Var_Control := 'monedaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DestinoCre, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 018;
		SET Par_ErrMen := 'El Destino de Credito esta Vacio.';
		SET Var_Control := 'destinoCreID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PlazoID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 019;
		SET Par_ErrMen := 'El Plazo de Credito esta Vacio.';
		SET Var_Control := 'plazoID';
		LEAVE ManejoErrores;
	END IF;

	SET Par_TipoFondeo  := IFNULL(Par_TipoFondeo, Cadena_Vacia);
	IF(Par_TipoFondeo != Rec_Propios AND Par_TipoFondeo != Rec_Fondeo ) THEN
		SET Par_NumErr := 020;
		SET Par_ErrMen := 'Favor de Especificar el Origen de los Recursos.';
		SET Var_Control := 'tipoFondeo';
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
			SET Par_NumErr := 021;
			SET Par_ErrMen := 'La Institucion de Fondeo no Existe o no esta Activa.';
			SET Var_Control := 'institutFondID';
			LEAVE ManejoErrores;
		ELSE
			IF (Var_SaldoFondo < Par_MontoSolic) THEN
				SET Par_NumErr := 022;
				SET Par_ErrMen := 'Saldo de la Linea de Fondeo Insuficiente.';
				SET Var_Control := 'saldoLineaFon';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_FechaReg < Var_FecIniLin) THEN
			SET Par_NumErr := 023;
			SET Par_ErrMen := 'La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.';
			SET Var_Control := 'fechaRegistro';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_FechaReg > Var_FecFinLin) THEN
			SET Par_NumErr := 024;
			SET Par_ErrMen := 'La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.';
			SET Var_Control := 'fechaRegistro';
			LEAVE ManejoErrores;
		END IF;

		SELECT  MAX(Tmp_FecFin) INTO Var_FecMaxAmort
			FROM TMPPAGAMORSIM
			WHERE NumTransaccion = Par_NumTransacSim;

		IF (Var_FecMaxAmort > Var_FecMaxVenL) THEN
			SET Par_NumErr := 025;
			SET Par_ErrMen := 'La Fecha de Vencimiento de la Ultima Amortizacion es Superior a la de la Linea de Fondeo.';
			LEAVE ManejoErrores;
		END IF;


	END IF;

	SELECT LOC.NumHabitantes
					INTO Var_NumHabitantesLoc
						FROM CLIENTES AS CTE
							LEFT JOIN DIRECCLIENTE AS DIR ON CTE.ClienteID = DIR.ClienteID AND DIR.Oficial='S'
							LEFT JOIN LOCALIDADREPUB AS LOC ON
								DIR.EstadoID = LOC.EstadoID AND
								DIR.MunicipioID = LOC.MunicipioID AND
								DIR.LocalidadID = LOC.LocalidadID
					WHERE CTE.ClienteID = Par_ClienteID;

	IF(Par_TipoFondeo = Rec_Fondeo AND Var_FinanciaRural = Cons_SI) THEN
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

	SET Var_CicloActual  := Entero_Cero;
	IF(Par_GrupoID != Entero_Cero) THEN
		IF(IFNULL(Par_TipoIntegr, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 027;
			SET Par_ErrMen := 'El Tipo de Integrante esta Vacio.';
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
			SET Par_NumErr := 028;
			SET Par_ErrMen := 'Simule o Calcule Amortizaciones Nuevamente.';
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
										SET Par_NumErr := 029;
										SET Par_ErrMen := 'El Producto de Credito No aplica para las Caracteristicas del safilocale.cliente Indicado.';
										SET Var_Control := 'productoCreditoID';
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
											SET Par_NumErr := 030;
											SET Par_ErrMen := 'El Producto de Credito No aplica para las Caracteristicas del safilocale.cliente Indicado.';
											SET Var_Control := 'productoCreditoID';
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
								SET Par_NumErr := 031;
								SET Par_ErrMen := 'El Producto de Credito No aplica para las Caracteristicas del Prospecto Indicado.';
								SET Var_Control := 'productoCreditoID';
								LEAVE ManejoErrores;
							 END IF;
					 END IF;
			END IF;
	END IF;

	SET Aud_FechaActual := NOW();
	SET Par_FolioCtrl   := IFNULL(Par_FolioCtrl, Cadena_Vacia);
	SET Par_HorarioVeri := IFNULL(Par_HorarioVeri, Cadena_Vacia);
	SET Par_TipoLiquidacion := IFNULL(Par_TipoLiquidacion,	Cadena_Vacia);
	SET Par_CantidadPagar := IFNULL(Par_CantidadPagar, Decimal_Cero);

	IF(IFNULL(Par_CalcInteres, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := 041;
            SET Par_ErrMen := 'El cálculo de Interes está vacío.';
            SET Var_Control := 'CalcInteresID';
            LEAVE ManejoErrores;
    END IF;

    -- INICIO PROCESO DE PERSONAS NO DESEADAS
    SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),Cons_NO);
	IF(Var_DetecNoDeseada = Cons_SI) THEN

		IF(Var_TipoPersonaCte = PersMoral) THEN
			SELECT 	Cli.RFCpm
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Par_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;

        IF(Var_TipoPersonaCte = PersFisica OR Var_TipoPersona = PersFisActEmp ) THEN
			SELECT 	Cli.RFC
			INTO 	Var_RFCOficial FROM	CLIENTES Cli,	SUCURSALES Suc
			WHERE 	Cli.ClienteID 	= Par_ClienteID
			AND		Suc.SucursalID 	= Cli.SucursalOrigen;
        END IF;

		CALL PLDDETECPERSNODESEADASPRO(
			Entero_Cero,	Var_RFCOficial,	Var_TipoPersonaCte,	SalidaNO,	Par_NumErr,
			Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Par_NumErr			:= 050;
			SET Par_ErrMen			:= Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
	 END IF;
     -- FIN PROCESO DE PERSONAS NO DESEADAS

	SET Var_EsAutomatico 		 := IFNULL(Var_EsAutomatico, Cons_NO);
    SET Var_TasaFijaReestructura := IFNULL(Par_TasaFija, Decimal_Cero);
    SET Par_Relacionado 		 := IFNULL(Par_Relacionado,Entero_Cero);

    IF(Var_EsAutomatico = Cons_NO) THEN

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

			/* Si el calculo de Interes es por Tasa Fija
			 * se actualiza la tasa de acuerdo al esquema de tasas */
			IF(IFNULL(Var_CalcInteres,Entero_Cero)=TasaFijaID AND Var_ValidaEsqTasa <> Cons_NO)THEN
				# ------------- SE CALCULA LA TASA DE INTERES --------------------------
				CALL ESQUEMATASACALPRO(
					Par_SucursalID,		Par_ProduCredID,        Par_NumCreditos,        Par_MontoSolic,     	Var_ClasifiCli,
					Var_Tasa,			Par_PlazoID,            Par_InstitNominaID, 	Par_ConvenioNominaID,	Var_NivelID,
		            SalidaNO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,       	Aud_Usuario,
		            Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       	Aud_NumTransaccion);

				SET Var_Tasa := IFNULL(Var_Tasa,Decimal_Cero);
				SET Par_TasaFija := Var_Tasa;

				IF(IFNULL(Var_Tasa,Decimal_Cero) = Decimal_Cero)THEN
					SET Par_NumErr := 032;
					SET Par_ErrMen := 'No Hay una Tasa Parametrizada para los Valores Indicados.';
					SET Var_Control := 'tasaFija';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END ValidaReestructuraAgro;
	ELSE
		IF(Var_TipoAutomatico = EsAutomatico) THEN
			SET Par_TasaFija := (SELECT	TA.Tasa
									FROM CUENTASAHO CA
									INNER JOIN TASASAHORRO TA
									ON CA.TipoCuentaID = TA.TipoCuentaID
									INNER JOIN CLIENTES CL
									ON CA.ClienteID = CA.ClienteID
									WHERE  	CA.CuentaAhoID = Par_CuentaAhoID
									AND CL.ClienteID  = Par_ClienteID
									AND TA.TipoPersona = CL.TipoPersona
									AND TA.MontoInferior <= CA.Saldo
									AND TA.MontoSuperior >= CA.Saldo);
		END IF;
    END IF;

	SET Var_NivelID := IFNULL(Var_NivelID,Entero_Cero);

	IF(IFNULL(Par_TasaFija,Decimal_Cero)= Decimal_Cero) THEN
			SET Par_NumErr := 033;
			SET Par_ErrMen := 'La Tasa Fija Anualizada esta Vacia.';
			SET Var_Control := 'tasaFija';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaInicioAmor, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr := 034;
			SET Par_ErrMen := 'Especifique la Fecha de Inicio de Amortizaciones.';
			SET Var_Control := 'fechaInicioAmor';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoCredito, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 035;
			SET Par_ErrMen := 'Especifique el Tipo de Credito.';
			SET Var_Control := 'tipoCredito';
			LEAVE ManejoErrores;
	END IF;

	IF(LOCATE(Par_TipoCredito,TiposCreditos)=0) THEN
			SET Par_NumErr := 036;
			SET Par_ErrMen := 'El Tipo de Credito No es Correcto.';
			SET Var_Control := 'tipoCredito';
			LEAVE ManejoErrores;
	END IF;

	IF(Var_DestinoCre=Cadena_Vacia)THEN
		SET Par_NumErr  := 037;
		SET Par_ErrMen  := 'El Destino de Credito Seleccionado no Corresponde con el Producto por su Clasificacion.' ;
		SET Var_Control := 'destinoCreID';
		LEAVE ManejoErrores;

	END IF;

	IF(Var_ValidaDestino <> Par_ClasiDestinCred)THEN
		SET Par_NumErr  := 043;
		SET Par_ErrMen  := 'La clasificacion no corresponde con el destino de credito.' ;
		SET Var_Control := 'destinoCreID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_TipoPersona != TipoPersAmbas)THEN
		IF(Var_TipoPersona = TipoPersFisicas)THEN
			IF(Var_TipoPersonaCte != PersFisica AND Var_TipoPersonaCte != PersFisActEmp)THEN
				SET Par_NumErr  := 038;
				SET Par_ErrMen  := 'El Producto de Credito solo admite Personas Fisicas.' ;
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF(Var_TipoPersona = TipoPersMorales)THEN
				IF(Var_TipoPersonaCte != PersMoral)THEN
					SET Par_NumErr  := 039;
					SET Par_ErrMen  := 'El Producto de Credito solo admite Personas Morales.' ;
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Par_MontoSeguroVida, Decimal_Cero) > Decimal_Cero) THEN
		SET Par_MontoSegOriginal    := ROUND(Par_MontoSeguroVida / (1 - (Par_DescuentoSeguro / 100)), 2);
	END IF;

	SELECT CobraSeguroCuota,CobraIVASeguroCuota  INTO Var_CobraSeguroCuota,Var_CobraIVASeguroCuota
		FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProduCredID;

	SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota, 'N');
	SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota,'N');

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
            SET Var_TotalPorcentaje := (1 +	(Var_MontoComApProd/100) + ((Var_MontoComApProd/100) * Var_IVASucursal));
            IF(Var_FormCobCom = FormaFinanciada) THEN
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
    SELECT CalificaCredito INTO Var_ClienteCalif FROM CLIENTES WHERE ClienteID = Par_ClienteID;

    IF EXISTS (SELECT EsquemaGarantiaLiqID
                FROM ESQUEMAGARANTIALIQ
                WHERE ProducCreditoID = Par_ProduCredID
                AND Clasificacion = Var_ClienteCalif)THEN

        SET Var_Aportacion := Par_MontoSolic * Par_PorcGarLiq/Entero_Cien;

        IF(Par_AporCliente!=Var_Aportacion) THEN
            SET Par_NumErr  := 040;
            SET Par_ErrMen  := 'El Monto de la Garantia Liquida no Corresponde con el Monto Solicitado.' ;
            SET Var_Control := 'montoSolici';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Par_Relacionado = IFNULL(Par_Relacionado,Entero_Cero);

    # Se valida que el numero del credito a renovar no este vacio
	 IF(Par_TipoCredito = Var_Renovado AND Par_Relacionado = Entero_Cero)THEN
        SET Par_NumErr  := 041;
        SET Par_ErrMen  := 'El Credito a Renovar esta Vacio.' ;
        SET Var_Control := 'creditoID';
        LEAVE ManejoErrores;

    END IF;

    # Se valida el credito no tenga pendiente ministraciones por desembolsar
	 IF(Par_TipoCredito = Var_Reestructura AND Par_Relacionado <> Entero_Cero AND Var_EsAgropecuario = Cons_SI)THEN
		IF EXISTS (SELECT CreditoID FROM MINISTRACREDAGRO
					WHERE CreditoID = Par_Relacionado
					AND ClienteID = Par_ClienteID
					AND FechaPagoMinis <= Par_FechaReg
					AND Estatus = EstInactiva)THEN

            SET Par_NumErr  := 042;
            SET Par_ErrMen  := 'Existen Ministraciones Pendientes por Desembolsar.' ;
            SET Var_Control := 'creditoID';
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
   IF(IFNULL(Par_FechaVencim,Fecha_Vacia)  = Fecha_Vacia ) THEN
			SET Par_NumErr := 046;
			SET Par_ErrMen := 'La Fecha de Vencimiento esta Vacia.';
			SET Var_Control := 'fechaVencimien';
			LEAVE ManejoErrores;
		END IF;

  SET Var_SolicitudCre:= (SELECT IFNULL(MAX(SolicitudCreditoID),Entero_Cero) + 1
              FROM SOLICITUDCREDITO);

	IF(Var_ManejaConvenio=Cons_NO)THEN

        SET Par_ConvenioNominaID := (IFNULL(Par_ConvenioNominaID,Entero_Cero));
    END IF;

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
			SET Par_NumErr	:= 067;
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
				SET Par_NumErr	:= 049;
				SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Administracion esta vacia.';
				SET Var_Control	:= 'comAdmonLinPrevLiq';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ComAdmonLinPrevLiq NOT IN (Cons_NO, Cons_SI) ) THEN
				SET Par_NumErr	:= 050;
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
					SET Par_NumErr	:= 051;
					SET Par_ErrMen	:= 'La Forma de pago por Comision por Administracion esta vacia.';
					SET Var_Control	:= 'forPagComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForPagComAdmon NOT IN (Con_Deduccion, Con_Financiado) ) THEN
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
				SET Par_NumErr	:= 057;
				SET Par_ErrMen	:= 'La Comision Previamente Liquidada por Garantia esta vacia.';
				SET Var_Control	:= 'comAdmonLinPrevLiq';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ComGarLinPrevLiq NOT IN (Cons_NO, Cons_SI) ) THEN
				SET Par_NumErr	:= 058;
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
					SET Par_NumErr	:= 059;
					SET Par_ErrMen	:= 'La Forma de pago por Comision por Garantia esta vacia.';
					SET Var_Control	:= 'forPagComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForPagComGarantia NOT IN (Con_Deduccion) ) THEN
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

				SET Var_MontoSimulacion := Par_MontoSolic;
				CALL CRESIMPAGCOMSERGARPRO (
					Par_LineaCreditoID,			Entero_Cero,		Entero_Cero,			Entero_Cero,	Par_NumTransacSim,
					Var_MontoPagComGarantia,	Var_PolizaID,		Var_MontoSimulacion,	Par_FechaVencim,
					SalidaNO,					Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

				SET Var_MontoPagComGarantia := IFNULL(Var_MontoPagComGarantia, Decimal_Cero);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				IF( Var_MontoPagComGarantia = Entero_Cero ) THEN
					SET Par_NumErr	:= 065;
					SET Par_ErrMen	:= 'El Monto de Pago por Comision por Servicio de Garantia no es valido.';
					SET Var_Control	:= 'montoComAdmon';
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

	IF(Par_TipoCredito != Var_Reestructura AND Var_EstatusProd = Estatus_Inactivo) THEN
		SET Par_NumErr := 068;
		SET Par_ErrMen := CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
		SET Var_Control:= 'productoCreditoID';
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO SOLICITUDCREDITO (
		SolicitudCreditoID,     	ProspectoID,            ClienteID,          		FechaRegistro,      		FechaAutoriza,
		MontoSolici,            	MontoAutorizado,        MonedaID,           		ProductoCreditoID,  		PlazoID,
		Estatus,                	TipoDispersion,         CuentaCLABE,        		SucursalID,         		ForCobroComAper,
		MontoPorComAper,        	IVAComAper,             DestinoCreID,       		PromotorID,         		TasaFija,
		TasaBase,               	SobreTasa,              PisoTasa,           		TechoTasa,          		FactorMora,
		FrecuenciaCap,          	PeriodicidadCap,        FrecuenciaInt,      		PeriodicidadInt,    		TipoPagoCapital,
		NumAmortizacion,        	CalendIrregular,        DiaPagoInteres,     		DiaPagoCapital,     		DiaMesInteres,
		DiaMesCapital,          	AjusFecUlVenAmo,        AjusFecExiVen,      		NumTransacSim,      		ValorCAT,
		FechaInhabil,           	AporteCliente,          UsuarioAutoriza,    		FechaRechazo,       		UsuarioRechazo,
		ComentarioRech,         	MotivoRechazo,          TipoCredito,        		NumCreditos,       			Relacionado,
		Proyecto,               	TipoFondeo,             InstitFondeoID,     		LineaFondeo,        		TipoCalInteres,
		TipoGeneraInteres,			CreditoID,				FechaFormalizacion,			MontoFondeado,				PorcentajeFonde,
		CalcInteresID,				NumeroFondeos,			NumAmortInteres,			MontoCuota,					FechaVencimiento,
		GrupoID,					ComentarioEjecutivo,	ComentarioMesaControl,		FechaInicio,				MontoSeguroVida,
		ForCobroSegVida,			ClasiDestinCred,		CicloGrupo,					InstitucionNominaID,		FolioCtrl,
		HorarioVeri,				PorcGarLiq,				UsuarioAltaSol,				FechaInicioAmor,			DescuentoSeguro,
		MontoSegOriginal,			DiaPagoProd,			MontoSeguroCuota,			IVASeguroCuota,				CobraSeguroCuota,
		CobraIVASeguroCuota,		TipoLiquidacion,		CantidadPagar,				TipoConsultaSIC,			FolioConsultaBC,
		FolioConsultaCC,			EsAgropecuario,			FechaCobroComision,			EsAutomatico,				TipoAutomatico,
		InvCredAut,					CtaCredAut,				NivelID,					CobraAccesorios,			Cobertura,
		Prima,						Vigencia,				ConvenioNominaID,			FolioSolici,				QuinquenioID,
		AplicaTabla,				ClabeCtaDomici,			TipoCtaSantander,			CtaSantander,				CtaClabeDisp,
		EsConsolidacionAgro,		DeudorOriginalID,		LineaCreditoID,				ManejaComAdmon,				ComAdmonLinPrevLiq,
		ForCobComAdmon,				ForPagComAdmon,			PorcentajeComAdmon,			ManejaComGarantia,			ComGarLinPrevLiq,
		ForCobComGarantia,			ForPagComGarantia,		PorcentajeComGarantia,		MontoPagComAdmon,			MontoPagComGarantia,
		EmpresaID,					Usuario,				FechaActual,	        	DireccionIP,				ProgramaID,
		Sucursal,					NumTransaccion)
	VALUES (
		Var_SolicitudCre,       	Par_ProspectoID,        Par_ClienteID,          	Par_FechaReg,           	Fecha_Vacia,
		Par_MontoSolic,         	Decimal_Cero,           Par_Moneda,             	Par_ProduCredID,        	Par_PlazoID,
		EstInactiva,            	Par_TipoDisper,         Par_CuentaClabe,        	Par_SucursalID,         	Var_FormCobCom,
		Par_ComApertura,        	Par_IVAComAper,         Par_DestinoCre,         	Par_Promotor,           	Par_TasaFija,
		Par_TasaBase,           	Par_SobreTasa,          Par_PisoTasa,           	Par_TechoTasa,          	Par_FactorMora,
		Par_FrecCapital,        	Par_PeriodCap,          Par_FrecInter,          	Par_PeriodInt,          	Par_TipoPagCap,
		Par_NumAmorti,          	Par_CalIrreg,           Par_DiaPagInt,          	Par_DiaPagCap,          	Par_DiaMesInter,
		Par_DiaMesCap,          	Par_AjFUlVenAm,         Par_AjuFecExiVe,        	Par_NumTransacSim,      	Par_CAT,
		Par_FechInhabil,        	Par_AporCliente,        Entero_Cero,            	Fecha_Vacia,            	Entero_Cero,
		Cadena_Vacia,           	Entero_Cero,            Par_TipoCredito,        	Par_NumCreditos,        	Par_Relacionado,
		Par_Proyecto,           	Par_TipoFondeo,         Par_InstitFondeoID,     	Par_LineaFondeo,        	Par_TipoCalInt,
		Var_TipoGeneraInteres,		Entero_Cero,			Fecha_Vacia,				Entero_Cero,				Entero_Cero,
		Par_CalcInteres,			Entero_Cero,			Par_NumAmortInt,			Par_MontoCuota,				Par_FechaVencim,
		Par_GrupoID,				Cadena_Vacia,			Cadena_Vacia,				Par_FechaInicio,			Par_MontoSeguroVida,
		Par_ForCobroSegVida,		Par_ClasiDestinCred,	Var_CicloActual,			Par_InstitNominaID,			Par_FolioCtrl,
		Par_HorarioVeri,			Par_PorcGarLiq,			UsuarioAltaSolicitud,		Par_FechaInicioAmor,		Par_DescuentoSeguro,
		Par_MontoSegOriginal,		Var_DiaPagoProd,		Var_MontoSeguroCuota,		Var_IVASeguroCuota,			Var_CobraSeguroCuota,
		Var_CobraIVASeguroCuota,	Par_TipoLiquidacion,	Par_CantidadPagar,			Par_TipoConsultaSIC,		Par_FolioConsultaBC,
		Par_FolioConsultaCC,		Var_EsAgropecuario,		Par_FechaCobroComision,		Var_EsAutomatico,			Var_TipoAutomatico,
		Par_InvCredAut,				Par_CtaCredAut,			Var_NivelID,				Var_CobraAccesorios,		Par_Cobertura,
		Par_Prima,					Par_Vigencia,			Par_ConvenioNominaID,		Par_FolioSolici,			Par_QuinquenioID,
		Var_AplicaTabla,			Par_ClabeDomiciliacion, Par_TipoCtaSantander,		Par_CtaSantander,			Par_CtaClabeDisp,
		Var_ReqConsolidacionAgro,	Par_DeudorOriginalID,	Par_LineaCreditoID,			Par_ManejaComAdmon,			Par_ComAdmonLinPrevLiq,
		Var_ForCobComAdmon,			Par_ForPagComAdmon,		Var_PorcentajeComAdmon,		Par_ManejaComGarantia,		Par_ComGarLinPrevLiq,
		Var_ForCobComGarantia,		Par_ForPagComGarantia,	Var_PorcentajeComGarantia,	Var_MontoPagComAdmon,		Var_MontoPagComGarantia,
		Par_EmpresaID,				Aud_Usuario,			DATE(Aud_FechaActual),		Aud_DireccionIP,			Aud_ProgramaID,
		Aud_Sucursal,				Aud_NumTransaccion);

		# Actualizar estatus de la solicitud de credito
	CALL ESTATUSSOLCREDITOSALT(
		Var_SolicitudCre,           Entero_Cero,         EstInactiva,               Cadena_Vacia,             Cadena_Vacia,
		SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,
		Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);

	IF(Par_NumErr <> Entero_Cero)THEN
	LEAVE ManejoErrores;
	END IF;

	# Si el credito es renovado se obtiene el numero del credito relacionado(credito a renovar)
	IF(Par_TipoCredito = Var_Renovado) THEN
		SELECT Relacionado INTO Var_Relacionado
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Var_SolicitudCre;

        SET Var_Relacionado =  IFNULL(Var_Relacionado, Entero_Cero);
			/* Si el valor del credito a renovar es 0 se actualiza el campo Relacionado en la tabla
				SOLICITUDCREDITO con el valor recibido de parametro.
            */
			IF(Var_Relacionado = Entero_Cero)THEN
				UPDATE SOLICITUDCREDITO
                SET Relacionado = Par_Relacionado
                WHERE SolicitudCreditoID = Var_SolicitudCre;
            END IF;

    END IF;


	# ------------------------ SE DA DE ALTA EL INTEGRANTE DE GRUPO DE CREDITO ------------------------
	IF(Par_GrupoID != Entero_Cero AND Var_EsAgropecuario = SalidaNO) THEN
		CALL INTEGRAGRUPOSALT(
			Par_GrupoID,        Var_SolicitudCre,   Par_ClienteID,      Par_ProspectoID,    Estatus_Activo,
			Par_FechaReg,       Entero_Cero,        Entero_Cero,        Par_TipoIntegr,     SalidaNO,
			Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
			Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := Par_NumErr;
			SET Par_ErrMen := Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
	ELSE
		IF(Par_GrupoID != Entero_Cero AND Var_EsAgropecuario = SalidaSI) THEN
			CALL INTEGRAGRUPOSAGROALT(
			Par_GrupoID,        Var_SolicitudCre,   Par_ClienteID,      Par_ProspectoID,    Par_FechaReg,
			SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Par_NumErr := Par_NumErr;
				SET Par_ErrMen := Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
        END IF;
	END IF;


    SELECT 	Pro.RequiereCheckList
		INTO 	Var_RequiereCheckList
		FROM PRODUCTOSCREDITO Pro,
			 SOLICITUDCREDITO Sol
		WHERE Pro.ProducCreditoID = Sol.ProductoCreditoID
		AND Sol.solicitudCreditoID = Var_SolicitudCre;


	IF (IFNULL(Var_RequiereCheckList,Cons_SI) = Cons_SI)THEN  -- vk
		# ------------------------- SE DA DE ALTA LOS DOCUMENTOS REQUERIDO PARA CHECKLIST DE SOLICITUD DE CREDITO ----------
		CALL SOLICIDOCENTALT(Var_SolicitudCre,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
							 Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
							 Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := Par_NumErr;
			SET Par_ErrMen := Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
	END IF;



	# --------- SE REGISTRAN DATOS DE CREDITOS DE NOMINA EN: NOMINAEMPLEADOS y SOLICITUDCREDITOBE -----------------------
	IF(Var_CredNomina = Cred_Nomina) THEN
		CALL SOLICITUDCREDITOBEALT(
			Var_SolicitudCre,   Par_ClienteID,   Par_ProspectoID, Par_InstitNominaID, Entero_Cero ,
			Par_FolioCtrl,      SalidaNO,        Par_NumErr,      Par_ErrMen,         Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN

			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ProspectoID, Entero_Cero) = Entero_Cero) THEN

			SET Var_ClienteReg= (SELECT ClienteID FROM NOMINAEMPLEADOS
								  WHERE InstitNominaID = Par_InstitNominaID
									AND ClienteID = Par_ClienteID
									LIMIT 1);

			IF(IFNULL(Var_ClienteReg,Entero_Cero) = Entero_Cero) THEN
			   CALL NOMINAEMPLEADOSALT (
					Par_InstitNominaID, Par_ClienteID,      Par_ProspectoID,  	Entero_Cero,			Entero_Cero,
                    Entero_Cero,		Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,			Fecha_Vacia,
                    Cadena_Vacia,		SalidaNO ,          Par_NumErr,
					Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN

					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE

			 SET Var_ProspectoReg= (SELECT ProspectoID FROM NOMINAEMPLEADOS
									 WHERE InstitNominaID = Par_InstitNominaID
									   AND ProspectoID = Par_ProspectoID
									   LIMIT 1);

			 IF(IFNULL(Var_ProspectoReg,Entero_Cero))=Entero_Cero THEN
				   CALL NOMINAEMPLEADOSALT (
						Par_InstitNominaID, Par_ClienteID,  Par_ProspectoID,  	Entero_Cero,			Entero_Cero,
						Entero_Cero,		Cadena_Vacia,	Entero_Cero,		Cadena_Vacia,			Fecha_Vacia,
						Cadena_Vacia,       SalidaNO ,      Par_NumErr,
						Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,
						Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN

						LEAVE ManejoErrores;
					END IF;
			END IF;
		END IF;  -- IF(IFNULL(Par_ProspectoID, Entero_Cero) = Entero_Cero) THEN
	END IF; -- IF(Var_CredNomina = Cred_Nomina) THEN

	/* Se obtiene el numero de solicitud de la tabla AVALESPORSOLICI para una solicitud Reestructurado
		en caso de que se le hayan asignados avales*/
	IF(Par_TipoCredito = Var_Reestructura) THEN


		SELECT Sol.SolicitudCreditoID --
		INTO Var_SolicitudOrigen
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_Relacionado
		LIMIT 1;

		SELECT Ava.SolicitudCreditoID INTO Var_SolicituAvales
			FROM CREDITOS Cre,
			SOLICITUDCREDITO Sol,
			AVALESPORSOLICI Ava
		WHERE Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			AND Ava.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Cre.CreditoID=Par_Relacionado LIMIT 1;

		IF (Var_SolicituAvales > Entero_Cero) THEN

			UPDATE SOLICITUDCREDITO
			SET SolicitudOrigen = Var_SolicituAvales
			WHERE SolicitudCreditoID = Var_SolicitudCre;


		INSERT INTO AVALESPORSOLICI (
				SolicitudCreditoID,	AvalID,				ClienteID,		ProspectoID,		Estatus,
				FechaRegistro,		EstatusSolicitud,	TipoRelacionID,	TiempoDeConocido,	EmpresaID,
				Usuario,			FechaActual,		DireccionIP,	ProgramaID,			Sucursal,
				NumTransaccion)
		SELECT Var_SolicitudCre,	AvalID, 			ClienteID,		ProspectoID,		Estatus,
				FechaRegistro,		EstatusSolicitud,	TipoRelacionID,	TiempoDeConocido,	EmpresaID,
				Usuario, 			FechaActual,		DireccionIP,	ProgramaID,			Sucursal,
				NumTransaccion
			FROM AVALESPORSOLICI
			WHERE SolicitudCreditoID = Var_SolicituAvales;

		END IF;

		UPDATE AVALESPORSOLICI
		SET EstatusSolicitud = 'O',
		Estatus = 'A'
		WHERE SolicitudCreditoID = Var_SolicitudCre;

		INSERT INTO ASIGNAGARANTIAS (
				SolicitudCreditoID,	CreditoID,	GarantiaID,		MontoAsignado,	FechaRegistro,
				Estatus,			EmpresaID,	Usuario,		FechaActual,	DireccionIP,
				ProgramaID,			Sucursal,	NumTransaccion)
		SELECT Var_SolicitudCre,	CreditoID, 	GarantiaID,		MontoAsignado,	FechaRegistro,
				Estatus,			EmpresaID,	Usuario,		FechaActual, 	DireccionIP,
				ProgramaID,			Sucursal,	NumTransaccion
		FROM ASIGNAGARANTIAS
		WHERE SolicitudCreditoID = Var_SolicitudOrigen;

		UPDATE ASIGNAGARANTIAS SET
			EstatusSolicitud = 'O',
			Estatus = 'A'
		WHERE SolicitudCreditoID = Var_SolicitudCre;


	END IF;

	IF(Var_CobraAccesorios = Cons_SI) THEN
		# SE DAN DE ALTA LOS ACCESORIOS QUE COBRA UN CREDITO CUANDO EL TIPO DE COBRO DEL ACCESORIO ES ANTICIPADA O DEDUCCION
		CALL DETALLEACCESORIOSALT(
			Entero_Cero,		Var_SolicitudCre,		Par_ProduCredID,		Par_ClienteID,			Par_NumTransacSim,
			Par_PlazoID,		TipoPantalla,			Par_MontoSolic,			Par_ConvenioNominaID,	SalidaNO,				Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Par_NumErr := Par_NumErr;
			SET Par_ErrMen := Par_ErrMen;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Var_CobraGarFin = Cons_SI) THEN
	CALL DETGARANTIALIQUIDAALT(
		Entero_Cero,		Var_SolicitudCre,		Par_ProduCredID,	Par_ClienteID,		SalidaNO,
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
				Var_SolicitudCre, 	Par_ClienteID, 		Par_ProspectoID,
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


	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Solicitud de Credito Agregada Exitosamente: ', CONVERT(Var_SolicitudCre, CHAR));
	SET Var_Control := 'solicitudCreditoID';


	END ManejoErrores;

	IF(Par_Salida =SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Var_SolicitudCre AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;

END TerminaStore$$
