-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO014REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO014REP`;
DELIMITER $$


CREATE PROCEDURE `EDORESINTERNO014REP`(
  Par_Ejercicio       INT,
  Par_Periodo         INT,
  Par_Fecha           DATE,
  Par_TipoConsulta    CHAR(1),
  Par_SaldosCero      CHAR(1),
  Par_Cifras          CHAR(1),

  Par_CCInicial        INT,
  Par_CCFinal          INT,

  Par_EmpresaID       INT,
  Aud_Usuario         INT,
  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal        INT,
  Aud_NumTransaccion  BIGINT
	)

TerminaStore: BEGIN


  DECLARE Var_FecConsulta DATE;
  DECLARE Var_FechaSistema  DATE;
  DECLARE Var_FechaSaldos DATE;
  DECLARE Var_EjeCon      INT;
  DECLARE Var_PerCon      INT;
  DECLARE Var_FecIniPer   DATE;
  DECLARE Var_FecFinPer   DATE;
  DECLARE Var_EjercicioVig  INT;
  DECLARE Var_PeriodoVig  INT;
  DECLARE Var_Ubicacion   CHAR(1);
  DECLARE Var_MostrarP    CHAR(1);

  DECLARE Var_Columna     VARCHAR(20);
  DECLARE Var_Monto     DECIMAL(18,2);

  DECLARE Var_IngreIntOrd     DECIMAL(18,2);
  DECLARE Var_GasInte     DECIMAL(18,2);
  DECLARE Var_GastPaSuARe   DECIMAL(18,2);
  DECLARE Var_GaPaNoSuARe   DECIMAL(18,2);
  DECLARE Var_GasIntMor     DECIMAL(18,2);
  DECLARE Var_MargenFinan   DECIMAL(18,2);
  DECLARE Var_EstPrevRiCr   DECIMAL(18,2);
  DECLARE Var_MarFRiesCre   DECIMAL(18,2);
  DECLARE Var_IngUtVenAct   DECIMAL(18,2);
  DECLARE Var_IngComConCr   DECIMAL(18,2);
  DECLARE Var_ProducFinan   DECIMAL(18,2);
  DECLARE Var_OtrosProduc   DECIMAL(18,2);
  DECLARE Var_GastosFinan     DECIMAL(18,2);
  DECLARE Var_OtrosResult   DECIMAL(18,2);
  DECLARE Var_GastosOpera   DECIMAL(18,2);
  DECLARE Var_GastosAdmin   DECIMAL(18,2);
  DECLARE Var_GasOpeAdmon   DECIMAL(18,2);
  DECLARE Var_OtrosGastos   DECIMAL(18,2);
  DECLARE Var_UtilidadPer   DECIMAL(18,2);

  DECLARE Var_NombreTabla     VARCHAR(40);
  DECLARE Var_CreateTable     VARCHAR(9000);
  DECLARE Var_InsertTable     VARCHAR(5000);
  DECLARE Var_InsertValores   VARCHAR(5000);
  DECLARE Var_SelectTable     VARCHAR(5000);
  DECLARE Var_UpdateAbs   VARCHAR(5000);
  DECLARE Var_UpdateIng   VARCHAR(5000);
  DECLARE Var_DropTable       VARCHAR(5000);

  DECLARE For_IngreIntOrd     VARCHAR(500);
  DECLARE Des_IngreIntOrd     VARCHAR(200);
  DECLARE For_GasInte       VARCHAR(500);
  DECLARE Des_GasInte       VARCHAR(200);
  DECLARE For_GastPaSuARe   VARCHAR(500);
  DECLARE Des_GastPaSuARe   VARCHAR(200);
  DECLARE For_GaPaNoSuARe   VARCHAR(500);
  DECLARE Des_GaPaNoSuARe   VARCHAR(200);
  DECLARE For_GasIntMor   VARCHAR(500);
  DECLARE Des_GasIntMor   VARCHAR(200);
  DECLARE For_MargenFinan   VARCHAR(500);
  DECLARE Des_MargenFinan   VARCHAR(200);
  DECLARE For_EstPrevRiCr   VARCHAR(500);
  DECLARE Des_EstPrevRiCr   VARCHAR(200);
  DECLARE For_MarFRiesCre   VARCHAR(500);
  DECLARE Des_MarFRiesCre   VARCHAR(200);
  DECLARE For_IngUtVenAct   VARCHAR(500);
  DECLARE Des_IngUtVenAct   VARCHAR(200);
  DECLARE For_IngComConCr   VARCHAR(500);
  DECLARE Des_IngComConCr   VARCHAR(200);
  DECLARE For_ProducFinan   VARCHAR(500);
  DECLARE Des_ProducFinan   VARCHAR(200);
  DECLARE For_OtrosProduc   VARCHAR(500);
  DECLARE Des_OtrosProduc   VARCHAR(200);
  DECLARE For_GastosFinan   VARCHAR(500);
  DECLARE Des_GastosFinan   VARCHAR(200);
  DECLARE For_OtrosResult   VARCHAR(500);
  DECLARE Des_OtrosResult   VARCHAR(200);
  DECLARE For_GastosOpera   VARCHAR(500);
  DECLARE Des_GastosOpera   VARCHAR(200);
  DECLARE For_GastosAdmin   VARCHAR(500);
  DECLARE Des_GastosAdmin   VARCHAR(200);
  DECLARE For_GasOpeAdmon   VARCHAR(500);
  DECLARE Des_GasOpeAdmon   VARCHAR(200);
  DECLARE For_OtrosGastos   VARCHAR(500);
  DECLARE Des_OtrosGastos   VARCHAR(200);
  DECLARE For_UtilidadPer     VARCHAR(500);
  DECLARE Des_UtilidadPer     VARCHAR(200);

  DECLARE Con_IngreIntOrd INT;
  DECLARE Con_GasInte   INT;
  DECLARE Con_GastPaSuARe INT;
  DECLARE Con_GaPaNoSuARe INT;
  DECLARE Con_GasIntMor   INT;
  DECLARE Con_MargenFinan INT;
  DECLARE Con_EstPrevRiCr INT;
  DECLARE Con_MarFRiesCre INT;
  DECLARE Con_IngUtVenAct INT;
  DECLARE Con_IngComConCr INT;
  DECLARE Con_ProducFinan INT;
  DECLARE Con_OtrosProduc INT;
  DECLARE Con_GastosFinan INT;
  DECLARE Con_OtrosResult INT;
  DECLARE Con_GastosOpera INT;
  DECLARE Con_GastosAdmin INT;
  DECLARE Con_GasOpeAdmon INT;
  DECLARE Con_OtrosGastos INT;
  DECLARE Con_UtilidadPer INT;

  DECLARE Var_CantCaracteres  INT;

  DECLARE Var_MinCenCos   INT;
  DECLARE Var_MaxCenCos   INT;
  DECLARE Var_FechaFinMes   DATE; -- Variable para obtener el ultimo dia del mes

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
  DECLARE Var_UltPeriodoCie   INT;
  DECLARE Var_UltEjercicioCie INT;
  DECLARE Est_Cerrado       CHAR(1);
  DECLARE NumCliente      INT;
  DECLARE Por_FinPeriodo    CHAR(1);
  DECLARE Por_CorteMes      CHAR(1);  -- Estado de Resultados por mes

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
  SET Datos_Director  := 'F';
  SET Ubi_Actual      := 'A';
  SET Ubi_Histor      := 'H';
  SET Tif_EdoResul    := 2;
  SET Est_Cerrado     := 'C';
  SET Var_MostrarP  := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro LIKE "MostrarPoderAdRep");
  SET Var_MostrarP  := IFNULL(Var_MostrarP, 'N');
  SET Por_FinPeriodo    := 'F';

  SET Con_IngreIntOrd := 219;
  SET Con_GasInte     := 200;
  SET Con_GastPaSuARe := 221;
  SET Con_GaPaNoSuARe := 222;
  SET Con_GasIntMor   := 227;
  SET Con_MargenFinan := 223;
  SET Con_EstPrevRiCr := 203;
  SET Con_MarFRiesCre := 224;
  SET Con_IngUtVenAct := 228;
  SET Con_IngComConCr := 229;
  SET Con_ProducFinan := 212;
  SET Con_OtrosProduc := 213;
  SET Con_GastosFinan := 214;
  SET Con_OtrosResult := 216;
  SET Con_GastosOpera := 215;
  SET Con_GastosAdmin := 217;
  SET Con_GasOpeAdmon := 225;
  SET Con_OtrosGastos := 218;
  SET Con_UtilidadPer := 226;
  SET NumCliente    := 14;
  SET Por_CorteMes    := 'X';

  SELECT FechaSistema,    EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,  Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           = IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    = IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      = IFNULL(Var_PeriodoVig, Entero_Cero);

  CALL TRANSACCIONESPRO(Aud_NumTransaccion);

  IF(Par_Fecha  != Fecha_Vacia) THEN
    SET Var_FecConsulta = Par_Fecha;
  ELSE
    SELECT  Fin INTO Var_FecConsulta
      FROM PERIODOCONTABLE
      WHERE EjercicioID   = Par_Ejercicio
        AND PeriodoID     = Par_Periodo;
  END IF;

  SELECT CuentaContable, Desplegado  INTO For_IngreIntOrd, Des_IngreIntOrd
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_IngreIntOrd
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_GasInte, Des_GasInte
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GasInte
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_GastPaSuARe, Des_GastPaSuARe
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GastPaSuARe
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_GaPaNoSuARe, Des_GaPaNoSuARe
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GaPaNoSuARe
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_GasIntMor, Des_GasIntMor
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GasIntMor
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_MargenFinan, Des_MargenFinan
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_MargenFinan
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_EstPrevRiCr, Des_EstPrevRiCr
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_EstPrevRiCr
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_MarFRiesCre, Des_MarFRiesCre
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_MarFRiesCre
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_IngUtVenAct, Des_IngUtVenAct
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_IngUtVenAct
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_IngComConCr, Des_IngComConCr
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_IngComConCr
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_ProducFinan, Des_ProducFinan
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_ProducFinan
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_OtrosProduc, Des_OtrosProduc
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_OtrosProduc
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_GastosFinan, Des_GastosFinan
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GastosFinan
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_OtrosResult, Des_OtrosResult
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_OtrosResult
      AND NumClien = NumCliente;


  SELECT CuentaContable, Desplegado  INTO For_GastosOpera, Des_GastosOpera
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GastosOpera
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_GastosAdmin, Des_GastosAdmin
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GastosAdmin
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_GasOpeAdmon, Des_GasOpeAdmon
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_GasOpeAdmon
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_OtrosGastos, Des_OtrosGastos
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_OtrosGastos
      AND NumClien = NumCliente;

  SELECT CuentaContable, Desplegado  INTO For_UtilidadPer, Des_UtilidadPer
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = 2
      AND ConceptoFinanID = Con_UtilidadPer
      AND NumClien = NumCliente;

  SET For_IngreIntOrd := IFNULL(For_IngreIntOrd, Cadena_Vacia);
  SET Des_IngreIntOrd := IFNULL(Des_IngreIntOrd, Cadena_Vacia);
  SET For_GasInte   := IFNULL(For_GasInte,Cadena_Vacia);
  SET Des_GasInte     := IFNULL(Des_GasInte,Cadena_Vacia);
  SET For_GastPaSuARe := IFNULL(For_GastPaSuARe,Cadena_Vacia);
  SET Des_GastPaSuARe := IFNULL(Des_GastPaSuARe,Cadena_Vacia);
  SET For_GaPaNoSuARe := IFNULL(For_GaPaNoSuARe,Cadena_Vacia);
  SET Des_GaPaNoSuARe := IFNULL(Des_GaPaNoSuARe,Cadena_Vacia);
  SET For_GasIntMor := IFNULL(For_GasIntMor,Cadena_Vacia);
  SET Des_GasIntMor := IFNULL(Des_GasIntMor,Cadena_Vacia);
  SET For_MargenFinan := IFNULL(For_MargenFinan,Cadena_Vacia);
  SET Des_MargenFinan := IFNULL(Des_MargenFinan,Cadena_Vacia);
  SET For_EstPrevRiCr := IFNULL(For_EstPrevRiCr,Cadena_Vacia);
  SET Des_EstPrevRiCr := IFNULL(Des_EstPrevRiCr,Cadena_Vacia);
  SET For_MarFRiesCre := IFNULL(For_MarFRiesCre,Cadena_Vacia);
  SET Des_MarFRiesCre := IFNULL(Des_MarFRiesCre,Cadena_Vacia);
  SET For_IngUtVenAct := IFNULL(For_IngUtVenAct,Cadena_Vacia);
  SET Des_IngUtVenAct := IFNULL(Des_IngUtVenAct,Cadena_Vacia);
  SET For_IngComConCr := IFNULL(For_IngComConCr,Cadena_Vacia);
  SET Des_IngComConCr := IFNULL(Des_IngComConCr,Cadena_Vacia);
  SET For_ProducFinan := IFNULL(For_OtrosProduc,Cadena_Vacia);
  SET Des_ProducFinan := IFNULL(Des_ProducFinan,Cadena_Vacia);
  SET For_OtrosProduc := IFNULL(For_OtrosProduc,Cadena_Vacia);
  SET Des_OtrosProduc := IFNULL(Des_OtrosProduc,Cadena_Vacia);
  SET For_GastosFinan := IFNULL(For_GastosFinan,Cadena_Vacia);
  SET Des_GastosFinan := IFNULL(Des_GastosFinan,Cadena_Vacia);
  SET For_OtrosResult := IFNULL(For_OtrosResult,Cadena_Vacia);
  SET Des_OtrosResult := IFNULL(Des_OtrosResult,Cadena_Vacia);
  SET For_GastosOpera := IFNULL(For_GastosOpera,Cadena_Vacia);
  SET Des_GastosOpera := IFNULL(Des_GastosOpera,Cadena_Vacia);
  SET For_GastosAdmin := IFNULL(For_GastosAdmin,Cadena_Vacia);
  SET Des_GastosAdmin := IFNULL(Des_GastosAdmin,Cadena_Vacia);
  SET For_GasOpeAdmon := IFNULL(For_GasOpeAdmon,Cadena_Vacia);
  SET Des_GasOpeAdmon := IFNULL(Des_GasOpeAdmon,Cadena_Vacia);
  SET For_OtrosGastos := IFNULL(For_OtrosGastos,Cadena_Vacia);
  SET Des_OtrosGastos := IFNULL(Des_OtrosGastos,Cadena_Vacia);
  SET For_UtilidadPer := IFNULL(For_UtilidadPer,Cadena_Vacia);
  SET Des_UtilidadPer := IFNULL(Des_UtilidadPer,Cadena_Vacia);


  SET Par_CCInicial := IFNULL(Par_CCInicial, Entero_Cero);
  SET Par_CCFinal   := IFNULL(Par_CCFinal, Entero_Cero);


  SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
    FROM PERIODOCONTABLE Per
    WHERE Per.Fin < Var_FecConsulta
      AND Per.Estatus = Est_Cerrado;

  SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo AND Par_TipoConsulta=Por_CorteMes) THEN
      SET Par_TipoConsulta := Por_FinPeriodo;
    END IF;

  IF(Var_UltEjercicioCie != Entero_Cero) THEN
    SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
      FROM PERIODOCONTABLE Per
      WHERE Per.EjercicioID = Var_UltEjercicioCie
        AND Per.Estatus = Est_Cerrado
        AND Per.Fin < Var_FecConsulta;
  END IF;

  SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

  SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
    FROM CENTROCOSTOS;

  IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
    SET Par_CCInicial := Var_MinCenCos;
    SET Par_CCFinal   := Var_MaxCenCos;
  END IF;


  IF (Par_TipoConsulta = Datos_Director) THEN
    SELECT NombreRepresentante, JefeContabilidad FROM PARAMETROSSIS LIMIT 1;

  ELSE IF (Par_TipoConsulta = Por_Fecha) THEN

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte <= Par_Fecha;

    SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);
    IF (Var_FechaSaldos = Fecha_Vacia) THEN
      INSERT INTO TMPCONTABLEBALANCE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
            CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                ROUND(SUM(  IFNULL(Pol.Cargos, Entero_Cero)-
                      IFNULL(Pol.Abonos, Entero_Cero) ),2)
                 ELSE
                Entero_Cero
            END,
            CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                ROUND(SUM(  IFNULL(Pol.Abonos, Entero_Cero)-
                      IFNULL(Pol.Cargos, Entero_Cero) ),2)
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
            GROUP BY Cue.CuentaCompleta;

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
              THEN
                 ROUND( SUM(IFNULL(Pol.SaldoDeudor, Entero_Cero) -
                      IFNULL(Pol.SaldoAcreedor, Entero_Cero)  ), 2)
              ELSE
                 ROUND( SUM(IFNULL(Pol.SaldoAcreedor, Entero_Cero) -
                      IFNULL(Pol.SaldoDeudor, Entero_Cero)  ), 2)
             END,
             Entero_Cero,
             Fin.Desplegado,  Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

        LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                           AND Pol.NumeroTransaccion  = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado;



        IF(For_IngreIntOrd != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            For_IngreIntOrd,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Var_IngreIntOrd,  Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion
          );
        END IF;

        IF(For_GasInte != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            For_GasInte,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GasInte,  Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion
          );
        END IF;

        IF(For_GastPaSuARe != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            For_GastPaSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Var_GastPaSuARe,  Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;
      IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GaPaNoSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GaPaNoSuARe,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_GasIntMor != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GasIntMor,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GasIntMor,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_MargenFinan != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
        For_MargenFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_MargenFinan,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_EstPrevRiCr != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_EstPrevRiCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_EstPrevRiCr,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_MarFRiesCre != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_MarFRiesCre,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_MarFRiesCre,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_IngUtVenAct != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_IngUtVenAct,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_IngUtVenAct,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;
      IF(For_IngComConCr != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_IngComConCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_IngComConCr,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;


      IF(For_OtrosProduc != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosProduc,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosProduc,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_GastosFinan != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GastosFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GastosFinan,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_OtrosResult != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosResult,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosResult,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_GastosOpera != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GastosOpera,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GastosOpera,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_GastosAdmin != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GastosAdmin,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GastosAdmin,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_GasOpeAdmon != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_GasOpeAdmon,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_GasOpeAdmon,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_OtrosGastos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosGastos,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosGastos,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

      IF(For_UtilidadPer != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_UtilidadPer,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_UtilidadPer,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
      END IF;

    ELSE
      SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
          Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
        FROM PERIODOCONTABLE
        WHERE Inicio  <= Par_Fecha
          AND Fin >= Par_Fecha;

      SET Var_EjeCon = IFNULL(Var_EjeCon, Entero_Cero);
      SET Var_PerCon = IFNULL(Var_PerCon, Entero_Cero);
      SET Var_FecIniPer = IFNULL(Var_FecIniPer, Fecha_Vacia);
      SET Var_FecFinPer = IFNULL(Var_FecFinPer, Fecha_Vacia);

      IF (Var_EjeCon = Entero_Cero) THEN
        SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
            Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
          FROM PERIODOCONTABLE
          WHERE Fin <= Par_Fecha;
      END IF;

            IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

              INSERT INTO TMPCONTABLEBALANCE
                SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
                    Entero_Cero, Entero_Cero,
                    (Cue.Naturaleza),
                    CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                        ROUND(  SUM(IFNULL(Pol.Cargos, Entero_Cero) -
                              IFNULL(Pol.Abonos, Entero_Cero) ) ,2)
                       ELSE
                        Entero_Cero
                      END,
                    CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                        ROUND(  SUM(IFNULL(Pol.Abonos, Entero_Cero) -
                              IFNULL(Pol.Cargos, Entero_Cero) ), 2)
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


                      IF(For_IngreIntOrd != Cadena_Vacia) THEN
                        CALL `EVALFORMULACONTAPRO`(
                          For_IngreIntOrd,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                          Var_UltPeriodoCie,  Par_Fecha,    Var_IngreIntOrd,  Par_CCInicial,    Par_CCFinal,
                          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                          Aud_Sucursal,     Aud_NumTransaccion
                        );
                      END IF;

                      IF(For_GasInte != Cadena_Vacia) THEN
                        CALL `EVALFORMULACONTAPRO`(
                          For_GasInte,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GasInte,  Par_CCInicial,    Par_CCFinal,
                          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                          Aud_Sucursal,     Aud_NumTransaccion
                        );
                      END IF;

                      IF(For_GastPaSuARe != Cadena_Vacia) THEN
                        CALL `EVALFORMULACONTAPRO`(
                          For_GastPaSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                          Var_UltPeriodoCie,  Par_Fecha,    Var_GastPaSuARe,  Par_CCInicial,    Par_CCFinal,
                          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                          Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;
                    IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GaPaNoSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GaPaNoSuARe,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GasIntMor != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GasIntMor,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GasIntMor,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_MargenFinan != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                      For_MargenFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_MargenFinan,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_EstPrevRiCr != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_EstPrevRiCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_EstPrevRiCr,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_MarFRiesCre != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_MarFRiesCre,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_MarFRiesCre,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_IngUtVenAct != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_IngUtVenAct,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_IngUtVenAct,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;
                    IF(For_IngComConCr != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_IngComConCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_IngComConCr,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;


                    IF(For_OtrosProduc != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_OtrosProduc,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosProduc,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GastosFinan != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GastosFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GastosFinan,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_OtrosResult != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_OtrosResult,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosResult,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GastosOpera != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GastosOpera,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GastosOpera,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GastosAdmin != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GastosAdmin,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GastosAdmin,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GasOpeAdmon != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GasOpeAdmon,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GasOpeAdmon,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_OtrosGastos != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_OtrosGastos,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosGastos,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_UtilidadPer != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_UtilidadPer,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_UtilidadPer,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

              ELSE

                  INSERT INTO TMPCONTABLEBALANCE
                  SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
                    Entero_Cero, Entero_Cero,
                    (Cue.Naturaleza),
                    CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                        ROUND(  SUM(IFNULL(Pol.Cargos, Entero_Cero) -
                              IFNULL(Pol.Abonos, Entero_Cero) ), 2)
                       ELSE
                        Entero_Cero
                      END,
                    CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                        ROUND(  SUM(IFNULL(Pol.Abonos, Entero_Cero) -
                              IFNULL(Pol.Cargos, Entero_Cero) ), 2)
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
                  GROUP BY Cue.CuentaCompleta;

                  SET Var_Ubicacion   := Ubi_Histor;

                    IF(For_IngreIntOrd != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_IngreIntOrd,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_IngreIntOrd,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GasInte != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GasInte,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GasInte,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                      );
                    END IF;

                    IF(For_GastPaSuARe != Cadena_Vacia) THEN
                      CALL `EVALFORMULACONTAPRO`(
                        For_GastPaSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                        Var_UltPeriodoCie,  Par_Fecha,    Var_GastPaSuARe,  Par_CCInicial,    Par_CCFinal,
                        Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;
                  IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GaPaNoSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GaPaNoSuARe,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_GasIntMor != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GasIntMor,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GasIntMor,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_MargenFinan != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                    For_MargenFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_MargenFinan,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_EstPrevRiCr != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_EstPrevRiCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_EstPrevRiCr,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_MarFRiesCre != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_MarFRiesCre,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_MarFRiesCre,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_IngUtVenAct != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_IngUtVenAct,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_IngUtVenAct,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;
                  IF(For_IngComConCr != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_IngComConCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_IngComConCr,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;


                  IF(For_OtrosProduc != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_OtrosProduc,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosProduc,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_GastosFinan != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GastosFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GastosFinan,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_OtrosResult != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_OtrosResult,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosResult,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_GastosOpera != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GastosOpera,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GastosOpera,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_GastosAdmin != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GastosAdmin,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GastosAdmin,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_GasOpeAdmon != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_GasOpeAdmon,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_GasOpeAdmon,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_OtrosGastos != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_OtrosGastos,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosGastos,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

                  IF(For_UtilidadPer != Cadena_Vacia) THEN
                    CALL `EVALFORMULACONTAPRO`(
                      For_UtilidadPer,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                      Var_UltPeriodoCie,  Par_Fecha,    Var_UtilidadPer,  Par_CCInicial,    Par_CCFinal,
                      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                      Aud_Sucursal,     Aud_NumTransaccion
                    );
                  END IF;

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
                        GROUP BY CuentaCompleta, FechaCorte;


              UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOSCONTABLES Sal
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

          END IF;


          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
            SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia, Entero_Cero,  Entero_Cero,
                Entero_Cero, Entero_Cero,
                CASE WHEN MAX(Pol.Naturaleza) = VarDeudora THEN
                  ROUND(  SUM(
                    IFNULL(Pol.SaldoInicialDeu, Entero_Cero) -
                    IFNULL(Pol.SaldoInicialAcr, Entero_Cero) +
                    IFNULL(Pol.SaldoDeudor, Entero_Cero) -
                    IFNULL(Pol.SaldoAcreedor, Entero_Cero)
                  ) , 2)
                ELSE
                  ROUND(  SUM(
                    IFNULL(Pol.SaldoInicialAcr, Entero_Cero) -
                    IFNULL(Pol.SaldoInicialDeu, Entero_Cero) +
                    IFNULL(Pol.SaldoAcreedor, Entero_Cero) -
                    IFNULL(Pol.SaldoDeudor, Entero_Cero)
                  ) , 2)
                END ,
              Entero_Cero,
              MAX(Fin.Descripcion), Cadena_Vacia,Cadena_Vacia
              FROM CONCEPESTADOSFIN Fin
             LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

              LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                AND Pol.Fecha = Var_FechaSistema
                                AND Pol.NumeroTransaccion = Aud_NumTransaccion)
            WHERE Fin.EstadoFinanID = Tif_EdoResul
              AND Fin.EsCalculado = 'N'
              AND NumClien = NumCliente
              GROUP BY Fin.ConceptoFinanID;


            IF(For_IngreIntOrd != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_IngreIntOrd,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,    Var_IngreIntOrd,  Par_CCInicial,    Par_CCFinal,
                Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                Aud_Sucursal,     Aud_NumTransaccion
              );
            END IF;

            IF(For_GasInte != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GasInte,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GasInte,  Par_CCInicial,    Par_CCFinal,
                Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                Aud_Sucursal,     Aud_NumTransaccion
              );
            END IF;

            IF(For_GastPaSuARe != Cadena_Vacia) THEN
              CALL `EVALFORMULACONTAPRO`(
                For_GastPaSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
                Var_UltPeriodoCie,  Par_Fecha,    Var_GastPaSuARe,  Par_CCInicial,    Par_CCFinal,
                Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;
          IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GaPaNoSuARe,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GaPaNoSuARe,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_GasIntMor != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GasIntMor,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GasIntMor,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_MargenFinan != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
            For_MargenFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_MargenFinan,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_EstPrevRiCr != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_EstPrevRiCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_EstPrevRiCr,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_MarFRiesCre != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_MarFRiesCre,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_MarFRiesCre,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_IngUtVenAct != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_IngUtVenAct,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_IngUtVenAct,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;
          IF(For_IngComConCr != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_IngComConCr,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_IngComConCr,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;


          IF(For_OtrosProduc != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_OtrosProduc,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosProduc,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_GastosFinan != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GastosFinan,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GastosFinan,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_OtrosResult != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_OtrosResult,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosResult,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_GastosOpera != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GastosOpera,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GastosOpera,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_GastosAdmin != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GastosAdmin,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GastosAdmin,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_GasOpeAdmon != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_GasOpeAdmon,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_GasOpeAdmon,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_OtrosGastos != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_OtrosGastos,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosGastos,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

          IF(For_UtilidadPer != Cadena_Vacia) THEN
            CALL `EVALFORMULACONTAPRO`(
              For_UtilidadPer,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
              Var_UltPeriodoCie,  Par_Fecha,    Var_UtilidadPer,  Par_CCInicial,    Par_CCFinal,
              Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
              Aud_Sucursal,     Aud_NumTransaccion
            );
          END IF;

        END IF;

    ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN
      INSERT INTO TMPCONTABLEBALANCE
      SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,  Entero_Cero,
          Entero_Cero,    Cue.Naturaleza,
          CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
            THEN  ROUND(SUM(IFNULL(Sal.SaldoFinal, Entero_Cero)), 2)
            ELSE  Entero_Cero   END,
          CASE WHEN (Cue.Naturaleza) = VarAcreedora
            THEN  ROUND(SUM(IFNULL(Sal.SaldoFinal, Entero_Cero)), 2)
            ELSE  Entero_Cero   END,
          Entero_Cero,Entero_Cero
          FROM CUENTASCONTABLES Cue,
             SALDOSCONTABLES AS Sal
          WHERE Sal.EjercicioID   = Par_Ejercicio
            AND Sal.PeriodoID   = Par_Periodo
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
                THEN  ROUND(  SUM(  IFNULL(Pol.SaldoDeudor, Entero_Cero)  -
                            IFNULL(Pol.SaldoAcreedor, Entero_Cero)  ), 2)
                ELSE  ROUND(  SUM(  IFNULL(Pol.SaldoAcreedor, Entero_Cero)  -
                            IFNULL(Pol.SaldoDeudor, Entero_Cero)  ), 2) END,
               Entero_Cero,
               Fin.Descripcion, Cadena_Vacia,Cadena_Vacia
            FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
              LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                              AND Pol.Fecha = Var_FechaSistema
                              AND Pol.NumeroTransaccion = Aud_NumTransaccion)

            WHERE Fin.EstadoFinanID = Tif_EdoResul
              AND Fin.EsCalculado = 'N'
              AND NumClien = NumCliente
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;

        IF(For_IngreIntOrd != Cadena_Vacia) THEN
            CALL EVALFORMULAREGPRO(Var_IngreIntOrd, For_IngreIntOrd,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_GasInte != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GasInte, For_GasInte,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_GastPaSuARe != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GastPaSuARe, For_GastPaSuARe,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GaPaNoSuARe, For_GaPaNoSuARe,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_GasIntMor != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GasIntMor, For_GasIntMor,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_MargenFinan != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_MargenFinan, For_MargenFinan,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_EstPrevRiCr != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_EstPrevRiCr, For_EstPrevRiCr,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_MarFRiesCre != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_MarFRiesCre, For_MarFRiesCre,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_IngUtVenAct != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_IngUtVenAct, For_IngUtVenAct,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_IngComConCr != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_IngComConCr, For_IngComConCr,  'H',  'F',  Var_FecConsulta);
        END IF;


        IF(For_OtrosProduc != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_OtrosProduc, For_OtrosProduc,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_GastosFinan != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GastosFinan, For_GastosFinan,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_OtrosResult != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_OtrosResult, For_OtrosResult,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_GastosOpera != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GastosOpera, For_GastosOpera,  'H',  'F',  Var_FecConsulta);
        END IF;
        IF(For_GastosAdmin != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GastosAdmin, For_GastosAdmin,  'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_GasOpeAdmon != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_GasOpeAdmon,For_GasOpeAdmon, 'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_OtrosGastos != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_OtrosGastos,For_OtrosGastos, 'H',  'F',  Var_FecConsulta);
        END IF;

        IF(For_UtilidadPer != Cadena_Vacia) THEN
          CALL EVALFORMULAREGPRO(Var_UtilidadPer,For_UtilidadPer, 'H',  'F',  Var_FecConsulta);
        END IF;
      END IF;

      IF(Par_TipoConsulta = Por_FinPeriodo) THEN
        SET Par_Periodo:=(SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE ejercicioID =Par_Ejercicio);
        INSERT INTO TMPCONTABLE
            SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                Entero_Cero, Entero_Cero,
                Cue.Naturaleza,
                CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                  SUM( ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero),2))
                   ELSE
                  Entero_Cero
                END,
                CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
                  SUM( ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero),2))
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
                                AND Pol.NumeroTransaccion   = Aud_NumTransaccion
                                )

              WHERE Fin.EstadoFinanID = Tif_EdoResul
                AND Fin.EsCalculado = 'N'
                AND NumClien = NumCliente
              GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;



            IF(For_OtrosIngresos != Cadena_Vacia) THEN
            CALL EVALFORMULAPERIFINPRO(Var_OtrosIngresos, For_OtrosIngresos,  'H',  'F',  Var_FecConsulta);

            INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto) 
			VALUES(
					Aud_NumTransaccion, "OtrosIngEgresos",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Var_OtrosIngresos,   Entero_Cero,    Des_OtrosIngresos,
					Cadena_Vacia, Cadena_Vacia);
            END IF;
            IF(For_ResultNeto != Cadena_Vacia) THEN
              CALL EVALFORMULAPERIFINPRO(Var_ResultNeto,  For_OtrosIngresos,  'H',  'F',  Var_FecConsulta);


               INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
				VALUES(
						Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
						Entero_Cero,    Entero_Cero,        Var_ResultNeto,   Entero_Cero,    Des_ResultNeto,
						Cadena_Vacia, Cadena_Vacia);
            END IF;
  END IF;


      /* Consulta por Fin de mes*/
      IF (Par_TipoConsulta = Por_CorteMes) THEN
        SET Var_FechaFinMes   := LAST_DAY(Par_Fecha);

        SELECT MAX(FechaCorte) INTO Var_FechaSaldos
          FROM  SALDOSCONTABLES
          WHERE FechaCorte < Par_Fecha;

        SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);

        SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
          Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
        FROM PERIODOCONTABLE
        WHERE Inicio    <= Par_Fecha
          AND Fin   >= Par_Fecha;

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
                  AND Pol.Fecha         >= Var_FecIniPer
                  AND Pol.Fecha         <= Var_FechaFinMes
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

              IF(For_IngreIntOrd != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                    For_IngreIntOrd,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngreIntOrd,      Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GasInte != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GasInte,      Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasInte,      Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GastPaSuARe != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GastPaSuARe,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastPaSuARe,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GaPaNoSuARe,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GaPaNoSuARe,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GasIntMor != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GasIntMor,      Ubi_Actual,     Por_CorteMes,        Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasIntMor,      Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_MargenFinan != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_MargenFinan,    Ubi_Actual,     Por_CorteMes,        Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_MargenFinan,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_EstPrevRiCr != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_EstPrevRiCr,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_EstPrevRiCr,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_MarFRiesCre != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_MarFRiesCre,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_MarFRiesCre,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_IngUtVenAct != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_IngUtVenAct,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngUtVenAct,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_IngComConCr != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_IngComConCr,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngComConCr,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_OtrosProduc != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_OtrosProduc,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosProduc,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GastosFinan != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GastosFinan,  Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosFinan,    Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_OtrosResult != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_OtrosResult,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosResult,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GastosOpera != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GastosOpera,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosOpera,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GastosAdmin != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GastosAdmin,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosAdmin,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_GasOpeAdmon != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_GasOpeAdmon,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasOpeAdmon,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_OtrosGastos != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_OtrosGastos,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosGastos,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

              IF(For_UtilidadPer != Cadena_Vacia) THEN
                  CALL `EVALFORMULACONTAPRO`(
                    For_UtilidadPer,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                    Var_UltPeriodoCie,  Var_FecIniPer,  Var_UtilidadPer,  Par_CCInicial,      Par_CCFinal,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
              END IF;

        ELSE

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

          IF (Var_EjeCon >= Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

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
                                AND Pol.Fecha         >= Var_FecIniPer
                                AND Pol.Fecha         <= Var_FechaFinMes
                                AND Pol.CentroCostoID >= Par_CCInicial
                                AND Pol.CentroCostoID <= Par_CCFinal )
              GROUP BY Cue.CuentaCompleta;

            IF(For_IngreIntOrd != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngreIntOrd,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngreIntOrd,      Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasInte != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasInte,      Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasInte,      Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastPaSuARe != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastPaSuARe,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastPaSuARe,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GaPaNoSuARe,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GaPaNoSuARe,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasIntMor != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasIntMor,      Ubi_Actual,     Por_CorteMes,        Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasIntMor,      Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_MargenFinan != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_MargenFinan,    Ubi_Actual,     Por_CorteMes,        Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_MargenFinan,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_EstPrevRiCr != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_EstPrevRiCr,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_EstPrevRiCr,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_MarFRiesCre != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_MarFRiesCre,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_MarFRiesCre,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_IngUtVenAct != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngUtVenAct,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngUtVenAct,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_IngComConCr != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngComConCr,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_IngComConCr,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosProduc != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosProduc,    Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosProduc,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosFinan != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosFinan,  Ubi_Actual,     Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosFinan,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosResult != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosResult,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosResult,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosOpera != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosOpera,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosOpera,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosAdmin != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosAdmin,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GastosAdmin,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasOpeAdmon != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasOpeAdmon,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_GasOpeAdmon,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosGastos != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosGastos,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_OtrosGastos,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_UtilidadPer != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_UtilidadPer,  Ubi_Actual,   Por_CorteMes,       Var_FecIniPer,      Var_UltEjercicioCie,
                  Var_UltPeriodoCie,  Var_FecIniPer,  Var_UtilidadPer,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

          ELSE

            INSERT INTO TMPCONTABLE
              SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                  Entero_Cero,    Entero_Cero,    MAX(Cue.Naturaleza),
                  CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
                      ROUND(SUM(IFNULL(Pol.Cargos, Entero_Cero)),2)-
                      ROUND(SUM(IFNULL(Pol.Abonos, Entero_Cero)),2)
                     ELSE
                      Entero_Cero
                    END,
                  CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
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
                GROUP BY Cue.CuentaCompleta;

            IF(For_IngreIntOrd != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngreIntOrd,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_IngreIntOrd,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasInte != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasInte,      Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GasInte,      Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastPaSuARe != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastPaSuARe,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GastPaSuARe,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GaPaNoSuARe != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GaPaNoSuARe,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GaPaNoSuARe,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasIntMor != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasIntMor,      Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GasIntMor,      Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_MargenFinan != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_MargenFinan,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_MargenFinan,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_EstPrevRiCr != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_EstPrevRiCr,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_EstPrevRiCr,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_MarFRiesCre != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_MarFRiesCre,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_MarFRiesCre,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_IngUtVenAct != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngUtVenAct,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_IngUtVenAct,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_IngComConCr != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_IngComConCr,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_IngComConCr,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosProduc != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosProduc,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_OtrosProduc,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosFinan != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosFinan,    Ubi_Histor,     Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GastosFinan,    Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosResult != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosResult,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_OtrosResult,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosOpera != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosOpera,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GastosOpera,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GastosAdmin != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GastosAdmin,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GastosAdmin,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_GasOpeAdmon != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_GasOpeAdmon,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_GasOpeAdmon,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_OtrosGastos != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_OtrosGastos,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_OtrosGastos,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

            IF(For_UtilidadPer != Cadena_Vacia) THEN
                CALL `EVALFORMULACONTAPRO`(
                  For_UtilidadPer,  Ubi_Histor,   Por_CorteMes,       Var_FecIniPer,      Par_Ejercicio,
                  Par_Periodo,      Var_FecIniPer,  Var_UtilidadPer,  Par_CCInicial,      Par_CCFinal,
                  Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                  Aud_Sucursal,       Aud_NumTransaccion);
            END IF;

          END IF;


          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
            SELECT Aud_NumTransaccion, MAX(Fin.NombreCampo),  Cadena_Vacia, Entero_Cero,  Entero_Cero,
              Entero_Cero, Entero_Cero,
                (CASE WHEN MAX(Pol.Naturaleza) = VarDeudora
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
              MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
              FROM CONCEPESTADOSFIN Fin
             LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

              LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                                AND Pol.Fecha = Var_FechaSistema
                                AND Pol.NumeroTransaccion = Aud_NumTransaccion)
            WHERE Fin.EstadoFinanID = Tif_EdoResul
              AND Fin.EsCalculado = 'N'
              AND NumClien = NumCliente
              GROUP BY Fin.ConceptoFinanID;
        END IF;

      END IF;

      UPDATE TMPBALANZACONTA SET

        SaldoDeudor     = (SaldoDeudor)
      WHERE NumeroTransaccion = Aud_NumTransaccion;

      IF(Par_Cifras = Cifras_Miles) THEN

        UPDATE TMPBALANZACONTA SET

          SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
          WHERE NumeroTransaccion = Aud_NumTransaccion;

        SET  Var_IngreIntOrd:= ROUND(Var_IngreIntOrd/1000.00, 2);
        SET  Var_GasInte    := ROUND(Var_GasInte/1000.00, 2);
        SET  Var_GastPaSuARe:= ROUND(Var_GastPaSuARe/1000.00, 2);
        SET  Var_GaPaNoSuARe:= ROUND(Var_GaPaNoSuARe/1000.00, 2);
        SET  Var_GasIntMor  := ROUND(Var_GasIntMor  /1000.00, 2);
        SET  Var_MargenFinan:= ROUND(Var_MargenFinan/1000.00, 2);
        SET  Var_EstPrevRiCr:= ROUND(Var_EstPrevRiCr/1000.00, 2);
        SET  Var_MarFRiesCre:= ROUND(Var_MarFRiesCre/1000.00, 2);
        SET  Var_IngUtVenAct:= ROUND(Var_IngUtVenAct/1000.00, 2);
        SET  Var_IngComConCr:= ROUND(Var_IngComConCr/1000.00, 2);
        SET  Var_ProducFinan:= ROUND(Var_ProducFinan/1000.00, 2);
        SET  Var_OtrosProduc:= ROUND(Var_OtrosProduc/1000.00, 2);
        SET  Var_GastosFinan:= ROUND(Var_GastosFinan/1000.00, 2);
        SET  Var_OtrosResult:= ROUND(Var_OtrosResult/1000.00, 2);
        SET  Var_GastosOpera:= ROUND(Var_GastosOpera/1000.00, 2);
        SET  Var_GastosAdmin:= ROUND(Var_GastosAdmin/1000.00, 2);
        SET  Var_GasOpeAdmon:= ROUND(Var_GasOpeAdmon/1000.00, 2);
        SET  Var_OtrosGastos:= ROUND(Var_OtrosGastos/1000.00, 2);
        SET  Var_UtilidadPer:= ROUND(Var_UtilidadPer/1000.00, 2);



      END IF;


    SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

    SET Var_CreateTable     := CONCAT( "CREATE TEMPORARY table ", Var_NombreTabla,
                       " (");

    SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

    SET Var_InsertValores   := ' VALUES( ';

    SET Var_SelectTable     := CONCAT(" SELECT * FROM ", Var_NombreTabla, "; ");


      SET Var_UpdateAbs   := CONCAT(" update  ", Var_NombreTabla, " set
                        ComCobradas   := abs(ComCobradas),
                        ComPagadas    := abs(ComPagadas),
                        EstimacionPrev  := abs(EstimacionPrev),
                        GasPorInteres := abs(GasPorInteres),
                        GastAdmonProm := abs(GastAdmonProm),
                        IngPorInteres := abs(IngPorInteres),
                        OperaDiscon   := abs(OperaDiscon),
                        PartResulSubsi  := abs(PartResulSubsi),
                        ResulIntermediacion:=abs(ResulIntermediacion),
                        ResulPosMone  := abs(ResulPosMone),
                        ResulIntermediacion := abs(ResulIntermediacion); ");


      SET @Var_IngreIntOrd := Var_IngreIntOrd;
      SET @Var_GasInte     := Var_GasInte   ;
      SET @Var_GastPaSuARe := Var_GastPaSuARe;
      SET @Var_GaPaNoSuARe := Var_GaPaNoSuARe;
      SET @Var_GasIntMor   := Var_GasIntMor  ;
      SET @Var_MargenFinan := Var_MargenFinan;
      SET @Var_EstPrevRiCr := Var_EstPrevRiCr;
      SET @Var_MarFRiesCre := Var_MarFRiesCre;
      SET @Var_IngUtVenAct := Var_IngUtVenAct;
      SET @Var_IngComConCr := Var_IngComConCr;
      SET @Var_OtrosProduc := Var_OtrosProduc;
      SET @Var_GastosFinan := Var_GastosFinan;
      SET @Var_OtrosResult := Var_OtrosResult;
      SET @Var_GastosOpera := Var_GastosOpera;
      SET @Var_GastosAdmin := Var_GastosAdmin;
      SET @Var_GasOpeAdmon := Var_GasOpeAdmon;
      SET @Var_OtrosGastos := Var_OtrosGastos;
      SET @Var_UtilidadPer := Var_UtilidadPer;

      SET Var_UpdateIng   := CONCAT("  UPDATE  ", Var_NombreTabla, " SET  ",


                                  "IngXInteresesOrd   := @Var_IngreIntOrd,  IngPorInteres     := @Var_GasInte, ",
                                  "GastIntPagSujARet  := @Var_GastPaSuARe,  GasIntPagNoSujRe  := @Var_GaPaNoSuARe, ",
                                  "GasIntAnt      := @Var_GasIntMor,      MargenFinanciero    := @Var_MargenFinan, ",
                                  "EstimacionPrev   := @Var_EstPrevRiCr,    MargFinanAjuRC      := @Var_MarFRiesCre, ",
                                  "IngUtiAct      := @Var_IngUtVenAct,    IngComCred      := @Var_IngComConCr, ",
                                  "OtrosProductos   := @Var_OtrosProduc, ",
                                  "GastosFinancieros  := @Var_GastosFinan,    OtrosResultados   := @Var_OtrosResult, ",
                                  "GastosOperativos   := @Var_GastosOpera,    GastosAdministrac   := @Var_GastosAdmin, ",
                                  "GastOperaYAdmon  := @Var_GasOpeAdmon,    OtrosGastos     := @Var_OtrosGastos, ",
                                  "UtilidadOPerdida   := @Var_UtilidadPer; ");

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

        SET Var_CreateTable     := CONCAT(Var_CreateTable, 'MostrarPoderAdRep CHAR(1)', "); ");
        SET Var_InsertTable     := CONCAT(Var_InsertTable, 'MostrarPoderAdRep');
        SET Var_InsertTable     := CONCAT(Var_InsertTable, ") ", Var_InsertValores,"'",Var_MostrarP,"');");


          SET @Sentencia  = (Var_CreateTable);
          PREPARE Tabla FROM @Sentencia;
          EXECUTE  Tabla;
          DEALLOCATE PREPARE Tabla;

          SET @Sentencia  = (Var_InsertTable);
          PREPARE InsertarValores FROM @Sentencia;
          EXECUTE  InsertarValores;
          DEALLOCATE PREPARE InsertarValores;


          SET @Sentencia  = (Var_UpdateAbs);
          PREPARE ActualizarValores FROM @Sentencia;
          EXECUTE  ActualizarValores;
          DEALLOCATE PREPARE ActualizarValores;


          SET @Sentencia  = (Var_UpdateIng);
          PREPARE ActualizarValores FROM @Sentencia;
          EXECUTE  ActualizarValores;
          DEALLOCATE PREPARE ActualizarValores;

          SET @Sentencia  = (Var_SelectTable);
          PREPARE SelectTable FROM @Sentencia;
          EXECUTE  SelectTable;
          DEALLOCATE PREPARE SelectTable;

          SET @Sentencia  = CONCAT( Var_DropTable);
          PREPARE DropTable FROM @Sentencia;
          EXECUTE  DropTable;
          DEALLOCATE PREPARE DropTable;


      END IF;

      DELETE FROM TMPCONTABLEBALANCE
        WHERE NumeroTransaccion = Aud_NumTransaccion;

      DELETE FROM TMPBALANZACONTA
        WHERE NumeroTransaccion = Aud_NumTransaccion;
  END IF;

END TerminaStore$$
