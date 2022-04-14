-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONESMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONESMOVALT`;DELIMITER $$

CREATE PROCEDURE `INVERSIONESMOVALT`(
	Par_InversionID		bigint,
	Par_NumeroMov		bigint,
	Par_Fecha			date,
	Par_TipoMovInvID	char(4),
	Par_CantidadMov		decimal(12,2),
	Par_NatMovimiento	char(1),
	Par_ReferenciaMov	varchar(100),
	Par_MonedaID		int,
	Par_PolizaID		bigint(20),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Float_Cero		float;
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);




Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Float_Cero		:= 0.0;
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(ifnull(Par_InversionID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El numero de Inversion esta vacio.' as ErrMen,
		 'inversionID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NumeroMov, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El numero de Movimiento esta vacio.' as ErrMen,
		 'numeroMov' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia then
	select '003' as NumErr,
		  'La fecha esta Vacia.' as ErrMen,
		  'fecha' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia then
	select '004' as NumErr,
		  'La naturaleza del Movimiento esta vacia.' as ErrMen,
		  'natMovimiento' as control;
	LEAVE TerminaStore;
end if;

if(Par_NatMovimiento<>Nat_Cargo)then
	if(Par_NatMovimiento<>Nat_Abono)then
		select '005' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(Par_NatMovimiento<>Nat_Abono)then
	if(Par_NatMovimiento<>Nat_Cargo)then
		select '006' as NumErr,
		  'La naturaleza del Movimiento no es correcta.' as ErrMen,
		  'natMovimiento' as control;
		LEAVE TerminaStore;
	end if;
end if;

if(ifnull(Par_CantidadMov, Float_Cero))= Float_Cero then
	select '007' as NumErr,
		 'La Cantidad esta Vacia.' as ErrMen,
		 'cantidadMov' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ReferenciaMov, Cadena_Vacia)) = Cadena_Vacia then
	select '008' as NumErr,
		  'La Referencia esta vacia.' as ErrMen,
		  'referenciaMov' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoMovInvID, Cadena_Vacia)) = Cadena_Vacia then
	select '009' as NumErr,
		  'El Tipo de Movimiento esta vacio.' as ErrMen,
		  'tipoMov' as control;
	LEAVE TerminaStore;
end if;

INSERT INVERSIONESMOV (	InversionID, 			NumeroMovimiento, 		Fecha, 			TipoMovInvID, 			Monto,
						NatMovimiento, 			Referencia, 			MonedaID, 		 				EmpresaID,
						Usuario,				FechaActual,			DireccionIP,	ProgramaID, 			Sucursal,
						NumTransaccion)
						VALUES(
						Par_InversionID,		Par_NumeroMov,		    Par_Fecha,		Par_TipoMovInvID,		Par_CantidadMov,
						Par_NatMovimiento,	    Par_ReferenciaMov,		Par_MonedaID,				Aud_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion);

END TerminaStore$$