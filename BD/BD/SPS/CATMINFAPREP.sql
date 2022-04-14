-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMINFAPREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMINFAPREP`;
DELIMITER $$


CREATE PROCEDURE `CATMINFAPREP`(
	# SP PARA OBTENER LOS SALDOS DE INICIO, FIN, CARGOS Y ABONOS DEL MES
	Par_Anio           		INT, 				-- Anio del que se obtendra el reporte
	Par_Mes					INT,				-- Mes del que se obtendra el reporte
	Par_NumRep				TINYINT UNSIGNED,	-- Numero de reporte Excel o CSV
	Par_Version 			INT,				-- Version 2015

    Par_EmpresaID       	INT(11),			-- Parametros de auditoria
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
)

TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_FechaInicio			DATE;			-- Fecha de incio del reporte
	DECLARE Var_FechaFin			DATE;			-- Fecha final del reporte
	DECLARE Var_EjercicioVig		INT;			-- Ejercicio vigente
	DECLARE Var_PeriodoVig			INT;			-- Periodo vigente

	DECLARE Var_EjercicioID			INT;			-- ID del ejercicio
	DECLARE Var_PeriodoID			INT;			-- Id del period
	DECLARE Var_FechInicio			DATE;			-- Fecha de inicio del period
	DECLARE Var_FechFin				DATE;			-- fecha fin del periodo
	DECLARE Var_FechaCorte			DATE;			-- Fecha de corte del periodo
	DECLARE Var_MaxFechaHis		DATE;			-- Fecha de corte del periodo

	DECLARE Var_CCInicial			INT;			-- centro de costos incial
	DECLARE Var_CCFinal				INT;			-- Centro de costo final
	DECLARE Var_FechaCorteMax		DATE;			-- Fecha de corte maximo del periodo
	DECLARE Var_NatMovimiento		CHAR(1);		-- Naturaleza del movimiento
	DECLARE Var_MaxEspacios			INT;			-- Maximo de espacios

	DECLARE Var_ConceptoFinanID		INT;			-- ID del concepto financiero
	DECLARE Var_ConceptoFinanIDMax	INT;			-- ID maximo del concepto financiero
	DECLARE Var_Formula				VARCHAR(200);	-- Formula. cuando las cuentas contables incluyen sumas o restas
	DECLARE Var_SaldoCalculado		DECIMAL(14,2);	-- Saldo calculado de las formulas
	DECLARE Var_ClaveNivInstitucion VARCHAR(10);	-- Clave de institucion

	DECLARE Var_AmortAcum			DECIMAL(16,2);	--
    DECLARE Var_MonedaExtID			INT;			-- ID de la moneda extranjera
    DECLARE Var_ValorMonedaExt		DECIMAL(16,2);	-- Valor de la moneda extranjera
    DECLARE Var_FechaMoneda			DATE;			-- Fecha de la moneda
    DECLARE Saldo_Positivo			CHAR(1);		-- Saldo positivo de las cuentas signo +

	DECLARE Saldo_Negativo			CHAR(2);		-- Saldo negativo sugno -
	DECLARE Cuenta_Detalle			CHAR(2);		-- cuenta detalle D
	DECLARE Cuenta_Encabezado		CHAR(2);		-- cuenta encabezado E
	DECLARE Moneda_Nacional			INT;			-- Moneda nacional
	DECLARE Moneda_Extranjera		INT;			-- Moneda extranjera

    DECLARE Var_TotActivo			DECIMAL(16,2);	-- total de activos
    DECLARE Var_TotPasivo			DECIMAL(16,2);	-- total de pasivos
    DECLARE Var_TotCapCon			DECIMAL(16,2);
    DECLARE Var_TotCapNeto1			DECIMAL(16,2);	-- total capital neto
    DECLARE Var_TotIngresos			DECIMAL(16,2);	-- total de ingresos

    DECLARE Var_TotGastos			DECIMAL(16,2);	-- total de gastos
    DECLARE Var_TotCapNeto2			DECIMAL(16,2);
    DECLARE Var_Diferencia			DECIMAL(16,2);	-- Diferencia
    DECLARE Var_CarteraVig			DECIMAL(16,2);	-- Cartera vigente
    DECLARE Var_CarteraVen			DECIMAL(16,2);	-- Cartera Vencida

    -- NUEVAS VARIABLES PARA CATALOGO MINIMO
    DECLARE Var_SaldoInicial		DECIMAL(14,2);	-- Saldo incial de la cuenta
    DECLARE Var_SaldoFinal			DECIMAL(14,2);	-- Saldo final de la cuenta
    DECLARE Var_Cargos				DECIMAL(14,2);	-- Cargos
    DECLARE Var_Abonos				DECIMAL(14,2);	-- Abonos

	DECLARE Clave_Reg				VARCHAR(3);		-- Clave de registro
	DECLARE Var_CuentaContable		VARCHAR(12);	-- Cuenta contable
	DECLARE Var_AjustaSaldo			CHAR(1);		-- Si ajusta o no el saldo
	DECLARE Var_SI					CHAR(1);		-- Si 'S'
	DECLARE Var_NO					CHAR(1);		-- No 'N'

  	-- Declaracion de Constantes
	DECLARE Rep_Excel				INT(1);			-- Reporte en formato excel
	DECLARE Rep_Csv					INT(1);			-- Reporte en csv
	DECLARE Entero_Cero				INT(2);			-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(21,2);	-- DECIMAL cero
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia

	DECLARE Fecha_Vacia				DATE;			-- fecha vacia
	DECLARE Estatus_NoCerrado		CHAR(1);		-- estatus no cerrado
	DECLARE VarDeudora				CHAR(1);		-- Naturaleza deudora
	DECLARE VarAcreedora			CHAR(1);		-- naturaleza acreedora
	DECLARE ConceptosCatMin			INT(2);			-- Concepto catalogo minimo

	DECLARE SaldosActuales			CHAR(1);		-- saldos actuales
	DECLARE SaldosHistorico			CHAR(1);		-- Saldos historicos
	DECLARE PorFecha				CHAR(1);		-- buscar por fecha
	DECLARE version_anterior_2015 	INT;			-- Version anterior al 2015

	DECLARE version_2015			INT;			-- version 2015
	DECLARE NumCliente				INT;			-- numero de cliente
	DECLARE Var_Redondeo				INT;		-- Si se va a redondear el resultado
    -- constantest nuevas
    DECLARE Estatus_Cerrado			CHAR(1);		-- Estatus cerrado 'C'

	-- Asignacion de constantes
	SET version_anterior_2015	:= 2014;
	SET version_2015			:= 2015;
	SET Rep_Excel       		:= 1;
	SET Rep_Csv					:= 2;
	SET Entero_Cero				:= 0;

	SET Decimal_Cero			:= 0.00;
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Estatus_NoCerrado		:= 'N';
	SET VarDeudora      		:= 'D';

	SET VarAcreedora   			:= 'A';
	SET ConceptosCatMin			:= 3;
	SET SaldosActuales			:= 'A';
	SET SaldosHistorico			:= 'H';
	SET PorFecha				:= 'F';

	SET Saldo_Positivo 			:= 'P';
	SET Saldo_Negativo 			:= 'N';
	SET Cuenta_Detalle			:= 'D';
	SET Cuenta_Encabezado 		:= 'E';
	SET Moneda_Nacional			:= 14;

	SET Moneda_Extranjera 		:= 4;
	SET Clave_Reg				:= '111';
	SET Var_SI					:= 'S';
	SET Var_NO					:= 'N';
    SET Estatus_Cerrado			:= 'C';

    SELECT IFNULL(ValorParametro, Entero_Cero) INTO NumCliente
    FROM PARAMGENERALES
    WHERE  LlaveParametro = 'CliProcEspecifico';

    SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
    SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);

    CALL TRANSACCIONESPRO(Aud_NumTransaccion);

    -- fecha ultimo cierre
    SELECT   MAX(FechaCorte)  INTO Var_FechaCorteMax
        FROM SALDOSCONTABLES Per
        WHERE Per.FechaCorte < Var_FechaInicio;

    SELECT MAX(Fecha) INTO  Var_MaxFechaHis FROM `HIS-DETALLEPOL` ;


    SET Var_MaxFechaHis := IFNULL(Var_MaxFechaHis,Fecha_Vacia);
    SET Var_FechaCorteMax := IFNULL(Var_FechaCorteMax,Fecha_Vacia);

    DELETE FROM TMPREGCATMIN;
	DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
    DELETE FROM TMPDETPOLCENCOS	WHERE NumTransaccion = Aud_NumTransaccion;

    	-- identificar si la fecha de consuta es de saldos historicos o actuales
    IF Var_MaxFechaHis < Var_FechaInicio THEN

        -- insertamos datos de DETALLEPOLIZA para obtener Cargos y Abonos del Mes
		INSERT INTO TMPCONTABLEBALANCE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
										Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
		SELECT 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		(Cue.Naturaleza),
					SUM(IFNULL(Pol.Cargos, Decimal_Cero)),
					SUM(IFNULL(Pol.Abonos, Decimal_Cero)),
					CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
						SUM( IFNULL(Pol.Cargos, Decimal_Cero)  - IFNULL(Pol.Abonos, Decimal_Cero) )
						ELSE	Decimal_Cero
					END,
					CASE WHEN (Cue.Naturaleza) =  VarAcreedora THEN
						SUM(IFNULL(Pol.Abonos, Decimal_Cero) - IFNULL(Pol.Cargos, Decimal_Cero) )
						ELSE	Decimal_Cero
					END
				FROM CUENTASCONTABLES Cue
					  LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
																	 AND Pol.Fecha BETWEEN  Var_FechaInicio AND Var_FechaFin)
				GROUP BY Cue.CuentaCompleta;


        INSERT INTO `TMPDETPOLCENCOS`	(
					`CentroCostoID`,			`CuentaCompleta`,			`Cargos`,			`Abonos`,			`NumTransaccion`)
			SELECT	Entero_Cero, Pol.CuentaCompleta,
					SUM(ROUND(IFNULL(Pol.Cargos,Entero_Cero),2)), SUM(ROUND(IFNULL(Pol.Abonos,Entero_Cero),2)), Aud_NumTransaccion
				FROM DETALLEPOLIZA AS Pol
				WHERE Pol.Fecha	> Var_MaxFechaHis
				  AND Pol.Fecha	< Var_FechaInicio
			GROUP BY Pol.CuentaCompleta;

    ELSE --  la Fecha de Consulta es de Saldos Historicos

        INSERT INTO TMPCONTABLEBALANCE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
										Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
		SELECT 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		(Cue.Naturaleza),
					SUM(IFNULL(Pol.Cargos, Decimal_Cero)),
					SUM(IFNULL(Pol.Abonos, Decimal_Cero)),
					CASE WHEN (Cue.Naturaleza) = VarDeudora  THEN
						SUM( IFNULL(Pol.Cargos, Decimal_Cero)  - IFNULL(Pol.Abonos, Decimal_Cero) )
						ELSE	Decimal_Cero
					END,
					CASE WHEN (Cue.Naturaleza) =  VarAcreedora THEN
						SUM(IFNULL(Pol.Abonos, Decimal_Cero) - IFNULL(Pol.Cargos, Decimal_Cero) )
						ELSE	Decimal_Cero
					END
				FROM CUENTASCONTABLES Cue
					  LEFT OUTER JOIN `HIS-DETALLEPOL` AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
																	 AND Pol.Fecha BETWEEN  Var_FechaInicio AND Var_FechaFin)
				GROUP BY Cue.CuentaCompleta;

    END IF;


    -- obtenemos los saldos del ultimo cierre contable, para poder calcular los saldos de inicio
    IF Var_FechaCorteMax <> Fecha_Vacia THEN

			DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
			INSERT INTO TMPSALDOCONTABLE
			SELECT	Aud_NumTransaccion,	Sal.CuentaCompleta, SUM(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
											Sal.SaldoFinal + IFNULL(Cos.Cargos,Entero_Cero)  - IFNULL(Cos.Abonos,Entero_Cero)
										ELSE
											Entero_Cero
									END) AS SaldoInicialDeudor,
					SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
											Sal.SaldoFinal - IFNULL(Cos.Cargos,Entero_Cero) + IFNULL(Cos.Abonos,Entero_Cero)
										ELSE
											Entero_Cero
									END) AS SaldoInicialAcreedor

				FROM	TMPCONTABLEBALANCE Tmp,
						SALDOSCONTABLES Sal
						LEFT OUTER JOIN TMPDETPOLCENCOS Cos
						ON Sal.CuentaCompleta = Cos.CuentaCompleta
						AND Cos.NumTransaccion = Aud_NumTransaccion

				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Sal.CuentaCompleta	= Tmp.CuentaContable
				  AND Sal.FechaCorte	= Var_FechaCorteMax
				GROUP BY Sal.CuentaCompleta ;

                UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr,
                    Tmp.SaldoDeudor	 	= CASE WHEN Naturaleza = VarDeudora THEN Sal.SaldoInicialDeu + Tmp.Cargos - Tmp.Abonos ELSE Entero_Cero END,
                    Tmp.SaldoAcreedor	= CASE WHEN Naturaleza = VarAcreedora THEN Sal.SaldoInicialAcr + Tmp.Abonos - Tmp.Cargos ELSE Entero_Cero END
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable 	= Tmp.CuentaContable;



    END IF;


	INSERT INTO TMPREGCATMIN (	NumeroTransaccion,		ConceptoFinanID,		Fecha,				CuentaContable,			Naturaleza,
								Cargos,					Abonos,					SaldoInicialDeu,	SaldoInicialAcr, 		SaldoDeudor,
								SaldoAcreedor, CentroCosto)
	SELECT 	Aud_NumTransaccion, 	Con.ConceptoFinanID,	Var_FechaFin,		Con.CuentaContable,	Con.Naturaleza,
			SUM(Tmp.Cargos),		SUM(Tmp.Abonos),
			CASE WHEN Con.Naturaleza = VarDeudora  THEN
					SUM(IFNULL(Tmp.SaldoInicialDeu,Decimal_Cero)-IFNULL(Tmp.SaldoInicialAcr,Decimal_Cero))
				ELSE Decimal_Cero
			END AS SaldoInicialDeu,
			CASE WHEN Con.Naturaleza = VarAcreedora  THEN
					SUM(IFNULL(Tmp.SaldoInicialAcr,Decimal_Cero)-IFNULL(Tmp.SaldoInicialDeu,Decimal_Cero))
				ELSE Decimal_Cero
			END AS SaldoInicialAcr,
			CASE WHEN Con.Naturaleza = VarDeudora THEN
					SUM(IFNULL((Tmp.SaldoInicialDeu), Decimal_Cero) -
						IFNULL((Tmp.SaldoInicialAcr), Decimal_Cero) +
						(IFNULL(Tmp.Cargos, Decimal_Cero) -
						IFNULL(Tmp.Abonos, Decimal_Cero)))
				ELSE
					Decimal_Cero
			END AS SaldoDeudorFin,
			CASE WHEN Con.Naturaleza = VarAcreedora THEN
					SUM(IFNULL((Tmp.SaldoInicialAcr), Entero_Cero) -
						IFNULL((Tmp.SaldoInicialDeu), Entero_Cero) +
						(IFNULL(Tmp.Abonos, Entero_Cero) -
						IFNULL(Tmp.Cargos, Entero_Cero)))
				ELSE
					Decimal_Cero
			END AS SaldoAcredorFin,
			Entero_Cero
	FROM CONCEPESTADOSFIN Con
	LEFT OUTER JOIN TMPCONTABLEBALANCE Tmp
			ON Tmp.CuentaContable LIKE Con.CuentaContable
			AND Tmp.NumeroTransaccion = Aud_NumTransaccion
	WHERE Con.EstadoFinanID = ConceptosCatMin
		AND Con.NumClien = NumCliente
	GROUP BY Con.CuentaContable, Con.ConceptoFinanID
	ORDER BY Con.ConceptoFinanID ;

	SET Var_ConceptoFinanID		:= Entero_Cero;
	SET Var_ConceptoFinanIDMax	:= (SELECT MAX(ConceptoFinanID)
									FROM TMPREGCATMIN
									WHERE NumeroTransaccion = Aud_NumTransaccion);


        -- CICLO PARA SUMAR CUENTAS CONTABLES

        WHILE (Var_ConceptoFinanID <= Var_ConceptoFinanIDMax) DO

                        SELECT  MIN(ConceptoFinanID) INTO
								Var_ConceptoFinanID
							FROM TMPREGCATMIN
							 WHERE ConceptoFinanID > Var_ConceptoFinanID
								AND (LOCATE('+', CuentaContable) > Entero_Cero OR LOCATE('-', CuentaContable) > Entero_Cero)
								AND NumeroTransaccion = Aud_NumTransaccion
			                    ORDER BY ConceptoFinanID;

						SELECT  CuentaContable INTO
								 Var_Formula
							FROM TMPREGCATMIN
							 WHERE ConceptoFinanID = Var_ConceptoFinanID
								AND NumeroTransaccion = Aud_NumTransaccion
			                    ORDER BY ConceptoFinanID;

					IF(Var_ConceptoFinanID > Entero_Cero ) THEN



						CALL EVALFORMULASALPRO(Var_SaldoFinal,Var_SaldoInicial,Var_Cargos,Var_Abonos,
												Var_Formula,SaldosActuales,PorFecha,Var_FechaFin,0,0);

                            -- Asignar nuevos saldos
						UPDATE TMPREGCATMIN
							SET Cargos = Var_Cargos,
								Abonos = Var_Abonos,
                                SaldoDeudor=Var_SaldoFinal,
                                SaldoInicialDeu=Var_SaldoInicial,
                                Naturaleza = VarDeudora
							WHERE ConceptoFinanID 	= Var_ConceptoFinanID
							AND NumeroTransaccion	= Aud_NumTransaccion;


					END IF;

		END WHILE;


		-- LENAR TABLA FINAL
		DROP TABLE IF EXISTS TMPSALDOSFINCATMINFAP;
		CREATE  TABLE TMPSALDOSFINCATMINFAP
		SELECT	Con.EstadoFinanID,	Con.ConceptoFinanID,	Con.Descripcion,	Con.Desplegado,	Con.CuentaContable,Con.Tipo,
				Con.EsCalculado,	Con.NombreCampo,		Con.Espacios,		Con.Negrita,	Con.Sombreado,
				Con.CombinarCeldas,	Tmp.NumeroTransaccion,	Tmp.Fecha,
				CASE WHEN Tmp.Naturaleza = VarDeudora
					THEN
						Tmp.SaldoDeudor-Tmp.SaldoAcreedor
					ELSE
						Tmp.SaldoAcreedor-Tmp.SaldoDeudor
				END AS SaldoFinal,
				CASE WHEN Tmp.Naturaleza = VarDeudora
					THEN
						Tmp.SaldoInicialDeu-Tmp.SaldoInicialAcr
					ELSE
						Tmp.SaldoInicialAcr-Tmp.SaldoInicialDeu
				END AS SaldoInicial,Tmp.Cargos,Tmp.Abonos
		FROM 	CONCEPESTADOSFIN Con,
				TMPREGCATMIN Tmp
		WHERE 	Con.EstadoFinanID 		= ConceptosCatMin
			AND	Tmp.NumeroTransaccion	= Aud_NumTransaccion
			AND	Con.ConceptoFinanID		= Tmp.ConceptoFinanID
			AND Con.NumClien = NumCliente
		ORDER BY Con.ConceptoFinanID ASC;



    -- TIPO DE REPORTE
    IF(Par_NumRep = Rep_Excel) THEN

				SET Var_MaxEspacios	:= ( SELECT	MAX(Con.CombinarCeldas)
											FROM 	TMPREGCATMIN Tmp,
													CONCEPESTADOSFIN Con
											WHERE 	Con.EstadoFinanID 		= ConceptosCatMin
												AND	Tmp.NumeroTransaccion	= Aud_NumTransaccion
												AND	Con.ConceptoFinanID		= Tmp.ConceptoFinanID
												AND Con.NumClien = NumCliente);

				SELECT	Con.EstadoFinanID,	Con.ConceptoFinanID,	Con.Descripcion,	Con.Desplegado,	Con.CuentaContable,
						Con.EsCalculado,	Con.NombreCampo,		Con.Espacios,		Con.Negrita,	Con.Sombreado,
						Con.CombinarCeldas,	Con.NumeroTransaccion,	Con.Fecha,			Var_MaxEspacios AS MaxEspacios,
                        IFNULL(Con.Cargos,Decimal_Cero) AS Cargos, IFNULL(Con.Abonos,Decimal_Cero) AS Abonos, Con.SaldoFinal, Con.SaldoInicial
				FROM 	TMPSALDOSFINCATMINFAP Con
                ORDER BY Con.ConceptoFinanID;


	END IF;

    IF(Par_NumRep = Rep_Csv) THEN

				(SELECT com.Valor
					FROM
					(SELECT	IFNULL(CONCAT (CON.CuentaFija,
                                            ';',TMP.SaldoInicial,';',IFNULL(TMP.Cargos,Decimal_Cero),';',
									IFNULL(TMP.Abonos,Decimal_Cero),';',TMP.SaldoFinal), Cadena_Vacia) AS Valor, IFNULL(TMP.CuentaContable,'') AS cta
							FROM 	TMPSALDOSFINCATMINFAP 		TMP,
									CONCEPESTADOSFIN	CON
						WHERE 	CON.EstadoFinanID 		= ConceptosCatMin
							AND	TMP.NumeroTransaccion	= Aud_NumTransaccion
							AND	CON.ConceptoFinanID		= TMP.ConceptoFinanID
							AND CON.NumClien = NumCliente
						 ORDER BY CON.ConceptoFinanID
					)AS com
					WHERE com.cta <> '');
	END IF;


END TerminaStore$$
