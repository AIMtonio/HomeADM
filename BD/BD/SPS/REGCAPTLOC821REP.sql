-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGCAPTLOC821REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCAPTLOC821REP`;
DELIMITER $$


CREATE PROCEDURE `REGCAPTLOC821REP`(

  Par_Fecha             DATE,
  Par_NumReporte        TINYINT UNSIGNED,

    Par_EmpresaID         INT(11),
    Aud_Usuario           INT(11),
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT(11),
    Aud_NumTransaccion    BIGINT(20)
)
TerminaStore: BEGIN


  DECLARE Var_FechaIniMesSis  DATE;
  DECLARE Var_FechaSistema    DATE;
  DECLARE Var_FechaHis        DATE;
  DECLARE Var_DiasAnio        INT;
  DECLARE Var_FechaSalInv     DATE;
  DECLARE Cliente_Inst    INT;
  DECLARE Var_FechaCieInv   DATE;

  DECLARE Var_MontoTotal    DECIMAL(16,2);
  DECLARE Var_MontoRound    DECIMAL(16,2);
  DECLARE Var_Diferencia    DECIMAL(16,2);
  DECLARE Var_MontoMax    DECIMAL(16,2);
  DECLARE Var_MaxLocalidad  VARCHAR(10);


  DECLARE Var_CatDepVista	DECIMAL(16,2);
  DECLARE Var_CatDepPlazo DECIMAL(16,2);
  DECLARE Var_NunCuentas	INT;

  DECLARE Entero_Cero       INT;
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Decimal_Cero      DECIMAL(12,2);
  DECLARE Fecha_Vacia       DATE;
  DECLARE Cue_Activa        CHAR(1);
  DECLARE Cue_Bloqueada     CHAR(1);
  DECLARE Inv_Vigente       CHAR(1);
  DECLARE Inv_Pagado        CHAR(1);
  DECLARE OficialSI         CHAR(1);
  DECLARE Des_DepVista      VARCHAR(100);
  DECLARE Des_Inversion     VARCHAR(100);
  DECLARE Des_DepRetDia     VARCHAR(100);
  DECLARE Cue_DepVista      VARCHAR(12);
  DECLARE Cue_Inversion     VARCHAR(12);
  DECLARE Cue_DepRetDia     VARCHAR(12);
  DECLARE CaptacionLoc14    INT;
  DECLARE CaptacionLoc13    INT;

  DECLARE CaptacionLoc14Csv   INT;
  DECLARE ClaveFederacion   VARCHAR(6);
  DECLARE ClaveEntidad      VARCHAR(6);
  DECLARE ClaveNivEnt     VARCHAR(6);
  DECLARE Var_Periodo     VARCHAR(100);
  DECLARE Rep_Csv       INT;
  DECLARE Var_Reporte     VARCHAR(100);



  SET Entero_Cero       := 0;
  SET Cadena_Vacia      := '';
  SET Decimal_Cero      := 0.00;
  SET Fecha_Vacia       := '1900-01-01';
  SET Cue_Activa        := 'A';
  SET Cue_Bloqueada     := 'B';
  SET Inv_Vigente       := 'N';
  SET Inv_Pagado        := 'P';

  SET OficialSI         := 'S';
  SET Des_DepVista      := 'DEPOSITOS A LA VISTA';
  SET Des_Inversion     := 'OTROS DEPOSITOS A PLAZO';
  SET Des_DepRetDia     := 'DEPOSITOS RETIRABLES EN DIAS PREESTABLECIDOS';

  SET Cue_DepVista      := '210101000000';
  SET Cue_Inversion     := '211190000000';
  SET Cue_DepRetDia     := '211104000000';

  SET CaptacionLoc14    := 1;
  SET CaptacionLoc13    := 2;
  SET Rep_Csv           := 3;

  SET CaptacionLoc14Csv   := 4;

  SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS);
  SET ClaveFederacion   := '';
  SET ClaveEntidad    := (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS  Ins WHERE EmpresaID = Par_EmpresaID);
  SET ClaveNivEnt     := (SELECT claveNivInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
  SET Var_Periodo     := DATE_FORMAT(Par_Fecha, '%Y%m');
  SET Var_Reporte     := '0821';


  IF(Par_NumReporte = CaptacionLoc14 OR Par_NumReporte = CaptacionLoc14Csv) THEN

      DROP TABLE IF EXISTS TMPREGB0821;

      CREATE TEMPORARY TABLE TMPREGB0821(
        TipoInstrumento VARCHAR(100),
        ClasifConta     VARCHAR(12),
        Estado          VARCHAR(100),
        Municipio       VARCHAR(100),
        Localidad       VARCHAR(10),
        Monto           DECIMAL(14,2),
        NumContratos    INT);

      SELECT FechaSistema, DiasInversion INTO
          Var_FechaSistema, Var_DiasAnio
        FROM  PARAMETROSSIS;


      SET Var_FechaIniMesSis := DATE_ADD(Var_FechaSistema, INTERVAL -1*(DAY(Var_FechaSistema))+1 DAY);


      IF (Par_Fecha >= Var_FechaIniMesSis) THEN
        INSERT INTO TMPREGB0821
          SELECT  Des_DepVista,   Cue_DepVista,  MAX(Est.Nombre),    MAX(Mun.Nombre),
              MAX(Mun.Localidad),
              IFNULL(SUM(Saldo), Entero_Cero),
              IFNULL(COUNT(DISTINCT(Cue.CuentaAhoID)), Entero_Cero)
            FROM CUENTASAHO Cue,
               DIRECCLIENTE Dir,
               ESTADOSREPUB Est,
               MUNICIPIOSREPUB Mun
            WHERE   Cue.ClienteID   = Dir.ClienteID
              AND Dir.EstadoID  = Est.EstadoID
              AND Dir.MunicipioID = Mun.MunicipioID
              AND Dir.Oficial   = OficialSI
              AND Mun.EstadoID  = Dir.EstadoID
                AND ( Cue.Estatus   = Cue_Activa )
                AND Cue.ClienteID   <> Cliente_Inst
          GROUP BY Localidad;
      ELSE

        SET Var_FechaHis := (SELECT MAX(Fecha)
                    FROM `HIS-CUENTASAHO`
                      WHERE Fecha <= Par_Fecha);

        SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

        INSERT INTO TMPREGB0821
        SELECT  Des_DepVista,   Cue_DepVista,  MAX(Est.Nombre),    MAX(Mun.Nombre),
            MAX(Mun.Localidad),
            ROUND(IFNULL(SUM(Saldo), Entero_Cero), 2),
            IFNULL(COUNT(DISTINCT(Cue.CuentaAhoID)), Entero_Cero)
          FROM `HIS-CUENTASAHO` Cue,
             DIRECCLIENTE Dir,
             ESTADOSREPUB Est,
             MUNICIPIOSREPUB Mun
          WHERE   Cue.ClienteID   = Dir.ClienteID
            AND Dir.EstadoID  = Est.EstadoID
            AND Dir.MunicipioID = Mun.MunicipioID
            AND Mun.EstadoID  = Dir.EstadoID
            AND Dir.Oficial   = OficialSI
            AND (Cue.Estatus  = Cue_Activa OR Cue.Estatus = 'B')
            AND Cue.ClienteID   <> Cliente_Inst
            AND Fecha = Var_FechaHis

        GROUP BY Localidad;

      END IF;

      SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);

      INSERT INTO TMPREGB0821
        SELECT Des_Inversion, Cue_Inversion,    MAX(Est.Nombre),
             MAX(Mun.Nombre), Mun.Localidad,
          ROUND(SUM(IFNULL(Inv.Monto, Entero_Cero)+ IFNULL(Inv.SaldoProvision, Entero_Cero)),2),
          IFNULL(COUNT(Inv.Monto), Entero_Cero)
          FROM HISINVERSIONES Inv,
             DIRECCLIENTE Dir,
             ESTADOSREPUB Est,
             MUNICIPIOSREPUB Mun
          WHERE Inv.ClienteID   = Dir.ClienteID
            AND Dir.EstadoID    = Est.EstadoID
            AND Dir.MunicipioID   = Mun.MunicipioID
            AND Mun.EstadoID    = Dir.EstadoID
            AND Dir.Oficial     = OficialSI
            AND ( Inv.Estatus   = Inv_Vigente  )
          AND Inv.FechaCorte    = Var_FechaCieInv
           AND Inv.ClienteID    <> Cliente_Inst
        GROUP BY Localidad;


      IF (Par_Fecha < Var_FechaSistema) THEN

        SET Var_FechaSalInv := (SELECT MAX(FechaCorte)
                      FROM SALDOSINVKUBO
                        WHERE FechaCorte <= Par_Fecha);

        SET Var_FechaSalInv := IFNULL(Var_FechaSalInv, Fecha_Vacia);

        SET Var_FechaSalInv := (SELECT MAX(FechaCorte)
                      FROM SALDOSINVKUBO
                        WHERE FechaCorte <= Par_Fecha);

        SET Var_FechaSalInv := IFNULL(Var_FechaSalInv, Fecha_Vacia);
        INSERT INTO TMPREGB0821
        SELECT  Des_DepRetDia, Cue_DepRetDia,    MAX(Est.Nombre),
              MAX(Mun.Nombre), Mun.Localidad,
              ROUND(SUM(SalCapVigente + SalCapExigible),2),
              COUNT(SalCapVigente)
            FROM SALDOSINVKUBO Inv,
               DIRECCLIENTE Dir,
               ESTADOSREPUB Est,
               MUNICIPIOSREPUB Mun
            WHERE FechaCorte    = Var_FechaSalInv
              AND Inv.ClienteID   = Dir.ClienteID
              AND Dir.Oficial     = OficialSI
              AND Dir.EstadoID    = Est.EstadoID
              AND Dir.MunicipioID   = Mun.MunicipioID
              AND Mun.EstadoID    = Dir.EstadoID
              AND (SalCapVigente + SalCapExigible) > 1

            GROUP BY Localidad;
      END IF;




IF EXISTS (SELECT CuentaContable FROM `HIS-CATALOGOMINIMO` WHERE Anio = YEAR(Par_Fecha) AND Mes = MONTH(Par_Fecha)) THEN
	UPDATE TMPREGB0821 SET Monto = ROUND(Monto,Entero_Cero);
    SELECT Monto INTO Var_CatDepVista FROM `HIS-CATALOGOMINIMO` WHERE Anio = YEAR(Par_Fecha)
		AND Mes = MONTH(Par_Fecha) AND CuentaContable IN('210100000000');

    SELECT Monto INTO Var_CatDepPlazo FROM `HIS-CATALOGOMINIMO` WHERE Anio = YEAR(Par_Fecha)
		AND Mes = MONTH(Par_Fecha) AND CuentaContable IN('211100000000');


	SELECT  SUM(Monto)INTO Var_MontoTotal
        FROM TMPREGB0821 WHERE TipoInstrumento = Des_DepVista;
	SET Var_MontoTotal := IFNULL(Var_MontoTotal,Entero_Cero);

    SET Var_Diferencia =  Var_CatDepVista - Var_MontoTotal;
    IF Var_Diferencia <> 0 AND Var_Diferencia <1000 THEN
		SET Var_NunCuentas := ABS(Var_Diferencia);
		UPDATE TMPREGB0821 SET Monto  = CASE WHEN Var_Diferencia < 0 THEN Monto - 1 ELSE Monto + 1 END
		WHERE TipoInstrumento = Des_DepVista
        LIMIT VAR_NUNCUENTAS;
	END IF;

    SELECT  SUM(Monto) INTO Var_MontoTotal
        FROM TMPREGB0821 WHERE TipoInstrumento = Des_Inversion;
	SET Var_MontoTotal := IFNULL(Var_MontoTotal,Entero_Cero);

    SET Var_Diferencia =  Var_CatDepPlazo - Var_MontoTotal;
    IF Var_Diferencia <> 0 AND Var_Diferencia <1000 THEN
		SET Var_NunCuentas := ABS(Var_Diferencia);
		UPDATE TMPREGB0821 SET Monto  = CASE WHEN Var_Diferencia < 0 THEN Monto - 1 ELSE Monto + 1 END
		WHERE TipoInstrumento = Des_Inversion
        LIMIT VAR_NUNCUENTAS;
	END IF;
END IF;


    IF(Par_NumReporte = CaptacionLoc14) THEN
      SELECT  TipoInstrumento,    ClasifConta,    Estado, Municipio,  Localidad,
          ROUND(Monto,Entero_Cero) AS Monto,          NumContratos
      FROM TMPREGB0821
      ORDER BY Localidad, TipoInstrumento;


    END IF;
    IF(Par_NumReporte = CaptacionLoc14Csv) THEN
      SET @Contador = 0;
      SELECT  CONCAT(ClaveNivEnt, ";",
          Var_Reporte, ";", @Contador := @Contador + 1, ";",
          ClasifConta, ";", Localidad, ";",
                    NumContratos, ";",  ROUND(Monto,Entero_Cero))
                AS Valor
      FROM TMPREGB0821
      ORDER BY Localidad, TipoInstrumento;
    END IF;
    DROP TABLE IF EXISTS TMPREGB0821;
  END IF;


  IF(Par_NumReporte = CaptacionLoc13 OR Par_NumReporte = Rep_Csv) THEN

      DROP TABLE IF EXISTS TMPREGB0821;

      CREATE TEMPORARY TABLE TMPREGB0821(
        TipoInstrumento VARCHAR(100),
        ClasifConta     VARCHAR(12),
        Periodo       VARCHAR(100),
        ClaveFede       VARCHAR(100),
        ClaveEntidad    VARCHAR(100),
        ClaveNivelEnti  VARCHAR(100),
        Localidad       VARCHAR(10),
        Monto           DECIMAL(14,2),
        NumContratos    INT);

      SELECT FechaSistema, DiasInversion INTO
          Var_FechaSistema, Var_DiasAnio
        FROM  PARAMETROSSIS;


      SET Var_FechaIniMesSis := DATE_ADD(Var_FechaSistema, INTERVAL -1*(DAY(Var_FechaSistema))+1 DAY);


      IF (Par_Fecha >= Var_FechaIniMesSis) THEN
        INSERT INTO TMPREGB0821
        SELECT  Des_DepVista,   Cue_DepVista,  Cadena_Vacia,    Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,
            MAX(Mun.Localidad),
            IFNULL(SUM(Saldo), Entero_Cero),
            IFNULL(COUNT(Saldo), Entero_Cero)
          FROM CUENTASAHO Cue,
             DIRECCLIENTE Dir,
             ESTADOSREPUB Est,
             MUNICIPIOSREPUB Mun
          WHERE Cue.ClienteID = Dir.ClienteID
            AND Dir.Oficial = OficialSI
            AND Dir.EstadoID = Est.EstadoID
            AND Dir.MunicipioID   = Mun.MunicipioID
            AND Mun.EstadoID = Dir.EstadoID
            AND ( Cue.Estatus = Cue_Activa
            OR   Cue.Estatus = Cue_Bloqueada )
             AND Cue.ClienteID <> Cliente_Inst
        GROUP BY Localidad;
      ELSE

        SET Var_FechaHis := (SELECT MAX(Fecha)
                    FROM `HIS-CUENTASAHO`
                    WHERE Fecha <= Par_Fecha);

        SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

        INSERT INTO TMPREGB0821
        SELECT  Des_DepVista,   Cue_DepVista,  Cadena_Vacia,    Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,
            MAX(Mun.Localidad),
            IFNULL(SUM(Saldo), Entero_Cero),
            IFNULL(COUNT(Saldo), Entero_Cero)
          FROM `HIS-CUENTASAHO` Cue,
             DIRECCLIENTE Dir,
             ESTADOSREPUB Est,
             MUNICIPIOSREPUB Mun
          WHERE Cue.ClienteID = Dir.ClienteID
            AND Dir.Oficial = OficialSI
            AND Dir.EstadoID = Est.EstadoID
            AND Dir.MunicipioID   = Mun.MunicipioID
            AND Mun.EstadoID = Dir.EstadoID
            AND ( Cue.Estatus = Cue_Activa
            OR   Cue.Estatus = Cue_Bloqueada )
            AND Fecha = Var_FechaHis
            AND Cue.ClienteID <> Cliente_Inst
        GROUP BY Localidad;

      END IF;


      INSERT INTO TMPREGB0821
        SELECT Des_Inversion, Cue_Inversion,    Cadena_Vacia,    Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,
          Mun.Localidad,
          IFNULL(SUM(Inv.Monto), Entero_Cero),
          IFNULL(COUNT(Inv.Monto), Entero_Cero)
          FROM INVERSIONES Inv,
             DIRECCLIENTE Dir,
             ESTADOSREPUB Est,
             MUNICIPIOSREPUB Mun
          WHERE Inv.ClienteID = Dir.ClienteID
            AND Dir.Oficial = OficialSI
            AND Dir.EstadoID = Est.EstadoID
            AND Dir.MunicipioID   = Mun.MunicipioID
            AND Mun.EstadoID = Dir.EstadoID
            AND ( Inv.Estatus = Inv_Vigente
            OR Inv.Estatus = Inv_Pagado    )
           AND Inv.FechaInicio <= Par_Fecha
           AND FechaVencimiento >= Par_Fecha
           AND Inv.ClienteID <> Cliente_Inst
        GROUP BY Localidad;


      IF (Par_Fecha < Var_FechaSistema) THEN

        SET Var_FechaSalInv := (SELECT MAX(FechaCorte)
                      FROM SALDOSINVKUBO
                      WHERE FechaCorte <= Par_Fecha);

        SET Var_FechaSalInv := IFNULL(Var_FechaSalInv, Fecha_Vacia);

        SET Var_FechaSalInv := (SELECT MAX(FechaCorte)
                      FROM SALDOSINVKUBO
                      WHERE FechaCorte <= Par_Fecha);

        SET Var_FechaSalInv := IFNULL(Var_FechaSalInv, Fecha_Vacia);

        INSERT INTO TMPREGB0821
        SELECT  Des_DepRetDia, Cue_DepRetDia, Cadena_Vacia,    Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,
              Mun.Localidad,
              SUM(SalCapVigente + SalCapExigible),
              COUNT(SalCapVigente)
            FROM SALDOSINVKUBO Inv,
               DIRECCLIENTE Dir,
               ESTADOSREPUB Est,
               MUNICIPIOSREPUB Mun
            WHERE FechaCorte = Var_FechaSalInv
              AND Inv.ClienteID = Dir.ClienteID
              AND Dir.Oficial = OficialSI
              AND Dir.EstadoID = Est.EstadoID
              AND Dir.MunicipioID   = Mun.MunicipioID
              AND Mun.EstadoID = Dir.EstadoID
              AND (SalCapVigente + SalCapExigible) > 0

            GROUP BY Localidad;
      END IF;
IF(Par_NumReporte  = CaptacionLoc13) THEN
      SELECT  TipoInstrumento,    ClasifConta,    Var_Periodo AS Periodo,
          ClaveFederacion AS ClaveFede,      ClaveEntidad,    ClaveNivEnt AS ClaveNivelEnti,
          Localidad,      ROUND(Monto, Entero_Cero) AS Monto,
          NumContratos
        FROM TMPREGB0821
        ORDER BY Localidad, TipoInstrumento;
END IF;

      IF(Par_NumReporte = Rep_Csv) THEN
        SET @contador := 0;

        SELECT CONCAT(
          ClaveEntidad,     ";",  "303",      ";",  "821",            ";",
          @contador := @contador +1,  ";",  ClasifConta,  ";",  SUBSTRING(Localidad,2,8), ";",
          ROUND(Monto, Entero_Cero),  ";",  NumContratos
          ) AS Valor
          FROM TMPREGB0821
          ORDER BY Localidad, TipoInstrumento;
      END IF;


DROP TABLE IF EXISTS TMPREGB0821;


END IF;


END TerminaStore$$