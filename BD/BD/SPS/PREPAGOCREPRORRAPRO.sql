
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCREPRORRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOCREPRORRAPRO`;
DELIMITER $$


CREATE PROCEDURE `PREPAGOCREPRORRAPRO`(
	-- SP DE PROCESO QUE REALIZA EL PREPAGO POR PRORRATEO DE CUOTAS
    Par_CreditoID     	BIGINT(12),
    Par_CuentaAhoID   	BIGINT(12),
    Par_MontoPagar    	DECIMAL(14,2),
    Par_MonedaID      	INT(11),
    Par_EmpresaID     	INT(11),

    Par_Salida        	CHAR(1),
    Par_AltaEncPoliza	CHAR(1),
	OUT Par_MontoPago	DECIMAL(12,2),
	INOUT Var_Poliza	BIGINT,
	Par_OrigenPago		CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService,
										-- O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
										-- A: Aplicacion de Garantias Agropecuaria

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT,
    Par_ModoPago        CHAR(1),
	Par_RespaldaCred	CHAR(1),		-- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)

	-- Parametros de Auditoria
	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE ConcepCtaOrdenDeu	INT;
DECLARE ConcepCtaOrdenCor	INT;
DECLARE VarSucursalLin		INT;
DECLARE Var_AltaPoliza		CHAR(1);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecAplicacion   DATE;
DECLARE Var_DiasCredito     INT;
DECLARE Var_SucCliente      INT;
DECLARE Var_ClienteID		BIGINT;
DECLARE Var_ProdCreID		INT;
DECLARE Var_ClasifCre		CHAR(1);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_CliPagIVA   	CHAR(1);
DECLARE Var_IVAIntOrd   	CHAR(1);
DECLARE Var_EsGrupal        CHAR(1);
DECLARE Var_SolCreditoID    BIGINT;
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_MonedaID        INT;
DECLARE Var_GrupoID         INT;
DECLARE Var_SubClasifID     INT;
DECLARE Var_MonPagoOri		DECIMAL(12,2);

DECLARE Var_CreditoID       BIGINT(12);           			-- Variables para los Cursores
DECLARE Var_AmortizacionID  INT;
DECLARE Var_SalCapitales	DECIMAL(14,2);
DECLARE Var_SaldoCapVigente DECIMAL(14,2);
DECLARE Var_SaldoCapVenNExi DECIMAL(14,2);
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);
DECLARE Var_SaldoInteresPro	DECIMAL(14,4);
DECLARE	Var_SaldoIntNoConta	DECIMAL(14,4);
DECLARE Var_ProvisionAcum   DECIMAL(14,4);


DECLARE Var_IVASucurs   	DECIMAL(8, 4);
DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
DECLARE Var_TotDeuda    	DECIMAL(14,2);
DECLARE Var_NumAtrasos  	INT;
DECLARE Var_EsHabil     	CHAR(1);
DECLARE Var_CueEstatus		CHAR(1);
DECLARE Var_CueClienteID    BIGINT;
DECLARE Var_CueSaldo		DECIMAL(14,2);
DECLARE Var_CueMoneda		INT;
DECLARE Var_CicloActual     INT;
DECLARE Var_CicloGrupo      INT;
DECLARE Var_GrupoCtaID      INT;
DECLARE Var_CuentaAhoStr	VARCHAR(20);
DECLARE Var_CreditoStr		VARCHAR(20);
DECLARE Var_SaldoPago       DECIMAL(14,2);
DECLARE Var_CantidPagar     DECIMAL(14,2);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_CalInteresID    INT;
DECLARE Var_Dias            INT;
DECLARE Var_TotCapital      DECIMAL(14,2);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_MaxAmoCapita    INT;
DECLARE Var_IVACantidPagar  DECIMAL(12, 2);
DECLARE	Var_FechaIniCal		DATE;
DECLARE	Var_EstAmorti		CHAR(1);
DECLARE Var_TotDeudaCap		DECIMAL(14,2);
DECLARE Var_MaxAmorti		INT;
DECLARE Var_PorcentajePag	DECIMAL(12,8);
DECLARE	Var_DivContaIng		CHAR(1);

DECLARE Var_ManejaLinea		CHAR(1);			-- variable para guardar el valor de si o no maneja linea el producto de credito
DECLARE Var_EsRevolvente	CHAR(1);			-- Variable para saber si es revolvente la linea
DECLARE Var_LineaCredito	BIGINT(20);			-- Variable para guardar la linea de credito
DECLARE Var_NumAmoPag		INT;
DECLARE Var_NumAmorti		INT;
DECLARE Var_MontoCredito		DECIMAL(14,2);		-- Monto Original del Credito
DECLARE Var_PorcMontoCred		DECIMAL(14,2);		-- Monto correspondiente al 20% del Monto Original del Credito
DECLARE Var_MontoPagado			DECIMAL(14,2);		-- Monto pagado del Credito
DECLARE Var_CapitalVigente		DECIMAL(14,2);		-- Saldo Capital Vigente
DECLARE Var_Frecuencia      CHAR(1);
DECLARE Var_EstCreacion		CHAR(1);
DECLARE Var_FrecInteres			CHAR(1);			-- Frecuencia de Interes
DECLARE Var_FechaInicioCred		DATE;				-- Fecha de Inicio del Credito
DECLARE Var_DiasTrans			INT(11);			-- Dias transcurridos
DECLARE Var_IntNoCont			DECIMAL(14,2);		-- Saldo Interes no contabilizado
DECLARE Var_PagoPerdCentRedond	CHAR(1);
DECLARE Var_PagoMontoMaxPerd	DECIMAL(16,2);
DECLARE Var_CuentaContablePerd	VARCHAR(29);
DECLARE Var_SaldoPerdida		DECIMAL(16,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE SiPagaIVA       CHAR(1);
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Esta_Pagado     CHAR(1);
DECLARE Esta_Activo     CHAR(1);
DECLARE Esta_Vencido    CHAR(1);
DECLARE Esta_Vigente    CHAR(1);
DECLARE Esta_Atrasado	CHAR(1);

DECLARE NO_EsGrupal     CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Mon_MinPago     DECIMAL(12,2);
DECLARE Tol_DifPago     DECIMAL(10,4);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Aho_PagoCred    CHAR(4);
DECLARE Con_AhoCapital  INT;
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE Tasa_Fija       INT;

DECLARE Coc_PagoCred    INT;
DECLARE Ref_PagAnti     VARCHAR(50);
DECLARE Con_PagoCred    VARCHAR(50);

DECLARE NoManejaLinea	CHAR(1);		-- NO maneja linea
DECLARE SiManejaLinea	CHAR(1);		-- Si maneja linea
DECLARE SiEsRevolvente	CHAR(1);		-- Si Es Revolvente
DECLARE NoEsRevolvente	CHAR(1);		-- NO Es Revolvente
DECLARE AltaMov_NO		CHAR(1);		-- Alta de Movimientos: NO
DECLARE TipoActInteres	INT(11);
DECLARE Frec_Unico		CHAR(1);
DECLARE Var_EsReestruc	CHAR(1);
DECLARE Si_EsReestruc	CHAR(1);
DECLARE Cons_Si			CHAR(1);
DECLARE Cons_No			CHAR(1);
DECLARE Var_ClienteEspecifico 	INT(11);  -- Numero de Cliente especifico
DECLARE Var_ClienteConsol     	INT(11);  -- Numero de Cliente especifico Consol
DECLARE Estatus_Suspendido		CHAR(1);		-- Estatus Suspendido
DECLARE Var_EsLineaCreditoAgroRevolvente  CHAR(1);  -- Es Linea de Credito Agro Revolvente
DECLARE Var_EsLineaCreditoAgro            CHAR(1);  -- Es linea de Credito Agro
DECLARE Con_NO                            CHAR(1);  -- Constante NO
DECLARE Con_SI                            CHAR(1);  -- Constante SI
DECLARE Var_PagoLineaCredito			CHAR(1);	-- Origen del pago de una linea de credito
DECLARE Con_CargoCta					CHAR(1);	-- Constante Origen de Pago con Cargo a Cuenta
DECLARE Con_PagoApliGarAgro				CHAR(1);	-- Constante Origen de Pago de Aplicacion por Garantias Agro (A)
DECLARE Con_CarCtaOrdenDeuAgro			INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
DECLARE Con_CarCtaOrdenCorAgro			INT(11);		-- Concepto Cuenta Ordenante Corte Agro

DECLARE CURSORAMORTI CURSOR FOR
    SELECT  Amo.CreditoID,      Amo.AmortizacionID, 	Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,
            Cre.MonedaID,       Amo.FechaInicio,    	Amo.FechaVencim,        Amo.FechaExigible,
            Amo.Estatus,		Amo.SaldoInteresPro,	Amo.SaldoIntNoConta
		FROM AMORTICREDITO Amo,
			  CREDITOS	 Cre
		WHERE Amo.CreditoID   = Cre.CreditoID
		  AND Cre.CreditoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente
			OR Cre.Estatus    = Esta_Vencido
			OR Cre.Estatus    = Estatus_Suspendido)
		  AND Amo.Estatus	  = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

-- Asignacion de Constantes
SET Cadena_Vacia    := '';              	-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
SET Entero_Cero		:= 0;					-- Entero en Cero
SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
SET Esta_Activo     := 'A';             	-- Estatus: Activo
SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
SET Esta_Vigente    := 'V';             	-- Estatus del Credito: Vigente
SET Esta_Atrasado	:= 'A';

SET NO_EsGrupal     := 'N';             	-- El Credito No es Grupal
SET AltaPoliza_SI   := 'S';             	-- SI dar de alta la Poliza Contable
SET AltaPoliza_NO   := 'N';             	-- NO dar de alta la Poliza Contable
SET Pol_Automatica  := 'A';             	-- Tipo de Poliza: Automatica
SET Mon_MinPago     := 0.01;            	-- Monto Minimo para Aceptar un Pago
SET Tol_DifPago     := 0.05;            	-- Minimo de la deuda para marcarlo como Pagado
SET Nat_Cargo       := 'C';             	-- Naturaleza de Cargo
SET Nat_Abono       := 'A';					-- Naturaleza de Abono
SET Aho_PagoCred    := '101';           	-- Concepto de Pago de Credito
SET Con_AhoCapital  := 1;               	-- Concepto de Ahorro: Capital
SET AltaMovAho_SI   := 'S';             	-- Alta del Movimiento de Ahorro: SI
SET Tasa_Fija       := 1;               	-- Tipo de Tasa de Interes: Fija
SET Coc_PagoCred    := 54;              	-- Concepto Contable: Pago de Credito

SET Ref_PagAnti     := 'PAGO ANTICIPADO CREDITO';
SET Con_PagoCred    := 'PAGO DE CREDITO';
SET Aud_ProgramaID  :='PAGOCREDITOPRO';

SET NoManejaLinea	:= 'N';	            -- No maneja linea
SET SiManejaLinea	:= 'S';	            -- Si maneja linea
SET SiEsRevolvente	:= 'S';	            -- Si Es Revolvente
SET NoEsRevolvente	:= 'N';	            -- No Es Revolvente
SET ConcepCtaOrdenDeu	:= 53;			-- Linea Credito Cta. Orden
SET ConcepCtaOrdenCor	:= 54;			-- Linea Credito Corr. Cta Orden
SET AltaMov_NO      := 'N';          	-- Alta de Movimientos: NO
SET TipoActInteres	:= 3;				-- Tipo de Actualizacion (intereses)
SET Frec_Unico			:= 'U';			-- Frecuencia Unica
SET Si_EsReestruc   	:= 'S';
SET Cons_Si				:= 'S';
SET Cons_No				:= 'N';			-- Constante NO
SET Var_ClienteConsol := 10;
SET Estatus_Suspendido	:= 'S';			-- Estatus Suspendido
SET Con_NO				:= 'N';
SET Con_SI				:= 'S';
SET Con_PagoApliGarAgro		:= 'A';
SET Con_CargoCta			:= 'C';
SET Con_CarCtaOrdenDeuAgro			:= 138;
SET Con_CarCtaOrdenCorAgro			:= 139;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PREPAGOCREPRORRAPRO');
		END;

	SET	Par_NumErr	:= Entero_Cero;

	SET Var_ClienteEspecifico 	:= FNPARAMGENERALES('CliProcEspecifico');
	SET Var_PagoPerdCentRedond 	:= FNPARAMGENERALES('PagoPerdCentRedond');
	SET Var_PagoMontoMaxPerd 	:= FNPARAMGENERALES('PagoMontoMaxPerd');
	SET Var_CuentaContablePerd 	:= FNPARAMGENERALES('CuentaContablePerd');

	-- Si el Origen del pago es por Aplicacion de garantias Agro revolventes  se asgina como el tipo de pago de linea como aplicacion de garantias
	-- y el origen se ajusta a cargo a cuenta para respetar el pago con cargo a cuenta de la narrativa original
	IF( Par_OrigenPago = Con_PagoApliGarAgro ) THEN
		SET Var_PagoLineaCredito 	:= Con_PagoApliGarAgro;
		SET Par_OrigenPago 			:= Con_CargoCta;
	END IF;

	SET Var_PagoLineaCredito 	:= IFNULL(Var_PagoLineaCredito, Con_CargoCta);
	SET Par_OrigenPago 			:= IFNULL(Par_OrigenPago, Con_CargoCta);

    IF( Var_PagoPerdCentRedond = Cadena_Vacia ) THEN
		SET Var_PagoPerdCentRedond := Con_NO;
	END IF;

	IF(Var_PagoPerdCentRedond=Con_NO) THEN
    SET Tol_DifPago := Var_PagoMontoMaxPerd;
    END IF;

	SET	Par_NumErr	:= Entero_Cero;

	SELECT FechaSistema, DiasCredito, DivideIngresoInteres INTO Var_FechaSistema, Var_DiasCredito, Var_DivContaIng
		FROM PARAMETROSSIS;

	SET	Var_DivContaIng	:= IFNULL(Var_DivContaIng, Cadena_Vacia);


	SELECT  Cli.SucursalOrigen,     Cre.ClienteID,  		Pro.ProducCreditoID,    Des.Clasificacion,		Cre.NumAmortizacion,
			Cre.Estatus,            Cli.PagaIVA,            Pro.CobraIVAInteres,	Pro.EsGrupal,			Cre.SolicitudCreditoID,
			Cre.TasaFija,           Cre.MonedaID,          	Cre.GrupoID,			Des.SubClasifID,        Cre.CicloGrupo,
			Cre.CalcInteresID,		FUNCIONTOTDEUDACRE(Par_CreditoID),				Cre.LineaCreditoID,		Pro.ManejaLinea,
            Pro.EsRevolvente,		Cre.MontoCredito,		Pro.EsReestructura,		Res.EstatusCreacion,	Cre.FrecuenciaCap,
            Cre.FrecuenciaInt,		Cre.FechaInicio
			INTO
			Var_SucCliente,     Var_ClienteID,  	Var_ProdCreID,      Var_ClasifCre,		Var_NumAmorti,
            Var_EstatusCre,     Var_CliPagIVA,  	Var_IVAIntOrd,      Var_EsGrupal,		Var_SolCreditoID,
            Var_CreTasa,   	    Var_MonedaID,      	Var_GrupoID,		Var_SubClasifID,    Var_CicloGrupo,
            Var_CalInteresID,   Var_TotDeuda,		Var_LineaCredito,	Var_ManejaLinea,	Var_EsRevolvente,
            Var_MontoCredito,	Var_EsReestruc,		Var_EstCreacion,	Var_Frecuencia,		 Var_FrecInteres,
            Var_FechaInicioCred

		FROM PRODUCTOSCREDITO Pro,
			  CLIENTES Cli,
			DESTINOSCREDITO Des,
			CREDITOS Cre
		LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
		WHERE Cre.CreditoID			= Par_CreditoID
		  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
		  AND Cre.ClienteID			= Cli.ClienteID
		 AND Cre.DestinoCreID      = Des.DestinoCreID;

	-- Inicializaciones
	SET Var_SucCliente  := IFNULL(Var_SucCliente,Entero_Cero);
	SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero);
	SET Var_ProdCreID   := IFNULL(Var_ProdCreID,Entero_Cero);
	SET Var_ClasifCre   := IFNULL(Var_ClasifCre,Cadena_Vacia);
	SET Var_EstatusCre  := IFNULL(Var_EstatusCre,Cadena_Vacia);
	SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA,SiPagaIVA);
	SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd,SiPagaIVA);
	SET Var_EsGrupal    := IFNULL(Var_EsGrupal,Cadena_Vacia);
	SET Var_SolCreditoID    := IFNULL(Var_SolCreditoID,Entero_Cero);
	SET Var_CreTasa     := IFNULL(Var_CreTasa,Entero_Cero);
	SET Var_MonedaID    := IFNULL(Var_MonedaID,Entero_Cero);
	SET Var_GrupoID     := IFNULL(Var_GrupoID,Entero_Cero);
	SET Var_SubClasifID := IFNULL(Var_SubClasifID,Entero_Cero);
	SET Var_TotDeuda    := IFNULL(Var_TotDeuda,Entero_Cero);
	SET Var_ManejaLinea   := IFNULL(Var_ManejaLinea,NoManejaLinea);
	SET Var_EsRevolvente  := IFNULL(Var_EsRevolvente,NoEsRevolvente);
    SET Var_MontoCredito  := IFNULL(Var_MontoCredito, Decimal_Cero);
	SET Var_LineaCredito  := IFNULL(Var_LineaCredito, Entero_Cero);

	IF( Var_LineaCredito <> Entero_Cero ) THEN
		SELECT	EsRevolvente,						EsAgropecuario
		INTO	Var_EsLineaCreditoAgroRevolvente, 	Var_EsLineaCreditoAgro
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Var_LineaCredito
		  AND EsAgropecuario = Con_SI;
	END IF;
	SET Var_EsLineaCreditoAgroRevolvente	:= IFNULL(Var_EsLineaCreditoAgroRevolvente, Cadena_Vacia);
	SET Var_EsLineaCreditoAgro				:= IFNULL(Var_EsLineaCreditoAgro, Con_NO);

	SELECT IVA INTO Var_IVASucurs
		FROM SUCURSALES
		WHERE SucursalID	= Var_SucCliente;

	SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);


	SET Var_ValIVAIntOr := Entero_Cero;
	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen := 'PrePago de Credito Aplicado Exitosamente.';


	IF (Var_CliPagIVA = SiPagaIVA) THEN
		IF (Var_IVAIntOrd = SiPagaIVA) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;
	END IF;

	IF(Par_MontoPagar >= Var_TotDeuda) THEN
		SET Par_NumErr      := 1;
		SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
		LEAVE ManejoErrores;
	END IF;

	SELECT COUNT(AmortizacionID) INTO Var_NumAtrasos
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID
		  AND FechaExigible <= Var_FechaSistema
		  AND Estatus != Esta_Pagado;

	SET Var_NumAtrasos := IFNULL(Var_NumAtrasos, Entero_Cero);

	IF(Var_NumAtrasos > Entero_Cero) THEN
		SET Par_NumErr      := 2;
		SET Par_ErrMen      := 'Antes de Realizar un PrePago, Por Favor realice el Pago de lo Exigible y en Atraso.' ;
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,   Entero_Cero,		Var_FecAplicacion,  Var_EsHabil,    Par_EmpresaID,
		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	CALL SALDOSAHORROCON(
		Var_CueClienteID, Var_CueSaldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);

	IF(IFNULL(Var_CueEstatus, Cadena_Vacia)) != Esta_Activo THEN
		 SET Par_NumErr      := 3;
		SET Par_ErrMen      := 'La Cuenta de Pago no Existe o no Esta Activa .' ;
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Var_CueClienteID, Entero_Cero)) != Var_ClienteID THEN
		SET Par_NumErr := Entero_Cero;

		IF (Var_EsGrupal = NO_EsGrupal) THEN
			SET Par_NumErr      := 4;
			SET Par_ErrMen      := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
									' no pertenece al Cliente ', CONVERT(Var_ClienteID, CHAR),
									'Cliente al que Pertence ' , CONVERT(Var_CueClienteID, CHAR));
			LEAVE ManejoErrores;
		ELSE

			SELECT CicloActual INTO Var_CicloActual
				FROM 	GRUPOSCREDITO
				WHERE GrupoID = Var_GrupoID;

			SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);


			IF(Var_CicloGrupo = Var_CicloActual) THEN
				SELECT GrupoID INTO Var_GrupoCtaID
					FROM INTEGRAGRUPOSCRE
					WHERE GrupoID = Var_GrupoID
					  AND Estatus = Esta_Activo
					  AND ClienteID = Var_CueClienteID
					LIMIT 1;
			ELSE
				SELECT GrupoID INTO Var_GrupoCtaID
					FROM `HIS-INTEGRAGRUPOSCRE` Ing
					WHERE GrupoID = Var_GrupoID
					  AND Estatus = Esta_Activo
					  AND ClienteID = Var_CueClienteID
					  AND Ing.Ciclo = Var_CicloGrupo
					LIMIT 1;
			END IF;

			SET Var_GrupoCtaID := IFNULL(Var_GrupoCtaID, Entero_Cero);

			IF (Var_GrupoCtaID = Entero_Cero) THEN

				SET Par_NumErr      := 5;
				SET Par_ErrMen      := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
										' no pertenece al Cliente ', CONVERT(Var_ClienteID, CHAR),
										'Cliente al que Pertence ' , CONVERT(Var_CueClienteID, CHAR));
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Var_CueMoneda, Entero_Cero)) != Par_MonedaID THEN
		SET Par_NumErr      := 6;
		SET Par_ErrMen      := 'La Moneda no corresponde con la Cuenta.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_CueSaldo, Decimal_Cero)) < Par_MontoPagar THEN
		SET Par_NumErr      := 7;
		SET Par_ErrMen      := 'Saldo Insuficiente en la Cuenta del Cliente';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCre = Cadena_Vacia ) THEN
		SET Par_NumErr      := 8;
		SET Par_ErrMen      := 'El Credito no Existe';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCre != Esta_Vigente AND
	   Var_EstatusCre != Esta_Vencido AND
	   Var_EstatusCre != Estatus_Suspendido) THEN

		SET Par_NumErr      := 9;
		SET Par_ErrMen      := 'Estatus del Credito Incorrecto';
		LEAVE ManejoErrores;

	END IF;

	-- SE OBTIENEN VALORES
	IF( (Var_ManejaLinea = SiManejaLinea AND Var_LineaCredito <> Entero_Cero) OR Var_EsLineaCreditoAgro = Con_SI )THEN
		SET VarSucursalLin := ( SELECT	SucursalID
								FROM  LINEASCREDITO
								WHERE LineaCreditoID = Var_LineaCredito);
	END IF;


	-- Obtenemos el Saldo de Capital
	SELECT SUM(IFNULL(Amo.SaldoCapVigente, Entero_Cero) + IFNULL(Amo.SaldoCapVenNExi, Entero_Cero)) INTO Var_TotDeudaCap
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID	= Par_CreditoID
			  AND Amo.Estatus	= Esta_Vigente;

	SET	Var_TotDeudaCap	:= IFNULL(Var_TotDeudaCap, Entero_Cero);

	-- Obtenemos la Ultima Amortizacion Vigente
	SELECT  MAX(Amo.AmortizacionID) INTO Var_MaxAmorti
		FROM AMORTICREDITO Amo
		WHERE Amo.CreditoID   = Par_CreditoID
		  AND Amo.Estatus		= Esta_Vigente
		AND Amo.FechaExigible > Var_FechaSistema;

	SET	Var_MaxAmorti	:= IFNULL(Var_MaxAmorti, Entero_Cero);

	-- Respaldo de las Tablas de Creditos, para su posible posterior reversa
	IF(Par_RespaldaCred = Cons_Si) THEN
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	END IF;
	-- Alta del Maestro de la Poliza
	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZASALT(
			Var_Poliza,			Par_EmpresaID,		Var_FecAplicacion,  Pol_Automatica,     Coc_PagoCred,
			Con_PagoCred,		SalidaNO,       	Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;



	SET Var_SaldoPago       := Par_MontoPagar;
	SET Var_MonPagoOri		:= Par_MontoPagar;
	SET Var_CuentaAhoStr    := CONVERT(Par_CuentaAhoID, CHAR(15));
	SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));
     -- Monto correspondiente al 20% del Monto del Credito
    SET Var_PorcMontoCred := ((Var_MontoCredito * 20)/100);

	OPEN CURSORAMORTI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTI INTO
			Var_CreditoID,      Var_AmortizacionID, Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
			Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,      Var_AmoEstatus,			Var_SaldoInteresPro,
			Var_SaldoIntNoConta;

		-- Inicializacion
		SET Var_CantidPagar		:= Decimal_Cero;
		SET Var_IVACantidPagar	:= Decimal_Cero;
		SET Var_PorcentajePag	:= IF(Var_TotDeudaCap != Decimal_Cero, ROUND((Var_SaldoCapVigente + Var_SaldoCapVenNExi)/Var_TotDeudaCap,8), Decimal_Cero);
		SET Var_SalCapitales	:= (Var_SaldoCapVigente + Var_SaldoCapVenNExi);

		IF(Var_SaldoPago	<= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

		-- Pago de Interes Provisionado
		IF (Var_SaldoInteresPro >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoInteresPro;
			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
			END IF;

			CALL PAGCREINTPROPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,			Par_OrigenPago,		Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,       Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			SET	Var_MonPagoOri	:= Var_MonPagoOri - (Var_CantidPagar + Var_IVACantidPagar);

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		-- Pago de Interes Calculado no Contabilizado
		IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

			SET	Var_IVACantidPagar = ROUND((ROUND(Var_SaldoIntNoConta, 2) *  Var_ValIVAIntOr), 2);

			IF(ROUND(Var_SaldoPago,2)	>= (ROUND(Var_SaldoIntNoConta, 2) + Var_IVACantidPagar)) THEN
				SET	Var_CantidPagar		:=  Var_SaldoIntNoConta;
			ELSE
				SET	Var_CantidPagar		:= Var_SaldoPago -
										   ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);

				SET	Var_IVACantidPagar	:= ROUND(((Var_SaldoPago)/(1+Var_ValIVAIntOr)) * Var_ValIVAIntOr, 2);
			END IF;

			CALL PAGCREINTNOCPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Var_IVACantidPagar,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_DivContaIng,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - (Var_CantidPagar + Var_IVACantidPagar);
			SET	Var_MonPagoOri	:= Var_MonPagoOri - (Var_CantidPagar + Var_IVACantidPagar);

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;


		IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

			IF(Var_AmortizacionID = Var_MaxAmorti) THEN
				SET Var_CantidPagar	:= Var_SaldoPago;
			ELSE
				SET Var_CantidPagar := ROUND(Var_PorcentajePag * Var_MonPagoOri, 2);
			END IF;

			IF( Var_SaldoPago < Var_CantidPagar) THEN
				SET Var_CantidPagar := Var_SaldoPago;
			END IF;

			IF(Var_CantidPagar > Var_SaldoCapVigente) THEN
				SET	Var_CantidPagar	:= Var_SaldoCapVigente;
			END IF;

			CALL PAGCRECAPVIGPRO (
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Par_CuentaAhoID,
				Var_ClienteID,      Var_FechaSistema,   Var_FecAplicacion,  Var_CantidPagar,    Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Var_CuentaAhoStr,   Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago	:= Var_SaldoPago - Var_CantidPagar;

			-- =================== Se realizan los cambios a LINEASCREDITO ==========================

			IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN -- si el credito tiene linea de credito y si el pago es distinto de garantias agro
				IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si maneja linea de credito
					IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si es revolvente
						UPDATE LINEASCREDITO SET
							Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
							SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

							Usuario				= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP			= Aud_DireccionIP,
							ProgramaID			= Aud_ProgramaID,
							Sucursal			= Aud_Sucursal,
							NumTransaccion		= Aud_NumTransaccion
						WHERE LineaCreditoID	= Var_LineaCredito;
						-- se genera la parte contable  solo cuando es revolvente
						IF(Var_Poliza = Entero_Cero)THEN
							SET Var_AltaPoliza	:= AltaPoliza_SI;
						ELSE
							SET Var_AltaPoliza	:= AltaPoliza_NO;
						END IF;

						IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
							SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
							SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
						END IF;

						-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
						CALL CONTALINEASCREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Ref_PagAnti,			Var_LineaCredito,
							Var_AltaPoliza,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenDeu,
							Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				SalidaNO,				Par_NumErr,
							Par_ErrMen,			Var_Poliza,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF( Par_NumErr <> Entero_Cero ) THEN
							LEAVE ManejoErrores;
						END IF;

						CALL CONTALINEASCREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Ref_PagAnti,			Var_LineaCredito,
							AltaPoliza_NO,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenCor,
							Cadena_Vacia,		Nat_Abono,				Nat_Abono,				SalidaNO,				Par_NumErr,
							Par_ErrMen,			Var_Poliza,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF( Par_NumErr <> Entero_Cero ) THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE
						UPDATE LINEASCREDITO SET
							Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

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
			-- ==========================================================================

			IF(Var_SaldoPago	<= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;


		SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
		IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

			IF(Var_AmortizacionID = Var_MaxAmorti) THEN
				SET Var_CantidPagar	:= Var_SaldoPago;
			ELSE
				SET Var_CantidPagar := ROUND(Var_PorcentajePag * Var_MonPagoOri, 2);
			END IF;

			IF( Var_SaldoPago < Var_CantidPagar) THEN
				SET Var_CantidPagar := Var_SaldoPago;
			END IF;

			IF(Var_CantidPagar > Var_SaldoCapVenNExi) THEN
				SET	Var_CantidPagar	:= Var_SaldoCapVenNExi;
			END IF;

			CALL PAGCRECAPVNEPRO (
				Var_CreditoID,	    Var_AmortizacionID, 	Var_FechaInicio,	Var_FechaVencim,    Par_CuentaAhoID,
				Var_ClienteID,	    Var_FechaSistema,   	Var_FecAplicacion,	Var_CantidPagar,    Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,     	 	Var_ClasifCre,		Var_SubClasifID,    Var_SucCliente,
				Con_PagoCred,       Var_CuentaAhoStr,   	Var_Poliza,         Var_SalCapitales,	Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

			-- =================== Se realizan los cambios a LINEASCREDITO ==========================

			IF( Var_LineaCredito != Entero_Cero AND Var_PagoLineaCredito <> Con_PagoApliGarAgro ) THEN -- si el credito tiene linea de credito y si el pago es distinto de garantias agro
				IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si maneja linea de credito
					IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN  -- si es revolvente
						UPDATE LINEASCREDITO SET
							Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidPagar ,
							SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

							Usuario				= Aud_Usuario,
							FechaActual			= Aud_FechaActual,
							DireccionIP			= Aud_DireccionIP,
							ProgramaID			= Aud_ProgramaID,
							Sucursal			= Aud_Sucursal,
							NumTransaccion		= Aud_NumTransaccion
						WHERE LineaCreditoID	= Var_LineaCredito;
						-- se genera la parte contable  solo cuando es revolvente
						IF(Var_Poliza = Entero_Cero)THEN
							SET Var_AltaPoliza	:= AltaPoliza_SI;
						ELSE
							SET Var_AltaPoliza	:= AltaPoliza_NO;
						END IF;

						IF( Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
							SET ConcepCtaOrdenDeu := Con_CarCtaOrdenDeuAgro;
							SET ConcepCtaOrdenCor := Con_CarCtaOrdenCorAgro;
						END IF;

						-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
						CALL CONTALINEASCREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Ref_PagAnti,			Var_LineaCredito,
							Var_AltaPoliza,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenDeu,
							Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,				SalidaNO,				Par_NumErr,
							Par_ErrMen,			Var_Poliza,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF( Par_NumErr <> Entero_Cero ) THEN
							LEAVE ManejoErrores;
						END IF;

						CALL CONTALINEASCREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEASCREPRO
							Var_LineaCredito,	Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,		Var_CantidPagar,
							Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Ref_PagAnti,			Var_LineaCredito,
							AltaPoliza_NO,		Coc_PagoCred,			AltaPoliza_SI,			AltaMov_NO,				ConcepCtaOrdenCor,
							Cadena_Vacia,		Nat_Abono,				Nat_Abono,				SalidaNO,				Par_NumErr,
							Par_ErrMen,			Var_Poliza,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

						IF( Par_NumErr <> Entero_Cero ) THEN
							LEAVE ManejoErrores;
						END IF;
					ELSE
						UPDATE LINEASCREDITO SET
							Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidPagar,
							SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidPagar,

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
			-- ==========================================================================

			IF(Var_SaldoPago <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		END LOOP CICLO;
	END;
	CLOSE CURSORAMORTI;

	SET Par_MontoPago	 := Par_MontoPagar - Var_SaldoPago;

	IF (Par_MontoPago	<= Decimal_Cero) THEN
		SET Par_NumErr      := 10;
		SET Par_ErrMen      := 'El Credito no Presenta Adeudos.';
		LEAVE ManejoErrores;
	ELSE
		IF Var_PagoPerdCentRedond = Cons_Si THEN
			call PAGCREAJUSTEPERDPRO(
				Par_CreditoID,		Par_CuentaAhoID,	Var_ClienteID,		Var_FechaSistema,		Var_FecAplicacion,
				Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,		Var_SubClasifID,		Var_SucCliente,
				Var_Poliza,			Par_OrigenPago,		Cons_No,			Par_NumErr,				Par_ErrMen,
				Par_Consecutivo,	Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,        	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Marcamos como Pagadas las Amortizaciones que hayan sido afectadas en el Prepago y
		-- Que no Presenten adeudos
		UPDATE AMORTICREDITO Amo  SET
			Estatus      = Esta_Pagado,
			FechaLiquida = Var_FechaSistema
			WHERE (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
				  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
				  SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
				  SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) <= Tol_DifPago
			  AND Amo.CreditoID 	= Par_CreditoID
			AND FechaExigible > Var_FechaSistema
			  AND Estatus 	!= Esta_Pagado
			AND Amo.NumTransaccion = Aud_NumTransaccion;

		 -- Consulta las amortizaciones que no estan pagadas
		 SELECT COUNT(DISTINCT(AmortizacionID)) INTO Var_NumAmorti
			FROM AMORTICREDITO
			WHERE CreditoID	= Par_CreditoID
				AND Estatus	IN(Esta_Vigente, Esta_Atrasado, Esta_Vencido );


		 SET Var_NumAmorti := IFNULL(Var_NumAmorti, Entero_Cero);
			-- Verifica que no se haya prepagado el total del credito
			IF (Var_NumAmorti = Entero_Cero) THEN
				SET Par_NumErr      := 11;
				SET Par_ErrMen      := 'Para Liquidar el Credito, Por Favor Seleccione la Opcion Total Adeudo.' ;
				LEAVE ManejoErrores;
			END IF;


		CALL CONTAAHOPRO (
			Par_CuentaAhoID,    Var_CueClienteID,  		Aud_NumTransaccion, 	Var_FechaSistema,		Var_FecAplicacion,
			Nat_Cargo,          Par_MontoPago,  		Ref_PagAnti,        	Var_CreditoStr,     	Aho_PagoCred,
			Var_MonedaID,       Var_SucCliente, 		AltaPoliza_NO,      	Entero_Cero,        	Var_Poliza,
			AltaMovAho_SI,      Con_AhoCapital, 		Nat_Cargo,          	Par_Consecutivo,		SalidaNO,
			Par_NumErr,         Par_ErrMen,				Par_EmpresaID,  		Aud_Usuario,        	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     	Aud_Sucursal,   		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		CALL DEPOSITOPAGOCREPRO (
			Par_CreditoID,      Par_MontoPago,		Var_FechaSistema,		Par_EmpresaID,		SalidaNO,
			Par_NumErr,         Par_ErrMen,     	Par_Consecutivo,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

	-- Actualizacion de los intereses
	CALL AMORTICREDITOACT(
		Par_CreditoID,		TipoActInteres,    	SalidaNO,			Par_NumErr, 		Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	IF ( Var_EsReestruc   = SI_EsReestruc AND Var_EstCreacion  = Esta_Vencido AND Var_Frecuencia = Frec_Unico ) THEN
		-- Regularizacion del Credito
		SET Var_MontoPagado := (SELECT (Var_MontoCredito) - (SaldoCapVigent +
									SaldoCapAtrasad +
									SaldoCapVencido + SaldCapVenNoExi)
								FROM CREDITOS
									WHERE CreditoID   = Par_CreditoID);

		IF(Var_MontoPagado >= Var_PorcMontoCred) THEN

			CALL REGULARIZACREDPRO (
				Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,  	Var_Poliza,     Par_EmpresaID,
				SalidaNO,       	Par_NumErr,         Par_ErrMen,     	Par_ModoPago,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion	);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

        IF(Var_FrecInteres = Frec_Unico) THEN
			SET Var_DiasTrans := IFNULL((DATEDIFF(Var_FechaSistema,Var_FechaInicioCred)),Entero_Cero);
            SET Var_IntNoCont := (SELECT SaldoIntNoConta FROM CREDITOS WHERE CreditoID = Par_CreditoID);

			IF(Var_DiasTrans >= 90 AND Var_IntNoCont = Decimal_Cero) THEN
				CALL REGULARIZACREDPRO (
					Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,  	Var_Poliza,     Par_EmpresaID,
					SalidaNO,       	Par_NumErr,         Par_ErrMen,     	Par_ModoPago,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion	);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

		END IF;
	END IF;

	IF(Par_RespaldaCred = Cons_Si) THEN
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion,		Par_CuentaAhoID,	Par_CreditoID,		Par_MontoPagar,		Par_NumErr,
			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
      	END IF;
    END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'PrePago de Credito Aplicado Exitosamente.';

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
			Var_Poliza AS control,
			Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$

