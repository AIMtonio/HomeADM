-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALFORMULAREGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALFORMULAREGPRO`;
DELIMITER $$

CREATE PROCEDURE `EVALFORMULAREGPRO`(
	-- Store Procedure: PARA CALCULAR UN SALDO FINAL DE VARIAS CUENTAS CONTABLES QUE SON SUMADAS Y/O RESTADAS ENTRE SI
	-- Modulo: Contabilidad Financiera

	OUT	Par_SaldoFinal		DECIMAL(18,2),	-- Dara el Saldo final calculado
	Par_Formula				VARCHAR(500),	-- Formula de la operacion con cuentas contables
	Par_Ubicacion			CHAR(1),		-- A = DETALLEPOLIZA, H = SALDOSCONTABLES
	Par_TipoCalculo			CHAR(1),		-- F = a una fecha, P = a un periodo contable
	Par_FechaCorte			DATE			-- Fecha de corte del periodo contable o Fecha Fin de consulta
)
TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_SaldoFinal	 	DECIMAL(18,2);	# Valor del saldo final calculado.
	DECLARE Var_SaldoCuenta		DECIMAL(18,2);	# Saldo para cada cuenta
	DECLARE Var_Sentencia		VARCHAR(900);	# Sentencia de la formula
	DECLARE Var_CtaSegmento 	VARCHAR(900);	# Semento de la formula
	DECLARE Var_Contador		INT(10);		# Contador para ciclo WHILE

	DECLARE Var_NumTransaccion	BIGINT(20);		# Numero de transaccion
	DECLARE Var_IdxSignoMas 	INT(11);		# Indice de la formula donde encuentra el signo +
	DECLARE Var_IdxSignoMenos 	INT(11);		# Indice de la formula donde encuentra el signo -
	DECLARE Var_FechaCorte		DATE;			# Fecha de corte de cierre contable

	DECLARE Var_LongCuentas 	INT;			-- Longitud de la Cuenta
	DECLARE Var_CtaBusqueda 	VARCHAR(50);	-- Variable Auxiliar de Cuenta Contable
	DECLARE Var_TipoNaturaCta 	CHAR(1);		-- Tipo de La naturaleza de la cuenta Contable
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Sistema

	# Declaracion de constantes
	DECLARE Entero_Cero			INT(10);		# Constante entero cero
	DECLARE Decimal_Cero		DECIMAL(2,2);	# Constante DECIMAL cero
	DECLARE Cadena_Vacia		VARCHAR(1);		# Constante cadena vacia
	DECLARE Fecha_Vacia			DATE;			# Constante para fecha vacia
	DECLARE Signo_Mas			CHAR(1);		# Signo +

	DECLARE Signo_Menos			CHAR(1);		# Signo -
	DECLARE Con_Periodo 		CHAR(1);		# Consulta por periodo
	DECLARE Con_Fecha 			CHAR(1);		# Consulta por fecha
	DECLARE Ubi_Actual 			CHAR(1);		# Buscara en DETALLEPOLIZA
	DECLARE Ubi_Historico		CHAR(1);		# Buscara en HIS-DETALLEPOL

	DECLARE Con_Deudora			CHAR(1);		# Naturaleza deudora
	DECLARE Con_Acreedora		CHAR(1);		# Naturaleza acreedora
	DECLARE Var_Control 		VARCHAR(100); 	# Variable de Control
	DECLARE	Par_NumErr 			INT(11);		# Numero de error
	DECLARE	Par_ErrMen 			VARCHAR(400);	# Mensaje de error

	DECLARE Salida_NO			CHAR(1);		# Salida NO
	DECLARE Par_Salida			CHAR(1);		# Salida
	DECLARE Entero_Uno			INT(10);		# Constante entero Uno

	DECLARE Con_Porcentaje		CHAR(1);		-- Constante Porcentaje
	DECLARE Cadena_Cero			CHAR(1);		-- Constante Cadena Cero

	# Asignacion de constantes
	SET Par_Salida			:= 'S';
	SET	Salida_NO			:= 'N';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';

	SET Fecha_Vacia			:= '1900-01-01';
	SET Signo_Mas			:= '+';
	SET Signo_Menos			:= '-';
	SET Con_Periodo 		:= 'P';
	SET Con_Fecha 			:= 'F';

	SET Ubi_Actual 			:= 'A';
	SET Ubi_Historico	 	:= 'H';
	SET Con_Deudora			:= 'D';
	SET Con_Acreedora 		:= 'A';
	SET Entero_Uno			:= 1;

	SET Con_Porcentaje		:= '%';
	SET Cadena_Cero			:= '0';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-EVALFORMULAREGPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		# Asignacion de variables
		SET Var_Sentencia 	:= Par_Formula;
		SET Var_Contador 	:= Entero_Cero;
		CALL TRANSACCIONESPRO(Var_NumTransaccion);

		SELECT LENGTH(CuentaCompleta)
		INTO Var_LongCuentas
		FROM CUENTASCONTABLES LIMIT 1;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		# Verifico si la formula implica una operacion entre cuentas contables
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
					SET Var_CtaSegmento:= SUBSTRING_INDEX(Par_Formula, Signo_Menos, Entero_Uno);
				END IF;

				SET Var_CtaSegmento := LTRIM(RTRIM(Var_CtaSegmento));
				SET Var_CtaBusqueda := RPAD(REPLACE(Var_CtaSegmento,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);
				SELECT Naturaleza INTO Var_TipoNaturaCta
				FROM CUENTASCONTABLES
				WHERE CuentaCompleta = Var_CtaBusqueda;

				# ========== POBLAR LA TABLA TEMPORAL CON LAS CUENTAS Y SUS SALDOS ========
				IF (Par_Ubicacion = Ubi_Actual) THEN

					# Se obtienen los moviemientos realizados hasta la fecha de consulta existentes en DETALLEPOLIZA
					INSERT INTO TMPCONTABLE(
							NumeroTransaccion,	Fecha,	CuentaContable,	CentroCosto,	Naturaleza,
							Cargos,				Abonos,	SaldoDeudor,	SaldoAcreedor)
					SELECT  Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
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
					LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON ( Par_TipoCalculo = Con_Fecha
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

					# Calculo la ultima fecha del cierre contable menor o igual a la fecha de la cual se requiere el reporte
					SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM SALDOSCONTABLES WHERE FechaCorte < Par_FechaCorte);

					IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN
						DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
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
						INNER JOIN SALDOSCONTABLES Sal ON (Sal.FechaCorte = Var_FechaCorte
													   AND Sal.CuentaCompleta = Tmp.CuentaContable)
						WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
						GROUP BY Sal.CuentaCompleta ;

						UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
							Tmp.SaldoInicialDeu = Sal.SaldoInicialDeu,
							Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
						WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
						  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
						  AND Tmp.CuentaContable = Sal.CuentaContable;

					END IF; -- IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

				# IF (Par_Ubicacion = Ubi_Historico) THEN
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
					INNER JOIN SALDOSCONTABLES Sal ON (Cue.CuentaCompleta = Sal.CuentaCompleta
												   AND Sal.FechaCorte = Par_FechaCorte)
					WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
					  AND Par_TipoCalculo = Con_Fecha
					GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

				END IF; -- (Par_Ubicacion = Ubi_Actual) THEN

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
				SET Par_Formula := REPLACE(Par_Formula, Var_CtaSegmento, Cadena_Vacia);

				IF(Var_IdxSignoMas != Entero_Cero) THEN
					IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
						SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Mas, Par_Formula) + Entero_Uno);
					ELSE
						SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + Entero_Uno);
					END IF;
				ELSE
					SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + Entero_Uno);
				END IF;

				# Se eliminan los datos temporales de paso
				DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;

				SET Var_Contador := Var_Contador + Entero_Uno;
			END WHILE;
		END IF; -- IF(LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) THEN

		SET Par_Formula := LTRIM(RTRIM(Par_Formula));
		SET Var_CtaBusqueda	:= RPAD(REPLACE(Par_Formula,Con_Porcentaje,Cadena_Vacia),Var_LongCuentas,Cadena_Cero);
		SELECT Naturaleza INTO Var_TipoNaturaCta
		FROM CUENTASCONTABLES
		WHERE CuentaCompleta = Var_CtaBusqueda;

		# ========== POBLAR LA TABLA TEMPORAL CON LA ULTIMA O UNICA CUENTA CONTABLE DE LA FORMULA========
		IF (Par_Ubicacion = Ubi_Actual) THEN
			# Se obtienen los moviemientos realizados hasta la fecha de consulta existentes en DETALLEPOLIZA
			INSERT INTO TMPCONTABLE(
					NumeroTransaccion,	Fecha,	CuentaContable,	CentroCosto,	Naturaleza,
					Cargos,				Abonos,	SaldoDeudor,	SaldoAcreedor)
			SELECT  Var_NumTransaccion, Par_FechaCorte, Cue.CuentaCompleta, Entero_Cero, Cue.Naturaleza,
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
			LEFT OUTER JOIN SALDOSDETALLEPOLIZA Pol ON ( Par_TipoCalculo = Con_Fecha
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

			# Calculo la ultima fecha del cierre contable menor o igual a la fecha de la cual se requiere el reporte
			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM SALDOSCONTABLES WHERE FechaCorte < Par_FechaCorte);

			IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
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
				INNER JOIN SALDOSCONTABLES Sal ON (Sal.FechaCorte = Var_FechaCorte
											   AND Sal.CuentaCompleta = Tmp.CuentaContable)
				WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
				GROUP BY Sal.CuentaCompleta ;

				UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu = Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
				 AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				 AND Sal.CuentaContable = Tmp.CuentaContable;

				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;

			END IF; -- IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

		# IF (Par_Ubicacion = Ubi_Historico) THEN
		ELSE
			INSERT INTO TMPCONTABLE(
					NumeroTransaccion,	Fecha,			CuentaContable,	CentroCosto,	Naturaleza,
					SaldoDeudor,		SaldoAcreedor)
			SELECT	Var_NumTransaccion, 		Par_FechaCorte,	 	Cue.CuentaCompleta,		Entero_Cero,		Cue.Naturaleza,
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
			INNER JOIN SALDOSCONTABLES Sal ON (Par_TipoCalculo = Con_Fecha
										   AND Sal.FechaCorte = Par_FechaCorte
										   AND Cue.CuentaCompleta = Sal.CuentaCompleta)
			WHERE Cue.CuentaCompleta LIKE Par_Formula
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

		END IF; -- (Par_Ubicacion = Ubi_Actual) THEN

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

		SET Var_Sentencia := CONCAT("SELECT ", Var_Sentencia, " INTO @SaldoCuenta", + ";");

		SET @Sentencia	:= (Var_Sentencia);
		PREPARE STSALDOSCAPITALREP FROM @Sentencia;
		EXECUTE STSALDOSCAPITALREP;
		DEALLOCATE PREPARE STSALDOSCAPITALREP;

		SET Par_SaldoFinal := IFNULL(@SaldoCuenta, Decimal_Cero);

		DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;

	END ManejoErrores;

	IF (Par_Salida = Salida_NO) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control;
	END IF;


END TerminaStore$$