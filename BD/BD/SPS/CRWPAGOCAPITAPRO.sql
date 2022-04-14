-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOCAPITAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWPAGOCAPITAPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWPAGOCAPITAPRO`(
	Par_CreditoID			BIGINT(12),
	Par_FechaInicio			DATE,				-- Inicio de la Amortizacion que se esta Pagando
	Par_FechaVencim			DATE,				-- Vencimiento de la Amortizacion que se esta Pagando
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,

	Par_Monto				DECIMAL(12,2),
	Par_MonedaID			INT(11),
	Par_SucCliente			INT(11),
	Par_Poliza				BIGINT,
	Par_MontoCap        	DECIMAL(14,4),

	Par_MontoCapCO			DECIMAL(14,4),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE	Var_Contador		BIGINT;
DECLARE	Var_SolFondeoID		BIGINT;
DECLARE	Var_ClienteID		BIGINT;
DECLARE	Var_CuentaAhoID		BIGINT;
DECLARE	Var_AmortizaID		BIGINT;
DECLARE	Var_PorcCapital		DECIMAL(9,6);
DECLARE	Var_NumRetMes		INT;
DECLARE	Var_SaldoCapVig		DECIMAL(12,2);
DECLARE	Var_SaldoCapExi		DECIMAL(12,2);
DECLARE	Var_SucCliente		INT;

DECLARE	Var_MonAplicar		DECIMAL(12,6);
DECLARE	Var_FondeoIdStr		VARCHAR(30);
DECLARE Var_CapCtaOrden		DECIMAL(14,4);
DECLARE Nat_OpeKubo			CHAR(1);
DECLARE Nat_ContaKubo		CHAR(1);
DECLARE	Mov_Capita			INT;
DECLARE	Con_Capita			INT;
DECLARE	Var_Control			VARCHAR(30);

/* Declaracion de Constantes. */
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE Decimal_Cien    	DECIMAL(12, 2);
DECLARE Tol_DifPago     	DECIMAL(6, 4);
DECLARE Estatus_Pagada  	CHAR(1);
DECLARE Estatus_Vigente 	CHAR(1);
DECLARE Des_PagoCap     	VARCHAR(50);

DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE AltaPolKubo_SI  	CHAR(1);
DECLARE AltaMovKubo_SI  	CHAR(1);
DECLARE AltaMovKubo_NO  	CHAR(1);

DECLARE AltaMovAho_SI   	CHAR(1);
DECLARE AltaMovAho_NO		CHAR(1);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);
DECLARE	Proc_TipoPago		INT;

DECLARE	Con_CapOrdinario	INT;
DECLARE	Con_CapExigible		INT;
DECLARE	Mov_CapOrdinario 	INT;
DECLARE	Mov_CapExigible 	INT;
DECLARE	Aho_Capital			VARCHAR(4);
DECLARE CtaOrdenCap			INT(11);									-- cuenta de Orden corresponde con CONCEPTOSKUBO
DECLARE CorrCtaOrdenCap		INT(11);
DECLARE TipoMovCapCtaOr		INT(4);
DECLARE TipoMovAhoCap		CHAR(4);
DECLARE EstPendiente		CHAR(1);
DECLARE MontoMinPago		DECIMAL(6,4);
DECLARE Var_NumFondeos      INT;            -- @vjimenez : Para ajuste por perdida de precisión en redondeos
DECLARE Var_MontoAplicado   DECIMAL(12,4);  --
DECLARE Var_FondeoAct       INT;            --
DECLARE Var_Factor          DECIMAL(12,6);  --
DECLARE Var_SalCapFondeos   DECIMAL(12,4);  --
DECLARE Var_SaldoCapCre     DECIMAL(12,4);  --
DECLARE Var_SaldoCapAmo     DECIMAL(12,4);  --
DECLARE Var_TotCubrir       DECIMAL(12,4);  --

/* Asignacion de Constantes */
SET Cadena_Vacia    := '';
SET Str_SI			:= 'S';
SET Str_NO			:= 'N';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Decimal_Cien    := 100.00;
SET Tol_DifPago     := 0.01;
SET Estatus_Pagada  := 'P';             -- Estatus Pagado
SET Estatus_Vigente := 'N';             -- Estatus Vigente

SET AltaPoliza_NO   := 'N';					-- Alta del Maestro Contable: NO
SET AltaPolKubo_SI  := 'S';					-- Alta del Detalle de la Poliza Contable: NO
SET AltaMovKubo_SI  := 'S';					-- Alta del Movimiento Operativo de Inv.Kubo: SI
SET AltaMovKubo_NO  := 'N';					-- Alta del Movimiento Operativo de Inv.Kubo: NO
SET AltaMovAho_SI   := 'S';					-- Alta del Movimiento Operativo en Cuenta de Ahorro: SI
SET AltaMovAho_NO	:='N';					-- Alta del Movimiento Operativo en Cuenta de Ahorro: NO
SET Nat_Cargo       := 'C';					-- Naturaleza de Cargo
SET Nat_Abono       := 'A';					-- Naturaleza de Abono
										-- Tipo de Mov Operativo de Inv.Kubo (TIPOSMOVSCRW)
SET Mov_CapOrdinario 	:= 1;					-- Capital Vigente u Ordinario
SET Mov_CapExigible 	:= 2;					-- Capital Exigible o en Atraso
										-- Tipo de Mov Contables de Inv.Kubo (CONCEPTOSKUBO)
SET Con_CapOrdinario	:= 1;					-- Capital Vigente u Ordinario
SET Con_CapExigible		:= 2;					-- Capital Exigible o en Atraso

SET Aho_Capital     	:= '71';			    -- Tipo de Movimiento en Cta de Ahorro: Capital (TIPOSMOVSAHO)

SET Des_PagoCap			:= 'PAGO DE INVERSION. CAPITAL';
SET EstPendiente		:='P';
SET MontoMinPago		:=0.01;
SET CtaOrdenCap			:= 11;						-- cuenta de Orden corresponde con CONCEPTOSKUBO
SET CorrCtaOrdenCap		:=12;						-- correlativa cuenta de Orden corresponde con CONCEPTOSKUBO
SET TipoMovCapCtaOr		:=3;						-- Tipo de movimiento de kubo Capital en cuenta de Orden corresponde con TIPOSMOVSCRW
SET TipoMovAhoCap		:='86';       				-- tipo de Movimiento de ahorro Aplicacion de Capital en Garantia TIPOSMOVSAHO

SET Var_FondeoAct       :=1;
SET Var_MontoAplicado   :=0.0;
SET Var_TotCubrir       :=0.0;
SET Proc_TipoPago       := 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWPAGOCAPITAPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPAMORTIFONCRECRW
		WHERE Transaccion = Aud_NumTransaccion;

	DELETE FROM TMPPAGOSCREDCRW
		WHERE TipoProcesoPago = Proc_TipoPago
			AND NumTransaccion	= Aud_NumTransaccion;

	SET @Consecutivo := Entero_Cero;
	INSERT INTO TMPPAGOSCREDCRW(
		TmpID,
		SolFondeoID,			ClienteID,			CuentaAhoID,			AmortizacionID,
		PorcentajeCapital,		NumRetirosMes,		SaldoCapVigente,		SaldoCapExigible,
		SaldoCapCtaOrden,		SucursalOrigen,		NumTransaccion,			TipoProcesoPago)
	SELECT
		(@Consecutivo:= @Consecutivo+1),
		Fon.SolFondeoID,		Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
		Amo.PorcentajeCapital,	Fon.NumRetirosMes,	Amo.SaldoCapVigente,	Amo.SaldoCapExigible,
		Amo.SaldoCapCtaOrden, 	Cli.SucursalOrigen,	Aud_NumTransaccion,		Proc_TipoPago
	FROM CRWFONDEO Fon,
		 AMORTICRWFONDEO Amo,
		 CLIENTES Cli,
		 CRWTIPOSFONDEADOR Tip
	WHERE Fon.SolFondeoID	= Amo.SolFondeoID
		AND Amo.FechaVencimiento	= Par_FechaVencim
		AND Fon.ClienteID		= Cli.ClienteID
		AND Fon.CreditoID		= Par_CreditoID
		AND Fon.TipoFondeo		= Tip.TipoFondeadorID
		AND Fon.TipoFondeo		= 1				-- Tipo de Inversionista: Kubo (Publico Inversionista)
		AND Tip.PagoEnIncumple	= 'N'			-- Pago en Incumplimiento .- NO
		AND Fon.Estatus			= 'N'			-- Estatus Inversion Kubo: Vigente
		AND Amo.Estatus			= 'N';			-- Estatus Amortizacion Inv.Kubo: Vigente



	SET Var_NumFondeos := (SELECT COUNT(SolFondeoID)
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);

	-- se manda a pagar capital en cuenta de Orden,
	IF(Par_MontoCapCO>Entero_Cero)THEN
		SET Var_SalCapFondeos:=(SELECT SUM(IFNULL(SaldoCapCtaOrden,0))
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);

	-- si se paga capital
	ELSE
		SET Var_SalCapFondeos:=(SELECT  SUM(IFNULL(SaldoCapVigente,0))+SUM(IFNULL(SaldoCapExigible,0))
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);
	END IF;

	IF(Par_Monto >= (Par_MontoCapCO + Par_MontoCap ))THEN
		SET Var_TotCubrir:=Var_SalCapFondeos;
	ELSE
	   SET Var_TotCubrir:=ROUND((Var_SalCapFondeos/(Par_MontoCapCO + Par_MontoCap ))* Par_Monto,2);
	END IF;

	SET Var_FondeoAct:=1;
	SET Var_MonAplicar	:= Decimal_Cero;
	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_NumFondeos)DO
		SELECT
			SolFondeoID,		ClienteID,			CuentaAhoID,		AmortizacionID,		PorcentajeCapital,
			NumRetirosMes,		SaldoCapVigente,	SaldoCapExigible,	SaldoCapCtaOrden,	SucursalOrigen
		INTO
			Var_SolFondeoID,	Var_ClienteID,		Var_CuentaAhoID,	Var_AmortizaID,		Var_PorcCapital,
			Var_NumRetMes,		Var_SaldoCapVig,	Var_SaldoCapExi,	Var_CapCtaOrden,	Var_SucCliente
		FROM TMPPAGOSCREDCRW
			WHERE TipoProcesoPago = Proc_TipoPago
				AND NumTransaccion = Aud_NumTransaccion
				AND TmpID = Var_Contador;

		-- Inicializaciones
		SET Var_FondeoIdStr	:= CONVERT(Var_SolFondeoID, CHAR);
		SET Var_CapCtaOrden	:= IFNULL(Var_CapCtaOrden, Decimal_Cero);
		-- SELECT Var_MontoAplicado;

		IF(Par_MontoCapCO>Entero_Cero)THEN
			SET Var_SaldoCapAmo := Var_CapCtaOrden;
			SET Var_SaldoCapCre := Par_MontoCapCO;
		ELSE
			SET Var_SaldoCapAmo := Var_SaldoCapVig + Var_SaldoCapExi;
			SET Var_SaldoCapCre := Par_MontoCap;
		END IF;

		SET Var_MonAplicar	:= ROUND((Par_Monto * (Var_SaldoCapAmo/ Var_SaldoCapCre)), 2);
		IF (Var_MonAplicar >= Var_SaldoCapAmo) THEN -- si el monto es mayor al Saldo.
			SET Var_MonAplicar	:= Var_SaldoCapAmo;
		END IF;

		IF(Var_MontoAplicado + Var_MonAplicar > Var_TotCubrir)THEN
			SET  Var_MonAplicar:=(Var_TotCubrir-Var_MontoAplicado);
		END IF;

		IF(Var_NumFondeos=Var_FondeoAct)THEN -- si es el ultimo fondeo.
			IF(Var_MontoAplicado+Var_MonAplicar<Var_TotCubrir )THEN
				IF(Var_TotCubrir-Var_MontoAplicado<= Var_SaldoCapAmo )THEN
					SET Var_MonAplicar:=Var_TotCubrir-Var_MontoAplicado ;
				ELSE
					SET Var_MonAplicar:=Var_SaldoCapAmo;
				END IF;
			END IF;
		END IF;

		IF (Var_MonAplicar >= MontoMinPago)THEN
			SET Var_MontoAplicado:=Var_MontoAplicado + Var_MonAplicar;
		END IF;

		SET Var_FondeoAct:=Var_FondeoAct+1;

		IF(Var_CapCtaOrden > Decimal_Cero)THEN
			SET	Mov_Capita		:= TipoMovCapCtaOr;
			SET	Con_Capita		:= CtaOrdenCap;
			SET Nat_OpeKubo		:=Nat_Abono;
			SET Nat_ContaKubo	:=Nat_Abono;

		ELSEIF(Var_SaldoCapExi > Decimal_Cero) THEN
			SET	Mov_Capita		:= Mov_CapExigible;
			SET	Con_Capita		:= Con_CapExigible;
			SET Nat_OpeKubo		:=Nat_Abono;
			SET Nat_ContaKubo	:=Nat_Cargo;

		ELSE
			SET	Mov_Capita		:= Mov_CapOrdinario;
			SET	Con_Capita		:= Con_CapOrdinario;
			SET Nat_OpeKubo		:=Nat_Abono;
			SET Nat_ContaKubo	:=Nat_Cargo;
		END IF;

		-- Alta de los Movimientos Operativos y Contables del Pago del Capital
		IF (Var_MonAplicar >= MontoMinPago) THEN
			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonAplicar,		Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
				Des_PagoCap,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,	Par_Poliza,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_Capita,			Mov_Capita,		Nat_ContaKubo,
				Nat_OpeKubo,			AltaMovAho_SI,		Aho_Capital,		Nat_Abono,		Str_NO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_Empresa,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_CapCtaOrden >= MontoMinPago)THEN
				CALL CRWCONTAINVPRO(
					Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
					Par_FechaAplicacion,	Var_MonAplicar,		Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
					Des_PagoCap,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,	Par_Poliza,
					AltaPolKubo_SI,			AltaMovKubo_NO,		CorrCtaOrdenCap,	Mov_Capita,		Nat_Cargo,
					Cadena_Vacia,			AltaMovAho_NO,		Entero_Cero,		Cadena_Vacia,	Str_NO,
					Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_Empresa,	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Registramos la Amortizacion que se Afecta en el Pago
			-- Para Posteriormente Verificar si la marcamos como Pagada
			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTIFONCRECRW Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizaID
							  AND Tem.SolFondeoID = Var_SolFondeoID) THEN

				INSERT INTO TMPAMORTIFONCRECRW (
					Transaccion,			AmortizacionID,		SolFondeoID)
				VALUES
					(Aud_NumTransaccion,	Var_AmortizaID,		Var_SolFondeoID );
			END IF;

			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPCRWPREPAGOAMOR Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
								AND Tem.SolFondeoID = Var_SolFondeoID) THEN

					INSERT INTO TMPCRWPREPAGOAMOR (
						Transaccion,			SolFondeoID)
					VALUES
						(Aud_NumTransaccion,	Var_SolFondeoID );
			END IF;
		END IF;

		IF(Var_MonAplicar > Decimal_Cero AND Var_MonAplicar < MontoMinPago)THEN
			INSERT INTO CRWPAGOPENINV(
				SolFondeoID,		AmortizacionID,		Transaccion,		CuentaAhoID,		ClienteID,
				Fecha,				Monto,				TipoMovAhoID,		Naturaleza,			Estatus,
				Retencion,			PolizaID,			CreditoID,			EmpresaID,	 		Usuario,
				FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
			VALUES (
				Var_SolFondeoID,	Var_AmortizaID,		Aud_NumTransaccion,	Var_CuentaAhoID,	Var_ClienteID,
				Par_FechaAplicacion,Var_MonAplicar,		Con_Capita,			Nat_Abono,			EstPendiente,
				Decimal_Cero,		Par_Poliza,			Par_CreditoID,		Par_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	-- Actualizamos la Amortizacion Como Pagada Si Paga Todo el Saldo de Capital e Interes
	UPDATE AMORTICRWFONDEO Amo, TMPAMORTIFONCRECRW Tem SET
		Estatus				= Estatus_Pagada,
		FechaLiquida		= Par_FechaOperacion,

		EmpresaID			= Par_Empresa,
		Usuario				= Aud_Usuario,
		FechaActual 		= Aud_FechaActual,
		DireccionIP 		= Aud_DireccionIP,
		ProgramaID  		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	WHERE Amo.SolFondeoID	= Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
		AND Amo.AmortizacionID = Tem.AmortizacionID
		AND Tem.Transaccion = Aud_NumTransaccion

	   AND (IFNULL(SaldoCapVigente, Entero_Cero) +
			IFNULL(SaldoCapExigible, Entero_Cero) +
			IFNULL(SaldoInteres, Entero_Cero)+
			IFNULL(SaldoCapCtaOrden,Entero_Cero)+
			IFNULL(SaldoIntCtaOrden,Entero_Cero )+
			IFNULL(SaldoIntMoratorio,Entero_Cero)	) <= Tol_DifPago;

	-- Marcamos el Fondeo como Pagado
	UPDATE CRWFONDEO Fon, TMPAMORTIFONCRECRW Tem SET
		Fon.Estatus = Estatus_Pagada
		WHERE Fon.SolFondeoID	= Tem.SolFondeoID          -- Amortizaciones que hayan Sido Afectada con el Pago
		  AND Tem.Transaccion = Aud_NumTransaccion
		  AND (SELECT COUNT(Amo.SolFondeoID)
				FROM AMORTICRWFONDEO Amo
				 WHERE Amo.SolFondeoID = Fon.SolFondeoID
				   AND Amo.SolFondeoID = Tem.SolFondeoID
				   AND Amo.Estatus = Estatus_Vigente ) <= 0;

	DELETE FROM TMPAMORTIFONCRECRW
		WHERE Transaccion = Aud_NumTransaccion;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Proceso Terminado Exitosamente.';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;


END TerminaStore$$