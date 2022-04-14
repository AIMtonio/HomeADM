-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEINVKUBOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEINVKUBOCON`;DELIMITER $$

CREATE PROCEDURE `DETALLEINVKUBOCON`(
	Par_ClienteID 		int,
	Par_NumCon			int,
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
DECLARE	NumEfecDisp		int;
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
DECLARE	NuInvVen121a180	int;
DECLARE	SaInvVen121a180	decimal(12,4);
DECLARE	CapitalCobrado	decimal(12,4);
DECLARE	NumCapCobrado		int;
DECLARE	MoraCobrado		decimal(12,4);
DECLARE	CFPagCobrado		decimal(12,4);
DECLARE	Anter_DiaHab		date;
DECLARE	NumMorCobrado		int;
DECLARE	NumCFCobrado		int;
DECLARE	NumIntCobrado		int;
DECLARE	TasaPonderada		decimal(12,4);
DECLARE	Impuestos		decimal(12,4);
DECLARE	ComisPagadas		decimal(12,4);
DECLARE	Depositos		int;
DECLARE	InverRealiz		int;
DECLARE	PagCapRecib		int;
DECLARE	IntOrdRec		int;
DECLARE	IntMoraRec		int;
DECLARE	RecupMorosos		int;
DECLARE	ISRretenido		int;
DECLARE	ComisCobrad		int;
DECLARE	ComisPagad		int;
DECLARE	Ajustes			int;
DECLARE	Quebrantos		int;
DECLARE	QuebranXapli		int;
DECLARE	PremiosRecom		int;



DECLARE	NumInvQuebrant	int;
DECLARE	SalInvQuebrant	decimal(12,4);
DECLARE	NumInvLiquidada	int;
DECLARE	SalInvLiquidada	decimal(12,4);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero 		decimal(12,4);
DECLARE	EstatVigente		char(1);
DECLARE	EstatProceso		char(1);
DECLARE	EstatPagada		char(1);
DECLARE	EstatVencida		char(1);
DECLARE	ConDetalleInv		int;
DECLARE	LisCalifPorc		int;
DECLARE	LisPlazosPorc		int;
DECLARE	LisTasaPonXcal	int;


DECLARE	DecimalCien		decimal(12,4);


DECLARE	NumCredito		int;
DECLARE	NumInvCal		int;


DECLARE CURSORINVKUBOCON CURSOR FOR
	select	FondeoKuboID,	 ifnull(sum(MoratorioPagado),Entero_Cero),	ifnull(sum(ComFalPagPagada),Entero_Cero),
			ifnull(sum(ProvisionAcum-SaldoInteres),Entero_Cero)
		from FONDEOKUBO
		where (Estatus = 'N'
		  or  Estatus = 'V')
		and  ClienteID = Par_ClienteID;





Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
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
Set NuInvVen121a180	:= 0;
Set SaInvVen121a180	:= 0.0;

Set	NumInvQuebrant	:= 0;
Set SalInvQuebrant	:= 0.0;
Set	Anter_DiaHab		:= '';
set NumCapCobrado 	:= 0;
Set DecimalCien		:= 100.0;
Set ConDetalleInv 	:= 3;
Set LisCalifPorc		:= 4;
Set LisPlazosPorc		:= 5;
Set LisTasaPonXcal	:= 6;
Set ComisPagadas		:= 0.0;

Set 	Depositos		:= 0;
Set 	InverRealiz		:= 0;
Set 	PagCapRecib		:= 0;
Set 	IntOrdRec		:= 0;
Set 	IntMoraRec		:= 0;
Set 	RecupMorosos		:= 0;
Set 	ISRretenido		:= 0;
Set 	ComisCobrad		:= 0;
Set 	ComisPagad		:= 0;
Set 	Ajustes			:= 0;
Set 	Quebrantos		:= 0;
Set 	QuebranXapli		:= 0;
Set 	PremiosRecom		:= 0;

select FechaSistema into Var_FecActual
	from PARAMETROSSIS;

if (Par_NumCon = ConDetalleInv) then


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
							ifnull(count(FondeoKuboID),Entero_Cero),	ifnull(sum(SaldoInteres),Entero_Cero),
							ifnull(sum(IntOrdRetenido+IntMorRetenido+ComFalPagRetenido),Entero_Cero)

							into
							NumInvActivas,		SalInvActivas,
							CapitalCobrado,
							NumIntDeveng,			SalIntDeveng,
							Impuestos

					from FONDEOKUBO
					where Estatus= EstatVigente
					and	ClienteID = Par_ClienteID;


			OPEN CURSORINVKUBOCON;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;

					LOOP

					FETCH CURSORINVKUBOCON 	into
						NumFondeoKubo,	MoraCobrado,	CFPagCobrado,		InteresCobrado;

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
					if(select CFPagCobrado > Decimal_Cero)then
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


					select  ifnull(sum(CapitalCobrado + InteresCobrado + MoraCobrado + CFPagCobrado),Entero_Cero)
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







					 call DIASHABILANTERCAL(
										Var_FecActual,	1,				Anter_DiaHab,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);



					select 	sum(NumAtras1A15),	sum(SalAtras1A15),	sum(NumAtras16a30),	sum(SaldoAtras16a30),	sum(NumAtras31a90),
							sum(SalAtras31a90),	sum(NumVenc91a120),	sum(SalVenc91a120),	sum(NumVenc120a180),	sum(SalVenc120a180)
							into
							NumInvAtra1a15,		SalInvAtra1a15,		NumInvAtra16a30,		SalInvAtra16a30,		NumInvAtra31a90,
							SalInvAtra31a90,		NumInvVen91a120,		SalInvVen91a120,		NuInvVen121a180,		SaInvVen121a180
						from	 SALDOSINVKUBO
						where ClienteID 	 		= Par_ClienteID
						and FechaCorte 			= Anter_DiaHab;


					select	ifnull(sum(FSol.TasaPasiva)/ count(Fon.FondeoKuboID),Entero_Cero)
							into
							TasaPonderada
						FROM		FONDEOKUBO Fon,
								FONDEOSOLICITUD FSol
						where  FSol.SolicitudCreditoID = Fon.SolicitudCreditoID
						and Fon.ClienteID = FSol.ClienteID
						and Fon.ClienteID = Par_ClienteID;


					if(NumInvAtra1a15 >=0 or  NumInvAtra16a30 >=0 or NumInvAtra31a90 >=0 or NumInvVen91a120 >=0 or NuInvVen121a180 >=0) then

					select	(ifnull(count(FondeoKuboID),Entero_Cero)-NumInvAtra1a15-NumInvAtra16a30-NumInvAtra31a90-
							NumInvVen91a120-NuInvVen121a180),
							((SaldoCapVigente + SaldoCapExigible )-SalInvAtra1a15 -
							SalInvAtra16a30- SalInvAtra31a90-	SalInvVen91a120 - SaInvVen121a180)
							into
							NumInvActResum,
							SalInvActResum
						from FONDEOKUBO
						where Estatus= EstatVigente
						and	ClienteID = Par_ClienteID;
						if(SalInvActResum< Decimal_Cero) then
							set SalInvActResum := Decimal_Cero;
						end if;
					end if;


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
					Set NuInvVen121a180 	:= ifnull(NuInvVen121a180,Entero_Cero);
					Set SaInvVen121a180 	:= ifnull(SaInvVen121a180,Decimal_Cero);
					Set NumInvQuebrant 	:= ifnull(NumInvQuebrant,Entero_Cero);
					Set SalInvQuebrant 	:= ifnull(SalInvQuebrant,Decimal_Cero);
					Set NumInvLiquidada 	:= ifnull(SalInvQuebrant,Entero_Cero);
					Set SalInvLiquidada 	:= ifnull(SalInvQuebrant,Decimal_Cero);
					Set MoraCobrado 		:= ifnull(MoraCobrado,Decimal_Cero);
					Set InteresCobrado 	:= ifnull(InteresCobrado,Decimal_Cero);
					Set CapitalCobrado 	:= ifnull(CapitalCobrado,Decimal_Cero);
					Set CFPagCobrado 		:= ifnull(CFPagCobrado,Decimal_Cero);



					set 	NumErr := '000';
					set 	ErrMen := 'Consulta Exitosa';

					Select 	NumTotInver,		NumInvProceso,	SalInvProceso	,				NumInvActResum,	SalInvActResum,
							NumInvAtra1a15,	SalInvAtra1a15,	NumInvAtra16a30,				SalInvAtra16a30,	NumInvAtra31a90,
							SalInvAtra31a90,	NumInvVen91a120,	SalInvVen91a120,				NuInvVen121a180,	SaInvVen121a180,
							NumInvQuebrant,	SalInvQuebrant,	NumInvLiquidada,				SalInvLiquidada,	TasaPonderada,
							NumIntDeveng,		SalIntDeveng,		NumCapCobrado as NumPagTotRec,	PagTotalRecib,	NumCapCobrado,
							CapitalCobrado,	NumIntCobrado,	InteresCobrado,				NumMorCobrado,	MoraCobrado,
							Impuestos,		ComisPagadas,		NumCFCobrado,					CFPagCobrado,		NumEfecDisp,
							SalEfecDisp,		NumInvActivas,	SalInvActivas,				NumIntDeveng,		SalIntDeveng,
							Depositos,		InverRealiz,		PagCapRecib,					IntOrdRec,		IntMoraRec,
							RecupMorosos,		ISRretenido,		ComisCobrad,					ComisPagad,		Ajustes,
							Quebrantos,		QuebranXapli,		PremiosRecom,					NumErr,			ErrMen;

	end if;
end if;


if (Par_NumCon = LisCalifPorc) then

		set	NumTotInver := (select count(Fon.FondeoKuboID)
							FROM SOLICITUDCREDITO Sol,
							FONDEOKUBO Fon
							where Fon.CreditoID = Sol.CreditoID
							and Fon.ClienteID = Par_ClienteID);
		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';

		select	Sol.Calificacion,	 count(Fon.FondeoKuboID),	count(Fon.FondeoKuboID)/(NumTotInver/DecimalCien),
				NumErr,			 ErrMen
			FROM SOLICITUDCREDITO Sol,
				FONDEOKUBO Fon
			where Fon.CreditoID = Sol.CreditoID
			and Fon.ClienteID = Par_ClienteID
			group by  Sol.Calificacion ;

end if;



if (Par_NumCon = LisPlazosPorc) then

		set	NumTotInver := (select count(Fon.FondeoKuboID)
							FROM SOLICITUDCREDITO Sol,
							FONDEOKUBO Fon
							where Fon.CreditoID = Sol.CreditoID
							and Fon.ClienteID = Par_ClienteID);

		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';

		select	Sol.Plazo,	count(Fon.FondeoKuboID),	count(Fon.FondeoKuboID)/(NumTotInver/DecimalCien),
				NumErr,		ErrMen
			FROM SOLICITUDCREDITO Sol,
				FONDEOKUBO Fon
			where Fon.CreditoID = Sol.CreditoID
			and Fon.ClienteID = Par_ClienteID
			group by  Sol.Plazo ;

end if;

if (Par_NumCon = LisTasaPonXcal) then

			set 	NumErr := '000';
			set 	ErrMen := 'Consulta Exitosa';

			select	Sol.Calificacion, 	sum(FSol.TasaPasiva)/count(Sol.SolicitudCreditoID),
			NumErr,	ErrMen
			FROM SOLICITUDCREDITO Sol,
				FONDEOKUBO Fon,
				FONDEOSOLICITUD FSol
			where Fon.CreditoID = Sol.CreditoID
			and FSol.SolicitudCreditoID = Fon.SolicitudCreditoID
			and Fon.SolicitudCreditoID = Sol.SolicitudCreditoID
			and Fon.ClienteID = FSol.ClienteID
			and Fon.ClienteID = Par_ClienteID
			group by  Sol.Calificacion ;


end if;

END TerminaStore$$