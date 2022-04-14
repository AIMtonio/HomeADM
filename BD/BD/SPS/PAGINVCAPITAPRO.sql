-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGINVCAPITAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGINVCAPITAPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGINVCAPITAPRO`(
	Par_CreditoID			bigint,
	Par_FechaInicio		date,
	Par_FechaVencim		date,

	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,
	Par_Monto			decimal(12,2),
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
DECLARE	Var_PorcFondeo	decimal(8,4);
DECLARE	Var_NumRetMes		int;
DECLARE	Var_SaldoCapVig	decimal(12,2);
DECLARE	Var_SaldoCapExi	decimal(12,2);
DECLARE	Var_SucCliente	int;

DECLARE	Var_MonAplicar	decimal(12,2);
DECLARE	Var_FondeoIdStr	varchar(30);
DECLARE	Mov_Capita		int;
DECLARE	Con_Capita		int;



DECLARE	Cadena_Vacia	  	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12, 2);
DECLARE	Decimal_Cien		decimal(12, 2);
DECLARE	Tol_DifPago		decimal(6, 4);
DECLARE	Estatus_Pagada	char(1);
DECLARE	Des_PagoCap		varchar(50);


DECLARE	AltaPoliza_NO		char(1);
DECLARE	AltaPolKubo_SI	char(1);
DECLARE	AltaMovKubo_SI	char(1);
DECLARE	AltaMovAho_SI		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);

DECLARE	Con_CapOrdinario	int;
DECLARE	Con_CapExigible	int;
DECLARE	Mov_CapOrdinario 	int;
DECLARE	Mov_CapExigible 	int;
DECLARE	Aho_Capital		varchar(4);



DECLARE CURSORINVER CURSOR FOR
	select	Fon.FondeoKuboID,			Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
			Fon.PorcentajeFondeo,		Fon.NumRetirosMes,	Amo.SaldoCapVigente,	Amo.SaldoCapExigible,
			Cli.SucursalOrigen
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
		  and Amo.Estatus			= 'N';


Set	Cadena_Vacia	  	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.00;
Set	Decimal_Cien		:= 100.00;
Set	Tol_DifPago		:= 0.01;
Set	Estatus_Pagada	:= 'P';

Set	AltaPoliza_NO		:= 'N';
Set	AltaPolKubo_SI	:= 'S';
Set	AltaMovKubo_SI	:= 'S';
Set	AltaMovAho_SI		:= 'S';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set	Mov_CapOrdinario 	:= 1;
Set	Mov_CapExigible 	:= 2;

Set	Con_CapOrdinario	:= 1;
Set	Con_CapExigible	:= 2;

Set	Aho_Capital		:= '71';

Set	Des_PagoCap		:= 'PAGO DE CREDITO. CAPITAL';


OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORINVER into
		Var_FondeoKuboID,	Var_ClienteID,	Var_CuentaAhoID,	Var_AmortizaID,	Var_PorcFondeo,
		Var_NumRetMes,	Var_SaldoCapVig,	Var_SaldoCapExi,	Var_SucCliente;


	set	Var_MonAplicar	:= Decimal_Cero;
	Set	Var_PorcFondeo	:= (Var_PorcFondeo / Decimal_Cien);
	set	Var_FondeoIdStr	:= convert(Var_FondeoKuboID, char);


	set	Var_MonAplicar	:= round(Par_Monto * Var_PorcFondeo, 2);

	if (Var_MonAplicar > Var_SaldoCapExi + Var_SaldoCapVig ) then
		set Var_MonAplicar	:= Var_SaldoCapExi + Var_SaldoCapVig ;
	end if;

	if(Var_SaldoCapExi > Decimal_Cero) then
		set	Mov_Capita	:= Mov_CapExigible;
		set	Con_Capita	:= Con_CapExigible;
	else
		set	Mov_Capita	:= Mov_CapOrdinario;
		set	Con_Capita	:= Con_CapOrdinario;
	end if;


	if (Var_MonAplicar > Decimal_Cero) then

		call CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,	Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonAplicar,	Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
			Des_PagoCap,			Var_FondeoIdStr,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,		AltaMovKubo_SI,	Con_Capita,		Mov_Capita,		Nat_Cargo,
			Nat_Abono,			AltaMovAho_SI,	Aho_Capital,		Nat_Abono,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	if((Var_SaldoCapExi + Var_SaldoCapVig) - Var_MonAplicar) <= Tol_DifPago then
		update AMORTIZAFONDEO set
			Estatus			= Estatus_Pagada,
			FechaLiquida		= Par_FechaOperacion,

			EmpresaID		= Par_Empresa,
			Usuario			= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

			where FondeoKuboID	= Var_FondeoKuboID
			  and AmortizacionID	= Var_AmortizaID;
	end if;

	End LOOP CICLO;
END;
CLOSE CURSORINVER;


END TerminaStore$$