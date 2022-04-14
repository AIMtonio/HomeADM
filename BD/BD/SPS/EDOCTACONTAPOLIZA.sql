-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACONTAPOLIZA
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACONTAPOLIZA`;DELIMITER $$

CREATE PROCEDURE `EDOCTACONTAPOLIZA`(

    Par_ClienteID   INT(11),
    Par_Total       DECIMAL(14,2)
        )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE Decimal_Cero    DECIMAL(12,2);
    DECLARE Fecha_Vacia     DATE;
    DECLARE MesProceso      VARCHAR(10);

    DECLARE FinProceso      VARCHAR(10);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Decimal_Cero    := 0.0;


    SET MesProceso  :=  (SELECT AnioMes FROM EDOCTADATOSCTE WHERE ClienteID = Par_ClienteID);

    SET MesProceso := CONCAT(SUBSTRING(MesProceso,1,4),'-',SUBSTRING(MesProceso,5,6),'-01');
    SET FinProceso := Last_Day(MesProceso);


    DROP TEMPORARY TABLE IF EXISTS TMPMOVEDOCTA;
    CREATE TEMPORARY TABLE TMPMOVEDOCTA (
        ClienteID       INT(11),
        PolizaID        BIGINT(20),
        CuentaAhoID     BIGINT(12),
        DescripcionMov  VARCHAR(150),
        CFDIUUID        VARCHAR(50),
        RFC             VARCHAR(13),
        Total           DECIMAL(14,2));

    CREATE INDEX id_indexPoliza ON TMPMOVEDOCTA (PolizaID);


    INSERT INTO TMPMOVEDOCTA
    SELECT  Cte.ClienteID, Cta.PolizaID, Cta.CuentaAhoID,Cta.DescripcionMov,IFNULL(Cte.CFDIUUID,Cadena_Vacia) AS CFDIUUID,
            IFNULL(Cte.RFC,Cadena_Vacia) AS RFC,IFNULL(Par_Total,Decimal_Cero) AS Total
    FROM EDOCTADETACTA Cta,
         EDOCTADATOSCTE Cte
    WHERE Cta.TipoMovAhoID IN (202, 203, 204, 205, 206, 207, 208, 209, 21, 22,
            210, 211, 212, 213, 214,215,216,217,218,219, 220, 221, 225, 226)
        AND Cta.ClienteID = Cte.ClienteID
        AND Cte.ClienteID = Par_ClienteID;


    UPDATE DETALLEPOLIZA Det,
            TMPMOVEDOCTA Tmp
    SET Det.FolioUUID = Tmp.CFDIUUID,
        Det.RFC = Tmp.RFC,
        Det.TotalFactura = Tmp.Total
    WHERE Det.PolizaID = Tmp.PolizaID
    AND CAST(Det.Instrumento AS UNSIGNED) = Tmp.CuentaAhoID
    AND Det.Descripcion = Tmp.DescripcionMov;



    DROP TEMPORARY TABLE IF EXISTS TMPINVEDOCTA;
    CREATE TEMPORARY TABLE TMPINVEDOCTA (
        ClienteID       INT(11),
        InversionID     INT(11),
        Fecha           DATE,
        CFDIUUID        VARCHAR(50),
        RFC             VARCHAR(13),
        Total           DECIMAL(14,2));

    CREATE INDEX id_indexInversion ON TMPINVEDOCTA (InversionID);

    INSERT INTO TMPINVEDOCTA
    SELECT Inv.ClienteID, Mov.InversionID, Mov.Fecha,IFNULL(Cte.CFDIUUID,Cadena_Vacia) AS CFDIUUID,
            IFNULL(Cte.RFC,Cadena_Vacia) AS RFC,IFNULL(Par_Total,Decimal_Cero) AS Total
    FROM INVERSIONESMOV Mov,
         INVERSIONES Inv,
         EDOCTADATOSCTE Cte
    WHERE Mov.InversionID = Inv.InversionID
    AND Inv.ClienteID = Cte.ClienteID
    AND Mov.Fecha >= MesProceso
    AND Mov.Fecha <= FinProceso
    AND Inv.ClienteID = Par_ClienteID;


    UPDATE DETALLEPOLIZA Det,
           TMPINVEDOCTA Tmp
    SET Det.FolioUUID = Tmp.CFDIUUID,
        Det.RFC = Tmp.RFC,
        Det.TotalFactura = Tmp.Total
    WHERE Det.Fecha = Tmp.Fecha
    AND CAST(Det.Instrumento AS UNSIGNED) = Tmp.InversionID;



    DROP TEMPORARY TABLE IF EXISTS TMPCREDEDOCTA;
    CREATE TEMPORARY TABLE TMPCREDEDOCTA (
        ClienteID       INT(11),
        CreditoID       BIGINT(12),
        PolizaID        BIGINT(20),
        FechaOperacion  DATE,
        Cargos          DECIMAL(14,2),
        CFDIUUID        VARCHAR(50),
        RFC             VARCHAR(13),
        Total           DECIMAL(14,2));

    CREATE INDEX id_indexPoliza ON TMPCREDEDOCTA (PolizaID);

    INSERT INTO TMPCREDEDOCTA
    SELECT Con.ClienteID,Con.CreditoID,Con.PolizaID,Con.FechaOperacion,
        Con.Cargos,IFNULL(Cte.CFDIUUID,Cadena_Vacia) AS CFDIUUID,
        IFNULL(Cte.RFC,Cadena_Vacia) AS RFC,IFNULL(Par_Total,Decimal_Cero) AS Total
    FROM CONELECDETACRE Con,
        EDOCTADATOSCTE Cte
    WHERE Cte.ClienteID = Con.ClienteID
    AND  Con.ClienteID = Par_ClienteID;


    UPDATE DETALLEPOLIZA Det,
           TMPCREDEDOCTA Tmp
    SET Det.FolioUUID =  Tmp.CFDIUUID,
        Det.RFC = Tmp.RFC,
        Det.TotalFactura = Tmp.Total
    WHERE Det.PolizaID = Tmp.PolizaID;


    DROP TEMPORARY TABLE TMPMOVEDOCTA;
    DROP TEMPORARY TABLE TMPINVEDOCTA;
    DROP TEMPORARY TABLE TMPCREDEDOCTA;

END TerminaStore$$