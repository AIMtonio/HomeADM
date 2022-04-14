
DELIMITER ;
DROP procedure IF EXISTS `EVALFORMULACONTAFINPRO`;

DELIMITER $$
CREATE PROCEDURE `EVALFORMULACONTAFINPRO`(

    Par_Formula         VARCHAR(500),
    Par_Ubicacion       CHAR(1),
    Par_Corte           CHAR(1),
    Par_Fecha           DATE,
    Par_Ejercicio       INT,

    Par_Periodo         INT,
    Var_FecIniPer       DATE,
OUT Par_AcumuladoCta    DECIMAL(14,2),
    Par_CCInicial       INT,
    Par_CCFinal         INT,
    Par_PoblarTabla 	CHAR(1), -- Indica si se debe llenar la tabla para la consulta o si ya se lleno previamente, valores S o N

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

)
BEGIN


DECLARE contador        INT;
DECLARE Var_IdxSignoMas INT;
DECLARE Var_IdxSignoMenos   INT;
DECLARE Var_CtaSegmento VARCHAR(500);
DECLARE Var_Sentencia   VARCHAR(1000);
DECLARE Var_SaldoCuenta DECIMAL(14,2);

DECLARE Var_LongCuentas   INT;      -- Longitud de la Cuenta
DECLARE Var_CtaBusqueda   VARCHAR(50);  -- Variable Auxiliar de Cuenta Contable
DECLARE Var_TipoNaturaCta   CHAR(1);    -- Tipo de La naturaleza de la cuenta Contable

DECLARE Entero_Cero     INT;
DECLARE Ubi_Actual      CHAR(1);
DECLARE Ubi_Histor      CHAR(1);
DECLARE Con_Periodo     CHAR(1);
DECLARE Con_Fecha       CHAR(1);
DECLARE VarDeudora      CHAR(1);
DECLARE VarAcreedora    CHAR(1);




SET Entero_Cero     := 0;
SET Ubi_Actual      := 'A';
SET Ubi_Histor      := 'H';
SET Con_Periodo     := 'P';
SET Con_Fecha       := 'D';
SET VarDeudora      := 'D';
SET VarAcreedora    := 'A';



SET Var_Sentencia := Par_Formula;
SET contador            := Entero_Cero;
SET Par_Ejercicio       := IFNULL(Par_Ejercicio, Entero_Cero);
SET Par_Periodo         := IFNULL(Par_Periodo, Entero_Cero);

DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;


SELECT LENGTH(CuentaCompleta)
INTO Var_LongCuentas
FROM CUENTASCONTABLES LIMIT 1;



IF(LOCATE('+', Par_Formula) > Entero_Cero OR LOCATE('-', Par_Formula) > Entero_Cero) THEN
    WHILE ((LOCATE('+', Par_Formula) > Entero_Cero OR LOCATE('-', Par_Formula) > Entero_Cero)
           AND contador <= 200) DO


        SET Var_SaldoCuenta := Entero_Cero;

        SET Var_IdxSignoMas     = LOCATE('+', Par_Formula);
        SET Var_IdxSignoMenos   = LOCATE('-', Par_Formula);

        IF(Var_IdxSignoMas != 0) THEN
            IF((Var_IdxSignoMenos != 0 AND Var_IdxSignoMas < Var_IdxSignoMenos) OR
                Var_IdxSignoMenos = 0 ) THEN
                SET Var_CtaSegmento := SUBSTRING_INDEX(Par_Formula, '+', 1);
            ELSE
                SET Var_CtaSegmento:= SUBSTRING_INDEX(Par_Formula, '-', 1);
            END IF;
        ELSE
            SET Var_CtaSegmento:= SUBSTRING_INDEX(Par_Formula, '-', 1);
        END IF;

        SET Var_CtaSegmento := ltrim(rtrim(Var_CtaSegmento));
    SET Var_CtaBusqueda := RPAD(REPLACE(Var_CtaSegmento,'%',''),Var_LongCuentas,'0');
    SELECT Naturaleza INTO Var_TipoNaturaCta
       FROM CUENTASCONTABLES
       WHERE CuentaCompleta = Var_CtaBusqueda;


       IF Par_PoblarTabla = 'S' THEN
			DELETE FROM TMPEVALFORMULAPOLIFIN where NumTransaccion = Aud_NumTransaccion;

			IF (Par_Ubicacion = Ubi_Actual) THEN

				INSERT INTO TMPEVALFORMULAPOLIFIN(
						NumTransaccion,		CentroCostoID,		CuentaCompleta,		Cargos,		Abonos,		Ubicacion)
				SELECT 	Aud_NumTransaccion, 	CentroCostoID,		CuentaCompleta,		sum(Cargos),		sum(Abonos),		Par_Ubicacion
				FROM DETALLEPOLIZA
				WHERE Fecha between Var_FecIniPer and Par_Fecha
					AND CuentaCompleta like Var_CtaSegmento
					AND CentroCostoID
					BETWEEN Par_CCInicial AND Par_CCFinal
				group by CuentaCompleta,CentroCostoID;

			ELSE

				INSERT INTO TMPEVALFORMULAPOLIFIN(
						NumTransaccion,		CentroCostoID,		CuentaCompleta,		Cargos,		Abonos,		Ubicacion)
				SELECT 	Aud_NumTransaccion, 	CentroCostoID,		CuentaCompleta,		sum(Cargos),		sum(Abonos),		Par_Ubicacion
				FROM `HIS-DETALLEPOL`
				WHERE Fecha BETWEEN Var_FecIniPer AND Par_Fecha
					AND CuentaCompleta like Var_CtaSegmento
					AND CentroCostoID
					BETWEEN Par_CCInicial AND Par_CCFinal
				group by CuentaCompleta,CentroCostoID;
			END IF;

		END IF; -- fin poblar tabla



        IF (Par_Ubicacion = Ubi_Actual) THEN

            INSERT INTO TMPCONTABLE
                SELECT  Aud_NumTransaccion, Par_Fecha,  Cue.CuentaCompleta, Entero_Cero,
                        Entero_Cero, Entero_Cero,
                        (Cue.Naturaleza),
                        CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
                                                IFNULL(Pol.Abonos, Entero_Cero))    , 2)
                            ELSE   Entero_Cero
                        END,
                        CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
                                                IFNULL(Pol.Cargos, Entero_Cero))    , 2)
                        ELSE    Entero_Cero
                        END,
                       Entero_Cero, Entero_Cero
                    FROM CUENTASCONTABLES Cue
                    LEFT OUTER JOIN TMPEVALFORMULAPOLIFIN Pol ON (Par_Corte = Con_Fecha
                                                            AND Cue.CuentaCompleta = Pol.CuentaCompleta
                                                            AND Pol.NumTransaccion = Aud_NumTransaccion )
                WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
                GROUP BY Cue.CuentaCompleta;

        ELSE
            INSERT INTO TMPCONTABLE
                SELECT  Aud_NumTransaccion, Par_Fecha,  Cue.CuentaCompleta, Entero_Cero,
                        Entero_Cero, Entero_Cero,
                        (Cue.Naturaleza),
                        CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                                ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
                                                IFNULL(Pol.Abonos, Entero_Cero))    , 2)
                            ELSE   Entero_Cero
                        END,
                        CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                                ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
                                                IFNULL(Pol.Cargos, Entero_Cero))    , 2)
                        ELSE    Entero_Cero
                        END,
                       Entero_Cero, Entero_Cero
                FROM CUENTASCONTABLES Cue
                LEFT OUTER JOIN TMPEVALFORMULAPOLIFIN Pol ON ( Par_Corte = Con_Fecha
                                                        AND Cue.CuentaCompleta = Pol.CuentaCompleta
                                                            AND Pol.NumTransaccion = Aud_NumTransaccion )

                WHERE Cue.CuentaCompleta LIKE Var_CtaSegmento
                GROUP BY Cue.CuentaCompleta;

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
              AND Sal.EjercicioID       = Par_Ejercicio
              AND Sal.PeriodoID         = Par_Periodo
              AND Sal.CuentaCompleta    = Tmp.CuentaContable
              AND Sal.CentroCosto >= Par_CCInicial
              AND Sal.CentroCosto <= Par_CCFinal
            GROUP BY Sal.CuentaCompleta ;




        UPDATE TMPCONTABLE Tmp, TMPSALDOCONTABLE Sal SET
            Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
            Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
        WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
          AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
          AND Sal.CuentaContable    = Tmp.CuentaContable;


        SET Var_SaldoCuenta := (
                SELECT SUM( CASE WHEN Var_TipoNaturaCta = VarDeudora
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

        DELETE FROM TMPCONTABLE
            WHERE NumeroTransaccion = Aud_NumTransaccion;

        DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;



        SET Var_SaldoCuenta     := IFNULL(Var_SaldoCuenta, Entero_Cero);

        SET Var_Sentencia := REPLACE(Var_Sentencia, Var_CtaSegmento, CONVERT(Var_SaldoCuenta, CHAR));
        SET Par_Formula := REPLACE(Par_Formula, Var_CtaSegmento, '');

        IF(Var_IdxSignoMas != 0) THEN
            IF((Var_IdxSignoMenos != 0 AND Var_IdxSignoMas < Var_IdxSignoMenos) OR
                Var_IdxSignoMenos = 0 ) THEN
            SET Par_Formula := SUBSTRING(Par_Formula, LOCATE('+', Par_Formula) + 1);
            ELSE
            SET Par_Formula := SUBSTRING(Par_Formula, LOCATE('-', Par_Formula) + 1);
            END IF;
        ELSE
            SET Par_Formula := SUBSTRING(Par_Formula, LOCATE('-', Par_Formula) + 1);
        END IF;

        SET contador := contador + 1;
    END WHILE;

END IF;

DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;

SET Par_Formula := ltrim(rtrim(Par_Formula));
SET Var_CtaBusqueda := RPAD(REPLACE(Par_Formula,'%',''),Var_LongCuentas,'0');
SELECT Naturaleza INTO Var_TipoNaturaCta
  FROM CUENTASCONTABLES
  WHERE CuentaCompleta = Var_CtaBusqueda;


IF Par_PoblarTabla = 'S' THEN
	DELETE FROM TMPEVALFORMULAPOLIFIN where NumTransaccion = Aud_NumTransaccion;

	IF (Par_Ubicacion = Ubi_Actual) THEN

		INSERT INTO TMPEVALFORMULAPOLIFIN(
				NumTransaccion,		CentroCostoID,		CuentaCompleta,		Cargos,		Abonos,		Ubicacion)
		SELECT 	Aud_NumTransaccion, 	CentroCostoID,		CuentaCompleta,		sum(Cargos),		sum(Abonos),		Par_Ubicacion
		FROM DETALLEPOLIZA
		WHERE Fecha  BETWEEN Var_FecIniPer AND Par_Fecha
			AND CuentaCompleta like Par_Formula
			AND CentroCostoID
			BETWEEN Par_CCInicial AND Par_CCFinal
		group by CuentaCompleta,CentroCostoID;

	ELSE

		INSERT INTO TMPEVALFORMULAPOLIFIN(
				NumTransaccion,		CentroCostoID,		CuentaCompleta,		Cargos,		Abonos,		Ubicacion)
		SELECT 	Aud_NumTransaccion, 	CentroCostoID,		CuentaCompleta,		sum(Cargos),		sum(Abonos),		Par_Ubicacion
		FROM `HIS-DETALLEPOL`
		WHERE Fecha BETWEEN Var_FecIniPer AND Par_Fecha
			AND CuentaCompleta like Par_Formula
			AND CentroCostoID
			BETWEEN Par_CCInicial AND Par_CCFinal
		group by CuentaCompleta,CentroCostoID;
	END IF;

END IF; -- fin poblar tabla


IF (Par_Ubicacion = Ubi_Actual) THEN

    INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Par_Fecha,  Cue.CuentaCompleta, Entero_Cero,
                Entero_Cero, Entero_Cero,
                (Cue.Naturaleza),
                CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                        ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
                                        IFNULL(Pol.Abonos, Entero_Cero) ), 2)
                    ELSE   Entero_Cero
                END,
                CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                        ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
                                        IFNULL(Pol.Cargos, Entero_Cero) ), 2)
                ELSE    Entero_Cero
                END,
               Entero_Cero,Entero_Cero
            FROM CUENTASCONTABLES Cue
            LEFT OUTER JOIN TMPEVALFORMULAPOLIFIN Pol ON (Par_Corte = Con_Fecha
                                                    AND Cue.CuentaCompleta = Pol.CuentaCompleta
                                                            AND Pol.NumTransaccion = Aud_NumTransaccion )
        WHERE Cue.CuentaCompleta LIKE Par_Formula
        GROUP BY Cue.CuentaCompleta;



ELSE
    INSERT INTO TMPCONTABLE
        SELECT  Aud_NumTransaccion, Par_Fecha,  Cue.CuentaCompleta, Entero_Cero,
                Entero_Cero, Entero_Cero,
                (Cue.Naturaleza),
                CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
                        ROUND(  SUM(    IFNULL(Pol.Cargos, Entero_Cero)-
                                        IFNULL(Pol.Abonos, Entero_Cero) ), 2)
                    ELSE   Entero_Cero
                END,
                CASE WHEN (Cue.Naturaleza) = VarAcreedora  THEN
                        ROUND(  SUM(    IFNULL(Pol.Abonos, Entero_Cero)-
                                        IFNULL(Pol.Cargos, Entero_Cero) ), 2)
                ELSE    Entero_Cero
                END,
               Entero_Cero,Entero_Cero
        FROM CUENTASCONTABLES Cue
        LEFT OUTER JOIN TMPEVALFORMULAPOLIFIN Pol ON ( Par_Corte = Con_Fecha
                                                AND Cue.CuentaCompleta = Pol.CuentaCompleta
													AND Pol.NumTransaccion = Aud_NumTransaccion )

        WHERE Cue.CuentaCompleta LIKE Par_Formula
        GROUP BY Cue.CuentaCompleta;

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
      AND Sal.EjercicioID       = Par_Ejercicio
      AND Sal.PeriodoID         = Par_Periodo
      AND Sal.CuentaCompleta    = Tmp.CuentaContable
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

SET Var_SaldoCuenta := (
        SELECT SUM( CASE WHEN Var_TipoNaturaCta = VarDeudora
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


SET Var_Sentencia   := CONCAT("SELECT ", Var_Sentencia, " INTO @SaldoCuenta", + ";");
SET @Sentencia  = (Var_Sentencia);
PREPARE STSALDOSCAPITALREP FROM @Sentencia;
EXECUTE STSALDOSCAPITALREP;
DEALLOCATE PREPARE STSALDOSCAPITALREP;

SET Par_AcumuladoCta = @SaldoCuenta;

DELETE FROM TMPCONTABLE
    WHERE NumeroTransaccion = Aud_NumTransaccion;

END$$