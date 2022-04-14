-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESALT`;
DELIMITER $$


CREATE PROCEDURE `ROLESALT`(
	Par_NombreRol			varchar(60),
	Par_Descripcion		varchar(100),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	NumeroRol		int;
DECLARE AutoTim			char(1); -- Establece el permiso de Timbrado al Rol

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
set AutoTim			:= 'N';-- Valor por default NO

if(ifnull(Par_NombreRol,Cadena_Vacia)) = Cadena_Vacia then
	select '001' as NumErr,
		 'El nombre esta Vacio.' as ErrMen,
		 'nombreRol' as control,
		  NumeroCliente as consecutivo;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La Descripcion esta Vacia.' as ErrMen,
		 'descripcion' as control,
		  NumeroCliente as consecutivo;
	LEAVE TerminaStore;
end if;

set NumeroRol := (select ifnull(Max(RolID),Entero_Cero) + 1
from ROLES);
Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into ROLES values   (NumeroRol, 		Par_EmpresaID, 	Par_NombreRol,
						 Par_Descripcion,AutoTim,Aud_Usuario, 	Aud_FechaActual,
						 Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						 Aud_NumTransaccion);


select '000' as NumErr,
	  concat("Rol Agregado: ", convert(NumeroRol, CHAR))  as ErrMen,
	  'rolID	' as control, (SELECT LPAD(NumeroRol, 10, 0)) as consecutivo;

END TerminaStore$$