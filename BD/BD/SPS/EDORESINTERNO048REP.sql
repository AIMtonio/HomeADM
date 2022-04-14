-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNO048REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNO048REP`;

DELIMITER $$
CREATE PROCEDURE `EDORESINTERNO048REP`(
	-- SP para generar el Estado de Resultados del Cliente: NATGAS
	-- Modulo de Contabilidad --> Reportes --> Reportes Financieros

	Par_Ejercicio		INT(11),		-- Ejercicio a consultar
	Par_Periodo			INT(11),		-- Periodo a consultar
	Par_Fecha			DATE,			-- Fecha de consulta
	Par_TipoConsulta	CHAR(1),		-- Tipo de consulta
	Par_SaldosCero		CHAR(1),		-- Si se toma en cuenta los saldos en 0

	Par_Cifras			CHAR(1),		-- Tipo de cifras a representar(pesos, miles)
	Par_CCInicial		INT(11),		-- Centro de costo inicial
	Par_CCFinal			INT(11),		-- Centro de costo final

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FecConsulta		DATE;				-- Fecha en la que se esta realiando la consulta
	DECLARE Var_FechaSistema	DATE;				-- Fecha que tiene el sistema
	DECLARE Var_FechaSaldos		DATE;				-- Fecha de saldos
	DECLARE Var_EjeCon			INT(11);			-- Numero del ejercicio
	DECLARE Var_PerCon			INT(11);			-- Periodo de consulta

	DECLARE Var_FecIniPer		DATE;				-- Fecha de inicio del periodo
	DECLARE Var_FecFinPer		DATE;				-- Fecha de fin del periodo
	DECLARE Var_EjercicioVig	INT(11);			-- El ejercicio es vigente
	DECLARE Var_PeriodoVig		INT(11);			-- Periodo vigente
	DECLARE Par_AcumuladoCta	DECIMAL(18,2);		-- Acumulado de cuenta

	DECLARE Var_Desplegado		VARCHAR(300);		-- Desplegado del resultado neto
	DECLARE Var_Ubicacion		CHAR(1);			-- Ubicacion
	DECLARE Var_Columna			VARCHAR(20);		-- Columna
	DECLARE Var_Monto			DECIMAL(18,2);		-- Monto de la consuta
	DECLARE Var_NombreTabla		VARCHAR(40);		-- Sentencia para Crear el Nombre de la tabla a consultar

	DECLARE Var_CreateTable		VARCHAR(9000);		-- Sentencia para Crear la tabla
	DECLARE Var_InsertTable		VARCHAR(5000);		-- Sentencia para Crear el insert de la tabla
	DECLARE Var_InsertValores	VARCHAR(5000);		-- Sentencia para Crear los valores de la tabla
	DECLARE Var_SelectTable		VARCHAR(5000);		-- Sentencia para Crear la consulta a la tabla
	DECLARE Var_DropTable		VARCHAR(5000);		-- Sentencia para Crear el delete de la tabla

	DECLARE	Var_Update			VARCHAR(5000);		-- Sentencia para Crear el Update Dinamico
	DECLARE Var_CantCaracteres	INT;				-- Cantidad de caracteres
	DECLARE Var_UltPeriodoCie	INT;				-- Ultimo periodo cierre
	DECLARE Var_UltEjercicioCie	INT;				-- Ultimo ejercicio cierre
	DECLARE Var_MinCenCos		INT(11);			-- Numero minimo de centro de costos

	DECLARE Var_MaxCenCos		INT(11);			-- Numero maximo de centro de costos
	DECLARE Var_NumeroRegistros	INT(11);			-- Numero maximo de Registros
	DECLARE Var_Contador		INT(11);			-- Contador de Ciclo
	DECLARE Var_NombreCampo		VARCHAR(20);		-- Nombre del Campo
	DECLARE Var_CuentaContable	VARCHAR(500);		-- Cuenta Contable

	DECLARE Var_ContaGeneral	VARCHAR(250);		-- Contador General
	DECLARE Var_DirectGeneral	VARCHAR(250);		-- Director General
	DECLARE Var_DirectorFinanza	VARCHAR(250);		-- Director de Finanzas
	DECLARE Var_NumCliente		INT(11);			-- Numero de Cliente Especifico
	DECLARE Var_FechaIniPerido	DATE;				-- FECHA INICIO DEL PERIODO
	DECLARE Var_FechaFinPeriodo	DATE;				-- FECHA FIN DEL PERIODO
	DECLARE Var_DesFechaPeriodo	VARCHAR(200);		-- DESCRIPCION DE LA FECHA DEL PERIODO

	DECLARE Var_FirmaRepLegal	VARCHAR(200);       -- Firma Representante Legal
	DECLARE Var_FirmaCoordCont	VARCHAR(200);       -- Firma Coordinardor Contable


	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);			-- Constante Entero Cero
	DECLARE Tif_EdoResul			INT(11);			-- Constante Corresponde al Estado financiero Estado de Resultados
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO

	DECLARE Est_Cerrado			CHAR(1);			-- Constante Estatus Periodo Cerrado
	DECLARE Con_Deudora			CHAR(1);			-- Constante Naturaleza deudora
	DECLARE Con_Acreedora		CHAR(1);			-- Constante Naturaleza acreedora
	DECLARE Cifras_Pesos		CHAR(1);			-- Constante cifras en pesos
	DECLARE Cifras_Miles		CHAR(1);			-- Constante cifras en miles

	DECLARE Por_Peridodo		CHAR(1);			-- Constante si el balance se genera por periodo
	DECLARE Por_Fecha			CHAR(1);			-- Constante si el balance se genera por fecha
	DECLARE Por_FinPeriodo		CHAR(1);			-- Constante si el balance se genera por fin de periodo
	DECLARE Ubi_Actual			CHAR(1);			-- Constante Ubicacion actual
	DECLARE Ubi_Histor			CHAR(1);			-- Constante Ubicacion historico

	DECLARE Por_CorteMes		CHAR(1); 			-- Constante Consulta por corte del mes
	DECLARE Con_Dinamico		CHAR(1);			-- Constante Campo Dinamico
	DECLARE Tipo_Detalle		CHAR(1);			-- Constante Tipo Detalle
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha Vacia

	-- VARIABLES PARA OBTENER  FECHA FIN DE MES
	DECLARE Var_FechaFinMes DATE;

	DECLARE cur_Balance CURSOR FOR
	SELECT CuentaContable,	SaldoDeudor
	FROM TMPBALANZACONTA
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	-- Asignacion de valores
	SET Entero_Cero			:= 0;
	SET Tif_EdoResul		:= 2;
	SET Cadena_Vacia		:= '';
	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';

	SET Est_Cerrado			:= 'C';
	SET Con_Deudora			:= 'D';
	SET Con_Acreedora		:= 'A';
	SET Cifras_Pesos		:= 'P';
	SET Cifras_Miles		:= 'M';

	SET Por_Peridodo		:= 'P';
	SET Por_Fecha			:= 'D';
	SET Por_FinPeriodo		:= 'F';
	SET Ubi_Actual			:= 'A';
	SET Ubi_Histor			:= 'H';

	SET Por_CorteMes		:= 'X';
	SET Con_Dinamico		:= 'D';
	SET Tipo_Detalle		:= 'D';
	SET Entero_Uno			:= 1;
	SET Fecha_Vacia			:= '1900-01-01';
	SET Var_NumCliente		:= IFNULL(FNPARAMGENERALES('CliProcEspecifico'), 48);
	SET Var_DesFechaPeriodo := Cadena_Vacia;
	SELECT FechaSistema,	 EjercicioVigente, PeriodoVigente, JefeContabilidad, GerenteGeneral,    IFNULL(DirectorFinanzas, Cadena_Vacia)
	INTO   Var_FechaSistema, Var_EjercicioVig, Var_PeriodoVig, Var_ContaGeneral, Var_DirectGeneral, Var_DirectorFinanza
	FROM PARAMETROSSIS;

	SET Var_FirmaRepLegal	:= IFNULL(FNPARAMGENERALES('RutaFirmaRepLegal'), Cadena_Vacia);
	SET Var_FirmaCoordCont	:= IFNULL(FNPARAMGENERALES('RutaFirmaCoordCont'), Cadena_Vacia);


	SET Par_Fecha		 := IFNULL(Par_Fecha, Fecha_Vacia);
	SET Var_EjercicioVig := IFNULL(Var_EjercicioVig, Entero_Cero);
	SET Var_PeriodoVig	 := IFNULL(Var_PeriodoVig, Entero_Cero);

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	IF( Par_Fecha != Fecha_Vacia ) THEN
		SET Var_FecConsulta := Par_Fecha;
	ELSE
		SELECT Fin INTO Var_FecConsulta
		FROM PERIODOCONTABLE
		WHERE EjercicioID = Par_Ejercicio
		  AND PeriodoID = Par_Periodo;
	END IF;

	SET Par_CCInicial	:= IFNULL(Par_CCInicial, Entero_Cero);
	SET Par_CCFinal		:= IFNULL(Par_CCFinal, Entero_Cero);


	SELECT	MIN(CentroCostoID), MAX(CentroCostoID)
	INTO	Var_MinCenCos,		Var_MaxCenCos
	FROM CENTROCOSTOS;

	IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
		SET Par_CCInicial	:= Var_MinCenCos;
		SET Par_CCFinal  	:= Var_MaxCenCos;
	END IF;

	SELECT	MAX(EjercicioID)
	INTO	Var_UltEjercicioCie
	FROM PERIODOCONTABLE Per
	WHERE Per.Fin < Var_FecConsulta
	  AND Per.Estatus = Est_Cerrado;

	SET Var_UltEjercicioCie := IFNULL(Var_UltEjercicioCie, Entero_Cero);

	IF( Var_UltEjercicioCie != Entero_Cero ) THEN
		SELECT  MAX(PeriodoID)
		INTO Var_UltPeriodoCie
		FROM PERIODOCONTABLE Per
		WHERE Per.EjercicioID = Var_UltEjercicioCie
		  AND Per.Estatus = Est_Cerrado
		  AND Per.Fin < Var_FecConsulta;
	END IF;

	SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

	IF (Par_Ejercicio <> Entero_Cero AND Par_Periodo = Entero_Cero AND Par_TipoConsulta=Por_Peridodo) THEN
		SET Par_TipoConsulta := Por_FinPeriodo;
	END IF;

	-- Tabla de Sumatorias del estado de resultados
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINRESULTADODIN;
	CREATE TEMPORARY TABLE TMP_CONCEPESTADOSFINRESULTADODIN(
		NumeroRegistro 		INT(11),
		NombreCampo			VARCHAR(20),
		CuentaContable		VARCHAR(500),
		KEY `IDX_TMP_CONCEPESTADOSFINRESULTADODIN_1` (`NumeroRegistro`));

	SET @NumeroRegistro := Entero_Cero;
	INSERT INTO TMP_CONCEPESTADOSFINRESULTADODIN(
		NumeroRegistro,NombreCampo, CuentaContable)
	SELECT @NumeroRegistro:=(@NumeroRegistro+Entero_Uno), IFNULL(NombreCampo,Cadena_Vacia), IFNULL(CuentaContable, Cadena_Vacia)
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_EdoResul
	  AND NumClien = Var_NumCliente
	  AND EsCalculado = Con_Dinamico;

	-- Tabla de Campos Calculados del estado de resultados
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINRESULTADO;
	CREATE TEMPORARY TABLE TMP_CONCEPESTADOSFINRESULTADO(
		NumeroRegistro 		INT(11),
		NombreCampo			VARCHAR(20),
		CuentaContable		VARCHAR(500),
		Desplegado 			VARCHAR(300),
		KEY `IDX_TMP_CONCEPESTADOSFINRESULTADO_1` (`NumeroRegistro`));

	SET @NumeroRegistro := Entero_Cero;
	INSERT INTO TMP_CONCEPESTADOSFINRESULTADO(
		NumeroRegistro,NombreCampo, CuentaContable,Desplegado )
	SELECT @NumeroRegistro:=(@NumeroRegistro+1), IFNULL(NombreCampo,Cadena_Vacia), IFNULL(CuentaContable, Cadena_Vacia), IFNULL(Desplegado,Cadena_Vacia)
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_EdoResul
	  AND NumClien = Var_NumCliente
	  AND EsCalculado = Con_SI;

	SELECT IFNULL(MAX(NumeroRegistro),Entero_Cero)
	INTO Var_NumeroRegistros
	FROM TMP_CONCEPESTADOSFINRESULTADO;

	IF( Par_TipoConsulta = Por_Fecha ) THEN

		SET Var_DesFechaPeriodo := UPPER(CONCAT('Al ',FUNCIONLETRASFECHA(Par_Fecha)));

		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
		FROM  SALDOSCONTABLES
		WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos	:= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		IF (Var_FechaSaldos = Fecha_Vacia) THEN

			INSERT INTO TMPCONTABLE (
				NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
				Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
				SaldoInicialAcr)
			SELECT	Aud_NumTransaccion, Var_FecConsulta, Cue.CuentaCompleta,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					(Cue.Naturaleza),
					CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
							SUM(IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero))
						 ELSE
							Entero_Cero
					END AS SaldoDeudor,
					CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
							SUM(IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero))
						 ELSE
							Entero_Cero
					END AS SaldoAcreedor,
					Entero_Cero, Entero_Cero
			FROM CUENTASCONTABLES Cue
			LEFT OUTER JOIN SALDOSDETALLEPOLIZA AS Pol ON (Pol.Fecha <= Par_Fecha
													   AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
													   AND Pol.CuentaCompleta = Cue.CuentaCompleta)
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

			IF( Par_Fecha = Var_FechaSistema ) THEN

				DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

				INSERT INTO TMPBALPOLCENCOSDIA (
						NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
				SELECT	Aud_NumTransaccion, MAX(IFNULL(Cue.CuentaCompleta, Cadena_Vacia)), Entero_Cero,
						CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
								SUM(IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero))
							 ELSE
								Entero_Cero
						END,
						CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
								SUM(IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero))
							 ELSE
								Entero_Cero
						END
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Pol.Fecha = Var_FechaSistema
													 AND Pol.CuentaCompleta = Cue.CuentaCompleta
													 AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
				WHERE Cue.Grupo = Tipo_Detalle
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
					NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
					Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
					CuentaMayor,		CentroCosto)
			SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = Con_Deudora THEN
								 IFNULL(Pol.SaldoDeudor, Entero_Cero) - IFNULL(Pol.SaldoAcreedor, Entero_Cero)
							 ELSE
								 IFNULL(Pol.SaldoAcreedor, Entero_Cero) - IFNULL(Pol.SaldoDeudor, Entero_Cero)
					END),
					Entero_Cero,
					MAX(Fin.Desplegado), Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.NumeroTransaccion = Aud_NumTransaccion)
			WHERE Fin.EstadoFinanID = Tif_EdoResul
			  AND Fin.EsCalculado = Con_NO
			  AND Fin.NumClien = Var_NumCliente
			GROUP BY Fin.ConceptoFinanID;

			IF(Var_NumeroRegistros > Entero_Cero) THEN

				SET Var_Contador := Entero_Uno;

				WHILE( Var_Contador <= Var_NumeroRegistros) DO

					SELECT NombreCampo,	  CuentaContable,	  Desplegado
					INTO Var_NombreCampo, Var_CuentaContable, Var_Desplegado
					FROM TMP_CONCEPESTADOSFINRESULTADO
					WHERE NumeroRegistro = Var_Contador;

					IF( Var_CuentaContable != Cadena_Vacia ) THEN
						CALL `EVALFORMULACONTAPRO`(
							Var_CuentaContable,	Ubi_Actual,			Por_Fecha,			Par_Fecha,			Var_UltEjercicioCie,
							Var_UltPeriodoCie,	Par_Fecha,			Par_AcumuladoCta,	Par_CCInicial,		Par_CCFinal,
							Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						INSERT INTO TMPBALANZACONTA	(
							NumeroTransaccion,	CuentaContable,		Grupo,				SaldoInicialDeu,	SaldoInicialAcre,
							Cargos,				Abonos,				SaldoDeudor,		SaldoAcreedor,		DescripcionCuenta,
							CuentaMayor,		CentroCosto)
						VALUES(
							Aud_NumTransaccion,	Var_NombreCampo,	Cadena_Vacia,		Entero_Cero,		Entero_Cero,
							Entero_Cero,		Entero_Cero,		Par_AcumuladoCta,	Entero_Cero,		Var_Desplegado,
							Cadena_Vacia,		Cadena_Vacia);
					END IF;

					SET Var_Contador := Var_Contador + Entero_Uno;
					SET Var_Desplegado := Cadena_Vacia;
					SET Var_NombreCampo := Cadena_Vacia;
					SET Var_CuentaContable := Cadena_Vacia;
					SET Par_AcumuladoCta := Entero_Cero;

				END WHILE;

			END IF;

		ELSE

			SELECT	EjercicioID, PeriodoID,  Inicio,        Fin
			INTO	Var_EjeCon,  Var_PerCon, Var_FecIniPer, Var_FecFinPer
			FROM PERIODOCONTABLE
			WHERE Inicio <= Par_Fecha
			  AND Fin >= Par_Fecha;

			SET Var_EjeCon := IFNULL(Var_EjeCon, Entero_Cero);
			SET Var_PerCon := IFNULL(Var_PerCon, Entero_Cero);
			SET Var_FecIniPer := IFNULL(Var_FecIniPer, Fecha_Vacia);
			SET Var_FecFinPer := IFNULL(Var_FecFinPer, Fecha_Vacia);

			IF (Var_EjeCon = Entero_Cero) THEN
				SELECT	MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio),	 MAX(Fin)
				INTO	Var_EjeCon,		  Var_PerCon,	  Var_FecIniPer, Var_FecFinPer
				FROM PERIODOCONTABLE
				WHERE Fin <= Par_Fecha;
			END IF;

			IF (Var_EjeCon >= Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN

				INSERT INTO TMPCONTABLE (
					NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
					Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
					SaldoInicialAcr)
				SELECT	Aud_NumTransaccion,	Var_FechaSistema,	IFNULL(Cue.CuentaCompleta, ""), Entero_Cero,
						Entero_Cero, Entero_Cero,
						(Cue.Naturaleza),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
									IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
									IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
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
					SELECT	Aud_NumTransaccion, IFNULL(Pol.CuentaCompleta, ""), Entero_Cero,
							SUM(CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
										IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
									 ELSE
										Entero_Cero
								END),
							SUM(CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
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

				UPDATE TMPCONTABLE TMP, CUENTASCONTABLES Cue SET
					TMP.Naturaleza = Cue.Naturaleza
				WHERE Cue.CuentaCompleta = IFNULL(TMP.CuentaContable, "")
				  AND TMP.NumeroTransaccion = Aud_NumTransaccion;

				SET Var_Ubicacion   := Ubi_Actual;

			ELSE

				INSERT INTO TMPCONTABLE (
					NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
					Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
					SaldoInicialAcr)
				SELECT  Aud_NumTransaccion,	Var_FechaSistema,	IFNULL(Cue.CuentaCompleta, ""),	Entero_Cero,
						Entero_Cero, Entero_Cero,
						(Cue.Naturaleza),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
									IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
									IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						Entero_Cero,Entero_Cero
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN HISSALDOSDETPOLIZA AS Pol ON (Pol.Fecha BETWEEN Var_FecIniPer AND Par_Fecha
														  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
														  AND Pol.CuentaCompleta = Cue.CuentaCompleta)
				GROUP BY Cue.CuentaCompleta;

				SET Var_Ubicacion   := Ubi_Histor;

			END IF;

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
			INSERT INTO TMPSALDOCONTABLE (NumeroTransaccion, CuentaContable, SaldoInicialDeu, SaldoInicialAcr)
			SELECT  Aud_NumTransaccion, IFNULL(Sal.CuentaCompleta,""),
					SUM(
						CASE WHEN Tmp.Naturaleza = Con_Deudora  THEN
								Sal.SaldoFinal
							 ELSE
								Entero_Cero
						END) AS SaldoInicialDeudor,
					SUM(CASE WHEN Tmp.Naturaleza = Con_Acreedora  THEN
								Sal.SaldoFinal
							 ELSE
								Entero_Cero
						END) AS SaldoInicialAcreedor
			FROM TMPCONTABLE Tmp
			INNER JOIN SALDOSCONTABLES Sal ON Sal.FechaCorte = Var_FechaSaldos
										  AND Sal.CuentaCompleta = Tmp.CuentaContable
										  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			GROUP BY Sal.CuentaCompleta;

			UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
				Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
				Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
			  AND Tmp.CuentaContable = Sal.CuentaContable;

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

			INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
					Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
					CuentaMayor,		CentroCosto)
			SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo),	Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = Con_Deudora THEN
								(IFNULL(Pol.SaldoInicialDeu, Entero_Cero) - IFNULL(Pol.SaldoInicialAcr, Entero_Cero)) +
								(IFNULL(Pol.SaldoDeudor, Entero_Cero) 	  - IFNULL(Pol.SaldoAcreedor, Entero_Cero))
							 ELSE
								(IFNULL(Pol.SaldoInicialAcr, Entero_Cero) - IFNULL(Pol.SaldoInicialDeu, Entero_Cero)) +
								(IFNULL(Pol.SaldoAcreedor, Entero_Cero)   - IFNULL(Pol.SaldoDeudor, Entero_Cero))
						END),
					Entero_Cero,
					MAX(Fin.Descripcion), Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.Fecha = Var_FechaSistema
											   AND Pol.NumeroTransaccion = Aud_NumTransaccion)
			WHERE Fin.EstadoFinanID = Tif_EdoResul
			  AND Fin.EsCalculado = Con_NO
			  AND Fin.NumClien = Var_NumCliente
			GROUP BY Fin.ConceptoFinanID;

			IF(Var_NumeroRegistros > Entero_Cero) THEN

				SET Var_Contador := Entero_Uno;

				WHILE( Var_Contador <= Var_NumeroRegistros) DO

					SELECT NombreCampo, CuentaContable, Desplegado
					INTO Var_NombreCampo, Var_CuentaContable,Var_Desplegado
					FROM TMP_CONCEPESTADOSFINRESULTADO
					WHERE NumeroRegistro = Var_Contador;

					IF(Var_CuentaContable != Cadena_Vacia) THEN
						CALL `EVALFORMULACONTAPRO`(
							Var_CuentaContable,	Var_Ubicacion,		Por_Fecha,			Par_Fecha,			Var_UltEjercicioCie,
							Var_UltPeriodoCie,	Var_FecIniPer,		Par_AcumuladoCta,	Par_CCInicial,		Par_CCFinal,
							Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						INSERT INTO TMPBALANZACONTA	(
								NumeroTransaccion,	CuentaContable,		Grupo,				SaldoInicialDeu,	SaldoInicialAcre,
								Cargos,				Abonos,				SaldoDeudor,		SaldoAcreedor,		DescripcionCuenta,
								CuentaMayor,		CentroCosto)
						VALUES(
								Aud_NumTransaccion,	Var_NombreCampo,	Cadena_Vacia,		Entero_Cero,		Entero_Cero,
								Entero_Cero,		Entero_Cero,		Par_AcumuladoCta,	Entero_Cero,		Var_Desplegado,
								Cadena_Vacia,		Cadena_Vacia);
					END IF;

					SET Var_Contador := Var_Contador + Entero_Uno;
					SET Var_Desplegado := Cadena_Vacia;
					SET Var_NombreCampo := Cadena_Vacia;
					SET Var_CuentaContable := Cadena_Vacia;
					SET Par_AcumuladoCta := Entero_Cero;

				END WHILE;

			END IF;

		END IF;
	END IF;

	IF( Par_TipoConsulta = Por_Peridodo ) THEN

		SELECT 	 Inicio, 				Fin
		INTO Var_FechaIniPerido,	Var_FechaFinPeriodo
		FROM PERIODOCONTABLE
		WHERE EjercicioID =Par_Ejercicio
		  AND PeriodoID = Par_Periodo;

		SET Var_DesFechaPeriodo := UPPER(CONCAT('Del ',FUNCIONLETRASFECHA(Var_FechaIniPerido), ' al ', FUNCIONLETRASFECHA(Var_FechaFinPeriodo)));

		INSERT INTO TMPCONTABLE (
			NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
			Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
			SaldoInicialAcr)
		SELECT  Aud_NumTransaccion,	Var_FechaSistema,	IFNULL(Cue.CuentaCompleta, ""),	Entero_Cero,
				Entero_Cero, Entero_Cero,
				(Cue.Naturaleza),
				SUM(
					CASE WHEN (Cue.Naturaleza) = Con_Deudora  THEN
							IFNULL(Sal.SaldoFinal, Entero_Cero)
						 ELSE
							Entero_Cero
					END),
				SUM(
					CASE WHEN (Cue.Naturaleza) = Con_Acreedora  THEN
							IFNULL(Sal.SaldoFinal, Entero_Cero)
						ELSE
							Entero_Cero
					END),
				Entero_Cero,Entero_Cero
		FROM CUENTASCONTABLES Cue
		LEFT OUTER JOIN SALDOSCONTABLES Sal ON Cue.CuentaCompleta = Sal.CuentaCompleta
		WHERE Sal.EjercicioID = Par_Ejercicio
		  AND Sal.PeriodoID = Par_Periodo
		  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
		GROUP BY Cue.CuentaCompleta;

		INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,	CuentaContable,		Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
				Cargos,				Abonos,				SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
				CuentaMayor,		CentroCosto)
		SELECT  Aud_NumTransaccion, MAX(Fin.NombreCampo),	Cadena_Vacia,
				Entero_Cero,		Entero_Cero,			Entero_Cero,
				Entero_Cero,
				SUM(
					CASE WHEN Fin.Naturaleza = Con_Deudora THEN
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
										   AND Pol.NumeroTransaccion = Aud_NumTransaccion)
		WHERE Fin.EstadoFinanID = Tif_EdoResul
		  AND Fin.EsCalculado = Con_NO
		  AND Fin.NumClien = Var_NumCliente
		GROUP BY Fin.ConceptoFinanID;

		IF(Var_NumeroRegistros > Entero_Cero) THEN

			SET Var_Contador := Entero_Uno;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable, Desplegado
				INTO Var_NombreCampo, Var_CuentaContable,Var_Desplegado
				FROM TMP_CONCEPESTADOSFINRESULTADO
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN
					CALL `EVALFORMULACONTAPRO`(
						Var_CuentaContable,	Cadena_Vacia,		Por_Peridodo,		Par_Fecha,			Par_Ejercicio,
						Par_Periodo,		Par_Fecha,			Par_AcumuladoCta,	Par_CCInicial,		Par_CCFinal,
						Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,	CuentaContable,		Grupo,				SaldoInicialDeu,	SaldoInicialAcre,
						Cargos,				Abonos,				SaldoDeudor,		SaldoAcreedor,		DescripcionCuenta,
						CuentaMayor,		CentroCosto)
					VALUES(
						Aud_NumTransaccion,	Var_NombreCampo,	Cadena_Vacia,		Entero_Cero,		Entero_Cero,
						Entero_Cero,		Entero_Cero,		Par_AcumuladoCta,	Entero_Cero,		Var_Desplegado,
						Cadena_Vacia,		Cadena_Vacia);
				END IF;

				SET Var_Contador := Var_Contador + Entero_Uno;
				SET Var_Desplegado := Cadena_Vacia;
				SET Var_NombreCampo := Cadena_Vacia;
				SET Var_CuentaContable := Cadena_Vacia;
				SET Par_AcumuladoCta := Entero_Cero;

			END WHILE;

		END IF;
	END IF;

	IF( Par_TipoConsulta = Por_FinPeriodo ) THEN

		SET Par_Periodo := (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID =Par_Ejercicio);

		SELECT 	 Inicio, 				Fin
			INTO Var_FechaIniPerido,	Var_FechaFinPeriodo
			FROM PERIODOCONTABLE
			WHERE EjercicioID =Par_Ejercicio
			AND PeriodoID = Par_Periodo;

		SET Var_DesFechaPeriodo := UPPER(CONCAT('AL ', FUNCIONLETRASFECHA(Var_FechaFinPeriodo)));

		INSERT INTO TMPCONTABLEBALANCE(
			NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
			Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
			SaldoInicialAcr)
		SELECT  Aud_NumTransaccion, Var_FechaSistema, IFNULL(Cue.CuentaCompleta,""), Entero_Cero,
				Entero_Cero, Entero_Cero,
				(Cue.Naturaleza),
				SUM(
					CASE WHEN (Cue.Naturaleza) = Con_Deudora  THEN
						ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero), 2)
					ELSE
						Entero_Cero
					END),
				SUM(
					CASE WHEN (Cue.Naturaleza) = Con_Acreedora  THEN
						ROUND(IFNULL(Sal.SaldoFinal, Entero_Cero), 2)
					ELSE
						Entero_Cero
					END),
				Entero_Cero,Entero_Cero
		FROM CUENTASCONTABLES Cue
		INNER JOIN SALDOCONTACIERREJER Sal ON Cue.CuentaCompleta = Sal.CuentaCompleta
		WHERE Sal.EjercicioID = Par_Ejercicio
		  AND Sal.PeriodoID = Par_Periodo
		  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
		GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

		INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
				Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
				CuentaMayor,		CentroCosto)
		SELECT  Aud_NumTransaccion,	MAX(Fin.NombreCampo), Cadena_Vacia,  Entero_Cero,
				Entero_Cero,		Entero_Cero,			Entero_Cero,
				SUM(CASE WHEN Fin.Naturaleza = Con_Deudora THEN
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
		WHERE Fin.EstadoFinanID = Tif_EdoResul
		  AND Fin.EsCalculado = Con_NO
		  AND Fin.NumClien = Var_NumCliente
		GROUP BY Fin.ConceptoFinanID;

		IF( Var_NumeroRegistros > Entero_Cero ) THEN

			SET Var_Contador := Entero_Uno;

			SELECT Fin INTO Par_Fecha
			FROM PERIODOCONTABLE
			WHERE EjercicioID = Par_Ejercicio
			AND PeriodoID = Par_Periodo;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable, Desplegado
				INTO Var_NombreCampo, Var_CuentaContable, Var_Desplegado
				FROM TMP_CONCEPESTADOSFINRESULTADO
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN
					CALL `EVALFORMULAPERIFINPRO`(Par_AcumuladoCta,	Var_CuentaContable,	Ubi_Histor, Por_FinPeriodo, Par_Fecha);

					INSERT INTO TMPBALANZACONTA	(
						NumeroTransaccion,	CuentaContable,		Grupo,				SaldoInicialDeu,	SaldoInicialAcre,
						Cargos,				Abonos,				SaldoDeudor,		SaldoAcreedor,		DescripcionCuenta,
						CuentaMayor,		CentroCosto)
					VALUES(
						Aud_NumTransaccion,	Var_NombreCampo,	Cadena_Vacia,		Entero_Cero,		Entero_Cero,
						Entero_Cero,		Entero_Cero,		Par_AcumuladoCta,	Entero_Cero,		Var_Desplegado,
						Cadena_Vacia,		Cadena_Vacia);
				END IF;

				SET Var_Contador := Var_Contador + Entero_Uno;
				SET Var_Desplegado := Cadena_Vacia;
				SET Var_NombreCampo := Cadena_Vacia;
				SET Var_CuentaContable := Cadena_Vacia;
				SET Par_AcumuladoCta := Entero_Cero;

			END WHILE;

		END IF;
	END IF;

	IF (Par_TipoConsulta = Por_CorteMes) THEN

		SET Var_DesFechaPeriodo := UPPER(CONCAT('Al ',FUNCIONLETRASFECHA(Par_Fecha)));

		SET Var_FechaFinMes	:= LAST_DAY(Par_Fecha);

		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
		FROM  SALDOSCONTABLES
		WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos := IFNULL(Var_FechaSaldos, Fecha_Vacia);

		SELECT  EjercicioID, PeriodoID,  Inicio,	    Fin
		INTO	Var_EjeCon,  Var_PerCon, Var_FecIniPer, Var_FecFinPer
		FROM PERIODOCONTABLE
		WHERE Inicio <= Par_Fecha
		  AND Fin >= Par_Fecha;

		IF (Var_FechaSaldos = Fecha_Vacia) THEN

			INSERT INTO TMPCONTABLE (
				NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
				Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
				SaldoInicialAcr)
			SELECT Aud_NumTransaccion, Var_FecConsulta, IFNULL(Cue.CuentaCompleta, ""), Entero_Cero,
					Entero_Cero, Entero_Cero,
					(Cue.Naturaleza),
					SUM(
						CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
								IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
							 ELSE
								Entero_Cero
						END),
					SUM(
						CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
								IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
							 ELSE
								Entero_Cero
						END),
					Entero_Cero, Entero_Cero
			FROM CUENTASCONTABLES Cue
			LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON Cue.CuentaCompleta = Pol.CuentaCompleta
			WHERE Pol.Fecha BETWEEN Var_FecIniPer AND Var_FechaFinMes
			  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

			INSERT INTO TMPBALANZACONTA	(
					NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
					Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
					CuentaMayor,		CentroCosto)
			SELECT	Aud_NumTransaccion, MAX(Fin.NombreCampo), Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = Con_Deudora THEN
								 IFNULL(Pol.SaldoDeudor, Entero_Cero) - IFNULL(Pol.SaldoAcreedor, Entero_Cero)
							 ELSE
								 IFNULL(Pol.SaldoAcreedor, Entero_Cero) - IFNULL(Pol.SaldoDeudor, Entero_Cero)
					END),
					Entero_Cero,
					MAX(Fin.Desplegado), Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT OUTER JOIN CUENTASCONTABLES Cue ON Cue.CuentaCompleta LIKE Fin.CuentaContable
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.NumeroTransaccion = Aud_NumTransaccion)
			WHERE Fin.EstadoFinanID = Tif_EdoResul
			  AND Fin.EsCalculado = Con_NO
			  AND Fin.NumClien = Var_NumCliente
			GROUP BY Fin.ConceptoFinanID;
		ELSE

			SET Var_EjeCon := IFNULL(Var_EjeCon, Entero_Cero);
			SET Var_PerCon := IFNULL(Var_PerCon, Entero_Cero);
			SET Var_FecIniPer := IFNULL(Var_FecIniPer, Fecha_Vacia);
			SET Var_FecFinPer := IFNULL(Var_FecFinPer, Fecha_Vacia);

			IF (Var_EjeCon = Entero_Cero) THEN
				SELECT  MAX(EjercicioID), MAX(PeriodoID), MAX(Inicio),	 MAX(Fin)
				INTO	Var_EjeCon,		  Var_PerCon,	  Var_FecIniPer, Var_FecFinPer
				FROM PERIODOCONTABLE
				WHERE Fin <= Par_Fecha;
			END IF;

			IF (Var_EjeCon >= Var_EjercicioVig AND Var_PerCon >= Var_PeriodoVig) THEN
				INSERT INTO TMPCONTABLE (
					NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
					Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
					SaldoInicialAcr)
				SELECT  Aud_NumTransaccion, Var_FechaSistema,   IFNULL(Cue.CuentaCompleta, ""), Entero_Cero,
						Entero_Cero, Entero_Cero,
						(Cue.Naturaleza),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
									IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
									IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						Entero_Cero,    Entero_Cero
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON Cue.CuentaCompleta = Pol.CuentaCompleta
				WHERE  Pol.CentroCostoID BETWEEN Var_FecIniPer AND Var_FechaFinMes
				  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
				GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

				SET Var_Ubicacion   := Ubi_Actual;

			ELSE

				INSERT INTO TMPCONTABLE(
						NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
						Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
						SaldoInicialAcr)
				SELECT  Aud_NumTransaccion, Var_FechaSistema,   IFNULL(Cue.CuentaCompleta, ""), Entero_Cero,
						Entero_Cero, 		Entero_Cero,		(Cue.Naturaleza),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
									IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),
						SUM(
							CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
									IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
								 ELSE
									Entero_Cero
							END),	Entero_Cero,    Entero_Cero
				FROM  CUENTASCONTABLES Cue
				LEFT OUTER JOIN HISSALDOSDETPOLIZA AS Pol ON (Pol.Fecha BETWEEN Var_FecIniPer AND Var_FechaFinMes
														  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
														  AND Pol.CuentaCompleta = Cue.CuentaCompleta)
				GROUP BY Cue.CuentaCompleta;

				SET Var_Ubicacion   := Ubi_Histor;

			END IF;

			INSERT INTO TMPBALANZACONTA	(
				NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
				Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
				CuentaMayor,		CentroCosto)
			SELECT 	Aud_NumTransaccion, MAX(Fin.NombreCampo),	Cadena_Vacia, Entero_Cero,	Entero_Cero,
					Entero_Cero, Entero_Cero,
					SUM(CASE WHEN Fin.Naturaleza = Con_Deudora THEN
								(IFNULL(Pol.SaldoInicialDeu, Entero_Cero) - IFNULL(Pol.SaldoInicialAcr, Entero_Cero)) +
								(IFNULL(Pol.SaldoDeudor, Entero_Cero) 	  - IFNULL(Pol.SaldoAcreedor, Entero_Cero))
							 ELSE
								(IFNULL(Pol.SaldoInicialAcr, Entero_Cero) - IFNULL(Pol.SaldoInicialDeu, Entero_Cero)) +
								(IFNULL(Pol.SaldoAcreedor, Entero_Cero)   - IFNULL(Pol.SaldoDeudor, Entero_Cero))
						END),
					Entero_Cero,
					MAX(Fin.Descripcion),	Cadena_Vacia, Cadena_Vacia
			FROM CONCEPESTADOSFIN Fin
			LEFT JOIN CUENTASCONTABLES Cue ON (Cue.CuentaCompleta LIKE Fin.CuentaContable)
			LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.CuentaContable = Cue.CuentaCompleta
											   AND Pol.Fecha = Var_FechaSistema
											   AND Pol.NumeroTransaccion = Aud_NumTransaccion)
			WHERE Fin.EstadoFinanID = Tif_EdoResul
			  AND Fin.EsCalculado = Con_NO
			  AND Fin.NumClien = NumCliente
			GROUP BY Fin.ConceptoFinanID;

		END IF;

	END IF;

	IF(Par_Cifras = Cifras_Miles) THEN
		UPDATE TMPBALANZACONTA SET
			SaldoDeudor     = ROUND(SaldoDeudor/1000.00, 2)
		WHERE NumeroTransaccion = Aud_NumTransaccion;
	END IF;

	-- Agrego los campos de tipo Sumatoria configurados en la tabla CONCEPESTADOSFIN
	INSERT INTO TMPBALANZACONTA (
		NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
		Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
		CuentaMayor,		CentroCosto)
	SELECT
		Aud_NumTransaccion,	NombreCampo,	Cadena_Vacia,	Entero_Cero,		Entero_Cero,
		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,		Descripcion,
		Cadena_Vacia,		Cadena_Vacia
	FROM CONCEPESTADOSFIN
	WHERE EstadoFinanID = Tif_EdoResul
	  AND NumClien = Var_NumCliente
	  AND EsCalculado = Con_Dinamico;


	SET Var_NombreTabla     := CONCAT("TMP_", CAST(IFNULL(Aud_NumTransaccion, Entero_Cero) AS CHAR), " ");
	SET Var_CreateTable     := CONCAT("CREATE TEMPORARY TABLE ", Var_NombreTabla, " (");
	SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla, " (");
	SET Var_InsertValores   := ' VALUES( ';
	SET Var_ContaGeneral := CONCAT("Lic. ", Var_ContaGeneral);
	SET Var_DirectGeneral := CONCAT("Lic. ", Var_DirectGeneral);
	SET Var_DirectorFinanza := CONCAT("Lic. ", Var_DirectorFinanza);
	SET Var_SelectTable     := CONCAT(' SELECT *, "',Var_DirectorFinanza,'" ','AS Par_DirectorFinanzas,',
										' "',Var_ContaGeneral,'" ','AS Par_JefeContabilidad,',
										' "',Var_DirectGeneral,'" ','AS Par_GerenteGral,',
										' "',Var_DesFechaPeriodo,'" ','AS Par_FechaPeriodo, ',
										' "',Var_FirmaRepLegal,'" ','AS Par_FirmaRepLegal, ',
										' "',Var_FirmaCoordCont,'" ','AS Par_FirmaCoordCont ',
										'FROM ', Var_NombreTabla, '; ');

	SET Var_DropTable       := CONCAT(" DROP TABLE IF EXISTS ", Var_NombreTabla, "; ");

	SET Var_CantCaracteres := Entero_Cero;

	IF( IFNULL(Aud_NumTransaccion, Entero_Cero) > Entero_Cero ) THEN

		OPEN  cur_Balance;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH cur_Balance  INTO   Var_Columna, Var_Monto;

					SET Var_CreateTable := CONCAT(Var_CreateTable, CASE WHEN Var_CantCaracteres > Entero_Cero THEN " ," ELSE " " END, Var_Columna, " DECIMAL(18,2)");
					SET Var_InsertTable := CONCAT(Var_InsertTable, CASE WHEN Var_CantCaracteres > Entero_Cero THEN " ," ELSE " " END, Var_Columna);
					SET Var_InsertValores  := CONCAT(Var_InsertValores,  CASE WHEN Var_CantCaracteres > Entero_Cero THEN " ," ELSE " " END, CAST(IFNULL(Var_Monto, 0.00) AS CHAR));
					SET Var_CantCaracteres := Var_CantCaracteres + Entero_Uno;

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
		FROM TMP_CONCEPESTADOSFINRESULTADODIN;

		IF(Var_NumeroRegistros > Entero_Cero) THEN

			SET Var_Contador := Entero_Uno;

			WHILE( Var_Contador <= Var_NumeroRegistros) DO

				SELECT NombreCampo, CuentaContable
				INTO Var_NombreCampo, Var_CuentaContable
				FROM TMP_CONCEPESTADOSFINRESULTADODIN
				WHERE NumeroRegistro = Var_Contador;

				IF(Var_CuentaContable != Cadena_Vacia) THEN

					SET Var_Update  := CONCAT('UPDATE ', Var_NombreTabla ,' SET ',Var_NombreCampo,' = ',Var_CuentaContable,';');
					SET @Sentencia	:= (Var_Update);
					PREPARE Actualiza FROM @Sentencia;
					EXECUTE Actualiza;
					DEALLOCATE PREPARE Actualiza;

				END IF;

				SET Var_Contador 		:= Var_Contador + Entero_Uno;
				SET Var_Update 			:= Cadena_Vacia;
				SET Var_NombreCampo 	:= Cadena_Vacia;
				SET Var_CuentaContable 	:= Cadena_Vacia;

			END WHILE;

		END IF;

		SET @Sentencia	:= (Var_SelectTable);
		PREPARE SelectTable FROM @Sentencia;
		EXECUTE SelectTable;
		DEALLOCATE PREPARE SelectTable;

		SET @Sentencia	:= CONCAT( Var_DropTable);
		PREPARE DropTable FROM @Sentencia;
		EXECUTE DropTable;
		DEALLOCATE PREPARE DropTable;

	END IF;

	DELETE FROM TMPCONTABLE
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPBALANZACONTA
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINRESULTADO;
	DROP TABLE IF EXISTS TMP_CONCEPESTADOSFINRESULTADODIN;

END TerminaStore$$