-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-BALANZADENOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-BALANZADENOLIS`;DELIMITER $$

CREATE PROCEDURE `HIS-BALANZADENOLIS`(
    Par_SucursalID      int(11),
    Par_CajaID          	int(11),
    Par_DenomID        int(11),
    Par_MonedaID       int(11),
    Par_Fecha			varchar(10),
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
DECLARE Con_Fecha     int;
DECLARE Lis_Fecha		int;



Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Con_Fecha      := 1;
Set Lis_Fecha      := 2;


if( Con_Fecha = Par_NumCon ) then
    select  SucursalID, CajaID, DenominacionID, Cantidad
        from `HIS-BALANZADENO`
        where CajaID		= Par_CajaID
          and MonedaID	= Par_MonedaID
	  and Fecha		=Par_Fecha;
end if;

if( Lis_Fecha = Par_NumCon )then
	select distinct Fecha
	from `HIS-BALANZADENO`
	where Fecha like concat("%",Par_Fecha,"%")
	and 	CajaID =Par_CajaID
	and 	SucursalID = Par_SucursalID
	and	 	MonedaID	= Par_MonedaID
	limit 0,10;
end if;
END TerminaStore$$