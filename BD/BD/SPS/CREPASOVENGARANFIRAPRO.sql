-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASOVENGARANFIRAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASOVENGARANFIRAPRO`;

DELIMITER $$
CREATE PROCEDURE `CREPASOVENGARANFIRAPRO`(
-- ======================================================================
-- STORE PARA REALIZAR EL PROCESO DE PASO A VENCIDO DE UN CREDITO ESPECIFICO
-- ======================================================================
	Par_CreditoID       BIGINT(12),		-- Parametro ID de credito
	Par_Salida			CHAR(1), 		-- Parametro de Salida S o N
    Par_PolizaID		BIGINT(20),		-- Parametro de ID Poliza
	INOUT	Par_NumErr	INT(11),		-- Control de Errores: Numero de Error
	INOUT	Par_ErrMen	VARCHAR(400),	-- Control de Errores: Descripcion del Error

    Par_EmpresaID       INT(11),		-- Parametro de Auditoria
    Aud_Usuario         INT(11),		-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Parametro de Auditoria
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
	DECLARE Par_Fecha			DATE;

	/* Declaracion de Constantes. */
	DECLARE Decimal_Cero 		DECIMAL(14,2);
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
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE Contador			INT(11);


	/* Asignacion de Constantes */
	SET Estatus_Vigente     := 'V';             -- Estatus Amortizacion: Vigente
	SET Estatus_Vencida     := 'B';             -- Estatus Amortizacion: Vencido
	SET Estatus_Atrasado    := 'A';             -- Estatus Amortizacion: Atrasado
	SET Cre_Vencido         := 'B';           	-- Estatus Credito: Vencido
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Pro_PasoVenc        := 203;             -- Numero de Proceso Batch: Traspado de Cartera Vencida
	SET Pol_Automatica      := 'A';             -- Tipo de Poliza Contable: Automatica
	SET Con_PasoCarVenc     := 53;              -- Concepto Contable: Traspaso a Cartera Vencida
	SET SalidaNO        	:= 'N';             -- Salida a Pantalla: NO
	SET SalidaSI        	:= 'S';             -- Salida a Pantalla: SI


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

	SET Des_CieDia          := 'APLICACION DE GARANTIAS FIRA';
	SET Ref_GenInt          := 'TRASPASO A CARTERA VENCIDA';
	SET Des_Reserva         := 'ESTIMACION PASO A VENCIDO';
	SET Des_CanResInt       := 'LIBERACION ESTIMACION PREVIA INTERES';

	SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';
	SET Decimal_Cero 		:= 0.00;
	SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);
	SET Par_Fecha := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecApl := Par_Fecha;

	ManejoErrores : BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPASOVENGARANFIRAPRO');
			END;

	SELECT TipoContaMora INTO Var_TipoContaMora
		FROM PARAMETROSSIS;

	SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCAdicional INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCAdicional
		FROM PARAMSRESERVCASTIG
		WHERE EmpresaID = Par_EmpresaID;


	SET Var_RegContaEPRC 	:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
	SET Var_DivideEPRC		:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
	SET Var_TipoContaMora   := IFNULL(Var_TipoContaMora, Mora_CtaOrden);
	SET Var_EPRCAdicional   := IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);
	SET Var_Poliza			:= Par_PolizaID;
	-- Fecha de la Ultima Estimacion de Reservas
	SELECT  MAX(Fecha) INTO Var_FecAntRes
		FROM CALRESCREDITOS
		WHERE   AplicaConta = Si_AplicaConta;

	SET Var_FecAntRes   := IFNULL(Var_FecAntRes, Fecha_Vacia);


	-- Temporal Para seleccionar los Creditos que van a  pasar a vencido
	DELETE FROM TMPCREPASOVENCIDO WHERE Transaccion = Aud_NumTransaccion;

	-- Se obtienen los datos del Credito
	INSERT INTO TMPCREPASOVENCIDO(
		CreditoID,			Transaccion,		ProductoCreditoID,	FrecuenciaCapital,	FrecuenciaInteres,
        FechaAtrasoCapital,	FechaAtrasoInteres,	FechaTraspaso)

	SELECT
		Cre.CreditoID, 		Aud_NumTransaccion,	MAX(Cre.ProductoCreditoID),	MAX(Cre.FrecuenciaCap),
        MAX(Cre.FrecuenciaInt),	MAX(Cre.FechaAtrasoCapital),	MAX(Cre.FechaAtrasoInteres),
        DATE_ADD(IFNULL(MIN(Amo.FechaExigible), Par_Fecha), INTERVAL (IFNULL(MAX(Dia.DiasPasoVencido), 1) - 1) DAY)
	 FROM	AMORTICREDITO Amo,
			PRODUCTOSCREDITO Pro,
			CREDITOS Cre
      LEFT OUTER JOIN DIASPASOVENCIDO Dia ON Dia.ProducCreditoID = Cre.ProductoCreditoID
        WHERE Amo.CreditoID     = Cre.CreditoID
          AND Cre.ProductoCreditoID = Pro.ProducCreditoID
          AND (Amo.Estatus =  Estatus_Atrasado OR Amo.Estatus = Estatus_Vigente)
		  AND Cre.CreditoID = Par_CreditoID
        GROUP BY Cre.CreditoID;

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
			FechaVencCapital		= (SELECT DATE_SUB(DATE_ADD( T.FechaAtrasoCapital, INTERVAL T.DiasCapital DAY), INTERVAL 1 DAY))
	WHERE	T.FechaAtrasoCapital	!= Fecha_Vacia
	AND		T.FrecuenciaCapital	 	= PagoPeriodico;


	-- Actualiza la fecha de paso a vencido del Credito cuando el atraso sea por Interes para Creditos con frecuencia "I"
	 UPDATE TMPCREPASOVENCIDO T	SET
			FechaVencInteres		= (SELECT DATE_SUB(DATE_ADD( T.FechaAtrasoInteres, INTERVAL T.DiasInteres DAY), INTERVAL 1 DAY))
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


    SELECT  COUNT(DISTINCT(Tmp.CreditoID)) INTO  Var_ContadorCre
		FROM TMPCREPASOVENCIDO Tmp
		WHERE Tmp.Transaccion = Aud_NumTransaccion
		  AND Tmp.FechaTraspaso  <= Par_Fecha;

	SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

	IF (Var_ContadorCre > Entero_Cero) THEN
		CALL MAESTROPOLIZASALT(
			Var_Poliza,     Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_PasoCarVenc,
			Ref_TrasVenc,   SalidaNO,       	Par_NumErr,     Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	DELETE FROM TMPAMORTIPASOVEN WHERE Transaccion = Aud_NumTransaccion;

	SET @conta := 0;

		INSERT INTO TMPAMORTIPASOVEN(
				CreditoID,				TMPID,
				AmortizacionID,			FechaInicio,		FechaVencim,
				FechaExigible,			SaldoCapVigente,	SaldoCapAtrasa,		SaldoCapVencido,
				SaldoCapVenNExi,		EmpresaID,			SaldoCapVigent,		SaldoCapAtrasad,
				SaldoCapVencidoCre,		SaldCapVenNoExi,	SaldoInterOrdin,	MonedaID,
				EstatusCre,				ProductoCreditoID,	EstatusAmo,			SucursalOrigen,
				Clasificacion,			SaldoInteresAtr,	EsReestructura,		EstatusCreacion,
				Regularizado,			SaldoInteresPro,	SubClasifID,		SucursalID,
				SaldoMoratorios,		Transaccion)
		SELECT  DISTINCT(Cre.CreditoID),    (@conta :=@conta+1),
				Amo.AmortizacionID,							IFNULL(Amo.FechaInicio, Fecha_Vacia),       IFNULL(Amo.FechaVencim, Fecha_Vacia),
				IFNULL(Amo.FechaExigible, Fecha_Vacia),     IFNULL(Amo.SaldoCapVigente, Decimal_Cero),  IFNULL(Amo.SaldoCapAtrasa, Decimal_Cero),   IFNULL(Amo.SaldoCapVencido, Decimal_Cero),
				IFNULL(Amo.SaldoCapVenNExi, Decimal_Cero),  IFNULL(Cre.EmpresaID, Entero_Cero),         IFNULL(Cre.SaldoCapVigent, Decimal_Cero),   IFNULL(Cre.SaldoCapAtrasad, Decimal_Cero),
				IFNULL(Cre.SaldoCapVencido, Decimal_Cero),  IFNULL(Cre.SaldCapVenNoExi, Decimal_Cero),  IFNULL(Cre.SaldoInterOrdin, Decimal_Cero),  IFNULL(Cre.MonedaID, Entero_Cero),
				IFNULL(Cre.Estatus, Cadena_Vacia),          IFNULL(Cre.ProductoCreditoID, Entero_Cero), IFNULL(Amo.Estatus, Cadena_Vacia),          IFNULL(Cli.SucursalOrigen, Entero_Cero),
				IFNULL(Des.Clasificacion, Cadena_Vacia),    IFNULL(Amo.SaldoInteresAtr, Decimal_Cero),  IFNULL(Pro.EsReestructura, Cadena_Vacia), 	IFNULL(Res.EstatusCreacion, Cadena_Vacia),
				IFNULL(Res.Regularizado, Cadena_Vacia),     IFNULL(Amo.SaldoInteresPro, Decimal_Cero),  IFNULL(Des.SubClasifID, Entero_Cero),       IFNULL(Cre.SucursalID, Entero_Cero),
				IFNULL(Amo.SaldoMoratorios, Decimal_Cero),	Aud_NumTransaccion
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
			AND 	Cre.CreditoID 			= Tmp.CreditoID
            ORDER BY Amo.AmortizacionID ASC LIMIT 1;



		SET Contador := (SELECT COUNT(*) FROM TMPAMORTIPASOVEN WHERE Transaccion = Aud_NumTransaccion);

			SELECT 	CreditoID,				AmortizacionID,		FechaInicio,			FechaVencim,			FechaExigible,
					SaldoCapVigente,		SaldoCapAtrasa,		SaldoCapVencido,		SaldoCapVenNExi,		EmpresaID,
					SaldoCapVigent,			SaldoCapAtrasad,	SaldoCapVencidoCre,		SaldCapVenNoExi,		SaldoInterOrdin,
					MonedaID,				EstatusCre,			ProductoCreditoID,		EstatusAmo,				SucursalOrigen,
                    Clasificacion,			SaldoInteresAtr,	EsReestructura,			EstatusCreacion,		Regularizado,
                    SaldoInteresPro,		SubClasifID,		SucursalID,				SaldoMoratorios
			INTO 	Var_CreditoID,      Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
					Var_AmoCapVig,      Var_AmoCapAtra,     Var_AmoCapVen,      Var_AmoCaVeNex,     Var_EmpresaID,
					Var_CreCapVig,      Var_CreCapAtra,     Var_CreCapVen,      Var_CreCapVNE,      Var_CreIntOrd,
					Var_MonedaID,       Var_Estatus,        Var_ProdCreID,      Var_StatuAmort,     Var_SucCliente,
					Var_ClasifCre,      Var_IntAtrasado,    Var_EsReestruc,     Var_EstCreacion,    Var_Regularizado,
					Var_IntProvision,   Var_SubClasifID,    Var_SucursalCred,   Var_IntMorato
			FROM TMPAMORTIPASOVEN
            WHERE CreditoID = Par_CreditoID AND TMPID = 1 AND Transaccion = Aud_NumTransaccion;

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


			IF (Var_Estatus = Estatus_Vigente)THEN

				UPDATE CREDITOS SET
					Estatus         = Estatus_Vencida,
					FechTraspasVenc = Par_Fecha
					WHERE CreditoID     = Var_CreditoID;

				IF (Var_StatuAmort = Estatus_Atrasado AND Var_AmoCapAtra > Entero_Cero) THEN

					SET Mov_AboConta    := Con_CapAtrasado;
					SET Mov_CarConta    := Con_CapVencido;
					SET Mov_CarOpera    := Mov_CapVencido;
					SET Mov_AboOpera    := Mov_CapAtrasado;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_AmoCapAtra,     Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_AmoCapAtra,     Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_AboOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

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

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
						Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Mov_AboOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


					-- Poliza del Paso a Vencido del Interes
					SET Mov_AboConta    := Con_IntAtrasado;
					SET Mov_CarConta    := Con_IntVencido;
					SET Mov_CarOpera    := Mov_IntVencido;
					SET Mov_AboOpera    := Mov_IntAtrasado;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntAtrasado,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
						-- Verificamos si Divide la Estimacion en Capital e Interes
						IF(Var_DivideEPRC = NO_DivideEPRC) THEN
							SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
						ELSE
							SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
						END IF;

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_AboOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

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

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntMorato,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
						Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntMorato,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Mov_AboOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					-- Poliza del Traspaso a Vencido
					SET Mov_AboOpera    := Mov_IntMoratoVig;
					SET Mov_CarOpera    := Mov_IntMoraVencido;
					SET Mov_CarConta    := Con_MoraVencido;
					SET Mov_AboConta    := Con_MoraDeven;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntMorato,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntMorato,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

					SET Mov_AboConta    := Con_CapVigente;
					SET Mov_CarConta    := Con_CapVenNoEx;
					SET Mov_CarOpera    := Mov_CapVenNoEx;
					SET Mov_AboOpera    := Mov_CapVigente;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_AmoCapVig,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_AmoCapVig,      Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

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

							CALL  CONTACREDITOSPRO (
								Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
								Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
								Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
								Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
								Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
								Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
								Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

							-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
							-- Verificamos si Divide la Estimacion en Capital e Interes
							IF(Var_DivideEPRC = NO_DivideEPRC) THEN
								SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
							ELSE
								SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
							END IF;

							CALL  CONTACREDITOSPRO (
								Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
								Var_FecApl,         Var_SaldoResInt,    Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
								Var_SubClasifID,    Var_SucCliente,		Des_CanResInt,  	Ref_GenInt,         AltaPoliza_NO,
								Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
								Mov_AboOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
								Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
								Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

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

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_IntProvision,   Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
							Mov_CarOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

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

						CALL  CONTACREDITOSPRO (
							Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
							Var_FecApl,         Var_IntProvision,   Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
							Var_SubClasifID,    Var_SucCliente,		Des_Reserva,    	Ref_GenInt,         AltaPoliza_NO,
							Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
							Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
							Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
							Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

					-- Poliza del Paso a Vencido del Interes Devengado Vigente al Dia (fchia 123)
					SET Mov_CarConta    := Con_IntVencido;
					SET Mov_AboConta    := Con_IntDeven;

					SET Mov_CarOpera    := Mov_IntVencido;
					SET Mov_AboOpera    := Mov_IntProvision;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntProvision,   Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_CarConta,
						Mov_CarOpera,   	Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Var_CreditoID,  	Var_AmortizacionID, Entero_Cero,        Entero_Cero,		Par_Fecha,
						Var_FecApl,         Var_IntProvision,   Var_MonedaID,		Var_ProdCreID,  	Var_ClasifCre,
						Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,         AltaPoliza_NO,
						Entero_Cero,		Var_Poliza,     	AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,   	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,  
						Cadena_Vacia,		SalidaNO,			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
						Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Var_SucursalCred,   Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					END IF; -- EndIf de Interes Provisionado Mayor a Cero

				END IF; -- EndIf Consideraciones Reestructura
			END IF; -- EndIf Var_AmoCapVig > Entero_Cero

    SET Par_NumErr      := '000';
	SET Par_ErrMen      := CONCAT('Credito Pasado a Vencido Exitosamente: ',CONVERT(Par_CreditoID,CHAR));

	-- Se realiza el borrado de la tabla temporal por el numero de Transaccion
	DELETE FROM TMPCREPASOVENCIDO WHERE Transaccion = Aud_NumTransaccion;
	DELETE FROM TMPAMORTIPASOVEN WHERE Transaccion = Aud_NumTransaccion;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           'creditoID' AS control;
END IF;
END TerminaStore$$