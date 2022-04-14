-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVIOCORREOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENVIOCORREOACT`;DELIMITER $$

CREATE PROCEDURE `ENVIOCORREOACT`(
	Par_CorreoID		int(11),
	Par_Estatus			char(1),
	Par_NumAct			tinyint unsigned,

	Par_Salida			char(1),
	inout Par_NumErr   int,
    inout Par_ErrMen   varchar(400),

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore:BEGIN

DECLARE Con_ActEstatus		int;


set Con_ActEstatus	:=1	;



if(Par_NumAct = Con_ActEstatus) then
	Update ENVIOCORREO
		set Estatus = Par_Estatus
		where Par_CorreoID = CorreoID;
end if;

END TerminaStore$$