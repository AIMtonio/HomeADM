-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMSCALIFICALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMSCALIFICALIS`;DELIMITER $$

CREATE PROCEDURE `PARAMSCALIFICALIS`(
	Par_NumLis		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE	Lis_Principal	int(11);
DECLARE	Lis_Foranea		int(11);
DECLARE Lis_Combox		int(11);

Set	Lis_Principal	:= 1;
Set	Lis_Foranea		:= 2;
set Lis_Combox	    := 3;

if(Par_NumLis = Lis_Combox) then
	select TipoInstitucion from PARAMSCALIFICA;
end if;

END TerminaStore$$