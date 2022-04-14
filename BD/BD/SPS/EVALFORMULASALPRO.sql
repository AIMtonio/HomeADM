-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALFORMULASALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EVALFORMULASALPRO`;DELIMITER $$

CREATE PROCEDURE `EVALFORMULASALPRO`(
# PARA REGULATORIOS: SP PARA CALCULAR UN SALDO FINAL DE VARIAS CUENTAS CONTABLES QUE SON SUMADAS Y/O RESTADAS ENTRE SI

OUT	Par_SaldoFinal		DECIMAL(14,2),	# Dara el Saldo final calculado
OUT	Par_SaldoInicial	DECIMAL(14,2),	# Dara el Saldo inicial calculado
OUT	Par_Cargos			DECIMAL(14,2),	# Dara los Cargos
OUT	Par_Abonos			DECIMAL(14,2),	# Dara los Abonos
    Par_Formula         VARCHAR(500),	# Formula de la operacion con cuentas contables
    Par_Ubicacion       CHAR(1),        # A = DETALLEPOLIZA, H = SALDOSCONTABLES
    Par_TipoCalculo     CHAR(1),      	# F = a una fecha, P = a un periodo contable
    Par_FechaCorte      DATE,          # Fecha de corte del periodo contable o Fecha Fin de consulta
	Par_CCInicial		INT,
	Par_CCFinal			INT
	)
BEGIN

# Declaracion de variables
DECLARE Var_SaldoFinal	    DECIMAL(18,2);	# Valor del saldo final calculado.
DECLARE Var_SaldoCuenta		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_SaldoInicial		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_SaldoIniAcr		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_SaldoIniDeu		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_SaldoCargos		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_SaldoAbonos		DECIMAL(18,2);	# Saldo para cada cuenta
DECLARE Var_Sentencia		VARCHAR(900);	# Sentencia de la formula
DECLARE Var_SentenciaD		VARCHAR(900);	# Sentencia de la formula
DECLARE Var_SentenciaC		VARCHAR(900);	# Sentencia de la formula
DECLARE Var_SentenciaA		VARCHAR(900);	# Sentencia de la formula
DECLARE Var_CtaSegmento 	VARCHAR(900);	# Semento de la formula
DECLARE Var_Formula 		VARCHAR(900);	# Semento de la formula
DECLARE Var_Contador		INT(10);		# Contador para ciclo WHILE
DECLARE Var_NumTransaccion	BIGINT;			# Numero de transaccion
DECLARE Var_IdxSignoMas 	INT;			# Indice de la formula donde encuentra el signo +
DECLARE Var_IdxSignoMenos   INT;			# Indice de la formula donde encuentra el signo -
DECLARE Var_FechaCorte		DATE;			# Fecha de corte de cierre contable
DECLARE Var_MinCenCos		INT;			# Centro de costos minimo
DECLARE Var_MaxCenCos		INT;			# Centro de costos maximo
DECLARE Var_LongCuentas 	INT;			-- Longitud de la Cuenta
DECLARE Var_CtaBusqueda 	VARCHAR(50);	-- Variable Auxiliar de Cuenta Contable
DECLARE Var_TipoNaturaCta 	CHAR(1);		-- Tipo de La naturaleza de la cuenta Contable

# Declaracion de constantes
DECLARE Entero_Cero			INT(10);		# Constante entero cero
DECLARE Decimal_Cero		DECIMAL(2,2);	# Constante DECIMAL cero
DECLARE Cadena_Vacia		VARCHAR(1);		# Constante cadena vacia
DECLARE Fecha_Vacia			DATE;			# Constante para fecha vacia
DECLARE Signo_Mas			CHAR(1);		# Signo +
DECLARE Signo_Menos			CHAR(1);		# Signo -
DECLARE Con_Periodo    		CHAR(1);		# Consulta por periodo
DECLARE Con_Fecha      		CHAR(1);		# Consulta por fecha
DECLARE Ubi_Actual   		CHAR(1);		# Buscara en DETALLEPOLIZA
DECLARE Ubi_Historico		CHAR(1);		# Buscara en HIS-DETALLEPOL
DECLARE VarDeudora			CHAR(1);		# Naturaleza deudora
DECLARE VarAcreedora		CHAR(1);		# Naturaleza acreedora
DECLARE Est_Cerrado		CHAR(1);		# Naturaleza acreedora
DECLARE Var_UltPeriodoCie   INT;
DECLARE Var_UltEjercicioCie INT;


# Asignacion de constantes
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
SET VarDeudora      	:= 'D';
SET VarAcreedora   		:= 'A';
SET Est_Cerrado   		:= 'C';
SET Var_Formula   		:= Par_Formula;


# Asignacion de variables
SET Var_Sentencia 		:= Par_Formula;
SET Var_SentenciaD 		:= Par_Formula;
SET Var_SentenciaC 		:= Par_Formula;
SET Var_SentenciaA 		:= Par_Formula;
SET Var_Contador        := Entero_Cero;
CALL TRANSACCIONESPRO(Var_NumTransaccion);


DROP TABLE IF EXISTS TMPCONTABLEBORRAR;
CREATE TEMPORARY TABLE `TMPCONTABLEBORRAR` (
  `NumeroTransaccion` BIGINT(20) NOT NULL COMMENT 'Numero \n    Transaccion',
  `Fecha` DATE NOT NULL COMMENT 'Fecha',
  `CuentaContable` CHAR(25) NOT NULL COMMENT 'Cuenta Contable',
  `CentroCosto` VARCHAR(4) NOT NULL,
  `Cargos` DECIMAL(16,4) DEFAULT NULL,
  `Abonos` DECIMAL(16,4) DEFAULT NULL,
  `Naturaleza` CHAR(1) DEFAULT NULL COMMENT 'Naturaleza de la\nCuenta\nA .-  Acreedora\nD .-  Deudora',
  `SaldoDeudor` DECIMAL(16,4) DEFAULT NULL COMMENT 'Saldo Deudor de la Cuenta Contable.',
  `SaldoAcreedor` DECIMAL(16,4) DEFAULT NULL COMMENT 'Saldo Acreedor de la Cuenta Contable.',
  `SaldoInicialDeu` DECIMAL(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Deudor',
  `SaldoInicialAcr` DECIMAL(16,4) DEFAULT NULL COMMENT 'Saldo Inicial Acreedor'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para Procesos de Contabilidad';


SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
	FROM CENTROCOSTOS;
IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
	SET Par_CCInicial	:= Var_MinCenCos;
	SET	Par_CCFinal		:= Var_MaxCenCos;
END IF;

SELECT LENGTH(CuentaCompleta)
INTO Var_LongCuentas
FROM CUENTASCONTABLES LIMIT 1;

# Verifico si la formula implica una operacion entre cuentas contables
IF(LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) THEN
	WHILE ((LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) AND Var_Contador <= 200) DO
		SET Var_SaldoCuenta := Entero_Cero;

		SET Var_IdxSignoMas     = LOCATE(Signo_Mas, Par_Formula);
		SET Var_IdxSignoMenos   = LOCATE(Signo_Menos, Par_Formula);

		IF(Var_IdxSignoMas != Entero_Cero) THEN
			IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
				SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, Signo_Mas, 1);
			ELSE
				SET Var_CtaSegmento:= SUBSTRING_INDEX(Par_Formula, Signo_Menos, 1);
			END IF;
		ELSE
			SET Var_CtaSegmento:= SUBSTRING_INDEX(Par_Formula, Signo_Menos, 1);
		END IF;

		SET Var_CtaSegmento := LTRIM(RTRIM(Var_CtaSegmento));
		SET Var_CtaBusqueda := RPAD(REPLACE(Var_CtaSegmento,'%',''),Var_LongCuentas,'0');
		SELECT Naturaleza INTO Var_TipoNaturaCta
			FROM CUENTASCONTABLES
			WHERE CuentaCompleta = Var_CtaBusqueda;


		# ========== POBLAR LA TABLA TEMPORAL CON LAS CUENTAS Y SUS SALDOS ========
		IF (Par_Ubicacion = Ubi_Actual) THEN
			# Se obtienen los moviemientos realizados hasta la fecha de consulta existentes en DETALLEPOLIZA
			INSERT INTO TMPCONTABLE(
				NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
				Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
			SELECT
				Var_NumTransaccion, 		Par_FechaCorte,	 	Cue.CuentaCompleta,		Entero_Cero,		Cue.Naturaleza,
				SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)),	SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)),
				CASE WHEN Cue.Naturaleza = VarDeudora  THEN
						SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2))
					 ELSE	Decimal_Cero
				END,
				CASE WHEN Cue.Naturaleza =  VarAcreedora THEN
						SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2))
					 ELSE	Decimal_Cero
				END
			FROM CUENTASCONTABLES Cue
				  LEFT OUTER JOIN DETALLEPOLIZA   Pol ON ( Pol.CuentaCompleta = Cue.CuentaCompleta
															AND	Pol.CuentaCompleta LIKE Var_CtaSegmento
															AND Pol.Fecha <= Par_FechaCorte
                                                            AND Pol.CentroCostoID >= Par_CCInicial
															AND Pol.CentroCostoID <= Par_CCFinal)
				WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;

			# Calculo la ultima fecha del cierre contable menor o igual a la fecha de la cual se requiere el reporte
			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte < Par_FechaCorte);

			IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN
				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;
				INSERT INTO TMPSALDOCONTABLE
				SELECT	Var_NumTransaccion,	Sal.CuentaCompleta,
						SUM(CASE WHEN Tmp.Naturaleza = VarDeudora	THEN Sal.SaldoFinal ELSE Entero_Cero END) AS SaldoInicialDeudor,
						SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora	THEN Sal.SaldoFinal	ELSE
												Entero_Cero
										END) AS SaldoInicialAcreedor

					FROM	TMPCONTABLE Tmp,
							SALDOSCONTABLES Sal
					WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
					  AND Sal.FechaCorte		= Var_FechaCorte
					  AND Sal.CuentaCompleta	= Tmp.CuentaContable
					  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
					GROUP BY Sal.CuentaCompleta ;

					UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
						Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
						Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
					WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
					  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
					  AND Sal.CuentaContable    = Tmp.CuentaContable;


			END IF; -- IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN


		# IF (Par_Ubicacion = Ubi_Historico) THEN
		ELSE
			INSERT INTO TMPCONTABLE(
				NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
				SaldoDeudor,				SaldoAcreedor, 		Cargos,					Abonos,				SaldoInicialDeu,
                SaldoInicialAcr)
			SELECT
				Var_NumTransaccion, 		Par_FechaCorte,	 	Cue.CuentaCompleta,		Entero_Cero,		Cue.Naturaleza,
				CASE WHEN Cue.Naturaleza= VarDeudora		THEN	SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2)) ELSE	Decimal_Cero	END,
				CASE WHEN Cue.Naturaleza = VarAcreedora	THEN	SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2)) ELSE	Decimal_Cero	END			,
				SUM(Cargos),				SUM(Abonos),
				CASE WHEN Cue.Naturaleza = VarDeudora  THEN SUM(ROUND(IFNULL(Sal.SaldoInicial, Decimal_Cero), 2)) ELSE Decimal_Cero END			,
				CASE WHEN Cue.Naturaleza = VarAcreedora  THEN SUM(ROUND(IFNULL(Sal.SaldoInicial, Decimal_Cero), 2)) ELSE Decimal_Cero END
			FROM CUENTASCONTABLES Cue,
				  SALDOSCONTABLES   Sal
				WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
					AND Sal.FechaCorte	 = Par_FechaCorte
					AND Cue.CuentaCompleta LIKE Var_CtaSegmento
					AND Par_TipoCalculo = Con_Fecha
                    AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
			GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;
		END IF; --  (Par_Ubicacion = Ubi_Historico) THEN

		SET Var_SaldoCuenta := (SELECT SUM( CASE WHEN Var_TipoNaturaCta = VarDeudora THEN
																ROUND(IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2) -
																ROUND(IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2)
															ELSE
																ROUND(IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2) -
																ROUND(IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2)
													END )
											FROM TMPCONTABLE Pol
											WHERE Pol.NumeroTransaccion = Var_NumTransaccion );

		SET Var_SaldoCuenta	:= IFNULL(Var_SaldoCuenta, Decimal_Cero);
		SET Var_Sentencia	:= REPLACE(Var_Sentencia,	Var_CtaSegmento, CONVERT(Var_SaldoCuenta, CHAR));
		SET Par_Formula := REPLACE(Par_Formula, Var_CtaSegmento, Cadena_Vacia);



		IF(Var_IdxSignoMas != Entero_Cero) THEN
				IF((Var_IdxSignoMenos != Entero_Cero AND Var_IdxSignoMas < Var_IdxSignoMenos) OR Var_IdxSignoMenos = Entero_Cero ) THEN
						SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Mas, Par_Formula) + 1);
				ELSE
						SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + 1);
				END IF;
		ELSE
				SET Par_Formula := SUBSTRING(Par_Formula, LOCATE(Signo_Menos, Par_Formula) + 1);
		END IF;

		INSERT INTO TMPCONTABLEBORRAR
			SELECT * FROM TMPCONTABLE;

		# Se eliminan los datos temporales de paso
		DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
		DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;


		SET Var_Contador := Var_Contador + 1;
	END WHILE;
END IF; -- IF(LOCATE(Signo_Mas, Par_Formula) > Entero_Cero OR LOCATE(Signo_Menos, Par_Formula) > Entero_Cero) THEN




SET Par_Formula := LTRIM(RTRIM(Par_Formula));
SET Var_CtaBusqueda	:= RPAD(REPLACE(Par_Formula,'%',''),Var_LongCuentas,'0');
SELECT Naturaleza INTO Var_TipoNaturaCta
	FROM CUENTASCONTABLES
	WHERE CuentaCompleta = Var_CtaBusqueda;

# ========== POBLAR LA TABLA TEMPORAL CON LA ULTIMA O UNICA CUENTA CONTABLE DE LA FORMULA========
IF (Par_Ubicacion = Ubi_Actual) THEN
	# Se obtienen los moviemientos realizados hasta la fecha de consulta existentes en DETALLEPOLIZA
	INSERT INTO TMPCONTABLE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
							Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
	SELECT 				 	Var_NumTransaccion, 		Par_FechaCorte,	 	Cue.CuentaCompleta,		Entero_Cero,		Cue.Naturaleza,
							SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)),
							SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)),
							CASE WHEN Cue.Naturaleza = VarDeudora  THEN
									SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2))
								 ELSE	Decimal_Cero
							END,
							CASE WHEN Cue.Naturaleza =  VarAcreedora THEN
									SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2))
								 ELSE	Decimal_Cero
							END
	FROM CUENTASCONTABLES Cue
		  LEFT OUTER JOIN DETALLEPOLIZA   Pol ON (Pol.CuentaCompleta = Cue.CuentaCompleta
													AND Pol.CuentaCompleta LIKE Par_Formula
													AND Pol.Fecha <= Par_FechaCorte
                                                    AND Pol.CentroCostoID >= Par_CCInicial
													AND Pol.CentroCostoID <= Par_CCFinal)
		WHERE Cue.CuentaCompleta LIKE Par_Formula
	GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;


	# Calculo la ultima fecha del cierre contable menor o igual a la fecha de la cual se requiere el reporte
	SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte < Par_FechaCorte);

	IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;
			INSERT INTO TMPSALDOCONTABLE
			SELECT	Var_NumTransaccion,	Sal.CuentaCompleta, SUM(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
											Sal.SaldoFinal
										ELSE
											Entero_Cero
									END) AS SaldoInicialDeudor,
					SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
											Sal.SaldoFinal
										ELSE
											Entero_Cero
									END) AS SaldoInicialAcreedor

				FROM	TMPCONTABLE Tmp,
						SALDOSCONTABLES Sal
				WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
				  AND Sal.FechaCorte		= Var_FechaCorte
				  AND Sal.CuentaCompleta	= Tmp.CuentaContable
                  AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
				GROUP BY Sal.CuentaCompleta ;

				UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Var_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable    = Tmp.CuentaContable;

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Var_NumTransaccion;

	END IF; -- IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN


# IF (Par_Ubicacion = Ubi_Historico) THEN
ELSE

	INSERT INTO TMPCONTABLE(
		NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
		SaldoDeudor,				SaldoAcreedor,		Cargos, 				Abonos, 			SaldoInicialDeu,
        SaldoInicialAcr)
	SELECT
		Var_NumTransaccion, 		Par_FechaCorte,	 	Cue.CuentaCompleta,		Entero_Cero,		Cue.Naturaleza,
		CASE WHEN Cue.Naturaleza = VarDeudora  THEN SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2)) ELSE Decimal_Cero END,
		CASE WHEN Cue.Naturaleza = VarAcreedora  THEN SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2)) ELSE Decimal_Cero END	,
		SUM(Cargos), SUM(Abonos),
		CASE WHEN Cue.Naturaleza = VarDeudora  THEN SUM(ROUND(IFNULL(Sal.SaldoInicial, Decimal_Cero), 2)) ELSE Decimal_Cero END,
		CASE WHEN Cue.Naturaleza = VarAcreedora  THEN SUM(ROUND(IFNULL(Sal.SaldoInicial, Decimal_Cero), 2)) ELSE Decimal_Cero END
	FROM CUENTASCONTABLES Cue,
		  SALDOSCONTABLES   Sal
		WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
			AND Sal.FechaCorte	 = Par_FechaCorte
			AND Cue.CuentaCompleta LIKE Par_Formula
			AND Par_TipoCalculo = Con_Fecha
			AND Sal.CentroCosto BETWEEN Par_CCInicial AND Par_CCFinal
	GROUP BY Cue.CuentaCompleta, Cue.Naturaleza;
END IF; --  (Par_Ubicacion = Ubi_

SET Var_SaldoCuenta := (SELECT SUM( CASE WHEN Var_TipoNaturaCta = VarDeudora
											THEN
												ROUND(IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2) -
												ROUND(IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2)
											ELSE
												ROUND(IFNULL(Pol.SaldoAcreedor, Decimal_Cero), 2) -
												ROUND(IFNULL(Pol.SaldoDeudor, Decimal_Cero), 2)
									END )
							FROM TMPCONTABLE Pol
							WHERE Pol.NumeroTransaccion = Var_NumTransaccion );
SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Entero_Cero);

/* SE INSERTA EN UNA TEMPORAL LOS VALORES */
INSERT INTO TMPCONTABLEBORRAR
	SELECT * FROM TMPCONTABLE;


-- ***
SET Var_SaldoIniAcr := (SELECT SUM(IFNULL(Pol.SaldoInicialAcr, Decimal_Cero))
								FROM TMPCONTABLEBORRAR Pol
								WHERE Pol.NumeroTransaccion = Var_NumTransaccion );
SET Var_SaldoIniDeu := (SELECT SUM(IFNULL(Pol.SaldoInicialDeu, Decimal_Cero))
								FROM TMPCONTABLEBORRAR Pol
								WHERE Pol.NumeroTransaccion = Var_NumTransaccion );
SET Var_SaldoIniAcr	:= IFNULL(Var_SaldoIniAcr, Entero_Cero);
SET Var_SaldoIniDeu	:= IFNULL(Var_SaldoIniDeu, Entero_Cero);



SET Var_SaldoCargos := (SELECT SUM(Cargos)
							FROM TMPCONTABLEBORRAR Pol
							WHERE Pol.NumeroTransaccion = Var_NumTransaccion );

SET Var_SaldoAbonos :=   (SELECT SUM(Abonos)
								FROM TMPCONTABLEBORRAR Pol
								WHERE Pol.NumeroTransaccion = Var_NumTransaccion );
-- ***
IF (Par_Ubicacion = Ubi_Actual) THEN

	CALL `EVALFORMULAREGPRO`(
		Var_SaldoCuenta,	Var_Formula,     	Ubi_Actual,			Con_Fecha,          Par_FechaCorte);


    SET Var_Sentencia 	:=  CONVERT(Var_SaldoCuenta, CHAR);
ELSE
	SET Var_Sentencia 	:= REPLACE(Var_Sentencia, Par_Formula, CONVERT(Var_SaldoCuenta, CHAR));
END IF;


SET Var_SaldoInicial	:= IFNULL(Var_SaldoInicial, Entero_Cero);
SET Var_SaldoCargos		:= IFNULL(Var_SaldoCargos, Entero_Cero);
SET Var_SaldoAbonos		:= IFNULL(Var_SaldoAbonos, Entero_Cero);

SET Var_SaldoInicial := Var_SaldoInicial - Var_SaldoAbonos + Var_SaldoCargos;


SET Var_Sentencia   := CONCAT("SELECT ", Var_Sentencia,",",Var_SaldoInicial,",",Var_SaldoCargos ,",",Var_SaldoAbonos,
								" INTO @SaldoCuenta, @Var_SaldoInicial, @VarCargos, @VarAbonos", ";");

IF(IFNULL(Var_Sentencia, Decimal_Cero)<>Decimal_Cero)THEN
	SET @Sentencia	= (Var_Sentencia);
	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP;
	DEALLOCATE PREPARE STSALDOSCAPITALREP;
END IF;
SET Par_SaldoFinal	= IFNULL(@SaldoCuenta, Decimal_Cero);
SET Par_SaldoInicial= IFNULL(@Var_SaldoInicial, Decimal_Cero);
SET Par_Cargos		= IFNULL(@VarCargos, Decimal_Cero);
SET Par_Abonos		= IFNULL(@VarAbonos, Decimal_Cero);


DELETE FROM TMPCONTABLE WHERE NumeroTransaccion = Var_NumTransaccion;
DROP TABLE IF EXISTS TMPCONTABLEBORRAR;

END$$