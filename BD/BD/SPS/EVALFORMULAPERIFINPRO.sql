-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALFORMULAPERIFINPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALFORMULAPERIFINPRO`;
DELIMITER $$

CREATE PROCEDURE `EVALFORMULAPERIFINPRO`(
	-- Store Procedure: PARA CALCULAR UN SALDO FINAL DE VARIAS CUENTAS CONTABLES QUE SON SUMADAS Y/O RESTADAS ENTRE SI
	-- Modulo: Contabilidad Financiera

OUT	Par_SaldoFinal		DECIMAL(18,2),	-- Acumulado de Calculo de Cuenta
	Par_Formula         VARCHAR(500),	-- Formula contable a Calcular
	Par_Ubicacion       CHAR(1),		-- Ubicacion del Saldo: A.- Actual H.- Historico
	Par_TipoCalculo     CHAR(1),		-- Tipo de Calculo
	Par_FechaCorte      DATE			-- Corte por Fecha
)
TerminaStore:BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_SaldoFinal	    DECIMAL(18,2);	-- Saldo Final de la Cuenta
	DECLARE Var_SaldoCuenta		DECIMAL(18,2);	-- Saldo de Cuenta
	DECLARE Var_Sentencia		VARCHAR(500);	-- Sentencia de Ejecucion
	DECLARE Var_CtaSegmento 	VARCHAR(500);	-- Segmento de Cuenta
	DECLARE Var_Contador		INT(10);		-- Contador de Formula

	DECLARE Var_NumTransaccion	BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_IdxSignoMas 	INT(11);		-- Indice de Signo Mas
	DECLARE Var_IdxSignoMenos   INT(11);		-- Indice de Signo Menos
	DECLARE Var_FechaCorte		DATE;			-- Fecha de Corte
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Sistema

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero			INT(10);		-- Constante Entero Cero
	DECLARE Decimal_Cero		DECIMAL(2,2);	-- Constante Decimal Cero
	DECLARE Cadena_Vacia		VARCHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Signo_Mas			CHAR(1);		-- Constante Signo Mas

	DECLARE Signo_Menos			CHAR(1);		-- Constante Signo Menos
	DECLARE Con_Periodo    		CHAR(1);		-- Constante Fecha
	DECLARE Con_Fecha      		CHAR(1);		-- Constante Periodo
	DECLARE Ubi_Actual   		CHAR(1);		-- Constante Ubicacion Actual
	DECLARE Ubi_Historico		CHAR(1);		-- Constante Ubicacion Historica

	DECLARE Con_Deudora			CHAR(1);		-- Constante Naturaleza Deudora
	DECLARE Con_Acreedora		CHAR(1);		-- Constante Naturaleza Acreedora
	DECLARE Var_LongCuentas 	INT;			-- Longitud de la Cuenta
	DECLARE Var_CtaBusqueda 	VARCHAR(50);	-- Variable Auxiliar de Cuenta Contable
	DECLARE Var_TipoNaturaCta 	CHAR(1);		-- Tipo de La naturaleza de la cuenta Contable

	DECLARE Entero_Uno			INT(11);		-- Constante entero Uno
	DECLARE Con_Porcentaje		CHAR(1);		-- Constante Porcentaje
	DECLARE Cadena_Cero			CHAR(1);		-- Constante Cadena Cero

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Signo_Mas			:= '+';

	SET Signo_Menos			:= '-';
	SET Con_Periodo    		:= 'P';
	SET Con_Fecha       	:= 'F';
	SET Ubi_Actual      	:= 'A';
	SET Ubi_Historico	    := 'H';

	SET Con_Deudora      	:= 'D';
	SET Con_Acreedora		:= 'A';
	SET Entero_Uno			:= 1;
	SET Con_Porcentaje		:= '%';
	SET Cadena_Cero			:= '0';

	SET Var_Sentencia 		:= Par_Formula;
	SET Var_Contador        := Entero_Cero;
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

	CALL TRANSACCIONESPRO(Var_NumTransaccion);

	SELECT LENGTH(CuentaCompleta)
	INTO Var_LongCuentas
	FROM CUENTASCONTABLES LIMIT 1;

	IF(LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) THEN

		WHILE ((LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) AND Var_Contador <= 200) DO

			SET Var_SaldoCuenta := Entero_Cero;

			SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Par_Formula);
			SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Par_Formula);

			IF(Var_IdxSignoMas != Entero_Cero) THEN
				IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
					SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Signo_Mas, Entero_Uno);
				ELSE
					SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Signo_Menos, Entero_Uno);
				END IF;
			ELSE
				SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Signo_Menos, Entero_Uno);
			END IF;

			SET Var_CtaSegmento := LTRIM(RTRIM(Var_CtaSegmento));
			SET Var_CtaBusqueda := RPAD(REPLACE(Var_CtaSegmento,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);
			SELECT Naturaleza INTO Var_TipoNaturaCta
			FROM CUENTASCONTABLES
			WHERE CuentaCompleta = Var_CtaBusqueda;

			IF (Par_Ubicacion = Ubi_Actual) THEN

				INSERT INTO TMPCONTABLE(
					NumeroTransaccion,	Fecha,	CuentaContable,	CentroCosto,	Naturaleza,
					Cargos,				Abonos,	SaldoDeudor,	SaldoAcreedor)
				SELECT 	Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
						ROUND(SUM(IFNULL(Pol.Cargos, Decimal_Cero)), 2),
						ROUND(SUM(IFNULL(Pol.Abonos, Decimal_Cero)), 2),
						CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
								ROUND(SUM(IFNULL(Pol.Cargos, Decimal_Cero) -
										  IFNULL(Pol.Abonos, Decimal_Cero)), 2)
							 ELSE
								Decimal_Cero
						END,
						CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
								ROUND(SUM(IFNULL(Pol.Abonos, Decimal_Cero) -
										  IFNULL(Pol.Cargos, Decimal_Cero)), 2)
							 ELSE
								Decimal_Cero
						END
				FROM CUENTASCONTABLES Cue
				LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON (Par_TipoCalculo = Con_Fecha
														AND Pol.Fecha <= Par_FechaCorte
														AND Pol.CuentaCompleta = Cue.CuentaCompleta)
				WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
				GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

				IF( Par_FechaCorte = Var_FechaSistema ) THEN

					DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Var_NumTransaccion;

					INSERT INTO TMPBALPOLCENCOSDIA (
							NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
					SELECT	Var_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
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
													AND Pol.CuentaCompleta = Cue.CuentaCompleta)
					WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
					GROUP BY Pol.CuentaCompleta, Cue.Naturaleza;

					UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
						Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
						Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
					WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
					  AND Tmp.NumeroTransaccion = Aux.NumTransaccion
					  AND Tmp.CuentaContable = Aux.CuentaCompleta;

					DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Var_NumTransaccion;

				END IF;

				SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM SALDOCONTACIERREJER WHERE FechaCorte < Par_FechaCorte);

				IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN
					DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;
					INSERT INTO TMPSALDOCONTABLE
					SELECT	Var_NumTransaccion,	Sal.CuentaCompleta,
							SUM(CASE WHEN Tmp.Naturaleza = Con_Deudora THEN
										  Sal.SaldoFinal
									 ELSE
										  Entero_Cero
								END) AS SaldoInicialDeudor,
							SUM(CASE WHEN Tmp.Naturaleza = Con_Acreedora THEN
										  Sal.SaldoFinal
									 ELSE
										  Entero_Cero
								END) AS SaldoInicialAcreedor
					FROM	TMPCONTABLE Tmp
					INNER JOIN SALDOCONTACIERREJER Sal ON (Sal.FechaCorte = Var_FechaCorte
													   AND Sal.CuentaCompleta = Tmp.CuentaContable)
					WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
					GROUP BY Sal.CuentaCompleta ;

					UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
						Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
						Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
					WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
					  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
					  AND Tmp.CuentaContable = Sal.CuentaContable;

				END IF;

			ELSE

				INSERT INTO TMPCONTABLE(
						NumeroTransaccion,	Fecha,			CuentaContable,	CentroCosto,	Naturaleza,
						SaldoDeudor,		SaldoAcreedor)
				SELECT	Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
						CASE WHEN Cue.Naturaleza = Con_Deudora
								THEN
									ROUND(SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero)), 2)
								ELSE
									Decimal_Cero
						END,
						CASE WHEN Cue.Naturaleza = Con_Acreedora
								THEN
									ROUND(SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero)), 2)
								ELSE
									Decimal_Cero
						END
				FROM CUENTASCONTABLES Cue
				INNER JOIN SALDOCONTACIERREJER Sal ON (Par_TipoCalculo = Con_Fecha
												   AND Sal.FechaCorte = Par_FechaCorte
												   AND Cue.CuentaCompleta = Sal.CuentaCompleta)
				WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
				GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

			END IF;

			SET Var_SaldoCuenta := (
				SELECT SUM( CASE WHEN Var_TipoNaturaCta = Con_Deudora
									THEN
										ROUND(	IFNULL(Pol.SaldoInicialDeu, Decimal_Cero) -
												IFNULL(Pol.SaldoInicialAcr, Decimal_Cero) +
												IFNULL(Pol.SaldoDeudor, Decimal_Cero) -
												IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2)
									ELSE
										ROUND(	IFNULL(Pol.SaldoInicialAcr, Decimal_Cero) -
												IFNULL(Pol.SaldoInicialDeu, Decimal_Cero) +
												IFNULL(Pol.SaldoAcreedor, Decimal_Cero) -
												IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2)
							END )
				FROM TMPCONTABLE Pol
				WHERE Pol.NumeroTransaccion = Var_NumTransaccion );

			SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Decimal_Cero);
			SET Var_Sentencia := REPLACE(Var_Sentencia, Var_CtaSegmento, CONVERT(Var_SaldoCuenta, CHAR));
			SET Par_Formula   := REPLACE(Par_Formula, Var_CtaSegmento, Cadena_Vacia);

			IF(Var_IdxSignoMas != Entero_Cero) THEN
				IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
					SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Mas, Par_Formula) + Entero_Uno);
				ELSE
					SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + Entero_Uno);
				END IF;
			ELSE
				SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + Entero_Uno);
			END IF;

			DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;

			SET Var_Contador := Var_Contador + Entero_Uno;
		END WHILE;
	END IF;

	SET Par_Formula := LTRIM(RTRIM(Par_Formula));
	SET Var_CtaBusqueda	:= RPAD(REPLACE(Par_Formula,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);
	SELECT Naturaleza INTO Var_TipoNaturaCta
	FROM CUENTASCONTABLES
	WHERE CuentaCompleta = Var_CtaBusqueda;

	IF (Par_Ubicacion = Ubi_Actual) THEN

		INSERT INTO TMPCONTABLE(
			NumeroTransaccion,	Fecha,	CuentaContable,	CentroCosto,	Naturaleza,
			Cargos,				Abonos,	SaldoDeudor,	SaldoAcreedor)
		SELECT 	Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
				ROUND(SUM(IFNULL(Pol.Cargos, Decimal_Cero)), 2),
				ROUND(SUM(IFNULL(Pol.Abonos, Decimal_Cero)), 2),
				CASE WHEN Cue.Naturaleza = Con_Deudora  THEN
						ROUND(SUM(IFNULL(Pol.Cargos, Decimal_Cero) -
								  IFNULL(Pol.Abonos, Decimal_Cero)), 2)
					 ELSE
						Decimal_Cero
				END,
				CASE WHEN Cue.Naturaleza = Con_Acreedora  THEN
						ROUND(SUM(IFNULL(Pol.Abonos, Decimal_Cero) -
								  IFNULL(Pol.Cargos, Decimal_Cero)), 2)
					 ELSE
						Decimal_Cero
				END
		FROM CUENTASCONTABLES Cue
		LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON (Par_TipoCalculo = Con_Fecha
												AND Pol.Fecha <= Par_FechaCorte
												AND Pol.CuentaCompleta = Cue.CuentaCompleta)
		WHERE Cue.CuentaCompleta LIKE Par_Formula
		GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

		IF( Par_FechaCorte = Var_FechaSistema ) THEN

			DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Var_NumTransaccion;

			INSERT INTO TMPBALPOLCENCOSDIA (
					NumTransaccion, CuentaCompleta, CentroCostoID, Cargos, Abonos)
			SELECT	Var_NumTransaccion, Pol.CuentaCompleta, Entero_Cero,
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
											AND Pol.CuentaCompleta = Cue.CuentaCompleta)
			WHERE Cue.CuentaCompleta LIKE Par_Formula
			GROUP BY Pol.CuentaCompleta, Cue.Naturaleza;

			UPDATE TMPCONTABLE Tmp, TMPBALPOLCENCOSDIA Aux SET
				Tmp.SaldoDeudor = Tmp.SaldoDeudor + Aux.Cargos,
				Tmp.SaldoAcreedor = Tmp.SaldoAcreedor + Aux.Abonos
			WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
			  AND Tmp.NumeroTransaccion = Aux.NumTransaccion
			  AND Tmp.CuentaContable = Aux.CuentaCompleta;

			DELETE FROM TMPBALPOLCENCOSDIA WHERE NumTransaccion = Var_NumTransaccion;

		END IF;

		SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOCONTACIERREJER WHERE FechaCorte < Par_FechaCorte);

		IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;
			INSERT INTO TMPSALDOCONTABLE
			SELECT	Var_NumTransaccion,	Sal.CuentaCompleta,
					SUM(CASE WHEN Tmp.Naturaleza = Con_Deudora THEN
								  Sal.SaldoFinal
							 ELSE
								  Entero_Cero
						END) AS SaldoInicialDeudor,
					SUM(CASE WHEN Tmp.Naturaleza = Con_Acreedora THEN
								  Sal.SaldoFinal
							 ELSE
								  Entero_Cero
						END) AS SaldoInicialAcreedor
			FROM	TMPCONTABLE Tmp
			INNER JOIN SALDOCONTACIERREJER Sal ON (Sal.FechaCorte = Var_FechaCorte
											   AND Sal.CuentaCompleta = Tmp.CuentaContable)
			WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
			GROUP BY Sal.CuentaCompleta ;

			UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
				Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
				Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
			WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
			  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
			  AND Tmp.CuentaContable = Sal.CuentaContable;

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;

		END IF;
	ELSE

		INSERT INTO TMPCONTABLE(
				NumeroTransaccion,	Fecha,			CuentaContable,	CentroCosto,	Naturaleza,
				SaldoDeudor,		SaldoAcreedor)
		SELECT	Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
				CASE WHEN Cue.Naturaleza = Con_Deudora
						THEN
							ROUND(SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero)), 2)
						ELSE
							Decimal_Cero
				END,
				CASE WHEN Cue.Naturaleza = Con_Acreedora
						THEN
							ROUND(SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero)), 2)
						ELSE
							Decimal_Cero
				END
		FROM CUENTASCONTABLES Cue
		INNER JOIN SALDOCONTACIERREJER Sal ON (Par_TipoCalculo = Con_Fecha
										   AND Sal.FechaCorte	 = Par_FechaCorte
										   AND Cue.CuentaCompleta = Sal.CuentaCompleta)
		WHERE Cue.CuentaCompleta LIKE Par_Formula
		GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

	END IF;

	SET Var_SaldoCuenta := (
		SELECT SUM( CASE WHEN Var_TipoNaturaCta = Con_Deudora
							THEN
								ROUND(	IFNULL(Pol.SaldoInicialDeu, Decimal_Cero) -
										IFNULL(Pol.SaldoInicialAcr, Decimal_Cero) +
										IFNULL(Pol.SaldoDeudor, Decimal_Cero) -
										IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2)
							ELSE
								ROUND(	IFNULL(Pol.SaldoInicialAcr, Decimal_Cero) -
										IFNULL(Pol.SaldoInicialDeu, Decimal_Cero) +
										IFNULL(Pol.SaldoAcreedor, Decimal_Cero) -
										IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2)
					END )
		FROM TMPCONTABLE Pol
		WHERE Pol.NumeroTransaccion = Var_NumTransaccion );

	SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Entero_Cero);
	SET Var_Sentencia 	:= REPLACE(Var_Sentencia, Par_Formula, CONVERT(Var_SaldoCuenta, CHAR));
	SET Var_Sentencia   := CONCAT("SELECT ", Var_Sentencia, " INTO @SaldoCuenta", + ";");

	SET @Sentencia	:= (Var_Sentencia);
	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP;
	DEALLOCATE PREPARE STSALDOSCAPITALREP;

	SET Par_SaldoFinal := IFNULL(@SaldoCuenta, Decimal_Cero);
	DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
END TerminaStore$$