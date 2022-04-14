-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ROLESCON`;
DELIMITER $$


CREATE PROCEDURE `ROLESCON`(
	Par_RolID		int,
	Par_NumCon		int,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)

TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;
DECLARE	Con_AutTimbrado	int; -- Consulta para obtener el estatus de Autorización de Timbrado por Rol


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea	:= 2;
set Con_AutTimbrado := 3;


if(Par_NumCon = Con_Principal) then
	select	`RolID`, 		`NombreRol`, 		`Descripcion`
	from ROLES
	where  RolID = Par_RolID;
end if;

if(Par_NumCon = Con_Foranea) then
	select	`RolID`, 		`NombreRol`
	from ROLES
	where  RolID = Par_RolID;
end if;

if(Par_NumCon = Con_AutTimbrado) then
	select AutTimbrado
	from ROLES
	where  RolID = Par_RolID;
end if;


END TerminaStore$$