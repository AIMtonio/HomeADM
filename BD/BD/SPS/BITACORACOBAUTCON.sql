-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACOBAUTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACOBAUTCON`;DELIMITER $$

CREATE PROCEDURE `BITACORACOBAUTCON`(
    Par_Fecha           date,
    Par_NumCon          tinyint unsigned,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_NumPagos    int;
DECLARE Var_TiempoProc  int;


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_BitDia      int;


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_BitDia      := 1;

if(Par_NumCon = Con_BitDia) then
    select count(FechaProceso), sum(TiempoProceso) into
           Var_NumPagos, Var_TiempoProc
        from BITACORACOBAUT
        where FechaProceso = Par_Fecha;

    set Var_NumPagos    = ifnull(Var_NumPagos, Entero_Cero);
    set Var_TiempoProc  = ifnull(Var_TiempoProc, Entero_Cero);

    select  Var_NumPagos, Var_TiempoProc;
end if;


END TerminaStore$$