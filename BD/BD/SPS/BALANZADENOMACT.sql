-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZADENOMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANZADENOMACT`;DELIMITER $$

CREATE PROCEDURE `BALANZADENOMACT`(
    Par_SucursalID      int(11),
    Par_CajaID          int(11),
    Par_DenomID         int(11),
    Par_MonedaID        int(11),
    Par_Cantidad        decimal(14,2),
    Par_Naturaleza      int,
    Par_NumAct          tinyint unsigned,

    Par_EmpresaID       int(11),

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_SucursalID     int;
DECLARE Var_SucursalCaja	int;


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Act_Saldo       int;
DECLARE Mov_Entrada     int;
DECLARE Mov_Salida      int;



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Act_Saldo       := 1;
Set Mov_Entrada     := 1;
Set Mov_Salida      := 2;

Set Aud_FechaActual := now();

if(Par_NumAct = Act_Saldo) then
    if (Par_Naturaleza = Mov_Salida) then
        set Par_Cantidad    := Par_Cantidad*-1;
    end if;



    select  SucursalID into Var_SucursalID
        from BALANZADENOM Bal
        where SucursalID        = Par_SucursalID
          and CajaID            = Par_CajaID
          and DenominacionID    = Par_DenomID
          and MonedaID          = Par_MonedaID;

    if(ifnull(Var_SucursalID, Entero_Cero) = Entero_Cero) then
        insert BALANZADENOM values(
            Par_SucursalID,     Par_CajaID,     Par_DenomID,        Par_MonedaID,       Par_Cantidad,
            Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion);
    else
        update BALANZADENOM set
            Cantidad    = Cantidad + Par_Cantidad
            where SucursalID        = Par_SucursalID
              and CajaID            = Par_CajaID
              and DenominacionID    = Par_DenomID
              and MonedaID          = Par_MonedaID;
    end if;
end if;


END TerminaStore$$