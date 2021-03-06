-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO017REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO017REP`;
DELIMITER $$

CREATE PROCEDURE `EDORESINTERNO017REP`(

  Par_Ejercicio       INT,
  Par_Periodo         INT,
  Par_Fecha           DATE,
  Par_TipoConsulta    CHAR(1),
  Par_SaldosCero      CHAR(1),
  Par_Cifras          CHAR(1),

  Par_CCInicial       INT,
  Par_CCFinal         INT,

  Par_EmpresaID       INT,
  Aud_Usuario         INT,
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal        INT,
  Aud_NumTransaccion  BIGINT
  )
TerminaStore: BEGIN


  DECLARE Var_FecConsulta   DATE;
  DECLARE Var_FechaSistema  DATE;
  DECLARE Var_FechaSaldos   DATE;
  DECLARE Var_EjeCon        INT;
  DECLARE Var_PerCon        INT;
  DECLARE Var_FecIniPer     DATE;
  DECLARE Var_FecFinPer     DATE;
  DECLARE Var_EjercicioVig  INT;
  DECLARE Var_PeriodoVig    INT;
  DECLARE For_ResulNeto     VARCHAR(500);
  DECLARE Var_Ubicacion     CHAR(1);

  DECLARE Var_Columna         VARCHAR(20);
  DECLARE Var_Monto           DECIMAL(18,4);
  DECLARE Var_NombreTabla     VARCHAR(40);
  DECLARE Var_CreateTable     VARCHAR(9000);
  DECLARE Var_InsertTable     VARCHAR(5000);
  DECLARE Var_InsertValores   VARCHAR(5000);
  DECLARE Var_SelectTable     VARCHAR(5000);
  DECLARE Var_DropTable       VARCHAR(5000);
  DECLARE Var_CantCaracteres  INT;

  DECLARE Var_MinCenCos   INT;
  DECLARE Var_MaxCenCos   INT;
  DECLARE Var_FechaFinMes DATE; -- Variable para obtener el ultimo dia del mes


  DECLARE Entero_Cero     INT;
  DECLARE Cadena_Vacia    CHAR(1);
  DECLARE Fecha_Vacia     DATE;
  DECLARE VarDeudora      CHAR(1);
  DECLARE VarAcreedora    CHAR(1);
  DECLARE Tip_Encabezado  CHAR(1);
  DECLARE No_SaldoCeros   CHAR(1);
  DECLARE Cifras_Pesos    CHAR(1);
  DECLARE Cifras_Miles    CHAR(1);
  DECLARE Por_Peridodo    CHAR(1);
  DECLARE Por_Fecha       CHAR(1);
  DECLARE Datos_Director  CHAR(1);
  DECLARE Ubi_Actual      CHAR(1);
  DECLARE Ubi_Histor      CHAR(1);
  DECLARE Tif_EdoResul    INT;
  DECLARE NumCliente      INT;
  DECLARE Por_FinPeriodo  CHAR(1);
  DECLARE Por_CorteMes    CHAR(1); -- Estado de Resultados por mes
  DECLARE Var_IniMes      DATE; -- husein
  DECLARE Var_PolizaCierrePeriodo BIGINT;

  DECLARE cur_Balance CURSOR FOR
    SELECT CuentaContable,  SaldoDeudor
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      ORDER BY CuentaContable;



  SET Entero_Cero     := 0;
  SET Cadena_Vacia    := '';
  SET Fecha_Vacia     := '1900-01-01';
  SET VarDeudora      := 'D';
  SET VarAcreedora    := 'A';
  SET Tip_Encabezado  := 'E';
  SET No_SaldoCeros   := 'N';
  SET Cifras_Pesos    := 'P';
  SET Cifras_Miles    := 'M';
  SET Por_Peridodo    := 'P';
  SET Por_Fecha       := 'D';
  SET Datos_Director  := 'Z';
  SET Ubi_Actual      := 'A';
  SET Ubi_Histor      := 'H';
  SET Tif_EdoResul    := 2;
  SET NumCliente    := 17;
  SET Por_FinPeriodo  := 'F';
  SET Por_CorteMes    := 'X';

  SELECT FechaSistema,    EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,  Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);
  SET Var_IniMes          :=  DATE_FORMAT(Par_Fecha,'%Y-%m-01'); -- husein

  CALL TRANSACCIONESPRO(Aud_NumTransaccion);

  IF(Par_Fecha  != Fecha_Vacia) THEN
    SET Var_FecConsulta := Par_Fecha;
  ELSE
    SELECT  Fin INTO Var_FecConsulta
      FROM PERIODOCONTABLE
      WHERE EjercicioID   = Par_Ejercicio
        AND PeriodoID     = Par_Periodo;
  END IF;

  SET Par_CCInicial := IFNULL(Par_CCInicial, Entero_Cero);
  SET Par_CCFinal   := IFNULL(Par_CCFinal, Entero_Cero);


  SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
    FROM CENTROCOSTOS;

  IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
    SET Par_CCInicial := Var_MinCenCos;
    SET Par_CCFinal   := Var_MaxCenCos;
  END IF;

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo) THEN
    SET Par_TipoConsulta := Por_FinPeriodo;
  END IF;

  IF (Par_TipoConsulta = Datos_Director) THEN
    SELECT NombreRepresentante, JefeContabilidad FROM PARAMETROSSIS LIMIT 1;

  ELSE IF (Par_TipoConsulta = Por_Fecha) THEN

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte <= Par_Fecha;

    SET Var_FechaSaldos := IFNULL(Var_FechaSaldos, Fecha_Vacia);

    IF (Var_FechaSaldos = Fecha_Vacia) THEN
      INSERT INTO TMPCONTABLE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            Cue.Naturaleza,
            CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                SUM(ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                SUM(ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                SUM(ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                SUM(ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            Entero_Cero, Entero_Cero

            FROM CUENTASCONTABLES Cue,
               DETALLEPOLIZA AS Pol
            WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
              AND Pol.Fecha     <= Par_Fecha
              AND Pol.CentroCostoID >= Par_CCInicial
              AND Pol.CentroCostoID <= Par_CCFinal
            GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;
-- inicio hussein
  INSERT INTO TMPCONTABLEPERIODO
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            Cue.Naturaleza,
            CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                SUM(ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                SUM(ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                SUM(ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                SUM(ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            Entero_Cero, Entero_Cero
            FROM CUENTASCONTABLES Cue,
               DETALLEPOLIZA AS Pol
            WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
            AND Pol.Fecha     BETWEEN Var_IniMes AND Par_Fecha    -- husssein
              AND Pol.CentroCostoID >= Par_CCInicial
              AND Pol.CentroCostoID <= Par_CCFinal
            GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;
-- fin

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
      SELECT Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN Fin.Naturaleza = VarDeudora
              THEN
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
              ELSE
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
             END,
             Entero_Cero,
             Fin.Desplegado,  Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

        LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                           AND Pol.NumeroTransaccion  = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND Fin.NombreCampo NOT LIKE 'Per_%' -- husein
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado, Fin.Naturaleza;

      INSERT INTO TMPBALANZACONTA (
        NumeroTransaccion,        CuentaContable,       Grupo,          SaldoInicialDeu,      SaldoInicialAcre,
        Cargos,             Abonos,           SaldoDeudor,      SaldoAcreedor,        DescripcionCuenta,
        CuentaMayor,          CentroCosto)
      SELECT Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN Fin.Naturaleza = VarDeudora
              THEN
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
              ELSE
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
             END,
             Entero_Cero,
             Fin.Desplegado,  Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

        LEFT OUTER JOIN TMPCONTABLEPERIODO AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                           AND Pol.NumeroTransaccion  = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND Fin.NombreCampo LIKE 'Per_%'
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado, Fin.Naturaleza;

    ELSE

      SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
          Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
        FROM PERIODOCONTABLE
        WHERE Inicio  <= Par_Fecha
          AND Fin >= Par_Fecha;

      SET Var_EjeCon := IFNULL(Var_EjeCon, Entero_Cero);
      SET Var_PerCon := IFNULL(Var_PerCon, Entero_Cero);
      SET Var_FecIniPer := IFNULL(Var_FecIniPer, Fecha_Vacia);
      SET Var_FecFinPer := IFNULL(Var_FecFinPer, Fecha_Vacia);

      IF (Var_EjeCon = Entero_Cero) THEN
        SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
            Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
          FROM PERIODOCONTABLE
          WHERE Fin <= Par_Fecha;
      END IF;

      IF (Var_EjeCon >= Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

        INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              Cue.Naturaleza,
              CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
                END,
              CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
              END,
              Entero_Cero,    Entero_Cero
              FROM CUENTASCONTABLES Cue
              LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                                AND Pol.Fecha <= Par_Fecha
                                AND Pol.CentroCostoID >= Par_CCInicial
                                AND Pol.CentroCostoID <= Par_CCFinal )
              GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

          INSERT INTO TMPCONTABLEPERIODO
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              Cue.Naturaleza,
              CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
                END,
              CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
              END,
              Entero_Cero,    Entero_Cero
              FROM CUENTASCONTABLES Cue
              LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                                AND Pol.Fecha     BETWEEN Var_IniMes AND Par_Fecha
                                AND Pol.CentroCostoID >= Par_CCInicial
                                AND Pol.CentroCostoID <= Par_CCFinal )
              GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

        SET Var_Ubicacion   := Ubi_Actual;


      ELSE
      INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          Cue.Naturaleza,
          CASE WHEN Cue.Naturaleza = VarDeudora  THEN
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)
             ELSE
              Entero_Cero
            END,
          CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)
             ELSE
              Entero_Cero
          END,
          Entero_Cero,    Entero_Cero
          FROM  CUENTASCONTABLES Cue
        LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                            AND Pol.Fecha >=  Var_FecIniPer
                            AND Pol.Fecha <=  Par_Fecha
                            AND Pol.CentroCostoID >= Par_CCInicial
                            AND Pol.CentroCostoID <= Par_CCFinal )
        GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

        INSERT INTO TMPCONTABLEPERIODO
        SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          Cue.Naturaleza,
          CASE WHEN Cue.Naturaleza = VarDeudora  THEN
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)
             ELSE
              Entero_Cero
            END,
          CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)
             ELSE
              Entero_Cero
          END,
          Entero_Cero,    Entero_Cero
          FROM  CUENTASCONTABLES Cue
        LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                            AND Pol.Fecha >=  Var_FecIniPer
                            AND Pol.Fecha     BETWEEN Var_IniMes AND Par_Fecha
                            AND Pol.CentroCostoID >= Par_CCInicial
                            AND Pol.CentroCostoID <= Par_CCFinal )
        GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

        SET Var_Ubicacion   := Ubi_Histor;

      END IF;

        IF(Var_FechaSaldos != Par_Fecha) THEN

          DROP TEMPORARY TABLE IF EXISTS TMPSALDOSCONTABLES;
              CREATE TEMPORARY TABLE IF NOT EXISTS TMPSALDOSCONTABLES(
                                    CuentaCompleta  VARCHAR(25),
                                    FechaCorte    DATE,
                                    SaldoFinal    DECIMAL(16,4));
              INSERT INTO TMPSALDOSCONTABLES (CuentaCompleta,   FechaCorte,   SaldoFinal)
              SELECT              CuentaCompleta,   FechaCorte,   SUM(SaldoFinal)
                    FROM SALDOSCONTABLES
                      WHERE FechaCorte  = Var_FechaSaldos
                       AND CentroCosto >= Par_CCInicial
                       AND CentroCosto <= Par_CCFinal
                        GROUP BY CuentaCompleta,    FechaCorte;


                UPDATE TMPCONTABLE Tmp, TMPSALDOSCONTABLES Sal
                SET
                  Tmp.SaldoInicialDeu =  CASE WHEN Naturaleza = VarDeudora  THEN
                                Sal.SaldoFinal
                              ELSE
                                Entero_Cero
                            END,
                  Tmp.SaldoInicialAcr = CASE WHEN Naturaleza = VarAcreedora  THEN
                                 Sal.SaldoFinal
                              ELSE
                                Entero_Cero
                            END
                WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
                  AND Sal.CuentaCompleta = Tmp.CuentaContable
                  AND Sal.FechaCorte  = Var_FechaSaldos;

        -- IALDANA T_13911 SE ELIMINA LA SECCI??N PORQUE OCASIONABA EL DESCUADRE CONTRA LA BALANZA

            END IF;

            INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)

              SELECT Aud_NumTransaccion, Fin.NombreCampo,  Cadena_Vacia, Entero_Cero,  Entero_Cero,
                Entero_Cero, Entero_Cero,
                  (CASE WHEN Fin.Naturaleza = VarDeudora
                     THEN
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
                     ELSE
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
                  END ),
                Entero_Cero,
                Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
                FROM CONCEPESTADOSFIN Fin
               LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

                LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                  AND Pol.Fecha = Var_FechaSistema
                                  AND Pol.NumeroTransaccion = Aud_NumTransaccion)
              WHERE Fin.EstadoFinanID = Tif_EdoResul
                AND Fin.EsCalculado = 'N'
                AND NumClien = NumCliente
    AND Fin.NombreCampo NOT LIKE 'Per_%'
                GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;


INSERT INTO TMPBALANZACONTA (
          NumeroTransaccion,        CuentaContable,       Grupo,          SaldoInicialDeu,      SaldoInicialAcre,
          Cargos,             Abonos,           SaldoDeudor,      SaldoAcreedor,        DescripcionCuenta,
          CuentaMayor,          CentroCosto)

              SELECT Aud_NumTransaccion, Fin.NombreCampo,  Cadena_Vacia, Entero_Cero,  Entero_Cero,
                Entero_Cero, Entero_Cero,
                  (CASE WHEN Fin.Naturaleza = VarDeudora
                     THEN
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
                     ELSE
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
                  END ),
                Entero_Cero,
                Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
                FROM CONCEPESTADOSFIN Fin
               LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

               LEFT OUTER JOIN TMPCONTABLEPERIODO AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                  AND Pol.Fecha = Var_FechaSistema
                                  AND Pol.NumeroTransaccion = Aud_NumTransaccion)
              WHERE Fin.EstadoFinanID = Tif_EdoResul
                AND Fin.EsCalculado = 'N'
                AND NumClien = NumCliente
                AND Fin.NombreCampo LIKE 'Per_%'
                GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;
      END IF;


  ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

    INSERT INTO TMPCONTABLE
      SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          Cue.Naturaleza,
          CASE WHEN Cue.Naturaleza = VarDeudora  THEN
            ROUND(SUM( IFNULL(Sal.SaldoFinal, Entero_Cero)),2)
             ELSE
            Entero_Cero
          END,
          CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
             ROUND(SUM( IFNULL(Sal.SaldoFinal, Entero_Cero)),2)
            ELSE
            Entero_Cero
          END,
          Entero_Cero,Entero_Cero

          FROM CUENTASCONTABLES Cue,
             SALDOSCONTABLES AS Sal
          WHERE Sal.EjercicioID   = Par_Ejercicio
            AND Sal.PeriodoID   = Par_Periodo
            AND Cue.CuentaCompleta = Sal.CuentaCompleta
            AND Sal.CentroCosto >= Par_CCInicial
            AND Sal.CentroCosto <= Par_CCFinal
          GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

    INSERT INTO TMPBALANZACONTA (
        NumeroTransaccion,        CuentaContable,       Grupo,          SaldoInicialDeu,      SaldoInicialAcre,
        Cargos,             Abonos,           SaldoDeudor,      SaldoAcreedor,        DescripcionCuenta,
        CuentaMayor,          CentroCosto)
      SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero,
          Entero_Cero,        Entero_Cero,     Entero_Cero,
          CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
             ELSE
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
           END,
           Entero_Cero,
           Fin.Descripcion, Cadena_Vacia,Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          AND Fin.NombreCampo not LIKE 'Per_%'
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;

    INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
      SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero,
          Entero_Cero,        Entero_Cero,     Entero_Cero,
          CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
             ELSE
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
           END,
           Entero_Cero,
           Fin.Descripcion, Cadena_Vacia,Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          AND Fin.NombreCampo LIKE 'Per_%'
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;

  ELSEIF(Par_TipoConsulta = Por_FinPeriodo) THEN
      SET Par_Periodo := (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);

      SELECT Inicio, Fin, PolizaFinal
      INTO Var_FecIniPer,Par_Fecha, Var_PolizaCierrePeriodo
      FROM PERIODOCONTABLE
      WHERE EjercicioID   = Par_Ejercicio
      AND PeriodoID       = Par_Periodo;

      SET Var_IniMes := Var_FecIniPer;


      INSERT INTO TMPCONTABLEPERIODO
        SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          Cue.Naturaleza,
          CASE WHEN Cue.Naturaleza = VarDeudora  THEN
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)
             ELSE
              Entero_Cero
            END,
          CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
              ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)-
              ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)
             ELSE
              Entero_Cero
          END,
          Entero_Cero,    Entero_Cero
          FROM  CUENTASCONTABLES Cue
        LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
              AND Pol.PolizaID <> Var_PolizaCierrePeriodo
                            AND Pol.Fecha   >=  Var_FecIniPer
                            AND Pol.Fecha     BETWEEN Var_IniMes AND Par_Fecha
                            AND Pol.CentroCostoID >= Par_CCInicial
                            AND Pol.CentroCostoID <= Par_CCFinal )
        GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;


      INSERT INTO TMPCONTABLEBALANCE
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              (Cue.Naturaleza),
              CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                SUM(ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero), 2))
                 ELSE
                Entero_Cero
              END,
              CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                SUM(ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero), 2))
                ELSE
                Entero_Cero
              END,
              Entero_Cero,Entero_Cero

              FROM CUENTASCONTABLES Cue,
                 SALDOCONTACIERREJER AS Sal
              WHERE Sal.EjercicioID   = Par_Ejercicio
                AND Sal.PeriodoID   = Par_Periodo
                AND Cue.CuentaCompleta = Sal.CuentaCompleta
                AND Sal.CentroCosto >= Par_CCInicial
                AND Sal.CentroCosto <= Par_CCFinal
              GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;


          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
          SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero,
              Entero_Cero,        Entero_Cero,     Entero_Cero,
              CASE WHEN Fin.Naturaleza = VarDeudora
                 THEN
                  SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
                  SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
                 ELSE
                  SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                  SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
               END,
               Entero_Cero,
               Fin.Descripcion, Cadena_Vacia, Entero_Cero
            FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
              LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                              AND Pol.Fecha = Var_FechaSistema
                              AND Pol.NumeroTransaccion = Aud_NumTransaccion)

            WHERE Fin.EstadoFinanID = Tif_EdoResul
              AND Fin.EsCalculado = 'N'
            AND NumClien = NumCliente
            AND Fin.NombreCampo not LIKE 'Per_%'
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;


            INSERT INTO TMPBALANZACONTA (
          NumeroTransaccion,        CuentaContable,       Grupo,          SaldoInicialDeu,      SaldoInicialAcre,
          Cargos,             Abonos,           SaldoDeudor,      SaldoAcreedor,        DescripcionCuenta,
          CuentaMayor,          CentroCosto)

              SELECT Aud_NumTransaccion, Fin.NombreCampo,  Cadena_Vacia, Entero_Cero,  Entero_Cero,
                Entero_Cero, Entero_Cero,
                  (CASE WHEN Fin.Naturaleza = VarDeudora
                     THEN
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
                     ELSE
                    IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
                    IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
                    SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                    SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
                  END ),
                Entero_Cero,
                Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
                FROM CONCEPESTADOSFIN Fin
               LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

               LEFT OUTER JOIN TMPCONTABLEPERIODO AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                  AND Pol.Fecha = Var_FechaSistema
                                  AND Pol.NumeroTransaccion = Aud_NumTransaccion)
              WHERE Fin.EstadoFinanID = Tif_EdoResul
                AND Fin.EsCalculado = 'N'
                AND NumClien = NumCliente
                AND Fin.NombreCampo LIKE 'Per_%'
                GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;

  END IF;

  /* CONSULTA POR MES*/
  IF (Par_TipoConsulta = Por_CorteMes) THEN

      SET Var_FechaFinMes   := LAST_DAY(Par_Fecha);

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte < Par_Fecha;

    SET Var_FechaSaldos := IFNULL(Var_FechaSaldos, Fecha_Vacia);

    SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
      Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
    FROM PERIODOCONTABLE
    WHERE Inicio    <= Par_Fecha
      AND Fin   >= Par_Fecha;

    IF (Var_FechaSaldos = Fecha_Vacia) THEN

      INSERT INTO TMPCONTABLE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            Cue.Naturaleza,
            CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            Entero_Cero, Entero_Cero

            FROM CUENTASCONTABLES Cue,
               DETALLEPOLIZA AS Pol
            WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
              AND Pol.Fecha         >= Var_FecIniPer
              AND Pol.Fecha         <= Var_FechaFinMes
              AND Pol.CentroCostoID >= Par_CCInicial
              AND Pol.CentroCostoID <= Par_CCFinal
            GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN Fin.Naturaleza = VarDeudora
              THEN
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
              ELSE
                 SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
                 SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
             END,
             Entero_Cero,
             Fin.Desplegado,  Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

        LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                           AND Pol.NumeroTransaccion    = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado, Fin.Naturaleza;

    ELSE

      SET Var_EjeCon := IFNULL(Var_EjeCon, Entero_Cero);
      SET Var_PerCon := IFNULL(Var_PerCon, Entero_Cero);
      SET Var_FecIniPer := IFNULL(Var_FecIniPer, Fecha_Vacia);
      SET Var_FecFinPer := IFNULL(Var_FecFinPer, Fecha_Vacia);

      IF (Var_EjeCon = Entero_Cero) THEN
        SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
            Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
          FROM PERIODOCONTABLE
          WHERE Fin   <= Par_Fecha;
      END IF;

      IF (Var_EjeCon >= Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN
        INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              Cue.Naturaleza,
              CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
                END,
              CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
              END,
              Entero_Cero,    Entero_Cero
              FROM CUENTASCONTABLES Cue
              LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                                AND Pol.Fecha         >= Var_FecIniPer
                                AND Pol.Fecha         <= Var_FechaFinMes
                                AND Pol.CentroCostoID >= Par_CCInicial
                                AND Pol.CentroCostoID <= Par_CCFinal )
              GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

        SET Var_Ubicacion   := Ubi_Actual;
      ELSE
        INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero,    Entero_Cero,    Cue.Naturaleza,
            CASE WHEN Cue.Naturaleza = VarDeudora  THEN
                ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)-
                ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)
               ELSE
                Entero_Cero
              END,
            CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)-
                ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)
               ELSE
                Entero_Cero
            END,  Entero_Cero,    Entero_Cero
            FROM  CUENTASCONTABLES Cue
          LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                              AND Pol.Fecha >=    Var_FecIniPer
                              AND Pol.Fecha <=    Var_FechaFinMes
                              AND Pol.CentroCostoID >= Par_CCInicial
                              AND Pol.CentroCostoID <= Par_CCFinal )
          GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;
        SET Var_Ubicacion   := Ubi_Histor;
      END IF;



      INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)

      SELECT Aud_NumTransaccion, Fin.NombreCampo,  Cadena_Vacia, Entero_Cero,  Entero_Cero,
        Entero_Cero, Entero_Cero,
          (CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
            IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
            IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
            SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
            SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
             ELSE
            IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
            IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
            SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
            SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
          END ),
        Entero_Cero,
        Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
       LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

        LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)
      WHERE Fin.EstadoFinanID = Tif_EdoResul
        AND Fin.EsCalculado = 'N'
        AND NumClien = NumCliente
        AND Fin.NombreCampo NOT LIKE 'Per_%'
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;

    INSERT INTO TMPBALANZACONTA

      SELECT Aud_NumTransaccion, Fin.NombreCampo,  Cadena_Vacia, Entero_Cero,  Entero_Cero,
        Entero_Cero, Entero_Cero,
          (CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
            SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
            SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
             ELSE
            SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
            SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
          END ),
        Entero_Cero,
        Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
       LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

        LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)
      WHERE Fin.EstadoFinanID = Tif_EdoResul
        AND Fin.EsCalculado = 'N'
        AND NumClien = NumCliente
        AND Fin.NombreCampo LIKE 'Per_%'
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;

      END IF;

  END IF;

  IF(Par_Cifras = Cifras_Miles) THEN

    UPDATE TMPBALANZACONTA SET
      SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
      WHERE NumeroTransaccion = Aud_NumTransaccion;

  END IF;


  SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

  SET Var_CreateTable     := CONCAT( "CREATE TEMPORARY TABLE ", Var_NombreTabla,
                 " (");

  SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

  SET Var_InsertValores   := ' VALUES( ';

  SET Var_SelectTable     := CONCAT(" SELECT * FROM ", Var_NombreTabla, "; ");

  SET Var_DropTable       := CONCAT(" DROP TABLE IF EXISTS ", Var_NombreTabla, "; ");


  IF IFNULL(Aud_NumTransaccion, Entero_Cero) > Entero_Cero THEN
      OPEN  cur_Balance;
          BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP
              FETCH cur_Balance  INTO     Var_Columna, Var_Monto;

              SET Var_CreateTable := CONCAT(Var_CreateTable,Var_Columna, " DECIMAL(18,2)", " ,");

              SET Var_InsertTable := CONCAT(Var_InsertTable,Var_Columna," ," );

              SET Var_InsertValores  := CONCAT(Var_InsertValores, CAST(IFNULL(Var_Monto, 0.0) AS CHAR)," ,");

          END LOOP;
        END;
      CLOSE cur_Balance;

      SET Var_CreateTable   := substring(Var_CreateTable,1,LENGTH(Var_CreateTable)-1);

      SET Var_InsertTable   := substring(Var_InsertTable,1,LENGTH(Var_InsertTable)-1);

      SET Var_InsertValores   := substring(Var_InsertValores,2,LENGTH(Var_InsertValores)-2);

      SET Var_CreateTable     := CONCAT(Var_CreateTable,"); ");
      SET Var_InsertTable     := CONCAT(Var_InsertTable, ") ", Var_InsertValores, ");  ");

      SET @Sentencia  := (Var_CreateTable);
      PREPARE Tabla FROM @Sentencia;
      EXECUTE  Tabla;
      DEALLOCATE PREPARE Tabla;

      SET @Sentencia  := (Var_InsertTable);

      PREPARE InsertarValores FROM @Sentencia;
      EXECUTE  InsertarValores;
      DEALLOCATE PREPARE InsertarValores;

      SET @Sentencia  := (Var_SelectTable);
      PREPARE SelectTable FROM @Sentencia;
      EXECUTE  SelectTable;
      DEALLOCATE PREPARE SelectTable;

      SET @Sentencia  := CONCAT( Var_DropTable);
      PREPARE DropTable FROM @Sentencia;
      EXECUTE  DropTable;
      DEALLOCATE PREPARE DropTable;
  END IF;

  DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;

  DELETE FROM TMPCONTABLEPERIODO
    WHERE NumeroTransaccion = Aud_NumTransaccion;

  DELETE FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion;

    END IF;
END TerminaStore$$
