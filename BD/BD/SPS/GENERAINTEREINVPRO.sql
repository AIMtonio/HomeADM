-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTEREINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAINTEREINVPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERAINTEREINVPRO`(
    Par_Fecha           date,
    Par_EmpresaID       int,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)

TerminaStore: BEGIN


DECLARE Var_FondeoKuboID    int;
DECLARE Var_AmortizacionID	int;
DECLARE Var_FechaInicio		date;
DECLARE Var_FechaVencim		date;
DECLARE Var_FechaExigible   date;
DECLARE Var_EmpresaID			int;
DECLARE Var_CapitalVig		decimal(14,2);
DECLARE Var_FormulaID 		int(11);
DECLARE Var_TasaFija 			decimal(12,4);
DECLARE Var_MonedaID			int(11);
DECLARE Var_Estatus			char(1);
DECLARE Var_SucCliente	 	int;
DECLARE Var_ClienteID			bigint;
DECLARE Var_PagaISR			char(1);
DECLARE Var_CuentaAhoID		bigint;
DECLARE Var_NumRetirosMes   int;
DECLARE Var_CreditoStr 		varchar(30);
DECLARE Var_ValorTasa			DECIMAL(12,4);
DECLARE Var_DiasCredito		DECIMAL(10,2);
DECLARE Var_Intere          DECIMAL(14,4);
DECLARE Var_FecApl          date;
DECLARE Var_EsHabil         char(1);
DECLARE SalCapital          decimal(14,2);
DECLARE DiasInteres         decimal(14,2);
DECLARE Var_CapAju          decimal(14,2);
DECLARE Ref_GenInt          varchar(50);
DECLARE Error_Key           int;

DECLARE Mov_CarConta			int;
DECLARE Var_Poliza          bigint;
DECLARE Var_TasaISR			decimal(12,4);
DECLARE Var_RetenInt			decimal(12,4);

DECLARE Par_NumErr          INT(11);
DECLARE Par_ErrMen          varchar(100);
DECLARE Sig_DiaHab          date;
DECLARE Par_Consecutivo     bigint;
DECLARE Var_ContadorInv     int;
DECLARE Var_SigFecha    date;


DECLARE Estatus_Vigente char(1);
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(8,2);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Dec_Cien        decimal(10,2);
DECLARE Pro_GenIntere   int;
DECLARE Mov_IntPro      int;
DECLARE Con_IntDeven    int;
DECLARE Con_EgreIntGra  int;
DECLARE Con_EgreIntExc  int;
DECLARE Pol_Automatica  char(1);
DECLARE Con_GenIntere   int;
DECLARE Par_SalidaNO    char(1);
DECLARE AltaPoliza_NO   char(1);
DECLARE AltaPolKubo_SI  char(1);
DECLARE AltaMovKubo_SI  char(1);
DECLARE AltaMovKubo_NO  char(1);
DECLARE AltaMovAho_NO   char(1);
DECLARE PagaISR_SI      char(1);
DECLARE Des_CieDia      varchar(100);


DECLARE CURSORINTER CURSOR FOR
	select	Inv.FondeoKuboID, 	AmortizacionID,	Amo.FechaInicio,		Amo.FechaVencimiento,
			Amo.FechaExigible,	Inv.EmpresaID,	Inv.SaldoCapVigente,	Inv.CalcInteresID,
			Inv.TasaFija,			Inv.MonedaID,		Inv.Estatus,			Cli.SucursalOrigen,
			Cli.ClienteID	,		Cli.PagaISR,		Inv.CuentaAhoID,		Inv.NumRetirosMes
		from AMORTIZAFONDEO Amo,
			 FONDEOKUBO	 Inv,
			 CLIENTES Cli
		where Amo.FondeoKuboID 		= Inv.FondeoKuboID
		  and Inv.ClienteID			= Cli.ClienteID
		  and Amo.FechaInicio			<= Var_SigFecha
		  and Amo.FechaVencimiento		>  Par_Fecha
		  and Amo.FechaExigible		>  Par_Fecha
		  and Amo.Estatus				=  'N'
		  and Inv.Estatus				=  'N';


Set Estatus_Vigente := 'N';
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.00;
Set Nat_Cargo       := 'C';
Set Nat_Abono       := 'A';
Set Dec_Cien        := 100.00;
Set Pro_GenIntere   := 301;
Set Mov_IntPro      := 10;
Set Con_IntDeven    := 8;
Set Con_EgreIntGra  := 3;
Set Con_EgreIntExc  := 4;
Set Pol_Automatica  := 'A';
Set Con_GenIntere   := 20;
Set Par_SalidaNO    := 'N';
Set AltaPoliza_NO   := 'N';
Set AltaPolKubo_SI  := 'S';
Set AltaMovKubo_NO  := 'N';
Set AltaMovKubo_SI  := 'S';
Set AltaMovAho_NO   := 'N';
Set PagaISR_SI      := 'S';
Set Des_CieDia      := 'CIERRE DIARO INVERSIONES KUBO';
Set Ref_GenInt      := 'GENERACION INTERES';

set Aud_ProgramaID  := 'GENERAINTEREINVPRO';

select DiasCredito, TasaISR into Var_DiasCredito, Var_TasaISR
	from PARAMETROSSIS;

set Var_SigFecha := DATE_ADD(FUNCIONDIAHABIL(Par_Fecha, 1, Par_EmpresaID), interval -1 day);

call DIASFESTIVOSCAL(
	Par_Fecha,	Entero_Cero,		Var_FecApl,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);


call DIASFESTIVOSCAL(
	Par_Fecha,	1,		Sig_DiaHab,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);


select count(Inv.FondeoKuboID) into Var_ContadorInv
		from AMORTIZAFONDEO Amo,
			 FONDEOKUBO	 Inv
		where Amo.FondeoKuboID 		= Inv.FondeoKuboID
		  and Amo.FechaInicio			<= Var_SigFecha
		  and Amo.FechaVencimiento		>  Par_Fecha
		  and Amo.FechaExigible		>  Par_Fecha
		  and Amo.Estatus				=  Estatus_Vigente
		  and Inv.Estatus				=  Estatus_Vigente;

set Var_ContadorInv := ifnull(Var_ContadorInv, Entero_Cero);

if (Var_ContadorInv > Entero_Cero) then
    call MAESTROPOLIZAALT(
        Var_Poliza,		Par_EmpresaID,  Var_FecApl,     Pol_Automatica,	Con_GenIntere,
        Ref_GenInt,		Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
        Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion);
end if;

OPEN CURSORINTER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORINTER into
		Var_FondeoKuboID,		Var_AmortizacionID,	Var_FechaInicio,	Var_FechaVencim,
		Var_FechaExigible,	Var_EmpresaID,		Var_CapitalVig,	Var_FormulaID,
		Var_TasaFija,			Var_MonedaID,			Var_Estatus,		Var_SucCliente,
		Var_ClienteID,		Var_PagaISR,			Var_CuentaAhoID,	Var_NumRetirosMes;

	START TRANSACTION;
	BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

		set Error_Key 	= Entero_Cero;
		set DiasInteres 	= Entero_Cero;
		set SalCapital	= Decimal_Cero;
		set Var_CapAju	= Decimal_Cero;
		set Var_Intere	= Decimal_Cero;
		set	Var_RetenInt	= 0.0000;
		set Var_ValorTasa	= Var_TasaFija;

		if (Var_FechaVencim > Var_FechaExigible and (datediff(Var_FechaExigible, Sig_DiaHab) = 0)) then
			set	DiasInteres	= datediff(Var_FechaVencim, Par_Fecha);
		else
			if(Sig_DiaHab > Var_FechaVencim) then
				set 	DiasInteres	= datediff(Var_FechaVencim, Par_Fecha);
			elseif(Var_FechaInicio > Par_Fecha) then
				set 	DiasInteres	= datediff(Sig_DiaHab, Var_FechaInicio);
			else
				set 	DiasInteres	= datediff(Sig_DiaHab, Par_Fecha);
			end if;
		end if;

		set	SalCapital = Var_CapitalVig;

		set	Var_CapAju	:= (select ifnull(sum(SaldoCapVigente), Decimal_Cero)
							from AMORTIZAFONDEO
							where FondeoKuboID 	= Var_FondeoKuboID
							  and AmortizacionID	< Var_AmortizacionID
							  and FechaExigible	> Var_FechaInicio
							  and FechaExigible	> FechaVencimiento
							group by FondeoKuboID );


		set	Var_CapAju = ifnull(Var_CapAju, Entero_Cero);

		set	SalCapital = SalCapital - Var_CapAju;

		set	Var_Intere = round(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 4);
		set	Var_RetenInt	= round(SalCapital * Var_TasaISR * DiasInteres / (Var_DiasCredito * Dec_Cien), 4);

		if (Var_Intere > Entero_Cero) then


			if (Var_PagaISR = PagaISR_SI) then
				set	Mov_CarConta	:= Con_EgreIntGra;
			else
				set	Mov_CarConta	:= Con_EgreIntExc;
			end if;

			call  CONTAINVKUBOPRO (
				Var_FondeoKuboID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_Intere,		Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_CieDia,		Ref_GenInt,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,		AltaPolKubo_SI,
				AltaMovKubo_SI,		Mov_CarConta,			Mov_IntPro,		Nat_Cargo,
				Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			call  CONTAINVKUBOPRO (
				Var_FondeoKuboID,		Var_AmortizacionID,	Var_CuentaAhoID,	Var_ClienteID,
				Par_Fecha,			Var_FecApl,			Var_Intere,		Var_MonedaID,
				Var_NumRetirosMes,	Var_SucCliente,		Des_CieDia,		Ref_GenInt,
				AltaPoliza_NO,		Entero_Cero,			Var_Poliza,		AltaPolKubo_SI,
				AltaMovKubo_NO,		Con_IntDeven,			Entero_Cero,		Nat_Abono,
				Cadena_Vacia,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);


			update AMORTIZAFONDEO set
				RetencionIntAcum	= RetencionIntAcum + Var_RetenInt
				where FondeoKuboID 	= Var_FondeoKuboID
				  and AmortizacionID	= Var_AmortizacionID;

		end if;

	END;
	set Var_CreditoStr = CONCAT(convert(Var_FondeoKuboID, char), '-', convert(Var_AmortizacionID, char)) ;
	if Error_Key = 0 then
		COMMIT;
	end if;
	if Error_Key = 1 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_GenIntere, 	Par_Fecha, 		Var_CreditoStr, 	'ERROR DE SQL GENERAL',
				Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 2 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_GenIntere, 	Par_Fecha, 		Var_CreditoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',
				Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 3 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_GenIntere, 	Par_Fecha, 		Var_CreditoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE',
				Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 4 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_GenIntere, 	Par_Fecha, 		Var_CreditoStr, 	'ERROR VALORES NULOS',
				Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		COMMIT;
	end if;

	End LOOP;
END;
CLOSE CURSORINTER;

END TerminaStore$$