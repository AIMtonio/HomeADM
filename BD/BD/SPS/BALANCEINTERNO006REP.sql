-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNO006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNO006REP`;
DELIMITER $$


CREATE PROCEDURE `BALANCEINTERNO006REP`(

# SP QUE GENERA EL BALANCE GENERAL. PERSONALIZADO PARA LA BOLSA.

	Par_Ejercicio       INT(11),    -- Ejercicio contable (Anio)
	Par_Periodo         INT(11),    -- Periodo contable (Mes)
	Par_Fecha           DATE,       -- Fecha de consulta
	Par_TipoConsulta    CHAR(1),    -- Tipo de consulta (Centro de costo o Global)
	Par_SaldosCero      CHAR(1),    -- Inclusion de saldos en cero (S/N)
	Par_Cifras          CHAR(1),    -- Pesos o Miles
	Par_CCInicial   	INT(11),    -- Centro de costos inicial
	Par_CCFinal     	INT(11),    -- Centro de Costos Final

	-- Parametros de auditoria
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  	BIGINT(20)
      )

TerminaStore: BEGIN


	DECLARE Var_FecConsulta   	DATE;
	DECLARE Var_FechaSistema 	DATE;
	DECLARE Var_FechaSaldos  	DATE;
	DECLARE Var_EjeCon       	INT(11);
	DECLARE Var_PerCon        	INT(11);
	DECLARE Var_FecIniPer     	DATE;
	DECLARE Var_FecFinPer     	DATE;
	DECLARE Var_EjercicioVig  	INT(11);
	DECLARE Var_PeriodoVig    	INT(11);
	DECLARE For_Efectivo      	VARCHAR(500);
	DECLARE Total_Cartera     	VARCHAR(500);
	DECLARE Total_CarteraNeto 	VARCHAR(500);
	DECLARE ReservaCapital    	VARCHAR(500);
	DECLARE ResulEjerAnteriores VARCHAR(500);
	DECLARE ResulPeriodo    	VARCHAR(500);
	DECLARE OtrosIngEgresos   	VARCHAR(500);
	DECLARE Par_AcumuladoCta    DECIMAL(18,2);
	DECLARE Des_Total_Cartera   VARCHAR(200);
	DECLARE Des_Total_CarNeto   VARCHAR(200);
	DECLARE Des_ReservaCapital  VARCHAR(200);
	DECLARE Des_ResulEjerAnt  	VARCHAR(200);
	DECLARE Des_ResulPeriodo  	VARCHAR(200);
	DECLARE Des_ResulNeto     	VARCHAR(200);
	DECLARE Des_OtrosIngEgresos VARCHAR(200);
	DECLARE Var_Ubicacion     	CHAR(1);

	DECLARE Var_Columna     	VARCHAR(20);
	DECLARE Var_Monto     		DECIMAL(18,2);
	DECLARE Var_NombreTabla     VARCHAR(40);
	DECLARE Var_CreateTable     VARCHAR(9000);
	DECLARE Var_InsertTable     VARCHAR(5000);
	DECLARE Var_InsertValores   VARCHAR(5000);
	DECLARE Var_SelectTable     VARCHAR(5000);
	DECLARE Var_DropTable       VARCHAR(5000);
	DECLARE Var_CantCaracteres  INT(11);
	DECLARE Var_UltPeriodoCie   INT(11);
	DECLARE Var_UltEjercicioCie INT(11);
	DECLARE Var_MinCenCos   	INT(11);
	DECLARE Var_MaxCenCos   	INT(11);


	DECLARE Entero_Cero         	INT(11);
	DECLARE Cadena_Vacia        	CHAR(1);
	DECLARE Est_Cerrado           	CHAR(1);
	DECLARE Fecha_Vacia           	DATE;
	DECLARE VarDeudora          	CHAR(1);
	DECLARE VarAcreedora        	CHAR(1);
	DECLARE Tip_Encabezado      	CHAR(1);
	DECLARE No_SaldoCeros       	CHAR(1);
	DECLARE Cifras_Pesos        	CHAR(1);
	DECLARE Cifras_Miles        	CHAR(1);
	DECLARE Por_Periodo       		CHAR(1);
	DECLARE Por_Fecha             	CHAR(1);
	DECLARE Ubi_Actual            	CHAR(1);
	DECLARE Ubi_Histor            	CHAR(1);
	DECLARE Tif_Balance         	INT(11);
	DECLARE Con_ResulEfectivo     	INT(11);
	DECLARE ConTotal_Cartera      	INT(11);
	DECLARE ConTotal_CarteraNeto  	INT(11);
	DECLARE ConReservaCapital   	INT(11);
	DECLARE ConResulEjerAnteriores  INT(11);
	DECLARE ConResulPeriodo     	INT(11);
	DECLARE ConOtrosIngEgresos    	INT(11);
	DECLARE NumCliente        		INT(11);
	DECLARE Con_OtrasCtasRge    	INT(11);
	DECLARE For_OtrasCtsRegistro  	VARCHAR(60);
	DECLARE Des_ResulCtsRegistro  	VARCHAR(30);
	DECLARE Por_FinEjercicio    	CHAR(1);
	DECLARE Con_NO								CHAR(1);-- Constante NO

  DECLARE cur_Balance CURSOR FOR
    SELECT CuentaContable,  SaldoDeudor
      FROM TMPBALANZACONTA
      WHERE NumeroTransaccion = Aud_NumTransaccion
      ORDER BY CuentaContable;



	SET Entero_Cero     		:= 0;
	SET Cadena_Vacia    		:= '';
	SET Fecha_Vacia     		:= '1900-01-01';
	SET Est_Cerrado     		:= 'C';
	SET VarDeudora      		:= 'D';
	SET VarAcreedora    		:= 'A';
	SET Tip_Encabezado  		:= 'E';
	SET No_SaldoCeros   		:= 'N';
	SET Cifras_Pesos    		:= 'P';
	SET Cifras_Miles    		:= 'M';
	SET Por_Periodo    			:= 'P';
	SET Por_Fecha       		:= 'D';
	SET Ubi_Actual      		:= 'A';
	SET Ubi_Histor      		:= 'H';
	SET Por_FinEjercicio  		:= 'F';
	SET Tif_Balance     		:= 1;
	SET Con_ResulEfectivo   	:= 1;
	SET ConTotal_Cartera      	:= 4;
	SET ConTotal_CarteraNeto  	:= 6;
	SET ConReservaCapital   	:= 20;
	SET ConResulEjerAnteriores  := 21;
	SET ConResulPeriodo     	:= 26;
	SET ConOtrosIngEgresos    	:= 30;
	SET NumCliente        		:= 6;
	SET Con_OtrasCtasRge    	:= 23;
	SET Con_NO								:= 'N';

  SELECT FechaSistema,    EjercicioVigente, PeriodoVigente INTO
       Var_FechaSistema,  Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

  SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
  SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
  SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Periodo) THEN
        SET Par_TipoConsulta := Por_FinEjercicio;
    END IF;

  CALL TRANSACCIONESPRO(Aud_NumTransaccion);


  IF(Par_Fecha  != Fecha_Vacia AND Par_TipoConsulta=Por_Fecha ) THEN
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

  SELECT CuentaContable, Desplegado  INTO For_Efectivo, Des_ResulNeto
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = Con_ResulEfectivo
        AND NumClien = NumCliente;

  SET For_Efectivo   := IFNULL(For_Efectivo, Cadena_Vacia);
  SET Des_ResulNeto   := IFNULL(Des_ResulNeto, Cadena_Vacia);

    SELECT CuentaContable, Desplegado  INTO Total_Cartera, Des_Total_Cartera
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = ConTotal_Cartera
        AND NumClien = NumCliente;

  SET Total_Cartera     := IFNULL(Total_Cartera, Cadena_Vacia);
  SET Des_Total_Cartera   := IFNULL(Des_Total_Cartera, Cadena_Vacia);

    SELECT CuentaContable, Desplegado  INTO Total_CarteraNeto, Des_Total_CarNeto
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = ConTotal_CarteraNeto
        AND NumClien = NumCliente;

  SET Total_CarteraNeto   := IFNULL(Total_CarteraNeto, Cadena_Vacia);
  SET Des_Total_CarNeto   := IFNULL(Des_Total_CarNeto, Cadena_Vacia);

    SELECT CuentaContable, Desplegado  INTO ReservaCapital, Des_ReservaCapital
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = ConReservaCapital
        AND NumClien = NumCliente;

  SET ReservaCapital   := IFNULL(ReservaCapital, Cadena_Vacia);
  SET Des_ReservaCapital   := IFNULL(Des_ReservaCapital, Cadena_Vacia);

    SELECT CuentaContable, Desplegado  INTO ResulEjerAnteriores, Des_ResulEjerAnt
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = ConResulEjerAnteriores
        AND NumClien = NumCliente;

  SET ResulEjerAnteriores   := IFNULL(ResulEjerAnteriores, Cadena_Vacia);
  SET Des_ResulEjerAnt   := IFNULL(Des_ResulEjerAnt, Cadena_Vacia);

    SELECT CuentaContable, Desplegado  INTO ResulPeriodo, Des_ResulPeriodo
      FROM CONCEPESTADOSFIN
        WHERE EstadoFinanID = Tif_Balance
          AND ConceptoFinanID = ConResulPeriodo
          AND NumClien = NumCliente;

    SET ResulPeriodo   := IFNULL(ResulPeriodo, Cadena_Vacia);
    SET Des_ResulPeriodo   := IFNULL(Des_ResulPeriodo, Cadena_Vacia);

  SELECT CuentaContable, Desplegado  INTO OtrosIngEgresos, Des_OtrosIngEgresos
    FROM CONCEPESTADOSFIN
      WHERE EstadoFinanID = Tif_Balance
        AND ConceptoFinanID = ConOtrosIngEgresos
        AND NumClien = NumCliente;
  SET OtrosIngEgresos   := IFNULL(OtrosIngEgresos, Cadena_Vacia);
  SET Des_OtrosIngEgresos   := IFNULL(Des_OtrosIngEgresos, Cadena_Vacia);


  SELECT CuentaContable, Desplegado   INTO For_OtrasCtsRegistro, Des_ResulCtsRegistro
    FROM CONCEPESTADOSFIN
    WHERE EstadoFinanID = Tif_Balance
    AND ConceptoFinanID = Con_OtrasCtasRge
    AND NumClien = NumCliente;
    SET For_OtrasCtsRegistro   := IFNULL(For_OtrasCtsRegistro, Cadena_Vacia);
  SET Des_ResulCtsRegistro   := IFNULL(Des_ResulCtsRegistro, Cadena_Vacia);

  SELECT MAX(EjercicioID) INTO Var_UltEjercicioCie
    FROM PERIODOCONTABLE Per
    WHERE Per.Fin < Var_FecConsulta
      AND  Per.Estatus = Est_Cerrado;

  SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

  IF(Var_UltEjercicioCie != Entero_Cero) THEN
    SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
      FROM PERIODOCONTABLE Per
      WHERE Per.EjercicioID = Var_UltEjercicioCie
        AND Per.Estatus = Est_Cerrado
        AND Per.Fin <= Var_FecConsulta;
  END IF;

  SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);


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
            Entero_Cero, Entero_Cero

            FROM CUENTASCONTABLES Cue,
               SALDOSDETALLEPOLIZA AS Pol
            WHERE Pol.Fecha <= Par_Fecha
              AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
              AND Pol.CuentaCompleta = Cue.CuentaCompleta
            GROUP BY Cue.CuentaCompleta;

      IF( Par_Fecha = Var_FechaSistema ) THEN

    		DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

    		INSERT INTO TMPBALPOLCENCOSDIA (
    				NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
    		SELECT	Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
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

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
        SELECT  Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero, Entero_Cero,
             Entero_Cero, Entero_Cero,
             CASE WHEN Fin.Naturaleza = VarDeudora
              THEN
                 SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero))) -
                 SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero)))
              ELSE
                 SUM((IFNULL(Pol.SaldoAcreedor, Entero_Cero))) -
                 SUM((IFNULL(Pol.SaldoDeudor, Entero_Cero)))
             END,
             Entero_Cero,
             Fin.Desplegado, Cadena_Vacia, Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
            LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
            LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                               AND Pol.NumeroTransaccion  = Aud_NumTransaccion)

            WHERE Fin.EstadoFinanID = Tif_Balance
              AND Fin.EsCalculado = Con_NO
              AND NumClien = NumCliente
              GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado, Fin.Naturaleza;


      IF(For_Efectivo != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_Efectivo,      Ubi_Actual,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "Efectivo",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulNeto,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
      IF(Total_CarteraNeto != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            Total_CarteraNeto,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActCarteraNto",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_CarNeto,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(Total_Cartera != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            Total_Cartera,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActTotalCartCredito",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_Cartera,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(ReservaCapital != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            ReservaCapital,      Ubi_Actual,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "CapReserva",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ReservaCapital,
				Cadena_Vacia, Cadena_Vacia);

      END IF;
           IF(ResulEjerAnteriores != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          ResulEjerAnteriores,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "CapResulEjerAnt",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulEjerAnt,
				Cadena_Vacia, Cadena_Vacia);


      END IF;

      IF(ResulPeriodo != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          ResulPeriodo ,      Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulPeriodo,
				Cadena_Vacia, Cadena_Vacia);

      END IF;
            IF(OtrosIngEgresos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          OtrosIngEgresos ,   Ubi_Actual, Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "OtrosIngEgresos",  Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_OtrosIngEgresos,
				Cadena_Vacia, Cadena_Vacia);

      END IF;


      IF(For_OtrasCtsRegistro != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrasCtsRegistro, Ubi_Actual,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,    Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,      Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,       Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "OtrasCtasRge",   Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,    Par_AcumuladoCta,   Entero_Cero,    Des_ResulCtsRegistro,
				Cadena_Vacia,     Cadena_Vacia);
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

      IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

                INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
              Entero_Cero, Entero_Cero,
              MAX(Cue.Naturaleza),
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
              GROUP BY Cue.CuentaCompleta;

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

      UPDATE  TMPCONTABLE  TMP,CUENTASCONTABLES    Cue SET
        TMP.Naturaleza = Cue.Naturaleza
        WHERE Cue.CuentaCompleta = TMP.CuentaContable
          AND TMP.NumeroTransaccion = Aud_NumTransaccion;

      SET Var_Ubicacion   := Ubi_Actual;

      ELSE

        INSERT INTO TMPCONTABLE
          SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
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
          GROUP BY Cue.CuentaCompleta;

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
          AND Sal.FechaCorte    = Var_FechaSaldos
          AND Sal.CuentaCompleta = Tmp.CuentaContable
          AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
          GROUP BY Sal.CuentaCompleta ;

        UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
          Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
          Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
          WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
            AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
            AND Tmp.CuentaContable    = Sal.CuentaContable;



      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
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
          Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin

        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                            AND Pol.Fecha = Var_FechaSistema
                            AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Naturaleza, Fin.Descripcion;
      IF(For_Efectivo != Cadena_Vacia) THEN

        CALL `EVALFORMULACONTAPRO`(
          For_Efectivo,      Var_Ubicacion, Por_Fecha,          Par_Fecha,      Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,   Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "Efectivo",       Cadena_Vacia,     Entero_Cero,  Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,  Des_ResulNeto,
				Cadena_Vacia, Cadena_Vacia);

      END IF;

        IF(Total_CarteraNeto != Cadena_Vacia) THEN

          CALL `EVALFORMULACONTAPRO`(
            Total_CarteraNeto,      Var_Ubicacion,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActCarteraNto",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_CarNeto,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(Total_Cartera != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            Total_Cartera,      Var_Ubicacion,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActTotalCartCredito",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_Cartera,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(ReservaCapital != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            ReservaCapital,      Var_Ubicacion,   Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "CapReserva",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ReservaCapital,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(ResulEjerAnteriores != Cadena_Vacia) THEN
          CALL `EVALFORMULACONTAPRO`(
            ResulEjerAnteriores,      Var_Ubicacion,    Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
            Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
            Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "CapResulEjerAnt",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulEjerAnt,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
        IF(ResulPeriodo != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          ResulPeriodo ,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulPeriodo,
				Cadena_Vacia, Cadena_Vacia);


      END IF;
            IF(OtrosIngEgresos != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          OtrosIngEgresos ,   Var_Ubicacion,  Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "OtrosIngEgresos",  Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_OtrosIngEgresos,
				Cadena_Vacia, Cadena_Vacia);

      END IF;


              IF(For_OtrasCtsRegistro != Cadena_Vacia) THEN
        CALL `EVALFORMULACONTAPRO`(
          For_OtrasCtsRegistro ,   Var_Ubicacion, Por_Fecha,          Par_Fecha,        Var_UltEjercicioCie,
          Var_UltPeriodoCie,  Par_Fecha,    Par_AcumuladoCta, Par_CCInicial,    Par_CCFinal,
          Par_EmpresaID,    Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,     Aud_NumTransaccion);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "OtrasCtasRge", Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulCtsRegistro,
				Cadena_Vacia, Cadena_Vacia);
        END IF;

    END IF;

  ELSEIF(Par_TipoConsulta = Por_Periodo) THEN
    INSERT INTO TMPCONTABLE
      SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
          Entero_Cero, Entero_Cero,
          MAX(Cue.Naturaleza),
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
            GROUP BY Cue.CuentaCompleta;


    INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
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
           Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
        FROM CONCEPESTADOSFIN Fin
        LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

          LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                          AND Pol.Fecha = Var_FechaSistema
                          AND Pol.NumeroTransaccion = Aud_NumTransaccion)

        WHERE Fin.EstadoFinanID = Tif_Balance
          AND Fin.EsCalculado = Con_NO
          AND NumClien = NumCliente
          GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;


      IF(For_Efectivo != Cadena_Vacia) THEN
        CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  For_Efectivo  ,    'H',    'F',  Var_FecConsulta );

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "Efectivo",       Cadena_Vacia,     Entero_Cero,  Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,  Des_ResulNeto,
				Cadena_Vacia, Cadena_Vacia);

      END IF;

      IF(Total_CarteraNeto != Cadena_Vacia) THEN
                CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  Total_CarteraNeto  ,    'H',    'F',  Var_FecConsulta );

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActCarteraNto",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_CarNeto,
				Cadena_Vacia, Cadena_Vacia);


      END IF;

      IF(Total_Cartera != Cadena_Vacia) THEN
               CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  Total_Cartera  ,    'H',    'F',  Var_FecConsulta );

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "ActTotalCartCredito",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_Cartera,
				Cadena_Vacia, Cadena_Vacia);


      END IF;

      IF(ReservaCapital != Cadena_Vacia) THEN
                CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  ReservaCapital  ,    'H',    'F',  Var_FecConsulta );

                INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
				VALUES(
						Aud_NumTransaccion, "CapReserva",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
						Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ReservaCapital,
						Cadena_Vacia, Cadena_Vacia);


      END IF;

      IF(ResulEjerAnteriores != Cadena_Vacia) THEN
                CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  ResulEjerAnteriores  ,    'H',    'F',  Var_FecConsulta );

      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
	VALUES(
			Aud_NumTransaccion, "CapResulEjerAnt",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
			Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulEjerAnt,
			Cadena_Vacia, Cadena_Vacia);
      END IF;

      IF(ResulPeriodo != Cadena_Vacia) THEN
        CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  ResulPeriodo  ,    'H',    'F',  Var_FecConsulta );

                INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
				VALUES(
						Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
						Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulPeriodo,
						Cadena_Vacia, Cadena_Vacia);
      END IF;

            IF(OtrosIngEgresos != Cadena_Vacia) THEN

            CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  OtrosIngEgresos  ,    'H',    'F',  Var_FecConsulta );

            INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "OtrosIngEgresos",  Cadena_Vacia,     Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_OtrosIngEgresos,
					Cadena_Vacia, Cadena_Vacia);

      END IF;

            IF(For_OtrasCtsRegistro != Cadena_Vacia) THEN
                CALL EVALFORMULAREGPRO(Par_AcumuladoCta,  For_OtrasCtsRegistro  ,    'H',    'F',  Var_FecConsulta );

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "OtrasCtasRge", Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulCtsRegistro,
				Cadena_Vacia, Cadena_Vacia);
        END IF;

  END IF;

  IF(Par_TipoConsulta = Por_FinEjercicio) THEN
    SET Par_Periodo := (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE ejercicioID =Par_Ejercicio);
    INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
            Entero_Cero, Entero_Cero,
            MAX(Cue.Naturaleza),
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
              GROUP BY Cue.CuentaCompleta;


      INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
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
             Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
          FROM CONCEPESTADOSFIN Fin
          LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

            LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
                            AND Pol.Fecha = Var_FechaSistema
                            AND Pol.NumeroTransaccion = Aud_NumTransaccion)

          WHERE Fin.EstadoFinanID = Tif_Balance
            AND Fin.EsCalculado = Con_NO
            AND NumClien = NumCliente
            GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion, Fin.Naturaleza;

        IF(For_Efectivo != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  For_Efectivo, 'H',  'F',  Var_FecConsulta);

          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "Efectivo",       Cadena_Vacia,     Entero_Cero,  Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,  Des_ResulNeto,
					Cadena_Vacia, Cadena_Vacia);

        END IF;

        IF(Total_CarteraNeto != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  Total_CarteraNeto,  'H',  'F',  Var_FecConsulta);

          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "ActCarteraNto",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_CarNeto,
					Cadena_Vacia, Cadena_Vacia);


        END IF;
        IF(Total_Cartera != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  Total_Cartera,  'H',  'F',  Var_FecConsulta);


          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "ActTotalCartCredito",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_Total_Cartera,
					Cadena_Vacia, Cadena_Vacia);


        END IF;
        IF(ReservaCapital != Cadena_Vacia) THEN
        CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  ReservaCapital, 'H',  'F',  Var_FecConsulta);

        INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		VALUES(
				Aud_NumTransaccion, "CapReserva",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
				Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ReservaCapital,
				Cadena_Vacia, Cadena_Vacia);


        END IF;
          IF(ResulEjerAnteriores != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  ResulEjerAnteriores,  'H',  'F',  Var_FecConsulta);

          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "CapResulEjerAnt",       Cadena_Vacia,    Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulEjerAnt,
					Cadena_Vacia, Cadena_Vacia);


        END IF;
        IF(ResulPeriodo != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  ResulPeriodo, 'H',  'F',  Var_FecConsulta);

          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "ResultNeto",       Cadena_Vacia,     Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulPeriodo,
					Cadena_Vacia, Cadena_Vacia);


        END IF;
        IF(OtrosIngEgresos != Cadena_Vacia) THEN
          CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  OtrosIngEgresos,  'H',  'F',  Var_FecConsulta);

          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "OtrosIngEgresos",  Cadena_Vacia,     Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_OtrosIngEgresos,
					Cadena_Vacia, Cadena_Vacia);

        END IF;


          IF(For_OtrasCtsRegistro != Cadena_Vacia) THEN
            CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,  For_OtrasCtsRegistro, 'H',  'F',  Var_FecConsulta);


          INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			VALUES(
					Aud_NumTransaccion, "OtrasCtasRge", Cadena_Vacia,     Entero_Cero,    Entero_Cero,
					Entero_Cero,    Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Des_ResulCtsRegistro,
					Cadena_Vacia, Cadena_Vacia);
          END IF;

  END IF;

  IF(Par_Cifras = Cifras_Miles) THEN

    UPDATE TMPBALANZACONTA SET
      SaldoDeudor     = ROUND(SaldoDeudor/1000, 2)
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
