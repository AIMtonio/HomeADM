-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOVARIACIONES008REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOVARIACIONES008REP`;
DELIMITER $$


CREATE PROCEDURE `EDOVARIACIONES008REP`(
# ==============================================================
# ------------ REPORTE DE VARIACIONES DE CAPITAL ---------------
# ==============================================================

  Par_Ejercicio       INT,
  Par_Periodo       INT,
  Par_Fecha       DATE,
  Par_TipoConsulta    CHAR(1),
  Par_SaldosCero      CHAR(1),

  Par_Cifras        CHAR(1),
  Par_CCInicial     INT,
  Par_CCFinal       INT,
  Par_EmpresaID       INT,
  Aud_Usuario       INT,

  Aud_FechaActual     DATETIME,
  Aud_DireccionIP     VARCHAR(15),
  Aud_ProgramaID      VARCHAR(50),
  Aud_Sucursal      INT,
  Aud_NumTransaccion    BIGINT
      	)

TerminaStore: BEGIN


DECLARE Var_FecConsulta     DATE;
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FechaSaldos     DATE;
DECLARE Var_EjeCon        INT;
DECLARE Var_PerCon        INT;
DECLARE Var_FecIniPer       DATE;
DECLARE Var_FecFinPer       DATE;
DECLARE Var_EjercicioVig    INT;
DECLARE Var_PeriodoVig      INT;
DECLARE For_ResulNeto       VARCHAR(500);
DECLARE Par_AcumuladoCta    DECIMAL(14,2);
DECLARE Des_ResulNeto       VARCHAR(200);
DECLARE Var_Ubicacion       CHAR(1);

DECLARE Var_Columna       VARCHAR(20);
DECLARE Var_Monto       DECIMAL(18,2);
DECLARE Var_NombreTabla     VARCHAR(40);
DECLARE Var_CreateTable     VARCHAR(9000);
DECLARE Var_InsertTable     VARCHAR(5000);
DECLARE Var_InsertValores     VARCHAR(5000);
DECLARE Var_SelectTable     VARCHAR(5000);
DECLARE Var_DropTable       VARCHAR(5000);
DECLARE Var_CantCaracteres    INT;
DECLARE Var_UltPeriodoCie     INT;
DECLARE Var_AntPeriodoCie     INT;
DECLARE Var_UltEjercicioCie   INT;
DECLARE Var_AntEjercicioCie   INT;
DECLARE Var_MinCenCos     INT;
DECLARE Var_MaxCenCos     INT;
DECLARE For_ResultNeto      VARCHAR(500);
DECLARE Des_ResultNeto      VARCHAR(200);
DECLARE For_TotCapConta     VARCHAR(500);
DECLARE Des_TotCapConta     VARCHAR(200);
DECLARE For_CapSocial       VARCHAR(500);
DECLARE Des_CapSocial     VARCHAR(200);
DECLARE For_FondoReserConsRe  VARCHAR(500);
DECLARE Des_FondoReserConsRe  VARCHAR(200);
DECLARE For_PrimaVentAcci   VARCHAR(500);
DECLARE Des_PrimaVentAcci   VARCHAR(200);
DECLARE For_ResultEjerAnt   VARCHAR(500);
DECLARE Des_ResultEjerAnt   VARCHAR(200);
DECLARE Var_ResultXValuTitu2    DECIMAL(14,2);
DECLARE Var_RetenTenenMN2     DECIMAL(14,2);
DECLARE Var_resultNeto2     DECIMAL(14,2);
DECLARE Var_TotCapConta     DECIMAL(14,2);

DECLARE Var_FondoReserConsRe  DECIMAL(18,2);
DECLARE Var_resultNeto      DECIMAL(18,2);
DECLARE Var_RetenTenenMN    DECIMAL(18,2);
DECLARE Var_ResultXValuTitu   DECIMAL(18,2);
DECLARE Var_ResultEjerAnt   DECIMAL(18,2);
DECLARE Var_FondoReser      DECIMAL(18,2);
DECLARE Var_AporFinComu     DECIMAL(18,2);
DECLARE Var_CapSocial     DECIMAL(18,2);
DECLARE Var_EfecIncoRegSoc    DECIMAL(18,2);
DECLARE Var_AportFutAport   DECIMAL(18,2);
DECLARE Var_CapSocialNExh   DECIMAL(18,2);
DECLARE Var_PrimaVentAcci   DECIMAL(18,2);
DECLARE Var_FondoReser2     DECIMAL(18,2);
DECLARE Var_ObligaSubCirc   DECIMAL(18,2);
DECLARE Var_ReservaEspeci   DECIMAL(18,2);
DECLARE Entero_Cero       INT;
DECLARE Cadena_Vacia      CHAR(1);
DECLARE Est_Cerrado       CHAR(1);
DECLARE Fecha_Vacia       DATE;
DECLARE VarDeudora        CHAR(1);
DECLARE VarAcreedora      CHAR(1);
DECLARE Tip_Encabezado      CHAR(1);
DECLARE No_SaldoCeros       CHAR(1);
DECLARE Cifras_Pesos      CHAR(1);
DECLARE Cifras_Miles      CHAR(1);
DECLARE Por_Peridodo      CHAR(1);
DECLARE Por_Fecha         CHAR(1);
DECLARE Ubi_Actual        CHAR(1);
DECLARE Ubi_Histor        CHAR(1);
DECLARE Tif_Balance       INT;
DECLARE NumCliente        INT;
DECLARE Con_ResultNeto      INT;
DECLARE Con_TotCapConta     INT;
DECLARE Con_CapSocial     INT;
DECLARE Con_FondoReserConsRe  INT;
DECLARE Con_PrimaVentAcci   INT;
DECLARE Con_ResultEjerAnt   INT;
DECLARE Var_AntEjeCon     INT;
DECLARE Var_AntPerCon     INT;
DECLARE Var_AntFecIniPer    DATE;
DECLARE Var_AntFecFinPer    DATE;
DECLARE Var_FecIniEjer      DATE;
DECLARE Var_FecFinEjer      DATE;

DECLARE cur_Balance CURSOR FOR
 SELECT CuentaContable, SaldoDeudor
 FROM TMPBALANZACONTA
 WHERE NumeroTransaccion = Aud_NumTransaccion
 ORDER BY CuentaContable;



SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Est_Cerrado     := 'C';
SET VarDeudora      := 'D';
SET VarAcreedora    := 'A';
SET Tip_Encabezado    := 'E';
SET No_SaldoCeros     := 'N';
SET Cifras_Pesos    := 'P';
SET Cifras_Miles    := 'M';
SET Por_Peridodo    := 'P';
SET Por_Fecha       := 'D';
SET Ubi_Actual      := 'A';
SET Ubi_Histor      := 'H';
SET Tif_Balance     := 5;
SET Con_ResultNeto    := 15;
SET Con_TotCapConta   := 14;
SET Con_CapSocial   := 1;
SET Con_FondoReserConsRe:= 19;
SET Con_PrimaVentAcci := 4;
SET Con_ResultEjerAnt := 9;
SET NumCliente      := 8;

SELECT FechaSistema,    EjercicioVigente, PeriodoVigente INTO
    Var_FechaSistema, Var_EjercicioVig, Var_PeriodoVig
      FROM PARAMETROSSIS;

SET Par_Fecha = IFNULL(Par_Fecha, Fecha_Vacia);
SET Var_EjercicioVig = IFNULL(Var_EjercicioVig, Entero_Cero);
SET Var_PeriodoVig = IFNULL(Var_PeriodoVig, Entero_Cero);

CALL TRANSACCIONESPRO(Aud_NumTransaccion);

IF(Par_Fecha  != Fecha_Vacia) THEN
  SET Var_FecConsulta = Par_Fecha;
ELSE
  SELECT  Fin INTO Var_FecConsulta
    FROM PERIODOCONTABLE
    WHERE EjercicioID = Par_Ejercicio
     AND PeriodoID = Par_Periodo;
END IF;


SELECT CuentaContable, Desplegado INTO For_ResultNeto, Des_ResultNeto
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_ResultNeto
     AND NumClien = NumCliente;

SET For_ResultNeto := IFNULL(For_ResultNeto, Cadena_Vacia);
SET Des_ResultNeto := IFNULL(Des_ResultNeto, Cadena_Vacia);


SELECT CuentaContable, Desplegado INTO For_TotCapConta, Des_TotCapConta
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_TotCapConta
     AND NumClien = NumCliente;

SET For_TotCapConta := IFNULL(For_TotCapConta, Cadena_Vacia);
SET Des_TotCapConta := IFNULL(Des_TotCapConta, Cadena_Vacia);


SELECT CuentaContable, Desplegado INTO For_CapSocial, Des_CapSocial
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_CapSocial
     AND NumClien = NumCliente;

SET For_CapSocial := IFNULL(For_CapSocial, Cadena_Vacia);
SET Des_CapSocial := IFNULL(Des_CapSocial, Cadena_Vacia);

SELECT CuentaContable, Desplegado INTO For_FondoReserConsRe, Des_FondoReserConsRe
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_FondoReserConsRe
     AND NumClien = NumCliente;

SET For_FondoReserConsRe := IFNULL(For_FondoReserConsRe, Cadena_Vacia);
SET Des_FondoReserConsRe := IFNULL(Des_FondoReserConsRe, Cadena_Vacia);

SELECT CuentaContable, Desplegado INTO For_PrimaVentAcci, Des_PrimaVentAcci
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_PrimaVentAcci
     AND NumClien = NumCliente;

SET For_PrimaVentAcci := IFNULL(For_PrimaVentAcci, Cadena_Vacia);
SET Des_PrimaVentAcci := IFNULL(Des_PrimaVentAcci, Cadena_Vacia);

SELECT CuentaContable, Desplegado INTO For_ResultEjerAnt, Des_ResultEjerAnt
  FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
     AND ConceptoFinanID = Con_ResultEjerAnt
     AND NumClien = NumCliente;

SET For_ResultEjerAnt := IFNULL(For_ResultEjerAnt, Cadena_Vacia);
SET Des_ResultEjerAnt := IFNULL(Des_ResultEjerAnt, Cadena_Vacia);

SET Par_CCInicial := IFNULL(Par_CCInicial, Entero_Cero);
SET Par_CCFinal   := IFNULL(Par_CCFinal, Entero_Cero);


SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
  FROM CENTROCOSTOS;

IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
  SET Par_CCInicial := Var_MinCenCos;
  SET Par_CCFinal   := Var_MaxCenCos;
END IF;



SELECT MAX(EjercicioID) INTO Var_UltEjercicioCie
 FROM PERIODOCONTABLE Per
  WHERE Per.Fin < Var_FecConsulta
  AND Per.Estatus = Est_Cerrado;

SET Var_UltEjercicioCie := IFNULL(Var_UltEjercicioCie, Entero_Cero);

IF(Var_UltEjercicioCie != Entero_Cero) THEN
 SELECT MAX(PeriodoID) INTO Var_UltPeriodoCie
  FROM PERIODOCONTABLE Per
    WHERE Per.EjercicioID = Var_UltEjercicioCie
     AND Per.Estatus = Est_Cerrado
     AND Per.Fin  < Var_FecConsulta;
END IF;

SET Var_UltPeriodoCie := IFNULL(Var_UltPeriodoCie, Entero_Cero);

SELECT   EjercicioID INTO Var_AntEjercicioCie
  FROM PERIODOCONTABLE
        WHERE       EjercicioID=(Var_UltEjercicioCie-1) LIMIT 1;

 SET Var_AntEjercicioCie := IFNULL(Var_AntEjercicioCie, Entero_Cero);

IF(Var_AntEjercicioCie != Entero_Cero) THEN
 SELECT MAX(PeriodoID) INTO Var_AntPeriodoCie
  FROM PERIODOCONTABLE Per
    WHERE Per.EjercicioID = Var_AntEjercicioCie
      AND Per.Estatus = Est_Cerrado
      AND Per.Fin < Var_FecConsulta;
END IF;


IF (Par_TipoConsulta = Por_Fecha) THEN

  SELECT MAX(FechaCorte) INTO Var_FechaSaldos
    FROM SALDOSCONTABLES
      WHERE FechaCorte < Par_Fecha;

SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);

IF (Var_FechaSaldos = Fecha_Vacia) THEN

 INSERT INTO TMPCONTABLE
 SELECT   Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta,  Entero_Cero,  Entero_Cero,
      Entero_Cero,
      MAX(Cue.Naturaleza),
      CASE WHEN MAX(Cue.Naturaleza) = VarDeudora THEN
      SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
      SUM((IFNULL(Pol.Abonos, Entero_Cero)))
      ELSE
      Entero_Cero
      END,
      CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora THEN
      SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
      SUM((IFNULL(Pol.Cargos, Entero_Cero)))
      ELSE
      Entero_Cero
      END,

      Entero_Cero, Entero_Cero

   FROM CUENTASCONTABLES Cue, DETALLEPOLIZA AS Pol
    WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
    AND Pol.Fecha       <= Par_Fecha
             AND Pol.CentroCostoID >= Par_CCInicial
             AND Pol.CentroCostoID <= Par_CCFinal
		GROUP BY Cue.CuentaCompleta;

INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,

    Entero_Cero,
        Entero_Cero,
    CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
    THEN
    SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero))) -
    SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero)))
    ELSE
    SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero))) -
    SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero)))
    END,
    Entero_Cero,
    Fin.Desplegado,
        Cadena_Vacia, Cadena_Vacia
    FROM CONCEPESTADOSFIN Fin
     LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
     LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
      AND Pol.NumeroTransaccion = Aud_NumTransaccion)
     WHERE Fin.EstadoFinanID = Tif_Balance
        AND Fin.EsCalculado = 'N'
                AND NumClien = NumCliente
		GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado;


  IF(For_ResultNeto != Cadena_Vacia) THEN
   CALL `EVALFORMULACONTAPRO`(
  For_ResultNeto,   Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "resultNeto2",  Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_ResultNeto,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;

     IF(For_TotCapConta  != Cadena_Vacia) THEN
   CALL `EVALFORMULACONTAPRO`(
  For_TotCapConta ,   Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "TotCapConta",  Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_TotCapConta,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;

  IF(For_CapSocial   != Cadena_Vacia) THEN
   CALL `EVALFORMULACONTAPRO`(
  For_CapSocial ,   Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

  INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "CapSocial",  Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_CapSocial,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;


   IF(For_FondoReserConsRe   != Cadena_Vacia) THEN
   CALL `EVALFORMULACONTAPRO`(
  For_FondoReserConsRe,   Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "FondoReserConsRe",   Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_FondoReserConsRe,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;

  IF(For_PrimaVentAcci   != Cadena_Vacia) THEN

  CALL `EVALFORMULACONTAPRO`(
  For_PrimaVentAcci,  Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "PrimaVentAcci",  Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_PrimaVentAcci,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;

     IF(For_ResultEjerAnt  != Cadena_Vacia) THEN

  CALL `EVALFORMULACONTAPRO`(
  For_ResultEjerAnt,  Ubi_Actual,   Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
  Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
  Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
  Aud_Sucursal,     Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "ResultEjerAnt",  Cadena_Vacia,     Entero_Cero, Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero, Des_ResultEjerAnt,
			Cadena_Vacia,     Cadena_Vacia);

   END IF;

  ELSE

    SELECT EjercicioID, PeriodoID, Inicio, Fin INTO
        Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
      FROM PERIODOCONTABLE
      WHERE Inicio  <= Par_Fecha
       AND Fin  >= Par_Fecha;

 SET Var_EjeCon = IFNULL(Var_EjeCon, Entero_Cero);
 SET Var_PerCon = IFNULL(Var_PerCon, Entero_Cero);
 SET Var_FecIniPer = IFNULL(Var_FecIniPer, Fecha_Vacia);
 SET Var_FecFinPer = IFNULL(Var_FecFinPer, Fecha_Vacia);

 IF (Var_EjeCon = Entero_Cero) THEN
 SELECT MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
 Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
 FROM PERIODOCONTABLE
 WHERE Fin  <= Par_Fecha;
 END IF;

IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN
 INSERT INTO TMPCONTABLE
    SELECT Aud_NumTransaccion,  Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
         Entero_Cero, Entero_Cero,
         MAX(Cue.Naturaleza),
         CASE WHEN MAX(Cue.Naturaleza) = VarDeudora THEN
         SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
         SUM((IFNULL(Pol.Abonos, Entero_Cero)))
         ELSE
         Entero_Cero
         END,
         CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora THEN
         SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
         SUM((IFNULL(Pol.Cargos, Entero_Cero)))
         ELSE
         Entero_Cero
         END,
         Entero_Cero, Entero_Cero
         FROM CUENTASCONTABLES Cue
         LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
          AND Pol.Fecha <= Par_Fecha
          AND Pol.CentroCostoID >= Par_CCInicial
          AND Pol.CentroCostoID <= Par_CCFinal )
			GROUP BY Cue.CuentaCompleta;

 UPDATE TMPCONTABLE TMP,
 CUENTASCONTABLES Cue SET
 TMP.Naturaleza = Cue.Naturaleza
  WHERE Cue.CuentaCompleta = TMP.CuentaContable
    AND TMP.NumeroTransaccion = Aud_NumTransaccion;

 SET Var_Ubicacion := Ubi_Actual;

  ELSE
    INSERT INTO TMPCONTABLE
    SELECT   Aud_NumTransaccion,  Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
         Entero_Cero, Entero_Cero,
         MAX(Cue.Naturaleza),
         CASE WHEN MAX(Cue.Naturaleza) = VarDeudora THEN
         SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
         SUM((IFNULL(Pol.Abonos, Entero_Cero)))
         ELSE
         Entero_Cero
         END,
         CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora THEN
         SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
         SUM((IFNULL(Pol.Cargos, Entero_Cero)))
         ELSE
         Entero_Cero
         END,
         Entero_Cero,Entero_Cero
                  FROM CUENTASCONTABLES Cue
         LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
          AND Pol.Fecha >=  Var_FecIniPer
          AND Pol.Fecha <=  Par_Fecha
          AND Pol.CentroCostoID >= Par_CCInicial
          AND Pol.CentroCostoID <= Par_CCFinal)
			GROUP BY Cue.CuentaCompleta;

 SET Var_Ubicacion := Ubi_Histor;

 END IF;


 DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;
 INSERT INTO TMPSALDOCONTABLE
 SELECT Aud_NumTransaccion, Sal.CuentaCompleta, SUM(CASE WHEN Tmp.Naturaleza = VarDeudora THEN
   Sal.SaldoFinal
   ELSE
   Entero_Cero
   END) AS SaldoInicialDeudor,
   SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora THEN
   Sal.SaldoFinal
   ELSE
   Entero_Cero
   END) AS SaldoInicialAcreedor

   FROM TMPCONTABLE Tmp,
   SALDOSCONTABLES Sal
   WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
     AND Sal.FechaCorte = Var_FechaSaldos
     AND Sal.CuentaCompleta = Tmp.CuentaContable
     AND Sal.CentroCosto >= Par_CCInicial
     AND Sal.CentroCosto <= Par_CCFinal
      GROUP BY Sal.CuentaCompleta ;


 UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
 Tmp.SaldoInicialDeu = Sal.SaldoInicialDeu,
 Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
   WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
     AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
     AND Sal.CuentaContable = Tmp.CuentaContable;


 DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

    INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
      SELECT   Aud_NumTransaccion, MAX(Fin.NombreCampo),  Cadena_Vacia, Entero_Cero,  Entero_Cero,
           Entero_Cero, Entero_Cero,
           (CASE WHEN MAX(Pol.Naturaleza) = VarDeudora
           THEN
           IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
           IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
           SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero))) -
           SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero)))
           ELSE
           IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
           IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
           SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero))) -
           SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero)))
           END ),
           Entero_Cero,
           MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
              LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
              LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                 AND Pol.Fecha = Var_FechaSistema
                 AND Pol.NumeroTransaccion  = Aud_NumTransaccion)
           WHERE Fin.EstadoFinanID = Tif_Balance
              AND Fin.EsCalculado = 'N'
              AND NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID;

   IF(For_ResultNeto != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_ResultNeto,   Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "resultNeto2",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_ResultNeto,
			Cadena_Vacia, Cadena_Vacia);

   END IF;


     IF(For_TotCapConta != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_TotCapConta,  Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "TotCapConta",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_TotCapConta,
			Cadena_Vacia, Cadena_Vacia);

   END IF;

     IF(For_CapSocial != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_CapSocial,    Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "CapSocial",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_CapSocial,
			Cadena_Vacia, Cadena_Vacia);

   END IF;

      IF(For_FondoReserConsRe != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_FondoReserConsRe,   Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "FondoReserConsRe",   Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_FondoReserConsRe,
			Cadena_Vacia, Cadena_Vacia);

   END IF;


      IF(For_PrimaVentAcci != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_PrimaVentAcci,  Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "PrimaVentAcci",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_PrimaVentAcci,
			Cadena_Vacia, Cadena_Vacia);

   END IF;

      IF(For_ResultEjerAnt != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_ResultEjerAnt,  Var_Ubicacion,  Por_Fecha,      Par_Fecha,      Var_UltEjercicioCie,
      Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "ResultEjerAnt",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_ResultEjerAnt,
			Cadena_Vacia, Cadena_Vacia);

   END IF;



 END IF;


ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

 INSERT INTO TMPCONTABLE
 SELECT  Aud_NumTransaccion,  Var_FechaSistema, Cue.CuentaCompleta,   Entero_Cero,   Entero_Cero,

         Entero_Cero,
     MAX(Cue.Naturaleza),
     CASE WHEN MAX(Cue.Naturaleza) = VarDeudora THEN
     SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
     ELSE
     Entero_Cero
     END,
     CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora THEN
     SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
     ELSE
     Entero_Cero
     END,

     Entero_Cero,Entero_Cero

  FROM CUENTASCONTABLES Cue,
  SALDOSCONTABLES AS Sal
     WHERE Sal.EjercicioID    = Par_Ejercicio
     AND Sal.PeriodoID    = Par_Periodo
     AND Cue.CuentaCompleta = Sal.CuentaCompleta
     AND Sal.CentroCosto >= Par_CCInicial
     AND Sal.CentroCosto <= Par_CCFinal
		GROUP BY Cue.CuentaCompleta;


 INSERT INTO TMPBALANZACONTA	(
		NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
		Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
		CuentaMayor,					CentroCosto)
 SELECT Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia,  Entero_Cero, Entero_Cero,

    Entero_Cero,
    Entero_Cero,
    CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
    THEN
    SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero))) -
    SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero)))
    ELSE
    SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero))) -
    SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero)))
    END,
    Entero_Cero,
    Fin.Descripcion,

    Cadena_Vacia, Cadena_Vacia
  FROM CONCEPESTADOSFIN Fin
      LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
      LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
        AND Pol.Fecha = Var_FechaSistema
        AND Pol.NumeroTransaccion = Aud_NumTransaccion)
    WHERE Fin.EstadoFinanID = Tif_Balance
      AND Fin.EsCalculado = 'N'
      AND NumClien = NumCliente
		GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;


   IF(For_ResultNeto != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_ResultNeto, Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "resultNeto2",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_ResulNeto,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;



   IF(For_TotCapConta != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_TotCapConta,  Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "TotCapConta",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_TotCapConta,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;

     IF(For_CapSocial != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_CapSocial,  Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "CapSocial",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_CapSocial,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;


     IF(For_FondoReserConsRe != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_FondoReserConsRe, Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "FondoReserConsRe",   Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_FondoReserConsRe,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;

      IF(For_PrimaVentAcci != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_PrimaVentAcci,  Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "PrimaVentAcci",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_PrimaVentAcci,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;

     IF(For_ResultEjerAnt != Cadena_Vacia) THEN

   CALL `EVALFORMULACONTAPRO`(
      For_ResultEjerAnt,  Cadena_Vacia, Por_Peridodo,     Par_Fecha,      Par_Ejercicio,
      Par_Periodo,  Par_Fecha,    Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
      Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
      Aud_Sucursal,   Aud_NumTransaccion);

   INSERT INTO TMPBALANZACONTA	(
			NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
			Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
			CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "ResultEjerAnt",  Cadena_Vacia,     Entero_Cero,  Entero_Cero,
			Entero_Cero,    Entero_Cero,  Par_AcumuladoCta,   Entero_Cero,  Des_ResultEjerAnt,
			Cadena_Vacia,   Cadena_Vacia);

   END IF;




END IF;


IF(Par_Cifras = Cifras_Miles) THEN

 UPDATE TMPBALANZACONTA SET
 SaldoDeudor = ROUND(SaldoDeudor/1000.00, 2)
 WHERE NumeroTransaccion = Aud_NumTransaccion;

END IF;


SELECT SaldoDeudor INTO Var_ResultXValuTitu2
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'ResultXValuTitu'
        ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_RetenTenenMN2
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'RetenTenenMN'
        ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_resultNeto2
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'resultNeto2'
        ORDER BY CuentaContable;

SELECT SaldoDeudor INTO Var_TotCapConta
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'TotCapConta'
        ORDER BY CuentaContable;

SELECT SaldoDeudor INTO Var_CapSocial
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'CapSocial'
        ORDER BY CuentaContable;

SELECT SaldoDeudor INTO Var_FondoReserConsRe
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'FondoReserConsRe'
        ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_PrimaVentAcci
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'PrimaVentAcci'
        ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_ResultEjerAnt
  FROM TMPBALANZACONTA
    WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'ResultEjerAnt'
        ORDER BY CuentaContable;

TRUNCATE TMPCONTABLE;
TRUNCATE TMPBALANZACONTA;


SELECT EjercicioID,MAX(PeriodoID), MIN(Inicio), MAX(Fin)
 INTO Var_AntEjeCon, Var_AntPerCon, Var_AntFecIniPer, Var_AntFecFinPer
      FROM PERIODOCONTABLE
        WHERE EjercicioID=Var_AntEjercicioCie LIMIT 1;


SELECT MIN(Inicio), MAX(Fin)
  INTO Var_FecIniEjer, Var_FecFinEjer
      FROM PERIODOCONTABLE
        WHERE EjercicioID=Var_UltEjercicioCie
          AND Estatus='C' LIMIT 1;
 SET Var_AntEjeCon = IFNULL(Var_AntEjeCon, Entero_Cero);
 SET Var_AntPerCon = IFNULL(Var_AntPerCon, Entero_Cero);
 SET Var_AntFecIniPer = IFNULL(Var_AntFecIniPer, Fecha_Vacia);
 SET Var_AntFecFinPer = IFNULL(Var_AntFecFinPer, Fecha_Vacia);

INSERT INTO TMPCONTABLE
SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,  Entero_Cero,

    Entero_Cero,
    MAX(Cue.Naturaleza),
    CASE WHEN MAX(Cue.Naturaleza) = VarDeudora THEN
    SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
    SUM((IFNULL(Pol.Abonos, Entero_Cero)))
    ELSE
    Entero_Cero
    END,
    CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora THEN
    SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
    SUM((IFNULL(Pol.Cargos, Entero_Cero)))
    ELSE
    Entero_Cero
    END,
    Entero_Cero,

    Entero_Cero
  FROM CUENTASCONTABLES Cue
    LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
      AND Pol.Fecha >=  Var_AntFecIniPer
      AND Pol.Fecha <=  Var_AntFecFinPer
      AND Pol.CentroCostoID >= Par_CCInicial
      AND Pol.CentroCostoID <= Par_CCFinal)
		GROUP BY Cue.CuentaCompleta;

 SET Var_Ubicacion := Ubi_Histor;




 DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;
 INSERT INTO TMPSALDOCONTABLE
 SELECT Aud_NumTransaccion,
    Sal.CuentaCompleta,
        SUM(CASE WHEN Tmp.Naturaleza = VarDeudora THEN
    Sal.SaldoFinal
    ELSE
    Entero_Cero
    END) AS SaldoInicialDeudor,
    SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora THEN
    Sal.SaldoFinal
    ELSE
    Entero_Cero
    END) AS SaldoInicialAcreedor
  FROM TMPCONTABLE Tmp,SALDOSCONTABLES Sal
   WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
     AND Sal.FechaCorte = Var_AntFecFinPer
     AND Sal.CuentaCompleta = Tmp.CuentaContable
     AND Sal.CentroCosto >= Par_CCInicial
     AND Sal.CentroCosto <= Par_CCFinal
      GROUP BY Sal.CuentaCompleta ;


 UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
 Tmp.SaldoInicialDeu = Sal.SaldoInicialDeu,
 Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
  WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
   AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
   AND Sal.CuentaContable = Tmp.CuentaContable;


 DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

INSERT INTO TMPBALANZACONTA	(
		NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
		Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
		CuentaMayor,					CentroCosto)
 SELECT Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia, Entero_Cero,  Entero_Cero,

     Entero_Cero,
     Entero_Cero,
     (CASE WHEN MAX(Pol.Naturaleza) = VarDeudora
     THEN
     IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) -
     IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) +
     SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero))) -
     SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero)))
     ELSE
     IFNULL(SUM(Pol.SaldoInicialAcr), Entero_Cero) -
     IFNULL(SUM(Pol.SaldoInicialDeu), Entero_Cero) +
     SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero))) -
     SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero)))
     END ),
     Entero_Cero,
    MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
  FROM CONCEPESTADOSFIN Fin
   LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
   LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
   AND Pol.Fecha = Var_FechaSistema
   AND Pol.NumeroTransaccion  = Aud_NumTransaccion)
    WHERE Fin.EstadoFinanID = Tif_Balance
      AND Fin.EsCalculado = 'N'
      AND NumClien = NumCliente
		GROUP BY Fin.ConceptoFinanID;

IF(Par_Cifras = Cifras_Miles) THEN

 UPDATE TMPBALANZACONTA SET
 SaldoDeudor = ROUND(SaldoDeudor/1000.00, 2)
 WHERE NumeroTransaccion = Aud_NumTransaccion;

END IF;
SELECT SaldoDeudor INTO Var_EfecIncoRegSoc
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'EfecIncoRegSoc'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_AportFutAport
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'AportFutAport'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_ObligaSubCirc
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'ObligaSubCirc'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_ReservaEspeci
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'ReservaEspeci'
      ORDER BY CuentaContable;

SELECT SaldoDeudor INTO Var_AporFinComu
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'AporFinComu'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_FondoReser
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'FondoReser'
      ORDER BY CuentaContable;

SELECT SaldoDeudor INTO Var_ResultXValuTitu
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'ResultXValuTitu'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_RetenTenenMN
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'RetenTenenMN'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_resultNeto
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'resultNeto'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_CapSocialNExh
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'CapSocialNExh'
      ORDER BY CuentaContable;
SELECT SaldoDeudor INTO Var_FondoReser2
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      AND CuentaContable = 'FondoReser2'
      ORDER BY CuentaContable;

SELECT  Var_resultNeto AS resultNeto, Var_RetenTenenMN AS RetenTenenMN, Var_ResultXValuTitu AS ResultXValuTitu, Var_ResultEjerAnt AS ResultEjerAnt, Var_FondoReser AS FondoReser,
    Var_AporFinComu AS AporFinComu,   Var_CapSocial AS CapSocial,   Var_EfecIncoRegSoc AS EfecIncoRegSoc,   Var_AportFutAport AS AportFutAport,
    Var_PrimaVentAcci AS PrimaVentAcci , Var_ReservaEspeci  AS ReservaEspeci, Var_ResultXValuTitu2 AS ResultXValuTitu2, Var_RetenTenenMN2 AS RetenTenenMN2, Var_resultNeto2 AS resultNeto2, Var_TotCapConta AS TotCapConta,
        Var_ObligaSubCirc AS ObligaSubCirc,   Var_FechaSistema, Var_CapSocialNExh AS CapSocialNExh, Var_FondoReser2 AS FondoReser2,  Var_FondoReserConsRe AS FondoReserConsRe, Var_AntFecFinPer,  Var_FecIniEjer,   Var_FecFinEjer;


DELETE FROM TMPCONTABLE
 WHERE NumeroTransaccion = Aud_NumTransaccion;

DELETE FROM TMPBALANZACONTA
 WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$
