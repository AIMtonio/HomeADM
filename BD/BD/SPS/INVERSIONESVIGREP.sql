-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONESVIGREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONESVIGREP`;DELIMITER $$

CREATE PROCEDURE `INVERSIONESVIGREP`(
    /* SP para el generar el reporte de inversiones Vigentes por fecha*/
    Par_Fecha     DATE,
    Par_TipoInversionID INT,
    Par_PromotorID      INT,
    Par_SucursalID      INT,
    Par_TipoMonedaID    INT
	)
TerminaStore: BEGIN

    DECLARE Var_Sentencia       VARCHAR(1000);
    DECLARE Var_ParaNombre      VARCHAR(100);
    DECLARE Var_ParaSucursal    VARCHAR(100);
    DECLARE Var_ParaMoneda      VARCHAR(100);
    DECLARE Var_Consulta        VARCHAR(100);
    DECLARE Var_Retorna         INT;

    DECLARE Entero_Cero         INT;
    DECLARE Estatus_Vig         CHAR(1);
    DECLARE Estatus_Pagado      CHAR(1);

    SET	Entero_Cero		:= 0;
    SET Estatus_Vig       :='N';
    SET Estatus_Pagado		:='P';

    SET Var_Sentencia := 'SELECT I.InversionID, I.ClienteID, C.NombreCompleto, I.Tasa, I.TasaISR,I.TasaNeta,I.Monto,I.Plazo,I.FechaVencimiento,I.InteresGenerado,';
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'I.InteresRetener, I.InteresRecibir,(I.Monto+I.InteresRecibir)AS TotalRecibir, CI.TipoInversionID, CI.Descripcion AS DescripInversion,P.PromotorID,');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'P.NombrePromotor, S.SucursalID, S.NombreSucurs,M.MonedaID,M.Descripcion AS DescripMoneda, C.ClienteID,I.SaldoProvision ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM INVERSIONES AS I');

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CATINVERSION AS CI  ON I.TipoInversionID = CI.TipoInversionID');

    SET Par_TipoInversionID:= IFNULL(Par_TipoInversionID, Entero_Cero);
    IF(Par_TipoInversionID!=0)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND CI.TipoInversionID =',CONVERT(Par_TipoInversionID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS C ON I.ClienteID = C.ClienteID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN MONEDAS AS M ON I.MonedaID = M.MonedaID');

    SET Par_TipoMonedaID := IFNULL(Par_TipoMonedaID,Entero_Cero);
    IF(Par_TipoMonedaID!=0)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND M.MonedaID =',CONVERT(Par_TipoMonedaID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES AS S ON C.SucursalOrigen = S.SucursalID');

    SET Par_SucursalID:= IFNULL(Par_SucursalID, Entero_Cero);
    IF(Par_SucursalID!=0)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND S.SucursalID =',CONVERT(Par_SucursalID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS P ON C.PromotorActual= P.PromotorID');

    SET Par_PromotorID:= IFNULL(Par_PromotorID,Entero_Cero);
    IF(Par_PromotorID!=0)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND P.PromotorID=',CONVERT(Par_PromotorID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHERE I.FechaInicio <= ? AND I.FechaVencimiento > ? AND (I.Estatus ="',Estatus_Vig,'" OR I.Estatus ="',Estatus_Pagado,'") ORDER BY S.SucursalID, I.TipoInversionID, P.PromotorID, C.ClienteID,I.InversionID  ;');

    SET @Sentencia	= (Var_Sentencia);
    SET @Fecha	= Par_Fecha;
    SET @Fecha1	= Par_Fecha;

    PREPARE SINVERSIONESVIGREP FROM @Sentencia;
    EXECUTE SINVERSIONESVIGREP USING @Fecha,@Fecha1;
    DEALLOCATE PREPARE SINVERSIONESVIGREP;

END TerminaStore$$