-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RENOVACCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RENOVACCREDITOALT`;
DELIMITER $$

CREATE PROCEDURE `RENOVACCREDITOALT`(
# ==================================================================================================================
# ---------------------- SP PARA DAR DE ALTA UNA RENOVACION O REESTRUCTURA DE CREDITO  -----------------------------
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
	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT	Par_NumErr		INT(11),		-- Numero de Error

	INOUT	Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_NomControl		CHAR(20);			-- Variable de control
	DECLARE Var_CreEstatus      CHAR(1);			-- Variable del estatus del credito
	DECLARE Var_SalInteres      DECIMAL(14,2);		-- Variable para almacenar el saldo del interes
	DECLARE Var_Reserva         DECIMAL(14,2);		-- Variable para almacenar la reserva del credito
	DECLARE Var_EstRelacionado	CHAR(1);			-- Variable para almacenar el estatus relacionado
	DECLARE Var_PeriodCap		INT(11);			-- Variable para almacenar la periocidad capital
	DECLARE Var_GrupoID     	INT;				-- Variable para guardar el id del grupo
	DECLARE Var_Estatus			CHAR(1);			-- Variable para guardar el estatus
	DECLARE Var_Relacionado		BIGINT(12);			-- Variable para guardar el id del realacionad
	DECLARE Var_TotalAdeudo		DECIMAL(14,2);		-- Variable para guardar el total del adeudo
	DECLARE Var_TotalAdeudoCap	DECIMAL(14,2);		-- Variable para almacenar el total del adeudo capital
	DECLARE Var_TotalAdeudoInt	DECIMAL(14,2);		-- Variabla para guardar el total adeudo del interes
	DECLARE Var_TotalAdeudoMora	DECIMAL(14,2);		-- Variable para guardar el adeudo total mora
	DECLARE Var_TotalAdeudoCom	DECIMAL(14,2);		-- Variable para almacenar el adeudo total de la comision
	DECLARE Var_AdeudoInt		DECIMAL(14,2);		-- Variable para almacenar el adeudo de interes
	DECLARE Var_AdeudoMora		DECIMAL(14,2);		-- Variable para guardar el adeudo de mora
	DECLARE Var_AdeudoCom		DECIMAL(14,2);		-- Variable para almacenar el adeudo de la comision
	DECLARE Var_ValIVAIntOr		DECIMAL(12,2);		-- Variable para guardar el IVA del interes ordinario
	DECLARE Var_ValIVAIntMo		DECIMAL(12,2);		-- Variable para guardar el IVA del interes moratorio
	DECLARE Var_ValIVAGen		DECIMAL(12,2);		-- Variable para guardar el IVA de interes
	DECLARE Var_IVASucurs       DECIMAL(8, 4);		-- Variable para guardar el IVA de la sucursal
	DECLARE Var_CliPagIVA		CHAR(1);			-- Variable para almacenar si el cliente paga IVA
	DECLARE Var_IVAIntOrd		CHAR(1);			-- Variable auxiliar para guardar el IVA del interes ordinario
	DECLARE Var_IVAIntMor		CHAR(1);			-- Variable auxiliar para guardar el IVA del interes moratorio
	DECLARE Var_SucursalCte		INT(11);			-- Variable para guardar la sucursal del cliente
	DECLARE Var_Tratamiento		VARCHAR(20);		-- Variable para guardar el tratamiento
	DECLARE Var_NumMaxDiasMora	INT(11);			-- Variable para almacenar el numero de maximo de dias mora
	DECLARE Var_EsReestructura	CHAR(1);			-- Variable para almacenar si es reestructura
	DECLARE Var_EstatusReest	CHAR(1);			-- Variable para guardar el estatus de la reestructura
	DECLARE Var_SolicitudCreditoID BIGINT(20);		-- Variable para almacenar el id de la solicitud de credito
	DECLARE Var_NumTransacSim	BIGINT;				-- Variable para guardar el numero de transaccion del simulador
	DECLARE Var_ClienteID		INT(11);			-- Variable para guardar el id del cliente
	DECLARE Var_CuentaAhoID		BIGINT(12);			-- Variable para guardar la cuenta de ahorro
	DECLARE Var_NumAmorti		INT(11);			-- Variable para almacenar el numero de amortizaciones
    DECLARE Var_NumAmorInt		INT(11);			-- Variable para guardar el numero de amortizacion de interes
	DECLARE Var_CreditoID       BIGINT(12);			-- Variable guardar el id del credito
	DECLARE Var_AmortizID       INT;				-- Variable para almacenar el id de la amortizacion
	DECLARE Var_Cantidad        DECIMAL(14,2);		-- Variable para guardar la cantidad
	DECLARE Var_TipoMovCred		INT;				-- Variable para almacenar el id del tipo de movimiento del credito
    DECLARE Var_ConContCred		INT(11);			-- Variable para credito
	DECLARE Var_Consecutivo     BIGINT;				-- Variable para almacenar el consecutivo
	DECLARE Var_MonedaID        INT(11);			-- Variable para guardar el tipo de moneda
	DECLARE Var_CuentaAhoStr    VARCHAR(20);
    DECLARE	Var_FechaInicio		DATE;				-- Variable para guardar la fecha de inicio
    DECLARE	Var_FechaInicioAmor DATE;				-- Variable para guardar la fecha de inicio de la amortizacion
	DECLARE Var_TipoPagoCapital CHAR(1);			-- Variable para guardar el tipo de pago capital
	DECLARE Var_FrecuenciaCap	CHAR(1);			-- Variable para guardar la frecuencia de la capital
    DECLARE	Var_FrecuenciaInt	CHAR(1);			-- Variable para guardar la frecuencia del interes
	DECLARE	Var_PeriodicidadCap INT;				-- Variable para guardar la periocidad capital
	DECLARE	Var_PeriodicidadInt INT;				-- Variable para almacenar la periocidad del interes
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
    DECLARE Var_MontoIVAComCont	DECIMAL(14,2);		-- Variable para guardar el monto del iva de comision
    DECLARE Var_TipoConsultaSIC	CHAR(2);			-- Variable para guardar el tipo de consulta
    DECLARE Var_FolioConsultaBC	VARCHAR(30);		-- Variable para guardar el folio de consulta de buro de credito
    DECLARE Var_FolioConsultaCC VARCHAR(30);		-- Variable para guardar el folio de consulta del circulo de credito
    DECLARE Var_NumReestr		INT(11);		-- Numero de Reestructuras
    DECLARE Var_ConsecutivRes	BIGINT(20);		-- Numer Consecutivo
    DECLARE Var_Reacreditado	CHAR(1);		-- Es Reacreditamiento


-- Ivett
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

-- Ivett

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
    DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovAho_SI   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE Nat_Abono      		CHAR(1);
    DECLARE Pro_PasoVenc		INT(11);
	DECLARE ConcReestrRen		INT(11);
    DECLARE Tol_DifPago			DECIMAL(10,4);
	DECLARE Con_Origen			CHAR(1);

	DECLARE Var_Contador			INT(11);			-- Varialbe para Consulta en el while
	DECLARE Var_Tamanio 			INT(11);			-- Variable para Consulta en el while
	DECLARE	Var_LineaFondeo			INT(11);			-- Variable para Linea de Fondeo
	DECLARE	Var_InstitFondeoID		INT(11);			-- Variable para Instatitucion de Fondeo

	DECLARE	Var_CreLineaFondeo 			INT(11);
	DECLARE	Var_CreInstitFondeoID 		INT(11);
	DECLARE	Var_FolioFondeo				INT(11);


	DECLARE	Var_CreTipoCalInteres		INT(11);
	DECLARE	Var_CreCalcInteresID		INT(11);

	DECLARE	Var_CreTasaBase				INT(11);
	DECLARE	Var_CreSobreTasa			DECIMAL(12,4);
	DECLARE	Var_CreTasaFija				DECIMAL(12,4);
	DECLARE	Var_CrePisoTasa				DECIMAL(12,4);
	DECLARE	Var_CreTechoTasa			DECIMAL(12,4);

	DECLARE	Var_CreFactorMora			DECIMAL(12,4);
	DECLARE	Var_CreMontoCredito			DECIMAL(12,4);
	DECLARE	Var_CreMonedaID				INT(11);
	DECLARE	Var_CreFechaInicio			DATE;
	DECLARE	Var_CreFechaVencimien		DATE;

	DECLARE	Var_CreTipoPagoCapital		CHAR(1);
	DECLARE	Var_CreFrecuenciaCap		CHAR(1);
	DECLARE	Var_CrePeriodicidadCap		INT(11);
	DECLARE	Var_CreNumAmortizacion		CHAR(1);
	DECLARE	Var_CreFrecuenciaInt		CHAR(1);

	DECLARE	Var_CrePeriodicidadInt		INT(11);
	DECLARE	Var_CreNumAmortInteres		INT(11);
	DECLARE	Var_CreMontoCuota			DECIMAL(12,2);
	DECLARE	Var_CreFechaInhabil			CHAR(1);
	DECLARE	Var_CreCalendIrregular		CHAR(1);

	DECLARE	Var_CreDiaPagoCapital		CHAR(1);
	DECLARE	Var_CreDiaPagoInteres 		CHAR(1);
	DECLARE	Var_CreDiaMesInteres   		INT(11);
	DECLARE	Var_CreDiaMesCapital   		INT(11);
	DECLARE	Var_CreAjusFecUlVenAmo 		CHAR(1);

	DECLARE	Var_CreAjusFecExiVen   		CHAR(1);
	DECLARE	Var_CreNumTransacSim   		BIGINT(20);
	DECLARE	Var_CrePlazoID			VARCHAR(20);
	DECLARE	Var_CliPagaIVA				CHAR(1);
	DECLARE Var_CreditoFonID			INT(11);

    DECLARE Var_TipoFondeo				CHAR(1);
    DECLARE Var_EstatusFondeo			CHAR(1);
    DECLARE Var_Fondeado				CHAR(1);
   	DECLARE Var_MargenPagIgual			DECIMAL(12,2);			# Margen para Pagos Iguales.
	DECLARE Var_InstitucionPasID		INT(11);				# Numero de Institucion (INSTITUCIONES)

	DECLARE Var_CuentaClabePas			VARCHAR(18);			# Cuenta Clabe de la institucion
	DECLARE Var_NumCtaInstitPas			VARCHAR(20);			# Numero de Cuenta Bancaria.
	DECLARE Var_PlazoContable			CHAR(1);				# plazo contable C.- Corto plazo L.- Largo Plazo
	DECLARE Var_TipoInstitID			INT(11);				# Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
	DECLARE Var_ComDispos				DECIMAL(12,2);			# Comision por disposicion.
	DECLARE Var_IvaComDispos			DECIMAL(12,2);			# IVA Comision por disposicion.
	DECLARE Var_CobraISR				CHAR(1);				# Indica si cobra o no ISR Si = S No = N
	DECLARE Var_TasaISR					DECIMAL(12,2);			# Tasa del ISR
	DECLARE Var_PagosParciales			CHAR(1);
	DECLARE Var_CapitalizaInteres		CHAR(1);

	DECLARE Var_TasaPasiva				DECIMAL(14,4);			# Tasa del ISR
	DECLARE Var_TipoFondeador			CHAR(1);
	DECLARE Var_CreditoFondeoID			BIGINT(20);				# Numero de Credito de Fonde (Credito Pasivo)
	DECLARE Var_AdeudoPasivo			DECIMAL(14,2);			# Deuda del Credito Pasivo



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
	SET DescripcionMov		:= 'REENOVACION DE CREDITO';
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
    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_Contador		:= 1;				-- Contador para el while
	SET Var_Fondeado		:= 'F';

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
			   SET Par_NumErr  = 999;
			   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-RENOVACCREDITOALT');
			   SET Var_NomControl  = 'SQLEXCEPTION';
			END;

	# Inicializacion de variables
	 SELECT 	Cli.SucursalOrigen,		Cli.PagaIVA,			Pro.CobraIVAInteres,    Pro.CobraIVAMora,		Cre.Estatus,
				Cre.PeriodicidadCap,	Cre.GrupoID,			Cre.Estatus,			Pro.EsReestructura,		Cre.ClienteID,
				Cre.CuentaID,			Cre.MonedaID,			Cre.MontoComApert,		Cre.IVAComApertura,		Cre.MontoCredito,
				Cre.MontoSeguroVida,	Cre.Relacionado,		Cre.TipoCredito,		Pro.ProducCreditoID,    Des.Clasificacion,
	            Des.SubClasifID,		Cre.ComAperCont,		Cre.IVAComAperCont,		Cre.LineaFondeo, 		Cre.InstitFondeoID
		INTO	Var_SucursalCte,		Var_CliPagIVA,      	Var_IVAIntOrd,      	Var_IVAIntMor,			Var_EstRelacionado,
				Var_PeriodCap,			Var_GrupoID,			Var_Estatus,			Var_EsReestructura,		Var_ClienteID,
				Var_CuentaAhoID,		Var_MonedaID,			Var_MontoComAp,			Var_IVAComAp,			MontoCred,
				Var_MontoSegVida,		Var_Relacionado,		Var_TipoCredito,		Var_ProdCreID,			Var_ClasifCre,
	            Var_SubClasifID,		Var_MontoConta ,		Var_MontoIVAComCont,	Var_LineaFondeo,		Var_InstitFondeoID
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


	SET Var_Relacionado 	:= IFNULL(Var_Relacionado, Entero_Cero);
	SET Var_MontoSegVida 	:= IFNULL(Var_MontoSegVida, Entero_Cero);
	SET MontoCred 			:= IFNULL(MontoCred, Entero_Cero);
	SET Var_IVAComAp		:= IFNULL(Var_IVAComAp, Entero_Cero);
	SET Var_MontoComAp 		:= IFNULL(Var_MontoComAp, Entero_Cero);

	SET Var_Reacreditado := (SELECT Reacreditado FROM CREDITOS WHERE CreditoID = Par_CreditoDestinoID);
	SET Var_Reacreditado 	:= IFNULL(Var_Reacreditado, Var_NO);

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
	DELETE FROM TMPRENOVAAMORTICRED WHERE CreditoID = Par_CreditoOrigenID;

    SET @Var_Consecutivo = Entero_Cero;
	# Declaracion de cursores
    INSERT INTO TMPRENOVAAMORTICRED
    SELECT ( @Var_Consecutivo := @Var_Consecutivo + 1) AS Consecutivo, Amo.CreditoID,  	Amo.AmortizacionID, Amo.SaldoCapVigente, Amo.SaldoCapAtrasa, Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi,Aud_NumTransaccion
            FROM AMORTICREDITO Amo
        INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
	WHERE Cre.CreditoID   = Par_CreditoOrigenID
        AND Amo.Estatus IN (Estatus_Vigente, Estatus_Vencido, Estatus_Atrasado );


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
		SELECT IFNULL(MAX(Consecutivo),Entero_Cero) INTO Var_Tamanio FROM TMPRENOVAAMORTICRED;

		SET Var_TipoFondeo   := (SELECT TipoFondeo  FROM CREDITOS where CreditoID = Par_CreditoDestinoID);
        SET Var_CreditoFonID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoID = Par_CreditoOrigenID AND EstatusRelacion=Estatus_Vigente);
		SET Var_CreditoFonID := IFNULL(Var_CreditoFonID,Entero_Cero);
		SET Var_GrupoID		:= (SELECT GrupoID FROM CREDITOS WHERE CreditoID =Par_CreditoOrigenID);
		SET Var_GrupoID		:= IFNULL(Var_GrupoID,Entero_Cero);
		END IF; -- Termina: IF(Par_Origen = OrigenRenovacion)


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
					SaldoInteresMora,		SaldoComisiones,		EstatusReest,			Origen,					Reacreditado,
					EmpresaID,          	Usuario,            	FechaActual, 			DireccionIP,			ProgramaID,
					Sucursal,           	NumTransaccion  )
			VALUES(
					Par_FechaRegistro,  	Par_UsuarioID,          Par_CreditoOrigenID,    Par_CreditoDestinoID,   Par_SaldoCredAnteri,
					Par_EstatusCredAnt, 	Par_EstatusCreacion,    Par_NumDiasAtraOri,     Par_NumPagoSoste,       Par_NumPagoActual,
					Par_Regularizado,   	Par_FechaRegula,        Par_NumeroReest,        Par_ReservaInteres,     Par_SaldoInteres,
					Par_SaldoInteresMora,	Par_SaldoComisiones,	Var_EstatusReest,   	Par_Origen,				Var_Reacreditado,
					Par_EmpresaID,      	Aud_Usuario,            Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);

	END IF;

	DELETE FROM TMPRENOVAAMORTICRED WHERE Transaccion = Aud_NumTransaccion;
	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Renovaci&oacute;n de Cr&eacute;dito Registrado con &Eacute;xito: ', Par_CreditoDestinoID);
	END ManejoErrores;  -- End del Handler de Errores


	 IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_NomControl 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

END TerminaStore$$