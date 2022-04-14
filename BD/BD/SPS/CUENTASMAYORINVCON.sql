-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORINVCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORINVCON`(
	Par_ConceptoInvID 	int(11),
	Par_NumCon			tinyint unsigned,

	Aud_EmpresaID			int,
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
	select		ConceptoInvID,		Cuenta, 		Nomenclatura,NomenclaturaCR
	from CUENTASMAYORINV
	where  ConceptoInvID 	= Par_ConceptoInvID;
end if;

END TerminaStore$$