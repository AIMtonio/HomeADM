-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURENCACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURENCACT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURENCACT`(

	Par_FolioID   	int(11),
	Par_Usuario		int(11),
	Par_Fecha		date,
	Par_Sucursal	int(11),
	Par_Estatus		char(1),
	Par_NumAct  	int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Var_ActEstatus  int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero 	:= 0;
Set Var_ActEstatus	:= 1;

if(ifnull(Par_Usuario, Entero_Cero)= Entero_Cero) then
	select	'001' as NumErr,
			'El campo usuario esta vacio' as ErrMen,
			'usuario' as control,
			'1' as consecutivo;
			LEAVE TerminaStore;
end if;


if(ifnull(Par_Fecha, Fecha_Vacia)= Fecha_Vacia) then
	select	'002' as NumErr,
			'La Fecha esta vacia' as ErrMen,
			'fecha' as control,
			'2' as consecutivo;
			LEAVE TerminaStore;
end if;

if(ifnull(Par_Sucursal, Cadena_Vacia)= Cadena_Vacia) then
	select	'003' as NumErr,
			'La Sucursal esta vacia' as ErrMen,
			'fecha' as control,
			'3' as consecutivo;
			LEAVE TerminaStore;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();



if(Par_NumAct = Var_ActEstatus)then

update PRESUCURENC set

	Estatus			=	Par_Estatus,

	EmpresaID		=	Aud_EmpresaID,
	Usuario			=	Aud_Usuario,
	FechaActual		=	Aud_FechaActual,
	DireccionIP		=	Aud_DireccionIP,
	ProgramaID		=	Aud_ProgramaID,
	Sucursal 		=	Aud_Sucursal,
	NumTransaccion	=	Aud_NumTransaccion

where FolioID=Par_FolioID;

end if;

			select	0 as NumErr,
					 concat("Se ha actualizado correctamente el presupuesto: ", convert(Par_FolioID, CHAR))  as ErrMen,
					'folio'	as control,
					 Par_FolioID as consecutivo;

END TerminaStore$$