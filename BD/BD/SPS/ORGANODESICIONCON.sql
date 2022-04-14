-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANODESICIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANODESICIONCON`;DELIMITER $$

CREATE PROCEDURE `ORGANODESICIONCON`(
	Par_OrganoID 		int(11),
	Par_Descripcion 	varchar(100),
	Par_NumCon			tinyint unsigned,


	Aud_Empresa         int(11) ,
    Aud_Usuario         int(11) ,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_SucursalID      int(11) ,
    Aud_NumTransaccion  bigint(20)

	)
TerminaStore:BEGIN




DECLARE	Con_Principal	int;


Set	Con_Principal	:= 1;


if(Par_NumCon = Con_Principal) then
	select OrganoID, Descripcion
	from 	ORGANODESICION
	where Par_OrganoID=OrganoID;
end if;


END TerminaStore$$