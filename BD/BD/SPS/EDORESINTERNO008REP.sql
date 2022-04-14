-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO008REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO008REP`;
DELIMITER $$


CREATE PROCEDURE `EDORESINTERNO008REP`(
    Par_Ejercicio           INT,
    Par_Periodo           INT,
    Par_Fecha             DATE,
    Par_TipoConsulta      CHAR(1),
    Par_SaldosCero        CHAR(1),
    Par_Cifras            CHAR(1),

    Par_CCInicial         INT,
    Par_CCFinal           INT,
    Par_EmpresaID         INT,
    Aud_Usuario           INT,
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT,
    Aud_NumTransaccion    BIGINT
    	)

TerminaStore: BEGIN


  DECLARE Var_FecConsulta     DATE;
  DECLARE Var_FechaSistema      DATE;
  DECLARE Var_FechaSaldos     DATE;
  DECLARE Var_EjeCon          INT;
  DECLARE Var_PerCon          INT;
  DECLARE Var_FecIniPer       DATE;
  DECLARE Var_FecFinPer       DATE;
  DECLARE Var_EjercicioVig      INT;
  DECLARE Var_PeriodoVig      INT;
  DECLARE For_ResulNeto       VARCHAR(500);
  DECLARE Var_Ubicacion       CHAR(1);

  DECLARE Var_Columna           VARCHAR(20);
  DECLARE Var_Monto             DECIMAL(18,4);
  DECLARE Var_NombreTabla       VARCHAR(40);
  DECLARE Var_CreateTable       VARCHAR(9000);
  DECLARE Var_InsertTable       VARCHAR(5000);
  DECLARE Var_InsertValores     VARCHAR(5000);
  DECLARE Var_SELECTTable       VARCHAR(5000);
  DECLARE Var_DropTable         VARCHAR(5000);
  DECLARE Var_CantCaracteres    INT;
  DECLARE Var_UPDATEAbs     VARCHAR(5000);
  DECLARE Var_UPDATEIng     VARCHAR(5000);
  DECLARE Var_MinCenCos       INT;
  DECLARE Var_MaxCenCos       INT;

  DECLARE Des_MargFinan         VARCHAR(200);
  DECLARE For_MargFinan         VARCHAR(500);
  DECLARE Des_MargFinRies       VARCHAR(200);
  DECLARE For_MargFinRies       VARCHAR(500);
  DECLARE Des_TotIngresos       VARCHAR(200);
  DECLARE For_TotIngresos       VARCHAR(500);
  DECLARE Des_ReISRYPTU         VARCHAR(200);
  DECLARE For_ReISRYPTU         VARCHAR(500);
  DECLARE Des_RestAntPart       VARCHAR(200);
  DECLARE For_RestAntPart       VARCHAR(500);
  DECLARE Des_IngresOPera       VARCHAR(200);
  DECLARE For_IngresOPera       VARCHAR(500);
  DECLARE Des_SumISRYPTU        VARCHAR(200);
  DECLARE For_SumISRYPTU        VARCHAR(500);
  DECLARE Des_SumMagFinan       VARCHAR(200);
  DECLARE For_SumMagFinan       VARCHAR(500);
  DECLARE Des_IngXInteres       VARCHAR(200);
  DECLARE For_IngXInteres       VARCHAR(500);
  DECLARE Des_GasPorInteres     VARCHAR(200);
  DECLARE For_GasPorInteres     VARCHAR(500);
  DECLARE Des_ComPagadas        VARCHAR(200);
  DECLARE For_ComPagadas        VARCHAR(500);
  DECLARE Des_OtrosIngEgresos     VARCHAR(200);
  DECLARE For_OtrosIngEgresos     VARCHAR(500);
  DECLARE Des_GastAdmonProm     VARCHAR(200);
  DECLARE For_GastAdmonProm     VARCHAR(500);

  DECLARE Var_MargFinan     DECIMAL(18,2);
  DECLARE Var_MargFinRies     DECIMAL(18,2);
  DECLARE Var_TotIngresos     DECIMAL(18,2);
  DECLARE Var_ReISRYPTU     DECIMAL(18,2);
  DECLARE Var_RestAntPart     DECIMAL(18,2);
  DECLARE Var_IngresOPera     DECIMAL(18,2);
  DECLARE Var_SumISRYPTU      DECIMAL(18,2);
  DECLARE Var_SumMagFinan     DECIMAL(18,2);
  DECLARE Var_IngXInteres     DECIMAL(18,2);
  DECLARE Var_GasPorInteres   DECIMAL(18,2);
  DECLARE Var_ComPagadas      DECIMAL(18,2);
  DECLARE Var_OtrosIngEgresos   DECIMAL(18,2);
  DECLARE Var_GastAdmonProm   DECIMAL(18,2);


  DECLARE Var_UltEjercicioCie   INT;
  DECLARE Var_UltPeriodoCie     INT;
  DECLARE Entero_Cero         INT;
  DECLARE Cadena_Vacia        CHAR(1);
  DECLARE Fecha_Vacia         DATE;
  DECLARE VarDeudora          CHAR(1);
  DECLARE VarAcreedora        CHAR(1);
  DECLARE Tip_Encabezado      CHAR(1);
  DECLARE No_SaldoCeros       CHAR(1);
  DECLARE Cifras_Pesos        CHAR(1);
  DECLARE Cifras_Miles        CHAR(1);
  DECLARE Por_Peridodo        CHAR(1);
  DECLARE Por_Fecha           CHAR(1);
  DECLARE Ubi_Actual          CHAR(1);
  DECLARE Ubi_Histor          CHAR(1);
  DECLARE Tif_EdoResul        INT;
  DECLARE NumCliente        INT;
  DECLARE Con_MargFinan       INT;
  DECLARE Con_MargFinRies     INT;
  DECLARE Con_TotIngresos       INT;
  DECLARE Con_ReISRYPTU       INT;
  DECLARE Con_RestAntPart       INT;
  DECLARE Con_IngresOPera       INT;
  DECLARE Con_SumISRYPTU      INT;
  DECLARE Con_SumMagFinan       INT;
  DECLARE Con_IngXInteres       INT;
  DECLARE Con_GasPorInteres     INT;
  DECLARE Con_ComPagadas        INT;
  DECLARE Con_OtrosIngEgresos   INT;
  DECLARE Con_GastAdmonProm   INT;
  DECLARE Por_FinPeriodo      CHAR(1);

  DECLARE Est_Cerrado         CHAR(1);

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
  SET NumCliente    := 8;
  SET Con_MargFinan := 215;
  SET Con_MargFinRies := 216;
  SET Con_TotIngresos := 217;
  SET Con_ReISRYPTU := 218;
  SET Con_RestAntPart := 219;
  SET Con_IngresOPera := 220;
  SET Con_SumISRYPTU  := 221;
  SET Con_SumMagFinan := 222;
  SET Con_IngXInteres := 200;
  SET Con_GasPorInteres:= 201;
  SET Con_ComPagadas  := 205;
  SET Con_OtrosIngEgresos:= 207;
  SET Con_GastAdmonProm:= 208;
  SET Por_FinPeriodo  := 'F';
  SET Est_Cerrado     := 'C';

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


  SELECT CuentaContable, Desplegado  INTO For_MargFinan, Des_MargFinan
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_MargFinan
      AND NumClien = NumCliente;

  SET For_MargFinan   := IFNULL(For_MargFinan, Cadena_Vacia);
  SET Des_MargFinan   := IFNULL(Des_MargFinan, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_MargFinRies, Des_MargFinRies
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_MargFinRies
      AND NumClien = NumCliente;

  SET For_MargFinRies   := IFNULL(For_MargFinRies, Cadena_Vacia);
  SET Des_MargFinRies   := IFNULL(Des_MargFinRies, Cadena_Vacia);

  SELECT CuentaContable, Desplegado  INTO For_TotIngresos, Des_TotIngresos
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_TotIngresos
      AND NumClien = NumCliente;

  SET For_TotIngresos   := IFNULL(For_TotIngresos, Cadena_Vacia);
  SET Des_TotIngresos   := IFNULL(Des_TotIngresos, Cadena_Vacia);



  SELECT CuentaContable, Desplegado  INTO For_ReISRYPTU, Des_ReISRYPTU
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_ReISRYPTU
      AND NumClien = NumCliente;

  SET For_ReISRYPTU   := IFNULL(For_ReISRYPTU, Cadena_Vacia);
  SET Des_ReISRYPTU   := IFNULL(Des_ReISRYPTU, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_RestAntPart, Des_RestAntPart
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_RestAntPart
      AND NumClien = NumCliente;

  SET For_RestAntPart   := IFNULL(For_RestAntPart, Cadena_Vacia);
  SET Des_RestAntPart   := IFNULL(Des_RestAntPart, Cadena_Vacia);

  SELECT CuentaContable, Desplegado  INTO For_IngresOPera, Des_IngresOPera
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_IngresOPera
      AND NumClien = NumCliente;

  SET For_IngresOPera   := IFNULL(For_IngresOPera, Cadena_Vacia);
  SET Des_IngresOPera   := IFNULL(Des_IngresOPera, Cadena_Vacia);

  SELECT CuentaContable, Desplegado  INTO For_SumISRYPTU, Des_SumISRYPTU
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_SumISRYPTU
      AND NumClien = NumCliente;

  SET For_SumISRYPTU   := IFNULL(For_SumISRYPTU, Cadena_Vacia);
  SET Des_SumISRYPTU   := IFNULL(Des_SumISRYPTU, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_SumMagFinan, Des_SumMagFinan
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_SumMagFinan
      AND NumClien = NumCliente;

  SET For_SumISRYPTU   := IFNULL(For_SumISRYPTU, Cadena_Vacia);
  SET Des_SumISRYPTU   := IFNULL(Des_SumISRYPTU, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_IngXInteres, Des_IngXInteres
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_IngXInteres
      AND NumClien = NumCliente;

  SET For_IngXInteres   := IFNULL(For_IngXInteres, Cadena_Vacia);
  SET Des_IngXInteres   := IFNULL(Des_IngXInteres, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_GasPorInteres, Des_GasPorInteres
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GasPorInteres
      AND NumClien = NumCliente;

  SET For_GasPorInteres   := IFNULL(For_GasPorInteres, Cadena_Vacia);
  SET Des_GasPorInteres   := IFNULL(Des_GasPorInteres, Cadena_Vacia);



  SELECT CuentaContable, Desplegado  INTO For_ComPagadas, Des_ComPagadas
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_ComPagadas
      AND NumClien = NumCliente;

  SET For_ComPagadas   := IFNULL(For_ComPagadas, Cadena_Vacia);
  SET Des_ComPagadas   := IFNULL(Des_ComPagadas, Cadena_Vacia);

  SELECT CuentaContable, Desplegado  INTO For_OtrosIngEgresos, Des_OtrosIngEgresos
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_OtrosIngEgresos
      AND NumClien = NumCliente;

  SET For_OtrosIngEgresos   := IFNULL(For_OtrosIngEgresos, Cadena_Vacia);
  SET Des_OtrosIngEgresos   := IFNULL(Des_OtrosIngEgresos, Cadena_Vacia);


  SELECT CuentaContable, Desplegado  INTO For_GastAdmonProm, Des_GastAdmonProm
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GastAdmonProm
      AND NumClien = NumCliente;

  SET For_GastAdmonProm  := IFNULL(For_GastAdmonProm, Cadena_Vacia);
  SET Des_GastAdmonProm   := IFNULL(Des_GastAdmonProm, Cadena_Vacia);


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

         IF(For_MargFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinan,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_MargFinan,      Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

         IF(For_MargFinRies != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinRies,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_MargFinRies,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_TotIngresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_TotIngresos,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_TotIngresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_ReISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ReISRYPTU,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_ReISRYPTU,      Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
           IF(For_RestAntPart != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_RestAntPart,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_RestAntPart,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_IngresOPera != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngresOPera,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_IngresOPera,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_SumISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumISRYPTU,     Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_SumISRYPTU,     Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


              IF(For_SumMagFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumMagFinan,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_SumMagFinan,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

              IF(For_IngXInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngXInteres,    Ubi_Actual,     Por_Fecha,            Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_IngXInteres,        Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_GasPorInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GasPorInteres,    Ubi_Actual,     Por_Fecha,            Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_GasPorInteres,        Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_ComPagadas != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ComPagadas,    Ubi_Actual,     Por_Fecha,           Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_ComPagadas,         Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_OtrosIngEgresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_OtrosIngEgresos,    Ubi_Actual,     Por_Fecha,            Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_OtrosIngEgresos,        Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_GastAdmonProm != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GastAdmonProm,    Ubi_Actual,     Por_Fecha,            Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_GastAdmonProm,        Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;







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

         IF(For_MargFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinan,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_MargFinan,       Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


         IF(For_MargFinRies != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinRies,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_MargFinRies,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_TotIngresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_TotIngresos,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_TotIngresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_ReISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ReISRYPTU,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_ReISRYPTU,      Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
           IF(For_RestAntPart != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_RestAntPart,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_RestAntPart,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_IngresOPera != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngresOPera,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_IngresOPera,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_SumISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumISRYPTU,     Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_SumISRYPTU,     Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


              IF(For_SumMagFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumMagFinan,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_SumMagFinan,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
            IF(For_IngXInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngXInteres,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_IngXInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_GasPorInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GasPorInteres,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_GasPorInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_ComPagadas != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ComPagadas,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_ComPagadas,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_GastAdmonProm != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GastAdmonProm,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_GastAdmonProm,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_OtrosIngEgresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_OtrosIngEgresos,    Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,      Var_OtrosIngEgresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


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
       IF(For_MargFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinan,      Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_MargFinan,       Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

         IF(For_MargFinRies != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinRies,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_MargFinRies,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_TotIngresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_TotIngresos,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_TotIngresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_ReISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ReISRYPTU,      Var_Ubicacion,     Por_Fecha,           Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_ReISRYPTU,       Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
           IF(For_RestAntPart != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_RestAntPart,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_RestAntPart,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_IngresOPera != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngresOPera,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_IngresOPera,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_SumISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumISRYPTU,     Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_SumISRYPTU,     Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


              IF(For_SumMagFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumMagFinan,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_SumMagFinan,   Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,   Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
              IF(For_IngXInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngXInteres,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_IngXInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_GasPorInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GasPorInteres,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_GasPorInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_ComPagadas != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ComPagadas,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_ComPagadas,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_OtrosIngEgresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_OtrosIngEgresos,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_OtrosIngEgresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

             IF(For_GastAdmonProm != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GastAdmonProm,    Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,     Var_GastAdmonProm,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,       Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;




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

       IF(For_MargFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinan,      Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_MargFinan,      Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

         IF(For_MargFinRies != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_MargFinRies,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_MargFinRies,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_TotIngresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_TotIngresos,     Var_Ubicacion,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,       Var_TotIngresos,       Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_ReISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ReISRYPTU,      Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_ReISRYPTU,      Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
           IF(For_RestAntPart != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_RestAntPart,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_RestAntPart,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

           IF(For_IngresOPera != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngresOPera,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_IngresOPera,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

          IF(For_SumISRYPTU != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumISRYPTU,     Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_SumISRYPTU,     Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


              IF(For_SumMagFinan != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_SumMagFinan,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_SumMagFinan,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
              IF(For_IngXInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngXInteres,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_IngXInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


            IF(For_GasPorInteres != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GasPorInteres,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_GasPorInteres,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;

            IF(For_ComPagadas != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_ComPagadas,    Var_Ubicacion,       Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_ComPagadas,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;


            IF(For_OtrosIngEgresos != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_OtrosIngEgresos,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_OtrosIngEgresos,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;
            IF(For_GastAdmonProm != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GastAdmonProm,    Var_Ubicacion,      Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Var_FecIniPer,      Var_GastAdmonProm,    Par_CCInicial,      Par_CCFinal,
                Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);


            END IF;




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

          IF(For_MargFinan != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_MargFinan,    For_MargFinan,   'H',    'F',    Var_FecConsulta);
        END IF;

         IF(For_MargFinRies != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_MargFinRies,    For_MargFinRies,   'H',    'F',    Var_FecConsulta);
        END IF;
         IF(For_TotIngresos != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_TotIngresos,    For_TotIngresos,   'H',    'F',    Var_FecConsulta);
        END IF;

         IF(For_ReISRYPTU != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_ReISRYPTU,    For_ReISRYPTU,   'H',    'F',    Var_FecConsulta);
        END IF;
         IF(For_RestAntPart != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_RestAntPart,    For_RestAntPart,   'H',    'F',    Var_FecConsulta);
        END IF;

         IF(For_IngresOPera != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_IngresOPera,    For_IngresOPera,   'H',    'F',    Var_FecConsulta);
        END IF;
         IF(For_SumISRYPTU != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_SumISRYPTU,    For_SumISRYPTU,   'H',    'F',    Var_FecConsulta);
        END IF;
         IF(For_SumMagFinan != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_SumMagFinan,    For_SumMagFinan,   'H',    'F',    Var_FecConsulta);
        END IF;
        IF(For_IngXInteres != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_IngXInteres,    For_IngXInteres,   'H',    'F',    Var_FecConsulta);
        END IF;
         IF(For_GasPorInteres != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GasPorInteres,    For_GasPorInteres,   'H',    'F',    Var_FecConsulta);
        END IF;
        IF(For_ComPagadas!= Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_ComPagadas,    For_ComPagadas,   'H',    'F',    Var_FecConsulta);
        END IF;
        IF(For_OtrosIngEgresos!= Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_OtrosIngEgresos,    For_OtrosIngEgresos,   'H',    'F',    Var_FecConsulta);
        END IF;
        IF(For_GastAdmonProm!= Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GastAdmonProm,    For_GastAdmonProm,   'H',    'F',    Var_FecConsulta);
        END IF;


  ELSEIF(Par_TipoConsulta = Por_FinPeriodo) THEN
      SET Par_Periodo :=  (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);
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


    SET Var_MargFinan    := ROUND(Var_MargFinan/1000.00, 2);
    SET Var_MargFinRies  := ROUND(Var_MargFinRies/1000.00, 2);
    SET Var_TotIngresos  := ROUND(Var_TotIngresos/1000.00, 2);
    SET Var_ReISRYPTU    := ROUND(Var_ReISRYPTU/1000.00, 2);
    SET Var_RestAntPart  := ROUND(Var_RestAntPart/1000.00, 2);
    SET Var_IngresOPera  := ROUND(Var_IngresOPera/1000.00, 2);
    SET Var_SumISRYPTU   := ROUND(Var_SumISRYPTU/1000.00, 2);
    SET Var_SumMagFinan  := ROUND(Var_SumMagFinan/1000.00, 2);
    SET Var_IngXInteres  := ROUND(Var_IngXInteres/1000.00, 2);
    SET Var_GasPorInteres  := ROUND(Var_GasPorInteres/1000.00, 2);
    SET Var_ComPagadas  := ROUND(Var_ComPagadas/1000.00, 2);
    SET Var_OtrosIngEgresos  := ROUND(Var_OtrosIngEgresos/1000.00, 2);
    SET Var_GastAdmonProm  := ROUND(Var_GastAdmonProm/1000.00, 2);


  END IF;

  SET @Var_MargFinan    := Var_MargFinan;
  SET @Var_MargFinRies  := Var_MargFinRies;
  SET @Var_TotIngresos  := Var_TotIngresos;
  SET @Var_ReISRYPTU    := Var_ReISRYPTU;
  SET @Var_RestAntPart  := Var_RestAntPart;
  SET @Var_IngresOPera  := Var_IngresOPera;
  SET @Var_SumISRYPTU   := Var_SumISRYPTU;
  SET @Var_SumMagFinan  := Var_SumMagFinan;
  SET @Var_IngXInteres  := Var_IngXInteres;
  SET @Var_GasPorInteres := Var_GasPorInteres;
  SET @Var_ComPagadas := Var_ComPagadas;
  SET @Var_OtrosIngEgresos := Var_OtrosIngEgresos;
  SET @Var_GastAdmonProm := Var_GastAdmonProm;

  SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

  SET Var_CreateTable     := CONCAT( "CREATE temporary TABLE ", Var_NombreTabla,
                     " (");

  SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

  SET Var_InsertValores   := ' VALUES( ';

  SET Var_SelectTable     := CONCAT(" SELECT * FROM ", Var_NombreTabla, "; ");


  SET Var_SELECTTable     := CONCAT(" SELECT * FROM ", Var_NombreTabla, "; ");
  SET Var_UPDATEAbs   := CONCAT(" UPDATE  ", Var_NombreTabla, " SET
                    ResulPMonNeto   := abs(ResulPMonNeto),
                    EstimacionPrev  := abs(EstimacionPrev),
                    ComCobradas := abs(ComCobradas),
                    ResulIntermediacion := abs(ResulIntermediacion),
                    OtrosProductos:=abs(OtrosProductos),
                    OtrosGastos := abs(OtrosGastos),
                    OperaDiscon := abs(OperaDiscon),
                    PartResulSubsi  := abs(PartResulSubsi); ");



  SET Var_UPDATEIng   := CONCAT("  UPDATE  ", Var_NombreTabla, " SET  ",

                        "MargenFinan      := @Var_MargFinan,    MargenFinanXRiesgo      := @Var_MargFinRies, ",

                        "TotalIngresos  := @Var_TotIngresos,    ResulISRYPTU    := @Var_ReISRYPTU, GastAdmonProm    := @Var_GastAdmonProm,  ",

                        "ResultAntPart  := @Var_RestAntPart,    IngresoOperacion    := @Var_IngresOPera,OtrosIngEgresos   := @Var_OtrosIngEgresos, ",

                        "SumISRYPTU   := @Var_SumISRYPTU,    SumMargenFinan     := @Var_SumMagFinan, ComPagadas:= @Var_ComPagadas,",
                        "GasPorInteres      := @Var_GasPorInteres, IngPorInteres  := @Var_IngXInteres;" );

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

      SET @Sentencia  = (Var_UPDATEAbs);
      PREPARE ActualizarValores FROM @Sentencia;
      EXECUTE  ActualizarValores;
      DEALLOCATE PREPARE ActualizarValores;

      SET @Sentencia  = (Var_UPDATEIng);
      PREPARE ActualizarValores FROM @Sentencia;
      EXECUTE  ActualizarValores;
      DEALLOCATE PREPARE ActualizarValores;

      SET @Sentencia  = (Var_SELECTTable);
      PREPARE SELECTTable FROM @Sentencia;
      EXECUTE  SELECTTable;
      DEALLOCATE PREPARE SELECTTable;



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
