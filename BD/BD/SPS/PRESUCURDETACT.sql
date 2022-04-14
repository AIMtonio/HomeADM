-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURDETACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURDETACT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURDETACT`(

	Par_FolioID         	int(11),
	Par_EncabezadoID		int(11),
	Par_Concepto			int(11),
	Par_Descripcion		varchar(250),
	Par_Estatus			char(1),

	Par_Monto			decimal(18,2),
	Par_Observaciones	varchar(250),
	Num_Act				int,
	Par_Salida			char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Folio			int;
DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia		date;
DECLARE Entero_Cero		int;
DECLARE Esta_Auto			char(1);
DECLARE Esta_Soli			char(1);
DECLARE Esta_Cancel		char(1);
DECLARE Var_Monto			decimal(18,2);
DECLARE Act_Estatus   	int;
DECLARE Act_Elimina		int;
DECLARE Var_MontoDispon	decimal(13,2);
DECLARE Act_MontoDispon 	int;
DECLARE SalidaSi			char(1);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero 		:= 0;
Set Esta_Auto			:= "A";
Set Esta_Soli			:= "S";
Set Esta_Cancel		:= "C";
Set Act_Estatus   	:= 1;
Set Act_Elimina		:= 2;
Set Act_MontoDispon	:= 3;
Set SalidaSi			:= 'S';


Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(Num_Act = Act_Estatus)then
	if(Par_Estatus = Esta_Soli) then
		Set Var_MontoDispon	:=	Par_Monto;
	end if;

	if(Par_Estatus = Esta_Auto or Par_Estatus = Esta_Cancel) then
		Set Var_MontoDispon	:=	(select MontoDispon from PRESUCURDET where FolioID=Par_FolioID
								and EncabezadoID = Par_EncabezadoID);
	end if;

	update PRESUCURDET set
		Estatus 			= Par_Estatus,
		Monto			= Par_Monto,
		Descripcion		= Par_Descripcion,
		MontoDispon 		= Var_MontoDispon,
		Observaciones	=Par_Observaciones,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where	FolioID		= Par_FolioID
	 and 	EncabezadoID	= Par_EncabezadoID;

end if;


if(Num_Act = Act_Elimina)then
	update PRESUCURDET set
		Estatus = Par_Estatus,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	where FolioID=Par_FolioID
	and EncabezadoID = Par_EncabezadoID;

end if;


if(Num_Act = Act_MontoDispon)then
	update PRESUCURDET set
		MontoDispon 		= MontoDispon - Par_Monto,

		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	 where FolioID = Par_FolioID;

end if;

if(Par_Salida = SalidaSi)then
	select	'000' as NumErr,
	'' as ErrMen,
	'folio'	as control,
	Var_Folio as consecutivo;
else
	Set Par_NumErr	:= 0;
	Set Par_ErrMen	:= 'Presupuesto Actualizado';
end if ;

END TerminaStore$$