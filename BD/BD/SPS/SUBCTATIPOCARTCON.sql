-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOCARTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPOCARTCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPOCARTCON`(
	Par_ConceptoCarID 		int(11),
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
	select	ConceptoCarID, Capital,	Interes
	from		SUBCTATIPOCART
	where  	ConceptoCarID 	= Par_ConceptoCarID;
end if;

END TerminaStore$$