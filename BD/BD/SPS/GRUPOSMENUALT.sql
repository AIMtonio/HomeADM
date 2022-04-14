-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSMENUALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSMENUALT`;DELIMITER $$

CREATE PROCEDURE `GRUPOSMENUALT`(
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
DECLARE	NumGrupo		int;
DECLARE	ConsOrden		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

if(ifnull(Par_MenuID,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Menu esta Vacio.' as ErrMen,
		 'menu' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Desplegado, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'EL desplegado esta Vacio.' as ErrMen,
		 'desplegado' as control;
	LEAVE TerminaStore;
end if;

set NumGrupo := (select ifnull(Max(GrupoMenuID),Entero_Cero) + 1
from GRUPOSMENU);
set ConsOrden := (select ifnull(Max(Orden),Entero_Cero)+1
from GRUPOSMENU
where MenuID = Par_MenuID);
Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into GRUPOSMENU values   (NumGrupo, 			Par_MenuID, 		Par_EmpresaID,
							  Par_Descripcion,	Par_Desplegado,	ConsOrden,
							  Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,
							  Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);




select '000' as NumErr,
	  concat("Grupo del Menu Agregado: ", convert(NumGrupo, CHAR))  as ErrMen,
	  'menu	' as control;

END TerminaStore$$