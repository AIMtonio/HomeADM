-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURENCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURENCALT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURENCALT`(

	Par_MesPresupuesto   	int(2),
	Par_AnioPresupuesto  	int(4),
	Par_Usuario				int(11),
	Par_Fecha				date,
	Par_Sucursal			int(11),
	Par_Estatus				char(1),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

DECLARE		Var_Folio		int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Existe_Folio      int(11);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero 	:= 0;


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


Set Existe_Folio:=(select folioID from PRESUCURENC
					where  MesPresupuesto=Par_MesPresupuesto and
							AnioPresupuesto =Par_AnioPresupuesto
							and SucursalOrigen=Par_Sucursal );

if(ifnull(Existe_Folio, Entero_Cero)= Entero_Cero) then

	Set Var_Folio := (select ifnull(Max(FolioID),Entero_Cero)+1 from PRESUCURENC);

	Set Aud_FechaActual := CURRENT_TIMESTAMP();

	insert into PRESUCURENC
			(FolioID,			MesPresupuesto,		AnioPresupuesto,		UsuarioElaboro,
			 SucursalOrigen,    Fecha, 				Estatus,				EmpresaID,
			 Usuario,			FechaActual,		DireccionIP,			ProgramaID,
			 Sucursal,			NumTransaccion   )

	values(Var_Folio,			Par_MesPresupuesto,	Par_AnioPresupuesto,		Par_Usuario,
			Par_Sucursal,       Par_Fecha, 			Par_Estatus,				Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,            Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

	select	0 as NumErr,
	concat("Se Agrego exitosamente el Presupuesto con Folio: ", convert(Var_Folio, CHAR))  as ErrMen,
	'folio'	as control,
	Var_Folio as consecutivo;


else

		select	'003' as NumErr,
				concat("Ya existe un presupuesto de este mes con Folio: ", convert(Existe_Folio, CHAR))  as ErrMen,
			    'FolioID' as control,
			    Existe_Folio as consecutivo;

end if;


END TerminaStore$$