-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO005REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO005REP`;
DELIMITER $$


CREATE PROCEDURE `EDORESINTERNO005REP`(
	Par_Ejercicio       INT(11),      	-- Ejercicio cerrado (Anio)
    Par_Periodo         INT(11),      	-- Periodo cerrado (Mes)
    Par_Fecha           DATE,         	-- Fecha de corte
    Par_TipoConsulta    CHAR(1),      	-- Tipo de consulta (Centro de costo o Global)
    Par_SaldosCero      CHAR(1),        -- Inclusion de saldos en cero (S/N)
    Par_Cifras          CHAR(1),        -- Pesos o Miles
    Par_CCInicial       INT(11),      	-- Centro de costos inicial
    Par_CCFinal         INT(11),      	-- Centro de costos finall

	-- Parametros de auditoria
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
      )

TerminaStore: BEGIN


  DECLARE Var_FecConsulta   	DATE;
  DECLARE Var_FechaSistema  	DATE;
  DECLARE Var_FechaSaldos   	DATE;
  DECLARE Var_EjeCon        	INT(11);
  DECLARE Var_PerCon        	INT(11);
  DECLARE Var_FecIniPer     	DATE;
  DECLARE Var_FecFinPer     	DATE;
  DECLARE Var_EjercicioVig    	INT(11);
  DECLARE Var_PeriodoVig    	INT(11);
  DECLARE For_ResulNeto     	VARCHAR(500);
  DECLARE Var_Ubicacion     	CHAR(1);

  DECLARE Var_Columna         VARCHAR(20);
  DECLARE Var_Monto           DECIMAL(18,2);
  DECLARE Var_NombreTabla     VARCHAR(40);
  DECLARE Var_CreateTable     VARCHAR(9000);
  DECLARE Var_InsertTable     VARCHAR(5000);
  DECLARE Var_InsertValores   VARCHAR(5000);
  DECLARE Var_SelectTable     VARCHAR(5000);
  DECLARE Var_DropTable       VARCHAR(5000);
  DECLARE Var_CantCaracteres  INT(11);
  DECLARE Var_UltPeriodoCie   INT(11);
  DECLARE Var_UltEjercicioCie INT(11);
  DECLARE For_OtrosIngresos   VARCHAR(500);
  DECLARE Des_OtrosIngresos   VARCHAR(200);
  DECLARE Var_OtrosIngresos   DECIMAL(18,2);
  DECLARE Con_OtrosIngresos   INT(11);
  DECLARE For_ResultNeto      VARCHAR(500);
  DECLARE Des_ResultNeto      VARCHAR(200);
  DECLARE Var_ResultNeto      DECIMAL(18,2);
  DECLARE Con_ResultNeto      INT(11);
  DECLARE Var_MinCenCos       INT(11);
  DECLARE Var_MaxCenCos       INT(11);


  DECLARE Entero_Cero       INT(11);
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Fecha_Vacia       DATE;
  DECLARE VarDeudora        CHAR(1);
  DECLARE VarAcreedora      CHAR(1);
  DECLARE Tip_Encabezado    CHAR(1);
  DECLARE No_SaldoCeros     CHAR(1);
  DECLARE Cifras_Pesos      CHAR(1);
  DECLARE Cifras_Miles      CHAR(1);
  DECLARE Por_Peridodo      CHAR(1);
  DECLARE Por_Fecha         CHAR(1);
  DECLARE Ubi_Actual        CHAR(1);
  DECLARE Ubi_Histor        CHAR(1);
  DECLARE Tif_EdoResul      INT(11);
  DECLARE NumCliente        INT(11);
  DECLARE Est_Cerrado       CHAR(1);
  DECLARE Por_FinPeriodo    CHAR(1);

  DECLARE cur_Balance CURSOR FOR
    SELECT CuentaContable,  SaldoDeudor
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      ORDER BY CuentaContable;


-- Asignacion de Constantes
  SET Entero_Cero     	:= 0;       		-- Entero Cero
  SET Cadena_Vacia    	:= '';        		-- Cadena Vacia
  SET Fecha_Vacia     	:= '1900-01-01';  	-- Fecha Vacia
  SET VarDeudora      	:= 'D';       		-- Naturaleza Deudora
  SET VarAcreedora    	:= 'A';       		-- Naturaleza Acreedora
  SET Tip_Encabezado  	:= 'E';       		-- Tipo de Cuenta: Encabezado
  SET No_SaldoCeros   	:= 'N';       		-- No Incluir Saldos Ceros
  SET Cifras_Pesos      := 'P';
  SET Cifras_Miles      := 'M';
  SET Por_Peridodo      := 'P';
  SET Por_Fecha         := 'D';
  SET Ubi_Actual        := 'A';
  SET Ubi_Histor        := 'H';
  SET Tif_EdoResul      := 2;
  SET Con_OtrosIngresos := 4;
  SET Con_ResultNeto    := 6;
  SET NumCliente      	:= 10;
  SET Est_Cerrado       := 'C';
  SET Por_FinPeriodo    := 'F';


  SELECT FechaSistema,        EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,    Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);

  IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta = Por_Peridodo) THEN
    SET Par_TipoConsulta := Por_FinPeriodo;
  END IF;

  CALL TRANSACCIONESPRO(Aud_NumTransaccion);

  IF(Par_Fecha    != Fecha_Vacia) THEN
    SET Var_FecConsulta := Par_Fecha;
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

  SELECT CuentaContable, Desplegado  INTO For_OtrosIngresos, Des_OtrosIngresos
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_EdoResul
      AND ConceptoFinanID = Con_OtrosIngresos
      AND NumClien = NumCliente;

   SELECT CuentaContable, Desplegado  INTO For_ResultNeto, Des_ResultNeto
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_EdoResul
      AND ConceptoFinanID = Con_ResultNeto
      AND NumClien = NumCliente;
  SET For_OtrosIngresos := IFNULL(For_OtrosIngresos, Cadena_Vacia);
  SET Des_OtrosIngresos := IFNULL(Des_OtrosIngresos, Cadena_Vacia);
  SET For_ResultNeto := IFNULL(For_ResultNeto, Cadena_Vacia);
  SET Des_ResultNeto := IFNULL(Des_ResultNeto, Cadena_Vacia);
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

  IF (Par_TipoConsulta = Por_Fecha) THEN

    SELECT MAX(FechaCorte) INTO Var_FechaSaldos
      FROM  SALDOSCONTABLES
      WHERE FechaCorte < Par_Fecha;

    SET Var_FechaSaldos := IFNULL(Var_FechaSaldos, Fecha_Vacia);

    IF (Var_FechaSaldos = Fecha_Vacia) THEN

      INSERT INTO TMPCONTABLE
        SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
            CASE WHEN Cue.Naturaleza = VarDeudora  THEN
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


      IF(For_OtrosIngresos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosIngresos,    Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosIngresos,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
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
        CALL `EVALFORMULACONTAPRO`(
          For_ResultNeto,    Ubi_Actual,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_ResultNeto, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
         INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Var_ResultNeto,   Entero_Cero,    Des_ResultNeto,
				Cadena_Vacia, Cadena_Vacia);
      END IF;
    ELSE

      SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
          Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
        FROM PERIODOCONTABLE
        WHERE Inicio    <= Par_Fecha
          AND Fin   >= Par_Fecha;

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
        SELECT Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia, Entero_Cero,  Entero_Cero,
          Entero_Cero, Entero_Cero,
            (CASE WHEN Fin.Naturaleza = VarDeudora
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
          Fin.Descripcion,   Cadena_Vacia,Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
         LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                            AND Pol.Fecha = Var_FechaSistema
                            AND Pol.NumeroTransaccion   = Aud_NumTransaccion)
        WHERE Fin.EstadoFinanID = Tif_EdoResul
          AND Fin.EsCalculado = 'N'
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID,Fin.NombreCampo,Fin.Naturaleza,Fin.Descripcion;

      IF(For_OtrosIngresos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosIngresos,    Var_Ubicacion,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_OtrosIngresos,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
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
        CALL `EVALFORMULACONTAPRO`(
          For_ResultNeto,    Var_Ubicacion,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Var_ResultNeto, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
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


  ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

    INSERT INTO TMPCONTABLE
      SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          MAX(Cue.Naturaleza),
          CASE WHEN Cue.Naturaleza = VarDeudora  THEN
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
             SALDOSCONTABLES AS Sal
          WHERE Sal.EjercicioID       = Par_Ejercicio
            AND Sal.PeriodoID     = Par_Periodo
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
        GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;



        IF(For_OtrosIngresos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrosIngresos,    Cadena_Vacia,   Por_Peridodo,          Par_Fecha,       Par_Ejercicio,
          Par_Periodo,  Par_Fecha,    Var_OtrosIngresos,  Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );
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
        CALL `EVALFORMULACONTAPRO`(
          For_ResultNeto,    Cadena_Vacia,    Por_Peridodo,          Par_Fecha,       Par_Ejercicio,
          Par_Periodo,  Par_Fecha,    Var_ResultNeto, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion
        );

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

IF(Par_TipoConsulta = Por_FinPeriodo) THEN
  SET Par_Periodo := (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE ejercicioID =Par_Ejercicio);

     INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              MAX(Cue.Naturaleza),
              CASE WHEN Cue.Naturaleza = VarDeudora  THEN
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
              CASE WHEN Fin.Naturaleza = VarDeudora
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
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;



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


  IF(Par_Cifras = Cifras_Miles) THEN

    UPDATE TMPBALANZACONTA SET
      SaldoDeudor     =  (SaldoDeudor/1000.00)
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

            SET Var_CreateTable   := SUBSTRING(Var_CreateTable,1,LENGTH(Var_CreateTable)-1);

            SET Var_InsertTable   := SUBSTRING(Var_InsertTable,1,LENGTH(Var_InsertTable)-1);

            SET Var_InsertValores   := SUBSTRING(Var_InsertValores,2,LENGTH(Var_InsertValores)-2);

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

  DELETE FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$
