-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSEMPSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSEMPSCON`;DELIMITER $$

CREATE PROCEDURE `GRUPOSEMPSCON`(
	Par_GrupoEmpID	int,
	Par_NumCon		tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

Declare	Cadena_Vacia	char(1);
Declare	Fecha_Vacia		date;
Declare	Entero_Cero		int;
Declare	Con_Principal	int;
Declare	Con_Foranea		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;


if(Par_NumCon = Con_Principal) then
	select	`GrupoEmpID`, `EmpresaID`,	`NombreGrupo`,  `Observacion`
	from GRUPOSEMP
	where  GrupoEmpID = Par_GrupoEmpID;
end if;

if(Par_NumCon = Con_Foranea) then
	select	`GrupoEmpID`,	`NombreGrupo`
	from GRUPOSEMP
	where  GrupoEmpID = Par_GrupoEmpID;
end if;

END TerminaStore$$