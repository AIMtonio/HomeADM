-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGINEGISOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGINEGISOLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBGINEGISOLIS`(
    Par_GiroID       char(50),

    Par_NumLis              tinyint unsigned,

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN


DECLARE Lis_Principal		int;
DECLARE Lis_Giros			int;
DECLARE Entero_Cero		    int;
DECLARE Cadena_Vacia	    char(1);
DECLARE Estatus_Activo		char(1);


Set Entero_Cero		    := 0;
Set Cadena_Vacia		:= '';
Set Lis_Principal		:= 1;
Set Lis_Giros			:= 2;
Set Estatus_Activo		:= 'A';


if(Par_NumLis = Lis_Principal) then
    SELECT GiroID,Descripcion
        FROM TARDEBGIROSNEGISO
        WHERE Estatus = Estatus_Activo AND (GiroID like concat("%",Par_GiroID, "%") or
             Descripcion like concat("%",Par_GiroID, "%"))
        limit 0, 15;
end if;

if(Par_NumLis = Lis_Giros) then
    SELECT GiroID,Descripcion
        FROM TARDEBGIROSNEGISO
        WHERE (GiroID like concat("%",Par_GiroID, "%") or
             Descripcion like concat("%",Par_GiroID, "%"))
        limit 0, 15;
end if;

END TerminaStore$$