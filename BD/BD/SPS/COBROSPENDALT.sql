-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENDALT`;DELIMITER $$

CREATE PROCEDURE `COBROSPENDALT`(

	Par_ClienteID		int(11),
	Par_CuentaAhoID		bigint(12),
	Par_Fecha			date,
	Par_CantPenOri		decimal(12,2),
	Par_TipoMovAhoID	char(4),

	Par_Descripcion		varchar(300),
	Par_Transaccion		bigint(20),
	Par_IVA				decimal(12,2),
    Par_Salida			char(1),
    inout Par_NumErr	int,

    inout Par_ErrMen  	varchar(350),
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),

	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Bigint_Cero		bigint;
DECLARE	Fecha_Vacia		date;
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
DECLARE	Est_Pendiente	char(1);
DECLARE Salida_SI 		char(1);





Set	Entero_Cero		:= 0;
Set	Cadena_Vacia	:= '';
Set	Bigint_Cero		:= 0;
Set	Fecha_Vacia		:= '1900-01-01';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Est_Pendiente	:= 'P';
set	Salida_SI 	   	:= 'S';

if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '001' as NumErr,
			'El numero de Cuenta esta Vacio.' as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
	else
		set	Par_NumErr := 1;
		set	Par_ErrMen := 'El numero de Cuenta esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '002' as NumErr,
			'El numero de Cliente esta Vacio.' as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
	else
		set	Par_NumErr := 2;
		set	Par_ErrMen := 'El numero de Cliente esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Fecha, Fecha_Vacia))= Fecha_Vacia then
	if (Par_Salida = Salida_SI) then
		select '003' as NumErr,
			'La Fecha esta Vacio.' as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
	else
		set	Par_NumErr := 3;
		set	Par_ErrMen := 'La Fecha esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Transaccion, Bigint_Cero))= Bigint_Cero then
	if (Par_Salida = Salida_SI) then
		select '004' as NumErr,
			'El Numero de Transaccion de la Operacion esta Vacio.' as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
	else
		set	Par_NumErr := 4;
		set	Par_ErrMen := 'El Numero de Transaccion de la Operacion esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoMovAhoID, Cadena_Vacia)= Cadena_Vacia) then
	if (Par_Salida = Salida_SI) then
		select '005' as NumErr,
			'El Tipo de Movimiento de la Operacion esta Vacio.' as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
	else
		set	Par_NumErr := 5;
		set	Par_ErrMen := 'El Tipo de Movimiento de la Operacion esta Vacio.';
	end if;
	LEAVE TerminaStore;
end if;



insert into COBROSPEND (
	ClienteID,			CuentaAhoID,		Fecha,			CantPenOri,			CantPenAct,
	Estatus,			TipoMovAhoID,		FechaPago,		Descripcion,		Transaccion,
	IVA,				EmpresaID,			Usuario,		FechaActual,		DireccionIP,
	ProgramaID,			Sucursal,			NumTransaccion)
values (
	Par_ClienteID,		Par_CuentaAhoID,	Par_Fecha,		Par_CantPenOri,		Par_CantPenOri,
	Est_Pendiente,		Par_TipoMovAhoID,	Fecha_Vacia,	Par_Descripcion,	Par_Transaccion,
	Par_IVA,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
);

set	Par_NumErr := 0;
set	Par_ErrMen := concat("Cobro Pendiente Agregado.");

if (Par_Salida = Salida_SI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
end if;

END TerminaStore$$