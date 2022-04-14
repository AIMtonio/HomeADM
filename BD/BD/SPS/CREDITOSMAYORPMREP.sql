-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMAYORPMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMAYORPMREP`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSMAYORPMREP`(
	-- SP para generar el reporte de mayor saldo insoluto Persona Moral
	Par_Anio			INT(11),				-- Anio para generar informacion del reporte
	Par_Mes				INT(11),				-- Mes para generar informacion del reporte
	Par_NumRep			TINYINT UNSIGNED,		-- Numero de Reporte

	Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables.
DECLARE Var_FechaSistema		DATE;            	-- Fecha del Sistema
DECLARE Var_FechaInicio 		DATE;			 	-- Fecha Inicio
DECLARE Var_FechaFin 			DATE;		     	-- Fecha Fin
DECLARE Var_FechFin				DATE;		     	-- Fecha Fin Periodo Contable
DECLARE Var_ReporteID			VARCHAR(10);	 	-- Numero de Reporte Regulatorio

DECLARE Var_EjercicioVig		INT;				-- Ejercicio vigente
DECLARE Var_PeriodoVig			INT;				-- Periodo vigente
DECLARE Var_FormulaCapital		VARCHAR(2000);		-- Formula para obtener el capital
DECLARE Var_SaldosCapital		DECIMAL(18,4);		-- Saldos del capital
DECLARE Var_CapitalNeto			DECIMAL(18,4);		-- Valor de capital neto

DECLARE Var_FechaCorte			DATE;				-- Fecha de corte
DECLARE Var_PorcentajeCredPM    DECIMAL(10,2);	    -- Porcentaje Creditos Mayor Saldo Insoluto Persona Moral
DECLARE Var_PorcentualCredPM    DECIMAL(10,2);      -- Resultado Porcentual (Creditos Mayor Saldo Insoluto Persona Moral)
DECLARE Var_DifLimCredPM   		DECIMAL(10,2);      -- Diferencia entre el Parametro (Creditos Mayor Saldo Insoluto Persona Moral) y el Resultado Porcentual
DECLARE Var_TotSaldoInsoluto 	DECIMAL(14,2);      -- Total Saldo Insoluto

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE Decimal_Cero		INT(11);
DECLARE ParamCredPM     	INT(11);

DECLARE EstatusVigente  	CHAR(1);
DECLARE EstatusVencida  	CHAR(1);
DECLARE PersonaMoral    	CHAR(1);
DECLARE Rep_Principal   	INT(11);
DECLARE Rep_Parametro   	INT(11);

DECLARE EstatusNoCerrado    CHAR(1);
DECLARE SaldosActuales		CHAR(1);
DECLARE SaldosHistorico		CHAR(1);
DECLARE PorFecha			CHAR(1);
DECLARE VarDeudora			CHAR(1);

DECLARE VarAcreedora		CHAR(1);

SET Cadena_Vacia		:= '';    			-- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET Decimal_Cero		:= 0.0;				-- Decimal Cero
SET ParamCredPM         := 12;    			-- CatParamRiesgosID: Parametro Creditos Mayor Saldo Insoluto Persona Moral

SET EstatusVigente      := 'V';				-- Estatus Credito: Vigente
SET EstatusVencida      := 'B';				-- Estatus Credito: Vencido
SET PersonaMoral        := 'M';             -- Tipo Persona: Persona Moral
SET Rep_Principal       := 1;				-- Tipo Reporte: Mayor Saldo Insoluto Persona Moral
SET Rep_Parametro       := 2;				-- Tipo Reporte: Consulta Parametro % Persona Moral

SET SaldosActuales		:= 'A';				-- Ubicacion: DETALLEPOLIZA
SET SaldosHistorico		:= 'H';				-- Ubicacion: SALDOSCONTABLES
SET PorFecha			:= 'F';				-- Tipo Calculo: A una Fecha
SET EstatusNoCerrado    := 'N';				-- Estatus: No Cerrado
SET VarDeudora      	:= 'D';				-- Naturaleza de movimiento: Deudora

SET VarAcreedora   		:= 'A';				-- Naturaleza de movimiento: Acreedora

SET Var_ReporteID		:= 'A2112';
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_FormulaCapital	:= (SELECT CuentaContable FROM CONCEPTOSREGREP  WHERE ConceptoID = 55 AND  ReporteID = Var_ReporteID);
SET Var_PorcentajeCredPM   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamCredPM);
SET Var_PorcentajeCredPM   := IFNULL(Var_PorcentajeCredPM,Decimal_Cero);

-- Se obtiene el ejercicio y periodo vigente
SELECT EjercicioVigente, PeriodoVigente INTO Var_EjercicioVig,Var_PeriodoVig FROM PARAMETROSSIS LIMIT 1;

SET Var_EjercicioVig := IFNULL(Var_EjercicioVig,Entero_Cero);
SET Var_PeriodoVig 	 := IFNULL(Var_PeriodoVig,Entero_Cero);

SET Var_SaldosCapital	:= IFNULL(Var_SaldosCapital, Decimal_Cero);

	-- Se obtiene la fecha final del periodo contable
	SELECT 	Fin INTO  Var_FechFin
		FROM PERIODOCONTABLE
		WHERE EjercicioID	= Var_EjercicioVig
			AND PeriodoID	= Var_PeriodoVig
			AND Estatus 	= EstatusNoCerrado;

	DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;

    -- Tabla temporal para el registro del capital
	DROP TABLE IF EXISTS TMPSALDOCAPITALNETO;
	CREATE TEMPORARY TABLE TMPSALDOCAPITALNETO(
		TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
	    ConceptoID      INT(11),
	    Saldo			DECIMAL(14,4),
		Naturaleza		CHAR(1),
		SaldoDeudor		DECIMAL(14,2),
		SaldoAcreedor	DECIMAL(14,2));
-- Se realiza la comparacion de la fecha final de la informacion a generar y la fecha final del periodo contable
IF(Var_FechaFin >= IFNULL(Var_FechFin,Fecha_Vacia))THEN
		INSERT INTO TMPCONTABLEBALANCE
					(NumeroTransaccion, 		Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
					Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
			SELECT 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
					SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)),
					SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)),
					CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
							SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2))
						 ELSE	Decimal_Cero
					END,
					CASE WHEN MAX(Cue.Naturaleza) =  VarAcreedora THEN
							SUM(ROUND(IFNULL(Pol.Abonos, Decimal_Cero), 2)) - SUM(ROUND(IFNULL(Pol.Cargos, Decimal_Cero), 2))
						 ELSE	Decimal_Cero
					END
			FROM CUENTASCONTABLES Cue
				 LEFT OUTER JOIN DETALLEPOLIZA   Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta AND Pol.Fecha <= Var_FechaFin)
			GROUP BY Cue.CuentaCompleta;

			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte < Var_FechaFin);

			IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN
				DELETE FROM TMPSALDOCONTABLE WHERE NumeroTransaccion  = Aud_NumTransaccion;
				INSERT INTO TMPSALDOCONTABLE
				SELECT	Aud_NumTransaccion,	Sal.CuentaCompleta, SUM(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
												Sal.SaldoFinal
											ELSE
												Entero_Cero
										END) AS SaldoInicialDeudor,
						SUM(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
												Sal.SaldoFinal
											ELSE
												Entero_Cero
										END) AS SaldoInicialAcreedor

					FROM	TMPCONTABLEBALANCE Tmp,
							SALDOSCONTABLES Sal
					WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
					  AND Sal.CuentaCompleta	= Tmp.CuentaContable
					  AND Sal.FechaCorte	= Var_FechaCorte
					GROUP BY Sal.CuentaCompleta ;



				UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal
                SET	Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable 	= Tmp.CuentaContable;
			END IF;

	CALL EVALFORMULAREGPRO(Var_SaldosCapital,		Var_FormulaCapital,		SaldosActuales,		PorFecha, 			Var_FechFin);

ELSE
	SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte <= Var_FechaFin);

		INSERT INTO TMPCONTABLEBALANCE
						(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
						SaldoDeudor,				SaldoAcreedor)
				SELECT 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
						CASE WHEN MAX(Cue.Naturaleza) = VarDeudora
								THEN
									SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
								ELSE
									Decimal_Cero
						END,
						CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora
								THEN
									SUM(ROUND(IFNULL(Sal.SaldoFinal, Decimal_Cero), 2))
								ELSE
									Decimal_Cero
						END
		FROM CUENTASCONTABLES Cue,
			  SALDOSCONTABLES   Sal
			WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
				AND Sal.FechaCorte	 = Var_FechaCorte
		GROUP BY Cue.CuentaCompleta;

	CALL EVALFORMULAREGPRO(Var_SaldosCapital,		Var_FormulaCapital,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);

END IF;
	-- Se obtiene el monto del capital
	INSERT INTO TMPSALDOCAPITALNETO
				(ConceptoID,	Naturaleza,			SaldoDeudor,		SaldoAcreedor)
		SELECT 	ConceptoID,		MAX(Tmp.Naturaleza),
					CASE WHEN MAX(Tmp.Naturaleza) = VarDeudora
							 THEN
								IFNULL(SUM(Tmp.SaldoInicialDeu), Decimal_Cero) -
								IFNULL(SUM(Tmp.SaldoInicialAcr), Decimal_Cero) +
								SUM(ROUND(IFNULL(Tmp.SaldoDeudor, Decimal_Cero), 2)) -
								SUM(ROUND(IFNULL(Tmp.SaldoAcreedor, Decimal_Cero), 2))
							 ELSE
								Decimal_Cero
						END AS SaldoDeudorFin,
						CASE WHEN MAX(Tmp.Naturaleza) = VarAcreedora
								 THEN
									IFNULL(SUM(Tmp.SaldoInicialAcr), Entero_Cero) -
									IFNULL(SUM(Tmp.SaldoInicialDeu), Entero_Cero) +
									SUM(ROUND(IFNULL(Tmp.SaldoAcreedor, Entero_Cero), 2)) -
									SUM(ROUND(IFNULL(Tmp.SaldoDeudor, Entero_Cero), 2))
								 ELSE
									Decimal_Cero
						END AS SaldoAcredorFin
		FROM CONCEPTOSREGREP Con
		LEFT OUTER JOIN TMPCONTABLEBALANCE Tmp
			ON Tmp.CuentaContable LIKE Con.CuentaContable
				AND Tmp.NumeroTransaccion = Aud_NumTransaccion
		WHERE Con.ReporteID = Var_ReporteID
		GROUP BY Con.CuentaContable, Con.ConceptoID
		ORDER BY Con.ConceptoID;

    UPDATE TMPSALDOCAPITALNETO
	SET Saldo = CASE WHEN Naturaleza = VarDeudora
						THEN SaldoDeudor
					 WHEN Naturaleza = VarAcreedora
						THEN SaldoAcreedor
					 ELSE Saldo
				END;

	-- Se obtiene el monto del capital neto
	SET Var_CapitalNeto := Var_SaldosCapital - IFNULL((SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPSALDOCAPITALNETO WHERE ConceptoID IN (56,57,58,59,60,61,62)), Decimal_Cero);
	SET Var_CapitalNeto	:= IFNULL(Var_CapitalNeto, Decimal_Cero);

-- Mayor Saldo Insoluto Persona Moral (Grid)
IF(Par_NumRep = Rep_Principal) THEN
	SELECT Cli.ClienteID,Cre.CreditoID, SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi +
					Sal.SalIntOrdinario + Sal.SalIntProvision + Sal.SalIntAtrasado +
					Sal.SalIntVencido + Sal.SalIntNoConta + Sal.SalMoratorios +
					Sal.SaldoMoraVencido) AS SaldoInsoluto,Cre.SucursalID,
					 Var_CapitalNeto,Var_CapitalNeto as Var_CapitalNetoMes, Var_PorcentajeCredPM, Var_DifLimCredPM
		FROM CLIENTES Cli
			INNER JOIN SALDOSCREDITOS Sal
				ON Sal.ClienteID = Cli.ClienteID
			AND Sal.EstatusCredito IN(EstatusVigente,EstatusVencida)
			AND Cli.TipoPersona = PersonaMoral
			LEFT JOIN CREDITOS Cre
				ON Cre.CreditoID = Sal.CreditoID
			WHERE Sal.FechaCorte = Var_FechaFin
			 GROUP BY Cre.CreditoID, Cli.ClienteID, Cre.SucursalID
			 ORDER BY SaldoInsoluto DESC
		LIMIT 20;
	DROP TABLE TMPSALDOCAPITALNETO;
END IF;

-- Consulta Parametro % Mayor Saldo Insoluto Persona Moral
IF(Par_NumRep = Rep_Parametro) THEN
	DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSMAYORSALDOPM;
	CREATE TEMPORARY TABLE  TMPCREDITOSMAYORSALDOPM(
			ClienteID			INT(11),
            CreditoID           BIGINT(12),
            SaldoInsoluto       DECIMAL(14,2),
            SucursalID			INT(11),
            CapitalNetoMes		DECIMAL(18,2),
            PorcentajeCredPF    DECIMAL(14,2),
            PRIMARY KEY(CreditoID));

	INSERT INTO TMPCREDITOSMAYORSALDOPM()
	SELECT Cli.ClienteID,Cre.CreditoID, SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi +
					Sal.SalIntOrdinario + Sal.SalIntProvision + Sal.SalIntAtrasado +
					Sal.SalIntVencido + Sal.SalIntNoConta + Sal.SalMoratorios +
					Sal.SaldoMoraVencido) AS SaldoInsoluto,Cre.SucursalID,
					Var_CapitalNeto, Var_PorcentajeCredPM
		FROM CLIENTES Cli
			INNER JOIN SALDOSCREDITOS Sal
				ON Sal.ClienteID = Cli.ClienteID
			AND Sal.EstatusCredito IN(EstatusVigente,EstatusVencida)
			AND Cli.TipoPersona = PersonaMoral
			LEFT JOIN CREDITOS Cre
				ON Cre.CreditoID = Sal.CreditoID
			WHERE Sal.FechaCorte = Var_FechaFin
			 GROUP BY Cre.CreditoID, Cli.ClienteID,	Cre.SucursalID
			 ORDER BY SaldoInsoluto DESC
		LIMIT 20;

	SELECT SUM(SaldoInsoluto) INTO Var_TotSaldoInsoluto FROM TMPCREDITOSMAYORSALDOPM;

	SET Var_TotSaldoInsoluto := IFNULL(Var_TotSaldoInsoluto,Decimal_Cero);

	SET Var_PorcentualCredPM   := (Var_CapitalNeto * Var_PorcentajeCredPM) / 100;
	SET Var_PorcentualCredPM   := IFNULL(Var_PorcentualCredPM, Decimal_Cero);

	SELECT 	Var_TotSaldoInsoluto,	 Var_CapitalNeto, Var_CapitalNeto as Var_CapitalNetoMes, 	Var_PorcentualCredPM,
			Var_PorcentajeCredPM, Var_DifLimCredPM;

	DROP TABLE TMPCREDITOSMAYORSALDOPM;
    DROP TABLE TMPSALDOCAPITALNETO;
END IF;
END TerminaStore$$