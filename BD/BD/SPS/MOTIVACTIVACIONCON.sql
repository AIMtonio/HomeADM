-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVACTIVACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `MOTIVACTIVACIONCON`;DELIMITER $$

CREATE PROCEDURE `MOTIVACTIVACIONCON`(
    Par_MotivoActivaID     int(11),
    Par_NumCon         tinyint unsigned,


    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint	)
TerminaStore: BEGIN



    DECLARE	Con_Principal	int;


    SET  Con_Principal :=1;

    if(   Par_NumCon  = Con_Principal) then
        select    MotivoActivaID,   TipoMovimiento,         Descripcion,    PermiteReactivacion,
                  RequiereCobro,    EmpresaID,  Usuario,    FechaActual,    DireccionIP,
                  ProgramaID,   Sucursal,   NumTransaccion, PermiteReactivacion,    RequiereCobro
        from MOTIVACTIVACION
        where MotivoActivaID= Par_MotivoActivaID;
    end if;
END TerminaStore$$