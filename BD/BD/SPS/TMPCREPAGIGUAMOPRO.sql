-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREPAGIGUAMOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCREPAGIGUAMOPRO`;DELIMITER $$

CREATE PROCEDURE `TMPCREPAGIGUAMOPRO`(


	Par_Monto			decimal(12,2),
	Par_Tasa				decimal(12,4),
	Par_Frecu			int,
	Par_FrecuInt			int,
	Par_PagoCuota			char(1),
	Par_PagoInter			char(1),
	Par_PagoFinAni		char(1),
	Par_PagoFinAniInt		char(1),
	Par_FechaInicio		date	,
	Par_FechaVenc			date	,
	Par_ProducCreditoID	int,
	Par_ClienteID			int,
	Par_DiaHabilSig		char(1),
	Par_AjustaFecAmo		char(1),
	Par_AjusFecExiVen		char (1),
	Par_DiaMesInt			int,
	Par_DiaMesCap			int,


	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint	,
	out Out_FecFin date,
	out Out_FecVig date,
	out Out_Cuotas int,
	out Out_NumTransaccion bigint (20)
	)
TerminaStore: BEGIN



DECLARE Decimal_Cero		decimal(12,2);
DECLARE Entero_Cero		int;
DECLARE Entero_Negativo	int;
DECLARE Var_SI			char(1);
DECLARE Var_No			char(1);
DECLARE PagoSemanal		char(1);
DECLARE PagoCatorcenal	char(1);
DECLARE PagoQuincenal		char(1);
DECLARE PagoMensual		char(1);
DECLARE PagoPeriodo		char(1);
DECLARE PagoBimestral		char(1);
DECLARE PagoTrimestral	char(1);
DECLARE PagoTetrames		char(1);
DECLARE PagoSemestral		char(1);
DECLARE PagoAnual			char(1);
DECLARE PagoFinMes		char(1);
DECLARE PagoAniver		char(1);
DECLARE FrecSemanal		int;
DECLARE FrecCator			int;
DECLARE FrecQuin			int;
DECLARE FrecMensual		int;
DECLARE FrecBimestral		int;
DECLARE FrecTrimestral	int;
DECLARE FrecTetrames		int;
DECLARE FrecSemestral		int;
DECLARE FrecAnual			int;
DECLARE Var_Capital		char(1);
DECLARE Var_Interes		char(1);
DECLARE Var_CapInt		char(1);


declare Var_UltDia		int;
DECLARE Contador			int;
DECLARE Consecutivo		int;
DECLARE ContadorInt		int;
DECLARE ContadorCap		int;
DECLARE FechaInicio		date;
DECLARE FechaFinal		date;
DECLARE FechaInicioInt	date;
DECLARE FechaFinalInt		date;
DECLARE FechaVig			date;
DECLARE Var_EsHabil		char(1);
DECLARE Var_Cuotas		int;
DECLARE Var_CuotasInt		int;
DECLARE Var_Amor			int;
DECLARE Capital			decimal(12,2);
DECLARE Interes			decimal(12,4);
DECLARE IvaInt			decimal(12,4);
DECLARE Subtotal			decimal(12,2);
DECLARE Insoluto			decimal(12,2);
DECLARE Var_IVA			decimal(12,4);
DECLARE Fre_DiasAnio		int;
DECLARE Fre_Dias			int;
DECLARE Fre_DiasTab		int;
DECLARE Fre_DiasInt		int;
DECLARE Fre_DiasIntTab		int;
DECLARE Var_GraciaFaltaPago	int;
DECLARE Var_ProCobIva		char(1);
DECLARE Var_CtePagIva		char(1);
DECLARE Var_PagaIVA		char(1);
DECLARE CapInt			char(1);
declare Var_InteresAco		decimal(12,4);
declare Var_IvaAco		decimal(12,4);


set Decimal_Cero		:= 0.00;
set Entero_Cero		:= 0;
set Entero_Negativo	:= -1;
set Var_SI			:= 'S';
set Var_No			:= 'N';
set PagoSemanal		:= 'S';
set PagoCatorcenal	:= 'C';
set PagoQuincenal		:= 'Q';
set PagoMensual		:= 'M';
set PagoPeriodo		:= 'P';
set PagoBimestral		:= 'B';
set PagoTrimestral	:= 'T';
set PagoTetrames		:= 'R';
set PagoSemestral		:= 'E';
set PagoAnual			:= 'A';
set PagoFinMes		:= 'F';
set PagoAniver		:= 'A';
set FrecSemanal		:= 7;
set FrecCator			:= 14;
set FrecQuin			:= 15;
set FrecMensual		:= 30;

set FrecBimestral		:= 60;
set FrecTrimestral	:= 90;
set FrecTetrames		:= 120;
set FrecSemestral		:= 180;
set FrecAnual			:= 360;
set Var_Capital		:= 'C';
set Var_Interes		:= 'I';
set Var_CapInt		:= 'G';


set Contador			:= 1;
set ContadorInt		:= 1;
set FechaInicio		:= Par_FechaInicio;
set FechaInicioInt	:= Par_FechaInicio;
set Var_IVA			:= (select IVA from SUCURSALES where SucursalID = Aud_Sucursal);
set Fre_DiasAnio		:= (select DiasCredito from PARAMETROSSIS);


select GraciaFaltaPago,  CobraIVAInteres into Var_GraciaFaltaPago,  Var_ProCobIva
	from PRODUCTOSCREDITO
	where ProducCreditoID = Par_ProducCreditoID;


select PagaIVA into Var_CtePagIva
	from CLIENTES
	where ClienteID = Par_ClienteID;

if (Var_ProCobIva = Var_Si) then
	if (Var_CtePagIva = Var_Si) then
		set Var_PagaIVA		:= Var_Si;
	end if;
else
	set Var_PagaIVA		:= Var_No;
end if;


if (Par_PagoCuota = PagoQuincenal ) then set Fre_Dias :=  FrecQuin; else
	if (Par_PagoCuota = PagoCatorcenal ) then set Fre_Dias :=  FrecCator; else
		if (Par_PagoCuota = PagoSemanal ) then set Fre_Dias :=  FrecSemanal; else
			if (Par_PagoCuota = PagoPeriodo) then set Fre_Dias :=  Par_Frecu; else
				if (Par_PagoCuota = PagoMensual ) then set Fre_Dias :=  FrecMensual; else
					if (Par_PagoCuota = PagoBimestral ) then set Fre_Dias :=  FrecBimestral; else
						if (Par_PagoCuota = PagoTrimestral ) then set Fre_Dias	:=  FrecTrimestral; else
							if (Par_PagoCuota = PagoTetrames ) then set Fre_Dias :=  FrecTetrames; else
								if (Par_PagoCuota = PagoSemestral ) then set Fre_Dias :=  FrecSemestral; else
									if (Par_PagoCuota = PagoAnual ) then set Fre_Dias :=  FrecAnual; end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;


if ( Par_PagoInter = PagoQuincenal) then set Fre_DiasInt :=  FrecQuin; else
	if ( Par_PagoInter = PagoCatorcenal) then set Fre_DiasInt :=  FrecCator; else
		if ( Par_PagoInter = PagoSemanal) then set Fre_DiasInt :=  FrecSemanal; else
			if ( Par_PagoInter = PagoPeriodo) then set Fre_DiasInt :=  Par_FrecuInt; else
				if (Par_PagoInter = PagoMensual) then set Fre_DiasInt :=  FrecMensual; else
					if (Par_PagoInter = PagoBimestral) then set Fre_DiasInt :=  FrecBimestral; else
						if (Par_PagoInter = PagoTrimestral) then set Fre_DiasInt :=  FrecTrimestral; else
							if (Par_PagoInter = PagoTetrames) then set Fre_DiasInt	:=  FrecTetrames; else
								if (Par_PagoInter = PagoSemestral) then set Fre_DiasInt :=  FrecSemestral; else
									if (Par_PagoInter = PagoAnual) then 	set Fre_DiasInt :=  FrecAnual; end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;


set Var_Cuotas:=convert(DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_Dias,unsigned);
set Var_CuotasInt:=convert(DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_DiasInt,unsigned);
set Capital	:= Par_Monto / Var_Cuotas;
set Insoluto	:= Par_Monto;


CREATE TEMPORARY TABLE Tmp_Amortizacion(
	Tmp_Consecutivo	int,
	Tmp_Dias			int,
	Tmp_FecIni		date,
	Tmp_FecFin		date,
	Tmp_FecVig		date,
	Tmp_Capital		decimal(12,2),
	Tmp_Interes		decimal(12,4),
	Tmp_iva			decimal(12,4),
	Tmp_SubTotal		decimal(12,2),
	Tmp_Insoluto		decimal(12,2),
	Tmp_CapInt		char(1),
	Tmp_InteresAco 	decimal(12,2),
    PRIMARY KEY  (Tmp_Consecutivo));


CREATE TEMPORARY TABLE Tmp_AmortizacionInt(
	Tmp_Consecutivo	int,
	Tmp_Dias			int,
	Tmp_FecIni		date,
	Tmp_FecFin		date,
	Tmp_FecVig		date,
	Tmp_Capital		decimal(12,2),
	Tmp_Interes		decimal(12,4),
	Tmp_iva			decimal(12,4),
	Tmp_SubTotal		decimal(12,2),
	Tmp_Insoluto		decimal(12,2),
	Tmp_CapInt		char(1),
	Tmp_InteresAco 	decimal(12,2),
    PRIMARY KEY  (Tmp_Consecutivo));


while (Contador <= Var_Cuotas) do

	if (Par_PagoCuota = PagoQuincenal) then
		if ((convert(day(FechaInicio),unsigned)*1) = FrecQuin) then
			set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
		else
			if ((convert(day(FechaInicio),unsigned)*1) >28) then
				set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
									convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , '15'),date);
			else
				set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL day(FechaInicio) day), INTERVAL FrecQuin DAY);
				if  (FechaFinal <= FechaInicio) then
					set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , '15'),date);
				end	if;
			end if;
		end if;
	else

		if (Par_PagoCuota = PagoMensual) then

			if (Par_PagoFinAni = PagoAniver) then
				if(Par_DiaMesCap>28)then
					set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
					set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
					if(Var_UltDia < Par_DiaMesCap)then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

					else
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
					end if;
				else
					set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
				end if;
			else

				if (Par_PagoFinAni = PagoFinMes) then
					if ((convert(day(FechaInicio),unsigned)*1)>=28)then
						set FechaFinal := convert(DATE_ADD(FechaInicio, interval 2 month),char(12));
						set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
					else

						set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
					end if;
				end if;
			end if;
		else
			if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
				set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
			else
				if (Par_PagoCuota = PagoBimestral ) then
					if (Par_PagoFinAni = PagoAniver ) then
						if(Par_DiaMesCap>28)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
							if(Var_UltDia < Par_DiaMesCap)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' ,Var_UltDia),date);

							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMesCap),date);
							end if;
						else
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMesCap),date);
						end if;
					else

						if (Par_PagoFinAni = PagoFinMes) then
							if ((convert(day(FechaInicio),unsigned)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
							else
								set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoTrimestral ) then

						if (Par_PagoFinAni = PagoAniver) then

							if(Par_DiaMesCap>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
								if(Var_UltDia < Par_DiaMesCap)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMesCap),date);
								end if;
							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMesCap),date);
							end if;

						else

							if (Par_PagoFinAni = PagoFinMes) then
								if ((convert(day(FechaInicio),unsigned)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
								else
									set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY),char(12));
								end if;
							end if;
						end if;

					else
						if (Par_PagoCuota = PagoTetrames ) then

							if (Par_PagoFinAni = PagoAniver) then
								if(Par_DiaMesCap>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
									if(Var_UltDia < Par_DiaMesCap)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMesCap),date);
									end if;
								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMesCap),date);
								end if;
							else

								if (Par_PagoFinAni = PagoFinMes) then
									if ((convert(day(FechaInicio),unsigned)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
									else
										set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY),char(12));
									end if;
								end if;
							end if;

						else
							if (Par_PagoCuota = PagoSemestral ) then

								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMesCap>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
										if(Var_UltDia < Par_DiaMesCap)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' ,Var_UltDia),date);

										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMesCap),date);
										end if;
									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMesCap),date);
									end if;

								else

									if (Par_PagoFinAni = PagoFinMes) then
										if ((convert(day(FechaInicio),unsigned)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
										else
											set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if (Par_PagoCuota = PagoAnual ) then

									set FechaFinal 	:= convert(DATE_ADD(FechaInicio, interval 1 year),char(12));
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;

	if(Par_DiaHabilSig = Var_SI) then
		call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	else
		call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	end if;


	while ((convert(datediff(FechaVig, FechaInicio),unsigned)*1) <= Var_GraciaFaltaPago ) do
		if (Par_PagoCuota = PagoQuincenal ) then
			if ((convert(day(FechaFinal),unsigned)*1) = FrecQuin) then
				set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
			else
				if ((convert(day(FechaFinal),unsigned)*1) >28) then
					set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
										convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , '15'),date);
				else
					set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL day(FechaFinal) day), INTERVAL FrecQuin DAY);
					if  (FechaFinal <= FechaInicio) then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , '15'),date);
					end	if;
				end if;
			end if;
		else

			if (Par_PagoCuota = PagoMensual  ) then
				if (Par_PagoFinAni = PagoAniver) then
					if(Par_DiaMesCap>28)then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
						set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
						if(Var_UltDia < Par_DiaMesCap)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

						else
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
						end if;
					else
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
					end if;
				else

					if (Par_PagoFinAni = PagoFinMes) then
						if ((convert(day(FechaFinal),unsigned)*1)>=28)then
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
						else

							set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY),char(12));
						end if;
					end if;
				end if ;
			else
				if ( Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
					set FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
				end if;
			end if;
		end if;
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		end if;
	end while;


	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
			set Contador = Var_Cuotas+1;
			set FechaFinal 	:= Par_FechaVenc;
		end if;
		if (Contador = Var_Cuotas )then
			set FechaFinal 	:= Par_FechaVenc;
		end if;
	end if;

	if(Par_DiaHabilSig = Var_SI) then
		call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	else
		call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	end if;


	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinal:= FechaVig;
	end if;

	set CapInt:= Var_Capital;

	set Consecutivo := (select ifnull(Max(Tmp_Consecutivo),Entero_Cero) + 1
					from Tmp_Amortizacion);

	set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

	INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
					values	(	Consecutivo,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);
	set FechaInicio := FechaFinal;

	if((Contador+1) = Var_Cuotas )then



		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinal 	:= Par_FechaVenc;
		else

			if (Par_PagoCuota = PagoQuincenal) then
				if ((convert(day(FechaInicio),unsigned)*1) = FrecQuin) then
					set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
				else
					if ((convert(day(FechaInicio),unsigned)*1) >28) then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , '15'),date);
					else
						set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL day(FechaInicio) day), INTERVAL FrecQuin DAY);
						if  (FechaFinal <= FechaInicio) then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , '15'),date);
						end	if;
					end if;
				end if;
			else
				if (Par_PagoCuota = PagoMensual) then

					if (Par_PagoFinAni = PagoAniver) then
						if(Par_DiaMesCap>28)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
							if(Var_UltDia < Par_DiaMesCap)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);
							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
							end if;
						else
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
						end if;
					else

						if (Par_PagoFinAni = PagoFinMes) then
							if ((convert(day(FechaInicio),unsigned)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 2 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
							else

								set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
						set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
					else
						if (Par_PagoCuota = PagoBimestral ) then
							if (Par_PagoFinAni = PagoAniver ) then
								if(Par_DiaMesCap>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
									if(Var_UltDia < Par_DiaMesCap)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' ,Var_UltDia),date);

									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMesCap),date);
									end if;
								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMesCap),date);
								end if;
							else

								if (Par_PagoFinAni = PagoFinMes) then
									if ((convert(day(FechaInicio),unsigned)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
									else
										set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoCuota = PagoTrimestral ) then

								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMesCap>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
										if(Var_UltDia < Par_DiaMesCap)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMesCap),date);
										end if;
									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMesCap),date);
									end if;
								else

									if (Par_PagoFinAni = PagoFinMes) then
										if ((convert(day(FechaInicio),unsigned)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
										else
											set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY),char(12));
										end if;
									end if;
								end if;

							else
								if (Par_PagoCuota = PagoTetrames ) then

									if (Par_PagoFinAni = PagoAniver) then
										if(Par_DiaMesCap>28)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
											set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
											if(Var_UltDia < Par_DiaMesCap)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

											else
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMesCap),date);
											end if;
										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMesCap),date);
										end if;
									else

										if (Par_PagoFinAni = PagoFinMes) then
											if ((convert(day(FechaInicio),unsigned)*1)>=28)then
												set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
												set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
											else
												set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY),char(12));
											end if;
										end if;
									end if;

								else
									if (Par_PagoCuota = PagoSemestral ) then

										if (Par_PagoFinAni = PagoAniver) then
											if(Par_DiaMesCap>28)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
												set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
												if(Var_UltDia < Par_DiaMesCap)then
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' ,Var_UltDia),date);

												else
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMesCap),date);
												end if;
											else
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMesCap),date);
											end if;
										else

											if (Par_PagoFinAni = PagoFinMes) then
												if ((convert(day(FechaInicio),unsigned)*1)>=28)then
													set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
													set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
												else
													set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY),char(12));
												end if;
											end if;
										end if;

									else
										if (Par_PagoCuota = PagoAnual ) then

											set FechaFinal 	:= convert(DATE_ADD(FechaInicio, interval 1 year),char(12));
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;

			if(Par_DiaHabilSig = Var_SI) then
				call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			else
				call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			end if;

			while ((datediff(FechaVig, FechaInicio)*1) <= Var_GraciaFaltaPago ) do
				if (Par_PagoCuota = PagoQuincenal ) then
					if ((convert(day(FechaFinal),unsigned)*1) = FrecQuin) then
						set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
					else
						if ((convert(day(FechaFinal),unsigned)*1) >28) then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , '15'),date);
						else
							set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL day(FechaFinal) day), INTERVAL FrecQuin DAY);
							if  (FechaFinal <= FechaInicio) then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , '15'),date);
							end	if;
						end if;
					end if;
				else

					if (Par_PagoCuota = PagoMensual  ) then
						if (Par_PagoFinAni = PagoAniver) then
							if(Par_DiaMesCap>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
								if(Var_UltDia < Par_DiaMesCap)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
								end if;
							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMesCap),date);
							end if;
						else

							if (Par_PagoFinAni = PagoFinMes) then
								if ((convert(day(FechaFinal),unsigned)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
								else

									set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY),char(12));
								end if;
							end if;
						end if ;
					else
						if ( Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
							set FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
						end if;
					end if;
				end if;
				if(Par_DiaHabilSig = Var_SI) then
					call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);

				else
					call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				end if;
			end while;
		end if;

		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

		else
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		end if;

		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinal:= FechaVig;
		end if;
		set CapInt:= Var_Capital;
		set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
		INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
					values	(	Consecutivo+1,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);
		set Contador = Contador+1;
	end if;
	set Contador = Contador+1;
end while;


while (ContadorInt <= Var_CuotasInt ) do

	if (Par_PagoInter = PagoQuincenal) then
		if ((convert(day(FechaInicioInt),unsigned)*1) = FrecQuin) then
			set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
		else
			if ((convert(day(FechaInicioInt),unsigned)*1) >28) then
				set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
									convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
			else
				set FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL day(FechaInicioInt) day), INTERVAL FrecQuin DAY);
				if  (FechaFinalInt <= FechaInicioInt) then
					set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
				end	if;
			end if;
		end if;
	else

		if (Par_PagoInter = PagoMensual) then

			if (Par_PagoFinAniInt = PagoAniver) then
				if(Par_DiaMesInt>28)then
					set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , 28),date);
					set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
					if(Var_UltDia < Par_DiaMesInt)then
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);
					else
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
					end if;
				else
					set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
				end if;
			else

				if (Par_PagoFinAniInt = PagoFinMes) then
					if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
						set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 2 month),char(12));
						set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
					else

						set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY),char(12));
					end if;
				end if;
			end if;
		else
			if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal ) then
				set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
			else
				if ( Par_PagoInter = PagoBimestral) then

					if (Par_PagoFinAniInt = PagoAniver ) then
						if(Par_DiaMesInt>28)then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
							if(Var_UltDia < Par_DiaMesInt)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' ,Var_UltDia),date);

							else
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , Par_DiaMesInt),date);
							end if;
						else
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , Par_DiaMesInt),date);
						end if;
					else

						if (Par_PagoFinAniInt = PagoFinMes) then
							if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
							else
								set FechaFinalInt	:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 2 month), interval -1 * day(FechaInicioInt) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoInter = PagoTrimestral) then

						if (Par_PagoFinAniInt = PagoAniver) then
							if(Par_DiaMesInt>28)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' ,  28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
								if(Var_UltDia < Par_DiaMesInt)then
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

								else
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Par_DiaMesInt),date);
								end if;
							else
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Par_DiaMesInt),date);
							end if;
						else

							if (Par_PagoFinAniInt = PagoFinMes) then
								if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
								else
									set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 3 month), interval -1 * day(FechaInicioInt) DAY),char(12));
								end if;
							end if;
						end if;
					else
						if ( Par_PagoInter = PagoTetrames) then

							if (Par_PagoFinAniInt = PagoAniver) then
								if(Par_DiaMesInt>28)then
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
									if(Var_UltDia < Par_DiaMesInt)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

									else
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Par_DiaMesInt),date);
									end if;
								else
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Par_DiaMesInt),date);
								end if;
							else

								if (Par_PagoFinAniInt = PagoFinMes) then
									if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
									else
										set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 4 month), interval -1 * day(FechaInicioInt) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoInter = PagoSemestral) then

								if (Par_PagoFinAniInt = PagoAniver) then
									if(Par_DiaMesInt>28)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
										if(Var_UltDia < Par_DiaMesInt)then
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Var_UltDia),date);

										else
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Par_DiaMesInt),date);
										end if;
									else
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Par_DiaMesInt),date);
									end if;
								else

									if (Par_PagoFinAniInt = PagoFinMes) then
										if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
										else
											set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 6 month), interval -1 * day(FechaInicioInt) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if ( Par_PagoInter = PagoAnual) then

									set FechaFinalInt	:= convert(DATE_ADD(FechaInicioInt, interval 1 year),char(12));
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;

	if(Par_DiaHabilSig = Var_SI) then
		call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	else
		call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	end if;


	while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPago ) do
		if (Par_PagoInter = PagoQuincenal ) then
			if ((convert(day(FechaFinalInt),unsigned)*1) = FrecQuin) then
				set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
			else
				if ((convert(day(FechaFinalInt),unsigned)*1) >28) then
					set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
										convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , '15'),date);
				else
					set FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL day(FechaFinalInt) day), INTERVAL FrecQuin DAY);
					if  (FechaFinalInt <= FechaInicioInt) then
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
					end	if;
				end if;
			end if;
		else

			if (Par_PagoInter = PagoMensual  ) then
				if (Par_PagoFinAniInt = PagoAniver) then
					if(Par_DiaMesInt>28)then
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , 28),date);
						set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
						if(Var_UltDia < Par_DiaMesInt)then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

						else
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
						end if;
					else
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
					end if;
				else

					if (Par_PagoFinAniInt = PagoFinMes) then
						if ((convert(day(FechaFinalInt),unsigned)*1)>=28)then
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
						else

							set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY),char(12));
						end if;
					end if;
				end if ;
			else
				if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal ) then
					set FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
				end if;
			end if;
		end if;
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else

			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		end if;
	end while;

	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinalInt) then
			set ContadorInt = Var_CuotasInt+1;
			set FechaFinalInt 	:= Par_FechaVenc;
		end if;
		if (ContadorInt = Var_CuotasInt )then
			set FechaFinalInt 	:= Par_FechaVenc;
		end if;
	end if;

	if(Par_DiaHabilSig = Var_SI) then
		call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	else

		call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
							Aud_NumTransaccion);
	end if;

	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinalInt:= FechaVig;
	end if;
	set Consecutivo := (select ifnull(Max(Tmp_Consecutivo),Entero_Cero) + 1 from Tmp_AmortizacionInt);
	set CapInt:= Var_Interes;
	set Fre_DiasIntTab		:= (DATEDIFF(FechaFinalInt,FechaInicioInt));

	INSERT into Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
					values	(	Consecutivo,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab, CapInt);

	set FechaInicioInt := FechaFinalInt;

	if( (ContadorInt+1) = Var_CuotasInt )then


		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinalInt	:= Par_FechaVenc;
		else set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);

			if (Par_PagoInter = PagoQuincenal) then
				if ((convert(day(FechaInicioInt),unsigned)*1) = FrecQuin) then
					set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
				else
					if ((convert(day(FechaInicioInt),unsigned)*1) >28) then
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
					else
						set FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL day(FechaInicioInt) day), INTERVAL FrecQuin DAY);
						if  (FechaFinalInt <= FechaInicioInt) then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
						end	if;
					end if;
				end if;
			else

				if (Par_PagoInter = PagoMensual) then

					if (Par_PagoFinAniInt = PagoAniver) then
						if(Par_DiaMesInt>28)then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
							if(Var_UltDia < Par_DiaMesInt)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);
							else
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
							end if;
						else
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
						end if;
					else

						if (Par_PagoFinAniInt = PagoFinMes) then
							if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 2 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
							else

								set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal) then
						set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
					else
						if ( Par_PagoInter = PagoBimestral) then

							if (Par_PagoFinAniInt = PagoAniver ) then
								if(Par_DiaMesInt>28)then
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
									if(Var_UltDia < Par_DiaMesInt)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' ,Var_UltDia),date);

									else
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , Par_DiaMesInt),date);
									end if;
								else
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , Par_DiaMesInt),date);
								end if;
							else

								if (Par_PagoFinAniInt = PagoFinMes) then
									if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
									else
										set FechaFinalInt	:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 2 month), interval -1 * day(FechaInicioInt) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoInter = PagoTrimestral) then

								if (Par_PagoFinAniInt = PagoAniver) then
									if(Par_DiaMesInt>28)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' ,  28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
										if(Var_UltDia < Par_DiaMesInt)then
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

										else
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Par_DiaMesInt),date);
										end if;
									else
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' , Par_DiaMesInt),date);
									end if;

									if (Par_PagoFinAniInt = PagoFinMes) then
										if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
										else
											set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 3 month), interval -1 * day(FechaInicioInt) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if ( Par_PagoInter = PagoTetrames) then

									if (Par_PagoFinAniInt = PagoAniver) then
										if(Par_DiaMesInt>28)then
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , 28),date);
											set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
											if(Var_UltDia < Par_DiaMesInt)then
												set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

											else
												set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Par_DiaMesInt),date);
											end if;
										else
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , Par_DiaMesInt),date);
										end if;
									else

										if (Par_PagoFinAniInt = PagoFinMes) then
											if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
												set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
												set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
											else
												set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 4 month), interval -1 * day(FechaInicioInt) DAY),char(12));
											end if;
										end if;
									end if;
								else
									if (Par_PagoInter = PagoSemestral) then

										if (Par_PagoFinAniInt = PagoAniver) then
											if(Par_DiaMesInt>28)then
												set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , 28),date);
												set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
												if(Var_UltDia < Par_DiaMesInt)then
													set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Var_UltDia),date);

												else
													set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Par_DiaMesInt),date);
												end if;
											else
												set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , Par_DiaMesInt),date);
											end if;
										else

											if (Par_PagoFinAniInt = PagoFinMes) then
												if ((convert(day(FechaInicioInt),unsigned)*1)>=28)then
													set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
													set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
												else
													set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 6 month), interval -1 * day(FechaInicioInt) DAY),char(12));
												end if;
											end if;
										end if;
									else
										if ( Par_PagoInter = PagoAnual) then

											set FechaFinalInt	:= convert(DATE_ADD(FechaInicioInt, interval 1 year),char(12));
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
			if(Par_DiaHabilSig = Var_SI) then
				call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			else
				call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			end if;

			while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPago ) do
				if (Par_PagoInter = PagoQuincenal ) then
					if ((convert(day(FechaFinalInt),unsigned)*1) = FrecQuin) then
						set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
					else
						if ((convert(day(FechaFinalInt),unsigned)*1) >28) then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , '15'),date);
						else
							set FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL day(FechaFinalInt) day), INTERVAL FrecQuin DAY);
							if  (FechaFinalInt <= FechaInicioInt) then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , '15'),date);
							end	if;
						end if;
					end if;
				else

					if (Par_PagoInter = PagoMensual  ) then
						if (Par_PagoFinAniInt = PagoAniver) then
							if(Par_DiaMesInt>28)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinalInt)),unsigned)*1;
								if(Var_UltDia < Par_DiaMesCap)then
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

								else
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
								end if;
							else
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , Par_DiaMesInt),date);
							end if;
						else

							if (Par_PagoFinAniInt = PagoFinMes) then
								if ((convert(day(FechaFinalInt),unsigned)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*convert(day(FechaFinalInt),unsigned) day),char(12));
								else

									set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY),char(12));
								end if;
							end if;
						end if ;
					else
						if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal ) then
							set FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
						end if;
					end if;
				end if;
				if(Par_DiaHabilSig = Var_SI) then
					call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
													Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
													Aud_NumTransaccion);
				else
					call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				end if;

			end while;
		end if;

		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
											Aud_NumTransaccion);
		else
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Negativo,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		end if;

		set CapInt:= Var_Interes;

		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinalInt:= FechaVig;
		end if;
		set Fre_DiasIntTab	:= (DATEDIFF(FechaFinalInt,FechaInicioInt));
		INSERT into Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
					values	(	Consecutivo+1,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab,	CapInt);
		set ContadorInt = ContadorInt+1;
	end if;
	set ContadorInt = ContadorInt+1;
end while;


set Contador := 1;
set ContadorCap := 1;
set ContadorInt := 1;
set Consecutivo := 1;


if (Var_Cuotas >= Var_CuotasInt) then
	set Var_Amor := Var_Cuotas;
else
	set Var_Amor := Var_CuotasInt;
end if;
select Tmp_FecIni, Tmp_FecFin into FechaInicio, FechaFinal from Tmp_Amortizacion where Tmp_Consecutivo = Contador;
select Tmp_FecIni, Tmp_FecFin into FechaInicioInt, FechaFinalInt from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;


while (Contador <= Var_Amor) do
	if (FechaFinal<FechaFinalInt)then
		set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,		NumTransaccion)
			select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,	Aud_NumTransaccion
				from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		set FechaInicio := FechaFinal;
		if (ContadorInt <= Var_CuotasInt)then
			if (ContadorInt>1)then set ContadorInt := ContadorInt-1;else set ContadorInt :=0 ; end if;
		end if;
	else
		if (FechaFinal=FechaFinalInt)then
			set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
			insert into 	TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,	NumTransaccion)
				select	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Var_CapInt,	Aud_NumTransaccion
					from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
		end if;
	end if;

	if (FechaFinal> FechaFinalInt)then
		set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,	NumTransaccion)
					select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt,	Aud_NumTransaccion
						from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
		if (ContadorCap <= Var_Cuotas)then
			if (ContadorCap>1)then set ContadorCap := ContadorCap-1;else set ContadorCap :=0 ; end if;
		end if;
		set FechaInicio := FechaFinalInt;
	end if;

	set Contador := Contador+1;
	set ContadorCap := ContadorCap+1;
	set ContadorInt := ContadorInt+1;
	set Consecutivo := Consecutivo+1;

	if (Contador>Var_Amor) then
		if (ContadorCap < Var_Cuotas) then
			set Contador:= ContadorCap;
		else if (ContadorInt < Var_CuotasInt) then
				set Contador:= ContadorInt;
			end if;
		end if;
	end if;

	if (ContadorCap <= Var_Cuotas) then
		select Tmp_FecFin into  FechaFinal from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		else set FechaFinal:= '2100-12-31';
	end if;
	if (ContadorInt <= Var_CuotasInt)then
		select  Tmp_FecFin into FechaFinalInt from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
	else
		set FechaFinalInt:= '2100-12-31';
	end if;
end while;


if (ContadorCap = Var_Cuotas) then
	if(ContadorInt = Var_CuotasInt) then
		select  Tmp_FecFin into FechaFinal from Tmp_Amortizacion where Tmp_Consecutivo =ContadorCap;
		select  Tmp_FecFin into FechaFinalInt from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
		if (FechaFinal<FechaFinalInt)then
			set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
				select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Tmp_CapInt,	Aud_NumTransaccion
					from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt, 		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
		else
			if (FechaFinal=FechaFinalInt)then
				set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
				insert into 	TMPPAGAMORSIM (	Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
					select	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Var_CapInt,	Aud_NumTransaccion
						from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
				set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				set FechaInicio := FechaFinal;
				set Consecutivo := Consecutivo+1;
				insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
							select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
			end if;
		end if;

		if (FechaFinal> FechaFinalInt)then
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
			set FechaInicio := FechaFinal;
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
							select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,	Aud_NumTransaccion
								from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		end if;
	else
		set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,		NumTransaccion)
			select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,	Aud_NumTransaccion
				from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		set FechaInicio := FechaFinal;
	end if;
else
	if(ContadorInt = Var_CuotasInt) then
		set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
	end if;

end if;


set Contador := 1;
select max(Tmp_Consecutivo) into ContadorInt from TMPPAGAMORSIM where NumTransaccion = Aud_NumTransaccion ;
while (Contador <= ContadorInt) do
	select Tmp_InteresAco into  Var_InteresAco from TMPPAGAMORSIM where Tmp_Consecutivo = Contador-1 and NumTransaccion = Aud_NumTransaccion ;

	select Tmp_Dias, Tmp_CapInt into Fre_Dias, CapInt from TMPPAGAMORSIM where Tmp_Consecutivo = Contador and NumTransaccion = Aud_NumTransaccion ;

	if(ifnull(Var_InteresAco, Entero_Cero))= Entero_Cero  then
		set Var_InteresAco := Entero_Cero;
	end if;


	if (CapInt= Var_Interes) then
		set Interes		:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
		set Capital		:= Decimal_Cero;
		set Var_InteresAco := Entero_Cero;
	else
		if (CapInt= Var_CapInt) then
			set Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			set Capital	:= Par_Monto / Var_Cuotas;
			set Var_InteresAco := Entero_Cero;
		else
			set Interes		:= Decimal_Cero;
			set Capital	:= Par_Monto / Var_Cuotas;
			set Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
		end if;
	end if;


	if (Var_PagaIVA = Var_Si) then
		set IvaInt	:= Interes * Var_IVA;
	else
		set IvaInt := Decimal_Cero;
	end if;

	set Subtotal	:= Capital + Interes + IvaInt;
	if (Insoluto<=Capital) then
		set Capital := Insoluto;
	end if;
	set Insoluto	:= Insoluto - Capital;

	update TMPPAGAMORSIM set
		Tmp_Capital	= Capital,
		Tmp_Interes	= Interes,
		Tmp_iva		= IvaInt,
		Tmp_SubTotal	= Subtotal,
		Tmp_Insoluto	= Insoluto,
		Tmp_InteresAco	= Var_InteresAco
	where Tmp_Consecutivo = Contador
	and 	NumTransaccion = Aud_NumTransaccion;

	if((Contador+1) = ContadorInt)then
		select Tmp_Insoluto, Tmp_InteresAco into Insoluto, Var_InteresAco from TMPPAGAMORSIM where Tmp_Consecutivo = Contador and NumTransaccion=Aud_NumTransaccion;

		set Contador = Contador+1;

		select Tmp_Dias, Tmp_CapInt into Fre_Dias, CapInt from TMPPAGAMORSIM where Tmp_Consecutivo = Contador and NumTransaccion = Aud_NumTransaccion ;

		if(ifnull(Var_InteresAco, Entero_Cero))= Entero_Cero  then
			set Var_InteresAco := Entero_Cero;
		end if;


		if (CapInt= Var_Interes) then

			set Capital	:= Par_Monto / Var_Cuotas;
			set Capital	:= Insoluto + Capital;
			set Subtotal	:= Insoluto + Subtotal;
			update TMPPAGAMORSIM set
				Tmp_Capital	= Capital,
				Tmp_SubTotal	= Subtotal,
				Tmp_Insoluto	= Insoluto-Insoluto
			where Tmp_Consecutivo = Contador-1
			and NumTransaccion=Aud_NumTransaccion;

			set Interes		:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			set Capital		:= Decimal_Cero;
			set Var_InteresAco := Entero_Cero;
		else
			if (CapInt= Var_CapInt) then
				set Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				set Capital	:= Insoluto;
				set Var_InteresAco := Entero_Cero;
			else
				set Interes	:= Decimal_Cero;
				set Capital	:= Insoluto;
				set Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			end if;
			if (Insoluto<=Capital) then
				set Capital := Insoluto;
			end if;
			set Insoluto	:= Insoluto - Capital;


			if (Var_PagaIVA = Var_Si) then
				set IvaInt	:= Interes * Var_IVA;
			else
				set IvaInt := Decimal_Cero;
			end if;

			set Subtotal	:= Capital + Interes + IvaInt;
			update TMPPAGAMORSIM set
				Tmp_Capital	= Capital,
				Tmp_Interes	= Interes,
				Tmp_iva		= IvaInt,
				Tmp_SubTotal	= Subtotal,
				Tmp_Insoluto	= Insoluto,
				Tmp_InteresAco	= Var_InteresAco
			where Tmp_Consecutivo = Contador
			and NumTransaccion=Aud_NumTransaccion;


		end if;
	end if;
	set Contador = Contador+1;
end while;


select max(Tmp_Consecutivo) into Consecutivo from TMPPAGAMORSIM where NumTransaccion=Aud_NumTransaccion;
select Tmp_Capital,Tmp_Interes, Tmp_CapInt into Capital, Interes, CapInt   from TMPPAGAMORSIM where Tmp_Consecutivo = Consecutivo and NumTransaccion=Aud_NumTransaccion;
if ( Capital = Decimal_Cero and Interes = Decimal_Cero ) then
	delete from TMPPAGAMORSIM where Tmp_Consecutivo = Consecutivo and NumTransaccion=Aud_NumTransaccion;
	if (CapInt= Var_Capital) then
		set Var_Cuotas:=Var_Cuotas-1;
	else if (CapInt= Var_Interes) then
			set Var_CuotasInt:=Var_CuotasInt-1;
		else
			set Var_Cuotas:=Var_Cuotas-1;
			set Var_CuotasInt:=Var_CuotasInt-1;
		end if;
	end if;

end if;



select	Tmp_FecFin,	Tmp_FecVig,	Var_Cuotas,	NumTransaccion into Out_FecFin, Out_FecVig, Out_Cuotas,Out_NumTransaccion
	from	TMPPAGAMORSIM
	where NumTransaccion=Aud_NumTransaccion
	order by Tmp_FecFin desc limit 1;


 drop table Tmp_Amortizacion;
 drop table Tmp_AmortizacionInt;

END TerminaStore$$