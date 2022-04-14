-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMINV000PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMINV000PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMINV000PRO`(
    Par_AnioMes     int(11),
    Par_SucursalID  int(11),
    Par_FecIniMes   DATE,
    Par_FecFinMes   DATE
)
TerminaStore: BEGIN


DECLARE	Con_Cadena_Vacia	varchar(1);
DECLARE	Con_Fecha_Vacia		date;
DECLARE	Con_Entero_Cero		int(11);
DECLARE	Con_Moneda_Cero		decimal(14,2);
DECLARE Con_StaVigente		char(1);
DECLARE Con_StaVencido		char(1);
DECLARE Con_StaPagado		char(1);
DECLARE Con_StaCancelado	char(1);


set Con_Cadena_Vacia		= '';
set Con_Fecha_Vacia		= '1900-01-01';
set Con_Entero_Cero		= 0;
set Con_Moneda_Cero		= 0.00;
set Con_StaVigente	   	= 'N';
set Con_StaVencido    		= 'V';
SET Con_StaPagado		='P';
set Con_StaCancelado		='C';
SET SQL_SAFE_UPDATES		=0;


insert into EDOCTARESUMINV
select  Par_AnioMes,
        Con_Entero_Cero,
        Inv.ClienteID,
        Inv.InversionID,
        Inv.FechaInicio,
        Inv.FechaVencimiento,
        ifnull(Inv.Etiqueta, 'Sin Etiqueta Definida'),
        Inv.Monto,
        Inv.Tasa,
        Inv.Plazo,
        Inv.InteresGenerado,
        Inv.InteresRetener,
        Inv.InteresRecibir,
		Cat.Descripcion,
		ifnull(Inv.GatInformativo, Con_Moneda_Cero),
        Inv.Estatus,

        case Inv.Estatus when Con_StaVigente then 'VIGENTE'
						 when Con_StaVencido then 'VENCIDA'
						 when Con_StaPagado then 'PAGADA'
						 when Con_StaCancelado then 'CANCELADA'
                                     else 'Estatus No Identificado'
       end
from INVERSIONES Inv
inner join CATINVERSION Cat on Inv.TipoInversionID = Cat.TipoInversionID
where (Inv.Estatus in(Con_StaVigente)
        OR (Inv.Estatus = Con_StaPagado and Inv.FechaVencimiento >= Par_FecIniMes
                              and Inv.FechaVencimiento <= Par_FecFinMes))
order by Inv.ClienteID, Inv.InversionID;

update EDOCTARESUMINV Edo, CLIENTES Cli
set Edo.SucursalID = Cli.SucursalOrigen
where Edo.ClienteID = Cli.ClienteID;


END TerminaStore$$