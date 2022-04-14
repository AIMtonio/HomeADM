-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOVARIACIONES024REP_ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOVARIACIONES024REP_ALT;

DELIMITER $$
CREATE PROCEDURE `EDOVARIACIONES024REP_ALT`(
	Par_Ejercicio       INT,
	Par_Periodo         INT,
	Par_Fecha           DATE,
	Par_TipoConsulta    CHAR(1),
	Par_SaldosCero      CHAR(1),

	Par_Cifras          CHAR(1),
	Par_CCInicial		INT,
	Par_CCFinal			INT,


	Par_EmpresaID       INT,
	Aud_Usuario         INT,

	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT,
	Aud_NumTransaccion  BIGINT
		)
TerminaStore: BEGIN


	DECLARE Var_FecConsulta			DATE;
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FechaSaldos			DATE;
	DECLARE Var_EjeCon      		INT;
	DECLARE Var_PerCon      		INT;

	DECLARE Var_FecIniPer   		DATE;
	DECLARE Var_FecFinPer   		DATE;
	DECLARE Var_EjercicioVig		INT;
	DECLARE Var_PeriodoVig			INT;
	DECLARE For_ResulNeto			VARCHAR(500);

	DECLARE Par_AcumuladoCta    	DECIMAL(18,2);
	DECLARE Var_TotalPasivo			DECIMAL(14,2);
	DECLARE Des_ResulNeto			VARCHAR(200);
	DECLARE Var_Ubicacion			CHAR(1);

	DECLARE For_EfeRegSOCAP			VARCHAR(500);
	DECLARE For_CapResActNo			VARCHAR(500);
	DECLARE For_CapResVal			VARCHAR(500);
	DECLARE For_CapResEjeAnt		VARCHAR(500);
	DECLARE For_FondoRes			VARCHAR(500);

	DECLARE For_TotPasCapCont   	VARCHAR(500);
	DECLARE Var_UltPeriodoCie   	INT;
	DECLARE Var_UltEjercicioCie 	INT;
	DECLARE Var_UltPeriodoCieAnt   	INT;
	DECLARE Var_UltEjercicioCieAnt 	INT;
	DECLARE Var_MinCenCos			INT;

	DECLARE Var_MaxCenCos			INT;
	DECLARE Var_Ejercicio			INT;
	DECLARE Var_Periodo				INT;
	DECLARE Var_CapitalGanado   	DECIMAL(18,2);
	DECLARE Var_TotPasCapCont   	DECIMAL(18,2);

	DECLARE Var_DecimalCero         DECIMAL(14,2);
	DECLARE Var_CapSocialAct        DECIMAL(18,2);
	DECLARE Var_CapSocialAnt        DECIMAL(18,2);
	DECLARE Var_CapFondoReservaAct  DECIMAL(18,2);
	DECLARE Var_CapFondoReservaAnt  DECIMAL(18,2);

	DECLARE Var_CapResultadoEjeAct  DECIMAL(18,2);
	DECLARE Var_CapResultadoEjeAnt  DECIMAL(18,2);
	DECLARE Var_CapResNetoAct       DECIMAL(18,2);
	DECLARE Var_CapResNetoAnt       DECIMAL(18,2);
	DECLARE Var_CapitalSocial    	DECIMAL(18,2);

	DECLARE Var_FondoReserva     	DECIMAL(18,2);
	DECLARE Var_ResultadoAnt     	DECIMAL(18,2);
	DECLARE Var_ResultadoNeto    	DECIMAL(18,2);
	DECLARE Var_FechaAnt			DATE;
	DECLARE	Var_FechaAct			DATE;
	DECLARE Var_MaxFechaHis			DATE;

	DECLARE Var_MesAct              INT;
	DECLARE Var_MesAnt              INT;
	DECLARE Var_FechaInicio			DATE;
	DECLARE Var_MesIni				INT;
	DECLARE Var_EjercicioID			INT;

	DECLARE Var_NumeroPeriodo		INT;
	DECLARE Var_Fecha			    DATE;

	DECLARE Var_CapAporFutAumCap    DECIMAL(18,2);
	DECLARE Var_CapAporFutAumCapAct DECIMAL(18,2);
	DECLARE Var_CapAporFutAumCapAnt DECIMAL(18,2);

	DECLARE Var_CapRegimenSOFIPO    DECIMAL(18,2);
	DECLARE Var_CapRegimenSOFIPOAct DECIMAL(18,2);
	DECLARE Var_CapRegimenSOFIPOAnt DECIMAL(18,2);


	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Est_Cerrado     	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;

	DECLARE VarDeudora      	CHAR(1);
	DECLARE VarAcreedora    	CHAR(1);
	DECLARE No_SaldoCeros   	CHAR(1);
	DECLARE Cifras_Pesos    	CHAR(1);
	DECLARE Cifras_Miles    	CHAR(1);

	DECLARE Por_Periodo     	CHAR(1);
	DECLARE Por_Fecha       	CHAR(1);
	DECLARE Ubi_Actual      	CHAR(1);
	DECLARE Ubi_Histor      	CHAR(1);
	DECLARE Tif_Balance     	INT;

	DECLARE Con_ResulNeto   	INT;
	DECLARE Con_EfeRegSOCAP		INT;
	DECLARE Con_CapResActNo		INT;
	DECLARE Con_CapResVal		INT;
	DECLARE Con_CapResEjeAn		INT;

	DECLARE Con_FondoRes		INT;
	DECLARE Con_CerApoOrd		INT;
	DECLARE Con_TotPasCapCont 	INT;
	DECLARE NumCliente			INT;
	DECLARE NoEsCalculado   	CHAR(1);

	DECLARE UbicaSaldoConta		CHAR(1);
	DECLARE CalculoFecha		CHAR(1);

	DECLARE cur_Balance CURSOR FOR
		SELECT CuentaContable,	SaldoDeudor
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion
			ORDER BY CuentaContable;


	SET Entero_Cero    		:= 0;
	SET Decimal_Cero    	:= 0.0;
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Est_Cerrado     	:= 'C';

	SET VarDeudora      	:= 'D';
	SET VarAcreedora    	:= 'A';
	SET No_SaldoCeros   	:= 'N';
	SET Cifras_Pesos    	:= 'P';
	SET Cifras_Miles    	:= 'M';

	SET Por_Periodo     	:= 'P';
	SET Por_Fecha       	:= 'D';
	SET Ubi_Actual      	:= 'A';
	SET Ubi_Histor      	:= 'H';
	SET Tif_Balance     	:= 1;

	SET Con_ResulNeto   	:= 48;
	SET Con_EfeRegSOCAP		:= 66;
	SET Con_CapResActNo		:= 46;
	SET Con_CapResVal		:= 45;
	SET Con_CapResEjeAn		:= 44;

	SET Con_FondoRes		:= 80;
	SET Con_CerApoOrd		:= 62;
	SET Con_TotPasCapCont	:= 65;
	SET NumCliente      	:= 24;
	SET NoEsCalculado		:= 'N';

	SET UbicaSaldoConta 	:= 'H';
	SET CalculoFecha		:= 'F';

	IF(Par_Periodo > Entero_Cero ) THEN
		SET Par_TipoConsulta := Por_Periodo;
	END IF;

	SELECT FechaSistema, 		EjercicioVigente, PeriodoVigente INTO
		   Var_FechaSistema,	Var_EjercicioVig, Var_PeriodoVig
		FROM PARAMETROSSIS;

	SET Par_Fecha           = IFNULL(Par_Fecha, Fecha_Vacia);
	SET Var_EjercicioVig    = IFNULL(Var_EjercicioVig, Entero_Cero);
	SET Var_PeriodoVig      = IFNULL(Var_PeriodoVig, Entero_Cero);

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	IF(Par_Fecha != Fecha_Vacia) THEN
		SET Var_FecConsulta	= Par_Fecha;
	ELSE
		SELECT	Fin INTO Var_FecConsulta
			FROM PERIODOCONTABLE
			WHERE EjercicioID   = Par_Ejercicio
			  AND PeriodoID     = Par_Periodo;
	END IF;

	SET	Par_CCInicial	:= IFNULL(Par_CCInicial, Entero_Cero);
	SET	Par_CCFinal		:= IFNULL(Par_CCFinal, Entero_Cero);


	SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
		FROM CENTROCOSTOS;

	IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
		SET Par_CCInicial	:= Var_MinCenCos;
		SET	Par_CCFinal		:= Var_MaxCenCos;
	END IF;

	SELECT CuentaContable, Desplegado  INTO For_ResulNeto, Des_ResulNeto
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Balance
		  AND ConceptoFinanID = Con_ResulNeto
			AND NumClien = NumCliente;

	SET For_ResulNeto   := IFNULL(For_ResulNeto, Cadena_Vacia);
	SET Des_ResulNeto   := IFNULL(Des_ResulNeto, Cadena_Vacia);

	SELECT CuentaContable  INTO For_EfeRegSOCAP
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Balance
		  AND ConceptoFinanID = Con_EfeRegSOCAP
			AND NumClien = NumCliente;

	SET For_EfeRegSOCAP   := IFNULL(For_EfeRegSOCAP, Cadena_Vacia);

	SELECT CuentaContable  INTO For_CapResActNo
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Balance
		  AND ConceptoFinanID = Con_CapResActNo
			AND NumClien = NumCliente;

	SET For_CapResActNo   := IFNULL(For_CapResActNo, Cadena_Vacia);

	SELECT CuentaContable  INTO For_CapResVal
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Balance
		  AND ConceptoFinanID = Con_CapResVal
			AND NumClien = NumCliente;

	SET For_CapResVal   := IFNULL(For_CapResVal, Cadena_Vacia);

	SELECT CuentaContable  INTO For_TotPasCapCont
		FROM CONCEPESTADOSFIN
		WHERE EstadoFinanID = Tif_Balance
		  AND ConceptoFinanID = Con_TotPasCapCont
			AND NumClien = NumCliente;

	SET For_TotPasCapCont   := IFNULL(For_TotPasCapCont, Cadena_Vacia);

	SELECT MIN(EjercicioID) INTO Var_EjercicioID
		FROM EJERCICIOCONTABLE;

	SET Var_EjercicioID    := IFNULL(Var_EjercicioID, Entero_Cero);


	SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCie
		FROM PERIODOCONTABLE Per
		WHERE Per.Fin	< Var_FecConsulta
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



	DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;


	IF (Par_TipoConsulta = Por_Fecha) THEN


		SET Var_Fecha := date_format(Par_Fecha,'%Y-01-01');
		SET Var_Fecha := date_sub(Var_Fecha,INTERVAL 1 DAY);
		IF YEAR(Par_Fecha)  = '2018' then
			SET Var_Fecha := '2018-03-31';
		END IF;

		IF(Par_Fecha != Fecha_Vacia) THEN

			SET Var_FechaAct 	:= Par_Fecha;
			SET Var_FechaInicio	:= Var_Fecha;

			SET Var_MesIni   := (SELECT month(Var_FechaInicio));
			SET Var_MesAct   := (SELECT month(Var_FechaAct));
			SELECT MAX(FechaCorte) INTO Var_FechaSaldos
			FROM  SALDOSCONTABLES
			WHERE FechaCorte < Par_Fecha;

			SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);

			IF (Var_FechaSaldos = Fecha_Vacia) THEN


				INSERT INTO TMPCONTABLEBALANCE
				SELECT Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta, Entero_Cero,
				Entero_Cero, Entero_Cero,
				MAX(Cue.Naturaleza),
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
				Entero_Cero, Entero_Cero

				FROM CUENTASCONTABLES Cue,
					 DETALLEPOLIZA AS Pol
				WHERE Cue.CuentaCompleta = Pol.CuentaCompleta
				  AND Pol.Fecha <= Par_Fecha
				  AND Pol.CentroCostoID >= Par_CCInicial
				  AND Pol.CentroCostoID <= Par_CCFinal
				GROUP BY Cue.CuentaCompleta;

				INSERT INTO TMPBALANZACONTA
					(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
					`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
					`CuentaMayor`,			`CentroCosto`)
				SELECT 	Aud_NumTransaccion, 	Fin.NombreCampo, 	Cadena_Vacia,
					Entero_Cero, 			Entero_Cero, 		Entero_Cero,
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
				   Fin.Desplegado, Cadena_Vacia, Cadena_Vacia
				FROM CONCEPESTADOSFIN Fin
				LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.NumeroTransaccion    = Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				AND Fin.EsCalculado = NoEsCalculado
				AND Fin.NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado;


				IF(For_ResulNeto != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						For_ResulNeto,      Ubi_Actual,     Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
						Var_UltPeriodoCie,  Par_Fecha,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
						Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,		`Grupo`,				`SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,               `SaldoDeudor`,			`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,      	`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	"CapResNeto",       	Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
						Entero_Cero,        	Entero_Cero,        	Par_AcumuladoCta,   	Entero_Cero,    	Des_ResulNeto,
						Cadena_Vacia, 			Cadena_Vacia);
				END IF;


				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = (SaldoDeudor)
				WHERE NumeroTransaccion = Aud_NumTransaccion;

				SET Var_CapitalGanado   := (
							SELECT SUM(SaldoDeudor)
							FROM TMPBALANZACONTA
							WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
								CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
								CuentaContable LIKE'CapResNeto' )
							AND NumeroTransaccion = Aud_NumTransaccion
							);

				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_CapitalGanado
				WHERE CuentaContable LIKE "CapitalGanado"
				 AND NumeroTransaccion = Aud_NumTransaccion;

				SET Var_TotPasCapCont:= (
									SELECT SUM(SaldoDeudor)
									FROM TMPBALANZACONTA
									WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
										CuentaContable LIKE'CapContribuido' )
									AND NumeroTransaccion = Aud_NumTransaccion
									);


				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_TotPasCapCont
				WHERE CuentaContable LIKE "TotPasCapCont"
				AND NumeroTransaccion = Aud_NumTransaccion;

				IF(Par_Cifras = Cifras_Miles) THEN
					UPDATE TMPBALANZACONTA SET
						SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
						WHERE NumeroTransaccion = Aud_NumTransaccion;
				END IF;

				SELECT SaldoDeudor INTO Var_CapSocialAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapSocial'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapFondoReservaAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapFondoSocReserva'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResultadoEjeAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResultadoEjeAnt'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResNetoAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResNeto'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapAporFutAumCapAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapAporFutAumCap'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapRegimenSOFIPO'
					ORDER BY CuentaContable;

				DELETE FROM TMPCONTABLEBALANCE
					WHERE NumeroTransaccion = Aud_NumTransaccion;

				DELETE FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion;


			ELSE
				SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
				  Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
				FROM PERIODOCONTABLE
				WHERE Inicio <= Par_Fecha
				  AND Fin     >= Par_Fecha;

				SET Var_EjeCon 		:= IFNULL(Var_EjeCon, Entero_Cero);
				SET Var_PerCon 		:= IFNULL(Var_PerCon, Entero_Cero);
				SET Var_FecIniPer 	:= IFNULL(Var_FecIniPer, Fecha_Vacia);
				SET Var_FecFinPer 	:= IFNULL(Var_FecFinPer, Fecha_Vacia);

				IF (Var_EjeCon = Entero_Cero) THEN
					SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
							Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
						FROM PERIODOCONTABLE
						WHERE Fin   <= Par_Fecha;
				END IF;

				IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN
					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
							Entero_Cero, Entero_Cero,
							MAX(Cue.Naturaleza),
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
							Entero_Cero,    Entero_Cero
							FROM CUENTASCONTABLES Cue
							LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
																 AND Pol.Fecha <= Par_Fecha
																 AND Pol.CentroCostoID >= Par_CCInicial
																 AND Pol.CentroCostoID <= Par_CCFinal )
							GROUP BY Cue.CuentaCompleta;

					UPDATE  TMPCONTABLEBALANCE  TMP,
							CUENTASCONTABLES    Cue SET
						TMP.Naturaleza = Cue.Naturaleza
					WHERE Cue.CuentaCompleta = TMP.CuentaContable
					  AND TMP.NumeroTransaccion = Aud_NumTransaccion;

					SET Var_Ubicacion   := Ubi_Actual;

				ELSE
					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
						Entero_Cero, Entero_Cero,
						MAX(Cue.Naturaleza),
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

				FROM    TMPCONTABLEBALANCE Tmp,
						SALDOSCONTABLES Sal
				 WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Sal.FechaCorte    = Var_FechaSaldos
				  AND Sal.CuentaCompleta = Tmp.CuentaContable
				  AND Sal.CentroCosto >= Par_CCInicial
				  AND Sal.CentroCosto <= Par_CCFinal
				GROUP BY Sal.CuentaCompleta;

				 UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable    = Tmp.CuentaContable;


				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

				INSERT INTO TMPBALANZACONTA
					(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
					`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
					`CuentaMayor`,      	`CentroCosto`)
				SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo),   Cadena_Vacia, Entero_Cero,  Entero_Cero,
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

				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
													AND Pol.Fecha = Var_FechaSistema
													AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				 AND Fin.EsCalculado = NoEsCalculado
					AND Fin.NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID;

				IF(For_ResulNeto != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						For_ResulNeto,      Var_Ubicacion,  Por_Fecha,          Par_Fecha,          Var_UltEjercicioCie,
						Var_UltPeriodoCie,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
						Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);


					INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,		`Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,               `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,     	   `CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	"CapResNeto",      	 	Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
						Entero_Cero,        	Entero_Cero,        	Par_AcumuladoCta,   	Entero_Cero,   		Des_ResulNeto,
						Cadena_Vacia, 			Cadena_Vacia);
				END IF;


				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = (SaldoDeudor)
				WHERE NumeroTransaccion = Aud_NumTransaccion;

				SET Var_CapitalGanado   := (
							SELECT SUM(SaldoDeudor)
							FROM TMPBALANZACONTA
							WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
								CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
								CuentaContable LIKE'CapResNeto' )
							AND NumeroTransaccion = Aud_NumTransaccion
							);

				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_CapitalGanado
				WHERE CuentaContable LIKE "CapitalGanado"
				 AND NumeroTransaccion = Aud_NumTransaccion;

				SET Var_TotPasCapCont:= (
									SELECT SUM(SaldoDeudor)
									FROM TMPBALANZACONTA
									WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
										CuentaContable LIKE'CapContribuido' )
									AND NumeroTransaccion = Aud_NumTransaccion
									);
				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_TotPasCapCont
				WHERE CuentaContable LIKE "TotPasCapCont"
				AND NumeroTransaccion = Aud_NumTransaccion;

				IF(Par_Cifras = Cifras_Miles) THEN
					UPDATE TMPBALANZACONTA SET
						SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
						WHERE NumeroTransaccion = Aud_NumTransaccion;

				END IF;

				SELECT SaldoDeudor INTO Var_CapSocialAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapSocial'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapFondoReservaAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapFondoSocReserva'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResultadoEjeAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResultadoEjeAnt'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapAporFutAumCapAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapAporFutAumCap'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapRegimenSOFIPO'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResNetoAct
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResNeto'
					ORDER BY CuentaContable;
				DELETE FROM TMPCONTABLEBALANCE
					WHERE NumeroTransaccion = Aud_NumTransaccion;

				DELETE FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion;
			END IF;
		END IF;


		IF(Var_Fecha != Fecha_Vacia) THEN

			SELECT  MAX(EjercicioID) INTO Var_UltEjercicioCieAnt
				FROM PERIODOCONTABLE Per
				WHERE Per.Fin	< Var_Fecha
				  AND Per.Estatus = Est_Cerrado;

			SET Var_UltEjercicioCieAnt    := IFNULL(Var_UltEjercicioCieAnt, Entero_Cero);

			IF(Var_UltEjercicioCieAnt != Entero_Cero) THEN
				SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCieAnt
					FROM PERIODOCONTABLE Per
					WHERE Per.EjercicioID	= Var_UltEjercicioCieAnt
					  AND Per.Estatus = Est_Cerrado
					  AND Per.Fin	< Var_Fecha;
			END IF;

			SET Var_UltPeriodoCieAnt    := IFNULL(Var_UltPeriodoCieAnt, Entero_Cero);



			SET Var_MesAnt   := (SELECT month(Var_Fecha));

			 SELECT MAX(FechaCorte) INTO Var_FechaSaldos
					FROM  SALDOSCONTABLES
					WHERE FechaCorte < Var_Fecha;
			SET Var_FechaSaldos = IFNULL(Var_FechaSaldos, Fecha_Vacia);

			IF (Var_FechaSaldos = Fecha_Vacia) THEN

				SET Var_FecIniPer := date_format(Var_Fecha,'%Y-%m-01');
				SELECT MAX(Fecha) from `HIS-DETALLEPOL`
				INTO Var_MaxFechaHis;

				SET Var_MaxFechaHis := IFNUll(Var_MaxFechaHis,Fecha_Vacia);

				IF Var_Fecha > Var_MaxFechaHis THEN
					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
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
														 AND Pol.Fecha <= Var_Fecha
														 AND Pol.CentroCostoID >= Par_CCInicial
														 AND Pol.CentroCostoID <= Par_CCFinal )
					GROUP BY Cue.CuentaCompleta;

					UPDATE  TMPCONTABLEBALANCE  TMP,
							CUENTASCONTABLES    Cue SET
						TMP.Naturaleza = Cue.Naturaleza
					WHERE Cue.CuentaCompleta = TMP.CuentaContable
					  AND TMP.NumeroTransaccion = Aud_NumTransaccion;

					SET Var_Ubicacion   := Ubi_Actual;

				ELSE
					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
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
															AND Pol.Fecha <=    Var_Fecha
															AND Pol.CentroCostoID >= Par_CCInicial
															AND Pol.CentroCostoID <= Par_CCFinal)
					GROUP BY Cue.CuentaCompleta;

					SET Var_Ubicacion   := Ubi_Histor;
				END IF;


			INSERT INTO TMPBALANZACONTA
					(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
					`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
					`CuentaMayor`,			`CentroCosto`)
				SELECT 	Aud_NumTransaccion, 	Fin.NombreCampo, 	Cadena_Vacia,
					Entero_Cero, 			Entero_Cero, 		Entero_Cero,
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
				   Fin.Desplegado, Cadena_Vacia, Cadena_Vacia
				FROM CONCEPESTADOSFIN Fin
				LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable

				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
												   AND Pol.NumeroTransaccion    = Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				 AND Fin.EsCalculado = NoEsCalculado
				AND Fin.NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Desplegado;

				IF(For_ResulNeto != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						For_ResulNeto,      Var_Ubicacion,     Por_Fecha,          Var_Fecha,          Var_UltEjercicioCieAnt,
						Var_UltPeriodoCieAnt,  Var_FecIniPer,      Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
						Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,		`Grupo`,				`SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,               `SaldoDeudor`,			`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,      	`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	"CapResNeto",       	Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
						Entero_Cero,        	Entero_Cero,        	Par_AcumuladoCta,   	Entero_Cero,    	Des_ResulNeto,
						Cadena_Vacia, 			Cadena_Vacia);
				END IF;


				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = (SaldoDeudor)
				WHERE NumeroTransaccion = Aud_NumTransaccion;

				SET Var_CapitalGanado   := (
							SELECT SUM(SaldoDeudor)
							FROM TMPBALANZACONTA
							WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
								CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
								CuentaContable LIKE'CapResNeto' )
							AND NumeroTransaccion = Aud_NumTransaccion
							);

				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_CapitalGanado
				WHERE CuentaContable LIKE "CapitalGanado"
				 AND NumeroTransaccion = Aud_NumTransaccion;

				SET Var_TotPasCapCont:= (
									SELECT SUM(SaldoDeudor)
									FROM TMPBALANZACONTA
									WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
										CuentaContable LIKE'CapContribuido' )
									AND NumeroTransaccion = Aud_NumTransaccion
									);
				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_TotPasCapCont
				WHERE CuentaContable LIKE "TotPasCapCont"
				AND NumeroTransaccion = Aud_NumTransaccion;

				IF(Par_Cifras = Cifras_Miles) THEN
					UPDATE TMPBALANZACONTA SET
						SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
						WHERE NumeroTransaccion = Aud_NumTransaccion;

				END IF;

				SELECT SaldoDeudor INTO Var_CapSocialAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapSocial'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapFondoReservaAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapFondoSocReserva'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResultadoEjeAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResultadoEjeAnt'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResNetoAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResNeto'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapAporFutAumCapAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapAporFutAumCap'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapRegimenSOFIPO'
					ORDER BY CuentaContable;

				DELETE FROM TMPCONTABLEBALANCE
					WHERE NumeroTransaccion = Aud_NumTransaccion;

				DELETE FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion;


			ELSE

				SELECT  EjercicioID, PeriodoID, Inicio, Fin INTO
					  Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
					FROM PERIODOCONTABLE
					WHERE Inicio <= Var_Fecha
					  AND Fin     >= Var_Fecha;

				SET Var_EjeCon 		:= IFNULL(Var_EjeCon, Entero_Cero);
				SET Var_PerCon 		:= IFNULL(Var_PerCon, Entero_Cero);
				SET Var_FecIniPer 	:= IFNULL(Var_FecIniPer, Fecha_Vacia);
				SET Var_FecFinPer 	:= IFNULL(Var_FecFinPer, Fecha_Vacia);

				IF (Var_EjeCon = Entero_Cero) THEN
					SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio), MAX(Fin) INTO
							Var_EjeCon, Var_PerCon, Var_FecIniPer, Var_FecFinPer
						FROM PERIODOCONTABLE
						WHERE Fin   <= Var_Fecha;
				END IF;

				IF (Var_EjeCon = Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
							Entero_Cero, Entero_Cero,
							MAX(Cue.Naturaleza),
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
							Entero_Cero,    Entero_Cero
					FROM CUENTASCONTABLES Cue
					LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
														 AND Pol.Fecha <= Var_Fecha
														 AND Pol.CentroCostoID >= Par_CCInicial
														 AND Pol.CentroCostoID <= Par_CCFinal )
					GROUP BY Cue.CuentaCompleta;

					UPDATE  TMPCONTABLEBALANCE  TMP,
							CUENTASCONTABLES    Cue SET
						TMP.Naturaleza = Cue.Naturaleza
					WHERE Cue.CuentaCompleta = TMP.CuentaContable
					  AND TMP.NumeroTransaccion = Aud_NumTransaccion;

					SET Var_Ubicacion   := Ubi_Actual;

				ELSE

					INSERT INTO TMPCONTABLEBALANCE
					SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Entero_Cero,
							Entero_Cero, Entero_Cero,
							MAX(Cue.Naturaleza),
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
					LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
																AND Pol.Fecha >=    Var_FecIniPer
																AND Pol.Fecha <=    Var_Fecha
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

				FROM    TMPCONTABLEBALANCE Tmp,
						SALDOSCONTABLES Sal
				 WHERE  Tmp.NumeroTransaccion = Aud_NumTransaccion
				 AND Sal.FechaCorte    = Var_FechaSaldos
				  AND Sal.CuentaCompleta = Tmp.CuentaContable
				  AND Sal.CentroCosto >= Par_CCInicial
				  AND Sal.CentroCosto <= Par_CCFinal
				GROUP BY Sal.CuentaCompleta;

				UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable    = Tmp.CuentaContable;

				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;




				INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,      	`CentroCosto`)
				SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo),   Cadena_Vacia, Entero_Cero,  Entero_Cero,
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
				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
														AND Pol.Fecha = Var_FechaSistema
														AND Pol.NumeroTransaccion   = Aud_NumTransaccion)

				WHERE Fin.EstadoFinanID = Tif_Balance
				 AND Fin.EsCalculado = NoEsCalculado
					AND Fin.NumClien = NumCliente
				GROUP BY Fin.ConceptoFinanID;

				IF(For_ResulNeto != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						For_ResulNeto,      Var_Ubicacion,  Por_Fecha,          Var_Fecha,          Var_UltEjercicioCieAnt,
						Var_UltPeriodoCieAnt,  Var_FecIniPer,  Par_AcumuladoCta,   Par_CCInicial,      Par_CCFinal,
						Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);


					INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,		`Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,               `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,     	   `CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	"CapResNeto",      	 	Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
						Entero_Cero,        	Entero_Cero,        	Par_AcumuladoCta,   	Entero_Cero,   		Des_ResulNeto,
						Cadena_Vacia, 			Cadena_Vacia);
				END IF;


				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = (SaldoDeudor)
				WHERE NumeroTransaccion = Aud_NumTransaccion;

				SET Var_CapitalGanado   := (
								SELECT SUM(SaldoDeudor)
								FROM TMPBALANZACONTA
								WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
									CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
									CuentaContable LIKE'CapResNeto' )
								AND NumeroTransaccion = Aud_NumTransaccion
								);

				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_CapitalGanado
				WHERE CuentaContable LIKE "CapitalGanado"
				 AND NumeroTransaccion = Aud_NumTransaccion;

				SET Var_TotPasCapCont:= (
										SELECT SUM(SaldoDeudor)
										FROM TMPBALANZACONTA
										WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
											CuentaContable LIKE'CapContribuido' )
										AND NumeroTransaccion = Aud_NumTransaccion
										);


				UPDATE  TMPBALANZACONTA SET
					SaldoDeudor = Var_TotPasCapCont
				WHERE CuentaContable LIKE "TotPasCapCont"
				AND NumeroTransaccion = Aud_NumTransaccion;

				IF(Par_Cifras = Cifras_Miles) THEN
					UPDATE TMPBALANZACONTA SET
						SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
						WHERE NumeroTransaccion = Aud_NumTransaccion;

				END IF;

				SELECT SaldoDeudor INTO Var_CapSocialAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapSocial'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapFondoReservaAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapFondoSocReserva'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResultadoEjeAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResultadoEjeAnt'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapResNetoAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapResNeto'
					ORDER BY CuentaContable;


				SELECT SaldoDeudor INTO Var_CapAporFutAumCapAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapAporFutAumCap'
					ORDER BY CuentaContable;

				SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAnt
					FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion
					AND CuentaContable = 'CapRegimenSOFIPO'
					ORDER BY CuentaContable;

				DELETE FROM TMPCONTABLEBALANCE
					WHERE NumeroTransaccion = Aud_NumTransaccion;

				DELETE FROM TMPBALANZACONTA
					WHERE NumeroTransaccion = Aud_NumTransaccion;

			END IF;
		END IF;
	END IF;


	IF(Par_TipoConsulta = Por_Periodo) THEN

		IF( Var_EjercicioID >= 1) THEN
			SET Var_Ejercicio := Par_Ejercicio - 1;

			SELECT	MAX(PeriodoID) INTO Var_NumeroPeriodo
				FROM PERIODOCONTABLE
				WHERE EjercicioID = Var_Ejercicio;

			SET Var_NumeroPeriodo    := IFNULL(Var_NumeroPeriodo, Entero_Cero);

			SET Var_Periodo := Var_NumeroPeriodo;
		END IF;

		IF Var_EjercicioID <= 1 THEN
			SET Var_Ejercicio := 2;
			SET Var_Periodo := 3;
		END IF;

		IF(Par_Periodo >=0) THEN


			IF Par_Periodo = Entero_Cero THEN
				SET Par_Periodo := 12;

				INSERT INTO TMPCONTABLEBALANCE
				SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
						Entero_Cero, Entero_Cero,
						MAX(Cue.Naturaleza),
						CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
							SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
							ELSE	Entero_Cero
						END,
						CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
							SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
							ELSE
							Entero_Cero
						END,
						Entero_Cero,Entero_Cero

				FROM CUENTASCONTABLES Cue,
					 SALDOCONTACIERREJER AS Sal
				WHERE Sal.EjercicioID		= Par_Ejercicio
				  AND Sal.PeriodoID		= Par_Periodo
				  AND Cue.CuentaCompleta = Sal.CuentaCompleta
				  AND Sal.CentroCosto >= Par_CCInicial
				  AND Sal.CentroCosto <= Par_CCFinal
				GROUP BY Cue.CuentaCompleta;

				SET Var_Ubicacion := 'A';

			ELSE

				INSERT INTO TMPCONTABLEBALANCE
				SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					MAX(Cue.Naturaleza),
					CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
						ELSE	Entero_Cero
					END,
					CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
						ELSE
						Entero_Cero
					END,
					Entero_Cero,Entero_Cero

				FROM CUENTASCONTABLES Cue,
					 SALDOSCONTABLES AS Sal
				WHERE Sal.EjercicioID		= Par_Ejercicio
				  AND Sal.PeriodoID		= Par_Periodo
				  AND Cue.CuentaCompleta = Sal.CuentaCompleta
				  AND Sal.CentroCosto >= Par_CCInicial
				  AND Sal.CentroCosto <= Par_CCFinal
				GROUP BY Cue.CuentaCompleta;

				SET Var_Ubicacion := 'H';

			END IF;

			SELECT	Inicio,Fin INTO Var_FechaInicio, Var_FechaAct
			FROM PERIODOCONTABLE
			WHERE EjercicioID   = Par_Ejercicio
			  AND PeriodoID     = Par_Periodo;

			SET Var_MesIni   := (SELECT month(Var_FechaInicio));
			SET Var_MesAct   := (SELECT month(Var_FechaAct));

			INSERT INTO TMPBALANZACONTA
				(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
				`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
				`CuentaMayor`,     		`CentroCosto`)
			SELECT  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
				Entero_Cero,        Entero_Cero,		Entero_Cero,
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

				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
												AND Pol.Fecha = Var_FechaSistema
												AND Pol.NumeroTransaccion	= Aud_NumTransaccion)

			WHERE Fin.EstadoFinanID = Tif_Balance
			  AND Fin.EsCalculado = NoEsCalculado
				AND Fin.NumClien = NumCliente
			GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;

			SELECT	Fin INTO Var_FecConsulta
			FROM PERIODOCONTABLE
			WHERE EjercicioID   = Par_Ejercicio
			  AND PeriodoID     = Par_Periodo;

			IF(For_ResulNeto != Cadena_Vacia) THEN


				IF Var_Ubicacion = 'A' THEN
					CALL EVALFORMULAPERIFINPRO(Par_AcumuladoCta,	For_ResulNeto,		UbicaSaldoConta,	CalculoFecha, 	Var_FecConsulta);
				ELSE
					CALL EVALFORMULAREGPRO(Par_AcumuladoCta,	For_ResulNeto,		UbicaSaldoConta,	CalculoFecha, 	Var_FecConsulta);
				END IF;


				INSERT INTO TMPBALANZACONTA
					(`NumeroTransaccion`,   `CuentaContable`,       `Grupo`,            	`SaldoInicialDeu`,      `SaldoInicialAcre`,
					`Cargos`,               `Abonos`,               `SaldoDeudor`,			`SaldoAcreedor`,        `DescripcionCuenta`,
					`CuentaMayor`,      	`CentroCosto`)
				VALUES(
					Aud_NumTransaccion, 	"CapResNeto",      		 Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
					Entero_Cero,        	Entero_Cero,       		 Par_AcumuladoCta,   	Entero_Cero,   		Des_ResulNeto,
					Cadena_Vacia, 			Cadena_Vacia);
			END IF;


			UPDATE TMPBALANZACONTA SET
				SaldoDeudor     = (SaldoDeudor)
			WHERE NumeroTransaccion = Aud_NumTransaccion;

			SET Var_CapitalGanado   := (
							SELECT SUM(SaldoDeudor)
							FROM TMPBALANZACONTA
							WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
								CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
								CuentaContable LIKE'CapResNeto' )
							AND NumeroTransaccion = Aud_NumTransaccion
							);

			UPDATE  TMPBALANZACONTA SET
				SaldoDeudor = Var_CapitalGanado
			WHERE CuentaContable LIKE "CapitalGanado"
			  AND NumeroTransaccion = Aud_NumTransaccion;

			SET Var_TotPasCapCont:= (
									SELECT SUM(SaldoDeudor)
									FROM TMPBALANZACONTA
									WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
										CuentaContable LIKE'CapContribuido' )
									AND NumeroTransaccion = Aud_NumTransaccion
									);
			UPDATE  TMPBALANZACONTA SET
				SaldoDeudor = Var_TotPasCapCont
			WHERE CuentaContable LIKE "TotPasCapCont"
			AND NumeroTransaccion = Aud_NumTransaccion;

			IF(Par_Cifras = Cifras_Miles) THEN
				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
					WHERE NumeroTransaccion = Aud_NumTransaccion;
			END IF;

			SELECT SaldoDeudor INTO Var_CapSocialAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapSocial'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapFondoReservaAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapFondoSocReserva'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapResultadoEjeAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapResultadoEjeAnt'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapResNetoAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapResNeto'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapAporFutAumCapAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapAporFutAumCap'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAct
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapRegimenSOFIPO'
				ORDER BY CuentaContable;

			DELETE FROM TMPCONTABLEBALANCE
				WHERE NumeroTransaccion = Aud_NumTransaccion;

			DELETE FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion;
		END IF;


		IF(Var_Periodo >0) THEN

			SELECT	Fin INTO Var_FechaAnt
			FROM PERIODOCONTABLE
			WHERE EjercicioID   = Var_Ejercicio
			  AND PeriodoID     = Var_Periodo;

			SET Var_MesAnt   := (SELECT month(Var_FechaAnt));

			INSERT INTO TMPCONTABLEBALANCE
			SELECT  Aud_NumTransaccion,	Var_FechaSistema,	Cue.CuentaCompleta,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					MAX(Cue.Naturaleza),
					CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
						ELSE	Entero_Cero
					END,
					CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
						SUM((IFNULL(Sal.SaldoFinal, Entero_Cero)))
						ELSE
						Entero_Cero
					END,
					Entero_Cero,Entero_Cero

			FROM CUENTASCONTABLES Cue,
				 SALDOSCONTABLES AS Sal
			WHERE Sal.EjercicioID		= Var_Ejercicio
			  AND Sal.PeriodoID		= Var_Periodo
			  AND Cue.CuentaCompleta = Sal.CuentaCompleta
			  AND Sal.CentroCosto >= Par_CCInicial
			  AND Sal.CentroCosto <= Par_CCFinal
			GROUP BY Cue.CuentaCompleta;

			INSERT INTO TMPBALANZACONTA
				(`NumeroTransaccion`,   `CuentaContable`,           `Grupo`,            `SaldoInicialDeu`,      `SaldoInicialAcre`,
				`Cargos`,               `Abonos`,                   `SaldoDeudor`,		`SaldoAcreedor`,        `DescripcionCuenta`,
				`CuentaMayor`,     		`CentroCosto`)
			SELECT  Aud_NumTransaccion, Fin.NombreCampo,    Cadena_Vacia,
				Entero_Cero,        Entero_Cero,		Entero_Cero,
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

				LEFT OUTER JOIN TMPCONTABLEBALANCE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
												AND Pol.Fecha = Var_FechaSistema
												AND Pol.NumeroTransaccion	= Aud_NumTransaccion)

			WHERE Fin.EstadoFinanID = Tif_Balance
			  AND Fin.EsCalculado = NoEsCalculado
				AND Fin.NumClien = NumCliente
			GROUP BY Fin.ConceptoFinanID, Fin.NombreCampo, Fin.Descripcion;

			SELECT	Fin INTO Var_FecConsulta
					FROM PERIODOCONTABLE
					WHERE EjercicioID   = Var_Ejercicio
					  AND PeriodoID     = Var_Periodo;

			IF(For_ResulNeto != Cadena_Vacia) THEN
				CALL EVALFORMULAREGPRO(Par_AcumuladoCta,	For_ResulNeto,		UbicaSaldoConta,	CalculoFecha, 	Var_FecConsulta);

				INSERT INTO TMPBALANZACONTA
						(`NumeroTransaccion`,   `CuentaContable`,       `Grupo`,            	`SaldoInicialDeu`,      `SaldoInicialAcre`,
						`Cargos`,               `Abonos`,               `SaldoDeudor`,			`SaldoAcreedor`,        `DescripcionCuenta`,
						`CuentaMayor`,      	`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	"CapResNeto",      		 Cadena_Vacia,       	Entero_Cero,    	Entero_Cero,
						Entero_Cero,        	Entero_Cero,       		 Par_AcumuladoCta,   	Entero_Cero,   		Des_ResulNeto,
						Cadena_Vacia, 			Cadena_Vacia);
			END IF;


			UPDATE TMPBALANZACONTA SET
				SaldoDeudor     = (SaldoDeudor)
			WHERE NumeroTransaccion = Aud_NumTransaccion;

			SET Var_CapitalGanado   := (
							SELECT SUM(SaldoDeudor)
							FROM TMPBALANZACONTA
							WHERE  (CuentaContable LIKE"CapFondoSocReserva" OR CuentaContable LIKE"CapResultadoEjeAnt" OR
								CuentaContable LIKE'CapResValTitDispVen' OR CuentaContable LIKE'CapResValTitDispVen' OR
								CuentaContable LIKE'CapResNeto' )
							AND NumeroTransaccion = Aud_NumTransaccion
							);

			UPDATE  TMPBALANZACONTA SET
				SaldoDeudor = Var_CapitalGanado
			WHERE CuentaContable LIKE "CapitalGanado"
			  AND NumeroTransaccion = Aud_NumTransaccion;

			SET Var_TotPasCapCont:= (
									SELECT SUM(SaldoDeudor)
									FROM TMPBALANZACONTA
									WHERE  (CuentaContable LIKE"PasTotalPasivo" OR CuentaContable LIKE"CapitalGanado" OR
										CuentaContable LIKE'CapContribuido' )
									AND NumeroTransaccion = Aud_NumTransaccion
									);
			UPDATE  TMPBALANZACONTA SET
				SaldoDeudor = Var_TotPasCapCont
			WHERE CuentaContable LIKE "TotPasCapCont"
			  AND NumeroTransaccion = Aud_NumTransaccion;

			IF(Par_Cifras = Cifras_Miles) THEN
				UPDATE TMPBALANZACONTA SET
					SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
					WHERE NumeroTransaccion = Aud_NumTransaccion;
			END IF;

			SELECT SaldoDeudor INTO Var_CapSocialAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapSocial'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapFondoReservaAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapFondoSocReserva'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapResultadoEjeAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapResultadoEjeAnt'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapResNetoAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapResNeto'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapAporFutAumCapAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapAporFutAumCap'
				ORDER BY CuentaContable;

			SELECT SaldoDeudor INTO Var_CapRegimenSOFIPOAnt
				FROM TMPBALANZACONTA
				WHERE NumeroTransaccion = Aud_NumTransaccion
				AND CuentaContable = 'CapRegimenSOFIPO'
				ORDER BY CuentaContable;

			DELETE FROM TMPCONTABLEBALANCE
			WHERE NumeroTransaccion = Aud_NumTransaccion;

			DELETE FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion;
		END IF;
	END IF;


	SET Var_DecimalCero     := Decimal_Cero;

	IF(Var_Fecha = '2018-03-31') THEN
		SET Var_CapResNetoAnt := Var_CapResNetoAnt / 2;
	END IF;

	SET  Var_CapitalSocial   := Var_CapSocialAct - Var_CapSocialAnt;
	SET  Var_FondoReserva    := Var_CapFondoReservaAct - Var_CapFondoReservaAnt;
	SET  Var_ResultadoAnt    := Var_CapResultadoEjeAct - Var_CapResultadoEjeAnt;
	SET  Var_ResultadoNeto   := Var_CapResNetoAct - Var_CapResNetoAnt;

	SET Var_CapSocialAct	:= IFNULL(Var_CapSocialAct, Decimal_Cero);
	SET Var_CapSocialAnt	:= IFNULL(Var_CapSocialAnt, Decimal_Cero);
	SET Var_CapFondoReservaAct	:= IFNULL(Var_CapFondoReservaAct, Decimal_Cero);
	SET Var_CapFondoReservaAnt	:= IFNULL(Var_CapFondoReservaAnt, Decimal_Cero);

	SET Var_CapResultadoEjeAct	:= IFNULL(Var_CapResultadoEjeAct, Decimal_Cero);
	SET Var_CapResultadoEjeAnt	:= IFNULL(Var_CapResultadoEjeAnt, Decimal_Cero);
	SET Var_CapResNetoAct		:= IFNULL(Var_CapResNetoAct, Decimal_Cero);
	SET Var_CapResNetoAnt		:= IFNULL(Var_CapResNetoAnt, Decimal_Cero);

	SET Var_CapitalSocial	:= IFNULL(Var_CapitalSocial, Decimal_Cero);
	SET Var_FondoReserva	:= IFNULL(Var_FondoReserva, Decimal_Cero);
	SET Var_ResultadoAnt	:= IFNULL(Var_ResultadoAnt, Decimal_Cero);
	SET Var_ResultadoNeto	:= IFNULL(Var_ResultadoNeto, Decimal_Cero);

	SET Var_FechaAnt  := IFNULL(Var_FechaAnt, Fecha_Vacia);
	SET Var_MesAnt    := IFNULL(Var_MesAnt, Decimal_Cero);

	SET Var_CapAporFutAumCap := IFNULL(Var_CapAporFutAumCapAct,0) - IFNULL(Var_CapAporFutAumCapAnt,0);
	SET Var_CapRegimenSOFIPO := IFNULL(Var_CapRegimenSOFIPOAct,0) - IFNULL(Var_CapRegimenSOFIPOAnt,0);

	SET Var_MesIni   := (SELECT month(Var_FechaInicio));

	SELECT 	Var_CapSocialAct, 			Var_CapFondoReservaAct,		Var_CapResultadoEjeAct,		Var_CapResNetoAct,
			Var_CapSocialAnt, 			Var_CapFondoReservaAnt,		Var_CapResultadoEjeAnt,		Var_CapResNetoAnt,
			Var_CapitalSocial,			Var_FondoReserva,			Var_ResultadoAnt,			Var_ResultadoNeto,
			Var_MesAnt,					Var_MesAct,					Var_FechaAnt,				Var_FechaAct,
			Var_FechaInicio,			Var_MesIni,					Decimal_Cero,				Var_CapAporFutAumCap,
			Var_CapAporFutAumCapAnt, 	Var_CapAporFutAumCapAct,    Var_CapRegimenSOFIPO, 		Var_CapRegimenSOFIPOAnt,
			Var_CapRegimenSOFIPOAct;


	DELETE FROM TMPCONTABLEBALANCE
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$