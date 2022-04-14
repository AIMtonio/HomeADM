-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONKUBOTRASEXIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONKUBOTRASEXIPRO`;
DELIMITER $$


CREATE PROCEDURE `FONKUBOTRASEXIPRO`(
	Par_Fecha			date,
	Par_EmpresaID			int,


inout	Par_NumErr			int(11),
inout	Par_ErrMen			varchar(400),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


DECLARE Var_FondeoKuboID    int;
DECLARE Var_AmortizacionID	int;
DECLARE Var_FechaInicio		date;
DECLARE Var_FechaVencim		date;
DECLARE Var_EmpresaID			int;
DECLARE Var_MonedaID			int(11);
DECLARE Var_NumRetirosMes	int;
DECLARE Var_CuentaAhoID		bigint;
DECLARE Var_CapitalVig		decimal(12,2);
DECLARE Var_Interes			decimal(12,4);
DECLARE Var_SucCliente	 	int;
DECLARE Var_ClienteID			bigint;
DECLARE Var_FecApl          date;
DECLARE Var_EsHabil         char(1);
DECLARE Var_Poliza          bigint;
DECLARE Error_Key			   int;
DECLARE Var_FondeoStr			varchar(20);
DECLARE Par_Consecutivo		bigint;
DECLARE Var_ContadorInv     int;



DECLARE Cadena_Vacia		   char(1);
DECLARE Fecha_Vacia		   date;
DECLARE Entero_Cero		   int;
DECLARE Decimal_Cero        decimal(8,2);
DECLARE Pro_TraspaExi       int;
DECLARE AltaPoliza_NO       char(1);
DECLARE AltaPolKubo_SI      char(1);
DECLARE AltaMovKubo_SI      char(1);
DECLARE AltaMovAho_NO       char(1);
DECLARE Par_SalidaNO        char(1);
DECLARE Pol_Automatica      char(1);
DECLARE Nat_Cargo           char(1);
DECLARE Nat_Abono           char(1);
DECLARE Estatus_Vigente     char(1);

DECLARE Mov_CapOrdinario    int;
DECLARE Mov_CapExigible     int;
DECLARE Con_CapOrdinario    int;
DECLARE Con_CapExigible     int;
DECLARE Con_TraspaExi       int;
DECLARE Des_TraspaExi       varchar(50);

DECLARE CURSOREXIGIBLE CURSOR FOR
	select	Inv.FondeoKuboID, 	AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencimiento,
			Inv.EmpresaID,		Inv.MonedaID,			Inv.NumRetirosMes,	Inv.CuentaAhoID,
			Amo.SaldoCapVigente,	Amo.SaldoInteres,		Cli.SucursalOrigen,	Cli.ClienteID
		from AMORTIZAFONDEO Amo,
			 FONDEOKUBO	 Inv,
			 CLIENTES Cli
		where Amo.FondeoKuboID 		= Inv.FondeoKuboID
		  and Inv.ClienteID			= Cli.ClienteID
		  and Amo.FechaExigible		<= Par_Fecha
		  and Amo.Estatus				=  'N'
		  and Inv.Estatus				=  'N'
		  and Amo.SaldoCapVigente 		> 0.00;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Pro_TraspaExi   := 303;
Set AltaPoliza_NO   := 'N';
Set AltaPolKubo_SI  := 'S';
Set AltaMovKubo_SI  := 'S';
Set AltaMovAho_NO   := 'N';
Set Par_SalidaNO    := 'N';
Set Pol_Automatica  := 'A';
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Estatus_Vigente := 'N';
Set Mov_CapOrdinario 	:= 1;
Set Mov_CapExigible 	:= 2;
Set Con_CapOrdinario	:= 1;
Set Con_CapExigible	:= 2;
Set Con_TraspaExi		:= 22;
Set Des_TraspaExi		:= 'TRASPASO EXIGIBLE INVERSIONES KUBO';


call DIASFESTIVOSCAL(
	Par_Fecha,	Entero_Cero,		Var_FecApl,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);

select count(Inv.FondeoKuboID) into Var_ContadorInv
    from AMORTIZAFONDEO Amo,
         FONDEOKUBO	 Inv
    where Amo.FondeoKuboID 		= Inv.FondeoKuboID
      and Amo.FechaExigible		<= Par_Fecha
      and Amo.Estatus				=  Estatus_Vigente
      and Inv.Estatus				=  Estatus_Vigente
      and Amo.SaldoCapVigente 		> 0.00;

set Var_ContadorInv := ifnull(Var_ContadorInv, Entero_Cero);

if (Var_ContadorInv > Entero_Cero) then
    call MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,  Var_FecApl,         Pol_Automatica,	Con_TraspaExi,
        Des_TraspaExi,	Par_SalidaNO,   Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
end if;

OPEN CURSOREXIGIBLE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSOREXIGIBLE into
		Var_FondeoKuboID,	Var_AmortizacionID,	Var_FechaInicio,	Var_FechaVencim,	Var_EmpresaID,
		Var_MonedaID,		Var_NumRetirosMes,	Var_CuentaAhoID,	Var_CapitalVig,	Var_Interes,
		Var_SucCliente,	Var_ClienteID;

	START TRANSACTION;

	BLOQUE_ERROR: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;



		set	Error_Key 		:= Entero_Cero;
		set Var_FondeoStr 	:= CONCAT(convert(Var_FondeoKuboID, char), '-', convert(Var_AmortizacionID, char));

		if(Var_CapitalVig > Decimal_Cero) then



			call CONTAINVKUBOPRO(
				Var_FondeoKuboID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_CapitalVig,	Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_TraspaExi,	Var_FondeoStr,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,		AltaPolKubo_SI,
				AltaMovKubo_SI,		Con_CapOrdinario,		Mov_CapOrdinario,	Nat_Cargo,
				Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Var_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);



			call CONTAINVKUBOPRO(
				Var_FondeoKuboID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_CapitalVig,	Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_TraspaExi,	Var_FondeoStr,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,		AltaPolKubo_SI,
				AltaMovKubo_SI,		Con_CapExigible,		Mov_CapExigible,	Nat_Abono,
				Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Var_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);
		end if;

	END BLOQUE_ERROR;

	if Error_Key = 0 then
		COMMIT;
	end if;
	if Error_Key = 1 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_TraspaExi, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR DE SQL GENERAL',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 2 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_TraspaExi, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 3 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_TraspaExi, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 4 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_TraspaExi, 	Par_Fecha, 		Var_FondeoStr, 	'ERROR VALORES NULOS',
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 999 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_TraspaExi, 	Par_Fecha, 		Var_FondeoStr, 	Par_ErrMen,
				Var_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	End LOOP;
END;
CLOSE CURSOREXIGIBLE;

END TerminaStore$$