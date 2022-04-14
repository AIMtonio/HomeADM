-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AREASEMITESPEILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AREASEMITESPEILIS`;DELIMITER $$

CREATE PROCEDURE `AREASEMITESPEILIS`(
	Par_AreaEmiteID	    int(2),
	Par_Estatus	        char(1),
	Par_NumLis		    int,
	Par_EmpresaID		int,
	Aud_Usuario			int,

	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(20),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN

DECLARE Lis_Principal	int;
DECLARE Lis_Estatus 	int;

Set	Lis_Principal	:= 1;
Set	Lis_Estatus  	:= 2;


if(Par_NumLis = Lis_Principal) then
	select AE.AreaEmiteID, AE.Descripcion, AE.Estatus
	from AREASEMITESPEI AE
	limit 0, 15;
end if;


if(Par_NumLis = Lis_Estatus) then
	select AE.AreaEmiteID, AE.Estatus
	from AREASEMITESPEI AE
 	where AE.Estatus like concat("%", Par_Estatus, "%")
	limit 0, 15;
end if;

END TerminaStore$$