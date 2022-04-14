-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONRECPAGLIBPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONRECPAGLIBPRO`;DELIMITER $$

CREATE PROCEDURE `FONRECPAGLIBPRO`(
	/*sp para calcular los montos de interes e  iva en el grid de simulador de cuotas
	de pagos libres de CREDITOFONDEO*/
	Par_Monto			decimal(12,2),
	Par_Tasa			decimal(12,4),
	Par_PagaIVA			char(1),			-- indica si paga IVA valores :  Si = "S" / No = "N")
	Par_IVA				decimal(12,4),		-- indica el valor del iva si es que Paga IVA = si
    	Par_ComAnualLin		DECIMAL(12,2),			-- Monto de Comisión por Anualidad de Línea de Crédito

	Par_Salida    		char(1),			-- Indica si hay una salida o no
    inout	Par_NumErr 	int,
    inout	Par_ErrMen  varchar(350),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

-- declaracion de constantes
declare Decimal_Cero	decimal(12,2);
declare Entero_Cero		int;
declare Cadena_Vacia	char(1);
declare Var_SI			char(1);
declare Var_No			char(1);
declare Var_Capital		char(1);
declare Var_Interes		char(1);
declare Var_CapInt		char(1);
declare Par_FechaVenc	date;
-- declaracion de Variables
declare Contador		int;
declare Consecutivo		int;
declare ContadorInt		int;
declare ContadorCap		int;
declare FechaInicio		date;
declare FechaFinal		date;
declare FechaInicioInt	date;
declare FechaFinalInt	date;
declare Var_Cuotas		int;
declare Var_CuotasInt	int;
declare Capital			decimal(12,2);
declare Interes			decimal(12,4);
declare IvaInt			decimal(12,4);
declare Subtotal		decimal(12,2);
declare Insoluto		decimal(12,2);
declare Var_IVA			decimal(12,4);
declare Fre_DiasAnio	int;
declare Fre_Dias		int;
declare Fre_DiasInt		int;
declare CapInt			char(1);
declare Var_InteresAco	decimal(12,4);
declare Var_CoutasAmor	varchar(8000);
declare Var_CAT 	    decimal(12,4);
declare Var_FrecuPago	int;
declare CuotaSinIva		decimal(12,2);

-- asignacion de constantes
set Decimal_Cero	:= 0.00;
set Entero_Cero		:= 0;
set Cadena_Vacia	:= '';
set Var_SI			:= 'S';
set Var_No			:= 'N';
set Var_Capital		:= 'C';
set Var_Interes		:= 'I';
set Var_CapInt		:= 'G';

-- declaracion de variables
set Contador		:= 1;
set ContadorInt		:= 1;
set Fre_DiasAnio	:= (select DiasCredito from PARAMETROSSIS);
set Var_CoutasAmor	:= '';
set Var_CAT			:= 0.0000;
set Var_FrecuPago	:= 0;
set CuotaSinIva		:= 0;
Set Par_NumErr		:= 0;
Set Par_ErrMen		:= Cadena_Vacia;

if (Par_PagaIVA = Var_Si) then
	set Var_IVA	:= ifnull(Par_IVA/100,Decimal_Cero);
else
	set Var_IVA	:= Decimal_Cero;
end if;

if(ifnull(Par_Monto, Decimal_Cero))= Decimal_Cero then
	if(Par_Salida = Var_SI) then
		select	'001' as NumErr,
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
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo,
				Entero_Cero as consecutivo;
	else
		Set Par_NumErr := 1;
		Set Par_ErrMen := 'El monto esta Vacio.';
	end if;
	LEAVE TerminaStore;
else
	if(Par_Monto < Entero_Cero)then
		if(Par_Salida = Var_SI) then
			select '001' as NumErr,
				'El monto no puede ser negativo.' as ErrMen,
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
			Set Par_NumErr := 1;
			Set Par_ErrMen := 'El monto no puede ser negativo.';
		end if;
		LEAVE TerminaStore;
	end if;
end if;

set Insoluto	:= Par_Monto;

select Tmp_FrecuPago into Var_FrecuPago
		from TMPPAGAMORSIM where Tmp_Consecutivo = 1
			and NumTransaccion = Aud_NumTransaccion;

set Contador := 1;
select max(Tmp_Consecutivo) into ContadorInt
	from TMPPAGAMORSIM
	where NumTransaccion = Aud_NumTransaccion;

-- ciclo para calcular el interes y el iva a partir del capital
while (Contador <= ContadorInt) do

	select Tmp_InteresAco into  Var_InteresAco
from TMPPAGAMORSIM where Tmp_Consecutivo = Contador-1
and NumTransaccion = Aud_NumTransaccion ;



	select Tmp_Dias, Tmp_Capital, Tmp_CapInt into Fre_Dias, Capital, CapInt
		from TMPPAGAMORSIM where Tmp_Consecutivo = Contador
			and NumTransaccion = Aud_NumTransaccion;

	set Var_InteresAco=ifnull(Var_InteresAco, Entero_Cero);

	if (CapInt= Var_Interes) then

		set Interes		:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
		set Capital		:= Decimal_Cero;
		set Var_InteresAco := Entero_Cero;
	else
		if (CapInt= Var_CapInt) then

			set Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			set Var_InteresAco := Entero_Cero;
		else

			set Interes		:= Decimal_Cero;
			set Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
		end if;
	end if;

	if (Par_PagaIVA = Var_Si) then
		set IvaInt	:= Interes * Var_IVA;
	else
		set IvaInt := Decimal_Cero;
	end if;

	set Subtotal	:= Capital + Interes + IvaInt;
	set Insoluto	:= Insoluto - Capital;

	set CuotaSinIva := Capital + Interes;
	set Var_CoutasAmor := concat(Var_CoutasAmor,CuotaSinIva,',');

	update TMPPAGAMORSIM set
		Tmp_Capital		= Capital,
		Tmp_Interes		= Interes,
		Tmp_Iva			= IvaInt,
		Tmp_SubTotal	= Subtotal,
		Tmp_Insoluto	= Insoluto,
		Tmp_InteresAco	= Var_InteresAco
	where Tmp_Consecutivo = Contador
	and NumTransaccion = Aud_NumTransaccion;

	-- Si es la penultima cuota, en este mismo cilco se calcula la ultima cuota
	if((Contador+1) = ContadorInt)then
		select Tmp_Dias, Tmp_Capital,  Tmp_CapInt into Fre_Dias, Capital, CapInt
			from TMPPAGAMORSIM
			where Tmp_Consecutivo = Contador +1
			and NumTransaccion = Aud_NumTransaccion;

		select Tmp_Insoluto, Tmp_InteresAco into Insoluto, Var_InteresAco
		from TMPPAGAMORSIM where Tmp_Consecutivo = Contador
		and NumTransaccion=Aud_NumTransaccion;

		if(ifnull(Var_InteresAco, Entero_Cero))= Entero_Cero  then
			set Var_InteresAco := Entero_Cero;
		end if;

		if (CapInt= Var_Interes) then
			set Capital		:= IF(IFNULL(Var_Cuotas, Entero_Cero) != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
			set Capital		:= Insoluto + Capital;
			set Subtotal	:= Insoluto + Subtotal;
			update TMPPAGAMORSIM set
				Tmp_Capital		= Capital,
				Tmp_SubTotal	= Subtotal,
				Tmp_Insoluto	= Insoluto-Insoluto
			where Tmp_Consecutivo = Contador-1
				and NumTransaccion= Aud_NumTransaccion;

			set Interes			:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			set Capital			:= Decimal_Cero;
			set Var_InteresAco	:= Entero_Cero;
		else
			if (CapInt= Var_CapInt) then
				set Interes			:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				set Capital			:= Insoluto;
				set Var_InteresAco	:= Entero_Cero;
			else
				set Interes			:= Decimal_Cero;
				set Capital			:= Insoluto;
				set Var_InteresAco	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			end if;
		end if;

		set Insoluto	:= Insoluto - Capital;

		if (Par_PagaIVA = Var_Si) then
			set IvaInt	:= Interes * Var_IVA;
		else
			set IvaInt 	:= Decimal_Cero;
		end if;
		set Subtotal	:= Capital + Interes + IvaInt;

		set CuotaSinIva	:= Capital + Interes;

		set Var_CoutasAmor := concat(Var_CoutasAmor,CuotaSinIva);
		update TMPPAGAMORSIM set
			Tmp_Capital		= Capital,
			Tmp_Interes		= Interes,
			Tmp_Iva			= IvaInt,
			Tmp_SubTotal	= Subtotal,
			Tmp_Insoluto	= Insoluto,
			Tmp_InteresAco	= Var_InteresAco
		where Tmp_Consecutivo = Contador+1
			and NumTransaccion = Aud_NumTransaccion;
		set Contador = Contador+1;
	end if;  -- Ultima Cuota
	set Contador = Contador+1;
end while;

select max(Tmp_Consecutivo) into Consecutivo
	from TMPPAGAMORSIM
	where NumTransaccion = Aud_NumTransaccion;

select Tmp_Capital,Tmp_Interes, Tmp_CapInt into Capital, Interes, CapInt
	from TMPPAGAMORSIM
	where Tmp_Consecutivo = Consecutivo
	 and NumTransaccion=Aud_NumTransaccion;

if ( Capital = Decimal_Cero and Interes = Decimal_Cero ) then
	delete from TMPPAGAMORSIM
		where Tmp_Consecutivo = Consecutivo
		 and NumTransaccion=Aud_NumTransaccion;
	if (CapInt= Var_Capital) then
		set Var_Cuotas:=Var_Cuotas-1;
	else
		if (CapInt= Var_Interes) then
			set Var_CuotasInt:=Var_CuotasInt-1;
		else
			set Var_Cuotas:=Var_Cuotas-1;
			set Var_CuotasInt:=Var_CuotasInt-1;
		end if;
	end if;
end if;


-- se ejecuta el sp que calcula el cat
call CALCULARCATPRO(
	Par_Monto,		Var_CoutasAmor,		Var_FrecuPago,		Var_No,		Entero_Cero,
    	Entero_Cero,		Entero_Cero,		Par_ComAnualLin,	Var_CAT,	Aud_NumTransaccion);

Set Par_NumErr := 0;
Set Par_ErrMen := "Amortizaciones Generadas";
/* -- se determina cual es la fecha de vencimiento*/
set Par_FechaVenc := (select max(Tmp_FecFin) from TMPPAGAMORSIM where 	NumTransaccion = Aud_NumTransaccion);
set Var_Cuotas:= (select count(Tmp_Consecutivo) from TMPPAGAMORSIM where (Tmp_CapInt = Var_Capital or  Tmp_CapInt = Var_CapInt) and NumTransaccion=Aud_NumTransaccion);
set Var_CuotasInt:=(select count(Tmp_Consecutivo) from TMPPAGAMORSIM where (Tmp_CapInt = Var_Interes or  Tmp_CapInt = Var_CapInt) and NumTransaccion=Aud_NumTransaccion);

/*se actualiza el numero de cuotas de capital y de interes */
update TMPPAGAMORSIM set
	Tmp_CuotasCap	= Var_Cuotas,
	Tmp_CuotasInt	= Var_CuotasInt
where NumTransaccion = Aud_NumTransaccion;

if(Par_Salida = Var_SI) then
	select	Tmp_Consecutivo,						Tmp_FecIni,						Tmp_FecFin,								Tmp_FecVig,									FORMAT(Tmp_Capital,2)as Tmp_Capital,
			FORMAT(Tmp_Interes,2)as Tmp_Interes,	FORMAT(Tmp_Iva,2) as Tmp_Iva,	FORMAT(Tmp_SubTotal,2)as Tmp_SubTotal,	FORMAT(Tmp_Insoluto,2)  as Tmp_Insoluto,	Tmp_Dias,
			Tmp_CapInt,								Aud_NumTransaccion,				Tmp_CuotasCap,							Tmp_CuotasInt,								Var_CAT,
			Par_FechaVenc
		from	TMPPAGAMORSIM
		where NumTransaccion = Aud_NumTransaccion;
end if;


END TerminaStore$$