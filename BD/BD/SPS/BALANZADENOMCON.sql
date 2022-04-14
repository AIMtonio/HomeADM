-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZADENOMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANZADENOMCON`;DELIMITER $$

CREATE PROCEDURE `BALANZADENOMCON`(
    Par_SucursalID      int(11),
    Par_CajaID          int(11),
    Par_DenomID         int(11),
    Par_MonedaID        int(11),
    Par_NumCon         int,

    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(60),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_SucursalID     int;


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Saldos      int;




Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Saldos      := 1;


if(Par_NumCon = Con_Saldos) then

    select  SucursalID, CajaID, DenominacionID, Cantidad
        from BALANZADENOM Bal
        where SucursalID	= Par_SucursalID
			and CajaID            = Par_CajaID;


end if;


END TerminaStore$$