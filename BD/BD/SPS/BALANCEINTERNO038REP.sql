-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANCEINTERNO038REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANCEINTERNO038REP`;

DELIMITER $$
CREATE PROCEDURE `BALANCEINTERNO038REP`(
	-- SP para generar el Balance General MEXI - VIGUA
	-- Modulo de Contabilidad --> Reportes --> Reportes Financieros

	Par_Ejercicio       INT,    		-- Ejercicio a consultar
	Par_Periodo         INT,			-- periodo a consultar
	Par_Fecha           DATE, 			-- fecha de consulta
	Par_TipoConsulta    CHAR(1), 		-- Tipo de consulta
	Par_SaldosCero      CHAR(1),  		-- Si se toma en cuenta los saldos en 0

	Par_Cifras          CHAR(1), 		-- tipo de cifras a representar(pesos, miles)
	Par_CCInicial		INT,			-- Centor de costo inicial
	Par_CCFinal			INT,			-- centro de costo final
	Par_EmpresaID       INT,			-- parametro de auditoria
	Aud_Usuario         INT,			-- parametro de auditoria

	Aud_FechaActual     DATETIME,		-- parametro de auditoria
	Aud_DireccionIP     VARCHAR(15),	-- parametro de auditoria
	Aud_ProgramaID      VARCHAR(50),	-- parametro de auditoria
	Aud_Sucursal        INT,			-- parametro de auditoria
	Aud_NumTransaccion  BIGINT			-- parametro de auditoria
		)
TerminaStore: BEGIN

  -- Declaracion de Variables
	DECLARE Var_FecConsulta		DATE;					-- fecha en la que se esta realiando la consulta
	DECLARE Var_FechaSistema	DATE;					-- fecha que tiene el sistema
	DECLARE Var_FechaSaldos		DATE;					-- fecha de saldos
	DECLARE Var_EjeCon      	INT;					-- numero del ejercicio
	DECLARE Var_PerCon      	INT;					-- periodo de consulta
	DECLARE Var_FecIniPer   	DATE;					-- fecha de inicio del periodo
	DECLARE Var_FecFinPer   	DATE;					-- fecha de fin del periodo
	DECLARE Var_EjercicioVig	INT;					-- El ejercicio es vigente
	DECLARE Var_PeriodoVig		INT;					-- periodo vigente
	DECLARE For_ResulNeto   	VARCHAR(500);			-- formula de resultado neto
	DECLARE Par_AcumuladoCta    DECIMAL(18,2);			-- acumulado de cuenta
	DECLARE Var_Desplegado  	VARCHAR(300);			-- desplegado del resultado neto
	DECLARE Var_Ubicacion   	CHAR(1);				-- ubicacion

	DECLARE Var_Columna 			VARCHAR(20);  	      -- Columna
	DECLARE Var_Monto				DECIMAL(18,2);	    -- monto de la consuta
	DECLARE Var_NombreTabla     	VARCHAR(40);	    -- Nombre de la tabla a consultar
	DECLARE Var_CreateTable     	VARCHAR(9000);      -- para crear tabla
	DECLARE Var_InsertTable     	VARCHAR(5000);      -- para isertar a tabla
	DECLARE Var_InsertValores   	VARCHAR(5000);      -- para insertar valores a tabla
	DECLARE Var_SelectTable    		VARCHAR(5000);		-- para consultar a tabla
	DECLARE Var_DropTable       	VARCHAR(5000);		-- para eliminar tabla
	DECLARE	Var_Update				VARCHAR(5000);		-- Update Dinamico
	DECLARE Var_CantCaracteres		INT;				-- cantidad de caacteres
	DECLARE Var_UltPeriodoCie   	INT;				-- ultimo periodo cierre
	DECLARE Var_UltEjercicioCie 	INT;				-- ultimo ejercicio cierre

	DECLARE Var_MinCenCos			INT;           		-- numero minimo de centro de costos
	DECLARE Var_MaxCenCos			INT;            	-- numero maximo de centro de costos
	DECLARE Var_NumeroRegistros		INT(11);            	-- numero maximo de Registros
	DECLARE Var_Contador			INT(11);            	-- numero maximo de Registros

	-- Declaracion de Constantes
	DECLARE Entero_Cero     INT;      					-- valor 0
	DECLARE Cadena_Vacia    CHAR(1);    				-- campo vacio
	DECLARE Est_Cerrado     CHAR(1);   					-- estatus cerrado
	DECLARE Con_SI  	   CHAR(1);   					-- Constante SI
	DECLARE Fecha_Vacia     DATE;     					-- fecha vacia
	DECLARE VarDeudora      CHAR(1);    				-- es deudora
	DECLARE VarAcreedora    CHAR(1);    				-- es acreedora
	DECLARE Tip_Encabezado  CHAR(1);    				-- tipos de encabezdos
	DECLARE No_SaldoCeros   CHAR(1);   					-- no sados en ceros
	DECLARE Cifras_Pesos    CHAR(1);    				-- si cifras en pesos
	DECLARE Cifras_Miles    CHAR(1);    				-- si cifras en miles
	DECLARE Por_Peridodo    CHAR(1);    				-- si se realiza por periodo
	DECLARE Por_Fecha       CHAR(1);    				-- si se realiza por fecha
	DECLARE Ubi_Actual      CHAR(1);   					-- ubicacion actual
	DECLARE Ubi_Histor      CHAR(1);    				-- ubicacion historico
	DECLARE Tif_Balance     INT;      					-- correspode al estado financiero
	DECLARE Con_ResulNeto   INT;      					-- con resltado neto
	DECLARE NumCliente    	INT;      					-- identificador del cliente
	DECLARE Por_FinPeriodo  CHAR(1);   					-- si por fin de periodo
	DECLARE Con_Dinamico		CHAR(1);    			-- Constante Dinamica
	DECLARE Var_NombreCampo		VARCHAR(20);
	DECLARE Var_CuentaContable	VARCHAR(500);
	DECLARE Var_ContaGeneral	VARCHAR(250);	-- Contador General
	DECLARE Var_DirectGeneral	VARCHAR(250);	-- Director General
	DECLARE Var_DirectorFinanza VARCHAR(250);	-- Director de Finanzas
	DECLARE Con_NO				CHAR(1);-- Constante NO

	DECLARE cur_Balance CURSOR FOR
		SELECT CuentaContable,	SaldoDeudor
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion
			ORDER BY CuentaContable;


	-- Asignacion de valores
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
	SET NumCliente		:= 38;
	SET Por_FinPeriodo  := 'F';
	SET Con_SI			:= 'S';
	SET Con_Dinamico	:= 'D';
	SET Con_NO			:= 'N';

	SELECT FechaSistema, 		EjercicioVigente, PeriodoVigente,JefeContabilidad,	GerenteGeneral,		IFNULL(DirectorFinanzas, Cadena_Vacia)
	INTO   Var_FechaSistema,	Var_EjercicioVig, Var_PeriodoVig,Var_ContaGeneral,	Var_DirectGeneral,	Var_DirectorFinanza
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

	-- Tabla de Sumatorias del estado de resultados
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINBALANCEDIN;
	CREATE TEMPORARY TABLE TMP_CONCEPESTADOSFINBALANCEDIN(
		NumeroRegistro 		INT(11),
		NombreCampo			VARCHAR(20),
		CuentaContable		VARCHAR(500),
		KEY `IDX_TMP_CONCEPESTADOSFINBALANCEDIN_1` (`NumeroRegistro`));

	SET @NumeroRegistro := 0;
	INSERT INTO TMP_CONCEPESTADOSFINBALANCEDIN(
		NumeroRegistro,NombreCampo, CuentaContable)
	SELECT @NumeroRegistro:=(@NumeroRegistro+1), IFNULL(NombreCampo,Cadena_Vacia), IFNULL(CuentaContable, Cadena_Vacia)
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_Balance
	  AND NumClien = NumCliente
	  AND EsCalculado = Con_Dinamico;

	-- Tabla de Campos Calculados del Balance General
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINBALANCE;
	CREATE TEMPORARY TABLE TMP_CONCEPESTADOSFINBALANCE(
		NumeroRegistro 		INT(11),
		NombreCampo			VARCHAR(20),
		CuentaContable		VARCHAR(500),
		Desplegado 			VARCHAR(300),
		KEY `IDX_TMP_CONCEPESTADOSFINBALANCE_1` (`NumeroRegistro`)
	);

	SET @NumeroRegistro := 0;
	INSERT INTO TMP_CONCEPESTADOSFINBALANCE(
		NumeroRegistro,NombreCampo, CuentaContable,Desplegado )
	SELECT @NumeroRegistro:=(@NumeroRegistro+1), IFNULL(NombreCampo,Cadena_Vacia), IFNULL(CuentaContable, Cadena_Vacia), IFNULL(Desplegado,Cadena_Vacia)
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_Balance
	  AND NumClien = NumCliente
	  AND EsCalculado = Con_SI;

	SELECT IFNULL(MAX(NumeroRegistro),Entero_Cero)
	INTO Var_NumeroRegistros
	FROM TMP_CONCEPESTADOSFINBALANCE;

	IF (Par_TipoConsulta = Por_Fecha) THEN

		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
			FROM  SALDOSCONTABLES
			WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos	= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		IF (Var_FechaSaldos = Fecha_Vacia) THEN

			INSERT INTO TMPCONTABLE
			SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta,	Entero_Cero,
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
			SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = VarDeudora THEN
						   (IFNULL(Pol.SaldoDeudor, Entero_Cero)) - (IFNULL(Pol.SaldoAcreedor, Entero_Cero))
					ELSE
						   (IFNULL(Pol.SaldoAcreedor, Entero_Cero)) - (IFNULL(Pol.SaldoDeudor, Entero_Cero))
					END),
					Entero_Cero,
					MAX(Fin.Desplegado), Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.NumeroTransaccion	= Aud_NumTransaccion)
			WHERE Fin.EstadoFinanID = Tif_Balance
			  AND Fin.EsCalculado = Con_NO
			  AND NumClien = NumCliente
			GROUP BY Fin.ConceptoFinanID;

			IF(Var_NumeroRegistros > Entero_Cero) THEN

				SET Var_Contador := 1;

				WHILE( Var_Contador <= Var_NumeroRegistros) DO

					SELECT NombreCampo, CuentaContable, Desplegado
					INTO Var_NombreCampo, Var_CuentaContable, Var_Desplegado
					FROM TMP_CONCEPESTADOSFINBALANCE
					WHERE NumeroRegistro = Var_Contador;

					IF(Var_CuentaContable != Cadena_Vacia) THEN
						CALL `EVALFORMULACONTAPRO`(
							Var_CuentaContable,     Ubi_Actual,	Por_Fecha,          Par_Fecha,      	Var_UltEjercicioCie,
							Var_UltPeriodoCie,  	Par_Fecha,		Par_AcumuladoCta,	Par_CCInicial,		Par_CCFinal,
							Par_EmpresaID,			Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,   		Aud_NumTransaccion);

						INSERT INTO TMPBALANZACONTA	(
							NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
							Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
							CuentaMayor,					CentroCosto)
						VALUES(
							Aud_NumTransaccion, Var_NombreCampo,    Cadena_Vacia,   	Entero_Cero,    Entero_Cero,
							Entero_Cero, 		Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,    Var_Desplegado,
							Cadena_Vacia, Cadena_Vacia);
					END IF;

					SET Var_Contador := Var_Contador + 1;
					SET Var_Desplegado := Cadena_Vacia;
					SET Var_NombreCampo := Cadena_Vacia;
					SET Var_CuentaContable := Cadena_Vacia;
					SET Par_AcumuladoCta := Entero_Cero;

				END WHILE;

			END IF;

		ELSE

			SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
					Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
			FROM PERIODOCONTABLE
			WHERE Inicio	<= Par_Fecha
			  AND Fin	>= Par_Fecha;

			SET Var_EjeCon := IFNULL(Var_EjeCon, Entero_Cero);
			SET Var_PerCon := IFNULL(Var_PerCon, Entero_Cero);
			SET Var_FecIniPer := IFNULL(Var_FecIniPer, Fecha_Vacia);
			SET Var_FecFinPer := IFNULL(Var_FecFinPer, Fecha_Vacia);

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
				GROUP BY Cue.CuentaCompleta;

				IF( Par_Fecha = Var_FechaSistema ) THEN

					DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

					INSERT INTO TMPBALPOLCENCOSDIA (
							NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
					SELECT	Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
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
				SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
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

			INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
					Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
					CuentaMayor,					CentroCosto)
			SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo),	Cadena_Vacia, Entero_Cero,	Entero_Cero,
				Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = VarDeudora THEN
								(IFNULL(Pol.SaldoInicialDeu, Entero_Cero) - IFNULL(Pol.SaldoInicialAcr, Entero_Cero)) +
								(IFNULL(Pol.SaldoDeudor, Entero_Cero) 	  - IFNULL(Pol.SaldoAcreedor, Entero_Cero))
							 ELSE
								(IFNULL(Pol.SaldoInicialAcr, Entero_Cero) - IFNULL(Pol.SaldoInicialDeu, Entero_Cero)) +
								(IFNULL(Pol.SaldoAcreedor, Entero_Cero)   - IFNULL(Pol.SaldoDeudor, Entero_Cero))
					END ),
				Entero_Cero,
				MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
													AND Pol.Fecha = Var_FechaSistema
													AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

			WHERE Fin.EstadoFinanID = Tif_Balance
			  AND Fin.EsCalculado = Con_NO
				AND NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID;

			IF(Var_NumeroRegistros > Entero_Cero) THEN

				SET Var_Contador := 1;

				WHILE( Var_Contador <= Var_NumeroRegistros) DO

					SELECT NombreCampo, CuentaContable, Desplegado
					INTO Var_NombreCampo, Var_CuentaContable,Var_Desplegado
					FROM TMP_CONCEPESTADOSFINBALANCE
					WHERE NumeroRegistro = Var_Contador;

					IF(Var_CuentaContable != Cadena_Vacia) THEN
						CALL `EVALFORMULACONTAPRO`(
							Var_CuentaContable,	Var_Ubicacion,		Por_Fecha,          Par_Fecha,			Var_UltEjercicioCie,
							Var_UltPeriodoCie,	Var_FecIniPer,		Par_AcumuladoCta,   Par_CCInicial,		Par_CCFinal,
							Par_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						INSERT INTO TMPBALANZACONTA	(
								NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
								Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
								CuentaMayor,					CentroCosto)
						VALUES(
								Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,   	Entero_Cero,	Entero_Cero,
								Entero_Cero, 		Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,	Var_Desplegado,
								Cadena_Vacia, 		Cadena_Vacia);
					END IF;

					SET Var_Contador := Var_Contador + 1;
					SET Var_Desplegado := Cadena_Vacia;
					SET Var_NombreCampo := Cadena_Vacia;
					SET Var_CuentaContable := Cadena_Vacia;
					SET Par_AcumuladoCta := Entero_Cero;

				END WHILE;

			END IF;

		END IF;


	ELSEIF(Par_TipoConsulta = Por_Peridodo) THEN

		INSERT INTO TMPCONTABLE
		SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
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


		INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo),    Cadena_Vacia,
				Entero_Cero,        Entero_Cero,        Entero_Cero,
				Entero_Cero,
				SUM(CASE WHEN Fin.Naturaleza = VarDeudora THEN
							(IFNULL(Pol.SaldoDeudor, Entero_Cero) - IFNULL(Pol.SaldoAcreedor, Entero_Cero))
						 ELSE
							(IFNULL(Pol.SaldoAcreedor, Entero_Cero) - IFNULL(Pol.SaldoDeudor, Entero_Cero))
				 END),
				 Entero_Cero,
				 MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
		FROM CONCEPESTADOSFIN Fin
		LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
		LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
										AND Pol.Fecha = Var_FechaSistema
										AND Pol.NumeroTransaccion	= Aud_NumTransaccion)

		WHERE Fin.EstadoFinanID = Tif_Balance
		  AND Fin.EsCalculado = Con_NO
		  AND NumClien = NumCliente
		GROUP BY Fin.ConceptoFinanID;

		IF(Var_NumeroRegistros > Entero_Cero) THEN

			SET Var_Contador := 1;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable, Desplegado
				INTO Var_NombreCampo, Var_CuentaContable,Var_Desplegado
				FROM TMP_CONCEPESTADOSFINBALANCE
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						Var_CuentaContable,	Cadena_Vacia,	Por_Peridodo,       Par_Fecha,			Par_Ejercicio,
						Par_Periodo,		Par_Fecha,		Par_AcumuladoCta,   Par_CCInicial,		Par_CCFinal,
						Par_EmpresaID,  	Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,   	Aud_NumTransaccion);

					INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
					VALUES(
						Aud_NumTransaccion, Var_NombreCampo,       Cadena_Vacia,   	Entero_Cero,	Entero_Cero,
						Entero_Cero, 		Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,	Var_Desplegado,
						Cadena_Vacia, 		Cadena_Vacia);
				END IF;

				SET Var_Contador := Var_Contador + 1;
				SET Var_Desplegado := Cadena_Vacia;
				SET Var_NombreCampo := Cadena_Vacia;
				SET Var_CuentaContable := Cadena_Vacia;
				SET Par_AcumuladoCta := Entero_Cero;

			END WHILE;

		END IF;

	ELSEIF(Par_TipoConsulta = Por_FinPeriodo) THEN

		SET Par_Periodo =  (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);

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
			WHERE Sal.EjercicioID = Par_Ejercicio
			  AND Sal.PeriodoID = Par_Periodo
			  AND Sal.CuentaCompleta = Cue.CuentaCompleta
			  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

		INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
				Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
				CuentaMayor,					CentroCosto)
		SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia,  Entero_Cero,
				Entero_Cero,        Entero_Cero,     Entero_Cero,
				SUM(CASE WHEN Fin.Naturaleza = VarDeudora THEN
							(ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2) - ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2))
						 ELSE
							(ROUND(IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2) - ROUND(IFNULL(Pol.SaldoDeudor, Entero_Cero), 2))
				 END),
				 Entero_Cero,
				 MAX(Fin.Descripcion), Cadena_Vacia, Entero_Cero
		FROM CONCEPESTADOSFIN Fin
		LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
		LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
					AND Pol.Fecha = Var_FechaSistema
					AND Pol.NumeroTransaccion = Aud_NumTransaccion)
		WHERE Fin.EstadoFinanID = Tif_Balance
		  AND Fin.EsCalculado = Con_NO
		  AND NumClien = NumCliente
		GROUP BY Fin.ConceptoFinanID;

		IF(Var_NumeroRegistros > Entero_Cero) THEN

			SET Var_Contador := 1;

			SELECT Fin INTO Par_Fecha
			FROM PERIODOCONTABLE
			WHERE EjercicioID = Par_Ejercicio
			AND PeriodoID = Par_Periodo;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable, Desplegado
				INTO Var_NombreCampo, Var_CuentaContable, Var_Desplegado
				FROM TMP_CONCEPESTADOSFINBALANCE
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN
					CALL `EVALFORMULAPERIFINPRO`(
						Par_AcumuladoCta,	Var_CuentaContable,	'H',  'F',  Par_Fecha );

					INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
						Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
						CuentaMayor,					CentroCosto)
					VALUES(
						Aud_NumTransaccion, Var_NombreCampo,    Cadena_Vacia,   	Entero_Cero,	Entero_Cero,
						Entero_Cero, 		Entero_Cero,        Par_AcumuladoCta,   Entero_Cero,	Var_Desplegado,
						Cadena_Vacia, 		Cadena_Vacia);
				END IF;

				SET Var_Contador := Var_Contador + 1;
				SET Var_Desplegado := Cadena_Vacia;
				SET Var_NombreCampo := Cadena_Vacia;
				SET Var_CuentaContable := Cadena_Vacia;
				SET Par_AcumuladoCta := Entero_Cero;

			END WHILE;

		END IF;
	END IF;

	-- Agrego los campos de tipo Sumatoria configurados en la tabla CONCEPESTADOSFIN
	INSERT INTO TMPBALANZACONTA	(
		NumeroTransaccion,				CuentaContable,				Grupo,					SaldoInicialDeu,			SaldoInicialAcre,
		Cargos,							Abonos,						SaldoDeudor,			SaldoAcreedor,				DescripcionCuenta,
		CuentaMayor,					CentroCosto)
	SELECT
		Aud_NumTransaccion, NombreCampo,		Cadena_Vacia,	Entero_Cero,  Entero_Cero,
		Entero_Cero,    	Entero_Cero,        Entero_Cero,  	Entero_Cero,  Descripcion,
		Cadena_Vacia, 		Cadena_Vacia
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_Balance
	  AND NumClien = NumCliente
	  AND EsCalculado = Con_Dinamico;


	SET Var_NombreTabla     := CONCAT(" tmp_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR), " ");

	SET Var_CreateTable     := CONCAT( " CREATE TEMPORARY TABLE ", Var_NombreTabla,
				 " (");

	SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");

	SET Var_InsertValores   := ' VALUES( ';

	SET Var_SelectTable     := CONCAT(" SELECT *,",' "',Var_DirectorFinanza,'" AS Var_DirectorFinanza,',' "',Var_ContaGeneral,'" AS Var_ContaGeneral, "',Var_DirectGeneral,'" AS Var_DirectGeneral', " FROM ", Var_NombreTabla, "; ");

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

		SET @Sentencia	:= (Var_CreateTable);
		PREPARE Tabla FROM @Sentencia;
		EXECUTE  Tabla;
		DEALLOCATE PREPARE Tabla;

		SET @Sentencia	:= (Var_InsertTable);
		PREPARE InsertarValores FROM @Sentencia;
		EXECUTE  InsertarValores;
		DEALLOCATE PREPARE InsertarValores;

		-- Inicio ciclo de update para los campos calculados
		SELECT IFNULL(MAX(NumeroRegistro),Entero_Cero)
		INTO Var_NumeroRegistros
		FROM TMP_CONCEPESTADOSFINBALANCEDIN;

		IF(Var_NumeroRegistros > Entero_Cero) THEN

			SET Var_Contador := 1;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable
				INTO Var_NombreCampo, Var_CuentaContable
				FROM TMP_CONCEPESTADOSFINBALANCEDIN
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN

					SET Var_Update  := CONCAT('UPDATE ', Var_NombreTabla ,' SET ',Var_NombreCampo,' = ',Var_CuentaContable,';');
					SET @Sentencia	:= (Var_Update);
					PREPARE Actualiza FROM @Sentencia;
					EXECUTE Actualiza;
					DEALLOCATE PREPARE Actualiza;

				END IF;

				SET Var_Contador 		:= Var_Contador + 1;
				SET Var_Update 			:= Cadena_Vacia;
				SET Var_NombreCampo 	:= Cadena_Vacia;
				SET Var_CuentaContable 	:= Cadena_Vacia;

			END WHILE;

		END IF;

		SET @Sentencia	:= (Var_SelectTable);
		PREPARE SelectTable FROM @Sentencia;
		EXECUTE  SelectTable;
		DEALLOCATE PREPARE SelectTable;

		SET @Sentencia	:= CONCAT( Var_DropTable);
		PREPARE DropTable FROM @Sentencia;
		EXECUTE  DropTable;
		DEALLOCATE PREPARE DropTable;

	END IF;

	DELETE FROM TMPCONTABLE
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPBALANZACONTA
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINBALANCE;
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINBALANCEDIN;
END TerminaStore$$