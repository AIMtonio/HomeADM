-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOFALPAGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWPAGOFALPAGPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWPAGOFALPAGPRO`(
	Par_CreditoID			BIGINT(12),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,

	Par_Monto				DECIMAL(12,2),
	Par_MonedaID			INT(11),
	Par_SucCliente			INT(11),
	Par_Poliza				BIGINT,
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
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN


-- Declaracion de Variables
DECLARE	Var_Contador		BIGINT;
DECLARE	Var_SolFondeoID		BIGINT;
DECLARE	Var_ClienteID		BIGINT;
DECLARE	Var_CuentaAhoID		BIGINT;
DECLARE	Var_AmortizaID		BIGINT;
DECLARE	Var_PorcComisi		DECIMAL(10,4);
DECLARE	Var_NumRetMes		INT;
DECLARE	Var_SucCliente		INT;
DECLARE	Var_PagaISR			CHAR(1);
DECLARE	Var_PorcFondeo		DECIMAL(10,4);
DECLARE	Var_Control			VARCHAR(30);
DECLARE	Var_MonAplicar		DECIMAL(12,2);
DECLARE	Var_MonRetener		DECIMAL(12,2);
DECLARE	Var_FondeoIdStr		VARCHAR(30);
DECLARE Var_NumFondeos		INT;
DECLARE Var_ProdCredID		INT;
DECLARE Por_Retencion   	DECIMAL(8,4);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	  	CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12, 2);
DECLARE	Decimal_Cien		DECIMAL(12, 2);
DECLARE	Des_PagoComision	VARCHAR(50);
DECLARE	Des_RetenComision	VARCHAR(50);

DECLARE	AltaPoliza_NO		CHAR(1);
DECLARE	AltaPolKubo_SI		CHAR(1);
DECLARE	AltaMovKubo_SI		CHAR(1);
DECLARE	AltaMovAho_SI		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Si_PagaISR			CHAR(1);
DECLARE	Str_SI				CHAR(1);
DECLARE	Str_NO				CHAR(1);

DECLARE	Mov_Comision 		INT;
DECLARE	Mov_RetComision 	INT;
DECLARE	Con_RetComision 	INT;
DECLARE	Con_EgreComision 	INT;
DECLARE	Aho_PagComisi		VARCHAR(4);
DECLARE	Aho_RetComisi		VARCHAR(4);
DECLARE MontoMinPago		DECIMAL(6,4);
DECLARE SumaComision		DECIMAL(14,6);
DECLARE SumaISR				DECIMAL(14,6);
DECLARE EstPendiente		CHAR(1);
DECLARE	Proc_TipoPago		INT;

-- Asignacion de Constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Decimal_Cien    := 100.00;

SET AltaPoliza_NO   := 'N';
SET AltaPolKubo_SI  := 'S';
SET AltaMovKubo_SI  := 'S';
SET AltaMovAho_SI   := 'S';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Si_PagaISR      := 'S';
SET Str_SI			:= 'S';
SET Str_NO			:= 'N';
SET Mov_Comision    := 40;
SET Mov_RetComision := 52;
SET Con_RetComision := 7;
SET Con_EgreComision    := 10;
SET Aho_PagComisi   := '75';
SET Aho_RetComisi   := '78';
SET Des_PagoComision    := 'PAGO DE INVERSION. COM.FALTA PAGO';
SET Des_RetenComision   := 'PAGO DE INVERSION. ISR COMISION';
SET MontoMinPago		:=0.01;
SET SumaComision			:=0.0;
SET SumaISR				:=0.0;
SET EstPendiente		:='P';
SET Proc_TipoPago       := 2;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWPAGOFALPAGPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPPAGOSCREDCRW
		WHERE TipoProcesoPago = Proc_TipoPago
			AND NumTransaccion	= Aud_NumTransaccion;

	SET @Consecutivo := Entero_Cero;
	INSERT INTO TMPPAGOSCREDCRW(
		TmpID,
		SolFondeoID,			ClienteID,			CuentaAhoID,			AmortizacionID,
		PorcentajeComisi,		NumRetirosMes,		SucursalOrigen,			PagaISR,
		PorcentajeFondeo,		NumTransaccion,		TipoProcesoPago)
	SELECT
		(@Consecutivo:= @Consecutivo+1),
		Fon.SolFondeoID,		Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
		Fon.PorcentajeComisi,	Fon.NumRetirosMes,	Cli.SucursalOrigen,		Cli.PagaISR,
		Fon.PorcentajeFondeo,	Aud_NumTransaccion,	Proc_TipoPago
	FROM CRWFONDEO Fon,
		 AMORTICRWFONDEO Amo,
		 CLIENTES Cli,
		 CRWTIPOSFONDEADOR Tip
	WHERE Fon.SolFondeoID	= Amo.SolFondeoID
		AND Amo.FechaVencimiento	= Par_FechaVencim
		AND Fon.ClienteID		= Cli.ClienteID
		AND Fon.CreditoID		= Par_CreditoID
		AND Fon.TipoFondeo		= Tip.TipoFondeadorID
		AND Fon.TipoFondeo		= 1
		AND Tip.PagoEnIncumple	= 'N'
		AND Fon.Estatus			= 'N'
		AND Amo.Estatus			= 'N';

	SET Var_ProdCredID := (SELECT ProductoCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	SET Por_Retencion := (SELECT PorcISRComision FROM PARAMETROSCRW WHERE ProductoCreditoID = Var_ProdCredID);
	SET Por_Retencion := IFNULL(Por_Retencion, Decimal_Cero);

	SET Var_NumFondeos :=   (SELECT COUNT(SolFondeoID)
								FROM TMPPAGOSCREDCRW
								WHERE TipoProcesoPago = Proc_TipoPago
									AND NumTransaccion	= Aud_NumTransaccion);


	SET Var_Contador := 1;

	WHILE(Var_Contador <= Var_NumFondeos)DO
		SELECT
			SolFondeoID,		ClienteID,			CuentaAhoID,	AmortizacionID,		PorcentajeComisi,
			NumRetirosMes,		SucursalOrigen,		PagaISR,		PorcentajeFondeo
		INTO
			Var_SolFondeoID,	Var_ClienteID,		Var_CuentaAhoID,Var_AmortizaID,		Var_PorcComisi,
			Var_NumRetMes,		Var_SucCliente,		Var_PagaISR,	Var_PorcFondeo
		FROM TMPPAGOSCREDCRW
			WHERE TipoProcesoPago = Proc_TipoPago
				AND NumTransaccion = Aud_NumTransaccion
				AND TmpID = Var_Contador;

	    SET Var_MonAplicar  := Decimal_Cero;
	    SET Var_MonRetener  := Decimal_Cero;
		SET SumaComision	:= Decimal_Cero;
		SET SumaISR			:= Decimal_Cero;
	    SET Var_PorcComisi  := (Var_PorcComisi / Decimal_Cien);
	    SET Var_PorcFondeo  := (Var_PorcFondeo / Decimal_Cien);
	    SET Por_Retencion   := (Por_Retencion / Decimal_Cien);

		SET	Var_FondeoIdStr	:= CONVERT(Var_SolFondeoID, CHAR);

		SET	Var_MonAplicar	:= ROUND(Par_Monto * Var_PorcComisi * Var_PorcFondeo, 2);

		IF (Var_PagaISR = Si_PagaISR) THEN
			SET	Var_MonRetener	:= ROUND(Var_MonAplicar * Por_Retencion, 2);
		ELSE
			SET	Var_MonRetener	:= Decimal_Cero;
		END IF;


		IF (Var_MonAplicar >= MontoMinPago) THEN
			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonAplicar,		Par_MonedaID,		Var_NumRetMes,		Var_SucCliente,
				Des_PagoComision,		Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_EgreComision,	Mov_Comision,		Nat_Cargo,
				Nat_Abono,				AltaMovAho_SI,		Aho_PagComisi,		Nat_Abono,			Str_NO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (Var_MonRetener >= MontoMinPago) THEN

			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Par_FechaOperacion,
				Par_FechaAplicacion,	Var_MonRetener,		Par_MonedaID,		Var_NumRetMes,		Var_SucCliente,
				Des_RetenComision,		Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_RetComision,	Mov_RetComision,	Nat_Abono,
				Nat_Cargo,				AltaMovAho_SI,		Aho_RetComisi,		Nat_Cargo,			Str_NO,
				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
		IF(Var_MonAplicar < MontoMinPago AND Var_MonAplicar > Decimal_Cero)THEN
			SET SumaComision	:=Var_MonAplicar;
		END IF;

		IF(Var_MonRetener < MontoMinPago AND Var_MonRetener > Decimal_Cero)THEN
			SET SumaISR	:= Var_MonRetener;
		END IF;
		IF(SumaComision OR SumaISR >Decimal_Cero)THEN
			INSERT INTO CRWPAGOPENINV(
				SolFondeoID,	AmortizacionID,	Transaccion,	CuentaAhoID,	ClienteID,	Fecha,
				Monto,			TipoMovAhoID,	Naturaleza,		Estatus,	Retencion,
				PolizaID,		CreditoID,		EmpresaID, 		Usuario,	FechaActual,
				DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
			VALUES (
				Var_SolFondeoID,	Var_AmortizaID,		Aud_NumTransaccion,	Var_CuentaAhoID,	Var_ClienteID,
				Par_FechaAplicacion,SumaComision,		Aho_PagComisi,		Nat_Abono,			EstPendiente,
				SumaISR,			Par_Poliza,			Par_CreditoID,		Par_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	SET	Par_NumErr 	:= Entero_Cero;
	SET	Par_ErrMen 	:= 'Proceso Terminado Exitosamente.';
	SET Var_Control := 'creditoID';

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$