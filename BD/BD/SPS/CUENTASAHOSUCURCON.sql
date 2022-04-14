-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOSUCURCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOSUCURCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOSUCURCON`(

	Par_SucursalID       int(11),
	Par_InstitucionID    int(11),
	Par_NumCon	int,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN
DECLARE		Var_Folio		int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal		int;
DECLARE		Con_Foranea		int;
DECLARE		Con_Folio		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set Entero_Cero := 0;
Set	Con_Principal:=1;
Set	Con_Foranea:=2;
Set	Con_Folio:=3;


if(Par_NumCon = Con_Foranea) then
  select CuentaSucurID,CueClave from CUENTASAHOSUCUR
  where InstitucionID=Par_InstitucionID and
  SucursalID=Par_SucursalID order by EsPrincipal desc;

end if;






END TerminaStore$$