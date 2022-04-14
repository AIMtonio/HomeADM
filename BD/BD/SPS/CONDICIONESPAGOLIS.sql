-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESPAGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONDICIONESPAGOLIS`;DELIMITER $$

CREATE PROCEDURE `CONDICIONESPAGOLIS`(
	Par_CondicPagID		int,
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID   	int(11),
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Lis_CondFac  	int;


Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_CondFac		:= 2;



if(Par_NumLis = Lis_CondFac) then
	select	CondicionPagoID,	Descripcion,	NumeroDias
		from CONDICIONESPAGO;
end if;



END TerminaStore$$