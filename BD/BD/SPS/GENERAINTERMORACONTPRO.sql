-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERMORACONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS GENERAINTERMORACONTPRO;
DELIMITER $$


CREATE PROCEDURE GENERAINTERMORACONTPRO(
# =======================================================================
# -- STORE DE GENERACION DE INTERESES MORATORIOS CREDITOS CONTINGENTES-
# =======================================================================
    Par_Fecha           DATE,				-- Fecha
    Par_EmpresaID       INT(11),			-- ID de empresa

    Par_Salida 			CHAR(1),    		-- indica una salida
	INOUT	Par_NumErr	INT(11),			-- parametro numero de error
	INOUT	Par_ErrMen	VARCHAR(400),		-- mensaje de error

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN
	--  Declaracion de Variables
	DECLARE Var_CreditoID		BIGINT(12);
	DECLARE Var_AmortizacionID	INT;
	DECLARE Var_FechaInicio		DATE;
	DECLARE Var_FechaVencim		DATE;
	DECLARE Var_FechaExigible   DATE;
	DECLARE Var_EmpresaID		INT;
	DECLARE Var_CreCapVig		DECIMAL(14,2);
	DECLARE Var_AmoCapVig		DECIMAL(14,2);
	DECLARE Var_AmoCapVNE		DECIMAL(14,2);
	DECLARE Var_FormulaID 		INT(11);
	DECLARE Var_TasaFija 		DECIMAL(12,4);
	DECLARE Var_MonedaID		INT(11);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_StatuAmort		CHAR(1);
	DECLARE Var_SucCliente	  	INT;
	DECLARE Var_ProdCreID		INT;
	DECLARE Var_ClasifCre       CHAR(1);
	DECLARE Var_FactorMora		DECIMAL(10,4);
	DECLARE Var_CreditoStr 		VARCHAR(30);
	DECLARE Var_ValorTasa		DECIMAL(12,4);
	DECLARE Var_DiasCredito		DECIMAL(10,2);
	DECLARE Var_IntereMor		DECIMAL(12,4);
	DECLARE Var_ComFalPag		CHAR(1);
	DECLARE Var_MontoFalPag		DECIMAL(12,4);
	DECLARE Var_IntProvis		DECIMAL(14,4);
	DECLARE Var_IntAtrasado		DECIMAL(14,4);
	DECLARE Var_IntVencido		DECIMAL(14,4);
	DECLARE Var_FecMorato		DATE;
	DECLARE Var_FecFalPago		DATE;
	DECLARE Var_FecPasAtr       DATE;
	DECLARE Var_EsReestruc		CHAR(1);
	DECLARE Var_EstCreacion     CHAR(1);
	DECLARE Var_Regularizado    CHAR(1);
	DECLARE Var_CriComFalPag    CHAR(1);
	DECLARE Var_MinComFalPag    DECIMAL(12,2);
	DECLARE Var_AmoTotCuota     DECIMAL(14,2);
	DECLARE Var_AmoCapital      DECIMAL(14,2);
	DECLARE Var_SalIntNoConta   DECIMAL(14,4);
	DECLARE Var_CobFaltaPago    CHAR(1);
	DECLARE Var_CobraMora       CHAR(1);
	DECLARE Var_TipCobComMor    CHAR(1);
	DECLARE Var_TipCobFalPago   CHAR(1);
	DECLARE Var_PerCobFalPag    CHAR(1);
	DECLARE Var_ProComFalPag    CHAR(1);
	DECLARE Var_FecApl          DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE SalCapital          DECIMAL(14,2);
	DECLARE DiasInteres         DECIMAL(10,2);
	DECLARE Var_CapAju          DECIMAL(14,2);
	DECLARE Ref_GenInt          VARCHAR(50);
	DECLARE Error_Key           INT;
	DECLARE Mov_AboConta		INT;
	DECLARE Mov_CarConta		INT;
	DECLARE Mov_CarOpera		INT;
	DECLARE Mov_AboOpera		INT;
	DECLARE Var_Poliza          BIGINT;
	DECLARE Par_ErrMen          VARCHAR(100);
	DECLARE Par_Consecutivo     BIGINT;
	DECLARE Var_ContadorCre     INT;
	DECLARE Var_DifMorMov       DECIMAL(14,2);  -- almacena el valor del abonos - cargos  de los movimientos cuando se cobra mora y los dias de gracia ya vencieron
	DECLARE Var_BaseComisi      DECIMAL(14,2);
	DECLARE Var_TipoComision    CHAR(1);
	DECLARE Var_Comision        DECIMAL(12,4);
	DECLARE Var_CapAmorti       DECIMAL(14,2);
	DECLARE Var_SolCreditoID    BIGINT;
	DECLARE Var_GrupoID         INT;
	DECLARE Var_Ciclo           INT;
	DECLARE Var_NumIntegra      INT;
	DECLARE Var_NumCobFalPag    INT;
	DECLARE Var_AplFaltaPago    CHAR(1);
	DECLARE Var_SubClasifID     INT;
	DECLARE Var_CicloActual     INT;
	DECLARE Var_SucursalCred	INT;
	DECLARE	Var_TipoContaMora	CHAR(1);
	DECLARE Var_ComFalPagM  	CHAR(1);
	DECLARE Var_ComFalPagP  	CHAR(1);
    DECLARE Var_Control			VARCHAR(100);
    DECLARE Var_Consecutivo		BIGINT;
	-- Declaracion de Constantes
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Estatus_Vencida 	CHAR(1);
	DECLARE Estatus_Atrasado  	CHAR(1);
	DECLARE Cre_Vencido     	CHAR(1);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Dec_Cien        	DECIMAL(10,2);
	DECLARE Com_MonOriCap   	CHAR(1);
	DECLARE Com_MonOriTot   	CHAR(1);
	DECLARE Com_SaldoAmo    	CHAR(1);
	DECLARE Pro_PasoAtras   	INT;
	DECLARE Mora_NVeces         CHAR(1);
	DECLARE Mora_TasaFija       CHAR(1);
	DECLARE Mov_MoraVigen 		INT;
	DECLARE Mov_MoraCarVen 		INT;
	DECLARE Mov_CapAtrasado 	INT;
	DECLARE Mov_CapVigente  	INT;
	DECLARE Mov_CapVencido  	INT;
	DECLARE Mov_ComFalPago  	INT;
	DECLARE Mov_InterPro    	INT;
	DECLARE Mov_IntAtras    	INT;
	DECLARE Mov_IntVencido  	INT;
	DECLARE Mov_CapVenNoEx  	INT;
	DECLARE Con_CueOrdMor   	INT;
	DECLARE Con_CorOrdMor   	INT;
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE Con_GenIntere   	INT;
	DECLARE Salida_NO    		CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE Des_CieDia      	VARCHAR(100);
	DECLARE TipoMovCapOrd  		INT;
	DECLARE TipoMovCapAtr   	INT;
	DECLARE TipoMovCapVen   	INT;
	DECLARE TipoMovCapVN    	INT;
	DECLARE No_EsReestruc   	CHAR(1);
	DECLARE Si_EsReestruc   	CHAR(1);
	DECLARE Si_Regulariza   	CHAR(1);
	DECLARE No_Regulariza   	CHAR(1);
	DECLARE Act_PagoSost    	INT;
	DECLARE SI_CobraMora    	CHAR(1);
	DECLARE SI_CobraFalPag  	CHAR(1);
	DECLARE NO_CobraFalPag  	CHAR(1);
	DECLARE SI_Prorratea    	CHAR(1);
	DECLARE Inte_Activo     	CHAR(1);
	DECLARE Per_Diario      	CHAR(1);
	DECLARE Per_Evento      	CHAR(1);
	DECLARE Por_Amorti      	CHAR(1);
	DECLARE Por_Credito     	CHAR(1);
	DECLARE Mora_CtaOrden		CHAR(1);
    DECLARE Salida_SI			CHAR(1);
	DECLARE Des_ErrorGral      	VARCHAR(100);
	DECLARE Des_ErrorLlavDup    VARCHAR(100);
	DECLARE Des_ErrorCallSP     VARCHAR(100);
	DECLARE Des_ErrorValNulos   VARCHAR(100);

	-- Cursor para Obtener todas la cuotas que Presentan atrasado (Considerando Dias de Gracia)
	DECLARE CURSORINTERMOR CURSOR FOR
		SELECT  CreditoID,          AmortizacionID,     FechaInicio,        FechaVencim,        FechaExigible,
				EmpresaID,          SaldoCapVigent,     SaldoCapVenNExi,    CalcInteresID,      TasaFija,
				MonedaID,           CreEstatus,         SucursalOrigen,     ProductoCreditoID,  TipoProduc,
				FactorMora,         SaldoCapital,       CapitalVigente,     AmoEstatus,         AmoSaldoInteresPro,
				AmoSaldoInteresAtr, AmoSaldoInteresVen, AmoFecGraMora,      AmoFecGraCom,       AmoFecGraAtr,
				EsReestructura,     ReestEstCreacion,   ReestRegularizado,  CriterioComFalPag,  MontoMinComFalPag,
				AmoTotCuota,        AmoCapital,         AmoSaldoIntNoConta, CobraFaltaPago,     CobraMora,
				TipCobComMorato,    TipCobComFalPago,   PerCobComFalPag,    ProrrateoComFalPag, SolicitudCreditoID,
				GrupoID,            Ciclo,              SubClasifID,		SucursalCredito
		FROM TMPCREDCIEMORA
			WHERE ( AmoFecGraMora <= Par_Fecha
			   OR   AmoFecGraCom  <= Par_Fecha
			   OR   AmoFecGraAtr <= Par_Fecha
               OR 	AmortizacionID=1);

	TRUNCATE TABLE TMPCREDCIEMORA;
	INSERT INTO TMPCREDCIEMORA    (
				CreditoID,					AmortizacionID,					FechaInicio,					FechaVencim,					FechaExigible,
				EmpresaID,					SaldoCapVigent,					SaldoCapVenNExi,				CalcInteresID,				TasaFija,
				MonedaID,						CreEstatus,						SucursalOrigen,				ProductoCreditoID,			TipoProduc,
				FactorMora,					SaldoCapital,						CapitalVigente,				AmoEstatus,				AmoSaldoInteresPro,
				AmoSaldoInteresAtr,			AmoSaldoInteresVen,				AmoFecGraMora,				AmoFecGraCom,					AmoFecGraAtr,
				EsReestructura,				ReestEstCreacion,					ReestRegularizado,			CriterioComFalPag,			MontoMinComFalPag,
				AmoTotCuota,					AmoCapital,						AmoSaldoIntNoConta,			CobraFaltaPago,				CobraMora,
				TipCobComMorato,				TipCobComFalPago,					PerCobComFalPag,				ProrrateoComFalPag,		SolicitudCreditoID,
				GrupoID,						Ciclo,							SubClasifID,					SucursalCredito)
    SELECT  Cre.CreditoID,        Amo.AmortizacionID,     Amo.FechaInicio,    Amo.FechaVencim,
			Amo.FechaExigible,    Cre.EmpresaID,          Cre.SaldoCapVigent, Amo.SaldoCapVenNExi,
            CalcInteresID,        Cre.TasaFija,			  Cre.MonedaID,		  Cre.Estatus,
            Cli.SucursalOrigen,	  Cre.ProductoCreditoID,  Des.Clasificacion,  Cre.FactorMora,

                (Amo.SaldoCapVigente+Amo.SaldoCapAtrasa+Amo.SaldoCapVencido+Amo.SaldoCapVenNExi),
                Amo.SaldoCapVigente,	Amo.Estatus,   Amo.SaldoInteresPro,    Amo.SaldoInteresAtr,
             Amo.SaldoInteresVen,
             -- Este Case se puso aqui, para discriminar y no evaluar aquellas amortizaciones
             -- muy Viejas (Cuya Fecha de Exigibilidad tiene mas de los Dias de gracia
             -- del producto mas 15 dias de "Colchon") para que no evalue la funcion FUNCIONDIAHABIL
             -- Esto para ayudar a mejorar el preformance del cierre y hacer menos evaluaciones.
             CASE WHEN Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (GraciaMoratorios + 15 ) DAY) THEN
                        Amo.FechaExigible
				  WHEN Amo.AmortizacionID =1 THEN
					    Bic.FechaAtraso
                  ELSE
                        FUNCIONDIAHABIL(Amo.FechaExigible, GraciaMoratorios, Par_EmpresaID)
             END,
             CASE WHEN Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (GraciaFaltaPago + 15 ) DAY) THEN
                       Amo.FechaExigible
                  ELSE
                        FUNCIONDIAHABIL(Amo.FechaExigible, GraciaFaltaPago, Par_EmpresaID)
             END,
             CASE WHEN Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (DiasPasoAtraso + 15 ) DAY) THEN
                       Amo.FechaExigible
                  ELSE
                        FUNCIONDIAHABIL(Amo.FechaExigible, DiasPasoAtraso, Par_EmpresaID)
             END,
             Pro.EsReestructura,   		Cadena_Vacia, 			Cadena_Vacia,  			Pro.CriterioComFalPag,
             Pro.MontoMinComFalPag,  	(Amo.Capital + Amo.Interes + Amo.IVAInteres),   Amo.Capital,
             Amo.SaldoIntNoConta,       Pro.CobraFaltaPago,     Pro.CobraMora,          Cre.TipCobComMorato,
             Pro.TipCobComFalPago,      Pro.PerCobComFalPag,    Pro.ProrrateoComFalPag,	Cre.SolicitudCreditoID,
			 Cre.GrupoID,            	Cre.CicloGrupo,  		Des.SubClasifID,		Cre.SucursalID

            FROM AMORTICREDITOCONT Amo,
                 CLIENTES Cli,
                 PRODUCTOSCREDITO Pro,
                 DESTINOSCREDITO Des,
                 BITACORAAPLIGAR Bic,
                 CREDITOSCONT Cre

            WHERE Amo.CreditoID = Cre.CreditoID
				AND Cre.ClienteID = Cli.ClienteID
				AND Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Cre.DestinoCreID  = Des.DestinoCreID
                AND Cre.CreditoID = Bic.CreditoID
				AND Amo.Estatus IN('V','A','B')
				AND Cre.Estatus	IN('V','B')
				AND  (Amo.FechaExigible <= Par_Fecha);

	--  Asignacion de Constantes
	SET Estatus_Vigente 	:= 'V';             	-- Estatus Amortizacion: Vigente
	SET Estatus_Vencida 	:= 'B';            	 	-- Estatus Amortizacion: Vencido
	SET Estatus_Atrasado    := 'A';             	-- Estatus Amortizacion: Atrasado
	SET Cre_Vencido     	:= 'B';             	-- Estatus Credito: Vencido
	SET Cadena_Vacia    	:= '';                  -- Cadena Vacia
	SET Fecha_Vacia     	:= '1900-01-01';        -- Fecha Vacia
	SET Entero_Cero     	:= 0;                   -- Entero en Cero
	SET Decimal_Cero    	:= 0.00;                -- Decimal Cero
	SET Nat_Cargo       	:= 'C';                 -- Naturaleza de Cargo
	SET Nat_Abono       	:= 'A';                 -- Naturaleza de Cargo
	SET Dec_Cien        	:= 100.00;              -- Decimal Cien
	SET Com_MonOriCap   	:= 'C';                 -- Criterio Comision: Monto Original de la Cuota Capital
	SET Com_MonOriTot   	:= 'T';                 -- Criterio Comision: Monto Original de la Cuota Capital + Int + IVA
	SET Com_SaldoAmo    	:= 'S';                 -- Criterio Comision: Saldo de la Cuota
	SET Var_ComFalPagM 		:= 'M';                 -- Tipo de Comision por Falta de Pago: Monto
	SET Var_ComFalPagP 		:= 'P';                 -- Tipo de Comision por Falta de Pago: Porcentaje
	SET Mora_NVeces     	:= 'N';                 -- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
	SET Mora_TasaFija   	:= 'T';                 -- Tipo de Cobro de Moratorios: Tasa Fija Anualizada
	SET Pro_PasoAtras   	:= 1402;                -- Numero de Proceso Batch: Trapsaso a Atrasado
	SET Mov_MoraVigen 		:= 15;                  -- Tipo de Movimiento de Credito: Moratorios
	SET	Mov_MoraCarVen		:= 17;					-- Tipo de Movimiento de Credito: Moratorios de Cartera Vencida
	SET Mov_CapAtrasado 	:= 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
	SET Mov_CapVigente  	:= 1;                   -- Tipo de Movimiento de Credito: Capital Vigente
	SET Mov_ComFalPago  	:= 40;                  -- Tipo de Movimiento de Credito: Comision x Falta de Pago
	SET Mov_InterPro    	:= 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
	SET Mov_IntAtras    	:= 11;                  -- Tipo de Movimiento de Credito: Interes Atrasado
	SET Mov_CapVencido  	:= 3;                   -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_IntVencido  	:= 12;                  -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_CapVenNoEx  	:= 4;                   -- Tipo de Movimiento de Credito: Capital Vencido no Exigible
	SET Con_CueOrdMor   	:= 74;                  -- Concepto Contable: Cuentas de Orden de Moratorios
	SET Con_CorOrdMor   	:= 75;                  -- Concepto Contable: Correlativa de Orden de Moratorios
	SET Pol_Automatica  	:= 'A';                 -- Tipo de Poliza: Automatica
	SET Con_GenIntere   	:= 52;                  -- Tipo de Proceso Contable: Generacion de Interes de Cartera
	SET Salida_NO    		:= 'N';                 -- El store no Arroja una Salida
	SET AltaPoliza_NO   	:= 'N';                 -- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI   	:= 'S';                 -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO   	:= 'N';                 -- Alta del Movimiento de Credito: SI
	SET AltaMovCre_SI   	:= 'S';                 -- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO   	:= 'N';                 -- Alta del Movimiento de Ahorro: NO
	SET SI_Prorratea    	:= 'S';                 -- SI Prorratea la Comision por Falta de Pago
	SET Inte_Activo     	:= 'A';                 -- Integrante Activo del Grupo
	SET Per_Diario      	:= 'D';                 -- Periodiciad en el Cobro de FalPago: Diario
	SET Per_Evento     		:= 'C';                 -- Periodiciad en el Cobro de FalPago: Por Evento o Atraso
	SET Por_Amorti      	:= 'A';                 -- Tipo de Cobro de FalPago: Por Amortizacion
	SET Por_Credito     	:= 'C';                 -- Tipo de Cobro de FalPago: Por Credito
    SET Salida_SI			:= 'S';
	SET Des_CieDia      	:= 'CIERRE DIARO CREDITOS CONTINGENTES';
	SET Ref_GenInt      	:= 'GENERACION INTERES MORATORIO CONTINGENTE';
	SET TipoMovCapOrd   	:= 1;                   -- Tipo de Movimiento de Credito: Capital Ordinario
	SET TipoMovCapAtr   	:= 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
	SET TipoMovCapVen   	:= 3;                   -- Tipo de Movimiento de Credito: Capital Vencido
	SET TipoMovCapVN    	:= 4;                   -- Tipo de Movimiento de Credito: Capital Vencido No Exigible.
	SET No_EsReestruc       := 'N';            		 -- El Producto de Credito no es para Reestructuras
	SET Si_EsReestruc       := 'S';             	-- El credito si es una Reestructura
	SET Si_Regulariza       := 'S';            	 	-- La Reestructura ya fue Regularizada
	SET No_Regulariza       := 'N';            		 -- La Reestructura NO ha sido Regularizada
	SET Act_PagoSost        := 2;               	-- Tipo de Actualizacion de la Reest: Pagos Sostenidos
	SET SI_CobraMora        := 'S';             -- Si Cobra Interes Moratorio
	SET SI_CobraFalPag      := 'S';             -- Si Cobra Comisicion por Falta de Pago
	SET NO_CobraFalPag      := 'N';             -- No Cobra Comisicion por Falta de Pago
	SET Mora_CtaOrden		:= 'C';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden
	SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-GENERAINTERMORACONTPRO');
			SET Var_Control := 'sqlexception';
		END;


		SELECT DiasCredito,	TipoContaMora INTO Var_DiasCredito, Var_TipoContaMora FROM PARAMETROSSIS;

		SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);
		SET Var_FecApl	:= Par_Fecha;

		SELECT   COUNT(CreditoID) INTO Var_ContadorCre FROM TMPCREDCIEMORA;
		SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

		IF (Var_ContadorCre > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Par_EmpresaID,		Var_FecApl, 			Pol_Automatica,			Con_GenIntere,
				Ref_GenInt,			Salida_No, 			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		OPEN CURSORINTERMOR;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORINTERMOR INTO
				Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
				Var_EmpresaID,      Var_CreCapVig,      Var_AmoCapVNE,      Var_FormulaID,      Var_TasaFija,
				Var_MonedaID,       Var_Estatus,        Var_SucCliente,     Var_ProdCreID,      Var_ClasifCre,
				Var_FactorMora,     SalCapital,         Var_AmoCapVig,      Var_StatuAmort,     Var_IntProvis,
				Var_IntAtrasado,    Var_IntVencido,     Var_FecMorato,      Var_FecFalPago,     Var_FecPasAtr,
				Var_EsReestruc,     Var_EstCreacion,    Var_Regularizado,   Var_CriComFalPag,   Var_MinComFalPag,
				Var_AmoTotCuota,    Var_AmoCapital,     Var_SalIntNoConta,  Var_CobFaltaPago,   Var_CobraMora,
				Var_TipCobComMor,   Var_TipCobFalPago,  Var_PerCobFalPag,   Var_ProComFalPag,   Var_SolCreditoID,
				Var_GrupoID,        Var_Ciclo,          Var_SubClasifID,	Var_SucursalCred;

			START TRANSACTION;
			BEGIN

				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

			-- Inicializacion
			SET Error_Key           := Entero_Cero;
			SET DiasInteres         := Entero_Cero;
			SET Var_CapAju          := Entero_Cero;
			SET Var_IntereMor       := Entero_Cero;
			SET Var_ValorTasa       := Entero_Cero;
			SET Var_CapAmorti       := Entero_Cero;
			SET Var_NumCobFalPag    := Entero_Cero;
			SET Var_AplFaltaPago    := Cadena_Vacia;
			SET Var_EstCreacion     := IFNULL(Var_EstCreacion, Cadena_Vacia);
			SET Var_Regularizado    := IFNULL(Var_Regularizado, Cadena_Vacia);
			SET Var_SolCreditoID    := IFNULL(Var_SolCreditoID, Entero_Cero);
			SET Var_GrupoID         := IFNULL(Var_GrupoID, Entero_Cero);
			SET Var_Ciclo           := IFNULL(Var_Ciclo, Entero_Cero);
			SET Var_NumIntegra      := IFNULL(Var_NumIntegra, Entero_Cero);
			SET	Var_SucursalCred	:= IFNULL(Var_SucursalCred, Aud_Sucursal);
			SET Var_EsReestruc  	:= No_EsReestruc;

			# ======================== GENERACION DE MORATORIOS ==============================
			 -- Generacion de Intereses moratorios
			IF(Var_FecMorato <= Par_Fecha AND Var_CobraMora = SI_CobraMora) THEN


				-- Si se contabiliza en cuentas de orden o en cuentas de ingresos
				SET Mov_AboConta    := Con_CorOrdMor;
				SET Mov_CarConta    := Con_CueOrdMor;
				SET Mov_CarOpera    := Mov_MoraVigen;

				SET SalCapital      := IFNULL(SalCapital,Entero_Cero);

				CALL CRECALCULOTASACONTPRO(
					Var_CreditoID,  Var_FormulaID,  	Var_TasaFija,   	Par_Fecha,          Var_FechaInicio,
					Var_EmpresaID,  Var_ValorTasa,  	Salida_No, 			Par_NumErr,			Par_ErrMen,
					Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				/*cuando el cliente no ha pagado y terminan sus dias de gracia, se generan los intereses
				  desde el primer dia de no pago hasta el dia de hoy. */
				IF (Var_TipCobComMor = Mora_NVeces) THEN
					SET Var_FactorMora  := Var_FactorMora * Var_ValorTasa;
				END IF;

				IF (Var_FecMorato = Par_Fecha) THEN
					-- Calculo de la Mora Acumulada por los Pagos Realizados en el Transcurso de los
					-- Dias de Gracia para la Generacion de Moratorios
					SET Var_DifMorMov := IFNULL(
							(SELECT SUM(DATEDIFF(FechaOperacion, Var_FechaExigible) * (Var_FactorMora) *
									(IFNULL(LOCATE(Nat_Abono, Mov.NatMovimiento) * IFNULL(Mov.Cantidad, Decimal_Cero), Decimal_Cero) -
									 IFNULL(LOCATE(Nat_Cargo, Mov.NatMovimiento) * IFNULL(Mov.Cantidad, Decimal_Cero), Decimal_Cero)) /
									  (Var_DiasCredito * Dec_Cien))
										FROM CREDITOSCONTMOVS Mov
										WHERE CreditoID = Var_CreditoID
											AND FechaOperacion > Var_FechaExigible
											AND FechaOperacion <= Par_Fecha
											AND AmortiCreID = Var_AmortizacionID
											AND    TipoMovCreID	IN( TipoMovCapOrd ,TipoMovCapAtr , TipoMovCapVen, TipoMovCapVN) ), Decimal_Cero);

					SET	DiasInteres   := (SELECT DATEDIFF(Par_Fecha, Var_FechaExigible) + 1);

					SET Var_IntereMor := (ROUND(SalCapital *  Var_FactorMora /
												(Var_DiasCredito * Dec_Cien) * DiasInteres, 2)  + Var_DifMorMov);
				ELSE
						-- cuando ya pasaron sus dias de Gracia, se generan los intereses moratorios del dia
						SET DiasInteres	:= 1;
						SET SalCapital  :=IFNULL(SalCapital,Entero_Cero);
						SET	Var_IntereMor := ROUND(SalCapital * Var_FactorMora * DiasInteres /
											(Var_DiasCredito * Dec_Cien), 2);
				END IF; -- EndIF del Tipo de Calculo de los Moratorios

				-- se realizan los movimientos contables y operativos del cargo por interes moratorio
				IF (Var_IntereMor > Decimal_Cero) THEN

					CALL CONTACREDITOSCONTPRO (
						Var_CreditoID,      	Var_AmortizacionID, 	Entero_Cero,        Entero_Cero,    		Par_Fecha,
						Var_FecApl,				Var_IntereMor,			Var_MonedaID,		Var_ProdCreID,  		Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,			Des_CieDia,			Ref_GenInt,				AltaPoliza_NO,
						Entero_Cero,        	Var_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,			Mov_CarConta,
						Mov_CarOpera,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
						Salida_NO,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,
						Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Var_SucursalCred,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTACREDITOSCONTPRO (
						Var_CreditoID,      	Var_AmortizacionID, 	Entero_Cero,        Entero_Cero,    		Par_Fecha,
						Var_FecApl,				Var_IntereMor,			Var_MonedaID,		Var_ProdCreID,  		Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,			Des_CieDia,			Ref_GenInt,				AltaPoliza_NO,
						Entero_Cero,        	Var_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,			Mov_AboConta,
						Entero_Cero,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
						Salida_NO,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,
						Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Var_SucursalCred,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF; -- Endif de Var_IntereMor (Moratorios) mayor que cero
			END IF; -- EndIf Generacion de Intereses moratorios
			# ============================= CALCULO DE LA COMISION POR FALTA DE PAGO ==============================
		END; -- End del Begin Handler

		SET Var_CreditoStr := CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;

		IF Error_Key = 0 THEN
			COMMIT;
		END IF;

		IF Error_Key = 1 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Pro_PasoAtras, 		Par_Fecha, 			Var_CreditoStr,    	Des_ErrorGral, 			Var_EmpresaID,
					Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
					Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF Error_Key = 2 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
				Pro_PasoAtras,  Par_Fecha,      Var_CreditoStr,     Des_ErrorLlavDup,
				Var_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF Error_Key = 3 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
				Pro_PasoAtras,  Par_Fecha,      Var_CreditoStr,     Des_ErrorCallSP,
				Var_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF Error_Key = 4 THEN
			ROLLBACK;
			START TRANSACTION;

				CALL EXCEPCIONBATCHALT(
				Pro_PasoAtras,  Par_Fecha,      Var_CreditoStr,     Des_ErrorValNulos,
				Var_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
			COMMIT;
		END IF;
		END LOOP;
		END;

		CLOSE CURSORINTERMOR;



		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Informacion Procesada Exitosamente.';
		SET Var_Control	:= 'creditoID' ;
		SET Var_Consecutivo := IFNULL(Par_Consecutivo, Entero_Cero);

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT	Par_NumErr 	AS NumErr,
			Par_ErrMen 	AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo	AS consecutivo;
END IF;

END TerminaStore$$
