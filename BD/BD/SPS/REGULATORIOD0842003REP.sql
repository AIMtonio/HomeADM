-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD0842003REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD0842003REP`(
/*====================================================================================
---- SP QUE GENERA REPORTE DE LOS REGISTROS DE UN PERIODO DEL REGULATORIO 0842 -----
=====================================================================================*/
    Par_Anio            INT(11),
    Par_Mes             INT(11),
  Par_NumRep        TINYINT UNSIGNED,
    Par_EmpresaID   INT(11),
  Aud_Usuario     INT(11),

  Aud_FechaActual   DATETIME,
  Aud_DireccionIP   VARCHAR(15),
  Aud_ProgramaID    VARCHAR(50),
  Aud_Sucursal    INT(11),
  Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
  -- Declaracion de variables
    DECLARE Var_SI      CHAR(2);
  DECLARE Var_No      CHAR(2);

  DECLARE Rep_Excel       INT;
  DECLARE Rep_CSV       INT;

  SET Rep_Excel     := 4;
  SET Rep_CSV           := 5;
    SET Var_SI        := 'SI';
    SET Var_No        := 'NO';

  IF(Par_NumRep = Rep_Excel) THEN
    -- entidad
        DROP TABLE IF EXISTS TMP_DESENTIDAD;
    CREATE TEMPORARY TABLE TMP_DESENTIDAD(
      DesEntidadID    VARCHAR(50),
      Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_DESENTIDAD SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 1;

    -- Tabla para destino de credito
    DROP TABLE IF EXISTS TMP_DESCREDITO;
    CREATE TEMPORARY TABLE TMP_DESCREDITO(
      DesCreditoID    VARCHAR(50),
      Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_DESCREDITO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 10;

        -- tabla plazo corto largo
        DROP TABLE IF EXISTS TMP_PLAZO;
    CREATE TEMPORARY TABLE TMP_PLAZO(
      PlazoID         VARCHAR(50),
      Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_PLAZO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 12;

        -- tipo prestamista
    DROP TABLE IF EXISTS TMP_PREST;
    CREATE TEMPORARY TABLE TMP_PREST(
      TipoPrestID     VARCHAR(50),
      Descripcion     VARCHAR(250)
    );

    INSERT INTO TMP_PREST SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 15;


    SELECT  Reg.Periodo,          Reg.ClaveEntidad,         Reg.Formulario,       Ent.Descripcion AS NumeroIden,      Pre.Descripcion AS TipoPrestamista,
        Pai.Nombre AS PaisEntidadExt, Reg.NumeroCuenta,           Reg.NumeroContrato,     Cla.Descripcion AS  ClasificaConta,   DATE_FORMAT(Reg.FechaContra,'%d%m%Y') AS FechaContra,
                DATE_FORMAT(Reg.FechaVencim,'%d%m%Y') AS FechaVencim,         Reg.PlazoVencimiento,     Reg.MontoInicial,             Reg.MontoInicialMNX,    TiT.Descripcion AS TipoTasa,
                Reg.ValorTasa,          Reg.ValorTasaInt,         TaRe.Descripcion  AS  TasaIntReferencia,              Reg.DifTasaReferencia,
                Ope.Descripcion AS OperaDifTasaRefe,                Reg.FrecRevTasa,      Mon.Descripcion AS TipoMoneda,      Reg.PorcentajeComision,
                Reg.ImporteComision,      Per.Descripcion AS PeriodoComision, Reg.PagosPeriodo,
                Disp.Descripcion AS TipoDispCredito,                Des.Descripcion AS  DestinoCredito,                 Pla.Descripcion AS  ClasificaCortLarg,
                Reg.SaldoIniPeriodo,      Perd.Descripcion AS PeriodoPago,  Reg.ComPagadasPeriodo,    Reg.InteresPagado,            Reg.InteresDevengados,
                Reg.SaldoCierre,        Reg.PorcentajeLinRev,         DATE_FORMAT(Reg.FechaUltPago,'%d%m%Y') AS FechaUltPago,       CASE Reg.PagoAnticipado WHEN 101 THEN Var_SI WHEN 102 THEN Var_No END AS PagoAnticipado,
                Reg.MontoUltimoPago,      DATE_FORMAT(Reg.FechaPagoSig,'%d%m%Y') AS FechaPagoSig,     Reg.MontoPagImediato,           Tga.Descripcion AS  TipoGarantia,
                Reg.MontoGarantia,        DATE_FORMAT(Reg.FechaValuaGaran,'%d%m%Y') AS FechaValuaGaran
    FROM REGULATORIOD0842003 Reg
        INNER JOIN TMP_DESENTIDAD       Ent   ON Reg.NumeroIden       = Ent.DesEntidadID
        INNER JOIN TMP_DESCREDITO       Des   ON Reg.DestinoCredito     = Des.DesCreditoID
    INNER JOIN TMP_PLAZO            Pla   ON Reg.ClasificaCortLarg  = Pla.PlazoID
    INNER JOIN CATTIPOGARANREG        Tga   ON Reg.TipoGarantia     = Tga.CodigoOpcion
        INNER JOIN TMP_PREST            Pre   ON Reg.TipoPrestamista    = Pre.TipoPrestID
        INNER JOIN PAISES         Pai   ON Reg.PaisEntidadExt   = Pai.PaisID
        INNER JOIN MONEDAS          Mon   ON Reg.TipoMoneda     = Mon.MonedaId
        INNER JOIN CATCLASIFICACONTAREG   Cla   ON Reg.ClasificaConta   = Cla.CodigoOpcion
        INNER JOIN CATTIPOTASAREG     TiT   ON Reg.TipoTasa       = TiT.CodigoOpcion
        INNER JOIN CATTASAREFERENREG    TaRe  ON Reg.TasaIntReferencia  = TaRe.CodigoOpcion
        INNER JOIN CATOPEDIFTASAREFREG    Ope   ON Reg.OperaDifTasaRefe   = Ope.CodigoOpcion
        INNER JOIN CATPERIODOPAGCOMREG    Per   ON Reg.PeriodoComision    = Per.CodigoOpcion
    INNER JOIN CATPERIODOPAGCOMREG    Perd  ON Reg.PeriodoPago      = Perd.CodigoOpcion
        INNER JOIN CATTIPODISCREDREG    Disp  ON Reg.TipoDispCredito    = Disp.CodigoOpcion
    WHERE Reg.Anio = Par_Anio AND Reg.Mes = Par_mes
    ORDER BY Reg.Consecutivo ;
  END IF;

  IF(Par_NumRep = Rep_CSV) THEN
    SELECT CONCAT(
    Formulario,';',       NumeroIden,';',       TipoPrestamista,';',      PaisEntidadExt,';',       NumeroCuenta,';',
        NumeroContrato,';',     ClasificaConta,';',         DATE_FORMAT(FechaContra,'%d%m%Y'),';',
    DATE_FORMAT(FechaVencim,'%d%m%Y'),';',          PlazoVencimiento,';',     PeriodoPago,';',      MontoInicial,';',
    MontoInicialMNX,';',    TipoTasa,';',       ValorTasa,';',        ValorTasaInt,';',         TasaIntReferencia,';',
    DifTasaReferencia,';',    OperaDifTasaRefe,';',   FrecRevTasa,';',      TipoMoneda,';',       PorcentajeComision,';',
    ImporteComision,';',    PeriodoComision,';',    TipoDispCredito,';',    DestinoCredito,';',     ClasificaCortLarg,';',
    SaldoIniPeriodo,';',    PagosPeriodo,';',     ComPagadasPeriodo,';',    InteresPagado,';',      InteresDevengados,';',
    SaldoCierre,';',      PorcentajeLinRev,';',   DATE_FORMAT(FechaUltPago,'%d%m%Y'),';',         PagoAnticipado,';',
    MontoUltimoPago,';',    DATE_FORMAT(FechaPagoSig,'%d%m%Y'),';',         MontoPagImediato,';',   TipoGarantia,';',
    MontoGarantia,';',      DATE_FORMAT(FechaValuaGaran,'%d%m%Y'),';'
  ) AS Renglon
    FROM REGULATORIOD0842003 WHERE Anio = Par_Anio AND Mes = Par_mes
    ORDER BY Consecutivo;

  END IF;

END TerminaStore$$