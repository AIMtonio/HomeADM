-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACAJERODIVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACAJERODIVCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTACAJERODIVCON`(
	Par_ConceptoMonID	int(11),
	Par_CajaID			int,
	Par_NumCon			tinyint unsigned,


	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:Begin

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;


Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;



if(Par_NumCon = Con_Principal) then
	select	ConceptoMonID,		CajaID, 		SubCuenta
	from SUBCTACAJERODIV
	where  ConceptoMonID 	= Par_ConceptoMonID
		and CajaID= Par_CajaID;
end if;



END TerminaStore$$