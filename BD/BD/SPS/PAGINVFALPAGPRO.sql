-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGINVFALPAGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGINVFALPAGPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGINVFALPAGPRO`(
	Par_CreditoID		BIGINT,
	Par_FechaInicio		DATE,
	Par_FechaVencim		DATE,

	Par_FechaOperacion	DATE,
	Par_FechaAplicacion	DATE,
	Par_Monto			DECIMAL(12,2),
	Par_MonedaID		INT,
	Par_SucCliente		INT,
	Par_Poliza			BIGINT,

INOUT	Par_NumErr		INT(11),
INOUT	Par_ErrMen		VARCHAR(400),
INOUT	Par_Consecutivo	BIGINT,

	Par_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN



DECLARE	Var_FondeoKuboID	BIGINT;
DECLARE	Var_ClienteID		BIGINT;
DECLARE	Var_CuentaAhoID		BIGINT(12);
DECLARE	Var_AmortizaID		BIGINT;
DECLARE	Var_PorcComisi		DECIMAL(10,4);
DECLARE	Var_NumRetMes		INT;
DECLARE	Var_SucCliente		INT;
DECLARE	Var_PagaISR			CHAR(1);
DECLARE	Var_PorcFondeo		DECIMAL(10,4);

DECLARE	Var_MonAplicar		DECIMAL(12,2);
DECLARE	Var_MonRetener		DECIMAL(12,2);
DECLARE	Var_FondeoIdStr		VARCHAR(30);



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

DECLARE	Mov_Comision 		INT;
DECLARE	Mov_RetComision 	INT;
DECLARE	Con_RetComision 	INT;
DECLARE	Con_EgreComision 	INT;
DECLARE	Aho_PagComisi		VARCHAR(4);
DECLARE	Aho_RetComisi		VARCHAR(4);
DECLARE	Por_Retencion		DECIMAL(8,4);


DECLARE CURSORINVER CURSOR FOR
	SELECT	Fon.FondeoKuboID,			Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
			Fon.PorcentajeComisi,		Fon.NumRetirosMes,	Cli.SucursalOrigen,	Cli.PagaISR,
			Fon.PorcentajeFondeo
		FROM FONDEOKUBO Fon,
			 AMORTIZAFONDEO Amo,
			 CLIENTES Cli,
			 TIPOSFONDEADORES Tip
		WHERE Fon.FondeoKuboID	= Amo.FondeoKuboID
		  AND Amo.FechaVencimiento	= Par_FechaVencim
		  AND Fon.ClienteID		= Cli.ClienteID
		  AND Fon.CreditoID		= Par_CreditoID
		  AND Fon.TipoFondeo		= Tip.TipoFondeadorID
		  AND Fon.TipoFondeo		= 1
		  AND Tip.PagoEnIncumple	= 'N'
		  AND Fon.Estatus			= 'N'
		  AND Amo.Estatus			= 'N';


SET	Cadena_Vacia	  	:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.00;
SET	Decimal_Cien		:= 100.00;

SET	AltaPoliza_NO		:= 'N';
SET	AltaPolKubo_SI		:= 'S';
SET	AltaMovKubo_SI		:= 'S';
SET	AltaMovAho_SI		:= 'S';
SET	Nat_Cargo			:= 'C';
SET	Nat_Abono			:= 'A';
SET	Si_PagaISR			:= 'S';

SET	Mov_Comision 		:= 40;
SET	Mov_RetComision		:= 52;

SET	Con_RetComision 	:= 7;
SET	Con_EgreComision	:= 10;

SET	Aho_PagComisi		:= '75';
SET	Aho_RetComisi		:= '78';

SET	Por_Retencion		:= 0.28;

SET	Des_PagoComision	:= 'PAGO DE CREDITO. COM.FALTA PAGO';
SET	Des_RetenComision	:= 'PAGO DE CREDITO. RETENCION COM.FALTA PAGO';


OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORINVER INTO
		Var_FondeoKuboID,	Var_ClienteID,	Var_CuentaAhoID,	Var_AmortizaID,	Var_PorcComisi,
		Var_NumRetMes,	Var_SucCliente,	Var_PagaISR,		Var_PorcFondeo;


	SET	Var_MonAplicar	:= Decimal_Cero;
	SET	Var_MonRetener	:= Decimal_Cero;
	SET	Var_PorcComisi	:= (Var_PorcComisi / Decimal_Cien);
	SET	Var_PorcFondeo	:= (Var_PorcFondeo / Decimal_Cien);

	SET	Var_FondeoIdStr	:= CONVERT(Var_FondeoKuboID, CHAR);

	SET	Var_MonAplicar	:= ROUND(Par_Monto * Var_PorcComisi * Var_PorcFondeo, 2);

	IF (Var_PagaISR = Si_PagaISR) THEN
		SET	Var_MonRetener	:= ROUND(Var_MonAplicar * Por_Retencion, 2);
	ELSE
		SET	Var_MonRetener	:= Decimal_Cero;
	END IF;


	IF (Var_MonAplicar > Decimal_Cero) THEN

		CALL CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonAplicar,		Par_MonedaID,		Var_NumRetMes,		Var_SucCliente,
			Des_PagoComision,		Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,			AltaMovKubo_SI,		Con_EgreComision,	Mov_Comision,		Nat_Cargo,
			Nat_Abono,				AltaMovAho_SI,		Aho_PagComisi,		Nat_Abono,			Par_NumErr,
			Par_ErrMen,				Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	END IF;


	IF (Var_MonRetener > Decimal_Cero) THEN

		CALL CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonRetener,		Par_MonedaID,		Var_NumRetMes,		Var_SucCliente,
			Des_RetenComision,		Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,			AltaMovKubo_SI,		Con_RetComision,	Mov_RetComision,	Nat_Abono,
			Nat_Cargo,				AltaMovAho_SI,		Aho_RetComisi,		Nat_Cargo,			Par_NumErr,
			Par_ErrMen,				Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	END LOOP CICLO;
END;
CLOSE CURSORINVER;


END TerminaStore$$