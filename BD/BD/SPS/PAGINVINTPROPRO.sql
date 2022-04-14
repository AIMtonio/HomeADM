-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGINVINTPROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGINVINTPROPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGINVINTPROPRO`(
	Par_CreditoID			bigint,
	Par_FechaInicio		date,
	Par_FechaVencim		date,

	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,
	Par_Monto			decimal(14,2),
	Par_MonedaID			int,
	Par_SucCliente		int,
	Par_Poliza			bigint,

inout	Par_NumErr			int(11),
inout	Par_ErrMen			varchar(400),
inout	Par_Consecutivo		bigint,

	Par_Empresa			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN



DECLARE	Var_FondeoKuboID	bigint;
DECLARE	Var_ClienteID		bigint;
DECLARE	Var_CuentaAhoID	bigint(12);
DECLARE	Var_AmortizaID	bigint;
DECLARE	Var_PorcInteres	decimal(10,6);
DECLARE	Var_InteresAcum	decimal(14,4);
DECLARE	Var_RetencAcum	decimal(14,4);
DECLARE	Var_NumRetMes		int;
DECLARE	Var_SucCliente	int;
DECLARE	Var_PagaISR		char(1);
DECLARE	Var_SaldoInteres	decimal(14,4);


DECLARE	Var_MonAplicar	decimal(14,2);
DECLARE	Var_MonRetener	decimal(14,2);
DECLARE	Var_FondeoIdStr	varchar(30);
DECLARE	Aho_MovPago		varchar(4);


DECLARE	Cadena_Vacia	  	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12, 2);
DECLARE	Des_PagoInt		varchar(50);
DECLARE	Des_RetenInt		varchar(50);

DECLARE	AltaPoliza_NO		char(1);
DECLARE	AltaPolKubo_SI	char(1);
DECLARE	AltaMovKubo_SI	char(1);
DECLARE	AltaMovAho_SI		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Con_IntDeven 		int;
DECLARE	Con_RetInt		int;
DECLARE	Mov_IntPro		int;
DECLARE	Mov_RetInt		int;
DECLARE	Aho_PagIntGra		char(4);
DECLARE	Aho_PagIntExe		char(4);
DECLARE	Aho_RetInteres	char(4);
DECLARE	PagaISR_SI		char(1);


DECLARE CURSORINVER CURSOR FOR
	select	Fon.FondeoKuboID,			Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
			Amo.PorcentajeInteres,	Amo.ProvisionAcum,	Amo.RetencionIntAcum,	Fon.NumRetirosMes,
			Cli.SucursalOrigen,		Cli.PagaISR,			Amo.SaldoInteres
		from FONDEOKUBO Fon,
			 AMORTIZAFONDEO Amo,
			 CLIENTES Cli,
			 TIPOSFONDEADORES Tip
		where Fon.FondeoKuboID	= Amo.FondeoKuboID
		  and Amo.FechaVencimiento	= Par_FechaVencim
		  and Fon.ClienteID		= Cli.ClienteID
		  and Fon.CreditoID		= Par_CreditoID
		  and Fon.TipoFondeo		= Tip.TipoFondeadorID
		  and Fon.TipoFondeo		= 1
		  and Tip.PagoEnIncumple	= 'N'
		  and Fon.Estatus			= 'N'
		  and Amo.Estatus			= 'N';


Set	Cadena_Vacia	  	:= '';
Set	Fecha_Vacia		:= '0000-00-00';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.00;

Set	AltaPoliza_NO		:= 'N';
Set	AltaPolKubo_SI	:= 'S';
Set	AltaMovKubo_SI	:= 'S';
Set	AltaMovAho_SI		:= 'S';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set	Mov_IntPro 		:= 10;
Set	Mov_RetInt 		:= 50;

Set	Con_RetInt 		:= 5;
Set	Con_IntDeven 		:= 8;

Set	Aho_PagIntGra		:= '72';
Set	Aho_PagIntExe		:= '73';
Set	Aho_RetInteres	:= '76';


Set	PagaISR_SI		:= 'S';
Set	Des_PagoInt		:= 'PAGO DE CREDITO. INTERES';
Set	Des_RetenInt		:= 'PAGO DE CREDITO. RETENCION DE INTERES';


OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORINVER into
		Var_FondeoKuboID,	Var_ClienteID,	Var_CuentaAhoID,	Var_AmortizaID,	Var_PorcInteres,
		Var_InteresAcum,	Var_RetencAcum,	Var_NumRetMes,	Var_SucCliente,	Var_PagaISR,
		Var_SaldoInteres;


	set	Var_MonAplicar	:= Decimal_Cero;
	set	Var_MonRetener	:= Decimal_Cero;
	set	Var_FondeoIdStr	:= convert(Var_FondeoKuboID, char);


	set	Var_MonAplicar	:= round(Par_Monto * Var_PorcInteres, 2);

	if (Var_MonAplicar >= round(Var_SaldoInteres, 2) ) then
		set Var_MonAplicar	:= Var_SaldoInteres ;
	end if;

	set	Var_MonRetener	:= round((Var_RetencAcum / Var_InteresAcum) * round(Var_MonAplicar, 2), 2);


	if (Var_MonAplicar > Decimal_Cero) then

		if (Var_PagaISR = PagaISR_SI) then
			set	Aho_MovPago	:= Aho_PagIntGra;
		else
			set	Aho_MovPago	:= Aho_PagIntExe;
		end if;

		call CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,	Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonAplicar,	Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
			Des_PagoInt,			Var_FondeoIdStr,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,		AltaMovKubo_SI,	Con_IntDeven,		Mov_IntPro,		Nat_Cargo,
			Nat_Abono,			AltaMovAho_SI,	Aho_MovPago,		Nat_Abono,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	if (Var_MonRetener > Decimal_Cero) and (Var_PagaISR = PagaISR_SI) then

		call CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,	Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonRetener,	Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
			Des_RetenInt,			Var_FondeoIdStr,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,		AltaMovKubo_SI,	Con_RetInt,		Mov_RetInt,		Nat_Abono,
			Nat_Cargo,			AltaMovAho_SI,	Aho_RetInteres,	Nat_Cargo,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	End LOOP CICLO;
END;
CLOSE CURSORINVER;


END TerminaStore$$