-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSINVERKUBOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSINVERKUBOCON`;DELIMITER $$

CREATE PROCEDURE `SALDOSINVERKUBOCON`(
	Par_ClienteID 		int,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint


	)
TerminaStore: BEGIN




DECLARE	InteresCobrado	decimal(12,4);
DECLARE	PagTotalRecib		decimal(12,4);
DECLARE	SaldoTotal		decimal(12,4);
DECLARE	NumEfecDisp		bigint;
DECLARE	SalEfecDisp		decimal(12,4);
DECLARE	NumInvProceso		int;
DECLARE	SalInvProceso		decimal(12,4);
DECLARE	NumInvActivas		int;
DECLARE	SalInvActivas		decimal(12,4);
DECLARE	NumTotInver		int;
DECLARE	NumInvActResum	int;
DECLARE	SalInvActResum	decimal(12,4);
DECLARE	NumErr		 	int(11);
DECLARE	ErrMen			varchar(40);
DECLARE	NumFondeoKubo		int;
DECLARE  Var_FecActual		date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Ent_Cero_Neg		int;
DECLARE	Decimal_Cero 		decimal(12,4);
DECLARE	EstatVigente		char(1);
DECLARE	EstatProceso		char(1);
DECLARE	EstatPagada		char(1);
DECLARE	EstatVencida		char(1);

DECLARE	GanAnuTotal 		decimal(12,4);
DECLARE	NumIntDeveng		int;
DECLARE	SalIntDeveng		decimal(12,4);
DECLARE	NumInvAtra1a15 	int;
DECLARE	SalInvAtra1a15	decimal(12,4);
DECLARE	NumInvAtra16a30	int;
DECLARE	SalInvAtra16a30	decimal(12,4);
DECLARE	NumInvAtra31a90	int;
DECLARE	SalInvAtra31a90	decimal(12,4);
DECLARE	NumInvVen91a120	int;
DECLARE	SalInvVen91a120	decimal(12,4);
DECLARE	NuInvVen120a180	int;
DECLARE	SaInvVen120a180	decimal(12,4);
DECLARE	CapitalCobrado	decimal(12,4);
DECLARE	NumCapCobrado		int;
DECLARE	MoraCobrado		decimal(12,4);
DECLARE	CFPagPagado		decimal(12,4);
DECLARE	Anter_DiaHab		date;
DECLARE	NumMorCobrado		int;
DECLARE	NumCFCobrado		int;
DECLARE	NumIntCobrado		int;


DECLARE	NumInvQuebrant	int;
DECLARE	SalInvQuebrant	decimal(12,4);
DECLARE	NumInvLiquidada	int;
DECLARE	SalInvLiquidada	decimal(12,4);



DECLARE CURSORINVKUBOCON CURSOR FOR
	select	FondeoKuboID,	MoratorioPagado,	ComFalPagPagada,	ifnull((ProvisionAcum-SaldoInteres),Entero_Cero)
		from FONDEOKUBO
		where (Estatus = 'N'
		  or  Estatus = 'V')
		and  ClienteID = Par_ClienteID;




Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Ent_Cero_Neg		:= -1;
Set 	Decimal_Cero		:= 0.0;
Set	EstatVigente		:= 'N';
Set	EstatProceso		:= 'F';
Set	EstatPagada		:= 'P';
Set	EstatVencida		:= 'V';
Set GanAnuTotal		:= 0.0;
Set NumInvAtra1a15	:= 0;
Set SalInvAtra1a15	:= 0.0;
Set NumInvAtra16a30	:= 0;
Set SalInvAtra16a30	:= 0.0;
Set NumInvAtra31a90	:= 0;
Set SalInvAtra31a90	:= 0.0;
Set NumInvVen91a120	:= 0;
Set SalInvVen91a120	:= 0.0;
Set NuInvVen120a180	:= 0;
Set SaInvVen120a180	:= 0.0;
Set SaldoTotal 		:= 0.0;

Set	NumInvQuebrant	:= 0;
Set SalInvQuebrant	:= 0.0;
Set	Anter_DiaHab		:= '';


select FechaSistema into Var_FecActual
	from PARAMETROSSIS;

if(not exists(select ClienteID
			from CLIENTES
			where ClienteID = Par_ClienteID)) then
		set 	NumErr := 1;
		set 	ErrMen :=  'El Numero de Cliente no existe.';

		select 	Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
				Entero_Cero,		Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,
				Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,		Entero_Cero,
				Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,		Decimal_Cero,
				Entero_Cero,		Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,
				Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,		Decimal_Cero,
				Entero_Cero,		Decimal_Cero,		Entero_Cero,		Decimal_Cero,		Entero_Cero,
				Decimal_Cero,		NumErr,			ErrMen;
else


				select	ifnull(sum(SaldoDispon),Entero_Cero),	ifnull(count(CuentaAhoID),Entero_Cero)
						into
						SalEfecDisp,		NumEfecDisp
					from 	CUENTASAHO
					where 	ClienteID = Par_ClienteID;


				Select	ifnull(count(SolicitudCreditoID),Entero_Cero), ifnull(SUM(MontoFondeo ),Entero_Cero)
						into
						NumInvProceso,	   		SalInvProceso
						from 	FONDEOSOLICITUD
						where 	Estatus = EstatProceso
						and 		ClienteID = Par_ClienteID;



				select	ifnull(count(FondeoKuboID),Entero_Cero), 	ifnull(sum(SaldoCapVigente + SaldoCapExigible),Entero_Cero),
						(ifnull(sum(MontoFondeo),Entero_Cero)- ifnull(sum(SaldoCapVigente + SaldoCapExigible),Entero_Cero)),
						ifnull(count(FondeoKuboID),Entero_Cero),	ifnull(sum(SaldoInteres),Entero_Cero)

						into
						NumInvActivas,		SalInvActivas,		CapitalCobrado,
						NumIntDeveng,			SalIntDeveng

					from FONDEOKUBO
					where Estatus= EstatVigente
					and	ClienteID = Par_ClienteID;




				OPEN CURSORINVKUBOCON;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;

					LOOP

					FETCH CURSORINVKUBOCON 	into
						NumFondeoKubo,	MoraCobrado,			CFPagPagado,	InteresCobrado;

					set NumCapCobrado 	:= 0;
					set NumMorCobrado 	:= 0;
					set NumCFCobrado		:= 0;
					set NumIntCobrado		:= 0;
						if((select ifnull(sum(MontoFondeo),Entero_Cero)- ifnull(sum(SaldoCapVigente + SaldoCapExigible),Entero_Cero)
								from FONDEOKUBO
								where Estatus	 = EstatVigente
								and	ClienteID = Par_ClienteID
								and FondeoKuboID=NumFondeoKubo) >Decimal_Cero)then
						set NumCapCobrado:= NumCapCobrado+1;
						else
						Set NumCapCobrado := NumCapCobrado;
						end if;
					if(select MoraCobrado > Decimal_Cero)then
						set NumMorCobrado:= NumMorCobrado+1;
						else
						Set NumMorCobrado := NumMorCobrado;
					end if;
					if(select CFPagPagado > Decimal_Cero)then
						set NumCFCobrado:= NumCFCobrado+1;
						else
						Set NumCFCobrado := NumCFCobrado;
					end if;
					if(select InteresCobrado > Decimal_Cero)then
						set NumIntCobrado:= NumIntCobrado+1;
						else
						Set NumIntCobrado := NumIntCobrado;
					end if;

					End LOOP;
				END;
				CLOSE CURSORINVKUBOCON;




				select  ifnull(sum(CapitalCobrado + InteresCobrado + MoraCobrado + CFPagPagado),Entero_Cero)
						into
						PagTotalRecib;


				select	ifnull(count(FondeoKuboID),Entero_Cero)+ NumInvProceso
						into
						NumTotInver
						from FONDEOKUBO
						where ClienteID 	= Par_ClienteID
						and	 (Estatus 	= EstatVigente
							or Estatus	= EstatPagada
							or Estatus 	= EstatVencida);


				select	ifnull(count(FondeoKuboID),Entero_Cero),	ifnull(sum(MontoFondeo),Entero_Cero)
						into
						NumInvLiquidada,	SalInvLiquidada
						from FONDEOKUBO
						where ClienteID = Par_ClienteID
						and	Estatus = EstatPagada;



				set SaldoTotal := ifnull(SalEfecDisp + SalInvProceso + SalInvActivas + SalIntDeveng,Entero_Cero);



				 call DIASHABILANTERCAL(
									Var_FecActual,	1,				Anter_DiaHab,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);



				select 	GAT,					sum(NumAtras1A15),	sum(SalAtras1A15),	sum(NumAtras16a30),	sum(SaldoAtras16a30),
						sum(NumAtras31a90),	sum(SalAtras31a90),	sum(NumVenc91a120),	sum(SalVenc91a120),	sum(NumVenc120a180),
						sum(SalVenc120a180)
						into
						GanAnuTotal,		NumInvAtra1a15,	SalInvAtra1a15,	NumInvAtra16a30,	SalInvAtra16a30,
						NumInvAtra31a90,	SalInvAtra31a90,	NumInvVen91a120,	SalInvVen91a120,	NuInvVen120a180,
						SaInvVen120a180
						from	 SALDOSINVKUBO
						where ClienteID 	 		= Par_ClienteID
						and FechaCorte 			= Anter_DiaHab;


				if(NumInvAtra1a15 >=0 or  NumInvAtra16a30 >=0 or NumInvAtra31a90 >=0 or NumInvVen91a120 >=0 or NuInvVen120a180 >=0) then

					select	(ifnull(count(FondeoKuboID),Entero_Cero)-NumInvAtra1a15-NumInvAtra16a30-NumInvAtra31a90-
							NumInvVen91a120-NuInvVen120a180),
							((SaldoCapVigente + SaldoCapExigible )-SalInvAtra1a15 -
							SalInvAtra16a30- SalInvAtra31a90-	SalInvVen91a120 - SaInvVen120a180)
							into
							NumInvActResum,
							SalInvActResum
						from FONDEOKUBO
						where Estatus= EstatVigente
						and	ClienteID = Par_ClienteID;
				end if;


				Set GanAnuTotal		:= ifnull(GanAnuTotal,Decimal_Cero);
				Set InteresCobrado	:= ifnull(InteresCobrado,Decimal_Cero);
				Set PagTotalRecib		:= ifnull(PagTotalRecib,Decimal_Cero);
				Set SaldoTotal		:= ifnull(SaldoTotal,Decimal_Cero);
				Set NumEfecDisp		:= ifnull(NumEfecDisp,Entero_Cero);
				Set SalEfecDisp 		:= ifnull(SalEfecDisp,Decimal_Cero);
				Set NumInvProceso 	:= ifnull(NumInvProceso,Entero_Cero);
				Set SalInvProceso 	:= ifnull(SalInvProceso,Decimal_Cero);
				Set NumInvActivas 	:= ifnull(NumInvActivas,Entero_Cero);
				Set SalInvActivas 	:= ifnull(SalInvActivas,Decimal_Cero);
				Set NumIntDeveng 		:= ifnull(NumIntDeveng,Entero_Cero);
				Set SalIntDeveng 		:= ifnull(SalIntDeveng,Decimal_Cero);
				Set NumTotInver 		:= ifnull(NumTotInver,Entero_Cero);
				Set NumInvActResum 	:= ifnull(NumInvActResum,Entero_Cero);
				Set SalInvActResum 	:= ifnull(SalInvActResum,Decimal_Cero);
				Set NumInvAtra1a15 	:= ifnull(NumInvAtra1a15,Entero_Cero);
				Set SalInvAtra1a15 	:= ifnull(SalInvAtra1a15,Decimal_Cero);
				Set NumInvAtra16a30	:= ifnull(NumInvAtra16a30,Entero_Cero);
				Set SalInvAtra16a30 	:= ifnull(SalInvAtra16a30,Decimal_Cero);
				Set NumInvAtra31a90 	:= ifnull(NumInvAtra31a90,Entero_Cero);
				Set SalInvAtra31a90 	:= ifnull(SalInvAtra31a90,Decimal_Cero);
				Set NumInvVen91a120 	:= ifnull(NumInvVen91a120,Entero_Cero);
				Set SalInvVen91a120 	:= ifnull(SalInvVen91a120,Decimal_Cero);
				Set NuInvVen120a180 	:= ifnull(NuInvVen120a180,Entero_Cero);
				Set SaInvVen120a180 	:= ifnull(SaInvVen120a180,Decimal_Cero);
				Set NumInvQuebrant 	:= ifnull(NumInvQuebrant,Entero_Cero);
				Set SalInvQuebrant 	:= ifnull(SalInvQuebrant,Decimal_Cero);
				Set NumInvLiquidada 	:= ifnull(SalInvQuebrant,Entero_Cero);
				Set SalInvLiquidada 	:= ifnull(SalInvQuebrant,Decimal_Cero);
				Set MoraCobrado 		:= ifnull(MoraCobrado,Decimal_Cero);
				Set InteresCobrado 	:= ifnull(InteresCobrado,Decimal_Cero);
				Set CapitalCobrado 	:= ifnull(CapitalCobrado,Decimal_Cero);
				Set CFPagPagado 		:= ifnull(CFPagPagado,Decimal_Cero);

				set 	NumErr := '000';
				set 	ErrMen := 'Consulta Exitosa';

				Select 	GanAnuTotal,				NumIntCobrado,			InteresCobrado,			PagTotalRecib,		SaldoTotal,
						NumEfecDisp,				SalEfecDisp,				NumInvProceso,			SalInvProceso	,		NumInvActivas,
						SalInvActivas,			NumIntDeveng,				SalIntDeveng,				NumTotInver,			NumInvActResum,
						SalInvActResum,			NumInvAtra1a15,			SalInvAtra1a15,			NumInvAtra16a30,		SalInvAtra16a30,
						NumInvAtra31a90,			SalInvAtra31a90,			NumInvVen91a120,			SalInvVen91a120,		NuInvVen120a180,
						SaInvVen120a180,			NumInvQuebrant,			SalInvQuebrant,			NumInvLiquidada,		SalInvLiquidada,
						NumCapCobrado,			CapitalCobrado,			NumMorCobrado,			MoraCobrado,			NumCFCobrado,
						CFPagPagado,				NumErr,					ErrMen;

	end if;

END TerminaStore$$