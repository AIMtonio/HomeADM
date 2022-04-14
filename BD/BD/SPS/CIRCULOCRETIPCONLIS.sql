-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRETIPCONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRETIPCONLIS`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRETIPCONLIS`(
	Par_TipoContratoBCID		varchar(2),
	Par_Descripcion				varchar(100),
	Par_NumLis					tinyint unsigned,
	Par_EmpresaID				int,

	Aud_Usuario					int,
	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion			bigint
	)
TerminaStore: BEGIN


DECLARE		Lis_Principal		int;


Set	Lis_Principal				:= 1;

if(Par_NumLis = Lis_Principal) then
	select TipoContratoCCID, Descripcion
		from CIRCULOCRETIPCON
		where Descripcion like concat('%',Par_Descripcion,'%')
	limit 15;
end if;

END TerminaStore$$