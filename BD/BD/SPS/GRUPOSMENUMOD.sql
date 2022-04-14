-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSMENUMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSMENUMOD`;DELIMITER $$

CREATE PROCEDURE `GRUPOSMENUMOD`(
	Par_GrupoMenuID		int,
	Par_MenuID			int,
	Par_Descripcion		varchar(100),
	Par_Desplegado		varchar(45),
	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

if(not exists(select GrupoMenuID
			from GRUPOSMENU
			where GrupoMenuID = Par_GrupoMenuID)) then
	select '001' as NumErr,
		 'El grupo del menu no existe.' as ErrMen,
		 'numero' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MenuID,Entero_Cero)) = Entero_Cero then
	select '002' as NumErr,
		 'El Menu esta Vacio.' as ErrMen,
		 'grupoMenu' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'La descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;



if(ifnull(Par_Desplegado, Cadena_Vacia)) = Cadena_Vacia then
	select '004' as NumErr,
		 'El Desplegado esta Vacio.' as ErrMen,
		 'desplegado' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
update GRUPOSMENU set
	MenuID				= Par_MenuID,
	Descripcion			= Par_Descripcion,
	Desplegado			= Par_Desplegado,
	EmpresaID			= Par_EmpresaID,
	Usuario				= Aud_Usuario,
	FechaActual 			= Aud_FechaActual,
	DireccionIP 			= Aud_DireccionIP,
	ProgramaID  			= Aud_ProgramaID,
	Sucursal				= Aud_Sucursal,
	NumTransaccion		= Aud_NumTransaccion

where GrupoMenuID = Par_GrupoMenuID;

select '000' as NumErr ,
	  'Grupo del Menu Modificado' as ErrMen,
	  'numero' as control;

END TerminaStore$$