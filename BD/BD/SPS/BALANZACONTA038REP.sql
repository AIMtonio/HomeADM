-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZACONTA038REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANZACONTA038REP`;

DELIMITER $$
CREATE PROCEDURE `BALANZACONTA038REP`(
	-- Store Procedure: Para generar la Balanza Contable del Cliente: VIGUA SERVICIOS PATRIMONIALES, SA DE CV
	-- Modulo: Contabilidad --> Reportes --> Balanza Contable
	Par_Ejercicio		INT(11),		-- Ejecicio cerrado (Anio)
	Par_Periodo			INT(11),		-- Periodo cerrado (Mes)
	Par_Fecha			DATE,			-- Fecha de corte
	Par_TipoConsulta	CHAR(1),		-- Tipo de consulta:E.- Dias Especial F.- Fecha P.- Periodo
	Par_SaldosCero		CHAR(1),		-- Inclusion de saldos en cero (S/N)

	Par_Cifras			CHAR(1),		-- Pesos o Miles
	Par_CCInicial		INT(11),		-- Centro de Costos Inicial
	Par_CCFinal			INT(11),		-- Centro de Costos Final
	Par_CuentaIni		VARCHAR(30),	-- Cuenta contable Inicial
	Par_CuentaFin		VARCHAR(30),	-- Cuenta contable Final

	Par_NivelDet		VARCHAR(30),	-- Nivel de detalle
	Par_TipoBalanza		CHAR(1),		-- Tipo Balanza C:Centro costo G: Global.

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
	DECLARE Var_FecConsulta		DATE;			-- fehca de consulta
	DECLARE Var_FechaSistema 	DATE;			-- fecha del sistema
	DECLARE Var_FechaSaldos		DATE;			-- fecha de los saldos
	DECLARE Var_EjeCon      	INT(11);		-- consulta por ejercicio
	DECLARE Var_PerCon      	INT(11);		-- consulta por periodo
	DECLARE Var_FecIniPer   	DATE;			-- fecha de inicio de periodo
	DECLARE Var_FecFinPer   	DATE;			-- fecha de fin de periodo
	DECLARE Var_EjIni       	DATE;			-- inicio de ejerccio
	DECLARE Var_EjFin       	DATE;			-- fin de ejercicio
	DECLARE Var_PerMes      	VARCHAR(50);	-- mes del periodo
	DECLARE Var_EjercicioVig 	INT(11);		-- es vigente el ejercicio
	DECLARE Var_PeriodoVig		INT(11);		-- es vigente el periodo
	DECLARE Var_NumSegConta 	INT(11);		-- numero de segmentos contador
	DECLARE Var_IniPerCon		DATE;			-- inico de periodo contable
	DECLARE Var_FinPerCon		DATE;			-- fin de periodo contable

	DECLARE Var_MinCenCos		INT(11);		-- minimo de centro de costos
	DECLARE Var_MaxCenCos		INT(11);		-- maximo de centro de costos
	DECLARE Var_NumSegmen		INT(11);		-- numero de segmentos

	DECLARE	Var_SumaSalIniDeu	DECIMAL(21,2);	-- suma salida e inicio de tipo deudora
	DECLARE Var_SumaSalIniAcre	DECIMAL(21,2);	-- suma salida e inicio de tipo acreedora
	DECLARE Var_SumaCargos		DECIMAL(21,2);	-- suma los cargs
	DECLARE Var_SumaAbonos		DECIMAL(21,2);	-- suma los abonos
	DECLARE Var_SumaSalDeu		DECIMAL(21,2);	-- suma saldos deudoras
	DECLARE Var_SumaSalAcr		DECIMAL(21,2);	-- suma saldos acreedoras

	DECLARE Var_SaldoFinal		DECIMAL(21,2);	-- saldo final
	DECLARE Var_SaldoInicial	DECIMAL(21,2);	-- saldo inicial
	DECLARE Var_Cargos			DECIMAL(21,2);	-- cargos
	DECLARE Var_Abonos			DECIMAL(21,2);	-- abonos
	DECLARE Var_LongitudCC		INT(11);		-- numero de centro de costos
	DECLARE Var_CentroCostoID	INT(11);		-- numero de centro de costos
	DECLARE Var_MinRegistroID	INT(11);		-- numero de Min centro de costos
	DECLARE Var_MaxRegistroID	INT(11);		-- numero de Max centro de costos
	DECLARE Var_RegistroID 		INT(11);		-- numero de centro de costos

	-- Declaracion de Constantes
	DECLARE Decimal_Cero	DECIMAL(18,2);		-- Decimal Cero
	DECLARE Decimal_Cien	DECIMAL(18,2);		-- Decimal Cien
	DECLARE Entero_Cero     INT(11);
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE VarDeudora      CHAR(1);
	DECLARE VarAcreedora    CHAR(1);
	DECLARE Tip_Encabezado  CHAR(1);
	DECLARE Tip_Detalle  	CHAR(1);
	DECLARE No_SaldoCeros   CHAR(1);
	DECLARE Cifras_Pesos    CHAR(1);
	DECLARE Cifras_Miles    CHAR(1);
	DECLARE Por_Periodo     CHAR(1);
	DECLARE Por_Fecha       CHAR(1);
	DECLARE Por_DiaEspeci   CHAR(1);
	DECLARE Entero_Uno		INT(11);

	DECLARE Var_UltPeriodoCie   INT(11);
	DECLARE Var_UltEjercicioCie INT(11);
	DECLARE Est_Cerrado     	CHAR(1);
	DECLARE Tipo_Global			CHAR(1);
	DECLARE Tipo_CenCostos		CHAR(1);
	DECLARE CenCos_Global		CHAR(2);
	DECLARE Con_Electronica		VARCHAR(50);

	-- Asignacion de Constantes
	SET Decimal_Cero	:= 0.00;
	SET Decimal_Cien	:= 1000.00;
	SET Entero_Cero     := 0;				-- Entero Cero
	SET Cadena_Vacia    := '';				-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
	SET VarDeudora      := 'D';				-- Naturaleza Deudora
	SET VarAcreedora    := 'A';				-- Naturaleza Acreedora
	SET Tip_Encabezado  := 'E';				-- Tipo de Cuenta: Encabezado
	SET Tip_Detalle  	:= 'D';				-- Tipo de Cuenta: Detalle
	SET No_SaldoCeros   := 'N';				-- No Incluir Saldos Ceros
	SET Cifras_Pesos    := 'P';				-- Reporte con Cifras en Pesos
	SET Cifras_Miles    := 'M';				-- Reporte con Cifras en Miles
	SET Por_Periodo     := 'P';				-- Tipo de consulta por Periodo Contable Cerrado
	SET Por_Fecha       := 'D';				-- Tipo de consulta Acumulado a una Fecha
	SET Por_DiaEspeci   := 'E';				-- Tipo de consulta Solo del Dia Especifico
	SET Est_Cerrado		:= 'C';				-- Estatus del Periodo: Cerrado
	SET	Tipo_Global		:= 'G';				-- Tipo de Saldos: Global o por Cuenta Contable
	SET	Tipo_CenCostos	:= 'C';				-- Por Centro de Costos
	SET	CenCos_Global	:= ' G';			-- Centro de Costos: Global
	SET Entero_Uno		:= 1;				-- Entero Uno
	SET Con_Electronica	:= 'CONTAELECTRONICA';-- Contabilidad Electronica

	-- Validacion para parametros
	SET Par_TipoConsulta := IFNULL(Par_TipoConsulta, Por_Fecha );
	SET Par_SaldosCero	 := IFNULL(Par_SaldosCero, No_SaldoCeros);
	SET Par_Cifras		 := IFNULL(Par_Cifras, Cifras_Pesos);

	SELECT FechaSistema, 		EjercicioVigente,	PeriodoVigente
	INTO   Var_FechaSistema,	Var_EjercicioVig,	Var_PeriodoVig
	FROM PARAMETROSSIS;

	SET Par_Fecha           := IFNULL(Par_Fecha, Fecha_Vacia);
	SET Var_EjercicioVig    := IFNULL(Var_EjercicioVig, Entero_Cero);
	SET Var_PeriodoVig      := IFNULL(Var_PeriodoVig, Entero_Cero);

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	SELECT COUNT(DISTINCT CHAR_LENGTH(CuentaCompleta))
	INTO Var_NumSegConta
	FROM CUENTASCONTABLES
	WHERE CuentaCompleta != '0';

	SELECT  MAX(EjercicioID)
	INTO Var_UltEjercicioCie
	FROM PERIODOCONTABLE Per
	WHERE Per.Fin	< Par_Fecha
	  AND Per.Estatus = Est_Cerrado;

	SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);

	IF(Var_UltEjercicioCie != Entero_Cero) THEN
		SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
		FROM PERIODOCONTABLE Per
		WHERE Per.EjercicioID	= Var_UltEjercicioCie
		  AND Per.Estatus = Est_Cerrado
		  AND Per.Fin	<= Par_Fecha;
	END IF;

	SET Var_NumSegConta := IFNULL(Var_NumSegConta, Entero_Cero);
	SET	Par_CCInicial	:= IFNULL(Par_CCInicial, Entero_Cero);
	SET	Par_CCFinal		:= IFNULL(Par_CCFinal, Entero_Cero);
	SET	Par_NivelDet	:= IFNULL(Par_NivelDet, Cadena_Vacia);
	SET	Var_NumSegmen	:= Entero_Cero;

	SET	Var_NumSegmen	:= CHAR_LENGTH(Par_NivelDet);

	SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
	FROM CENTROCOSTOS;

	IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
		SET Par_CCInicial	:= Var_MinCenCos;
		SET	Par_CCFinal		:= Var_MaxCenCos;
	END IF;

	SELECT CHAR_LENGTH(Var_MaxCenCos) INTO Var_LongitudCC;

	SET	Par_CuentaIni	:= IFNULL(Par_CuentaIni, Cadena_Vacia);
	SET	Par_CuentaFin	:= IFNULL(Par_CuentaFin, Cadena_Vacia);

	IF(Par_CuentaIni = Cadena_Vacia OR Par_CuentaFin = Cadena_Vacia) THEN
		SET Par_CuentaIni	:= Cadena_Vacia;
		SET	Par_CuentaFin	:= Cadena_Vacia;
	END IF;

	-- Borrado de Tablas Temporales
	TRUNCATE TMPBALCUENTACONTABLE;

	TRUNCATE TMPBALANZACONTABLE;

	TRUNCATE TMPSALCONTACENCOSTOS;

	TRUNCATE TMPBALPOLCENCOS;

	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPBALANZACENCOS WHERE NumeroTransaccion = Aud_NumTransaccion;

	INSERT INTO TMPBALCUENTACONTABLE
	SELECT Aud_NumTransaccion, Cue.CuentaCompleta,
		   Cen.CentroCostoID,
		   CASE WHEN Cue.Grupo = Tip_Encabezado AND Var_NumSegConta = 1
					 AND Cue.CuentaCompleta NOT IN ('54001000000000','24000710000000') THEN
				TRIM(TRAILING '0' FROM Cue.CuentaCompleta)
			ELSE
				CuentaCompleta
			END,
			Cadena_Vacia, Naturaleza, Grupo, MonedaID
	FROM CUENTASCONTABLES Cue,
		 CENTROCOSTOS Cen;

	UPDATE TMPBALCUENTACONTABLE SET
		CuentaMayor = '540010'
	WHERE CuentaCompleta = '54001000000000'
	  AND NumTransaccion = Aud_NumTransaccion;

	UPDATE TMPBALCUENTACONTABLE SET
		CuentaMayor = '24000710'
	WHERE CuentaCompleta = '24000710000000'
	  AND NumTransaccion = Aud_NumTransaccion;

	IF(Par_Fecha != Fecha_Vacia) THEN
		SET Var_FecConsulta	= Par_Fecha;
	ELSE
		SELECT	Fin INTO Var_FecConsulta
		FROM PERIODOCONTABLE
		WHERE EjercicioID   = Par_Ejercicio
		  AND PeriodoID     = Par_Periodo;
	END IF;

	-- Dejamos Solo las Cuentas Contable Especificados en los Parametros
	IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
		DELETE FROM TMPBALCUENTACONTABLE
		WHERE NumTransaccion = Aud_NumTransaccion
		  AND CuentaCompleta NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
	END IF;

	-- Dejamos Solo los Centros de Costos Especificados en los Parametros
	IF(Par_CCInicial != Cadena_Vacia AND Par_CCFinal != Cadena_Vacia) THEN
		DELETE FROM TMPBALCUENTACONTABLE
		WHERE NumTransaccion = Aud_NumTransaccion
		  AND CentroCosto NOT BETWEEN Par_CCInicial AND Par_CCFinal;
	END IF;

	-- Acumulado a Cierta Fecha
	IF( Par_TipoConsulta = Por_Fecha AND Var_EjercicioVig != Entero_Cero AND Var_PeriodoVig != Entero_Cero ) THEN

		-- Se obtiene el Periodo y Ejercicio Contable Vigente
		SELECT	Inicio, Fin INTO Var_FecIniPer, Var_FecFinPer
		FROM PERIODOCONTABLE
		WHERE EjercicioID   = Var_EjercicioVig
		  AND PeriodoID     = Var_PeriodoVig;

		-- Se obtiene la Fecha de Inicio y de Fin del Periodo que contiene la Fecha que se esta Consultando
		SELECT	Inicio, Fin INTO Var_IniPerCon, Var_FinPerCon
		FROM PERIODOCONTABLE
		WHERE Inicio >= Par_Fecha
		  AND Fin <= Par_Fecha;

		SET	Var_IniPerCon	:= IFNULL(Var_IniPerCon, Fecha_Vacia);
		SET	Var_FinPerCon	:= IFNULL(Var_FinPerCon, Fecha_Vacia);

		-- Si no existen Periodos contables, entonces asumimos periodos mensuales
		IF(Var_IniPerCon = Fecha_Vacia) THEN
			SET Var_IniPerCon := DATE_ADD(Par_Fecha, INTERVAL -1 *(DAY(Par_Fecha))+1 DAY);
			SET Var_FinPerCon := LAST_DAY(Par_Fecha);
		END IF;

		-- Obtenemos la ultima Fecha del Cierre del Periodo Contable
		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
		FROM  SALDOSCONTABLES
		WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos	:= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		-- Se Obtienen las Polizas del Rango de Fechas, Agrupado por CuentaContable y Centro de Costos
		-- Esto para hacerlo mas Eficente, se usa esta temporal
		IF(Par_Fecha >= Var_FecIniPer) THEN

			-- Obtengo los Saldos de las cuentas contables Actual
			INSERT INTO TMPBALPOLCENCOS (
				NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
			SELECT	Aud_NumTransaccion,	 Pol.CuentaCompleta, Pol.CentroCostoID,
					SUM(ROUND(IFNULL(Pol.Cargos,Entero_Cero),2)), SUM(ROUND(IFNULL(Pol.Abonos,Entero_Cero),2))
			FROM SALDOSDETALLEPOLIZA AS Pol
			WHERE Pol.Fecha BETWEEN Var_IniPerCon AND Par_Fecha
			  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
			GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

			IF( Par_Fecha = Var_FechaSistema ) THEN
				DROP TABLE IF EXISTS `TMPBALPOLCENCOS_AUX`;
				CREATE TABLE `TMPBALPOLCENCOS_AUX` (
					`NumTransaccion`	BIGINT(20)		NOT NULL COMMENT 'Numero de Transacción de la Operación',
					`CuentaCompleta`	VARCHAR(50)		NOT NULL COMMENT 'Cuenta Contable Completa',
					`CentroCostoID`		INT(11)			NOT NULL COMMENT 'Centro de Costos',
					`Cargos`			DECIMAL(18,4)	NOT NULL COMMENT 'Cargos',
					`Abonos`			DECIMAL(18,4)	NOT NULL COMMENT 'Abonos',
					PRIMARY KEY (`NumTransaccion`,`CuentaCompleta`,`CentroCostoID`),
					KEY `INDEX_TMPBALPOLCENCOS_AUX_1` (`NumTransaccion`,`CuentaCompleta`,`CentroCostoID`)
				) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal del Detalle de Poliza Contable';

				INSERT INTO TMPBALPOLCENCOS_AUX (
					NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
				SELECT	Aud_NumTransaccion,	 Pol.CuentaCompleta, Pol.CentroCostoID,
						SUM(ROUND(IFNULL(Pol.Cargos,Entero_Cero),2)), SUM(ROUND(IFNULL(Pol.Abonos,Entero_Cero),2))
				FROM DETALLEPOLIZA AS Pol
				WHERE Pol.Fecha = Var_FechaSistema
				  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
				GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

				INSERT INTO TMPBALPOLCENCOS (NumTransaccion,CuentaCompleta,CentroCostoID,Cargos, Abonos)
				SELECT Aud_NumTransaccion,Aux.CuentaCompleta,Aux.CentroCostoID,Entero_Cero,Entero_Cero
				FROM TMPBALPOLCENCOS_AUX Aux
				WHERE CuentaCompleta NOT IN (SELECT CuentaCompleta FROM TMPBALPOLCENCOS WHERE NumTransaccion = Aud_NumTransaccion);

				INSERT IGNORE INTO TMPBALPOLCENCOS (NumTransaccion,CuentaCompleta,CentroCostoID,Cargos, Abonos)
				SELECT Aud_NumTransaccion,Aux.CuentaCompleta,Aux.CentroCostoID,Entero_Cero,Entero_Cero
				FROM TMPBALPOLCENCOS_AUX Aux
				LEFT JOIN TMPBALPOLCENCOS TMP ON Aux.CuentaCompleta = TMP.CuentaCompleta
				WHERE TMP.NumTransaccion = Aud_NumTransaccion;

				UPDATE TMPBALPOLCENCOS Tmp, TMPBALPOLCENCOS_AUX Aux SET
					Tmp.Cargos = Tmp.Cargos + Aux.Cargos,
					Tmp.Abonos = Tmp.Abonos + Aux.Abonos
				WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				  AND Tmp.NumTransaccion = Aux.NumTransaccion
				  AND Tmp.CuentaCompleta = Aux.CuentaCompleta
				  AND Tmp.CentroCostoID = Aux.CentroCostoID;
			END IF;

		ELSE

			-- Obtengo los Saldos de las cuentas contables historicos
			INSERT INTO TMPBALPOLCENCOS (
				NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
			SELECT	Aud_NumTransaccion, Pol.CuentaCompleta,	Pol.CentroCostoID,
					SUM(ROUND(IFNULL(Pol.Cargos,Entero_Cero),2)), SUM(ROUND(IFNULL(Pol.Abonos,Entero_Cero),2))
			FROM HISSALDOSDETPOLIZA AS Pol
			WHERE Pol.Fecha BETWEEN Var_IniPerCon AND Par_Fecha
			  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
			GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

		END IF;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPBALPOLCENCOS
			WHERE NumTransaccion = Aud_NumTransaccion
			  AND CuentaCompleta NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

		-- Insertamos en la Temporal de Paso, Los Saldos de las Polizas
		INSERT INTO TMPCONTABLE (
			NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
			Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
			SaldoInicialAcr)
		SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Cue.CentroCosto,
				IFNULL(Pol.Cargos, Entero_Cero),
				IFNULL(Pol.Abonos, Entero_Cero),
				Cue.Naturaleza,
				CASE WHEN Cue.Naturaleza = VarDeudora  THEN
						  IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
					 ELSE
						  Entero_Cero
				END,
				CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
						  IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
					 ELSE
						  Entero_Cero
				END,
				Entero_Cero, Entero_Cero
		FROM TMPBALCUENTACONTABLE Cue
		LEFT OUTER JOIN TMPBALPOLCENCOS Pol ON (Pol.NumTransaccion = Aud_NumTransaccion
											AND Cue.NumTransaccion = Pol.NumTransaccion
											AND Cue.CuentaCompleta = Pol.CuentaCompleta
											AND Cue.CentroCosto = Pol.CentroCostoID
											AND Cue.Grupo = Tip_Detalle)
		WHERE Cue.NumTransaccion = Aud_NumTransaccion;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CuentaContable NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

		-- Actualizamos el Saldo Inicial
		IF (Var_FechaSaldos != Fecha_Vacia) THEN

			UPDATE TMPCONTABLE Tmp, SALDOSCONTABLES Sal SET
				Tmp.SaldoInicialDeu = CASE WHEN Tmp.Naturaleza = VarDeudora THEN
												IFNULL(Sal.SaldoFinal, Entero_Cero)
										   ELSE
												Entero_Cero
									  END,
				Tmp.SaldoInicialAcr = CASE WHEN Tmp.Naturaleza = VarAcreedora THEN
												IFNULL(Sal.SaldoFinal, Entero_Cero)
										   ELSE
												Entero_Cero
									  END,
				Tmp.SaldoDeudor   = CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
											  Tmp.SaldoDeudor + IFNULL(Sal.SaldoFinal, Entero_Cero)
									    ELSE
											  Tmp.SaldoDeudor
									END,
				Tmp.SaldoAcreedor = CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
											  Tmp.SaldoAcreedor + IFNULL(Sal.SaldoFinal, Entero_Cero)
										 ELSE
											  Tmp.SaldoAcreedor
									END
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			  AND Tmp.CuentaContable = Sal.CuentaCompleta
			  AND Tmp.CentroCosto = Sal.CentroCosto
			  AND Sal.FechaCorte = Var_FechaSaldos;
		END IF;

		TRUNCATE TMPBALPOLCENCOS;
		-- Obtenemos Como Saldo Inicial el Detalle de Poliza
		-- Para las Polizas que estan en el Actual (Periodo No Cerrado)
		-- Pero que pertenecen a otros Periodos

		INSERT INTO TMPBALPOLCENCOS (
			NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
		SELECT	Aud_NumTransaccion, Pol.CuentaCompleta, Pol.CentroCostoID,
				SUM(ROUND(IFNULL(Pol.Cargos,Entero_Cero),2)), SUM(ROUND(IFNULL(Pol.Abonos,Entero_Cero),2))
		FROM SALDOSDETALLEPOLIZA AS Pol
		WHERE Pol.Fecha > Var_FechaSaldos
		  AND Pol.Fecha < Var_IniPerCon
		  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
		GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPBALPOLCENCOS
			WHERE NumTransaccion = Aud_NumTransaccion
			  AND CuentaCompleta NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

		-- Obtengo los Saldos contables de los centro de costos
		INSERT INTO TMPSALCONTACENCOSTOS (
			NumeroTransaccion, CuentaContable, CentroCosto, SaldoInicialDeu, SaldoInicialAcr)
		SELECT  Aud_NumTransaccion, Cue.CuentaContable, Cue.CentroCosto,
				CASE WHEN Cue.Naturaleza = VarDeudora  THEN
						  IFNULL(Pol.Cargos, Entero_Cero) - IFNULL(Pol.Abonos, Entero_Cero)
					 ELSE
						  Entero_Cero
				END,
				CASE WHEN Cue.Naturaleza = VarAcreedora THEN
						  IFNULL(Pol.Abonos, Entero_Cero) - IFNULL(Pol.Cargos, Entero_Cero)
					 ELSE
						  Entero_Cero
				END
		FROM TMPCONTABLE Cue
		INNER JOIN TMPBALPOLCENCOS Pol ON (Cue.NumeroTransaccion = Pol.NumTransaccion
									   AND Cue.CuentaContable = Pol.CuentaCompleta
									   AND Cue.CentroCosto = Pol.CentroCostoID)
		WHERE Cue.NumeroTransaccion = Aud_NumTransaccion;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPSALCONTACENCOSTOS
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CuentaContable NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

		-- Se actualizan los saltos contables por centro de costos
		UPDATE TMPCONTABLE Tmp, TMPSALCONTACENCOSTOS Sal SET
			Tmp.SaldoInicialDeu = Tmp.SaldoInicialDeu +
								  CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
											Sal.SaldoInicialDeu
									   ELSE
											Entero_Cero
								  END,
			Tmp.SaldoInicialAcr = Tmp.SaldoInicialAcr +
								  CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
											Sal.SaldoInicialAcr
									   ELSE
											Entero_Cero
								  END
		WHERE Tmp.NumeroTransaccion = Sal.NumeroTransaccion
		  AND Tmp.CuentaContable = Sal.CuentaContable
		  AND Tmp.CentroCosto = Sal.CentroCosto
		  AND Sal.NumeroTransaccion	= Aud_NumTransaccion;

		-- Borramos Aquellas Cuentas de la Temporal de Saldos, que no hayan tenido movimiento alguno
		-- Esto borrara las Cuentas Agrupadoras, ya que ellas nunca tienen saldos directamente
		DELETE FROM TMPCONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion
		  AND SaldoInicialDeu = Entero_Cero
		  AND SaldoInicialAcr = Entero_Cero
		  AND Cargos = Entero_Cero
		  AND Abonos = Entero_Cero;

	END IF;

	-- Saldos de Solo un Dia en Particular.
	IF( Par_TipoConsulta = Por_DiaEspeci ) THEN

		-- Obtengo la Fecha Inicial y Final del Periodo Contable
		SELECT	Inicio, Fin INTO Var_FecIniPer, Var_FecFinPer
		FROM PERIODOCONTABLE
		WHERE EjercicioID = Var_EjercicioVig
		  AND PeriodoID   = Var_PeriodoVig;

		-- Obtengo la Fecha Inicial y Final del Periodo Contable
		SELECT	Inicio, Fin INTO Var_IniPerCon, Var_FinPerCon
		FROM PERIODOCONTABLE
		WHERE Inicio >= Par_Fecha
		  AND Fin <= Par_Fecha;

		SET	Var_IniPerCon	:= IFNULL(Var_IniPerCon, Fecha_Vacia);
		SET	Var_FinPerCon	:= IFNULL(Var_FinPerCon, Fecha_Vacia);


		-- Se valida que la fecha de Inicio del Periodo contable
		IF(Var_IniPerCon = Fecha_Vacia) THEN
			SET Var_IniPerCon := DATE_ADD(Par_Fecha, INTERVAL -1 *(DAY(Par_Fecha))+1 DAY);
			SET Var_FinPerCon := LAST_DAY(Par_Fecha);
		END IF;

		-- Obtengo la Fecha cirte del los Saldos Contable
		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
		FROM  SALDOSCONTABLES
		WHERE FechaCorte < Par_Fecha;

		SET Var_FechaSaldos	:= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		IF(Par_Fecha >= Var_FecIniPer) THEN

			-- Si la fecha de consulta no es la fecha del sistema consulto la tabla de saldos
			IF( Par_Fecha <> Var_FechaSistema ) THEN
				-- Obtengo los Saldos de las cuentas contables Actuales
				INSERT INTO TMPCONTABLE (
					NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
					Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
					SaldoInicialAcr)
				SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Cue.CentroCosto,
						SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)),
						SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)),
						Cue.Naturaleza,
						CASE WHEN Cue.Naturaleza = VarDeudora  THEN
								  SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
							 ELSE
								  Entero_Cero
						END,
						CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
								  SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero))
							 ELSE
								  Entero_Cero
						END,
						Entero_Cero, Entero_Cero
				FROM TMPBALCUENTACONTABLE Cue
				INNER JOIN SALDOSDETALLEPOLIZA Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
												   AND Cue.CentroCosto = Pol.CentroCostoID
												   AND Pol.Fecha = Par_Fecha
												   AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
				WHERE Cue.NumTransaccion = Aud_NumTransaccion
				GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Naturaleza;

			END IF;

			-- Si la fecha de consulta es la fecha del sistema consulto la tabla de saldos detallepoliza
			IF( Par_Fecha = Var_FechaSistema ) THEN

				-- Obtengo los Saldos de las cuentas contables Actuales
				INSERT INTO TMPCONTABLE (
					NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
					Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
					SaldoInicialAcr)
				SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Cue.CentroCosto,
						SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)),
						SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)),
						Cue.Naturaleza,
						CASE WHEN Cue.Naturaleza = VarDeudora  THEN
								  SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
							 ELSE
								  Entero_Cero
						END,
						CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
								  SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero))
							 ELSE
								  Entero_Cero
						END,
						Entero_Cero, Entero_Cero
				FROM TMPBALCUENTACONTABLE Cue
				INNER JOIN DETALLEPOLIZA Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
											 AND Cue.CentroCosto = Pol.CentroCostoID
											 AND Pol.Fecha = Par_Fecha
											 AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
				WHERE Cue.NumTransaccion = Aud_NumTransaccion
				GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Naturaleza;
			END IF;

		ELSE

			-- Obtengo los Saldos de las cuentas contables historicos
			INSERT INTO TMPCONTABLE (
				NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
				Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
				SaldoInicialAcr)
			SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Cue.CentroCosto,
					SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)),
					SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)),
					Cue.Naturaleza,
					CASE WHEN Cue.Naturaleza = VarDeudora  THEN
							  SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
						 ELSE
							  Entero_Cero
						END,
					CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
							  SUM(IFNULL(ROUND(Pol.Abonos,2), Entero_Cero)) - SUM(IFNULL(ROUND(Pol.Cargos,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					Entero_Cero, Entero_Cero
			FROM TMPBALCUENTACONTABLE Cue
			INNER JOIN HISSALDOSDETPOLIZA Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
											  AND Cue.CentroCosto = Pol.CentroCostoID
											  AND Pol.Fecha = Par_Fecha
											  AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
			WHERE Cue.NumTransaccion = Aud_NumTransaccion
			GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Naturaleza;
		END IF;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CuentaContable NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

	END IF;

	-- Consulta de la Balanza a Periodo Cerrado
	IF( Par_TipoConsulta = Por_Periodo ) THEN

		IF(Par_Ejercicio = Entero_Uno AND Par_Periodo = Entero_Cero) THEN

			-- Se obtiene el Periodo de Ejercicio
			SET Par_Periodo := (SELECT MAX(PeriodoID)
								FROM PERIODOCONTABLE
								WHERE ejercicioID = Par_Ejercicio);

			-- Obtengo los Saldos de las cuentas contables al cierre de ejercicio
			INSERT INTO TMPCONTABLE (
				NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
				Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
				SaldoInicialAcr)
			SELECT  Aud_NumTransaccion, Var_FechaSistema, Cue.CuentaCompleta, Cue.CentroCosto,
					SUM(IFNULL(ROUND(Sal.Cargos,2), Entero_Cero)),
					SUM(IFNULL(ROUND(Sal.Abonos,2), Entero_Cero)),
					Cue.Naturaleza,
					CASE WHEN Cue.Naturaleza = VarDeudora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoFinal,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoFinal,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarDeudora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoInicial,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoInicial,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END
			FROM TMPBALCUENTACONTABLE Cue
			INNER JOIN SALDOCONTACIERREJER Sal ON (Cue.CuentaCompleta = Sal.CuentaCompleta
											   AND Cue.CentroCosto = Sal.CentroCosto
											   AND Sal.EjercicioID = Par_Ejercicio
											   AND Sal.PeriodoID = Par_Periodo
											   AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal)
			GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Naturaleza;

		ELSE
			-- Obtengo los Saldos de las cuentas contables historicos
			INSERT INTO TMPCONTABLE (
				NumeroTransaccion,	Fecha,		CuentaContable,	CentroCosto,	Cargos,
				Abonos,				Naturaleza,	SaldoDeudor,	SaldoAcreedor,	SaldoInicialDeu,
				SaldoInicialAcr)
			SELECT  Aud_NumTransaccion, Var_FechaSistema,   Cue.CuentaCompleta, Cue.CentroCosto,
					SUM(IFNULL(ROUND(Sal.Cargos,2), Entero_Cero)),
					SUM(IFNULL(ROUND(Sal.Abonos,2), Entero_Cero)),
					MAX(Cue.Naturaleza),
					CASE WHEN Cue.Naturaleza = VarDeudora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoFinal,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoFinal,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarDeudora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoInicial,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END,
					CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
							  SUM(IFNULL(ROUND(Sal.SaldoInicial,2), Entero_Cero))
						 ELSE
							  Entero_Cero
					END
			FROM TMPBALCUENTACONTABLE Cue
			INNER JOIN SALDOSCONTABLES Sal ON (Cue.CuentaCompleta = Sal.CuentaCompleta
										   AND Cue.CentroCosto = Sal.CentroCosto
										   AND Sal.EjercicioID = Par_Ejercicio
										   AND Sal.PeriodoID = Par_Periodo
										   AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal)
			WHERE Cue.NumTransaccion = Aud_NumTransaccion
			GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Naturaleza;

		END IF;

		-- Se Eliminan las cuentas contables que no pertenecen a los parametros ingresados
		IF(Par_CuentaIni != Cadena_Vacia AND Par_CuentaFin != Cadena_Vacia) THEN
			DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CuentaContable NOT BETWEEN Par_CuentaIni AND Par_CuentaFin;
		END IF;

		SELECT	CASE MONTH(Pr.Inicio)
					WHEN '1' THEN 'ENERO'
					WHEN '2' THEN 'FEBRERO'
					WHEN '3' THEN 'MARZO'
					WHEN '4' THEN 'ABRIL'
					WHEN '5' THEN 'MAYO'
					WHEN '6' THEN 'JUNIO'
					WHEN '7' THEN 'JULIO'
					WHEN '8' THEN 'AGOSTO'
					WHEN '9' THEN 'SEPTIEMBRE'
					WHEN '10' THEN 'OCTUBRE'
					WHEN '11' THEN 'NOVIEMBRE'
					WHEN '12' THEN 'DICIEMBRE'
				END
		INTO	Var_PerMes
		FROM EJERCICIOCONTABLE Ej
		LEFT JOIN PERIODOCONTABLE AS Pr ON  Ej.EjercicioID= Pr.EjercicioID
										AND Pr.EjercicioID = Par_Ejercicio
										AND Pr.PeriodoID = Par_Periodo
		WHERE Ej.EjercicioID = Par_Ejercicio;

	END IF;

	-- Se insertan las Cuentas Contables de Detalle
	INSERT INTO TMPBALANZACENCOS (
		NumeroTransaccion,	CuentaContable,	CentroCosto,	Grupo,			SaldoInicialDeu,
		SaldoInicialAcre,	Cargos,			Abonos,			SaldoDeudor,	SaldoAcreedor,
		DescripcionCuenta,	CuentaMayor)
	SELECT	Aud_NumTransaccion, Cue.CuentaCompleta, Cue.CentroCosto, Cue.Grupo,
			IFNULL(SUM(ROUND(Pol.SaldoInicialDeu,2)), Entero_Cero),
			IFNULL(SUM(ROUND(Pol.SaldoInicialAcr,2)), Entero_Cero),
			IFNULL(SUM(ROUND(Pol.Cargos,2)), Entero_Cero),
			IFNULL(SUM(ROUND(Pol.Abonos,2)), Entero_Cero),
			CASE WHEN Cue.Naturaleza = VarDeudora THEN
					  -- Consideramos cuentas que pueden tener dos saldos (Mayor)
					  SUM(IFNULL(ROUND(Pol.SaldoInicialDeu,2), Entero_Cero) - IFNULL(ROUND(Pol.SaldoInicialAcr,2), Entero_Cero) +
						  IFNULL(ROUND(Pol.Cargos,2), Entero_Cero) - IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
				 ELSE
					  Entero_Cero
			END,
			CASE WHEN Cue.Naturaleza = VarAcreedora  THEN
					  -- Consideramos cuentas que pueden tener dos saldos (Mayor)
					  SUM(IFNULL(ROUND(Pol.SaldoInicialAcr,2), Entero_Cero) - IFNULL(ROUND(Pol.SaldoInicialDeu,2), Entero_Cero) -
						  IFNULL(ROUND(Pol.Cargos,2), Entero_Cero) + IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
				 ELSE
					  Entero_Cero
			END,
			Cadena_Vacia AS Descripcion, MAX(Cue.CuentaMayor) AS CuentaMayor
	FROM TMPBALCUENTACONTABLE Cue
	LEFT OUTER JOIN TMPCONTABLE AS Pol ON (Pol.NumeroTransaccion = Aud_NumTransaccion
									   AND Pol.NumeroTransaccion = Cue.NumTransaccion
									   AND Pol.CuentaContable = Cue.CuentaCompleta
									   AND Pol.CentroCosto = Cue.CentroCosto)
	WHERE Cue.NumTransaccion = Aud_NumTransaccion
	GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Grupo, Cue.Naturaleza;

	UPDATE TMPBALCUENTACONTABLE Tmp SET
		Tmp.CuentaMayor = CONCAT(Tmp.CuentaMayor, "%")
	WHERE Tmp.NumTransaccion = Aud_NumTransaccion
	  AND Tmp.Grupo = Tip_Encabezado;

	DROP TABLE IF EXISTS `TMP_ITERACENTROCOSTO`;
	CREATE TABLE `TMP_ITERACENTROCOSTO` (
		`RegistroID`		INT(11) NOT NULL COMMENT 'RegistroID',
		`CentroCostoID`		INT(11) NOT NULL COMMENT 'Centro de Costos',
		PRIMARY KEY (`RegistroID`)
	);

	SET @RegistroID := Entero_Cero;
	INSERT INTO TMP_ITERACENTROCOSTO (RegistroID, CentroCostoID)
	SELECT @RegistroID:=(@RegistroID + Entero_Uno), CentroCostoID
	FROM CENTROCOSTOS
	WHERE CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal;

	SELECT MIN(RegistroID),		MAX(RegistroID)
	INTO 	Var_MinRegistroID,	Var_MaxRegistroID
	FROM TMP_ITERACENTROCOSTO;

	SET Var_RegistroID := Var_MinRegistroID;
	WHILE ( Var_RegistroID <= Var_MaxRegistroID) DO

		SELECT	CentroCostoID
		INTO	Var_CentroCostoID
		FROM TMP_ITERACENTROCOSTO
		WHERE RegistroID = Var_RegistroID;

		-- Se insertan las Cuentas Contables de Encabezado
		INSERT INTO TMPBALANZACENCOS (
			NumeroTransaccion,	CuentaContable,	CentroCosto,	Grupo,			SaldoInicialDeu,
			SaldoInicialAcre,	Cargos,			Abonos,			SaldoDeudor,	SaldoAcreedor,
			DescripcionCuenta,	CuentaMayor)
		SELECT	Aud_NumTransaccion, Cue.CuentaCompleta, Cue.CentroCosto, Cue.Grupo,
				IFNULL(SUM(ROUND(Pol.SaldoInicialDeu,2)), Entero_Cero),
				IFNULL(SUM(ROUND(Pol.SaldoInicialAcre,2)), Entero_Cero),
				IFNULL(SUM(ROUND(Pol.Cargos,2)), Entero_Cero),
				IFNULL(SUM(ROUND(Pol.Abonos,2)), Entero_Cero),
				CASE WHEN Cue.Naturaleza = VarDeudora THEN
						  -- Consideramos cuentas que pueden tener dos saldos (Mayor)
						  SUM(IFNULL(ROUND(Pol.SaldoInicialDeu,2), Entero_Cero) - IFNULL(ROUND(Pol.SaldoInicialAcre,2), Entero_Cero) +
							  IFNULL(ROUND(Pol.Cargos,2), Entero_Cero) - IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
					 ELSE
						  Entero_Cero
				END,
				CASE WHEN Cue.Naturaleza = VarAcreedora THEN
						  -- Consideramos cuentas que pueden tener dos saldos (Mayor)
						  SUM(IFNULL(ROUND(Pol.SaldoInicialAcre,2), Entero_Cero) - IFNULL(ROUND(Pol.SaldoInicialDeu,2), Entero_Cero) -
							  IFNULL(ROUND(Pol.Cargos,2), Entero_Cero) + IFNULL(ROUND(Pol.Abonos,2), Entero_Cero))
					 ELSE
						  Entero_Cero
				END,
				Cadena_Vacia AS Descripcion, MAX(Cue.CuentaMayor) AS CuentaMayor
		FROM TMPBALCUENTACONTABLE Cue
		INNER JOIN TMPBALANZACENCOS AS Pol ON (Pol.NumeroTransaccion = Aud_NumTransaccion
										   AND Pol.NumeroTransaccion = Cue.NumTransaccion
										   AND Pol.CuentaContable LIKE Cue.CuentaMayor
										   AND Pol.CentroCosto = Cue.CentroCosto
										   AND Pol.Grupo = Tip_Detalle)
		WHERE Cue.NumTransaccion = Aud_NumTransaccion
		  AND Cue.Grupo = Tip_Encabezado
		  AND Pol.CentroCosto = Var_CentroCostoID
		GROUP BY Cue.CuentaCompleta, Cue.CentroCosto, Cue.Grupo, Cue.Naturaleza;

		SET Var_RegistroID = Var_RegistroID + Entero_Uno;
	END WHILE;

		-- Se insertan las Cuentas Contables de Encabezado y de Detalle con 0 Movimientos
	INSERT INTO TMPBALANZACENCOS (
		NumeroTransaccion,	CuentaContable,	CentroCosto,	Grupo,			SaldoInicialDeu,
		SaldoInicialAcre,	Cargos,			Abonos,			SaldoDeudor,	SaldoAcreedor,
		DescripcionCuenta,	CuentaMayor)
	SELECT	Aud_NumTransaccion, Cue.CuentaCompleta, Cue.CentroCosto, Cue.Grupo,
			Entero_Cero,	Entero_Cero,
			Entero_Cero,	Entero_Cero,
			Entero_Cero,	Entero_Cero,
			Cadena_Vacia, Cue.CuentaMayor
	FROM TMPBALCUENTACONTABLE Cue
	WHERE Cue.NumTransaccion = Aud_NumTransaccion
	  AND Cue.CuentaCompleta NOT IN (SELECT CuentaContable
									 FROM TMPBALANZACENCOS
									 WHERE NumeroTransaccion = Aud_NumTransaccion
									 GROUP BY CuentaContable);

	UPDATE TMPBALANZACENCOS Tmp SET
		Tmp.CuentaMayor = REPLACE(Tmp.CuentaMayor, '%','')
	WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
	  AND Tmp.Grupo = Tip_Encabezado;

	-- Se realiza la Agrupacion de Saldo por Cuenta Contable
	INSERT INTO TMPBALANZACONTABLE (
		NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
		Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
		CuentaMayor,		CentroCosto)
	SELECT	NumeroTransaccion,		CuentaContable,			MAX(Grupo),					SUM(ROUND(SaldoInicialDeu,2)),	SUM(ROUND(SaldoInicialAcre,2)),
			SUM(ROUND(Cargos,2)),	SUM(ROUND(Abonos,2)),	SUM(ROUND(SaldoDeudor,2)),	SUM(ROUND(SaldoAcreedor,2)),	Cadena_Vacia,
			MAX(CuentaMayor),		CenCos_Global
	FROM TMPBALANZACENCOS
	WHERE NumeroTransaccion = Aud_NumTransaccion
	GROUP BY CuentaContable;

	-- Si el Tipo de Balanza es por Centro de Costos
	IF (Par_TipoBalanza = Tipo_CenCostos) THEN

		-- Se realiza la Agrupacion de Saldo por Cuenta Contable y Centro de Costos
		INSERT INTO TMPBALANZACONTABLE (
			NumeroTransaccion,	CuentaContable,	Grupo,			SaldoInicialDeu,	SaldoInicialAcre,
			Cargos,				Abonos,			SaldoDeudor,	SaldoAcreedor,		DescripcionCuenta,
			CuentaMayor,		CentroCosto)
		SELECT	NumeroTransaccion,	CuentaContable,	MAX(Grupo),			MAX(SaldoInicialDeu),	MAX(SaldoInicialAcre),
				MAX(Cargos),		MAX(Abonos),	MAX(SaldoDeudor),	MAX(SaldoAcreedor),		Cadena_Vacia,
				MAX(CuentaMayor),	LPAD(CONVERT(CentroCosto, CHAR), Var_LongitudCC, '0')
		FROM TMPBALANZACENCOS
		WHERE NumeroTransaccion = Aud_NumTransaccion
		  AND Grupo = Tip_Detalle
		GROUP BY CuentaContable, CentroCosto;

	END IF;

	-- Obtengo las sumatorias de Saldos
	SELECT
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN SaldoInicialDeu ELSE Decimal_Cero END),2),
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN SaldoInicialAcre ELSE Decimal_Cero END),2),
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN Cargos ELSE Decimal_Cero END),2),
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN Abonos ELSE Decimal_Cero END),2),
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN SaldoDeudor ELSE Decimal_Cero END),2),
		ROUND(SUM(CASE WHEN Grupo = Tip_Detalle THEN SaldoAcreedor ELSE Decimal_Cero END),2)
	INTO
		Var_SumaSalIniDeu,	Var_SumaSalIniAcre,	Var_SumaCargos,	Var_SumaAbonos,	Var_SumaSalDeu,
		Var_SumaSalAcr
	FROM TMPBALANZACONTABLE
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	SET	Var_SumaSalIniDeu	:= IFNULL(Var_SumaSalIniDeu,Entero_Cero);
	SET	Var_SumaSalIniAcre	:= IFNULL(Var_SumaSalIniAcre,Entero_Cero);
	SET	Var_SumaCargos		:= IFNULL(Var_SumaCargos,Entero_Cero);
	SET	Var_SumaAbonos		:= IFNULL(Var_SumaAbonos,Entero_Cero);
	SET	Var_SumaSalDeu		:= IFNULL(Var_SumaSalDeu,Entero_Cero);
	SET	Var_SumaSalAcr		:= IFNULL(Var_SumaSalAcr,Entero_Cero);

	-- Si los Saldos son Cero borramos los elementos.
	IF(Par_SaldosCero = No_SaldoCeros) THEN

		DELETE FROM TMPBALANZACONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion
		  AND (ABS(SaldoInicialDeu) + ABS(SaldoInicialAcre)+ ABS(Cargos) + ABS(Abonos)) = Entero_Cero;

	END IF;

	-- Si el valor del Segmento es distinto se eliminan
	IF(Var_NumSegmen != Entero_Cero) THEN
		DELETE FROM TMPBALANZACONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion
		  AND CHAR_LENGTH(CuentaMayor) > Var_NumSegmen;
	END IF;

	-- Silas Ciifras son en Miles se divide
	IF(Par_Cifras = Cifras_Miles) THEN

		UPDATE TMPBALANZACONTABLE SET
			SaldoInicialDeu		= ROUND(SaldoInicialDeu / Decimal_Cien, 2),
			SaldoInicialAcre	= ROUND(SaldoInicialAcre / Decimal_Cien, 2),
			Cargos				= ROUND(Cargos / Decimal_Cien, 2),
			Abonos				= ROUND(Abonos / Decimal_Cien, 2),
			SaldoDeudor			= ROUND(SaldoDeudor / Decimal_Cien, 2),
			SaldoAcreedor		= ROUND(SaldoAcreedor / Decimal_Cien, 2)
		WHERE NumeroTransaccion = Aud_NumTransaccion;

		SET	Var_SumaSalIniDeu	:= ROUND(Var_SumaSalIniDeu / Decimal_Cien, 2);
		SET	Var_SumaSalIniAcre	:= ROUND(Var_SumaSalIniAcre / Decimal_Cien, 2);
		SET	Var_SumaCargos		:= ROUND(Var_SumaCargos / Decimal_Cien, 2);
		SET	Var_SumaAbonos		:= ROUND(Var_SumaAbonos / Decimal_Cien, 2);
		SET	Var_SumaSalDeu		:= ROUND(Var_SumaSalDeu / Decimal_Cien, 2);
		SET	Var_SumaSalAcr		:= ROUND(Var_SumaSalAcr / Decimal_Cien, 2);

	END IF;

	-- Actualizo la Descripcion de las cuentas contables.
	UPDATE TMPBALANZACONTABLE Tmp, CUENTASCONTABLES Cue SET
		Tmp.DescripcionCuenta = Cue.Descripcion
	WHERE Tmp.CuentaContable = Cue.CuentaCompleta;

	-- --------------------------------------------------------------
	-- TERMINA
	-- ---------------------------------------------------------------
	-- SELECT Final.
	IF( Aud_ProgramaID <> Con_Electronica ) THEN
		SELECT	CuentaContable,  DescripcionCuenta,	CentroCosto, Grupo,
				ROUND(SaldoInicialDeu, 2) AS SaldoInicial,
				ROUND(SaldoInicialAcre, 2) AS SaldoInicialAcre,
				ROUND(Cargos, 2) AS Cargos,
				ROUND(Abonos, 2) AS Abonos,
				ROUND(SaldoDeudor, 2) AS SaldoDeudor,
				ROUND(SaldoAcreedor, 2) AS SaldoAcreedor,
				Par_Fecha AS fecha,Var_PerMes ,

				Var_SumaSalIniDeu AS SumaSalIni,
				Var_SumaSalIniAcre AS SumaSalIniAcre,
				Var_SumaCargos AS SumaCargos,
				Var_SumaAbonos AS SumaAbonos,
				Var_SumaSalDeu AS SumaSalDeu,
				Var_SumaSalAcr AS SumaSalAcr

		FROM TMPBALANZACONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion
		ORDER BY CuentaContable, CentroCosto;
	ELSE

		DROP TABLE IF EXISTS `temporal_balanza`;
		CREATE TABLE `temporal_balanza` (
			`CuentaContable`		VARCHAR(50)		COMMENT 'Cuenta Contable Completa',
			`DescripcionCuenta`		VARCHAR(250)	COMMENT 'Descripcion de la Cuenta Contable',
			`Grupo`					CHAR(1)			COMMENT 'nivel de Detalle. \nE.- Encabezado \nD.-Detalle',

			`SaldoInicial`			DECIMAL(21,2)	COMMENT 'Saldo Inicial Deudor',
			`SaldoInicialAcre`		DECIMAL(21,2)	COMMENT 'Saldo Inicial Acreedor',
			`Cargos`				DECIMAL(21,2)	COMMENT 'Cargos',
			`Abonos`				DECIMAL(21,2)	COMMENT 'Abonos',
			`SaldoDeudor`			DECIMAL(21,2)	COMMENT 'Saldo Final Deudor',
			`SaldoAcreedor`			DECIMAL(21,2)	COMMENT 'Saldo Final Acreedor',

			`fecha`					DATE 			COMMENT 'Fecha de la Balanza',
			`Var_PerMes`			VARCHAR(30)		COMMENT 'Periodo del Mes',
			`SumaSalIni`			DECIMAL(21,2)	COMMENT 'Suma Inicial de Cargos',
			`SumaSalIniAcre`		DECIMAL(21,2)	COMMENT 'Suma Inicial de Abonos',
			`SumaCargos`			DECIMAL(21,2)	COMMENT 'Suma de Cargos',
			`SumaAbonos`			DECIMAL(21,2)	COMMENT 'Suma de Abonos',
			`SumaSalDeu`			DECIMAL(21,2)	COMMENT 'Suma Final de Cargos',
			`SumaSalAcr`			DECIMAL(21,2)	COMMENT 'Suma Final de Abonos',
			KEY `INDEX_temporal_balanza_1` (`CuentaContable`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal de Balanza Utilizada para la Balanza Contable Electronica';

		INSERT INTO temporal_balanza(
			CuentaContable,		DescripcionCuenta,	Grupo,
			SaldoInicial,		SaldoInicialAcre,	Cargos,
			Abonos,				SaldoDeudor,		SaldoAcreedor,
			fecha,				Var_PerMes,			SumaSalIni,
			SumaSalIniAcre,		SumaCargos,			SumaAbonos,
			SumaSalDeu,			SumaSalAcr)
		SELECT	CuentaContable,  DescripcionCuenta,	Grupo,
				ROUND(SaldoInicialDeu, 2) AS SaldoInicial,
				ROUND(SaldoInicialAcre, 2) AS SaldoInicialAcre,
				ROUND(Cargos, 2) AS Cargos,
				ROUND(Abonos, 2) AS Abonos,
				ROUND(SaldoDeudor, 2) AS SaldoDeudor,
				ROUND(SaldoAcreedor, 2) AS SaldoAcreedor,

				Par_Fecha AS fecha,
				Var_PerMes ,
				Var_SumaSalIniDeu AS SumaSalIni,
				Var_SumaSalIniAcre AS SumaSalIniAcre,
				Var_SumaCargos AS SumaCargos,
				Var_SumaAbonos AS SumaAbonos,
				Var_SumaSalDeu AS SumaSalDeu,
				Var_SumaSalAcr AS SumaSalAcr
		FROM TMPBALANZACONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion
		ORDER BY CuentaContable;
	END IF;

	-- Borrado de Tablas Temporales.
	TRUNCATE TMPBALCUENTACONTABLE;

	TRUNCATE TMPBALANZACONTABLE;

	TRUNCATE TMPSALCONTACENCOSTOS;

	TRUNCATE TMPBALPOLCENCOS;

	DELETE FROM TMPBALANZACENCOS WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS `TMPBALPOLCENCOS_AUX`;

	DROP TABLE IF EXISTS `TMP_ITERACENTROCOSTO`;

END TerminaStore$$