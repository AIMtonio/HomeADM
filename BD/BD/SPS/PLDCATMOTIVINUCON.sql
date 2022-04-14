-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATMOTIVINUCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCATMOTIVINUCON`;DELIMITER $$

CREATE PROCEDURE `PLDCATMOTIVINUCON`(
	Par_CatMotivInuID	char(15),
	Par_NumCon			tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea	int;
DECLARE 		Con_F2		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_F2		:= 3;

if(Par_NumCon = Con_Principal) then
	select	DesLarga
	from 	PLDCATMOTIVINU
	where	CatMotivInuID 	= Par_CatMotivInuID;
end if;



END TerminaStore$$