-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROFUNCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROFUNCON`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROFUNCON`(

    Par_ClienteID	    int,
    Par_NumCon			tinyint unsigned,

    Par_EmpresaID		int,
    Aud_Usuario			int,
    Aud_FechaActual		DateTime,

    Aud_DireccionIP		varchar(15),
    Aud_ProgramaID		varchar(50),
    Aud_Sucursal		int,
    Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Con_Principal	int;


Set Con_Principal	:= 1;


if(Par_NumCon = Con_Principal) then
	select  ClienteID,		format(Monto,2)as Monto,	Comentario,			ActaDefuncion,	FechaDefuncion,
			UsuarioReg,		FechaRegistro,				FechaAutoriza,		UsuarioAuto,	UsuarioRechaza,
			FechaRechaza,	MotivoRechazo,				AplicadoSocios,		Estatus
	from    CLIAPLICAPROFUN
	where   ClienteID = Par_ClienteID ;
end if;

END TerminaStore$$