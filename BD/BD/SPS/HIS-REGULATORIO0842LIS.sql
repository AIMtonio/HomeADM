-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIO0842LIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-REGULATORIO0842LIS`;DELIMITER $$

CREATE PROCEDURE `HIS-REGULATORIO0842LIS`(

    Par_Anio            INT,
    Par_Mes             INT,
  Par_NumLis        TINYINT UNSIGNED,
    Aud_Empresa       INT(11),
  Aud_Usuario     INT(11),

  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT,
  Aud_NumTransaccion  BIGINT
  )
TerminaStore: BEGIN
DECLARE Principal     INT;
DECLARE Rep_Excel       INT;
DECLARE Rep_CSV       INT;

SET Principal       := 1;
SET Rep_Excel     := 2;
SET Rep_CSV           := 3;

IF(Par_NumLis = Principal) THEN
  SELECT
    ClaveEntidad,       Formulario,       NumeroIden,     TipoPrestamista,    ClavePrestamista,
    NumeroContrato,     NumeroCuenta,       FechaContra,    FechaVencim,      FORMAT(TasaAnual,2) AS TasaAnual,
    PeriodoPago,      Plazo,        MontoRecibido,    TipoCredito,          Destino,
    TipoGarantia,     MontoGarantia,    FechaPago,      MontoPago,        ClasificaCortLarg,
  SalInsoluto

    FROM `HIS-REGULATORIOD0842` WHERE Anio = Par_Anio AND Mes = Par_mes;
END IF;

IF(Par_NumLis = Rep_Excel) THEN

    DROP TABLE IF EXISTS TMP_DESCREDITO;
  CREATE TEMPORARY TABLE TMP_DESCREDITO(
    DesCreditoID    VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_DESCREDITO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 10;

    DROP TABLE IF EXISTS TMP_PERIODICIDAD;
  CREATE TEMPORARY TABLE TMP_PERIODICIDAD(
    PeriodicidadID    VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_PERIODICIDAD SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 11;

    DROP TABLE IF EXISTS TMP_PLAZO;
  CREATE TEMPORARY TABLE TMP_PLAZO(
    PlazoID         VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_PLAZO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 12;

    DROP TABLE IF EXISTS TMP_TIPOCRED;
  CREATE TEMPORARY TABLE TMP_TIPOCRED(
    TipoCredID    VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_TIPOCRED SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 13;

  DROP TABLE IF EXISTS TMP_TGARAN;
  CREATE TEMPORARY TABLE TMP_TGARAN(
    TipoGaranID     VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_TGARAN SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 14;

  DROP TABLE IF EXISTS TMP_PREST;
  CREATE TEMPORARY TABLE TMP_PREST(
    TipoPrestID     VARCHAR(50),
        Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_PREST SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 15;



  SELECT
  His.Periodo,              His.ClaveEntidad,               His.Formulario,               His.NumeroIden,
  Pre.Descripcion AS TipoPrestamista,     His.ClavePrestamista,               His.NumeroContrato,               His.NumeroCuenta,
  His.FechaContra,              His. FechaVencim,                 FORMAT(His.TasaAnual,2) AS TasaAnual,   His.Plazo,
  Per.Descripcion AS PeriodoPago,         His.MontoRecibido,                  Tip.Descripcion AS TipoCredito,         Des.Descripcion AS Destino,
  Tga.Descripcion AS TipoGarantia,        His.MontoGarantia,                    His.FechaPago,              His.MontoPago,
  Pla.Descripcion AS ClasificaCortLarg,   His.SalInsoluto

    FROM `HIS-REGULATORIOD0842` His            INNER JOIN TMP_DESCREDITO   Des
    ON His.Destino          = Des.DesCreditoID       INNER JOIN TMP_PERIODICIDAD Per
    ON His.PeriodoPago      = Per.PeriodicidadID     INNER JOIN TMP_PLAZO        Pla
    ON His.ClasificaCortLarg= Pla.PlazoID          INNER JOIN TMP_TIPOCRED     Tip
  ON His.TipoCredito    = Tip.TipoCredID     INNER JOIN TMP_TGARAN       Tga
  On His.TipoGarantia   = Tga.TipoGaranID    INNER JOIN TMP_PREST        Pre
    ON His.TipoPrestamista  = Pre.TipoPrestID
    WHERE His.Anio = Par_Anio AND His.Mes = Par_mes
    ORDER BY His.Consecutivo ;
END IF;

IF(Par_NumLis = Rep_CSV) THEN
  SELECT CONCAT(
    Formulario,';',     NumeroIden,';',        TipoPrestamista,';',       ClavePrestamista,';',      NumeroContrato,';',
    NumeroCuenta,';',     DATE_FORMAT(FechaContra,'%Y%m%d'),';',          DATE_FORMAT(FechaVencim,'%Y%m%d'),';',           TasaAnual,';',
    Plazo,';',        PeriodoPago,';',           MontoRecibido,';',      TipoCredito,';',       Destino,';',           TipoGarantia,';',
    MontoGarantia,';',    DATE_FORMAT(FechaPago,'%Y%m%d'),';',                MontoPago,';',              ClasificaCortLarg,';',     SalInsoluto
) AS Renglon
    FROM `HIS-REGULATORIOD0842` WHERE Anio = Par_Anio AND Mes = Par_mes
    ORDER BY Consecutivo;

END IF;

END TerminaStore$$