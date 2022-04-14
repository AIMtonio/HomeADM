-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENDACT`;DELIMITER $$

CREATE PROCEDURE `COBROSPENDACT`(

	Par_ClienteID		int(11),
	Par_CuentaAhoID		bigint(12),
	Par_Fecha			date,
	Par_FechaPago		date,
	Par_TipoMovAhoID	char(4),

	Par_Transaccion		bigint(20),
	Par_Monto			decimal(12,2),
	Par_NumAct			int,
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
DECLARE Est_Cobrado		char(1);
DECLARE Est_Cancelado 	char(1);
DECLARE Var_PagaIVA		char(1);
DECLARE Var_IVA			decimal(14,2);
DECLARE Salida_SI 		char(1);
DECLARE Var_SI	 		char(1);
DECLARE Act_PagoPend	int(11);



DECLARE Var_CantPenAct	decimal(12,2);
DECLARE	Var_Estatus		char(1);


Set	Entero_Cero		:= 0;
Set	Cadena_Vacia	:= '';
Set	Decimal_Cero	:= 0.0;
Set	Bigint_Cero		:= 0;
Set	Fecha_Vacia		:= '1900-01-01';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Est_Pendiente	:= 'P';
Set	Est_Cobrado		:= 'C';
Set	Est_Cancelado	:= 'D';
set	Salida_SI 	   	:= 'S';
set	Var_SI 	 	 	:= 'S';
Set	Act_PagoPend	:= 1;

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

if(ifnull(Par_FechaPago, Fecha_Vacia)= Fecha_Vacia )then
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


if(Par_NumAct = Act_PagoPend) then
	set Var_CantPenAct := (select CantPenAct
							from COBROSPEND
							WHERE	ClienteID	= Par_ClienteID
							 AND 	CuentaAhoID	= Par_CuentaAhoID
							 AND	Fecha		= Par_Fecha
							 AND	TipoMovAhoID= Par_TipoMovAhoID
							 AND	Transaccion	= Par_Transaccion);


	if ((Var_CantPenAct-Par_Monto) = Decimal_Cero) then
		SET Var_Estatus := Est_Cobrado;
	else
		SET Var_Estatus := Est_Pendiente;
	end if;

	set Var_PagaIVA		:= (select	Cli.PagaIVA
								from	CLIENTES	Cli,
										SUCURSALES 	Suc
							where 	Cli.ClienteID  = Par_ClienteID
							 and 	Cli.SucursalOrigen = Suc.SucursalID);

	set Var_IVA			:= (select	case Cli.PagaIVA when 'S' then Suc.IVA else 0 end as PagaIVA
								from	CLIENTES	Cli,
										SUCURSALES 	Suc
							where 	Cli.ClienteID  = Par_ClienteID
							 and 	Cli.SucursalOrigen = Suc.SucursalID);

	UPDATE  COBROSPEND SET
		CantPenAct		= CantPenAct - Par_Monto,
		Estatus			= Var_Estatus,
		FechaPago		= Par_FechaPago,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE	ClienteID	= Par_ClienteID
	 AND 	CuentaAhoID	= Par_CuentaAhoID
	 AND	Fecha		= Par_Fecha
	 AND	TipoMovAhoID= Par_TipoMovAhoID
	 AND	Transaccion	= Par_Transaccion;

	if(Var_PagaIVA = Var_SI)then
		UPDATE  COBROSPEND SET
			IVA		= CantPenAct * Var_IVA
		WHERE	ClienteID	= Par_ClienteID
		 AND 	CuentaAhoID	= Par_CuentaAhoID
		 AND	Fecha		= Par_Fecha
		 AND	TipoMovAhoID= Par_TipoMovAhoID
		 AND	Transaccion	= Par_Transaccion;
	end if;


	set	Par_NumErr := 0;
	set	Par_ErrMen := concat("Cobro Pendiente Actualizado.");

end if;


if (Par_Salida = Salida_SI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
end if;

END TerminaStore$$