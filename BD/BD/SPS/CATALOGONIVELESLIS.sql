-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGONIVELESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGONIVELESLIS`;DELIMITER $$

CREATE PROCEDURE `CATALOGONIVELESLIS`(
	Par_Descripcion		varchar(50),
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN


DECLARE Lis_Combo	int(11);


set Lis_Combo		:= 1;

if(Par_NumLis = Lis_Combo)then
	select NivelID, Descripcion
		from CATALOGONIVELES;
end if;

END TerminaStore$$