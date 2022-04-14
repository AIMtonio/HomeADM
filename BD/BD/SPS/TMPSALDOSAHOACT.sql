-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPSALDOSAHOACT`;DELIMITER $$

CREATE PROCEDURE `TMPSALDOSAHOACT`(
	Par_CuentaAhoID 		bigint(12),
	Par_NatMovimiento 	char(1),
	Par_CantidadMov		float
		)
TerminaStore: BEGIN
	DECLARE		Cadena_Vacia	char(1);
	DECLARE		Entero_Cero		int;
	DECLARE		Float_Cero		float;
	DECLARE		Nat_Cargo		char(1);
	DECLARE		Nat_Abono		char(1);
	DECLARE		NumError			int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	Float_Cero		:= 0.0;
	Set	Nat_Cargo		:= 'C';
	Set	Nat_Abono		:= 'A';

	if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
		Set NumError := 1;
		LEAVE TerminaStore;
	end if;

	if(not exists(select CuentaAhoID
			from CUENTASAHO
			where CuentaAhoID = Par_CuentaAhoID)) then
			Set NumError := 1;
	LEAVE TerminaStore;
	end if;

	if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
		Set NumError := 1;
		LEAVE TerminaStore;
	end if;

	if(Par_NatMovimiento<>Nat_Cargo)then
		if(Par_NatMovimiento<>Nat_Abono)then
			Set NumError := 1;
			LEAVE TerminaStore;
		end if;
	end if;

	if(Par_NatMovimiento<>Nat_Abono)then
		if(Par_NatMovimiento<>Nat_Cargo)then
			Set NumError := 1;
			LEAVE TerminaStore;
		end if;
	end if;

	if(ifnull(Par_CantidadMov, Float_Cero))= Float_Cero then
		Set NumError := 1;
		LEAVE TerminaStore;
	end if;

	if(Par_NatMovimiento = Nat_Abono) then
		update CUENTASAHO set
				AbonosDia		= AbonosDia		+Par_CantidadMov,
				AbonosMes		= AbonosMes		+Par_CantidadMov,
				SaldoDispon		= SaldoDispon	+Par_CantidadMov
			where CuentaAhoID 	= Par_CuentaAhoID;
	end if;

	if(Par_NatMovimiento = Nat_Cargo) then
		update CUENTASAHO set
			SaldoDispon		= SaldoDispon	-Par_CantidadMov,
			CargosDia		= CargosDia		+Par_CantidadMov,
			CargosMes		= CargosMes		+Par_CantidadMov
		where CuentaAhoID 	= Par_CuentaAhoID;
	end if;
END TerminaStore$$