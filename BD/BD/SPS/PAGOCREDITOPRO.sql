-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOPRO`(
	-- SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO
	Par_CreditoID			BIGINT(12),
	Par_CuentaAhoID			BIGINT(12),
	Par_MontoPagar			DECIMAL(12,2),
	Par_MonedaID			INT(11),
	Par_EsPrePago			CHAR(1),

	Par_Finiquito			CHAR(1),
	Par_EmpresaID			INT(11),
	Par_Salida				CHAR(1),
	Par_AltaEncPoliza		CHAR(1),
	INOUT Var_MontoPago		DECIMAL(12,2),

	INOUT Var_Poliza		BIGINT,
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo 	BIGINT,
	Par_ModoPago			CHAR(1),

	Par_Origen				CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService,
											-- O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
											-- A: Aplicacion de Garantias Agropecuaria
	Par_RespaldaCred		CHAR(1),		-- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)
	-- Parametros de Auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_ProgOriginalID  VARCHAR(50);
DECLARE ConcepCtaOrdenDeu INT;
DECLARE ConcepCtaOrdenCor INT;
DECLARE Var_CreditoID     BIGINT(12);
DECLARE Var_AmortizacionID  INT(4);
DECLARE Var_SaldoCapVigente DECIMAL(12, 2);
DECLARE Var_SaldoCapAtrasa  DECIMAL(12, 2);
DECLARE Var_SaldoCapVencido DECIMAL(12, 2);
DECLARE Var_SaldoCapVenNExi DECIMAL(12, 2);
DECLARE Var_SaldoInteresOrd DECIMAL(12, 4);
DECLARE Var_SaldoInteresAtr DECIMAL(12, 4);
DECLARE Var_SaldoInteresVen DECIMAL(12, 4);
DECLARE Var_SaldoInteresPro DECIMAL(12, 4);
DECLARE Var_SaldoIntNoConta DECIMAL(12, 4);
DECLARE Var_SaldoMoratorios DECIMAL(12, 2);
DECLARE Var_SaldoMoraVenci  DECIMAL(12, 2);
DECLARE Var_SaldoMoraCarVen DECIMAL(12, 2);
DECLARE Var_SaldoSeguroCuota DECIMAL(12, 2);          -- Monto del seguro por cuota
DECLARE Var_SaldoComFaltaPa DECIMAL(12, 2);
DECLARE Var_SaldoOtrasComis DECIMAL(12, 2);
DECLARE Var_SaldoComServGar DECIMAL(12, 2);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_MonedaID        INT;
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);
DECLARE Var_EsGrupal        CHAR(1);
DECLARE Var_SolCreditoID    BIGINT;
DECLARE Var_GrupoID         INT;
DECLARE Var_CicloGrupo      INT;
DECLARE Var_CicloActual     INT;
DECLARE Var_GrupoCtaID      INT;
DECLARE Var_SaldoPago       DECIMAL(14, 4);
DECLARE Var_CantidPagar     DECIMAL(14, 4);
DECLARE Var_IVACantidPagar  DECIMAL(16, 2);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecAplicacion   DATE;
DECLARE Var_EsHabil     CHAR(1);
DECLARE Var_IVASucurs       DECIMAL(8, 4);
DECLARE Var_SucCliente      INT;
DECLARE Var_ClienteID   BIGINT;
DECLARE Var_ProdCreID   INT;
DECLARE Var_ClasifCre   CHAR(1);
DECLARE Var_CuentaAhoStr  VARCHAR(20);
DECLARE Var_CreditoStr    VARCHAR(20);
DECLARE Var_NumAmorti   INT;
DECLARE Var_NumAmoPag   INT;
DECLARE Var_NumAmoExi   INT;
DECLARE Var_CueClienteID  BIGINT;
DECLARE Var_Cue_Saldo   DECIMAL(12,2);
DECLARE Var_CueMoneda   INT;
DECLARE Var_CueEstatus    CHAR(1);
DECLARE Var_MontoDeuda    DECIMAL(14,2);
DECLARE Var_CliPagIVA   CHAR(1);
DECLARE Var_IVAIntOrd   CHAR(1);
DECLARE Var_IVAIntMor   CHAR(1);
DECLARE Var_ValIVAIntOr   DECIMAL(12,2);
DECLARE Var_ValIVAIntMo   DECIMAL(12,2);
DECLARE Var_ValIVAGen   DECIMAL(12,2);
DECLARE Var_EsReestruc    CHAR(1);
DECLARE Var_EstCreacion   CHAR(1);
DECLARE Var_Regularizado  CHAR(1);
DECLARE Var_ResPagAct       INT;
DECLARE Var_NumPagSos       INT;
DECLARE Var_ProxAmorti      INT;
DECLARE Var_DiasAntici      INT;
DECLARE Var_IntAntici       DECIMAL(14,4);
DECLARE Var_ProyInPagAde    CHAR(1);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_CobraSeguroCuota  CHAR(1);
DECLARE Var_CobraIVASeguroCuota CHAR(1);
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_DiasCredito     INT;
DECLARE Mov_AboConta        INT;
DECLARE Mov_CarConta        INT;
DECLARE Mov_CarOpera        INT;
DECLARE Var_Frecuencia      CHAR(1);
DECLARE Var_DiasPermPagAnt  INT;
DECLARE Var_ComAntici       DECIMAL(14,4);      -- Para el Control de la Liquidacion Anticipada o Finiquito
DECLARE Var_IVAComAntici    DECIMAL(14,2);      -- Para el Control de la Liquidacion Anticipada o Finiquito,
DECLARE Var_PermiteLiqAnt   CHAR(1);
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
DECLARE Var_ManejaLinea   CHAR(1);      -- variable para guardar el valor de si o no maneja linea el producto de credito
DECLARE Var_EsRevolvente  CHAR(1);       -- Variable para saber si es revolvente la linea
DECLARE Var_LineaCredito	BIGINT(20);   -- Variable para guardar la linea de credito
DECLARE Var_DivContaIng   CHAR(1);
DECLARE Var_InverEnGar      INT;
DECLARE Var_ProdUsaGarLiq   CHAR(1);
DECLARE Var_LiberaAlLiquidar  CHAR(1);
DECLARE Var_PagoAdeSinProy  CHAR(1);
DECLARE Var_CalInteresID    INT;
DECLARE Var_ProvisionAcum   DECIMAL(14,4);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_TotCapital      DECIMAL(14,2);
DECLARE Var_Dias            INT;
DECLARE Var_DiasAmor    INT;
DECLARE Var_Control     VARCHAR(100);
DECLARE Var_NumRecPago    INT;
/*COMISION ANUAL*/
DECLARE Var_CobraComAnual CHAR(1);
DECLARE Var_SaldoComAnual DECIMAL(14,2);
/*FIN COMISION ANUAL*/
DECLARE Var_TipoLiquidacion CHAR(1);
DECLARE Var_LiquidaCred   CHAR(1);

DECLARE Var_MontoComAp      DECIMAL(12,2);  -- Monto de la Comision por Apertura
DECLARE Var_IVAComAp        DECIMAL(12,2);  -- Monto del IVA de la Comision por Apertura
DECLARE Var_MontoCont   DECIMAL(14,2);    	-- Monto Comision Contabilizado
DECLARE Var_MontoIVACont  DECIMAL(14,2);    -- Monto del IVA de la Comision por Apertura Contabilizado
DECLARE Var_MontoAmort    DECIMAL(14,2);    -- Monto de la Comision a contabilizar
DECLARE Var_MontoIVAAmort DECIMAL(14,2);    -- Monto IVA de la Comision a contabilizar
DECLARE Var_MontoSeguro   DECIMAL(14,2);
DECLARE Var_MontoSeguroOp DECIMAL(14,2);    -- Monto del Seguro Operativo
DECLARE Var_MontoSeguroCont DECIMAL(14,2);    -- Monto del Seguro Contable
DECLARE Var_MontoIVASeguroOp  DECIMAL(14,2);  -- Monto del IVA del Seguro Operativo
DECLARE Var_MontoIVASeguroCont  DECIMAL(14,2);  -- Monto del IVA del Seguro Contable

DECLARE Var_NumeroAmort     INT(11);      -- Numero de Amortizaciones
DECLARE Saldo_CapAtrasado     DECIMAL(14,2);    -- Saldo de Capital Atrasado
DECLARE Saldo_IntAtrasado   DECIMAL(14,2);    -- Saldo de Interes Atrasado
DECLARE Var_FechaMinAtraso    DATE;       -- Fecha de Atraso de la primera amortizacion que se encuentre atrasada
DECLARE Var_AmortizacionIDAtr INT(11);      -- Amortizacion ID
DECLARE Var_MontoCredito    DECIMAL(14,2);    -- Monto Original del Credito
DECLARE Var_PorcMontoCred   DECIMAL(14,2);    -- Monto correspondiente al 20% del Monto Original del Credito
DECLARE Var_MontoPagado     DECIMAL(14,2);    -- Monto pagado del Credito
DECLARE Var_CapitalVigente    DECIMAL(14,2);    -- Saldo Capital Vigente
DECLARE Var_Refinancia      CHAR(1);      -- Refinancia Intereses
DECLARE Var_PagoXReferencia   CHAR(1);
DECLARE Var_ReferenciaPago    VARCHAR(20);
DECLARE Var_CobraAccesorios   CHAR(1);      -- Indica si la solicitud cobra accesorios
DECLARE Var_CobraAccesoriosGen  CHAR(1);      -- Valor del Cobro de Accesorios

DECLARE Var_CobraComAnualLin  CHAR(1);    -- Indica si cobra comisión anual de linea de crédito
DECLARE Var_TipoComAnualLin   CHAR(1);  -- Indica el tipo de comisión anual de la linea de crédito
DECLARE Var_ValorComAnualLin  DECIMAL(14,2);    -- Indica el valor de la comsión anual de la linea
DECLARE Var_ComAnualCobradaLin  CHAR(1);    -- Indica si la comisión anual de la linea ya fue cobrada
DECLARE Var_SaldoLinea      DECIMAL(14,2);  -- Indica el saldo pendiende la comisón anual de la linea
DECLARE Var_MontoComAnual   DECIMAL(14,2);  -- Indica el monto a pagar de la comisión anual de la linea
DECLARE Var_MontoIVAComAnual  DECIMAL(14,2);    -- Indica el monto de iva a pagar de la comisión anual de la linea
DECLARE Var_SaldoComAnualLin  DECIMAL(14,2);    -- Indida el saldo total pagado de la comisión anual de la linea
DECLARE Var_ProrrateaPago   CHAR(1);
DECLARE Var_CobraGarantiaFinanciada CHAR(1);

DECLARE Var_ReqGarLiq       CHAR(1);
DECLARE Var_BonoGarLiq      CHAR(1);
DECLARE Var_ReqFOGAFI       CHAR(1);
DECLARE Var_BonoFOGAFI      CHAR(1);
DECLARE Var_LiberaGarFOGAFI   CHAR(1);
DECLARE Var_IntCtaOrden     DECIMAL(14,4);
DECLARE Var_CapCtaOrden     DECIMAL(14,4);
DECLARE Var_CantAmoVenSusp  INT(11);          -- Cantidad de amortizaciones Vencidas solo para creditos suspendidos.
DECLARE Var_PagoPerdCentRedond			CHAR(1);
DECLARE Var_PagoMontoMaxPerd			DECIMAL(16,2);
DECLARE Var_CuentaContablePerd			VARCHAR(29);
DECLARE Var_SaldoPerdida				DECIMAL(16,2);
DECLARE Var_FechaActPago				DATETIME;
DECLARE Var_DifDiasPago					INT;

DECLARE Var_SaldoNotCargoRev		DECIMAL(14,2);		-- Variable por notas de cargo
DECLARE Var_SaldoNotCargoSinIVA		DECIMAL(14,2);		-- Variable por notas de cargo
DECLARE Var_SaldoNotCargoConIVA		DECIMAL(14,2);		-- Variable por notas de cargo
DECLARE Var_MontoNotaCargo			DECIMAL(14,2);		-- Variable para la suma total por nota de cargo
DECLARE Var_IVANotaCargo			DECIMAL(12,2);		-- Variable para el porcentaje de iva de nota cargo
DECLARE Var_EsConsolidacion			CHAR(1);			-- Variable para saber si el credito es consolidado

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Cons_No     CHAR(1);
DECLARE Cons_Si     CHAR(1);
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
DECLARE Var_AltaPoliza  CHAR(1);
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
DECLARE NO_ProyectInt   CHAR(1);
DECLARE Mov_IntPro      INT;
DECLARE Con_IntDeven    INT;
DECLARE Con_IngreInt    INT;
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE SiPagaIVA       CHAR(1);
DECLARE Coc_PagoCred    INT;
DECLARE Aho_PagoCred    CHAR(4);
DECLARE Con_AhoCapital  INT;
DECLARE Mov_CapVigente    INT;
DECLARE Mov_CapAtrasado   INT;
DECLARE Mov_CapVencido    INT;
DECLARE Mov_CapVencidoNE  INT;
DECLARE Mov_IntOrdinario    INT;
DECLARE Mov_IntAtrasado   INT;
DECLARE Mov_IntVencido    INT;
DECLARE Mov_IntNoContab   INT;
DECLARE Mov_IntProvision  INT;
DECLARE Mov_Moratorio   INT;
DECLARE Mov_ComFalPag   INT;
DECLARE Mov_IVAInteres    INT;
DECLARE Mov_IVAIntMora    INT;
DECLARE Mov_IVAComFaPag   INT;
DECLARE Mov_ComLiqAnt       INT;
DECLARE Mov_IVAComLiqAnt    INT;
DECLARE Con_CapVigente    INT;
DECLARE Con_CapAtrasado   INT;
DECLARE Con_CapVencido    INT;
DECLARE Con_CapVencidoNE  INT;
DECLARE Con_IngInteres    INT;
DECLARE Con_IngIntMora    INT;
DECLARE Con_IngFalPag   INT;
DECLARE Con_IVAInteres    INT;
DECLARE Con_IVAMora     INT;
DECLARE Con_IVAFalPag   INT;
DECLARE Con_CtaOrdInt   INT;
DECLARE Con_CorIntDev   INT;
DECLARE Con_CtaOrdMor   INT;
DECLARE Con_CorIntMor   INT;
DECLARE Con_CtaOrdCom   INT;
DECLARE Con_CorComFal   INT;
DECLARE Con_IntAtrasado   INT;
DECLARE Con_IntVencido    INT;
DECLARE Con_ComFiniqui    INT;
DECLARE Con_IVAComFin   INT;
DECLARE Tol_DifPago     DECIMAL(10,4);
DECLARE Des_PagoCred    VARCHAR(50);
DECLARE Con_PagoCred    VARCHAR(50);
DECLARE Ref_PagAnti     VARCHAR(50);
DECLARE No_EsReestruc   CHAR(1);
DECLARE Si_EsReestruc   CHAR(1);
DECLARE Si_Regulariza   CHAR(1);
DECLARE No_Regulariza   CHAR(1);
DECLARE Si_EsGrupal     CHAR(1);
DECLARE NO_EsGrupal     CHAR(1);
DECLARE SI_PermiteLiqAnt  CHAR(1);
DECLARE SI_CobraLiqAnt    CHAR(1);
DECLARE Cob_FalPagCuota   CHAR(1);
DECLARE Cob_FalPagFinal   CHAR(1);
DECLARE SiManejaLinea   CHAR(1);    -- Si maneja linea
DECLARE NoManejaLinea   CHAR(1);    -- NO maneja linea
DECLARE SiEsRevolvente    CHAR(1);  -- Si Es Revolvente
DECLARE NoEsRevolvente    CHAR(1);  -- NO Es Revolvente
DECLARE Act_PagoSost    INT;
DECLARE Proyeccion_Int    CHAR(1);
DECLARE Monto_Fijo        CHAR(1);
DECLARE Por_Porcentaje    CHAR(1);
DECLARE Mon_MinPago       DECIMAL(12,2);
DECLARE Int_NumErr        INT;
DECLARE Act_LiberarPagCre INT;
DECLARE ValorSI       CHAR(1);
DECLARE ValorNO       CHAR(1);
DECLARE VarSucursalLin      INT;        -- Variables para el CURSOR
DECLARE MonedaLinea         INT(11);
DECLARE Tasa_Fija         INT;
DECLARE EstatusDesembolso CHAR(1);
DECLARE DiasRegula      INT;
DECLARE Prog_Reestructura   VARCHAR(50);
DECLARE TipoActInteres    INT(11);
DECLARE SiCobSeguroCuota  CHAR(1);
DECLARE SiCobIVASeguroCuota CHAR(1);
DECLARE LiquidacionTotal  CHAR(1);
DECLARE LiquidacionParcial  CHAR(1);
DECLARE Var_DescComAper   VARCHAR(100); -- Descripcion: Comision por Apertura
DECLARE Var_DcIVAComApe     VARCHAR(100); -- Descripcion: IVA Comision por Apertura
DECLARE Con_ContComApe      INT(11);    -- Concepto Cartera: Comision por Apertura
DECLARE Con_ContIVACApe     INT(11);    -- Concepto Cartera: IVA Comision por Apertura
DECLARE Con_ContGastos      INT(11);    -- Concento Cartera: Cuenta Puente para la Comision por Apertura
DECLARE Con_OrigenWS      CHAR(1);
DECLARE Frec_Unico        CHAR(1);
DECLARE FechaReal       CHAR(1);
DECLARE EsAutomatico      CHAR(1);
DECLARE Llave_CobraAccesorios VARCHAR(100);     -- Llave para consulta el valor de Cobro de Accesorios
DECLARE ConstDescipLinea    VARCHAR(500);     -- Descripción para los movimientos de linea de crédito
DECLARE NO_Prorratea      CHAR(1);
DECLARE Var_CicloGpoActual    INT(11);

DECLARE Con_ContComAnual    INT(11);  -- Constante del Movimiento Contable de la Comisión anual de la linea de crédito
DECLARE Con_ContIVAComAnual   INT(11);  -- Constante del Movimiento contable del IVA de la comisión anual de la linea
DECLARE TipoMovAhoComAnual    VARCHAR(4); -- Constante del movimiento de ahorro de la comisión anual de la linea
DECLARE TipoMovAhoIVAComAnual   VARCHAR(4);   -- Constante del movimieinto de ahorro del iva por la comisión anual de la linea
DECLARE IntActivo     CHAR(1);
DECLARE Var_ClienteEspecifico INT(11);  -- Numero de Cliente especifico
DECLARE Var_ClienteConsol     INT(11);  -- Numero de Cliente especifico Consol

DECLARE Estatus_Suspendido 			CHAR(1);	-- Estatus Suspendido
DECLARE Est_Autorizado 				CHAR(1);	-- Es Credito Consolidado
DECLARE Var_OrigenPago     			CHAR(1);	-- Origen de Proceso 'P' Pago de Cuotas
DECLARE Var_EsConsolidacionAgro 	CHAR(1);	-- Es Credito Consolidado
DECLARE Var_EstatusConsolidacion 	CHAR(1);	-- Estatus del credito al momento de la consolidacion
DECLARE Var_EsRegularizado 			CHAR(1);	-- Si la conlidacion es Regularizada
DECLARE Var_NumPagosSostenidos		INT(11);	-- Numero de Pagos Sostenidos
DECLARE Var_SolicitudConsolida		BIGINT(20);	-- Solicitud de Consolidacion
DECLARE Var_CreditoConsolida		BIGINT(12);	-- credito de Consolidacion


DECLARE Var_EjecucionCobAut       VARCHAR(200);   -- Variable para almacenar el valor del campo EjecucionCobAut
DECLARE Var_EjecucionCobAutRef    VARCHAR(200);   -- Variable para almacenar el valor del campo EjecucionCobAutRef
DECLARE Llave_EjecucionCobAut     VARCHAR(50);    -- Llave EjecucionCobAut
DECLARE Llave_EjecucionCobAutRef  VARCHAR(50);    -- Llave EjecucionCobAutRef
DECLARE Con_NO                    CHAR(1);        -- Constante NO
DECLARE Con_SI                    CHAR(1);        -- Constante SI
DECLARE Salida_NO                 CHAR(1);          -- Constante Salida NO
DECLARE Inst_Credito              TINYINT UNSIGNED; -- Proceso de Credito
DECLARE Var_OperacionPeticionID   TINYINT UNSIGNED; -- Proceso de Notificacion de Saldo
DECLARE Pro_CobranzaAutomatica    TINYINT UNSIGNED; -- Proceso de Cobranza Automatica
DECLARE Pro_CobranzaAutomaticaRef TINYINT UNSIGNED; -- Proceso de Cobranza Automatica Referenciada

DECLARE Con_SPEI                  CHAR(1);
DECLARE Con_Ventanilla            CHAR(1);
DECLARE Con_CargoCta              CHAR(1);				-- Constante Origen de Pago con Cargo a Cuenta
DECLARE Con_Automatica            CHAR(1);
DECLARE Con_OrigenNomina          CHAR(1);          -- Constante Origen Nomina
DECLARE OrigMinistraCrePro        VARCHAR(20);

DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);	-- Es Linea de Credito Agro Revolvente
DECLARE Var_EsLineaCreditoAgro 				CHAR(1);	-- Es linea de Credito Agro
DECLARE Var_PagoLineaCredito				CHAR(1);	-- Origen del pago de una linea de credito
DECLARE Con_PagoApliGarAgro					CHAR(1);	-- Constante Origen de Pago de Aplicacion por Garantias Agro (A)
DECLARE Var_MontoComServGar					DECIMAL(14,2);	-- Monto Comision por Servicio de Garantia Agro
DECLARE Var_MontoIvaComServGar				DECIMAL(14,2);	-- Monto Iva Comision por Servicio de Garantia Agro
DECLARE TipoOperPLDCredito   	  INT(11); 		-- Tipo de operacion 1 = Abonos y cargos cuenta,2= Pago de credito
DECLARE Con_CarCtaOrdenDeuAgro			INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
DECLARE Con_CarCtaOrdenCorAgro			INT(11);		-- Concepto Cuenta Ordenante Corte Agro
DECLARE Var_CargosPoliza		DECIMAL(14,4);		-- Variable para almacenar los Cargos de la Poliza
DECLARE Var_AbonosPoliza		DECIMAL(14,4);		-- Variable para almacenar los Abonos de la Poliza
DECLARE LimiteDifPoliza			DECIMAL(12,2);		-- Monto Limite de Diferencia
DECLARE Con_OrigenDepRef		CHAR(1);			-- Origen pago deposito referenciado

-- DECLARACION DE CURSORES
DECLARE CURSORAMORTI CURSOR FOR
	SELECT  Amo.CreditoID,				Amo.AmortizacionID,			Amo.SaldoCapVigente,		Amo.SaldoCapAtrasa,		Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi,		Amo.SaldoInteresOrd,		Amo.SaldoInteresAtr,		Amo.SaldoInteresVen,	Amo.SaldoInteresPro,
			Amo.SaldoIntNoConta,		Amo.SaldoMoratorios,		Amo.SaldoComFaltaPa,		Amo.SaldoOtrasComis,	Cre.MonedaID,
			Amo.FechaInicio,			Amo.FechaVencim,			Amo.FechaExigible,			Amo.Estatus,			Amo.SaldoMoraVencido,
			Amo.SaldoMoraCarVen,		Amo.SaldoSeguroCuota,		Cre.CobraComAnual,			Amo.SaldoComisionAnual,	Amo.SaldoNotCargoRev,
			Amo.SaldoNotCargoSinIVA,	Amo.SaldoNotCargoConIVA,	Amo.SaldoComServGar
	FROM AMORTICREDITO Amo
	INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
	WHERE Cre.CreditoID = Par_CreditoID
	  AND Cre.Estatus IN (Esta_Vigente, Esta_Vencido,Estatus_Suspendido)
	  AND Amo.Estatus IN (Esta_Vigente, Esta_Vencido, Esta_Atrasado)
	ORDER BY FechaExigible;

-- CURSOR Para Pagar al Final del Pago Ordinario, La Comision por Falta de Pago
DECLARE CURSORCOMFALPAG CURSOR FOR
  SELECT  Amo.CreditoID,    Amo.AmortizacionID,   Amo.SaldoComFaltaPa,  Cre.MonedaID, Amo.FechaInicio,
      Amo.FechaVencim,  Amo.FechaExigible,    Amo.Estatus
    FROM  AMORTICREDITO Amo,
        CREDITOS    Cre
    WHERE Amo.CreditoID   = Cre.CreditoID
      AND Cre.CreditoID = Par_CreditoID
      AND (Cre.Estatus  = Esta_Vigente
       OR   Cre.Estatus = Esta_Vencido
       OR   Cre.Estatus = Estatus_Suspendido)
      AND (Amo.Estatus  = Esta_Vigente
      OR    Amo.Estatus = Esta_Vencido
      OR    Amo.Estatus = Esta_Atrasado)
    AND Amo.SaldoComFaltaPa > Entero_Cero
    ORDER BY FechaExigible;

-- Asignacion de Constantes
SET Cadena_Vacia    := '';              -- String Vacio
SET Cons_No       := 'N';               -- Constante No
SET Cons_Si       := 'S';               -- Constante SI
SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero     := 0;               -- Entero en Cero
SET Decimal_Cero    := 0.00;            -- DECIMAL Cero
SET Decimal_Cien    := 100.00;          -- DECIMAL en Cien

SET Esta_Activo     := 'A';             -- Estatus Activo
SET Esta_Cancelado  := 'C';             -- Estatus Cancelado
SET Esta_Inactivo   := 'I';             -- Estatus Inactivo
SET Esta_Vencido    := 'B';             -- Estatus Vencido
SET Esta_Vigente    := 'V';             -- Estatus Vigente
SET Esta_Pagado     := 'P';             -- Estatus Pagado
SET Esta_Atrasado   := 'A';             -- Estatus Atrasado

SET Aho_PagoCred    := '101';           -- Concepto de Ahorro: Pago de Credito
SET Con_AhoCapital  := 1;               -- Concepto Contable de Ahorro: Pasivo

SET Par_SalidaNO    := 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
SET Par_SalidaSI    := 'S';             -- Ejecutar Store Con Regreso o Mensaje de Salida
SET SiManejaLinea := 'S';             	-- Si maneja linea
SET NoManejaLinea := 'N';             	-- No maneja linea
SET SiEsRevolvente  := 'S';             -- Si Es Revolvente
SET NoEsRevolvente  := 'N';             -- No Es Revolvente

SET PrePago_SI      := 'S';             -- SI es un PrePago
SET PrePago_NO      := 'N';             -- NO es un PrePago
SET Finiquito_SI    := 'S';             -- SI es un Finiquito o Liquidacion Total Anticipada
SET Finiquito_NO    := 'N';             -- NO es un Finiquito o Liquidacion Total Anticipada
SET SI_ProyectInt   := 'S';             -- El Producto de Credito si Proyecta Interes
SET NO_ProyectInt   := 'N';             -- El Producto de Credito si Proyecta Interes
SET Mov_IntPro      := 14;              -- Tipo de Movimiento de Credito: Interes Provisionado
SET Con_IntDeven    := 19;              -- Concepto Contable Interes Devengado
SET Con_IngreInt    := 5;               -- Concepto Contable Ingreso por Interes
SET AltaPoliza_SI   := 'S';             -- Alta de la Poliza Contable: SI
SET AltaPoliza_NO   := 'N';             -- Alta de la Poliza Contable: NO
SET AltaPolCre_SI   := 'S';             -- Alta de la Poliza Contable de Credito: SI
SET AltaPolCre_NO   := 'N';             -- Alta de la Poliza Contable de Credito: NO
SET AltaMovCre_NO   := 'N';             -- Alta de los Movimientos de Credito: NO
SET AltaMovCre_SI   := 'S';             -- Alta de los Movimientos de Credito: SI
SET AltaMovAho_NO   := 'N';             -- Alta de los Movimientos de Ahorro: NO
SET AltaMovAho_SI   := 'S';             -- Alta de los Movimientos de Ahorro: SI.

SET Nat_Cargo       := 'C';             -- Naturaleza de Cargo
SET Nat_Abono       := 'A';             -- Naturaleza de Abono.
SET Pol_Automatica  := 'A';             -- Tipo de Poliza: Automatica
SET SiPagaIVA       := 'S';             -- El Cliente si Paga IVA
SET Coc_PagoCred    := 54;              -- Concepto Contable de Cartera: Pago de Credito
SET SiCobSeguroCuota  := 'S';
SET SiCobIVASeguroCuota := 'S';

SET Mov_CapVigente    := 1;
SET Mov_CapAtrasado   := 2;
SET Mov_CapVencido    := 3;
SET Mov_CapVencidoNE    := 4;
SET Mov_IntOrdinario    := 10;
SET Mov_IntAtrasado   := 11;
SET Mov_IntVencido    := 12;
SET Mov_IntNoContab   := 13;
SET Mov_IntProvision    := 14;
SET Mov_Moratorio     := 15;
SET Mov_ComFalPag     := 40;
SET Mov_IVAInteres    := 20;
SET Mov_IVAIntMora    := 21;
SET Mov_IVAComFaPag   := 22;
SET Mov_ComLiqAnt     := 42;          -- Comision por Administracion: Liquidacion Anticipada
SET Mov_IVAComLiqAnt    := 24;        -- IVA Comision por Administracion: Liquidacion Anticipada

SET Con_CapVigente    := 1;           -- Concepto Contable de Credito: Capital Vigente (CONCEPTOSCARTERA)
SET Con_CapAtrasado   := 2;           -- Concepto Contable de Credito: Atrasado (CONCEPTOSCARTERA)
SET Con_CapVencido    := 3;           -- Concepto Contable de Credito: Capital Vencido (CONCEPTOSCARTERA)
SET Con_CapVencidoNE    := 4;         -- Concepto Contable de Credito: Capital Vencido no Exigible
SET Con_IngInteres    := 5;           -- Concepto Contable de Credito: Ingreso por Interes
SET Con_IngIntMora    := 6;           -- Concepto Contable de Credito: Ingreso por Moratorios
SET Con_IngFalPag     := 7;           -- Concepto Contable de Credito: Ingreso Comision Falta de Pago
SET Con_IVAInteres    := 8;           -- Concepto Contable de Credito: IVA de Interes
SET Con_IVAMora       := 9;           -- Concepto Contable de Credito: IVA Moratorios
SET Con_IVAFalPag     := 10;          -- Concepto Contable de Credito: IVA Falta de Pago
SET Con_CtaOrdInt     := 11;          -- Concepto Contable de Credito: Cta de Orden de Interes
SET Con_CorIntDev     := 12;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Interes
SET Con_CtaOrdMor     := 13;          -- Concepto Contable de Credito: Cta de Orden de Moratorios
SET Con_CorIntMor     := 14;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Moratorios
SET Con_CtaOrdCom     := 15;          -- Concepto Contable de Credito: Cta de Orden de Com Falta de Pago
SET Con_CorComFal     := 16;          -- Concepto Contable de Credito: Correlativa Cta de Orden de Com Falta de Pago
SET Con_IntAtrasado   := 20;          -- Concepto Contable de Credito: Interes Atrasado
SET Con_IntVencido    := 21;          -- Concepto Contable de Credito: Interes Vencido
SET Con_ComFiniqui    := 27;          -- Concepto Contable de Cartera: Comision por Finiquito
SET Con_IVAComFin     := 28;          -- Concepto Contable de Cartera: IVA Comision por Finiquito
SET Con_ContComAnual  := 100;     -- Concepto Contable de Cartera: Comisión Anual
SET Con_ContIVAComAnual := 101;     -- Concepto Contable de Cartera: IVA Comisión Anual
SET Tol_DifPago       := 0.05;

SET No_EsReestruc     := 'N';
SET Si_EsReestruc     := 'S';
SET Si_Regulariza     := 'S';
SET No_Regulariza     := 'N';
SET Si_EsGrupal       := 'S';
SET NO_EsGrupal       := 'N';
SET SI_PermiteLiqAnt    := 'S';         -- El Producto Si Permite Liquidacion Anticipada
SET SI_CobraLiqAnt      := 'S';         -- El Producto Si Cobra Comision por Liquidacion Anticipada
SET Cob_FalPagCuota     := 'C';         -- Cobro de la Comision en Cada Cuota (Tradicional)
SET Cob_FalPagFinal     := 'F';         -- Cobro de la Comision al Final de la Prelacion
SET Proyeccion_Int      := 'P';     -- Tipo de Comision por Finiquito: Proyeccion de Interes
SET Monto_Fijo          := 'M';     -- Tipo de Comision por Finiquito: Monto Fijo
SET Por_Porcentaje      := 'S';     -- Tipo de Comision Porcentaje del Sald Insoluto

SET Act_PagoSost      := 2;
SET Act_LiberarPagCre := 3;
SET Mon_MinPago       := 0.01;
SET TipoActInteres    := 1;     -- Tipo de Actualizacion (intereses)
SET Ref_PagAnti       := 'PAGO ANTICIPADO';
SET Des_PagoCred      := 'PAGO DE CREDITO';
SET Con_PagoCred      := 'PAGO DE CREDITO';
SET Aud_ProgramaID    := 'PAGOCREDITOPRO';
SET ValorSI       :='S';
SET ValorNO       :='N';
SET Tasa_Fija         := 1;
SET ConcepCtaOrdenDeu := 53;      -- Linea Credito Cta. Orden
SET ConcepCtaOrdenCor := 54;      -- Linea Credito Corr. Cta Orden
SET EstatusDesembolso := 'D';     -- Estatus desembolsada de una reestructura-renovacion
SET DiasRegula      := 60;
SET Prog_Reestructura :='REESTRUCCREDITOALT';
SET Var_NumRecPago    := 0;
SET Var_Control     := 'creditoID';
SET Var_ProgOriginalID  := Aud_ProgramaID;
SET LiquidacionTotal  := 'T';
SET LiquidacionParcial  := 'P';
SET Var_DescComAper   := 'COMISION POR APERTURA';
SET Var_DcIVAComApe   := 'IVA COMISION POR APERTURA';
SET Con_ContComApe    := 22;        -- CONCEPTOSCARTERA: 22 Comision por Apertura
SET Con_ContIVACApe   := 23;        -- CONCEPTOSCARTERA: 23 IVA Comision por Apertura
SET Con_ContGastos    := 58;        -- Cuenta Puente para la Comision por Apertura
SET Con_OrigenWS    := 'W';
SET Var_EsHabil     := 'S';
SET Frec_Unico      := 'U';     -- Frecuencia Unica
SET FechaReal     := 'R';     -- Recalcular intereses a la fecha REAL
SET EsAutomatico    := 'A';     -- El pago proviene de la cobranza automatica
SET Llave_CobraAccesorios := 'CobraAccesorios';
SET TipoMovAhoComAnual  := '208'; -- Tipo Movimiento Ahorro Comisión Anual
SET TipoMovAhoIVAComAnual := '209'; -- Tipo Movimiento Ahorro IVA Comisión Anual
SET NO_Prorratea    := 'N';
SET IntActivo     := 'A';
SET Var_ClienteConsol := 10;

SET Est_Autorizado		:= 'A';
SET Estatus_Suspendido		:= 'S';			-- Estatus Suspendido
SET Var_OrigenPago        := 'P';

SET Con_NO                    := 'N';
SET Con_SI                    := 'S';
SET Llave_EjecucionCobAut     := 'EjecucionCobAut';
SET Llave_EjecucionCobAutRef  := 'EjecucionCobAutRef';
SET Salida_NO                 := 'N';
SET Inst_Credito              := 4;
SET Pro_CobranzaAutomatica    := 13;
SET Pro_CobranzaAutomaticaRef := 14;

SET Con_SPEI                  := 'S';
SET Con_Ventanilla            := 'V';
SET Con_CargoCta              := 'C';
SET Con_Automatica            := 'A';
SET Con_OrigenNomina          := 'N';
SET Con_PagoApliGarAgro		  := 'A';
SET Con_OrigenDepRef		  := 'R';
SET TipoOperPLDCredito		  := 2;
SET Con_CarCtaOrdenDeuAgro	  := 138;
SET Con_CarCtaOrdenCorAgro	  := 139;
SET OrigMinistraCrePro		  := 'MINISTRACREPRO'; -- Referencia de origen MINISTRACREPRO
SET LimiteDifPoliza			:= 0.01;


ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      	SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOPRO');
	    SET Par_NumErr  = 999;
	    SET Var_Control = 'sqlException';
    END;

	SET Var_ClienteEspecifico := FNPARAMGENERALES('CliProcEspecifico');
	SET Var_PagoPerdCentRedond := FNPARAMGENERALES('PagoPerdCentRedond');
	SET Var_PagoMontoMaxPerd := FNPARAMGENERALES('PagoMontoMaxPerd');
	SET Var_CuentaContablePerd := FNPARAMGENERALES('CuentaContablePerd');

	-- Si el Origen del pago es por Aplicacion de garantias Agro revolventes  se asgina como el tipo de pago de linea como aplicacion de garantias
	-- y el origen se ajusta a cargo a cuenta para respetar el pago con cargo a cuenta de la narrativa original
	IF( Par_Origen = Con_PagoApliGarAgro ) THEN
		SET Var_PagoLineaCredito 	:= Con_PagoApliGarAgro;
		SET Par_Origen 				:= Con_CargoCta;
	END IF;

	SET Var_PagoLineaCredito 	:= IFNULL(Var_PagoLineaCredito, Con_CargoCta);
	SET Par_Origen 				:= IFNULL(Par_Origen, Con_CargoCta);

	IF( Var_PagoPerdCentRedond =Cadena_Vacia ) THEN
		SET Var_PagoPerdCentRedond :=Con_NO;
    END IF;

	IF(Var_PagoPerdCentRedond=Cons_No) THEN
    SET Tol_DifPago := Var_PagoMontoMaxPerd;
    END IF;

  SELECT FechaSistema,  DiasCredito,    DivideIngresoInteres
  INTO Var_FechaSistema,  Var_DiasCredito,  Var_DivContaIng
    FROM PARAMETROSSIS;

   -- Se obtiene el valor de si se realiza o no el cobro de accesorios
  SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
  SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

  SET Var_PagoXReferencia := (SELECT ValorParametro
                    FROM PARAMGENERALES WHERE LlaveParametro = 'PagosXReferencia');
  SET Var_PagoXReferencia := IFNULL(Var_PagoXReferencia, Cadena_Vacia);

   -- Obtiene el parametro que indica si la institución permite el cobro de garantía financiada
  SET Var_CobraGarantiaFinanciada := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CobraGarantiaFinanciada');
  SET Var_CobraGarantiaFinanciada := IFNULL(Var_CobraGarantiaFinanciada,Cadena_Vacia);

  SET Aud_FechaActual   := NOW();
    SET Var_FechaSistema  := (SELECT FechaSistema FROM PARAMETROSSIS);
  -- Se consulta si la barredora esta en ejecucion
  SET Var_EjecucionCobAut := (FNPARAMGENERALES('EjecucionCobAut'));

	-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
	IF (Par_Origen != Con_OrigenWS AND Par_Origen != EsAutomatico AND Par_Origen != Con_OrigenNomina AND Par_Origen != Con_OrigenDepRef) THEN
		# SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
		SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID AND FechaPago = Var_FechaSistema);
		SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

		-- SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
		SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
		SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

		-- SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
		IF(Var_DifDiasPago=Entero_Cero)THEN
			IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= time('00:01:00') AND Var_EjecucionCobAut = Cons_No)THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
				SET Par_Consecutivo	:= 0;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

  SET Var_DivContaIng := IFNULL(Var_DivContaIng, Cadena_Vacia);
  SET Var_PagoAdeSinProy  := ValorNO;

	SELECT  Cli.SucursalOrigen,     Cre.ClienteID,      Pro.ProducCreditoID,    Des.Clasificacion,      Cre.NumAmortizacion,
			Cre.Estatus,            Cli.PagaIVA,        Pro.CobraIVAInteres,    Pro.CobraIVAMora,       Pro.EsReestructura,
			Res.EstatusCreacion,    Res.Regularizado,   Res.NumPagoActual,      Pro.EsGrupal,           Cre.SolicitudCreditoID,
			Pro.ProyInteresPagAde,  Cre.TasaFija,       Cre.MonedaID,           Cre.FrecuenciaCap,      Cre.FechaVencimien,
			Cre.GrupoID,            Cre.CicloGrupo,     Des.SubClasifID,        Pro.TipoPagoComFalPago, Pro.ManejaLinea,
			Pro.EsRevolvente,       Cre.LineaCreditoID, Cre.CalcInteresID,
			(Cre.SaldoCapVigent + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad + 	Cre.SaldoCapVencido),   Cre.CobraSeguroCuota,
			Cre.CobraIVASeguroCuota,Cre.MontoComApert,  Cre.IVAComApertura,   	Cre.ComAperCont,    	Cre.IVAComAperCont,
			Cre.MontoCredito,  		Cre.Refinancia,   	Cre.ReferenciaPago,   	Cre.CobraAccesorios,	Cre.EsConsolidacionAgro,
			Cre.EsConsolidado
	INTO    Var_SucCliente,         Var_ClienteID,      Var_ProdCreID,      	Var_ClasifCre,      	Var_NumAmorti,
			Var_EstatusCre,         Var_CliPagIVA,      Var_IVAIntOrd,      	Var_IVAIntMor,      	Var_EsReestruc,
			Var_EstCreacion,        Var_Regularizado,   Var_ResPagAct,      	Var_EsGrupal,       	Var_SolCreditoID,
			Var_ProyInPagAde,       Var_CreTasa,        Var_MonedaID,       	Var_Frecuencia,     	Var_FecVenCred,
			Var_GrupoID,            Var_CicloGrupo,     Var_SubClasifID,    	Var_TipCobComFal,   	Var_ManejaLinea,
			Var_EsRevolvente,       Var_LineaCredito,   Var_CalInteresID, 		Var_SaldoCapita,  		Var_CobraSeguroCuota,
			Var_CobraIVASeguroCuota,Var_MontoComAp,   	Var_IVAComAp,   		Var_MontoCont,    		Var_MontoIVACont,
			Var_MontoCredito,   	Var_Refinancia,   	Var_ReferenciaPago, 	Var_CobraAccesorios,	Var_EsConsolidacionAgro,
            Var_EsConsolidacion
	FROM CREDITOS Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
	LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
	WHERE Cre.CreditoID = Par_CreditoID;

	SET Var_EstCreacion     := IFNULL(Var_EstCreacion, Cadena_Vacia);
	SET Var_Regularizado    := IFNULL(Var_Regularizado, Cadena_Vacia);
	SET Var_ResPagAct     	:= IFNULL(Var_ResPagAct, Entero_Cero);
	SET Var_SubClasifID     := IFNULL(Var_SubClasifID, Entero_Cero);
	SET Var_TipCobComFal    := IFNULL(Var_TipCobComFal, Cadena_Vacia);
	SET Var_MontoCredito    := IFNULL(Var_MontoCredito, Decimal_Cero);
	SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios, ValorNO);
	SET Var_EsConsolidacionAgro := IFNULL(Var_EsConsolidacionAgro, ValorNO);
	SET	Var_EsConsolidacion	:= IFNULL(Var_EsConsolidacion, ValorNO);
	SET Var_LineaCredito	:= IFNULL(Var_LineaCredito, Entero_Cero);
	SET Var_ManejaLinea 	:= IFNULL(Var_ManejaLinea, NoManejaLinea);
	SET Var_EsRevolvente 	:= IFNULL(Var_EsRevolvente, NoEsRevolvente);

	IF( Var_LineaCredito <> Entero_Cero ) THEN
		SELECT	EsRevolvente,						EsAgropecuario,			SucursalID
		INTO	Var_EsLineaCreditoAgroRevolvente,	Var_EsLineaCreditoAgro,	VarSucursalLin
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Var_LineaCredito
		  AND EsAgropecuario = Con_SI;
	END IF;

	SET Var_EsLineaCreditoAgroRevolvente := IFNULL(Var_EsLineaCreditoAgroRevolvente, Cadena_Vacia);
	SET Var_EsLineaCreditoAgro			 := IFNULL(Var_EsLineaCreditoAgro, Cadena_Vacia);

	IF( Var_EsConsolidacionAgro = ValorSI ) THEN

		SELECT 	EstatusCreacion,			Regularizado,		NumPagoActual
		INTO 	Var_EstatusConsolidacion,	Var_EsRegularizado,	Var_NumPagosSostenidos
		FROM REGCRECONSOLIDADOS
		WHERE CreditoID = Par_CreditoID;

		SET Var_EstatusConsolidacion := IFNULL(Var_EstatusConsolidacion, Cadena_Vacia);
		SET Var_EsRegularizado := IFNULL(Var_EsRegularizado, ValorNO);
		SET Var_NumPagosSostenidos := IFNULL(Var_NumPagosSostenidos, Entero_Cero);
	END IF;

	IF( Var_EsConsolidacion = ValorSI ) THEN

		SELECT 	EstatusCreacion,			Regularizado,		NumPagoActual
		INTO 	Var_EstatusConsolidacion,	Var_EsRegularizado,	Var_NumPagosSostenidos
		FROM CONSOLIDACIONCARTALIQ
		WHERE CreditoID = Par_CreditoID;

		SET Var_EstatusConsolidacion := IFNULL(Var_EstatusConsolidacion, Cadena_Vacia);
		SET Var_EsRegularizado := IFNULL(Var_EsRegularizado, ValorNO);
		SET Var_NumPagosSostenidos := IFNULL(Var_NumPagosSostenidos, Entero_Cero);
	END IF;


  -- Contamos la cantidad de amortizaciones Vencidas solo para creditos suspendidos.
  IF(Var_EstatusCre = Estatus_Suspendido) THEN
    SELECT COUNT(AmortizacionID)
      INTO Var_CantAmoVenSusp
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID
      AND Estatus = Esta_Vencido;
  END IF;
  SET Var_CantAmoVenSusp := IFNULL(Var_CantAmoVenSusp, Entero_Cero);


  -- Buscamos la Dias Permitidos para el Adelanto del Pago
  SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
    FROM CREDDIASPAGANT Dpa
    WHERE Dpa.ProducCreditoID = Var_ProdCreID
      AND Dpa.Frecuencia = Var_Frecuencia;

  SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);
    -- Monto correspondiente al 20% del Monto del Credito
    SET Var_PorcMontoCred := ((Var_MontoCredito * 20)/100);

  IF(Var_EstCreacion = Cadena_Vacia) THEN
      SET Var_EsReestruc  := No_EsReestruc;
  ELSE
      SET Var_EsReestruc  := SI_EsReestruc;
  END IF;

  SELECT IVA INTO Var_IVASucurs
    FROM SUCURSALES
    WHERE SucursalID  = Var_SucCliente;

  SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
  SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
  SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
  SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

  -- Inicializaciones
  SET Var_ValIVAIntOr := Entero_Cero;
  SET Var_ValIVAIntMo := Entero_Cero;
  SET Var_ValIVAGen   := Entero_Cero;
  SET Int_NumErr      := Entero_Cero;
  SET Var_NumPagSos   := Entero_Cero;
  SET Var_ComAntici   := Entero_Cero;
  SET Var_DiasAntici  := Entero_Cero;
  SET Var_IVANotaCargo := Entero_Cero;

  -- Asignamos el monto de cobro de iva sin importa que el cliente no pague iva
  SET Var_IVANotaCargo	:= Var_IVASucurs;

  IF (Var_CliPagIVA = SiPagaIVA) THEN
    SET Var_ValIVAGen  := Var_IVASucurs;

    IF (Var_IVAIntOrd = SiPagaIVA) THEN
      SET Var_ValIVAIntOr  := Var_IVASucurs;
    END IF;

    IF (Var_IVAIntMor = SiPagaIVA) THEN
      SET Var_ValIVAIntMo  := Var_IVASucurs;
    END IF;
  END IF;

  -- Revisamos si es una Liquidacion Anticipada o Finiquito
   IF( Par_Finiquito = Finiquito_SI) THEN
    SET Con_PagoCred := "LIQUIDACION ANT.CREDITO";
    SET Var_FecVenCred := IFNULL(Var_FecVenCred, Fecha_Vacia);

    -- Obtenemos las Condiciones de la Comision por Finiquito
    SELECT  PermiteLiqAntici,   CobraComLiqAntici,    TipComLiqAntici,
        ComisionLiqAntici,  DiasGraciaLiqAntici
    INTO    Var_PermiteLiqAnt,  Var_CobraComLiqAnt,   Var_TipComLiqAnt,
        Var_ComLiqAnt,    Var_DiasGraciaLiq
    FROM ESQUEMACOMPRECRE
      WHERE ProductoCreditoID = Var_ProdCreID;

    SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
    SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
    SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
    SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
    SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);

    IF(Var_FecVenCred != Fecha_Vacia AND Var_FecVenCred >= Var_FechaSistema) THEN
      SET Var_DiasAntici := DATEDIFF(Var_FecVenCred, Var_FechaSistema);
    ELSE
      SET Var_DiasAntici := Entero_Cero;
    END IF;

     IF(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND
       Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN

      -- * VALIDAR EL TIPO DE COMISION
      IF(Var_TipComLiqAnt = Proyeccion_Int) THEN
        -- * SI ES PROYECCION
        -- Obtenemos el Monto del Interes Pendiente de Devengar
        SELECT SUM(Interes) INTO Var_ComAntici
        FROM AMORTICREDITO
          WHERE CreditoID   = Par_CreditoID
            AND FechaVencim > Var_FechaSistema
            AND Estatus     != Esta_Pagado;
        SET Var_ComAntici   := IFNULL(Var_ComAntici, Entero_Cero);

        -- Obtenemos el Saldo De Interes de la Amortizacion Actual o Vigente
        SELECT (Amo.SaldoInteresPro + Amo.SaldoIntNoConta) INTO Var_IntActual
          FROM AMORTICREDITO Amo
          WHERE Amo.CreditoID   = Par_CreditoID
            AND Amo.FechaVencim > Var_FechaSistema
            AND Amo.FechaInicio <= Var_FechaSistema
            AND Amo.Estatus     != Esta_Pagado;
        SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
        SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

      ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN        -- En Base a Porcentaje de Saldo Insoluto
          SET Var_ComAntici   := ROUND(Var_SaldoCapita * Var_ComLiqAnt / Decimal_Cien,2);
        ELSE
          SET Var_ComAntici   := Var_ComLiqAnt;               -- En Base a Monto Fijo
        END IF; -- Endif Del Tipo de Cobro
    END IF; -- Endif Perimite Finiquito y Dias de Gracia

    IF(Var_ComAntici < Entero_Cero) THEN
      SET Var_ComAntici   := Entero_Cero;
    END IF;

    SELECT TipoLiquidacion  INTO Var_TipoLiquidacion
        FROM CREDITOS
        WHERE Relacionado = Par_CreditoID LIMIT 1;

        SET Var_TipoLiquidacion := IFNULL(Var_TipoLiquidacion, LiquidacionTotal);

        IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
    -- Monto Total del Adeudo
    SELECT FUNCIONTOTDEUDACRE(Par_CreditoID) INTO Var_MontoDeuda;
    ELSE
    -- Monto Parcial del Adeudo
    SELECT FUNCIONPARCDEUDACRE(Par_CreditoID) INTO Var_MontoDeuda;
        END IF;


	IF (Aud_ProgramaID = OrigMinistraCrePro) THEN
   		-- En una Reestructura o Renovacion no hay Comision por Liquidacion Anticipada
    	IF EXISTS (SELECT CreditoOrigenID FROM REESTRUCCREDITO
                      WHERE CreditoOrigenID = Par_CreditoID AND EstatusReest = EstatusDesembolso) THEN
      		SET Var_ComAntici := Entero_Cero;
    	END IF;
	END IF;

    SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero) +
                Var_ComAntici + ROUND(Var_ComAntici * Var_ValIVAIntOr,2);

    IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
      IF(ABS(Var_MontoDeuda - Par_MontoPagar) > Tol_DifPago) THEN
          SET Par_NumErr    := '100';
          SET Par_ErrMen    := CONCAT('Credito: ', CONVERT(Par_CreditoID,CHAR), ' . <br>En una Liquidacion Anticipada el Monto de Pago debe ser el Total ',
                       'del Adeudo. <br>Adeudo Total: $', CONVERT(FORMAT(Var_MontoDeuda,2), CHAR),
                      ' <br>Monto del Pago: $', CONVERT(FORMAT(Par_MontoPagar,2), CHAR));
          SET Par_Consecutivo := 0;
          SET Var_Control   := 'creditoID';
        LEAVE ManejoErrores;
      END IF;
    END IF; -- END IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
  END IF; --  IF( Par_Finiquito = Finiquito_SI) THEN


  CALL DIASFESTIVOSCAL(
	    Var_FechaSistema,	Entero_Cero,    	Var_FecAplicacion,    	Var_EsHabil,    	Par_EmpresaID,
	    Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,   	Aud_Sucursal,
	    Aud_NumTransaccion);

  CALL SALDOSAHORROCON(
    	Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

  -- Si el pago fue por referencia
  IF(Var_PagoXReferencia = Cons_Si AND Par_ModoPago = Con_CargoCta) THEN
    CALL PAGOXREFERENCIAACT(
		Aud_NumTransaccion,		Par_CreditoID,		Par_CuentaAhoID,	Var_ClienteID,	Var_ReferenciaPago,
		Par_MontoPagar,			Var_Cue_Saldo,		Var_FechaSistema,	1,				Par_Origen,
		Cons_No,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero) THEN
      LEAVE ManejoErrores;
    END IF;
  END IF;

    IF(Var_EsGrupal = SI_EsGrupal)THEN
    SET Var_CicloGpoActual := (SELECT CicloActual FROM GRUPOSCREDITO WHERE GrupoID = Var_GrupoID);
        SET Var_CicloGpoActual := IFNULL(Var_CicloGpoActual,Entero_Cero);

        IF(Var_CicloGpoActual = Var_CicloGrupo)THEN
      SET Var_ProrrateaPago := (SELECT ProrrateaPago FROM INTEGRAGRUPOSCRE WHERE ClienteID = Var_ClienteID
                  AND GrupoID = Var_GrupoID AND Estatus = IntActivo);
    ELSE
    SET Var_ProrrateaPago := (SELECT ProrrateaPago FROM `HIS-INTEGRAGRUPOSCRE` WHERE ClienteID = Var_ClienteID
          AND GrupoID = Var_GrupoID AND Ciclo = Var_CicloGrupo and Estatus = 'A'); -- aqui
    END IF;
    END IF;

  IF ( (Var_EsGrupal = NO_EsGrupal OR (Var_EsGrupal = SI_EsGrupal AND Var_ProrrateaPago=NO_Prorratea))
    AND Par_Finiquito <>  Finiquito_SI) THEN
    -- Se manda a llamar el SP que realizará los bloqueos y desbloqueos de GARANTIA LIQUIDA
    CALL GARANTIALIQUIDAPRO(
		Var_Poliza,     	Par_CreditoID,    	Var_MonedaID,   	Par_MontoPagar,     Par_EsPrePago,
		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

    IF(Par_NumErr!=Entero_Cero) THEN
      LEAVE ManejoErrores;
    END IF;
  END IF;

  CALL SALDOSAHORROCON(
  		Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

  IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != Esta_Activo THEN
      SET Par_NumErr    := '01';
      SET Par_ErrMen    := 'La Cuenta No Existe o no Esta Activa ';
      SET Par_Consecutivo := 0;
      SET Var_Control   :=  'cuentaAhoID';
    LEAVE ManejoErrores;
  END IF;

	-- Valido que el credito a liquidar
	SELECT	CreditoID, 				SolicitudCreditoID
	INTO 	Var_CreditoConsolida,	Var_SolicitudConsolida
	FROM CRECONSOLIDAAGRODET
	WHERE CreditoID = Par_CreditoID
	  AND Estatus = Est_Autorizado
	LIMIT 1;

	IF( IFNULL(Var_CreditoConsolida, Entero_Cero) = Entero_Cero ) THEN
  IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID THEN
    SET Par_NumErr := Entero_Cero;

    IF (Var_EsGrupal = NO_EsGrupal) THEN
      SET Par_NumErr    := '02';
      SET Par_ErrMen    := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
                  ' No Pertenece al Cliente: ', CONVERT(Var_ClienteID, CHAR),
                  ' Cliente al que Pertence: ' , CONVERT(Var_CueClienteID, CHAR));
      SET Par_Consecutivo := 0;

    ELSE
      -- En un Credito Grupal si se Puede Pagar con la Cuenta de Otro Cliente
      -- Siempre y Cuando ese Cliente Pertenezca al Grupo
      SET Var_SolCreditoID := IFNULL(Var_SolCreditoID, Entero_Cero);
      SET Var_GrupoID := IFNULL(Var_GrupoID, Entero_Cero);

      SELECT CicloActual INTO Var_CicloActual
        FROM  GRUPOSCREDITO
        WHERE GrupoID = Var_GrupoID;

      SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

      -- Verificamos el Ciclo del Grupo, Si es el Ciclo Actual o si es un Ciclo Anterior
      -- Entonces Buscamos los Integrantes en el Historico
      IF(Var_CicloGrupo = Var_CicloActual) THEN
        SELECT GrupoID INTO Var_GrupoCtaID
          FROM INTEGRAGRUPOSCRE
          WHERE GrupoID = Var_GrupoID
            AND Estatus = Esta_Activo
            AND ClienteID = Var_CueClienteID
          LIMIT 1;
    ELSE
		-- Ajuste para obtener el ciclo correcto del grupo
		SELECT Ing.GrupoID INTO Var_GrupoCtaID
		FROM `HIS-INTEGRAGRUPOSCRE` Ing
		INNER JOIN SOLICITUDCREDITO Sol ON Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN CREDITOS Cre ON Sol.CreditoID = Cre.CreditoID
		WHERE Ing.GrupoID = Var_GrupoID
			AND Ing.Estatus = Esta_Activo
			AND Ing.ClienteID = Var_CueClienteID
			AND Cre.CicloGrupo = Var_CicloGrupo
		LIMIT 1;
    END IF;

      SET Var_GrupoCtaID := IFNULL(Var_GrupoCtaID, Entero_Cero);

      IF (Var_GrupoCtaID = Entero_Cero) THEN
        SET Par_NumErr    := '02';
        SET Par_ErrMen    := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
                  ' No Pertenece al Cliente: ', CONVERT(Var_ClienteID, CHAR),
                  'Cliente al que Pertence: ' , CONVERT(Var_CueClienteID, CHAR));
        SET Par_Consecutivo := 0;
      END IF;
    END IF;

    IF(Par_NumErr != Entero_Cero) THEN
      LEAVE ManejoErrores;
    END IF;
  END IF; -- IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID

	END IF;

  IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
      SET Par_NumErr    := '03';
      SET Par_ErrMen    := 'La Moneda No Corresponde con la Cuenta.';
      SET Par_Consecutivo := 0;
    LEAVE ManejoErrores;
  END IF;


  IF(Var_ProgOriginalID != Prog_Reestructura) THEN
    IF(IFNULL(Var_Cue_Saldo, Decimal_Cero)) < Par_MontoPagar THEN
        SET Par_NumErr    := '04';
        SET Par_ErrMen    := CONCAT('Saldo Insuficiente en la Cuenta del Cliente.');
        SET Par_Consecutivo := 0;
      LEAVE ManejoErrores;
    END IF;
  END IF;

  IF(IFNULL(Var_EstatusCre, Cadena_Vacia)) = Cadena_Vacia THEN
      SET Par_NumErr    := '05';
      SET Par_ErrMen    := 'El Credito No Existe.';
      SET Par_Consecutivo := 0;
    LEAVE ManejoErrores;
  END IF;

  IF(Var_EstatusCre != Esta_Vigente AND
     Var_EstatusCre != Esta_Vencido AND
     Var_EstatusCre != Estatus_Suspendido) THEN
      SET Par_NumErr    := '06';
      SET Par_ErrMen    := 'Estatus del Credito Incorrecto.';
      SET Par_Consecutivo := 0;
      SET Var_Control   := 'monto';
    LEAVE ManejoErrores;
  END IF;

  IF(Par_RespaldaCred = Cons_Si) THEN
    -- Respaldamos las tablas de CREDITOS, AMORTICREDITO, CREDITOSMOVS antes de realizar el pago (usado para la reversa)
    CALL RESPAGCREDITOPRO(
          Par_CreditoID,  Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);
  END IF;

  IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZASALT(
			Var_Poliza,			Par_EmpresaID,   	Var_FecAplicacion, 	Pol_Automatica,		Coc_PagoCred,
			Con_PagoCred,		Par_SalidaNO,      	Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
  END IF;

  SET Var_SaldoPago       := Par_MontoPagar;
  SET Var_CuentaAhoStr    := CONVERT(Par_CuentaAhoID, CHAR(15));
  SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));


  -- Cobramos la Comision por Finiquito o Liquidacion Anticipada
  IF( Par_Finiquito = Finiquito_SI AND Var_ComAntici > Entero_Cero) THEN
    -- COMISION DIFERIDA
    -- Se verifica si aun tiene Saldo de Comision pendiente por contabilizar
    IF(Var_MontoCont>Decimal_Cero) THEN
      -- Si el monto de la Comision por apertura es mayor que cero, se procede a generar los asientos contables
      IF(Var_MontoComAp > Decimal_Cero)THEN

        SET Var_MontoAmort    := ROUND(Var_MontoCont,2);  # Obtiene el monto que se abona a la cuenta de Com. por Apert

        -- Se realiza el CARGO a la cuenta Puente (Gasto)
        CALL CONTACREDITOSPRO (
			Par_CreditoID,			Entero_Cero,			Entero_Cero,		Entero_Cero,		Var_FechaSistema,
			Var_FechaSistema,		Var_MontoAmort,			Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
			Var_SubClasifID,		Var_SucCliente,			Var_DescComAper,	Cadena_Vacia,		AltaPoliza_NO,
			Entero_Cero,			Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,		Con_ContGastos,
			Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
			Par_Origen,				Par_SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
			Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Ref_PagAnti,			Aud_Sucursal,			Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
        	LEAVE ManejoErrores;
        END IF;

        -- Se realiza el ABONO a la cuenta de Comision por Apertura de Credito
        CALL CONTACREDITOSPRO (
			Par_CreditoID,			Entero_Cero,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
			Var_FechaSistema,		Var_MontoAmort,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
			Var_SubClasifID,		Var_SucCliente,		Var_DescComAper,	Cadena_Vacia,		AltaPoliza_NO,
			Entero_Cero,			Var_Poliza,			AltaPolCre_SI,		AltaMovCre_NO,		Con_ContComApe,
			Entero_Cero,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
			Par_Origen,				Par_SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
			Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Ref_PagAnti,			Aud_Sucursal,		Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          	LEAVE ManejoErrores;
        END IF;

        -- Actualizando el Campo ComAperCont para disminuir lo que ya ha sido contabilizado
        UPDATE CREDITOS SET
          ComAperCont = ComAperCont - Var_MontoAmort
        WHERE CreditoID= Par_CreditoID;

      END IF;

    END IF;        --  FIN COMISION DIFERIDA

    -- Obtenemos la Amortizacion "Vigente-Actual", a la cual Cargar la Comision
    SELECT MIN(AmortizacionID) INTO Var_ProxAmorti
      FROM AMORTICREDITO
      WHERE CreditoID     = Par_CreditoID
        AND FechaVencim >= Var_FechaSistema
        AND Estatus     != Esta_Pagado;

    -- Cargo de los Gastos de Admon o Liq. Anticipada
    CALL CONTACREDITOSPRO (
		Par_CreditoID,		Var_ProxAmorti,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
		Var_FecAplicacion,	Var_ComAntici,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
		Var_SubClasifID,	Var_SucCliente,		Des_PagoCred,		Ref_PagAnti,		AltaPoliza_NO,
		Entero_Cero,		Var_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Entero_Cero,
		Mov_ComLiqAnt,		Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
		Par_Origen,			Par_SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
		Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Ref_PagAnti,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

    -- Pago de los Gastos de Admon o Liq. Anticipada
    CALL CONTACREDITOSPRO (
		Par_CreditoID,		Var_ProxAmorti,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
		Var_FecAplicacion,	Var_ComAntici,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
		Var_SubClasifID,	Var_SucCliente,		Des_PagoCred,		Ref_PagAnti,		AltaPoliza_NO,
		Entero_Cero,		Var_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,		Con_ComFiniqui,
		Mov_ComLiqAnt,		Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
		Par_Origen,			Par_SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
		Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

    -- Pago del IVA Gastos de Admon o Liq. Anticipada
    SET Var_IVAComAntici    := ROUND(Var_ComAntici * Var_ValIVAIntOr, 2);
    IF(Var_IVAComAntici > Entero_Cero) THEN
      	CALL CONTACREDITOSPRO (
			Par_CreditoID,		Var_ProxAmorti,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
			Var_FecAplicacion,	Var_IVAComAntici,	Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
			Var_SubClasifID,	Var_SucCliente,		Des_PagoCred,		Ref_PagAnti,		AltaPoliza_NO,
			Entero_Cero,		Var_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,		Con_IVAComFin,
			Mov_IVAComLiqAnt,	Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
			Par_Origen,			Par_SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
			Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;
    SET Var_SaldoPago   := Var_SaldoPago - Var_ComAntici - Var_IVAComAntici;

    -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
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
		Var_CreditoID,			Var_AmortizacionID,			Var_SaldoCapVigente,		Var_SaldoCapAtrasa,
		Var_SaldoCapVencido,	Var_SaldoCapVenNExi,		Var_SaldoInteresOrd,		Var_SaldoInteresAtr,
		Var_SaldoInteresVen,	Var_SaldoInteresPro,		Var_SaldoIntNoConta,		Var_SaldoMoratorios,
		Var_SaldoComFaltaPa,	Var_SaldoOtrasComis,		Var_MonedaID,				Var_FechaInicio,
		Var_FechaVencim,		Var_FechaExigible,			Var_AmoEstatus,				Var_SaldoMoraVenci,
		Var_SaldoMoraCarVen,	Var_SaldoSeguroCuota,		Var_CobraComAnual,			Var_SaldoComAnual,
		Var_SaldoNotCargoRev,	Var_SaldoNotCargoSinIVA,	Var_SaldoNotCargoConIVA,	Var_MontoComServGar;

    -- Inicializaciones
    SET Var_CantidPagar   	:= Decimal_Cero;
    SET Var_IVACantidPagar  := Decimal_Cero;
    SET Var_NumPagSos       := Entero_Cero;
    SET Var_SaldoMoraVenci  := IFNULL(Var_SaldoMoraVenci, Entero_Cero);
    SET Var_SaldoMoraCarVen := IFNULL(Var_SaldoMoraCarVen, Entero_Cero);
    SET Var_SaldoSeguroCuota := IFNULL(Var_SaldoSeguroCuota, Decimal_Cero);
    SET Var_SalCapitales     := Var_SaldoCapVigente + Var_SaldoCapAtrasa +
                   				Var_SaldoCapVencido + Var_SaldoCapVenNExi;
    SET Var_CobraComAnual 	:= IFNULL(Var_CobraComAnual, Cons_No); -- COMISION ANUAL
    SET Var_SaldoComAnual 	:= IFNULL(Var_SaldoComAnual, Entero_Cero); -- COMISION ANUAL

    SET Var_SaldoOtrasComis 	:= IFNULL(Var_SaldoOtrasComis, Entero_Cero); -- OTRAS COMISIONES
    SET Var_SaldoNotCargoRev 	:= IFNULL(Var_SaldoNotCargoRev, Entero_Cero); -- NOTAS CARGOS
    SET Var_SaldoNotCargoSinIVA := IFNULL(Var_SaldoNotCargoSinIVA, Entero_Cero); -- NOTAS CARGOS
    SET Var_SaldoNotCargoConIVA := IFNULL(Var_SaldoNotCargoConIVA, Entero_Cero);  -- NOTAS CARGOS
	SET Var_MontoComServGar		:= IFNULL(Var_MontoComServGar, Entero_Cero);

    IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
      LEAVE CICLO;
    END IF;

     IF( DATE_SUB(Var_FechaExigible, INTERVAL Var_DiasPermPagAnt DAY) > Var_FechaSistema AND Par_Finiquito = Finiquito_NO) THEN
      LEAVE CICLO;
    END IF;

	-- ======================= INICIO DE PAGO DE CREDITO POR NOTAS CARGOS ================
	-- ===================================================================================
	-- SUmamos los montos de notas Cargos
	SET	Var_MontoNotaCargo	:= Var_SaldoNotCargoRev + Var_SaldoNotCargoSinIVA + Var_SaldoNotCargoConIVA;

	IF (Var_MontoNotaCargo >= Mon_MinPago) THEN

		-- Calculamos el monto que corresponden a nota cargo  cuando cobra iva
		IF(Var_SaldoNotCargoConIVA > Entero_Cero) THEN
			SET Var_IVACantidPagar = ROUND((ROUND(Var_SaldoNotCargoConIVA, 2) * Var_IVANotaCargo), 2);
		END IF;

		IF(ROUND(Var_SaldoPago,2) >= (ROUND(Var_MontoNotaCargo, 2) + Var_IVACantidPagar)) THEN
			SET Var_CantidPagar		:= Var_MontoNotaCargo;
		ELSE
			SET Var_CantidPagar		:= Var_SaldoPago - ROUND(((Var_SaldoNotCargoConIVA)/(1 + Var_IVANotaCargo)) * Var_IVANotaCargo, 2);
			SET Var_IVACantidPagar	:= ROUND(((Var_SaldoNotCargoConIVA)/(1 + Var_IVANotaCargo)) * Var_IVANotaCargo, 2);
		END IF;

		CALL PAGCRENOTACARGOPRO(
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			Par_Origen,			Salida_NO,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
		UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
			WHERE AmortizacionID = Var_AmortizacionID
			AND CreditoID = Par_CreditoID;

		SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;
	END IF;
	-- ========================== FIN DE PAGO DE CREDITO POR NOTAS CARGOS ================
	-- ===================================================================================

        IF(Var_CobraAccesoriosGen = ValorSI AND Var_CobraAccesorios = ValorSI) THEN
      -- COBRO DE OTRAS COMISIONES
      IF (Var_SaldoOtrasComis >= Mon_MinPago ) THEN
        SET Var_IVACantidPagar  := 0.00;
        SET Var_CantidPagar   := Var_SaldoPago;

		CALL  PAGCREOTRASCOMISPRO (
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			Par_Origen,			Par_SalidaNO,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		 END IF;

        -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

        SET Var_SaldoPago := Var_CantidPagar;
        IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
          LEAVE CICLO;
        END IF;

      END IF;
    END IF;

    -- SE OBTIENEN VALORES
    IF( (Var_ManejaLinea = SiManejaLinea AND Var_LineaCredito <> Entero_Cero))THEN
      SELECT  MonedaID,   SucursalID,     CobraComAnual,      ComisionCobrada,    SaldoComAnual
        INTO
          MonedaLinea,  VarSucursalLin,   Var_CobraComAnualLin, Var_ComAnualCobradaLin, Var_SaldoComAnualLin
        FROM  LINEASCREDITO
        WHERE LineaCreditoID = Var_LineaCredito;
    END IF;

	-- ===================== Inicio Comisión Anual Linea de Crédito ============================
	IF( Var_ManejaLinea = SiManejaLinea AND Var_CobraComAnualLin=Cons_Si AND Var_ComAnualCobradaLin=Cons_No AND Var_LineaCredito <> Entero_Cero ) THEN

		-- Sección para verificar el monto de pago
		SET Var_IVASucurs := (SELECT IVA
							  FROM SUCURSALES
							  WHERE SucursalID = Var_SucCliente);

		SET Var_IVASucurs := IFNULL(Var_IVASucurs,Entero_Cero); -- DEFAULT IVA Comisisón

		SET Var_MontoComAnual := IFNULL(Var_SaldoComAnualLin,Entero_Cero);
		SET Var_MontoIVAComAnual := ROUND(Var_MontoComAnual*Var_IVASucurs,2);

		IF( (Var_MontoComAnual+Var_MontoIVAComAnual) > Var_SaldoPago)THEN
			SET Var_MontoComAnual := ROUND(Var_SaldoPago / (1 + Var_IVASucurs),2);
			SET Var_MontoIVAComAnual := ROUND(Var_MontoComAnual * Var_IVASucurs,2);
		END IF;

		SET ConstDescipLinea := CONCAT('CARGO POR ANUALIDAD DE LA LINEA No.',Var_LineaCredito);

		-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE LA COMISION ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO Y POLIZASAHORROPRO
		CALL CONTALINEASCREPRO(
			Var_LineaCredito,		Entero_Cero,		Var_FechaSistema,		Var_FechaSistema,	Var_MontoComAnual,
			Var_MonedaID,			Var_ProdCreID,		VarSucursalLin,			ConstDescipLinea,	Var_LineaCredito,
			AltaPoliza_NO,			Entero_Cero,		AltaPolCre_SI,			AltaMovAho_NO,		Con_ContComAnual,
			TipoMovAhoComAnual,		Nat_Abono,			Nat_Cargo,				Salida_NO,			Par_NumErr,
			Par_ErrMen,				Var_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_CliPagIVA = SiPagaIVA) THEN

			SET ConstDescipLinea := CONCAT('CARGO IVA POR ANUALIDAD DE LA LINEA No.',Var_LineaCredito);

			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE IVA DE LA COMISION ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
			CALL CONTALINEASCREPRO(
				Var_LineaCredito,		Entero_Cero,	Var_FechaSistema,		Var_FechaSistema,	Var_MontoIVAComAnual,
				Var_MonedaID,			Var_ProdCreID,	VarSucursalLin,			ConstDescipLinea,	Var_LineaCredito,
				AltaPoliza_NO,			Entero_Cero,	AltaPolCre_SI,			AltaMovAho_NO,		Con_ContIVAComAnual,
				TipoMovAhoIVAComAnual,	Nat_Abono,		Nat_Cargo,				Salida_NO,			Par_NumErr,
				Par_ErrMen,				Var_Poliza,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		UPDATE LINEASCREDITO SET
			SaldoComAnual = SaldoComAnual - Var_MontoComAnual,
			ComisionCobrada = IF(SaldoComAnual=0,'S','N')
		WHERE LineaCreditoID = Var_LineaCredito;

		SET Var_SaldoPago := Var_SaldoPago - (Var_MontoComAnual + Var_MontoIVAComAnual);
		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;
	-- ===================== Fin Comision Anual Linea de Credito ============================

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
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			Par_Origen,			Par_ModoPago,
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


    -- Consideraciones en el Cobro de la Comision por Falta de Pago
    -- De acuerdo a la Parametrizacion del Producto de Credito, la Comision por Falta de Pago
    -- Se puede Cobar en Cada Cuota, o Al final de la Prelacion, Siendo el ultimo concepto que se Pague.
    IF (Var_SaldoComFaltaPa >= Mon_MinPago AND Var_TipCobComFal = Cob_FalPagCuota) THEN

      SET Var_IVACantidPagar := ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

      IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   := Var_SaldoComFaltaPa;
      ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                       ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
      END IF;

		CALL PAGCRECOMFALPRO (
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,			Par_Origen,			Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

          -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
         UPDATE AMORTICREDITO Tem
      SET NumTransaccion = Aud_NumTransaccion
        WHERE AmortizacionID = Var_AmortizacionID
          AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;
    -- Pago de Seguro por Cuota
    IF(Var_SaldoSeguroCuota >= Mon_MinPago AND Var_CobraSeguroCuota = SiCobSeguroCuota) THEN
      SET Var_MontoSeguro := Var_SaldoSeguroCuota;
      -- Se verifica el cobro del IVA de Seguro por Cuota
      IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
        SET Var_IVACantidPagar    := ROUND((Var_SaldoSeguroCuota * Var_ValIVAGen), 2);
      ELSE
        -- OPERATIVO
                SET Var_IVACantidPagar    := Decimal_Cero;
                -- CONTABLE
                SET Var_MontoSeguroCont   := ROUND((Var_SaldoSeguroCuota/(1+Var_ValIVAGen)),2);
        SET Var_MontoIVASeguroCont  := ROUND(Var_MontoSeguro-Var_MontoSeguroCont,2);
      END IF;

            -- Se obtiene el Monto a Pagar
            IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoSeguroCuota + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   := Var_SaldoSeguroCuota;

      ELSE
        IF (Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
          SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                        ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

          SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
        ELSE
          -- OPERATIVO
          SET Var_CantidPagar   := ROUND(Var_SaldoPago,2);
          SET Var_IVACantidPagar  := Decimal_Cero;
                    -- CONTABLE
          SET Var_MontoSeguroCont   := ROUND(Var_SaldoPago,2) -
                        ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
          SET Var_MontoIVASeguroCont  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
        END IF;
      END IF;

            SET Var_MontoSeguroOp     := Var_CantidPagar;
            SET Var_MontoIVASeguroOp  := Var_IVACantidPagar;
            IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota) THEN
        -- Proceso para el Pago de Seguro por Cuota
		CALL PAGCRESEGCUOTAPRO (
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,		Var_FechaVencim,		Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,		Var_CantidPagar,		Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,			Var_SubClasifID,		Var_SucCliente,
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,				Par_Origen,				Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
      ELSE
        	CALL PAGCRESEGCUOTASINIVAPRO (
        		Var_CreditoID,      Var_AmortizacionID,   	Var_FechaInicio,    	Var_FechaVencim,  	Par_CuentaAhoID,
                Var_ClienteID,      Var_FechaSistema,     	Var_FecAplicacion,  	Var_MontoSeguroOp,  Var_MontoIVASeguroOp,
                Var_MontoSeguroCont,Var_MontoIVASeguroCont, Var_MonedaID,       	Var_ProdCreID,    	Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,         Des_PagoCred,   		Var_CuentaAhoStr,   Var_Poliza,
                Par_Origen,			Par_NumErr,				Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,
                Par_ModoPago,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
                Aud_Sucursal,		Aud_NumTransaccion);

        	IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
        END IF;
            -- Se actualiza el Numero de Transaccion en AMORTICREDITO
      UPDATE AMORTICREDITO Tem
      SET NumTransaccion = Aud_NumTransaccion
        WHERE AmortizacionID = Var_AmortizacionID
          AND CreditoID = Par_CreditoID;

            -- Se obtiene el monto disponible para realizar los pagos siguientes
            SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;
        END IF; -- FIN Pago Seguro por Cuota
    -- Pago de Comision x Anualidad
    IF(Var_CobraComAnual = Cons_Si) THEN/*COMISION ANUAL*/
      SET Var_IVACantidPagar  := Entero_Cero;
      SET Var_CantidPagar   := Entero_Cero;

      IF(Var_ValIVAGen > Entero_Cero) THEN
        SET Var_IVACantidPagar    := ROUND((Var_SaldoComAnual * Var_ValIVAGen), 2);
      ELSE
        SET Var_IVACantidPagar    := Decimal_Cero;
      END IF;

      -- Se obtiene el Monto a Pagar
      IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoComAnual + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   := Var_SaldoComAnual;
        ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) - ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
      END IF;

		CALL PAGCRECOMANUALIDADPRO (
			Var_CreditoID,		Var_AmortizacionID,		Var_FechaInicio,		Var_FechaVencim,		Par_CuentaAhoID,
			Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,		Var_CantidPagar,		Var_IVACantidPagar,
			Var_MonedaID,		Var_ProdCreID,			Var_ClasifCre,			Var_SubClasifID,		Var_SucCliente,
			Des_PagoCred,		Var_CuentaAhoStr,		Var_Poliza,				Par_Origen,				Par_SalidaNO,
			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,			Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

      -- Se actualiza el Numero de Transaccion en AMORTICREDITO
      UPDATE AMORTICREDITO Tem
      SET NumTransaccion = Aud_NumTransaccion
        WHERE AmortizacionID = Var_AmortizacionID
          AND CreditoID = Par_CreditoID;

      -- Se obtiene el monto disponible para realizar los pagos siguientes
      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;/*COMISION ANUAL*/
    END IF; -- FIN Pago Comision x Anualidad
    -- Saldo de Interes Moratorio Vencido
    IF (Var_SaldoMoraVenci >= Mon_MinPago) THEN

      SET Var_IVACantidPagar = ROUND((Var_SaldoMoraVenci *  Var_ValIVAIntMo), 2);

      IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoMoraVenci + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   :=  Var_SaldoMoraVenci;
      ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                       ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);
      END IF;

		CALL PAGCREMORATOVENCPRO (
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
			Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Par_Origen,         Par_NumErr,
			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,       Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

          -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
          UPDATE AMORTICREDITO Tem
      SET NumTransaccion = Aud_NumTransaccion
        WHERE AmortizacionID = Var_AmortizacionID
          AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;
    -- Saldo de Interes Moratorio de Cartera Vencida (Cuentas de Orden)
    IF (Var_SaldoMoraCarVen >= Mon_MinPago) THEN

      SET Var_IVACantidPagar = ROUND((Var_SaldoMoraCarVen *  Var_ValIVAIntMo), 2);

      IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoMoraCarVen + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   :=  Var_SaldoMoraCarVen;
      ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                       ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);
      END IF;

		CALL PAGCREMORACARVENPRO (
			Var_CreditoID,			Var_AmortizacionID, Var_FechaInicio,	Var_FechaVencim,	Par_CuentaAhoID,
			Var_ClienteID,			Var_FechaSistema,	Var_FecAplicacion,	Var_CantidPagar,	Var_IVACantidPagar,
			Var_MonedaID,			Var_ProdCreID,		Var_ClasifCre,		Var_SubClasifID,	Var_SucCliente,
			Des_PagoCred,			Var_CuentaAhoStr,	Var_Poliza,			Par_Origen,			Par_NumErr,
			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Par_ModoPago,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

      	IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;
    -- Saldo de Interes Moratorio de Cartera Vigente
    IF (Var_SaldoMoratorios >= Mon_MinPago) THEN

      SET Var_IVACantidPagar = ROUND((Var_SaldoMoratorios *  Var_ValIVAIntMo), 2);

      IF(ROUND(Var_SaldoPago,2) >= (Var_SaldoMoratorios + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   :=  Var_SaldoMoratorios;
      ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                       ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);

        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntMo)) * Var_ValIVAIntMo, 2);
      END IF;

        CALL  PAGCREMORAPRO (
            Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
            Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
            Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
            Des_PagoCred,       Var_CuentaAhoStr,   Var_SaldoMoratorios,Var_Poliza,			Par_Origen,
            Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
            Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
      UPDATE AMORTICREDITO Tem
      SET NumTransaccion = Aud_NumTransaccion
        WHERE AmortizacionID = Var_AmortizacionID
          AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;
    IF (Var_SaldoInteresVen >= Mon_MinPago) THEN

		SET Var_IVACantidPagar = ROUND(ROUND(Var_SaldoInteresVen,2) *  Var_ValIVAIntOr, 2);

		IF(ROUND(Var_SaldoPago,2) >= (ROUND(Var_SaldoInteresVen,2) + Var_IVACantidPagar)) THEN
			SET Var_CantidPagar   :=  Var_SaldoInteresVen;
		ELSE
			SET Var_CantidPagar   := Var_SaldoPago - ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
		END IF;

		CALL PAGCREINTVENPRO (
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
			Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Par_Origen,         Par_NumErr,
			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,   	Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;
    IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN

      SET Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_ValIVAIntOr), 2);

      IF(ROUND(Var_SaldoPago,2) >= (ROUND(Var_SaldoInteresAtr, 2) + Var_IVACantidPagar)) THEN
        SET Var_CantidPagar   :=  Var_SaldoInteresAtr;
      ELSE
        SET Var_CantidPagar   := Var_SaldoPago -
                       ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

        SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
      END IF;

		CALL PAGCREINTATRPRO (
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
			Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Par_Origen,		 	Par_NumErr,
			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,       Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;

    IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
      Var_ProyInPagAde = NO_ProyectInt AND Var_FechaExigible > Var_FechaSistema
      AND (
      Var_EstatusCre = Esta_Vigente
      OR (Var_EsReestruc = SI_EsReestruc AND
        Var_EstCreacion  = Esta_Vencido AND
        Var_Regularizado = No_Regulariza))) THEN

      SET Var_PagoAdeSinProy = ValorSI;

    END IF;

     -- se devenga interes proyectado cuando es un pago de cuota adelantado (NO Prepago, NI finiquito)
    IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
      Var_ProyInPagAde = SI_ProyectInt AND Var_FechaExigible > Var_FechaSistema
      AND (
      Var_EstatusCre = Esta_Vigente
      OR (	Var_EsReestruc = SI_EsReestruc AND
        	Var_EstCreacion  = Esta_Vencido AND
        	Var_Regularizado = No_Regulariza)
      OR
      	 (	Var_EsConsolidacionAgro = ValorSI AND
            Var_EstatusConsolidacion = Esta_Vencido AND
            Var_EsRegularizado = No_Regulariza )
      OR
      	 (	Var_EsConsolidacion = ValorSI AND
            Var_EstatusConsolidacion = Esta_Vencido AND
            Var_EsRegularizado = No_Regulariza ))) THEN

		CALL CREANTICIINTEREPRO(
			Var_CreditoID,      Var_EstatusCre,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Var_CreTasa,        Var_DiasCredito,    Var_FecAplicacion,
			Var_FechaSistema,   Var_Poliza,         Entero_Cero,      	Var_OrigenPago,		Var_IntAntici,
			Par_Origen,			Par_NumErr,        	Par_ErrMen,         Par_EmpresaID,      Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,   	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        IF Var_EstatusCre = Esta_Vigente THEN
            SET Var_SaldoInteresPro := Var_SaldoInteresPro + IFNULL(Var_IntAntici, Entero_Cero);
        ELSE
            SET Var_SaldoIntNoConta := Var_SaldoIntNoConta + IFNULL(Var_IntAntici, Entero_Cero);
        END IF;

    END IF;

    IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

		SET Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

		IF(ROUND(Var_SaldoPago,2) >= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
			SET Var_CantidPagar   :=  Var_SaldoInteresPro;
		ELSE
			SET Var_CantidPagar    := Var_SaldoPago - ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr,2);

			SET  Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
		END IF;

		CALL PAGCREINTPROPRO (
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
			Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Par_Origen,         Par_NumErr,
			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,       Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;

     -- Verificamos si Aplica Proyectar Intereses en Pago Adelantado de la Cuota
      IF(Par_EsPrePago = PrePago_NO AND Par_Finiquito = Finiquito_NO AND
          Var_ProyInPagAde = SI_ProyectInt AND Var_FechaExigible > Var_FechaSistema AND
          Var_EstatusCre = Esta_Vencido) THEN

		CALL CREANTICIINTEREPRO(
			Var_CreditoID,      Var_EstatusCre,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Var_CreTasa,        Var_DiasCredito,    Var_FecAplicacion,
			Var_FechaSistema,   Var_Poliza,         Entero_Cero,		Var_OrigenPago,		Var_IntAntici,
			Par_Origen,			Par_NumErr,			Par_ErrMen,         Par_EmpresaID,      Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion  );

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      SET Var_SaldoIntNoConta := Var_SaldoIntNoConta + IFNULL(Var_IntAntici, Entero_Cero);
    END IF;

    IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

		SET Var_IVACantidPagar = ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_ValIVAIntOr), 2);

		IF(ROUND(Var_SaldoPago,2) >= (ROUND(Var_SaldoIntNoConta, 2) + Var_IVACantidPagar)) THEN
			SET Var_CantidPagar   :=  Var_SaldoIntNoConta;
		ELSE
			SET Var_CantidPagar   := Var_SaldoPago - ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

			SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
		END IF;

		CALL PAGCREINTNOCPRO (
			Var_CreditoID,      Var_AmortizacionID,       Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,         Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
			Var_MonedaID,       Var_ProdCreID,            Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,         Var_Poliza,         Var_DivContaIng,    Par_Origen,
			Par_NumErr,         Par_ErrMen,               Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,          Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLO;
      END IF;

    END IF;

    IF (Var_SaldoCapVencido >= Mon_MinPago) THEN

		IF(ROUND(Var_SaldoPago,2) >= Var_SaldoCapVencido) THEN
			SET Var_CantidPagar   := Var_SaldoCapVencido;
		ELSE
			SET Var_CantidPagar   := ROUND(Var_SaldoPago,2);
		END IF;

		CALL PAGCRECAPVENPRO (
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
			Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalCapitales,   Par_Origen,
			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
		UPDATE AMORTICREDITO Tem
		SET NumTransaccion = Aud_NumTransaccion
		WHERE AmortizacionID = Var_AmortizacionID
			AND CreditoID = Par_CreditoID;

      SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

		IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN -- si el credito tiene linea de credito y si el pago es distinto de garantias agro
			IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si maneja linea de credito
				IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si es revolvente

					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible = IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;

					-- se genera la parte contable  solo cuando es revolvente
					IF(Var_Poliza = Entero_Cero)THEN
						SET Var_AltaPoliza  := AltaPoliza_SI;
					ELSE
						SET Var_AltaPoliza  := AltaPoliza_NO;
					END IF;

					IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
						SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
						SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
					END IF;

					-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						Var_AltaPoliza,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenDeu,
						Cadena_Vacia,		Nat_Cargo,		Nat_Cargo,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						AltaPoliza_NO,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenCor,
						Cadena_Vacia,		Nat_Abono, 		Nat_Abono,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDeudor		= IFNULL(SaldoDeudor, Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;
				END IF;
			END IF;
		END IF;

		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;
	END IF;

    IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

		IF(ROUND(Var_SaldoPago,2) >= Var_SaldoCapAtrasa) THEN
			SET Var_CantidPagar   := Var_SaldoCapAtrasa;
		ELSE
			SET Var_CantidPagar   := ROUND(Var_SaldoPago,2);
		END IF;

		CALL PAGCRECAPATRPRO (
			Var_CreditoID,      Var_AmortizacionID,   Var_FechaInicio,      Var_FechaVencim,		Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,     Var_FecAplicacion,    Var_CantidPagar,		Decimal_Cero,
			Var_MonedaID,       Var_ProdCreID,        Var_ClasifCre,        Var_SubClasifID,		Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,     Var_Poliza,           Var_SalCapitales,		Par_Origen,
			Par_NumErr,		  	Par_ErrMen,			  Par_Consecutivo,      Par_EmpresaID,			Par_ModoPago,
			Aud_Usuario,		Aud_FechaActual,      Aud_DireccionIP,      Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

		IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  /* si el credito tiene linea de credito y si el pago es distinto de garantias agro*/
			IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si maneja linea de credito*/
				IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  /* si es revolvente */

					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible	= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;

					-- se genera la parte contable  solo cuando es revolvente
					IF(Var_Poliza = Entero_Cero)THEN
						SET Var_AltaPoliza  := AltaPoliza_SI;
					ELSE
						SET Var_AltaPoliza  := AltaPoliza_NO;
					END IF;

					IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
						SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
						SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
					END IF;

					-- se manda a llamar a sp que genera los detalles contables de lineas de credito
					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						Var_AltaPoliza,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenDeu,
						Cadena_Vacia,		Nat_Cargo,		Nat_Cargo,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTALINEASCREPRO( -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						AltaPoliza_NO,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenCor,
						Cadena_Vacia,		Nat_Abono,		Nat_Abono,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;
				END IF;
			END IF;
		END IF;

		SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

    IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

      IF(Var_SaldoPago  >= Var_SaldoCapVigente) THEN
        SET Var_CantidPagar   := Var_SaldoCapVigente;
      ELSE
        SET Var_CantidPagar   := ROUND(Var_SaldoPago,2);
      END IF;

      CALL PAGCRECAPVIGPRO (
          Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
          Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
          Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
          Des_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalCapitales,   Par_Origen,
          Par_NumErr,		  Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
          Aud_Usuario,		  Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
          Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

		IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  -- si el credito tiene linea de credito y si el pago es distinto de garantias agro
			IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si maneja linea de credito
				IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si es revolvente

					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + ROUND(Var_CantidPagar,2),
						SaldoDisponible	= IFNULL(SaldoDisponible,Entero_Cero) + ROUND(Var_CantidPagar,2) ,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;

					-- se genera la parte contable  solo cuando es revolvente
					IF(Var_Poliza = Entero_Cero)THEN
						SET Var_AltaPoliza  := AltaPoliza_SI;
					ELSE
						SET Var_AltaPoliza  := AltaPoliza_NO;
					END IF;

					IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
						SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
						SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
					END IF;

					-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						Var_AltaPoliza,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenDeu,
						Cadena_Vacia,		Nat_Cargo,		Nat_Cargo,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						AltaPoliza_NO,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenCor,
						Cadena_Vacia,		Nat_Abono,		Nat_Abono,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;
				END IF;
			END IF;
		END IF;

		SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

	END IF;

    SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
    IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

		IF(Var_SaldoPago  >= Var_SaldoCapVenNExi) THEN
			SET Var_CantidPagar := Var_SaldoCapVenNExi;
		ELSE
			SET Var_CantidPagar := ROUND(Var_SaldoPago,2);
		END IF;

		CALL PAGCRECAPVNEPRO (
			Var_CreditoID,      Var_AmortizacionID,   Var_FechaInicio,      Var_FechaVencim,      Par_CuentaAhoID,
			Var_ClienteID,      Var_FechaSistema,     Var_FecAplicacion,    Var_CantidPagar,      Decimal_Cero,
			Var_MonedaID,       Var_ProdCreID,        Var_ClasifCre,        Var_SubClasifID,      Var_SucCliente,
			Des_PagoCred,       Var_CuentaAhoStr,     Var_Poliza,           Var_SalCapitales,     Par_Origen,
			Par_NumErr,         Par_ErrMen,           Par_Consecutivo,      Par_EmpresaID,        Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,      Aud_DireccionIP,      Aud_ProgramaID,       Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

      	-- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
        UPDATE AMORTICREDITO Tem
        SET NumTransaccion = Aud_NumTransaccion
          WHERE AmortizacionID = Var_AmortizacionID
            AND CreditoID = Par_CreditoID;

		IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN  -- si el credito tiene linea de credito y si el pago es distinto de garantias agro
			IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si maneja linea de credito
				IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si es revolvente

					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDisponible	= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;

					-- se genera la parte contable  solo cuando es revolvente
					IF(Var_Poliza = Entero_Cero)THEN
						SET Var_AltaPoliza  := AltaPoliza_SI;
					ELSE
						SET Var_AltaPoliza  := AltaPoliza_NO;
					END IF;

					IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
						SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
						SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
					END IF;

					-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
					CALL CONTALINEASCREPRO(  -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						Var_AltaPoliza,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenDeu,
						Cadena_Vacia,		Nat_Cargo,		Nat_Cargo,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTALINEASCREPRO( -- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
						Var_LineaCredito,	Entero_Cero,	Var_FechaSistema,	Var_FechaSistema,	Var_CantidPagar,
						Var_MonedaID,		Var_ProdCreID,	VarSucursalLin,		Des_PagoCred,		Var_LineaCredito,
						AltaPoliza_NO,		Coc_PagoCred,	AltaPolCre_SI,		AltaMovAho_NO,		ConcepCtaOrdenCor,
						Cadena_Vacia,		Nat_Abono,		Nat_Abono,			Salida_NO,			Par_NumErr,
						Par_ErrMen,			Var_Poliza,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

				ELSE
					UPDATE LINEASCREDITO SET
						Pagado			= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
						SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

						Usuario			= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID		= Aud_ProgramaID,
						Sucursal		= Aud_Sucursal,
						NumTransaccion	= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCredito;
				END IF;
			END IF;
		END IF;

      IF(Var_AmoEstatus != Esta_Vigente) THEN
        SET Var_NumPagSos = Entero_Cero;
		CALL REESTRUCCREDITOACT (
			Var_FechaSistema,   Var_CreditoID,      Entero_Cero,      Cadena_Vacia,     Cadena_Vacia,
			Entero_Cero,        Entero_Cero,        Var_NumPagSos,    Var_Poliza,       Act_PagoSost,
			Par_SalidaNO,     	Par_NumErr,         Par_ErrMen,       Par_EmpresaID,    Par_ModoPago,
			Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
			Aud_NumTransaccion);

		IF	(Par_NumErr <> Entero_Cero ) THEN
			LEAVE ManejoErrores;
	    END IF;
      END IF;

        IF( (Var_SaldoCapVenNExi - Var_CantidPagar) <= Tol_DifPago AND
            (Var_FechaExigible <= Var_FechaSistema AND Var_AmoEstatus = Esta_Vigente) ) THEN

            IF( (Var_EsReestruc = SI_EsReestruc AND Var_EstCreacion  = Esta_Vencido  AND Var_Regularizado = No_Regulariza) OR
                (Var_EsConsolidacionAgro = ValorSI AND Var_EstatusConsolidacion = Esta_Vencido AND Var_EsRegularizado = No_Regulariza) OR
                (Var_EsConsolidacion = ValorSI AND Var_EstatusConsolidacion = Esta_Vencido AND Var_EsRegularizado = No_Regulariza) ) THEN

          		SET Var_DiasAmor := (SELECT DATEDIFF(Var_FechaExigible, Var_FechaInicio));

          		IF(Var_DiasAmor >= DiasRegula)THEN
            		SET Var_NumPagSos := 3;
          		ELSE
            		SET Var_NumPagSos := Var_ResPagAct + 1;
            		IF( Var_EsConsolidacionAgro = ValorSI ) THEN
            			SET Var_NumPagSos := Var_NumPagosSostenidos + 1;
            		END IF;
            		IF ( Var_EsConsolidacion = ValorSI ) THEN
            			SET Var_NumPagSos := Var_NumPagosSostenidos + 1;
            		END IF;
          		END IF;

          		CALL REESTRUCCREDITOACT (
			        Var_FechaSistema,   Var_CreditoID,      Entero_Cero,      	Cadena_Vacia,     Cadena_Vacia,
			        Entero_Cero,        Entero_Cero,        Var_NumPagSos,    	Var_Poliza,       Act_PagoSost,
			        Par_SalidaNO,     	Par_NumErr,         Par_ErrMen,       	Par_EmpresaID,    Par_ModoPago,
			        Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
			        Aud_NumTransaccion);

			    IF	(Par_NumErr <> Entero_Cero ) THEN
        			LEAVE ManejoErrores;
			    END IF;
			END IF;
		END IF;

      		SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

      		IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        		LEAVE CICLO;
      		END IF;
    	END IF;

    END LOOP CICLO;
  END;
  CLOSE CURSORAMORTI;

  -- Verificamos si el Tipo de Cobro de la Comision por Falta de Pago es al Final de la Prelacion
  IF(ROUND(Var_SaldoPago,2) > Decimal_Cero AND Var_TipCobComFal = Cob_FalPagFinal) THEN
    OPEN CURSORCOMFALPAG;
    BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    CICLOFALPAG:LOOP

      FETCH CURSORCOMFALPAG INTO
        Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoComFaltaPa,    Var_MonedaID,
        Var_FechaInicio,        Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus;

      -- Inicializacion
      SET Var_CantidPagar   := Decimal_Cero;
      SET Var_IVACantidPagar  := Decimal_Cero;

      IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
        LEAVE CICLOFALPAG;
      END IF;

      IF( DATE_SUB(Var_FechaExigible, INTERVAL Var_DiasPermPagAnt DAY) > Var_FechaSistema AND
        Par_Finiquito = Finiquito_NO) THEN
        LEAVE CICLOFALPAG;
      END IF;

      IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN

        SET Var_IVACantidPagar = ROUND((Var_SaldoComFaltaPa *  Var_ValIVAGen), 2);

        IF(Var_SaldoPago  >= (Var_SaldoComFaltaPa + Var_IVACantidPagar)) THEN
          SET Var_CantidPagar   := Var_SaldoComFaltaPa;
        ELSE
          SET Var_CantidPagar   := ROUND(Var_SaldoPago,2) -
                         ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);

          SET Var_IVACantidPagar  := ROUND(((Var_SaldoPago)/(1+Var_ValIVAGen)) * Var_ValIVAGen, 2);
        END IF;

			CALL  PAGCRECOMFALPRO (
				Var_CreditoID,			Var_AmortizacionID,   Var_FechaInicio,      Var_FechaVencim,		Par_CuentaAhoID,
				Var_ClienteID,			Var_FechaSistema,     Var_FecAplicacion,    Var_CantidPagar,		Var_IVACantidPagar,
				Var_MonedaID,         	Var_ProdCreID,        Var_ClasifCre,      	Var_SubClasifID,		Var_SucCliente,
				Des_PagoCred,         	Var_CuentaAhoStr,     Var_Poliza,           Par_Origen,				Par_NumErr,
				Par_ErrMen,           	Par_Consecutivo,	  Par_EmpresaID,        Par_ModoPago,			Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,      Aud_ProgramaID,       Aud_Sucursal,           Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

          -- Registramos la Amortizacion que se Afecta en el Pago, para Posteriormente Verificar si la marcamos como Pagada
          UPDATE AMORTICREDITO Tem
          SET NumTransaccion = Aud_NumTransaccion
            WHERE AmortizacionID = Var_AmortizacionID
              AND CreditoID = Par_CreditoID;

        SET Var_SaldoPago := Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);

        IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
          LEAVE CICLOFALPAG;
        END IF;

      END IF;
      END LOOP CICLOFALPAG;
    END;
    CLOSE CURSORCOMFALPAG;
  END IF;

  SET Var_SaldoPago   := IFNULL(Var_SaldoPago, Entero_Cero);

  IF(Var_SaldoPago < Entero_Cero) THEN
    SET Var_SaldoPago   := Entero_Cero;
  END IF;

  SET Var_MontoPago  := Par_MontoPagar - ROUND(Var_SaldoPago,2);

  IF (Var_MontoPago <= Decimal_Cero) THEN
      SET Par_NumErr    := '100';
      SET Par_ErrMen    := 'El Credito no Presenta Adeudos.';
      SET Par_Consecutivo := 0;
      SET Var_Control   := 'creditoID';
  ELSE
	IF Var_PagoPerdCentRedond = ValorSI THEN
		CALL PAGCREAJUSTEPERDPRO(
			Par_CreditoID,		Par_CuentaAhoID,	Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,
			Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,		Var_SubClasifID,		Var_SucCliente,
			Var_Poliza,			Par_Origen,			ValorNO,			Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,	Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,        	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

    -- Amortizaciones que hayan Sido Afectada con el Pago Para evitar Marcar Como Pagadas, aquellas Amortizaciones
    -- Futuras que no Tienen Capital que son de Solo Interes
    UPDATE AMORTICREDITO Amo SET
      Amo.Estatus   = Esta_Pagado,
      Amo.FechaLiquida  = Var_FechaSistema
      WHERE (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi +
          Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro +
          Amo.SaldoIntNoConta + Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen +
          Amo.SaldoComFaltaPa +  Amo.SaldoComServGar + Amo.SaldoOtrasComis ) <= Tol_DifPago
        AND Amo.CreditoID   = Par_CreditoID
        AND Amo.Estatus   != Esta_Pagado
        AND Amo.NumTransaccion = Aud_NumTransaccion;

        -- Se obtiene el numero de amortizaciones atrasadas
        SET Var_NumeroAmort := (SELECT COUNT(*) FROM AMORTICREDITO
                WHERE Estatus = Esta_Atrasado
                                AND CreditoID = Par_CreditoID);
    SET Var_NumeroAmort := IFNULL(Var_NumeroAmort, Entero_Cero);

         -- Se obtiene la fecha de la primer amortizacion atrasada
        SET Var_FechaMinAtraso := (SELECT MIN(FechaExigible) FROM AMORTICREDITO
                  WHERE CreditoID =  Par_CreditoID
                                    AND Estatus = Esta_Atrasado);

        -- Se obtiene el ID de la primer amortizacion atrasada
        SET Var_AmortizacionIDAtr := (SELECT MIN(AmortizacionID) FROM AMORTICREDITO
                    WHERE CreditoID =  Par_CreditoID
                    AND Estatus = Esta_Atrasado);

    SET Var_FechaMinAtraso := IFNULL(Var_FechaMinAtraso, Fecha_Vacia);

    -- Se realiza la suma de capital atrasado e interes atrasado
        SELECT  SUM(SaldoCapAtrasa),  SUM(SaldoInteresAtr)
    INTO  Saldo_CapAtrasado,  Saldo_IntAtrasado
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID
            AND AmortizacionID = Var_AmortizacionIDAtr;

        -- Si el numero de amortizaciones es mayor a cero
    IF(Var_NumeroAmort > Entero_Cero) THEN
      -- Si el interes atrasado es mayor a acero y el capital atrasado es mayor a cero
      IF(Saldo_IntAtrasado > Entero_Cero AND Saldo_CapAtrasado > Entero_Cero) THEN
        -- Se actualiza la fecha de atraso de capital y la fecha de atraso del interes con la fecha de atraso de la primera amortizacion atrasada
        UPDATE CREDITOS SET
          FechaAtrasoCapital = Var_FechaMinAtraso,
          FechaAtrasoInteres = Var_FechaMinAtraso
          WHERE CreditoID = Par_CreditoID;
      END IF;

            -- Si el saldo del interes atrasado es igual a cero y el saldo del capital atrasado es mayor a cero
            IF(Saldo_IntAtrasado = Entero_Cero AND Saldo_CapAtrasado > Entero_Cero) THEN
        -- Solo se actualiza la fecha de atraso de capital
        UPDATE CREDITOS SET
          FechaAtrasoCapital = Var_FechaMinAtraso
          WHERE CreditoID = Par_CreditoID;

        -- Se obtiene la nueva fecha minima de atraso de la amortizacion que adeude interes atrasado
        SET Var_FechaMinAtraso  := (SELECT MIN(FechaExigible) FROM AMORTICREDITO
                      WHERE CreditoID =  Par_CreditoID
                      AND Estatus = Esta_Atrasado
                      AND SaldoInteresAtr != Entero_Cero);
        SET Var_FechaMinAtraso  := IFNULL(Var_FechaMinAtraso, Fecha_Vacia);
                # Se actualiza la fecha de atraso de interes
        UPDATE CREDITOS SET
          FechaAtrasoInteres = Var_FechaMinAtraso
          WHERE CreditoID = Par_CreditoID;
      END IF;
            -- Si el saldo de capital atrasado es igual a cero y el interes atrasado es mayor a cero
            IF(Saldo_CapAtrasado = Entero_Cero AND Saldo_IntAtrasado > Entero_Cero) THEN

        SET Var_FechaMinAtraso  := (SELECT MIN(FechaExigible) FROM AMORTICREDITO
                      WHERE CreditoID =  Par_CreditoID
                      AND Estatus = Esta_Atrasado
                      AND SaldoInteresAtr != Entero_Cero);
        SET Var_FechaMinAtraso  := IFNULL(Var_FechaMinAtraso, Fecha_Vacia);
                -- Se actualiza la fecha de atraso del interes
        UPDATE CREDITOS SET
          FechaAtrasoInteres = Var_FechaMinAtraso
          WHERE CreditoID = Par_CreditoID;
      END IF;

    ELSE
       UPDATE CREDITOS SET
          FechaAtrasoCapital = Fecha_Vacia,
          FechaAtrasoInteres = Fecha_Vacia
          WHERE CreditoID = Par_CreditoID;
        END IF;

    -- Si es un Finiquito Marcamos las cuotas como Pagadas
    IF( Par_Finiquito = Finiquito_SI) THEN
      IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
        UPDATE AMORTICREDITO Amo SET
          Amo.Estatus     = Esta_Pagado,
          Amo.FechaLiquida  = Var_FechaSistema
        WHERE Amo.CreditoID   = Par_CreditoID
          AND Amo.Estatus   != Esta_Pagado;

                  UPDATE CREDITOS SET
          FechaAtrasoCapital = Fecha_Vacia,
          FechaAtrasoInteres = Fecha_Vacia
          WHERE CreditoID = Par_CreditoID;
      END IF;
      IF(Var_TipoLiquidacion = LiquidacionParcial) THEN

        UPDATE AMORTICREDITO Amo SET
          Amo.Estatus     = Esta_Pagado,
          Amo.FechaLiquida  = Var_FechaSistema
        WHERE Amo.CreditoID   = Par_CreditoID
          AND (Amo.Estatus  = Esta_Vencido OR Amo.Estatus   = Esta_Atrasado);

        UPDATE CREDITOS SET
        FechaAtrasoCapital = Fecha_Vacia,
        FechaAtrasoInteres = Fecha_Vacia
        WHERE CreditoID = Par_CreditoID;

            END IF;
    END IF;

    SELECT COUNT(AmortizacionID) INTO Var_NumAmoPag
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID
        AND Estatus = Esta_Pagado;
    SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

      SELECT COUNT(AmortizacionID) INTO Var_NumAmorti
      FROM AMORTICREDITO
      WHERE CreditoID = Par_CreditoID;

    SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);

    IF (Var_NumAmorti = Var_NumAmoPag) THEN

      UPDATE CREDITOS SET
        Estatus     = Esta_Pagado,
        FechTerminacion = Var_FechaSistema,

        Usuario   = Aud_Usuario,
        FechaActual   = Aud_FechaActual,
        DireccionIP   = Aud_DireccionIP,
        ProgramaID    = Aud_ProgramaID,
        Sucursal    = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
      WHERE CreditoID = Par_CreditoID;


            SET Var_MontoCont := (SELECT ComAperCont FROM CREDITOS WHERE CreditoID = Par_CreditoID);
            -- Se verifica si aun tiene Saldo de Comision pendiente por contabilizar
      IF(Var_MontoCont>Decimal_Cero) THEN
        -- Si el monto de la Comision por apertura es mayor que cero, se procede a generar los asientos contables
        IF(Var_MontoComAp > Decimal_Cero)THEN

          SET Var_MontoAmort    := ROUND(Var_MontoCont,2);  # Obtiene el monto que se abona a la cuenta de Com. por Apert

          -- Se realiza el CARGO a la cuenta Puente (Gasto)
           CALL CONTACREDITOSPRO (
	            Par_CreditoID,		Entero_Cero,			Entero_Cero,			Entero_Cero,		Var_FechaSistema,
	            Var_FechaSistema,	Var_MontoAmort,			Var_MonedaID,			Var_ProdCreID,		Var_ClasifCre,
	            Var_SubClasifID,	Var_SucCliente,			Var_DescComAper,		Cadena_Vacia,		AltaPoliza_NO,
	            Entero_Cero,		Var_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,		Con_ContGastos,
	            Entero_Cero,		Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,
	            Par_Origen,			Par_SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
	            Par_EmpresaID,		Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	            Ref_PagAnti,		Aud_Sucursal,			Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;


          -- Se realiza el ABONO a la cuenta de Comision por Apertura de Credito
          CALL CONTACREDITOSPRO (
	            Par_CreditoID,			Entero_Cero,			Entero_Cero,			Entero_Cero,		Var_FechaSistema,
	            Var_FechaSistema,		Var_MontoAmort,			Var_MonedaID,			Var_ProdCreID,		Var_ClasifCre,
	            Var_SubClasifID,		Var_SucCliente,			Var_DescComAper,		Cadena_Vacia,		AltaPoliza_NO,
	            Entero_Cero,			Var_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,		Con_ContComApe,
	            Entero_Cero,			Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,
	            Par_Origen,				Par_SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
	            Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
	            Ref_PagAnti,			Aud_Sucursal,			Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

          -- Actualizando el Campo ComAperCont para disminuir lo que ya ha sido contabilizado
          UPDATE CREDITOS SET
            ComAperCont = ComAperCont - Var_MontoAmort
            WHERE CreditoID= Par_CreditoID;

        END IF;

      END IF;

      SELECT Garantizado, LiberarGaranLiq
        INTO Var_ProdUsaGarLiq, Var_LiberaAlLiquidar
        FROM PRODUCTOSCREDITO
        WHERE ProducCreditoID = Var_ProdCreID;

       -- Obtiene los valores de las garantias y si permiten bonificacion
      SELECT RequiereGarantia, Bonificacion, RequiereGarFOGAFI,   BonificacionFOGAFI, LiberaGarLiq
        INTO Var_ReqGarLiq, Var_BonoGarLiq, Var_ReqFOGAFI,    Var_BonoFOGAFI,   Var_LiberaGarFOGAFI
      FROM DETALLEGARLIQUIDA
      WHERE CreditoID = Par_CreditoID;

      SET Var_ReqGarLiq     := IFNULL(Var_ReqGarLiq, Cadena_Vacia);
      SET Var_LiberaGarFOGAFI   := IFNULL(Var_LiberaGarFOGAFI, Cadena_Vacia);

      IF(Var_ReqGarLiq = Cadena_Vacia) THEN
        SET Var_ProdUsaGarLiq := IFNULL(Var_ProdUsaGarLiq, ValorNO);
      ELSE
        SET Var_ProdUsaGarLiq   := Var_ReqGarLiq;
            END IF;

      IF(Var_LiberaGarFOGAFI = Cadena_Vacia) THEN
        SET Var_LiberaAlLiquidar  := IFNULL(Var_LiberaAlLiquidar, ValorNO);
      ELSE
        SET Var_LiberaAlLiquidar  := Var_LiberaGarFOGAFI;
            END IF;

      SET Var_ReqFOGAFI := IFNULL(Var_ReqFOGAFI, ValorNO);

      -- Desbloqueamos el Monto de la Garantia Liquida, si Condiciones =SI
      IF(Var_ProdUsaGarLiq = ValorSI)THEN
        IF(Var_LiberaAlLiquidar = ValorSI)THEN
          SET Par_NumErr :=0;
          CALL LIBERAGARANTIALIQPRO(
              Par_CreditoID,    Var_Poliza,   Par_SalidaNO,   	Par_NumErr,     	Par_ErrMen,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  	Aud_ProgramaID,
              Aud_Sucursal,   	Aud_NumTransaccion );

          SET Entero_Cero := 0;
          IF(Par_NumErr <> Entero_Cero)THEN
              SET Par_NumErr    := '101';
              SET Par_ErrMen    := Par_ErrMen;
              SET Par_Consecutivo := 0;
            LEAVE ManejoErrores;
          END IF;
        END IF;-- Si libera Automaticamente
      END IF;-- Si requiere GL

            -- Se libera la Garantia FOGAFI
      IF(Var_CobraGarantiaFinanciada = Cons_Si )THEN
        IF(Var_ReqFOGAFI = ValorSI)THEN
          IF(Var_LiberaAlLiquidar = ValorSI)THEN
            -- Valida si se cobra garantía financiada para poder realizar la liberacion de la garantia FOGAFI
            CALL LIBERAGARFOGAFIPRO(
              Par_CreditoID,    Var_Poliza,   Par_SalidaNO,   	Par_NumErr,     	Par_ErrMen,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  	Aud_ProgramaID,
              Aud_Sucursal,   	Aud_NumTransaccion );

            IF(Par_NumErr != Entero_Cero)THEN
              LEAVE ManejoErrores;
            END IF;
          END IF;-- Si libera Automaticamente
        END IF;-- Si requiere GARFOGAFI
      END IF;

      -- se revisa si estaba comprometida con creditos se liberan anticipadamente
      SET Var_InverEnGar  := (SELECT COUNT(CreditoID)
                    FROM CREDITOINVGAR
                    WHERE CreditoID = Par_CreditoID);
      SET Var_InverEnGar  := IFNULL(Var_InverEnGar, Entero_Cero);

      IF(Var_InverEnGar >Entero_Cero)THEN -- si la inversion esta respaldando algun credito se liberan
      CALL CREDITOINVGARACT(
          Entero_Cero,    	Par_CreditoID,    	Entero_Cero,  		Var_Poliza,     Act_LiberarPagCre,
          Par_SalidaNO,  	Par_NumErr,     	Par_ErrMen,   		Par_EmpresaID,   Aud_Usuario,
          Aud_FechaActual,  Aud_DireccionIP,  	Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion
        );
        IF(Par_NumErr <> Entero_Cero)THEN
            SET Par_NumErr    := '101';
            SET Par_ErrMen    := Par_ErrMen;
            SET Par_Consecutivo := 0;
          LEAVE ManejoErrores;
        END IF;
      END IF;

      -- Valida si se cobra garantía financiada
      IF(Var_CobraGarantiaFinanciada=Cons_Si)THEN

        -- Valida si se quiere alguna de las garantias y una de ellas permite bonificación, ejecuta el proceso de bonificación
        IF( (Var_ReqGarLiq=Cons_Si AND Var_BonoGarLiq=Cons_Si) OR ( Var_ReqFOGAFI=Cons_Si AND  Var_BonoFOGAFI=Cons_Si) )THEN

          CALL BONIFICACREDITOPRO(
              Var_Poliza,       	Par_CreditoID,    	Var_ClienteID,    	Par_CuentaAhoID,    Var_FechaSistema,
              Var_FechaSistema,   	Par_MonedaID,   	Par_SalidaNo,   	Par_NumErr,			Par_ErrMen,
              Par_EmpresaID,      	Aud_Usuario,    	Aud_FechaActual,  	Aud_DireccionIP,    Aud_ProgramaID,
              Aud_Sucursal,     	Aud_NumTransaccion);

          IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
          END IF;

        END IF;

      END IF;

    ELSEIF (Var_EstatusCre = Esta_Vencido OR Var_CantAmoVenSusp > Entero_Cero) THEN
      IF ( Var_EsReestruc   = SI_EsReestruc AND Var_EstCreacion  = Esta_Vencido AND Var_Frecuencia = Frec_Unico ) THEN
        -- Regularizacion del Credito
        SET Var_MontoPagado := (SELECT (Var_MontoCredito) - (SaldoCapVigent +
                        SaldoCapAtrasad +
                        SaldoCapVencido + SaldCapVenNoExi)
                      FROM CREDITOS
                        WHERE CreditoID   = Par_CreditoID);

        IF(Var_MontoPagado >= Var_PorcMontoCred) THEN

			CALL REGULARIZACREDPRO (
				Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,    	Var_Poliza,     Par_EmpresaID,
				Par_SalidaNO,       Par_NumErr,         Par_ErrMen,       	Par_ModoPago, 	Aud_Usuario,
				Aud_FechaActual,  	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,   Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;


      END IF;


      SELECT  COUNT(AmortizacionID) INTO Var_NumAmoExi
        FROM AMORTICREDITO
        WHERE CreditoID   = Par_CreditoID
          AND Estatus   != Esta_Pagado
          AND FechaExigible < Var_FechaSistema;
      SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);

      IF (Var_NumAmoExi = Entero_Cero) THEN

        IF ( ( Var_EsReestruc = No_EsReestruc AND Var_EsConsolidacion = ValorNO) OR

           ( Var_EsReestruc   = SI_EsReestruc AND
             Var_EstCreacion  = Esta_Vigente) OR

           ( Var_EsReestruc   = SI_EsReestruc AND
             Var_EstCreacion  = Esta_Vencido AND
             Var_Regularizado = Si_Regulariza) OR

             ( Var_EsConsolidacionAgro = ValorSI AND
               Var_EstatusConsolidacion = Esta_Vencido AND
               Var_EsRegularizado = Si_Regulariza) OR

             ( Var_EsConsolidacion = ValorSI AND
               Var_EstatusConsolidacion = Esta_Vencido AND
               Var_EsRegularizado = Si_Regulariza) OR

             (Var_EsConsolidacion = ValorSI AND
               Var_EstatusConsolidacion = Esta_Vigente) ) THEN

        		CALL REGULARIZACREDPRO (
                    Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,    Var_Poliza,     Par_EmpresaID,
                    Par_SalidaNO,       Par_NumErr,         Par_ErrMen,       Par_ModoPago,   Aud_Usuario,
            		Aud_FechaActual,  	Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

        		IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
              END IF;
      END IF;
    END IF;

    IF(Var_ProgOriginalID != Prog_Reestructura) THEN
		CALL CONTAAHOPRO (
			Par_CuentaAhoID,  Var_CueClienteID, Aud_NumTransaccion, Var_FechaSistema, Var_FecAplicacion,
			Nat_Cargo,        Var_MontoPago,    Des_PagoCred,       Var_CreditoStr,   Aho_PagoCred,
			Var_MonedaID,     Var_SucCliente,   AltaPoliza_NO,      Entero_Cero,      Var_Poliza,
			AltaMovAho_SI,    Con_AhoCapital,   Nat_Cargo,          Par_Consecutivo,  Par_SalidaNO,
			Par_NumErr,       Par_ErrMen,       Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
			Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,       Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

       	CALL DEPOSITOPAGOCREPRO (
	        Par_CreditoID,    	Var_MontoPago,  Var_FechaSistema,   Par_EmpresaID,    	Par_SalidaNO,
	        Par_NumErr,     	Par_ErrMen,   	Par_Consecutivo,    Aud_Usuario,    	Aud_FechaActual,
	        Aud_DireccionIP,  	Aud_ProgramaID, Aud_Sucursal,     	Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

    IF(Par_RespaldaCred = Cons_Si) THEN
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion, Par_CuentaAhoID,  	Par_CreditoID,  Var_MontoPago,    Par_NumErr,
			Par_ErrMen,     	Par_EmpresaID,    	Aud_Usuario,  	Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID,   	Aud_Sucursal,   	Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

  END IF;

  -- Si se pago Adelantadamente SIN proyectar los intereses, entonces lo tratamos
  -- Como un prepago y Recalculamos los intereses de la Tabla de Amortizacion
  IF (Var_PagoAdeSinProy = ValorSI) THEN-- Actualizacion de los intereses

    -- Actualizacion de los intereses
    IF(Var_Refinancia = Cons_Si) THEN
      	-- Recalculo de intereses con refinanciamiento
		CALL AMORTICREDITOAGROACT(
			Par_CreditoID,    	TipoActInteres,     FechaReal,        Par_SalidaNO,     Par_NumErr,
			Par_ErrMen,     	Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID,   	Aud_Sucursal,     	Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
    ELSE
    	-- Recalculo de intereses sin refinanciamiento
		CALL AMORTICREDITOACT(
			Par_CreditoID,    TipoActInteres,     	Par_SalidaNO,     Par_NumErr,     	Par_ErrMen,
			Par_EmpresaID,    Aud_Usuario,    		Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;
  END IF;

  -- Si el pago fue por referencia
  IF(Var_PagoXReferencia = Cons_Si AND Par_ModoPago = Con_CargoCta) THEN
	CALL PAGOXREFERENCIAACT(
		Aud_NumTransaccion,     Par_CreditoID,    	Par_CuentaAhoID,    Var_ClienteID,  	Var_ReferenciaPago,
		Par_MontoPagar,       	Var_Cue_Saldo,    	Var_FechaSistema,   2,        			Par_Origen,
		Con_NO,            		Par_NumErr,     	Par_ErrMen,       	Par_EmpresaID,  	Aud_Usuario,
		Aud_FechaActual,      	Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal, 		Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;
  END IF;


  SET Var_EjecucionCobAut     := IFNULL(FNPARAMGENERALES(Llave_EjecucionCobAut), Con_NO);
  SET Var_EjecucionCobAutRef  := IFNULL(FNPARAMGENERALES(Llave_EjecucionCobAutRef), Con_NO);

  IF( Var_EjecucionCobAut = Con_SI OR Var_EjecucionCobAutRef = Con_SI ) THEN

    IF( Var_EjecucionCobAut = Con_SI ) THEN
    	SET Var_OperacionPeticionID := Pro_CobranzaAutomatica;
  	END IF;

    IF( Var_EjecucionCobAutRef = Con_SI ) THEN
      SET Var_OperacionPeticionID := Pro_CobranzaAutomaticaRef;
    END IF;

	CALL ISOTRXTARNOTIFICAALT(
		Inst_Credito,       Par_CreditoID,    Aud_NumTransaccion,   Var_OperacionPeticionID,  Entero_Cero,
		Salida_NO,          Par_NumErr,       Par_ErrMen,           Par_EmpresaID,            Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,       Aud_Sucursal,             Aud_NumTransaccion);

	IF( Par_NumErr != Entero_Cero ) THEN
		LEAVE ManejoErrores;
	END IF;
  END IF;

  -- Proceso: Nomina
  -- Se valida si tiene Monto a Aplicar aquellos Creditos que son de Nomina y que provienen de un Proceso Diferente al de Nomina
  IF(Par_Origen IN (Con_SPEI, Con_Ventanilla, Con_CargoCta, Con_Automatica))THEN
	CALL DESCNOMINAREALPRO(
		Par_CreditoID,        Salida_NO,          Par_NumErr,         Par_ErrMen,               Par_EmpresaID,
		Aud_Usuario,          Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,           Aud_Sucursal,
		Aud_NumTransaccion );

	IF( Par_NumErr != Entero_Cero ) THEN
		LEAVE ManejoErrores;
	END IF;
  END IF;

	-- EJECUTA PROCESO DE DETECCION DE OPERACIONES INUSUALES AL MOMNETO DE LA TRANSACCIÓN POR PAGO DE CREDITO
	CALL PLDOPEINUSALERTTRANSPRO(
		TipoOperPLDCredito,		Var_ClienteID,			Par_CuentaAhoID,		Cadena_Vacia,			Cadena_Vacia,
		Par_CreditoID,
		Salida_NO,         		Par_NumErr,           	Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
		Aud_FechaActual,     	Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
	);

	IF(Par_NumErr <> Entero_Cero)THEN
		CALL BITAERRORPLDDETOPETRANALT(
			'PLDOPEINUSALERTTRANSPRO',	Par_NumErr,				Par_ErrMen,				TipoOperPLDCredito,		Var_ClienteID,
            Par_CreditoID,				Cadena_Vacia,			Par_MontoPagar,
			Salida_NO,         			Par_NumErr,           	Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
			Aud_FechaActual,     		Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
        );
	END IF;

	-- Se valida la poliza cuando el pago es cargo a cuenta
	IF( Par_Origen = Con_CargoCta ) THEN
		-- Se realiza la suma de los CARGOS y ABONOS de la Poliza
		SELECT ROUND(SUM(Cargos),2), ROUND(SUM(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
		FROM DETALLEPOLIZA
		WHERE PolizaID = Var_Poliza;

		SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Decimal_Cero);
		SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Decimal_Cero);

		IF(Var_CargosPoliza > Decimal_Cero OR Var_AbonosPoliza > Decimal_Cero)THEN
			IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza OR (Var_CargosPoliza + Var_AbonosPoliza) = Decimal_Cero)THEN
				SET Par_NumErr 	:= 01;
				SET Par_ErrMen	:= CONCAT("Poliza Descuadrada ",Var_CargosPoliza ,' - ',Var_AbonosPoliza);
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

  SET Par_NumErr    := '000';
  SET Par_ErrMen    := 'Pago Aplicado Exitosamente';
  SET Par_Consecutivo := 0;
  SET Var_Control   := 'creditoID';

END ManejoErrores;

IF (Par_Salida = ValorSI) THEN
  SELECT  Par_NumErr AS NumErr,
	      Par_ErrMen AS ErrMen,
	      Var_Control AS Control,
	      Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$

