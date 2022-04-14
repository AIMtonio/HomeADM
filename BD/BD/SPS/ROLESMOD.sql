-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESMOD`;DELIMITER $$

CREATE PROCEDURE `ROLESMOD`(
	Par_RolID			int(11),
	Par_NombreRol			varchar(60),
	Par_Descripcion		varchar(100),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

Set Aud_FechaActual	:= NOW();

if(not exists(select RolID
			from ROLES
			where RolID = Par_RolID)) then
	select '001' as NumErr,
		 'El Rol no existe.' as ErrMen,
		 'rolID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_NombreRol,Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'El Nombre esta Vacio.' as ErrMen,
		 'nombreRol' as control;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;


update ROLES set
	NombreRol	= Par_NombreRol,
	Descripcion	= Par_Descripcion,
	EmpresaID	= Par_EmpresaID,

	Usuario		= Aud_Usuario,
	FechaActual 	= Aud_FechaActual,
	DireccionIP 	= Aud_DireccionIP,
	ProgramaID  	= Aud_ProgramaID,
	Sucursal		= Aud_Sucursal,
	NumTransaccion	= Aud_NumTransaccion

where RolID = Par_RolID;

select '000' as NumErr ,
	  'Rol Modificado' as ErrMen,
	  'rolID' as control;

END TerminaStore$$