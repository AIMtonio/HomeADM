-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVPRO`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVPRO`(
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
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
			)
TerminaStore: BEGIN



DECLARE	Cliente			int;
DECLARE	SaldoDisp		decimal(12,2);
DECLARE	MonedaCon		int;
DECLARE	EstatusC			char(1);
DECLARE	Var_TipoMovID		char(4);


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
	select '001' as NumErr,
		 'El numero de Cuenta esta vacio.' as ErrMen,
		 'cuentaAhoID' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NumeroMov, Entero_Cero))= Entero_Cero then
	select '003' as NumErr,
		 'El numero de Movimiento esta vacio.' as ErrMen,
		 'numeroMov' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia then
	select '004' as NumErr,
		  'La fecha esta Vacia.' as ErrMen,
		  'fecha' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
	select '005' as NumErr,
		  'La naturaleza del Movimiento esta vacia.' as ErrMen,
		  'natMovimiento' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento<>Nat_Cargo)then
	if(Par_NatMovimiento<>Nat_Abono)then
		select '006' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento<>Nat_Abono)then
	if(Par_NatMovimiento<>Nat_Cargo)then
		select '007' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_CantidadMov, Decimal_Cero))= Decimal_Cero then
	select '008' as NumErr,
		 'La Cantidad esta Vacia.' as ErrMen,
		 'cantidadMov' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_DescripcionMov, Cadena_Vacia)) = Cadena_Vacia then
	select '009' as NumErr,
		  'La Descripcion del Movimiento esta vacia.' as ErrMen,
		  'descripcionMov' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia then
	select '010' as NumErr,
		  'La Referencia esta vacia.' as ErrMen,
		  'referenciaMov' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoMovAhoID, Cadena_Vacia)) = Cadena_Vacia then
	select '011' as NumErr,
		  'El Tipo de Movimiento esta vacio.' as ErrMen,
		  'tipoMov' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;



CALL SALDOSAHORROCON(
	Cliente,	SaldoDisp,	MonedaCon,	EstatusC,	Par_CuentaAhoID);

if(ifnull(EstatusC, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		  'La Cuenta no existe.' as ErrMen,
		  'cuentaAhoID' as control,
			0 as consecutivo;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
set Var_TipoMovID	:= (select TipoMovAhoID
					    from TIPOSMOVSAHO
						where TipoMovAhoID = Par_TipoMovAhoID and EsEfectivo = Var_Si);


call CUENTASAHOMOVALT(Par_CuentaAhoID,		Par_NumeroMov	,   	Par_Fecha, 		Par_NatMovimiento,	Par_CantidadMov,
					Par_DescripcionMov,	Par_ReferenciaMov,Par_TipoMovAhoID,	Aud_EmpresaID	,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion
					);

select '000' as NumErr,
		  'transaccion realizada' as ErrMen,
		  'cuentaAhoID' as control,
			0 as consecutivo;
		LEAVE TerminaStore;


END TerminaStore$$