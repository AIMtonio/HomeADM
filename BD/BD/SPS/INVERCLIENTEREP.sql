-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERCLIENTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERCLIENTEREP`;DELIMITER $$

CREATE PROCEDURE `INVERCLIENTEREP`(
    /* SP para el generar el reporte de inversiones por cliente y sucursal*/
  Par_ClienteID INT,
  Par_SucursalID INT
	)
TerminaStore: BEGIN

    DECLARE Var_Sentencia       VARCHAR(1000);
    DECLARE Var_ParaNombre      VARCHAR(100);
    DECLARE Var_ParaSucursal    VARCHAR(100);
    DECLARE Var_ParaMoneda      VARCHAR(100);
    DECLARE Var_Consulta        VARCHAR(100);
    DECLARE Var_Retorna         INT;
    DECLARE Cadena_Vacia        VARCHAR(20);

    DECLARE Entero_Cero         INT;
    DECLARE Estatus_Vig         CHAR(1);
    DECLARE Estatus_Pag         CHAR(1);

    SET	Entero_Cero		:= 0;
    SET Cadena_Vacia    := '';
    SET Estatus_Vig		:='N';
    SET Estatus_Pag		:='P';

    SET Var_Sentencia := 'SELECT I.InversionID, I.ClienteID, C.NombreCompleto, I.Tasa, I.TasaISR,I.TasaNeta,I.Monto,I.Plazo,I.FechaInicio,I.FechaVencimiento,I.InteresGenerado,';
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'I.InteresRetener, I.InteresRecibir,(I.Monto+I.InteresRecibir)AS TotalRecibir, CI.TipoInversionID, CI.Descripcion AS DescripInversion,P.PromotorID,');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, 'P.NombrePromotor, S.SucursalID, S.NombreSucurs,M.MonedaID,M.Descripcion AS DescripMoneda, C.ClienteID, ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE I.Estatus WHEN "N" THEN "VIGENTE"  WHEN "P" THEN "PAGADA" END AS Estatus, I.SaldoProvision');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM INVERSIONES AS I');

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CATINVERSION AS CI  ON I.TipoInversionID = CI.TipoInversionID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES AS C ON I.ClienteID = C.ClienteID');

    SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);


    IF(Par_ClienteID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND C.ClienteID = "',CONVERT(Par_ClienteID,CHAR),'"');
    END IF;

	SET Par_SucursalID :=IFNULL(Par_SucursalID,Entero_Cero);
	IF(Par_SucursalID != Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND C.SucursalOrigen = "',CONVERT(Par_SucursalID,CHAR),'"');
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN MONEDAS AS M ON I.MonedaID = M.MonedaID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES AS S ON C.SucursalOrigen = S.SucursalID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES AS P ON C.PromotorActual= P.PromotorID');

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHERE (I.Estatus = "',Estatus_Vig,'" OR I.Estatus = "',Estatus_Pag,'" )');
    SET Var_Sentencia := CONCAT(Var_Sentencia, ' ORDER BY S.SucursalID, I.TipoInversionID, P.PromotorID, C.ClienteID,I.InversionID;');


    SET @Sentencia	= (Var_Sentencia);

    PREPARE SINVERCLIENTEREP FROM @Sentencia;
    EXECUTE SINVERCLIENTEREP ;
    DEALLOCATE PREPARE SINVERCLIENTEREP;

END TerminaStore$$