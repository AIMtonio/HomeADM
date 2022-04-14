-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEDISPEVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEDISPEVAL`;
DELIMITER $$


CREATE PROCEDURE `BALANCEDISPEVAL`(
/*Store especifico de CONSOL*/
	Par_Ejercicio       INT(11),			-- Ejercicio contable
	Par_Periodo         INT(11),			-- periodo del ejercicio
	Par_Fecha           DATE, 			-- fecha actual
	Par_TipoConsulta    CHAR(1), 		-- tipo de consulta
	Par_SaldosCero      CHAR(1), 		-- cifras en ceros si o no

	Par_Cifras          CHAR(1), 		-- 	moneda
	Par_CCInicial		INT(11),			-- sucursal inicial
	Par_CCFinal			INT(11),			-- sucursal final
    OUT Par_Cajas		DECIMAL(14,2),		-- Monto Cajas
    OUT Par_Bancos		DECIMAL(14,2),		-- Monto Bancos
    OUT Par_CajasMicro	DECIMAL(14,2),		-- Monto Cajas Micro
    OUT Par_TituloNeg	DECIMAL(14,2),		-- Monto Negocio
	Par_EmpresaID       INT(11),			-- parametro de auditoria
	Aud_Usuario         INT(11),			-- parametro de auditoria

/*Parametros de Auditoria*/
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
		)

TerminaStore: BEGIN

	/*Declaracionde variables*/
	DECLARE Var_FecConsulta		DATE;			-- fecha de consulta
	DECLARE Var_FechaSistema	DATE;			-- fecha del sistema
	DECLARE Var_FechaSaldos		DATE;			-- fecha de los saldos
	DECLARE Var_EjeCon     		INT(11);			--
	DECLARE Var_PerCon      	INT(11);			--
	DECLARE Var_FecIniPer   	DATE;			-- fecha inicla del perido
	DECLARE Var_FecFinPer   	DATE;			-- fecha final del periodo
	DECLARE Var_EjercicioVig	INT(11);			-- ejercico vigente
	DECLARE Var_PeriodoVig		INT(11);			-- perido vigente
	DECLARE For_VigCredAvio    	VARCHAR(500);
	DECLARE For_VigCredRefa    	VARCHAR(500);
	DECLARE For_VigCredArrenda  VARCHAR(500);
	DECLARE For_VigMicrocreditos VARCHAR(500);
	DECLARE For_VencCredAvio    VARCHAR(500);
	DECLARE For_VencCredRefa    VARCHAR(500);
	DECLARE For_VencCredArrenda   VARCHAR(500);
	DECLARE For_VencMicrocreditos    VARCHAR(500);
	DECLARE For_PrestaBancAvio    VARCHAR(500);
	DECLARE For_PrestaBancRefa    VARCHAR(500);
	DECLARE For_PrestaBancArrenda    VARCHAR(500);
	DECLARE For_PrestamosFira    VARCHAR(500);
	DECLARE For_ERIntCarteraCredito    VARCHAR(500);
	DECLARE For_EROtrosProductos    VARCHAR(500);
	DECLARE For_ERInterAfecPagAvio    VARCHAR(500);
	DECLARE For_ERInterAfecPagRefa    VARCHAR(500);
	DECLARE For_ERInterAfecPagArrend    VARCHAR(500);
	DECLARE Par_AcumuladoCta    DECIMAL(14,2);
	DECLARE Des_VigCredAvio   VARCHAR(200);
	DECLARE Des_VigCredRefa   VARCHAR(200);
	DECLARE Des_VigCredArrenda   VARCHAR(200);
	DECLARE Des_VigMicrocreditos   VARCHAR(200);
	DECLARE Des_VencCredAvio   VARCHAR(200);
	DECLARE Des_VencCredRefa   VARCHAR(200);
	DECLARE Des_VencCredArrenda   VARCHAR(200);
	DECLARE Des_VencMicrocreditos   VARCHAR(200);
	DECLARE Des_PrestaBancAvio   VARCHAR(200);
	DECLARE Des_PrestaBancRefa   VARCHAR(200);
	DECLARE Des_PrestaBancArrenda   VARCHAR(200);
	DECLARE Des_PrestamosFira   VARCHAR(200);
	DECLARE Des_ERIntCarteraCredito   VARCHAR(200);
	DECLARE Des_EROtrosProductos   VARCHAR(200);
	DECLARE Des_ERInterAfecPagAvio   VARCHAR(200);
	DECLARE Des_ERInterAfecPagRefa   VARCHAR(200);
	DECLARE Des_ERInterAfecPagArrend   VARCHAR(200);
	DECLARE Var_Ubicacion   CHAR(1);

	DECLARE Var_Columna 		VARCHAR(20);	-- variable para guardar el nombre de la columna
	DECLARE Var_Monto			DECIMAL(18,2);	-- variable para guardar el valor de la columna
	DECLARE Var_NombreTabla     VARCHAR(40);	-- variable para el nombre de la tabal temporal
	DECLARE Var_CreateTable     VARCHAR(9000);	-- variable que guardara la consulta para rear la tabla
	DECLARE Var_InsertTable     VARCHAR(5000);	-- variable que guardara los insert en la tabla
	DECLARE Var_InsertValores   VARCHAR(5000);	-- variabale que guardara los valores a insertar
	DECLARE Var_SelectTable     VARCHAR(5000);	-- variabale para el select a la tabla
	DECLARE Var_DropTable       VARCHAR(5000);	-- variabla paa eliminar la tabla
	DECLARE Var_CantCaracteres	INT(11);			-- variable pivote para saber si llevara coma o espacio
	DECLARE Var_UltPeriodoCie   INT(11);			-- ultimo periodo
	DECLARE Var_UltEjercicioCie INT(11);			-- ultimo ejercico

	DECLARE Var_MinCenCos	INT;
	DECLARE Var_MaxCenCos	INT;
	/*Declaracionde constantes*/
    DECLARE Entero_Cero    	 		INT(11);			-- constante con valor cero
	DECLARE Cadena_Vacia    		CHAR(1);		-- constante cadena vacia
	DECLARE Est_Cerrado   	  		CHAR(1);		-- constante valor 'c'
	DECLARE Fecha_Vacia   	  		DATE;			-- constante con valor para fechas vacias
	DECLARE VarDeudora      		CHAR(1);		-- constante para saber que tipo de movimiento si es deudora
	DECLARE VarAcreedora    		CHAR(1);		-- constante para saber que tipo de movimiento si es acredora
	DECLARE Tip_Encabezado  		CHAR(1);		-- constante sin uso
	DECLARE No_SaldoCeros   		CHAR(1);		-- constante pra saber si llevara valores cero o no
	DECLARE Cifras_Pesos    		CHAR(1);		-- constate para saber si seran representados en pesos
	DECLARE Cifras_Miles    		CHAR(1);		-- constate para saber si seran representados en en miles
	DECLARE Por_Peridodo    CHAR(1);
	DECLARE Por_Fecha     	  		CHAR(1);		-- constate para saber si sera un balance por fecha
	DECLARE Ubi_Actual    	  		CHAR(1);		-- constante valor 'A'
	DECLARE Ubi_Histor    	  		CHAR(1);		-- constante valor 'H'
	DECLARE Tif_Balance     		INT(11);			-- tipo de balance
	DECLARE Con_VigCredAvio   INT;
	DECLARE Con_VigCredRefa   INT;
	DECLARE Con_VigCredArrenda   INT;
	DECLARE Con_VigMicrocreditos   INT;
	DECLARE Con_VencCredAvio   INT;
	DECLARE Con_VencCredRefa   INT;
	DECLARE Con_VencCredArrenda   INT;
	DECLARE Con_VencMicrocreditos   INT;
	DECLARE Con_PrestaBancAvio   INT;
	DECLARE Con_PrestaBancRefa   INT;
	DECLARE Con_PrestaBancArrenda   INT;
	DECLARE Con_PrestamosFira   INT;
	DECLARE Con_ERIntCarteraCredito   INT;
	DECLARE Con_EROtrosProductos   INT;
	DECLARE Con_ERInterAfecPagAvio   INT;
	DECLARE Con_ERInterAfecPagRefa   INT;
	DECLARE Con_ERInterAfecPagArrend   INT;
	DECLARE NumCliente		INT;
	DECLARE Por_FinPeriodo  CHAR(1);

	DECLARE cur_Balance CURSOR FOR
		SELECT CuentaContable,	SaldoDeudor
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
	SET Con_VigCredAvio   := 7;
	SET Con_VigCredRefa   := 8;
	SET Con_VigCredArrenda   := 9;
	SET Con_VigMicrocreditos   := 10;
	SET Con_VencCredAvio   := 11;
	SET Con_VencCredRefa   := 12;
	SET Con_VencCredArrenda   := 13;
	SET Con_VencMicrocreditos   := 14;
	SET Con_PrestaBancAvio   := 56;
	SET Con_PrestaBancRefa   := 57;
	SET Con_PrestaBancArrenda   := 58;
	SET Con_PrestamosFira   := 60;
	SET Con_ERIntCarteraCredito   := 85;
	SET Con_EROtrosProductos   := 92;
	SET Con_ERInterAfecPagAvio   := 95;
	SET Con_ERInterAfecPagRefa   := 96;
	SET Con_ERInterAfecPagArrend   := 97;
	SET NumCliente		:= 10;
	SET Por_FinPeriodo  := 'F';

	SELECT FechaSistema, 		EjercicioVigente, PeriodoVigente INTO
		   Var_FechaSistema,	Var_EjercicioVig, Var_PeriodoVig
		FROM PARAMETROSSIS;

	SET Par_Fecha           = IFNULL(Par_Fecha, Fecha_Vacia);
	SET Var_EjercicioVig    = IFNULL(Var_EjercicioVig, Entero_Cero);
	SET Var_PeriodoVig      = IFNULL(Var_PeriodoVig, Entero_Cero);

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	IF(Par_Fecha!= Fecha_Vacia) THEN
		SET Var_FecConsulta = Par_Fecha;
	ELSE
		SELECT Fin INTO Var_FecConsulta
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
		WHERE Per.Fin   < Var_FecConsulta
		  AND Per.Estatus = Est_Cerrado;

	SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

	IF(Var_UltEjercicioCie != Entero_Cero) THEN
		SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
			FROM PERIODOCONTABLE Per
			WHERE Per.EjercicioID	= Var_UltEjercicioCie
			  AND Per.Estatus = Est_Cerrado
			  AND Per.Fin	< Var_FecConsulta;
	END IF;

	SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

    IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo) THEN
		SET Par_TipoConsulta := Por_FinPeriodo;
	END IF;

	IF (Par_TipoConsulta = Por_Fecha) THEN

		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
			FROM  SALDOSCONTABLES
			WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos	= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		IF (Var_FechaSaldos = Fecha_Vacia) THEN

			INSERT INTO TMPCONTABLE
				SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta,	Entero_Cero,
						Entero_Cero, Entero_Cero,
						MAX(Cue.Naturaleza),
						CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
								SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
								SUM((IFNULL(Pol.Abonos, Entero_Cero)))
								 ELSE
							  Entero_Cero
						END,
						CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
								SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
								SUM((IFNULL(Pol.Cargos, Entero_Cero)))
								 ELSE
							  Entero_Cero
						END,
						Entero_Cero, Entero_Cero

						FROM CUENTASCONTABLES Cue,
							 DETALLEPOLIZA AS Pol
						WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
						  AND Pol.Fecha             <= Par_Fecha
						  AND Pol.CentroCostoID >= Par_CCInicial
						  AND Pol.CentroCostoID <= Par_CCFinal
						GROUP BY Cue.CuentaCompleta;

			INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
				SELECT	Aud_NumTransaccion, Fin.NombreCampo, Cadena_Vacia, Entero_Cero,	Entero_Cero,
					   Entero_Cero, Entero_Cero,
					   CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
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
												   AND Pol.NumeroTransaccion	= Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				  AND Fin.EsCalculado = 'N'
					AND NumClien = NumCliente
                    AND Fin.ConceptoFinanID IN(1,2,3,4)
					GROUP BY Fin.ConceptoFinanID;





		ELSE

			SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
				  Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
				FROM PERIODOCONTABLE
				WHERE Inicio	<= Par_Fecha
				  AND Fin	>= Par_Fecha;

			SET Var_EjeCon = IFNULL(Var_EjeCon, Entero_Cero);
			SET Var_PerCon = IFNULL(Var_PerCon, Entero_Cero);
			SET Var_FecIniPer = IFNULL(Var_FecIniPer, Fecha_Vacia);
			SET Var_FecFinPer = IFNULL(Var_FecFinPer, Fecha_Vacia);

			IF (Var_EjeCon = Entero_Cero) THEN
				SELECT	MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
						Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
					FROM PERIODOCONTABLE
					WHERE Fin	<= Par_Fecha;
			END IF;

			IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

				INSERT INTO TMPCONTABLE
					SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta, Entero_Cero,
							Entero_Cero, Entero_Cero,
							MAX(Cue.Naturaleza),
							CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
									SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
									SUM((IFNULL(Pol.Abonos, Entero_Cero)))
								 ELSE
									Entero_Cero
								END,
							CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
									SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
									SUM((IFNULL(Pol.Cargos, Entero_Cero)))
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

			UPDATE  TMPCONTABLE  TMP,
					CUENTASCONTABLES    Cue SET
				TMP.Naturaleza = Cue.Naturaleza
			WHERE Cue.CuentaCompleta = TMP.CuentaContable
			  AND TMP.NumeroTransaccion = Aud_NumTransaccion;

				SET Var_Ubicacion   := Ubi_Actual;

			ELSE
				INSERT INTO TMPCONTABLE
					SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
						Entero_Cero, Entero_Cero,
						MAX(Cue.Naturaleza),
						CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
							SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
							SUM((IFNULL(Pol.Abonos, Entero_Cero)))
							 ELSE
						  Entero_Cero
							END,
					  CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
							SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
							SUM((IFNULL(Pol.Cargos, Entero_Cero)))
							 ELSE
						  Entero_Cero
						END,
						Entero_Cero,Entero_Cero
						FROM  CUENTASCONTABLES Cue
					LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
															AND Pol.Fecha >=    Var_FecIniPer
															AND Pol.Fecha <=    Par_Fecha
															AND Pol.CentroCostoID >= Par_CCInicial
															AND Pol.CentroCostoID <= Par_CCFinal)
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
				  AND Sal.CentroCosto >= Par_CCInicial
				  AND Sal.CentroCosto <= Par_CCFinal
				GROUP BY Sal.CuentaCompleta ;


				UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable    = Tmp.CuentaContable;


			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

			INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
				SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo),	Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
						(CASE WHEN (Pol.Naturaleza) = VarDeudora
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
														AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				  AND Fin.EsCalculado = 'N'
					AND NumClien = NumCliente
                    AND Fin.ConceptoFinanID IN(1,2,3,4)
						GROUP BY Fin.ConceptoFinanID;




		END IF;


	ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

		INSERT INTO TMPCONTABLE
			SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					MAX(Cue.Naturaleza),
					CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
						 ELSE
						Entero_Cero
					END,
					CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
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
			SELECT  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
					Entero_Cero,        Entero_Cero,        Entero_Cero,
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
					 Fin.Descripcion, Cadena_Vacia, Cadena_Vacia
				FROM CONCEPESTADOSFIN Fin
				LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

					LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
													AND Pol.Fecha = Var_FechaSistema
													AND Pol.NumeroTransaccion	= Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				  AND Fin.EsCalculado = 'N'
					AND NumClien = NumCliente
                    AND Fin.ConceptoFinanID IN(1,2,3,4)
				GROUP BY Fin.ConceptoFinanID;




	ELSEIF(Par_TipoConsulta = Por_FinPeriodo) THEN

		SET Par_Periodo =  (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);
			INSERT INTO TMPCONTABLEBALANCE
			SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Entero_Cero,
				Entero_Cero, Entero_Cero,
				MAX(Cue.Naturaleza),
				CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
				  SUM(ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero), 2))
				   ELSE
				  Entero_Cero
				END,
				CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora  THEN
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
				 Fin.Descripcion, Cadena_Vacia, Entero_Cero
			  FROM CONCEPESTADOSFIN Fin
			  LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
								AND Pol.Fecha = Var_FechaSistema
								AND Pol.NumeroTransaccion = Aud_NumTransaccion)

			  WHERE Fin.EstadoFinanID = Tif_Balance
				AND Fin.EsCalculado = 'N'
			  AND NumClien = NumCliente
              AND Fin.ConceptoFinanID IN(1,2,3,4)
			  GROUP BY Fin.ConceptoFinanID;

	END IF;


	IF(Par_Cifras = Cifras_Miles) THEN

		UPDATE TMPBALANZACONTA SET
			SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
			WHERE NumeroTransaccion = Aud_NumTransaccion;

	END IF;

	DROP TABLE IF EXISTS tmp_DISPONIBILIDADES;
	SET Var_NombreTabla     := CONCAT("tmp_DISPONIBILIDADES");

	SET Var_CreateTable     := CONCAT( "CREATE temporary TABLE ", Var_NombreTabla,
									   " (");

	SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

	SET Var_InsertValores   := ' VALUES( ';

	SET Var_SelectTable     := CONCAT(" SELECT *  FROM ", Var_NombreTabla, " ; ");

	SET Var_DropTable       := CONCAT(" DROP TABLE IF EXISTS ", Var_NombreTabla, "; ");

	IF IFNULL(Aud_NumTransaccion, Entero_Cero) > Entero_Cero THEN

			OPEN  cur_Balance;
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						LOOP
							FETCH cur_Balance  INTO 	Var_Columna, Var_Monto;

							SET Var_CreateTable := CONCAT(Var_CreateTable,Var_Columna, " DECIMAL(18,2)", " ,");

                            SET Var_InsertTable := CONCAT(Var_InsertTable,Var_Columna," ," );

                            SET Var_InsertValores  := CONCAT(Var_InsertValores, CAST(IFNULL(Var_Monto, 0.0) AS CHAR)," ,");

						END LOOP;
					END;
			CLOSE cur_Balance;

            SET Var_CreateTable 	:= substring(Var_CreateTable,1,LENGTH(Var_CreateTable)-1);

            SET Var_InsertTable 	:= substring(Var_InsertTable,1,LENGTH(Var_InsertTable)-1);

            SET Var_InsertValores 	:= substring(Var_InsertValores,2,LENGTH(Var_InsertValores)-2);

			SET Var_CreateTable     := CONCAT(Var_CreateTable,"); ");
            SET Var_InsertTable     := CONCAT(Var_InsertTable, ") ", Var_InsertValores, ");  ");


			SET @Sentencia	= (Var_CreateTable);
			PREPARE Tabla FROM @Sentencia;
			EXECUTE  Tabla;
			DEALLOCATE PREPARE Tabla;

			SET @Sentencia	= (Var_InsertTable);
			PREPARE InsertarValores FROM @Sentencia;
			EXECUTE  InsertarValores;
			DEALLOCATE PREPARE InsertarValores;

			SELECT	Bancos,		Caja,		CajaMicro,		TitulosNegicio
            INTO 	Par_Bancos,	Par_Cajas,	Par_CajasMicro,	Par_TituloNeg
            FROM tmp_DISPONIBILIDADES;


			SET @Sentencia	= CONCAT( Var_DropTable);
			PREPARE DropTable FROM @Sentencia;
			EXECUTE  DropTable;
			DEALLOCATE PREPARE DropTable;

	END IF;

	DELETE FROM TMPCONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$
