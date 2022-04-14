-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONTASVARAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONTASVARAMORPRO`;
DELIMITER $$


CREATE PROCEDURE `FONTASVARAMORPRO`(
	-- SP que simula cuotas con tasa variable
	-- se utiliza en el CREDITO PASIVO
	Par_Monto				decimal(12,2),	/* Monto a prestar */
	Par_Frecu				int,			/* Frecuencia del pago de capital en Dias */
	Par_FrecuInt			int,			/* Frecuencia del pago de interes en Dias */
	Par_PagoCuota			char(1),		/* Pago de la cuota capital (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual) */
	Par_PagoInter			char(1),		/* Pago de la cuota de Intereses  (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual) */

	Par_PagoFinAni			char(1),		/* solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A) */
	Par_PagoFinAniInt		char(1),		/* solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A) para los intereses  */
	Par_FechaInicio			date	,		/* fecha en que empiezan los pagos */
	Par_NumeroCuotas		int,			/* Numero de Cuotas que se simularan */
	Par_NumCuotasInt		int,			/* Numero de Cuotas que se simularan para interes */

	Par_DiaHabilSig			char(1),		/* Indica si toma el dia habil siguiente (S - si) o el anterior (N - no) */
	Par_AjustaFecAmo		char(1),		/* Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no) */
	Par_AjusFecExiVen		char (1),		/* Indica si se ajusta la fecha de exigibilidad a fecha de vencimiento (S- si se ajusta N- no se ajusta) */
	Par_DiaMesInt			int,			/* solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para los intereses */
	Par_DiaMesCap			int,			/* solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para el capital */
	Par_Tasa				DECIMAL(14,2),	/* Tasa Anualizada*/
	Par_PagaIVA				CHAR(1),			-- indica si paga IVA valores :  Si = "S" / No = "N")
	Par_TasaISR				DECIMAL(12,2),	/* Tasa del ISR*/

	Par_Salida    			char(1),		/* Indica si hay una salida o no  */
	inout	Par_NumErr		int,
	inout	Par_ErrMen		varchar(350),
	inout	Par_NumTran		bigint(20),		/* Numero de transaccion con el que se genero el calendario de pagos */
	inout	Par_MontoCuo	decimal(14,4),	/* corresponde con la cuota promedio a pagar */

	inout	Par_FechaVen	date,			/* corresponde con la fecha final que genere el cotizador  */
	inout	Par_Cuotas		int,			/* devuelve el numero de cuotas de Capital */
	inout	Par_CuotasInt	int,			/* devuelve el numero de cuotas de Interes */
	Par_EmpresaID			int,
	Aud_Usuario				int,

	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)

TerminaStore: BEGIN
/* Declaracion de Constantes */
DECLARE Decimal_Cero		decimal(12,2);
DECLARE Entero_Cero			int;
DECLARE Entero_Negativo		int;
DECLARE Var_SI				char(1);	/* SI */
DECLARE Var_No				char(1);	/* NO */
DECLARE PagoSemanal			char(1);	/* Pago Semanal (S) */
DECLARE PagoCatorcenal		char(1);	/* Pago Catorcenal (C) */
DECLARE PagoQuincenal		char(1);	/* Pago Quincenal (Q) */
DECLARE PagoMensual			char(1);	/* Pago Mensual (M) */
DECLARE PagoPeriodo			char(1);	/* Pago por periodo (P) */
DECLARE PagoBimestral		char(1);	/* PagoBimestral (B) */
DECLARE PagoTrimestral		char(1);	/* PagoTrimestral (T) */
DECLARE PagoTetrames		char(1);	/* PagoTetraMestral (R) */
DECLARE PagoSemestral		char(1);	/* PagoSemestral (E) */
DECLARE PagoAnual			char(1);	/* PagoAnual (A) */
declare PagoUnico			char(1);	-- Pago Unico (U)
DECLARE PagoFinMes			char(1);	/* Pago al final del mes (F) */
DECLARE PagoAniver			char(1);	/* Pago por aniversario (A) */
DECLARE FrecSemanal			int;		/* frecuencia semanal en dias */
DECLARE FrecCator			int;		/* frecuencia Catorcenal en dias */
DECLARE FrecQuin			int;		/* frecuencia en dias quincena */
DECLARE FrecMensual			int;		/* frecuencia mensual */
DECLARE FrecBimestral		int;		/* Frecuencia en dias Bimestral  */
DECLARE FrecTrimestral		int;		/* Frecuencia en dias Trimestral  */
DECLARE FrecTetrames		int;		/* Frecuencia en dias TetraMestral  */
DECLARE FrecSemestral		int;		/* Frecuencia en dias Semestral  */
DECLARE FrecAnual			int;		/* frecuencia en dias Anual  */
DECLARE Var_Capital			char(1);	/* Bandera que me indica que se trata de un pago de capital */
DECLARE Var_Interes			char(1);	/* Bandera que me indica que se trata de un pago de interes */
DECLARE Var_CapInt			char(1);	/* Bandera que me indica que se trata de un pago de capital y  de interes */
declare Var_TipoCap			char(1);	-- Bandera que me indica que se trata de un pago de capital y de interes
DECLARE Salida_SI			char(1);

/* Declaracion de Variables */
DECLARE Var_UltDia			int;
DECLARE Contador			int;
DECLARE Consecutivo			int;
DECLARE ContadorInt			int;
DECLARE ContadorCap			int;
DECLARE FechaInicio			date;
DECLARE FechaFinal			date;
DECLARE FechaInicioInt		date;
DECLARE FechaFinalInt		date;
DECLARE FechaVig			date;
DECLARE Par_FechaVenc		date	;		/* fecha vencimiento en que terminan los pagos */
DECLARE Var_EsHabil			char(1);
DECLARE Var_Cuotas			int;
DECLARE Var_CuotasInt		int;
DECLARE Var_Amor			int;
DECLARE Capital				decimal(12,2);
DECLARE Subtotal			decimal(12,2);
DECLARE Insoluto			decimal(12,2);
DECLARE Fre_DiasAnio		int;		/* dias del aÃ±o  */
DECLARE Fre_Dias			int;		/* numero de dias para pagos de capital */
DECLARE Fre_DiasTab			int;		/* numero de dias para pagos de capital */
DECLARE Fre_DiasInt			int;		/* numero de dias para pagos de interes */
DECLARE Fre_DiasIntTab		int;		/* numero de dias para pagos de interes */
DECLARE Var_GraciaFaltaPag	int;		/* dias de gracia */
DECLARE Var_MargenPagIgual	int;		/* Margen para pagos iguales */
DECLARE CapInt				char(1);
DECLARE anualTotal			INT(11);
DECLARE Var_MontInt 		DECIMAL(12,2);
DECLARE Var_IVAInteres 		DECIMAL(12,2);
DECLARE Var_IVA 			DECIMAL(12,4);
DECLARE Var_Retencion 		DECIMAL(14,2);
DECLARE Var_TasaISR			DECIMAL(12,2); 		/* tasa de ISR */

/* asignacion de constantes */
set Decimal_Cero		:= 0.00;
set Entero_Cero			:= 0;
set Entero_Negativo		:= -1;
set Var_SI				:= 'S';
set Var_No				:= 'N';
set PagoSemanal			:= 'S'; /* PagoSemanal */
set PagoCatorcenal		:= 'C'; /* PagoCatorcenal */
set PagoQuincenal		:= 'Q'; /* PagoQuincenal */
set PagoMensual			:= 'M'; /* PagoMensual */
set PagoPeriodo			:= 'P'; /* PagoPeriodo */
set PagoBimestral		:= 'B'; /* PagoBimestral */
set PagoTrimestral		:= 'T'; /* PagoTrimestral  */
set PagoTetrames		:= 'R'; /* PagoTetraMestral */
set PagoSemestral		:= 'E'; /* PagoSemestral */
set PagoAnual			:= 'A'; /* PagoAnual */
set PagoFinMes			:= 'F'; /* PagoFinMes */
set PagoAniver			:= 'A'; /* Pago por aniversario */
set PagoUnico			:= 'U'; -- Pago Unico (U)
set FrecSemanal			:= 7;	/* frecuencia semanal en dias */
set FrecCator			:= 14;	/* frecuencia Catorcenal en dias */
set FrecQuin			:= 15;	/* frecuencia en dias de quincena */
set FrecMensual			:= 30;	/* frecuencia mesual */

set FrecBimestral		:= 60;	/* Frecuencia en dias Bimestral  */
set FrecTrimestral		:= 90;	/* Frecuencia en dias Trimestral  */
set FrecTetrames		:= 120;	/* Frecuencia en dias TetraMestral  */
set FrecSemestral		:= 180;	/* Frecuencia en dias Semestral  */
set FrecAnual			:= 360;	/* frecuencia en dias Anual  */
set Var_Capital			:= 'C';	/* Bandera que me indica que se trata de un pago de capital */
set Var_Interes			:= 'I';	/* Bandera que me indica que se trata de un pago de interes */
set Var_CapInt			:= 'G';	/* Bandera que me indica que se trata de un pago de capital y de interes */
set Salida_SI			:= 'S';
set anualTotal			:= 36000;

/* asignacion de variables */
set Contador			:= 1;
set ContadorInt			:= 1;
set FechaInicio			:= Par_FechaInicio;
set FechaInicioInt		:= Par_FechaInicio;
set Fre_DiasAnio		:= (select DiasCredito from PARAMETROSSIS);
 IF (Par_PagaIVA = Var_Si) THEN 
	SET Var_IVA	:= (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
ELSE
	SET Var_IVA	:= Decimal_Cero;
END IF;
SET Var_TasaISR	:= 0;


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
					Entero_Cero as consecutivo;
		else
			set Par_NumErr := 1;
			set Par_ErrMen := 'Especificar Frecuencia Pago.';
		end if ;
		LEAVE TerminaStore;
	end if ;
end if ;

if(ifnull(Par_Monto, Decimal_Cero))= Decimal_Cero then
	if (Par_Salida = Salida_SI) then
		select	'001' as Par_NumErr,
				'El monto esta Vacio.',
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
		set Par_NumErr 	:= 1;
		set Par_ErrMen 	:= 'El monto solicitado esta Vacio.';
	end if;
	LEAVE TerminaStore;
else
	if(Par_Monto < Entero_Cero)then
		if (Par_Salida = Salida_SI) then
			select '001' as Par_NumErr,
				'El monto no puede ser negativo.' as Par_ErrMen,
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
			set Par_NumErr 	:= 9;
			set Par_ErrMen 	:= 'El monto no puede ser negativo.';
		end if;
		LEAVE TerminaStore;
	end if;
end if;


-- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
CASE Par_PagoCuota
	when PagoSemanal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecSemanal day));
	when PagoCatorcenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecCator day));
	when PagoQuincenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*FrecQuin day));
	when PagoMensual	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas MONTH));
	when PagoPeriodo	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*Par_Frecu day));
	when PagoBimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*2 MONTH));
	when PagoTrimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*3 MONTH));
	when PagoTetrames	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*4 MONTH));
	when PagoSemestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*6 MONTH));
	when PagoAnual		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas YEAR));
	when PagoUnico		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_NumeroCuotas*Par_Frecu  day));
END CASE;


-- ASIGNA EL VALOR QUE LE CORRESPONDE EN FRECUENCIA EN DIAS SEGUN EL TIPO DE PAGO PARA CAPITAL
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
	when PagoUnico		then set Fre_Dias	:=  Par_Frecu; set Var_GraciaFaltaPag:= 0;
END CASE;

-- ASIGNA EL VALOR QUE LE CORRESPONDE EN FRECUENCIA EN DIAS SEGUN EL TIPO DE PAGO PARA INTERESES
CASE Par_PagoInter
	when PagoSemanal	then set Fre_DiasInt	:=  FrecSemanal;	set Var_GraciaFaltaPag:= 5;
	when PagoCatorcenal	then set Fre_DiasInt	:=  FrecCator; 		set Var_GraciaFaltaPag:= 10;
	when PagoQuincenal	then set Fre_DiasInt	:=  FrecQuin; 		set Var_GraciaFaltaPag:= 10;
	when PagoMensual	then set Fre_DiasInt	:=  FrecMensual; 	set Var_GraciaFaltaPag:= 20;
	when PagoPeriodo	then set Fre_DiasInt 	:=  Par_FrecuInt;
	when PagoBimestral	then set Fre_DiasInt	:=  FrecBimestral;	set Var_GraciaFaltaPag:= 40;
	when PagoTrimestral	then set Fre_DiasInt	:=  FrecTrimestral;	set Var_GraciaFaltaPag:= 60;
	when PagoTetrames	then set Fre_DiasInt	:=  FrecTetrames;	set Var_GraciaFaltaPag:= 80;
	when PagoSemestral	then set Fre_DiasInt	:=  FrecSemestral;	set Var_GraciaFaltaPag:= 120;
	when PagoAnual		then set Fre_DiasInt	:=  FrecAnual;		set Var_GraciaFaltaPag:= 240;
	when PagoUnico		then set Fre_DiasInt	:=  Par_Frecu; 		set Var_GraciaFaltaPag:= 0;
END CASE;

set Var_Cuotas		:= IFNULL(Par_NumeroCuotas, Entero_Cero);
set Var_CuotasInt	:= IFNULL(Par_NumCuotasInt, Entero_Cero);
set Capital			:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
set Insoluto		:= Par_Monto;

drop table if EXISTS Tmp_Amortizacion;
drop table if EXISTS Tmp_AmortizacionInt;
-- tabla temporal donde inserta las fechas de pago de capital
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

-- tabla temporal donde inserta las fechas de pago de intereses
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


-- -- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE CAPITAL
while (Contador <= Var_Cuotas) do
	-- pagos quincenales
	if (Par_PagoCuota = PagoQuincenal) then
		if ((cast(day(FechaInicio) as signed)*1) = FrecQuin) then
			set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
		else
			if ((cast(day(FechaInicio) as signed)*1) >28) then
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
		-- Pagos Mensuales
		if (Par_PagoCuota = PagoMensual) then
			-- Para pagos que se haran cada 30 dias
			if (Par_PagoFinAni != PagoFinMes) then
				if(Par_DiaMesCap>28)then
					set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
					set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
				-- Para pagos que se haran cada fin de mes
				if (Par_PagoFinAni = PagoFinMes) then
					/* se obtiene el final del mes.*/
					set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
				end if;
			end if;
		else
			 if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal or Par_PagoCuota = PagoUnico ) then
				  set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);

			 else

				if (Par_PagoCuota = PagoBimestral ) then
					if (Par_PagoFinAni != PagoFinMes ) then
						if(Par_DiaMesCap>28)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
						-- Para pagos que se haran en fin de mes
						if (Par_PagoFinAni = PagoFinMes) then
							if ((cast(day(FechaInicio) as signed)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
							else
								set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoTrimestral ) then
						-- Para pagos que se haran cada 90 dias
						if (Par_PagoFinAni != PagoFinMes) then
--
							if(Par_DiaMesCap>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
								set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
--
						 else
							-- Para pagos que se haran en fin de mes
							if (Par_PagoFinAni = PagoFinMes) then
								if ((cast(day(FechaInicio) as signed)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
								else
									set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY),char(12));
								end if;
							 end if;
						 end if;

					else
						if (Par_PagoCuota = PagoTetrames ) then
							-- Para pagos que se haran cada 120 dias
							if (Par_PagoFinAni != PagoFinMes) then
								if(Par_DiaMesCap>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAni = PagoFinMes) then
									if ((cast(day(FechaInicio) as signed)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
									else
										set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY),char(12));
									end if;
								end if;
							end if;

						else
							if (Par_PagoCuota = PagoSemestral ) then
								-- Para pagos que se haran cada 180 dias
								if (Par_PagoFinAni != PagoFinMes) then
									if(Par_DiaMesCap>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAni = PagoFinMes) then
										if ((cast(day(FechaInicio) as signed)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
										else
											set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if (Par_PagoCuota = PagoAnual ) then
									-- Para pagos que se haran cada 360 dias
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

	-- hace un ciclo para comparar los dias de gracia
	while ((cast(datediff(FechaVig, FechaInicio) as signed)*1) <= Var_GraciaFaltaPag ) do
		if (Par_PagoCuota = PagoQuincenal ) then
			if ((cast(day(FechaFinal) as signed)*1) = FrecQuin) then
				set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
			else
				if ((cast(day(FechaFinal) as signed)*1) >28) then
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
		-- Pagos Mensuales
			if (Par_PagoCuota = PagoMensual  ) then
				if (Par_PagoFinAni != PagoFinMes) then
					if(Par_DiaMesCap>28)then
						set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
						set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
					-- Para pagos que se haran cada fin de mes
					if (Par_PagoFinAni = PagoFinMes) then
						if ((cast(day(FechaFinal) as signed)*1)>=28)then
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
							set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
						else
						-- si no indica que es un numero menor y se obtiene el final del mes.
							set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY),char(12));
						end if;
					end if;
				end if ;
			else
				if ( Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal or Par_PagoCuota = PagoUnico) then
					set FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
				end if;
			end if;
		end if;
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;
	 end while;

	/* si el valor de la fecha final es mayoy a la de vencimiento en se ajusta */
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

	/* valida si se ajusta a fecha de exigibilidad o no*/
	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinal:= FechaVig;
	end if;

	set CapInt:= Var_Capital;

	set Consecutivo := (select ifnull(Max(Tmp_Consecutivo),Entero_Cero) + 1
					from Tmp_Amortizacion);

	set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

	INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
					values	(	Consecutivo,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);


set FechaInicio := FechaFinal;/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
			set Contador 	:= Var_Cuotas+1;
		end if;
	end if;

	if((Contador+1) = Var_Cuotas )then

		#Ajuste Saldo
		-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinal 	:= Par_FechaVenc;
		else
			-- pagos quincenales
			if (Par_PagoCuota = PagoQuincenal) then
				if ((cast(day(FechaInicio) as signed)*1) = FrecQuin) then
					set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
				else
					if ((cast(day(FechaInicio) as signed)*1) >28) then
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
			else 		-- Pagos Mensuales
				if (Par_PagoCuota = PagoMensual) then
					-- Para pagos que se haran cada 30 dias
					if (Par_PagoFinAni != PagoFinMes) then
						if(Par_DiaMesCap>28)then
							set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicio, interval 1 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
						-- Para pagos que se haran cada fin de mes
						if (Par_PagoFinAni = PagoFinMes) then
							if ((cast(day(FechaInicio) as signed)*1)>=28)then
								set FechaFinal := convert(DATE_ADD(FechaInicio, interval 2 month),char(12));
								set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
							else
							-- si no indica que es un numero menor y se obtiene el final del mes.
								set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal or Par_PagoCuota = PagoUnico ) then
						set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
					else
						if (Par_PagoCuota = PagoBimestral ) then
							if (Par_PagoFinAni != PagoFinMes ) then
								if(Par_DiaMesCap>28)then
									set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 2 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAni = PagoFinMes) then
									if ((cast(day(FechaInicio) as signed)*1)>=28)then
										set FechaFinal := convert(DATE_ADD(FechaInicio, interval 3 month),char(12));
										set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
									else
										set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoCuota = PagoTrimestral ) then
								-- Para pagos que se haran cada 90 dias
								if (Par_PagoFinAni != PagoFinMes) then
									if(Par_DiaMesCap>28)then
										set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 3 month)),char(2)) , '-' ,  28),date);
										set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAni = PagoFinMes) then
										if ((cast(day(FechaInicio) as signed)*1)>=28)then
											set FechaFinal := convert(DATE_ADD(FechaInicio, interval 4 month),char(12));
											set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
										else
											set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY),char(12));
										end if;
									end if;
								end if;

							else
								if (Par_PagoCuota = PagoTetrames ) then
									-- Para pagos que se haran cada 120 dias
									if (Par_PagoFinAni != PagoFinMes) then
										if(Par_DiaMesCap>28)then
											set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 4 month)),char(2)) , '-' , 28),date);
											set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
										-- Para pagos que se haran en fin de mes
										if (Par_PagoFinAni = PagoFinMes) then
											if ((cast(day(FechaInicio) as signed)*1)>=28)then
												set FechaFinal := convert(DATE_ADD(FechaInicio, interval 5 month),char(12));
												set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
											else
												set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY),char(12));
											end if;
										end if;
									end if;

								else
									if (Par_PagoCuota = PagoSemestral ) then
										-- Para pagos que se haran cada 180 dias
										if (Par_PagoFinAni != PagoFinMes) then
											if(Par_DiaMesCap>28)then
												set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaInicio, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicio, interval 6 month)),char(2)) , '-' , 28),date);
												set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
											-- Para pagos que se haran en fin de mes
											if (Par_PagoFinAni = PagoFinMes) then
												if ((cast(day(FechaInicio) as signed)*1)>=28)then
													set FechaFinal := convert(DATE_ADD(FechaInicio, interval 7 month),char(12));
													set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
												else
													set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY),char(12));
												end if;
											end if;
										end if;

									else
										if (Par_PagoCuota = PagoAnual ) then
											-- Para pagos que se haran cada 360 dias
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
			-- hace un ciclo para comparar los dias de gracia
			while ((datediff(FechaVig, FechaInicio)*1) <= Var_GraciaFaltaPag ) do
				if (Par_PagoCuota = PagoQuincenal ) then
					if ((cast(day(FechaFinal) as signed)*1) = FrecQuin) then
						set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
					else
						if ((cast(day(FechaFinal) as signed)*1) >28) then
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
				-- Pagos Mensuales
					if (Par_PagoCuota = PagoMensual  ) then
						if (Par_PagoFinAni != PagoFinMes) then
							if(Par_DiaMesCap>28)then
								set FechaFinal := convert(	concat(convert(year(DATE_ADD(FechaFinal, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinal, interval 1 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := cast(day(LAST_DAY(FechaFinal)) as signed)*1;
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
							-- Para pagos que se haran cada fin de mes
							if (Par_PagoFinAni = PagoFinMes) then
								if ((cast(day(FechaFinal) as signed)*1)>=28)then
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval 2 month),char(12));
									set FechaFinal := convert(DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal) as signed) day),char(12));
								else
								-- si no indica que es un numero menor y se obtiene el final del mes.
									set FechaFinal:= convert(DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY),char(12));
								end if;
							end if;
						end if ;
					else
						if ( Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal or Par_PagoCuota = PagoUnico) then
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
		-- Obtiene el dia habil siguiente o anterior
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

		else
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;
		/* valida si se ajusta a fecha de exigibilidad o no*/
		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinal:= FechaVig;
		end if;
		set CapInt:= Var_Capital;
		set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
		INSERT into Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
					values	(	Consecutivo+1,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
		if (Par_AjustaFecAmo = Var_SI)then
			if (Par_FechaVenc <=  FechaFinal) then
				set Contador 	:= Var_Cuotas+1;
			end if;
		end if;
		set Contador = Contador+1;
	end if;
	set Contador = Contador+1;
end while;



-- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE LOS INTERESES
while (ContadorInt <= Var_CuotasInt ) do
	-- pagos quincenales
	if (Par_PagoInter = PagoQuincenal) then
		if ((cast(day(FechaInicioInt) as signed)*1) = FrecQuin) then
			set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
		else
			if ((cast(day(FechaInicioInt) as signed)*1) >28) then
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
		-- Pagos Mensuales
		if (Par_PagoInter = PagoMensual) then
			-- Para pagos que se haran cada 30 dias de Intereses
			if (Par_PagoFinAniInt != PagoFinMes) then
				if(Par_DiaMesInt>28)then
					set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
											 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , 28),date);
					set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
				-- Para pagos que se haran cada fin de mes
				if (Par_PagoFinAniInt = PagoFinMes) then
					/* obtiene el final del mes.*/
					set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY),char(12));
				end if;
			end if;
		else
			if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal or Par_PagoInter = PagoUnico) then
				set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
			else
				if ( Par_PagoInter = PagoBimestral) then
					-- Para pagos que se haran cada 60 dias Intereses
					if (Par_PagoFinAniInt != PagoFinMes ) then
						if(Par_DiaMesInt>28)then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
						-- Para pagos que se haran en fin de mes
						if (Par_PagoFinAniInt = PagoFinMes) then
							if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
							else
								set FechaFinalInt	:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 2 month), interval -1 * day(FechaInicioInt) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if (Par_PagoInter = PagoTrimestral) then
						-- Para pagos que se haran cada 90 dias IntereseS
						if (Par_PagoFinAniInt != PagoFinMes) then
							if(Par_DiaMesInt>28)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' ,  28),date);
								set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
							-- Para pagos que se haran en fin de mes
							if (Par_PagoFinAniInt = PagoFinMes) then
								if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
								else
									set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 3 month), interval -1 * day(FechaInicioInt) DAY),char(12));
								end if;
							end if;
						end if;
					else
						if ( Par_PagoInter = PagoTetrames) then
							-- Para pagos que se haran cada 120 dias interes
							if (Par_PagoFinAniInt != PagoFinMes) then
								if(Par_DiaMesInt>28)then
									set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAniInt = PagoFinMes) then
									if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
									else
										set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 4 month), interval -1 * day(FechaInicioInt) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoInter = PagoSemestral) then
								-- Para pagos que se haran cada 180 dias Interes
								if (Par_PagoFinAniInt != PagoFinMes) then
									if(Par_DiaMesInt>28)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
											convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , 28),date);
										set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAniInt = PagoFinMes) then
										if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
										else
											set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 6 month), interval -1 * day(FechaInicioInt) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if ( Par_PagoInter = PagoAnual) then
									-- Para pagos que se haran cada 360 diasInteres
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
		call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	-- hace un ciclo para comparar los dias de gracia
	while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) do
		if (Par_PagoInter = PagoQuincenal ) then
			if ((cast(day(FechaFinalInt) as signed)*1) = FrecQuin) then
				set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
			else
				if ((cast(day(FechaFinalInt) as signed)*1) >28) then
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
		-- Pagos Mensuales
			if (Par_PagoInter = PagoMensual  ) then
				if (Par_PagoFinAniInt != PagoFinMes) then
					if(Par_DiaMesInt>28)then
						set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
												 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , 28),date);
						set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
					-- Para pagos que se haran cada fin de mes
					if (Par_PagoFinAniInt = PagoFinMes) then
						if ((cast(day(FechaFinalInt) as signed)*1)>=28)then
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
							set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
						else
						-- si no indica que es un numero menor y se obtiene el final del mes.
							set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY),char(12));
						end if;
					end if;
				end if ;
			else
				if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal or Par_PagoInter = PagoUnico) then
					set FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
				end if;
			end if;
		end if;
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else
			call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;
	end while;
	/*si la fecha final es mayor a la de vencimiento se ajusta */
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
		call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	end if;
	/* valida si se ajusta a fecha de exigibilidad o no*/
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
		#Ajuste Saldo
		-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinalInt	:= Par_FechaVenc;
		else
			-- pagos quincenales
			if (Par_PagoInter = PagoQuincenal) then
				if ((cast(day(FechaInicioInt) as signed)*1) = FrecQuin) then
					set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY);
				else
					if ((cast(day(FechaInicioInt) as signed)*1) >28) then
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
				-- Pagos Mensuales
				if (Par_PagoInter = PagoMensual) then
					-- Para pagos que se haran cada 30 dias de Intereses
					if (Par_PagoFinAniInt = PagoAniver) then
						if(Par_DiaMesInt>28)then
							set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 1 month)),char(4)) , '-' ,
													 convert(month(DATE_ADD(FechaInicioInt, interval 1 month)),char(2)) , '-' , 28),date);
							set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
						-- Para pagos que se haran cada fin de mes
						if (Par_PagoFinAniInt = PagoFinMes) then
							if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
								set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 2 month),char(12));
								set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
							else
							-- si no indica que es un numero menor y se obtiene el final del mes.
								set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 1 month), interval -1 * day(FechaInicioInt) DAY),char(12));
							end if;
						end if;
					end if;
				else
					if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal or Par_PagoInter = PagoUnico) then
						set FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
					else
						if ( Par_PagoInter = PagoBimestral) then
							-- Para pagos que se haran cada 60 dias Intereses
							if (Par_PagoFinAniInt != PagoFinMes ) then
								if(Par_DiaMesInt>28)then
									set FechaFinalInt := convert(concat(convert(year(DATE_ADD(FechaInicioInt, interval 2 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 2 month)),char(2)) , '-' , 28),date);
									set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAniInt = PagoFinMes) then
									if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
										set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 3 month),char(12));
										set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
									else
										set FechaFinalInt	:= convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 2 month), interval -1 * day(FechaInicioInt) DAY),char(12));
									end if;
								end if;
							end if;
						else
							if (Par_PagoInter = PagoTrimestral) then
								-- Para pagos que se haran cada 90 dias IntereseS
								if (Par_PagoFinAniInt != PagoFinMes) then
									if(Par_DiaMesInt>28)then
										set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 3 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 3 month)),char(2)) , '-' ,  28),date);
										set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
								ELSE
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAniInt = PagoFinMes) then
										if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
											set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 4 month),char(12));
											set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
										else
											set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 3 month), interval -1 * day(FechaInicioInt) DAY),char(12));
										end if;
									end if;
								end if;
							else
								if ( Par_PagoInter = PagoTetrames) then
									-- Para pagos que se haran cada 120 dias interes
									if (Par_PagoFinAniInt != PagoFinMes) then
										if(Par_DiaMesInt>28)then
											set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 4 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 4 month)),char(2)) , '-' , 28),date);
											set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
										-- Para pagos que se haran en fin de mes
										if (Par_PagoFinAniInt = PagoFinMes) then
											if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
												set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 5 month),char(12));
												set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
											else
												set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 4 month), interval -1 * day(FechaInicioInt) DAY),char(12));
											end if;
										end if;
									end if;
								else
									if (Par_PagoInter = PagoSemestral) then
										-- Para pagos que se haran cada 180 dias Interes
										if (Par_PagoFinAniInt != PagoFinMes) then
											if(Par_DiaMesInt>28)then
												set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaInicioInt, interval 6 month)),char(4)) , '-' ,
													convert(month(DATE_ADD(FechaInicioInt, interval 6 month)),char(2)) , '-' , 28),date);
												set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
											-- Para pagos que se haran en fin de mes
											if (Par_PagoFinAniInt = PagoFinMes) then
												if ((cast(day(FechaInicioInt) as signed)*1)>=28)then
													set FechaFinalInt := convert(DATE_ADD(FechaInicioInt, interval 7 month),char(12));
													set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
												else
													set FechaFinalInt := convert(DATE_ADD(DATE_ADD(FechaInicioInt, interval 6 month), interval -1 * day(FechaInicioInt) DAY),char(12));
												end if;
											end if;
										end if;
									else
										if ( Par_PagoInter = PagoAnual) then
											-- Para pagos que se haran cada 360 diasInteres
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
				call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;
			-- hace un ciclo para comparar los dias de gracia
			while ( (datediff(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) do
				if (Par_PagoInter = PagoQuincenal ) then
					if ((cast(day(FechaFinalInt) as signed)*1) = FrecQuin) then
						set FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY);
					else
						if ((cast(day(FechaFinalInt) as signed)*1) >28) then
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
				-- Pagos Mensuales
					if (Par_PagoInter = PagoMensual  ) then
						if (Par_PagoFinAniInt != PagoFinMes) then
							if(Par_DiaMesInt>28)then
								set FechaFinalInt := convert(	concat(convert(year(DATE_ADD(FechaFinalInt, interval 1 month)),char(4)) , '-' ,
														 convert(month(DATE_ADD(FechaFinalInt, interval 1 month)),char(2)) , '-' , 28),date);
								set Var_UltDia := cast(day(LAST_DAY(FechaFinalInt)) as signed)*1;
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
							-- Para pagos que se haran cada fin de mes
							if (Par_PagoFinAniInt = PagoFinMes) then
								if ((cast(day(FechaFinalInt) as signed)*1)>=28)then
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval 2 month),char(12));
									set FechaFinalInt := convert(DATE_ADD(FechaFinalInt, interval -1*cast(day(FechaFinalInt) as signed) day),char(12));
								else
								-- si no indica que es un numero menor y se obtiene el final del mes.
									set FechaFinalInt:= convert(DATE_ADD(DATE_ADD(FechaFinalInt, interval 1 month), interval -1 * day(FechaFinalInt) DAY),char(12));
								end if;
							end if;
						end if ;
					else
						if ( Par_PagoInter = PagoSemanal or Par_PagoInter = PagoPeriodo or Par_PagoInter = PagoCatorcenal or Par_PagoInter = PagoUnico ) then
							set FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
						end if;
					end if;
				end if;
				if(Par_DiaHabilSig = Var_SI) then
					call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
													Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
													Aud_NumTransaccion);
				else
					call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				end if;

			end while;
		end if;
		-- Obtiene el dia habil siguiente o anterior
		if(Par_DiaHabilSig = Var_SI) then
			call DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else
			call DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;

		set CapInt:= Var_Interes;
		/* valida si se ajusta a fecha de exigibilidad o no*/
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


-- INICIALIZO VARIABLES DE CONTROL
set Contador := 1;
set ContadorCap := 1;
set ContadorInt := 1;
set Consecutivo := 1;

-- COMPARO EL NUMERO DE LAS CUOTAS PARA SABER CUAL ES LA MAYOR
if (Var_Cuotas >= Var_CuotasInt) then
	 set Var_Amor := Var_Cuotas;
  else
	set Var_Amor := Var_CuotasInt;
end if;
select Tmp_FecIni, Tmp_FecFin into FechaInicio, FechaFinal from Tmp_Amortizacion where Tmp_Consecutivo = Contador;
select Tmp_FecIni, Tmp_FecFin into FechaInicioInt, FechaFinalInt from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;

-- INICIO UN CICLO PARA REACOMODAR LAS FECHAS PARA GENERAR UN CALENDARIO PARA MOSTRAR AL CLIENTE
while (Contador <= Var_Amor) do
	if (FechaFinal<FechaFinalInt)then
		set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

		if (ContadorInt = Var_CuotasInt)then
			set Var_TipoCap	:= Var_CapInt;
		else
			 set Var_TipoCap	:= Var_Capital;
		 end if;
		insert into TMPPAGAMORSIM (
				Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
				Tmp_CapInt,			NumTransaccion)
		select	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
				Var_TipoCap,		Aud_NumTransaccion
		from	Tmp_Amortizacion
		where Tmp_Consecutivo = ContadorCap;

		set FechaInicio := FechaFinal;

		if (ContadorInt <= Var_CuotasInt)then
			if (ContadorInt>1)then
				set ContadorInt := ContadorInt-1;
			else
				set ContadorInt :=0 ; end if;
		end if;
	else
		if (FechaFinal=FechaFinalInt)then
			set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

			insert into TMPPAGAMORSIM (
					Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,			NumTransaccion)
			select	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Var_CapInt,			Aud_NumTransaccion
			from	Tmp_Amortizacion
			where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
		else
			if (FechaFinal> FechaFinalInt)then

				set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				if (ContadorInt = Var_CuotasInt)then
					set Var_TipoCap	:= Var_CapInt;
				else
					set Var_TipoCap	:= Var_Interes;
				end if;

				insert into TMPPAGAMORSIM (
						Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
						Tmp_CapInt,			NumTransaccion)
				select 	Consecutivo,		Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						-- case  when Contador+1 > Var_Amor then Var_CapInt else Tmp_CapInt end ,			Aud_NumTransaccion
						Tmp_CapInt ,		Aud_NumTransaccion
				from	Tmp_AmortizacionInt
				where	Tmp_Consecutivo = ContadorInt;

				if (ContadorCap <= Var_Cuotas)then
					if (ContadorCap>1)then set ContadorCap := ContadorCap-1;else set ContadorCap :=0 ; end if;
				end if;
				set FechaInicio := FechaFinalInt;
			end if;
		end if;
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

-- AJUSTE DE FECHAS, INSERTA EL ULTIMO REGISTRO DE LA TABLA.
if (ContadorCap = Var_Cuotas) then /* si el contador de capital es = al numero de cuotas consideradas */
	if(ContadorInt = Var_CuotasInt) then /* si el contador de interes  es = al numero de cuotas de interes  consideradas */
		select  Tmp_FecFin into FechaFinal from Tmp_Amortizacion where Tmp_Consecutivo =ContadorCap;
		select  Tmp_FecFin into FechaFinalInt from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;

		if (FechaFinal<FechaFinalInt)then/* si la fecha final  de capital es menor que la de  interes  */
			set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
				select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Var_CapInt,	Aud_NumTransaccion
					from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
			set FechaInicio := FechaFinal;
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt, 		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
		else /* si la fecha final  de capital no  es menor que la de  interes  */
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
		end if; /* fin de si la fecha final  de capital es menor que la de  interes  */

		if (FechaFinal> FechaFinalInt)then
			set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
			set FechaInicio := FechaFinal;
			set Consecutivo := Consecutivo+1;
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
							select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		end if;
	else /* si el contador de interes  no es igual al numero de cuotas de interes  consideradas */
		set Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
		insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
								Tmp_CapInt,		NumTransaccion)
			select Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Var_CapInt,	Aud_NumTransaccion
				from Tmp_Amortizacion where Tmp_Consecutivo = ContadorCap;
		set FechaInicio := FechaFinal;
	end if;
else
	if(ContadorInt = Var_CuotasInt) then
		set Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
			insert into TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
						select 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,	Aud_NumTransaccion
							from Tmp_AmortizacionInt where Tmp_Consecutivo = ContadorInt;
	end if;

end if;

-- INICIO UN CICLO PARA CALCULO DE CAPITAL Y/O  INTERESES
set Contador := 1;
select max(Tmp_Consecutivo) into ContadorInt from TMPPAGAMORSIM where NumTransaccion= Aud_NumTransaccion;
while (Contador <= ContadorInt) do
	select Tmp_Dias, Tmp_CapInt into Fre_Dias, CapInt from TMPPAGAMORSIM where Tmp_Consecutivo = Contador and NumTransaccion= Aud_NumTransaccion ;
	if (CapInt= Var_Interes) then
		set Capital		:= Decimal_Cero;
	else
		set Capital	:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
	end if;

	if (Insoluto<=Capital) then
		set Capital := Insoluto;
	end if;

	set Insoluto	:= Insoluto - Capital;
	SET Var_MontInt := ROUND(Fre_Dias * Par_Tasa * (Capital + Insoluto) / anualTotal ,2);
	SET Var_IVAInteres := Var_MontInt * Var_IVA;
	SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / anualTotal, 2);
	SET Subtotal	:= Capital + Var_MontInt + Var_IVAInteres - Var_Retencion;

	update TMPPAGAMORSIM set
		Tmp_Capital	= Capital,
		Tmp_Insoluto	= Insoluto,
		Tmp_Interes = Var_MontInt,
		Tmp_Iva = Var_IVAInteres,
		Tmp_Retencion	= Var_Retencion,
		Tmp_SubTotal = Subtotal
	where Tmp_Consecutivo = Contador
	and NumTransaccion= Aud_NumTransaccion;

	if((Contador+1) = ContadorInt)then
		select Tmp_Dias, Tmp_CapInt into Fre_Dias, CapInt from TMPPAGAMORSIM where Tmp_Consecutivo = Contador +1 and NumTransaccion= Aud_NumTransaccion;
		set Contador = Contador+1;
		select Tmp_Insoluto into Insoluto from TMPPAGAMORSIM where Tmp_Consecutivo = Contador-1 and NumTransaccion= Aud_NumTransaccion;
		#Ajuste
		if (CapInt= Var_Interes) then
			set Capital		:= Decimal_Cero;
		else
			if (CapInt= Var_CapInt) then
				set Capital	:= Insoluto;
			else
				set Capital	:= Insoluto;
			end if;
		end if;
		if (Insoluto<=Capital) then
			set Capital := Insoluto;
		end if;
		set Insoluto	:= Insoluto - Capital;


		SET Var_MontInt := ROUND(Fre_Dias * Par_Tasa * (Capital + Insoluto) / anualTotal ,2);
		SET Var_IVAInteres := Var_MontInt * Var_IVA;
		SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / anualTotal, 2);
		SET Subtotal	:= Capital + Var_MontInt + Var_IVAInteres - Var_Retencion;

		update TMPPAGAMORSIM set
			Tmp_Capital	= Capital,
			Tmp_Insoluto = Insoluto,
			Tmp_Interes = Var_MontInt,
			Tmp_Iva = Var_IVAInteres,
			Tmp_Retencion	= Var_Retencion,
			Tmp_SubTotal = Subtotal
		where Tmp_Consecutivo = Contador
		and  NumTransaccion= Aud_NumTransaccion;

		set Contador = Contador+1;
	end if;
	set Contador = Contador+1;
end while;

-- COMPARO SI EL ULTIMO REGISTRO DE LA TABLA TMPPAGAMORSIM ES CERO, ELIMINO EL REGISTRO.
select max(Tmp_Consecutivo) into Consecutivo from TMPPAGAMORSIM where NumTransaccion= Aud_NumTransaccion;
select ifnull(Tmp_Capital,Decimal_Cero), Tmp_CapInt into Capital, CapInt from TMPPAGAMORSIM where Tmp_Consecutivo = Consecutivo and NumTransaccion= Aud_NumTransaccion;
if ( Capital = Decimal_Cero) then
	delete from TMPPAGAMORSIM where Tmp_Consecutivo = Consecutivo and NumTransaccion= Aud_NumTransaccion;
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



-- se determina cual es la fecha de vencimiento
set Par_FechaVenc := (select max(Tmp_FecFin) from TMPPAGAMORSIM where 	NumTransaccion = Aud_NumTransaccion);

-- Se muestran los datos
if (Par_Salida = Salida_SI) then
select	Tmp_Consecutivo,						Tmp_FecIni,		Tmp_FecFin,			Tmp_FecVig,					FORMAT(Tmp_Capital,2)as Tmp_Capital,
		FORMAT(Tmp_Insoluto,2)as Tmp_Insoluto,	Tmp_Dias,		Tmp_CapInt,			Var_Cuotas,  				Var_CuotasInt,
		NumTransaccion,							Par_FechaVenc, 	Par_FechaInicio,	Entero_Cero as MontoCuota,  FORMAT(Tmp_Interes,2) as Tmp_Interes,
		FORMAT(Tmp_Iva,2)AS Tmp_Iva,			FORMAT(IFNULL(Tmp_Retencion,0),2) as Tmp_Retencion,				FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal
	from	TMPPAGAMORSIM
	where NumTransaccion= Aud_NumTransaccion;
end if ;

set Par_NumErr 		:= 0;
set Par_ErrMen 		:= 'Cuotas generadas';
set Par_NumTran		:= Aud_NumTransaccion;
set Par_MontoCuo	:= Entero_Cero;
Set Par_FechaVen	:= Par_FechaVenc;
Set Par_Cuotas		:= Var_Cuotas;
Set Par_CuotasInt	:= Var_CuotasInt;

 drop table Tmp_Amortizacion;
 drop table Tmp_AmortizacionInt;

-- DROP procedure IF EXISTS `CRETASVARAMORPRO`;
END TerminaStore$$
