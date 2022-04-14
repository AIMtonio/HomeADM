-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUMAHORROINVERSIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUMAHORROINVERSIONREP`;
DELIMITER $$

CREATE PROCEDURE `SUMAHORROINVERSIONREP`(
	-- SP para generar el reporte de Sumas de Ahorro Inversion
	Par_FechaOperacion	DATE,			 -- Fecha para generar el Reporte

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


-- Declaracion de Variables
DECLARE Var_FechaSistema		DATE;            -- Fecha del Sistema
DECLARE Var_FechaAnterior   	DATE;            -- Fecha Dia Anterior
DECLARE Var_PorcSumAhoInv		DECIMAL(10,2);	 -- Porcentaje Parametrizado Suma Ahorro Inversion
DECLARE Var_FechaIniMes 		DATE;			 -- Fecha Inicio
DECLARE Var_FechaFin 			DATE;			 -- Fecha Fin

DECLARE Var_MontoCaptado		DECIMAL(14,2);   -- Monto Captado del Dia Anterior
DECLARE Var_PorcentSumAhoInv   	DECIMAL(10,2);   -- Resultado Porcentual Suma Ahorro Inversion
DECLARE Var_DifLimiteSumAhoInv  DECIMAL(10,2);   -- Diferencia entre el Parametro ( Suma Ahorro Inversion) y el Resultado Porcentual ( Suma Ahorro Inversion)
DECLARE Var_CapitalNeto 		DECIMAL(18,2);   -- Monto Capital Neto
DECLARE Var_DiasInversion  		INT(11);         -- Dias Inversion

DECLARE Var_FechaInicio 		DATE;            -- Fecha de Inicio
DECLARE Var_IniMesSistema	    DATE;			 -- Fecha Inicial Mes del Sistema
DECLARE Var_FechaHistor         DATE;			 -- Fecha Historica
DECLARE Var_SaldoOrdinario		DECIMAL(14,2);   -- Saldo Disponible de Cuentas de Ahorro Ordinario
DECLARE Var_SaldoVista			DECIMAL(14,2);   -- Saldo Disponible de Cuentas de Ahorro Vista

DECLARE Var_SaldoCaptado        DECIMAL(14,2);   -- Saldo Total Captado
DECLARE Var_PorcentualSaldo	 	DECIMAL(10,2);   -- Resultado Porcentual Saldos Ahorro e Inversion
DECLARE Var_DifLimiteSaldo		DECIMAL(10,2);   -- Diferencia entre el Parametro y el Resultado Porcentual (Saldos Ahorro e Inversion)
DECLARE Var_SaldoInversion      DECIMAL(14,2);   -- Saldo Total de la Inversion
DECLARE Var_AhoOrdinarioSocio   DECIMAL(14,2);   -- Ahooro Ordinario Socio

DECLARE Var_AhoVistaSocio       DECIMAL(14,2);   -- Ahorro Vista del Socio
DECLARE Var_InversionSocio   	DECIMAL(14,2);   -- Inversion del Socio
DECLARE Var_SalAhoOrdinSocio	DECIMAL(14,2);   -- Saldo Ahorro Ordinario Socio
DECLARE Var_SalAhoVistaSocio    DECIMAL(14,2);	 -- Saldo Ahorro Vista Socio
DECLARE Var_SalInversionSocio   DECIMAL(14,2);	 -- Saldo Inversion Socio

DECLARE Var_ReporteID			VARCHAR(10);	-- Numero de Reporte Regulatorio
DECLARE Var_EjercicioVig		INT;			-- Ejercicio vigente
DECLARE Var_PeriodoVig			INT;			-- Periodo vigente
DECLARE Var_FormulaCapital		VARCHAR(2000);	-- Formula para obtener el capital
DECLARE Var_SaldosCapital		DECIMAL(18,4);	-- Saldos del capital

DECLARE Var_FechFin				DATE;		    -- Fecha Fin Periodo Contable
DECLARE Var_FechaCorte			DATE;			-- Fecha de corte

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamSumAhoInv		INT(11);
DECLARE Estatus_Vigente     CHAR(1);

DECLARE MovimientoCargo		CHAR(1);
DECLARE MovimientoAbono		CHAR(1);
DECLARE AhorroOrdinario		CHAR(1);
DECLARE AhorroVista			CHAR(1);
DECLARE NumDia			    INT(11);

DECLARE Inversion_Vigente   CHAR(1);
DECLARE Inversion_Pagada    CHAR(1);
DECLARE Inversion_Cancelada CHAR(1);
DECLARE MenorEdadSI			CHAR(1);
DECLARE MovimientoBloqueo   CHAR(1);

DECLARE Cons_BloqGarLiq		INT(11);
DECLARE CtaActiva           CHAR(1);
DECLARE CtaBloqueada        CHAR(1);
DECLARE CtaCancelada        CHAR(1);
DECLARE EstatusNoCerrado    CHAR(1);

DECLARE SaldosActuales		CHAR(1);
DECLARE SaldosHistorico		CHAR(1);
DECLARE PorFecha			CHAR(1);
DECLARE VarDeudora			CHAR(1);
DECLARE VarAcreedora		CHAR(1);

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Entero_Cero			:= 0;				-- Entero Cero
SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET ParamSumAhoInv   	:= 10;              -- CatParamRiesgosID: Parametro Suma Ahorro Inversion

SET Estatus_Vigente     := 'N';             -- Estatus Inversion: Vigente
SET MovimientoCargo		:= 'C';				-- Naturaleza Movimiento: Cargo
SET MovimientoAbono		:= 'A';				-- Naturaleza Movimiento: Abono
SET AhorroOrdinario		:= 'A';				-- Clasificacion Contable: Ahorro(Ordinario)
SET AhorroVista			:= 'V';				-- Clasificacion Contable: Depositos a la Vista

SET NumDia              := 1;
SET Inversion_Vigente   := 'N';             -- Estatus Inversion: VIGENTE
SET Inversion_Pagada    := 'P';             -- Estatus Inversion: PAGADA
SET Inversion_Cancelada := 'C';             -- Estatus Inversion: CANCELADA
SET MenorEdadSI         := 'S';             -- Es Menor de Edad: SI

SET MovimientoBloqueo   := 'B';             -- Naturaleza Movimiento: Bloqueo
SET Cons_BloqGarLiq		:= 8;	            -- Tipo Bloqueo: Deposito por Garantia Liquida
SET CtaActiva           := 'A';				-- Cuenta Activa
SET CtaBloqueada        := 'B';				-- Cuenta Bloqueada
SET CtaCancelada        := 'C';				-- Cuenta Cancelada

SET SaldosActuales		:= 'A';				-- Ubicacion: DETALLEPOLIZA
SET SaldosHistorico		:= 'H';				-- Ubicacion: SALDOSCONTABLES
SET PorFecha			:= 'F';				-- Tipo Calculo: A una Fecha
SET EstatusNoCerrado    := 'N';				-- Estatus: No Cerrado
SET VarDeudora      	:= 'D';				-- Naturaleza de movimiento: Deudora

SET VarAcreedora   		:= 'A';				-- Naturaleza de movimiento: Acreedora

-- Asignacion de Variables
SET Var_ReporteID		:= 'A2112';
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_IniMesSistema	:= 	DATE(CONCAT(CAST(YEAR(Var_FechaSistema) AS CHAR), "-", CAST(MONTH( Var_FechaSistema) AS CHAR), "-01"));
SET Var_DiasInversion   := (SELECT DiasInversion FROM PARAMETROSSIS);
SET Var_PorcSumAhoInv   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamSumAhoInv);

SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_FechaIniMes 	:=  DATE(CONCAT(CAST(YEAR(Var_FechaAnterior) AS CHAR), "-", CAST(MONTH(Var_FechaAnterior) AS CHAR), "-01"));
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaIniMes, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_FormulaCapital	:= (SELECT CuentaContable FROM CONCEPTOSREGREP  WHERE ConceptoID = 55 AND  ReporteID = Var_ReporteID);
SET Var_PorcSumAhoInv   := IFNULL(Var_PorcSumAhoInv,Decimal_Cero);


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
		SELECT 	ConceptoID,		Tmp.Naturaleza,
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
		GROUP BY Con.CuentaContable, Con.ConceptoID, Tmp.Naturaleza
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

	-- ==================================================================
	-- Tabla Temporal para Almacenar el Monto de Ahorro Ordinario Por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSAHORD;
	CREATE TEMPORARY TABLE TMPSOCIOSAHORD(
		ClienteID		   INT(11),
		MontoAhoOrdinario  DECIMAL(14,2));

	IF(Var_FechaAnterior >= Var_IniMesSistema) THEN
		INSERT INTO TMPSOCIOSAHORD()
		SELECT Cli.ClienteID, IFNULL((CASE WHEN Mov.NatMovimiento  = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero) -
				IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero)
				FROM CUENTASAHOMOV Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad != MenorEdadSI
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
					AND Tip.ClasificacionConta = AhorroOrdinario
				WHERE Mov.Fecha = Var_FechaAnterior;
		ELSE
			INSERT INTO TMPSOCIOSAHORD()
			SELECT Cli.ClienteID, IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero) -
					IFNULL((CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero)
					FROM `HIS-CUENAHOMOV` Mov
					INNER JOIN CUENTASAHO Cue
						ON Cue.CuentaAhoID = Mov.CuentaAhoID
					INNER JOIN CLIENTES Cli
						ON Cue.ClienteID = Cli.ClienteID
						AND Cli.EsMenorEdad != MenorEdadSI
					INNER JOIN TIPOSCUENTAS Tip
						ON Tip.TipoCuentaID = Cue.TipoCuentaID
						AND Tip.ClasificacionConta = AhorroOrdinario
					WHERE Mov.Fecha = Var_FechaAnterior;

	END IF;

	-- ==================================================================
	-- Tabla Temporal para almacenar la Suma Ahorro Ordinario por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSSUMAHORD;
	CREATE TEMPORARY TABLE TMPSOCIOSSUMAHORD (
		ClienteID		   INT(11),
		SumaAhoOrdinario   DECIMAL(14,2));

	INSERT INTO TMPSOCIOSSUMAHORD()
	SELECT ClienteID, SUM(MontoAhoOrdinario)
		FROM TMPSOCIOSAHORD
		 GROUP BY ClienteID;

	-- ==================================================================
	-- Tabla Temporal para Almacenar el Monto de Ahorro Vista Por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSAHO;
	CREATE TEMPORARY TABLE TMPSOCIOSAHO(
		ClienteID		   INT(11),
		MontoAhorroVista   DECIMAL(14,2));

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
		INSERT INTO TMPSOCIOSAHO()
		SELECT Cli.ClienteID, IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero) -
				IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero)
				FROM CUENTASAHOMOV Mov
				INNER JOIN CUENTASAHO Cue
					ON Cue.CuentaAhoID = Mov.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
					AND Cli.EsMenorEdad != MenorEdadSI
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
					AND Tip.ClasificacionConta = AhorroVista
				WHERE Mov.Fecha = Var_FechaAnterior;
		ELSE
			INSERT INTO TMPSOCIOSAHO()
			SELECT Cli.ClienteID, IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero) -
					IFNULL((CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.CantidadMov ELSE Decimal_Cero END),Decimal_Cero)
					FROM `HIS-CUENAHOMOV` Mov
					INNER JOIN CUENTASAHO Cue
						ON Cue.CuentaAhoID = Mov.CuentaAhoID
					INNER JOIN CLIENTES Cli
						ON Cue.ClienteID = Cli.ClienteID
						AND Cli.EsMenorEdad != MenorEdadSI
					INNER JOIN TIPOSCUENTAS Tip
						ON Tip.TipoCuentaID = Cue.TipoCuentaID
						AND Tip.ClasificacionConta = AhorroVista
					WHERE Mov.Fecha = Var_FechaAnterior;

	END IF;

	-- ==================================================================
	-- Tabla Temporal para almacenar la Suma Ahorro Vista por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSSUMAHO;
	CREATE TEMPORARY TABLE  TMPSOCIOSSUMAHO (
		ClienteID		   INT(11),
		SumaAhorroVista    DECIMAL(14,2));

	INSERT INTO TMPSOCIOSSUMAHO()
	SELECT ClienteID, SUM(MontoAhorroVista)
		FROM TMPSOCIOSAHO
		 GROUP BY ClienteID;

	-- ==================================================================
	-- Tabla Temporal para Almacenar el Monto de las Inversiones por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSINV;
	CREATE TEMPORARY TABLE TMPSOCIOSINV(
		ClienteID		INT(11),
		MontoInversion	DECIMAL(14,2),
		MontoInteres    DECIMAL(14,2),
		TotalMonto      DECIMAL(14,2));

	IF (Var_FechaAnterior >= Var_IniMesSistema) THEN
	INSERT INTO TMPSOCIOSINV()
	SELECT ClienteID,IFNULL(Monto,Decimal_Cero),IFNULL(ROUND(((Monto * Tasa * NumDia/Var_DiasInversion)/100),2),Decimal_Cero) AS MontoInteres, Decimal_Cero
		FROM INVERSIONES
		WHERE FechaInicio = Var_FechaAnterior AND Plazo >= 1 AND Plazo <= 400 AND Estatus = Inversion_Vigente;


	UPDATE TMPSOCIOSINV Tmp
		SET TotalMonto = IFNULL((MontoInversion + MontoInteres),Decimal_Cero);

	ELSE
	INSERT INTO TMPSOCIOSINV()
	SELECT ClienteID, IFNULL(Monto,Decimal_Cero), IFNULL(InteresGenerado,Decimal_Cero), Decimal_Cero
	FROM `HISINVERSIONES`
		WHERE FechaInicio = Var_FechaAnterior AND Plazo >= 1 AND Plazo <= 400  AND Estatus = Inversion_Vigente;


	UPDATE TMPSOCIOSINV Tmp
		SET TotalMonto = IFNULL((MontoInversion + MontoInteres),Decimal_Cero);

	END IF;

	-- ==================================================================
	-- Tabla Temporal para Almacenar la Suma de las Inversiones por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSSUMAINV;
	CREATE TEMPORARY TABLE  TMPSOCIOSSUMAINV (
		ClienteID			INT(11),
		SumaInversion    	DECIMAL(14,2));

	INSERT INTO TMPSOCIOSSUMAINV()
	SELECT ClienteID, SUM(TotalMonto)
		FROM TMPSOCIOSINV
		 GROUP BY ClienteID;

	-- ==================================================================
	-- Tabla Temporal para Almacenar los Monto de Ahorros e Inversiones por Socio
	-- ==================================================================
	DROP TABLE IF EXISTS TMPSOCIOSAHOINV;
	CREATE TEMPORARY TABLE TMPSOCIOSAHOINV(
		ClienteID				INT(11),
		TotalAhoOrdinario    	DECIMAL(14,2),
		TotalAhorroVista    	DECIMAL(14,2),
		TotalMontoInversion		DECIMAL(14,2),
		MontoTotal				DECIMAL(14,2));

	INSERT INTO TMPSOCIOSAHOINV()
	SELECT Ord.ClienteID, IFNULL(Ord.SumaAhoOrdinario,Decimal_Cero), IFNULL(Aho.SumaAhorroVista,Decimal_Cero),
			IFNULL(Inv.SumaInversion,Decimal_Cero),Decimal_Cero
	FROM TMPSOCIOSSUMAHORD Ord
		INNER JOIN TMPSOCIOSSUMAHO Aho
		ON Aho.ClienteID = Ord.ClienteID
		LEFT JOIN TMPSOCIOSSUMAINV Inv
		ON Inv.ClienteID = Aho.ClienteID;

	UPDATE TMPSOCIOSAHOINV
		SET MontoTotal = TotalAhoOrdinario + TotalAhorroVista + TotalMontoInversion;

	SELECT TotalAhoOrdinario,TotalAhorroVista, TotalMontoInversion
		   INTO Var_AhoOrdinarioSocio,Var_AhoVistaSocio, Var_InversionSocio
		FROM TMPSOCIOSAHOINV
		ORDER BY MontoTotal DESC
		LIMIT 1;

	SET Var_AhoOrdinarioSocio	:= IFNULL(Var_AhoOrdinarioSocio, Decimal_Cero);
	SET Var_AhoVistaSocio	:= IFNULL(Var_AhoVistaSocio, Decimal_Cero);
	SET Var_InversionSocio	:= IFNULL(Var_InversionSocio, Decimal_Cero);


	-- ====================================
	 -- Saldo Cuentas de Ahorro
	-- ====================================

	SET Var_FechaInicio 	:= Fecha_Vacia;

	SET Var_FechaInicio	= DATE(CONCAT(CAST(YEAR( Var_FechaAnterior) AS CHAR), "-", CAST(MONTH( Var_FechaAnterior) AS CHAR), "-01"));

	-- Tabla temporal para almacenar saldos bloqueados
	DROP TABLE IF EXISTS TMPSALDOSBLOQUEO;
	CREATE TEMPORARY TABLE TMPSALDOSBLOQUEO (
		Cuenta 		BIGINT,
		Saldo		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	INSERT INTO TMPSALDOSBLOQUEO()
	SELECT Blo.CuentaAhoID, SUM(CASE WHEN NatMovimiento = MovimientoBloqueo THEN  MontoBloq ELSE MontoBloq *-1 END) AS Saldo
		FROM BLOQUEOS Blo
		WHERE DATE(FechaMov) <= Var_FechaAnterior
			AND TiposBloqID = Cons_BloqGarLiq
			GROUP BY CuentaAhoID;

	-- Tabla temporal para almacenar los saldos de movimientos
	DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOS;
	CREATE TEMPORARY TABLE TMPSALDOSMOVIMIENTOS (
		Cuenta 			BIGINT,
		SaldoMov		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	-- Tabla temporal para almacenar los saldos de movimientos Actuales
	DROP TABLE IF EXISTS TMPSALDOSMOVIMIENTOSACT;
	CREATE TEMPORARY TABLE TMPSALDOSMOVIMIENTOSACT (
		Cuenta 			BIGINT,
		SaldoMov		DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	IF(Var_FechaAnterior < Var_IniMesSistema) THEN
		SELECT MAX(Fecha) INTO Var_FechaHistor
			FROM `HIS-CUENTASAHO`
				WHERE Fecha < Var_IniMesSistema
				 AND MONTH(Fecha) = MONTH(Var_FechaAnterior);
	END IF;

	SET Var_FechaHistor	:= IFNULL(Var_FechaHistor, Fecha_Vacia);

	IF(Var_FechaAnterior < Var_IniMesSistema) THEN
		INSERT INTO TMPSALDOSMOVIMIENTOS
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
				FROM `HIS-CUENAHOMOV` Mov
					WHERE Mov.Fecha >= Var_FechaInicio
					  AND Mov.Fecha <= Var_FechaAnterior
					  GROUP BY Mov.CuentaAhoID;

		INSERT INTO TMPSALDOSMOVIMIENTOSACT
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END)
				FROM CUENTASAHOMOV Mov
				WHERE Mov.Fecha <= Var_FechaAnterior
					GROUP BY Mov.CuentaAhoID;
	ELSE
		INSERT INTO TMPSALDOSMOVIMIENTOS
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.CantidadMov * -1 else Mov.CantidadMov END)
				FROM CUENTASAHOMOV Mov
				WHERE Mov.Fecha >= Var_FechaInicio
				  AND Mov.Fecha <= Var_FechaAnterior
				GROUP BY Mov.CuentaAhoID;
	END IF;

	-- Tabla temporal para almacenar los saldos de las cuentas
	DROP TABLE IF EXISTS TMPSALDOSCTAS;
	CREATE TABLE TMPSALDOSCTAS (
		ClienteID		INT(11),
		Cuenta 			BIGINT,
		NumTipCuenta	INT(11),
		TipoCuenta		VARCHAR(30),
		NumSucursal		INT(11),
		NombreSucurs	VARCHAR(30),
		SaldoIniMes		DECIMAL(18,2),
		SaldoDispon		DECIMAL(18,2),
		SaldoGarLiq		DECIMAL(18,2),
		SaldoTotal		DECIMAL(18,2),
		EsMenor			CHAR(1),
		ClasiConta  	CHAR(1),
		PRIMARY KEY(Cuenta));

	IF(Var_FechaAnterior < Var_IniMesSistema) THEN
			INSERT INTO TMPSALDOSCTAS()
			SELECT  Cli.ClienteID,Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
					Cue.SaldoIniMes, 	Cue.SaldoIniMes AS SaldoDispon, Decimal_Cero as SaldoGarLiq, Decimal_Cero AS SaldoTotal,
					IFNULL(Cli.EsMenorEdad,Cadena_Vacia),Tip.ClasificacionConta
				FROM `HIS-CUENTASAHO` Cue
				INNER JOIN CUENTASAHO Act
					ON Cue.CuentaAhoID = Act.CuentaAhoID
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
				WHERE Cue.Fecha = Var_FechaHistor
					AND (Cue.Estatus IN (CtaActiva, CtaBloqueada)
					OR (Cue.Estatus = CtaCancelada AND Act.FechaCan  >= Var_FechaInicio))
					AND Cue.TipoCuentaID <> 1;
		ELSE
			INSERT INTO TMPSALDOSCTAS()
			SELECT  Cli.ClienteID,Cue.CuentaAhoID, Cue.TipoCuentaID AS NumTipoCue, NULL AS NombreTipCue, Cue.SucursalID, NULL AS NombreSuc,
					Cue.SaldoIniMes, Cue.SaldoIniMes AS SaldoDispon, Decimal_Cero AS SaldoGarLiq, Decimal_Cero AS SaldoTotal,
					 IFNULL(Cli.EsMenorEdad,Cadena_Vacia),Tip.ClasificacionConta
				FROM CUENTASAHO Cue
				INNER JOIN CLIENTES Cli
					ON Cue.ClienteID = Cli.ClienteID
				INNER JOIN TIPOSCUENTAS Tip
					ON Tip.TipoCuentaID = Cue.TipoCuentaID
				WHERE (Cue.Estatus IN (CtaActiva, CtaBloqueada)
					OR (Cue.Estatus = CtaCancelada AND Cue.FechaCan  >= Var_FechaInicio))
					AND Cue.TipoCuentaID <> 1;
	END IF;

	UPDATE TMPSALDOSCTAS Cue
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cue.NumSucursal
	SET Cue.NombreSucurs = Suc.NombreSucurs;

	UPDATE TMPSALDOSCTAS Cue
		INNER JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID = Cue.NumTipCuenta
	SET Cue.TipoCuenta = Tip.Descripcion;

	UPDATE TMPSALDOSCTAS Cue
		INNER JOIN TMPSALDOSBLOQUEO Tmp ON Cue.Cuenta = Tmp.Cuenta
	SET Cue.SaldoGarLiq = Tmp.Saldo,
		Cue.SaldoDispon = Cue.SaldoDispon - Tmp.Saldo;

	UPDATE TMPSALDOSCTAS Cue
		INNER JOIN TMPSALDOSMOVIMIENTOS Tmp ON Cue.Cuenta = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

	UPDATE TMPSALDOSCTAS Cue
		INNER JOIN TMPSALDOSMOVIMIENTOSACT Tmp ON Cue.Cuenta = Tmp.Cuenta
	SET Cue.SaldoDispon = Cue.SaldoDispon + Tmp.SaldoMov;

	UPDATE TMPSALDOSCTAS
	SET SaldoTotal = SaldoDispon + SaldoGarLiq;

	SELECT SUM(SaldoTotal) INTO Var_SaldoOrdinario
	FROM TMPSALDOSCTAS
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroOrdinario;

	SET Var_SaldoOrdinario	:= IFNULL(Var_SaldoOrdinario, Decimal_Cero);


	SELECT SUM(SaldoTotal)  INTO Var_SaldoVista
	FROM TMPSALDOSCTAS
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroVista;

	SET Var_SaldoVista	:= IFNULL(Var_SaldoVista, Decimal_Cero);


	-- Tabla temporal para almacenar los saldos de Ahorro Ordinario por Socio
	DROP TABLE IF EXISTS TMPAHORRORDINARIOSOCIO;
	CREATE TEMPORARY TABLE TMPAHORRORDINARIOSOCIO(
		ClienteID      		INT(11),
		SaldoOrdinario      DECIMAL(14,2));
	INSERT INTO TMPAHORRORDINARIOSOCIO()
	SELECT ClienteID,SUM(SaldoTotal) FROM TMPSALDOSCTAS
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroOrdinario
			GROUP BY ClienteID;

	-- Tabla temporal para almacenar los saldos de Ahorro Vista por Socio
	DROP TABLE IF EXISTS TMPAHORROVISTASOCIO;
	CREATE TEMPORARY TABLE TMPAHORROVISTASOCIO(
		ClienteID      INT(11),
		SaldoVista     DECIMAL(14,2));
	INSERT INTO TMPAHORROVISTASOCIO()
	SELECT ClienteID,SUM(SaldoTotal) FROM TMPSALDOSCTAS
		WHERE EsMenor != MenorEdadSI
			AND ClasiConta = AhorroVista
			GROUP BY ClienteID;

	-- ========================================
	 -- Saldo Inversiones
	-- ========================================
	DROP TABLE IF EXISTS TMPSALDOINVERSION;
	CREATE TEMPORARY TABLE TMPSALDOINVERSION(
		ClienteID         INT(11),
		SaldoInversion    DECIMAL(14,2));

	INSERT INTO TMPSALDOINVERSION()
	SELECT ClienteID,Monto AS SaldoInversion
		FROM INVERSIONES
		WHERE FechaInicio <= Var_FechaAnterior
		  AND (Estatus = Inversion_Vigente
		   OR (Estatus = Inversion_Pagada
			AND FechaVencimiento != Fecha_Vacia
			AND FechaVencimiento > Var_FechaAnterior)
		   OR ( Estatus = Inversion_Cancelada
			AND FechaVenAnt != Var_FechaAnterior
			AND FechaVenAnt > Var_FechaAnterior));

	SELECT SUM(SaldoInversion) INTO Var_SaldoInversion
		FROM TMPSALDOINVERSION;

	SET	Var_SaldoInversion	:= IFNULL(Var_SaldoInversion,Decimal_Cero);

	-- Tabla temporal para almacenar los saldos de Inversiones por Socio
	DROP TABLE IF EXISTS TMPINVERSIONSOCIO;
	CREATE TEMPORARY TABLE TMPINVERSIONSOCIO(
			ClienteID         INT(11),
			SaldoInversion    DECIMAL(14,2));
	INSERT INTO TMPINVERSIONSOCIO()
	SELECT ClienteID,SUM(SaldoInversion)
		FROM TMPSALDOINVERSION
			GROUP BY ClienteID;

	-- Tabla temporal para almacenar los saldos de Ahorro Ordinario, Ahorro Vista e Inversiones por Socio
	DROP TABLE IF EXISTS TMPVISTAINVERSIONSOCIO;
	CREATE TEMPORARY TABLE TMPVISTAINVERSIONSOCIO(
			ClienteID          INT(11),
			SaldoOrdinario	   DECIMAL(14,2),
			SaldoVista    	   DECIMAL(14,2),
			SaldoInversion	   DECIMAL(14,2),
			SaldoTotal		   DECIMAL(14,2));
	INSERT INTO TMPVISTAINVERSIONSOCIO()
	SELECT Ord.ClienteID, IFNULL(Ord.SaldoOrdinario,Decimal_Cero), IFNULL(Aho.SaldoVista,Decimal_Cero),
		IFNULL(Inv.SaldoInversion,Decimal_Cero), Decimal_Cero
		FROM TMPAHORRORDINARIOSOCIO Ord
			INNER JOIN TMPAHORROVISTASOCIO Aho
			ON Aho.ClienteID = Ord.ClienteID
			INNER JOIN TMPINVERSIONSOCIO Inv
			ON Inv.ClienteID = Aho.ClienteID;

		UPDATE TMPVISTAINVERSIONSOCIO
			SET SaldoTotal = SaldoOrdinario + SaldoVista + SaldoInversion;

	SELECT SaldoOrdinario,SaldoVista, SaldoInversion
		   INTO Var_SalAhoOrdinSocio, Var_SalAhoVistaSocio, Var_SalInversionSocio
		FROM TMPVISTAINVERSIONSOCIO
		ORDER BY SaldoTotal DESC
		LIMIT 1;

	SET Var_SalAhoOrdinSocio	:= IFNULL(Var_SalAhoOrdinSocio, Decimal_Cero);
	SET Var_SalAhoVistaSocio	:= IFNULL(Var_SalAhoVistaSocio, Decimal_Cero);
	SET Var_SalInversionSocio	:= IFNULL(Var_SalInversionSocio, Decimal_Cero);
    -- ========================================================================
	SET Var_MontoCaptado        := Var_AhoOrdinarioSocio + Var_AhoVistaSocio + Var_InversionSocio;
	SET Var_MontoCaptado        := IFNULL(Var_MontoCaptado,Decimal_Cero);

    SET Var_PorcentSumAhoInv  	:= (CASE WHEN Var_CapitalNeto = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoCaptado / Var_CapitalNeto) END)*100;
	SET	Var_PorcentSumAhoInv	:= IFNULL(Var_PorcentSumAhoInv,Decimal_Cero);

	SET Var_DifLimiteSumAhoInv	:= Var_PorcSumAhoInv - Var_PorcentSumAhoInv;
	SET	Var_DifLimiteSumAhoInv	:= IFNULL(Var_DifLimiteSumAhoInv,Decimal_Cero);

    SET Var_SaldoCaptado     	:= Var_SalAhoOrdinSocio + Var_SalAhoVistaSocio +  Var_SalInversionSocio;
	SET	Var_SaldoCaptado	 	:= IFNULL(Var_SaldoCaptado,Decimal_Cero);

	SET Var_PorcentualSaldo  	:= (CASE WHEN Var_CapitalNeto = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldoCaptado / Var_CapitalNeto) END)*100;
	SET	Var_PorcentualSaldo	 	:= IFNULL(Var_PorcentualSaldo,Decimal_Cero);

	SET Var_DifLimiteSaldo	 	:= Var_PorcSumAhoInv - Var_PorcentualSaldo;
	SET	Var_DifLimiteSaldo	 	:= IFNULL(Var_DifLimiteSaldo,Decimal_Cero);

     SELECT FORMAT(Var_MontoCaptado,2) AS Var_MontoCaptado,			Var_MontoCaptado AS Var_MontoCaptadoExc,
		FORMAT(Var_AhoOrdinarioSocio,2) AS Var_AhoOrdinarioSocio, 	Var_AhoOrdinarioSocio AS Var_AhoOrdinarioSocioExc,
		FORMAT(Var_AhoVistaSocio,2) AS Var_AhoVistaSocio,  			Var_AhoVistaSocio AS Var_AhoVistaSocioExc,
		Var_InversionSocio,				Var_PorcentSumAhoInv, 		Var_PorcSumAhoInv,
        Var_DifLimiteSumAhoInv, 		Var_SaldoCaptado,			Var_SalAhoOrdinSocio,
        Var_SalAhoVistaSocio,			Var_SalInversionSocio,		Var_PorcentualSaldo,
        Var_DifLimiteSaldo,				Var_CapitalNeto;

END TerminaStore$$