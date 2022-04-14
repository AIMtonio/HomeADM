-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULARCAT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULARCAT`;DELIMITER $$

CREATE PROCEDURE `CALCULARCAT`(
    Par_MontoCredito    Decimal(20,2),
    Par_ValorCuotas     varchar(15000),
    Par_FrecuPago       int(11),
    Par_Salida          char(1),

	inout    Var_CAT 	decimal(14,4),
    NumTransaccion      bigint(20)

	)
TerminaStore: BEGIN


DECLARE	Var_precision	Double;
DECLARE	Var_Cre_NumPag	int;
DECLARE	Var_separa		char(1);
DECLARE	Var_cuota		double;
DECLARE	Var_Xn			Double;
DECLARE	Var_Xn1			Double;
DECLARE	Var_control		Double;
DECLARE	Var_Xn_1		Double;
DECLARE	Var_sumXn		float;
DECLARE	Var_sumXn_1		float;
DECLARE	Var_Fxn			float;
DECLARE	Var_Fxn_1		float;
DECLARE	Var_Cre_Period	int;
DECLARE	Var_TamanioCadena	int;
DECLARE Var_CadenaPaso	varchar(8000);
declare numero			int(11);
DECLARE Var_SalidaCiclo bigint;

DECLARE	Con_Cadena_Vacia	varchar(1);
DECLARE	Con_Fecha_Vacia		date;
DECLARE	Con_Entero_Cero		int(11);
DECLARE	Con_Moneda_Cero		int(11);
DECLARE	Salida_SI			char(1);


BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
       set Var_CAT				:= 0.0;
    END;


set Con_Cadena_Vacia	:= '';
set Con_Fecha_Vacia		:= '1900-01-01';
set Con_Entero_Cero		:= 0;
set Con_Moneda_Cero		:= 0.00;
Set Salida_SI			:= 'S';

set Var_precision		:= 0.0000001;
set Var_separa			:= ',';
set Var_Cre_NumPag		:= 0;
set Var_Xn				:= 0.5;
set Var_Xn_1			:= 1;
set Var_Fxn := 0;
set Var_CAT				:= 0.0;


SET SQL_SAFE_UPDATES := 0;

set Par_ValorCuotas := trim(Par_ValorCuotas);

IF right(Par_ValorCuotas, 1) <> Var_separa THEN
	set Par_ValorCuotas := CONCAT(Par_ValorCuotas, Var_separa);
END IF;

set numero = 1;

delete from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion;

WHILE CHARACTER_LENGTH(Par_ValorCuotas) > 0 DO
	set Var_Cre_NumPag := Var_Cre_NumPag + 1;
	set Var_cuota = CAST(ifnull(substring(Par_ValorCuotas, 1, LOCATE(Var_separa, Par_ValorCuotas) -1), '') as Decimal(20,6));
	insert into TMPCUOTASCALCAT values (NumTransaccion, Var_Cre_NumPag, ifnull(Var_cuota, 0),0,0);
	set Par_ValorCuotas = substring(Par_ValorCuotas, LOCATE( Var_separa, Par_ValorCuotas ) +1,  LENGTH(Par_ValorCuotas));
END WHILE;



IF Par_FrecuPago = 7 THEN
	set Var_Cre_Period := 52;
ELSEIF Par_FrecuPago = 14 THEN
		set Var_Cre_Period := 26;
ELSEIF Par_FrecuPago = 15 THEN
		set Var_Cre_Period := 24;
ELSEIF (Par_FrecuPago = 28 or Par_FrecuPago = 29 or Par_FrecuPago = 30 or Par_FrecuPago = 31)	THEN
		set Var_Cre_Period := 12;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag = 1 THEN
		set Var_Cre_Period := 1;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 51 THEN
		set Var_Cre_Period := 52;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 25 and Var_Cre_NumPag <= 27 THEN
		set Var_Cre_Period := 26;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 23 and Var_Cre_NumPag <= 25 THEN
		set Var_Cre_Period := 24;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 11 and Var_Cre_NumPag <= 13 THEN
		set Var_Cre_Period := 12;
ELSE


		set Var_Cre_Period := 360/Par_FrecuPago;
		if ifnull(Var_Cre_Period , 0) < 1 then
			set Var_Cre_Period 	:= 1;
		end if;
END IF;

  update TMPCUOTASCALCAT
	set TmpCuo_Xn = TmpCuoMonto /( power( (1.00 + Var_Xn),(TmpCuoNumero / Var_Cre_Period  )))
    where TmpNumTransaccion = NumTransaccion;

  update TMPCUOTASCALCAT
	set TmpCuo_Xn_1 = TmpCuoMonto /( power( (1.00 + Var_Xn_1),(TmpCuoNumero / Var_Cre_Period  )));

  set Var_sumXn := (select sum(TmpCuo_Xn) from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion);
  set Var_sumXn_1 := (select sum(TmpCuo_Xn_1) from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion);
  set Var_Fxn := Par_MontoCredito - Var_sumXn;
  set Var_Fxn_1 := Par_MontoCredito - Var_sumXn_1;


set Var_SalidaCiclo := 0;

CICLOWHILE: LOOP
	WHILE abs(Var_Fxn) > Var_precision  DO
		set Var_SalidaCiclo := Var_SalidaCiclo + 1;
		set Var_control:= ( Var_Fxn - Var_Fxn_1 ) ;
		if(ifnull(Var_control,0) = 0) then
			LEAVE CICLOWHILE;
		end if ;
		set Var_Xn1		:= Var_Xn - ( ( (Var_Xn - Var_Xn_1) * Var_Fxn ) / ( Var_Fxn - Var_Fxn_1 ) );
		set Var_Xn_1	:= Var_Xn;
		set Var_Xn		:= Var_Xn1;

		update TMPCUOTASCALCAT
		set TmpCuo_Xn = TmpCuoMonto /( power( (1.00 + Var_Xn),(TmpCuoNumero / Var_Cre_Period  )))
		where TmpNumTransaccion = NumTransaccion;

		update TMPCUOTASCALCAT
		set TmpCuo_Xn_1 = TmpCuoMonto /( power( (1.00 + Var_Xn_1),(TmpCuoNumero / Var_Cre_Period  )))
		where TmpNumTransaccion = NumTransaccion;

		set Var_sumXn := (select sum(TmpCuo_Xn) from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion);
		set Var_sumXn_1 := (select sum(TmpCuo_Xn_1) from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion);
		set Var_Fxn := Par_MontoCredito - Var_sumXn;
		set Var_Fxn_1 := Par_MontoCredito - Var_sumXn_1;

		if(Var_SalidaCiclo = 50000) then
		   set Var_Fxn := Var_precision + 10;
		end if;
	END WHILE;
End LOOP CICLOWHILE;

set Var_CAT := (select round(Var_Xn1 * 100,4));

END;

if (Par_Salida = Salida_SI) then
    select Var_CAT;
end if;


delete from TMPCUOTASCALCAT where TmpNumTransaccion = NumTransaccion;

END TerminaStore$$