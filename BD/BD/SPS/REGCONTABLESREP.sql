-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGCONTABLESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCONTABLESREP`;
DELIMITER $$


CREATE PROCEDURE `REGCONTABLESREP`(
	-- Genera los regulatorios contables
	-- Modulo Regulatorios
	Par_FechaActual		DATE,			-- Fecha Actual
	Par_FechaAnterior	DATE,			-- Fecha Anterior
	Par_TipoConsulta	INT(11),		-- Indica la presentacion del reporte. 1 - Excel, 2 - csv
	Par_ClaveReporte	VARCHAR(20),	-- Indica el reporte a generar

	Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaración de variables
	DECLARE Var_ConceptoID			INT(11);		-- Concepto Minimo
	DECLARE Var_ConceptoIDMax		INT(11);		-- Concepto Maximo
	DECLARE Var_Contador			INT(11);		-- Contador de Ayuda en Ciclo
	DECLARE Var_ContadorT			INT(11);		-- Contador de Ayudo en ciclo tipo saldo

	DECLARE Var_AcumuladoCta 		DECIMAL(18,2);	-- Acumulado de la Cuenta

	DECLARE Var_FecConsultaActual	DATE;			-- Fecha de Consulta Actual
	DECLARE Var_FecConsultaAnterior	DATE;			-- Fecha de Consulta Anterior
	DECLARE Var_FechaHistorica		DATE;			-- Fecha de Consulta Historica
	DECLARE Var_FechaDetallePoliza	DATE;			-- Fecha de Consulta Detalle Poliza

	DECLARE	Var_NumCliente			INT(11);		-- Numero de cliente especifico;
	DECLARE Var_ClaveEntidad		VARCHAR(10);	-- Entidad Financiera

	DECLARE Var_UbicaSaldoContable	CHAR(1);
	DECLARE Var_Formula				VARCHAR(300);	-- Formula a evaluar. Puede ser contable o de reporte
	DECLARE Var_FuncionCalculo		VARCHAR(300);	-- Funcion a ejecutar
	DECLARE Var_TipoSaldoID			INT(11);		-- Tipo de saldo del concepto
	DECLARE Var_TipoSaldoIDMax		INT(11);		-- Tipo Saldo Maximo

	DECLARE Var_SentenciaFuncion	TEXT;			-- Llamada a funcion para calculo de saldo
	DECLARE Var_ConsultaReg			TEXT;			-- Consulta para salida en excel
	DECLARE Var_NombreCampo			VARCHAR(20);	-- Campo del tipo de saldo para la tabla temporal de salida excel
	DECLARE Var_MontoSaldo			DECIMAL(12,2);	-- Monto del tipo de saldo

	DECLARE Var_NumErr				INT(11);		-- Numero de error
	DECLARE Var_ErrMen				VARCHAR(400);	-- Mensaje de error

	-- Declaración de constantes
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Uno				INT(11);		-- Entero Uno
	DECLARE Entero_Dos				INT(11);		-- Constante Dos Decimales
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Decimal Vacio

	DECLARE Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE Con_TipoReporte			INT(11);		-- Tipo de Regulatorio
	DECLARE Con_TipoSaldo			INT(11);		-- Tipo de Saldo para el Regulatorio

	DECLARE SaldoContableActual		CHAR(3);		-- Saldo Contable Actual
	DECLARE SaldoInicioFin			CHAR(3);		-- Saldo Actual-Anterior
	DECLARE SaldoFinInicio			CHAR(3);		-- Saldo Anterior-Actual
	DECLARE SaldoContableAnterior	CHAR(3);		-- Saldo Contable Anterior

    DECLARE Con_Historica			CHAR(1);		-- Consulta historica
    DECLARE Con_Actual				CHAR(1);		-- Consulta actual
	DECLARE Con_Periodo				CHAR(1);		-- Consulta por periodo
	DECLARE Con_Fecha				CHAR(1);		-- Consulta por fecha

    DECLARE Salida_No				CHAR(1);		-- Salida no

	DECLARE Reporte_Excel			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia 			:= '';
	SET Entero_Cero 			:= 0;
	SET Entero_Uno				:= 1;
	SET Entero_Dos				:= 2;
	SET Decimal_Cero 			:= 0.0;

	SET Fecha_Vacia 			:= '1900-01-01';
	SET Con_TipoSaldo			:= 1;

	SET SaldoContableActual		:= 'SCI';
	SET SaldoInicioFin			:= 'SIF';
	SET SaldoFinInicio			:= 'SFI';
	SET SaldoContableAnterior 	:= 'SCF';

    SET Con_Historica			:= 'H';
    SET Con_Actual				:= 'A';
	SET Con_Periodo				:= 'P';
	SET Con_Fecha				:= 'F';
    SET Salida_No				:= 'N';

    SET Reporte_Excel			:= 1;

	-- Obtenemos el tipo de reporte
	SET Con_TipoReporte := SUBSTRING(Par_ClaveReporte, Entero_Dos);

	-- Tabla temporal para saldos que se obtienen a partir de funciones
	DROP TABLE IF EXISTS TMP_FUNTIPOSSALDOSREG;
	CREATE TEMPORARY TABLE TMP_FUNTIPOSSALDOSREG(
		RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
		ConceptoID			INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		TipoSaldoID			INT(11)			NOT NULL COMMENT 'Consecutivo por concepto para el tipo de saldo.',
		FuncionCalculo		VARCHAR(300)	NOT NULL COMMENT 'Nombre de funcion a ejecutar para calcular el saldo del concepto',
		KEY `IDX_TMP_FUNTIPOSSALDOSREG_1` (`RegistroID`),
		KEY `IDX_TMP_FUNTIPOSSALDOSREG_2` (`ConceptoID`, `TipoSaldoID`)
	);

	-- Tabla temporal para saldos que se obtienen a partir de saldos previamente calculados
	DROP TABLE IF EXISTS TMP_ENCTIPOSSALDOSREG;
	CREATE TEMPORARY TABLE TMP_ENCTIPOSSALDOSREG(
		RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
		ConceptoID			INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		TipoSaldoID			INT(11)			NOT NULL COMMENT 'Consecutivo por concepto para el tipo de saldo.',
		FormulaReporte		VARCHAR(300)	NOT NULL COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo CuentaContable"',
		KEY `IDX_TMP_ENCREGCONTABLESREP_1` (`RegistroID`),
		KEY `IDX_TMP_ENCREGCONTABLESREP_2` (`ConceptoID`, `TipoSaldoID`)
	);

	-- Tabla temporal para conceptos cuyo saldo se obtiene de cuentas contables
	DROP TABLE IF EXISTS TMP_DETTIPOSSALDOSREG;
	CREATE TEMPORARY TABLE TMP_DETTIPOSSALDOSREG(
		RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
		ConceptoID			INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		TipoSaldoID			INT(11)			NOT NULL COMMENT 'Consecutivo por concepto para el tipo de saldo.',
		FormulaContable		VARCHAR(300)	NOT NULL COMMENT 'Formula Contable',
		KEY `IDX_TMP_DETREGCONTABLESREP_1` (`RegistroID`),
		KEY `IDX_TMP_DETREGCONTABLESREP_2` (`ConceptoID`, `TipoSaldoID`)
	);

	-- Se obtiene el numero de cliente para procesos especificos
	SELECT IFNULL(ValorParametro, Entero_Cero)
	INTO Var_NumCliente
	FROM PARAMGENERALES
	WHERE LlaveParametro = 'CliProcEspecifico';

	-- Se obtiene clave de la entidad
	SELECT IFNULL(ClaveEntidad, Cadena_Vacia)
	INTO   Var_ClaveEntidad
	FROM PARAMETROSSIS
	WHERE EmpresaID = Aud_EmpresaID;

	-- Generamos un numero de transaccion para el reporte
	CALL TRANSACCIONESPRO(Aud_NumTransaccion);
	-- Borramos posible basura
	DELETE FROM TMPTIPOSSALDOSREG
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	SET Var_FecConsultaActual := Par_FechaActual ;
	SET Var_FecConsultaAnterior := Par_FechaAnterior ;

	-- Se obtienen fechas del ultimo periodo cerrado y del ultimo registro contable
	SELECT MAX(Fecha) INTO Var_FechaHistorica
		FROM `HIS-DETALLEPOL`;
	SELECT MAX(Fecha) INTO Var_FechaDetallePoliza
		FROM DETALLEPOLIZA;

	-- Se insertan las cuentas contables
	INSERT INTO TMPTIPOSSALDOSREG(
		ConceptoID,		TipoSaldoID,	ClaveSaldo,		ClaveCampo,		Descripcion,
		SaldoActual,	SaldoAnterior,	SaldoFinal,		CampoReporte,	Presentacion,
		NumeroTransaccion)
	SELECT
		T.ConceptoID,	T.TipoSaldoID,	T.ClaveSaldo,	T.ClaveCampo,	T.Descripcion,
		Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	T.CampoReporte,
		T.Presentacion,	Aud_NumTransaccion
	FROM TIPOSSALDOSREG T
	WHERE T.NumeroCliente = Var_NumCliente
	  AND T.ReporteID = Par_ClaveReporte;

	-- Se insertan los coneptos de saldo por formula
	INSERT INTO TMP_FUNTIPOSSALDOSREG(
		RegistroID, ConceptoID, TipoSaldoID, FuncionCalculo)
	SELECT
		Entero_Cero, T.ConceptoID, T.TipoSaldoID, T.FuncionCalculo
	FROM TIPOSSALDOSREG T
	WHERE T.NumeroCliente = Var_NumCliente
	  AND T.ReporteID = Par_ClaveReporte
	  AND T.FuncionCalculo <> Cadena_Vacia
	ORDER BY T.OrdenCalculo ASC;

	SET @Consecutivo := Entero_Cero;
	UPDATE TMP_FUNTIPOSSALDOSREG SET
		RegistroID = (@Consecutivo:=(@Consecutivo + Entero_Uno));

	-- Se insertan los conceptos de tipo encabezado
	INSERT INTO TMP_ENCTIPOSSALDOSREG(
		RegistroID,		ConceptoID,		TipoSaldoID,	FormulaReporte)
	SELECT
		Entero_Cero,	T.ConceptoID,	T.TipoSaldoID,	T.FormulaReporte
	FROM TIPOSSALDOSREG T
	WHERE T.NumeroCliente = Var_NumCliente
	  AND T.ReporteID = Par_ClaveReporte
	  AND T.FormulaReporte <> Cadena_Vacia
	  AND T.FuncionCalculo = Cadena_Vacia
	ORDER BY T.OrdenCalculo ASC;

	SET @Consecutivo := Entero_Cero;
	UPDATE TMP_ENCTIPOSSALDOSREG SET
		RegistroID = (@Consecutivo:=(@Consecutivo + Entero_Uno));

	-- Se insertar las conceptos de tipo detalle
	INSERT INTO TMP_DETTIPOSSALDOSREG(
		RegistroID,		ConceptoID,		TipoSaldoID,	FormulaContable)
	SELECT
		Entero_Cero,	T.ConceptoID,	T.TipoSaldoID,	T.FormulaContable
	FROM TIPOSSALDOSREG T
	WHERE T.NumeroCliente = Var_NumCliente
	  AND T.ReporteID = Par_ClaveReporte
	  AND T.FormulaContable <> Cadena_Vacia
      AND T.FormulaReporte = Cadena_Vacia
	  AND T.FuncionCalculo = Cadena_Vacia;

	SET @Consecutivo := Entero_Cero;
	UPDATE TMP_DETTIPOSSALDOSREG SET
		RegistroID = (@Consecutivo:=(@Consecutivo + Entero_Uno));

	-- Primero se calculan los saldos de los conceptos de tipo detalle
	-- Se evaluan los datos de la fecha actual
	IF (Par_FechaActual <> Fecha_Vacia) THEN
		SET Var_Contador := 1;

		-- Se identifica la ubicación de los saldos
		IF (Var_FecConsultaActual <= Var_FechaHistorica) THEN
			SET Var_UbicaSaldoContable := Con_Historica;
		ELSE
			SET Var_UbicaSaldoContable := Con_Actual;
		END IF;

		SELECT IFNULL( MAX(RegistroID), Entero_Cero)
		INTO   Var_ConceptoIDMax
		FROM TMP_DETTIPOSSALDOSREG;

		WHILE (Var_Contador <= Var_ConceptoIDMax) DO

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_Formula			:= Cadena_Vacia;

			-- Se obtiene el concepto a actualizar y su formula contable
			SELECT ConceptoID,		TipoSaldoID,		FormulaContable
			INTO   Var_ConceptoID,	Var_TipoSaldoID,	Var_Formula
			FROM TMP_DETTIPOSSALDOSREG
			WHERE RegistroID = Var_Contador;

			IF (Var_ConceptoID > Entero_Cero) THEN
				IF (Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Var_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				END IF;
				SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

				-- Se actualiza la tabla temporal de salida
				UPDATE TMPTIPOSSALDOSREG T SET
					T.SaldoActual = Var_AcumuladoCta
				WHERE T.ConceptoID = Var_ConceptoID
				  AND T.TipoSaldoID = Var_TipoSaldoID
				  AND T.NumeroTransaccion = Aud_NumTransaccion;
			END IF;

			SET Var_Contador := Var_Contador + 1;
		END WHILE;
	END IF;

	-- Se evaluan los datos de la fecha anterior
	IF (Par_FechaAnterior <> Fecha_Vacia) THEN
		SET Var_Contador := 1;

		-- Se identifica la ubicación de los saldos
		IF (Var_FecConsultaAnterior <= Var_FechaHistorica) THEN
			SET Var_UbicaSaldoContable := Con_Historica;
		ELSE
			SET Var_UbicaSaldoContable := Con_Actual;
		END IF;

		WHILE (Var_Contador <= Var_ConceptoIDMax) DO

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_Formula			:= Cadena_Vacia;

			-- Se obtiene el concepto a actualizar y su formula contable
			SELECT ConceptoID,		TipoSaldoID,		FormulaContable
			INTO   Var_ConceptoID,	Var_TipoSaldoID,	Var_Formula
			FROM TMP_DETTIPOSSALDOSREG
			WHERE RegistroID = Var_Contador;

			IF (Var_ConceptoID > Entero_Cero) THEN
				IF (Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Var_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaAnterior);
				END IF;
				SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

				-- Se actualiza la tabla temporal de salida
				UPDATE TMPTIPOSSALDOSREG T SET
					T.SaldoAnterior = Var_AcumuladoCta
				WHERE T.ConceptoID = Var_ConceptoID
				  AND T.TipoSaldoID = Var_TipoSaldoID
				  AND T.NumeroTransaccion = Aud_NumTransaccion;
			END IF;

			SET Var_Contador := Var_Contador + 1;
		END WHILE;

		-- Se ajustan los saldos finales de acuerdo a la configuracion de salida
		UPDATE TMPTIPOSSALDOSREG SET
			SaldoFinal = CASE WHEN Presentacion = SaldoContableActual	THEN SaldoActual
							  WHEN Presentacion = SaldoInicioFin 		THEN SaldoActual - SaldoAnterior
							  WHEN Presentacion = SaldoFinInicio 		THEN SaldoAnterior - SaldoActual
							  WHEN Presentacion = SaldoContableAnterior THEN SaldoAnterior
						 END
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	END IF;

	-- Ahora se calculan los saldos de los conceptos de tipo de encabezado
	-- Se encuentra el id maximo de los conceptos
	SELECT IFNULL(MAX(RegistroID), Entero_Cero)
	INTO   Var_ConceptoIDMax
	FROM TMP_ENCTIPOSSALDOSREG;

	-- Si existe al menos un registro de formula se calcula el saldo final
	IF(Var_ConceptoIDMax > Entero_Cero) THEN
		SET Var_Contador := Entero_Uno;

		WHILE (Var_Contador <= Var_ConceptoIDMax) DO

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_Formula			:= Cadena_Vacia;
			-- Se obtiene el concepto a actualizar y la formula
			SELECT ConceptoID,		TipoSaldoID,		FormulaReporte
			INTO   Var_ConceptoID,	Var_TipoSaldoID,	Var_Formula
			FROM TMP_ENCTIPOSSALDOSREG
			WHERE RegistroID = Var_Contador;

			IF (Var_ConceptoID > Entero_Cero) THEN

				CALL EVALFORMULAREPPRO(Var_AcumuladoCta, Var_Formula, Salida_No, Var_NumErr, Var_ErrMen,
										Aud_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);
				IF (Var_NumErr != Entero_Cero) THEN
					SET Var_AcumuladoCta := Decimal_Cero;
				END IF;

				SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

				-- Se actualiza la tabla temporal de salida
				UPDATE TMPTIPOSSALDOSREG T SET
					T.SaldoFinal = Var_AcumuladoCta
				WHERE T.ConceptoID = Var_ConceptoID
				  AND T.TipoSaldoID = Var_TipoSaldoID
				  AND T.NumeroTransaccion = Aud_NumTransaccion;

			END IF;
			SET Var_Contador := Var_Contador + 1;

		END WHILE;

	END IF;

	-- Se calculan los saldos de los conceptos por funcion
	-- Se encuentra el id maximo de los conceptos
	SELECT IFNULL(MAX(RegistroID), Entero_Cero)
	INTO   Var_ConceptoIDMax
	FROM TMP_FUNTIPOSSALDOSREG;

	IF(Var_ConceptoIDMax > Entero_Cero) THEN
		SET Var_Contador := Entero_Uno;

		WHILE (Var_Contador <= Var_ConceptoIDMax) DO

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_Formula			:= Cadena_Vacia;
			-- Se obtiene el concepto a actualizar y la formula
			SELECT ConceptoID,		TipoSaldoID,		FuncionCalculo
			INTO   Var_ConceptoID,	Var_TipoSaldoID,	Var_FuncionCalculo
			FROM TMP_FUNTIPOSSALDOSREG
			WHERE RegistroID = Var_Contador;

			IF (Var_ConceptoID > Entero_Cero) THEN

				SET Var_SentenciaFuncion := CONCAT('SET @Resultado := ', Var_FuncionCalculo);
				SET Var_SentenciaFuncion := CONCAT(Var_SentenciaFuncion, '();');
				SET @SentenciaReg    = (Var_SentenciaFuncion);
				PREPARE EjecutaProcReg FROM @SentenciaReg;
				EXECUTE  EjecutaProcReg;
				DEALLOCATE PREPARE EjecutaProcReg;

				SET Var_AcumuladoCta := @Resultado;

				SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

				-- Se actualiza la tabla temporal de salida
				UPDATE TMPTIPOSSALDOSREG T SET
					T.SaldoFinal = Var_AcumuladoCta
				WHERE T.ConceptoID = Var_ConceptoID
				  AND T.TipoSaldoID = Var_TipoSaldoID
				  AND T.NumeroTransaccion = Aud_NumTransaccion;

			END IF;
			SET Var_Contador := Var_Contador + 1;

		END WHILE;

	END IF;

	-- Salida
	IF(Reporte_Excel = Par_TipoConsulta) THEN

		-- Se realizar cursor para la salida de los campo
		SET Var_ConsultaReg := 'SELECT ';
		SET Var_Contador := Entero_Uno;

		SELECT IFNULL( MAX(ConceptoID), Entero_Cero)
		INTO   Var_ConceptoIDMax
		FROM TMPTIPOSSALDOSREG
		WHERE NumeroTransaccion = Aud_NumTransaccion;

		-- Se arma el select de salida
		WHILE (Var_Contador <= Var_ConceptoIDMax) DO

			SET Var_TipoSaldoIDMax := (SELECT IFNULL( MAX(TipoSaldoID), Entero_Cero)
										FROM TMPTIPOSSALDOSREG
										WHERE ConceptoID = Var_Contador
											AND NumeroTransaccion = Aud_NumTransaccion);
			SET Var_ContadorT := Entero_Cero;
			WHILE (Var_ContadorT <= Var_TipoSaldoIDMax) DO
				SELECT CampoReporte,		SaldoFinal
				INTO   Var_NombreCampo,	Var_MontoSaldo
				FROM TMPTIPOSSALDOSREG
				WHERE ConceptoID = Var_Contador
				AND TipoSaldoID = Var_ContadorT
				AND NumeroTransaccion = Aud_NumTransaccion;

				IF( Var_NombreCampo <> Cadena_Vacia  ) THEN
					SET Var_ConsultaReg := CONCAT(Var_ConsultaReg,' ',Var_MontoSaldo,' AS ', Var_NombreCampo);
					SET Var_ConsultaReg := CONCAT(Var_ConsultaReg, IF(Var_Contador = Var_ConceptoIDMax AND Var_ContadorT = Var_TipoSaldoIDMax, ';', ','));
				END IF;

				SET Var_ContadorT := Var_ContadorT + Entero_Uno;
			END WHILE;

			SET Var_Contador := Var_Contador + Entero_Uno;

		END WHILE;

		SET @SentenciaReg    = (Var_ConsultaReg);
		PREPARE EjecutaProcReg FROM @SentenciaReg;
		EXECUTE  EjecutaProcReg;
		DEALLOCATE PREPARE EjecutaProcReg;

	ELSE

		SELECT CONCAT(C.ClaveConcepto,';',Con_TipoReporte,';',tmp.ClaveSaldo,';', ROUND(tmp.SaldoFinal,2)) AS Valor
		FROM TMPTIPOSSALDOSREG tmp
			INNER JOIN CONCEPTOSREG C
					ON C.ConceptoID = tmp.ConceptoID
						AND C.ReporteID = Par_ClaveReporte
						AND C.NumeroCliente = Var_NumCliente
		WHERE tmp.NumeroTransaccion = Aud_NumTransaccion;

	END IF;

	-- Se limpia la tabla temporal
	DELETE FROM TMPTIPOSSALDOSREG
	WHERE NumeroTransaccion = Aud_NumTransaccion;

END TerminaStore$$