-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESSPEILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESSPEILIS`;DELIMITER $$

CREATE PROCEDURE `INSTITUCIONESSPEILIS`(
	Par_InstitucionID   int(5),
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

Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
    select INS.InstitucionID, INS.Descripcion
    from INSTITUCIONESSPEI INS
    where INS.InstitucionID not in(select ParticipanteSpei  from PARAMETROSSPEI)
	limit 0, 15;
end if;


END TerminaStore$$