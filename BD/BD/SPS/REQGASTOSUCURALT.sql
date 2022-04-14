-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCURALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCURALT`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCURALT`(
	Par_SucursalID      	int(11),
	Par_UsuarioID       	int(11),
	Par_FechRequis		date,
	Par_FormaPago        	char(1),
	Par_CuentaDepo		bigint(12),
	Par_EstatusReq      	char(1),
	Par_TipoGasto			char(1),

	Par_Salida			char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID        	int(11),
	Aud_Usuario       	int(11),
	Aud_FechaActual     	datetime,
	Aud_DireccionIP     	varchar(20),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)

			)
TerminaStore: BEGIN


DECLARE Entero_Cero 			int(1);
DECLARE Cadena_Vacia 			char(1);
DECLARE Var_InstitucionID 		int(11);
DECLARE Var_DispersionID 		int(11);
DECLARE Var_Finalizado 		char(1);

DECLARE SalidaNO       		char(1);
DECLARE SalidaSI       		char(1);



DECLARE NumRequisicion 		int (11);


Set Entero_Cero				:= 0;
Set Cadena_Vacia   			:= '';
Set Var_Finalizado			:= 'F';
set Var_DispersionID 			:= 0;
Set SalidaSI       			:= 'S';
Set SalidaNO        			:= 'N';

if(ifnull(Par_SucursalID, Entero_Cero)) = Entero_Cero then
	if(Par_Salida = SalidaSI) then
		select 	'001' as NumErr,
				'La Sucursal esta vacia.' as ErrMen,
				'SucursalID' as control,
				Entero_Cero as consecutivo;
	else
		set Par_NumErr	:= 1;
		set	Par_ErrMen	:= 'La Sucursal esta vacia.' ;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_UsuarioID, Entero_Cero)) = Entero_Cero then
	if(Par_Salida = SalidaSI) then
		select	'002' as NumErr,
				'El Usuario esta vacio.' as ErrMen,
				'UsuarioID' as control,
				Entero_Cero as consecutivo;
	else
		set Par_NumErr	:= 2;
		set	Par_ErrMen	:=  'El Usuario esta vacio.' ;
	end if;
	LEAVE TerminaStore;
end if;

set NumRequisicion := (select ifnull(Max(NumReqGasID ),Entero_Cero) + 1 from REQGASTOSUCUR);

set Aud_FechaActual := now();

Insert Into	REQGASTOSUCUR	(
	NumReqGasID,			SucursalID,		UsuarioID,		FechRequisicion,		FormaPago,
	EstatusReq,			TipoGasto,		FolioDispersion,	EmpresaID, 			Usuario,
	FechaActual,			DireccionIP, 		ProgramaID, 		Sucursal,			NumTransaccion)
values	(
	NumRequisicion,		Par_SucursalID,	Par_UsuarioID,	Par_FechRequis,		Par_FormaPago,
	Par_EstatusReq,		Par_TipoGasto,	Var_DispersionID,	Par_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,			Aud_NumTransaccion);

if(Par_Salida = SalidaSI) then
	select 	'000' as NumErr,
			concat("Requisicion de Gastos agregado: ", convert(NumRequisicion, CHAR))  as ErrMen,
			'NumReqGasID' as control,
			NumRequisicion as consecutivo;
else
	set Par_NumErr	:= 0;
	set	Par_ErrMen	:=   concat("Requisicion de Gastos agregado: ", convert(NumRequisicion, CHAR));
end if;

END TerminaStore$$