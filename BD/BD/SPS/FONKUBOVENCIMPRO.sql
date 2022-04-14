-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONKUBOVENCIMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONKUBOVENCIMPRO`;
DELIMITER $$


CREATE PROCEDURE `FONKUBOVENCIMPRO`(
    Par_Fecha           date,
    Par_EmpresaID       int,

inout	Par_NumErr			int(11),
inout	Par_ErrMen			varchar(400),
inout	Par_Consecutivo		bigint,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)

TerminaStore: BEGIN


DECLARE Var_FondeoKuboID		int;
DECLARE Var_AmortizacionID	int;
DECLARE Var_FechaInicio		date;
DECLARE Var_FechaVencim		date;
DECLARE Var_EmpresaID			int;
DECLARE Var_MonedaID			int(11);
DECLARE Var_NumRetirosMes   int;
DECLARE Var_CuentaAhoID		bigint;
DECLARE Var_CapitalVig		decimal(14,2);
DECLARE Var_CapitalAtr		decimal(14,2);
DECLARE Var_Interes			decimal(14,4);
DECLARE Var_InteresAcum		decimal(14,4);
DECLARE Var_RetencAcum		decimal(14,4);
DECLARE Var_SucCliente	 	int;
DECLARE Var_ClienteID			bigint;
DECLARE Var_PagaISR			char(1);
DECLARE Var_FondeoStr			char(50);
DECLARE Mov_Capita          int;
DECLARE Con_Capita          int;
DECLARE Var_FecApl          date;
DECLARE Var_EsHabil         char(1);
DECLARE Var_Poliza          bigint;
DECLARE Var_MonAplicar      decimal(12,2);
DECLARE Var_MonRetener		decimal(12,2);
DECLARE Aho_Interes			char(2);
DECLARE Error_Key           int;
DECLARE Var_ContadorInv     int;


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(8,2);
DECLARE Pro_VencimInv   int;
DECLARE Estatus_Vigente char(1);
DECLARE Pago_Incumple   char(1);

DECLARE AltaPoliza_NO   char(1);
DECLARE AltaPolKubo_SI  char(1);
DECLARE AltaMovKubo_SI  char(1);
DECLARE AltaMovAho_SI   char(1);
DECLARE Par_SalidaNO    char(1);
DECLARE Pol_Automatica  char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);

DECLARE Con_CapOrdinario    int;
DECLARE Con_CapExigible int;
DECLARE Con_IntDeven    int;
DECLARE Con_RetInt      int;
DECLARE Mov_IntPro      int;
DECLARE Mov_RetInt      int;
DECLARE Mov_CapOrdinario 	int;
DECLARE Mov_CapExigible int;
DECLARE Con_Vencimientos    int;
DECLARE Aho_CapInvKubo  char(2);
DECLARE Aho_IntGraKubo  char(2);
DECLARE Aho_IntExeKubo  char(2);
DECLARE Aho_ISRInteres  char(2);

DECLARE PagaISR_SI      char(1);
DECLARE Estatus_Pagada  char(1);
DECLARE Des_PagoCap     varchar(50);
DECLARE Des_PagoInteres varchar(50);
DECLARE Des_PagoRetIntere   varchar(50);
DECLARE Des_VenFondeo			varchar(50);


DECLARE CURSORFONDEO CURSOR FOR
	select	Inv.FondeoKuboID, 	AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencimiento,
			Inv.EmpresaID,		Inv.MonedaID,			Inv.NumRetirosMes,	Inv.CuentaAhoID,
			Amo.SaldoCapVigente,	Amo.SaldoCapExigible,	Amo.SaldoInteres,		Amo.ProvisionAcum,
			Amo.RetencionIntAcum,	Cli.SucursalOrigen,	Cli.ClienteID	,		Cli.PagaISR
		from AMORTIZAFONDEO Amo,
			 FONDEOKUBO	 Inv,
			 TIPOSFONDEADORES Tip,
			 CLIENTES Cli
		where Amo.FondeoKuboID	= Inv.FondeoKuboID
		  and Inv.TipoFondeo		= Tip.TipoFondeadorID
		  and Inv.ClienteID		= Cli.ClienteID
		  and Amo.FechaExigible	<= Par_Fecha
		  and Amo.Estatus			= 'N'
		  and Inv.Estatus			= 'N'
		  and Tip.PagoEnIncumple	= 'S';


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Pro_VencimInv   := 302;
Set Estatus_Vigente := 'N';
Set Pago_Incumple   := 'S';

Set AltaPoliza_NO   := 'N';
Set AltaPolKubo_SI  := 'S';
Set AltaMovKubo_SI  := 'S';
Set AltaMovAho_SI   := 'S';
Set Par_SalidaNO    := 'N';
Set Pol_Automatica  := 'A';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Mov_CapOrdinario    := 1;
Set Mov_CapExigible := 2;
Set Mov_IntPro      := 10;
Set Mov_RetInt      := 50;
Set Con_CapOrdinario    := 1;
Set Con_CapExigible := 2;
Set Con_RetInt      := 4;
Set Con_IntDeven    := 8;
Set Con_Vencimientos    := 21;
Set Aho_CapInvKubo  := '71';
Set Aho_IntGraKubo  := '72';
Set Aho_IntExeKubo  := '73';
Set Aho_ISRInteres  := '76';
Set PagaISR_SI      := 'S';
Set Estatus_Pagada  := 'P';

Set Des_PagoCap         := 'PAGO DE INVERSION. CAPITAL';
Set Des_PagoInteres     := 'PAGO DE INVERSION. INTERES';
Set Des_PagoRetIntere   := 'PAGO DE INVERSION. RETENCION INTERES';
Set Des_VenFondeo       := 'VENCIMIENTO FONDEO KUBO';


call DIASFESTIVOSCAL(
	Par_Fecha,	Entero_Cero,		Var_FecApl,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);

select count(Inv.FondeoKuboID) into Var_ContadorInv
    from AMORTIZAFONDEO Amo,
         FONDEOKUBO	 Inv,
         TIPOSFONDEADORES Tip,
         CLIENTES Cli
    where Amo.FondeoKuboID	= Inv.FondeoKuboID
      and Inv.TipoFondeo		= Tip.TipoFondeadorID
      and Inv.ClienteID		= Cli.ClienteID
      and Amo.FechaExigible	<= Par_Fecha
      and Amo.Estatus			= Estatus_Vigente
      and Inv.Estatus			= Estatus_Vigente
      and Tip.PagoEnIncumple	= Pago_Incumple;

set Var_ContadorInv := ifnull(Var_ContadorInv, Entero_Cero);

if (Var_ContadorInv > Entero_Cero) then
    call MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,	Var_FecApl,	Pol_Automatica,	Con_Vencimientos,
        Des_VenFondeo,	Par_SalidaNO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
end if;

OPEN CURSORFONDEO;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORFONDEO into
		Var_FondeoKuboID,	Var_AmortizacionID,	Var_FechaInicio,	Var_FechaVencim,	Var_EmpresaID,
		Var_MonedaID,		Var_NumRetirosMes,	Var_CuentaAhoID,	Var_CapitalVig,	Var_CapitalAtr,
		Var_Interes,		Var_InteresAcum,		Var_RetencAcum,	Var_SucCliente,	Var_ClienteID,
		Var_PagaISR;
	START TRANSACTION;
	BEGIN

		 DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		 DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		 DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		 DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


		set	Error_Key 	:= Entero_Cero;
		set	Mov_Capita	:= Entero_Cero;
		set	Con_Capita	:= Entero_Cero;
		set	Var_MonAplicar	:= Decimal_Cero;
		set	Var_MonRetener	:= Decimal_Cero;

		set Var_FondeoStr = CONCAT(convert(Var_FondeoKuboID, char), '-', convert(Var_AmortizacionID, char)) ;


		if ((Var_CapitalVig + Var_CapitalAtr) > Decimal_Cero ) then
			set Var_MonAplicar	:= Var_CapitalVig + Var_CapitalAtr;
		end if;

		if (Var_MonAplicar > Decimal_Cero ) then

			if(Var_CapitalAtr > Decimal_Cero) then
				set	Mov_Capita	:= Mov_CapExigible;
				set	Con_Capita	:= Con_CapExigible;
			else
				set	Mov_Capita	:= Mov_CapOrdinario;
				set	Con_Capita	:= Con_CapOrdinario;
			end if;
			call CONTAINVKUBOPRO(
				Var_FondeoKuboID,   Var_AmortizacionID,	Var_CuentaAhoID,    Var_ClienteID,
				Par_Fecha,          Var_FecApl,			Var_MonAplicar,     Var_MonedaID,
				Var_NumRetirosMes,  Var_SucCliente,		Des_PagoCap,        Var_FondeoStr,
				AltaPoliza_NO,      Entero_Cero,			Var_Poliza,         AltaPolKubo_SI,
				AltaMovKubo_SI,     Con_Capita,			Mov_Capita,         Nat_Cargo,
				Nat_Abono,          AltaMovAho_SI,		Aho_CapInvKubo,     Nat_Abono,
				Par_NumErr,         Par_ErrMen,			Par_Consecutivo,    Var_EmpresaID,
				Aud_Usuario,	        Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

		end if;

		set	Var_MonRetener	:= round((Var_RetencAcum / Var_InteresAcum) * round(Var_Interes, 2), 2);


		if (Var_Interes > Decimal_Cero) then

			if (Var_MonRetener > Decimal_Cero) and (Var_PagaISR = PagaISR_SI) then
				set	Aho_Interes	:= Aho_IntGraKubo;
			else
				set	Aho_Interes	:= Aho_IntExeKubo;
			end if;

			call CONTAINVKUBOPRO(
				Var_FondeoKuboID,	Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_Interes,		Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_PagoInteres,	Var_FondeoStr,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,		AltaPolKubo_SI,
				AltaMovKubo_SI,		Con_IntDeven,			Mov_IntPro,		Nat_Cargo,
				Nat_Abono,			AltaMovAho_SI,		Aho_Interes,		Nat_Abono,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Var_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);
		end if;



		if (Var_MonRetener > Decimal_Cero) and (Var_PagaISR = PagaISR_SI) then
			call CONTAINVKUBOPRO(
				Var_FondeoKuboID,	Var_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_MonRetener,		Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_PagoRetIntere,	Var_FondeoStr,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,			AltaPolKubo_SI,
				AltaMovKubo_SI,		Con_RetInt,			Mov_RetInt,			Nat_Abono,
				Nat_Cargo,			AltaMovAho_SI,		Aho_ISRInteres,		Nat_Cargo,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,		Var_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);
		end if;


		update AMORTIZAFONDEO set
			Estatus			= Estatus_Pagada,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

			where FondeoKuboID	= Var_FondeoKuboID
			  and AmortizacionID	= Var_AmortizacionID;
	END;

	if Error_Key = 0 then
		COMMIT;
	end if;
	if Error_Key = 1 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_VencimInv, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR DE SQL GENERAL',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 2 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_VencimInv, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 3 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_VencimInv, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 4 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_VencimInv, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR VALORES NULOS',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;

	End LOOP;
END;
CLOSE CURSORFONDEO;
END TerminaStore$$