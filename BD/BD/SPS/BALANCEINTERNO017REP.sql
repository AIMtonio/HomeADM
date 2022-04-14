-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNO017REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNO017REP`;
DELIMITER $$

CREATE PROCEDURE `BALANCEINTERNO017REP`(

  Par_Ejercicio       INT,
  Par_Periodo         INT,
  Par_Fecha           DATE,
  Par_TipoConsulta    CHAR(1),
  Par_SaldosCero      CHAR(1),

  Par_Cifras          CHAR(1),
  Par_CCInicial   INT,
  Par_CCFinal     INT,
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
  DECLARE For_CapUtilEjerci   VARCHAR(500);
  DECLARE Par_AcumuladoCta    DECIMAL(14,2);
  DECLARE Des_CapUtilEjerci   VARCHAR(200);
  DECLARE Var_Ubicacion     CHAR(1);
  DECLARE For_IMPDERXPAGAR   VARCHAR(500); 
  DECLARE Des_IMPDERXPAGAR   VARCHAR(200); 
  DECLARE Con_IMPDERXPAGAR   INT; 

  DECLARE Var_Columna     VARCHAR(20);
  DECLARE Var_Monto     DECIMAL(18,2);
  DECLARE Var_NombreTabla     VARCHAR(40);
  DECLARE Var_CreateTable     VARCHAR(9000);
  DECLARE Var_InsertTable     VARCHAR(5000);
  DECLARE Var_InsertValores   VARCHAR(5000);
  DECLARE Var_SelectTable     VARCHAR(5000);
  DECLARE Var_DropTable       VARCHAR(5000);
  DECLARE Var_CantCaracteres  INT;
  DECLARE Var_UltPeriodoCie   INT;
  DECLARE Var_UltEjercicioCie INT;

  DECLARE Var_MinCenCos INT;
  DECLARE Var_MaxCenCos INT;


  DECLARE Entero_Cero     INT;
  DECLARE Cadena_Vacia    CHAR(1);
  DECLARE Est_Cerrado     CHAR(1);
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
  DECLARE Tif_Balance     INT;
  DECLARE Con_CapUtilEjerci   INT;
  DECLARE NumCliente      INT;
  DECLARE Por_FinPeriodo    CHAR(1);
  DECLARE Con_NO            CHAR(1);-- Constante NO


  DECLARE cur_Balance CURSOR FOR
    SELECT CuentaContable,  SaldoDeudor
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      ORDER BY CuentaContable;



  SET Entero_Cero     := 0;
  SET Cadena_Vacia    := '';
  SET Fecha_Vacia     := '1900-01-01';
  SET Est_Cerrado     := 'C';
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
  SET Tif_Balance     := 1;
  SET Con_CapUtilEjerci   := 30;
  SET Con_IMPDERXPAGAR   := 20; 
  SET NumCliente    := 17;
  SET Por_FinPeriodo  := 'F';
  SET Con_NO          := 'N';

  SELECT FechaSistema,    EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,  Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);

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


  SELECT CuentaContable, Desplegado  INTO For_CapUtilEjerci, Des_CapUtilEjerci
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
      AND ConceptoFinanID = Con_CapUtilEjerci
      AND NumClien = NumCliente;
      

   SELECT CuentaContable, Desplegado  INTO For_IMPDERXPAGAR, Des_IMPDERXPAGAR
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
      AND ConceptoFinanID = Con_IMPDERXPAGAR
      AND NumClien = NumCliente;
  

  SET For_CapUtilEjerci   := IFNULL(For_CapUtilEjerci, Cadena_Vacia);
  SET Des_CapUtilEjerci   := IFNULL(Des_CapUtilEjerci, Cadena_Vacia);


  SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
    FROM PERIODOCONTABLE Per
    WHERE Per.Fin < Var_FecConsulta
      AND Per.Estatus = Est_Cerrado;

  SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

  IF(Var_UltEjercicioCie != Entero_Cero) THEN
    SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
      FROM PERIODOCONTABLE Per
      WHERE Per.EjercicioID = Var_UltEjercicioCie
        AND Per.Estatus = Est_Cerrado
        AND Per.Fin < Var_FecConsulta;
  END IF;

  SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo) THEN
    SET Par_TipoConsulta := Por_FinPeriodo;
  END IF;

  IF (Par_TipoConsulta = Por_Fecha) THEN

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte < Par_Fecha;

    SET Var_FechaSaldos := IFNULL(Var_FechaSaldos, Fecha_Vacia);

    IF (Var_FechaSaldos = Fecha_Vacia) THEN

      INSERT INTO TMPCONTABLE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            (Cue.Naturaleza),
            CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                SUM(IFNULL(Pol.Cargos, Entero_Cero))-
                SUM(IFNULL(Pol.Abonos, Entero_Cero))
                 ELSE
                Entero_Cero
            END,
            CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                SUM(IFNULL(Pol.Abonos, Entero_Cero))-
                SUM(IFNULL(Pol.Cargos, Entero_Cero))
                 ELSE
                Entero_Cero
            END,
            Entero_Cero, Entero_Cero

            FROM CUENTASCONTABLES Cue,
                 SALDOSDETALLEPOLIZA AS Pol
            WHERE Pol.Fecha <= Par_Fecha
              AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
              AND Pol.CuentaCompleta = Cue.CuentaCompleta
            GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

      IF( Par_Fecha = Var_FechaSistema ) THEN

        DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

        INSERT INTO TMPBALPOLCENCOSDIA (
            NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
        SELECT  Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
            CASE WHEN (Cue.Naturaleza) = VarDeudora THEN
                SUM(IFNULL(Pol.Cargos, Entero_Cero)) - SUM(IFNULL(Pol.Abonos, Entero_Cero))
               ELSE
                Entero_Cero
              END,
            CASE WHEN (Cue.Naturaleza) = VarAcreedora THEN
                SUM(IFNULL(Pol.Abonos, Entero_Cero)) - SUM(IFNULL(Pol.Cargos, Entero_Cero))
               ELSE
                Entero_Cero
            END
        FROM CUENTASCONTABLES Cue
        LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Pol.Fecha = Var_FechaSistema
                           AND Pol.CuentaCompleta = Cue.CuentaCompleta
                           AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
        GROUP BY Pol.CuentaCompleta, Cue.Naturaleza;

        UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
          Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
          Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
        WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
          AND Tmp.NumeroTransaccion = Aux.NumTransaccion
          AND Tmp.CuentaContable = Aux.CuentaCompleta;

        DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

      END IF;

      INSERT INTO TMPBALANZACONTA
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN Fin.Naturaleza = VarDeudora
              THEN
                 SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero)) -
                 SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero))
              ELSE
                 SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero)) -
                 SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero))
             END,
             Entero_Cero,
             Fin.Desplegado, Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

        LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                           AND Pol.NumeroTransaccion  = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado, Fin.Naturaleza;


      IF(For_CapUtilEjerci != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_CapUtilEjerci,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT TMPBALANZACONTA VALUES(
          Aud_NumTransaccion, "CapUtilidadaEjerci",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
          Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_CapUtilEjerci,
          Cadena_Vacia,Cadena_Vacia);

      END IF;
    
   
	IF(For_IMPDERXPAGAR != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_IMPDERXPAGAR,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);
          
        INSERT TMPBALANZACONTA (NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre, Cargos, Abonos, SaldoDeudor, SaldoAcreedor, DescripcionCuenta, CuentaMayor, CentroCosto)
        VALUES(
          Aud_NumTransaccion, "IMP_DER_POR_PAGAR",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
          Entero_Cero,    Entero_Cero,       Par_AcumuladoCta ,   Entero_Cero,    Des_IMPDERXPAGAR,
          Cadena_Vacia,Cadena_Vacia);

      END IF;

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
              (Cue.Naturaleza),
              CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                  SUM(IFNULL(Pol.Cargos, Entero_Cero)) -
                  SUM(IFNULL(Pol.Abonos, Entero_Cero))
                 ELSE
                  Entero_Cero
                END,
              CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                  SUM(IFNULL(Pol.Abonos, Entero_Cero)) -
                  SUM(IFNULL(Pol.Cargos, Entero_Cero))
                 ELSE
                  Entero_Cero
              END,
              Entero_Cero,    Entero_Cero
              FROM CUENTASCONTABLES Cue
              LEFT OUTER JOIN SALDOSDETALLEPOLIZA AS Pol ON (Pol.Fecha <= Par_Fecha
                                                         AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
                                                         AND Pol.CuentaCompleta = Cue.CuentaCompleta)
              GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

        IF( Par_Fecha = Var_FechaSistema ) THEN

          DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

          INSERT INTO TMPBALPOLCENCOSDIA (
              NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
          SELECT  Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
              SUM(CASE WHEN (Cue.Naturaleza) = VarDeudora
                      THEN
                         IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
                      ELSE
                         Entero_Cero
                END),
              SUM(CASE WHEN (Cue.Naturaleza) = VarAcreedora
                      THEN
                         IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
                      ELSE
                         Entero_Cero
                END)
          FROM CUENTASCONTABLES Cue
          INNER JOIN DETALLEPOLIZA AS Pol ON (Pol.Fecha = Var_FechaSistema
                          AND Pol.CuentaCompleta = Cue.CuentaCompleta
                          AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
          GROUP BY Pol.CuentaCompleta;

          UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
            Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
            Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
          WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
            AND Tmp.NumeroTransaccion = Aux.NumTransaccion
            AND Tmp.CuentaContable = Aux.CuentaCompleta;

          DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

        END IF;

      UPDATE  TMPCONTABLE  TMP,
          CUENTASCONTABLES    Cue SET
        TMP.Naturaleza = Cue.Naturaleza
      WHERE Cue.CuentaCompleta = TMP.CuentaContable
        AND TMP.NumeroTransaccion = Aud_NumTransaccion;

        SET Var_Ubicacion   := Ubi_Actual;

      ELSE
        INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            (Cue.Naturaleza),
            CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
              SUM(IFNULL(Pol.Cargos, Entero_Cero)) -
              SUM(IFNULL(Pol.Abonos, Entero_Cero))
               ELSE
              Entero_Cero
              END,
            CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
              SUM(IFNULL(Pol.Abonos, Entero_Cero)) -
              SUM(IFNULL(Pol.Cargos, Entero_Cero))
               ELSE
              Entero_Cero
            END,
            Entero_Cero,Entero_Cero
            FROM  CUENTASCONTABLES Cue
            LEFT OUTER JOIN HISSALDOSDETPOLIZA AS Pol ON (Pol.Fecha BETWEEN Var_FecIniPer AND Par_Fecha
                                                      AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
                                                      AND Pol.CuentaCompleta = Cue.CuentaCompleta)
            GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

      SET Var_Ubicacion   := Ubi_Histor;

      END IF;


      DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
      INSERT INTO TMPSALDOCONTABLE
      SELECT  Aud_NumTransaccion, Sal.CuentaCompleta, SUM(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
                      Sal.SaldoFinal
                    ELSE
                      Entero_Cero
                  END) AS SaldoInicialDeudor,
          SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
                      Sal.SaldoFinal
                    ELSE
                      Entero_Cero
                  END) AS SaldoInicialAcreedor

        FROM    TMPCONTABLE Tmp,
            SALDOSCONTABLES Sal
        WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
          AND Sal.FechaCorte = Var_FechaSaldos
          AND Sal.CuentaCompleta = Tmp.CuentaContable
          AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
        GROUP BY Sal.CuentaCompleta;


        UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
          Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
          Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
        WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
          AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
          AND Tmp.CuentaContable = Sal.CuentaContable;


      DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

      INSERT INTO TMPBALANZACONTA
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero,  Entero_Cero,
          Entero_Cero, Entero_Cero,
            (CASE WHEN Fin.Naturaleza = VarDeudora
               THEN
              SUM(IFNULL(Pol.SaldoInicialDeu, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoInicialAcr, Entero_Cero)) +
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero))
               ELSE
              SUM(IFNULL(Pol.SaldoInicialAcr, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoInicialDeu, Entero_Cero)) +
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero))
            END ),
          Entero_Cero,
          Fin.Descripcion, Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin

        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                            AND Pol.Fecha = Var_FechaSistema
                            AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;


      IF(For_CapUtilEjerci != Cadena_Vacia) THEN

        CALL `EVALFORMULACONTAPRO`(
          For_CapUtilEjerci,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,      Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,   Aud_NumTransaccion);

        INSERT TMPBALANZACONTA VALUES(
          Aud_NumTransaccion, "CapUtilidadaEjerci",       Cadena_Vacia,     Entero_Cero,  Entero_Cero,
          Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,  Des_CapUtilEjerci,
          Cadena_Vacia,Cadena_Vacia);

      END IF;

    END IF;


  ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

    INSERT INTO TMPCONTABLE
      SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          (Cue.Naturaleza),
          CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
            SUM(IFNULL(Sal.SaldoFinal, Entero_Cero))
             ELSE
            Entero_Cero
          END,
          CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
            SUM(IFNULL(Sal.SaldoFinal, Entero_Cero))
            ELSE
            Entero_Cero
          END,
          Entero_Cero,Entero_Cero

          FROM CUENTASCONTABLES Cue,
             SALDOSCONTABLES AS Sal
          WHERE Sal.EjercicioID = Par_Ejercicio
            AND Sal.PeriodoID = Par_Periodo
            AND Sal.CuentaCompleta = Cue.CuentaCompleta
            AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
          GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;


    INSERT INTO TMPBALANZACONTA
      SELECT  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
          Entero_Cero,        Entero_Cero,        Entero_Cero,
          Entero_Cero,
          CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero))
             ELSE
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero))
           END,
           Entero_Cero,
           Fin.Descripcion, Cadena_Vacia,Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;


      IF(For_CapUtilEjerci != Cadena_Vacia) THEN

        CALL `EVALFORMULACONTAPRO`(
          For_CapUtilEjerci,  Cadena_Vacia, Por_Peridodo,       Par_Fecha,      Par_Ejercicio,
          Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,   Aud_NumTransaccion);

        INSERT TMPBALANZACONTA VALUES(
          Aud_NumTransaccion, "CapUtilidadaEjerci",       Cadena_Vacia,     Entero_Cero,  Entero_Cero,
          Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,  Des_CapUtilEjerci,
          Cadena_Vacia,Cadena_Vacia);

      END IF;

	IF(For_IMPDERXPAGAR != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_IMPDERXPAGAR,      Cadena_Vacia,   Por_Peridodo,          Par_Fecha,        Par_Ejercicio,
          Par_Periodo,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);
          
        INSERT TMPBALANZACONTA (NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre, Cargos, Abonos, SaldoDeudor, SaldoAcreedor, DescripcionCuenta, CuentaMayor, CentroCosto)
        VALUES(
          Aud_NumTransaccion, "IMP_DER_POR_PAGAR",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
          Entero_Cero,    Entero_Cero,       Par_AcumuladoCta ,   Entero_Cero,    Des_IMPDERXPAGAR,
          Cadena_Vacia,Cadena_Vacia);

      END IF;

  END IF;



  IF(Par_TipoConsulta = Por_FinPeriodo) THEN

    INSERT INTO TMPCONTABLEBALANCE
      SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          (Cue.Naturaleza),
          CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
            SUM(IFNULL(Sal.SaldoFinal, Entero_Cero))
             ELSE
            Entero_Cero
          END,
          CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
            SUM(IFNULL(Sal.SaldoFinal, Entero_Cero))
            ELSE
            Entero_Cero
          END,
          Entero_Cero,Entero_Cero

          FROM CUENTASCONTABLES Cue,
             SALDOCONTACIERREJER AS Sal
        WHERE Sal.EjercicioID = Par_Ejercicio
          AND Sal.PeriodoID = Par_Periodo
          AND Sal.CuentaCompleta = Cue.CuentaCompleta
          AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
        GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;


    INSERT INTO TMPBALANZACONTA
      SELECT  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
          Entero_Cero,        Entero_Cero,    Entero_Cero,
      Entero_Cero,
      CASE WHEN Fin.Naturaleza = VarDeudora
             THEN
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero))
             ELSE
              SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero)) -
              SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero))
           END,
           Entero_Cero,
           Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

      LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;

      SELECT  Fin INTO Var_FecConsulta
        FROM PERIODOCONTABLE
        WHERE EjercicioID   = Par_Ejercicio
        AND PeriodoID     = Par_Periodo;
    IF(For_CapUtilEjerci != Cadena_Vacia) THEN
      CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  For_CapUtilEjerci,  'H',  'F',  Var_FecConsulta);

      INSERT TMPBALANZACONTA VALUES(
        Aud_NumTransaccion, "CapUtilidadaEjerci",   Cadena_Vacia,       Entero_Cero,  Entero_Cero,
        Entero_Cero,      Entero_Cero,          Par_AcumuladoCta,   Entero_Cero,  Des_CapUtilEjerci,
        Cadena_Vacia,   Cadena_Vacia);
    END IF;


  END IF;





  IF(Par_Cifras = Cifras_Miles) THEN

    UPDATE TMPBALANZACONTA SET
      SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
      WHERE NumeroTransaccion = Aud_NumTransaccion;

  END IF;


  SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

  SET Var_CreateTable     := CONCAT( "CREATE temporary TABLE ", Var_NombreTabla,
                     " (");

  SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

  SET Var_InsertValores   := ' VALUES( ';

  SET Var_SelectTable     := CONCAT(" SELECT *  FROM ", Var_NombreTabla, " ; ");

  SET Var_DropTable       := CONCAT(" DROP TABLE IF EXISTS ", Var_NombreTabla, "; ");

  SET Var_CantCaracteres := 0;

  IF IFNULL(Aud_NumTransaccion, Entero_Cero) > Entero_Cero THEN

      OPEN  cur_Balance;
          BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP
              FETCH cur_Balance  INTO   Var_Columna, Var_Monto;

              SET Var_CreateTable := CONCAT(Var_CreateTable, CASE WHEN Var_CantCaracteres > 0 THEN " ," ELSE " " END, Var_Columna, " DECIMAL(18,2)");
              SET Var_InsertTable := CONCAT(Var_InsertTable, CASE WHEN Var_CantCaracteres > 0 THEN " ," ELSE " " END, Var_Columna);
              SET Var_InsertValores  := CONCAT(Var_InsertValores,  CASE WHEN Var_CantCaracteres > 0 THEN " ," ELSE " " END, CAST(IFNULL(Var_Monto, 0.0) AS CHAR));
              SET Var_CantCaracteres := Var_CantCaracteres + 1;

            END LOOP;
          END;
      CLOSE cur_Balance;

      SET Var_CreateTable := CONCAT(Var_CreateTable, "); ");
      SET Var_InsertTable := CONCAT(Var_InsertTable, ") ", Var_InsertValores, ");  ");

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

  DELETE FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$
