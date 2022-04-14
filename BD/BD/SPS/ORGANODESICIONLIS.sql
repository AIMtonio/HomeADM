-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANODESICIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANODESICIONLIS`;DELIMITER $$

CREATE PROCEDURE `ORGANODESICIONLIS`(
	Par_OrganoID 		int(11),
	Par_Descripcion 	varchar(100),
	Par_NumLis			tinyint unsigned,

	Aud_empresa 		int(11) ,
    Aud_Usuario 		int(11) ,
    Aud_FechaActual 	datetime,
    Aud_DireccionIP 	varchar(15),
    Aud_ProgramaID 		varchar(50),
    Aud_SucursalID 		int(11) ,
    Aud_NumTransaccion  bigint(20)

	)
TerminaStore:BEGIN


DECLARE varControl      char(15);


DECLARE		Lis_Grid	int;
DECLARE		Lis_Principal	int;
DECLARE 		Lis_Combo INT;


Set	Lis_Grid		:= 1;
Set Lis_Principal	:= 2;



if(Par_NumLis = Lis_Grid) then
	select OrganoID, Descripcion
	from 	ORGANODESICION ;
end if;

if(Par_NumLis = Lis_Principal) then
	select OrganoID, Descripcion
	from 	ORGANODESICION
	where descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;


END TerminaStore$$