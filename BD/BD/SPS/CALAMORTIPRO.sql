-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALAMORTIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALAMORTIPRO`;DELIMITER $$

CREATE PROCEDURE `CALAMORTIPRO`(
	Par_Monto		decimal(12,2),
	Par_Tasa			decimal(12,4),
	Par_Cuotas		int,
	Par_Frecu		int

	)
TerminaStore: BEGIN

DECLARE Tas_Periodo	decimal(12,4);
DECLARE Pag_Calculado	decimal(12,2);
DECLARE Contador		int;
DECLARE FechaSistema	date;
DECLARE FechaInicio	date;
DECLARE Fechafinal	date;

DECLARE Capital		decimal(12,2);
DECLARE Interes		decimal(12,4);
DECLARE iva			decimal(12,4);
DECLARE Subtotal		decimal(12,2);
DECLARE Saldo			decimal(12,2);

set Contador	:= 1;
set FechaSistema := CURDATE();

set	Tas_Periodo	= ((Par_Tasa / 100) * (1 + 0.16) * Par_Frecu) / 360 ;
set	Pag_Calculado	= (Par_Monto * Tas_Periodo * (power((1 + Tas_Periodo), Par_Cuotas))) / (power((1 + Tas_Periodo), Par_Cuotas)-1);

CREATE TEMPORARY TABLE Tem_Amortizacion(
	consecutivo		int,
	Tem_FecIni		date,
	Tem_FecFin		date,
	Tem_FecVig		date,
	Tem_Capital		decimal(12,2),
	Tem_Interes		decimal(12,4),
	Tem_iva			decimal(12,4),
	Tem_SubTotal		decimal(12,2),
	Tem_Saldo		decimal(12,2),
    PRIMARY KEY  (consecutivo));

while (contador <= Par_Cuotas) do

	set Interes	:= ((Par_Monto * Par_Tasa * Par_Frecu ) / (360*100));
	set iva		:= Interes * 0.16;
	set Capital	:= Pag_Calculado - Interes - iva;
	set Subtotal	:= Capital + Interes + iva;
	set Saldo	:= Par_Monto - Capital;

	set FechaInicio	:= FechaSistema;
	set Fechafinal 	:= DATE_ADD(FechaInicio, INTERVAL Par_Frecu DAY);

	INSERT into Tem_Amortizacion(consecutivo, Tem_FecIni,		Tem_FecFin,	Tem_FecVig,	Tem_Capital,
							  Tem_Interes, Tem_iva, 		Tem_SubTotal,		Tem_Saldo)

				values(contador,	FechaInicio,	Fechafinal,	'1900-01-01',		Capital,
					   Interes,	iva,			Subtotal,	Saldo);

	set Par_Monto := Saldo;


	if((contador+1) = Par_Cuotas)then


		set Interes	:= ((Par_Monto * Par_Tasa * Par_Frecu ) / (360*100));
		set iva		:= Interes * 0.16;
		set Capital	:= Saldo;
		set Subtotal	:= Capital + Interes + iva;
		set Saldo	:= Par_Monto - Capital;

		INSERT into Tem_Amortizacion(consecutivo, Tem_FecIni,		Tem_FecFin,	Tem_FecVig,	Tem_Capital,
								  Tem_Interes, Tem_iva, 		Tem_SubTotal,		Tem_Saldo)

				values(contador+1,	FechaInicio,	Fechafinal,	'1900-01-01',		Capital,
					   Interes,	iva,			Subtotal,	Saldo);

		set contador = Par_Cuotas;
	end if;

set FechaSistema := Fechafinal;

set Contador = Contador+1;
end while;

select Tem_FecIni,		Tem_FecFin,	Tem_FecVig,	Tem_Capital,
								  Tem_Interes, Tem_iva, 		Tem_SubTotal,		Tem_Saldo from Tem_Amortizacion;

drop table Tem_Amortizacion;


END TerminaStore$$