-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSENVIOSPEILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADOSENVIOSPEILIS`;DELIMITER $$

CREATE PROCEDURE `ESTADOSENVIOSPEILIS`(
	Par_EstadoEnvioID   int(3),
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

if(Par_NumLis = Lis_Principal) then
	select EN.EstadoEnvioID, EN.Descripcion
	from ESTADOSENVIOSPEI EN
	limit 0, 15;
end if;


END TerminaStore$$