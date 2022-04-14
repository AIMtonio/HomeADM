-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTASAHOMOVALTCRE
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCUENTASAHOMOVALTCRE`;
DELIMITER $$


CREATE PROCEDURE `TMPCUENTASAHOMOVALTCRE`(



	Par_CuentaAhoID		bigint(12),
	Par_NumeroMov			bigint(20),
	Par_Fecha			date,
	Par_NatMovimiento		char(1),
	Par_CantidadMov		decimal(12,2),
	Par_DescripcionMov	varchar(150),
	Par_ReferenciaMov		varchar(35),
	Par_TipoMovAhoID		char(4),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(20),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint,
	inout	Par_NumErr			int(11),
	inout	Par_ErrMen			varchar(100)
		)

TerminaStore: BEGIN



DECLARE	Cliente			int;
DECLARE	SaldoDisp		decimal(12,2);
DECLARE	MonedaCon		int;
DECLARE	EstatusC			char(1);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	EstatusActual		char(1);
DECLARE	EstatusActivo		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);

DECLARE	Fecha_Vacia		date;
DECLARE	Fecha			date;

declare	Var_PolizaID		bigint;
declare 	Salida_NO 		char(1);
declare 	Var_Si	 		char(1);
declare 	Pol_Automatica 	char(1);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.0;

Set	EstatusActivo		:= 'A';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set	Salida_NO		:= 'N';
Set	Pol_Automatica	:= 'A';
Set	Var_Si			:= 'S';


Set	SaldoDisp		:= 0.0;



if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
	set Par_NumErr := 1 ;
	set Par_ErrMen := 	'El numero de Cuenta esta vacio.'  ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NumeroMov, Entero_Cero))= Entero_Cero then
	set Par_NumErr := 3 ;
	set Par_ErrMen := 	 'El numero de Movimiento esta vacio.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia then
	set Par_NumErr := 4 ;
	set Par_ErrMen := 	 'La fecha esta Vacia.';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr := 5 ;
	set Par_ErrMen := 	'La naturaleza del Movimiento esta vacia.';
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento<>Nat_Cargo)then
	if(Par_NatMovimiento<>Nat_Abono)then
		set Par_NumErr := 6 ;
		set Par_ErrMen := 	 'La naturaleza del Movimiento no es correcta.';
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento<>Nat_Abono)then
	if(Par_NatMovimiento<>Nat_Cargo)then
		set Par_NumErr := 7 ;
		set Par_ErrMen := 	'La naturaleza del Movimiento no es correcta.';
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_CantidadMov, Decimal_Cero))= Decimal_Cero then
		set Par_NumErr := 8 ;
		set Par_ErrMen := 	 'La Cantidad esta Vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 9 ;
		set Par_ErrMen := 	 'La Descripcion del Movimiento esta vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 10 ;
		set Par_ErrMen := 	'La Referencia esta vacia.' ;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 11 ;
		set Par_ErrMen := 	 'El Tipo de Movimiento esta vacio.';
	LEAVE TerminaStore;
end if;



CALL SALDOSAHORROCON(
	Cliente,	SaldoDisp,	MonedaCon,	EstatusC,	Par_CuentaAhoID);

if(ifnull(EstatusC, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 2 ;
		set Par_ErrMen := 	  'La Cuenta no existe.' ;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento=Nat_Cargo)then

	if(EstatusC=EstatusActivo) then
		if(SaldoDisp>=Par_CantidadMov) then
			CALL TMPSALDOSAHOACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
		end if;
		if(SaldoDisp<Par_CantidadMov) then
			set Par_NumErr := 13 ;
			set Par_ErrMen := 	'Saldo insuficiente.'  ;
			LEAVE TerminaStore;
		end if;
	end if;
	if(EstatusC<>EstatusActivo) then
		set Par_NumErr := 14 ;
		set Par_ErrMen := 	 'No se Puede hacer movimientos en esta Cuenta.';
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento=Nat_Abono)then
	if(EstatusC = EstatusActivo) then
		CALL SALDOSAHORROACT(Par_CuentaAhoID, Par_NatMovimiento,Par_CantidadMov);
	end if;
	if(EstatusC <> EstatusActivo) then
		set Par_NumErr := 15 ;
		set Par_ErrMen :=  'No se Puede hacer movimientos en esta Cuenta.';
		LEAVE TerminaStore;
	end if;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();




INSERT INTO CUENTASAHOMOV( CuentaAhoID,	     NumeroMov,	            Fecha,			NatMovimiento,	CantidadMov,
						   DescripcionMov,	 ReferenciaMov,			TipoMovAhoID,	MonedaID,	  	EmpresaID,
						   Usuario,			 FechaActual,			DireccionIP, 	ProgramaID,		Sucursal,
						   NumTransaccion)
					VALUES(
	Par_CuentaAhoID,		Aud_NumTransaccion,	Par_Fecha,				Par_NatMovimiento,		Par_CantidadMov,
	Par_DescripcionMov,		Par_ReferenciaMov,	Par_TipoMovAhoID,		MonedaCon,				Aud_EmpresaID,
	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
	Aud_NumTransaccion);



END TerminaStore$$