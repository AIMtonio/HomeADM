-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRETIPCONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRETIPCONCON`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRETIPCONCON`(
	Par_TipoContratoCCID		varchar(2),
	Par_NumCon					tinyint unsigned,
	Par_EmpresaID				int,

	Aud_Usuario					int,
	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion			bigint
	)
TerminaStore: BEGIN


DECLARE		Con_Principal		int;


Set	Con_Principal				:= 1;

if(Par_NumCon = Con_Principal) then
	select	TipoContratoCCID,	Descripcion
		from CIRCULOCRETIPCON
		where TipoContratoCCID = Par_TipoContratoCCID;
end if;

END TerminaStore$$