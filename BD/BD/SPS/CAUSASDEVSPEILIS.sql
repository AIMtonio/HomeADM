-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAUSASDEVSPEILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAUSASDEVSPEILIS`;DELIMITER $$

CREATE PROCEDURE `CAUSASDEVSPEILIS`(
	Par_CausaDevID	    int(2),
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
	select CD.CausaDevID, CD.Descripcion, CD.Estatus
	from CAUSASDEVSPEI CD
	limit 0, 15;
end if;


if(Par_NumLis = Lis_Estatus) then
	select CD.CausaDevID, CD.Estatus
	from CAUSASDEVSPEI CD
	where  CD.CausaDevID = Par_CausaDevID and CD.Estatus = CD_Estatus
	limit 0, 15;
end if;


END TerminaStore$$