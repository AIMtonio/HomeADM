-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOINTMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWPAGOINTMORPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWPAGOINTMORPRO`(
/* Pago de intereses Moratorios al inversionista se ejecuta en PAGCREMORAPRO*/
	Par_CreditoID			BIGINT,
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,

	Par_Monto				DECIMAL(12,2),
	Par_MonedaID			INT(11),
	Par_SucCliente			INT(11),
	Par_SaldoMora			DECIMAL(14,4),
	Par_Poliza				BIGINT,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
-- Declaracion de Variables
DECLARE	Var_SolFondeoID		BIGINT;
DECLARE	Var_ClienteID		BIGINT;
DECLARE	Var_CuentaAhoID		BIGINT;
DECLARE	Var_AmortizaID		BIGINT;
DECLARE	Var_NumRetMes		INT;
DECLARE	Var_SucCliente		INT;
DECLARE	Var_ProdctoCreID	INT;
DECLARE	Var_PagaISR			CHAR(1);
DECLARE	Var_MonAplicar		DECIMAL(14,8);
DECLARE	Var_MonRetener		DECIMAL(14,2);

DECLARE	Var_FondeoIdStr		VARCHAR(30);
DECLARE	Por_Retencion   	DECIMAL(8,4);
DECLARE Decimal_Moneda  	DECIMAL(12,2);
DECLARE	Var_FondeoCon   	INT;
DECLARE	Var_Contador    	INT;
DECLARE Var_SaldoIntMora	DECIMAL(14,4);
DECLARE	Var_Control			VARCHAR(30);

-- Declaracion de constantes
DECLARE	Cadena_Vacia	  	CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12, 2);
DECLARE	Decimal_Cien		DECIMAL(12, 2);
DECLARE	Des_PagoMor			VARCHAR(50);
DECLARE	Des_RetenMor		VARCHAR(50);

DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPolKubo_SI		CHAR(1);
DECLARE	AltaMovKubo_SI		CHAR(1);
DECLARE	AltaMovAho_SI		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Si_PagaISR			CHAR(1);

DECLARE	Mov_IntMor 			INT;
DECLARE	Mov_RetMor 			INT;
DECLARE	Con_RetMor 			INT;
DECLARE	Con_EgreMora 		INT;
DECLARE	Aho_PagMorato		VARCHAR(4);
DECLARE	Aho_RetMorato		VARCHAR(4);
DECLARE TipoFonInvKubo		INT;
DECLARE PagoIncumpleNO		CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE CtaOrdenMora		INT(11);
DECLARE CorrCtaOrdenMora	INT(11);
DECLARE MovAhorroNO			CHAR(1);
DECLARE MovKuboNO			CHAR(1);
DECLARE DescConKubo			VARCHAR(100);
DECLARE Estatus_Pagada  	CHAR(1);
DECLARE Tol_DifPago     	DECIMAL(6, 4);
DECLARE Estatus_Vigente 	CHAR(1);
DECLARE MontoMinPago		DECIMAL(6,4);
DECLARE SumaInteres			DECIMAL(14,6);
DECLARE SumaISR				DECIMAL(14,6);
DECLARE EstPendiente		CHAR(1);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE	Proc_TipoPago		INT;

SET Cadena_Vacia    	:= '';							-- Cadena Vacia
SET Fecha_Vacia     	:= '1900-01-01';				-- Fecha Vacia
SET Entero_Cero     	:= 0;							-- Entero Cero
SET Decimal_Cero    	:= 0.00;						-- DECIMAL Cero
SET Decimal_Cien    	:= 100.00;						-- DECIMAL Cien
SET AltaPoliza_NO   	:= 'N';							-- Alta en el encabezado de la Poliza NO
SET AltaPolKubo_SI  	:= 'S';							-- Alta en Poliza Kubo NO
SET AltaMovKubo_SI  	:= 'S';							-- alta en Movimiento de Kubo NO
SET AltaMovAho_SI		:= 'S';							-- alta en movimiento de Ahorro SI
SET Nat_Cargo       	:= 'C';							-- Naturaleza Cargo
SET Nat_Abono       	:= 'A';							-- Naturaleza Abono
SET Si_PagaISR      	:= 'S';							-- El cliente SI paga ISR
SET Mov_IntMor      	:= 15;							-- Movimiento de kubo Pago de interes moratorio corresponde con TIPOSMOVSCRW
SET Mov_RetMor      	:= 51;							-- Movimiento de kubo retencion de interes moratorio corresponde con TIPOSMOVSCRW
SET Con_RetMor      	:= 6;							-- concepto Contable de kubo Retencion de interes Moratorio corresponde con CONCEPTOSKUBO
SET Con_EgreMora    	:= 9;							-- concepto Contable de kubo Resultados. Egreso por Moratorios corresponde con CONCEPTOSKUBO
SET Aho_PagMorato   	:= '74';						-- Movimiento de Ahorro PAGO INV KUBO. MORATORIOS corresponde con TIPOSMOVSAHO
SET Aho_RetMorato   	:= '77';						-- Movimiento de Ahorro RETENCION ISR MORATORIOS INVERSION corresponde con TIPOSMOVSAHO
SET Des_PagoMor     	:= 'PAGO DE INVERSION. MORATORIOS';
SET Des_RetenMor    	:= 'PAGO DE INVERSION. ISR MORA.';
SET Decimal_Moneda		:=0.01;							--  DECIMAL Moneda
SET TipoFonInvKubo		:=1;							-- Tipo de fondeador Inversionista Kubo corresponde con  CRWTIPOSFONDEADOR
SET PagoIncumpleNO		:='N';							-- NO pago al inversionista si hay incumplimiento del acreditado  corresponde con  CRWTIPOSFONDEADOR
SET EstatusVigente		:='N';							-- Estatus Vigente
SET CtaOrdenMora		:=15;							-- Cta. Orden Intereses Moratorios CONCEPTOSKUBO
SET CorrCtaOrdenMora	:=16;							-- Corr. Cta. Orden Intereses Moratorios CONCEPTOSKUBO
SET MovAhorroNO			:='N';							-- Movimiento de ahorro NO
SET MovKuboNO			:='N';							-- Movimiento de inversionista kubo SI
SET DescConKubo			:='PAGO DE INTERES MORATORIO CO';
SET Estatus_Pagada  	:= 'P';             -- Estatus Pagado
SET Estatus_Vigente 	:= 'N';             -- Estatus Vigente
SET Tol_DifPago     	:= 0.01;
SET MontoMinPago		:=0.01;
SET SumaInteres			:=0.0;
SET SumaISR				:=0.0;
SET EstPendiente		:='P';
SET Str_SI				:='S';
SET Str_NO				:='N';
SET Proc_TipoPago       := 4;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWPAGOINTMORPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPPAGOSCREDCRW
		WHERE TipoProcesoPago = Proc_TipoPago
			AND NumTransaccion	= Aud_NumTransaccion;

	SET @Consecutivo := Entero_Cero;

	INSERT INTO TMPPAGOSCREDCRW(
		TmpID,
		SolFondeoID,		ClienteID,			CuentaAhoID,		AmortizacionID,
		NumRetirosMes,		SucursalOrigen,		PagaISR,			SaldoIntMoratorio,
		NumTransaccion,		TipoProcesoPago)
	SELECT
		(@Consecutivo:= @Consecutivo+1),
		Fon.SolFondeoID,	Fon.ClienteID,		Fon.CuentaAhoID,	Amo.AmortizacionID,
		Fon.NumRetirosMes,	Cli.SucursalOrigen,	Cli.PagaISR,		Amo.SaldoIntMoratorio,
		Aud_NumTransaccion,	Proc_TipoPago
	FROM CRWFONDEO Fon,
		AMORTICRWFONDEO Amo,
		CLIENTES Cli,
		CRWTIPOSFONDEADOR Tip
	WHERE Fon.SolFondeoID	= Amo.SolFondeoID
		AND Amo.FechaVencimiento	= Par_FechaVencim
		AND Fon.ClienteID		= Cli.ClienteID
		AND Fon.CreditoID		= Par_CreditoID
		AND Fon.TipoFondeo		= Tip.TipoFondeadorID
		AND Fon.TipoFondeo		= TipoFonInvKubo
		AND Tip.PagoEnIncumple	= PagoIncumpleNO
		AND Fon.Estatus			= EstatusVigente
		AND Amo.Estatus			= EstatusVigente;


	SET Var_FondeoCon		:= ( SELECT	COUNT(SolFondeoID)
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);

	SET Var_ProdctoCreID := (SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	SET Por_Retencion := (SELECT PorcISRMoratorio FROM PARAMETROSCRW WHERE ProductoCreditoID = Var_ProdctoCreID);
	SET Por_Retencion := IFNULL(Por_Retencion, Decimal_Cero) / Decimal_Cien;

	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_FondeoCon)DO
		SELECT
			SolFondeoID,		ClienteID,			CuentaAhoID,		AmortizacionID,
			NumRetirosMes,		SucursalOrigen,		PagaISR,			SaldoIntMoratorio
		INTO
			Var_SolFondeoID,	Var_ClienteID,		Var_CuentaAhoID,	Var_AmortizaID,
			Var_NumRetMes,		Var_SucCliente,		Var_PagaISR,		Var_SaldoIntMora
		FROM TMPPAGOSCREDCRW
			WHERE TipoProcesoPago = Proc_TipoPago
				AND NumTransaccion = Aud_NumTransaccion
				AND TmpID = Var_Contador;

		SET Var_MonAplicar	:= Decimal_Cero;
		SET Var_MonRetener	:= Decimal_Cero;
		SET Var_SaldoIntMora:=IFNULL(Var_SaldoIntMora,Decimal_Cero );
		SET	Var_FondeoIdStr	:= CONVERT(Var_SolFondeoID, CHAR);

		SET	Var_MonAplicar	:= ROUND(Var_SaldoIntMora / Par_SaldoMora * Par_Monto, 2);
		SET SumaInteres		:=Decimal_Cero;
		SET SumaISR			:=Decimal_Cero;

		IF (Var_PagaISR = Si_PagaISR) THEN
			SET	Var_MonRetener	:= ROUND(Var_MonAplicar * Por_Retencion, 2);
		ELSE
			SET	Var_MonRetener	:= Decimal_Cero;
		END IF;


		IF(Var_MonAplicar > Var_SaldoIntMora)THEN
			SET Var_MonAplicar	:= Var_SaldoIntMora;
		END IF;

		IF (Var_MonAplicar >= MontoMinPago) THEN
			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonAplicar,		Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
				Des_PagoMor,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,	Par_Poliza,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_EgreMora,		Mov_IntMor,		Nat_Cargo,
				Nat_Abono,				AltaMovAho_SI,		Aho_PagMorato,		Nat_Abono,		Str_NO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			--  Cancelamos cuentas de orden de moratorios de los inversionistas
			CALL CRWCONTAINVPRO (
				Var_SolFondeoID, 		Var_AmortizaID,			Var_CuentaAhoID, 	Var_ClienteID, 		Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonAplicar,			Par_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				DescConKubo,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Par_Poliza,
				AltaPolKubo_SI,			MovKuboNO,				CtaOrdenMora,		Entero_Cero,		Nat_Abono,
				Nat_Abono, 				MovAhorroNO,			Entero_Cero,		Cadena_Vacia,     	Str_NO,
				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CRWCONTAINVPRO (
				Var_SolFondeoID, 		Var_AmortizaID,			Var_CuentaAhoID, 	Var_ClienteID, 		Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonAplicar,			Par_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				DescConKubo,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Par_Poliza,
				AltaPolKubo_SI,			MovKuboNO,				CorrCtaOrdenMora,	Entero_Cero,		Nat_Cargo,
				Nat_Cargo, 				MovAhorroNO,			Entero_Cero,		Cadena_Vacia,     	Str_NO,
				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPAMORTIFONCRECRW Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
							  AND Tem.AmortizacionID = Var_AmortizaID
							  AND Tem.SolFondeoID = Var_SolFondeoID) THEN

				INSERT INTO TMPAMORTIFONCRECRW (Transaccion,AmortizacionID,SolFondeoID) VALUES(Aud_NumTransaccion, Var_AmortizaID, Var_SolFondeoID );
			END IF;

			IF NOT EXISTS(SELECT Tem.Transaccion
							FROM TMPCRWPREPAGOAMOR Tem
							WHERE Tem.Transaccion = Aud_NumTransaccion
								AND Tem.SolFondeoID = Var_SolFondeoID) THEN

				INSERT INTO `TMPCRWPREPAGOAMOR` (
                    `Transaccion`,                  `SolFondeoID`)
                    VALUES  (Aud_NumTransaccion, Var_SolFondeoID );
			END IF;
		END IF;

		-- Retencion ISR de Moratorios
		IF (Var_MonRetener >= MontoMinPago) THEN
			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonRetener,		Par_MonedaID,		Var_NumRetMes,		Var_SucCliente,
				Des_RetenMor,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_RetMor,			Mov_RetMor,			Nat_Abono,
				Nat_Cargo,				AltaMovAho_SI,		Aho_RetMorato,		Nat_Cargo,			Str_NO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_MonAplicar < MontoMinPago AND Var_MonAplicar > Decimal_Cero)THEN
			SET SumaInteres	:=Var_MonAplicar;
		END IF;

		IF(Var_MonRetener < MontoMinPago AND Var_MonRetener > Decimal_Cero)THEN
			SET SumaISR	:= Var_MonRetener;
		END IF;

		IF(SumaInteres OR SumaISR >Decimal_Cero)THEN
			INSERT INTO CRWPAGOPENINV(
				SolFondeoID,	AmortizacionID,	Transaccion,	CuentaAhoID,	ClienteID,	Fecha,
				Monto,			TipoMovAhoID,	Naturaleza,		Estatus,	Retencion,
				PolizaID,		CreditoID,		EmpresaID, 		Usuario,	FechaActual,
				DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
			VALUES (
				Var_SolFondeoID,	Var_AmortizaID,		Aud_NumTransaccion,	Var_CuentaAhoID,	Var_ClienteID,
				Par_FechaAplicacion,SumaInteres,		Aho_PagMorato,		Nat_Abono,			EstPendiente,
				SumaISR,			Par_Poliza,			Par_CreditoID,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	-- Actualizamos la Amortizacion Como Pagada Si Paga Todo el Saldo de Capital e Interes
	UPDATE AMORTICRWFONDEO Amo, TMPAMORTIFONCRECRW Tem SET
		Estatus			= Estatus_Pagada,
		FechaLiquida	= Par_FechaOperacion,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
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

	DELETE FROM TMPCRWPREPAGOAMOR
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
