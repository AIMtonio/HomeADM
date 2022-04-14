-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALFORMULACONTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALFORMULACONTAPRO`;

DELIMITER $$
CREATE PROCEDURE `EVALFORMULACONTAPRO`(
	-- Store Procedure: Para Evalular una Formula Contable
	-- Modulo: Contabilidad Financiera
	Par_Formula				VARCHAR(500),	-- Formula contable a Calcular
	Par_Ubicacion			CHAR(1),		-- Ubicacion del Saldo: A.- Actual H.- Historico
	Par_Corte				CHAR(1),		-- Corte por Fecha
	Par_Fecha				DATE,			-- Fecha Corte de la Operacion
	Par_Ejercicio			INT(11),		-- Numero de Ejercicio

	Par_Periodo				INT(11),		-- Numero de Periodo del Ejercicio
	Par_FecIniPer			DATE,			-- Fecha de Inicio del Periodo
	OUT Par_AcumuladoCta	DECIMAL(18,2),	-- Acumulado de Calculo de Cuenta
	Par_CCInicial			INT(11),		-- Centro de Costos Inicial
	Par_CCFinal				INT(11),		-- Centro de Costos Final

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
BEGIN

	-- Declaracion de Variables
	DECLARE Contador			INT(11);		-- Contador de Formula
	DECLARE Var_IdxSignoMas		INT(11);		-- Indice de Signo Mas
	DECLARE Var_IdxSignoMenos	INT(11);		-- Indice de Signo Menos
	DECLARE Var_CtaSegmento		VARCHAR(500);	-- Segmento de Formula
	DECLARE Var_Sentencia		VARCHAR(1000);	-- Sentencia de Ejecucion
	DECLARE Var_SaldoCuenta		DECIMAL(18,2);	-- Saldo de la Cuenta Contable

	DECLARE Var_LongCuentas		INT(11);		-- Longitud de la Cuenta
	DECLARE Var_CtaBusqueda		VARCHAR(50);	-- Variable Auxiliar de Cuenta Contable
	DECLARE Var_TipoNaturaCta	CHAR(1);		-- Tipo de La naturaleza de la cuenta Contable
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Sistema

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);	-- Constante Entero Cero
	DECLARE Entero_Uno		INT(11);	-- Constante Entero Uno
	DECLARE Ubi_Actual		CHAR(1);	-- Constante Ubicacion Actual
	DECLARE Ubi_Histor		CHAR(1);	-- Constante Ubicacion Historica
	DECLARE Con_Periodo		CHAR(1);	-- Constante Constante Periodo

	DECLARE Con_Fecha		CHAR(1);	-- Constante Constante Fecha
	DECLARE Con_Deudora		CHAR(1);	-- Constante Naturaleza Deudora
	DECLARE Con_Acreedora	CHAR(1);	-- Constante Naturaleza Acreedora
	DECLARE Con_SignoMas	CHAR(1);	-- Constante Signo Mas
	DECLARE Con_SignoMenos	CHAR(1);	-- Constante Signo Menos

	DECLARE Con_Porcentaje	CHAR(1);	-- Constante Porcentaje
	DECLARE Cadena_Vacia	CHAR(1);	-- Constante Cadena Vacia
	DECLARE Cadena_Cero		CHAR(1);	-- Constante Cadena Cero

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Ubi_Actual			:= 'A';
	SET Ubi_Histor			:= 'H';
	SET Con_Periodo			:= 'P';

	SET Con_Fecha			:= 'D';
	SET Con_Deudora			:= 'D';
	SET Con_Acreedora		:= 'A';
	SET Con_SignoMas		:= '+';
	SET Con_SignoMenos		:= '-';

	SET Con_Porcentaje		:= '%';
	SET Cadena_Vacia		:= '';
	SET Cadena_Cero			:= '0';

	-- Inicializacion de Variables
	SET Var_Sentencia		:= Par_Formula;
	SET Contador			:= Entero_Cero;
	SET Par_Ejercicio		:= IFNULL(Par_Ejercicio, Entero_Cero);
	SET Par_Periodo			:= IFNULL(Par_Periodo, Entero_Cero);
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

	SELECT LENGTH(CuentaCompleta)
	INTO Var_LongCuentas
	FROM CUENTASCONTABLES LIMIT 1;

	IF(LOCATE(Con_SignoMas, Par_Formula) > Entero_Cero OR LOCATE(Con_SignoMenos, Par_Formula) > Entero_Cero) THEN
		WHILE ((LOCATE(Con_SignoMas, Par_Formula) > Entero_Cero OR LOCATE(Con_SignoMenos, Par_Formula) > Entero_Cero) AND Contador <= 200) DO

			SET Var_SaldoCuenta := Entero_Cero;

			SET Var_IdxSignoMas   := LOCATE(Con_SignoMas, Par_Formula);
			SET Var_IdxSignoMenos := LOCATE(Con_SignoMenos, Par_Formula);

			-- Obtengo el Segmento de la Cuenta contable a Evalaur
			IF(Var_IdxSignoMas != Entero_Cero) THEN
				IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR
					Var_IdxSignoMenos = Entero_Cero ) THEN
					SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Con_SignoMas, Entero_Uno);
				ELSE
					SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Con_SignoMenos, Entero_Uno);
				END IF;
			ELSE
				SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Con_SignoMenos, Entero_Uno);
			END IF;

			-- Obtengo la cuenta de Busqueda para obtener la maxima naturaleza del segmento
			SET Var_CtaSegmento := LTRIM(RTRIM(Var_CtaSegmento));
			SET Var_CtaBusqueda := RPAD(REPLACE(Var_CtaSegmento,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);

			SELECT Naturaleza INTO Var_TipoNaturaCta
			FROM CUENTASCONTABLES
			WHERE CuentaCompleta = Var_CtaBusqueda;

			-- Ubicacion Actual
			IF (Par_Ubicacion = Ubi_Actual) THEN

				INSERT INTO TMPCONTABLE
				SELECT  Aud_NumTransaccion, Par_Fecha, Cue.CuentaCompleta, Entero_Cero,
						Entero_Cero, Entero_Cero,
						Cue.Naturaleza,
						CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
								ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
												IFNULL(Pol.Abonos, Entero_Cero))    , 2)
							 ELSE
								Entero_Cero
						END,
						CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
								ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
												IFNULL(Pol.Cargos, Entero_Cero))    , 2)
							 ELSE
								Entero_Cero
						END,
						Entero_Cero, Entero_Cero
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN SALDOSDETALLEPOLIZA AS Pol ON ( Pol.Fecha <= Par_Fecha
															AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
															AND Pol.CuentaCompleta = Cue.CuentaCompleta)
				WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
				GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

				IF( Par_Fecha = Var_FechaSistema ) THEN

					DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

					INSERT INTO TMPBALPOLCENCOSDIA (
							NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
					SELECT	Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
							CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
									SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
									SUM((IFNULL(Pol.Abonos, Entero_Cero)))
								 ELSE
									Entero_Cero
								END,
							CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
									SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
									SUM((IFNULL(Pol.Cargos, Entero_Cero)))
								 ELSE
									Entero_Cero
							END
					FROM CUENTASCONTABLES Cue
					INNER JOIN DETALLEPOLIZA AS Pol ON (Pol.Fecha = Var_FechaSistema
													AND Pol.CuentaCompleta = Cue.CuentaCompleta
													AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
					WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
					GROUP BY Pol.CuentaCompleta, Cue.Naturaleza;

					UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
						Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
						Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
					WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
					  AND Tmp.NumeroTransaccion = Aux.NumTransaccion
					  AND Tmp.CuentaContable = Aux.CuentaCompleta;

					DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

				END IF;

			ELSE

				-- Ubicacion historica
				INSERT INTO TMPCONTABLE
				SELECT  Aud_NumTransaccion, Par_Fecha, Cue.CuentaCompleta, Entero_Cero,
						Entero_Cero, Entero_Cero,
						Cue.Naturaleza,
						CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
								ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
												IFNULL(Pol.Abonos, Entero_Cero))    , 2)
							 ELSE
								Entero_Cero
						END,
						CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
								ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
												IFNULL(Pol.Cargos, Entero_Cero))    , 2)
							 ELSE
								Entero_Cero
						END,
						Entero_Cero, Entero_Cero
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN	HISSALDOSDETPOLIZA AS Pol ON ( Pol.Fecha BETWEEN Par_FecIniPer AND Par_Fecha
														   AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
														   AND Pol.CuentaCompleta = Cue.CuentaCompleta)
				WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
				GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

			END IF;

			-- Obtengo el saldo Inicial del la cuenta
			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
			INSERT INTO TMPSALDOCONTABLE
			SELECT  Aud_NumTransaccion, Sal.CuentaCompleta,
					SUM(CASE WHEN Tmp.Naturaleza = Con_Deudora  THEN
								  Sal.SaldoFinal
							 ELSE
								  Entero_Cero
						END) AS SaldoInicialDeudor,
					SUM(CASE WHEN Tmp.Naturaleza = Con_Acreedora  THEN
								  Sal.SaldoFinal
							 ELSE
								  Entero_Cero
						END) AS SaldoInicialAcreedor
			FROM    TMPCONTABLE Tmp
			INNER JOIN SALDOSCONTABLES Sal ON (Tmp.CuentaContable = Sal.CuentaCompleta
										   AND Sal.EjercicioID = Par_Ejercicio
										   AND Sal.PeriodoID = Par_Periodo
										   AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal)
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			GROUP BY Sal.CuentaCompleta;

			-- Actualizo los saldos Iniciales de la cuenta
			UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
				Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
				Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
			  AND Tmp.CuentaContable = Sal.CuentaContable;

			-- Sumo los saldos de la Cuenta
			SET Var_SaldoCuenta := (
				SELECT SUM( CASE WHEN Var_TipoNaturaCta = Con_Deudora
							THEN
								ROUND(  IFNULL(Pol.SaldoInicialDeu, Entero_Cero) -
										IFNULL(Pol.SaldoInicialAcr, Entero_Cero) +
										IFNULL(Pol.SaldoDeudor, Entero_Cero) -
										IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)
							ELSE
								ROUND(  IFNULL(Pol.SaldoInicialAcr, Entero_Cero) -
										IFNULL(Pol.SaldoInicialDeu, Entero_Cero) +
										IFNULL(Pol.SaldoAcreedor, Entero_Cero) -
										IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)
							END )
				FROM TMPCONTABLE Pol
				WHERE Pol.NumeroTransaccion = Aud_NumTransaccion );

			-- Elimino los datos para la proxima iteracion
			DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;
			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

			SET Var_SaldoCuenta     := IFNULL(Var_SaldoCuenta, Entero_Cero);

			-- Reemplazo el Segmento de la Cuenta
			SET Var_Sentencia := REPLACE(Var_Sentencia, Var_CtaSegmento, CONVERT(Var_SaldoCuenta, CHAR));
			SET Par_Formula := REPLACE(Par_Formula, Var_CtaSegmento, Cadena_Vacia);

			-- Corto el bloque evaluado
			IF(Var_IdxSignoMas != Entero_Cero) THEN
				IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
					SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Con_SignoMas, Par_Formula) + Entero_Uno);
				ELSE
					SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Con_SignoMenos, Par_Formula) + Entero_Uno);
				END IF;
			ELSE
				SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Con_SignoMenos, Par_Formula) + Entero_Uno);
			END IF;

			SET Contador := Contador + Entero_Uno;
		END WHILE;

	END IF;

	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

	SET Par_Formula 	:= LTRIM(RTRIM(Par_Formula));
	SET Var_CtaBusqueda := RPAD(REPLACE(Par_Formula,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);

	SELECT Naturaleza INTO Var_TipoNaturaCta
	FROM CUENTASCONTABLES
	WHERE CuentaCompleta = Var_CtaBusqueda;

	-- Ubicacion Actual
	IF (Par_Ubicacion = Ubi_Actual) THEN

		INSERT INTO TMPCONTABLE
		SELECT  Aud_NumTransaccion, Par_Fecha, Cue.CuentaCompleta, Entero_Cero,
				Entero_Cero, Entero_Cero,
				Cue.Naturaleza,
				CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
						ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
										IFNULL(Pol.Abonos, Entero_Cero) ), 2)
					 ELSE
						Entero_Cero
				END,
				CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
						ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
										IFNULL(Pol.Cargos, Entero_Cero) ), 2)
					 ELSE
						Entero_Cero
				END,
				Entero_Cero, Entero_Cero
		FROM CUENTASCONTABLES Cue
		LEFT OUTER JOIN SALDOSDETALLEPOLIZA AS Pol ON ( Pol.Fecha <= Par_Fecha
													AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
													AND Pol.CuentaCompleta = Cue.CuentaCompleta)
		WHERE Cue.CuentaCompleta LIKE Par_Formula
		GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

		IF( Par_Fecha = Var_FechaSistema ) THEN

			DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

			INSERT INTO TMPBALPOLCENCOSDIA (
					NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
			SELECT	Aud_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
					CASE WHEN (Cue.Naturaleza) = Con_Deudora THEN
							SUM((IFNULL(Pol.Cargos, Entero_Cero)))-
							SUM((IFNULL(Pol.Abonos, Entero_Cero)))
						 ELSE
							Entero_Cero
						END,
					CASE WHEN (Cue.Naturaleza) = Con_Acreedora THEN
							SUM((IFNULL(Pol.Abonos, Entero_Cero)))-
							SUM((IFNULL(Pol.Cargos, Entero_Cero)))
						 ELSE
							Entero_Cero
					END
			FROM CUENTASCONTABLES Cue
			INNER JOIN DETALLEPOLIZA AS Pol ON (Pol.Fecha = Var_FechaSistema
											AND Pol.CuentaCompleta = Cue.CuentaCompleta
											AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal)
			WHERE Cue.CuentaCompleta LIKE Par_Formula
			GROUP BY Pol.CuentaCompleta, Cue.Naturaleza;

			UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
				Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
				Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			  AND Tmp.NumeroTransaccion = Aux.NumTransaccion
			  AND Tmp.CuentaContable = Aux.CuentaCompleta;

			DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Aud_NumTransaccion;

		END IF;

	ELSE

		-- Ubicacion historica
		INSERT INTO TMPCONTABLE
		SELECT  Aud_NumTransaccion, Par_Fecha, Cue.CuentaCompleta, Entero_Cero,
				Entero_Cero, Entero_Cero,
				Cue.Naturaleza,
				CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
						ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
										IFNULL(Pol.Abonos, Entero_Cero) ), 2)
					 ELSE
						Entero_Cero
				END,
				CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
						ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
										IFNULL(Pol.Cargos, Entero_Cero) ), 2)
					 ELSE
						Entero_Cero
				END,
				Entero_Cero, Entero_Cero
		FROM CUENTASCONTABLES Cue
		LEFT OUTER JOIN HISSALDOSDETPOLIZA AS Pol ON ( Pol.Fecha BETWEEN Par_FecIniPer AND Par_Fecha
												   AND Pol.CentroCostoID BETWEEN Par_CCInicial AND Par_CCFinal
												   AND Pol.CuentaCompleta = Cue.CuentaCompleta)
		WHERE Cue.CuentaCompleta LIKE Par_Formula
		GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

	END IF;

	-- Obtengo el saldo Inicial del la cuenta
	DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
	INSERT INTO TMPSALDOCONTABLE
	SELECT  Aud_NumTransaccion, Sal.CuentaCompleta,
			SUM(CASE WHEN Tmp.Naturaleza = Con_Deudora  THEN
						  Sal.SaldoFinal
					 ELSE
						  Entero_Cero
				END) AS SaldoInicialDeudor,
			SUM(CASE WHEN Tmp.Naturaleza = Con_Acreedora  THEN
						  Sal.SaldoFinal
					 ELSE
						  Entero_Cero
			END) AS SaldoInicialAcreedor
	FROM    TMPCONTABLE Tmp
	INNER JOIN SALDOSCONTABLES Sal ON (Tmp.CuentaContable = Sal.CuentaCompleta
								   AND Sal.EjercicioID = Par_Ejercicio
								   AND Sal.PeriodoID = Par_Periodo
								   AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal)
	WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
	GROUP BY Sal.CuentaCompleta ;

	-- Actualizo los saldos Iniciales de la cuenta
	UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
		Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
		Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
	WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
	  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
	  AND Tmp.CuentaContable = Sal.CuentaContable;

	DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;

	-- Sumo los saldos de la Cuenta
	SET Var_SaldoCuenta := (
		SELECT SUM( CASE WHEN Var_TipoNaturaCta = Con_Deudora
					THEN
						ROUND(  IFNULL(Pol.SaldoInicialDeu, Entero_Cero) -
								IFNULL(Pol.SaldoInicialAcr, Entero_Cero) +
								IFNULL(Pol.SaldoDeudor, Entero_Cero) -
								IFNULL(Pol.SaldoAcreedor, Entero_Cero), 2)
					ELSE
						ROUND(  IFNULL(Pol.SaldoInicialAcr, Entero_Cero) -
								IFNULL(Pol.SaldoInicialDeu, Entero_Cero) +
								IFNULL(Pol.SaldoAcreedor, Entero_Cero) -
								IFNULL(Pol.SaldoDeudor, Entero_Cero), 2)
					END )
		FROM TMPCONTABLE Pol
		WHERE Pol.NumeroTransaccion = Aud_NumTransaccion );

	SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Entero_Cero);
	SET Var_Sentencia := REPLACE(Var_Sentencia, Par_Formula, CONVERT(Var_SaldoCuenta, CHAR));

	-- Armo el select de Salida
	SET Var_Sentencia := CONCAT("SELECT ", Var_Sentencia, " INTO @SaldoCuenta", + ";");

	SET @Sentencia  := (Var_Sentencia);
	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP;
	DEALLOCATE PREPARE STSALDOSCAPITALREP;

	-- Asigno el monto de la Ejecucion
	SET Par_AcumuladoCta := @SaldoCuenta;

	-- Elimino la tabla pivote
	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Aud_NumTransaccion;

END$$