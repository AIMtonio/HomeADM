-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERMORAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS GENERAINTERMORAPRO;
DELIMITER $$


CREATE PROCEDURE GENERAINTERMORAPRO(
    Par_Fecha           DATE,
    Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
			)

TerminaStore: BEGIN

/* Declaracion de Variables */
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
DECLARE Mora_NVeces         CHAR(1);
DECLARE Mora_TasaFija       CHAR(1);
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
DECLARE Ref_PasoAtraso      VARCHAR(50);
DECLARE Ref_CobraInt        VARCHAR(50);
DECLARE Des_Poliza          VARCHAR(150);
DECLARE Error_Key           INT;
DECLARE Mov_AboConta		INT;
DECLARE Mov_CarConta		INT;
DECLARE Mov_CarOpera		INT;
DECLARE Mov_AboOpera		INT;
DECLARE Var_Poliza          BIGINT;
DECLARE Par_NumErr          INT(11);
DECLARE Par_ErrMen          VARCHAR(400);
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
DECLARE Var_AmorVencido		INT(11);		-- Variable de conteo de amortisaciones vencidas del credito

/* Declaracion de Constantes */
DECLARE Estatus_Vigente CHAR(1);
DECLARE Estatus_Vencida CHAR(1);
DECLARE Estatus_Atrasado  CHAR(1);
DECLARE Cre_Vencido     CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Dec_Cien        DECIMAL(10,2);
DECLARE Com_MonOriCap   CHAR(1);
DECLARE Com_MonOriTot   CHAR(1);
DECLARE Com_SaldoAmo    CHAR(1);
DECLARE Pro_PasoAtras   INT;
DECLARE Var_ComFalPagM  CHAR(1);
DECLARE Var_ComFalPagP  CHAR(1);
DECLARE Mov_MoraVigen 	INT;
DECLARE Mov_MoraCarVen 	INT;
DECLARE Mov_CapAtrasado INT;
DECLARE Mov_CapVigente  INT;
DECLARE Mov_CapVencido  INT;
DECLARE Mov_ComFalPago  INT;
DECLARE Mov_InterPro    INT;
DECLARE Mov_IntAtras    INT;
DECLARE Mov_IntVencido  INT;
DECLARE Mov_CapVenNoEx  INT;
DECLARE Con_CueOrdMor   INT;
DECLARE Con_CorOrdMor   INT;
DECLARE Con_MoraDeven   INT;
DECLARE Con_MoraIngreso	INT;
DECLARE Con_CapVigente  INT;
DECLARE Con_CapAtrasado INT;
DECLARE Con_CapVencido  INT;
DECLARE Con_CueOrdComFP INT;
DECLARE Con_CorOrdComFP INT;
DECLARE Con_IntDevVig   INT;
DECLARE Con_IntAtrasado INT;
DECLARE Con_IntVencido  INT;
DECLARE Con_CapVenNoEx  INT;
DECLARE Pol_Automatica  CHAR(1);
DECLARE Con_GenIntere   INT;
DECLARE Par_SalidaNO    CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE Des_CieDia      VARCHAR(100);
DECLARE TipoMovCapOrd   INT;
DECLARE TipoMovCapAtr   INT;
DECLARE TipoMovCapVen   INT;
DECLARE TipoMovCapVN    INT;
DECLARE No_EsReestruc   CHAR(1);
DECLARE Si_EsReestruc   CHAR(1);
DECLARE Si_Regulariza   CHAR(1);
DECLARE No_Regulariza   CHAR(1);
DECLARE Act_PagoSost    INT;
DECLARE SI_CobraMora    CHAR(1);
DECLARE SI_CobraFalPag  CHAR(1);
DECLARE NO_CobraFalPag  CHAR(1);
DECLARE SI_Prorratea    CHAR(1);
DECLARE Inte_Activo     CHAR(1);
DECLARE Per_Diario      CHAR(1);
DECLARE Per_Evento      CHAR(1);
DECLARE Por_Amorti      CHAR(1);
DECLARE Por_Credito     CHAR(1);
DECLARE Mora_CtaOrden	CHAR(1);
DECLARE Des_ErrorGral      	VARCHAR(100);
DECLARE Des_ErrorLlavDup    VARCHAR(100);
DECLARE Des_ErrorCallSP     VARCHAR(100);
DECLARE Des_ErrorValNulos   VARCHAR(100);

DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido
DECLARE Con_IntDevenSup		INT(11);	-- Concepto Contable Interes Devengado Supencion
DECLARE Con_IntAtrasadoSup	INT(11);	-- Concepto Contable: Interes Atrasado Suspendido
DECLARE Con_IntVencidoSup	INT(11);	-- Concepto Contable: Interes Vencido Suspendido
DECLARE Con_CapVigenteSup	INT(11);	-- Concepto Contable: Capital Vigente Suspendido
DECLARE Con_CapAtrasadoSup	INT(11);	-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
DECLARE Con_CapVencidoSup	INT(11);	-- Concepto Contable: Capital Vencido Suspendido
DECLARE Con_CapVenNoExSup	INT(11);	-- Concepto Contable: Capital Vencido no Exigible Suspendido
DECLARE Var_EsConsolidacionAgro CHAR(1);  -- Es Credito Consolidado
DECLARE Var_EsConsolidado       VARCHAR(1); -- El credito es una consolidacion no agropecuaria
DECLARE Var_EstatusCosolidacion CHAR(1);  -- Estatus del credito al momento de la consolidacion
DECLARE Var_EsRegularizado      CHAR(1);  -- Si la conlidacion es Regularizada
DECLARE Act_PagoSostenido INT(11);  -- Actualizacion de Pago Sostenido
DECLARE Con_SI            CHAR(1);  -- Constante SI
DECLARE Con_NO            CHAR(1);  -- Constante NO

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
       OR   AmoFecGraAtr <= Par_Fecha );



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
                Amo.SaldoCapVigente,	Amo.Estatus,                Amo.SaldoInteresPro,    Amo.SaldoInteresAtr,
             Amo.SaldoInteresVen,
             -- Este Case se puso aqui, para discriminar y no evaluar aquellas amortizaciones
             -- muy Viejas (Cuya Fecha de Exigibilidad tiene mas de los Dias de gracia
             -- del producto mas 15 dias de "Colchon") para que no evalue la funcion FUNCIONDIAHABIL
             -- Esto para ayudar a mejorar el preformance del cierre y hacer menos evaluaciones.
             CASE WHEN Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (GraciaMoratorios + 15 ) DAY) THEN
                        Amo.FechaExigible
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
             Pro.EsReestructura,   		Res.EstatusCreacion, 	Res.Regularizado,  		Pro.CriterioComFalPag,
             Pro.MontoMinComFalPag,  	(Amo.Capital + Amo.Interes + Amo.IVAInteres),   Amo.Capital,
             Amo.SaldoIntNoConta,       Pro.CobraFaltaPago,     Pro.CobraMora,          Cre.TipCobComMorato,
             Pro.TipCobComFalPago,      Pro.PerCobComFalPag,    Pro.ProrrateoComFalPag,	Cre.SolicitudCreditoID,
			 Cre.GrupoID,            	Cre.CicloGrupo,  		Des.SubClasifID,		Cre.SucursalID

            FROM AMORTICREDITO Amo,
                 CLIENTES Cli,
                 PRODUCTOSCREDITO Pro,
                 DESTINOSCREDITO Des,
                 CREDITOS Cre
          LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
            WHERE Amo.CreditoID 	= Cre.CreditoID
              AND Cre.ClienteID		= Cli.ClienteID
              AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
              AND Cre.DestinoCreID  = Des.DestinoCreID
			AND (Amo.Estatus		=  'V'
				OR Amo.Estatus		=  'A'
				OR Amo.Estatus		=  'B')
              AND (Cre.Estatus		=  'V'
				OR Cre.Estatus		=  'B'
				OR Cre.Estatus		=  'S')
              AND  Amo.FechaExigible <= Par_Fecha;



/* Asignacion de Constantes */
SET Estatus_Vigente 	:= 'V';             -- Estatus Amortizacion: Vigente
SET Estatus_Vencida 	:= 'B';             -- Estatus Amortizacion: Vencido
SET Estatus_Atrasado    := 'A';             -- Estatus Amortizacion: Atrasado
SET Cre_Vencido     	:= 'B';             -- Estatus Credito: Vencido
SET Cadena_Vacia    := '';                  -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     := 0;                   -- Entero en Cero
SET Decimal_Cero    := 0.00;                -- Decimal Cero
SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
SET Nat_Abono       := 'A';                 -- Naturaleza de Cargo
SET Dec_Cien        := 100.00;              -- Decimal Cien
SET Com_MonOriCap   := 'C';                 -- Criterio Comision: Monto Original de la Cuota Capital
SET Com_MonOriTot   := 'T';                 -- Criterio Comision: Monto Original de la Cuota Capital + Int + IVA
SET Com_SaldoAmo    := 'S';                 -- Criterio Comision: Saldo de la Cuota
SET Var_ComFalPagM  := 'M';                 -- Tipo de Comision por Falta de Pago: Monto
SET Var_ComFalPagP  := 'P';                 -- Tipo de Comision por Falta de Pago: Porcentaje
SET Mora_NVeces     := 'N';                 -- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
SET Mora_TasaFija   := 'T';                 -- Tipo de Cobro de Moratorios: Tasa Fija Anualizada
SET Pro_PasoAtras   := 202;                 -- Numero de Proceso Batch: Trapsaso a Atrasado
SET Mov_MoraVigen 	:= 15;                  -- Tipo de Movimiento de Credito: Moratorios
SET	Mov_MoraCarVen	:= 17;					-- Tipo de Movimiento de Credito: Moratorios de Cartera Vencida
SET Mov_CapAtrasado := 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
SET Mov_CapVigente  := 1;                   -- Tipo de Movimiento de Credito: Capital Vigente
SET Mov_ComFalPago  := 40;                  -- Tipo de Movimiento de Credito: Comision x Falta de Pago
SET Mov_InterPro    := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
SET Mov_IntAtras    := 11;                  -- Tipo de Movimiento de Credito: Interes Atrasado
SET Mov_CapVencido  := 3;                   -- Tipo de Movimiento de Credito: Interes Vencido
SET Mov_IntVencido  := 12;                  -- Tipo de Movimiento de Credito: Interes Vencido
SET Mov_CapVenNoEx  := 4;                   -- Tipo de Movimiento de Credito: Capital Vencido no Exigible
SET Con_CueOrdMor   := 13;                  -- Concepto Contable: Cuentas de Orden de Moratorios
SET Con_CorOrdMor   := 14;                  -- Concepto Contable: Correlativa de Orden de Moratorios
SET Con_CueOrdComFP := 15;	                -- Concepto Contable: Cuentas de Orden Comision Falta de Pago
SET Con_CorOrdComFP := 16;                  -- Concepto Contable: Correlativa de Orden Comision Falta de Pago
SET Con_MoraDeven   := 33;                  -- Concepto Contable: Interes Moratorio Devengado
SET Con_MoraIngreso	:= 6;					-- Concepto Contable: Ingreso por Interes Moratorio
SET Con_CapVigente  := 1;                   -- Concepto Contable: Capital Vigente
SET Con_CapAtrasado := 2;                   -- Concepto Contable: Capital Atrasado
SET Con_IntDevVig   := 19;                  -- Concepto Contable: Interes Devengado
SET Con_IntAtrasado := 20;                  -- Concepto Contable: Interes Atrasado
SET Con_IntVencido  := 21;                  -- Concepto Contable: Interes Vencido
SET Con_CapVencido  := 3;                   -- Concepto Contable: Capital Vigente
SET Con_CapVenNoEx  := 4;                   -- Concepto Contable: Capital Vencido No Exigible
SET Pol_Automatica  := 'A';                 -- Tipo de Poliza: Automatica
SET Con_GenIntere   := 52;                  -- Tipo de Proceso Contable: Generacion de Interes de Cartera
SET Par_SalidaNO    := 'N';                 -- El store no Arroja una Salida
SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: SI
SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: NO
SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
SET SI_Prorratea    := 'S';                 -- SI Prorratea la Comision por Falta de Pago
SET Inte_Activo     := 'A';                 -- Integrante Activo del Grupo
SET Per_Diario      := 'D';                 -- Periodiciad en el Cobro de FalPago: Diario
SET Per_Evento      := 'C';                 -- Periodiciad en el Cobro de FalPago: Por Evento o Atraso
SET Por_Amorti      := 'A';                 -- Tipo de Cobro de FalPago: Por Amortizacion
SET Por_Credito     := 'C';                 -- Tipo de Cobro de FalPago: Por Credito
SET Des_CieDia      := 'CIERRE DIARO CARTERA';
SET Ref_GenInt      := 'GENERACION INTERES MORATORIO';
SET Ref_PasoAtraso  := 'TRASPASO A CARTERA ATRASADA';
SET Ref_CobraInt    := 'COMISION POR FALTA DE PAGO';
SET Des_Poliza      := 'GENERACION INTERES MORATORIO, COMISION FALTA DE PAGO Y TRASPASO A CARTERA ATRASADA';

SET TipoMovCapOrd   := 1;                   -- Tipo de Movimiento de Credito: Capital Ordinario
SET TipoMovCapAtr   := 2;                   -- Tipo de Movimiento de Credito: Capital Atrasado
SET TipoMovCapVen   := 3;                   -- Tipo de Movimiento de Credito: Capital Vencido
SET TipoMovCapVN    := 4;                   -- Tipo de Movimiento de Credito: Capital Vencido No Exigible.

SET No_EsReestruc       := 'N';             -- El Producto de Credito no es para Reestructuras
SET Si_EsReestruc       := 'S';             -- El credito si es una Reestructura
SET Si_Regulariza       := 'S';             -- La Reestructura ya fue Regularizada
SET No_Regulariza       := 'N';             -- La Reestructura NO ha sido Regularizada
SET Act_PagoSost        := 2;               -- Tipo de Actualizacion de la Reest: Pagos Sostenidos
SET SI_CobraMora        := 'S';             -- Si Cobra Interes Moratorio
SET SI_CobraFalPag      := 'S';             -- Si Cobra Comisicion por Falta de Pago
SET NO_CobraFalPag      := 'N';             -- No Cobra Comisicion por Falta de Pago
SET Mora_CtaOrden		:= 'C';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';

SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido
SET Con_IntDevenSup		:= 114;		-- Concepto Contable Interes Devengado Ssupencion
SET Con_IntAtrasadoSup	:= 115;		-- Concepto Contable: Interes Atrasado Suspendido
SET Con_IntVencidoSup	:= 116;		-- Concepto Contable: Interes Vencido
SET Con_CapVigenteSup	:= 110;		-- Concepto Contable: Capital Vigente Suspendido
SET Con_CapAtrasadoSup	:= 111;		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
SET Con_CapVencidoSup	:= 112;		-- Concepto Contable: Capital Vencido Suspendido
SET Con_CapVenNoExSup	:= 113;		-- Concepto Contable: Capital Vencido no Exigible Suspendido
SET Con_SI            := 'S';
SET Con_NO            := 'N';
SET Act_PagoSostenido := 1;

SELECT DiasCredito,	TipoContaMora INTO Var_DiasCredito, Var_TipoContaMora FROM PARAMETROSSIS;
SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);

SET Var_FecApl	:= Par_Fecha;

SELECT   COUNT(CreditoID) INTO Var_ContadorCre FROM TMPCREDCIEMORA;
SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

IF (Var_ContadorCre > Entero_Cero) THEN
    CALL MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,      Var_FecApl,     Pol_Automatica,	Con_GenIntere,
        Des_Poliza,		Par_SalidaNO,       Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,       Aud_NumTransaccion);
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
    SET Var_EsConsolidacionAgro := Cadena_Vacia;
    SET Var_EstatusCosolidacion := Cadena_Vacia;
    SET Var_EsRegularizado      := Cadena_Vacia;
    SET Var_EsConsolidado       := Cadena_Vacia;

    IF(Var_EstCreacion = Cadena_Vacia) THEN
		  SET Var_EsReestruc  := No_EsReestruc;
    ELSE
		  SET Var_EsReestruc  := SI_EsReestruc;
    END IF;

    SET Var_EsConsolidacionAgro := (SELECT EsConsolidacionAgro FROM CREDITOS WHERE CreditoID = Var_CreditoID);
    SET Var_EsConsolidacionAgro := IFNULL(Var_EsConsolidacionAgro, Con_NO);

    SET Var_EsConsolidado := (SELECT EsConsolidado FROM CREDITOS WHERE CreditoID = Var_CreditoID);
    SET Var_EsConsolidado := IFNULL(Var_EsConsolidado, Con_NO);

    IF( Var_EsConsolidacionAgro = Con_SI ) THEN
      SET Var_EstatusCosolidacion := (SELECT EstatusCreacion FROM REGCRECONSOLIDADOS WHERE CreditoID = Var_CreditoID);
      SET Var_EsRegularizado      := (SELECT Regularizado FROM REGCRECONSOLIDADOS WHERE CreditoID = Var_CreditoID);

      SET Var_EstatusCosolidacion := IFNULL(Var_EstatusCosolidacion, Cadena_Vacia);
      SET Var_EsRegularizado      := IFNULL(Var_EsRegularizado, Con_NO);
    END IF;

    IF( Var_EsConsolidado = Con_SI ) THEN
      SET Var_EstatusCosolidacion := (SELECT EstatusCreacion FROM  CONSOLIDACIONCARTALIQ WHERE CreditoID = Var_CreditoID);
      SET Var_EsRegularizado      := (SELECT Regularizado FROM CONSOLIDACIONCARTALIQ WHERE CreditoID = Var_CreditoID);

      SET Var_EstatusCosolidacion := IFNULL(Var_EstatusCosolidacion, Cadena_Vacia);
      SET Var_EsRegularizado      := IFNULL(Var_EsRegularizado, Con_NO);
    END IF;


	# ======================== GENERACION DE MORATORIOS ==============================
	 -- Generacion de Intereses moratorios
    IF(Var_FecMorato <= Par_Fecha AND Var_CobraMora = SI_CobraMora AND Var_Estatus != Estatus_Suspendido) THEN

			-- Verificamos como Registrar Operativa y Contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
			-- Si se contabiliza en cuentas de orden o en cuentas de ingresos
			IF(Var_TipoContaMora = Mora_CtaOrden) THEN
				SET Mov_AboConta    := Con_CorOrdMor;
				SET Mov_CarConta    := Con_CueOrdMor;
				SET Mov_CarOpera    := Mov_MoraVigen;
			ELSE
				-- Verificamos si el Credito esta Vigente o Vencido, para saber como contabilizar
				IF( Var_Estatus = Estatus_Vigente) THEN
					SET Mov_AboConta    := Con_MoraIngreso;
					SET Mov_CarConta    := Con_MoraDeven;
					SET Mov_CarOpera    := Mov_MoraVigen;
				ELSE
					SET Mov_AboConta    := Con_CorOrdMor;
					SET Mov_CarConta    := Con_CueOrdMor;
					SET Mov_CarOpera    := Mov_MoraCarVen;
				END IF;
			END IF;

			SET SalCapital      := IFNULL(SalCapital,Entero_Cero);

			CALL CRECALCULOTASAPRO(
				Var_CreditoID,  Var_FormulaID,  Var_TasaFija,   Par_Fecha,          Var_FechaInicio,
				Var_EmpresaID,  Var_ValorTasa,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion	);

			/*cuando el cliente no ha pagado y terminan sus dias de gracia, se generan los intereses
			  desde el primer dia de no pago hasta el dia de hoy. */
			IF (Var_TipCobComMor = Mora_NVeces) THEN
				SET Var_FactorMora  = Var_FactorMora * Var_ValorTasa;
			END IF;

			IF (Var_FecMorato = Par_Fecha) THEN
				-- Calculo de la Mora Acumulada por los Pagos Realizados en el Transcurso de los
				-- Dias de Gracia para la Generacion de Moratorios
				SET Var_DifMorMov := IFNULL(
						(SELECT SUM(DATEDIFF(FechaOperacion, Var_FechaExigible) * (Var_FactorMora) *
								(IFNULL(LOCATE(Nat_Abono, Mov.NatMovimiento) * IFNULL(Mov.Cantidad, Decimal_Cero), Decimal_Cero) -
								 IFNULL(LOCATE(Nat_Cargo, Mov.NatMovimiento) * IFNULL(Mov.Cantidad, Decimal_Cero), Decimal_Cero)) /
								  (Var_DiasCredito * Dec_Cien))
									FROM CREDITOSMOVS Mov
									WHERE CreditoID = Var_CreditoID
									AND FechaOperacion > Var_FechaExigible
									AND FechaOperacion <= Par_Fecha
									AND AmortiCreID = Var_AmortizacionID
									AND (   TipoMovCreID	= TipoMovCapOrd
									 OR     TipoMovCreID = TipoMovCapAtr
									 OR     TipoMovCreID	= TipoMovCapVen
									 OR     TipoMovCreID = TipoMovCapVN )   ), Decimal_Cero);


				SET	DiasInteres = (SELECT DATEDIFF(Par_Fecha, Var_FechaExigible) + 1);

				SET Var_IntereMor = (ROUND(SalCapital *  Var_FactorMora /
											(Var_DiasCredito * Dec_Cien) * DiasInteres, 2)  + Var_DifMorMov);
			ELSE
					-- cuando ya pasaron sus dias de Gracia, se generan los intereses moratorios del dia
					SET DiasInteres	= 1;
					SET SalCapital:=IFNULL(SalCapital,Entero_Cero);

					SET	Var_IntereMor = ROUND(SalCapital * Var_FactorMora * DiasInteres /
										(Var_DiasCredito * Dec_Cien), 2);
			END IF; -- EndIF del Tipo de Calculo de los Moratorios

			-- se realizan los movimientos contables y operativos del cargo por interes moratorio
			IF (Var_IntereMor > Decimal_Cero) THEN
					CALL  CONTACREDITOPRO (
					Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
					Var_FecApl,			Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_GenInt,     	AltaPoliza_NO,
					Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_CarConta,
					Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
					Cadena_Vacia,		/*Par_SalidaNO,*/
					Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
					Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
					Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
					Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
					Var_FecApl,			Var_IntereMor,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_GenInt,     	AltaPoliza_NO,
					Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
					Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
					Cadena_Vacia,		/*Par_SalidaNO,*/
					Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
					Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
					Aud_NumTransaccion  );

			END IF; -- Endif de Var_IntereMor (Moratorios) mayor que cero
		END IF; -- EndIf Generacion de Intereses moratorios




	# ============ TRASPASOS DE LA AMORTIZACION A ATRASO. SI ES QUE NO SE HABIA PASADO ANTES ==========
	IF(Var_FecPasAtr <= Par_Fecha AND Var_StatuAmort = Estatus_Vigente) THEN
		SET Var_AmorVencido		:= (SELECT COUNT(AmortizacionID)
										FROM AMORTICREDITO
											WHERE CreditoID = Var_CreditoID
												AND Estatus = Estatus_Vencida);

		-- Actualizamos la Amortizacion en Atraso Cuando el Credito esta vigente
		IF( Var_Estatus = Estatus_Vigente) THEN
			UPDATE AMORTICREDITO SET
				Estatus = Estatus_Atrasado
				WHERE CreditoID 		= Var_CreditoID
					AND AmortizacionID	= Var_AmortizacionID;

			IF(Var_AmoCapVig>Decimal_Cero) THEN
				UPDATE CREDITOS SET
					FechaAtrasoCapital = Var_FechaExigible
					WHERE CreditoID 		= Var_CreditoID
						AND FechaAtrasoCapital = Fecha_Vacia;
			END IF;

			IF(Var_IntProvis>Decimal_Cero) THEN
				UPDATE CREDITOS SET
					FechaAtrasoInteres = Var_FechaExigible
					WHERE CreditoID 		= Var_CreditoID
						AND FechaAtrasoInteres = Fecha_Vacia;
			END IF;
		END IF;

		IF( Var_Estatus = Estatus_Vencida) THEN
			UPDATE AMORTICREDITO SET
				Estatus	= Estatus_Vencida
				WHERE CreditoID		= Var_CreditoID
					AND AmortizacionID	= Var_AmortizacionID;
		END IF;

		IF( Var_Estatus = Estatus_Suspendido) THEN
			IF(Var_AmorVencido = Entero_Cero) THEN
				UPDATE AMORTICREDITO SET
					Estatus = Estatus_Atrasado
					WHERE CreditoID 		= Var_CreditoID
						AND AmortizacionID	= Var_AmortizacionID;

				IF(Var_AmoCapVig>Decimal_Cero) THEN
					UPDATE CREDITOS SET
						FechaAtrasoCapital = Var_FechaExigible
						WHERE CreditoID 		= Var_CreditoID
							AND FechaAtrasoCapital = Fecha_Vacia;
				END IF;

				IF(Var_IntProvis>Decimal_Cero) THEN
					UPDATE CREDITOS SET
						FechaAtrasoInteres = Var_FechaExigible
						WHERE CreditoID 		= Var_CreditoID
							AND FechaAtrasoInteres = Fecha_Vacia;
				END IF;
			END IF;

			IF(Var_AmorVencido > Entero_Cero) THEN
				UPDATE AMORTICREDITO SET
					Estatus	= Estatus_Vencida
					WHERE CreditoID		= Var_CreditoID
						AND AmortizacionID	= Var_AmortizacionID;
			END IF;
		END IF;

        -- Si es una Credito Reestructura o Renovacion, Actualizamos el Numero de Pagos Sostenidos a Cero.
        IF ( Var_EsReestruc   = Si_EsReestruc AND
             Var_EstCreacion  = Estatus_Vencida AND
             Var_Regularizado = No_Regulariza)  THEN

            CALL REESTRUCCREDITOACT (
                Par_Fecha,          Var_CreditoID,      Entero_Cero,    	Cadena_Vacia,   	Cadena_Vacia,
                Entero_Cero,        Entero_Cero,        Entero_Cero,    	Entero_Cero,    	Act_PagoSost,
                Par_SalidaNO,       Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Var_SucursalCred,
				Aud_NumTransaccion);

        END IF; -- EndIf si es Reestructura

    -- Inicio de Pagos sostenidos para un credito consolidado Agro
    IF( Var_EsConsolidacionAgro = Con_SI AND
        Var_EstatusCosolidacion = Estatus_Vencida AND
        Var_EsRegularizado = No_Regulariza ) THEN

        CALL REGCRECONSOLIDADOSACT (
          Var_CreditoID,      Entero_Cero,      Entero_Cero,      Cadena_Vacia,     Act_PagoSostenido,
          Par_SalidaNO,       Par_NumErr,       Par_ErrMen,       Par_EmpresaID,    Aud_Usuario,
          Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Var_SucursalCred, Aud_NumTransaccion);
    END IF;
    -- Final  de Pagos sostenidos para un credito consolidado Agro

    -- Inicio de Pagos sostenidos para un credito consolidado
    IF( Var_EsConsolidado = Con_SI AND Var_EstatusCosolidacion = Estatus_Vencida AND Var_EsRegularizado = No_Regulariza ) THEN
        CALL REGCONSOLIDACIONCARTALIQACT (
          Var_CreditoID,      Entero_Cero,      Entero_Cero,      Cadena_Vacia,     Act_PagoSostenido,
          Par_SalidaNO,       Par_NumErr,       Par_ErrMen,       Par_EmpresaID,    Aud_Usuario,
          Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Var_SucursalCred, Aud_NumTransaccion);
    END IF;
    -- Final  de Pagos sostenidos para un credito consolidado

		-- Traspaso de Cartera del Interes Provisionado
		IF (Var_IntProvis > Decimal_Cero) THEN

			-- Consideracion para el Traspaso a Cartera Atrasada
			IF(Var_Estatus = Estatus_Vencida) THEN
				SET	Mov_AboConta	:= Con_IntDevVig;
				SET	Mov_CarConta	:= Con_IntVencido;
				SET	Mov_CarOpera	:= Mov_IntVencido;
				SET	Mov_AboOpera	:= Mov_InterPro;

			ELSEIF(Var_Estatus = Estatus_Vigente) THEN
				SET	Mov_AboConta	:= Con_IntDevVig;
				SET	Mov_CarConta	:= Con_IntAtrasado;
				SET	Mov_CarOpera	:= Mov_IntAtras;
				SET	Mov_AboOpera	:= Mov_InterPro;

			ELSEIF(Var_Estatus = Estatus_Suspendido) THEN
				IF(Var_AmorVencido = Entero_Cero ) THEN
					SET	Mov_AboConta	:= Con_IntDevenSup;
					SET	Mov_CarConta	:= Con_IntAtrasadoSup;
					SET	Mov_CarOpera	:= Mov_IntAtras;
					SET	Mov_AboOpera	:= Mov_InterPro;
				END IF;

				IF(Var_AmorVencido > Entero_Cero ) THEN
					SET	Mov_AboConta	:= Con_IntDevenSup;
					SET	Mov_CarConta	:= Con_IntVencidoSup;
					SET	Mov_CarOpera	:= Mov_IntVencido;
					SET	Mov_AboOpera	:= Mov_InterPro;
				END IF;
			END IF;

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
                Var_FecApl,         Var_IntProvis,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_PasoAtraso,    	AltaPoliza_NO,
                Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
                Cadena_Vacia,		/*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion);

            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
                Var_FecApl,         Var_IntProvis,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_PasoAtraso,    	AltaPoliza_NO,
                Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
                Cadena_Vacia,	    /*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion  );

        END IF; -- EndIf del Var_IntProvis (Interes Provisionado mayor a Cero)


		IF( (Var_Estatus = Estatus_Vigente AND Var_AmoCapVig > Decimal_Cero ) OR
			(Var_Estatus = Estatus_Vencida AND Var_AmoCapVNE > Decimal_Cero ) OR
			(Var_Estatus = Estatus_Suspendido AND (Var_AmoCapVig > Decimal_Cero OR Var_AmoCapVNE > Decimal_Cero))) THEN

			-- Traspaso a de Cartera del Capital
			IF(Var_Estatus = Estatus_Vencida) THEN
				SET Mov_AboConta	:= Con_CapVenNoEx;
				SET Mov_CarConta	:= Con_CapVencido;
				SET Mov_CarOpera	:= Mov_CapVencido;
				SET Mov_AboOpera	:= Mov_CapVenNoEx;
				SET Var_CapAmorti	:= Var_AmoCapVNE;

			ELSEIF(Var_Estatus = Estatus_Vigente) THEN
				SET Mov_AboConta	:= Con_CapVigente;
				SET Mov_CarConta	:= Con_CapAtrasado;
				SET Mov_CarOpera	:= Mov_CapAtrasado;
				SET Mov_AboOpera	:= Mov_CapVigente;
				SET Var_CapAmorti	:= Var_AmoCapVig;

			ELSEIF(Var_Estatus = Estatus_Suspendido) THEN
				-- Si el Credito Suspendido No tiene amortizaciones vencidas se realizan
				-- los movimientos contables con los conceptos de la cartera vigente suspencion
				IF(Var_AmorVencido = Entero_Cero ) THEN
					SET Mov_AboConta	:= Con_CapVigenteSup;
					SET Mov_CarConta	:= Con_CapAtrasadoSup;
					SET Mov_CarOpera	:= Mov_CapAtrasado;
					SET Mov_AboOpera	:= Mov_CapVigente;
					SET Var_CapAmorti	:= Var_AmoCapVig;
				END IF;

				-- Si el Credito Suspendido tiene amortizaciones vencidas se realizan
				-- los movimientos contables con los conceptos de la cartera Vencida suspencion
				IF(Var_AmorVencido > Entero_Cero ) THEN
					SET Mov_AboConta	:= Con_CapVenNoExSup;
					SET Mov_CarConta	:= Con_CapVencidoSup;
					SET Mov_CarOpera	:= Mov_CapVencido;
					SET Mov_AboOpera	:= Mov_CapVenNoEx;
					SET Var_CapAmorti	:= Var_AmoCapVNE;
				END IF;
			END IF;

            -- Abono de Capital Vigente
            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
                Var_FecApl,         Var_CapAmorti,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_PasoAtraso,     AltaPoliza_NO,
                Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_CarConta,
                Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
                Cadena_Vacia,		/*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion  );

                -- Cargo de Capital Vencido
            CALL  CONTACREDITOPRO (
                Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,        Par_Fecha,
                Var_FecApl,         Var_CapAmorti,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_PasoAtraso,     AltaPoliza_NO,
                Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,		/*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion);

        END IF;

    END IF;-- EndIF del Traspaso de Cartera de la Amortizacion






	# ============================= CALCULO DE LA COMISION POR FALTA DE PAGO ==============================
    -- Comision por Falta de Pago
    IF( Var_FecFalPago <= Par_Fecha AND Var_CobFaltaPago = SI_CobraFalPag AND
        (Var_PerCobFalPag = Per_Diario OR (Var_PerCobFalPag = Per_Evento AND Var_FecFalPago = Par_Fecha)) AND Var_Estatus != Estatus_Suspendido) THEN

        -- Validamos si es un Cobro por cada Cuota
        IF(Var_TipCobFalPago = Por_Amorti) THEN
            SET Var_AplFaltaPago = SI_CobraFalPag;
        ELSE
            SET Var_NumCobFalPag := (SELECT COUNT(Amo.AmortizacionID)
                                        FROM AMORTICREDITO Amo
                                        WHERE Amo.CreditoID = Var_CreditoID
                                          AND (	Amo.Estatus		=  Estatus_Vigente
                                           OR    Amo.Estatus	=  Estatus_Atrasado
                                           OR    Amo.Estatus	=  Estatus_Vencida)
                                          AND  Amo.FechaVencim <= Par_Fecha
                                          AND  Amo.AmortizacionID > Var_AmortizacionID);

            SET Var_NumCobFalPag = IFNULL(Var_NumCobFalPag, Entero_Cero);

            IF(Var_NumCobFalPag = Entero_Cero) THEN
                SET Var_AplFaltaPago = SI_CobraFalPag;
            ELSE
                SET Var_AplFaltaPago = NO_CobraFalPag;
            END IF;

        END IF; -- EndIf SI Cobra por Cuota o por Credito


		-- Si hay amortizacion para calcular com. Falta de pago
        IF(Var_AplFaltaPago = SI_CobraFalPag) THEN
				SET Var_BaseComisi  := Entero_Cero;
				SET Var_MontoFalPag := Entero_Cero;
				SET Var_CriComFalPag := IFNULL(Var_CriComFalPag, Cadena_Vacia);
				SET Var_MinComFalPag := IFNULL(Var_MinComFalPag, Entero_Cero);

				-- Seleccion de Criterios para el Monto Base de la Comision
				IF(Var_CriComFalPag = Com_MonOriCap) THEN       -- Monto de Capital Original
					SET Var_BaseComisi  := IFNULL(Var_AmoCapital, Entero_Cero);
				ELSEIF(Var_CriComFalPag = Com_MonOriTot) THEN   -- Monto Total Original (Cap,Int,IVA)
					SET Var_BaseComisi  := IFNULL(Var_AmoTotCuota, Entero_Cero);
				ELSE                                            -- Saldo de la Cuota
					SET Var_BaseComisi  := ROUND(IFNULL(SalCapital, Entero_Cero) +
												 IFNULL(Var_IntProvis, Entero_Cero) +
												 IFNULL(Var_IntAtrasado, Entero_Cero) +
												 IFNULL(Var_IntVencido, Entero_Cero) +
												 IFNULL(Var_SalIntNoConta, Entero_Cero), 2);
				END IF;

				-- Considerar el Monto Minimo para el Cobro
				IF (Var_MinComFalPag != Entero_Cero AND Var_BaseComisi  < Var_MinComFalPag) THEN
						SET Var_MontoFalPag := Entero_Cero;
				ELSE
					   SET Var_TipoComision := (SELECT TipoComision
												FROM ESQUEMACOMISCRE Esc
												WHERE Esc.ProducCreditoID   = Var_ProdCreID
												AND Var_BaseComisi >= Esc.MontoInicial
											AND Var_BaseComisi <= Esc.MontoFinal	);

						SET Var_Comision := (SELECT Comision
											FROM ESQUEMACOMISCRE Esc
											WHERE Esc.ProducCreditoID   = Var_ProdCreID
											  AND Var_BaseComisi >= Esc.MontoInicial
											  AND Var_BaseComisi <= Esc.MontoFinal);

						SET Var_Comision        := IFNULL(Var_Comision, Entero_Cero);
						SET Var_TipoComision    := IFNULL(Var_TipoComision, Cadena_Vacia);

						IF(Var_Comision > Entero_Cero) THEN
							IF(Var_TipoComision = Var_ComFalPagM) THEN  -- comision F. P. se cobra por monto
								SET Var_MontoFalPag := Var_Comision;
							ELSE        								-- comision F. P. se cobra por Porcentaje
								SET Var_MontoFalPag := ROUND(Var_BaseComisi * Var_Comision/100, 2);
							END IF;

							IF(Var_FecFalPago = Par_Fecha) 	THEN -- Entra solo si el cargo de la comision es por dia
								IF(Var_PerCobFalPag = Per_Diario)THEN   -- El calculo de la comision de F.P  por cada dia de atraso
									SET Var_MontoFalPag = Var_MontoFalPag *
															(DATEDIFF(Par_Fecha, Var_FechaExigible) + 1);
								ELSE									-- El calculo de la comision de F.P  por incumplimineto
									SET Var_MontoFalPag = ROUND(Var_MontoFalPag * 1, 2);
								END IF;
							END IF;

						END IF; -- fin Considerar el Monto Minimo para el Cobro
				END IF;		-- fin Si hay amortizacion para calcular com. Falta de pago



				IF (Var_MontoFalPag > Decimal_Cero) THEN

					-- Consideraciones si la Comision por Falta de Pago se Prorratea entre los Integrantes
					IF(Var_ProComFalPag = SI_Prorratea AND Var_GrupoID != Entero_Cero) THEN

						SET Var_CicloActual := ( SELECT CicloActual
													FROM 	GRUPOSCREDITO
													WHERE GrupoID = Var_GrupoID);

						SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

						IF(Var_Ciclo = Var_CicloActual) THEN
							SET Var_NumIntegra  :=  (SELECT COUNT(Ing.GrupoID)
								FROM INTEGRAGRUPOSCRE Ing,
									CREDITOS Cre
								WHERE Ing.GrupoID = Var_GrupoID
								AND Ing.ProrrateaPago = SI_Prorratea
								AND Ing.Estatus = Inte_Activo
								AND Ing.SolicitudCreditoID = Cre.SolicitudCreditoID
								AND Cre.GrupoID = Ing.GrupoID);
						ELSE
							 SET Var_NumIntegra  := (SELECT COUNT(Ing.GrupoID)
								FROM `HIS-INTEGRAGRUPOSCRE` Ing,
									CREDITOS Cre
								WHERE Ing.GrupoID = Var_GrupoID
								AND Ing.ProrrateaPago = SI_Prorratea
								AND Ing.Estatus = Inte_Activo
								AND Ing.SolicitudCreditoID = Cre.SolicitudCreditoID
								AND Cre.GrupoID = Ing.GrupoID
								AND Ing.Ciclo= Var_Ciclo);
						END IF;
						SET Var_NumIntegra  := IFNULL(Var_NumIntegra, Entero_Cero);

						IF(Var_NumIntegra > Entero_Cero) THEN
							SET Var_MontoFalPag = ROUND(Var_MontoFalPag / Var_NumIntegra, 2);
						END IF;

					END IF;

					SET	Mov_AboConta	:= Con_CorOrdComFP;
					SET	Mov_CarConta	:= Con_CueOrdComFP;
					SET	Mov_CarOpera	:= Mov_ComFalPago;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
						Var_FecApl,         Var_MontoFalPag,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_CobraInt,     	AltaPoliza_NO,
						Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,  	Mov_CarConta,
						Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
						Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
						Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
						Aud_NumTransaccion);

						CALL  CONTACREDITOPRO (
						Var_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,    	Par_Fecha,
						Var_FecApl,         Var_MontoFalPag,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,     Des_CieDia,         Ref_CobraInt,     	AltaPoliza_NO,
						Entero_Cero,        Var_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
						Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
						Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,  	Cadena_Vacia,
						Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
						Aud_NumTransaccion);
				END IF; -- EndIf de la Comision por Falta de Pago mayor a Cero
        END IF; -- End IF de si Aplica Falta de Pago
    END IF; -- Endif de la Comision por Falta de Pago




   END; -- End del Begin Handler

	SET Var_CreditoStr = CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;

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

TRUNCATE TABLE TMPCREDCIEMORA;

END TerminaStore$$
