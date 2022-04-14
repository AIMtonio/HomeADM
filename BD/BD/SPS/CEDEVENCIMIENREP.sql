-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEVENCIMIENREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEVENCIMIENREP`;
DELIMITER $$

CREATE PROCEDURE `CEDEVENCIMIENREP`(
    -- SP para generar el reporte de Cedes Vencidos
    Par_FechaInicial        DATE,
    Par_FechaFinal          DATE,
    Par_TipoCedeID          INT(11),
    Par_SucursalID          INT(11),
    Par_PromotorID          INT(11),
    Par_TipoMonedaID        INT(11),
    Par_Estatus             CHAR(1),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATE,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
    /*DECLARACION DE VARIABLES */
    DECLARE Var_Sentencia       VARCHAR(10000);
    DECLARE Var_ParaNombre      VARCHAR(100);
    DECLARE Var_ParaSucursal    VARCHAR(100);
    DECLARE Var_ParaMoneda      VARCHAR(100);
    DECLARE Var_Consulta        VARCHAR(100);
    DECLARE Var_Retorna         INT;
    DECLARE Cadena_Vacia        VARCHAR(20);

    /*DECLARACION DE CONSTANTES */
    DECLARE Entero_Cero         INT;
    DECLARE Estatus_Vig         CHAR(1);
    DECLARE Estatus_Pag         CHAR(1);
    DECLARE Cadena_Cero         CHAR(1);

    /* ASIGNACION  DE CONSTANTES */
    SET Entero_Cero             := 0;
    SET Cadena_Vacia            := '';
    SET Estatus_Vig             :='N';
    SET Estatus_Pag             :='P';
    SET Cadena_Cero             :='0';

    SET Var_Sentencia :=  ('INSERT INTO TMPCEDESVENCIMIENTOS(
                CedeID,                 TipoCedeID,         DescripCede,        ClienteID,
                NombreCompleto,         TasaFija,           TasaISR,            TasaNeta,
                Monto,                  Capital,            Plazo,              FechaInicio,
                FechaVencimiento,       InteresRetener,     InteresGenerado,    InteresRecibir,
                TotalRecibir,           MonedaId,           Descripcion,        SucursalID,
                NombreSucurs,           PromotorID,         NombrePromotor,     Estatus,
                EstatusAmortizacion,    Interes)
                                ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' SELECT C.CedeID,C.TipoCedeID,TC.Descripcion AS DescripCede,C.ClienteID,CL.NombreCompleto,C.TasaFija,C.TasaISR,C.TasaNeta,C.Monto,');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AC.Capital AS Capital,C.Plazo,AC.FechaInicio,AC.FechaPago AS FechaVencimiento,AC.InteresRetener,');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AC.SaldoProvision AS InteresGenerado, ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' (AC.Interes-AC.InteresRetener) AS InteresRecibir,(AC.Capital)+(AC.Interes-AC.InteresRetener) AS TotalRecibir,MO.MonedaId, MO.Descripcion, SU.SucursalID,  SU.NombreSucurs, PO.PromotorID, PO.NombrePromotor,');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' CASE C.Estatus WHEN "N" THEN "VIGENTE" WHEN "P" THEN "PAGADA" END AS Estatus, AC.Estatus AS EstatusAmortizacion, AC.Interes ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' FROM CEDES AS C');

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN TIPOSCEDES    AS TC   ON C.TipoCedeID      = TC.TipoCedeID');

    -- SELECT Var_Sentencia;
    SET Par_TipoCedeID:= IFNULL(Par_TipoCedeID, Entero_Cero);
    IF(Par_TipoCedeID!=Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND TC.TipoCedeID =',CONVERT(Par_TipoCedeID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN CLIENTES      AS CL   ON C.ClienteID       = CL.ClienteID');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN MONEDAS       AS MO   ON C.MonedaID        = MO.MonedaID');

    SET Par_TipoMonedaID := IFNULL(Par_TipoMonedaID,Entero_Cero);
    IF(Par_TipoMonedaID!=Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_sentencia,' AND MO.MonedaID =',CONVERT(Par_TipoMonedaID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN SUCURSALES    AS SU   ON C.SucursalID = SU.SucursalID');

    SET Par_SucursalID:= IFNULL(Par_SucursalID, Entero_Cero);
    IF(Par_SucursalID!=Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND SU.SucursalID =',CONVERT(Par_SucursalID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN PROMOTORES    AS PO   ON CL.PromotorActual = PO.PromotorID');

    SET Par_PromotorID:= IFNULL(Par_PromotorID,Entero_Cero);
    IF(Par_PromotorID!=Entero_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND PO.PromotorID=',CONVERT(Par_PromotorID,CHAR));
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' INNER JOIN AMORTIZACEDES  AS AC   ON C.CedeID          = AC.CedeID');

    SET Par_Estatus:= IFNULL(Par_Estatus,Cadena_Cero);

    IF(Par_Estatus = Cadena_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND ( AC.Estatus = "',Estatus_Vig,'" OR  AC.Estatus = "',Estatus_Pag,'" )');
    END IF;

    IF(Par_Estatus != Cadena_Cero)THEN
        SET Var_Sentencia = CONCAT(Var_Sentencia, ' AND AC.Estatus = "',Par_Estatus,'"');
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' WHERE AC.FechaPago BETWEEN ? AND ?');

    SET Var_Sentencia := CONCAT(Var_Sentencia, ' ORDER BY C.CedeID,SU.SucursalID, C.TipoCedeID, PO.PromotorID, CL.ClienteID, AC.FechaPago ;');

    SET @Sentencia    = (Var_Sentencia);
    SET @FechaInicial = Par_FechaInicial;
    SET @FechaFinal   = Par_FechaFinal;

    PREPARE SINVERVENCIMIENREP FROM @Sentencia;
    EXECUTE SINVERVENCIMIENREP USING @FechaInicial, @FechaFinal;
    DEALLOCATE PREPARE SINVERVENCIMIENREP;

-- TABLA DE PASO PARA LOS MOVIMIENTOS DE ISR
    DROP TABLE IF EXISTS TMPISRCEDEREALMOV;
    CREATE TABLE TMPISRCEDEREALMOV(
        CedeID  INT(11),
        ISR     DECIMAL(18,6),
        Fecha   DATE,
        INDEX `index_cede` (`CedeID`)
       );

    INSERT INTO TMPISRCEDEREALMOV(
               CedeID,              ISR,            Fecha)
        SELECT MAX(COB.ProductoID), SUM(COB.ISR),   MAX(COB.Fecha)
                FROM COBROISR AS COB
                    INNER JOIN TMPCEDESVENCIMIENTOS AS CED ON CED.CedeID = COB.ProductoID
                    WHERE   COB.InstrumentoID=28
                    AND     COB.ProductoID NOT IN(SELECT CedeIDSAFI FROM EQU_CEDES)
                    GROUP BY COB.ProductoID;

    INSERT INTO TMPISRCEDEREALMOV(
               CedeID,              ISR,            Fecha)
        SELECT MAX(COB.ProductoID), SUM(COB.ISR),   MAX(COB.Fecha)
                FROM HISCOBROISR AS COB
                    INNER JOIN TMPCEDESVENCIMIENTOS AS CED ON CED.CedeID = COB.ProductoID
                    WHERE   COB.InstrumentoID=28
                     AND    COB.ProductoID NOT IN(SELECT CedeIDSAFI FROM EQU_CEDES)
                    GROUP BY COB.ProductoID;

    DROP TABLE IF EXISTS TMPISRCEDEREALFIN;
    CREATE TABLE TMPISRCEDEREALFIN(
        CedeID  INT(11),
        ISR     DECIMAL(18,6),
        Fecha   DATE,
        INDEX `index_cede` (`CedeID`)
       );

    INSERT INTO TMPISRCEDEREALFIN(
               CedeID,              ISR,            Fecha)
    SELECT MAX(CedeID), SUM(ISR), MAX(Fecha)
        FROM TMPISRCEDEREALMOV
        GROUP BY CedeID;

    UPDATE TMPCEDESVENCIMIENTOS AS CED
            INNER JOIN TMPISRCEDEREALFIN   AS TMP  ON CED.CedeID = TMP.CedeID
        SET
            CED.InteresRetener  =   ROUND(TMP.ISR,2),
            CED.InteresGenerado =   CED.Interes,
            CED.InteresRecibir  =   CED.Interes-ROUND(TMP.ISR,2),
            CED.TotalRecibir    =   (CED.Capital)+(CED.Interes-ROUND(TMP.ISR,2))
            WHERE TMP.Fecha between CED.FechaInicio AND CED.FechaVencimiento;

    SELECT      CedeID,                 TipoCedeID,         DescripCede,        ClienteID,
                NombreCompleto,         TasaFija,           TasaISR,            TasaNeta,
                Monto,                  Capital,            Plazo,              FechaInicio,
                FechaVencimiento,       InteresRetener,     InteresGenerado,    InteresRecibir,
                TotalRecibir,           MonedaId,           Descripcion,        SucursalID,
                NombreSucurs,           PromotorID,         NombrePromotor,     Estatus,
                EstatusAmortizacion
            FROM TMPCEDESVENCIMIENTOS;

      TRUNCATE TABLE TMPCEDESVENCIMIENTOS;
      TRUNCATE TABLE TMPISRCEDEREALMOV;
      TRUNCATE TABLE TMPISRCEDEREALFIN;
END TerminaStore$$