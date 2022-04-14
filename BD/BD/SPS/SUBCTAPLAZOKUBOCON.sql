-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOKUBOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOKUBOCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOKUBOCON`(
	Par_ConceptoKuboID 		int(11),
	Par_NumRetiros 			int(11),
	Par_NumCon		tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;

if(Par_NumCon = Con_Principal) then
	select	ConceptoKuboID,		NumRetiros,		SubCuenta
	from		SUBCTAPLAZOKUBO
	where  	ConceptoKuboID 	= Par_ConceptoKuboID
	and 	 	NumRetiros		= Par_NumRetiros;
end if;

END TerminaStore$$