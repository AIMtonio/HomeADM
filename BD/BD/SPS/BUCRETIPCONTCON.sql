-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUCRETIPCONTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUCRETIPCONTCON`;DELIMITER $$

CREATE PROCEDURE `BUCRETIPCONTCON`(

	Par_TipoContratoBCID		varchar(5),
	Par_NumCon				tinyint unsigned,

	Aud_EmpresaID				int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN

DECLARE	Con_Principal	int;

Set	Con_Principal	:= 1;

if(Par_NumCon = Con_Principal) then
	select	Descripcion
	from 	BUCRETIPCONTRA
	where	TipoContratoBCID 	= Par_TipoContratoBCID;
end if;



END TerminaStore$$