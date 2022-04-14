-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGINVINTMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGINVINTMORPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGINVINTMORPRO`(
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
DECLARE	Var_PorcMora		decimal(10,4);
DECLARE	Var_NumRetMes		int;
DECLARE	Var_SucCliente	int;
DECLARE	Var_PagaISR		char(1);
DECLARE	Var_PorcFondeo	decimal(10,4);

DECLARE	Var_MonAplicar	decimal(12,2);
DECLARE	Var_MonRetener	decimal(12,2);
DECLARE	Var_FondeoIdStr	varchar(30);



DECLARE	Cadena_Vacia	  	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12, 2);
DECLARE	Decimal_Cien		decimal(12, 2);
DECLARE	Des_PagoMor		varchar(50);
DECLARE	Des_RetenMor		varchar(50);

DECLARE	AltaPoliza_NO		char(1);
DECLARE	AltaPolKubo_SI	char(1);
DECLARE	AltaMovKubo_SI	char(1);
DECLARE	AltaMovAho_SI		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Si_PagaISR		char(1);

DECLARE	Mov_IntMor 		int;
DECLARE	Mov_RetMor 		int;
DECLARE	Con_RetMor 		int;
DECLARE	Con_EgreMora 		int;
DECLARE	Aho_PagMorato		varchar(4);
DECLARE	Aho_RetMorato		varchar(4);

DECLARE	Por_Retencion		decimal(8,4);


DECLARE CURSORINVER CURSOR FOR
	select	Fon.FondeoKuboID,			Fon.ClienteID,		Fon.CuentaAhoID,		Amo.AmortizacionID,
			Fon.PorcentajeMora,		Fon.NumRetirosMes,	Cli.SucursalOrigen,	Cli.PagaISR,
			Fon.PorcentajeFondeo
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
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.00;
Set	Decimal_Cien		:= 100.00;

Set	AltaPoliza_NO		:= 'N';
Set	AltaPolKubo_SI	:= 'S';
Set	AltaMovKubo_SI	:= 'S';
Set	AltaMovAho_SI		:= 'S';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Si_PagaISR		:= 'S';

Set	Mov_IntMor 		:= 15;
Set	Mov_RetMor 		:= 51;

Set	Con_RetMor 		:= 6;
Set	Con_EgreMora 		:= 9;

Set	Aho_PagMorato		:= '74';
Set	Aho_RetMorato		:= '77';


Set	Por_Retencion		:= 0.28;

Set	Des_PagoMor		:= 'PAGO DE CREDITO. MORATORIOS';
Set	Des_RetenMor		:= 'PAGO DE CREDITO. RETENCION MORATORIOS';


OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORINVER into
		Var_FondeoKuboID,	Var_ClienteID,	Var_CuentaAhoID,	Var_AmortizaID,	Var_PorcMora,
		Var_NumRetMes,	Var_SucCliente,	Var_PagaISR,		Var_PorcFondeo;


	set	Var_MonAplicar	:= Decimal_Cero;
	set	Var_MonRetener	:= Decimal_Cero;
	set	Var_PorcMora		:= (Var_PorcMora / Decimal_Cien);
	set	Var_PorcFondeo	:= (Var_PorcFondeo / Decimal_Cien);

	set	Var_FondeoIdStr	:= convert(Var_FondeoKuboID, char);

	set	Var_MonAplicar	:= round(Par_Monto * Var_PorcMora * Var_PorcFondeo, 2);

	if (Var_PagaISR = Si_PagaISR) then
		set	Var_MonRetener	:= round(Var_MonAplicar * Por_Retencion, 2);
	else
		set	Var_MonRetener	:= Decimal_Cero;
	end if;


	if (Var_MonAplicar > Decimal_Cero) then

		call CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,	Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonAplicar,	Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
			Des_PagoMor,			Var_FondeoIdStr,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,		AltaMovKubo_SI,	Con_EgreMora,		Mov_IntMor,		Nat_Cargo,
			Nat_Abono,			AltaMovAho_SI,	Aho_PagMorato,	Nat_Abono,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	if (Var_MonRetener > Decimal_Cero) then

		call CONTAINVKUBOPRO(
			Var_FondeoKuboID,		Var_AmortizaID,	Var_CuentaAhoID,	Var_ClienteID,	Par_FechaOperacion,
			Par_FechaAplicacion,	Var_MonRetener,	Par_MonedaID,		Var_NumRetMes,	Var_SucCliente,
			Des_RetenMor,			Var_FondeoIdStr,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
			AltaPolKubo_SI,		AltaMovKubo_SI,	Con_RetMor,		Mov_RetMor,		Nat_Abono,
			Nat_Cargo,			AltaMovAho_SI,	Aho_RetMorato,	Nat_Cargo,		Par_NumErr,
			Par_ErrMen,			Par_Consecutivo,	Par_Empresa,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	End LOOP CICLO;
END;
CLOSE CURSORINVER;


END TerminaStore$$