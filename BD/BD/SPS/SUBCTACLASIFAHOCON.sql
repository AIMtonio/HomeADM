-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFAHOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFAHOCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTACLASIFAHOCON`(
	Par_ConceptoAhoID	int(5),
	Par_Clasificacion	char(1),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID 		int(11),
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
	select	ConceptoAhoID,		EmpresaID,			Clasificacion,	SubCuenta
	from		SUBCTACLASIFAHO
	where	ConceptoAhoID 	= Par_ConceptoAhoID
	and		Clasificacion	= Par_Clasificacion;
end if;
END TerminaStore$$