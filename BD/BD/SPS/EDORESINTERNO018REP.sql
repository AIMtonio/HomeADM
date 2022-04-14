-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO018REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO018REP`;
DELIMITER $$


CREATE PROCEDURE `EDORESINTERNO018REP`(
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
  DECLARE Var_FechaSistema    DATE;
  DECLARE Var_FechaSaldos   DATE;
  DECLARE Var_EjeCon        INT;
  DECLARE Var_PerCon        INT;
  DECLARE Var_FecIniPer     DATE;
  DECLARE Var_FecFinPer     DATE;
  DECLARE Var_EjercicioVig    INT;
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

  DECLARE Var_MinCenCos     INT;
  DECLARE Var_MaxCenCos     INT;


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
  DECLARE Ubi_Actual      CHAR(1);
  DECLARE Ubi_Histor      CHAR(1);
  DECLARE Tif_EdoResul    INT;
  DECLARE NumCliente    INT;
  DECLARE Por_FinPeriodo  CHAR(1);

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
  SET Ubi_Actual      := 'A';
  SET Ubi_Histor      := 'H';
  SET Tif_EdoResul    := 2;
  SET NumCliente    := 18;
  SET Por_FinPeriodo  := 'F';

  SELECT FechaSistema,        EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,    Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           = IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    = IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      = IFNULL(Var_PeriodoVig, Entero_Cero);

  CALL TRANSACCIONESPRO(Aud_NumTransaccion);

  IF(Par_Fecha    != Fecha_Vacia) THEN
    SET Var_FecConsulta = Par_Fecha;
  ELSE
    SELECT  Fin INTO Var_FecConsulta
      FROM PERIODOCONTABLE
      WHERE EjercicioID   = Par_Ejercicio
        AND PeriodoID     = Par_Periodo;
  END IF;

  SET Par_CCInicial   := IFNULL(Par_CCInicial, Entero_Cero);
  SET Par_CCFinal     := IFNULL(Par_CCFinal, Entero_Cero);


  SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
    FROM CENTROCOSTOS;

  IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
    SET Par_CCInicial   := Var_MinCenCos;
    SET Par_CCFinal     := Var_MaxCenCos;
  END IF;

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo) THEN
    SET Par_TipoConsulta := Por_FinPeriodo;
  END IF;

  IF (Par_TipoConsulta = Por_Fecha) THEN

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte < Par_Fecha;

    SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);

    IF (Var_FechaSaldos = Fecha_Vacia) THEN

      INSERT INTO TMPCONTABLE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
            CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
                 ELSE
                Entero_Cero
            END,
            Entero_Cero, Entero_Cero

            FROM CUENTASCONTABLES Cue,
               DETALLEPOLIZA AS Pol
            WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
              AND Pol.Fecha         <= Par_Fecha
              AND Pol.CentroCostoID >= Par_CCInicial
              AND Pol.CentroCostoID <= Par_CCFinal
            GROUP BY Cue.CuentaCompleta;

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
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
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado;

    ELSE

      SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
          Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
        FROM PERIODOCONTABLE
        WHERE Inicio    <= Par_Fecha
          AND Fin   >= Par_Fecha;

      SET Var_EjeCon = IFNULL(Var_EjeCon, Entero_Cero);
      SET Var_PerCon = IFNULL(Var_PerCon, Entero_Cero);
      SET Var_FecIniPer = IFNULL(Var_FecIniPer, Fecha_Vacia);
      SET Var_FecFinPer = IFNULL(Var_FecFinPer, Fecha_Vacia);

      IF (Var_EjeCon = Entero_Cero) THEN
        SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
            Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
          FROM PERIODOCONTABLE
          WHERE Fin   <= Par_Fecha;
      END IF;

      IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

        INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              MAX(Cue.Naturaleza),
              CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                  SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                  SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
                 ELSE
                  Entero_Cero
                END,
              CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
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
              GROUP BY Cue.CuentaCompleta;

        SET Var_Ubicacion   := Ubi_Actual;
      ELSE
      INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
            CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))
               ELSE
                Entero_Cero
              END,
            CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
                SUM( ROUND(IFNULL(Pol.Abonos, Entero_Cero),2))-
                SUM( ROUND(IFNULL(Pol.Cargos, Entero_Cero),2))
               ELSE
                Entero_Cero
            END,
            Entero_Cero,    Entero_Cero
            FROM  CUENTASCONTABLES Cue
          LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
                              AND Pol.Fecha >=    Var_FecIniPer
                              AND Pol.Fecha <=    Par_Fecha
                              AND Pol.CentroCostoID >= Par_CCInicial
                              AND Pol.CentroCostoID <= Par_CCFinal )
          GROUP BY Cue.CuentaCompleta;

      SET Var_Ubicacion   := Ubi_Histor;

      END IF;


      UPDATE TMPCONTABLE Tmp, SALDOSCONTABLES Sal SET
        Tmp.SaldoInicialDeu =  CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
                      Sal.SaldoFinal
                    ELSE
                      Entero_Cero
                  END,
        Tmp.SaldoInicialAcr = CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
                      Sal.SaldoFinal
                    ELSE
                      Entero_Cero
                  END

      WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
        AND Sal.FechaCorte    = Var_FechaSaldos
        AND Sal.CuentaCompleta = Tmp.CuentaContable
        AND Sal.CentroCosto >= Par_CCInicial
        AND Sal.CentroCosto <= Par_CCFinal;


      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
        SELECT Aud_NumTransaccion, MAX(Fin.NombreCampo),    Cadena_Vacia, Entero_Cero,  Entero_Cero,
          Entero_Cero, Entero_Cero,
            (CASE WHEN MAX(Pol.Naturaleza) = VarDeudora
               THEN
              IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
              IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
               ELSE
              IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
              IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
            END ),
          Entero_Cero,
          MAX(Fin.Descripcion),   Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
         LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                            AND Pol.Fecha = Var_FechaSistema
                            AND Pol.NumeroTransaccion   = Aud_NumTransaccion)
        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID;

    END IF;


  ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN
      INSERT INTO TMPCONTABLE
      SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          MAX(Cue.Naturaleza),
          CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
            SUM( ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero),2))
             ELSE
            Entero_Cero
          END,
          CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
            SUM( ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero),2))
            ELSE
            Entero_Cero
          END,
          Entero_Cero,Entero_Cero

          FROM CUENTASCONTABLES Cue,
             SALDOSCONTABLES AS Sal
          WHERE Sal.EjercicioID       = Par_Ejercicio
            AND Sal.PeriodoID     = Par_Periodo
            AND Cue.CuentaCompleta = Sal.CuentaCompleta
            AND Sal.CentroCosto >= Par_CCInicial
            AND Sal.CentroCosto <= Par_CCFinal
          GROUP BY Cue.CuentaCompleta;

    INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
      SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero,
          Entero_Cero,        Entero_Cero,     Entero_Cero,
          CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
             THEN
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2))
             ELSE
              SUM( ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero),2)) -
              SUM( ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero),2))
           END,
           Entero_Cero,
           Fin.Descripcion,   Cadena_Vacia,Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;

    ELSEIF(Par_TipoConsulta = Por_FinPeriodo) THEN

      SET Par_Periodo =  (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);
      INSERT INTO TMPCONTABLEBALANCE
          SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              MAX(Cue.Naturaleza),
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
              WHERE Sal.EjercicioID       = Par_Ejercicio
                AND Sal.PeriodoID     = Par_Periodo
                AND Cue.CuentaCompleta = Sal.CuentaCompleta
                AND Sal.CentroCosto >= Par_CCInicial
                AND Sal.CentroCosto <= Par_CCFinal
              GROUP BY Cue.CuentaCompleta;

          INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
          SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero,
              Entero_Cero,        Entero_Cero,     Entero_Cero,
              CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
                 THEN
                  SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)) -
                  SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
                 ELSE
                  SUM(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)) -
                  SUM(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
               END,
               Entero_Cero,
               Fin.Descripcion,   Cadena_Vacia, Entero_Cero
            FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
              LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                              AND Pol.Fecha = Var_FechaSistema
                              AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

            WHERE Fin.EstadoFinanID = Tif_EdoResul
              AND Fin.EsCalculado = 'N'
            AND NumClien = NumCliente
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;

  END IF;


  IF(Par_Cifras = Cifras_Miles) THEN

    UPDATE TMPBALANZACONTA SET
      SaldoDeudor     =  (SaldoDeudor/1000.00)
      WHERE NumeroTransaccion = Aud_NumTransaccion;

  END IF;


  SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

  SET Var_CreateTable     := CONCAT( "CREATE temporary TABLE ", Var_NombreTabla,
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


      SET @Sentencia  = (Var_CreateTable);
      PREPARE Tabla FROM @Sentencia;
      EXECUTE  Tabla;
      DEALLOCATE PREPARE Tabla;

      SET @Sentencia  = (Var_InsertTable);
      PREPARE InsertarValores FROM @Sentencia;
      EXECUTE  InsertarValores;
      DEALLOCATE PREPARE InsertarValores;


      SET @Sentencia  = (Var_SelectTable);
      PREPARE SelectTable FROM @Sentencia;
      EXECUTE  SelectTable;
      DEALLOCATE PREPARE SelectTable;



      SET @Sentencia  = CONCAT( Var_DropTable);
      PREPARE DropTable FROM @Sentencia;
      EXECUTE  DropTable;
      DEALLOCATE PREPARE DropTable;

  END IF;

  DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;

  DELETE FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$
