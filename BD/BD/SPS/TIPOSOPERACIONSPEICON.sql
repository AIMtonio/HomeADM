-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSOPERACIONSPEICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSOPERACIONSPEICON`;DELIMITER $$

CREATE PROCEDURE `TIPOSOPERACIONSPEICON`(
    Par_TipoOperacionID int(2),
    Par_NumCon          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint

)
TerminaStore: BEGIN


DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	bigint;
DECLARE		Con_Estatus     char;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Estatus		:= 2;



if(Par_NumCon = Con_Principal) then
 	select TS.TipoOperacionID, TS.Descripcion,TS.Estatus
    from TIPOSOPERACIONSPEI TS
	where TS.TipoOperacionID = Par_TipoOperacionID;
end if;


END TerminaStore$$