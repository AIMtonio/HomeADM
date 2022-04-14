-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPRODUCCARTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPRODUCCARTCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPRODUCCARTCON`(
	Par_ConceptoCarID 		int(11),
	Par_ProducCreditoID 			int(11),
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
	select	ConceptoCarID,		ProducCreditoID,		SubCuenta
	from		SUBCTAPRODUCCART
	where   ConceptoCarID 	= Par_ConceptoCarID
	and 	 	 ProducCreditoID	= Par_ProducCreditoID;
end if;

END TerminaStore$$