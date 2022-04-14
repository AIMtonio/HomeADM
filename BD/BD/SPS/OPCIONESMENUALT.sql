-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESMENUALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESMENUALT`;DELIMITER $$

CREATE PROCEDURE `OPCIONESMENUALT`(
	Par_GrupoMenuID	int,
	Par_Descripcion	varchar(100),
	Par_Desplegado		varchar(45),
	Par_Recurso		varchar(45),

	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual	DateTime,
	Aud_DireccionIP	varchar(15),
	Aud_ProgramaID	varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	NumConsecutivo	int;
DECLARE	Estatus_Vigente	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	ConsOrden			int;


Set	NumConsecutivo	:= 0;
Set	Estatus_Vigente	:= 'V';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;



if(ifnull(Par_GrupoMenuID,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Grupo esta Vacio.' as ErrMen,
		 'grupoMenu' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;



if(ifnull(Par_Desplegado, Cadena_Vacia)) = Cadena_Vacia then
	select '003' as NumErr,
		 'El Desplegado esta Vacio.' as ErrMen,
		 'desplegado' as control,
		  NumConsecutivo as consecutivo;
	LEAVE TerminaStore;
end if;


set NumConsecutivo := (select ifnull(Max(OpcionMenuID),Entero_Cero)+1
from OPCIONESMENU);
set ConsOrden := (select ifnull(Max(Orden),Entero_Cero)+1
from OPCIONESMENU
where GrupoMenuID = Par_GrupoMenuID);
Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into OPCIONESMENU values (	  NumConsecutivo,	Par_GrupoMenuID, 		Par_EmpresaID,
							  Par_Descripcion,	Par_Desplegado,		Par_Recurso,
							  ConsOrden, 		Aud_Usuario,			Aud_FechaActual,
							  Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						       Aud_NumTransaccion);


select '000' as NumErr,
	  concat("Opcion del menu Agregado: ", convert(NumConsecutivo, CHAR))  as ErrMen,
	  'numero' as control, (SELECT LPAD(NumConsecutivo, 3, 0)) as consecutivo;

END TerminaStore$$