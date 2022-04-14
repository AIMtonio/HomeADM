
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNO009REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNO009REP`;
DELIMITER $$

CREATE PROCEDURE `BALANCEINTERNO009REP`(
/*SP para obtener el balance general*/
    Par_Ejercicio       INT(11),	-- Ejercicio a consultar
    Par_Periodo         INT(11),	-- Periodo de Consulta
    Par_Fecha           DATE,		-- Fecha de Consulta
    Par_TipoConsulta    CHAR(1),	-- tipo de consulta a realizar
    Par_SaldosCero      CHAR(1),	-- con saldo ceros

    Par_Cifras          CHAR(1),	-- Indica si se va a mostrar en pesos redondeado a miles
    Par_CCInicial       INT(11),	-- Centro de Costo Inicial
    Par_CCFinal         INT(11),	-- Centro de Costo Final
    Par_EmpresaID       INT(11),	-- Parametro de auditoria
    Aud_Usuario         INT(11),	-- Parametro de auditoria

    Aud_FechaActual     DATETIME,	-- Parametro de auditoria
    Aud_DireccionIP     VARCHAR(15),-- Parametro de auditoria
    Aud_ProgramaID      VARCHAR(50),-- Parametro de auditoria
    Aud_Sucursal        INT(11),	-- Parametro de auditoria
    Aud_NumTransaccion  BIGINT(20)	-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_FecConsulta     DATE;			-- Fecha de consulta
    DECLARE Var_FechaSistema    DATE;			-- Fecha de Sistema
    DECLARE Var_FechaSaldos     DATE;			-- Fecha Saldos
    DECLARE Var_EjeCon          INT(11);		-- Contador Ejercicio
    DECLARE Var_PerCon          INT(11);		-- Contador Periodo
    DECLARE Var_FecIniPer       DATE;			-- Fecha Inicio Periodo
    DECLARE Var_FecFinPer       DATE;			-- fecha Fin Periodo
    DECLARE Var_EjercicioVig    INT(11);		-- Ejercicio Vigente
    DECLARE Var_PeriodoVig      INT(11);		-- Periodo Vigente
    DECLARE For_ResulNeto       VARCHAR(500);	-- Resultado Neto
    DECLARE Par_AcumuladoCta    DECIMAL(18,2);	-- Acomulado Cuenta
    DECLARE Des_ResulNeto       VARCHAR(200);	-- resultado Neto
    DECLARE Var_Ubicacion       CHAR(1);		-- Ubicacion
    DECLARE Por_FinPeriodo      CHAR(1);		-- Fin Periodo

    DECLARE Var_Columna         VARCHAR(20);	-- Columna
    DECLARE Var_Monto           DECIMAL(18,2);	-- Monto
    DECLARE Var_NombreTabla     VARCHAR(40);	-- Nombre tabla
    DECLARE Var_CreateTable     VARCHAR(9000);	-- Creacion Tabla
    DECLARE Var_InsertTable     VARCHAR(5000);	-- Insert Tabla
    DECLARE Var_InsertValores   VARCHAR(5000);	-- Insert de Valores
    DECLARE Var_SelectTable     VARCHAR(5000);	-- Select a la tabla
    DECLARE Var_DropTable       VARCHAR(5000);	-- Eliminacion de tabla
    DECLARE Var_AuxColumna		VARCHAR(5000);
    DECLARE Var_CantCaracteres  INT(11);		-- Concadenacion
    DECLARE Var_UltPeriodoCie   INT(11);		-- Ultimo Periodo Cierre
    DECLARE Var_UltEjercicioCie INT(11);		-- Ultimo Ejercicio Cierre

    DECLARE Var_MinCenCos   	INT(11);		-- Minimo Centro de Costos
    DECLARE Var_MaxCenCos   	INT(11);		-- maximo Centro de Costos

	-- DECLARACION DE CONSTANTES
    DECLARE Entero_Cero     	INT(11);		-- Entero Cero
    DECLARE Cadena_Vacia    	CHAR(1);		-- Cadena Vacia
    DECLARE Est_Cerrado     	CHAR(1);		-- Estatus Cerrado
    DECLARE Fecha_Vacia     	DATE;			-- Fecha Vacia
    DECLARE VarDeudora      	CHAR(1);		-- Deudora
    DECLARE VarAcreedora    	CHAR(1);		-- Acredora
    DECLARE Tip_Encabezado  	CHAR(1);		-- Encabezado
    DECLARE No_SaldoCeros   	CHAR(1);		-- Saldos Ceros
    DECLARE Cifras_Pesos    	CHAR(1);		-- Cifras Pesos
    DECLARE Cifras_Miles    	CHAR(1);		-- Cifras Miles
    DECLARE Por_Peridodo    	CHAR(1);		-- Por Periodo
    DECLARE Por_Fecha       	CHAR(1);		-- Por Fecha
    DECLARE Ubi_Actual      	CHAR(1);		-- Ubicacion Actual
    DECLARE Ubi_Histor      	CHAR(1);		-- Ubicacion Historica
    DECLARE Tif_Balance     	INT(11);		-- Balance
    DECLARE Con_ResulNeto   	INT(11);		-- Resultado Neto
    DECLARE NumCliente      	INT(11);		-- Numero Cliente

#     DECLARE Con_General INT(11);
    DECLARE Var_CuentaContable 	VARCHAR(300);	-- Cuenta Contable
    DECLARE Var_NombreCampo 	VARCHAR(200);	-- Nombre Campo
    DECLARE Var_Desplegado		VARCHAR(200);	-- Desplegado

    DECLARE Contador_Conceptos 	INT(11);		-- Contador Conceptos
    DECLARE Numero_Conceptos 	INT(11);		-- Numero Conceptos


    DECLARE cur_Balance CURSOR FOR
        SELECT CuentaContable,  SaldoDeudor
        FROM TMPBALANZACONTA
        WHERE NumeroTransaccion = Aud_NumTransaccion
        ORDER BY CuentaContable;

    CALL TRANSACCIONESPRO(Aud_NumTransaccion);

    # La tabla TMPCONCEPTOS es la que se usara para recorrer los conceptos financieros que se usaran
    DROP TABLE IF EXISTS TMPCONCEPTOS;
    CREATE TEMPORARY TABLE TMPCONCEPTOS(
        ConceptoID INT(11) AUTO_INCREMENT,
        CuentaContable VARCHAR(500),
        NombreCampo VARCHAR(20),
        Desplegado VARCHAR(300),
        NumeroTransaccion bigint(20),
            PRIMARY KEY(ConceptoID)
        );

    INSERT INTO TMPCONCEPTOS(CuentaContable, NombreCampo, Desplegado, NumeroTransaccion)
        SELECT  CuentaContable, NombreCampo, Desplegado, Aud_NumTransaccion
        FROM CONCEPESTADOSFIN
        WHERE NumClien = 9 AND EstadoFinanID = 1;

	-- ASIGNACION DE CONSTANTES
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
    SET Con_ResulNeto   := 48;
    SET NumCliente      := 9;
    SET Por_FinPeriodo  := 'F';

    SELECT FechaSistema,        EjercicioVigente, PeriodoVigente INTO
        Var_FechaSistema,   Var_EjercicioVig, Var_PeriodoVig
    FROM PARAMETROSSIS;

    SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
    SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
    SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);


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


    SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
    FROM PERIODOCONTABLE Per
    WHERE Per.Fin   <= Var_FecConsulta  -- T_15030 by hussein chan
      AND Per.Estatus = Est_Cerrado;

    SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

    IF(Var_UltEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
        FROM PERIODOCONTABLE Per
        WHERE Per.EjercicioID   = Var_UltEjercicioCie
          AND Per.Estatus = Est_Cerrado
          AND Per.Fin   <= Var_FecConsulta;  -- T_15030 by hussein chan
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

#             Recorrer los conceptos financieros que se usaran para el balance
            SELECT MIN(ConceptoID), MAX(ConceptoID) INTO Contador_Conceptos, Numero_Conceptos
            FROM TMPCONCEPTOS
            WHERE NumeroTransaccion = Aud_NumTransaccion;

            WHILE (Contador_Conceptos <= Numero_Conceptos) DO
                SELECT CuentaContable, NombreCampo, Desplegado INTO Var_CuentaContable, Var_NombreCampo, Var_Desplegado
                FROM TMPCONCEPTOS
                WHERE NumeroTransaccion = Aud_NumTransaccion AND ConceptoID = Contador_Conceptos;

                SET Var_CuentaContable      := IFNULL(Var_CuentaContable, Cadena_Vacia);
                SET Var_NombreCampo      := IFNULL(Var_NombreCampo, Cadena_Vacia);
                SET Var_Desplegado      := IFNULL(Var_Desplegado, Cadena_Vacia);

                IF (Var_NombreCampo != Cadena_Vacia AND Var_Desplegado != Cadena_Vacia) THEN
					IF(Var_CuentaContable!=Cadena_Vacia AND Var_CuentaContable!="NA")THEN
						CALL `EVALFORMULACONTAPRO`(
								Var_CuentaContable,      Ubi_Histor,        Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
								Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
								Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion);
					ELSE
						SET Par_AcumuladoCta := 0;
					END IF;

                    INSERT INTO TMPBALANZACONTA (
                        NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre,
                        Cargos, Abonos, SaldoDeudor,SaldoAcreedor, DescripcionCuenta,
                        CuentaMayor, CentroCosto)
                        VALUES(
                             Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                             Entero_Cero,       Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Var_Desplegado,
                             Cadena_Vacia, Cadena_Vacia);

                END IF;
                SET Contador_Conceptos := Contador_Conceptos + 1;
            END WHILE;
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
                SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
                        Entero_Cero, Entero_Cero,
                        (Cue.Naturaleza),
                        CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                     SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
                                     SUM((IFNULL(Pol.Abonos, Entero_Cero)))
                             ELSE
                                 Entero_Cero
                            END,
                        CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                     SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
                                     SUM((IFNULL(Pol.Cargos, Entero_Cero)))
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
            GROUP BY Sal.CuentaCompleta ;


            UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
                Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
                Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
            WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
              AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
              AND Tmp.CuentaContable = Sal.CuentaContable;

            SELECT MIN(ConceptoID), MAX(ConceptoID) INTO Contador_Conceptos, Numero_Conceptos
            FROM TMPCONCEPTOS
            WHERE NumeroTransaccion = Aud_NumTransaccion;

            WHILE (Contador_Conceptos <= Numero_Conceptos) DO
                SELECT CuentaContable, NombreCampo, Desplegado INTO Var_CuentaContable, Var_NombreCampo, Var_Desplegado
                FROM TMPCONCEPTOS
                WHERE NumeroTransaccion = Aud_NumTransaccion AND ConceptoID = Contador_Conceptos;


                SET Var_CuentaContable      := IFNULL(Var_CuentaContable, Cadena_Vacia);
                SET Var_NombreCampo      := IFNULL(Var_NombreCampo, Cadena_Vacia);
                SET Var_Desplegado      := IFNULL(Var_Desplegado, Cadena_Vacia);

                IF (Var_NombreCampo != Cadena_Vacia AND Var_Desplegado != Cadena_Vacia) THEN

                    IF(Var_CuentaContable!=Cadena_Vacia AND Var_CuentaContable!="NA")THEN
						CALL `EVALFORMULAPERIFINPRO`(Par_AcumuladoCta,  Var_CuentaContable, 'H',  'F',  Par_Fecha );  -- T_15030 by hussein chan

					ELSE
						SET Par_AcumuladoCta := 0;
					END IF;

                    INSERT INTO TMPBALANZACONTA (
                        NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre,
                        Cargos, Abonos, SaldoDeudor,SaldoAcreedor, DescripcionCuenta,
                        CuentaMayor, CentroCosto)
                    VALUES(
                              Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
                              Entero_Cero,       Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Var_Desplegado,
                              Cadena_Vacia, Cadena_Vacia);

                END IF;
                SET Contador_Conceptos := Contador_Conceptos + 1;

            END WHILE;

        END IF;


    ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

        INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
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

        SELECT MIN(ConceptoID), MAX(ConceptoID) INTO Contador_Conceptos, Numero_Conceptos
        FROM TMPCONCEPTOS
        WHERE NumeroTransaccion = Aud_NumTransaccion;

        WHILE (Contador_Conceptos <= Numero_Conceptos) DO
                SELECT CuentaContable, NombreCampo, Desplegado INTO Var_CuentaContable, Var_NombreCampo, Var_Desplegado
                FROM TMPCONCEPTOS
                WHERE NumeroTransaccion = Aud_NumTransaccion AND ConceptoID = Contador_Conceptos;

                SET Var_CuentaContable      := IFNULL(Var_CuentaContable, Cadena_Vacia);
                SET Var_NombreCampo      := IFNULL(Var_NombreCampo, Cadena_Vacia);
                SET Var_Desplegado      := IFNULL(Var_Desplegado, Cadena_Vacia);

                IF (Var_NombreCampo != Cadena_Vacia AND Var_Desplegado != Cadena_Vacia) THEN
					IF(Var_CuentaContable!=Cadena_Vacia AND Var_CuentaContable!="NA")THEN
						CALL `EVALFORMULACONTAPRO`(
								Var_CuentaContable,      Ubi_Actual,        Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
								Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
								Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion);
					ELSE
						SET Par_AcumuladoCta := 0;
					END IF;

					INSERT INTO TMPBALANZACONTA (
						NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre,
						Cargos, Abonos, SaldoDeudor,SaldoAcreedor, DescripcionCuenta,
						CuentaMayor, CentroCosto)
					VALUES(
							  Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
							  Entero_Cero,       Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Var_Desplegado,
							  Cadena_Vacia, Cadena_Vacia);

                END IF;
                SET Contador_Conceptos := Contador_Conceptos + 1;
            END WHILE;

    END IF;

    #*******************************CONSULTA POR FIN DE PERIODO**************************** */

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


        SELECT  Fin INTO Var_FecConsulta
        FROM PERIODOCONTABLE
        WHERE EjercicioID   = Par_Ejercicio
          AND PeriodoID     = Par_Periodo;

        SELECT MIN(ConceptoID), MAX(ConceptoID) INTO Contador_Conceptos, Numero_Conceptos
        FROM TMPCONCEPTOS;

        WHILE (Contador_Conceptos <= Numero_Conceptos) DO
                SELECT CuentaContable, NombreCampo, Desplegado INTO Var_CuentaContable, Var_NombreCampo, Var_Desplegado
                FROM TMPCONCEPTOS
                WHERE NumeroTransaccion = Aud_NumTransaccion AND ConceptoID = Contador_Conceptos;

                SET Var_CuentaContable      := IFNULL(Var_CuentaContable, Cadena_Vacia);
                SET Var_NombreCampo      := IFNULL(Var_NombreCampo, Cadena_Vacia);
                SET Var_Desplegado      := IFNULL(Var_Desplegado, Cadena_Vacia);

                IF (Var_NombreCampo != Cadena_Vacia AND Var_Desplegado != Cadena_Vacia) THEN

                    IF(Var_CuentaContable!=Cadena_Vacia AND Var_CuentaContable!="NA")THEN
						CALL `EVALFORMULACONTAPRO`(
								Var_CuentaContable,      Ubi_Actual,        Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
								Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
								Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion);
					ELSE
						SET Par_AcumuladoCta := 0;
                    END IF;

					INSERT INTO TMPBALANZACONTA (
						NumeroTransaccion, CuentaContable, Grupo, SaldoInicialDeu, SaldoInicialAcre,
						Cargos, Abonos, SaldoDeudor,SaldoAcreedor, DescripcionCuenta,
						CuentaMayor, CentroCosto)
					VALUES(
							  Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,       Entero_Cero,    Entero_Cero,
							  Entero_Cero,       Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Var_Desplegado,
							  Cadena_Vacia, Cadena_Vacia);

                END IF;
                SET Contador_Conceptos := Contador_Conceptos + 1;
            END WHILE;

    END IF;

    #TERMINA CONSULTA POR FIN DE PERIODO


    IF(Par_Cifras = Cifras_Miles) THEN

        UPDATE TMPBALANZACONTA SET
            SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
        WHERE NumeroTransaccion = Aud_NumTransaccion;

    END IF;

    DROP TABLE IF EXISTS TMPCONCEPTOS;

    SET Var_NombreTabla     := CONCAT("tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR));

    SET Var_CreateTable     := CONCAT( "CREATE temporary TABLE ", Var_NombreTabla,
                                       " (");

    SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

    SET Var_InsertValores   := ' VALUES( ';

    SET Var_SelectTable     := CONCAT(" SELECT *  FROM ", Var_NombreTabla, " ; ");

    SET Var_DropTable       := CONCAT(" DROP TABLE IF EXISTS ", Var_NombreTabla, "; ");

    SET Var_AuxColumna := "";

    SET Var_CantCaracteres := 0;

    IF IFNULL(Aud_NumTransaccion, Entero_Cero) > Entero_Cero THEN

        OPEN  cur_Balance;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP
                FETCH cur_Balance  INTO     Var_Columna, Var_Monto;

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
