-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAHOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROAHOCON`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPROAHOCON`(
	Par_ConceptoAhoID 		int(11),
	Par_TipoProductoID 		int(11),
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

DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;

if(Par_NumCon = Con_Principal) then
	select		ConceptoAhoID,		TipoProductoID,	SubCuenta
	from SUBCTATIPROAHO
	where  ConceptoAhoID 	= Par_ConceptoAhoID
	and	 TipoProductoID	= Par_TipoProductoID;

end if;

END TerminaStore$$