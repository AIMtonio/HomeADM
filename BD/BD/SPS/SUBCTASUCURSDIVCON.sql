-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUCURSDIVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTASUCURSDIVCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTASUCURSDIVCON`(
	Par_ConceptoMonID	int(11),
	Par_SucursalID	int(11),
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
	select	ConceptoMonID,		SucursalID, 		SubCuenta
	from SUBCTASUCURSDIV
	where  ConceptoMonID 	= Par_ConceptoMonID
	and 	SucursalID		=Par_SucursalID;
end if;



END TerminaStore$$