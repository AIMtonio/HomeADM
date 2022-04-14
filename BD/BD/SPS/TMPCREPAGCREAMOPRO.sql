-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREPAGCREAMOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCREPAGCREAMOPRO`;DELIMITER $$

CREATE PROCEDURE `TMPCREPAGCREAMOPRO`(


	Par_Monto			decimal(12,2),
	Par_Tasa				decimal(12,2),
	Par_Frecu			int,
	Par_PagoCuota			char(1),
	Par_PagoFinAni		char(1),
	Par_DiaMes			int(2),
	Par_FechaInicio		date	,
	Par_FechaVenc			date	,
	Par_ProducCreditoID	int,
	Par_ClienteID			int,
	Par_DiaHabilSig		char(1),
	Par_AjustaFecAmo		char(1),
	Par_AjusFecExiVen		char (1),

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


declare Decimal_Cero		decimal(12,2);
declare Entero_Cero		int;
declare Entero_Negativo	int;
declare Var_SI			char(1);
declare Var_No			char(1);
declare PagoSemanal		char(1);
declare PagoCatorcenal	char(1);
declare PagoQuincenal		char(1);
declare PagoMensual		char(1);
declare PagoPeriodo		char(1);
declare PagoBimestral		char(1);
declare PagoTrimestral	char(1);
declare PagoTetrames		char(1);
declare PagoSemestral		char(1);
declare PagoAnual			char(1);
declare PagoFinMes		char(1);
declare PagoAniver		char(1);
declare FrecSemanal		int;
declare FrecCator			int;
declare FrecQuin			int;
declare FrecMensual		int;
declare FrecBimestral		int;
declare FrecTrimestral		int;
declare FrecTetrames		int;
declare FrecSemestral		int;
declare FrecAnual			int;


declare Var_UltDia		int;
declare Contador			int;
declare ContadorMargen		int;
declare FechaInicio		date;
declare FechaFinal		date;
declare FechaVig			date;
declare Var_EsHabil		char(1);
declare Var_Cuotas		int;
declare Tas_Periodo		decimal(12,4);
declare Pag_Calculado		decimal(12,2);
declare Capital			decimal(12,2);
declare Interes			decimal(12,2);
declare IvaInt			decimal(12,2);
declare Subtotal			decimal(12,2);
declare Insoluto			decimal(12,2);
declare Var_IVA			decimal(12,2);
declare Fre_DiasAnio		int;
declare Fre_Dias			int;
declare Fre_DiasTab		int;
declare Var_GraciaFaltaPago	int;
declare Var_MargenPagIgual	int;
declare Var_Diferencia		decimal(12,2);
declare Var_Ajuste		decimal(12,2);
declare Var_ProCobIva		char(1);
declare Var_CtePagIva		char(1);
declare Var_PagaIVA		char(1);


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


set Contador			:= 1;
set ContadorMargen	:= 1;
set FechaInicio		:= Par_FechaInicio;
set Var_IVA			:= (select IVA from SUCURSALES where SucursalID = Aud_Sucursal);
set Fre_DiasAnio		:= (select DiasCredito from PARAMETROSSIS);


select GraciaFaltaPago, MargenPagIgual, CobraIVAInteres into Var_GraciaFaltaPago, Var_MargenPagIgual, Var_ProCobIva
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


if (Par_PagoCuota = PagoQuincenal) then set Fre_Dias	:=  FrecQuin; else
	if (Par_PagoCuota = PagoCatorcenal) then set Fre_Dias	:=  FrecCator; else
		if (Par_PagoCuota = PagoSemanal) then set Fre_Dias	:=  FrecSemanal; else
			if (Par_PagoCuota = PagoPeriodo) then set Fre_Dias	:=  Par_Frecu; else
				if (Par_PagoCuota = PagoMensual) then set Fre_Dias	:=  FrecMensual;	else
					if (Par_PagoCuota = PagoBimestral) then set Fre_Dias	:=  FrecBimestral; else
						if (Par_PagoCuota = PagoTrimestral) then set Fre_Dias	:=  FrecTrimestral; else
							if (Par_PagoCuota = PagoTetrames) then set Fre_Dias	:=  FrecTetrames;	else
								if (Par_PagoCuota = PagoSemestral) then set Fre_Dias	:=  FrecSemestral; else
									if (Par_PagoCuota = PagoAnual) then set Fre_Dias	:=  FrecAnual; end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;

set Var_Cuotas:=(DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_Dias);

set Tas_Periodo	:= ((Par_Tasa / 100) * (1 + Var_IVA) * Fre_Dias) / Fre_DiasAnio ;
set Pag_Calculado	:= (Par_Monto * Tas_Periodo * (power((1 + Tas_Periodo), Var_Cuotas))) / (power((1 + Tas_Periodo), Var_Cuotas)-1);
set Insoluto		:= Par_Monto;

while (ContadorMargen < 100) do

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
					if(Par_DiaMes>28)then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
						set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
						if(Var_UltDia < Par_DiaMes)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);
						else
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
						end if;
					else
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
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
					if (Par_PagoCuota = PagoBimestral) then

						if (Par_PagoFinAni = PagoAniver) then
							if(Par_DiaMes>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
								if(Var_UltDia < Par_DiaMes)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' ,Par_DiaMes),date);

								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMes),date);
								end if;
							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMes),date);
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
						if (Par_PagoCuota = PagoTrimestral) then

							if (Par_PagoFinAni = PagoAniver) then
								if(Par_DiaMes>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
									if(Var_UltDia < Par_DiaMes)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMes),date);
									end if;
								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMes),date);
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
							if (Par_PagoCuota = PagoTetrames) then

								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMes>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
										if(Var_UltDia < Par_DiaMes)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMes),date);
										end if;
									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMes),date);
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
								if (Par_PagoCuota = PagoSemestral) then

									if (Par_PagoFinAni = PagoAniver) then
										if(Par_DiaMes>28)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
											set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
											if(Var_UltDia < Par_DiaMes)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' ,Var_UltDia),date);

											else
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMes),date);
											end if;
										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
												convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMes),date);
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
									if (Par_PagoCuota = PagoAnual) then

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
						if(Par_DiaMes>28)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
							if(Var_UltDia < Par_DiaMes)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
							end if;
						else
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
						end if;
					else

						if (Par_PagoFinAni = PagoFinMes) then
							if ((convert(day(FechaFinal),unsigned)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
							else

								set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
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
				set Contador 		= Var_Cuotas+1;
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

		set Fre_DiasTab:= (DATEDIFF(FechaFinal,FechaInicio));
		set Interes		:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100));

		if (Var_PagaIVA = Var_Si) then
			set IvaInt		:= Interes * Var_IVA;
		else
			set IvaInt := Entero_Cero;
		end if;

		set Capital	:= Pag_Calculado - Interes - IvaInt;
		set Subtotal	:= Capital + Interes + IvaInt;
		if (Insoluto<=Capital) then
			set Capital := Insoluto;
		end if;
		set Insoluto	:= Insoluto - Capital;

		INSERT into TMPPAGAMORSIM(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Capital,
								Tmp_Interes, 		Tmp_Iva, 	Tmp_SubTotal,	Tmp_Insoluto,	Tmp_Dias,
								NumTransaccion)

					values(	Contador,	FechaInicio,	FechaFinal,	FechaVig,	Capital,
							Interes,		IvaInt,		Subtotal,	Insoluto,	Fre_DiasTab,
							Aud_NumTransaccion);


		set FechaInicio := FechaFinal;

		if((Contador+1) = Var_Cuotas)then


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
							if(Par_DiaMes>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
								if(Var_UltDia < Par_DiaMes)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);
								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
								end if;
							else
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
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
							if (Par_PagoCuota = PagoBimestral) then

								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMes>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
										if(Var_UltDia < Par_DiaMes)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' ,Par_DiaMes),date);

										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMes),date);
										end if;
									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , Par_DiaMes),date);
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
								if (Par_PagoCuota = PagoTrimestral) then

									if (Par_PagoFinAni = PagoAniver) then
										if(Par_DiaMes>28)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
											set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
											if(Var_UltDia < Par_DiaMes)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Var_UltDia),date);

											else
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMes),date);
											end if;
										else
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' , Par_DiaMes),date);
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
									if (Par_PagoCuota = PagoTetrames) then

										if (Par_PagoFinAni = PagoAniver) then
											if(Par_DiaMes>28)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
												set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
												if(Var_UltDia < Par_DiaMes)then
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Var_UltDia),date);

												else
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMes),date);
												end if;
											else
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , Par_DiaMes),date);
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
										if (Par_PagoCuota = PagoSemestral) then

											if (Par_PagoFinAni = PagoAniver) then
												if(Par_DiaMes>28)then
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
													set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
													if(Var_UltDia < Par_DiaMes)then
														set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' ,Var_UltDia),date);

													else
														set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMes),date);
													end if;
												else
													set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
														convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , Par_DiaMes),date);
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
											if (Par_PagoCuota = PagoAnual) then

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
								if(Par_DiaMes>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
															 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := convert(day(LAST_DAY(FechaFinal)),unsigned)*1;
									if(Var_UltDia < Par_DiaMes)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
															 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' ,Var_UltDia),date);

									else
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
															 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
									end if;
								else
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
															 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , Par_DiaMes),date);
								end if;
							else

								if (Par_PagoFinAni = PagoFinMes) then
									if ((convert(day(FechaFinal),unsigned)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*convert(day(FechaFinal),unsigned) day),char(12));
									else

										set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
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

			set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

			set Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100));
			if (Var_PagaIVA = Var_Si) then
				set IvaInt		:= Interes * Var_IVA;
			else
				set IvaInt := Entero_Cero;
			end if;
			set Capital	:= Insoluto;
			set Subtotal	:= Capital + Interes + IvaInt;

			if (Insoluto<=Capital) then
				set Capital := Insoluto;
			end if;
			set Insoluto	:= Insoluto - Capital;

			INSERT into TMPPAGAMORSIM(	Tmp_Consecutivo, Tmp_FecIni,	Tmp_FecFin,		Tmp_FecVig,	Tmp_Capital,
									Tmp_Interes, 		Tmp_Iva, 	Tmp_SubTotal,		Tmp_Insoluto,	Tmp_Dias,
									NumTransaccion)
								values(Contador+1,	FechaInicio,	FechaFinal,	FechaVig,	Capital,
									   Interes,		IvaInt,		Subtotal,	Insoluto, 	Fre_DiasTab,
									   Aud_NumTransaccion);

			set Var_Diferencia := Pag_Calculado-Subtotal;
			set Contador = Contador+1;
		end if;
		set Contador = Contador+1;
	end while;


	set ContadorMargen = ContadorMargen+1;

	if (Var_Diferencia < Decimal_Cero or Var_Diferencia > Var_MargenPagIgual) then
			if (ContadorMargen<>100)then

				delete from TMPPAGAMORSIM where NumTransaccion = Aud_NumTransaccion;
			end if;
			set Contador 		:=1;
			set Var_Ajuste 		:= Var_Diferencia/Var_Cuotas;
			set Pag_Calculado 	:= Pag_Calculado-Var_Ajuste;
			set Insoluto		:= Par_Monto;
			set FechaInicio		:= Par_FechaInicio;
	else
		set ContadorMargen := 100;
		set Contador = Var_Cuotas+1;
	end if;

 end while;




select	Tmp_FecFin,	Tmp_FecVig,	Var_Cuotas,		NumTransaccion into Out_FecFin, Out_FecVig, Out_Cuotas,Out_NumTransaccion
	from		TMPPAGAMORSIM
	where 	NumTransaccion = Aud_NumTransaccion
	order by Tmp_FecFin desc limit 1;



END TerminaStore$$