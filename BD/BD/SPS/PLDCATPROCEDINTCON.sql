-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATPROCEDINTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCATPROCEDINTCON`;DELIMITER $$

CREATE PROCEDURE `PLDCATPROCEDINTCON`(
	Par_CatProcedIntID	char(15),
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
	select	Descripcion
	from 	PLDCATPROCEDINT
	where	CatProcedIntID	= Par_CatProcedIntID;
end if;



END TerminaStore$$