-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSCON`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSCON`(
-- --------------------------------------------------------------------
-- SP DE CONSULTA DE LOS CREDITOS
-- --------------------------------------------------------------------
	Par_CreditoID		BIGINT(12),			-- Numero de Credito
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_CliPagIVA   	CHAR(1);
	DECLARE Var_IVAIntOrd   	CHAR(1);
	DECLARE Var_IVAIntMor   	CHAR(1);
	DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
	DECLARE Var_ValIVAIntMo 	DECIMAL(12,2);
	DECLARE Var_ValIVAGen   	DECIMAL(12,2);
	DECLARE Var_IVASucurs   	DECIMAL(12,2);
	DECLARE EstatusPagado   	CHAR(1);
	DECLARE Var_SucCredito      INT(11);
	DECLARE Var_FecActual       DATE;
	DECLARE Var_TotAdeudo       VARCHAR(20);
	DECLARE Var_CapVigIns		VARCHAR(20);
	DECLARE Var_TotAtrasado     DECIMAL(14,2);
	DECLARE Var_MontoExigible	VARCHAR(20);
	DECLARE Var_FechaExigible 	VARCHAR(20);
	DECLARE Var_AmortizacionID	INT(11);
	DECLARE Var_MontoGarLiq     DECIMAL(14,2);
	DECLARE Var_MontoComAp		DECIMAL(14,2);
	DECLARE Con_CreDiasAtraso	INT(11);
	DECLARE Con_Finiquito       INT(11);
	DECLARE Con_Finiquito2      INT(11);
	DECLARE Con_Generales       INT(11);
	DECLARE Var_FechaVencim     DATE;
	DECLARE Var_FecProxPago     DATE;
	DECLARE Var_ProyInPagAde    CHAR(1);
	DECLARE Var_SaldoCapita     DECIMAL(14,2);
	DECLARE Var_SaldoCapAtra    DECIMAL(14,2);
	DECLARE Var_DiasPermPagAnt  INT(11);
	DECLARE Var_PrductoCreID    INT(11);
	DECLARE Var_Frecuencia      CHAR(1);
	DECLARE Var_DiasAntici      INT(11);
	DECLARE Var_CreTasa         DECIMAL(12,4);
	DECLARE Var_DiasCredito     INT(11);
	DECLARE Var_IntAntici       DECIMAL(14,4);
	DECLARE Var_ComAntici       DECIMAL(14,4);
	DECLARE Var_PermiteLiqAnt   CHAR(1);
	DECLARE Var_CobraComLiqAnt  CHAR(1);
	DECLARE Var_TipComLiqAnt    CHAR(1);
	DECLARE Var_ComLiqAnt       DECIMAL(14,4);
	DECLARE Var_DiasGraciaLiq   INT(11);
	DECLARE Var_IntActual       DECIMAL(14,2);
	DECLARE Var_FecVenCred      DATE;
	DECLARE Var_ProxAmorti      INT;
	DECLARE Var_NumProyInteres  INT;
	DECLARE Var_CapitaAdela     DECIMAL(14,2);
	DECLARE Var_IntProActual    DECIMAL(14,4);
	DECLARE Var_TotPagAdela     DECIMAL(14,2);
	DECLARE Var_FecDiasProPag   DATE;
	DECLARE Var_SaldoInsoluto   DECIMAL(14,2);
	DECLARE Var_Interes    		DECIMAL(14,4);
	DECLARE Var_NombreCompleto	VARCHAR(100);
	DECLARE Var_Sucursal		VARCHAR(100);
	DECLARE Var_RefScotiabanck  VARCHAR(50);
	DECLARE Var_RefBanamex 		VARCHAR(50);
	DECLARE Par_NumErr    		INT(11);
	DECLARE Par_ErrMen    		VARCHAR(400);
	DECLARE Var_CuotasAtraso	INT;
	DECLARE Var_FechaUltCuota	DATE;
	DECLARE Var_UltCuotaPagada 	INT;
	DECLARE Var_totalPrimerCuota FLOAT;
	DECLARE	Var_EsGrupal		CHAR(1);
	DECLARE Var_ProrrateoPago	CHAR(1);
	DECLARE	Var_PrimCuoAtr		INT;
	DECLARE	Var_GrupoID			INT;
	DECLARE Var_EstatusCredito	CHAR(1);
	DECLARE Var_NumRenovacion	INT(5);
	DECLARE Var_Relacionado		BIGINT(12);
	DECLARE Var_CreditoOrigenID	INT(11);
	DECLARE Var_CreditoDestinoID INT(11);
	DECLARE Var_Origen			CHAR(1);
	DECLARE Var_NumReestructura	INT(5);
	DECLARE Var_SolicitudCreditoID 	BIGINT(20);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_NumDiasAtraOri	INT(11);
	DECLARE Var_MontoComision   DECIMAL(12,4);
	DECLARE Var_MontoInteres    DECIMAL(12,4);
	DECLARE Con_PagVertical		INT(11);
	DECLARE Var_TipoCalInteres	INT(11);
	DECLARE Var_SaldoIVAInteres	DECIMAL(12,4);
	DECLARE Var_OtrasComAntic	DECIMAL(12,2);
	DECLARE Var_IVAOtrasComAnt	DECIMAL(12,2);
    DECLARE Var_CreditoIDSAFI	BIGINT(12);
    DECLARE Var_CreditoIDCte	VARCHAR(20);
    DECLARE Var_CreditoText		VARCHAR(20);
	DECLARE Var_MontoBloq		DECIMAL(14,2);
    DECLARE Var_MontoMinisPen	DECIMAL(14,2);
    DECLARE Var_PorcenGarLiq	DECIMAL(14,2);
    DECLARE Var_ComAperPagado	DECIMAL(14,2);
    DECLARE Var_MontoPendPagCom	DECIMAL(14,2);
    DECLARE Var_SaldoInsolCar	DECIMAL(14,2);		-- Saldo Insuluto de toda la cartera de creditos
    DECLARE Var_SumatoriaCred	DECIMAL(14,2);		-- Sumatoria de los creditos mas grandes
    DECLARE Var_ForCobComAp		CHAR(1);	-- Forma de Cobro de la Comision por Apertura
    DECLARE Var_LineaCreditoID	BIGINT(20); 		-- Identificador de la línea de crédito

    DECLARE Var_CobraComAnual	CHAR(1); 		-- Indica si cobra o no comisión anual de linea de crédito
    DECLARE Var_TipoComAnual	CHAR(1); 		-- Indica el tipo de comisión de anual de linea de crédito
    DECLARE Var_ValorComAnual	DECIMAL(14,2);		-- Indica el monto de la comisón anual de la linea
    DECLARE Var_ComisionCobrada CHAR(1);		-- Indica si la comisión anual ya fue cobrada
    DECLARE Var_SaldoComAnual	DECIMAL(14,2);		-- Indica el Saldo Deudor de la comisión anual de la linea

    DECLARE SaldoComAnualLin 	DECIMAL(14,2);		-- Indica el monto de la comisión anual a pagar
    DECLARE SaldoIVAComAnualLin DECIMAL(14,2);		-- Indica el monto de iva de la comisión anual a pagar
    DECLARE Var_MontoFOGAFIPag	DECIMAL(14,2);
    DECLARE Var_SaldoGarFOGAFI	DECIMAL(14,2);

    DECLARE Var_CicloGrupo		DECIMAL(12,2);
    DECLARE Var_ClienteID 		BIGINT(20);
    DECLARE Var_CicloActual 	INT(11);
    DECLARE Var_FechaSis		DATE;
	DECLARE Var_IVANotaCargo	DECIMAL(14,2);		-- Variable para el porcentaje que se cobra por nota de cargo

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero     	DECIMAL(12,4);
	DECLARE Decimal_Cien     	DECIMAL(12,4);
	DECLARE Con_Principal   	INT(11);
	DECLARE Con_Foranea     	INT(11);
	DECLARE Con_PagareTfija 	INT(11);
	DECLARE Con_PagareImp   	INT(11);
	DECLARE Con_PagoCred    	INT(11);
	DECLARE Con_ExgibleSinProy  INT(11);
	DECLARE Con_PagCreExi   	INT(11);
	DECLARE Con_PagCreExi2   	INT(11);
	DECLARE Con_ProFecPag   	INT(11);
	DECLARE Con_AvaCredito  	INT(11);
	DECLARE Con_ComDesVent  	INT(11);
	DECLARE Con_QuitasCond      INT(11);
	DECLARE Con_GL          	INT(11);
	DECLARE Con_ResCliente  	INT(11);
	DECLARE Con_GarCredito  	INT(11);
	DECLARE Con_CreditosWS      INT(11);
	DECLARE Con_CreditosBEWS    INT(11);
	DECLARE Con_CredSegCuota    INT(11);
	DECLARE Con_CredCond		INT(11);
	DECLARE Con_CredComCargCta	INT(11);
	DECLARE Con_Agropecuario  	INT(11);
	DECLARE Con_CambioFondeo	INT(11);
    DECLARE Con_AplicaGarAgro	INT(11);
    DECLARE Con_Riesgos			INT(11);
    DECLARE Con_CobroAccesorios	INT(11); 		-- Constante para Consulta de Accesorios
    DECLARE Con_CobroGarFOGAFI	INT(11);
	DECLARE Con_InfoCredSuspencion	INT(11);		-- Numero de consulta de Informacion del credito a realizar la Suspencion
	DECLARE Con_CambioFuentFondCred	INT(11);	-- Consulta para pantalla de cambio fuente de fondeo del modulo de cartera para el cliente Mexi
	DECLARE Con_InstitucionConvenio	INT(11);	-- Consulta para obtener la institucion de nomia y su correspondiente convenio.
	DECLARE EstatusVigente  	CHAR(1);
	DECLARE EstatusAtras    	CHAR(1);
	DECLARE EstatusVencido  	CHAR(1);
	DECLARE SiPagaIVA       	CHAR(1);
	DECLARE Esta_Activo     	CHAR(1);
	DECLARE Var_No          	CHAR(1);
	DECLARE diasFaltaPago   	INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE SI_ProyectInt   	CHAR(1);
	DECLARE SI_PermiteLiqAnt    CHAR(1);
	DECLARE SI_CobraLiqAnt  	CHAR(1);
	DECLARE Proyeccion_Int  	CHAR(1);
	DECLARE Monto_Fijo      	CHAR(1);
	DECLARE Por_Porcentaje  	CHAR(1);
	DECLARE Tol_DifPago     	DECIMAL(10,4);
	DECLARE Con_ReferenciasBanc	INT(11);
	DECLARE Si_Grupal			CHAR(1);
	DECLARE Si_Prorratea		CHAR(1);
	DECLARE CtaBanamex			INT(11);
	DECLARE SucBanamex			INT(11);
	DECLARE CtaInverlat			BIGINT;
	DECLARE Con_CreditoRenovar	INT(4);
	DECLARE OrigenRenovacion	CHAR(1);
	DECLARE Esta_Desembolso		CHAR(1);
	DECLARE Con_CreditoReest	INT(4);
	DECLARE OrigenReestructura	CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);
	DECLARE Estatus_Liberado	CHAR(1);
	DECLARE Estatus_Autorizado	CHAR(1);
	DECLARE EsOficial			CHAR(1);

	DECLARE Origen_Nuevo		CHAR(1);  -- tipo de credito N
	DECLARE Tipo_NuevoDes		CHAR(15); -- tipo de credito N = Nuevo
	DECLARE Tipo_RenovadoDes	CHAR(15); -- tipo de credito O = Renovado
	DECLARE Tipo_ReestrucDes	CHAR(15); -- tipo de credito R = Reeestructurado
    DECLARE Tipo_ReacreditadoDes	CHAR(15); -- Tipo de credito Reacreditamiento
	DECLARE Fecha_Null	 		VARCHAR(10);
	DECLARE Int_SalInsol    	INT;
	DECLARE Int_SalGlobal   	INT;
	DECLARE Str_SI   			CHAR(1);
	DECLARE Blo_DepGarLiq     	INT(11);  -- Tipo de Bloqueo Automatico en cada Deposito
	DECLARE Tipo_Bloqueo    	CHAR(1);  -- Tipo de Movimiento de Bloqueo por garantia liquida
	DECLARE Estatus_Pendiente  	CHAR(1);  -- Estatus pendiente de una ministracion credito agro
	DECLARE var_NumIntegrante	INT(11);
	DECLARE Contador 			INT(11);
	DECLARE	ContaIntegra		INT(11);
    DECLARE Var_aval_2			VARCHAR(300);
	DECLARE Var_direcAval_2		VARCHAR (500);
    DECLARE Con_AvaCreditoConsol INT(11);
    DECLARE For_CobProgramado	CHAR(1);  -- Forma de cobro de la comision por apertura: PROGRAMADO
    DECLARE For_CobAnticipado	CHAR(1);  -- Forma de cobro del accesorio: ANTICIPADO
    DECLARE Con_MontoFOGAFI		INT(11);
    DECLARE Con_MontoAutoMod	INT(11);
	DECLARE RefPayCash			VARCHAR(20);
	DECLARE CanalCredito		INT(11);
	DECLARE PayCash				INT(11);

    DECLARE Var_CliSFG        	INT(11);
	DECLARE Var_cliEsp 			INT(11);
	DECLARE Var_CartaLiq		INT(11);
	DECLARE Var_ConNotaCargo	TINYINT UNSIGNED;	-- Consulta para la pantalla de notas de cargo
	DECLARE Con_InformacionCredito	TINYINT UNSIGNED;	-- Pantalla Consulta de informacion de Credito

	DECLARE Var_EstatusCre	CHAR(1);

	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Decimal_Cien        := 100.0;
	SET Con_Principal       := 1;
	SET Con_Foranea         := 2;
	SET Con_PagareImp       := 3;
	SET Con_PagareTfija     := 4;
	SET Con_ExgibleSinProy  := 5;

	SET Con_PagoCred        := 7;
	SET Con_PagCreExi       := 8;
	SET Con_PagCreExi2      := 2;
	SET Con_ProFecPag       := 9;
	SET Con_AvaCredito      := 10;
	SET Con_ComDesVent      := 11;
	SET Con_GL              := 12;
	SET Con_ResCliente      := 13;
	SET Con_GarCredito      := 14;
	SET Con_CreDiasAtraso   := 15;
	SET Con_Finiquito       := 17;
	SET Con_Finiquito2      := 1;
	SET Con_Generales       := 18;
	SET Con_CreditosWS      := 19;
	SET Con_CreditosBEWS    := 20;
	SET Con_ReferenciasBanc	:= 21;
	SET Con_CreditoRenovar	:= 22;
	SET Con_CreditoReest    := 23;
	SET Con_PagVertical		:= 24;
	SET Con_QuitasCond      := 25;
	SET Con_CredSegCuota    := 26;
	SET Con_CredCond		:= 27;
	SET Con_CredComCargCta	:= 28;
	SET Con_Agropecuario	:= 29;		-- Consulta de Creditos Agropecuarios
	SET Con_CambioFondeo	:= 30;		-- Consulta cambio fuente de fondeo
    SET Con_AplicaGarAgro	:= 31;		-- Consulta aplicacion de garantias Agro
    SET Con_Riesgos			:= 36;		-- Saldos para Evaluacion de Riesgos
    SET Con_AvaCreditoConsol:= 37;
    SET Con_CobroAccesorios	:= 40;		-- Consulta Cobro Accesorios Ventanilla
	SET Con_CobroGarFOGAFI	:= 41;
    SET Con_MontoFOGAFI 	:= 42;
    SET Con_MontoAutoMod	:= 43;		-- CONSULTA DE CREDITOS CON MONTOS AUTORIZADOS MODIFICADOS
	SET Con_InfoCredSuspencion	:= 44;	-- Numero de consulta de Informacion del credito a realizar la Suspencion
	SET Con_CambioFuentFondCred	:= 45;	-- Consulta para pantalla de cambio fuente de fondeo del modulo de cartera para el cliente Mexi
	SET Var_CartaLiq		:= 38;		-- Lista Carta de liquidacion
	SET Var_ConNotaCargo	:= 51;		-- Consulta para la pantalla de notas de cargo
	SET Con_InstitucionConvenio := 52;
	SET Con_InformacionCredito 	:= 53;
	SET EstatusVigente  	:= 'V';
	SET EstatusAtras    	:= 'A';
	SET SiPagaIVA       	:= 'S';
	SET EstatusPagado   	:= 'P';
	SET EstatusVencido  	:= 'B';
	SET Var_No          	:= 'N';
	SET Esta_Activo     	:= 'A';
	SET Salida_NO       	:= 'N';
	SET SI_ProyectInt   	:= 'S';
	SET SI_PermiteLiqAnt    := 'S';
	SET SI_CobraLiqAnt      := 'S';
	SET Proyeccion_Int      := 'P';
	SET Monto_Fijo          := 'M';
	SET Por_Porcentaje      := 'S';
	SET Tol_DifPago       	:= 0.02;
	SET Var_FechaUltCuota   := Fecha_Vacia;
	SET Si_Grupal			:= 'S';
	SET Si_Prorratea		:= 'S';
	SET OrigenRenovacion	:= 'O';
	SET Esta_Desembolso		:= 'D';
	SET OrigenReestructura  := 'R';
	SET Estatus_Inactivo	:= 'I';
	SET Estatus_Liberado	:= 'L';
	SET Estatus_Autorizado	:= 'A';
	SET EsOficial			:= 'S';
	SET CtaBanamex			:= IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CtaBanamex' ),Entero_Cero);
	SET	SucBanamex			:= IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'SucBanamex' ),Entero_Cero);
	SET CtaInverlat			:= IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CtaInverlat' ),Entero_Cero);
	SET Aud_FechaActual 	:= NOW();
	SET Var_IVANotaCargo	:= Entero_Cero;

	SET Origen_Nuevo				:='N';
	SET Tipo_NuevoDes				:='NORMAL';
	SET Tipo_RenovadoDes			:='RENOVADO';
	SET Tipo_ReestrucDes			:='REESTRUCTURADO';
	SET Fecha_Null					:='1900-01-01';
	SET Int_SalInsol    			:= 1;               -- Calculo de Interes Sobre Saldos Insolutos
	SET Int_SalGlobal   			:= 2;               -- Calculo de Interes Sobre Saldos Globales (Monto Original)
	SET Str_SI						:= 'S';
	SET Blo_DepGarLiq     			:= 8;
	SET Tipo_Bloqueo    			:= 'B';
    SET Estatus_Pendiente			:= 'P';
    SET Tipo_ReacreditadoDes		:= 'RECREDITAMIENTO';
    SET For_CobProgramado			:= 'P';
    SET For_CobAnticipado			:= 'A'; 		-- Constante Cobro de Accesorios Anticipados
    SET Var_CliSFG      := 29;
    SET  Var_CliEsp :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');
	SET CanalCredito				:= 1;
	SET PayCash						:= 61;

	IF(Par_NumCon = Con_PagCreExi 		OR Par_NumCon = Con_PagoCred OR
	   Par_NumCon = Con_ExgibleSinProy 	OR Par_NumCon = Con_Finiquito OR
	   Par_NumCon = Con_CreditosBEWS 	OR Par_NumCon = Con_QuitasCond OR
	   Par_NumCon = Con_CredComCargCta  OR Par_NumCon = Con_InformacionCredito) THEN

		SELECT Cli.PagaIVA, 			Cre.SucursalID, 	Pro.CobraIVAInteres, 	Pro.CobraIVAMora,  	Pro.ProyInteresPagAde,
			   Pro.ProducCreditoID,		Cre.FrecuenciaCap,  Cre.TasaFija,   		Cre.FechaVencimien,	(Cre.SaldoCapVigent + Cre.SaldCapVenNoExi),
               (Cre.SaldoCapAtrasad +
               Cre.SaldoCapVencido),	Pro.EsGrupal, 		Pro.ProrrateoPago, 		GrupoID, 			MontoComApert,
               ComAperPagado,			Cre.ForCobroComAper,LineaCreditoID
			INTO
				Var_CliPagIVA,      	Var_SucCredito, 	Var_IVAIntOrd,  		Var_IVAIntMor,  	Var_ProyInPagAde,
				Var_PrductoCreID,  		Var_Frecuencia, 	Var_CreTasa,    		Var_FecVenCred, 	Var_SaldoCapita,
				Var_SaldoCapAtra,		Var_EsGrupal,		Var_ProrrateoPago, 		Var_GrupoID, 		Var_MontoComAp,
                Var_ComAperPagado,		Var_ForCobComAp,	Var_LineaCreditoID
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli
			WHERE Cre.CreditoID     = Par_CreditoID
			  AND Cre.ProductoCreditoID = Pro.ProducCreditoID
			  AND Cre.ClienteID     = Cli.ClienteID;

		SET Var_SaldoInsoluto   := IFNULL(Var_SaldoCapita, Entero_Cero) +
								   IFNULL(Var_SaldoCapAtra, Entero_Cero);

		SET Var_CliPagIVA   	:= IFNULL(Var_CliPagIVA, SiPagaIVA);
		SET Var_IVAIntOrd   	:= IFNULL(Var_IVAIntOrd, SiPagaIVA);
		SET Var_IVAIntMor   	:= IFNULL(Var_IVAIntMor, SiPagaIVA);

		SET Var_ValIVAIntOr := Entero_Cero;
		SET Var_ValIVAIntMo := Entero_Cero;
		SET Var_ValIVAGen   := Entero_Cero;

		-- Asignamos el monto del iva de la sucursal
		SET Var_IVANotaCargo := IFNULL((SELECT IVA
											FROM SUCURSALES
											 WHERE  SucursalID = Var_SucCredito), Entero_Cero);

		  IF (Var_CliPagIVA = SiPagaIVA) THEN
			SET	Var_IVASucurs	:= IFNULL((SELECT IVA
											FROM SUCURSALES
											 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

			-- IVA General (Comisiones y Otro Cargos)
			SET Var_ValIVAGen  := Var_IVASucurs;
					-- Verificamos si Paga IVA de Interes Ordinario
			IF (Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr  := Var_IVASucurs;
			END IF;

			IF (Var_IVAIntMor = SiPagaIVA) THEN
				SET Var_ValIVAIntMo  := Var_IVASucurs;
			END IF;
		END IF;

	END IF;  -- Fin de la Verificacion de iva

	SELECT FechaSistema, DiasCredito INTO Var_FecActual, Var_DiasCredito
		FROM PARAMETROSSIS;

	IF(Par_NumCon = Con_Principal) THEN
		SET diasFaltaPago := (DATEDIFF( Var_FecActual,(SELECT MIN(FechaExigible)
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
				AND FechaExigible <= Var_FecActual
				AND Estatus       != EstatusPagado)));

		-- Obtenemos la referencia
		SELECT 	Referencia
		INTO	RefPayCash
		FROM REFPAGOSXINST
		WHERE TipoCanalID = CanalCredito
			AND InstitucionID = PayCash
			AND InstrumentoID = Par_CreditoID;

		SET RefPayCash	:= Par_CreditoID;
		-- Validacion de datos nulos
		SET RefPayCash := IFNULL(RefPayCash, Cadena_Vacia);

		SELECT
			Cre.CreditoID,																				Cre.ClienteID,						Cre.LineaCreditoID,													Cre.ProductoCreditoID,				Cre.CuentaID,
			Cre.Relacionado,																			Cre.SolicitudCreditoID,				FORMAT(Cre.MontoCredito,2)AS MontoCredito,							Cre.MonedaID,						Cre.FechaInicio,
			Cre.FechaVencimien,																			Cre.FactorMora,						Cre.CalcInteresID,													Cre.TasaBase,						Cre.TasaFija,
			Cre.SobreTasa,																				Cre.PisoTasa,						Cre.TechoTasa,														Cre.FechaInhabil,					Cre.AjusFecExiVen,
			Cre.CalendIrregular,																		Cre.AjusFecUlVenAmo,				Cre.TipoPagoCapital,												Cre.FrecuenciaInt,					Cre.FrecuenciaCap,
			Cre.PeriodicidadInt,																		Cre.PeriodicidadCap,				Cre.DiaPagoInteres,													Cre.DiaPagoCapital,					Cre.DiaMesInteres,
			Cre.DiaMesCapital,																			Cre.InstitFondeoID,					Cre.LineaFondeo,													Cre.Estatus,						Cre.FechTraspasVenc,
			Cre.FechTerminacion,																		Cre.NumAmortizacion,				Cre.NumTransacSim,													Cre.FactorMora,						Cre.FechaMinistrado,
			Cre.TipoFondeo,
			CASE WHEN Cre.FechaAutoriza=Fecha_Null THEN Fecha_Vacia
			ELSE Cre.FechaAutoriza	END AS FechaAutoriza,
			Cre.UsuarioAutoriza,																		Cre.MontoComApert,					Cre.IVAComApertura,													Cre.ValorCAT,						Cre.PlazoID,
			Cre.TipoDispersion,																			Cre.CuentaCLABE,					Cre.TipoCalInteres,													Cre.DestinoCreID,					Cre.NumAmortInteres,
			Cre.MontoCuota,																				Sol.ComentarioMesaControl,			FUNCIONTOTDEUDACRE(Par_CreditoID) AS TotalAdeudo,
			FUNCIONEXIGIBLE(Par_CreditoID)	AS TotalExigible,
			IFNULL(diasFaltaPago,Entero_Cero),															Cre.montoSeguroVida,				Cre.AporteCliente,														Cre.ClasiDestinCred,	Cre.TipoPrepago,
			Cre.PorcGarLiq,
			FNMONTOGARANLIQU(Par_CreditoID)AS MontoGLAho,
			FNGARANTIAINVERSION(Par_CreditoID,Fecha_Vacia) AS MontoGLInv,
			FUNCIONMONTOGARLIQ(Par_CreditoID) AS MontoGarLiq,
			Cre.GrupoID,																				Cre.FechaInicioAmor,					Cre.ForCobroSegVida,												Cre.ForCobroComAper,	Cre.DiaPagoProd,
			Cre.TipoCredito,																			Cre.CobraSeguroCuota,					Cre.CobraIVASeguroCuota,											Cre.MontoSeguroCuota,	Cre.IVASeguroCuota,
			Cre.TipCobComMorato,																		Cre.TipoConsultaSIC,					Cre.FolioConsultaBC, 												Cre.FolioConsultaCC,	Cre.EsAgropecuario,
			Cre.TipoCancelacion,		Cre.CadenaProductivaID,											Cre.RamaFIRAID,							Cre.SubramaFIRAID,													Cre.ActividadFIRAID,	Cre.TipoGarantiaFIRAID,
			Cre.ProgEspecialFIRAID,		Cre.FechaCobroComision,											Cre.EsAutomatico,						Cre.TipoAutomatico,													Cre.InvCredAut,			Cre.CtaCredAut,
            Cre.Reacreditado,			Cre.CobraAccesorios,											Cre.ReferenciaPago,						Sol.ConvenioNominaID,												IFNULL(Sol.FolioSolici, Cadena_Vacia) AS FolioSolici,
			Sol.QuinquenioID,			Sol.InstitucionNominaID,										Cre.ClabeCtaDomici AS ClabeDomiciliacion,
			Cre.EsConsolidacionAgro,	Sol.FlujoOrigen,
			Cre.ManejaComAdmon,			Cre.ComAdmonLinPrevLiq,	Cre.ForCobComAdmon,			Cre.ForPagComAdmon,		Cre.PorcentajeComAdmon,
			Cre.ManejaComGarantia,		Cre.ComGarLinPrevLiq,	Cre.ForCobComGarantia,		Cre.ForPagComGarantia,	Cre.PorcentajeComGarantia,
			Cre.MontoPagComAdmon,		Cre.MontoCobComAdmon,	Cre.MontoPagComGarantia,	Cre.MontoCobComGarantia,Cre.MontoPagComGarantiaSim,
			RefPayCash
        FROM CREDITOS Cre
			LEFT JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_CreditoID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	Cre.CreditoID,	Cre.LineaCreditoID,		Cre.ClienteID,		Cre.CuentaID,	Cre.MonedaID,
				Cre.Estatus,	Pro.EsGrupal, Cre.EsAgropecuario
		FROM CREDITOS Cre
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			WHERE  CreditoID = Par_CreditoID;
	END IF;

	IF(Par_NumCon = Con_PagareImp) THEN
	  SELECT PagareImpreso
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;
	END IF;

	-- Consulta lo Generales del Credito, Utilizada en las Pantalla de
	-- Pago de Credito, Quitas Condonaciones, Consulta de Informacion del Credito
	-- No.Consulta: 18
	IF(Par_NumCon = Con_Generales) THEN


        -- VALIDAMOS SI EL NUMERO DE CREDITO ES DE AGRO SE BUSCA SU CREDITO EN SAFI
        SET Var_CreditoText := CAST(Par_CreditoID AS CHAR(20));

        SELECT 		CreditoIDSAFI,		CreditoIDCte
			INTO 	Var_CreditoIDSAFI,	Var_CreditoIDCte
		FROM EQU_CREDITOS
        WHERE CreditoIDCte = Var_CreditoText;

        IF(Var_CreditoIDCte = Var_CreditoText)THEN
			IF EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID = Var_CreditoIDSAFI)THEN
				SET Par_CreditoID := Var_CreditoIDSAFI;
            END IF;
        END IF;
        -- FIN VALIDA AGRO

		SELECT MIN(FechaExigible) INTO Var_FechaVencim
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
			  AND FechaExigible <= Var_FecActual
			  AND Estatus       != EstatusPagado;

		 SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		IF(diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT MIN(FechaVencim) INTO Var_FecProxPago
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;
		END IF;
		SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);


		SELECT Estatus INTO Var_EstatusCre FROM CREDITOS WHERE CreditoID = Par_CreditoID;

		IF (Var_EstatusCre = 'C') THEN
			SET diasFaltaPago := Entero_Cero;
			SET Var_FecProxPago := Fecha_Vacia;
		END IF;


		SELECT  Cre.CreditoID,  Cre.ClienteID,  Cre.LineaCreditoID, Cre.ProductoCreditoID,  Cre.CuentaID,
				Cre.MonedaID,   Cre.Estatus,    diasFaltaPago,      Cre.GrupoID,            Cre.SucursalID,
				Cre.FechaInicio,Cre.TasaBase,	Cre.SobreTasa,		Cre.PisoTasa,			Cre.TechoTasa,
				FORMAT(Cre.MontoCredito,2) AS montoCredito,         Cre.CalcInteresID,
				Var_FecProxPago AS FechaProxPago, 	Cre.CicloGrupo, Cre.TasaFija, Cre.TipoPrepago,
				CASE
					WHEN Cre.TipoCredito = Origen_Nuevo		THEN Tipo_NuevoDes
					WHEN (Cre.TipoCredito = OrigenRenovacion AND Cre.Reacreditado = Var_No)	THEN Tipo_RenovadoDes
                    WHEN (Cre.TipoCredito = OrigenRenovacion AND Cre.Reacreditado = Str_SI)	THEN Tipo_ReacreditadoDes
					WHEN Cre.TipoCredito = OrigenReestructura	THEN Tipo_ReestrucDes
				END AS Origen,
				MontoSeguroCuota,IVASeguroCuota, CobraSeguroCuota, CobraIVASeguroCuota, Cre.IdenCreditoCNBV,
                EsAgropecuario
					FROM CREDITOS Cre
					WHERE Cre.CreditoID = Par_CreditoID;

	END IF;

	-- Consulta el Total del Adeudo de un Credito, sin Comision por Prepago o Finiquito
	-- Esta Consulta en utilizada en: * Pago de credito(Prepago), *Consulta de Informacion del Credito, * Condonacion total de credito
	-- No.Consulta: 7
	IF(Par_NumCon = Con_PagoCred) THEN

	   SELECT	FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigent,
				FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasad,
				FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
				FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldCapVenNoExi,
				FORMAT(
					IFNULL(SUM(ROUND(SaldoNotCargoRev, 2)), Entero_Cero) +
					IFNULL(SUM(ROUND(SaldoNotCargoSinIVA, 2)), Entero_Cero) +
					IFNULL(SUM(ROUND(SaldoNotCargoConIVA, 2)), Entero_Cero) +
					IFNULL((IFNULL(SUM(ROUND(SaldoNotCargoConIVA, 2)), Entero_Cero) * Var_ValIVAGen), Entero_Cero)
				, 2) AS SaldoNotasCargo,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInterOrdin,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInterAtras,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInterVenc,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInterProvi,
				FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero),2) AS SaldoIntNoConta,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro * Var_ValIVAIntOr,2)), Entero_Cero),2) AS SaldoIVAIntProv,
				FORMAT(IFNULL(SUM(
							  ROUND(
								ROUND(SaldoInteresOrd * Var_ValIVAIntOr,2) +
								ROUND(SaldoInteresAtr * Var_ValIVAIntOr,2) +
								ROUND(SaldoInteresVen * Var_ValIVAIntOr,2) +
								ROUND(SaldoInteresPro * Var_ValIVAIntOr,2) +
								ROUND(SaldoIntNoConta * Var_ValIVAIntOr,2), 2)), Entero_Cero), 2)AS SaldoIVAInteres,
				FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
				FORMAT(IFNULL(SUM(ROUND(
										ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)), Entero_Cero),2) AS SaldoIVAMorator,

				FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldComFaltPago,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SalIVAComFalPag,
				FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2)  + ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero),2) AS SaldoOtrasComis,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2)) + SUM(ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2)) +  SUM(ROUND(ROUND(SaldoNotCargoConIVA,2)* Var_IVANotaCargo,2)),Entero_Cero),2) AS SaldoIVAComisi,
				FORMAT(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2) AS SaldoSeguroCuota,
				FORMAT(IFNULL(SUM(ROUND(SaldoIVASeguroCuota,2)),Entero_Cero),2) AS SaldoIVASeguroCuota,
				FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2)	+
								  ROUND(SaldoCapAtrasa,2)	+
								  ROUND(SaldoCapVencido,2)	+
								  ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +
											  SaldoInteresAtr +
											  SaldoInteresVen +
											  SaldoInteresPro +
											  SaldoIntNoConta
											  ,2)),Entero_Cero), 2), 2) AS totalInteres,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2) + ROUND(SaldoSeguroCuota,2) + ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2)+ ROUND(SaldoNotCargoConIVA,2)),Entero_Cero),2), 2) AS totalComisi,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2)),Entero_Cero) * Var_ValIVAGen,2) + ROUND(SUM(ROUND(SaldoNotCargoConIVA,2)) * Var_IVANotaCargo,2) + SUM(ROUND(SaldoIVASeguroCuota,2)),2) AS totalIVACom,
				FORMAT(IFNULL(
							SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
								ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +
								  ROUND(SaldoInteresOrd + SaldoInteresAtr +
										SaldoInteresVen + SaldoInteresPro +
										SaldoIntNoConta + SaldoSeguroCuota +
										SaldoComisionAnual,2) +
								  ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
										ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +
								  ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoIntOtrasComis,2) + ROUND(ROUND(SaldoIntOtrasComis,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
								  ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
								  ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2)+
										ROUND(SaldoComisionAnual * Var_ValIVAGen,2), 2) +

								 ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2)
								 ),
							   Entero_Cero), 2) AS adeudoTotal,
					/*COMISION ANUAL*/
					 Decimal_Cero AS SaldoComAnual,
					 Decimal_Cero AS SaldoComAnualIVA
					/*FIN COMISION ANUAL*/
				FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID = Par_CreditoID
				 AND Amo.Estatus <> EstatusPagado;

	END IF;


	IF(Par_NumCon = Con_ProFecPag) THEN
		CALL CREPROXPAGCON(	Par_CreditoID,	Con_ProFecPag,	Var_TotAdeudo,		Var_MontoExigible,	Var_FechaExigible,
							Var_CapVigIns,
							Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);
		SELECT Var_TotAdeudo AS TotalAdeudo,	Var_MontoExigible AS MontoPagar,	Var_FechaExigible AS ProxFecPago;
	END IF;

		-- Consulta del Pago Exigible del Credito, incluyendo la proyeccion de Interes (Si es que aplica Proyeccion)
		-- Utilizado en las Pantallas de: *Pago de Credito, * Condonaciones
		-- PREPAGO
		-- No.Consulta: 8
		IF(Par_NumCon = Con_PagCreExi) THEN
			SET Var_DiasPermPagAnt  := Entero_Cero;
			SET Var_IntAntici       := Entero_Cero;
			SET Var_NumProyInteres  := Entero_Cero;
			SET Var_IntProActual    := Entero_Cero;
			SET Var_CapitaAdela     := Entero_Cero;
			SET Var_TotPagAdela     := Entero_Cero;

			SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
				FROM CREDDIASPAGANT Dpa
					WHERE Dpa.ProducCreditoID = Var_PrductoCreID
					AND Dpa.Frecuencia = Var_Frecuencia;

			SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

			IF(Var_DiasPermPagAnt > Entero_Cero) THEN
				SELECT MIN(FechaExigible), MIN(FechaVencim), MIN(AmortizacionID) INTO
					Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
					FROM AMORTICREDITO
						WHERE CreditoID   = Par_CreditoID
						AND FechaVencim > Var_FecActual
						AND Estatus     != EstatusPagado;

				SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);
				SET Var_FecDiasProPag := IFNULL(Var_FecDiasProPag, Fecha_Vacia);
				SET Var_ProxAmorti  := IFNULL(Var_ProxAmorti, Entero_Cero);

				IF(Var_FecProxPago != Fecha_Vacia) THEN
					SET Var_DiasAntici := DATEDIFF(Var_FecProxPago, Var_FecActual);
				  ELSE
					SET Var_DiasAntici := Entero_Cero;
				END IF;

				SELECT Amo.NumProyInteres, Amo.Interes,
					IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero),
					IFNULL(SaldoCapVigente, Entero_Cero) + IFNULL(SaldoCapAtrasa, Entero_Cero) +
					IFNULL(SaldoCapVencido, Entero_Cero) + IFNULL(SaldoCapVenNExi, Entero_Cero)  INTO
					Var_NumProyInteres, Var_Interes, Var_IntProActual, Var_CapitaAdela
					FROM AMORTICREDITO Amo
						WHERE Amo.CreditoID     = Par_CreditoID
						AND Amo.AmortizacionID = Var_ProxAmorti
						AND Amo.Estatus     != EstatusPagado;

				SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
				SET Var_IntProActual := IFNULL(Var_IntProActual, Entero_Cero);
				SET Var_CapitaAdela := IFNULL(Var_CapitaAdela, Entero_Cero);
				SET Var_Interes	:= IFNULL(Var_Interes, Entero_Cero);


				IF(Var_NumProyInteres = Entero_Cero) THEN

					IF(Var_DiasAntici <= Var_DiasPermPagAnt AND Var_ProyInPagAde = SI_ProyectInt) THEN
						SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);

						IF(Var_IntAntici < Entero_Cero) THEN
							SET Var_IntAntici := Entero_Cero;
						END IF;
					END IF;
				END IF;

				IF(Var_DiasAntici <= Var_DiasPermPagAnt) THEN
					SET Var_TotPagAdela := Var_CapitaAdela + ROUND(Var_IntAntici + Var_IntProActual,2) +
						ROUND(ROUND(Var_IntAntici + Var_IntProActual,2) * Var_ValIVAIntOr, 2);
				END IF;

			END IF;

			IF(Var_EsGrupal = Si_Grupal AND Var_ProrrateoPago = Si_Prorratea) THEN
				SELECT COUNT(CreditoID), MIN(AmortizacionID) INTO
				Var_CuotasAtraso, Var_PrimCuoAtr
				FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID
						AND Estatus != EstatusPagado
						AND FechaExigible < Var_FecActual;

				SET Var_PrimCuoAtr := IFNULL(Var_PrimCuoAtr, Entero_Cero);
				SET Var_CuotasAtraso := IFNULL(Var_CuotasAtraso, Entero_Cero);

				SELECT MAX(AC.AmortizacionID), MAX(DPC.FechaPago) INTO
				Var_UltCuotaPagada, Var_FechaUltCuota
				FROM AMORTICREDITO AC, DETALLEPAGCRE DPC
					WHERE AC.CreditoID = Par_CreditoID AND DPC.CreditoID=Par_CreditoID
					AND AC.Estatus = EstatusPagado
					AND AC.FechaExigible <= Var_FecActual;

				SET Var_TotalPrimerCuota:= (
				SELECT SUM(ROUND(amo.SaldoCapVigente + amo.SaldoCapAtrasa + amo.SaldoCapVencido +
				amo.SaldoCapVenNExi + amo.SaldoInteresPro + amo.SaldoInteresAtr +
				amo.SaldoInteresVen + amo.SaldoIntNoConta +
				(amo.SaldoMoratorios + amo.SaldoMoraVencido + amo.SaldoMoraCarVen) + amo.SaldoComFaltaPa +  amo.SaldoComServGar +
				amo.SaldoOtrasComis +   amo.SaldoSeguroCuota, 2)  +
				ROUND(
				ROUND(amo.SaldoInteresPro * Var_ValIVAIntOr, 2) +
				ROUND(amo.SaldoInteresAtr * Var_ValIVAIntOr, 2) +
				ROUND(amo.SaldoInteresVen * Var_ValIVAIntOr, 2) +
				ROUND(amo.SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +
				ROUND(ROUND(amo.SaldoMoratorios * Var_ValIVAIntMo, 2) +
						ROUND(amo.SaldoMoraVencido * Var_ValIVAIntMo, 2) +
						ROUND(amo.SaldoMoraCarVen * Var_ValIVAIntMo, 2), 2) +
						ROUND(amo.SaldoComFaltaPa * Var_ValIVAGen, 2) +
						ROUND(amo.SaldoComServGar * Var_ValIVAGen, 2) +
						ROUND(amo.SaldoOtrasComis * Var_ValIVAGen, 2) +
						ROUND(amo.SaldoIVASeguroCuota, 2))
				FROM INTEGRAGRUPOSCRE Ing,
				SOLICITUDCREDITO Sol,
				CREDITOS Cre,
				AMORTICREDITO amo
					WHERE Ing.GrupoID = Var_GrupoID
						AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
						AND Sol.CreditoID = Cre.CreditoID
						AND Cre.CreditoID = amo.CreditoID
						AND Ing.Estatus = Esta_Activo
						AND	( Cre.Estatus		= EstatusVigente
						OR  Cre.Estatus		= EstatusVencido)
						AND amo.AmortizacionID = Var_PrimCuoAtr	);
			END IF;

			SET Var_EstatusCredito  := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);
			SET Var_CuotasAtraso 	:= IFNULL(Var_CuotasAtraso,Entero_Cero);
			SET	Var_FechaUltCuota	:= IFNULL(Var_FechaUltCuota,Fecha_Vacia);
			SET	Var_UltCuotaPagada	:= IFNULL(Var_UltCuotaPagada,Entero_Cero);
			SET	Var_totalPrimerCuota:= IFNULL(Var_totalPrimerCuota,Decimal_Cero);
			SET	Var_ProxAmorti		:= IFNULL(Var_ProxAmorti,Entero_Cero);
			SET Var_SaldoIVAInteres := IFNULL(Var_SaldoIVAInteres,Decimal_Cero);

			CALL CALCIVAINTERESPROVCON(
				Par_CreditoID,		Con_PagCreExi2,		Var_SaldoIVAInteres,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(Var_ComAperPagado = Var_MontoComAp) THEN
				SET Var_MontoPendPagCom := Decimal_Cero;
			ELSE
				IF(Var_ForCobComAp <> For_CobProgramado ) THEN
					SET Var_MontoPendPagCom := Decimal_Cero;
				ELSE
					SET Var_MontoPendPagCom := Decimal_Cero;
				END IF;
			END IF;


            -- ========= Inicio Consulta Comisión Anual Linea de Crédito ========
            IF(IFNULL(Var_LineaCreditoID,Entero_Cero)<>0)THEN
				SELECT CobraComAnual,	ComisionCobrada, 	SaldoComAnual
					INTO Var_CobraComAnual,	Var_ComisionCobrada, Var_SaldoComAnual
					FROM LINEASCREDITO
					WHERE LineaCreditoID = Var_LineaCreditoID;

				IF(Var_CobraComAnual='S' AND Var_ComisionCobrada='N')THEN
					SET SaldoComAnualLin := IFNULL(Var_SaldoComAnual,Entero_Cero);

                    IF(Var_CliPagIVA='S')THEN

						SET	Var_IVASucurs	:= IFNULL((SELECT IVA
											FROM SUCURSALES
											 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

						SET SaldoIVAComAnualLin := ROUND( (SaldoComAnualLin*Var_IVASucurs), 2);
                    END IF;

                    SELECT MIN(AmortizacionID)  INTO Var_AmortizacionID
                    FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID
					AND Estatus <>  EstatusPagado
					AND DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;

                    IF(IFNULL(Var_AmortizacionID,Entero_Cero)=Entero_Cero)THEN
						SET SaldoComAnualLin := Entero_Cero;
                        SET SaldoIVAComAnualLin := Entero_Cero;
                    END IF;

                END IF;
            END IF;

            SET SaldoComAnualLin := IFNULL(SaldoComAnualLin,Entero_Cero);
            SET SaldoIVAComAnualLin := IFNULL(SaldoIVAComAnualLin,Entero_Cero);
            -- ========= Fin Consulta Comisión Anual Linea de Crédito ========

			SELECT
				FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
				FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasa,
				FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
				FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVenNExi,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInteresOrd,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInteresAtr,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresVen,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro +
					CASE WHEN AmortizacionID = Var_ProxAmorti THEN
					CASE WHEN Var_EstatusCredito = EstatusVigente THEN
						Var_IntAntici
						ELSE Entero_Cero END
						ELSE Entero_Cero END,2)),Entero_Cero),2) AS SaldoInteresPro,
				FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta +
					CASE WHEN AmortizacionID = Var_ProxAmorti THEN
					CASE WHEN Var_EstatusCredito = EstatusVencido THEN
					Var_IntAntici
					ELSE Entero_Cero END
					ELSE Entero_Cero END,2)),Entero_Cero),2) AS SaldoIntNoConta,
				ROUND(Var_SaldoIVAInteres,2) AS SaldoIVAInteres,
				FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
				FORMAT(IFNULL(SUM(
									ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2)+
									ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
									ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2)),Entero_Cero),2) AS SaldoIVAMorato,
				FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,

				FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2)  + ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero) + ROUND(Var_MontoPendPagCom,2),2) AS SaldoOtrasComis,

                FORMAT(IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero) +
					   IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2),Entero_Cero) +
					   IFNULL(SUM(IFNULL(ROUND(ROUND(SaldoNotCargoConIVA,2)* Var_IVANotaCargo,2),Entero_Cero)),Entero_Cero) +
					   IFNULL(SUM(ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComisi,

				FORMAT(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2) AS SaldoSeguroCuota,
				FORMAT(IFNULL(SUM(SaldoIVASeguroCuota),Entero_Cero),2) AS SaldoIVASeguroCuota,
				FORMAT(IFNULL(SUM(SaldoComisionAnual),Entero_Cero)+SaldoComAnualLin,2) AS SaldoComAnual,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2)),Entero_Cero)+SaldoIVAComAnualLin,2) AS SaldoComAnualIVA,
				FORMAT(IFNULL(SUM(	ROUND(SaldoCapVigente,2)	+	ROUND(SaldoCapAtrasa,2)	+
									ROUND(SaldoCapVencido,2)	+	ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,
				FORMAT(ROUND(IFNULL(SUM(ROUND(
												SaldoInteresOrd + SaldoInteresAtr +
												SaldoInteresVen + SaldoInteresPro +
												SaldoIntNoConta +
																	CASE WHEN AmortizacionID = Var_ProxAmorti THEN
																		Var_IntAntici
																		ELSE Entero_Cero END
																		,2)),Entero_Cero), 2), 2) AS totalInteres,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +
				                        ROUND(SaldoComServGar,2) +
										ROUND(SaldoOtrasComis,2) +
										ROUND(SaldoComisionAnual,2) + /*COMISION ANUAL*/
										ROUND(SaldoSeguroCuota,2) +
										ROUND(SaldoNotCargoRev,2) +
										ROUND(SaldoNotCargoSinIVA,2) +
										ROUND(SaldoNotCargoConIVA,2) ),Entero_Cero) +
										ROUND(Var_MontoPendPagCom,2) +
										SaldoComAnualLin,2), 2) AS totalComisi,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +
										ROUND(SaldoComServGar,2) +
										ROUND(SaldoComisionAnual,2)/*COMISION ANUAL*/
										),Entero_Cero) * Var_ValIVAGen,2) +
										ROUND(IFNULL(SUM(ROUND(SaldoNotCargoConIVA,2)),Entero_Cero) * Var_IVANotaCargo,2)+
										IFNULL(SUM(ROUND(SaldoIVASeguroCuota,2)),Entero_Cero)
                                        +
                                        IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero)
										+ IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2) + SaldoIVAComAnualLin,Entero_Cero),2)

										AS totalIVACom,
				FORMAT(IFNULL(SUM(	ROUND(SaldoCapVigente,2) +
									ROUND(SaldoCapAtrasa,2) +
									ROUND(SaldoCapVencido,2) +
									ROUND(SaldoCapVenNExi,2) +
									ROUND(SaldoInteresOrd +
							SaldoInteresAtr +
							SaldoInteresVen +
							SaldoInteresPro +
							SaldoIntNoConta  +
							CASE WHEN AmortizacionID = Var_ProxAmorti THEN Var_IntAntici ELSE Entero_Cero END, 2) +
							ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
							ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
							ROUND(SaldoOtrasComis,2) +
							ROUND(SaldoIntOtrasComis, 2) +
							ROUND(SaldoNotCargoRev,2) +
							ROUND(SaldoNotCargoSinIVA,2) +
							ROUND(SaldoNotCargoConIVA,2) +
							ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2) +
							ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +/*SEGURO CUOTA*/
							ROUND(SaldoComisionAnual,2) + ROUND(SaldoComisionAnual * Var_ValIVAGen,2) +/*COMISION ANUAL*/
							ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
							(ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2)  +
							ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
							ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2))),Entero_Cero)+
					(ROUND(Var_SaldoIVAInteres,2))
                    +
                    IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero)
					+ IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2),Entero_Cero) + ROUND(Var_MontoPendPagCom,2) + (SaldoComAnualLin + SaldoIVAComAnualLin) +
					IFNULL(SUM(ROUND(FNEXIGIBLEIVAINTERESACCESORIOS(Par_CreditoID, AmortizacionID, Var_ValIVAGen, Var_CliPagIVA), 2)), Entero_Cero), 2)  AS adeudoTotal,
				FORMAT(Var_TotPagAdela, 2) AS TotalAdelanto,
				Var_CuotasAtraso AS CuotasAtraso,
				Var_UltCuotaPagada AS UltCuotaPagada,
				Var_FechaUltCuota AS FechaUltCuota,
				Var_totalPrimerCuota AS totalPrimerCuota,
				FORMAT(	ROUND(IFNULL(SUM(ROUND(SaldoSeguroCuota,2) +
						ROUND(SaldoIVASeguroCuota,2)),Entero_Cero),2),2) AS TotalSeguroCuota
			FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
					AND Estatus <> EstatusPagado
					AND DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;
		END IF;

		-- Consulta del Pago Exigible del Credito, Sin incluir la proyeccion de Interes
		-- Utilizado en las Pantallas de: *Condonaciones
		-- No.Consulta: 5
		IF(Par_NumCon = Con_ExgibleSinProy) THEN
			SELECT FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
				FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasa,
				FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
				FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVenNExi,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInteresOrd,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInteresAtr,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresVen,
				FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
				FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero),2) AS SaldoIntNoConta,
				FORMAT(IFNULL(SUM(ROUND(
										 ROUND(IFNULL(SaldoInteresOrd,Entero_Cero) * Var_ValIVAIntOr, 2) +
										 ROUND(IFNULL(SaldoInteresAtr,Entero_Cero) * Var_ValIVAIntOr, 2) +
										 ROUND(IFNULL(SaldoInteresVen,Entero_Cero) * Var_ValIVAIntOr, 2) +
										 ROUND(IFNULL(SaldoInteresPro,Entero_Cero) * Var_ValIVAIntOr, 2) +
										 ROUND(IFNULL(SaldoIntNoConta, Entero_Cero) * Var_ValIVAIntOr, 2)
										 ,2)), Entero_Cero), 2) AS SaldoIVAInteres,
				FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)),Entero_Cero),2) AS SaldoIVAMorato,
				FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,
				FORMAT(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2) +  FORMAT(IFNULL(SUM(SaldoComServGar),Entero_Cero),2) AS SaldoOtrasComis,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2)),Entero_Cero),2) + FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2)),Entero_Cero),2)  AS SaldoIVAComisi,
				FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2)	+
								  ROUND(SaldoCapAtrasa,2)	+
								  ROUND(SaldoCapVencido,2)	+
								  ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +
										  SaldoInteresAtr +
										  SaldoInteresVen +
										  SaldoInteresPro +
										  SaldoIntNoConta
										,2)),Entero_Cero), 2), 2) AS totalInteres,
				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2)	+ ROUND(SaldoOtrasComis,2) +
										ROUND(SaldoSeguroCuota,2)	+ ROUND(SaldoComisionAnual,2)/*COMISION ANUAL*/ ),Entero_Cero),2), 2) AS totalComisi,
				FORMAT(ROUND(IFNULL(
								SUM(ROUND(SaldoComFaltaPa,2)	+
								        ROUND(SaldoComServGar,2) +
										ROUND(SaldoOtrasComis,2) +
										ROUND(SaldoComisionAnual,2)/*COMISION ANUAL*/
										),Entero_Cero) * Var_ValIVAGen,2)+
									IFNULL(SUM(ROUND(IVASeguroCuota,2)),Entero_Cero)
								,2) AS totalIVACom,
					FORMAT(IFNULL(SUM(
									ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
									ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +
									ROUND(	SaldoInteresOrd + SaldoInteresAtr +
											SaldoInteresVen + SaldoInteresPro +
											SaldoIntNoConta, 2) + ROUND(
																	ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
																	ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
																	ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
																	ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
																	ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +
																ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
																ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
																ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
																ROUND(SaldoComisionAnual,2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2) +/*COMISION ANUAL*/
																ROUND(SaldoSeguroCuota,2)+ROUND(IVASeguroCuota,2)+
																ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
						ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2), 2)),Entero_Cero), 2) AS adeudoTotal,
				FORMAT(ROUND(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2),2) AS SaldoSeguroCuota,/*SEGURO CUOTA*/
				FORMAT(ROUND(IFNULL(SUM(IVASeguroCuota),Entero_Cero),2),2) AS SaldoIVASeguroCuota,/*SEGURO CUOTA*/
				FORMAT(ROUND(IFNULL(SUM(SaldoComisionAnual),Entero_Cero),2),2) AS SaldoComAnual,/*COMISION ANUAL*/
				FORMAT(ROUND(ROUND(IFNULL(SUM(SaldoComisionAnual), Entero_Cero),2) * Var_ValIVAGen,2),2) AS SaldoComAnualIVA/*COMISION ANUAL*/
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
				AND Estatus <> EstatusPagado
				AND FechaExigible <= Var_FecActual;

		END IF;



	-- Consulta del Pago Exigible del Credito, Sin incluir la proyeccion de Interes
	-- Utilizado en las Pantallas de: *Condonaciones
	-- No.Consulta: 25
	IF(Par_NumCon = Con_QuitasCond) THEN

			SELECT FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
				 FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasa,
				 FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
				 FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVenNExi,
				 FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInteresOrd,
				 FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInteresAtr,
				 FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresVen,
				 FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
				 FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero),2) AS SaldoIntNoConta,


				 FORMAT(SUM(ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
								 ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
								 ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
								 ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
								 ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2) ,2)), 2) AS SaldoIVAInteres,

				FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,

				 FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)),Entero_Cero),2) AS SaldoIVAMorato,

				FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
				FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,

				FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero),2) AS SaldoOtrasComis,

				FORMAT(IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero)
					+ IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2),Entero_Cero) +
					SUM(IFNULL(ROUND(ROUND(SaldoNotCargoConIVA,2)* Var_IVANotaCargo,2),Entero_Cero))+
					SUM(IFNULL(ROUND(ROUND(SaldoComServGar,2)* Var_ValIVAGen,2),Entero_Cero))
					 ,2)  AS SaldoIVAComisi,

				FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2)	+
								  ROUND(SaldoCapAtrasa,2)	+
								  ROUND(SaldoCapVencido,2)	+
								  ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,

					FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +
											  SaldoInteresAtr +
											  SaldoInteresVen +
											  SaldoInteresPro +
											  SaldoIntNoConta
											,2)),Entero_Cero), 2), 2) AS totalInteres,

					FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2)  +  ROUND(SaldoOtrasComis,2) + ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2) ),
								   Entero_Cero),2), 2) AS totalComisi,

				FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +
				                    ROUND(SaldoComServGar,2) +
									ROUND(SaldoOtrasComis,2)),
									Entero_Cero) * Var_ValIVAGen,2) +
									ROUND(IFNULL(SUM(ROUND(SaldoNotCargoConIVA,2)),Entero_Cero) * Var_IVANotaCargo,2),2) AS totalIVACom,

					FORMAT(IFNULL(
							SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
								ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

								  ROUND(SaldoInteresOrd + SaldoInteresAtr +
										SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +

								  ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
										ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +

								  ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
								  ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +

								  ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2), 2) +

								ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2)

								 ),
							   Entero_Cero), 2) AS adeudoTotal,
							   FORMAT(IFNULL(SUM(ROUND(SaldoSeguroCuota,2)),Entero_Cero),2) AS SaldoSeguroCuota,
							   FORMAT(IFNULL(SUM(ROUND(SaldoIVASeguroCuota,2)),Entero_Cero),2) AS SaldoIVASeguroCuota,
							   /*COMISION ANUAL*/
								FORMAT(IFNULL(SUM(SaldoComisionAnual),Entero_Cero),2) AS SaldoComAnual,
								FORMAT(IFNULL(SUM(ROUND(SaldoComisionAnual* Var_ValIVAGen)),2),2) AS SaldoComAnualIVA,
								/*FIN COMISION ANUAL*/
								/* NOTAS CARGOS */
								FORMAT(IFNULL(SUM(ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero),2) AS SaldoNotasCargos
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
		   AND Estatus <> EstatusPagado;

	END IF;

		-- Consulta Para Finiquito del Credito, incluyendo la posible Comision por Pago Anticipado
		-- Tambien llamada Comision por Admon, Utilizada en las Pantallas de Pago de Credito
		-- No.Consulta: 17
		IF(Par_NumCon = Con_Finiquito) THEN
			/* *************** IMPORTATNTE ************************
			 * SI SE MODIFICA ESTA CONSULTA, TAMBIEN MODIFICAR LA FUNCION FUNCIONCONFINIQCRE QUE SE USA EN OTROS SPS
			**/
			SET Var_ComAntici		:= Entero_Cero;
			SET Var_DiasAntici		:= Entero_Cero;
			SET Var_FecVenCred		:= IFNULL(Var_FecVenCred, Fecha_Vacia);
			SET Var_SaldoIVAInteres	:= IFNULL(Var_SaldoIVAInteres,Decimal_Cero);
			IF Var_CliPagIVA = 'S' THEN -- se agrego la validacion del cliente paga iva Aeuan T_11173
				CALL CALCIVAINTERESPROVCON(
					Par_CreditoID,		Con_Finiquito2,		Var_SaldoIVAInteres,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);
			ELSE
				SET Var_SaldoIVAInteres = 0;
			END IF; -- fin de la validacion
			SELECT
			PermiteLiqAntici,		CobraComLiqAntici,		TipComLiqAntici,	ComisionLiqAntici,		DiasGraciaLiqAntici
			INTO
			Var_PermiteLiqAnt,		Var_CobraComLiqAnt,		Var_TipComLiqAnt,	Var_ComLiqAnt,			Var_DiasGraciaLiq
			FROM ESQUEMACOMPRECRE
				WHERE ProductoCreditoID = Var_PrductoCreID;

			SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
			SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
			SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
			SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
			SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);
			SET Var_SaldoIVAInteres	:= IFNULL(Var_SaldoIVAInteres, Entero_Cero);

			IF(Var_FecVenCred != Fecha_Vacia AND Var_FecVenCred >= Var_FecActual) THEN
				SET Var_DiasAntici := DATEDIFF(Var_FecVenCred, Var_FecActual);
			ELSE
				SET Var_DiasAntici := Entero_Cero;
			END IF;

			IF(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN
				IF(Var_TipComLiqAnt = Proyeccion_Int) THEN
					SELECT SUM(Interes) INTO Var_ComAntici
					FROM AMORTICREDITO
					WHERE CreditoID   = Par_CreditoID
					AND FechaVencim > Var_FecActual
					AND Estatus     != EstatusPagado;

					SET Var_FecProxPago		:= IFNULL(Var_FecProxPago, Fecha_Vacia);
					SET Var_ComAntici		:= IFNULL(Var_ComAntici, Entero_Cero);

					SELECT (Amo.SaldoInteresPro + Amo.SaldoIntNoConta) INTO Var_IntActual
						FROM AMORTICREDITO Amo
						WHERE Amo.CreditoID   = Par_CreditoID
							AND Amo.FechaVencim > Var_FecActual
							AND Amo.FechaInicio <= Var_FecActual
							AND Amo.Estatus     != EstatusPagado;
					SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
					SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

				  ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN
					SET Var_ComAntici   := ROUND(Var_SaldoInsoluto * Var_ComLiqAnt / Decimal_Cien,2);
				  ELSE
					SET Var_ComAntici   := Var_ComLiqAnt;
				END IF;
			  ELSE
				SET Var_ComAntici   := Entero_Cero;
			END IF;

			IF(Var_ComAntici < Entero_Cero) THEN
				SET Var_ComAntici   := Entero_Cero;
			END IF;

			SELECT
			FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
			FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasa,
			FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
			FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVenNExi,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInteresOrd,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInteresAtr,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresVen,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
			FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero),2) AS SaldoIntNoConta,
			FORMAT(Var_SaldoIVAInteres ,2) AS SaldoIVAInteres,
            FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
            ROUND(SUM(((SaldoMoratorios) +
                  (SaldoMoraVencido) +
                  (SaldoMoraCarVen)))* Var_ValIVAIntMo ,2)AS SaldoIVAMorato,
            FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
            FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,
			FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2)  + ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero),2) AS SaldoOtrasComis,
			FORMAT(IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero) +
						 SUM(IFNULL(ROUND(ROUND(SaldoNotCargoConIVA,2)* Var_IVANotaCargo,2),Entero_Cero)) +
						 SUM(IFNULL(ROUND(SaldoComServGar * Var_ValIVAGen, 2), Entero_Cero))
						 	,2) AS SaldoIVAComisi,
			FORMAT(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2) AS SaldoSeguroCuota,
			FORMAT(IFNULL(SUM(SaldoIVASeguroCuota),Entero_Cero),2) AS SaldoIVASeguroCuota,
			FORMAT(IFNULL(SUM(SaldoCapVigente	+ SaldoCapAtrasa + SaldoCapVencido	+ SaldoCapVenNExi),Entero_Cero),2) AS totalCapital,
			FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +SaldoInteresAtr +SaldoInteresVen +SaldoInteresPro +SaldoIntNoConta,2)),Entero_Cero), 2), 2) AS totalInteres,
			FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +  ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2) + ROUND(SaldoComisionAnual,2)/*COMISION ANUAL*/ + ROUND(SaldoSeguroCuota,2) +  ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2))+ ROUND(Var_ComAntici,2),Entero_Cero),2), 2) AS totalComisi,
      		FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa * Var_ValIVAGen, 2) +ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA) * Var_ValIVAGen, 2) +ROUND(SaldoComisionAnual * Var_ValIVAGen, 2)
      			+ROUND(SaldoComServGar * Var_ValIVAGen, 2)  +ROUND(SaldoIVASeguroCuota,2) + ROUND(SaldoNotCargoConIVA * Var_ValIVAGen, 2)) +ROUND(Var_ComAntici * Var_ValIVAGen, 2),Entero_Cero),
      		2) AS totalIVACom,

			FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +
			      ROUND(SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2) + ROUND(SaldoComFaltaPa,2) +
			      ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) + ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) + ROUND(SaldoOtrasComis,2) +

					CASE WHEN Var_CliEsp =Var_CliSFG THEN
					  IFNULL(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2),Entero_Cero)
					ELSE
					  ROUND(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2) * Var_ValIVAGen,2)
					END

			      + ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
			      ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2), 2) +
			      ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +ROUND(SaldoComisionAnual,2) +
			      ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2) +  ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) +ROUND(SaldoNotCargoConIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2)) + ROUND(Var_ComAntici,2) + ROUND(ROUND(Var_ComAntici,2) * Var_ValIVAIntOr,2) +
			      (ROUND(Var_SaldoIVAInteres ,2)), Entero_Cero) +
			      SUM(ROUND(SaldoIntOtrasComis, 2)) + IFNULL(SUM(ROUND(FNEXIGIBLEIVAINTERESACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA), 2)), Entero_Cero), 2) AS adeudoTotal,

			FORMAT(ROUND(Var_ComAntici, 2), 2) AS ComLiqAntici, FORMAT(ROUND(ROUND(Var_ComAntici,2) * Var_ValIVAIntOr,2), 2) AS IVAComLiqAntici,
			Var_PermiteLiqAnt AS PermiteLiqAnt,
			FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoCapVigente + SaldoCapAtrasa  +SaldoCapVencido + SaldoCapVenNExi +SaldoInteresOrd + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro + SaldoComFaltaPa + SaldoIntNoConta + SaldoSeguroCuota + SaldoComisionAnual + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA + SaldoIntOtrasComis,2)),Entero_Cero) , 2),2) AS adeudoTotalSinIVA,
			/*COMISION ANUAL*/
			FORMAT(IFNULL(SUM(SaldoComisionAnual),Entero_Cero),2) AS SaldoComAnual,
			FORMAT(IFNULL(SUM(ROUND(SaldoComisionAnual* Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoComAnualIVA,
			/*FIN COMISION ANUAL*/
             FORMAT(IFNULL(SUM(SaldoNotCargoSinIVA  +  SaldoNotCargoConIVA + SaldoNotCargoRev),Entero_Cero),2) AS SaldoNotasCargo
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			AND Estatus <> EstatusPagado;
		END IF; -- EndIf Consulta del Finiquito del Credito

	IF(Par_NumCon = Con_AvaCredito) THEN
			SELECT (CASE
						WHEN Avs.ClienteID != Entero_Cero THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID= Avs.ClienteID)
						WHEN Avs.ProspectoID != Entero_Cero THEN (SELECT NombreCompleto FROM PROSPECTOS WHERE ProspectoID = Avs.ProspectoID)
						WHEN Avs.AvalID != Entero_Cero THEN (SELECT NombreCompleto FROM AVALES WHERE AvalID= Avs.AvalID)
					END) AS aval,
					(CASE
						WHEN Avs.ClienteID != Entero_Cero THEN (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID=Avs.ClienteID  AND Oficial= EsOficial)
						WHEN Avs.ProspectoID != Entero_Cero  THEN ( SELECT CONCAT(Pro.Calle,', NO. ',Pro.NumExterior,', INTERIOR ',Pro.NumInterior,', COL. ',
																		Pro.Colonia,' C.P. ',Pro.CP,', ',Est.Nombre, ', ', Mun.Nombre)
																	FROM PROSPECTOS Pro,
																		ESTADOSREPUB 		Est,
																		MUNICIPIOSREPUB 	Mun
																		WHERE Pro.ProspectoID	= Avs.ProspectoID
																		AND Pro.EstadoID		= Est.EstadoID
																		AND Est.EstadoID		= Mun.EstadoID
																		AND Mun.MunicipioID		= Pro.MunicipioID )
						WHEN Avs.AvalID != Entero_Cero THEN (SELECT	CONCAT(Ava.Calle, ' ', Ava.NumExterior, ', COL. ', Ava.Colonia, ' CP. ', Ava.CP,
																		' , ', Est.Nombre, ', ', Mun.Nombre) FROM AVALES Ava,
																		ESTADOSREPUB 		Est,
																		MUNICIPIOSREPUB 	Mun
																		WHERE  Ava.AvalID = Avs.AvalID
																		AND Ava.EstadoID		= Est.EstadoID
																		AND Est.EstadoID		= Mun.EstadoID
																		AND Mun.MunicipioID		= Ava.MunicipioID )
					END)AS direcAval
			FROM	AVALESPORSOLICI Avs,
					SOLICITUDCREDITO 	Sol
			WHERE  Sol.CreditoID = Par_CreditoID
			AND Avs.SolicitudCreditoID = Sol.SolicitudCreditoID;


	END IF;



	-- consulta para la comsion por apertura y desembolso de credito
	-- en ventanilla
	IF(Par_NumCon = Con_ComDesVent) THEN

		SELECT 	Cre.CreditoID,			Cre.ClienteID,		Cre.ProductoCreditoID,	Cre.CuentaID,	  		Cre.MontoCredito AS MontoCredito,
				Cre.MonedaID,			Cre.MontoComApert,	Cre.IVAComApertura,		Cre.ForCobroComAper,	Cre.MontoComApert+Cre.IVAComApertura AS TotalComision,
				Cre.MontoPorDesemb,		MontoDesemb,		Cre.GrupoID,			Cre.SucursalID,			Cre.SolicitudCreditoID,
				Cre.Estatus, 			Cre.TipoDispersion,	Cre.MontoSeguroVida, 	Cre.SeguroVidaPagado, 	Cre.ComAperPagado,
				Cre.CicloGrupo,  Cre.AporteCliente AS AporteCliente, (Cre.MontoSeguroVida -  Cre.SeguroVidaPagado) AS MontoPendiente
		FROM CREDITOS Cre,
			 PRODUCTOSCREDITO Pro
		WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
		AND Cre.CreditoID = Par_CreditoID;
	END IF;


	-- consulta para obtener grupos y monto sugerido por gl
	-- en ventanilla
	IF(Par_NumCon = Con_GL) THEN
		-- consulta lo que el cliente ya habia depositado
		CALL CREGARLIQCON(
			Par_CreditoID,  Salida_NO,		Var_MontoGarLiq, 	Par_NumErr, 		Par_ErrMen,
			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion);

		SET Var_MontoGarLiq:= IFNULL(Var_MontoGarLiq,Entero_Cero);
		SELECT 	Cre.CreditoID,								Cre.ClienteID,	Cre.ProductoCreditoID,	Cre.MontoCredito, Var_MontoGarLiq AS montoGLDep,
				ROUND(Cre.AporteCliente,2) AS MontoPorcGL, 	CASE WHEN ((Cre.AporteCliente - Var_MontoGarLiq) >0) THEN
																ROUND(Cre.AporteCliente - Var_MontoGarLiq,2)
																ELSE ROUND(Decimal_Cero,2) END AS GLSugerido,
				Cre.GrupoID, Cre.CicloGrupo
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro
			WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
			AND Cre.CreditoID = Par_CreditoID;
	END IF;

	-- consulta de resumen informacion de credito del cliente, con saldo de adeudo total
	IF(Par_NumCon = Con_ResCliente) THEN

		 SELECT 	CreditoID,	ClienteID,			ProductoCreditoID,	MontoCredito,	MonedaID,
					Estatus,	FechaMinistrado,	FUNCIONTOTDEUDACRE(Par_CreditoID) AS TotalAdeudo
			FROM	CREDITOS
			WHERE  CreditoID = Par_CreditoID;
	END IF;

	--  consulta para obtener los garantes del credito
	 IF(Par_NumCon = Con_GarCredito) THEN
			DROP TABLE IF EXISTS TEMP_GARANTES;
			CREATE TEMPORARY TABLE TEMP_GARANTES(
				Garante  		VARCHAR(300),
				DirecGarante 	VARCHAR(300));

			INSERT INTO TEMP_GARANTES(
			SELECT Cli.NombreCompleto,Dir.DireccionCompleta
			FROM ASIGNAGARANTIAS Asi
			INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
			INNER JOIN CLIENTES Cli ON Cli.ClienteID = Gar.ClienteID
			INNER JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID
				AND Dir.Oficial = EsOficial
			WHERE Sol.CreditoID = Par_CreditoID);

			INSERT INTO TEMP_GARANTES(
			SELECT Ava.NombreCompleto,CONCAT(
										IFNULL(Ava.Calle,''), ' ',
										IFNULL(Ava.NumExterior,''), ', COL. ',
										IFNULL(Ava.Colonia,''), ' CP. ',
										IFNULL(Ava.CP,''),' ,',
										IFNULL(Mun.Nombre,''), ' ,',
										IFNULL(Edo.Nombre,''))
			FROM ASIGNAGARANTIAS Asi
			INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
			INNER JOIN AVALES Ava ON Ava.AvalID = Gar.AvalID
			INNER JOIN ESTADOSREPUB Edo ON Ava.EstadoID = Edo.EstadoID
			INNER JOIN MUNICIPIOSREPUB Mun ON Ava.EstadoID = Mun.EstadoID
				AND Ava.MunicipioID = Mun.MunicipioID
			WHERE Sol.CreditoID = Par_CreditoID);


			INSERT INTO TEMP_GARANTES(
			SELECT Pro.NombreCompleto,CONCAT(
										IFNULL(Pro.Calle,''),', NO. ',
										IFNULL(Pro.NumExterior,''),', INTERIOR ',
										IFNULL(Pro.NumInterior,''),', COL. ',
										IFNULL(Pro.Colonia,''),' C.P. ',
										IFNULL(Pro.CP,''),', ',
										IFNULL(Mun.Nombre,''), ', ',
										IFNULL(Edo.Nombre,''))
			FROM ASIGNAGARANTIAS Asi
			INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
			INNER JOIN PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID AND Gar.ClienteID = Entero_Cero
			INNER JOIN ESTADOSREPUB Edo ON Pro.EstadoID = Edo.EstadoID
			INNER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID
				AND Pro.MunicipioID = Mun.MunicipioID
			WHERE Sol.CreditoID = Par_CreditoID);


			INSERT INTO TEMP_GARANTES(
			SELECT Gar.GaranteNombre,CONCAT(
										IFNULL(Gar.CalleGarante,''),', NO. ',
										IFNULL(Gar.NumExtGarante,''),', INTERIOR ',
										IFNULL(Gar.NumIntGarante,''),', COL. ',
										IFNULL(Gar.ColoniaGarante,''),' C.P. ',
										IFNULL(Gar.CodPostalGarante,''),', ',
										IFNULL(Mun.Nombre,''), ', ',
										IFNULL(Edo.Nombre,''))
			FROM ASIGNAGARANTIAS Asi
			INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID
			INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
			AND Gar.ClienteID = Entero_Cero AND Gar.AvalID = Entero_Cero
				AND Gar.ProspectoID = Entero_Cero
			INNER JOIN ESTADOSREPUB Edo ON Gar.EstadoIDGarante = Edo.EstadoID
			INNER JOIN MUNICIPIOSREPUB Mun ON Gar.EstadoIDGarante = Mun.EstadoID
				AND Gar.MunicipioGarante = Mun.MunicipioID
			WHERE Sol.CreditoID = Par_CreditoID);

		SELECT Garante AS garante,DirecGarante AS direcGarante FROM TEMP_GARANTES;

	END IF;
	-- 15 consulta Informacion General del credito y Dias de Atraso
	IF(Par_NumCon = Con_CreDiasAtraso) THEN

		SET diasFaltaPago := (DATEDIFF( Var_FecActual,(SELECT IFNULL(MIN(FechaExigible),Var_FecActual)
				FROM AMORTICREDITO
				WHERE CreditoID     = Par_CreditoID
					AND FechaExigible <= Var_FecActual
					AND Estatus       != EstatusPagado)));
		SET diasFaltaPago	:=IFNULL(diasFaltaPago,Entero_Cero );

		SELECT 	Cre.CreditoID,			Cre.ClienteID,		Cre.ProductoCreditoID,			Cre.CuentaID,	  		Cre.MontoCredito AS MontoCredito,
				Cre.MonedaID,			Cre.MontoComApert,	Cre.IVAComApertura, 			Pro.ForCobroComAper,	Cre.MontoComApert+Cre.IVAComApertura AS TotalComision,
				Cre.MontoPorDesemb,		MontoDesemb,		Cre.GrupoID,					Cre.SucursalID,			Cre.SolicitudCreditoID,
				Cre.Estatus, 			Cre.TipoDispersion,	diasFaltaPago AS diasAtraso,	Cre.CicloGrupo
		FROM CREDITOS Cre,
			 PRODUCTOSCREDITO Pro
		WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
		AND Cre.CreditoID = Par_CreditoID;





	END IF;

	-- Consulta de creditosWS par carga de archivo de pagos
	IF(Par_NumCon = Con_CreditosWS) THEN
	SELECT Cre.CreditoID,Cli.ClienteID, Cli.NombreCompleto
			FROM CLIENTES Cli
		INNER JOIN CREDITOS Cre ON(Cli.ClienteID=Cre.ClienteID)
		WHERE Cre.CreditoID = Par_CreditoID;
	END IF;


	-- consulta creditos para banca en linea
	IF(Par_NumCon = Con_CreditosBEWS) THEN

		SET Var_FecActual := NOW();

		CALL CREPROXPAGCON(
			Par_CreditoID,	Con_ProFecPag,	Var_TotAdeudo,		Var_MontoExigible,	Var_FechaExigible,
			Var_CapVigIns,
			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion	);

		SET diasFaltaPago := (DATEDIFF( Var_FecActual,(SELECT MIN(Var_FechaExigible)
				FROM AMORTICREDITO
				WHERE CreditoID     = Par_CreditoID
					AND FechaExigible <= Var_FecActual
					AND Estatus       != EstatusPagado)));


		SET Var_DiasPermPagAnt  := Entero_Cero;
		SET Var_IntAntici       := Entero_Cero;
		SET Var_NumProyInteres  := Entero_Cero;
		SET Var_IntProActual    := Entero_Cero;
		SET Var_CapitaAdela     := Entero_Cero;
		SET diasFaltaPago		:= IFNULL(diasFaltaPago, Entero_Cero);


		SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
			FROM CREDDIASPAGANT Dpa
			WHERE Dpa.ProducCreditoID = Var_PrductoCreID
			  AND Dpa.Frecuencia = Var_Frecuencia;

		SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

		IF(Var_DiasPermPagAnt > Entero_Cero) THEN


			SELECT MIN(FechaExigible), MIN(FechaVencim), MIN(AmortizacionID) INTO
				   Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;

			SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);
			SET Var_FecDiasProPag := IFNULL(Var_FecDiasProPag, Fecha_Vacia);
			SET Var_ProxAmorti  := IFNULL(Var_ProxAmorti, Entero_Cero);

			IF(Var_FecProxPago != Fecha_Vacia) THEN
				SET Var_DiasAntici := DATEDIFF(Var_FecProxPago, Var_FecActual);
			ELSE
				SET Var_DiasAntici := Entero_Cero;
			END IF;


			SELECT Amo.NumProyInteres, Amo.Interes,

				   IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero),

				   IFNULL(SaldoCapVigente, Entero_Cero) + IFNULL(SaldoCapAtrasa, Entero_Cero) +
				   IFNULL(SaldoCapVencido, Entero_Cero) + IFNULL(SaldoCapVenNExi, Entero_Cero) INTO

				 Var_NumProyInteres, Var_Interes, Var_IntProActual, Var_CapitaAdela
				FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID     = Par_CreditoID
				  AND Amo.AmortizacionID = Var_ProxAmorti
				  AND Amo.Estatus     != EstatusPagado;

			SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
			SET Var_IntProActual := IFNULL(Var_IntProActual, Entero_Cero);
			SET Var_CapitaAdela := IFNULL(Var_CapitaAdela, Entero_Cero);
			SET	Var_Interes	:= IFNULL(Var_Interes, Entero_Cero);


			IF(Var_NumProyInteres = Entero_Cero) THEN


				IF(Var_DiasAntici <= Var_DiasPermPagAnt AND Var_ProyInPagAde = SI_ProyectInt) THEN

					SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);

					IF(Var_IntAntici < Entero_Cero) THEN
						SET Var_IntAntici := Entero_Cero;
					END IF;
				END IF;

			END IF;


		END IF;




			SELECT
				 IFNULL(Cre.CreditoID,Cadena_Vacia) AS CreditoID,
				IFNULL(Cre.CuentaID,Cadena_Vacia) AS CuentaID,
				IFNULL(Cre.Estatus, Cadena_Vacia) AS Estatus,
				IFNULL(Cre.ProductoCreditoID, Cadena_Vacia) AS ProductoCreditoID,
					 Pro.Descripcion AS DescripcionCredito,
					 Mon.Descripcion AS TipoMoneda,
				IFNULL(Cre.ValorCat, Cadena_Vacia) AS ValorCat,
				IFNULL(Cre.TasaFija,Cadena_Vacia) AS TasaFija,
				IFNULL(diasFaltaPago,Cadena_Vacia) AS DiasFaltaPago,
				IFNULL(Var_TotAdeudo,Entero_Cero) AS TotalDeuda,
				IFNULL(Var_MontoExigible,Entero_Cero) AS MontoExigible,
				IFNULL(Var_FechaExigible,Fecha_Vacia) AS ProxFechaPag,
				 FORMAT(IFNULL(SUM(Amo.SaldoCapVigente + Amo.SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVigente,
				 FORMAT(IFNULL(SUM(Amo.SaldoCapAtrasa + Amo.SaldoCapVencido),Entero_Cero),2) AS SaldoCapAtrasa,
				FORMAT(IFNULL(SUM(ROUND(Amo.SaldoInteresAtr,2) + ROUND(Amo.SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresAtr,
				FORMAT(IFNULL(SUM(ROUND(Amo.SaldoIntNoConta,2) + ROUND(Amo.SaldoInteresPro +
											  CASE WHEN AmortizacionID = Var_ProxAmorti THEN
														Var_IntAntici
											  ELSE Entero_Cero END,2)),
								Entero_Cero),2) AS SaldoInteresVig,


				FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoInteresPro + Amo. SaldoIntNoConta +
										CASE WHEN AmortizacionID = Var_ProxAmorti THEN
											Var_IntAntici
										ELSE Entero_Cero END,2) * Var_ValIVAIntOr,2)),0), 2) AS SaldoIVAIntVig,


				FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoInteresAtr * Var_ValIVAIntOr,2) +
										ROUND(Amo.SaldoInteresVen * Var_ValIVAIntOr,2),
										2)),0), 2) AS SaldoIVAAtrasa,

				FORMAT(IFNULL(SUM(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,

				FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(Amo.SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(Amo.SaldoMoraCarVen * Var_ValIVAIntMo,2), 2)), Entero_Cero),2) AS SaldoIVAMorato,

				FORMAT(IFNULL(SUM(Amo.SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
				FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,
				FORMAT(IFNULL(SUM(Amo.SaldoOtrasComis),Entero_Cero),2) + FORMAT(IFNULL(SUM(Amo.SaldoComServGar),Entero_Cero),2) AS SaldoOtrasComis,
				FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoOtrasComis,2) * Var_ValIVAGen,2)),Entero_Cero),2) + FORMAT(IFNULL(SUM(ROUND(ROUND(Amo.SaldoComServGar,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComisi

			FROM AMORTICREDITO Amo,
				CREDITOS Cre,
				PRODUCTOSCREDITO Pro,
				MONEDAS Mon
			WHERE Amo.CreditoID = Par_CreditoID
			AND Cre.CreditoID = Par_CreditoID
		   AND Amo.Estatus <> EstatusPagado
		   AND Cre.ProductoCreditoID=Pro.ProducCreditoID
		   AND Cre.MonedaID=Mon.Monedaid;

	END IF;

	IF Par_NumCon=Con_ReferenciasBanc THEN #Se utiliza para consultar las referencias bancarias
		SELECT Cli.NombreCompleto,Suc.NombreSucurs
				INTO Var_NombreCompleto,Var_Sucursal
			FROM CLIENTES Cli
				INNER JOIN CREDITOS Cre ON Cre.ClienteID=Cli.ClienteID
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID=Cli.SucursalOrigen
				WHERE Cre.CreditoID=Par_CreditoID;

		SELECT FUNCIONREFERENCIASBANC (Par_CreditoID,CtaBanamex,SucBanamex,2) INTO Var_RefBanamex;
		SELECT FUNCIONREFERENCIASBANC (Par_CreditoID,Entero_Cero,Entero_Cero,3) INTO Var_RefScotiabanck;

		SELECT Var_NombreCompleto,Var_Sucursal,Var_RefBanamex,Var_RefScotiabanck,CtaBanamex,SucBanamex,CtaInverlat;
	END IF;


	IF(Par_NumCon = Con_CreditoRenovar) THEN
		SET Var_Relacionado		 := IFNULL((SELECT Relacionado FROM CREDITOS WHERE CreditoID = Par_CreditoID), Entero_Cero);
		SET Var_NumRenovacion 	 := Entero_Cero;
		SET Var_CreditoOrigenID  := Entero_Cero;
		SET Var_CreditoDestinoID := Entero_Cero;
		SET @bandera := TRUE;

		IF(Var_Relacionado > Entero_Cero) THEN
			SET Var_NumRenovacion := 1;
		ELSE
			SET Var_NumRenovacion := 0;
		END IF;

		WHILE @bandera DO
			SET Var_CreditoDestinoID := IFNULL((SELECT CreditoDestinoID
												FROM REESTRUCCREDITO
												WHERE CreditoDestinoID = Var_Relacionado AND Origen = OrigenRenovacion AND EstatusReest = Esta_Desembolso
											   LIMIT 1), Entero_Cero);

			IF(Var_CreditoDestinoID > Entero_Cero) THEN
				SET Var_NumRenovacion := Var_NumRenovacion + 1;
				SET Var_CreditoOrigenID := IFNULL((SELECT CreditoOrigenID
													  FROM REESTRUCCREDITO
													  WHERE CreditoDestinoID = Var_CreditoDestinoID AND Origen = OrigenRenovacion AND EstatusReest = Esta_Desembolso
													LIMIT 1), Entero_Cero);
				SET Var_Relacionado	:= Var_CreditoOrigenID;

			ELSE
				SET @bandera := FALSE;
			END IF;

		END WHILE;

		SET Var_MontoComision :=(SELECT FUNCIONCONCOMFALPAGCRE(Par_CreditoID));
		SET Var_MontoInteres  :=(SELECT FNTOTALINTERESCREDITO(Par_CreditoID));

		SELECT SolicitudCreditoID,		Estatus
		INTO   Var_SolicitudCreditoID,	Var_Estatus
		FROM SOLICITUDCREDITO
		WHERE Relacionado = Par_CreditoID AND TipoCredito = OrigenRenovacion
			AND Estatus IN (Estatus_Inactivo, Estatus_Liberado, Estatus_Autorizado);
		SET Var_SolicitudCreditoID	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
		SET Var_Estatus	:= IFNULL(Var_Estatus, Cadena_Vacia);

		SELECT  Cre.CreditoID,			Cre.ClienteID,			Cre.ProductoCreditoID, 			Cre.Relacionado,		Cre.MontoCredito,
				Cre.MonedaID,	 		Cre.Estatus,			Cre.DestinoCreID,				Cre.ClasiDestinCred,    Cre.GrupoID,
				Cre.TipoCredito,
				Var_NumRenovacion AS NumRenovaciones,
				Var_SolicitudCreditoID AS SolicitudCreditoID,
				Var_Estatus AS EstatusSolici,
				Var_MontoComision AS MontoComision,
				Var_MontoInteres AS MontoInteres,
				CASE
					WHEN IFNULL(Sol.Proyecto, Cadena_Vacia) = Cadena_Vacia
						THEN Cadena_Vacia
						ELSE Sol.Proyecto
				END AS Proyecto,
				Cre.TipoConsultaSIC,	Cre.FolioConsultaBC, 	Cre.FolioConsultaCC
		FROM CREDITOS Cre
			LEFT JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_CreditoID
        AND Cre.EsAgropecuario = Var_No;

	END IF;


	IF(Par_NumCon = Con_CreditoReest) THEN
		SET Var_MontoComision :=(SELECT FUNCIONCONCOMFALPAGCRE(Par_CreditoID));
		SET Var_MontoInteres  :=(SELECT FNTOTALINTERESCREDITO(Par_CreditoID));

		SELECT SolicitudCreditoID,		Estatus
		INTO   Var_SolicitudCreditoID,	Var_Estatus
		FROM SOLICITUDCREDITO
		WHERE Relacionado = Par_CreditoID AND TipoCredito = OrigenReestructura
			AND Estatus IN (Estatus_Inactivo, Estatus_Liberado, Estatus_Autorizado);
		SET Var_SolicitudCreditoID	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
		SET Var_Estatus	:= IFNULL(Var_Estatus, Cadena_Vacia);

		SET Var_NumReestructura :=  IFNULL((SELECT NumeroReest
										  FROM REESTRUCCREDITO
										  WHERE CreditoDestinoID = Par_CreditoID AND Origen = OrigenReestructura AND EstatusReest = Esta_Desembolso
										LIMIT 1), Entero_Cero);


		SET Var_NumDiasAtraOri	:=	(SELECT  DATEDIFF(Var_FecActual, IFNULL(MIN(FechaExigible), Var_FecActual))
											FROM AMORTICREDITO Amo
											WHERE Amo.CreditoID = Par_CreditoID
											  AND Amo.Estatus != EstatusPagado
											  AND Amo.FechaExigible <= Var_FecActual);

		SELECT  Cre.CreditoID,			Cre.ClienteID,			Cre.ProductoCreditoID, 			Cre.Relacionado,			Cre.FechaInhabil,
				Cre.MonedaID,	 		Cre.Estatus,			Cre.DestinoCreID,				Cre.ClasiDestinCred,    	Cre.GrupoID,
				Cre.TipoCredito,		Cre.MontoCredito,		Sol.HorarioVeri,				Sol.InstitucionNominaID,	Cre.FechaInicio,
				Cre.FechaInicioAmor,	Cre.FechaVencimien,		Cre.PlazoID,					Cre.AporteCliente,			Cre.PorcGarLiq,
				Cre.TipoCalInteres,		Cre.CalcInteresID,		Cre.TasaBase,					Sol.FolioCtrl,
				ROUND(Cre.SobreTasa,2) AS	SobreTasa,
				Cre.TasaFija 		AS 		TasaFija,
				ROUND(Cre.PisoTasa,2) AS	PisoTasa,
				ROUND(Cre.TechoTasa,2) AS	TechoTasa,
				ROUND(Cre.FactorMora,2) AS	FactorMora,
				Var_SolicitudCreditoID AS SolicitudCreditoID,
				Var_Estatus AS EstatusSolici,
				Var_NumReestructura AS NumReestructuras,
				Var_NumDiasAtraOri	AS DiasAtraso,
				Var_MontoComision AS MontoComision,
				Var_MontoInteres AS MontoInteres,
				CASE
					WHEN IFNULL(Sol.Proyecto, Cadena_Vacia) = Cadena_Vacia
						THEN Cadena_Vacia
						ELSE Sol.Proyecto
				END AS Proyecto,
				Cre.TipoConsultaSIC,	Cre.FolioConsultaBC, 	Cre.FolioConsultaCC,
                Sol.ConvenioNominaID,	Cre.EsAgropecuario,
				IFNULL(Cre.TipoGarantiaFIRAID, Entero_Cero) TipoGarantiaFIRAID,
				IFNULL(Cre.AcreditadoIDFIRA, Entero_Cero) AcreditadoIDFIRA,
				IFNULL(Cre.CreditoIDFIRA, Entero_Cero) CreditoIDFIRA,	Cre.LineaCreditoID,
				Cre.ManejaComAdmon,			Cre.ComAdmonLinPrevLiq,		Cre.ForCobComAdmon,			Cre.ForPagComAdmon,		Cre.PorcentajeComAdmon,
				Cre.ManejaComGarantia,		Cre.ComGarLinPrevLiq,		Cre.ForCobComGarantia,		Cre.ForPagComGarantia,	Cre.PorcentajeComGarantia,
				Cre.MontoPagComAdmon,		Cre.MontoCobComAdmon,		Cre.MontoPagComGarantia,	Cre.MontoCobComGarantia,Cre.MontoPagComGarantiaSim
		FROM CREDITOS Cre
			LEFT JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_CreditoID;

	END IF;





	IF(Par_NumCon = Con_PagVertical) THEN
		SELECT MIN(FechaExigible) INTO Var_FechaVencim
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
			  AND FechaExigible <= Var_FecActual
			  AND Estatus       != EstatusPagado;

		SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		IF(diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT MIN(FechaVencim) INTO Var_FecProxPago
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;
		END IF;
		SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

		SELECT  Cre.CreditoID,  Cre.ClienteID,  Cre.LineaCreditoID, Cre.ProductoCreditoID,  Ca.CuentaAhoID AS CuentaID,
				Cre.MonedaID,   Cre.Estatus,    diasFaltaPago,      Cre.GrupoID,            Cre.SucursalID,
				Cre.FechaInicio,
				FORMAT(Cre.MontoCredito,2) AS montoCredito,
				Var_FecProxPago AS FechaProxPago, 	Cre.CicloGrupo, Cre.TasaFija, Cre.TipoPrepago,
				CASE Cre.TipoCredito
						WHEN Origen_Nuevo		THEN Tipo_NuevoDes
						WHEN OrigenRenovacion	THEN Tipo_RenovadoDes
						WHEN OrigenReestructura	THEN Tipo_ReestrucDes
						END AS Origen,
			  CobraSeguroCuota,
			  CobraIVASeguroCuota,
			  MontoSeguroCuota,
			  IVASeguroCuota
					FROM CREDITOS Cre INNER JOIN CLIENTES Cli
					ON (Cre.ClienteID = Cli.ClienteID)
					INNER JOIN CUENTASAHO Ca
					ON (Cli.ClienteID = Ca.ClienteID
						AND Ca.EsPrincipal = Str_SI)
					WHERE Cre.CreditoID = Par_CreditoID;

	END IF;

	IF(Par_NumCon=Con_CredSegCuota)THEN
		SELECT COUNT(CreditoID) AS TotalCreditos
			FROM CREDITOS
				WHERE CobraSeguroCuota = Str_SI
					AND Estatus IN (EstatusVigente,EstatusVencido);
	END IF;

	IF(Par_NumCon = Con_CredCond) THEN
		SET diasFaltaPago := (DATEDIFF( Var_FecActual,(SELECT MIN(FechaExigible)
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
				AND FechaExigible <= Var_FecActual
				AND Estatus       != EstatusPagado)));

		SELECT
			Cre.CreditoID,			Cre.ClienteID,			Cre.LineaCreditoID,							Cre.ProductoCreditoID,	Cre.CuentaID,
			Cre.Relacionado,		Cre.SolicitudCreditoID,	FORMAT(Cre.MontoCredito,2)AS MontoCredito,	Cre.MonedaID,			Cre.FechaInicio,
			Cre.FechaVencimien,		Cre.FactorMora,			Cre.CalcInteresID,							Cre.TasaBase,			Cre.TasaFija,
			Cre.SobreTasa,			Cre.PisoTasa,			Cre.TechoTasa,								Cre.FechaInhabil,		Cre.AjusFecExiVen,
			Cre.CalendIrregular,	Cre.AjusFecUlVenAmo,	Cre.TipoPagoCapital,						Cre.FrecuenciaInt,		Cre.FrecuenciaCap,
			Cre.PeriodicidadInt,	Cre.PeriodicidadCap,	Cre.DiaPagoInteres,							Cre.DiaPagoCapital,		Cre.DiaMesInteres,
			Cre.DiaMesCapital,		Cre.InstitFondeoID,		Cre.LineaFondeo,							Cre.Estatus,			Cre.FechTraspasVenc,
			Cre.FechTerminacion,	Cre.NumAmortizacion,	Cre.NumTransacSim,							Cre.FactorMora,			Cre.FechaMinistrado,
			Cre.TipoFondeo,			CASE WHEN Cre.FechaAutoriza=Fecha_Null THEN Fecha_Vacia	ELSE Cre.FechaAutoriza	END AS FechaAutoriza,
			Cre.UsuarioAutoriza,	Cre.MontoComApert,		Cre.IVAComApertura,							Cre.ValorCAT,			Cre.PlazoID,
			Cre.TipoDispersion,		Cre.CuentaCLABE,		Cre.TipoCalInteres,							Cre.DestinoCreID,		Cre.NumAmortInteres,
			Cre.MontoCuota,			Sol.ComentarioMesaControl,
			FUNCIONTOTDEUDACRE(Par_CreditoID) AS TotalAdeudo,FUNCIONEXIGIBLE(Par_CreditoID)	AS TotalExigible,
			IFNULL(diasFaltaPago,Entero_Cero), Cre.montoSeguroVida, Cre.AporteCliente,
			Cre.ClasiDestinCred, Cre.TipoPrepago,			Cre.PorcGarLiq,		FNMONTOGARANLIQU(Par_CreditoID)AS MontoGLAho,	FNGARANTIAINVERSION(Par_CreditoID,Fecha_Vacia) AS MontoGLInv,
			FUNCIONMONTOGARLIQ(Par_CreditoID) AS MontoGarLiq,
			Cre.GrupoID,			Cre.FechaInicioAmor,	Cre.ForCobroSegVida,						Cre.ForCobroComAper,	Cre.DiaPagoProd,
			Cre.TipoCredito,        Cre.CobraSeguroCuota,   Cre.CobraIVASeguroCuota,                    Cre.MontoSeguroCuota,   Cre.IVASeguroCuota,
			Cre.TipCobComMorato,	Sol.Condicionada,		Sol.ConvenioNominaID,						IFNULL(Sol.FolioSolici, Cadena_Vacia) AS FolioSolici,
			Sol.QuinquenioID,		Sol.InstitucionNominaID
		FROM CREDITOS Cre
			LEFT JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_CreditoID;
	END IF;


	IF(Par_NumCon = Con_CredComCargCta) THEN

			SELECT MIN(FechaExigible) INTO Var_FechaVencim
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
			  AND FechaExigible <= Var_FecActual
			  AND Estatus       != EstatusPagado;

		 SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);
		 SET Var_OtrasComAntic := Decimal_Cero;
		 SET Var_IVAOtrasComAnt := Decimal_Cero;

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		IF(diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT MIN(FechaVencim) INTO Var_FecProxPago
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;
		END IF;
		SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

        SELECT SUM(MontoCuota), SUM(MontoIVACuota) INTO Var_OtrasComAntic, Var_IVAOtrasComAnt
				FROM DETALLEACCESORIOS
                WHERE TipoFormaCobro = For_CobAnticipado
                AND FechaLiquida = Fecha_Null
                AND CreditoID = Par_CreditoID;

		SELECT  Cre.CreditoID,  Cre.ClienteID,  Cre.LineaCreditoID, Cre.ProductoCreditoID,  Cre.CuentaID,
				Cre.MonedaID,   Cre.Estatus,    diasFaltaPago,      Cre.GrupoID,            Cre.SucursalID,
				Cre.FechaInicio,Cre.TasaBase,	Cre.SobreTasa,		Cre.PisoTasa,			Cre.TechoTasa,
				FORMAT(Cre.MontoCredito,2) AS montoCredito,         Cre.CalcInteresID,
				Var_FecProxPago AS FechaProxPago, 	Cre.CicloGrupo, Cre.TasaFija, Cre.TipoPrepago,
				 CASE Cre.TipoCredito
						WHEN Origen_Nuevo		THEN Tipo_NuevoDes
						WHEN OrigenRenovacion	THEN Tipo_RenovadoDes
						WHEN OrigenReestructura	THEN Tipo_ReestrucDes
						END AS Origen,
				MontoSeguroCuota,	IVASeguroCuota,	CobraSeguroCuota, CobraIVASeguroCuota,
				CASE Cre.ForCobroComAper
					WHEN 'A' THEN FORMAT((Cre.MontoComApert-Cre.ComAperPagado),2)
					ELSE Decimal_Cero
				END AS MontoComApertura,
				CASE Cre.ForCobroComAper
					WHEN 'A' THEN ROUND((Cre.MontoComApert-Cre.ComAperPagado)*Var_ValIVAGen,2)
					ELSE Decimal_Cero
				END AS MontoIVAComApertura, Var_OtrasComAntic AS OtrasComAntic , Var_IVAOtrasComAnt AS IVAOtrasComAnt
					FROM CREDITOS Cre
					WHERE Cre.CreditoID = Par_CreditoID;

	END IF;

	IF(Par_NumCon = Con_Agropecuario) THEN
		SET diasFaltaPago := (DATEDIFF( Var_FecActual,(SELECT MIN(FechaExigible)
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
				AND FechaExigible <= Var_FecActual
				AND Estatus       != EstatusPagado)));

		SELECT
			Cre.CreditoID,																					Cre.ClienteID,							Cre.LineaCreditoID,													Cre.ProductoCreditoID,				Cre.CuentaID,
			Cre.Relacionado,																				Cre.SolicitudCreditoID,					FORMAT(Cre.MontoCredito,2)AS MontoCredito,							Cre.MonedaID,						Cre.FechaInicio,
			Cre.FechaVencimien,																				Cre.FactorMora,							Cre.CalcInteresID,													Cre.TasaBase,						Cre.TasaFija,
			Cre.SobreTasa,																					Cre.PisoTasa,							Cre.TechoTasa,														Cre.FechaInhabil,					Cre.AjusFecExiVen,
			Cre.CalendIrregular,																			Cre.AjusFecUlVenAmo,					Cre.TipoPagoCapital,												Cre.FrecuenciaInt,					Cre.FrecuenciaCap,
			Cre.PeriodicidadInt,																			Cre.PeriodicidadCap,					Cre.DiaPagoInteres,													Cre.DiaPagoCapital,					Cre.DiaMesInteres,
			Cre.DiaMesCapital,																				Cre.InstitFondeoID,						Cre.LineaFondeo,													Cre.Estatus,						Cre.FechTraspasVenc,
			Cre.FechTerminacion,																			Cre.NumAmortizacion,					Cre.NumTransacSim,													Cre.FactorMora,						Cre.FechaMinistrado,
			Cre.TipoFondeo,
			CASE WHEN Cre.FechaAutoriza=Fecha_Null THEN Fecha_Vacia
			ELSE Cre.FechaAutoriza	END AS FechaAutoriza,
			Cre.UsuarioAutoriza,																			Cre.MontoComApert,					Cre.IVAComApertura,														Cre.ValorCAT,					Cre.PlazoID,
			Cre.TipoDispersion,																				Cre.CuentaCLABE,					Cre.TipoCalInteres,														Cre.DestinoCreID,				Cre.NumAmortInteres,
			Cre.MontoCuota,																					Sol.ComentarioMesaControl,			FUNCIONTOTDEUDACRE(Par_CreditoID) AS TotalAdeudo,
			FUNCIONEXIGIBLE(Par_CreditoID)	AS TotalExigible,
			IFNULL(diasFaltaPago,Entero_Cero),																Cre.montoSeguroVida,				Cre.AporteCliente,														Cre.ClasiDestinCred,	Cre.TipoPrepago,
			Cre.PorcGarLiq,
			FNMONTOGARANLIQU(Par_CreditoID)AS MontoGLAho,
			FNGARANTIAINVERSION(Par_CreditoID,Fecha_Vacia) AS MontoGLInv,
			FUNCIONMONTOGARLIQ(Par_CreditoID) AS MontoGarLiq,
			Cre.GrupoID,																			Cre.FechaInicioAmor,					Cre.ForCobroSegVida,													Cre.ForCobroComAper,	Cre.DiaPagoProd,
			Cre.TipoCredito,																		Cre.CobraSeguroCuota,					Cre.CobraIVASeguroCuota,												Cre.MontoSeguroCuota,	Cre.IVASeguroCuota,
			Cre.TipCobComMorato,																	Cre.TipoConsultaSIC,					Cre.FolioConsultaBC, 													Cre.FolioConsultaCC,	Cre.EsAgropecuario,
			Cre.TipoCancelacion,																	Cre.CadenaProductivaID,					Cre.RamaFIRAID,															Cre.SubramaFIRAID,		Cre.ActividadFIRAID,
			Cre.TipoGarantiaFIRAID,																	Cre.ProgEspecialFIRAID,					Cre.FechaCobroComision,													Cre.Reacreditado,		Cre.EsConsolidacionAgro,
			Cre.ManejaComAdmon,			Cre.ComAdmonLinPrevLiq,	Cre.ForCobComAdmon,		Cre.ForPagComAdmon,		Cre.PorcentajeComAdmon,
			Cre.ManejaComGarantia,		Cre.ComGarLinPrevLiq,	Cre.ForCobComGarantia,	Cre.ForPagComGarantia,	Cre.PorcentajeComGarantia
		FROM CREDITOS Cre
			INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		WHERE Cre.CreditoID = Par_CreditoID
		AND Cre.EsAgropecuario = 'S';
	END IF;


	-- consulta para pantalla de cambio fuente de fondeo
	IF(Par_NumCon = Con_CambioFondeo) THEN
		SELECT MIN(FechaExigible) INTO Var_FechaVencim
			FROM AMORTICREDITO
			WHERE CreditoID     = Par_CreditoID
			  AND FechaExigible <= Var_FecActual
			  AND Estatus       != EstatusPagado;

		 SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		IF(diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT MIN(FechaVencim) INTO Var_FecProxPago
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;
		END IF;
		SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

		SELECT  Cre.CreditoID,  		Cre.ClienteID,  	Cre.LineaCreditoID, 	Cre.ProductoCreditoID,  	Cre.CuentaID,
				Cre.MonedaID,   		Cre.Estatus,    	diasFaltaPago,     		Cre.GrupoID,           	 	Cre.SucursalID,
				Cre.FechaInicio,		Cre.TasaBase,		Cre.SobreTasa,			Cre.PisoTasa,				Cre.TechoTasa,
				FORMAT(Cre.MontoCredito,2) AS MontoCredito,         				Cre.CalcInteresID,			Var_FecProxPago AS FechaProxPago,
                Cre.TasaFija, 			Cre.TipoPrepago,
				 CASE Cre.TipoCredito
						WHEN Origen_Nuevo		THEN Tipo_NuevoDes
						WHEN OrigenRenovacion	THEN Tipo_RenovadoDes
						WHEN OrigenReestructura	THEN Tipo_ReestrucDes
						END AS Origen,
				Cre.InstitFondeoID,		Cre.LineaFondeo, 	DATE_ADD(IFNULL(Cre.FechaMinistrado,Fecha_Vacia), INTERVAL IFNULL(30, Entero_Cero) DAY) AS FechaMinistrado,
                Cre.TipoGarantiaFIRAID
					FROM CREDITOS Cre
					WHERE Cre.CreditoID = Par_CreditoID
						AND Cre.EsAgropecuario = 'S'
							AND Cre.Estatus = EstatusVigente
								AND Cre.GrupoID <= Entero_Cero;
	END IF;

	-- consulta para pantalla de aplicacion de garantias AGRO
	IF(Par_NumCon = Con_AplicaGarAgro) THEN

		SELECT 		MIN(FechaExigible)  INTO Var_FechaVencim
			FROM 	AMORTICREDITO
			WHERE 	CreditoID     = Par_CreditoID
			AND 	FechaExigible <= Var_FecActual
			AND 	Estatus       != EstatusPagado;

		SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		IF(diasFaltaPago >Entero_Cero ) THEN
			SET Var_FecProxPago := Var_FecActual;
		ELSE
			SELECT 		MIN(FechaVencim) INTO Var_FecProxPago
				FROM 	AMORTICREDITO
				WHERE 	CreditoID   = Par_CreditoID
				AND 	FechaVencim > Var_FecActual
				AND 	Estatus     != EstatusPagado;
		END IF;
        SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);


        SELECT 		SUM(MontoBloq) INTO Var_MontoBloq
			FROM 	BLOQUEOS
			WHERE	TiposBloqID 	= Blo_DepGarLiq
			AND		NatMovimiento 	= Tipo_Bloqueo
			AND 	Referencia 		= Par_CreditoID
            AND		IFNULL(FolioBloq, Entero_Cero) = Entero_Cero;

		SET Var_MontoBloq := IFNULL(Var_MontoBloq, Decimal_Cero);

		SELECT 		SUM(Capital) INTO Var_MontoMinisPen
			FROM 	MINISTRACREDAGRO
			WHERE	CreditoID	= Par_CreditoID
            AND		Estatus 	= Estatus_Pendiente;

		SET Var_MontoMinisPen := IFNULL(Var_MontoMinisPen, Decimal_Cero);

		SELECT 		Porcentaje INTO Var_PorcenGarLiq
			FROM 	ESQUEMAGARANTIALIQ Q
					LEFT JOIN CREDITOS C ON Q.ProducCreditoID = C.ProductoCreditoID
                    INNER JOIN CLIENTES CL ON C.ClienteID = CL.ClienteID
			WHERE	C.CreditoID	= Par_CreditoID
            AND		(C.MontoCredito >= Q.LimiteInferior AND C.MontoCredito <= Q.LimiteSuperior)
            AND 	CL.CalificaCredito = Q.Clasificacion;


            SET Var_PorcenGarLiq := IFNULL(Var_PorcenGarLiq, Decimal_Cero);


		SELECT  	Cre.CreditoID,  Cre.ClienteID,  Cre.LineaCreditoID, Cre.ProductoCreditoID,  Cre.CuentaID,
					Cre.MonedaID,   Cre.Estatus,    diasFaltaPago,      Cre.GrupoID,            Cre.SucursalID,
					Cre.FechaInicio,Cre.TasaBase,	Cre.SobreTasa,		Cre.PisoTasa,			Cre.TechoTasa,
					FORMAT(Cre.MontoCredito,2) AS montoCredito,         Cre.CalcInteresID,
					Var_FecProxPago AS FechaProxPago,Cre.CicloGrupo, 	Cre.TasaFija, 			Cre.TipoPrepago,
					CASE Cre.TipoCredito
						WHEN Origen_Nuevo		THEN Tipo_NuevoDes
						WHEN OrigenRenovacion	THEN Tipo_RenovadoDes
						WHEN OrigenReestructura	THEN Tipo_ReestrucDes
						END AS Origen,
					Cre.TipoGarantiaFIRAID,		Cre.EstatusGarantiaFIRA,Cre.ProgEspecialFIRAID,Var_MontoBloq AS  MontoGarLiq,
                    Cre.EsAgropecuario,				Var_MontoMinisPen AS MontoMinisPen,
                    Var_PorcenGarLiq AS PorcGarLiq,
				IFNULL(Cre.AcreditadoIDFIRA, Entero_Cero) AS AcreditadoIDFIRA,
				IFNULL(Cre.CreditoIDFIRA, Entero_Cero) AS CreditoIDFIRA
			FROM 	CREDITOS Cre
			WHERE 	Cre.CreditoID = Par_CreditoID;
	END IF;
    IF(Par_NumCon = Con_Riesgos) THEN

		DROP TABLE IF EXISTS TEMCREDITOSRIES;
		CREATE TEMPORARY TABLE TEMCREDITOSRIES(
			CreditoID  		BIGINT(12),
			SaldoInsoluto 	DECIMAL(14,2));

		INSERT INTO TEMCREDITOSRIES(
		 SELECT MAX(CreditoID), SUM(SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi) AS Sumatoria
		FROM CREDITOS Cre
		WHERE Cre.Estatus IN( EstatusVigente, EstatusVencido)
		GROUP BY Cre.CreditoID ORDER BY Sumatoria DESC LIMIT 20);



		SET Var_SaldoInsolCar := (SELECT SUM(SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi) FROM CREDITOS Cre);

        SET Var_SumatoriaCred	:= (SELECT  SUM(SaldoInsoluto) FROM TEMCREDITOSRIES Cre ORDER BY SaldoInsoluto DESC	LIMIT 0,20);
		 SELECT  Var_SaldoInsolCar, Var_SumatoriaCred;

	END IF;
	IF(Par_NumCon = Con_AvaCreditoConsol) THEN
		DROP TABLE IF EXISTS AVALESCONSOL;
		CREATE TABLE AVALESCONSOL(
			Numero INT auto_increment,
			aval	VARCHAR(300),
			direcAval VARCHAR (500),
	        aval_2	VARCHAR(300),
			direcAval_2 VARCHAR (500),
			PRIMARY KEY (Numero)
		);
		INSERT INTO AVALESCONSOL
		SELECT Entero_Cero, (CASE
					WHEN Avs.ClienteID != Entero_Cero THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID= Avs.ClienteID)
					WHEN Avs.ProspectoID != Entero_Cero THEN (SELECT NombreCompleto FROM PROSPECTOS WHERE ProspectoID = Avs.ProspectoID)
					WHEN Avs.AvalID != Entero_Cero THEN (SELECT NombreCompleto FROM AVALES WHERE AvalID= Avs.AvalID)
				END) AS aval,
				(CASE
					WHEN Avs.ClienteID != Entero_Cero THEN (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID=Avs.ClienteID  AND Oficial= EsOficial)
					WHEN Avs.ProspectoID != Entero_Cero  THEN ( SELECT CONCAT(Pro.Calle,', NO. ',Pro.NumExterior,', INTERIOR ',Pro.NumInterior,', COL. ',
																	Pro.Colonia,' C.P. ',Pro.CP,', ',Est.Nombre, ', ', Mun.Nombre)
																FROM PROSPECTOS Pro,
																	ESTADOSREPUB 		Est,
																	MUNICIPIOSREPUB 	Mun
																	WHERE Pro.ProspectoID	= Avs.ProspectoID
																	AND Pro.EstadoID		= Est.EstadoID
																	AND Est.EstadoID		= Mun.EstadoID
																	AND Mun.MunicipioID		= Pro.MunicipioID )
					WHEN Avs.AvalID != Entero_Cero THEN (SELECT	CONCAT(Ava.Calle, ' ', Ava.NumExterior, ', COL. ', Ava.Colonia, ' CP. ', Ava.CP,
																	' , ', Est.Nombre, ', ', Mun.Nombre) FROM AVALES Ava,
																	ESTADOSREPUB 		Est,
																	MUNICIPIOSREPUB 	Mun
																	WHERE  Ava.AvalID = Avs.AvalID
																	AND Ava.EstadoID		= Est.EstadoID
																	AND Est.EstadoID		= Mun.EstadoID
																	AND Mun.MunicipioID		= Ava.MunicipioID )
				END)AS direcAval,Cadena_Vacia, Cadena_Vacia
		FROM	AVALESPORSOLICI Avs,
				SOLICITUDCREDITO 	Sol
		WHERE  Sol.CreditoID = Par_CreditoID
		AND Avs.SolicitudCreditoID = Sol.SolicitudCreditoID;
		SET  var_NumIntegrante	:= (SELECT MAX(Numero) FROM AVALESCONSOL);
		SET  Contador 			:= ROUND(var_NumIntegrante/2);
		SET  ContaIntegra			:= 1;

		WHILE (Contador <= var_NumIntegrante)
			do
				SET Contador := Contador+1;
					SELECT aval , direcAval INTO
							Var_aval_2 , Var_direcAval_2
					FROM AVALESCONSOL WHERE Numero=Contador;

				UPDATE AVALESCONSOL
				SET aval_2= Var_aval_2, direcAval_2=Var_direcAval_2
				WHERE Numero =ContaIntegra;
				SET ContaIntegra 	:= ContaIntegra +1;
				SET Var_aval_2		:='';
				SET Var_direcAval_2	:='';
      END WHILE;
      SELECT aval , direcAval, aval_2 ,direcAval_2 FROM AVALESCONSOL WHERE Numero <= ROUND(var_NumIntegrante/2);
	END IF;

    -- Consulta Credito para Cobro de Accesorios
	IF(Par_NumCon = Con_CobroAccesorios) THEN

		SELECT 	Cre.CreditoID,			Cre.ClienteID,					Cre.ProductoCreditoID,				Cre.CuentaID,	  					Cre.MontoCredito,
				Cre.MonedaID,			Cadena_Vacia AS MontoComApert,	Cadena_Vacia AS IVAComApertura,		Cadena_Vacia AS ForCobroComAper,	Decimal_Cero AS TotalComision,
				Cre.MontoPorDesemb,		MontoDesemb,					Cre.GrupoID,						Cre.SucursalID,						Cre.SolicitudCreditoID,
				Cre.Estatus, 			Cre.TipoDispersion,				Cre.MontoSeguroVida, 				Cre.SeguroVidaPagado, 				Cre.ComAperPagado,
				Cre.CicloGrupo,  		Cre.AporteCliente, 				Decimal_Cero AS MontoPendiente
		FROM CREDITOS Cre,
			 PRODUCTOSCREDITO Pro
		WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
		AND Cre.CreditoID = Par_CreditoID;
	END IF;

	IF(Par_NumCon = Con_CobroGarFOGAFI) THEN
		SELECT 	Cre.CreditoID,		Cre.ClienteID,		Cre.ProductoCreditoID,	Cre.MontoCredito,	Det.MontoBloqueadoFOGAFI,
				Det.MontoGarFOGAFI,	(Det.MontoGarFOGAFI - Det.MontoBloqueadoFOGAFI) AS SaldoFOGAFI,	Cre.GrupoID,			Cre.CicloGrupo,		Det.ModalidadFOGAFI,
                Det.PorcGarFOGAFI
			FROM CREDITOS Cre
            INNER JOIN DETALLEGARLIQUIDA Det
			WHERE Cre.CreditoID = Det.CreditoID
            AND Cre.CreditoID = Par_CreditoID;
	END IF;

    IF(Par_NumCon = Con_MontoFOGAFI)THEN
		SET Var_FecActual := (SELECT FechaSistema FROM PARAMETROSSIS);

        SELECT GrupoID, CicloGrupo, ClienteID
			INTO Var_GrupoID, Var_CicloGrupo, Var_ClienteID
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

        SELECT CicloActual INTO Var_CicloActual
		FROM GRUPOSCREDITO
        WHERE GrupoID = Var_GrupoID;

        IF(Var_CicloActual=Var_CicloGrupo)THEN
			SELECT ProrrateaPago INTO Var_ProrrateoPago
            FROM INTEGRAGRUPOSCRE
            WHERE GrupoID = Var_GrupoID
            AND ClienteID = Var_ClienteID;
        ELSE
			SELECT ProrrateaPago INTO Var_ProrrateoPago
            FROM `HIS-INTEGRAGRUPOSCRE`
            WHERE GrupoID = Var_GrupoID
            AND ClienteID = Var_ClienteID
            AND Ciclo = Var_CicloGrupo;
        END IF;

        IF(Var_GrupoID>Entero_Cero AND Var_ProrrateoPago='S')THEN
			SELECT Par_CreditoID AS CreditoID, SUM(Det.MontoCuota) AS montoFOGAFI
			FROM CREDITOS Cre
				INNER JOIN DETALLEGARFOGAFI Det
                ON Cre.CreditoID = Det.CreditoID
                AND Cre.GrupoID = Var_GrupoID
                AND Cre.CicloGrupo = Var_CicloGrupo
			WHERE Det.Estatus <> 'P'
			AND Det.FechaPago <= Var_FecActual;
        ELSE
			SELECT Par_CreditoID AS CreditoID, SUM(MontoCuota) AS montoFOGAFI
			FROM DETALLEGARFOGAFI
			WHERE CreditoID = Par_CreditoID
			AND Estatus <> 'P'
			AND FechaPago <= Var_FecActual;
        END IF;

    END IF;

    -- 43.- CONSULTA DE CREDITOS CON MONTOS AUTORIZADOS MODIFICADOS
    IF(Par_NumCon = Con_MontoAutoMod)THEN
		SELECT CreditoID,MontoOriginal,MontoModificado,Simulado
        FROM CREDITOSMONTOAUTOMOD
        WHERE CreditoID = Par_CreditoID;
    END IF;

	-- 44.- Numero de consulta
	IF(Par_NumCon = Con_InfoCredSuspencion) THEN
		SELECT FechaSistema
			INTO Var_FechaSis
			FROM PARAMETROSSIS
			LIMIT 1;

		SELECT	CRED.CreditoID,		CRED.ProductoCreditoID,		PROD.Descripcion AS DesProducto,	CRED.ClienteID,						CLI.NombreCompleto,
				CRED.Estatus,		CRED.MontoCredito,			CRED.ConvenioNominaID,				CONV.Descripcion AS DesConvenio,	CRED.FechaInicio,
				CRED.FechaVencimien,	FUNCIONDIASATRASO(CRED.CreditoID,Var_FechaSis) AS DiasAtraso
			FROM CREDITOS CRED
				INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRED.ClienteID
				INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = CRED.ProductoCreditoID
				LEFT JOIN CONVENIOSNOMINA CONV ON CONV.ConvenioNominaID = CRED.ConvenioNominaID
			WHERE CreditoID = Par_CreditoID;
	END IF;

	-- 45.- Consulta para pantalla de cambio fuente de fondeo del modulo de cartera para el cliente Mexi
	IF(Par_NumCon = Con_CambioFuentFondCred) THEN
		SELECT	Cre.CreditoID,			Cre.ClienteID,			Cre.CuentaID,			Cre.Estatus,		Cre.ProductoCreditoID,
				Prod.Descripcion,		Cre.InstitFondeoID,		Inst.NombreInstitFon,	Cre.LineaFondeo,	Lin.DescripLinea,
				IFNULL(Rel.CreditoFondeoID,Entero_Cero) AS CreditoFondeoID,					Fond.Folio
				FROM CREDITOS Cre
				INNER JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID = Cre.ProductoCreditoID
				LEFT JOIN INSTITUTFONDEO Inst ON Inst.InstitutFondID = Cre.InstitFondeoID
				LEFT JOIN LINEAFONDEADOR Lin ON Lin.LineaFondeoID = Cre.LineaFondeo
				LEFT JOIN RELCREDPASIVO Rel ON Rel.CreditoID = Cre.CreditoID AND Rel.EstatusRelacion = Esta_Activo
				LEFT JOIN CREDITOFONDEO Fond ON Rel.CreditoFondeoID = Fond.CreditoFondeoID
			WHERE Cre.CreditoID = Par_CreditoID
				AND Cre.EsAgropecuario = Var_No
				AND Cre.Estatus IN (EstatusVigente, EstatusVencido)

				AND Cre.GrupoID = Entero_Cero;
	END IF;

	-- 52.- Consulta para la pantalla Carga Archivo Incidencias
	IF(Par_NumCon = Con_InstitucionConvenio) THEN
		SELECT CreditoID, InstitNominaID, ConvenioNominaID, EstatusNomina FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;
	END IF;

	-- 38.- CONSULTA DE CREDITOS CON ESTATUS VIGENTE O VENCIDO
	IF(Par_NumCon = Var_CartaLiq)THEN
		SELECT	Cre.CreditoID,	Cre.ClienteID,	Cli.NombreCompleto,	Cre.MontoCredito
			FROM CREDITOS AS Cre
			INNER JOIN CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Cre.CreditoID = Par_CreditoID
			  AND Cre.Estatus IN (EstatusVigente,EstatusVencido);
	END IF;

	IF (Par_NumCon = Var_ConNotaCargo) THEN

		SELECT		CRE.CreditoID,		CRE.Estatus,		CRE.EsAgropecuario,		CRE.GrupoID,		CRE.LineaCreditoID,
					CRE.ClienteID,		CLI.NombreCompleto,	IFNULL(CON.DomiciliacionPagos, Str_SI) DomiciliacionPagos
			FROM	CREDITOS CRE
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID
			LEFT JOIN CONVENIOSNOMINA CON ON CON.ConvenioNominaID = CRE.ConvenioNominaID
			WHERE	CRE.CreditoID = Par_CreditoID
			LIMIT	1;

	END IF;

	-- Consulta de Informacion del Credito
	-- No.Consulta: 53
	IF( Par_NumCon = Con_InformacionCredito ) THEN
		SET Var_DiasPermPagAnt  := Entero_Cero;
		SET Var_IntAntici       := Entero_Cero;
		SET Var_NumProyInteres  := Entero_Cero;
		SET Var_IntProActual    := Entero_Cero;
		SET Var_CapitaAdela     := Entero_Cero;
		SET Var_TotPagAdela     := Entero_Cero;

		SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
			FROM CREDDIASPAGANT Dpa
				WHERE Dpa.ProducCreditoID = Var_PrductoCreID
				AND Dpa.Frecuencia = Var_Frecuencia;

		SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

		IF(Var_DiasPermPagAnt > Entero_Cero) THEN
			SELECT MIN(FechaExigible), MIN(FechaVencim), MIN(AmortizacionID) INTO
				Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
				FROM AMORTICREDITO
					WHERE CreditoID   = Par_CreditoID
					AND FechaVencim > Var_FecActual
					AND Estatus     != EstatusPagado;

			SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);
			SET Var_FecDiasProPag := IFNULL(Var_FecDiasProPag, Fecha_Vacia);
			SET Var_ProxAmorti  := IFNULL(Var_ProxAmorti, Entero_Cero);

			IF(Var_FecProxPago != Fecha_Vacia) THEN
				SET Var_DiasAntici := DATEDIFF(Var_FecProxPago, Var_FecActual);
			  ELSE
				SET Var_DiasAntici := Entero_Cero;
			END IF;

			SELECT Amo.NumProyInteres, Amo.Interes,
				IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero),
				IFNULL(SaldoCapVigente, Entero_Cero) + IFNULL(SaldoCapAtrasa, Entero_Cero) +
				IFNULL(SaldoCapVencido, Entero_Cero) + IFNULL(SaldoCapVenNExi, Entero_Cero)  INTO
				Var_NumProyInteres, Var_Interes, Var_IntProActual, Var_CapitaAdela
				FROM AMORTICREDITO Amo
					WHERE Amo.CreditoID     = Par_CreditoID
					AND Amo.AmortizacionID = Var_ProxAmorti
					AND Amo.Estatus     != EstatusPagado;

			SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
			SET Var_IntProActual := IFNULL(Var_IntProActual, Entero_Cero);
			SET Var_CapitaAdela := IFNULL(Var_CapitaAdela, Entero_Cero);
			SET Var_Interes	:= IFNULL(Var_Interes, Entero_Cero);


			IF(Var_NumProyInteres = Entero_Cero) THEN

				IF(Var_DiasAntici <= Var_DiasPermPagAnt AND Var_ProyInPagAde = SI_ProyectInt) THEN
					SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);

					IF(Var_IntAntici < Entero_Cero) THEN
						SET Var_IntAntici := Entero_Cero;
					END IF;
				END IF;
			END IF;

			IF(Var_DiasAntici <= Var_DiasPermPagAnt) THEN
				SET Var_TotPagAdela := Var_CapitaAdela + ROUND(Var_IntAntici + Var_IntProActual,2) +
					ROUND(ROUND(Var_IntAntici + Var_IntProActual,2) * Var_ValIVAIntOr, 2);
			END IF;

		END IF;

		IF(Var_EsGrupal = Si_Grupal AND Var_ProrrateoPago = Si_Prorratea) THEN
			SELECT COUNT(CreditoID), MIN(AmortizacionID) INTO
			Var_CuotasAtraso, Var_PrimCuoAtr
			FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
					AND Estatus != EstatusPagado
					AND FechaExigible < Var_FecActual;

			SET Var_PrimCuoAtr := IFNULL(Var_PrimCuoAtr, Entero_Cero);
			SET Var_CuotasAtraso := IFNULL(Var_CuotasAtraso, Entero_Cero);

			SELECT MAX(AC.AmortizacionID), MAX(DPC.FechaPago) INTO
			Var_UltCuotaPagada, Var_FechaUltCuota
			FROM AMORTICREDITO AC, DETALLEPAGCRE DPC
				WHERE AC.CreditoID = Par_CreditoID AND DPC.CreditoID=Par_CreditoID
				AND AC.Estatus = EstatusPagado
				AND AC.FechaExigible <= Var_FecActual;

			SET Var_TotalPrimerCuota:= (
			SELECT SUM(ROUND(amo.SaldoCapVigente + amo.SaldoCapAtrasa + amo.SaldoCapVencido +
			amo.SaldoCapVenNExi + amo.SaldoInteresPro + amo.SaldoInteresAtr +
			amo.SaldoInteresVen + amo.SaldoIntNoConta +
			(amo.SaldoMoratorios + amo.SaldoMoraVencido + amo.SaldoMoraCarVen) + amo.SaldoComFaltaPa +  amo.SaldoComServGar +
			amo.SaldoOtrasComis +   amo.SaldoSeguroCuota, 2)  +
			ROUND(
			ROUND(amo.SaldoInteresPro * Var_ValIVAIntOr, 2) +
			ROUND(amo.SaldoInteresAtr * Var_ValIVAIntOr, 2) +
			ROUND(amo.SaldoInteresVen * Var_ValIVAIntOr, 2) +
			ROUND(amo.SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +
			ROUND(ROUND(amo.SaldoMoratorios * Var_ValIVAIntMo, 2) +
					ROUND(amo.SaldoMoraVencido * Var_ValIVAIntMo, 2) +
					ROUND(amo.SaldoMoraCarVen * Var_ValIVAIntMo, 2), 2) +
					ROUND(amo.SaldoComFaltaPa * Var_ValIVAGen, 2) +
					ROUND(amo.SaldoComServGar * Var_ValIVAGen, 2) +
					ROUND(amo.SaldoOtrasComis * Var_ValIVAGen, 2) +
					ROUND(amo.SaldoIVASeguroCuota, 2))
			FROM INTEGRAGRUPOSCRE Ing,
			SOLICITUDCREDITO Sol,
			CREDITOS Cre,
			AMORTICREDITO amo
				WHERE Ing.GrupoID = Var_GrupoID
					AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
					AND Sol.CreditoID = Cre.CreditoID
					AND Cre.CreditoID = amo.CreditoID
					AND Ing.Estatus = Esta_Activo
					AND	( Cre.Estatus		= EstatusVigente
					OR  Cre.Estatus		= EstatusVencido)
					AND amo.AmortizacionID = Var_PrimCuoAtr	);
		END IF;

		SET Var_EstatusCredito  := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET Var_CuotasAtraso 	:= IFNULL(Var_CuotasAtraso,Entero_Cero);
		SET	Var_FechaUltCuota	:= IFNULL(Var_FechaUltCuota,Fecha_Vacia);
		SET	Var_UltCuotaPagada	:= IFNULL(Var_UltCuotaPagada,Entero_Cero);
		SET	Var_totalPrimerCuota:= IFNULL(Var_totalPrimerCuota,Decimal_Cero);
		SET	Var_ProxAmorti		:= IFNULL(Var_ProxAmorti,Entero_Cero);
		SET Var_SaldoIVAInteres := IFNULL(Var_SaldoIVAInteres,Decimal_Cero);

		CALL CALCIVAINTERESPROVCON(
			Par_CreditoID,		Con_PagCreExi2,		Var_SaldoIVAInteres,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

		IF(Var_ComAperPagado = Var_MontoComAp) THEN
			SET Var_MontoPendPagCom := Decimal_Cero;
		ELSE
			IF(Var_ForCobComAp =For_CobProgramado ) THEN
				SET Var_MontoPendPagCom := Var_MontoComAp;
			ELSE
				SET Var_MontoPendPagCom := Decimal_Cero;
			END IF;
		END IF;

		-- ========= Inicio Consulta Comisión Anual Linea de Crédito ========
		IF(IFNULL(Var_LineaCreditoID,Entero_Cero)<>0)THEN
			SELECT CobraComAnual,	ComisionCobrada, 	SaldoComAnual
				INTO Var_CobraComAnual,	Var_ComisionCobrada, Var_SaldoComAnual
				FROM LINEASCREDITO
				WHERE LineaCreditoID = Var_LineaCreditoID;

			IF(Var_CobraComAnual='S' AND Var_ComisionCobrada='N')THEN
				SET SaldoComAnualLin := IFNULL(Var_SaldoComAnual,Entero_Cero);

				IF(Var_CliPagIVA='S')THEN

					SET	Var_IVASucurs	:= IFNULL((SELECT IVA
										FROM SUCURSALES
										 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

					SET SaldoIVAComAnualLin := ROUND( (SaldoComAnualLin*Var_IVASucurs), 2);
				END IF;

				SELECT MIN(AmortizacionID)  INTO Var_AmortizacionID
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
				AND Estatus <>  EstatusPagado
				AND DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;

				IF(IFNULL(Var_AmortizacionID,Entero_Cero)=Entero_Cero)THEN
					SET SaldoComAnualLin := Entero_Cero;
					SET SaldoIVAComAnualLin := Entero_Cero;
				END IF;

			END IF;
		END IF;

		SET SaldoComAnualLin := IFNULL(SaldoComAnualLin,Entero_Cero);
		SET SaldoIVAComAnualLin := IFNULL(SaldoIVAComAnualLin,Entero_Cero);
		-- ========= Fin Consulta Comisión Anual Linea de Crédito ========

		SELECT
			FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
			FORMAT(IFNULL(SUM(SaldoCapAtrasa),Entero_Cero),2) AS SaldoCapAtrasa,
			FORMAT(IFNULL(SUM(SaldoCapVencido),Entero_Cero),2) AS SaldoCapVencido,
			FORMAT(IFNULL(SUM(SaldoCapVenNExi),Entero_Cero),2) AS SaldoCapVenNExi,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresOrd,2)),Entero_Cero),2) AS SaldoInteresOrd,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero),2) AS SaldoInteresAtr,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero),2) AS SaldoInteresVen,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro +
				CASE WHEN AmortizacionID = Var_ProxAmorti THEN
				CASE WHEN Var_EstatusCredito = EstatusVigente THEN
					Var_IntAntici
					ELSE Entero_Cero END
					ELSE Entero_Cero END,2)),Entero_Cero),2) AS SaldoInteresPro,
			FORMAT(IFNULL(SUM(ROUND(SaldoIntNoConta +
				CASE WHEN AmortizacionID = Var_ProxAmorti THEN
				CASE WHEN Var_EstatusCredito = EstatusVencido THEN
				Var_IntAntici
				ELSE Entero_Cero END
				ELSE Entero_Cero END,2)),Entero_Cero),2) AS SaldoIntNoConta,
			ROUND(Var_SaldoIVAInteres,2) AS SaldoIVAInteres,
			FORMAT(IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero),2) AS SaldoMoratorios,
			FORMAT(IFNULL(SUM(
								ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2)+
								ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
								ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2)),Entero_Cero),2) AS SaldoIVAMorato,
			FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
			FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComFalP,

			FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) + ROUND(SaldoComServGar,2)  + ROUND(SaldoNotCargoRev,2)+ ROUND(SaldoNotCargoSinIVA,2) + ROUND(SaldoNotCargoConIVA,2)), Entero_Cero) + ROUND(Var_MontoPendPagCom,2),2) AS SaldoOtrasComis,

			FORMAT(IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero) +
				   IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2),Entero_Cero) +
				   IFNULL(SUM(IFNULL(ROUND(ROUND(SaldoNotCargoConIVA,2)* Var_IVANotaCargo,2),Entero_Cero)),Entero_Cero) +
				   IFNULL(SUM(ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2)),Entero_Cero),2) AS SaldoIVAComisi,

			FORMAT(IFNULL(SUM(SaldoSeguroCuota),Entero_Cero),2) AS SaldoSeguroCuota,
			FORMAT(IFNULL(SUM(SaldoIVASeguroCuota),Entero_Cero),2) AS SaldoIVASeguroCuota,
			FORMAT(IFNULL(SUM(SaldoComisionAnual),Entero_Cero)+SaldoComAnualLin,2) AS SaldoComAnual,
			FORMAT(IFNULL(SUM(ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2)),Entero_Cero)+SaldoIVAComAnualLin,2) AS SaldoComAnualIVA,
			FORMAT(IFNULL(SUM(	ROUND(SaldoCapVigente,2)	+	ROUND(SaldoCapAtrasa,2)	+
								ROUND(SaldoCapVencido,2)	+	ROUND(SaldoCapVenNExi,2)),Entero_Cero),2) AS totalCapital,
			FORMAT(ROUND(IFNULL(SUM(ROUND(
											SaldoInteresOrd + SaldoInteresAtr +
											SaldoInteresVen + SaldoInteresPro +
											SaldoIntNoConta +
																CASE WHEN AmortizacionID = Var_ProxAmorti THEN
																	Var_IntAntici
																	ELSE Entero_Cero END
																	,2)),Entero_Cero), 2), 2) AS totalInteres,
			FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +
									ROUND(SaldoComServGar,2) +
									ROUND(SaldoOtrasComis,2) +
									ROUND(SaldoComisionAnual,2) + /*COMISION ANUAL*/
									ROUND(SaldoSeguroCuota,2) +
									ROUND(SaldoNotCargoRev,2) +
									ROUND(SaldoNotCargoSinIVA,2) +
									ROUND(SaldoNotCargoConIVA,2) ),Entero_Cero) +
									ROUND(Var_MontoPendPagCom,2) +
									SaldoComAnualLin,2), 2) AS totalComisi,
			FORMAT(ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) +
									ROUND(SaldoComServGar,2) +
									ROUND(SaldoComisionAnual,2)/*COMISION ANUAL*/
									),Entero_Cero) * Var_ValIVAGen,2) +
									ROUND(IFNULL(SUM(ROUND(SaldoNotCargoConIVA,2)),Entero_Cero) * Var_IVANotaCargo,2)+
									IFNULL(SUM(ROUND(SaldoIVASeguroCuota,2)),Entero_Cero)
									+
									IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero)
									+ IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2) + SaldoIVAComAnualLin,Entero_Cero),2)

									AS totalIVACom,
			FORMAT(IFNULL(SUM(	ROUND(SaldoCapVigente,2) +
								ROUND(SaldoCapAtrasa,2) +
								ROUND(SaldoCapVencido,2) +
								ROUND(SaldoCapVenNExi,2) +
								ROUND(SaldoInteresOrd +
						SaldoInteresAtr +
						SaldoInteresVen +
						SaldoInteresPro +
						SaldoIntNoConta  +
						CASE WHEN AmortizacionID = Var_ProxAmorti THEN Var_IntAntici ELSE Entero_Cero END, 2) +
						ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
						ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
						ROUND(SaldoOtrasComis,2) +
						ROUND(SaldoIntOtrasComis, 2) +
						ROUND(SaldoNotCargoRev,2) +
						ROUND(SaldoNotCargoSinIVA,2) +
						ROUND(SaldoNotCargoConIVA,2) +
						ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2) +
						ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +/*SEGURO CUOTA*/
						ROUND(SaldoComisionAnual,2) + ROUND(SaldoComisionAnual * Var_ValIVAGen,2) +/*COMISION ANUAL*/
						ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
						(ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2)  +
						ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
						ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2))),Entero_Cero)+
				(ROUND(Var_SaldoIVAInteres,2))
				+
				IFNULL(SUM(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Entero_Cero)
				+ IFNULL(ROUND(ROUND(Var_MontoPendPagCom,2)* Var_ValIVAGen,2),Entero_Cero) + ROUND(Var_MontoPendPagCom,2) + (SaldoComAnualLin + SaldoIVAComAnualLin) +
				IFNULL(SUM(ROUND(FNEXIGIBLEIVAINTERESACCESORIOS(Par_CreditoID, AmortizacionID, Var_ValIVAGen, Var_CliPagIVA), 2)), Entero_Cero), 2)  AS adeudoTotal,
			FORMAT(Var_TotPagAdela, 2) AS TotalAdelanto,
			Var_CuotasAtraso AS CuotasAtraso,
			Var_UltCuotaPagada AS UltCuotaPagada,
			Var_FechaUltCuota AS FechaUltCuota,
			Var_totalPrimerCuota AS totalPrimerCuota,
			FORMAT(	ROUND(IFNULL(SUM(ROUND(SaldoSeguroCuota,2) +
					ROUND(SaldoIVASeguroCuota,2)),Entero_Cero),2),2) AS TotalSeguroCuota
		FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
				AND Estatus <> EstatusPagado
				AND DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;
	END IF;
END TerminaStore$$