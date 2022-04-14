-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVTESOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSMOVTESOCON`;DELIMITER $$

CREATE PROCEDURE `TIPOSMOVTESOCON`(
    Par_TipMovTesID     varchar(4),
    Par_TipoMovimi      char(1),
    Par_NumCon          tinyint unsigned,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     Datetime,
    Aud_DireccionIP     varchar(20),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN




DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Con_Principal   int;
DECLARE Con_Foranea     int;


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Con_Principal       := 1;
Set Con_Foranea         := 2;

if(Par_NumCon = Con_Principal) then
    select  TipoMovTesoID,  Descripcion,    Estatus,        TipoMovimiento, CuentaContable,
            CuentaMayor,    CuentaEditable, NaturaContable
        from TIPOSMOVTESO
        where TipoMovTesoID     = Par_TipMovTesID
          and TipoMovimiento    = Par_TipoMovimi;
end if;


if(Par_NumCon = Con_Foranea) then
	select  TipoMovTesoID,  Descripcion,    CuentaContable,    CuentaMayor,    CuentaEditable,
			NaturaContable
		from TIPOSMOVTESO
		where TipoMovTesoID     = Par_TipMovTesID;
end if;

END TerminaStore$$