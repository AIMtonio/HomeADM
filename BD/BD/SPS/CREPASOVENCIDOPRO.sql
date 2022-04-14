-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASOVENCIDOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASOVENCIDOPRO`;
DELIMITER $$


CREATE PROCEDURE `CREPASOVENCIDOPRO`(
	Par_Fecha           DATE,
    Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
        	)

TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_CreditoID       BIGINT(12);
	DECLARE Var_CreditoStr      VARCHAR(30);
	DECLARE Error_Key           INT(11);
	DECLARE Var_ContadorCre     INT(11);
	DECLARE Var_Poliza          BIGINT;
	DECLARE Var_FecApl          DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Var_FecAntRes       DATE;
	DECLARE Var_SaldoResInt     DECIMAL(14,2);
	DECLARE Var_TipoContaMora   CHAR(1);
	DECLARE Var_RegContaEPRC    CHAR(1);
	DECLARE Var_DivideEPRC      CHAR(1);
	DECLARE Var_EPRCAdicional   CHAR(1);


	DECLARE Var_AmortizacionID  INT(11);                -- Variables para el Cursor
	DECLARE Var_FechaInicio     DATE;
	DECLARE Var_FechaVencim     DATE;
	DECLARE Var_FechaExigible   DATE;
	DECLARE Var_AmoCapVig       DECIMAL(14,2);
	DECLARE Var_AmoCapAtra      DECIMAL(14,2);
	DECLARE Var_AmoCapVen       DECIMAL(14,2);
	DECLARE Var_AmoCaVeNex      DECIMAL(14,2);
	DECLARE Var_EmpresaID       INT(11);
	DECLARE Var_CreCapVig       DECIMAL(14,2);
	DECLARE Var_CreCapAtra      DECIMAL(14,2);
	DECLARE Var_CreCapVen       DECIMAL(14,2);
	DECLARE Var_CreCapVNE       DECIMAL(14,2);
	DECLARE Var_CreIntOrd       DECIMAL(14,4);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_Estatus         CHAR(1);
	DECLARE Var_StatuAmort      CHAR(1);
	DECLARE Var_SucCliente      INT(11);
	DECLARE Var_ProdCreID       INT(11);
	DECLARE Var_ClasifCre       CHAR(1);
	DECLARE Var_IntAtrasado     DECIMAL(12,4);
	DECLARE Var_IntMorato       DECIMAL(12,4);
	DECLARE Var_EsReestruc      CHAR(1);
	DECLARE Var_EstCreacion     CHAR(1);
	DECLARE Var_Regularizado    CHAR(1);
	DECLARE Var_IntProvision    DECIMAL(12,4);
	DECLARE Var_SubClasifID     INT(11);
	DECLARE Var_SucursalCred    INT(11);
    DECLARE Var_ClienteEsp			INT;

	/* Declaracion de Constantes. */
	DECLARE Estatus_Vigente     CHAR(1);
	DECLARE Estatus_Vencida     CHAR(1);
	DECLARE Estatus_Atrasado    CHAR(1);
	DECLARE Cre_Vencido         CHAR(1);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Pro_PasoVenc        INT(11);
	DECLARE Pol_Automatica      CHAR(1);
	DECLARE Con_PasoCarVenc     INT(11);
	DECLARE Ref_TrasVenc        VARCHAR(100);
	DECLARE Par_SalidaNO        CHAR(1);

	DECLARE Con_CapAtrasado     INT(11);
	DECLARE Con_CapVencido      INT(11);
	DECLARE Mov_CapAtrasado     INT(11);
	DECLARE Mov_CapVencido      INT(11);
	DECLARE Con_CapVigente      INT(11);
	DECLARE Con_CapVenNoEx      INT(11);
	DECLARE Con_MoraDeven       INT(11);
	DECLARE Con_MoraVencido     INT(11);
	DECLARE Mov_CapVigente      INT(11);
	DECLARE Mov_CapVenNoEx      INT(11);
	DECLARE Con_IntAtrasado     INT(11);
	DECLARE Con_IntVencido      INT(11);
	DECLARE Con_PtePrinci       INT(11);
	DECLARE Con_PteIntere       INT(11);
	DECLARE Con_ResIntere       INT(11);
	DECLARE Con_BalIntere       INT(11);
	DECLARE Con_BalAdiEPRC      INT(11);
	DECLARE Con_PteAdiEPRC      INT(11);
	DECLARE Con_ResAdiEPRC      INT(11);
	DECLARE Con_IntDeven        INT(11);

	DECLARE Mov_IntAtrasado     INT(11);
	DECLARE Mov_IntProvision    INT(11);
	DECLARE Mov_IntVencido      INT(11);
	DECLARE Mov_IntMoratoVig    INT(11);
	DECLARE Mov_IntMoraVencido  INT(11);

	DECLARE AltaPoliza_NO       CHAR(1);
	DECLARE AltaPolCre_SI       CHAR(1);
	DECLARE AltaMovCre_SI       CHAR(1);
	DECLARE AltaMovCre_NO       CHAR(1);
	DECLARE AltaMovAho_NO       CHAR(1);
	DECLARE Des_CieDia          VARCHAR(100);
	DECLARE Ref_GenInt          VARCHAR(50);

	DECLARE Dec_Cien            DECIMAL(10,2);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);

	DECLARE Mov_AboConta        INT(11);
	DECLARE Mov_CarConta        INT(11);
	DECLARE Mov_CarOpera        INT(11);
	DECLARE Mov_AboOpera        INT(11);

	DECLARE Par_NumErr          INT(11);
	DECLARE Par_ErrMen          VARCHAR(400);
	DECLARE Par_Consecutivo     BIGINT;

	DECLARE No_EsReestruc       CHAR(1);
	DECLARE Si_EsReestruc       CHAR(1);
	DECLARE Si_Regulariza       CHAR(1);
	DECLARE No_Regulariza       CHAR(1);
	DECLARE Con_Balance         INT(11);
	DECLARE Des_Reserva         VARCHAR(100);
	DECLARE Des_CanResInt       VARCHAR(100);
	DECLARE Mora_CtaOrden       CHAR(1);
	DECLARE Mora_EnIngresos     CHAR(1);
	DECLARE EPRC_Resultados     CHAR(1);
	DECLARE SI_DivideEPRC       CHAR(1);
	DECLARE NO_DivideEPRC       CHAR(1);
	DECLARE NO_EPRCAdicional    CHAR(1);
	DECLARE SI_EPRCAdicional    CHAR(1);
	DECLARE Con_ResultEPRC      INT(11);
	DECLARE Si_AplicaConta      CHAR(1);
	DECLARE PagoUnico           CHAR(1);
	DECLARE Des_ErrorGral       VARCHAR(100);
	DECLARE Des_ErrorLlavDup    VARCHAR(100);
	DECLARE Des_ErrorCallSP     VARCHAR(100);
	DECLARE Des_ErrorValNulos   VARCHAR(100);
    DECLARE PagoPeriodico		CHAR(1);
    DECLARE Clien_Crediclub			INT;
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido
	DECLARE Con_CapAtrasadoSup	INT(11);	-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
	DECLARE Con_CapVencidoSup	INT(11);	-- Concepto Contable: Capital Vencido Suspendido
	DECLARE Con_IntAtrasadoSup	INT(11);	-- Concepto Contable: Interes Atrasado Suspendido
	DECLARE Con_IntVencidoSup	INT(11);	-- Concepto Contable: Interes Vencido Suspendido
	DECLARE Con_MoraDevenSup	INT(11);	-- Concepto Contable: Interes Moratorio Devengado Suspendido
	DECLARE Con_MoraVencidoSup	INT(11);	-- Concepto Contable: Interes Moratorio Vencido Suspendido
	DECLARE Con_CapVigenteSup	INT(11);	-- Concepto Contable: Capital Vigente Suspendido
	DECLARE Con_CapVenNoExSup	INT(11);	-- Concepto Contable: Capital Vencido no Exigible Suspendido
	DECLARE Con_IntDevenSup		INT(11);	-- Concepto Contable Interes Devengado Supencion

	DECLARE CURSORCREVEN CURSOR FOR
		SELECT  DISTINCT(Cre.CreditoID),    Amo.AmortizacionID,     Amo.FechaInicio,        Amo.FechaVencim,
				Amo.FechaExigible,          Amo.SaldoCapVigente,    Amo.SaldoCapAtrasa,     Amo.SaldoCapVencido,
				Amo.SaldoCapVenNExi,        Cre.EmpresaID,          Cre.SaldoCapVigent,     Cre.SaldoCapAtrasad,
				Cre.SaldoCapVencido,        Cre.SaldCapVenNoExi,    Cre.SaldoInterOrdin,    Cre.MonedaID,
				Cre.Estatus,                Cre.ProductoCreditoID,  Amo.Estatus,            Cli.SucursalOrigen,
				Des.Clasificacion,          Amo.SaldoInteresAtr,    Pro.EsReestructura,     Res.EstatusCreacion,
				Res.Regularizado,           Amo.SaldoInteresPro,    Des.SubClasifID,        Cre.SucursalID,
				Amo.SaldoMoratorios
			FROM AMORTICREDITO Amo,
			   CLIENTES Cli,
			   PRODUCTOSCREDITO Pro,
			   DESTINOSCREDITO Des,
			   TMPCREPASOVENCIDO Tmp,
			   CREDITOS  Cre
				LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cre.CreditoID
			WHERE	Amo.CreditoID			= Cre.CreditoID
			AND		Cre.ClienteID     		= Cli.ClienteID
			AND 	Cre.DestinoCreID  		= Des.DestinoCreID
			AND 	Cre.ProductoCreditoID	= Pro.ProducCreditoID
			AND 	(Amo.Estatus  			= Estatus_Atrasado OR
					Amo.Estatus 			= Estatus_Vigente)
			AND (
				Cre.Estatus   			= Estatus_Vigente OR
				Cre.Estatus				= Estatus_Suspendido
			)
			AND 	Cre.CreditoID 			= Tmp.CreditoID
			AND 	Tmp.Transaccion 		= Aud_NumTransaccion
			AND 	Tmp.FechaTraspaso  		<= Par_Fecha;



	/* Asignacion de Constantes */
	SET Estatus_Vigente     := 'V';             -- Estatus Amortizacion: Vigente
	SET Estatus_Vencida     := 'B';             -- Estatus Amortizacion: Vencido
	SET Estatus_Atrasado    := 'A';             -- Estatus Amortizacion: Atrasado
	SET Cre_Vencido         := 'B';           -- Estatus Credito: Vencido
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';        -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Pro_PasoVenc        := 203;             -- Numero de Proceso Batch: Traspado de Cartera Vencida
	SET Pol_Automatica      := 'A';             -- Tipo de Poliza Contable: Automatica
	SET Con_PasoCarVenc     := 53;              -- Concepto Contable: Traspaso a Cartera Vencida
	SET Par_SalidaNO        := 'N';             -- Salida a Pantalla: NO

	SET Ref_TrasVenc        := 'TRASPASO A CARTERA VENCIDA';

	SET Con_CapVigente      := 1;               -- Concepto Contable: Capital Vigente
	SET Con_CapAtrasado     := 2;               -- Tipo de Movimiento de Credito: Capital Atrasado
	SET Con_CapVencido      := 3;               -- Concepto Contable: Capital Vencido
	SET Con_CapVenNoEx      := 4;               -- Concepto Contable: Capital Vencido no Exigible
	SET Con_IntDeven        := 19;              -- Concepto Contable Interes Devengado
	SET Con_IntAtrasado     := 20;              -- Concepto Contable: Interes Atrasado
	SET Con_IntVencido      := 21;              -- Concepto Contable: Capital Vencido
	SET Con_MoraDeven       := 33;              -- Concepto Contable: Interes Moratorio Devengado
	SET Con_MoraVencido     := 34;              -- Concepto Contable: Interes Moratorio Vencido
	SET Con_PtePrinci       := 38;              -- Concepto Contable: EPRC Cta. Puente de Principal
	SET Con_PteIntere       := 39;              -- Concepto Contable: EPRC Cta. Puente de Int.Normal y Moratorio
	SET Con_BalIntere       := 36;              -- Concepto Contable: Balance. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_ResIntere       := 37;              -- Concepto Contable: Resultados. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_BalAdiEPRC      := 49;              -- Concepto Contable: Balance EPRC Adicional Car.Vencida
	SET Con_PteAdiEPRC      := 50;              -- Concepto Contable: EPRC Adicional Cta.Puente de Car.Vencida
	SET Con_ResAdiEPRC      := 51;              -- Concepto Contable: Resultados EPRC Adicional de Car.Vencida

	SET Mov_CapVigente      := 1;               -- Tipo de Movimiento de Credito: Capital Vigente
	SET Mov_CapAtrasado     := 2;               -- Tipo de Movimiento de Credito: Capital Atrasado
	SET Mov_CapVencido      := 3;               -- Tipo de Movimiento de Credito: Capital Vencido
	SET Mov_CapVenNoEx      := 4;               -- Tipo de Movimiento de Credito: Capital Vencido no Exigible
	SET Mov_IntAtrasado     := 11;              -- Tipo de Movimiento de Credito: Capital Interes Atrasado
	SET Mov_IntVencido      := 12;              -- Tipo de Movimiento de Credito: Interes Vencido
	SET Mov_IntProvision    := 14;              -- Tipo de Movimiento de Credito: Interes Provisionado
	SET Mov_IntMoratoVig    := 15;              -- Interes Moratorio de Cartera Vigente
	SET Mov_IntMoraVencido  := 16;              -- Tipo de Movimiento: Interes Moratorio Vencido


	SET AltaPoliza_NO       := 'N';             -- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI       := 'S';             -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO       := 'N';             -- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI       := 'S';             -- Alta del Movimiento de Credito: SI
	SET AltaMovAho_NO       := 'N';             -- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo           := 'C';             -- Naturaleza de Cargo
	SET Nat_Abono           := 'A';             -- Naturaleza de Abono
	SET Dec_Cien            := 100.00;          -- Decimal Cien
	SET No_EsReestruc       := 'N';             -- El Producto de Credito no es para Reestructuras
	SET Si_EsReestruc       := 'S';             -- El credito si es una Reestructura
	SET Si_Regulariza       := 'S';             -- La Reestructura ya fue Regularizada
	SET No_Regulariza       := 'N';             -- La Reestructura NO ha sido Regularizada
	SET Con_Balance         := 17;              -- Balance. Estimacion Prev. Riesgos Crediticios
	SET Con_ResultEPRC      := 18;              -- Resultados. Estimacion Prev. Riesgos Crediticios
	SET Si_AplicaConta      := 'S';             -- El Proceso de Reserva si Aplico Conta
	SET Mora_CtaOrden       := 'C';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden
	SET Mora_EnIngresos     := 'I';             -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Ingresos
	SET EPRC_Resultados     := 'R';             -- Estimacion en Cuentas de Resultados
	SET SI_DivideEPRC       := 'S';             -- SI Divide en la EPRC en Principal(Capital) e Interes
	SET NO_DivideEPRC       := 'N';             -- NO Divide en la EPRC en Principal(Capital) e Interes
	SET NO_EPRCAdicional    := 'N';             -- NO Realiza EPRC Adicional por el Interes Vencido
	SET SI_EPRCAdicional    := 'S';             -- SI Realiza EPRC Adicional por el Interes Vencido
	SET PagoUnico           := 'U';             -- Tipo Pago: Unico
    SET PagoPeriodico		:= 'I';				-- Tipo Pago: Unico de Capital y Periodico de Intereses

	SET Des_CieDia          := 'CIERRE DIARIO CARTERA';
	SET Ref_GenInt          := 'TRASPASO A CARTERA VENCIDA';
	SET Des_Reserva         := 'ESTIMACION PASO A VENCIDO';
	SET Des_CanResInt       := 'LIBERACION ESTIMACION PREVIA INTERES';

	SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';
    SET Clien_Crediclub		:= 24;

	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido
	SET Con_CapAtrasadoSup	:= 111;		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
	SET Con_CapVencidoSup	:= 112;		-- Concepto Contable: Capital Vencido Suspendido
	SET Con_IntAtrasadoSup	:= 115;		-- Concepto Contable: Interes Atrasado Suspendido
	SET Con_IntVencidoSup	:= 116;		-- Concepto Contable: Interes Vencido
	SET Con_MoraDevenSup	:= 117;		-- Concepto Contable: Interes Moratorio Devengado Suspendido
	SET Con_MoraVencidoSup	:= 118;		-- Concepto Contable: Interes Moratorio Vencido Suspendido
	SET Con_CapVenNoExSup	:= 113;		-- Concepto Contable: Capital Vencido no Exigible Suspendido
	SET Con_CapVigenteSup	:= 110;		-- Concepto Contable: Capital Vigente Suspendido
	SET Con_IntDevenSup		:= 114;		-- Concepto Contable Interes Devengado Ssupencion

	SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);

	SET Var_FecApl := Par_Fecha;

	SELECT TipoContaMora INTO Var_TipoContaMora
		FROM PARAMETROSSIS;

	SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCAdicional INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCAdicional
		FROM PARAMSRESERVCASTIG
		WHERE EmpresaID = Par_EmpresaID;


	SET Var_ClienteEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');


	SET Var_RegContaEPRC 	:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
	SET Var_DivideEPRC		:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
	SET Var_TipoContaMora   := IFNULL(Var_TipoContaMora, Mora_CtaOrden);
	SET Var_EPRCAdicional   := IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);




	-- Fecha de la Ultima Estimacion de Reservas
	SELECT  MAX(Fecha) INTO Var_FecAntRes
		FROM CALRESCREDITOS
		WHERE   AplicaConta = Si_AplicaConta;

	SET Var_FecAntRes   := IFNULL(Var_FecAntRes, Fecha_Vacia);



	-- Temporal Para seleccionar los Creditos que van a  pasar a vencido
	TRUNCATE TABLE TMPCREPASOVENCIDO;

	-- Se obtienen los datos del Credito
	INSERT INTO TMPCREPASOVENCIDO(
		CreditoID,				Transaccion,			ProductoCreditoID,		FrecuenciaCapital,		FrecuenciaInteres,
		FechaAtrasoCapital,		FechaAtrasoInteres,		DiasPasoVencido,		AmoFechaExigible)
	SELECT
		Cre.CreditoID,			Aud_NumTransaccion,		Cre.ProductoCreditoID,	Cre.FrecuenciaCap,		Cre.FrecuenciaInt,
		Cre.FechaAtrasoCapital,	Cre.FechaAtrasoInteres,	Dia.DiasPasoVencido,	MIN(Amo.FechaExigible)
		FROM	AMORTICREDITO Amo,
				CREDITOS Cre
			LEFT OUTER JOIN DIASPASOVENCIDO Dia ON Dia.ProducCreditoID = Cre.ProductoCreditoID
				AND (CASE
					WHEN ((Cre.FrecuenciaInt = PagoUnico OR Cre.FrecuenciaCap = PagoUnico) AND Cre.FechaVencimien <= Par_Fecha) THEN PagoUnico
					WHEN Cre.FrecuenciaInt = PagoUnico AND Cre.FrecuenciaCap = PagoUnico THEN PagoUnico
					WHEN Cre.FrecuenciaInt = PagoUnico AND Cre.FrecuenciaCap <> PagoUnico THEN Cre.FrecuenciaCap
					WHEN Cre.FrecuenciaCap = PagoUnico AND Cre.FrecuenciaInt <> PagoUnico THEN Cre.FrecuenciaInt
					WHEN (Cre.PeriodicidadCap > Cre.PeriodicidadInt) THEN Cre.FrecuenciaInt
					WHEN (Cre.PeriodicidadCap < Cre.PeriodicidadInt) THEN Cre.FrecuenciaCap
					ELSE Cre.FrecuenciaCap
				END) = Dia.Frecuencia
			WHERE Cre.Estatus   IN (Estatus_Vigente, Estatus_Suspendido)
				AND Amo.CreditoID     = Cre.CreditoID
				AND  Amo.FechaExigible <= Par_Fecha
				AND (Cre.FechaAtrasoCapital != Fecha_Vacia OR Cre.FechaAtrasoInteres != Fecha_Vacia)
				AND (Amo.Estatus =  Estatus_Atrasado OR Amo.Estatus = Estatus_Vigente)
			GROUP BY Cre.CreditoID,		Cre.ProductoCreditoID,	Cre.FrecuenciaCap,
					 Cre.FrecuenciaInt,	Cre.FechaAtrasoCapital,	Cre.FechaAtrasoInteres,	Dia.DiasPasoVencido;

	/*	Se actualiza la fecha de traspaso. */
	UPDATE TMPCREPASOVENCIDO T SET
			T.FechaTraspaso	= DATE_ADD(IFNULL(T.AmoFechaExigible, Par_Fecha), INTERVAL (IFNULL(T.DiasPasoVencido, 1) - 1) DAY);

    /*	Se cambia el valor de la Frecuencia de Capital para los Creditos con Pago Unico de Capital y Periodico de Intereses,
		su nuevo valor sera "I" que es la nueva frecuencia, esta solo se utiliza para el paso a vencido de los creditos.

    */
	UPDATE TMPCREPASOVENCIDO T SET
			T.FrecuenciaCapital	= PagoPeriodico
	WHERE	T.FrecuenciaCapital	= PagoUnico
	AND		T.FrecuenciaInteres	!= PagoUnico;

	-- Se obtienen los dias de paso a vencido para la Frecuencia "U" la cual aplica para el vencimiento del capital
	UPDATE TMPCREPASOVENCIDO T
		INNER JOIN DIASPASOVENCIDO D
		ON T.ProductoCreditoID = D.ProducCreditoID
	SET T.DiasCapital = D.DiasPasoVencido
		WHERE	T.ProductoCreditoID	= D.ProducCreditoID
        AND		T.FrecuenciaCapital	= PagoPeriodico
        AND		D.Frecuencia 		= PagoUnico;

	-- Se obtienen los días de paso a vencido para la Frecuencia "I" la cual aplica para el vencimiento del interes
	UPDATE TMPCREPASOVENCIDO T
		INNER JOIN DIASPASOVENCIDO D
		ON T.ProductoCreditoID = D.ProducCreditoID
	SET T.DiasInteres = D.DiasPasoVencido
		WHERE	T.ProductoCreditoID	= D.ProducCreditoID
        AND		T.FrecuenciaCapital	= PagoPeriodico
		AND		D.Frecuencia		= PagoPeriodico;


	-- Actualiza la fecha de paso a vencido del Credito cuando el atraso sea por capital para los Creditos con Frecuencia 'I'
	UPDATE TMPCREPASOVENCIDO T	SET
			FechaVencCapital		= (SELECT DATE_ADD( T.FechaAtrasoCapital, INTERVAL (IFNULL(T.DiasCapital , 1) - 1) DAY))
	WHERE	T.FechaAtrasoCapital	!= Fecha_Vacia
	AND		T.FrecuenciaCapital	 	= PagoPeriodico;


	-- Actualiza la fecha de paso a vencido del Credito cuando el atraso sea por Interes para Creditos con frecuencia "I"
	 UPDATE TMPCREPASOVENCIDO T	SET
			FechaVencInteres		= (SELECT DATE_ADD( T.FechaAtrasoInteres, INTERVAL  (IFNULL(T.DiasInteres , 1) - 1) DAY))
	WHERE	T.FechaAtrasoInteres	!= Fecha_Vacia
	AND		T.FrecuenciaCapital		= PagoPeriodico;


	/* 	Se actualiza la fecha de Vencimiento del Credito:
		Si la frecuencia de Capital es I, la fecha de paso a vencido se calcula de acuerdo a las Fechas de Paso a Vencido por
        Interes y por Capital calculadas anteriormente, si existe atraso de capital y de interes, la fecha de vencimiento sera
        la que ocurra primero.
	*/

    UPDATE TMPCREPASOVENCIDO T	SET
		T.FechaTraspaso =	CASE
								WHEN T.FrecuenciaCapital = PagoPeriodico AND T.FechaVencCapital < FechaVencInteres AND T.FechaVencCapital != Fecha_Vacia  THEN FechaVencCapital
								WHEN T.FrecuenciaCapital = PagoPeriodico AND FechaVencInteres > Fecha_Vacia AND T.FechaVencCapital > FechaVencInteres AND T.FechaVencCapital != Fecha_Vacia  THEN FechaVencInteres
                                WHEN T.FrecuenciaCapital = PagoPeriodico AND T.FechaVencInteres = Fecha_Vacia AND T.FechaVencCapital != Fecha_Vacia  THEN FechaVencCapital
								ELSE FechaVencInteres
							END
	WHERE	T.FrecuenciaCapital	= PagoPeriodico;


	/* Se actualiza la fecha de paso a vencido para creditos diferidos, tomando los días de atraso que tenia el credito antes de su diferimiento */
	IF Var_ClienteEsp = Clien_Crediclub  THEN

		DROP TABLE IF EXISTS TMPMAXDIFER;
		CREATE TEMPORARY TABLE TMPMAXDIFER(
			CreditoID 				BIGINT(12) PRIMARY KEY,
			NumeroDiferimientos 	INT(11)
		);

		INSERT INTO TMPMAXDIFER
		SELECT Cre.CreditoID , MAX(Dif.NumeroDiferimientos)
		FROM CREDITOSDIFERIDOS Dif,
			 CREDITOS Cre
		WHERE Dif.CreditoID = Cre.CreditoID
		  AND Cre.Estatus IN ('V','B')
		GROUP BY Dif.CreditoID;

		DELETE  T
		FROM TMPCREPASOVENCIDO T,CREDITOSDIFERIDOS D, TMPMAXDIFER M
		WHERE T.CreditoID = D.CreditoID
		  AND D.FechaFinPeriodo >= Par_Fecha
		  AND D.CreditoID = M.CreditoID
		  AND D.NumeroDiferimientos = M.NumeroDiferimientos;

		DROP TABLE IF EXISTS TMPDIASCREDDIFER;
		CREATE TEMPORARY TABLE TMPDIASCREDDIFER(
			CreditoID 	BIGINT(12) PRIMARY KEY,
			DiasAtraso  INT(11)
		);

		INSERT INTO TMPDIASCREDDIFER
		SELECT
		dif.CreditoID,
		(datediff(Par_Fecha,MIN(dif.FechaFinPeriodo))+Min(dif.DiasDiferidos)) as DiasDiferNew
		FROM
		CREDITOSDIFERIDOS dif,AMORTICREDITO amo,TMPMAXDIFER M
		WHERE dif.CreditoID = amo.CreditoID
		  AND dif.FechaFinPeriodo > amo.FechaExigible
		  AND amo.Estatus IN ('A','B')
		  AND dif.FechaFinPeriodo < Par_Fecha
		  AND dif.CreditoID = M.CreditoID
		  AND dif.NumeroDiferimientos = M.NumeroDiferimientos
		GROUP BY dif.CreditoID;

        UPDATE TMPCREPASOVENCIDO T,TMPDIASCREDDIFER D
			SET T.FechaTraspaso = Par_Fecha
		WHERE T.CreditoID = D.CreditoID
          AND D.DiasAtraso >= 90;

        UPDATE TMPCREPASOVENCIDO T,TMPDIASCREDDIFER D
			SET T.FechaTraspaso = date_add(Par_Fecha,interval 5 day)
		WHERE T.CreditoID = D.CreditoID
          AND D.DiasAtraso < 90;

    ELSE
		DROP TABLE IF EXISTS TMPDIASCREDDIFER;
		CREATE TEMPORARY TABLE TMPDIASCREDDIFER(
		CreditoID 	BIGINT(12) PRIMARY KEY,
		DiasAtraso  INT
		);

		INSERT INTO TMPDIASCREDDIFER
		SELECT Dif.CreditoID,MAX(Dif.DiasAtraso)
		FROM AMORTICREDITODIFER Dif,AMORTICREDITO Amo
		WHERE Dif.AmortizacionID = Amo.AmortizacionID
		  AND Dif.CreditoID = Amo.CreditoID
		  AND Amo.Estatus IN (Estatus_Vigente,Estatus_Atrasado,Estatus_Vencida)
		  AND Dif.NumeroDiferimientos = 1
		GROUP BY Dif.CreditoID;

		UPDATE TMPCREPASOVENCIDO T, TMPDIASCREDDIFER D
			SET T.FechaTraspaso = DATE_SUB(T.FechaTraspaso,INTERVAL D.DiasAtraso DAY)
		WHERE T.CreditoID = D.CreditoID;

    END IF;

    SELECT  COUNT(DISTINCT(Tmp.CreditoID)) INTO  Var_ContadorCre
		FROM TMPCREPASOVENCIDO Tmp
		WHERE Tmp.Transaccion = Aud_NumTransaccion
		  AND Tmp.FechaTraspaso  <= Par_Fecha;

	SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

	IF (Var_ContadorCre > Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(
			Var_Poliza,     Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_PasoCarVenc,
			Ref_TrasVenc,   Par_SalidaNO,       Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
	END IF;



	OPEN CURSORCREVEN;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP

		FETCH CURSORCREVEN INTO
			Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
			Var_AmoCapVig,      Var_AmoCapAtra,     Var_AmoCapVen,      Var_AmoCaVeNex,     Var_EmpresaID,
			Var_CreCapVig,      Var_CreCapAtra,     Var_CreCapVen,      Var_CreCapVNE,      Var_CreIntOrd,
			Var_MonedaID,       Var_Estatus,        Var_ProdCreID,      Var_StatuAmort,     Var_SucCliente,
			Var_ClasifCre,      Var_IntAtrasado,    Var_EsReestruc,     Var_EstCreacion,    Var_Regularizado,
			Var_IntProvision,   Var_SubClasifID,    Var_SucursalCred,   Var_IntMorato;

		START TRANSACTION;
		  BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

			SET Error_Key   := Entero_Cero;
			SET Var_AmoCapAtra  := IFNULL(Var_AmoCapAtra, Entero_Cero);
			SET Var_IntAtrasado := IFNULL(Var_IntAtrasado, Entero_Cero);
			SET Var_IntMorato   := IFNULL(Var_IntMorato, Entero_Cero);
			SET Var_AmoCapVig   := IFNULL(Var_AmoCapVig, Entero_Cero);
			SET Var_EstCreacion := IFNULL(Var_EstCreacion, Cadena_Vacia);
			SET Var_Regularizado    := IFNULL(Var_Regularizado, Cadena_Vacia);
			SET Var_SucursalCred    := IFNULL(Var_SucursalCred, Aud_Sucursal);

			IF(Var_EstCreacion = Cadena_Vacia) THEN
				SET Var_EsReestruc  := No_EsReestruc;
			ELSE
				SET Var_EsReestruc  := Si_EsReestruc;
			END IF;


			IF (Var_Estatus = Estatus_Vigente OR Var_Estatus = Estatus_Suspendido)THEN

				IF(Var_Estatus != Estatus_Suspendido) THEN
					UPDATE CREDITOS SET
						Estatus         = Estatus_Vencida,
						FechTraspasVenc = Par_Fecha
						WHERE CreditoID     = Var_CreditoID;
				END IF;

				IF (Var_StatuAmort = Estatus_Atrasado AND Var_AmoCapAtra > Entero_Cero) THEN

					IF(Var_Estatus = Estatus_Vigente) THEN
						SET Mov_AboConta    := Con_CapAtrasado;
						SET Mov_CarConta    := Con_CapVencido;
						SET Mov_CarOpera    := Mov_CapVencido;
						SET Mov_AboOpera    := Mov_CapAtrasado;
					END IF;

					IF(Var_Estatus = Estatus_Suspendido) THEN
						SET Mov_AboConta    := Con_CapAtrasadoSup;
						SET Mov_CarConta    := Con_CapVencidoSup;
						SET Mov_CarOpera    := Mov_CapVencido;
						SET Mov_AboOpera    := Mov_CapAtrasado;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_AmoCapAtra,     Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_AmoCapAtra,     Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

				END IF; -- Endif Var_StatuAmort = Estatus_Atrasado

				IF (Var_StatuAmort = Estatus_Atrasado AND Var_IntAtrasado > Entero_Cero) THEN

					-- -------------------------------------------------------------------------
					-- Realizacion de las Estimaciones por el 100% del Saldo del Interes Vencido
					-- -------------------------------------------------------------------------

					-- Cancelacion de la Reserva Anterior del Interes
					SET Var_SaldoResInt := (SELECT  SaldoResInteres
						FROM CALRESCREDITOS
						WHERE   AplicaConta = Si_AplicaConta
						  AND   Fecha       = Var_FecAntRes
						  AND   CreditoID   = Var_CreditoID);

					SET Var_SaldoResInt := IFNULL(Var_SaldoResInt, Entero_Cero);

					IF(Var_SaldoResInt > Entero_Cero) THEN
						UPDATE  CALRESCREDITOS SET
							SaldoResInteres = SaldoResInteres - Var_SaldoResInt
							WHERE   AplicaConta = Si_AplicaConta
							  AND   Fecha       = Var_FecAntRes
							  AND   CreditoID   = Var_CreditoID;

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Gasto-Egreso o Cuenta Puente

						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN

							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_AboConta    := Con_ResultEPRC;  -- No Concepto: 18
							ELSE
								SET Mov_AboConta    := Con_PtePrinci;   -- No Concepto: 38
							END IF;
						ELSE

							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_AboConta    := Con_ResIntere;   -- No Concepto: 37
							ELSE
								SET Mov_AboConta    := Con_PteIntere;   -- No Concepto: 39
							END IF;

						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_AboOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					END IF;

					-- Estimacion del 100% del Saldo del Interes a pasar a Vencido
					-- Verifica su la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
					-- A la EPRC derivada de la Calificacion de Cartera
					IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_AboConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_AboConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;
					ELSE
						SET Mov_AboConta    := Con_BalAdiEPRC;  -- No Concepto: 49
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
						Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);


					-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
					-- A la EPRC derivada de la Calificacion de Cartera
					IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_CarConta    := Con_ResultEPRC;  -- No Concepto: 18
							ELSE
								SET Mov_CarConta    := Con_PtePrinci;   -- No Concepto: 38
							END IF;
						ELSE
							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_CarConta    := Con_ResIntere;   -- No Concepto: 37
							ELSE
								SET Mov_CarConta    := Con_PteIntere;   -- No Concepto: 39
							END IF;

						END IF;

					ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

						-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
						IF(Var_RegContaEPRC = EPRC_Resultados) THEN
							SET Mov_CarConta    := Con_ResAdiEPRC;  -- No Concepto: 51
						ELSE
							SET Mov_CarConta    := Con_PteAdiEPRC;  -- No Concepto: 50
						END IF;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Mov_AboOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					-- Poliza del Paso a Vencido del Interes
					IF(Var_Estatus = Estatus_Vigente) THEN
						SET Mov_AboConta	:= Con_IntAtrasado;
						SET Mov_CarConta	:= Con_IntVencido;
						SET Mov_CarOpera	:= Mov_IntVencido;
						SET Mov_AboOpera	:= Mov_IntAtrasado;
					END IF;

					IF(Var_Estatus = Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_IntAtrasadoSup;
						SET Mov_CarConta	:= Con_IntVencidoSup;
						SET Mov_CarOpera	:= Mov_IntVencido;
						SET Mov_AboOpera	:= Mov_IntAtrasado;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID, Var_SucursalCred,   Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

				END IF; -- EndIf Var_IntAtrasado > Entero_Cero

				-- Pasamos a Moratorio Vencido el Moratorio Devengado
				-- Siempre y cuando se especifique que los moratorios si se llevan en cuentas de ingresos (PARAMETROSSIS)
				IF (Var_TipoContaMora = Mora_EnIngresos AND Var_StatuAmort = Estatus_Atrasado AND Var_IntMorato > Entero_Cero) THEN

					-- Cancelacion de la Reserva Anterior del Interes
					SET Var_SaldoResInt := (SELECT  SaldoResInteres
						FROM CALRESCREDITOS
						WHERE   AplicaConta = Si_AplicaConta
						  AND   Fecha       = Var_FecAntRes
						  AND   CreditoID   = Var_CreditoID);

					SET Var_SaldoResInt := IFNULL(Var_SaldoResInt, Entero_Cero);

					IF(Var_SaldoResInt > Entero_Cero) THEN
						UPDATE  CALRESCREDITOS SET
							SaldoResInteres = SaldoResInteres - Var_SaldoResInt
							WHERE   AplicaConta = Si_AplicaConta
							  AND   Fecha       = Var_FecAntRes
							  AND   CreditoID   = Var_CreditoID;

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Gasto-Egreso o Cuenta Puente

						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN

							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_AboConta    := Con_ResultEPRC;  -- No Concepto: 18
							ELSE
								SET Mov_AboConta    := Con_PtePrinci;   -- No Concepto: 38
							END IF;
						ELSE

							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_AboConta    := Con_ResIntere;   -- No Concepto: 37
							ELSE
								SET Mov_AboConta    := Con_PteIntere;   -- No Concepto: 39
							END IF;

						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_AboOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID, Var_SucursalCred,   Aud_NumTransaccion);

					END IF;
					-- Estimacion del 100% del Saldo del Moratorio a pasar a Vencido

					-- Verifica su la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
					-- A la EPRC derivada de la Calificacion de Cartera
					IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_AboConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_AboConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;
					ELSE
						SET Mov_AboConta    := Con_BalAdiEPRC;  -- No Concepto: 49
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntMorato,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
						Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID, Var_SucursalCred,   Aud_NumTransaccion);

					-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
					-- A la EPRC derivada de la Calificacion de Cartera
					IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_CarConta    := Con_ResultEPRC;  -- No Concepto: 18
							ELSE
								SET Mov_CarConta    := Con_PtePrinci;   -- No Concepto: 38
							END IF;
						ELSE
							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_CarConta    := Con_ResIntere;   -- No Concepto: 37
							ELSE
								SET Mov_CarConta    := Con_PteIntere;   -- No Concepto: 39
							END IF;

						END IF;

					ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

						-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
						IF(Var_RegContaEPRC = EPRC_Resultados) THEN
							SET Mov_CarConta    := Con_ResAdiEPRC;  -- No Concepto: 50
						ELSE
							SET Mov_CarConta    := Con_PteAdiEPRC;  -- No Concepto: 51
						END IF;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntMorato,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Mov_AboOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					-- Poliza del Traspaso a Vencido
					IF(Var_Estatus = Estatus_Vigente) THEN
						SET Mov_AboOpera	:= Mov_IntMoratoVig;
						SET Mov_CarOpera	:= Mov_IntMoraVencido;
						SET Mov_CarConta	:= Con_MoraVencido;
						SET Mov_AboConta	:= Con_MoraDeven;
					END IF;

					IF(Var_Estatus = Estatus_Suspendido) THEN
						SET Mov_AboOpera	:= Mov_IntMoratoVig;
						SET Mov_CarOpera	:= Mov_IntMoraVencido;
						SET Mov_CarConta	:= Con_MoraVencidoSup;
						SET Mov_AboConta	:= Con_MoraDevenSup;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntMorato,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntMorato,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

				END IF; -- Endif Var_StatuAmort = Estatus_Atrasado

				IF (Var_StatuAmort = Estatus_Atrasado) THEN
					UPDATE AMORTICREDITO SET
						Estatus = Estatus_Vencida
						WHERE CreditoID         = Var_CreditoID
						  AND AmortizacionID    = Var_AmortizacionID;
				END IF;
			END IF; --  EndIf Var_Estatus = Estatus_Vigente

			IF (Var_StatuAmort = Estatus_Vigente AND Var_AmoCapVig > Entero_Cero) THEN

				-- Consideraciones de Reestructura, ya que un Credito Reestructura puede nacer Vencido
				-- Y bajo ese Supuesto no se deberia pasar a Vencido, pq ya esta En Vencido
				IF ( ( Var_EsReestruc = No_EsReestruc ) OR

					 ( Var_EsReestruc   = SI_EsReestruc AND
					   Var_EstCreacion  = Estatus_Vigente) OR

					 ( Var_EsReestruc   = SI_EsReestruc AND
					   Var_EstCreacion  = Estatus_Vencida AND
					   Var_Regularizado = Si_Regulariza) ) THEN

					IF(Var_Estatus = Estatus_Vigente) THEN
						SET Mov_AboConta	:= Con_CapVigente;
						SET Mov_CarConta	:= Con_CapVenNoEx;
						SET Mov_CarOpera	:= Mov_CapVenNoEx;
						SET Mov_AboOpera	:= Mov_CapVigente;
					END IF;

					IF(Var_Estatus = Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_CapVigenteSup;
						SET Mov_CarConta	:= Con_CapVenNoExSup;
						SET Mov_CarOpera	:= Mov_CapVenNoEx;
						SET Mov_AboOpera	:= Mov_CapVigente;
					END IF;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_AmoCapVig,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_AmoCapVig,      Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					-- -------------------------------------------------------------------------------
					-- Realizacion de las Estimaciones por el 100% del Saldo del Interes Provisionado
					-- -------------------------------------------------------------------------------
					IF (Var_IntProvision > Entero_Cero) THEN

						-- Cancelacion de la Reserva Anterior del Interes
						SET Var_SaldoResInt := (SELECT  SaldoResInteres
													FROM CALRESCREDITOS
													WHERE   AplicaConta = Si_AplicaConta
													  AND   Fecha       = Var_FecAntRes
													  AND   CreditoID   = Var_CreditoID );

						SET Var_SaldoResInt := IFNULL(Var_SaldoResInt, Entero_Cero);

						IF(Var_SaldoResInt > Entero_Cero) THEN

							UPDATE  CALRESCREDITOS SET
								SaldoResInteres = SaldoResInteres - Var_SaldoResInt
								WHERE   AplicaConta = Si_AplicaConta
								  AND   Fecha       = Var_FecAntRes
								  AND   CreditoID   = Var_CreditoID;


							-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Gasto-Egreso o Cuenta Puente

							-- Verificamos si Divide la Estimacion en Capital e Interes
							IF(Var_DivideEPRC = NO_DivideEPRC) THEN

								-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
								IF(Var_RegContaEPRC = EPRC_Resultados) THEN
									SET Mov_AboConta    := Con_ResultEPRC;  -- No Concepto: 18
								ELSE
									SET Mov_AboConta    := Con_PtePrinci;   -- No Concepto: 38
								END IF;
							ELSE

								-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
								IF(Var_RegContaEPRC = EPRC_Resultados) THEN
									SET Mov_AboConta    := Con_ResIntere;   -- No Concepto: 37
								ELSE
									SET Mov_AboConta    := Con_PteIntere;   -- No Concepto: 39
								END IF;

							END IF;

							CALL  CONTACREDITOPRO (
								Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
								Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
								Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
								Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
								Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
								Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
								Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
								Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
								Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

							-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
							-- Verificamos si Divide la Estimacion en Capital e Interes
							IF(Var_DivideEPRC = NO_DivideEPRC) THEN
								SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
							ELSE
								SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
							END IF;

							CALL  CONTACREDITOPRO (
								Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
								Par_Fecha,      Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,
								Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
								Des_CanResInt,  Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
								Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
								Mov_AboOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
								Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
								Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
								Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

						END IF;

						-- Estimacion del 100% del Interes Provisionado

						-- Verifica su la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
						-- A la EPRC derivada de la Calificacion de Cartera
						IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
							-- Verificamos si Divide la Estimacion en Capital e Interes
							IF(Var_DivideEPRC = NO_DivideEPRC) THEN
								SET Mov_AboConta    := Con_Balance;     -- No Concepto: 17
							ELSE
								SET Mov_AboConta    := Con_BalIntere;   -- No Concepto: 36
							END IF;
						ELSE
							SET Mov_AboConta    := Con_BalAdiEPRC;  -- No Concepto: 49
						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_IntProvision,   Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,  	Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

						-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas   xx
						-- A la EPRC derivada de la Calificacion de Cartera
						IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
							-- Verificamos si Divide la Estimacion en Capital e Interes
							IF(Var_DivideEPRC = NO_DivideEPRC) THEN
								-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
								IF(Var_RegContaEPRC = EPRC_Resultados) THEN
									SET Mov_CarConta    := Con_ResultEPRC;  -- No Concepto: 18
								ELSE
									SET Mov_CarConta    := Con_PtePrinci;   -- No Concepto: 38
								END IF;
							ELSE
								-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
								IF(Var_RegContaEPRC = EPRC_Resultados) THEN
									SET Mov_CarConta    := Con_ResIntere;   -- No Concepto: 37
								ELSE
									SET Mov_CarConta    := Con_PteIntere;   -- No Concepto: 39
								END IF;

							END IF;

						ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

							-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
							IF(Var_RegContaEPRC = EPRC_Resultados) THEN
								SET Mov_CarConta    := Con_ResAdiEPRC;  -- No Concepto: 50
							ELSE
								SET Mov_CarConta    := Con_PteAdiEPRC;  -- No Concepto: 51
							END IF;
						END IF;

						CALL  CONTACREDITOPRO (
							Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
							Par_Fecha,      Var_FecApl,         Var_IntProvision,   Var_MonedaID,
							Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
							Des_Reserva,    Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
							Var_Poliza,     AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
							Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
							Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					-- Poliza del Paso a Vencido del Interes Devengado Vigente al Dia (fchia 123)
					IF(Var_Estatus = Estatus_Vigente) THEN
						SET Mov_CarConta	:= Con_IntVencido;
						SET Mov_AboConta	:= Con_IntDeven;
					END IF;

					IF(Var_Estatus = Estatus_Suspendido) THEN
						SET Mov_CarConta	:= Con_IntVencidoSup;
						SET Mov_AboConta	:= Con_IntDevenSup;
					END IF;

					SET Mov_CarOpera    := Mov_IntVencido;
					SET Mov_AboOpera    := Mov_IntProvision;

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntProvision,   Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					CALL  CONTACREDITOPRO (
						Var_CreditoID,  Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_Fecha,      Var_FecApl,         Var_IntProvision,   Var_MonedaID,
						Var_ProdCreID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucCliente,
						Des_CieDia,     Ref_GenInt,         AltaPoliza_NO,      Entero_Cero,
						Var_Poliza,     AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,   Cadena_Vacia,		/*Par_SalidaNO,*/
						Par_NumErr,     Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,  Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,Aud_ProgramaID,     Var_SucursalCred,   Aud_NumTransaccion);

					END IF; -- EndIf de Interes Provisionado Mayor a Cero

				END IF; -- EndIf Consideraciones Reestructura
			END IF; -- EndIf Var_AmoCapVig > Entero_Cero

		END;
		SET Var_CreditoStr = CONVERT(Var_CreditoID, CHAR);

		IF Error_Key = 0 THEN
			COMMIT;
		END IF;

		IF Error_Key = 1 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Pro_PasoVenc,   Par_Fecha,          Var_CreditoStr,     Des_ErrorGral,
					Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
			COMMIT;
		END IF;
		IF Error_Key = 2 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Pro_PasoVenc,   Par_Fecha,          Var_CreditoStr,     Des_ErrorLlavDup,
					Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
			COMMIT;
		END IF;
		IF Error_Key = 3 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Pro_PasoVenc,   Par_Fecha,          Var_CreditoStr,     Des_ErrorCallSP,
					Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
			COMMIT;
		END IF;
		IF Error_Key = 4 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Pro_PasoVenc,   Par_Fecha,          Var_CreditoStr,     Des_ErrorValNulos,
					Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
			COMMIT;
		END IF;

		 END LOOP;
	END;
	CLOSE CURSORCREVEN;

	TRUNCATE TABLE TMPCREPASOVENCIDO;

END TerminaStore$$