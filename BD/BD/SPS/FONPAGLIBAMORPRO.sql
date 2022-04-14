-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONPAGLIBAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONPAGLIBAMORPRO`;DELIMITER $$

CREATE PROCEDURE `FONPAGLIBAMORPRO`(

	Par_Frecu				int,
	Par_FrecuInt			int,
	Par_PagoCuota			char(1),
	Par_PagoInter			char(1),
	Par_PagoFinAni			char(1),
	Par_PagoFinAniInt		char(1),
	Par_FechaInicio			date	,
	Par_NumeroCuotas		int,
	Par_DiaHabilSig			char(1),
	Par_AjustaFecAmo		char(1),
	Par_AjusFecExiVen		char (1),
	Par_DiaMesInt			int,
	Par_DiaMesCap			int,
	Par_Salida    			char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),
	inout	Par_NumTran		bigint(20),
    inout	Par_MontoCuo	decimal(14,4),
	inout	Par_FechaVen 	date,


	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN

DECLARE Decimal_Cero		decimal(12,2);
DECLARE Entero_Cero			int;
DECLARE Entero_Negativo		int;
DECLARE Var_SI				char(1);
DECLARE Var_No				char(1);
DECLARE PagoSemanal			char(1);
DECLARE PagoCatorcenal		char(1);
DECLARE PagoQuincenal		char(1);
DECLARE PagoMensual			char(1);
DECLARE PagoPeriodo			char(1);
DECLARE PagoBimestral		char(1);
DECLARE PagoTrimestral		char(1);
DECLARE PagoTetrames		char(1);
DECLARE PagoSemestral		char(1);
DECLARE PagoAnual			char(1);
DECLARE PagoFinMes			char(1);
DECLARE PagoAniver			char(1);
DECLARE FrecSemanal			int;
DECLARE FrecCator			int;
DECLARE FrecQuin			int;
DECLARE FrecMensual			int;
DECLARE FrecBimestral		int;
DECLARE FrecTrimestral		int;
DECLARE FrecTetrames		int;
DECLARE FrecSemestral		int;
DECLARE FrecAnual			int;
DECLARE Var_Capital			char(1);
DECLARE Var_Interes			char(1);
DECLARE Var_CapInt			char(1);
declare Salida_SI 			char(1);


declare Var_UltDia			int;
DECLARE Contador			int;
DECLARE Consecutivo			int;
DECLARE ContadorInt			int;
DECLARE ContadorCap			int;
DECLARE FechaInicio			date;
DECLARE FechaFinal			date;
DECLARE FechaInicioInt		date;
DECLARE FechaFinalInt		date;
DECLARE FechaVig			date;
declare Par_FechaVenc		date	;
DECLARE Var_EsHabil			char(1);
DECLARE Var_Cuotas			int;
DECLARE Var_CuotasInt		int;
DECLARE Var_Amor			int;
DECLARE Fre_Dias			int;
DECLARE Fre_DiasTab			int;
DECLARE Fre_DiasInt			int;
DECLARE Fre_DiasIntTab		int;
DECLARE Var_GraciaFaltaPag	int;
DECLARE CapInt				char(1);
declare Var_FrecuPago		int;


set Decimal_Cero		:= 0.00;
set Entero_Cero			:= 0;
set Entero_Negativo		:= -1;
set Var_SI				:= 'S';
set Var_No				:= 'N';
set PagoSemanal			:= 'S';
set PagoCatorcenal		:= 'C';
set PagoQuincenal		:= 'Q';
set PagoMensual			:= 'M';
set PagoPeriodo			:= 'P';
set PagoBimestral		:= 'B';
set PagoTrimestral		:= 'T';
set PagoTetrames		:= 'R';
set PagoSemestral		:= 'E';
set PagoAnual			:= 'A';
set PagoFinMes			:= 'F';
set PagoAniver			:= 'A';
set FrecSemanal			:= 7;
set FrecCator			:= 14;
set FrecQuin			:= 15;
set FrecMensual			:= 30;

set FrecBimestral		:= 60;
set FrecTrimestral		:= 90;
set FrecTetrames		:= 120;
set FrecSemestral		:= 180;
set FrecAnual			:= 360;
set Var_Capital			:= 'C';
set Var_Interes			:= 'I';
set Var_CapInt			:= 'G';
set Salida_SI 	   		:= 'S';


set Contador			:= 1;
set ContadorInt			:= 1;
set FechaInicio			:= Par_FechaInicio;
set FechaInicioInt		:= Par_FechaInicio;
set Var_FrecuPago		:= 0;


if ( Par_PagoCuota = PagoPeriodo) then
	if(ifnull(Par_Frecu, Entero_Cero))= Entero_Cero then
		if (Par_Salida = Salida_SI) then
			select	'001' as Par_NumErr,
					'Especificar Frecuencia Pago.',
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo;
		else
			set Par_NumErr := 1;
			set Par_ErrMen := 'Especificar Frecuencia Pago.';
		end if ;
		LEAVE TerminaStore;
	end if ;
end if ;


if ( Par_PagoInter = PagoPeriodo) then
	if(ifnull(Par_FrecuInt, Entero_Cero))= Entero_Cero then
		if (Par_Salida = Salida_SI) then
			select	'001' as Par_NumErr,
					'Especificar Frecuencia Pago.',
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,
					Entero_Cero as consecutivo,

					Entero_Cero as consecutivo;
		else
			set Par_NumErr := 1;
			set Par_ErrMen := 'Especificar Frecuencia Pago.';
		end if ;
		LEAVE TerminaStore;
	end if ;
end if ;



CASE Par_PagoCuota
	when PagoSemanal		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecSemanal day));
	when PagoCatorcenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecCator day));
	when PagoQuincenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecQuin day));
	when PagoMensual		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas MONTH));
	when PagoPeriodo		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*Par_Frecu day));
	when PagoBimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*2 MONTH));
	when PagoTrimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*3 MONTH));
	when PagoTetrames		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*4 MONTH));
	when PagoSemestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*6 MONTH));
	when PagoAnual		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas YEAR));
END CASE;


CASE Par_PagoCuota
	when PagoSemanal	then set Fre_Dias	:=  FrecSemanal; set Var_GraciaFaltaPag:= 5;
	when PagoCatorcenal	then set Fre_Dias	:=  FrecCator; set Var_GraciaFaltaPag:= 10;
	when PagoQuincenal	then set Fre_Dias	:=  FrecQuin; set Var_GraciaFaltaPag:= 10;
	when PagoMensual	then set Fre_Dias	:=  FrecMensual; set Var_GraciaFaltaPag:= 20;
	when PagoPeriodo	then set Fre_Dias 	:=  Par_Frecu;
	when PagoBimestral	then set Fre_Dias	:=  FrecBimestral; set Var_GraciaFaltaPag:= 40;
	when PagoTrimestral	then set Fre_Dias	:=  FrecTrimestral; set Var_GraciaFaltaPag:= 60;
	when PagoTetrames	then set Fre_Dias	:=  FrecTetrames;	set Var_GraciaFaltaPag:= 80;
	when PagoSemestral	then set Fre_Dias	:=  FrecSemestral; set Var_GraciaFaltaPag:= 120;
	when PagoAnual		then set Fre_Dias	:=  FrecAnual; set Var_GraciaFaltaPag:= 240;
END CASE;



set  Var_FrecuPago = Fre_Dias;

if (Par_PagoInter = PagoQuincenal) then set Fre_DiasInt	:=  FrecQuin; else set Var_GraciaFaltaPag:= 10;
	if (Par_PagoInter = PagoCatorcenal) then set Fre_DiasInt	:=  FrecCator; set Var_GraciaFaltaPag:= 10;else
		if (Par_PagoInter = PagoSemanal) then set Fre_DiasInt	:=  FrecSemanal; set Var_GraciaFaltaPag:= 5;else
			if (Par_PagoInter = PagoMensual) then set Fre_DiasInt	:=  FrecMensual; set Var_GraciaFaltaPag:= 20;else
				if (Par_PagoInter = PagoBimestral) then set Fre_DiasInt	:=  FrecBimestral; set Var_GraciaFaltaPag:= 40; else
					if (Par_PagoInter = PagoTrimestral) then set Fre_DiasInt	:=  FrecTrimestral; set Var_GraciaFaltaPag:= 60;else
						if (Par_PagoInter = PagoTetrames) then set Fre_DiasInt	:=  FrecTetrames;	set Var_GraciaFaltaPag:= 80; else
							if (Par_PagoInter = PagoSemestral) then set Fre_DiasInt	:=  FrecSemestral; set Var_GraciaFaltaPag:= 120; else
								if (Par_PagoInter = PagoAnual) then set Fre_DiasInt	:=  FrecAnual; set Var_GraciaFaltaPag:= 240; else
									if ( Par_PagoInter = PagoPeriodo) then set Fre_DiasInt :=  Par_FrecuInt; end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
end if;


set Var_Cuotas:=cast(DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_Dias as  signed);
set Var_CuotasInt:=cast(DATEDIFF(Par_FechaVenc,Par_FechaInicio)/Fre_DiasInt as  signed);

drop table if EXISTS Tmp_Amortizacion;
drop table if EXISTS Tmp_AmortizacionInt;

CREATE TEMPORARY TABLE Tmp_Amortizacion(
	Tmp_Consecutivo	int,
	Tmp_Dias			int,
	Tmp_FecIni		date,
	Tmp_FecFin		date,
	Tmp_FecVig		date,
	Tmp_Capital		decimal(12,2),
	Tmp_Interes		decimal(12,4),
	Tmp_Iva			decimal(12,4),
	Tmp_SubTotal		decimal(12,2),
	Tmp_Insoluto		decimal(12,2),
	Tmp_CapInt		char(1),
    PRIMARY KEY  (Tmp_Consecutivo));


CREATE TEMPORARY TABLE Tmp_AmortizacionInt(
	Tmp_Consecutivo	int,
	Tmp_Dias			int,
	Tmp_FecIni		date,
	Tmp_FecFin		date,
	Tmp_FecVig		date,
	Tmp_Capital		decimal(12,2),
	Tmp_Interes		decimal(12,4),
	Tmp_Iva			decimal(12,4),
	Tmp_SubTotal		decimal(12,2),
	Tmp_Insoluto		decimal(12,2),
	Tmp_CapInt		char(1),
    PRIMARY KEY  (Tmp_Consecutivo));



while (Contador <= Var_Cuotas) do

	if (Par_PagoCuota = PagoQuincenal) then
		if ((cast(day(FechaInicio) as  signed)*1) = FrecQuin) then
			set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
		else
			if ((cast(day(FechaInicio) as  signed)*1) >28) then
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
					set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
					if ((cast(day(FechaInicio) as  signed)*1)>=28)then
						set FechaFinal := convert(DATE_ADD(FechaInicio, interval 2 month),char(12));
						set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
							set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
							if ((cast(day(FechaInicio) as  signed)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
								set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
								if ((cast(day(FechaInicio) as  signed)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
									set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
									if ((cast(day(FechaInicio) as  signed)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
										set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
										if ((cast(day(FechaInicio) as  signed)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
		call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	while ((cast(datediff(FechaVig, FechaInicio) as  signed)*1) <= Var_GraciaFaltaPag ) do
		if (Par_PagoCuota = PagoQuincenal ) then
			if ((cast(day(FechaFinal) as  signed)*1) = FrecQuin) then
				set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
			else
				if ((cast(day(FechaFinal) as  signed)*1) >28) then
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
						set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
						if ((cast(day(FechaFinal) as  signed)*1)>=28)then
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;
	end while;


	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
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
		call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinal:= FechaVig;
	end if;

	set CapInt:= Var_Capital;

	set Consecutivo := (select ifnull(Max(Tmp_Consecutivo),Entero_Cero) + 1
					from Tmp_Amortizacion);

	set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

	INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
								Tmp_CapInt)
					values	(	Consecutivo,		FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab,
								CapInt);

	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
			set Contador 	:= Var_Cuotas+1;
		end if;
	end if;
	set FechaInicio := FechaFinal;

	if((Contador+1) = Var_Cuotas )then



		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinal 	:= Par_FechaVenc;
		else

			if (Par_PagoCuota = PagoQuincenal) then
				if ((cast(day(FechaInicio) as  signed)*1) = FrecQuin) then
					set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
				else
					if ((cast(day(FechaInicio) as  signed)*1) >28) then
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
							set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
							if ((cast(day(FechaInicio) as  signed)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 2 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
									set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
									if ((cast(day(FechaInicio) as  signed)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
										set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
										if ((cast(day(FechaInicio) as  signed)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
											set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
											if ((cast(day(FechaInicio) as  signed)*1)>=28)then
												set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
												set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
												set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
												if ((cast(day(FechaInicio) as  signed)*1)>=28)then
													set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
													set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
				call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;

			while ((datediff(FechaVig, FechaInicio)*1) <= Var_GraciaFaltaPag ) do
				if (Par_PagoCuota = PagoQuincenal ) then
					if ((cast(day(FechaFinal) as  signed)*1) = FrecQuin) then
						set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
					else
						if ((cast(day(FechaFinal) as  signed)*1) >28) then
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
								set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as  signed)*1;
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
								if ((cast(day(FechaFinal) as  signed)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as  signed) day),char(12));
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
					call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				end if;
			end while;
		end if;

		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

		else
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;

		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinal:= FechaVig;
		end if;
		set CapInt:= Var_Capital;
		set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
		INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
									Tmp_CapInt)
					values	(	Consecutivo+1,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab,
									CapInt);
		set Contador = Contador+1;
	end if;
	set Contador = Contador+1;
end while;


while (ContadorInt <= Var_CuotasInt ) do

	if (Par_PagoInter = PagoQuincenal) then
		if ((cast(day(FechaInicioInt) as  signed)*1) = FrecQuin) then
			set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
		else
			if ((cast(day(FechaInicioInt) as  signed)*1) >28) then
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
					set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
					if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
						set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 2 month),char(12));
						set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
							set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
							if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
								set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
								if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
									set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
									if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
										set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
										if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
		call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;


	while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) do
		if (Par_PagoInter = PagoQuincenal ) then
			if ((cast(day(FechaFinalInt) as  signed)*1) = FrecQuin) then
				set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
			else
				if ((cast(day(FechaFinalInt) as  signed)*1) >28) then
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
						set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
						if ((cast(day(FechaFinalInt) as  signed)*1)>=28)then
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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

			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
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

		call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinalInt:= FechaVig;
	end if;
	set Consecutivo := (select ifnull(Max(Tmp_Consecutivo),Entero_Cero) + 1 from Tmp_AmortizacionInt);
	set CapInt:= Var_Interes;
	set Fre_DiasIntTab		:= (DATEDIFF(FechaFinalInt,FechaInicioInt));

	INSERT into Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
									Tmp_CapInt)
					values	(	Consecutivo,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab,
									CapInt);

	set FechaInicioInt := FechaFinalInt;

	if( (ContadorInt+1) = Var_CuotasInt )then


		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinalInt	:= Par_FechaVenc;
		else set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);

			if (Par_PagoInter = PagoQuincenal) then
				if ((cast(day(FechaInicioInt) as  signed)*1) = FrecQuin) then
					set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
				else
					if ((cast(day(FechaInicioInt) as  signed)*1) >28) then
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
							set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
							if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 2 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
									set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
									if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
										set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
										if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
											set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
											if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
												set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
												set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
												set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
												if ((cast(day(FechaInicioInt) as  signed)*1)>=28)then
													set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
													set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
				call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;

			while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) do
				if (Par_PagoInter = PagoQuincenal ) then
					if ((cast(day(FechaFinalInt) as  signed)*1) = FrecQuin) then
						set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
					else
						if ((cast(day(FechaFinalInt) as  signed)*1) >28) then
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
								set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as  signed)*1;
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
								if ((cast(day(FechaFinalInt) as  signed)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as  signed) day),char(12));
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
					call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				end if;

			end while;
		end if;

		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
											Aud_NumTransaccion);
		else
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;

		set CapInt:= Var_Interes;

		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinalInt:= FechaVig;
		end if;
		set Fre_DiasIntTab	:= (DATEDIFF(FechaFinalInt,FechaInicioInt));
		INSERT into Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
										Tmp_CapInt)
					values	(	Consecutivo+1,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab,
										CapInt);
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
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt,		NumTransaccion,	Tmp_CuotasCap,	Tmp_CuotasInt, 	Tmp_FrecuPago)
			select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,	Aud_NumTransaccion,	Var_Cuotas,	Var_CuotasInt,	Var_FrecuPago
				from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		set FechaInicio := FechaFinal;
		if (ContadorInt <= Var_CuotasInt)then
			if (ContadorInt>1)then set ContadorInt := ContadorInt-1;else set ContadorInt :=0 ; end if;
		end if;
	else
		if (FechaFinal=FechaFinalInt)then
			set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
			insert into 	TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,	NumTransaccion,		Tmp_CuotasCap,Tmp_CuotasInt,
										Tmp_FrecuPago)
				select	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Var_CapInt,	Aud_NumTransaccion,		Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
					from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
		end if;
	end if;

	if (FechaFinal> FechaFinalInt)then
		set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,	NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt,Tmp_FrecuPago)
					select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt,	Aud_NumTransaccion,		Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
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
									Tmp_CapInt,		NumTransaccion, Tmp_CuotasCap,Tmp_CuotasInt,Tmp_FrecuPago)
				select Consecutivo,	Fre_Dias,		FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
					from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
		else
			if (FechaFinal=FechaFinalInt)then
				set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
				insert into 	TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,	NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
					select	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Var_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
						from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
				set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				set FechaInicio := FechaFinal;
				set Consecutivo := Consecutivo+1;
				insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,	NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
							select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
								from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
			end if;
		end if;

		if (FechaFinal> FechaFinalInt)then
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,	NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt, Var_FrecuPago
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
			set FechaInicio := FechaFinal;
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
							select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt,Var_FrecuPago
								from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		end if;
	else
		set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,		NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
			select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt,Var_FrecuPago
				from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		set FechaInicio := FechaFinal;
	end if;
else
	if(ContadorInt = Var_CuotasInt) then
		set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,	NumTransaccion,	Tmp_CuotasCap,Tmp_CuotasInt, Tmp_FrecuPago)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,	Aud_NumTransaccion,Var_Cuotas,	Var_CuotasInt,Var_FrecuPago
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
	end if;

end if;


set Par_FechaVenc := (select max(Tmp_FecFin) from TMPPAGAMORSIM where 	NumTransaccion = Aud_NumTransaccion);


if (Par_Salida = Salida_SI) then
	select	Tmp_Consecutivo,	Tmp_FecIni,		Tmp_FecFin,		Tmp_FecVig,		Tmp_Capital,
			Tmp_Interes,		Tmp_Iva,			Tmp_SubTotal,		Tmp_Insoluto,		Tmp_Dias,
			Tmp_CapInt,		Tmp_CuotasCap,	Tmp_CuotasInt, 	NumTransaccion,	Par_FechaVenc,
			Par_FechaInicio, 	Entero_Cero as MontoCuota
		from	TMPPAGAMORSIM
		where NumTransaccion = Aud_NumTransaccion;
end if ;

set Par_NumErr 	:= 0;
set Par_ErrMen 	:= 'Cuotas generadas';
set Par_NumTran	:= Aud_NumTransaccion;
set Par_MontoCuo	:= Entero_Cero;
set Par_FechaVen	:= Par_FechaVenc;

 drop table Tmp_Amortizacion;
 drop table Tmp_AmortizacionInt;
END TerminaStore$$