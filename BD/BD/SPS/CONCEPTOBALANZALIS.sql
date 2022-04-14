-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOBALANZALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOBALANZALIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOBALANZALIS`(
	Par_Descripcion 	CHAR(30),
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Lis_PrincipalAlfa		int;

Set	Lis_PrincipalAlfa	:= 1;


if(Par_NumLis = Lis_PrincipalAlfa) then
	select	ConBalanzaID,  Descripcion
	from 	CONCEPTOBALANZA
	where	(Descripcion like concat("%", Par_Descripcion, "%")
	or 		ConBalanzaID like concat(Par_Descripcion, "%"))
	limit 0, 10;
end if;

END TerminaStore$$