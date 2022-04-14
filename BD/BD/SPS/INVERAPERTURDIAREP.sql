-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERAPERTURDIAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERAPERTURDIAREP`;DELIMITER $$

CREATE PROCEDURE `INVERAPERTURDIAREP`(
    Par_FechaInicio     Date,
    Par_TipoInversionID int,
    Par_PromotorID      int,
    Par_SucursalID      int,
    Par_TipoMonedaID    int
	)
TerminaStore: BEGIN

DECLARE Var_Sentencia       varchar(1000);
DECLARE Var_ParaNombre      varchar(100);
DECLARE Var_ParaSucursal    varchar(100);
DECLARE Var_ParaMoneda      varchar(100);
DECLARE Var_Consulta        varchar(100);
DECLARE Var_Retorna         int;

DECLARE Entero_Cero         int;
DECLARE Estatus_Vig         char(1);
DECLARE Estatus_Can         char(1);
DECLARE Estatus_Alta         char(1);

Set	Entero_Cero		:= 0;
Set Estatus_Vig		:='N';
Set Estatus_Alta	:='A';
Set Estatus_Can		:='C';

    set Var_Sentencia := 'select I.InversionID, I.ClienteID, C.NombreCompleto, I.Tasa, I.TasaISR,I.TasaNeta,I.Monto,I.Plazo,I.FechaVencimiento,I.InteresGenerado,';
    set Var_Sentencia :=  CONCAT(Var_Sentencia, 'I.InteresRetener, I.InteresRecibir,(I.Monto+I.InteresRecibir)as TotalRecibir, CI.TipoInversionID, CI.Descripcion as DescripInversion,P.PromotorID,');
    set Var_Sentencia :=  CONCAT(Var_Sentencia, 'P.NombrePromotor, S.SucursalID, S.NombreSucurs,M.MonedaID,M.Descripcion as DescripMoneda, C.ClienteID ');
    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' from INVERSIONES as I');

    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' inner join CATINVERSION as CI  on I.TipoInversionID = CI.TipoInversionID');

    set Par_TipoInversionID:= ifnull(Par_TipoInversionID, Entero_Cero);
    if(Par_TipoInversionID!=0)then
        set Var_Sentencia = CONCAT(Var_Sentencia, ' and CI.TipoInversionID =',convert(Par_TipoInversionID,char));
    end if;

    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' inner join CLIENTES as C on I.ClienteID = C.ClienteID');
    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' inner join MONEDAS as M on I.MonedaID = M.MonedaID');

    set Par_TipoMonedaID := ifnull(Par_TipoMonedaID,Entero_Cero);
    if(Par_TipoMonedaID!=0)then
        set Var_Sentencia = CONCAT(Var_sentencia,' and M.MonedaID =',convert(Par_TipoMonedaID,char));
    end if;

    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' inner join SUCURSALES as S on C.SucursalOrigen = S.SucursalID');

    set Par_SucursalID:= ifnull(Par_SucursalID, Entero_Cero);
    if(Par_SucursalID!=0)then
        set Var_Sentencia = CONCAT(Var_Sentencia, ' and S.SucursalID =',convert(Par_SucursalID,char));
    end if;

    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' inner join PROMOTORES as P on C.PromotorActual= P.PromotorID');

    set Par_PromotorID:= ifnull(Par_PromotorID,Entero_Cero);
    if(Par_PromotorID!=0)then
        set Var_Sentencia = CONCAT(Var_Sentencia, ' and P.PromotorID=',convert(Par_PromotorID,char));
    end if;

    set Var_Sentencia :=  CONCAT(Var_Sentencia, ' where I.FechaInicio = ? and (I.Estatus !="',Estatus_Can,'" and I.Estatus !="',Estatus_Alta,'") order by S.SucursalID, I.TipoInversionID, P.PromotorID, C.ClienteID,I.InversionID  ;');



   SET @Sentencia	= (Var_Sentencia);
	SET @Fecha	= Par_FechaInicio;

      PREPARE SINVERAPERTURDIAREP FROM @Sentencia;
      EXECUTE SINVERAPERTURDIAREP USING @Fecha;
      DEALLOCATE PREPARE SINVERAPERTURDIAREP;

END TerminaStore$$