-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEAFONDEACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEAFONDEACON`;DELIMITER $$

CREATE PROCEDURE `TIPOSLINEAFONDEACON`(
	Par_TLinFondID		int,
	Par_InstitutFondID	int(11),
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

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_ActComple	int;
DECLARE	Con_Foranea		int;
DECLARE	Con_Principal	int;
DECLARE Con_TipoInst	int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
set Con_TipoInst	:= 3;


if(Par_NumCon = Con_Principal) then
	select	TipoLinFondeaID,Descripcion
	from TIPOSLINEAFONDEA
	where  TipoLinFondeaID = Par_TLinFondID;
end if;

if(Par_NumCon = Con_Foranea) then
	select	TipoLinFondeaID,Descripcion,InstitutFondID
	from TIPOSLINEAFONDEA
	where  TipoLinFondeaID = Par_TLinFondID;
end if;
if(Par_NumCon = Con_TipoInst) then
	select	TipoLinFondeaID,Descripcion,InstitutFondID
	from TIPOSLINEAFONDEA
	where  TipoLinFondeaID = Par_TLinFondID
		and InstitutFondID=Par_InstitutFondID;
end if;



END TerminaStore$$