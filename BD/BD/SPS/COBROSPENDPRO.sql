-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENDPRO`;DELIMITER $$

CREATE PROCEDURE `COBROSPENDPRO`(

	Par_FechaOperacion	date,
	Par_Salida			char(1),
	inout Par_NumErr	int,
    inout Par_ErrMen  	varchar(350),
    inout Par_Poliza  	bigint,
	Par_EmpresaID		int,
	Aud_Usuario			int,

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE	Salida_NO		char(1);
DECLARE	Salida_SI		char(1);
DECLARE Est_Pendiente	char(1);
DECLARE Var_SI			char(1);
DECLARE Var_NO			char(1);
DECLARE Nat_Cargo		char(1);
DECLARE Nat_Abono		char(1);
DECLARE AltaEncPolizaSi	char(1);
DECLARE AltaEncPolizaNo	char(1);
DECLARE AltaPolizaSi	char(1);

DECLARE Var_MovComAper	varchar(4);
DECLARE Var_MovComAniv	varchar(4);
DECLARE Var_MovComManC	varchar(4);
DECLARE Var_MovIvaAper	varchar(4);
DECLARE Var_MovIvaAniv	varchar(4);
DECLARE Var_MovIvaManC	varchar(4);

DECLARE	Var_DesMov		varchar(100);
DECLARE	Var_DesMovIVA	varchar(100);
DECLARE	Var_ConIvaMov	varchar(100);
DECLARE	Act_PagoPend	int(11);


DECLARE ConAhoComApe		int;
DECLARE ConAhoComAnual		int;
DECLARE ConAhoComManCta		int;
DECLARE ConAhoIvaApe		int;
DECLARE ConAhoIvaAnual		int;
DECLARE ConAhoIvaManCta		int;
DECLARE ConAhoPasivo		int;


DECLARE	VarConcepConta		int;


DECLARE Var_ClienteID	int(11);
DECLARE Var_MontoCob	decimal(12,2);
DECLARE Var_MontoCobIva	decimal(12,2);
DECLARE Var_CantPenAct	decimal(12,2);
DECLARE Var_CantPenCom	decimal(12,2);
DECLARE Var_AltaEncPol	char(1);
DECLARE Var_TipoMovAho	char(4);
DECLARE Var_TipoMovIva	char(4);
DECLARE Var_Fecha		date;
DECLARE Var_CuentaAhoID	bigint(12);
DECLARE Var_SaldoDispon	decimal(12,2);
DECLARE Var_PagaIVA		char(1);
DECLARE Var_IVA			decimal(14,2);
DECLARE Var_Transaccion	bigint;
DECLARE Var_Descripcion	varchar(300);
DECLARE Var_MonedaID	int(11);
DECLARE Var_SucOrigen	int(5);
DECLARE Var_ConAho		int;
DECLARE Var_ConAhoIva	int;
DECLARE Var_Contador	int;



DECLARE CursorCobrosPen CURSOR FOR (

	select	Cob.ClienteID,		Cob.CuentaAhoID,	Cob.Fecha,			Cob.CantPenAct,		Cob.TipoMovAhoID,
			Cob.Transaccion,	Cue.SaldoDispon,	Cob.Descripcion,	Cli.PagaIVA,		case Cli.PagaIVA when 'S' then Suc.IVA else 0 end as PagaIVA,
			Cli.SucursalOrigen
		from	COBROSPEND	Cob,
				CUENTASAHO	Cue,
				CLIENTES	Cli,
				SUCURSALES 	Suc
		where 	Cob.CuentaAhoID = Cue.CuentaAhoID
		 and	Cob.ClienteID	= Cue.ClienteID
		 and	Cue.ClienteID	= Cli.ClienteID
		 and 	Cli.SucursalOrigen = Suc.SucursalID
		 and	Cob.Estatus 	= 'P'
		 and 	Cob.CantPenAct 	> 0.00
		 and 	Cue.SaldoDispon > 0.00
		order by Cob.ClienteID);



Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero	:= 0.0;
Set Est_Pendiente	:= 'P' ;
set	Nat_Cargo		:= 'C';
set	Nat_Abono		:= 'A';
set Var_SI			:= 'S';
set Var_NO			:= 'N';
set AltaPolizaSi	:= 'S';
set AltaEncPolizaSi	:= 'S';
set AltaEncPolizaNo	:= 'N';
set Salida_NO		:= 'N';
set Salida_SI		:= 'S';
Set	Act_PagoPend	:= 1;
Set Aud_ProgramaID  := 'COBROSPENDPRO';


set ConAhoComApe 	:= 5;
set ConAhoComAnual	:= 9;
set ConAhoComManCta	:= 7;
set ConAhoIvaApe	:= 6;
set ConAhoIvaAnual	:= 10;
set ConAhoIvaManCta	:= 8;
set ConAhoPasivo	:= 1;


set	Var_MovComAper	:= '206';
set	Var_MovComAniv	:= '208';
set	Var_MovComManC	:= '202';
set	Var_MovIvaAper	:= '207';
set	Var_MovIvaAniv	:= '209';
set	Var_MovIvaManC	:= '203';


Set	VarConcepConta	:= 200;
set Var_Descripcion := 'COBROS PENDIENTES ';


Set Aud_FechaActual	:= now();
Set Var_MonedaID	:= (select MonedaBaseID from PARAMETROSSIS);
Set Var_Contador 	:= 0;

Open  CursorCobrosPen;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO: Loop

		Fetch CursorCobrosPen  Into
			Var_ClienteID,		Var_CuentaAhoID,	Var_Fecha,			Var_CantPenAct,		Var_TipoMovAho,
			Var_Transaccion,	Var_SaldoDispon, 	Var_Descripcion,	Var_PagaIVA,		Var_IVA,
			Var_SucOrigen;

		Set Var_Contador 	:= Var_Contador	+1;
		set Var_SaldoDispon	:= (select SaldoDispon from CUENTASAHO where CuentaAhoID = Var_CuentaAhoID);

		Set Var_CuentaAhoID := ifnull(Var_CuentaAhoID,Entero_Cero );
		Set Var_CantPenAct 	:= ifnull(Var_CantPenAct,Decimal_Cero );
		Set Var_SaldoDispon := ifnull(Var_SaldoDispon,Decimal_Cero );
		Set Var_PagaIVA		:= ifnull(Var_PagaIVA,Var_NO );
		Set Var_IVA			:= ifnull(Var_IVA,Decimal_Cero );


		if	(Var_CuentaAhoID > Entero_Cero and Var_SaldoDispon > Decimal_Cero )then
			CASE Var_TipoMovAho
				WHEN Var_MovComAper THEN
					set Var_ConIvaMov	:= (select Descripcion from TIPOSMOVSAHO where	TipoMovAhoID = Var_MovIvaAper);
					set Var_TipoMovIva	:= Var_MovIvaAper;
					Set Var_ConAho		:= ConAhoComApe;
					Set Var_ConAhoIva	:= ConAhoIvaApe;
				WHEN Var_MovComAniv THEN
					set Var_ConIvaMov	:= (select Descripcion from TIPOSMOVSAHO where	TipoMovAhoID = Var_MovIvaAniv);
					set Var_TipoMovIva	:= Var_MovIvaAniv;
					Set Var_ConAho		:= ConAhoComAnual;
					Set Var_ConAhoIva	:= ConAhoIvaAnual;
				WHEN Var_MovComManC THEN
					set Var_ConIvaMov	:= (select Descripcion from TIPOSMOVSAHO where	TipoMovAhoID = Var_MovIvaManC);
					set Var_TipoMovIva	:= Var_MovIvaManC;
					Set Var_ConAho		:= ConAhoComManCta;
					Set Var_ConAhoIva	:= ConAhoIvaManCta;
			END CASE ;

			Set Var_CantPenCom	:= Var_CantPenAct + round(Var_CantPenAct * Var_IVA,2);


			if(Var_SaldoDispon >= Var_CantPenCom ) then
				Set Var_MontoCob 	:= Var_CantPenAct;
				if(Var_PagaIVA = Var_SI)then
					set Var_MontoCobIva := round(Var_CantPenAct * Var_IVA,2);
				else
					set Var_MontoCobIva := Decimal_Cero;
				end if;
			else
				if(Var_PagaIVA = Var_SI)then
					Set Var_MontoCob	:= round((Var_SaldoDispon - ((Var_SaldoDispon/(1+Var_IVA))*Var_IVA)),2);
					set Var_MontoCobIva := Var_SaldoDispon -  Var_MontoCob;
				else
					Set Var_MontoCob 	:= Var_SaldoDispon;
					set Var_MontoCobIva := Decimal_Cero;
				end if;
			end if;


			set Var_DesMov		:= concat('COBRO PENDIENTE-',Var_Fecha,':',Var_Descripcion);
			set Var_MontoCobIva := ifnull(Var_MontoCobIva,Decimal_Cero);


			if(Var_MontoCobIva>Decimal_Cero)then
				set Var_DesMovIVA		:= concat('COBRO PENDIENTE IVA-',Var_Fecha,':',Var_Descripcion);
			end if;

			Set Var_CantPenCom	:= Var_MontoCob+Var_MontoCobIva;


			if(Var_Contador = 1)then
				Set Var_Contador = Var_Contador + 1;
				call MAESTROPOLIZAALT(
					Par_Poliza,			Par_EmpresaID,	Par_FechaOperacion,		'A',				VarConcepConta,
					Var_Descripcion,	Salida_NO,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
			end if;

			set Var_AltaEncPol := AltaEncPolizaNo;


			call COBROSPENAPLICAPRO	(
				Var_ClienteID,		Var_CuentaAhoID,		Var_Fecha,			Par_FechaOperacion,		Var_Transaccion,
				Var_MontoCob,		Var_CantPenCom,			Var_MontoCobIva,	Var_DesMov,				Var_DesMovIVA,
				Var_TipoMovAho,		Var_TipoMovIva,			Var_MonedaID,		Var_SucOrigen,			VarConcepConta,
				Var_ConAho,			Var_ConAhoIva,			Var_AltaEncPol,		Salida_NO,				Par_NumErr,
				Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


			if(Par_NumErr <> Entero_Cero)then
				LEAVE CICLO;
			end if;
		end if;

		END Loop CICLO;
	END;
Close CursorCobrosPen;

if(Par_NumErr = Entero_Cero)then
	set	Par_NumErr := 0;
	set	Par_ErrMen := concat("Cobro Pendiente Aplicado.");
end if;

if (Par_Salida = Salida_SI ) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'cuentaAhoID' as control,
			Par_Poliza as consecutivo;
end if;

END TerminaStore$$