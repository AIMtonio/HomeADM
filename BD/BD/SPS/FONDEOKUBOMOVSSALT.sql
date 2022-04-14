-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOMOVSSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOKUBOMOVSSALT`;
DELIMITER $$


CREATE PROCEDURE `FONDEOKUBOMOVSSALT`(
	Par_FondeoKuboID		bigint,
	Par_AmortizacionID	int(4),
	Par_Transaccion		bigint(20),
	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,
	Par_TipoMovKuboID		int(4),
	Par_NatMovimiento		char(1),
	Par_MonedaID			int(11),
	Par_Cantidad			decimal(14,4),
	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(50),

out	Par_NumErr			int(11),
out	Par_ErrMen			varchar(400),
out	Par_Consecutivo		bigint,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(20),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint		)

TerminaStore: BEGIN


DECLARE	Fecha			date;
DECLARE	Mov_Cantidad 		decimal(14,4);
DECLARE	Var_Estatus 		char(1);
DECLARE	Var_AcumProv 		decimal(12,4);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Float_Cero		decimal(12,2);

DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Est_Vigente		char(1);
DECLARE	Est_Vencido		char(1);

DECLARE	Mov_CapOrd 		int;
DECLARE	Mov_CapAtr 		int;

DECLARE	Mov_IntOrd 		int;
DECLARE	Mov_IntMor 		int;
DECLARE	Mov_ComFalPag 	int;

DECLARE	Mov_RetInt 		int;
DECLARE	Mov_RetMor 		int;
DECLARE	Mov_RetFalPag 	int;

DECLARE	Pro_GenInt		varchar(50);
DECLARE	Pro_PagCre		varchar(50);



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.00;

Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set	Est_Vigente		:= 'N';
Set	Est_Vencido		:= 'V';

Set	Mov_CapOrd 		:= 1;
Set	Mov_CapAtr 		:= 2;
Set	Mov_IntOrd 		:= 10;
Set	Mov_IntMor 		:= 15;
Set	Mov_ComFalPag 	:= 40;

Set	Mov_RetInt 		:= 50;
Set	Mov_RetMor 		:= 51;
Set	Mov_RetFalPag 	:= 52;

Set	Pro_GenInt		:= 'GENERAINTEREINVPRO';
Set	Pro_PagCre		:= 'PAGOCREDITOPRO';

if(ifnull(Par_FondeoKuboID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Numero de FondeoKubo esta vacio.' as ErrMen,
		 'fondeoKuboID' as control;
	LEAVE TerminaStore;
end if;

select	Estatus into Var_Estatus
	from FONDEOKUBO
	where FondeoKuboID = Par_FondeoKuboID;

set Var_Estatus = ifnull(Var_Estatus, Cadena_Vacia);

if Var_Estatus = Cadena_Vacia then
	select '002' as NumErr,
		   'El FondeoKubo no Existe.' as ErrMen,
		   'fondeoKuboID' as control;
	LEAVE TerminaStore;
end if;

if (Var_Estatus != Est_Vigente and Var_Estatus != Est_Vencido) then
	select '003' as NumErr,
		   'Estatus del FondeoKubo Incorrecto.' as ErrMen,
		   'fondeoKuboID' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Transaccion, Entero_Cero))= Entero_Cero then
	select '004' as NumErr,
		   'El numero de Movimiento esta vacio.' as ErrMen,
		   'fondeoKuboID' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia then
	select '005' as NumErr,
		  'La Fecha Op. esta Vacia.' as ErrMen,
		  'fecha' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia then
	select '006' as NumErr,
		  'La Fecha Apl. esta Vacia.' as ErrMen,
		  'fecha' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
	select '007' as NumErr,
		  'La naturaleza del Movimiento esta vacia.' as ErrMen,
		  'natMovimiento' as control;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento<>Nat_Cargo)then
	if(Par_NatMovimiento<>Nat_Abono)then
		select '008' as NumErr,
			  'La naturaleza del Movimiento no es correcta.' as ErrMen,
			  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento<>Nat_Abono)then
	if(Par_NatMovimiento<>Nat_Cargo)then
		select '009' as NumErr,
			  'La naturaleza del Movimiento no es correcta.' as ErrMen,
			  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_Cantidad, Float_Cero)) <= Float_Cero then
	select '010' as NumErr,
		   'La Cantidad es Incorrecta.' as ErrMen,
		   'cantidad' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '011' as NumErr,
		  'La Descripcion del Movimiento esta vacia.' as ErrMen,
		  'descripcion' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia then
	select '012' as NumErr,
		  'La Referencia esta vacia.' as ErrMen,
		  'referencia' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoMovKuboID, Entero_Cero)) = Entero_Cero then
	select '013' as NumErr,
		  'El Tipo de Movimiento esta vacio.' as ErrMen,
		  'tipoMovCreID' as control;
	LEAVE TerminaStore;
end if;

if(not exists(select AmortizacionID
				from AMORTIZAFONDEO
				where FondeoKuboID 	= Par_FondeoKuboID
				  and AmortizacionID	= Par_AmortizacionID)) then
		select '014' as NumErr,
			  'La Amortizacion no existe.' as ErrMen,
			  'amortizacionID' as control;
	LEAVE TerminaStore;
end if;

set Mov_Cantidad = Par_Cantidad;

if (Par_NatMovimiento = Nat_Abono) then
	set Mov_Cantidad = Mov_Cantidad * -1;
end if;



if (Par_TipoMovKuboID = Mov_IntOrd) then

	if (Par_NatMovimiento = Nat_Cargo and Aud_ProgramaID = Pro_GenInt) then
		set Var_AcumProv = Mov_Cantidad;
	else
		set Var_AcumProv = Entero_Cero;
	end if;

	update FONDEOKUBO set
		SaldoInteres		= SaldoInteres + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		where FondeoKuboID = Par_FondeoKuboID;

	update AMORTIZAFONDEO set
		SaldoInteres		= SaldoInteres + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		where FondeoKuboID	= Par_FondeoKuboID
		  and AmortizacionID	= Par_AmortizacionID;

elseif (Par_TipoMovKuboID = Mov_CapOrd) then
	update FONDEOKUBO set
		SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
		where FondeoKuboID = Par_FondeoKuboID;

	update AMORTIZAFONDEO set
		SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
		where FondeoKuboID	= Par_FondeoKuboID
		  and AmortizacionID 	= Par_AmortizacionID;

elseif (Par_TipoMovKuboID = Mov_CapAtr) then
	update FONDEOKUBO set
		SaldoCapExigible	= SaldoCapExigible + Mov_Cantidad
		where FondeoKuboID = Par_FondeoKuboID;

	update AMORTIZAFONDEO set
		SaldoCapExigible	= SaldoCapExigible + Mov_Cantidad
		where FondeoKuboID	= Par_FondeoKuboID
		  and AmortizacionID	= Par_AmortizacionID;

elseif (Par_TipoMovKuboID = Mov_IntMor) then

	if (Par_NatMovimiento = Nat_Abono and Aud_ProgramaID = Pro_PagCre) then
		update FONDEOKUBO set
			MoratorioPagado	= MoratorioPagado + Par_Cantidad
			where FondeoKuboID = Par_FondeoKuboID;

		update AMORTIZAFONDEO set
			MoratorioPagado	= MoratorioPagado + Par_Cantidad
			where FondeoKuboID	= Par_FondeoKuboID
			  and AmortizacionID	= Par_AmortizacionID;
	end if;

elseif (Par_TipoMovKuboID = Mov_ComFalPag) then

	if (Par_NatMovimiento = Nat_Abono and Aud_ProgramaID = Pro_PagCre) then
		update FONDEOKUBO set
			ComFalPagPagada	= ComFalPagPagada + Par_Cantidad
			where FondeoKuboID = Par_FondeoKuboID;

		update AMORTIZAFONDEO set
			ComFalPagPagada	= ComFalPagPagada + Par_Cantidad
			where FondeoKuboID	= Par_FondeoKuboID
			  and AmortizacionID	= Par_AmortizacionID;
	end if;

elseif (Par_TipoMovKuboID = Mov_RetInt) then

	if (Par_NatMovimiento = Nat_Cargo and Aud_ProgramaID = Pro_PagCre) then
		update FONDEOKUBO set
			IntOrdRetenido	= IntOrdRetenido + Par_Cantidad
			where FondeoKuboID = Par_FondeoKuboID;

		update AMORTIZAFONDEO set
			IntOrdRetenido	= IntOrdRetenido + Par_Cantidad
			where FondeoKuboID	= Par_FondeoKuboID
			  and AmortizacionID	= Par_AmortizacionID;
	end if;

elseif (Par_TipoMovKuboID = Mov_RetMor) then

	if (Par_NatMovimiento = Nat_Cargo and Aud_ProgramaID = Pro_PagCre) then
		update FONDEOKUBO set
			IntMorRetenido	= IntMorRetenido + Par_Cantidad
			where FondeoKuboID = Par_FondeoKuboID;

		update AMORTIZAFONDEO set
			IntMorRetenido	= IntMorRetenido + Par_Cantidad
			where FondeoKuboID	= Par_FondeoKuboID
			  and AmortizacionID	= Par_AmortizacionID;
	end if;

elseif (Par_TipoMovKuboID = Mov_RetFalPag) then

	if (Par_NatMovimiento = Nat_Cargo and Aud_ProgramaID = Pro_PagCre) then
		update FONDEOKUBO set
			ComFalPagRetenido	= ComFalPagRetenido + Par_Cantidad
			where FondeoKuboID = Par_FondeoKuboID;

		update AMORTIZAFONDEO set
			ComFalPagRetenido	= ComFalPagRetenido + Par_Cantidad
			where FondeoKuboID	= Par_FondeoKuboID
			  and AmortizacionID	= Par_AmortizacionID;
	end if;

end if;

INSERT FONDEOKUBOMOVS VALUES(
	Par_FondeoKuboID,		Par_AmortizacionID,	Par_Transaccion,		Par_FechaOperacion,
	Par_FechaAplicacion,	Par_TipoMovKuboID,	Par_NatMovimiento,	Par_MonedaID,
	Par_Cantidad,			Par_Descripcion,		Par_Referencia,		Aud_EmpresaID,
	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	Aud_Sucursal,			Aud_NumTransaccion	);


END TerminaStore$$