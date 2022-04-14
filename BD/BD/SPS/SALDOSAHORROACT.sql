-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSAHORROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSAHORROACT`;DELIMITER $$

CREATE PROCEDURE `SALDOSAHORROACT`(
	Par_CuentaAhoID 		bigint(12),
	Par_NatMovimiento 	char(1),
	Par_CantidadMov		decimal(12,2)
		)
TerminaStore: BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;
DECLARE		Float_Cero		float;
DECLARE		Nat_Cargo		char(1);
DECLARE		Nat_Abono		char(1);


Set	Cadena_Vacia	:= '';
Set	Entero_Cero	:= 0;
Set	Float_Cero	:= 0.0;
Set	Nat_Cargo	:= 'C';
Set	Nat_Abono	:= 'A';

if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El numero de Cuenta esta vacio.' as ErrMen,
		 'cuentaAhoID' as control;
	LEAVE TerminaStore;
end if;

if(not exists(select CuentaAhoID
		from CUENTASAHO
		where CuentaAhoID = Par_CuentaAhoID)) then
		select '002' as NumErr,
		'La Cuenta no existe.' as ErrMen,
		'cuentaAhoID' as control;
LEAVE TerminaStore;
end if;

if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		  'La naturaleza del Movimiento esta vacia.' as ErrMen,
		  'natMovimiento' as control;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento<>Nat_Cargo)then
	if(Par_NatMovimiento<>Nat_Abono)then
		select '004' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento<>Nat_Abono)then
	if(Par_NatMovimiento<>Nat_Cargo)then
		select '005' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_CantidadMov, Float_Cero))= Float_Cero then
	select '006' as NumErr,
		 'La Cantidad esta Vacia.' as ErrMen,
		 'cantidadMov' as control;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento = Nat_Abono) then
	update CUENTASAHO set
			AbonosDia		= AbonosDia		+Par_CantidadMov,
			AbonosMes		= AbonosMes		+Par_CantidadMov,
			Saldo 			= (SaldoDispon + SaldoBloq) + Par_CantidadMov,
			SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) + Par_CantidadMov) - SaldoBloq - SaldoSBC)
		where CuentaAhoID 	= Par_CuentaAhoID;

end if;

if(Par_NatMovimiento = Nat_Cargo) then
	update CUENTASAHO set
		CargosDia		= CargosDia		+Par_CantidadMov,
		CargosMes		= CargosMes		+Par_CantidadMov,
		Saldo 			= (SaldoDispon + SaldoBloq) - Par_CantidadMov,
		SaldoDispon		= (((SaldoDispon + SaldoBloq + SaldoSBC) - Par_CantidadMov) - SaldoBloq - SaldoSBC)
	where CuentaAhoID 	= Par_CuentaAhoID;

end if;
END TerminaStore$$