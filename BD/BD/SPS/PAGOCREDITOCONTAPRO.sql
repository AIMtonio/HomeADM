-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOCONTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOCONTAPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOCREDITOCONTAPRO`(


	Par_CreditoID			BIGINT,
	Par_CuentaContable		VARCHAR(25),
	Par_CenCosto			INT,
	Par_MontoPagar			DECIMAL(12, 2),
	Par_MonedaID			INT,

	Par_Finiquito			CHAR(1),
	Par_ComFiniquito		CHAR(1),
	Par_PagarIVA			CHAR(1),
	Par_EmpresaID			INT,
	Par_Salida				CHAR(1),

	Par_AltaEncPoliza		CHAR(1),
	INOUT Var_MontoPago		DECIMAL(12, 2),
	INOUT Var_MontoIVAInt	DECIMAL(12, 2),
	INOUT Var_MontoIVAMora	DECIMAL(12, 2),
	INOUT Var_MontoIVAComi	DECIMAL(12, 2),

	INOUT Var_Poliza		BIGINT,
	Par_OrigenPago			CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE Var_CreditoID 		BIGINT(12);
DECLARE Var_AmortizacionID	INT(11);
DECLARE Var_SaldoCapVigente	DECIMAL(12, 2);
DECLARE Var_SaldoCapAtrasa	DECIMAL(12, 2);
DECLARE Var_SaldoCapVencido	DECIMAL(12, 2);
DECLARE Var_SaldoCapVenNExi	DECIMAL(12, 2);
DECLARE Var_SaldoInteresOrd	DECIMAL(12, 4);
DECLARE Var_SaldoInteresAtr	DECIMAL(12, 4);
DECLARE Var_SaldoInteresVen	DECIMAL(12, 4);
DECLARE Var_SaldoInteresPro	DECIMAL(12, 4);
DECLARE Var_SaldoIntNoConta	DECIMAL(12, 4);
DECLARE Var_SaldoMoratorios	DECIMAL(12, 2);
DECLARE Var_SaldoMoraVenci	DECIMAL(12, 2);
DECLARE Var_SaldoMoraCarVen	DECIMAL(12, 2);
DECLARE Var_SaldoComFaltaPa	DECIMAL(12, 2);
DECLARE Var_SaldoOtrasComis	DECIMAL(12, 2);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_MonedaID        INT;
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);

DECLARE Var_GrupoID         INT;
DECLARE Var_CicloActual     INT;
DECLARE Var_GrupoCtaID      INT;

DECLARE Var_SaldoPago       DECIMAL(14, 4);
DECLARE Var_CantidPagar     DECIMAL(14, 4);
DECLARE Var_IVACantidPagar  DECIMAL(12, 2);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecAplicacion   DATE;
DECLARE Var_EsHabil			CHAR(1);
DECLARE Var_IVASucurs       DECIMAL(8, 4);
DECLARE Var_SucCliente      INT;

DECLARE Var_ClienteID		BIGINT;
DECLARE Var_ProdCreID		INT;
DECLARE Var_ClasifCre		CHAR(1);
DECLARE Var_CreditoStr		VARCHAR(20);
DECLARE Var_NumAmorti		INT;
DECLARE Var_NumAmoPag		INT;
DECLARE Var_NumAmoExi		INT;

DECLARE Var_MontoDeuda		DECIMAL(14,2);
DECLARE Var_CliPagIVA		CHAR(1);
DECLARE Var_IVAIntOrd		CHAR(1);
DECLARE Var_IVAIntMor		CHAR(1);
DECLARE Var_ValIVAIntOr		DECIMAL(12,2);
DECLARE Var_ValIVAIntMo		DECIMAL(12,2);
DECLARE Var_ValIVAGen		DECIMAL(12,2);

DECLARE Var_EsReestruc		CHAR(1);
DECLARE Var_EstCreacion		CHAR(1);
DECLARE Var_Regularizado	CHAR(1);
DECLARE Var_ResPagAct       INT;
DECLARE Var_NumPagSos       INT;

DECLARE Var_ProxAmorti      INT;
DECLARE Var_DiasAntici      INT;
DECLARE Var_ProyInPagAde    CHAR(1);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_DiasCredito     INT;
DECLARE Mov_AboConta        INT;
DECLARE Mov_CarConta        INT;
DECLARE Mov_CarOpera        INT;
DECLARE Var_Frecuencia      CHAR(1);
DECLARE Var_DiasPermPagAnt  INT;

DECLARE Var_ComAntici       DECIMAL(14,4);
DECLARE Var_IVAComAntici    DECIMAL(14,2);
DECLARE Var_CobraComLiqAnt  CHAR(1);
DECLARE Var_TipComLiqAnt    CHAR(1);
DECLARE Var_ComLiqAnt       DECIMAL(14,4);
DECLARE Var_DiasGraciaLiq   INT;
DECLARE Var_IntActual       DECIMAL(14,2);
DECLARE Var_FecVenCred      DATE;
DECLARE Var_SubClasifID     INT;
DECLARE Var_TipCobComFal    CHAR(1);
DECLARE Var_SalCapitales    DECIMAL(14,2);
DECLARE Var_NumCapAtra      INT;

DECLARE Var_ManejaLinea		CHAR(1);
DECLARE Var_EsRevolvente	CHAR(1);
DECLARE Var_LineaCredito	BIGINT;
DECLARE Var_TipoPrepago		CHAR(1);
DECLARE Var_MonPrePago		DECIMAL(12,2);
DECLARE	Var_DivContaIng		CHAR(1);
DECLARE Var_InverEnGar      INT;
DECLARE Var_NumErrChar		VARCHAR(10);
DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);	-- Es Linea de Credito Agro Revolvente
DECLARE Var_MontoComServGar					DECIMAL(14,2);	-- Monto Comision por Servicio de Garantia Agro
DECLARE Var_MontoIvaComServGar				DECIMAL(14,2);	-- Monto Iva Comision por Servicio de Garantia Agro

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE Decimal_Cien    DECIMAL(12, 2);

DECLARE Esta_Activo     CHAR(1);
DECLARE Esta_Cancelado  CHAR(1);
DECLARE Esta_Inactivo   CHAR(1);
DECLARE Esta_Vencido    CHAR(1);
DECLARE Esta_Vigente    CHAR(1);
DECLARE Esta_Atrasado   CHAR(1);

DECLARE Esta_Pagado     CHAR(1);

DECLARE Par_SalidaNO    CHAR(1);
DECLARE Par_SalidaSI    CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPolCre_NO   CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE Finiquito_SI    CHAR(1);
DECLARE Finiquito_NO    CHAR(1);
DECLARE PrePago_SI      CHAR(1);
DECLARE PrePago_NO      CHAR(1);
DECLARE SI_ProyectInt   CHAR(1);
DECLARE Mov_IntPro      INT;
DECLARE Con_IntDeven    INT;
DECLARE Con_IngreInt    INT;

DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE SiPagaIVA      	CHAR(1);
DECLARE Coc_PagoCred    INT;

DECLARE Aho_PagoCred    CHAR(4);
DECLARE Con_AhoCapital  INT;

DECLARE Mov_CapVigente  	INT;
DECLARE Mov_CapAtrasado 	INT;
DECLARE Mov_CapVencido  	INT;
DECLARE Mov_CapVencidoNE	INT;
DECLARE Mov_IntOrdinario    INT;
DECLARE Mov_IntAtrasado		INT;
DECLARE Mov_IntVencido		INT;
DECLARE Mov_IntNoContab		INT;
DECLARE Mov_IntProvision	INT;
DECLARE Mov_Moratorio		INT;
DECLARE Mov_ComFalPag		INT;
DECLARE Mov_IVAInteres		INT;
DECLARE Mov_IVAIntMora		INT;
DECLARE Mov_IVAComFaPag		INT;
DECLARE Mov_ComLiqAnt       INT;
DECLARE Mov_IVAComLiqAnt    INT;

DECLARE Con_CapVigente		INT;
DECLARE Con_CapAtrasado		INT;
DECLARE Con_CapVencido		INT;
DECLARE Con_CapVencidoNE	INT;
DECLARE Con_IngInteres		INT;
DECLARE Con_IngIntMora		INT;
DECLARE Con_IngFalPag		INT;
DECLARE Con_IVAInteres		INT;
DECLARE Con_IVAMora			INT;
DECLARE Con_IVAFalPag		INT;
DECLARE Con_CtaOrdInt		INT;
DECLARE Con_CorIntDev		INT;
DECLARE Con_CtaOrdMor		INT;
DECLARE Con_CorIntMor		INT;
DECLARE Con_CtaOrdCom		INT;
DECLARE Con_CorComFal		INT;
DECLARE Con_IntAtrasado		INT;
DECLARE Con_IntVencido		INT;
DECLARE Con_ComFiniqui		INT;
DECLARE Con_IVAComFin		INT;
DECLARE Tol_DifPago			DECIMAL(10,4);
DECLARE Des_PagoCred		VARCHAR(50);
DECLARE Con_PagoCred		VARCHAR(50);
DECLARE Ref_PagAnti			VARCHAR(50);

DECLARE No_EsReestruc		CHAR(1);
DECLARE Si_EsReestruc		CHAR(1);
DECLARE Si_Regulariza		CHAR(1);
DECLARE No_Regulariza		CHAR(1);
DECLARE Si_EsGrupal			CHAR(1);
DECLARE NO_EsGrupal			CHAR(1);
DECLARE SI_PermiteLiqAnt	CHAR(1);
DECLARE SI_CobraLiqAnt		CHAR(1);
DECLARE Cob_FalPagCuota		CHAR(1);
DECLARE Cob_FalPagFinal		CHAR(1);
DECLARE SiManejaLinea		CHAR(1);
DECLARE NoManejaLinea		CHAR(1);
DECLARE SiEsRevolvente		CHAR(1);
DECLARE NoEsRevolvente		CHAR(1);
DECLARE Act_PagoSost		INT;
DECLARE Proyeccion_Int  	CHAR(1);
DECLARE Monto_Fijo      	CHAR(1);
DECLARE Por_Porcentaje  	CHAR(1);
DECLARE Tip_UltCuo			CHAR(1);
DECLARE Tip_SigCuo			CHAR(1);
DECLARE Tip_Prorrateo		CHAR(1);
DECLARE Mon_MinPago     	DECIMAL(12,2);
DECLARE Ins_Credito			INT;
DECLARE	NO_Respaldar		CHAR(1);
DECLARE Act_LiberarPagCre	INT;
DECLARE Pago_CargoCta		CHAR(1);
DECLARE Var_EsConsolidacionAgro CHAR(1);	-- Es Credito Consolidado
DECLARE Var_EstatusConsolidacion CHAR(1);	-- Estatus del credito al momento de la consolidacion
DECLARE Var_EsRegularizado       CHAR(1);	-- Si la conlidacion es Regularizada
DECLARE Con_SI            		 CHAR(1);	-- Constante SI
DECLARE Con_NO            		 CHAR(1);	-- Constante NO
DECLARE Var_NumPagosSostenidos	 INT(11);	-- Numero de Pagos Sostenidos
DECLARE Var_EsConsolidacion	CHAR(1);		-- Variable para saber si el credito es consolidado
DECLARE Salida_NO				CHAR(1);	-- Constante Salida NO


DECLARE CURSORAMORTI CURSOR FOR
	SELECT	Amo.CreditoID,			Amo.AmortizacionID,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,		Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresVen,	Amo.SaldoInteresPro,
			Amo.SaldoIntNoConta,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Cre.MonedaID,
			Amo.FechaInicio,		Amo.FechaVencim,		Amo.FechaExigible,		Amo.Estatus,			Amo.SaldoMoraVencido,
			Amo.SaldoMoraCarVen,	Amo.SaldoComServGar
	FROM AMORTICREDITO Amo
	INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
	WHERE Cre.CreditoID = Par_CreditoID
	  AND Cre.Estatus IN (Esta_Vigente, Esta_Vencido)
	  AND Amo.Estatus IN (Esta_Vigente, Esta_Vencido, Esta_Atrasado)
	ORDER BY FechaExigible;

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Decimal_Cien    := 100.00;

SET Esta_Activo     := 'A';
SET Esta_Cancelado  := 'C';
SET Esta_Inactivo   := 'I';
SET Esta_Vencido    := 'B';
SET Esta_Vigente    := 'V';
SET Esta_Atrasado   := 'A';

SET Esta_Pagado     := 'P';

SET Aho_PagoCred    := '101';
SET Con_AhoCapital  := 1;

SET Par_SalidaNO    := 'N';
SET Par_SalidaSI    := 'S';
SET SiManejaLinea	:= 'S';
SET NoManejaLinea	:= 'N';
SET SiEsRevolvente	:= 'S';
SET NoEsRevolvente	:= 'N';

SET PrePago_SI      := 'S';
SET PrePago_NO      := 'N';
SET Finiquito_SI    := 'S';
SET Finiquito_NO    := 'N';
SET SI_ProyectInt   := 'S';
SET Mov_IntPro      := 14;
SET Con_IntDeven    := 19;
SET Con_IngreInt    := 5;
SET AltaPoliza_SI   := 'S';
SET AltaPoliza_NO   := 'N';
SET AltaPolCre_SI   := 'S';
SET AltaPolCre_NO   := 'N';
SET AltaMovCre_NO   := 'N';
SET AltaMovCre_SI   := 'S';
SET AltaMovAho_NO   := 'N';
SET AltaMovAho_SI   := 'S';

SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Pol_Automatica  := 'A';
SET SiPagaIVA       := 'S';
SET Coc_PagoCred    := 54;

SET Mov_CapVigente  	:= 1;
SET Mov_CapAtrasado 	:= 2;
SET Mov_CapVencido  	:= 3;
SET Mov_CapVencidoNE    := 4;
SET Mov_IntOrdinario    := 10;
SET Mov_IntAtrasado		:= 11;
SET Mov_IntVencido		:= 12;
SET Mov_IntNoContab		:= 13;
SET Mov_IntProvision    := 14;
SET Mov_Moratorio		:= 15;
SET Mov_ComFalPag   	:= 40;
SET Mov_IVAInteres		:= 20;
SET Mov_IVAIntMora  	:= 21;
SET Mov_IVAComFaPag 	:= 22;
SET Mov_ComLiqAnt   	:= 42;
SET Mov_IVAComLiqAnt    := 24;

SET Con_CapVigente  	:= 1;
SET Con_CapAtrasado 	:= 2;
SET Con_CapVencido  	:= 3;
SET Con_CapVencidoNE    := 4;
SET Con_IngInteres  	:= 5;
SET Con_IngIntMora  	:= 6;
SET Con_IngFalPag  		:= 7;
SET Con_IVAInteres  	:= 8;
SET Con_IVAMora     	:= 9;
SET Con_IVAFalPag   	:= 10;
SET Con_CtaOrdInt   	:= 11;
SET Con_CorIntDev   	:= 12;
SET Con_CtaOrdMor   	:= 13;
SET Con_CorIntMor   	:= 14;
SET Con_CtaOrdCom   	:= 15;
SET Con_CorComFal   	:= 16;
SET Con_IntAtrasado 	:= 20;
SET Con_IntVencido  	:= 21;
SET Con_ComFiniqui  	:= 27;
SET Con_IVAComFin   	:= 28;
SET Tol_DifPago     	:= 0.05;

SET No_EsReestruc   	:= 'N';
SET Si_EsReestruc   	:= 'S';
SET Si_Regulariza   	:= 'S';
SET No_Regulariza   	:= 'N';
SET Si_EsGrupal     	:= 'S';
SET NO_EsGrupal     	:= 'N';
SET SI_PermiteLiqAnt    := 'S';
SET SI_CobraLiqAnt      := 'S';
SET Cob_FalPagCuota     := 'C';
SET Cob_FalPagFinal     := 'F';
SET Proyeccion_Int      := 'P';
SET Monto_Fijo          := 'M';
SET Por_Porcentaje      := 'S';

SET Tip_UltCuo			:= 'U';
SET Tip_SigCuo			:= 'I';
SET Tip_Prorrateo		:= 'V';
SET Ins_Credito			:= 11;
SET NO_Respaldar		:= 'N';

SET Act_PagoSost    	:= 2;
SET Mon_MinPago			:= 0.01;

SET Ref_PagAnti     	:= 'PAGO ANTICIPADO';
SET Des_PagoCred    	:= 'PAGO DE CREDITO';
SET Con_PagoCred    	:= 'PAGO DE CREDITO';
SET Aud_ProgramaID  	:= 'PAGOCREDITOPRO';
SET Act_LiberarPagCre	:= 3;
SET Pago_CargoCta		:= 'C';
SET Con_SI            	:= 'S';
SET Con_NO            	:= 'N';
SET Aud_FechaActual		:= NOW();
SET Salida_NO			:= 'N';
ManejoErrores: BEGIN


SET	Var_MontoIVAInt		:= Entero_Cero;
SET	Var_MontoIVAMora	:= Entero_Cero;
SET	Var_MontoIVAComi	:= Entero_Cero;
SET Par_NumErr			:= 0;
SET Par_ErrMen			:= 'Pago Aplicado Exitosamente';
SET Par_Consecutivo		:= Entero_Cero;


SET Var_FechaSistema	:= (SELECT FechaSistema			FROM PARAMETROSSIS);
SET Var_DiasCredito		:= (SELECT DiasCredito			FROM PARAMETROSSIS);
SET Var_DivContaIng		:= (SELECT DivideIngresoInteres FROM PARAMETROSSIS);

SET Var_ClienteID		:= (SELECT Cre.ClienteID			FROM CREDITOS Cre	WHERE Cre.CreditoID	= Par_CreditoID);
SET Var_ProdCreID		:= (SELECT Cre.ProductoCreditoID	FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_NumAmorti		:= (SELECT Cre.NumAmortizacion		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_EstatusCre		:= (SELECT Cre.Estatus				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_CreTasa			:= (SELECT Cre.TasaFija				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_MonedaID		:= (SELECT Cre.MonedaID				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_Frecuencia		:= (SELECT Cre.FrecuenciaCap		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_FecVenCred		:= (SELECT Cre.FechaVencimien		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_GrupoID			:= (SELECT Cre.GrupoID				FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_LineaCredito	:= (SELECT Cre.LineaCreditoID		FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_TipoPrepago		:= (SELECT Cre.TipoPrepago			FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
SET Var_SaldoCapita		:= (SELECT Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad + Cre.SaldoCapVencido
										FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);

SET	Var_EsConsolidacion	:= (SELECT Cre.EsConsolidado	FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
IF(Var_EsConsolidacion = Con_SI) THEN
	SET	Var_EstatusConsolidacion	:= IFNULL((SELECT EstatusCreacion FROM CONSOLIDACIONCARTALIQ WHERE CreditoID = Par_CreditoID), Cadena_Vacia);
	SET	Var_EsRegularizado			:= IFNULL((SELECT Regularizado FROM CONSOLIDACIONCARTALIQ WHERE CreditoID = Par_CreditoID), Cadena_Vacia);
	SET Var_NumPagosSostenidos		:= IFNULL((SELECT NumPagoActual FROM CONSOLIDACIONCARTALIQ WHERE CreditoID = Par_CreditoID), Cadena_Vacia);
END IF;

SET Var_EsConsolidacionAgro	:= (SELECT Cre.EsConsolidacionAgro	FROM CREDITOS Cre	WHERE Cre.CreditoID = Par_CreditoID);
IF( Var_EsConsolidacionAgro = Con_SI ) THEN
	SET Var_EstatusConsolidacion := IFNULL((SELECT EstatusCreacion FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Cadena_Vacia);
	SET Var_EsRegularizado       := IFNULL((SELECT Regularizado FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Con_NO);
	SET Var_NumPagosSostenidos   := IFNULL((SELECT NumPagoActual FROM REGCRECONSOLIDADOS WHERE CreditoID = Par_CreditoID), Entero_Cero);
END IF;

SET Var_SucCliente		:= (SELECT Cli.SucursalOrigen		FROM CLIENTES Cli	WHERE Cli.ClienteID = Var_ClienteID);
SET Var_CliPagIVA		:= (SELECT Cli.PagaIVA				FROM CLIENTES Cli	WHERE Cli.ClienteID = Var_ClienteID);

SET Var_ClasifCre		:= (SELECT Des.Clasificacion 		FROM DESTINOSCREDITO Des, CREDITOS Cre
								WHERE	Cre.CreditoID	= Par_CreditoID	AND Cre.DestinoCreID	= Des.DestinoCreID);
SET Var_SubClasifID		:= (SELECT Des.SubClasifID 		FROM DESTINOSCREDITO Des, CREDITOS Cre
								WHERE	Cre.CreditoID	= Par_CreditoID	AND Cre.DestinoCreID	= Des.DestinoCreID);

SET Var_IVAIntOrd		:= (SELECT Pro.CobraIVAInteres		FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_IVAIntMor		:= (SELECT Pro.CobraIVAMora			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID 	= Var_ProdCreID);
SET Var_EsReestruc		:= (SELECT Pro.EsReestructura		FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_ProyInPagAde	:= (SELECT Pro.ProyInteresPagAde	FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_TipCobComFal	:= (SELECT Pro.TipoPagoComFalPago	FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_ManejaLinea		:= (SELECT Pro.ManejaLinea			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_EsRevolvente	:= (SELECT Pro.EsRevolvente			FROM PRODUCTOSCREDITO Pro	WHERE Pro.ProducCreditoID	= Var_ProdCreID);
SET Var_EstCreacion		:= (SELECT Res.EstatusCreacion		FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);
SET Var_Regularizado	:= (SELECT Res.Regularizado			FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);
SET Var_ResPagAct		:= (SELECT Res.NumPagoActual		FROM REESTRUCCREDITO Res 	WHERE Res.CreditoDestinoID	= Par_CreditoID);
SET Var_EsLineaCreditoAgroRevolvente := (SELECT Lin.EsRevolvente
										 FROM CREDITOS Cre
										 INNER JOIN LINEASCREDITO Lin ON Cre.LineaCreditoID = Lin.LineaCreditoID AND Lin.EsAgropecuario = Con_SI
										 WHERE Cre.CreditoID = Par_CreditoID);

SET	Var_DivContaIng		:= IFNULL(Var_DivContaIng,	Cadena_Vacia);
SET Var_EstCreacion     := IFNULL(Var_EstCreacion,	Cadena_Vacia);
SET Var_Regularizado    := IFNULL(Var_Regularizado,	Cadena_Vacia);
SET Var_ResPagAct		:= IFNULL(Var_ResPagAct, 	Entero_Cero);
SET Var_SubClasifID		:= IFNULL(Var_SubClasifID,	Entero_Cero);
SET Var_TipCobComFal    := IFNULL(Var_TipCobComFal,	Cadena_Vacia);
SET Var_TipoPrepago		:= IFNULL(Var_TipoPrepago, 	Cadena_Vacia);
SET Var_EsLineaCreditoAgroRevolvente := IFNULL(Var_EsLineaCreditoAgroRevolvente, Con_NO);


SET Var_DiasPermPagAnt	:= (SELECT Dpa.NumDias
								FROM CREDDIASPAGANT Dpa
								WHERE Dpa.ProducCreditoID = Var_ProdCreID
								  AND Dpa.Frecuencia = Var_Frecuencia);
SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

IF(Var_EstCreacion = Cadena_Vacia) THEN
    SET Var_EsReestruc  := No_EsReestruc;
ELSE
    SET Var_EsReestruc  := SI_EsReestruc;
END IF;

SET Var_IVASucurs		:=	(SELECT IVA	FROM SUCURSALES	WHERE SucursalID = Var_SucCliente);

SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);


SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;
SET Var_NumPagSos   := Entero_Cero;
SET Var_ComAntici   := Entero_Cero;
SET Var_DiasAntici  := Entero_Cero;


IF (Var_CliPagIVA = SiPagaIVA) THEN
    SET Var_ValIVAGen  := Var_IVASucurs;

    IF (Var_IVAIntOrd = SiPagaIVA) THEN
        SET Var_ValIVAIntOr  := Var_IVASucurs;
    END IF;

    IF (Var_IVAIntMor = SiPagaIVA) THEN
        SET Var_ValIVAIntMo  := Var_IVASucurs;
    END IF;
END IF;


 IF( Par_Finiquito = Finiquito_SI) THEN
    SET Con_PagoCred 	:= "LIQUIDACION ANT.CREDITO";
    SET Var_FecVenCred	:= IFNULL(Var_FecVenCred, Fecha_Vacia);


    SET Var_CobraComLiqAnt	:= (SELECT	CobraComLiqAntici	FROM ESQUEMACOMPRECRE	WHERE ProductoCreditoID = Var_ProdCreID);
    SET Var_TipComLiqAnt	:= (SELECT	TipComLiqAntici		FROM ESQUEMACOMPRECRE	WHERE ProductoCreditoID = Var_ProdCreID);
    SET Var_ComLiqAnt		:= (SELECT	ComisionLiqAntici	FROM ESQUEMACOMPRECRE	WHERE ProductoCreditoID = Var_ProdCreID);
    SET Var_DiasGraciaLiq	:= (SELECT	DiasGraciaLiqAntici	FROM ESQUEMACOMPRECRE	WHERE ProductoCreditoID = Var_ProdCreID);
    SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt,	Cadena_Vacia);
    SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt,		Cadena_Vacia);
    SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt,		Entero_Cero);
    SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq,	Entero_Cero);

    IF(Var_FecVenCred != Fecha_Vacia AND Var_FecVenCred >= Var_FechaSistema) THEN
        SET Var_DiasAntici := DATEDIFF(Var_FecVenCred, Var_FechaSistema);
    ELSE
        SET Var_DiasAntici := Entero_Cero;
    END IF;




   IF(Var_DiasAntici > Var_DiasGraciaLiq AND Par_ComFiniquito = SI_CobraLiqAnt AND
       Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN


        IF(Var_TipComLiqAnt = Proyeccion_Int) THEN


            SET Var_ComAntici	:= (SELECT SUM(Interes)
										FROM AMORTICREDITO
										WHERE CreditoID   = Par_CreditoID
										  AND FechaVencim > Var_FechaSistema
										  AND Estatus     != Esta_Pagado);

            SET Var_ComAntici   := IFNULL(Var_ComAntici, Entero_Cero);


            SET Var_IntActual	:= (SELECT (Amo.SaldoInteresPro + Amo.SaldoIntNoConta)
										FROM AMORTICREDITO Amo
										WHERE Amo.CreditoID   = Par_CreditoID
										  AND Amo.FechaVencim > Var_FechaSistema
										  AND Amo.FechaInicio <= Var_FechaSistema
										  AND Amo.Estatus     != Esta_Pagado);

            SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
            SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

        ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN
            SET Var_ComAntici   := ROUND(Var_SaldoCapita * Var_ComLiqAnt / Decimal_Cien,2);
        ELSE
            SET Var_ComAntici   := Var_ComLiqAnt;
        END IF;
    END IF;

    IF(Var_ComAntici < Entero_Cero) THEN
        SET Var_ComAntici   := Entero_Cero;
    END IF;


	IF(Par_PagarIVA = SiPagaIVA) THEN
		SET Var_MontoDeuda := (SELECT FUNCIONTOTDEUDACRE(Par_CreditoID));
		SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero) +
									 Var_ComAntici + ROUND(Var_ComAntici * Var_ValIVAIntOr,2);
	ELSE
		SET Var_MontoDeuda := (SELECT FUNCTOTDEUCRESINIIVA(Par_CreditoID));
		SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero) + Var_ComAntici;
	END IF;

    IF(ABS(Var_MontoDeuda - Par_MontoPagar) > 0.05) THEN
		SET Par_NumErr		:= 100;
		SET Par_ErrMen		:= CONCAT('Credito: ', CONVERT(Par_CreditoID,CHAR), ' .En una Liquidacion Anticipada el Monto de pago deber ser el Total ',
								 'del Adeudo. Adeudo Total: ', CONVERT(Var_MontoDeuda, CHAR),
								' .Monto del Pago: ', CONVERT(Par_MontoPagar, CHAR));
        SET Par_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
    END IF;
END IF;

CALL DIASFESTIVOSCAL(
	Var_FechaSistema,	Entero_Cero,		Var_FecAplicacion,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);

IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_NumErr		:= 1;
	SET Par_ErrMen		:= 'El Credito no Existe';
	SET Par_Consecutivo	:= Entero_Cero;
	LEAVE ManejoErrores;
END IF;

IF(Var_EstatusCre != Esta_Vigente AND
   Var_EstatusCre != Esta_Vencido ) THEN

	SET Par_NumErr		:= 2;
	SET Par_ErrMen		:= 'Estatus del Credito Incorrecto';
	SET Par_Consecutivo	:= Entero_Cero;
	LEAVE ManejoErrores;
END IF;


CALL RESPAGCREDITOPRO(
			Par_CreditoID,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
    CALL MAESTROPOLIZASALT(
        Var_Poliza,			Par_EmpresaID,		Var_FecAplicacion,	Pol_Automatica,		Coc_PagoCred,
        Con_PagoCred,		Par_SalidaNO,		Par_NumErr,         Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
END IF;

SET Var_SaldoPago       := Par_MontoPagar;
SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));


IF( Par_Finiquito = Finiquito_SI AND Var_ComAntici > Entero_Cero) THEN


    SET Var_ProxAmorti	:=	(SELECT MIN(AmortizacionID)
								FROM AMORTICREDITO
								WHERE CreditoID     = Par_CreditoID
								  AND FechaVencim >= Var_FechaSistema
								  AND Estatus     != Esta_Pagado);


    CALL CONTACREDITOSPRO (
        Par_CreditoID,      Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Var_FechaSistema,
        Var_FecAplicacion,  Var_ComAntici,      Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_PagoCred,       Ref_PagAnti,        AltaPoliza_NO,
        Entero_Cero,        Var_Poliza,         AltaPolCre_NO,      AltaMovCre_SI,      Entero_Cero,
        Mov_ComLiqAnt,      Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Par_OrigenPago,     Par_SalidaNO,		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
        Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Ref_PagAnti,		Aud_Sucursal,       Aud_NumTransaccion);
	IF(Par_NumErr > Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


    CALL CONTACREDITOSPRO (
        Par_CreditoID,      Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Var_FechaSistema,
        Var_FecAplicacion,  Var_ComAntici,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,		Des_PagoCred,       Ref_PagAnti,        AltaPoliza_NO,
        Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Con_ComFiniqui,
        Mov_ComLiqAnt,      Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Par_OrigenPago,     Par_SalidaNO,		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
        Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);
	IF(Par_NumErr > Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;


	SET Var_IVAComAntici    := ROUND(Var_ComAntici * Var_ValIVAIntOr, 2);
	IF(Par_PagarIVA = SiPagaIVA) THEN
		IF(Var_IVAComAntici > Entero_Cero) THEN
			CALL CONTACREDITOSPRO (
				Par_CreditoID,      Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Var_FechaSistema,
                Var_FecAplicacion,  Var_IVAComAntici,   Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,		Des_PagoCred,       Ref_PagAnti,        AltaPoliza_NO,
                Entero_Cero,		Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Con_IVAComFin,
				Mov_IVAComLiqAnt,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,
                Par_OrigenPago,		Par_SalidaNO,		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
                Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,        Aud_FechaActual,   	Aud_DireccionIP,
                Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
			IF(Par_NumErr > Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	ELSE
		SET	Var_MontoIVAComi	:= Var_MontoIVAComi + Var_IVAComAntici;
		SET	Var_IVAComAntici	:= Entero_Cero;
	END IF;

    SET Var_SaldoPago   := Var_SaldoPago - Var_ComAntici - Var_IVAComAntici;


    UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_ProxAmorti
				AND CreditoID = Par_CreditoID;

END IF;

OPEN CURSORAMORTI;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORAMORTI INTO
        Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoCapVigente,    Var_SaldoCapAtrasa,		Var_SaldoCapVencido,
        Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,    Var_SaldoInteresAtr,    Var_SaldoInteresVen,    Var_SaldoInteresPro,
        Var_SaldoIntNoConta,    Var_SaldoMoratorios,    Var_SaldoComFaltaPa,    Var_SaldoOtrasComis,    Var_MonedaID,
        Var_FechaInicio,        Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoMoraVenci,
		Var_SaldoMoraCarVen,	Var_MontoComServGar;


    SET Var_CantidPagar		:= Decimal_Cero;
    SET Var_IVACantidPagar	:= Decimal_Cero;
    SET Var_NumPagSos       := Entero_Cero;
	SET	Var_SaldoMoraVenci	:= IFNULL(Var_SaldoMoraVenci, Entero_Cero);
	SET	Var_SaldoMoraCarVen	:= IFNULL(Var_SaldoMoraCarVen, Entero_Cero);
    SET Var_SalCapitales    := Var_SaldoCapVigente + Var_SaldoCapAtrasa +
								Var_SaldoCapVencido + Var_SaldoCapVenNExi;
	SET Var_MontoComServGar		:= IFNULL(Var_MontoComServGar, Entero_Cero);

	IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
		LEAVE CICLO;
	END IF;

   IF( DATE_SUB(Var_FechaExigible, INTERVAL Var_DiasPermPagAnt DAY) > Var_FechaSistema AND Par_Finiquito = Finiquito_NO) THEN
		LEAVE CICLO;
	END IF;

	-- Pago de Garantias por Servicio de Linea de credito Agro
	IF (Var_MontoComServGar >= Mon_MinPago ) THEN

		SET Var_IVACantidPagar := ROUND((Var_MontoComServGar * Var_ValIVAGen), 2);

		IF( ROUND(Var_SaldoPago,2) >= (Var_MontoComServGar + Var_IVACantidPagar)) THEN
			SET Var_CantidPagar		:= Var_MontoComServGar;
		ELSE
			SET Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
			SET Var_CantidPagar		:= ROUND(Var_SaldoPago,2) - Var_IVACantidPagar;
		END IF;

		CALL PAGCRECOMSERGARANTIAPRO (
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
			Des_PagoCred,		Par_CuentaContable,		Var_Poliza,			Par_Origen,			Pago_CargoCta,
			Par_Consecutivo,
			Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
		UPDATE AMORTICREDITO SET
			NumTransaccion = Aud_NumTransaccion
		WHERE AmortizacionID = Var_AmortizacionID
		  AND CreditoID = Par_CreditoID;

		SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;
	END IF;

	IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:= Var_SaldoComFaltaPa;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAComi	:= Var_MontoIVAComi + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAComi	:= Var_MontoIVAComi + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		END IF;

        CALL  PAGCRECOMFALPRO (
            Var_CreditoID,	    Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,	Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,	Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,		Par_CuentaContable,	Var_Poliza,         Par_OrigenPago,		Par_NumErr,
            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;


	IF (Var_SaldoMoraVenci >= Mon_MinPago) THEN
		SET	Var_IVACantidPagar = ROUND((Var_SaldoMoraVenci *  Var_ValIVAIntMo), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoraVenci + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoMoraVenci;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		END IF;

        CALL  PAGCREMORATOVENCPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,			Par_OrigenPago,		Var_NumErrChar,
            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,      Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		IF(Var_NumErrChar <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;
	END IF;


	IF (Var_SaldoMoraCarVen >= Mon_MinPago) THEN
		SET	Var_IVACantidPagar = ROUND((Var_SaldoMoraCarVen *  Var_ValIVAIntMo), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoraCarVen + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoMoraCarVen;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		END IF;

        CALL  PAGCREMORACARVENPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,
            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;
	END IF;


	IF (Var_SaldoMoratorios >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND((Var_SaldoMoratorios *  Var_ValIVAIntMo), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoMoratorios;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2) -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAMora	:= Var_MontoIVAMora + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;
		END IF;

        CALL PAGCREMORAPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_SaldoMoratorios,Var_Poliza,			Par_OrigenPago,
            Par_NumErr,         Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,
            Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoInteresVen >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND(ROUND(Var_SaldoInteresVen,2) *  Var_ValIVAIntOr, 2);

		IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresVen,2) + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoInteresVen;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		ELSE
			SET	Var_CantidPagar		:= Var_SaldoPago -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		END IF;

        CALL PAGCREINTVENPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,
            Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_ValIVAIntOr), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresAtr, 2) + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoInteresAtr;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		ELSE
			SET	Var_CantidPagar		:= Var_SaldoPago -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		END IF;

        CALL PAGCREINTATRPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,         Par_OrigenPago,		Par_NumErr,
            Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoInteresPro;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		ELSE
			SET	Var_CantidPagar		:= Var_SaldoPago -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		END IF;

        CALL PAGCREINTPROPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,         Par_OrigenPago,		Par_NumErr,
            Par_ErrMen,          Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;


	IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

		SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_ValIVAIntOr), 2);

		IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoIntNoConta, 2) + Var_IVACantidPagar)) THEN
			SET	Var_CantidPagar		:=  Var_SaldoIntNoConta;



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		ELSE
			SET	Var_CantidPagar		:= Var_SaldoPago -
									   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);



			IF(Par_PagarIVA != SiPagaIVA) THEN
				SET	Var_CantidPagar		:= Var_CantidPagar + Var_IVACantidPagar;
				SET	Var_MontoIVAInt		:= Var_MontoIVAInt + Var_IVACantidPagar;
				SET	Var_IVACantidPagar	:=  Entero_Cero;
			END IF;

		END IF;

        CALL PAGCREINTNOCPRO (
            Var_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,		Var_Poliza,         Var_DivContaIng,	Par_OrigenPago,
            Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,		Pago_CargoCta,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion	);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoCapVencido >= Mon_MinPago) THEN

		IF(ROUND(Var_SaldoPago,2)	>= Var_SaldoCapVencido) THEN
			SET	Var_CantidPagar		:= Var_SaldoCapVencido;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
		END IF;

        CALL PAGCRECAPVENPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
			Par_NumErr,         Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

		IF(IFNULL(Var_LineaCredito,Entero_Cero) != Entero_Cero) THEN
			IF( IFNULL(Var_ManejaLinea,NoManejaLinea) = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
				IF( IFNULL(Var_EsRevolvente,NoEsRevolvente) = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				END IF;
			END IF;
		END IF;

		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

		IF(ROUND(Var_SaldoPago,2)	>= Var_SaldoCapAtrasa) THEN
			SET	Var_CantidPagar		:= Var_SaldoCapAtrasa;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
		END IF;

        CALL PAGCRECAPATRPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,		Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  	Var_CantidPagar,    Decimal_Cero,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      	Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,         	Var_SalCapitales,	Par_OrigenPago,
            Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Pago_CargoCta,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		IF(IFNULL(Var_LineaCredito,Entero_Cero) != Entero_Cero) THEN
			IF( IFNULL(Var_ManejaLinea,NoManejaLinea) = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
				IF( IFNULL(Var_EsRevolvente,NoEsRevolvente) = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				END IF;
			END IF;
		END IF;

		SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

		IF(Var_SaldoPago	>= Var_SaldoCapVigente) THEN
			SET	Var_CantidPagar		:= Var_SaldoCapVigente;
		ELSE
			SET	Var_CantidPagar		:= ROUND(Var_SaldoPago,2);
		END IF;

		CALL PAGCRECAPVIGPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
            Par_NumErr,         Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Pago_CargoCta,
            Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		IF(IFNULL(Var_LineaCredito,Entero_Cero) != Entero_Cero) THEN
			IF( IFNULL(Var_ManejaLinea,NoManejaLinea) = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
				IF( IFNULL(Var_EsRevolvente,NoEsRevolvente) = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + ROUND(Var_CantidPagar,2),
						SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + ROUND(Var_CantidPagar,2) ,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				END IF;
			END IF;
		END IF;


		SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

    SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
    IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

        IF(Var_SaldoPago	>= Var_SaldoCapVenNExi) THEN
            SET	Var_CantidPagar := Var_SaldoCapVenNExi;
        ELSE
            SET	Var_CantidPagar := ROUND(Var_SaldoPago,2);
        END IF;

        CALL PAGCRECAPVNEPRO (
            Var_CreditoID,	    Var_AmortizacionID, Var_FechaInicio,		Var_FechaVencim,    Entero_Cero,
            Var_ClienteID,	    Var_FechaSistema,   Var_FecAplicacion,		Var_CantidPagar,    Decimal_Cero,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,			Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Par_CuentaContable,	Var_Poliza,        	 	Var_SalCapitales,	Par_OrigenPago,
            Par_NumErr,         Par_ErrMen,			Par_Consecutivo,    	Par_EmpresaID,      Pago_CargoCta,
            Aud_Usuario,       Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);


        UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
				AND CreditoID = Par_CreditoID;


		IF(IFNULL(Var_LineaCredito,Entero_Cero) != Entero_Cero) THEN
			IF( IFNULL(Var_ManejaLinea,NoManejaLinea) = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
				IF( IFNULL(Var_EsRevolvente,NoEsRevolvente) = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,

						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE LineaCreditoID	= Var_LineaCredito;
				END IF;
			END IF;
		END IF;


        IF( (Var_SaldoCapVenNExi - Var_CantidPagar) <= Tol_DifPago AND
        	(Var_FechaExigible <= Var_FechaSistema AND Var_AmoEstatus = Esta_Vigente)) THEN

            IF( (Var_EsReestruc   = SI_EsReestruc AND Var_EstCreacion  = Esta_Vencido AND Var_Regularizado = No_Regulariza) OR
            	(Var_EsConsolidacionAgro = Con_SI AND Var_EstatusConsolidacion = Esta_Vencido AND Var_EsRegularizado = No_Regulariza) OR
            	(Var_EsConsolidacion = Con_SI AND Var_EstatusConsolidacion = Esta_Vencido AND Var_EsRegularizado = No_Regulariza)) THEN

                SET Var_NumPagSos := Var_ResPagAct + 1;
                IF( Var_EsConsolidacionAgro = Con_SI ) THEN
                	SET Var_NumPagSos := Var_NumPagosSostenidos + 1;
                END IF;
                IF( Var_EsConsolidacion = Con_SI) THEN
                	SET Var_NumPagSos := Var_NumPagosSostenidos + 1;
                END IF;
                CALL REESTRUCCREDITOACT (
                    Var_FechaSistema,   Var_CreditoID,      Entero_Cero,    	Cadena_Vacia,   	Cadena_Vacia,
                    Entero_Cero,        Entero_Cero,        Var_NumPagSos,  	Var_Poliza,     	Act_PagoSost,
                    Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,  	Pago_CargoCta,
					Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,
					Aud_NumTransaccion  );

			    IF( Par_NumErr <> Entero_Cero ) THEN
        			LEAVE ManejoErrores;
			    END IF;
            END IF;
        END IF;

        SET	Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

		IF(ROUND(Var_SaldoPago,2)	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

	END LOOP CICLO;
END;
CLOSE CURSORAMORTI;

SET Var_SaldoPago   := IFNULL(Var_SaldoPago, Entero_Cero);

IF(Var_SaldoPago < Entero_Cero) THEN
    SET Var_SaldoPago   := Entero_Cero;
END IF;

SET	Var_MontoPago	 := Par_MontoPagar - ROUND(Var_SaldoPago,2);

IF (Var_MontoPago > Decimal_Cero) THEN



	UPDATE AMORTICREDITO Amo SET
		Amo.Estatus		= Esta_Pagado,
		Amo.FechaLiquida	= Var_FechaSistema
		WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi +
			  Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro +
			  Amo.SaldoIntNoConta + Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen +
			  Amo.SaldoComFaltaPa +   Amo.SaldoComServGar + Amo.SaldoOtrasComis ) <= Tol_DifPago
		  AND Amo.CreditoID 	= Par_CreditoID
		  AND Amo.Estatus 	!= Esta_Pagado
		AND Amo.NumTransaccion = Aud_NumTransaccion;


    IF( Par_Finiquito = Finiquito_SI) THEN
        UPDATE AMORTICREDITO Amo SET
            Amo.Estatus		= Esta_Pagado,
            Amo.FechaLiquida	= Var_FechaSistema
            WHERE Amo.CreditoID 	= Par_CreditoID
              AND Amo.Estatus 	!= Esta_Pagado;
    END IF;

    SET Var_NumAmoPag	:=	(SELECT COUNT(AmortizacionID)
								FROM AMORTICREDITO
								WHERE CreditoID	= Par_CreditoID
								  AND Estatus		= Esta_Pagado);

    SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

    IF (Var_NumAmorti = Var_NumAmoPag) THEN
        UPDATE CREDITOS SET
            Estatus			= Esta_Pagado,
            FechTerminacion	= Var_FechaSistema,

            Usuario		= Aud_Usuario,
            FechaActual 	= Aud_FechaActual,
            DireccionIP 	= Aud_DireccionIP,
            ProgramaID  	= Aud_ProgramaID,
            Sucursal		= Aud_Sucursal,
            NumTransaccion	= Aud_NumTransaccion

			WHERE CreditoID = Par_CreditoID;

		SET Var_InverEnGar	:= (SELECT COUNT(CreditoID)
									FROM CREDITOINVGAR
									WHERE CreditoID = Par_CreditoID);
		SET Var_InverEnGar	:= IFNULL(Var_InverEnGar, Entero_Cero);

		IF(Var_InverEnGar >Entero_Cero)THEN
			CALL CREDITOINVGARACT(
				Entero_Cero,		Par_CreditoID,		Entero_Cero,	Var_Poliza,			Act_LiberarPagCre,
				Par_SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
			);
			IF(Par_NumErr <> Entero_Cero)THEN
				SET Par_NumErr		:= 101;
				SET Par_ErrMen		:= Par_ErrMen;
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			ELSE
				SET Par_NumErr		:= 0;
				SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
			END IF;
		END IF;


    ELSEIF (Var_EstatusCre = Esta_Vencido) THEN

        SET Var_NumAmoExi	:=	(SELECT	COUNT(AmortizacionID)
									FROM AMORTICREDITO
									WHERE CreditoID		= Par_CreditoID
									  AND Estatus			!= Esta_Pagado
									  AND FechaExigible	< Var_FechaSistema);

        SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);


        IF (Var_NumAmoExi = Entero_Cero) THEN

            IF ( ( Var_EsReestruc = No_EsReestruc ) OR

                 ( Var_EsReestruc   = SI_EsReestruc AND
                   Var_EstCreacion  = Esta_Vigente) OR

                 ( Var_EsReestruc   = SI_EsReestruc AND
                   Var_EstCreacion  = Esta_Vencido AND
                   Var_Regularizado = Si_Regulariza) OR

                 ( Var_EsConsolidacionAgro = Con_SI AND
                   Var_EstatusConsolidacion = Esta_Vencido AND
                   Var_EsRegularizado = Si_Regulariza) OR

                 ( Var_EsConsolidacion = Con_SI AND
                   Var_EstatusConsolidacion = Esta_Vencido AND
                   Var_EsRegularizado = Si_Regulariza) ) THEN

                CALL REGULARIZACREDPRO (
                    Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,  	Var_Poliza,     Par_EmpresaID,
                    Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Pago_CargoCta,  Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
            END IF;
		END IF;
	END IF;

END IF;



IF(Var_TipoPrepago = Cadena_Vacia) THEN
	SET Var_TipoPrepago := Tip_UltCuo;
END IF;


IF (ROUND(Var_SaldoPago,2) > Decimal_Cero AND Var_TipoPrepago = Tip_UltCuo) THEN

	SET	Var_MonPrePago	:= Entero_Cero;

	CALL `PREPAGCRECONTAULTPRO`(
		Par_CreditoID,	Par_CuentaContable,	Var_SaldoPago,		Par_MonedaID,		Par_EmpresaID,
		Par_PagarIVA,	Var_MontoIVAInt,	Par_SalidaNO,		AltaPoliza_NO,		AltaPoliza_NO,
		Var_MonPrePago,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,			Par_ErrMen,
		Par_Consecutivo,NO_Respaldar,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,Aud_Sucursal,		Aud_NumTransaccion);

	SET	Var_MonPrePago	:= IFNULL(Var_MonPrePago, Entero_Cero);

	SET	Var_MontoPago	 := Var_MontoPago + Var_MonPrePago;


ELSEIF (ROUND(Var_SaldoPago,2) > Decimal_Cero AND Var_TipoPrepago = Tip_SigCuo) THEN

	SET	Var_MonPrePago	:= Entero_Cero;

	CALL `PREPAGCRECONTASIGPRO`(
		Par_CreditoID,	Par_CuentaContable,	Var_SaldoPago,		Par_MonedaID,		Par_EmpresaID,
		Par_PagarIVA,	Var_MontoIVAInt,	Par_SalidaNO,		AltaPoliza_NO,		AltaPoliza_NO,
		Var_MonPrePago,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,			Par_ErrMen,
		Par_Consecutivo,NO_Respaldar,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	SET	Var_MonPrePago	:= IFNULL(Var_MonPrePago, Entero_Cero);

	SET	Var_MontoPago	 := Var_MontoPago + Var_MonPrePago;


ELSEIF (ROUND(Var_SaldoPago,2) > Decimal_Cero AND Var_TipoPrepago = Tip_Prorrateo) THEN

	SET	Var_MonPrePago	:= Entero_Cero;

	CALL `PREPAGCRECONTAVIGPRO`(
		Par_CreditoID,	Par_CuentaContable,	Var_SaldoPago,		Par_MonedaID,		Par_EmpresaID,
		Par_PagarIVA,	Var_MontoIVAInt,	Par_SalidaNO,		AltaPoliza_NO,		AltaPoliza_NO,
		Var_MonPrePago,	Var_Poliza,			Par_OrigenPago,		Par_NumErr,			Par_ErrMen,
		Par_Consecutivo,NO_Respaldar,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	SET	Var_MonPrePago	:= IFNULL(Var_MonPrePago, Entero_Cero);

	SET	Var_MontoPago	 := Var_MontoPago + Var_MonPrePago;

END IF;


CALL RESPAGCREDITOALT(
	Aud_NumTransaccion,	Entero_Cero,		Par_CreditoID,		Var_MontoPago,		Par_NumErr,
	Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


IF(Var_MontoPago > Entero_Cero) THEN
	SET	Des_PagoCred	:= 'PAGO DE CREDITO CON CUENTA CONTABLE';

	SET	Par_CenCosto	:= IFNULL(Par_CenCosto, Aud_Sucursal);

	CALL `DETALLEPOLIZAALT`(
		Par_EmpresaID,		Var_Poliza,			Var_FecAplicacion,	Par_CenCosto,	Par_CuentaContable,
		Var_CreditoStr,		Par_MonedaID,		Var_MontoPago,		Entero_Cero,	Des_PagoCred,
		Var_CreditoStr,		Aud_ProgramaID,		Ins_Credito,		Cadena_Vacia,	Decimal_Cero,
		Cadena_Vacia,		Par_SalidaNO,		Par_NumErr,			Par_ErrMen,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
END IF;

SET Par_NumErr		:= 0;
SET Par_ErrMen		:= 'Pago Aplicado Exitosamente.';
SET Par_Consecutivo	:= Entero_Cero;

END ManejoErrores;

 IF (Par_Salida = Par_SalidaSI) THEN
	SELECT 	CONVERT(Par_NumErr, CHAR) AS NumErr,
		Par_ErrMen AS ErrMen,
		'creditoID' AS control,
		Entero_Cero AS consecutivo;
END IF;


END TerminaStore$$