-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCAMBIOSUCURCLIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISCAMBIOSUCURCLIREP`;DELIMITER $$

CREATE PROCEDURE `HISCAMBIOSUCURCLIREP`(




  Par_ClienteInicio INT(11),
  Par_ClienteFin    INT(11),
  Par_NumReporte    int(11),
  Par_FechaInicial  date,
  Par_FechaFinal    date,

  Par_EmpresaID   INT,
  Aud_Usuario     INT,
  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT,
  Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Rep_Principal   INT;



DECLARE Var_Sentencia VARCHAR(9000);


Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set Rep_Principal   := 1;

if(Par_NumReporte = Rep_Principal) then

  set Var_Sentencia :=  'select His.ClienteID, Cli.NombreCompleto AS NombreCliente, His.SucursalOrigen, His.SucursalDestino,
                  SucO.NombreSucurs AS NombreSucursO, SucD.NombreSucurs AS NombreSucursD, ProO.NombrePromotor AS NombrePromotorO,
                  ProD.NombrePromotor AS NombrePromotorD,
                  His.PromotorAnterior AS PromotorOrigen, His.PromotorActual AS PromotorDestino, CAST(Fecha AS CHAR)  AS Fecha ';

  set Var_Sentencia :=  CONCAT(Var_Sentencia,' from HISCAMBIOSUCURCLI His,
                         CLIENTES Cli,
                         SUCURSALES SucO,
                         SUCURSALES SucD,
                         PROMOTORES ProO,
                         PROMOTORES ProD');

  set Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE His.ClienteID = Cli.ClienteID
                         and His.SucursalOrigen = SucO.SucursalID
                         and His.SucursalDestino = SucD.SucursalID
                         and His.PromotorAnterior = ProO.PromotorID
                         and His.PromotorActual= ProD.PromotorID');

  if(ifnull(Par_ClienteInicio,Entero_Cero) != Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and His.ClienteID >= ', Par_ClienteInicio);
    end if;
  if(ifnull(Par_ClienteFin,Entero_Cero) != Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and His.ClienteID <= ', Par_ClienteFin);
    end if;

  if(ifnull(Par_FechaInicial,Cadena_Vacia) != Cadena_Vacia and Par_FechaInicial != '0000-00-00' )then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and DATE(His.Fecha) >= "', Par_FechaInicial,'"');
    end if;
  if(ifnull(Par_FechaFinal,Cadena_Vacia) != Cadena_Vacia and Par_FechaFinal != '0000-00-00' )then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and DATE(His.Fecha) <= "', Par_FechaFinal,'"');
    end if;

  set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by  His.ClienteID, Fecha;');

  set @Sentencia  = (Var_Sentencia);

  PREPARE STCAMBIOSUCURCLIREP FROM @Sentencia;
  EXECUTE STCAMBIOSUCURCLIREP;

  DEALLOCATE PREPARE STCAMBIOSUCURCLIREP;

end if;



END TerminaStore$$