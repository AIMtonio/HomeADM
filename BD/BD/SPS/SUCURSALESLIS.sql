-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUCURSALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUCURSALESLIS`;DELIMITER $$

CREATE PROCEDURE `SUCURSALESLIS`(
	Par_NombreSucur	varchar(50),
	Par_NumLis		tinyint unsigned,
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
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Combo	 	int;
DECLARE 	Lis_Boveda		int;
DECLARE 	Lis_Foranea		int;
DECLARE Lis_SucurActivas int;
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Combo		:= 2;
Set	Lis_Boveda		:= 3;
Set	Lis_Foranea		:= 4;
Set Lis_SucurActivas := 5;

if(Par_NumLis = Lis_Principal) then
	select	`SucursalID`,		`NombreSucurs`
	from SUCURSALES
	where  NombreSucurs like concat("%", Par_NombreSucur, "%")
	and Estatus='A' AND TipoSucursal = 'A'
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Foranea) then
	select	`SucursalID`,		`NombreSucurs`
	from SUCURSALES
	where  NombreSucurs like concat("%", Par_NombreSucur, "%")
	and Estatus='A'
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Combo) then
	select	`SucursalID`,		`NombreSucurs`
	from SUCURSALES
	where Estatus = 'A';
end if;

if(Par_NumLis = Lis_Boveda) then
	select	`SucursalID`,	`NombreSucurs`
	from SUCURSALES
	where  NombreSucurs like concat("%", Par_NombreSucur, "%")
	and Estatus='A' AND TipoSucursal = 'C'
	limit 0, 15;
end if;

if(Par_NumLis = Lis_SucurActivas) then
	select	`SucursalID`,		`NombreSucurs`
	from SUCURSALES
	where Estatus = 'A';
end if;

END TerminaStore$$