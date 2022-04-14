-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJEROATMTRANSFALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJEROATMTRANSFALT`;DELIMITER $$

CREATE PROCEDURE `CAJEROATMTRANSFALT`(
	Par_CajeroOrigenID		varchar(20),
	Par_CajeroDestinoID		varchar(20),
	Par_Fecha				date,
	Par_Cantidad			decimal(14,2),
	Par_Estatus				char(1),

	Par_MonedaID			int(11),
	Par_SucursalID			int(11),
	Par_Salida				char(1),
	inout Par_NumErr    	int,
    inout Par_ErrMen    	varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN


DECLARE Var_CajeroTID			int(11);
DECLARE Var_Control				char(1);
DECLARE Var_EstatusCajeroAtm	char(1);


DECLARE Cadena_Vacia		char;
DECLARE SalidaSI			char(1);
DECLARE Decimal_Cero		decimal;
DECLARE Entero_Cero			int;
DECLARE EstatusActivo		char(1);


set Cadena_Vacia			:='';
set SalidaSI				:='S';
set Decimal_Cero			:=0.0;
set Entero_Cero				:=0;
set EstatusActivo			:='A';

ManejoErrores:BEGIN
if(ifnull(Par_CajeroOrigenID, Cadena_Vacia)= Cadena_Vacia)then
	set Par_NumErr := 1;
	set Par_ErrMen := "El Origen de la Transferencia esta vacio";
	set Var_Control	:= 'cajaID';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_CajeroDestinoID, Cadena_Vacia)= Cadena_Vacia)then
	set Par_NumErr := 2;
	set Par_ErrMen := "El Destino de la transferencia esta vacio";
	set Var_Control	:= 'cajaID';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_Cantidad, Decimal_Cero)= Decimal_Cero)then
	set Par_NumErr := 3;
	set Par_ErrMen := "El Monto de la Transferencia se encuentra vacio";
	set Var_Control	:= 'montoID';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_MonedaID, Entero_Cero)= Entero_Cero)then
	set Par_NumErr := 4;
	set Par_ErrMen := "La moneda esta vacia";
	set Var_Control	:= 'montoID';
	LEAVE ManejoErrores;
end if;


if not exists(select  CajeroID
				from CATCAJEROSATM
					where CajeroID =  Par_CajeroDestinoID)then
	set Par_NumErr := 5;
	set Par_ErrMen := "El Cajero Destino no Existe";
	set Var_Control	:= 'cajeroDestinoID';
	LEAVE ManejoErrores;
end if;



select Estatus	into Var_EstatusCajeroAtm
	from CATCAJEROSATM
	where CajeroID = Par_CajeroDestinoID;

set Var_EstatusCajeroAtm :=ifnull(Var_EstatusCajeroAtm,Cadena_Vacia );
if(Var_EstatusCajeroAtm	!= EstatusActivo)then
		set Par_NumErr := 6;
	set Par_ErrMen := "El Cajero Destino no se Encuentra Activo";
	set Var_Control	:= 'cajeroID';
	LEAVE ManejoErrores;

end if;



call FOLIOSAPLICAACT( 'CAJEROATMTRANSF',Var_CajeroTID);
set Aud_FechaActual	:=now();

insert into CAJEROATMTRANSF (
				CajeroTransfID,	CajeroOrigenID,	CajeroDestinoID,	Fecha,		Cantidad,
				Estatus,		MonedaID,		SucursalOrigen,		EmpresaID,	Usuario,
				FechaActual,	DireccionIP,	ProgramaID,			Sucursal,	NumTransaccion)
		values
			(Var_CajeroTID,		Par_CajeroOrigenID,	Par_CajeroDestinoID,Par_Fecha,		Par_Cantidad,
			Par_Estatus,		Par_MonedaID,	Par_SucursalID,			Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);


END ManejoErrores;

if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Par_CajeroDestinoID as consecutivo;
	end if;
END TerminaStore$$