-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDAGROALT`;
DELIMITER $$

CREATE PROCEDURE `REESTRUCCREDAGROALT`(
# ==================================================================================================================
# ---------------------- SP PARA DAR DE ALTA UNA REESTRUCTURA DE CREDITO ACTIVO AGRO  -----------------------------
# ==================================================================================================================
	Par_FechaRegistro		DATE,			-- Fecha de alta del tratamiento al credito
	Par_UsuarioID 			INT(11),		-- Usuario que registra el tratamiento al credito
	Par_CreditoOrigenID		BIGINT(12),		-- Credito a renovar o reestructurar
	Par_CreditoDestinoID 	BIGINT(12),		-- Credito renovador o reestructurador
	Par_SaldoCredAnteri		DECIMAL(12,2), 	-- Saldo del credito origen

	Par_EstatusCredAnt	 	CHAR(1),		-- Estatus del credito origen en el momento de sus tratamiento
	Par_EstatusCreacion		CHAR(1),		-- Estatus con el que nace el credito destino, V=vigente, B=vencido
	Par_NumDiasAtraOri		INT(11),		-- Numero de dias de atrado del credito origen
	Par_NumPagoSoste 		INT(11),		-- Numero de pagos sostenidos que se aplicaran al credito destino para su regularizacion
	Par_NumPagoActual 		INT(11),		-- Numero de pagos sostenidos aplicados a la fecha al credito destino

	Par_Regularizado 		CHAR(1),		-- Indica si el credito destino esta regualarizado o no
	Par_FechaRegula 		DATE,			-- Fecha en la el credito destino alcanza su regularizacion
	Par_NumeroReest 		INT(11), 		-- Numero de tratamientos aplicados al mismo credito
	Par_ReservaInteres		DECIMAL(14,2),	-- Monto de EPRC para interes en cuentas de orden
	Par_SaldoInteres		DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito

	Par_SaldoInteresMora	DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito
	Par_SaldoComisiones		DECIMAL(14,2),	-- Saldo del Interes refinanciado con el tratamiento al credito
	Par_Origen 				CHAR(1),		-- Tipo de Tratamiento: O= Renovacion, R= Reestructura
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_NomControl		CHAR(20);
	DECLARE Var_CreEstatus      CHAR(1);
	DECLARE Var_SalInteres      DECIMAL(14,2);
	DECLARE Var_Reserva         DECIMAL(14,2);
	DECLARE Var_EstRelacionado	CHAR(1);
	DECLARE Var_PeriodCap		INT(11);
	DECLARE Var_GrupoID     	INT;
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_Relacionado		BIGINT(12);
	DECLARE Var_TotalAdeudo		DECIMAL(14,2);
	DECLARE Var_TotalAdeudoCap	DECIMAL(14,2);
	DECLARE Var_TotalAdeudoInt	DECIMAL(14,2);
	DECLARE Var_TotalAdeudoMora	DECIMAL(14,2);
	DECLARE Var_TotalAdeudoCom	DECIMAL(14,2);
	DECLARE Var_AdeudoInt		DECIMAL(14,2);
	DECLARE Var_AdeudoMora		DECIMAL(14,2);
	DECLARE Var_AdeudoCom		DECIMAL(14,2);
	DECLARE Var_ValIVAIntOr		DECIMAL(12,2);
	DECLARE Var_ValIVAIntMo		DECIMAL(12,2);
	DECLARE Var_ValIVAGen		DECIMAL(12,2);
	DECLARE Var_IVASucurs       DECIMAL(8, 4);
	DECLARE Var_CliPagIVA		CHAR(1);
	DECLARE Var_IVAIntOrd		CHAR(1);
	DECLARE Var_IVAIntMor		CHAR(1);
	DECLARE Var_SucursalCte		INT(11);
	DECLARE Var_Tratamiento		VARCHAR(20);
	DECLARE Var_NumMaxDiasMora	INT(11);
	DECLARE Var_EsReestructura	CHAR(1);
	DECLARE Var_EstatusReest	CHAR(1);
	DECLARE Var_SolicitudCreditoID BIGINT(20);
	DECLARE Var_NumTransacSim	BIGINT;
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_NumAmorti		INT(11);
    DECLARE Var_NumAmorInt		INT(11);
	DECLARE Var_CreditoID       BIGINT(12);
	DECLARE Var_AmortizID       INT;
	DECLARE Var_Cantidad        DECIMAL(14,2);
	DECLARE Var_TipoMovCred		INT;
    DECLARE Var_ConContCred		INT(11);
	DECLARE Var_Consecutivo     BIGINT;
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_CuentaAhoStr    VARCHAR(20);
    DECLARE	Var_FechaInicio		DATE;
    DECLARE	Var_FechaInicioAmor DATE;
	DECLARE Var_TipoPagoCapital CHAR(1);
	DECLARE Var_FrecuenciaCap	CHAR(1);
    DECLARE	Var_FrecuenciaInt	CHAR(1);
	DECLARE	Var_PeriodicidadCap INT;
	DECLARE	Var_PeriodicidadInt INT;
	DECLARE Var_DiaMesCapital	INT;
	DECLARE Var_DiaMesInteres   INT;
	DECLARE	Var_MontoCuota		DECIMAL(14,2);
	DECLARE Var_ValorCAT		DECIMAL(14,4);
    DECLARE Var_SucCliReest		INT(11);
    DECLARE Var_ProdCreID		INT(11);
    DECLARE Var_ClasifCre		CHAR(1);
    DECLARE Var_SubClasifID 	INT(11);
    DECLARE Var_EstatusAmor		CHAR(1);
    DECLARE Var_FechaSistema	DATE;
	DECLARE Var_AmoCredStr      VARCHAR(30);
    DECLARE Var_Poliza			BIGINT(20);
    DECLARE Var_SalCapVig		DECIMAL(14,2);
    DECLARE Var_SaldCapAtr		DECIMAL(14,2);
    DECLARE Var_SaldCapVen		DECIMAL(14,2);
    DECLARE Var_SaldCapVenNoEx	DECIMAL(14,2);
    DECLARE Var_MontoOpera		DECIMAL(14,2);
    DECLARE Var_MontoConta		DECIMAL(14,2);
    DECLARE Var_MontoIVAComCont	DECIMAL(14,2);
    DECLARE Var_TipoConsultaSIC	CHAR(2);
    DECLARE Var_FolioConsultaBC	VARCHAR(30);
    DECLARE Var_FolioConsultaCC VARCHAR(30);
    DECLARE Var_NumReestr		INT(11);		-- Numero de Reestructuras
    DECLARE Var_ConsecutivRes	BIGINT(20);		-- Numer Consecutivo

	DECLARE Var_TipoCredito		CHAR(1);
	DECLARE Var_MontoPago       DECIMAL(14,2);
	DECLARE Var_PagoAplica      DECIMAL(14,2);
	DECLARE Par_Consecutivo     BIGINT;
	DECLARE MontoCred           DECIMAL(14,2);
	DECLARE	Var_MontoComAp		DECIMAL(14,2);
	DECLARE Var_IVAComAp  		DECIMAL(14,2);
	DECLARE Var_MontoSegVida	DECIMAL(14,2);
	DECLARE PrePago_NO          CHAR(1);
	DECLARE Finiquito_SI        CHAR(1);
	DECLARE Var_CargoCuenta		CHAR(1); -- Indica que se trata de un pago con cargo a cuenta
	DECLARE Str_NumErr          CHAR(3);
	DECLARE Var_RelaEstatus 	CHAR(1);
	DECLARE EstatusPagado       CHAR(1);
    DECLARE Var_NumAmortVig		INT(11);		-- Numero de Amortizaciones Vigentes
	DECLARE Var_LineaCreditoID		BIGINT(20);		-- Linea de Credito
	DECLARE Var_ManejaComAdmon		CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq	CHAR(1);		-- Comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon		CHAR(1);		-- Forma de Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición
	DECLARE Var_MontoPagComAdmon	DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administración
	DECLARE Var_ManejaComGarantia	CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq	CHAR(1);		-- Comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_MontoPagComGarantia	DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_FechaUltimoCobro	DATE;			-- Fecha de Ultimo cobro de Comision
	DECLARE Var_MontoComisionPago	DECIMAL(14,2);	-- Monto de Comision de Pago
	DECLARE Var_RegistroID			INT(11);		-- Numero de Registro
	DECLARE Var_MontoSolicitado		DECIMAL(14,2);
	DECLARE Var_EsAgropecuario		CHAR(1);
	DECLARE Var_SucursalLin			INT(11);
	DECLARE Var_LineaCreditoOriginalID	INT(11);
	DECLARE Var_TasaFija		DECIMAL(8,4);	-- Tasa de Interes

	# Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Var_SI          	CHAR(1);
	DECLARE Var_NO          	CHAR(1);
	DECLARE Estatus_Cancela     CHAR(1);
	DECLARE Estatus_Pagado      CHAR(1);
	DECLARE EstaInactivo    	CHAR(1);
	DECLARE EstaAutoriza    	CHAR(1);
	DECLARE SalidaSI        	CHAR(1);
	DECLARE SalidaNO        	CHAR(1);
	DECLARE OrigenReestructura	CHAR(1);
	DECLARE OrigenRenovacion	CHAR(1);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Vencido		CHAR(1);
	DECLARE Estatus_Atrasado	CHAR(1);
	DECLARE Estatus_Desembolso  CHAR(1);
	DECLARE Estatus_Alta 		CHAR(1);
	DECLARE Estatus_Autorizado	CHAR(1);
	DECLARE CalendarioReestruc	INT(11);
	DECLARE Mov_CapVigente      INT(11);
	DECLARE Mov_CapVeNoExi      INT(11);
    DECLARE Mov_CapAtrasado		INT(11);
    DECLARE Mov_CapVencido		INT(11);
	DECLARE Con_CapVigente 		INT(11);
	DECLARE Con_CapAtrasado		INT(11);
	DECLARE Con_CapVencido		INT(11);
	DECLARE Con_CapVeNoExi 		INT(11);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE DescripcionMov		VARCHAR(100);
	DECLARE PagLibres			CHAR(1);
    DECLARE AltaPoliza_SI   	CHAR(1);
    DECLARE AltaPoliza_NO   CHAR(1);
	DECLARE AltaPolCre_NO   CHAR(1);
	DECLARE AltaPolCre_SI   CHAR(1);
	DECLARE AltaMovAho_SI   CHAR(1);
	DECLARE AltaMovAho_NO   CHAR(1);
	DECLARE AltaMovCre_SI   CHAR(1);
	DECLARE AltaMovCre_NO   CHAR(1);
	DECLARE Nat_Abono       CHAR(1);
	DECLARE OrigenPagoRees		CHAR(1);
    DECLARE Pro_PasoVenc		INT(11);
	DECLARE ConcReestrRen		INT(11);
    DECLARE Tol_DifPago			DECIMAL(10,4);
	DECLARE Con_Origen		CHAR(1);
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Con_NO							CHAR(1);		-- Constante NO
	DECLARE Tip_Disposicion					CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total						CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota						CHAR(1);		-- Constante Cada Cuota
	DECLARE	Tip_ComAdmon					CHAR(1);		-- Constante Tipo Comision Admon
	DECLARE	Tip_ComGarantia					CHAR(1);		-- Constante Tipo Comision Garantia
	DECLARE Con_Deduccion					CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado					CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DesForCobCom				VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision
	DECLARE Con_DesIvaForCobCom				VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision
	DECLARE Con_CarComAdmonLinCred			INT(11);		-- Concepto Cartera Comision por Admon por Linea Credito Agro
	DECLARE Con_CarComAdmonDisLinCred		INT(11);		-- Concepto Cartera Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarIvaComAdmonDisLinCred	INT(11);		-- Concepto Cartera IVA Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarComGarDisLinCred			INT(11);		-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE SiPagaIVA						CHAR(1);
	DECLARE Var_PagIVA						CHAR(1);
	DECLARE Var_IVALineaCredito				DECIMAL(14,2);	-- IVA de Linea de Credito
	DECLARE Tip_MovComAdmonDisLinCred		INT(11);		-- Tipo Movimiento Credito Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Tip_MovIVAComAdmonDisLinCred	INT(11);		-- Tipo Movimiento Credito IVA Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Entero_Uno						INT(11);
	DECLARE Con_CarCtaOrdenDeuAgro			INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE Con_CarCtaOrdenCorAgro			INT(11);		-- Concepto Cuenta Ordenante Corte Agro
	DECLARE Var_ForPagComAdmon				CHAR(1);		-- Forma de Pago Comision por Admon
	DECLARE Var_PorcentajeComAdmon			DECIMAL(6,2);	-- Porcentaje de Admon
	DECLARE Var_ForCobComGarantia			CHAR(1);		-- Forma de Cobro Comision por Garantia
	DECLARE Var_ForPagComGarantia			CHAR(1);		-- Forma de Pago Comision por Garantia
	DECLARE Var_PorcentajeComGarantia		DECIMAL(6,2);	-- Porcentaje de Admon

	# Declaracion de cursores
	DECLARE CURSORAMORTICREDITO CURSOR FOR
    SELECT  Amo.CreditoID,  Amo.AmortizacionID, Aud_NumTransaccion, Amo.Capital
	FROM AMORTICREDITO Amo
        INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
	WHERE Cre.CreditoID   = Par_CreditoDestinoID
        AND Amo.Estatus   = Estatus_Vigente
        AND (Cre.Estatus  = Estatus_Vigente
				OR  Cre.Estatus  = Estatus_Vencido )
        AND Amo.Capital > Entero_Cero ;

	# Declaracion de cursores
	DECLARE CURSORAMORTICREDITOEST CURSOR FOR
    SELECT  Amo.CreditoID,  Amo.AmortizacionID, Amo.SaldoCapVigente, Amo.SaldoCapAtrasa, Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi
            FROM AMORTICREDITO Amo
        INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
	WHERE Cre.CreditoID   = Par_CreditoOrigenID
        AND Amo.Estatus IN (Estatus_Vigente, Estatus_Vencido, Estatus_Atrasado );



	# Asignacion de Constantes
	SET Cadena_Vacia    	:= '';              -- Cadena o String Vacio
	SET Fecha_Vacia     	:= '1900-01-01';    -- Fecha vacia
	SET Entero_Cero     	:= 0;               -- Entero en Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal cero
	SET Var_SI          	:= 'S';             -- Valor para Si
	SET Var_NO          	:= 'N';             -- Valor para Si
	SET Estatus_Cancela     := 'C';             -- Estatus de la Reest: Cancelado
	SET Estatus_Pagado      := 'P';             -- Estatus del Credito: Pagado
	SET EstaInactivo    	:= 'I';             -- Estatus del Credito: Inactivo
	SET EstaAutoriza    	:= 'A';             -- Estatus del Credito: Autorizado
	SET SalidaSI        	:= 'S';             -- El Store SI genera una Salida
	SET SalidaNO        	:= 'N';             -- El Store NO genera una Salida
	SET OrigenReestructura	:= 'R';             -- Tipo de Tratamiento: Reestructura
	SET OrigenRenovacion	:= 'O';				-- Tipo de tratamiento: Renovacion
	SET Estatus_Vigente		:= 'V';				-- Estatus vigente
    SET Estatus_Vencido		:= 'B'; 			-- Estatus vencido
    SET Estatus_Atrasado	:= 'A'; 			-- Estatus Atrasado
	SET Estatus_Desembolso	:= 'D';				-- Estatus desembolsado
	SET Estatus_Alta		:= 'A';				-- Estatus del registro en REESTRUCCREDITO, A=alta, C=cancelado, D=desembolsado
	SET Estatus_Autorizado	:= 'A';				-- Estatus liberado
	SET CalendarioReestruc	:= 2;				-- Calendario de pagos para credito reestructura
	SET Mov_CapVigente      := 1;  		       	-- Tipo del Movimiento de Credito: Capital Vigente (TIPOSMOVSCRE)
    SET Mov_CapAtrasado 	:= 2;    			-- Tipo del Movimiento de Credito: Capital Atrasado (TIPOSMOVSCRE)
	SET Mov_CapVencido  	:= 3; 				-- Tipo del Movimiento del Credito: Capital Vencido (TIPOSMOVSCRE)
	SET Mov_CapVeNoExi      := 4;  		       	-- Tipo del Movimiento de Credito: Capital Vencido No Exigible
    SET Con_CapVigente 		:= 1;				-- Concepto Cartera: Capital Vigente
	SET Con_CapAtrasado		:= 2;				-- Concepto Cartera: Capital Atrasado
	SET Con_CapVencido		:= 3; 				-- Concepto Cartera: Capital Vencido
	SET Con_CapVeNoExi 		:= 4;				-- Concepto Cartera: Capital Vencido No Exigible
	SET Nat_Cargo           := 'C';             -- Naturaleza de Cargo
	SET DescripcionMov		:= 'REESTRUCTURA DE CREDITO';
	SET PrePago_NO          := 'N';             -- El Tipo de Pago No es PrePago
	SET Finiquito_SI        := 'S';
	SET Var_CargoCuenta		:= 'C';
	SET Str_NumErr			:= '0';
	SET EstatusPagado       := 'P';		       	-- Estatus de Pagado
	SET PagLibres			:= 'L';
    SET AltaPoliza_SI   	:= 'S';             -- Alta de la Poliza Contable: SI
	SET AltaPoliza_NO   	:= 'N';             -- Alta de la Poliza Contable: NO
	SET AltaPolCre_SI   	:= 'S';             -- Alta de la Poliza Contable de Credito: SI
	SET AltaPolCre_NO   	:= 'N';             -- Alta de la Poliza Contable de Credito: NO
	SET AltaMovCre_NO   	:= 'N';             -- Alta de los Movimientos de Credito: NO
	SET AltaMovCre_SI   	:= 'S';             -- Alta de los Movimientos de Credito: SI
	SET AltaMovAho_NO   	:= 'N';             -- Alta de los Movimientos de Ahorro: NO
	SET AltaMovAho_SI   	:= 'S';             -- Alta de los Movimientos de Ahorro: SI.
	SET Nat_Abono       	:= 'A';             -- Naturaleza de Abono.
    SET Pro_PasoVenc		:= 205;
    SET ConcReestrRen		:= 66;
    SET Tol_DifPago			:= 0.05;
    SET Con_Origen			:= 'S';				-- Constante Origen donde se llama el SP (S= safy, W=WS)1
    SET OrigenPagoRees		:= 'E';
    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_NO							:= 'N';
	SET Con_SI							:= 'S';
	SET Con_Deduccion					:= 'D';
	SET Con_Financiado					:= 'F';
	SET Tip_Disposicion					:= 'D';
	SET Tip_Total						:= 'T';
	SET Tip_Cuota						:= 'C';
	SET Con_DesForCobCom				:= 'COBRO DE COMISION POR LINEA DE CREDITO';
	SET Con_DesIvaForCobCom				:= 'COBRO DE IVA COMISION POR LINEA DE CREDITO';
	SET Con_CarCtaOrdenDeuAgro			:= 138;
	SET Con_CarCtaOrdenCorAgro			:= 139;
	SET Con_CarComAdmonLinCred 			:= 140;
	SET Con_CarComAdmonDisLinCred 		:= 141;
	SET Con_CarIvaComAdmonDisLinCred	:= 144;
	SET Con_CarComGarDisLinCred 		:= 143;
	SET SiPagaIVA						:= 'S';						# El Cliente si Paga IVA
	SET Tip_MovComAdmonDisLinCred		:= 61;
	SET Tip_MovIVAComAdmonDisLinCred	:= 62;
	SET Entero_Uno						:= 1;

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-REESTRUCCREDAGROALT');
			   SET Var_NomControl  = 'SQLEXCEPTION';
			END;

	# Inicializacion de variables
	SELECT  Cli.SucursalOrigen,		Cli.PagaIVA,			Pro.CobraIVAInteres,    Pro.CobraIVAMora,		Cre.Estatus,
			Cre.PeriodicidadCap,	Cre.GrupoID,			Cre.Estatus,			Pro.EsReestructura,		Cre.ClienteID,
			Cre.CuentaID,			Cre.MonedaID,			Cre.MontoComApert,		Cre.IVAComApertura,		Cre.MontoCredito,
			Cre.MontoSeguroVida,	Cre.Relacionado,		Cre.TipoCredito,		Pro.ProducCreditoID,    Des.Clasificacion,
            Des.SubClasifID,		Cre.ComAperCont,		Cre.IVAComAperCont,		Cli.PagaIVA,			Cre.LineaCreditoID
	INTO	Var_SucursalCte,		Var_CliPagIVA,      	Var_IVAIntOrd,      	Var_IVAIntMor,			Var_EstRelacionado,
			Var_PeriodCap,			Var_GrupoID,			Var_Estatus,			Var_EsReestructura,		Var_ClienteID,
			Var_CuentaAhoID,		Var_MonedaID,			Var_MontoComAp,			Var_IVAComAp,			MontoCred,
			Var_MontoSegVida,		Var_Relacionado,		Var_TipoCredito,		Var_ProdCreID,			Var_ClasifCre,
            Var_SubClasifID,		Var_MontoConta ,		Var_MontoIVAComCont,	Var_PagIVA,				Var_LineaCreditoOriginalID
	FROM CREDITOS Cre
	INNER JOIN CLIENTES Cli	ON Cre.ClienteID = Cli.ClienteID
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN DESTINOSCREDITO Des ON  Cre.DestinoCreID       = Des.DestinoCreID
	WHERE Cre.CreditoID = Par_CreditoOrigenID;


	SELECT IVA INTO Var_IVASucurs FROM SUCURSALES WHERE SucursalID	= Var_SucursalCte;
	SELECT NumMaxDiasMora INTO Var_NumMaxDiasMora FROM PARAMETROSSIS LIMIT 1;
	SET Var_CuentaAhoStr := CONVERT(Var_CuentaAhoID, CHAR);
	SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, Var_SI);
	SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, Var_SI);
	SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, Var_SI);
	SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
	SET Var_SalInteres  := IFNULL(Var_SalInteres, Decimal_Cero);
	SET Var_NumMaxDiasMora  := IFNULL(Var_NumMaxDiasMora, Entero_Cero);
	SET Var_ValIVAIntOr := Entero_Cero;
	SET Var_ValIVAIntMo := Entero_Cero;
	SET Var_ValIVAGen   := Entero_Cero;
	SET Var_PagIVA		:= IFNULL(Var_PagIVA, Cadena_Vacia);


	SET Var_Relacionado := IFNULL(Var_Relacionado, Entero_Cero);
	SET Var_MontoSegVida := IFNULL(Var_MontoSegVida, Entero_Cero);
	SET MontoCred := IFNULL(MontoCred, Entero_Cero);
	SET Var_IVAComAp := IFNULL(Var_IVAComAp, Entero_Cero);
	SET Var_MontoComAp := IFNULL(Var_MontoComAp, Entero_Cero);


	IF (Var_CliPagIVA = Var_SI) THEN
		SET Var_ValIVAGen  := Var_IVASucurs;

		IF (Var_IVAIntOrd = Var_SI) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;

		IF (Var_IVAIntMor = Var_SI) THEN
			SET Var_ValIVAIntMo  := Var_IVASucurs;
		END IF;
	END IF;

	SELECT FUNCIONTOTDEUDACRE(Par_CreditoOrigenID) INTO Var_TotalAdeudo;

	SELECT 	SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
				ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2)),  -- Var_TotalAdeudoCap
			SUM(ROUND(SaldoInteresOrd + SaldoInteresAtr +
					  SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2)), -- Var_AdeudoInt
			SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2)), -- Var_AdeudoMora
			SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2) + ROUND(SaldoSeguroCuota,2)),	-- Var_AdeudoCom
			SUM(ROUND(SaldoInteresOrd + SaldoInteresAtr +
					  SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2) +
				ROUND(  ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
						ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
						ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
						ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
						ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2)), -- Var_TotalAdeudoInt
			SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
				ROUND( ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
					   ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
					   ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2), 2)),   -- Var_TotalAdeudoMora
			SUM(ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
		    	ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
				ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
				 ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2))  -- Var_TotalAdeudoCom


	INTO	Var_TotalAdeudoCap,		Var_AdeudoInt,		Var_AdeudoMora,		Var_AdeudoCom,		Var_TotalAdeudoInt,
			Var_TotalAdeudoMora,	Var_TotalAdeudoCom
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoOrigenID
		AND Estatus IN (Estatus_Vigente, Estatus_Vencido, Estatus_Atrasado );

	SET Var_TotalAdeudoCap	:= IFNULL(Var_TotalAdeudoCap, Decimal_Cero);
	SET Var_TotalAdeudoInt	:= IFNULL(Var_TotalAdeudoInt, Decimal_Cero);
	SET Var_TotalAdeudoMora	:= IFNULL(Var_TotalAdeudoMora, Decimal_Cero);
	SET Var_TotalAdeudoCom	:= IFNULL(Var_TotalAdeudoCom, Decimal_Cero);
	SET Var_AdeudoInt		:= IFNULL(Var_AdeudoInt, Decimal_Cero);
	SET Var_AdeudoMora		:= IFNULL(Var_AdeudoMora, Decimal_Cero);
	SET Var_AdeudoCom		:= IFNULL(Var_AdeudoCom, Decimal_Cero);
	SET Par_NumDiasAtraOri	:= IFNULL(Par_NumDiasAtraOri, Entero_Cero);
    SET Par_NumPagoSoste 	:= IFNULL(Par_NumPagoSoste, Entero_Cero);
    SET Par_NumPagoActual	:= IFNULL(Par_NumPagoActual, Entero_Cero);
	SET Par_NumeroReest		:= IFNULL(Par_NumeroReest, Entero_Cero);
    SET Par_ReservaInteres 	:= IFNULL(Par_ReservaInteres, Decimal_Cero);
    SET Par_SaldoInteres	:= IFNULL(Par_SaldoInteres, Decimal_Cero);


	IF(Par_SaldoInteres <= Entero_Cero) THEN
		SET Par_SaldoInteres		:= Var_AdeudoInt;
		SET Par_ReservaInteres		:= Var_AdeudoInt;
	END IF;
	IF(Par_SaldoInteresMora <= Entero_Cero) THEN
		SET Par_SaldoInteresMora	:= Var_AdeudoMora;
	END IF;
	IF(Par_SaldoComisiones <= Entero_Cero) THEN
		SET Par_SaldoComisiones		:= Var_AdeudoCom;
	END IF;
	IF(Par_ReservaInteres <= Entero_Cero) THEN
		SET Par_ReservaInteres		:= Var_SalInteres;
	END IF;


	IF(Par_Origen = OrigenRenovacion) THEN
		SET Var_Tratamiento	:= 'Renovar';
	ELSE
		SET Var_Tratamiento	:= 'Reestructurar';
	END IF;




	# ============================================================================================================================
	# ----------------------------------------------- VALIDACIONES GENERALES -----------------------------------------------------

		IF(IFNULL(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia)THEN
			SET Par_NumErr      := 101;
			SET Par_ErrMen      := CONCAT('La Fecha de Registro del Cr&eacute;dito a ', Var_Tratamiento, ' est&aacute; Vacia.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CreditoOrigenID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 102;
			SET Par_ErrMen      := CONCAT('Indique el N&uacute;mero de Cr&eacute;dito a ', Var_Tratamiento, '.');
			SET Var_NomControl  := 'relacionado';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_CreditoDestinoID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 103;
			SET Par_ErrMen      := CONCAT('Indique el N&uacute;mero de Cr&eacute;dito Destino.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_SaldoCredAnteri, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 104;
			SET Par_ErrMen      := CONCAT('El Saldo del Cr&eacute;dito a ', Var_Tratamiento, ' est&aacute; Vacio.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_EstatusCredAnt, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr      := 105;
			SET Par_ErrMen      := CONCAT('Indique el Estatus Actual del Cr&eacute;dito a ', Var_Tratamiento, '.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_EstatusCreacion, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr      := 106;
			SET Par_ErrMen      := CONCAT('Indique el Estatus del Cr&eacute;dito Destino.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_Origen, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr      := 107;
			SET Par_ErrMen      := CONCAT('Indique el Tipo de Tratamiento (Renovaci&oacute;n/Reestructura) de Cr&eacute;dito.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_Origen != OrigenRenovacion AND Par_Origen != OrigenReestructura)THEN
			SET Par_NumErr      := 108;
			SET Par_ErrMen      := CONCAT('El Tipo de Tratamiento Indicado es Incorrecto.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(Var_Estatus != Estatus_Vigente AND Var_Estatus != Estatus_Vencido)THEN
			SET	Par_NumErr 		:= 109;
			SET	Par_ErrMen 		:= CONCAT('El Cr&eacute;dito a ', Var_Tratamiento, ' debe estar Vigente o Vencido.');
			SET Var_NomControl 	:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Var_GrupoID, Entero_Cero) > Entero_Cero)THEN
			SET Par_NumErr      := 110;
			SET Par_ErrMen      := CONCAT('No se Permite ', Var_Tratamiento, ' un Cr&eacute;dito Grupal.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		IF (Var_TotalAdeudo <= Entero_Cero) THEN
			SET Par_NumErr	:= 111;
			SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito a ', Var_Tratamiento, '  No Presenta Adeudos.');
			SET Var_NomControl  := 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;






		# ============================================================================================================================
		# ---------------------------------------- VALIDACIONES PARA UNA RENOVACION DE CREDITO ---------------------------------------
		IF(Par_Origen = OrigenRenovacion) THEN

			IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITO
												WHERE CreditoOrigenID = Par_CreditoOrigenID
													AND Origen = OrigenReestructura
													AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
				SET Par_NumErr      := 201;
				SET Par_ErrMen      := 'No se Permite Renovar un Cr&eacute;dito Reestructura.';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITO
												WHERE CreditoOrigenID = Par_CreditoOrigenID
													AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
				SET Par_NumErr      := 202;
				SET Par_ErrMen      := 'El Cr&eacute;dito Relacionado ya Fue Renovado.';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;
			IF (Var_EsReestructura = Var_NO) THEN
				SET Par_NumErr	:= 203;
				SET Par_ErrMen	:= 'El Producto de Cr&eacute;dito No Permite Renovaciones.';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;



			SET Var_EstatusReest := Estatus_Alta;
			SET	Par_NumErr := Entero_Cero;
			SET	Par_ErrMen := CONCAT('Renovaci&oacute;n de Cr&eacute;dito Registrado con &Eacute;xito: ', Par_CreditoDestinoID);

		END IF; -- Termina: IF(Par_Origen = OrigenRenovacion) THEN





	# ============================================================================================================================
	# -------------------------------------- VALIDACIONES PARA UNA REESTRUCTURA DE CREDITO ---------------------------------------

-- Se obtienen los datos de la nueva Solicitud de Credito
	IF(Par_Origen = OrigenReestructura) THEN
    	SET Var_Consecutivo := Entero_Cero;

		SELECT  SolicitudCreditoID,		NumTransacSim,			FechaAutoriza, 			FechaInicioAmor,
				TipoPagoCapital, 		FrecuenciaCap,			FrecuenciaInt,			PeriodicidadCap,
				PeriodicidadInt,		DiaMesCapital,			DiaMesInteres,			MontoCuota,
				ValorCAT,				TipoConsultaSIC,		FolioConsultaBC,		FolioConsultaCC,
				TasaFija
		INTO 	Var_SolicitudCreditoID, 	Var_NumTransacSim,  	Var_FechaInicio, 		Var_FechaInicioAmor,
				Var_TipoPagoCapital,	Var_FrecuenciaCap,  	Var_FrecuenciaInt, 		Var_PeriodicidadCap,
				Var_PeriodicidadInt,	Var_DiaMesCapital,		Var_DiaMesInteres,		Var_MontoCuota,
				Var_ValorCAT,			Var_TipoConsultaSIC,	Var_FolioConsultaBC,	Var_FolioConsultaCC,
				Var_TasaFija
		FROM SOLICITUDCREDITO
		WHERE Relacionado = Par_CreditoOrigenID AND TipoCredito = OrigenReestructura AND Estatus = Estatus_Autorizado;


		SELECT	LineaCreditoID,			MontoSolici,
				ManejaComAdmon,			ComAdmonLinPrevLiq,		ForCobComAdmon,			ForPagComAdmon,			PorcentajeComAdmon,			MontoPagComAdmon,
				ManejaComGarantia,		ComGarLinPrevLiq,		ForCobComGarantia,		ForPagComGarantia,		PorcentajeComGarantia,		MontoPagComGarantia
		INTO 	Var_LineaCreditoID,		Var_MontoSolicitado,
				Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,	Var_ForCobComAdmon,		Var_ForPagComAdmon,		Var_PorcentajeComAdmon,		Var_MontoPagComAdmon,
				Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,	Var_ForCobComGarantia,	Var_ForPagComGarantia,	Var_PorcentajeComGarantia,	Var_MontoPagComGarantia
		FROM SOLICITUDCREDITO Cre
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID;


		SET Var_LineaCreditoID := IFNULL(Var_LineaCreditoID, Entero_Cero);

		SELECT EsAgropecuario
		INTO 	Var_EsAgropecuario
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Var_LineaCreditoID;

		SET Var_EsAgropecuario := IFNULL(Var_EsAgropecuario, Con_NO);

		SELECT  Cli.SucursalOrigen INTO	Var_SucCliReest
			FROM	CLIENTES Cli,	SOLICITUDCREDITO Sol
			WHERE Relacionado = Par_CreditoOrigenID
			  AND Sol.ClienteID			= Cli.ClienteID
			  AND Sol.TipoCredito = OrigenReestructura AND Sol.Estatus = Estatus_Autorizado;

		SET Var_TipoConsultaSIC := IFNULL(Var_TipoConsultaSIC,Cadena_Vacia);
		SET Var_FolioConsultaBC := IFNULL(Var_FolioConsultaBC,Cadena_Vacia);
        SET Var_FolioConsultaCC := IFNULL(Var_FolioConsultaCC,Cadena_Vacia);

			IF EXISTS (SELECT CreditoOrigenID FROM  REESTRUCCREDITO
												WHERE CreditoOrigenID = Par_CreditoOrigenID
													AND Origen = OrigenRenovacion
													AND EstatusReest  = Estatus_Desembolso LIMIT 1) THEN
				SET Par_NumErr      := 201;
				SET Par_ErrMen      := 'No se Permite Reestructurar un Cr&eacute;dito Renovado.';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_TotalAdeudoCom > Entero_Cero) THEN
				SET Par_NumErr := 202;
				SET Par_ErrMen := CONCAT('El Cr&eacute;dito a Reestructurar tiene Adeudo de Comisiones: $', FORMAT(Var_TotalAdeudoCom, 2));
				SET Var_NomControl := 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;
			IF(Var_TotalAdeudoMora > Entero_Cero) THEN
				SET Par_NumErr := 203;
				SET Par_ErrMen := CONCAT('El Cr&eacute;dito a Reestructurar tiene Adeudo de Inter&eacute;s Moratorio: $', FORMAT(Var_TotalAdeudoMora, 2));
				SET Var_NomControl := 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TotalAdeudoInt > Decimal_Cero) THEN
				SET Par_NumErr := 204;
				SET Par_ErrMen := CONCAT('El Cr&eacute;dito a Reestructurar tiene Adeudo de Intereses: $', FORMAT(Var_TotalAdeudoInt, 2));
				SET Var_NomControl := 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TotalAdeudoCap != Par_SaldoCredAnteri AND (Var_LineaCreditoID = Entero_Cero AND Var_EsAgropecuario = Con_NO)) THEN
				SET Par_NumErr := 205;
				SET Par_ErrMen := CONCAT('El Monto Autorizado debe ser Igual al Saldo Insoluto de Capital del Cr&eacute;dito a Reestructurar: $', FORMAT(Var_TotalAdeudoCap, 2));
				SET Var_NomControl := 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;
			IF(Par_NumDiasAtraOri > Var_NumMaxDiasMora AND Var_Estatus = Estatus_Vencido) THEN
				SET Par_NumErr := 206;
				SET Par_ErrMen := CONCAT('El Numero de D&iacute;as de Mora del Cr&eacute;dito a Reestructurar es Mayor al Permitido.<br>',
										  'D&iacute;as Mora Cr&eacute;dito: ',Par_NumDiasAtraOri, '<br>',
										  'D&iacute;as Mora Permitidos: ', Var_NumMaxDiasMora);
				SET Var_NomControl := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;
			IF (Var_EsReestructura = Var_NO) THEN
				SET Par_NumErr	:= 207;
				SET Par_ErrMen	:= 'El Producto de Cr&eacute;dito No Permite Reestructuras.';
				SET Var_NomControl  := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;


			UPDATE SOLICITUDCREDITO SET
				CreditoID			= Par_CreditoDestinoID,
				Estatus				= Estatus_Desembolso,
				FechaFormalizacion	= Par_FechaRegistro,
                FechaInicioAmor		= Par_FechaRegistro,

			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

		# Si el credito tiene ministraciones que su fecha de desembolso sea mayor a la fecha del sistema seran canceladas
		IF EXISTS (SELECT CreditoID FROM MINISTRACREDAGRO
					WHERE CreditoID = Par_CreditoOrigenID
					AND ClienteID = Var_ClienteID
					AND FechaPagoMinis > Par_FechaRegistro
					AND Estatus = EstaInactivo)THEN


           UPDATE MINISTRACREDAGRO
			SET Estatus = Estatus_Cancela
				WHERE CreditoID = Par_CreditoOrigenID
				AND ClienteID = Var_ClienteID
				AND FechaPagoMinis > Par_FechaRegistro
				AND Estatus = EstaInactivo;
		END IF;


        -- Se hace la llamada a CONTACREDITOSPRO para generar el encabezado de la Poliza
		CALL CONTACREDITOSPRO (
			Var_CreditoID,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
			Par_FechaRegistro,	Decimal_Cero, 		Var_MonedaID,		Var_ProdCreID, 		Var_ClasifCre,
			Var_SubClasifID,	Var_SucursalCte,	DescripcionMov, 	Var_CuentaAhoStr,	AltaPoliza_SI,
			ConcReestrRen,		Var_Poliza, 		AltaPolCre_NO, 		AltaMovCre_NO,		Entero_Cero,
			Var_TipoMovCred, 	Cadena_Vacia, 		AltaMovAho_NO, 		Cadena_Vacia,		Cadena_Vacia,
			OrigenPagoRees,		SalidaNO,			Par_NumErr, 		Par_ErrMen, 		Var_Consecutivo,
			Par_EmpresaID,		Cadena_Vacia,		Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr > Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza el abono del saldo capital a la linea de credito
		IF ( Var_LineaCreditoOriginalID > Entero_Cero AND Var_TotalAdeudoCap > Entero_Cero) THEN

			SELECT	SucursalID
			INTO	Var_SucursalLin
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Var_LineaCreditoID
			  AND EsAgropecuario = Con_SI;


			UPDATE LINEASCREDITO SET
				Pagado			= IFNULL(Pagado,Entero_Cero) + Var_TotalAdeudoCap,
				SaldoDisponible = IFNULL(SaldoDisponible,Entero_Cero) + Var_TotalAdeudoCap ,
				SaldoDeudor		= IFNULL(SaldoDeudor,Entero_Cero) - Var_TotalAdeudoCap,

				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE LineaCreditoID = Var_LineaCreditoOriginalID;

			CALL CONTALINEACREPRO(
				Var_LineaCreditoOriginalID,	Entero_Cero,	Par_FechaRegistro,	Par_FechaRegistro,	Var_TotalAdeudoCap,
				Var_MonedaID,				Var_ProdCreID,	Var_SucursalLin,	DescripcionMov,		Var_LineaCreditoOriginalID,
				AltaPoliza_NO,				ConcReestrRen,	AltaPolCre_SI,		AltaMovAho_NO,		Con_CarCtaOrdenDeuAgro,
				Cadena_Vacia,				Nat_Cargo,		Nat_Cargo,			Par_NumErr,			Par_ErrMen,
				Var_Poliza,					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,				Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CONTALINEACREPRO(
				Var_LineaCreditoOriginalID,	Entero_Cero,	Par_FechaRegistro,	Par_FechaRegistro,	Var_TotalAdeudoCap,
				Var_MonedaID,				Var_ProdCreID,	Var_SucursalLin,	DescripcionMov,		Var_LineaCreditoOriginalID,
				AltaPoliza_NO,				ConcReestrRen,	AltaPolCre_SI,		AltaMovAho_NO,		Con_CarCtaOrdenCorAgro,
				Cadena_Vacia,				Nat_Abono, 		Nat_Abono,			Par_NumErr,			Par_ErrMen,
				Var_Poliza,					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,				Aud_Sucursal,	Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		# CURSOR para realizar los movimientos operativos y contables de las amortizaciones originales del credito
		OPEN CURSORAMORTICREDITOEST;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP

				FETCH CURSORAMORTICREDITOEST INTO
					Var_CreditoID, 	Var_AmortizID,	  Var_SalCapVig,    Var_SaldCapAtr,  Var_SaldCapVen,
                    Var_SaldCapVenNoEx;

						-- Asignacion de valores cuando el Saldo de Capital Vigente sea mayor a 0
						IF (Var_SalCapVig > Decimal_Cero) THEN
							SET Var_TipoMovCred := Mov_CapVigente;
                            SET Var_ConContCred	:= Con_CapVigente;
                            SET Var_MontoOpera	:= Var_SalCapVig;
						END IF;

                        -- Asignacion de valores cuando el Saldo de Capital Atrasado sea mayor a 0
						IF (Var_SaldCapAtr > Decimal_Cero) THEN
							SET Var_TipoMovCred := Mov_CapAtrasado;
                            SET Var_ConContCred	:= Con_CapAtrasado;
                            SET Var_MontoOpera	:= Var_SaldCapAtr;
						END IF;

						-- Asignacion de valores cuando el Saldo de Capital Vencido sea mayor a 0
						IF (Var_SaldCapVen > Decimal_Cero) THEN
							SET Var_TipoMovCred := Mov_CapVencido;
                            SET Var_ConContCred	:= Con_CapVencido;
							SET Var_MontoOpera	:= Var_SaldCapVen;
						END IF;

						-- Asignacion de valores cuando el Saldo de Capital Vencido no Exigible sea mayor a 0
						IF (Var_SaldCapVenNoEx > Decimal_Cero) THEN
							SET Var_TipoMovCred := Mov_CapVeNoExi;
                            SET Var_ConContCred	:= Con_CapVeNoExi;
							SET Var_MontoOpera	:= Var_SaldCapVenNoEx;
						END IF;

                    -- Se marcan las amortizaciones como Pagadas
                    UPDATE AMORTICREDITO SET
						Estatus 		= Estatus_Pagado,
						FechaLiquida 	= Par_FechaRegistro
					WHERE CreditoID	= Var_CreditoID
					AND AmortizacionID = Var_AmortizID;

                    IF (Var_MontoOpera > Decimal_Cero) THEN
						-- Se hacen los movimientos operativos y contables.
						CALL CONTACREDITOSPRO (
							Var_CreditoID,		Var_AmortizID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
							Par_FechaRegistro,	Var_MontoOpera,		Var_MonedaID,		Var_ProdCreID, 		Var_ClasifCre,
							Var_SubClasifID,	Var_SucursalCte,	DescripcionMov, 	Var_CuentaAhoStr,	AltaPoliza_NO,
							Entero_Cero,		Var_Poliza, 		AltaPolCre_SI, 		AltaMovCre_SI,		Var_ConContCred,
							Var_TipoMovCred, 	Nat_Abono, 			AltaMovAho_NO, 		Cadena_Vacia,		Cadena_Vacia,
							OrigenPagoRees,		SalidaNO,			Par_NumErr, 		Par_ErrMen, 		Var_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);
                    END IF;
					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTICREDITOEST;

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se valida el tipo de Pago de Capital para generar las amortizaciones cuando sean CRECIENTES o IGUALES
		IF(Var_TipoPagoCapital = PagLibres) THEN
			-- se trata de un calendario con pagos libres, se eliminan las amortizaciones
			CALL AMORTICREDITOALT (
				Par_CreditoDestinoID,	Var_NumTransacSim,	Var_ClienteID,		Var_CuentaAhoID,	Par_SaldoCredAnteri,
				CalendarioReestruc,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario, 			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

		ELSE
			CALL CREGENAMORTIZARESPRO(
				Var_SolicitudCreditoID,	Par_CreditoOrigenID,	Var_FechaSistema,	Par_Salida,
				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario	,		Aud_FechaActual	,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		END IF;

		# CURSOR para registrar el saldo de capital de las amortizaciones en capital vigente o en vencido no exigible
		# Se generan los movimientos operativos y contables.
		OPEN CURSORAMORTICREDITO;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP

				FETCH CURSORAMORTICREDITO INTO
					Var_CreditoID, 	Var_AmortizID,	Aud_NumTransaccion,	Var_Cantidad;


					-- Verificamos si el credito es Reestructura y  nace como Vencido
					IF (Par_EstatusCreacion = Estatus_Vencido) THEN
						SET Var_TipoMovCred   := Mov_CapVeNoExi;
						SET Var_ConContCred	:= Con_CapVeNoExi;
					ELSE
						SET Var_TipoMovCred   := Mov_CapVigente;
                        SET Var_ConContCred	:= Con_CapVigente;
					END IF;

                    -- Se registran los movimientos operativos y contables
					CALL CONTACREDITOSPRO (
						Var_CreditoID,		Var_AmortizID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
						Par_FechaRegistro,	Var_Cantidad, 		Var_MonedaID,		Var_ProdCreID, 		Var_ClasifCre,
						Var_SubClasifID,	Var_SucCliReest,	DescripcionMov, 	Var_CuentaAhoStr,	AltaPoliza_NO,
						Entero_Cero,		Var_Poliza, 		AltaPolCre_SI, 		AltaMovCre_SI,		Var_ConContCred,
						Var_TipoMovCred, 	Nat_Cargo, 			AltaMovAho_NO, 		Cadena_Vacia,		Cadena_Vacia,
						OrigenPagoRees,		SalidaNO,			Par_NumErr, 		Par_ErrMen, 		Var_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
					END IF;

				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTICREDITO;

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_ManejaComAdmon		:= IFNULL(Var_ManejaComAdmon, Con_NO);
		SET Var_ComAdmonLinPrevLiq	:= IFNULL(Var_ComAdmonLinPrevLiq, Con_NO);
		SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
		SET Var_MontoPagComAdmon	:= IFNULL(Var_MontoPagComAdmon, Entero_Cero);

		SET Var_ManejaComGarantia	:= IFNULL(Var_ManejaComGarantia, Con_NO);
		SET Var_ComGarLinPrevLiq	:= IFNULL(Var_ComGarLinPrevLiq, Con_NO);
		SET Var_MontoPagComGarantia	:= IFNULL(Var_MontoPagComGarantia, Entero_Cero);

		-- Formas de cobro de comisión para lineas de credito agro.
		-- Las comisiones cargadas sobre la o las disposiciones en una línea de crédito seran cobradas al cliente al momento del desembolso, de acuerdo a la forma elegida al momento del alta
		-- de la solicitud y alta del crédito (Campo Forma Cobro de la sección de línea de crédito)
		IF( Var_LineaCreditoID > Entero_Cero ) THEN

			-- Se realizan los movimiento contables de la ministracion de una linea de credito Agro
			CALL MINISTRALINEAAGROPRO(
				Par_CreditoOrigenID,	Var_Poliza,			Var_MontoSolicitado,
				SalidaNO,				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL CONTACOMLINCREDAGROPRO(
				Par_CreditoOrigenID,	Var_SolicitudCreditoID,	Con_SI,			Var_Poliza,			OrigenPagoRees,
				Entero_Uno,
				SalidaNO,				Par_NumErr,				Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Tipos de cobro de comisión.
			/*Cobros de comision para una linea de credito con comisiones por administracion
			T.- Total en primera dispersión
			D.- Por disposición**/
			IF( Var_ManejaComAdmon = Con_SI AND
				Var_ComAdmonLinPrevLiq = Con_NO AND
				Var_MontoPagComAdmon > Entero_Cero ) THEN

				-- Actualizo el Monto Pagado en la solicitud y en el Credito
				UPDATE CREDITOS SET
					MontoPagComAdmon = MontoCobComAdmon + Var_MontoPagComAdmon,
					MontoCobComAdmon = MontoCobComAdmon + Var_MontoPagComAdmon
				WHERE CreditoID = Par_CreditoOrigenID;
			END IF;

			IF( Var_ManejaComGarantia = Con_SI AND
				Var_ComGarLinPrevLiq = Con_NO AND
				Var_MontoPagComGarantia > Entero_Cero ) THEN

				-- Actualizo el Monto Pagado en la solicitud y en el Credito
				UPDATE CREDITOS SET
					MontoPagComGarantia = MontoPagComGarantia + Var_MontoPagComGarantia,
					MontoCobComGarantia = MontoCobComGarantia + Var_MontoPagComGarantia,
					MontoPagComGarantiaSim = Var_MontoPagComGarantia
				WHERE CreditoID = Par_CreditoOrigenID;
			END IF;

			-- actualiza la nueva linea de credito, asi como sus propiedades
			-- Se los nuevos datos de la línea de crédito al credito renovado
			UPDATE CREDITOS SET
				LineaCreditoID			= Var_LineaCreditoID,
				ManejaComAdmon			= Var_ManejaComAdmon,
				ComAdmonLinPrevLiq		= Var_ComAdmonLinPrevLiq,
				ForCobComAdmon			= Var_ForCobComAdmon,
				ForPagComAdmon			= Var_ForPagComAdmon,
				PorcentajeComAdmon		= Var_PorcentajeComAdmon,
				MontoPagComAdmon		= Var_MontoPagComAdmon,
				ManejaComGarantia		= Var_ManejaComGarantia,
				ComGarLinPrevLiq		= Var_ComGarLinPrevLiq,
				ForCobComGarantia		= Var_ForCobComGarantia,
				ForPagComGarantia		= Var_ForPagComGarantia,
				PorcentajeComGarantia	= Var_PorcentajeComGarantia,
				MontoPagComGarantia		= Var_MontoPagComGarantia
			WHERE CreditoID = Par_CreditoOrigenID;
		END IF;



			SET Var_NumAmorti	:= (SELECT COUNT(AmortizacionID)
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoDestinoID AND Estatus IN (Estatus_Vigente, Estatus_Vencido, EstatusPagado));

			SET Var_NumAmorInt	:= (SELECT COUNT(Interes)
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoDestinoID
									AND Estatus IN (Estatus_Vigente, Estatus_Vencido, EstatusPagado)
									AND Interes > Decimal_Cero);

            SET Var_NumAmortVig	:= (SELECT COUNT(AmortizacionID)
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoDestinoID AND Estatus IN (Estatus_Vigente, Estatus_Vencido));

            # PAGO SOSTENIDO EXCLUSIVO PARA CREDITOS AGROPECUARIOS CON CALENDARIO LIBRE
            # Si en la tabla de amortizaciones solo existe una amortizacion, se le dara tratamiento de PAGO UNICO
			IF(Var_NumAmortVig = 1) THEN
				SET Par_NumPagoSoste := 1;
            ELSE
				SET Par_NumPagoSoste := 3; -- Tres pagos sostenidos cuando tengan mas amortizaciones
            END IF;


			UPDATE CREDITOS SET
				Estatus         	= Par_EstatusCreacion,
				NumAmortizacion 	= Var_NumAmorti,
                NumAmortInteres 	= Var_NumAmorInt,
				TipoCredito			= OrigenReestructura,
				Relacionado			= Par_CreditoDestinoID,
				SolicitudCreditoID	= Var_SolicitudCreditoID,
                MontoCredito		= Par_SaldoCredAnteri,
				TasaFija 			= Var_TasaFija,
                FechaInicio			= Var_FechaInicio,
                FechaInicioAmor		= Var_FechaInicio,
				TipoPagoCapital		= Var_TipoPagoCapital,
				FrecuenciaCap		= Var_FrecuenciaCap,
				FrecuenciaInt		= Var_FrecuenciaInt,
				PeriodicidadCap		= Var_PeriodicidadCap,
				PeriodicidadInt		= Var_PeriodicidadInt,
				DiaMesCapital		= Var_DiaMesCapital,
				DiaMesInteres		= Var_DiaMesInteres,
				MontoCuota			= Var_MontoCuota,
				ValorCAT			= Var_ValorCAT,
                ComAperReest		= Var_MontoConta,
                IVAComAperReest		= Var_MontoIVAComCont,
                TipoConsultaSIC		= Var_TipoConsultaSIC,
				FolioConsultaBC		= Var_FolioConsultaBC,
				FolioConsultaCC     = Var_FolioConsultaCC,

				Usuario         	= Aud_Usuario,
				FechaActual     	= Aud_FechaActual,
				DireccionIP     	= Aud_DireccionIP,
				ProgramaID      	= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal,
				NumTransaccion  	= Aud_NumTransaccion
			WHERE CreditoID	= Par_CreditoDestinoID;

			SET Var_EstatusReest := Estatus_Desembolso;
			SET	Par_NumErr := Entero_Cero;
			SET	Par_ErrMen := CONCAT('Cr&eacute;dito Reestructurado Exitosamente: ', Par_CreditoOrigenID );

		END IF; -- Termina: IF(Par_Origen = OrigenReestructura) THEN




		#======================================================================================================================================
		# ------------------------------------------- SE REGISTRA EL CREDITO EN LA TABLA DE TRATAMIENTOS ---------------------------------------
		SET Var_NumReestr := (SELECT COUNT(CreditoOrigenID) FROM REESTRUCCREDITO
								WHERE CreditoOrigenID = Par_CreditoOrigenID);

		SET Var_NumReestr := (IFNULL(Var_NumReestr,Entero_Cero));


        IF(Var_NumReestr > Entero_Cero) THEN
			SET Var_ConsecutivRes := (SELECT IFNULL(MAX(Consecutivo),Entero_Cero) + 1
							FROM `HIS-REESTRUCCREDITO`);

			INSERT INTO `HIS-REESTRUCCREDITO`(
					Consecutivo,			FechaRegistro,  		UsuarioID,          	CreditoOrigenID,    	CreditoDestinoID,
                    SaldoCredAnteri,		EstatusCredAnt, 		EstatusCreacion,    	NumDiasAtraOri,     	NumPagoSoste,
                    NumPagoActual,			Regularizado,   		FechaRegula,        	NumeroReest,        	ReservaInteres,
                    SaldoInteres,			SaldoInteresMora,		SaldoComisiones,		EstatusReest,			Origen,
                    EmpresaID,          	Usuario,            	FechaActual, 			DireccionIP,			ProgramaID,
					Sucursal,           	NumTransaccion  )
			SELECT
					Var_ConsecutivRes,		FechaRegistro,  		UsuarioID,          	CreditoOrigenID,    	CreditoDestinoID,
                    SaldoCredAnteri,		EstatusCredAnt, 		EstatusCreacion,    	NumDiasAtraOri,     	NumPagoSoste,
                    NumPagoActual,			Regularizado,   		FechaRegula,        	NumeroReest,        	ReservaInteres,
                    SaldoInteres,			SaldoInteresMora,		SaldoComisiones,		EstatusReest,			Origen,
					EmpresaID,          	Usuario,            	FechaActual, 			DireccionIP,			ProgramaID,
                    Sucursal,           	NumTransaccion
			FROM REESTRUCCREDITO
					WHERE CreditoOrigenID = Par_CreditoOrigenID;

			UPDATE REESTRUCCREDITO
            SET NumPagoSoste = Par_NumPagoSoste,
            NumeroReest = Par_NumeroReest,
            NumDiasAtraOri = Par_NumDiasAtraOri,
            EstatusReest = Var_EstatusReest,
            EstatusCredAnt = Par_EstatusCredAnt,
            EstatusCreacion = Par_EstatusCreacion
            WHERE CreditoOrigenID = Par_CreditoOrigenID;


		ELSE

			INSERT INTO REESTRUCCREDITO(
					FechaRegistro,  		UsuarioID,          	CreditoOrigenID,    	CreditoDestinoID,   	SaldoCredAnteri,
					EstatusCredAnt, 		EstatusCreacion,    	NumDiasAtraOri,     	NumPagoSoste,       	NumPagoActual,
					Regularizado,   		FechaRegula,        	NumeroReest,        	ReservaInteres,     	SaldoInteres,
					SaldoInteresMora,		SaldoComisiones,		EstatusReest,			Origen,
					EmpresaID,          	Usuario,            	FechaActual, 			DireccionIP,			ProgramaID,
					Sucursal,           	NumTransaccion  )
			VALUES(
					Par_FechaRegistro,  	Par_UsuarioID,          Par_CreditoOrigenID,    Par_CreditoDestinoID,   Par_SaldoCredAnteri,
					Par_EstatusCredAnt, 	Par_EstatusCreacion,    Par_NumDiasAtraOri,     Par_NumPagoSoste,       Par_NumPagoActual,
					Par_Regularizado,   	Par_FechaRegula,        Par_NumeroReest,        Par_ReservaInteres,     Par_SaldoInteres,
					Par_SaldoInteresMora,	Par_SaldoComisiones,	Var_EstatusReest,   	Par_Origen,
					Par_EmpresaID,      	Aud_Usuario,            Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);

	END IF;

	END ManejoErrores;  -- End del Handler de Errores


	 IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

END TerminaStore$$