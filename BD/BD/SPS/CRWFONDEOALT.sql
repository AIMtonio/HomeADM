-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOALT`;
DELIMITER $$


CREATE PROCEDURE `CRWFONDEOALT`(
    Par_ClienteID       BIGINT(20),			-- ID del cliente
    Par_CreditoID       BIGINT(12), 		-- ID del credito
    Par_CuentaAhoID     BIGINT(12), 		-- ID de la cuenta de ahorro
    Par_SoliciCredID    BIGINT(20),			-- ID de la solicitud de credito
    Par_SolFondeoID     BIGINT(20),			-- ID de la solicitud fondeo
    Par_ConsecSolici    INT(11), 			-- Consecutivo de la solicitud
    Par_Folio           VARCHAR(20), 		-- Folio
    Par_CalcInteresID   INT(11),			-- ID del calculo de intereses
    Par_TasaBaseID      INT(11),			-- ID de la tasa base
    Par_SobreTasa       DECIMAL(10,2),		-- sobre tasa

    Par_TasaFija        DECIMAL(10,2),		-- Tasa fija
    Par_PisoTasa        DECIMAL(10,2),		-- Piso tasa
    Par_TechoTasa       DECIMAL(10,2),		-- Techo tasa
    Par_MontoFondeo     DECIMAL(12,2),		-- Monto fondeo
    Par_PorcenFondeo    DECIMAL(10,6),		-- Porcentaje fondeo
    Par_MonedaID        INT(11),			-- ID de la moneda
    Par_FechaInicio     DATE,				-- Fecha de inicio
    Par_FechaVencim     DATE,				-- Fecha de Vencimiento
    Par_TipoFondeadorID CHAR(1),            -- Tipo de Fondeador (TIPOSFONDEADORES).
    Par_NumCuotas       INT(11),			-- Numero de cuotas

    Par_Frecuencia      CHAR(1),			-- Frecuencia
    Par_DiaPagoCap      CHAR(1),			-- Dias pago capital
    Par_DiaMesCap       INT(11),			-- Dias mes capital
    Par_PorcenMora      DECIMAL(10,2),		-- porcentaje moratorio
    Par_PorcenComisi    DECIMAL(10,2),		-- porcentaje comisiones
    Par_ProdctoCreID    INT(11),			-- producto de credito
    Par_SucCliente      INT(11),			-- sucursal cliente
    Par_FechaOper       DATE,				-- fecha operacion
    Par_FechaApl        DATE,				-- fecha de aplicacion

    Par_Referencia      VARCHAR(50),		-- Referencia
    Par_NumRetMes       INT(11),			-- numero retencion de mes
    Par_FechaInhabil    CHAR(1),			-- fecha inhabil
    Par_AjFecUlVenAmo   CHAR(1),			-- Ajusta fecha exigible vencimiento de amortizacion
    Par_AjFecExiVen     CHAR(1),			-- Ajusta fecha exigible vencimiento
    Par_Poliza          BIGINT(20),			-- Poliza
    Par_TipoFondeo      CHAR(1),            -- S: Fondeo por Solicitud, C: Fondeo por Credito
	Par_Gat				DECIMAL(12,2),		-- Gasto anual total
    Par_Salida          CHAR(1),			-- Parametro de salida S= SI, N= NO

	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Error mensaje
	INOUT Par_Consecutivo	BIGINT(20),		-- Consecutivo

	Aud_EmpresaID       INT(11),		-- Auditoria
	Aud_Usuario         INT(11),        -- Auditoria
	Aud_FechaActual     DATETIME,       -- Auditoria
	Aud_DireccionIP     VARCHAR(15),    -- Auditoria
	Aud_ProgramaID      VARCHAR(50),    -- Auditoria
	Aud_Sucursal        INT(11),        -- Auditoria
	Aud_NumTransaccion  BIGINT(20)      -- Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE FondeoCRW      BIGINT(20);
	DECLARE Var_InterGene   DECIMAL(12,2);
	DECLARE Var_InterRet    DECIMAL(12,2);
	DECLARE Var_PorcentInt  DECIMAL(8,6);
	DECLARE Var_DiasIntere  INT(11);
	DECLARE Var_Ciclo       INT(11);
	DECLARE Var_DiasCredito DECIMAL(12,2);
	DECLARE Var_TasaISR     DECIMAL(8,4);
	DECLARE Var_PagaISR     CHAR(1);
	DECLARE Int_NumErr      INT(11);
	DECLARE Var_CAT         DECIMAL(14,4);
	DECLARE Var_FormReten   CHAR(1);
	DECLARE TotalCuotas		INT(11);
	DECLARE Var_MaxFecVen	DATE;
	DECLARE	FondeoKuboIni	BIGINT(20);

	DECLARE Var_GAT			DECIMAL(12,2);
	DECLARE	Var_Inflacion 	DECIMAL(5,2);
	DECLARE Var_GATReal		DECIMAL(12,2);
	DECLARE Var_Control		VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia     DATE;
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Entero_Cero     INT(11);
	DECLARE Por_Cien        DECIMAL(12,2);
	DECLARE Nace_Estatus    CHAR(1);
	DECLARE Salida_SI       CHAR(1);
	DECLARE Salida_NO       CHAR(1);
	DECLARE NO_PagaISR      CHAR(1);
	DECLARE SI_PagaISR      CHAR(1);
	DECLARE Des_AltaInv     VARCHAR(100);
	DECLARE EstatusVigen    CHAR(1);
	DECLARE Nat_Cargo       CHAR(1);
	DECLARE Nat_Abono       CHAR(1);

	DECLARE AltaPoliza_NO   CHAR(1);
	DECLARE AltaPolKubo_SI  CHAR(1);
	DECLARE AltaMovKubo_NO  CHAR(1);
	DECLARE AltaMovAho_SI   CHAR(1);
	DECLARE Aplica_IVANO    CHAR(1);
	DECLARE Con_KuboCapita  INT(11);
	DECLARE Mov_AhoApeInv   CHAR(3);
	DECLARE Ret_Porcenta    CHAR(1);
	DECLARE Tip_FonSolici   CHAR(1);
	DECLARE Tip_FonCredito  CHAR(1);
	DECLARE Mov_Capital     INT(11);
	DECLARE SI_AplicaISR    CHAR(1);
	DECLARE Par_FechaVen		DATE;
	DECLARE Par_MontoCuota		DECIMAL(12,2);

	-- Asignacion de Constantes
	SET Fecha_Vacia     := '1900-01-01';  -- Fecha Vacia
	SET Cadena_Vacia    := '';			   -- String Vacio
	SET Entero_Cero     := 0;			   -- Entero en Cero
	SET Por_Cien        := 100.00;			-- Porcentaje Cien
	SET Nace_Estatus    := 'N';			   -- Estats de Vigente
	SET Salida_SI       := 'S';			  -- Al ejecutar el Store SI pedir Salida
	SET Salida_NO       := 'N';         -- Al ejecutar el Store NO pedir Salida
	SET NO_PagaISR      := 'N';         -- El Cliente NO Paga ISR
	SET SI_PagaISR      := 'S';         -- El Cliente SI Paga ISR
	SET EstatusVigen    := 'N';			  -- Estatus de Vigente
	SET Nat_Cargo       := 'C';			  -- Naturaleza de Cargo
	SET Nat_Abono       := 'A';			  -- Naturaleza de Abono
	SET AltaPoliza_NO   := 'N';			  -- No dar de Alta la Poliza Contable
	SET AltaPolKubo_SI  := 'S';			  -- Alta de la Poliza de Kubo: SI
	SET AltaMovKubo_NO  := 'N';			  -- Alta de Movimiento de Kubo: NO
	SET AltaMovAho_SI   := 'S';			  -- Alta de Movimiento de Ahorro: SI
	SET Con_KuboCapita  := 1;			  -- Concepto Contable de Kubo: Capital
	SET Mov_AhoApeInv   := '70';		  -- Tipo de Movimiento der Ahorro: Apertura de Inversion
	SET Aplica_IVANO    := 'N';         -- No aplicar IVA en los Cotizadores
	SET Ret_Porcenta    := 'P';         -- Formual de Retencion: Porcentaje Directo Sobre Rendimiento
	SET Tip_FonSolici   := 'S';         -- Tipo de Fondeo en base a la Solicitud
	SET Tip_FonCredito  := 'C';         -- Tipo de Fondeo en base al Credito
	SET SI_AplicaISR    := 'S';         -- SI se considera la Aplicacion del ISR
	SET Mov_Capital     := 1;           -- Tipo de Movimiento Kubo: Capital Ordinario
	SET Des_AltaInv	:= 'ALTA INVERSION CRW';

	SET FondeoCRW 	:= 0;
	SET Var_Ciclo   := 1;

ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOALT');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 001;
			SET Par_ErrMen 			:= 'El numero de Cliente esta Vacio';
			SET Var_Control 		:= 'clienteID';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 002;
			SET Par_ErrMen 			:= 'El numero de Credito esta Vacio';
			SET Var_Control 		:= 'creditoID';
			LEAVE ManejoErrores;

	END IF;

	IF(IFNULL(Par_SoliciCredID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 003;
			SET Par_ErrMen 			:= 'La Solicitud de Credito esta vacia.';
			SET Var_Control 		:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ConsecSolici, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 004;
			SET Par_ErrMen 			:= 'El numero consecutivo esta vacio.';
			SET Var_Control 		:= 'consecutivo';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MontoFondeo, Entero_Cero)) <= Entero_Cero THEN
			SET Par_NumErr 			:= 005;
			SET Par_ErrMen 			:= 'El Monto de Fondeo esta vacio.';
			SET Var_Control 		:= 'montoFondeo';
			LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_PorcenFondeo, Entero_Cero)) <= Entero_Cero THEN
			SET Par_NumErr 			:= 006;
			SET Par_ErrMen 			:= 'El procentaje de fondeo esta vacio.';
			SET Var_Control 		:= 'porcentajeFondeo';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 007;
			SET Par_ErrMen 			:= 'El numero de moneda esta vacio.';
			SET Var_Control 		:= 'monedaID';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NumCuotas, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 008;
			SET Par_ErrMen 			:= 'El numero de cuotas esta vacio.';
			SET Var_Control 		:= 'numCuotas';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcenMora, Entero_Cero)) < Entero_Cero THEN
			SET Par_NumErr 			:= 009;
			SET Par_ErrMen 			:= 'Porcentaje Participacion en Mora Incorrecto.';
			SET Var_Control 		:= 'porcentajeMora';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PorcenComisi, Entero_Cero)) < Entero_Cero THEN
			SET Par_NumErr 			:= 010;
			SET Par_ErrMen 			:= 'Porcentaje Participacion en Comisiones esta vacio.';
			SET Var_Control 		:= 'porcentajeComisi';
			LEAVE ManejoErrores;
	END IF;

	-- CALL FOLIOMASIVOKUBO('FONDEOKUBO',	1,  FondeoKuboIni,	FondeoKubo);
	CALL FOLIOSAPLICAACT('CRWDFONDEO',	FondeoCRW );

	/*
	SET FondeoKubo	:= (SELECT IFNULL(MAX(FondeoKuboID),Entero_Cero) + 1
						FROM FONDEOKUBO);
	*/

	-- Alta del Fondeo Kubo
	INSERT INTO CRWFONDEO(
		SolFondeoID, 		ClienteID,			CreditoID,			CuentaAhoID,			SolicitudCreditoID,
		Consecutivo,		Folio, 				CalcInteresID,		TasaBaseID,				SobreTasa,
		TasaFija,			PisoTasa,			TechoTasa, 			MontoFondeo,			PorcentajeFondeo,
		MonedaID,			FechaInicio,  		FechaVencimiento,	TipoFondeo,				NumCuotas,
		NumRetirosMes,		PorcentajeMora,		PorcentajeComisi,	Estatus,     			SaldoCapVigente,
		SaldoCapExigible,   SaldoInteres,		ProvisionAcum,		MoratorioPagado,		ComFalPagPagada,
		IntOrdRetenido,     IntMorRetenido,		ComFalPagRetenido,	Gat,					ValorGatReal,
		SaldoIntMoratorio,	SaldoCapCtaOrden,	SaldoIntCtaOrden, 	EmpresaID,				Usuario,
		FechaActual,        DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion)
	VALUES (
		FondeoCRW,			Par_ClienteID,		Par_CreditoID,		Par_CuentaAhoID,		Par_SoliciCredID,
		Par_ConsecSolici,	Par_Folio,			Par_CalcInteresID,	Par_TasaBaseID,			Par_SobreTasa,
		Par_TasaFija,		Par_PisoTasa,		Par_TechoTasa,		Par_MontoFondeo,		Par_PorcenFondeo,
		Par_MonedaID,		Par_FechaInicio,	Par_FechaVencim,   	Par_TipoFondeadorID,	Par_NumCuotas,
		Par_NumRetMes,		Par_PorcenMora,		Par_PorcenComisi,	Nace_Estatus,			Par_MontoFondeo,
		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,			Entero_Cero,
		Entero_Cero,		Entero_Cero,		Entero_Cero,		Par_Gat,				Var_GATReal,
		Entero_Cero,		Entero_Cero,		Entero_Cero,		Aud_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	-- Marcamos la Solicitu de Fondeo como Vigente o con Inversion ya Creada
	UPDATE CRWFONDEOSOLICITUD SET
		FondeoID    	= FondeoCRW,
		Estatus      	= EstatusVigen
		WHERE SolFondeoID 	= Par_SolFondeoID;


	-- Contabilizacion de la Inversion (Cartera Pasiva)
	CALL CRWCONTAINVPRO (
		FondeoCRW,      	Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,  Par_FechaOper,
		Par_FechaApl,       Par_MontoFondeo,    Par_MonedaID,       Par_NumRetMes,  Par_SucCliente,
		Des_AltaInv,        Par_Referencia,     AltaPoliza_NO,      Entero_Cero,    Par_Poliza,
		AltaPolKubo_SI,     AltaMovKubo_NO,     Con_KuboCapita,     Entero_Cero,    Nat_Abono,
		Cadena_Vacia,       AltaMovAho_SI,      Mov_AhoApeInv,      Nat_Cargo,      Salida_NO,
		Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    Aud_EmpresaID,  Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
	END IF;

	SELECT DiasCredito INTO Var_DiasCredito
		FROM PARAMETROSSIS;

	SELECT TasaISR, FormulaRetencion INTO Var_TasaISR, Var_FormReten
	FROM PARAMETROSCRW WHERE ProductoCreditoID = Par_ProdctoCreID;


	SELECT PagaISR INTO Var_PagaISR
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

	SET Var_PagaISR = IFNULL(Var_PagaISR, SI_PagaISR);

	IF (Var_PagaISR = NO_PagaISR) THEN
		SET Var_TasaISR = 0.00;
	END IF;

	-- Creacion del Calendario de Amortizaciones del Inversionista
	DELETE FROM CRWTMPPAGAMORSIM
		WHERE NumTransaccion    = Aud_NumTransaccion;

	-- Si la Creacion del Credito Pasivo es el Fondeo de un Credito que recien Comienza (No Maduro)
	IF(Par_TipoFondeo = Tip_FonSolici) THEN

		CALL CRWINVCALENPAGOPRO(
			Par_CreditoID,      Par_MontoFondeo,    Par_TasaFija,   Par_FechaOper,  Var_PagaISR,
			Salida_NO,          Int_NumErr,         Par_ErrMen,     Aud_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );

			IF(Int_NumErr != Entero_Cero)THEN
				SET  Par_NumErr := Int_NumErr;
				LEAVE ManejoErrores;
			END IF;

	ELSE    -- Es fondeo es de un Credito Maduro
		CALL CRWINVCALENPAGOPRO(
			Par_CreditoID,      Par_MontoFondeo,    Par_TasaFija,   Par_FechaOper,  Var_PagaISR,
			Salida_NO,          Int_NumErr,         Par_ErrMen,     Aud_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );

			IF(Int_NumErr != Entero_Cero)THEN
				SET  Par_NumErr := Int_NumErr;
				LEAVE ManejoErrores;
			END IF;


	END IF;

	-- Alta de las Amortizaciones
		INSERT AMORTICRWFONDEO(
		SolFondeoID,      	AmortizacionID,     FechaInicio,        FechaVencimiento,   FechaExigible,
		Capital,            InteresGenerado,    InteresRetener,     PorcentajeInteres,  PorcentajeCapital,
		Estatus,            SaldoCapVigente,    SaldoCapExigible,   SaldoInteres,       ProvisionAcum,
		RetencionIntAcum,   MoratorioPagado,    ComFalPagPagada,    IntOrdRetenido,     IntMorRetenido,
		ComFalPagRetenido,  FechaLiquida,       SaldoIntMoratorio,	SaldoCapCtaOrden,	SaldoIntCtaOrden,
		EmpresaID,          Usuario,            FechaActual,	    DireccionIP,        ProgramaID,
		Sucursal,           NumTransaccion  )

		SELECT	FondeoCRW, Tmp.Tmp_Consecutivo,
				Tmp_FecIni, Tmp.Tmp_FecFin, Tmp.Tmp_FecVig,     -- Fecha de Inicio, Vencimiento y Exigibilidad
				ROUND(Tmp.Tmp_Capital, 2),                  -- Monto de Capital de la Amortizacion
				ROUND(Tmp.Tmp_Interes, 2),                  -- Monto de Interes de la Amortizacion
				ROUND(Tmp.Tmp_ISR, 2),             			-- Monto de Interes de la Amortizacion
				ROUND(Tmp.Tmp_Interes/Amo.Interes,6),    	-- Porcentaje de Interes vs Parte Activa del Credito
				ROUND(Tmp.Tmp_Capital/						-- Porcentaje de Capital vs Parte Activa del Credito
					( IFNULL(Amo.SaldoCapAtrasa, 0) +
						IFNULL(Amo.SaldoCapVigente, 0) +
						IFNULL(Amo.SaldoCapVencido, 0) +
						IFNULL(Amo.SaldoCapVenNExi, 0) ) ,6),
				EstatusVigen,                        -- Estatus de la Amortizacion: Vigente
				ROUND(Tmp.Tmp_Capital, 2),               -- Saldo de Capital Vigente
				Entero_Cero,    Entero_Cero,         -- Saldo de Capital Exigible, Saldo Interes
				Entero_Cero,    Entero_Cero,         -- Provision Acumulada, Retencion INT. Acumulada


				Entero_Cero,    Entero_Cero,         -- Moratorio Pagado, Comisiones Pagadas
				Entero_Cero,    Entero_Cero,         -- INT.Ordinadrio Retenido, Moratorio Retenido
				Entero_Cero,    Fecha_Vacia,         -- Comision Retenida, Fecha de Liquidacion

				Entero_Cero,						-- Saldo INT moratorio
				Entero_Cero,    					-- Saldo de capital en cuentas de orden
				Entero_Cero,    					-- Interes en cuentas de orden

				Aud_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion

			FROM	CRWTMPPAGAMORSIM Tmp,
				AMORTICREDITO Amo
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Amo.CreditoID = Par_CreditoID
			AND Amo.FechaVencim = Tmp.Tmp_FecFin;


	-- Respaldo de las Amortizaciones Originales
	INSERT INTO CRWPAGAREFONDEO
		SELECT  Tmp.Tmp_Consecutivo, FondeoCRW,
				Tmp.Tmp_FecIni, Tmp.Tmp_FecFin, Tmp.Tmp_FecVig,     -- Fecha de Inicio, Vencimiento y Exigibilidad
				ROUND(Tmp.Tmp_Capital, 2),                  -- Monto de Capital de la Amortizacion
				ROUND(Tmp.Tmp_Interes, 2),                  -- Monto de Interes de la Amortizacion
				ROUND(Tmp.Tmp_ISR, 2),                  -- Monto de Interes de la Amortizacion
				Aud_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion

			FROM	 CRWTMPPAGAMORSIM Tmp,
				AMORTICREDITO Amo
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Amo.CreditoID = Par_CreditoID
			AND Amo.FechaVencim = Tmp.Tmp_FecFin;
	-- contamos el numero de cuotas calculadas para el inversionista y las actualizamos
		SELECT IFNULL(COUNT(Tmp_Consecutivo),Entero_Cero) INTO TotalCuotas
				FROM CRWTMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion;


	-- Alta de los Movimientos de Inv. Crowdfounding
	INSERT CRWFONDEOMOVS(
		SolFondeoID, 	AmortizacionID, Transaccion,    FechaOperacion, FechaAplicacion,
		TipoMovCRWID,  	NatMovimiento,  MonedaID,       Cantidad,       Descripcion,
		Referencia,     EmpresaID,      Usuario,        FechaActual,    DireccionIP,
		ProgramaID,     Sucursal,       NumTransaccion  )

		SELECT  FondeoCRW,         Tmp_Consecutivo,    Aud_NumTransaccion,     	Par_FechaOper,
				Par_FechaOper,      Mov_Capital,        Nat_Cargo,              Par_MonedaID,
				Tmp_Capital,        Des_AltaInv,        Par_Referencia,         Aud_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion
		FROM CRWTMPPAGAMORSIM Tmp
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion;



	-- ------------------------- Calculo de GAT ------------------------------------------------------------------
	CALL CRWCALCULACATINVPRO(
		FondeoCRW,			Salida_NO,			Var_GAT, 			Int_NumErr, 		Par_ErrMen,
		Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,       Aud_NumTransaccion);

	IF(Int_NumErr != Entero_Cero)THEN
		SET  Par_NumErr := Int_NumErr;
		LEAVE ManejoErrores;
	END IF;

	-- ----------------------- Calculo del GAT REAL ---------------------------------------------------------------
	SET Var_Inflacion 	:=(SELECT InflacionProy
							FROM INFLACIONACTUAL
							ORDER BY FechaActualizacion DESC LIMIT 1);

	SET Var_GATReal := FUNCIONCALCGATREAL(Var_GAT,Var_Inflacion);


	-- Actualizamos la Fecha de Vencimiento de la Inversion
	SELECT MAX(FechaVencimiento)
	INTO Var_MaxFecVen
	FROM AMORTICRWFONDEO
	WHERE SolFondeoID = FondeoCRW;

	-- TODO: Eliminarlo
	SET Var_MaxFecVen 	:= IFNULL(Var_MaxFecVen, Fecha_Vacia);

	-- -------------------------Actualizamos el fondeo -------------------------------------------
	UPDATE CRWFONDEO SET
		NumCuotas			= TotalCuotas,
		Gat					= Var_GAT,
		ValorGatReal		= Var_GATReal,
		FechaVencimiento 	= Var_MaxFecVen
		WHERE CreditoID 	= Par_CreditoID
		AND NumTransaccion 	= Aud_NumTransaccion
	AND SolFondeoID = FondeoCRW;

	-- -------------------------- Actualizamos la Solicitud de Fondeo ---------------------
	UPDATE CRWFONDEOSOLICITUD SET
		Gat				= Var_GAT,
		ValorGatReal	= Var_GATReal
		WHERE SolFondeoID 	= Par_SolFondeoID;

	-- Kubo.Modificado
	INSERT INTO CRWDIAALTAFONDEO(
			SolFondeoID,		CuentaAhoID, 		ClienteID,			CreditoID,			SolicitudCredito,
			ClienteCre,			MontoCredito,		MontoFondeo,		PorcentajeFondeo,	FechaInicio,
			FechaVencimiento,	TasaFija,			PeriodicidadCap,	NumAmortizacion,	FrecuenciaInt,
			EstatusCre,			FechaVencimCre,		NoCuotasAtraso,		NumCuotas,			DiasAtraso,
			DiaAtrasoID,		FechaActual,		ComisionApertura,	IVAComisionAper)

	SELECT 	FK.SolFondeoID,		FK.CuentaAhoID,		FK.ClienteID,		CR.CreditoID,	   	 CR.SolicitudCreditoID,
			CR.ClienteID,		CR.MontoCredito,	FK.MontoFondeo,		FK.PorcentajeFondeo, FK.FechaInicio,
			FK.FechaVencimiento,FK.TasaFija,		CR.PeriodicidadCap,	CR.NumAmortizacion,	 CR.FrecuenciaInt,
			CR.Estatus,			CR.FechaVencimien,	Entero_Cero,		FK.NumCuotas,		 Entero_Cero,
			Entero_Cero,		NOW(),				CR.MontoComApert, 	CR.IVAComApertura
	FROM 		CRWFONDEO FK
	INNER JOIN 	CREDITOS CR ON FK.CreditoID = CR.CreditoID
	WHERE 		FK.SolFondeoID	= FondeoCRW;

	SET	Par_NumErr := 000;
	SET	Par_ErrMen := CONCAT('El Fondeo CRW ha sido Agregado.', FondeoCRW);
	SET	Par_Consecutivo := FondeoCRW;

END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			IFNULL(Par_Consecutivo, Entero_Cero) AS FondeoCRWID;
	END IF;
END TerminaStore$$
