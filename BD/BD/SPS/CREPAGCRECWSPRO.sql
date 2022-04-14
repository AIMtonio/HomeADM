-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGCRECWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGCRECWSPRO`;DELIMITER $$

CREATE PROCEDURE `CREPAGCRECWSPRO`(
	Par_Monto			decimal(14,2),	#Monto a prestar
	Par_PagoCuota		char(1),			-- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_Plazo			int,
	Par_Tasa			decimal(14,2),	#Tasa Anualizada
	Par_FechaInicio		date	,			-- fecha en que empiezan los pagos

	Par_AjustaFecAmo	char(1),		-- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	Par_ComAper			decimal(14,2), -- Monto de la comision por apertura
	Par_ForCobComAp		char(1),			-- Forma de cobro de la comision por apertura
    Par_ComAnualLin		DECIMAL(12,2),		-- Monto Comisión por Anualidad Línea de Crédito
	Par_Salida    		char(1),			-- Indica si hay una salida o no

    inout Par_NumErr 	int,
    inout Par_ErrMen  	varchar(350),

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN
-- Declaracion de Constantes
DECLARE Cadena_Vacia		char(1);
DECLARE Decimal_Cero		decimal(14,2);
DECLARE Entero_Cero			int;
DECLARE Entero_Uno			int;
DECLARE Entero_Negativo		int;
DECLARE Fecha_Vacia   		date;
DECLARE Var_SI				char(1);	-- SI
DECLARE Var_No				char(1);	-- NO
DECLARE PagoSemanal			char(1);	-- Pago Semanal (S)
DECLARE PagoCatorcenal		char(1);	-- Pago Catorcenal (C)
DECLARE PagoQuincenal		char(1);	-- Pago Quincenal (Q)
DECLARE PagoMensual			char(1);	-- Pago Mensual (M)
DECLARE PagoPeriodo			char(1);	-- Pago por periodo (P)
DECLARE PagoBimestral		char(1);	-- PagoBimestral (B)
DECLARE PagoTrimestral		char(1);	-- PagoTrimestral (T)
DECLARE PagoTetrames		char(1);	-- PagoTetraMestral (R)
DECLARE PagoSemestral		char(1);	-- PagoSemestral (E)
DECLARE PagoAnual			char(1);	-- PagoAnual (A)
DECLARE PagoFinMes			char(1);	-- Pago al final del mes (F)
DECLARE PagoAniver			char(1);	-- Pago por aniversario (A)
DECLARE FrecSemanal			int;		-- frecuencia semanal en dias
DECLARE FrecCator			int;		-- frecuencia Catorcenal en dias
DECLARE FrecQuin			int;		-- frecuencia en dias quincena
DECLARE FrecMensual			int;		-- frecuencia mensual
DECLARE FrecBimestral		int;		-- Frecuencia en dias Bimestral
DECLARE FrecTrimestral		int;		-- Frecuencia en dias Trimestral
DECLARE FrecTetrames		int;		-- Frecuencia en dias TetraMestral
DECLARE FrecSemestral		int;		-- Frecuencia en dias Semestral
DECLARE FrecAnual			int;		-- frecuencia en dias Anual

DECLARE Par_PagoFinAni		char(1);	-- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)
DECLARE Par_DiaMes			int(2);	-- Si escoge en pago por aniversario, puede especificar un dia del mes (1 -31) segun el mes en que se encuentre
DECLARE Par_DiaHabilSig		char(1);	-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
DECLARE Par_AjusFecExiVen	char(1);	-- Indica si se ajusta la fecha de exigibilidad a fecha de vencimiento (S- si se ajusta N- no se ajusta)

DECLARE Per_Semanal	 		char(1);
DECLARE Per_Catorcenal		char(1);
DECLARE Per_Quincenal	 	char(1);
DECLARE Per_Mensual	 		char(1);
DECLARE ComApDeduc	 		char(1);
DECLARE ComApFinan	 		char(1);
DECLARE	Salida_SI			char(1);
DECLARE NumIteraciones		int;

--  Declaracion de Variables
DECLARE Var_UltDia			int;
DECLARE Var_CadCuotas		varchar(8000);
DECLARE Contador			int;
DECLARE ContadorMargen		int;
DECLARE FechaInicio			date;
DECLARE FechaFinal			date;
DECLARE FechaVig			date;
DECLARE Var_EsHabil			char(1);
DECLARE Var_Cuotas			int;
DECLARE Tas_Periodo			decimal(14,6);
DECLARE Pag_Calculado		decimal(14,2);
DECLARE Capital				decimal(14,2);
DECLARE Interes				decimal(14,2);
DECLARE IvaInt				decimal(14,2);
DECLARE Subtotal			decimal(14,2);
DECLARE Insoluto			decimal(14,2);
DECLARE Var_IVA				decimal(14,2);
DECLARE Fre_DiasAnio		int;		-- dias del año
DECLARE Fre_Dias			int;		-- numero de dias
DECLARE Fre_DiasTab			int;		-- numero de dias para pagos de capital
DECLARE Var_GraciaFaltaPag	int;		-- dias de gracia
DECLARE Var_MargenPagIgual	int;		-- Margen para pagos iguales
DECLARE Var_Diferencia		decimal(14,2);
DECLARE Var_Ajuste			decimal(14,2);
DECLARE Var_CtePagIva		char(1);	-- Cliente Paga Iva S si N no
DECLARE Var_PagaIVA			char(1);
DECLARE Par_FechaVenc		date	;		-- fecha vencimiento en que terminan los pagos
DECLARE Var_CoutasAmor		varchar(8000);
DECLARE Var_CAT 	     	decimal(14,4);
DECLARE Var_MontoCuota    	decimal(14,2);
DECLARE Var_TotalPagar    	decimal(14,2);
DECLARE Var_FrecuPago		int;
DECLARE Par_NumErr 			int;
DECLARE Par_ErrMen  		varchar(350);
DECLARE CuotaSinIva			decimal(14,2);


-- asignacion de constantes
set Cadena_Vacia		:= '';
set Decimal_Cero		:= 0.00;
set Entero_Cero			:= 0;
set Entero_Uno			:= 1;
set Entero_Negativo		:= -1;
set	Fecha_Vacia			:= '1900-01-01';
set Var_SI				:= 'S';
set Var_No				:= 'N';
set PagoSemanal			:= 'S'; -- PagoSemanal
set PagoCatorcenal		:= 'C'; -- PagoCatorcenal
set PagoQuincenal		:= 'Q'; -- PagoQuincenal
set PagoMensual			:= 'M'; -- PagoMensual
set PagoPeriodo			:= 'P'; -- PagoPeriodo
set PagoBimestral		:= 'B'; -- PagoBimestral
set PagoTrimestral		:= 'T'; -- PagoTrimestral
set PagoTetrames		:= 'R'; -- PagoTetraMestral
set PagoSemestral		:= 'E'; -- PagoSemestral
set PagoAnual			:= 'A'; -- PagoAnual
set PagoFinMes			:= 'F'; -- PagoFinMes
set PagoAniver			:= 'A'; -- Pago por aniversario
set FrecSemanal			:= 7;	-- frecuencia semanal en dias
set FrecCator			:= 14;	-- frecuencia Catorcenal en dias
set FrecQuin			:= 15;	-- frecuencia en dias de quincena
set FrecMensual			:= 30;	-- frecuencia mesual

set FrecBimestral		:= 60;	-- Frecuencia en dias Bimestral
set FrecTrimestral		:= 90;	-- Frecuencia en dias Trimestral
set FrecTetrames		:= 120;	-- Frecuencia en dias TetraMestral
set FrecSemestral		:= 180;	-- Frecuencia en dias Semestral
set FrecAnual			:= 360;	-- frecuencia en dias Anual

set Par_PagoFinAni		:= 'A'; 	-- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)
set Par_DiaMes			:= day(Par_FechaInicio);
set Par_DiaHabilSig		:= 'S'; 	-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
set Var_PagaIVA			:= Var_Si;
set Var_GraciaFaltaPag	:= 10;
set Var_MargenPagIgual	:= 10;
set Par_AjusFecExiVen	:= 'N';		-- Indica si se ajusta la fecha de exigibilidad a fecha de vencimiento (S- si se ajusta N- no se ajusta)

set 	Per_Semanal		:='S';
set 	Per_Catorcenal	:='C';
set 	Per_Quincenal	:='Q';
set 	Per_Mensual		:='M';
set 	ComApDeduc		:='D';
set 	ComApFinan		:='F';
Set Salida_SI			:= 'S';
set NumIteraciones		:= '100';

-- asignacion de variables
set Contador		:= 1;
set ContadorMargen	:= 1;
set FechaInicio		:= Par_FechaInicio;
set Var_IVA			:= (select IVA from SUCURSALES where SucursalID = Aud_Sucursal);
set Fre_DiasAnio		:= (select DiasCredito from PARAMETROSSIS);
set Var_CoutasAmor	:= '';
set Var_CAT			:= 0.0000;
set Var_MontoCuota	:= 0.00;
set Var_TotalPagar	:= 0.00;
set Var_FrecuPago 	:= 0;
set CuotaSinIva		:= 0.0;
set Par_NumErr  	:= Entero_Cero;
set Par_ErrMen  	:= Cadena_Vacia;



BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CREPAGCRECWSPRO");
	    	set Var_MontoCuota := 0;
		set Var_Cuotas	:=0;
		set Var_TotalPagar:= 0;
		set Var_CAT 	:= 0;
    END;

-- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad

CASE Par_PagoCuota
	when PagoSemanal		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*FrecSemanal day));
	when PagoCatorcenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*FrecCator day));
	when PagoQuincenal	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*FrecQuin day));
	when PagoMensual		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo MONTH));
	when PagoPeriodo		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*Par_Frecu day));
	when PagoBimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*2 MONTH));
	when PagoTrimestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*3 MONTH));
	when PagoTetrames		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*4 MONTH));
	when PagoSemestral	then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo*6 MONTH));
	when PagoAnual		then set Par_FechaVenc := (select date_add(Par_FechaInicio, interval Par_Plazo YEAR));
else
set Par_PagoCuota := Cadena_Vacia;

END CASE;

if(ifnull(Par_Monto, Decimal_Cero))= Decimal_Cero then
	if (Par_Salida = Salida_SI) then
		select	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'001' as Par_NumErr,
				'El monto solicitado esta Vacio.' as Par_ErrMen;
	else
		set Par_NumErr 	:= 1;
		set Par_ErrMen 	:= 'El monto solicitado esta Vacio.';
	end if;
	LEAVE TerminaStore;
else
	if(Par_Monto < Entero_Cero)then
		if (Par_Salida = Salida_SI) then
			select	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'009' as Par_NumErr,
				'El monto no puede ser negativo.' as Par_ErrMen;
		else
			set Par_NumErr 	:= 9;
			set Par_ErrMen 	:= 'El monto no puede ser negativo.';
		end if;
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_PagoCuota, ''))= '' then
	if (Par_Salida = Salida_SI) then
		select 	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'002' as Par_NumErr,
				'La frecuencia esta Vacia.' as Par_ErrMen;
	else
		set Par_NumErr 	:= 2;
		set Par_ErrMen 	:= 'La frecuencia esta Vacia.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Plazo, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'003' as Par_NumErr,
				'El Plazo esta Vacio.' as Par_ErrMen;
	else
		set Par_NumErr 	:= 3;
		set Par_ErrMen 	:= 'El Plazo esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Tasa, Decimal_Cero))= Decimal_Cero then
	if (Par_Salida = Salida_SI) then
		select	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'004' as Par_NumErr,
				'La Tasa Anualizada esta Vacia.' as Par_ErrMen;
	else
		set Par_NumErr 	:= 4;
		set Par_ErrMen 	:= 'La Tasa Anualizada esta Vacia.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_FechaInicio, Fecha_Vacia))= Fecha_Vacia then
	if (Par_Salida = Salida_SI) then
		select	Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				'005' as NumErr,
				'La Fecha de Inicio esta Vacia.' as ErrMen;
	else
		set Par_NumErr 	:= 5;
		set Par_ErrMen 	:= 'La Fecha de Inicio esta Vacia.' ;
	end if;
	LEAVE TerminaStore;
end if;

/*Compara el valor de pago de la cuota para asiganrle un valor en dias*/
CASE Par_PagoCuota
	when PagoSemanal	then set Fre_Dias	:=  FrecSemanal;	set Var_GraciaFaltaPag:= 5;
	when PagoCatorcenal	then set Fre_Dias	:=  FrecCator; 		set Var_GraciaFaltaPag:= 10;
	when PagoQuincenal	then set Fre_Dias	:=  FrecQuin; 		set Var_GraciaFaltaPag:= 10;
	when PagoMensual	then set Fre_Dias	:=  FrecMensual; 	set Var_GraciaFaltaPag:= 20;
	when PagoPeriodo	then set Fre_Dias 	:=  Par_Frecu;
	when PagoBimestral	then set Fre_Dias	:=  FrecBimestral; 	set Var_GraciaFaltaPag:= 40;
	when PagoTrimestral	then set Fre_Dias	:=  FrecTrimestral; set Var_GraciaFaltaPag:= 60;
	when PagoTetrames	then set Fre_Dias	:=  FrecTetrames;	set Var_GraciaFaltaPag:= 80;
	when PagoSemestral	then set Fre_Dias	:=  FrecSemestral; 	set Var_GraciaFaltaPag:= 120;
	when PagoAnual		then set Fre_Dias	:=  FrecAnual; 		set Var_GraciaFaltaPag:= 240;
END CASE;
if (Par_ForCobComAp  = ComApFinan) then
	set Par_Monto := Par_Monto+Par_ComAper+round((Par_ComAper*Var_IVA),2);
end if;


set Var_FrecuPago := Fre_Dias;
set Var_Cuotas	:= Par_Plazo;
set Tas_Periodo	:= ((Par_Tasa / 100) * (1 + Var_IVA) * Fre_Dias) / Fre_DiasAnio ;
set Pag_Calculado	:= (Par_Monto * Tas_Periodo * (power((1 + Tas_Periodo), Var_Cuotas))) / (power((1 + Tas_Periodo), Var_Cuotas)-1);

-- se redondea a cero el valor del pago calculado
set Pag_Calculado	:= CEILING(Pag_Calculado);
set Insoluto		:= Par_Monto;
set Var_CadCuotas := concat(Var_CadCuotas,Pag_Calculado);

-- se calculan las Fechas
while (Contador <= Var_Cuotas) do
	-- pagos quincenales
	if (Par_PagoCuota = PagoQuincenal) then
		if (day(FechaInicio) = FrecQuin) then
			set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
		else
			if (day(FechaInicio) >28) then
				set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
									month(DATE_ADD(FechaInicio, interval 1 month)), '-' , '15'),date);
			else
				set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL day(FechaInicio) day), INTERVAL FrecQuin DAY);
				if  (FechaFinal <= FechaInicio) then
					set FechaFinal := last_day(FechaInicio);
					if(cast(datediff(FechaFinal, FechaInicio)as signed)<Var_GraciaFaltaPag) then
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 1 month)) , '-' , '15'),date);
					end if;
				end	if;
			end if;
		end if;
	else
		-- Pagos Mensuales
		if (Par_PagoCuota = PagoMensual) then
			-- Para pagos que se haran cada 30 dias
			if (Par_PagoFinAni = PagoAniver) then
				if(Par_DiaMes>28)then
					set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 1 month)) , '-' , 28),date);
					set Var_UltDia := day(LAST_DAY(FechaFinal));
					if(Var_UltDia < Par_DiaMes)then
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
											 month(DATE_ADD(FechaInicio, interval 1 month)), '-' ,Var_UltDia),date);
					else
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
											 month(DATE_ADD(FechaInicio, interval 1 month)), '-' , Par_DiaMes),date);
					end if;
				else
					set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
											 month(DATE_ADD(FechaInicio, interval 1 month)), '-' , Par_DiaMes),date);
				end if;
			else
				-- Para pagos que se haran cada fin de mes
				if (Par_PagoFinAni = PagoFinMes) then
					if (day(FechaInicio)>=28)then
						set FechaFinal := DATE_ADD(FechaInicio, interval 2 month);
						set FechaFinal := DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal)as signed) day);
					else
					-- si no indica que es un numero menor y se obtiene el final del mes.
						set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
					end if;
				end if;
			end if;
		else
			if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
				set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
			else
				if (Par_PagoCuota = PagoBimestral) then
					-- Para pagos que se haran cada 60 dias
					if (Par_PagoFinAni = PagoAniver) then
						if(Par_DiaMes>28)then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 2 month)), '-' , 28),date);
							set Var_UltDia := day(LAST_DAY(FechaFinal));
							if(Var_UltDia < Par_DiaMes)then
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 2 month)), '-' ,Par_DiaMes),date);
							else
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 2 month)), '-' , Par_DiaMes),date);
							end if;
						else
							set FechaFinal := convert(concat(year(DATE_ADD(FechaInicio, interval 2 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 2 month)), '-' , Par_DiaMes),date);
						end if;
					else
						-- Para pagos que se haran en fin de mes
						if (Par_PagoFinAni = PagoFinMes) then
							if (day(FechaInicio)>=28)then
								set FechaFinal := DATE_ADD(FechaInicio, interval 3 month);
								set FechaFinal := DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal)as signed) day);
							else
								set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY);
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoTrimestral) then
						-- Para pagos que se haran cada 90 dias
						if (Par_PagoFinAni = PagoAniver) then
							if(Par_DiaMes>28)then
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 3 month)), '-' ,  28),date);
								set Var_UltDia := day(LAST_DAY(FechaFinal));
								if(Var_UltDia < Par_DiaMes)then
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
												month(DATE_ADD(FechaInicio, interval 3 month)), '-' , Var_UltDia),date);
								else
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 3 month)), '-' , Par_DiaMes),date);
								end if;
							else
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 3 month)), '-' , Par_DiaMes),date);
							end if;
						else
							-- Para pagos que se haran en fin de mes
							if (Par_PagoFinAni = PagoFinMes) then
								if (day(FechaInicio)>=28)then
									set FechaFinal := DATE_ADD(FechaInicio, interval 4 month);
									set FechaFinal := DATE_ADD(FechaFinal, interval -1* day(FechaFinal) day);
								else
									set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY);
								end if;
							end if;
						end if;
					else
						if (Par_PagoCuota = PagoTetrames) then
							-- Para pagos que se haran cada 120 dias
							if (Par_PagoFinAni = PagoAniver) then
								if(Par_DiaMes>28)then
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 4 month)), '-' , 28),date);
									set Var_UltDia := day(LAST_DAY(FechaFinal));
									if(Var_UltDia < Par_DiaMes)then
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 4 month)), '-' , Var_UltDia),date);

									else
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 4 month)), '-' , Par_DiaMes),date);
									end if;
								else
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 4 month)), '-' , Par_DiaMes),date);
								end if;
							else
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAni = PagoFinMes) then
									if (day(FechaInicio)>=28)then
										set FechaFinal := DATE_ADD(FechaInicio, interval 5 month);
										set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
									else
										set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY);
									end if;
								end if;
							end if;
						else
							if (Par_PagoCuota = PagoSemestral) then
								-- Para pagos que se haran cada 180 dias
								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMes>28)then
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)) , '-' ,
											month(DATE_ADD(FechaInicio, interval 6 month)), '-' , 28),date);
										set Var_UltDia := day(LAST_DAY(FechaFinal));
										if(Var_UltDia < Par_DiaMes)then
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 6 month)) , '-' ,Var_UltDia),date);

										else
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 6 month)), '-' , Par_DiaMes),date);
										end if;
									else
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 6 month)), '-' , Par_DiaMes),date);
									end if;
								else
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAni = PagoFinMes) then
										if (day(FechaInicio)>=28)then
											set FechaFinal := DATE_ADD(FechaInicio, interval 7 month);
											set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
										else
											set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY);
										end if;
									end if;
								end if;
							else
								if (Par_PagoCuota = PagoAnual) then
									-- Para pagos que se haran cada 360 dias
									set FechaFinal 	:= DATE_ADD(FechaInicio, interval 1 year);
								end if;
							end if;
						end if;
					end if;
				end if;
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

	-- hace un ciclo para comparar los dias de gracia
	while (datediff(FechaVig, FechaInicio) < Var_GraciaFaltaPag ) do
		if (Par_PagoCuota = PagoQuincenal ) then
			if (day(FechaFinal) = FrecQuin) then
				set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
			else
				if (day(FechaFinal) >28) then
					set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)) , '-' ,
										month(DATE_ADD(FechaFinal, interval 1 month)), '-' , '15'),date);
				else
					set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL day(FechaFinal) day), INTERVAL FrecQuin DAY);
					if  (FechaFinal <= FechaInicio) then
						set FechaFinal := last_day(FechaFinal);
						if(cast(datediff(FechaFinal, FechaInicio)as signed)<Var_GraciaFaltaPag) then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)) , '-' ,
												month(DATE_ADD(FechaFinal, interval 1 month)) , '-' , '15'),date);
						end if;
					end	if;
				end if;
			end if;
		else
			-- Pagos Mensuales
			if (Par_PagoCuota = PagoMensual  ) then
				if (Par_PagoFinAni = PagoAniver) then
					if(Par_DiaMes>28)then
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
												 month(DATE_ADD(FechaFinal, interval 1 month)), '-' , 28),date);
						set Var_UltDia := day(LAST_DAY(FechaFinal));
						if(Var_UltDia < Par_DiaMes)then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
												 month(DATE_ADD(FechaFinal, interval 1 month)), '-' ,Var_UltDia),date);

						else
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
												 month(DATE_ADD(FechaFinal, interval 1 month)), '-' , Par_DiaMes),date);
						end if;
					else
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
												 month(DATE_ADD(FechaFinal, interval 1 month)), '-' , Par_DiaMes),date);
					end if;
				else
					-- Para pagos que se haran cada fin de mes
					if (Par_PagoFinAni = PagoFinMes) then
						if (day(FechaFinal)>=28)then
							set FechaFinal := DATE_ADD(FechaFinal, interval 2 month);
							set FechaFinal := DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal)as signed) day);
						else
						-- si no indica que es un numero menor y se obtiene el final del mes.
							set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
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
			call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		else
			call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;
	end while;

	/* si el valor de la fecha final es mayor a la de vencimiento en se ajusta */
	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
			set FechaFinal 	:= Par_FechaVenc;
			if(Par_DiaHabilSig = Var_SI) then
				call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			else
				call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;
		end if;
		if (Contador = Var_Cuotas )then
			set FechaFinal 	:= Par_FechaVenc;
			if(Par_DiaHabilSig = Var_SI) then
				call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			else
				call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;
		end if;
	end if;


	/* valida si se ajusta a fecha de exigibilidad o no*/
	if (Par_AjusFecExiVen= Var_SI)then
		set FechaFinal:= FechaVig;
	end if;

	set Fre_DiasTab:= (DATEDIFF(FechaFinal,FechaInicio));

	INSERT into TMPPAGAMORSIM(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
							NumTransaccion)
					values(	Contador,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab,
							Aud_NumTransaccion);
	/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
	if (Par_AjustaFecAmo = Var_SI)then
		if (Par_FechaVenc <=  FechaFinal) then
			set Contador 	:= Var_Cuotas+1;
		end if;
	end if;
	set FechaInicio := FechaFinal;

	if((Contador+1) = Var_Cuotas)then
		#Ajuste Saldo
		-- se ajusta a ultima fecha de amortizacion (no) o a fecha de vencimiento del contrato (si)
		if (Par_AjustaFecAmo = Var_SI)then
			set FechaFinal 	:= Par_FechaVenc;
		else
			-- pagos quincenales
			if (Par_PagoCuota = PagoQuincenal) then
				if (day(FechaInicio) = FrecQuin) then
					set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
				else
					if (day(FechaInicio) >28) then
						set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
											month(DATE_ADD(FechaInicio, interval 1 month)), '-' , '15'),date);
					else
						set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL day(FechaInicio) day), INTERVAL FrecQuin DAY);
						if  (FechaFinal <= FechaInicio) then
							set FechaFinal := last_day(FechaInicio);
							if(Var_GraciaFaltaPag>cast(datediff(FechaFinal, FechaInicio)as signed)) then
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)) , '-' ,
													month(DATE_ADD(FechaInicio, interval 1 month)) , '-' , '15'),date);
							end if;
						end	if;
					end if;
				end if;
			else
				-- Pagos Mensuales
				if (Par_PagoCuota = PagoMensual) then
					-- Para pagos que se haran cada 30 dias
					if (Par_PagoFinAni = PagoAniver) then
						if(Par_DiaMes>28)then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
													 month(DATE_ADD(FechaInicio, interval 1 month)), '-' , 28),date);
							set Var_UltDia := day(LAST_DAY(FechaFinal));
							if(Var_UltDia < Par_DiaMes)then
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
													 month(DATE_ADD(FechaInicio, interval 1 month)), '-' ,Var_UltDia),date);
							else
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
													 month(DATE_ADD(FechaInicio, interval 1 month)), '-' , Par_DiaMes),date);
							end if;
						else
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 1 month)), '-' ,
													 month(DATE_ADD(FechaInicio, interval 1 month)), '-' , Par_DiaMes),date);
						end if;
					else
						-- Para pagos que se haran cada fin de mes
						if (Par_PagoFinAni = PagoFinMes) then
							if (day(FechaInicio)>=28)then
								set FechaFinal := DATE_ADD(FechaInicio, interval 2 month);
								set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
							else
							-- si no indica que es un numero menor y se obtiene el final del mes.
								set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
							end if;
						end if;
					end if;
				else
					if (Par_PagoCuota = PagoSemanal or Par_PagoCuota = PagoPeriodo or Par_PagoCuota = PagoCatorcenal ) then
						set FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
					else
						if (Par_PagoCuota = PagoBimestral) then
							-- Para pagos que se haran cada 60 dias
							if (Par_PagoFinAni = PagoAniver) then
								if(Par_DiaMes>28)then
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)) , '-' ,
													month(DATE_ADD(FechaInicio, interval 2 month)), '-' , 28),date);
									set Var_UltDia := day(LAST_DAY(FechaFinal));
									if(Var_UltDia < Par_DiaMes)then
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 2 month)), '-' ,Par_DiaMes),date);
									else
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)) , '-' ,
													month(DATE_ADD(FechaInicio, interval 2 month)), '-' , Par_DiaMes),date);
									end if;
								else
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 2 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 2 month)), '-' , Par_DiaMes),date);
								end if;
							else
								-- Para pagos que se haran en fin de mes
								if (Par_PagoFinAni = PagoFinMes) then
									if (day(FechaInicio)>=28)then
										set FechaFinal := DATE_ADD(FechaInicio, interval 3 month);
										set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
									else
										set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 2 month), interval -1 * day(FechaInicio) DAY);
									end if;
								end if;
							end if;
						else
							if (Par_PagoCuota = PagoTrimestral) then
								-- Para pagos que se haran cada 90 dias
								if (Par_PagoFinAni = PagoAniver) then
									if(Par_DiaMes>28)then
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 3 month)), '-' ,  28),date);
										set Var_UltDia := day(LAST_DAY(FechaFinal));
										if(Var_UltDia < Par_DiaMes)then
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 3 month)), '-' , Var_UltDia),date);
										else
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 3 month)),'-' , Par_DiaMes),date);
										end if;
									else
										set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 3 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 3 month)) , '-' , Par_DiaMes),date);
									end if;
								else
									-- Para pagos que se haran en fin de mes
									if (Par_PagoFinAni = PagoFinMes) then
										if (day(FechaInicio)>=28)then
											set FechaFinal := DATE_ADD(FechaInicio, interval 4 month);
											set FechaFinal := DATE_ADD(FechaFinal, interval -1*cast(day(FechaFinal)as signed) day);
										else
											set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 3 month), interval -1 * day(FechaInicio) DAY);
										end if;
									end if;
								end if;
							else
								if (Par_PagoCuota = PagoTetrames) then
									-- Para pagos que se haran cada 120 dias
									if (Par_PagoFinAni = PagoAniver) then
										if(Par_DiaMes>28)then
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 4 month)), '-' , 28),date);
											set Var_UltDia := day(LAST_DAY(FechaFinal));
											if(Var_UltDia < Par_DiaMes)then
												set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)) , '-' ,
													month(DATE_ADD(FechaInicio, interval 4 month)), '-' , Var_UltDia),date);

											else
												set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 4 month)),'-' , Par_DiaMes),date);
											end if;
										else
											set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 4 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 4 month)), '-' , Par_DiaMes),date);
										end if;
									else
										-- Para pagos que se haran en fin de mes
										if (Par_PagoFinAni = PagoFinMes) then
											if ((cast(day(FechaInicio)as signed)*1)>=28)then
												set FechaFinal := DATE_ADD(FechaInicio, interval 5 month);
												set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
											else
												set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 4 month), interval -1 * day(FechaInicio) DAY);
											end if;
										end if;
									end if;
								else
									if (Par_PagoCuota = PagoSemestral) then
										-- Para pagos que se haran cada 180 dias
										if (Par_PagoFinAni = PagoAniver) then
											if(Par_DiaMes>28)then
												set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 6 month)), '-' , 28),date);
												set Var_UltDia := day(LAST_DAY(FechaFinal))*1;
												if(Var_UltDia < Par_DiaMes)then
													set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 6 month)), '-' ,Var_UltDia),date);

												else
													set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)), '-' ,
													month(DATE_ADD(FechaInicio, interval 6 month)) , '-' , Par_DiaMes),date);
												end if;
											else
												set FechaFinal := convert(	concat(year(DATE_ADD(FechaInicio, interval 6 month)),'-' ,
													month(DATE_ADD(FechaInicio, interval 6 month)), '-' , Par_DiaMes),date);
											end if;
										else
											-- Para pagos que se haran en fin de mes
											if (Par_PagoFinAni = PagoFinMes) then
												if (day(FechaInicio)>=28)then
													set FechaFinal := DATE_ADD(FechaInicio, interval 7 month);
													set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
												else
													set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 6 month), interval -1 * day(FechaInicio) DAY);
												end if;
											end if;
										end if;
									else
										if (Par_PagoCuota = PagoAnual) then
											-- Para pagos que se haran cada 360 dias
											set FechaFinal 	:= DATE_ADD(FechaInicio, interval 1 year);
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;

			if(Par_DiaHabilSig = Var_SI) then
				call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			else
				call DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			end if;
			-- hace un ciclo para comparar los dias de gracia
			while (datediff(FechaVig, FechaInicio) <= Var_GraciaFaltaPag ) do
				if (Par_PagoCuota = PagoQuincenal ) then
					if (day(FechaFinal) = FrecQuin) then
						set FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, interval 1 month), interval -1 * day(FechaFinal) DAY);
					else
						if (day(FechaFinal) >28) then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
												month(DATE_ADD(FechaFinal, interval 1 month)) , '-' , '15'),date);
						else
							set FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL day(FechaFinal) day), INTERVAL FrecQuin DAY);
					if  (FechaFinal <= FechaInicio) then
						set FechaFinal := last_day(FechaFinal);
						if(cast(datediff(FechaFinal, FechaInicio)as signed)<Var_GraciaFaltaPag) then
							set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)) , '-' ,
												month(DATE_ADD(FechaFinal, interval 1 month)) , '-' , '15'),date);
						end if;
					end	if;
						end if;
					end if;
				else
				-- Pagos Mensuales
					if (Par_PagoCuota = PagoMensual  ) then
						if (Par_PagoFinAni = PagoAniver) then
							if(Par_DiaMes>28)then
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
														 month(DATE_ADD(FechaFinal, interval 1 month)), '-' , 28),date);
								set Var_UltDia :=day(LAST_DAY(FechaFinal));
								if(Var_UltDia < Par_DiaMes)then
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
														 month(DATE_ADD(FechaFinal, interval 1 month)), '-' ,Var_UltDia),date);

								else
									set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)), '-' ,
														 month(DATE_ADD(FechaFinal, interval 1 month)), '-' , Par_DiaMes),date);
								end if;
							else
								set FechaFinal := convert(	concat(year(DATE_ADD(FechaFinal, interval 1 month)) , '-' ,
														 month(DATE_ADD(FechaFinal, interval 1 month)) , '-' , Par_DiaMes),date);
							end if;
						else
							-- Para pagos que se haran cada fin de mes
							if (Par_PagoFinAni = PagoFinMes) then
								if ((cast(day(FechaFinal)as signed)*1)>=28)then
									set FechaFinal := DATE_ADD(FechaFinal, interval 2 month);
									set FechaFinal := DATE_ADD(FechaFinal, interval -1*day(FechaFinal) day);
								else
								-- si no indica que es un numero menor y se obtiene el final del mes.
									set FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, interval 1 month), interval -1 * day(FechaInicio) DAY);
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
					call DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
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
			call DIASHABILANTERCAL(FechaFinal,			Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		end if;

		/* valida si se ajusta a fecha de exigibilidad o no*/
		if (Par_AjusFecExiVen= Var_SI)then
			set FechaFinal:= FechaVig;
		end if;

		set Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
		INSERT into TMPPAGAMORSIM(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,		Tmp_FecVig,	Tmp_Dias,
								NumTransaccion)
						values(	Contador+1,		FechaInicio,	FechaFinal,		FechaVig,	Fre_DiasTab,
								Aud_NumTransaccion);
		set Contador = Contador+1;
	end if;
	set Contador = Contador+1;
end while;

-- Se inicializa el Contador
set Contador			:= 1;

-- genera los montos y los inserta en la tabla TMPPAGAMORSIM
while (ContadorMargen <= NumIteraciones) do
	while (Contador <= Var_Cuotas) do
		select Tmp_Dias into Fre_DiasTab
			from TMPPAGAMORSIM
			where NumTransaccion = Aud_NumTransaccion
			and Tmp_Consecutivo = Contador;

		set Interes	:= round(((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio*100)),2);
		set IvaInt	:= round(Interes * Var_IVA,2);


		if(Insoluto > 0) then
			if(Contador = Var_Cuotas)then
				set Capital	:= round(Insoluto,2);
				set Var_CoutasAmor := concat(Var_CoutasAmor,Capital + Interes);
			else
				set Capital	:= round(Pag_Calculado - Interes - IvaInt,2);
				/* si el capital es negativo entonces la cuota de esta amortizacion tendra como
					capital un peso y su total de pago no sera el pago calculado.*/
				if(Capital < Entero_Cero)then
					set Capital	:=Entero_Uno;
				end if;
				if (Insoluto<=Capital) then
					set Capital := Insoluto;
				end if;
				set Var_CoutasAmor := concat(Var_CoutasAmor,Capital + Interes,',');
			end if;

			set Insoluto		:= Insoluto - Capital;
			set Subtotal		:= Capital + Interes + IvaInt;
			set Var_MontoCuota := Capital + Interes + IvaInt;
			set Var_TotalPagar := Var_TotalPagar + Subtotal;
			update TMPPAGAMORSIM set
				Tmp_Capital		= Capital,
				Tmp_Interes		= Interes,
				Tmp_Iva			= IvaInt,
				Tmp_SubTotal	= Subtotal,
				Tmp_Insoluto	= Insoluto
			where NumTransaccion = Aud_NumTransaccion
			and Tmp_Consecutivo = Contador;
		else
			Set Var_Cuotas	:= Contador;
			Set Contador := Var_Cuotas+10;
		end if;

		set Contador = Contador+1;

	end while;
	set Var_MontoCuota := Pag_Calculado; -- se asigna el valor del monto de la cuota
	set Var_Diferencia := Pag_Calculado-Subtotal;
	set ContadorMargen = ContadorMargen+1;

if (ContadorMargen<=NumIteraciones)then
		if (abs(Var_Diferencia) > Var_MargenPagIgual) then
				-- se redondea el ajuste al proximo entero
				if(Var_Diferencia>Entero_Cero)then
					if(Subtotal>Pag_Calculado) then
						set Pag_Calculado 	:= Pag_Calculado-2;
					else
						set Pag_Calculado 	:= Pag_Calculado-Entero_Uno;
					end if;
				else
					if(Subtotal>Pag_Calculado) then
						set Pag_Calculado 	:= Pag_Calculado+2;
					else
						set Pag_Calculado 	:= Pag_Calculado+Entero_Uno;
					end if;
				end if;

				-- se redondea a cero el valor del pago calculado
				set Pag_Calculado	:= CEILING(Pag_Calculado);
				set Insoluto		:= Par_Monto;

				if (select Var_CadCuotas like concat('%',Pag_Calculado,'%'))then
					set Contador := Var_Cuotas+1;
					set ContadorMargen := NumIteraciones+1;
				else
					set Var_CoutasAmor	:= '';
					set Contador 		:=1;
					set Var_TotalPagar  := 0;
				end if;
				set Var_CadCuotas := concat(Var_CadCuotas,',',Pag_Calculado);
		else
			if(Subtotal>Pag_Calculado) then
				if(Var_Diferencia>Entero_Cero)then
						set Pag_Calculado 	:= Pag_Calculado-Entero_Uno;
				else
						set Pag_Calculado 	:= Pag_Calculado+Entero_Uno;
				end if;

				-- se redondea a cero el valor del pago calculado
				set Pag_Calculado	:= CEILING(Pag_Calculado);
				set Insoluto		:= Par_Monto;

				if (select Var_CadCuotas like concat('%',Pag_Calculado,'%'))then
					set Contador := Var_Cuotas+1;
					set ContadorMargen := NumIteraciones+1;
				else
					set Var_CoutasAmor	:= '';
					set Contador 		:=1;
					set Var_TotalPagar  := 0;
				end if;
				set Var_CadCuotas := concat(Var_CadCuotas,',',Pag_Calculado);
			else
				set ContadorMargen := NumIteraciones+1;
				set Contador = Var_Cuotas+1;
			end if;
		end if;
	end if;
 end while;

-- COMPARO SI EL ULTIMO REGISTRO DE LA TABLA TMPPAGAMORSIM ES CERO, ELIMINO EL REGISTRO.

select Tmp_Consecutivo
	into Var_Cuotas
	from TMPPAGAMORSIM
	where NumTransaccion=Aud_NumTransaccion
	and Tmp_Insoluto= 0 limit 1;

delete from TMPPAGAMORSIM where Tmp_Consecutivo > Var_Cuotas and NumTransaccion=Aud_NumTransaccion;

-- se ejecuta el sp que calcula el cat
call CALCULARCATPRO(
	Par_Monto,		Var_CoutasAmor,		Var_FrecuPago,		Var_No,		Entero_Cero,
    	Entero_Cero,		Par_ComAper,		Par_ComAnualLin,	Var_CAT,	Aud_NumTransaccion);

set Par_NumErr := 0;
set Par_ErrMen := 'exito';



  END;

-- Se muestran los datos
if (Par_Salida = Salida_SI) then
	select  	FORMAT(Var_MontoCuota,2)as MontoCuota,	Var_Cuotas,	FORMAT(Var_TotalPagar,2) as TotalPagar,	Var_CAT,	convert(Par_NumErr, char(10)) as NumErr,
			Par_ErrMen as ErrMen;
end if ;

set Par_NumErr 	:= 0;
set Par_ErrMen 	:= 'Cuotas generadas';

END TerminaStore$$