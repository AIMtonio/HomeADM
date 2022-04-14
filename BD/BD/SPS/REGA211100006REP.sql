-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA211100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA211100006REP`;
DELIMITER $$

CREATE PROCEDURE `REGA211100006REP`(
-- ---------------------------------------------------------------------------------
-- Genera el Reporte A2111 - Capital por Riesgos - SOCAP
-- ---------------------------------------------------------------------------------
	Par_Anio           		INT,				-- Ano
	Par_Mes					INT,				-- Mes
	Par_NumRep				TINYINT UNSIGNED, 	-- Numero de Reporte

    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion		BIGINT(20) 			-- Auditoria
)
TerminaStore:BEGIN


DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio
DECLARE Var_FechaFin				DATE;			-- Fecha de Fin
DECLARE Var_ReporteID				VARCHAR(10);	-- Numero del reporte
DECLARE Var_ClaveEntidad			VARCHAR(300);	-- Clave de la entidad
DECLARE Var_EjercicioVig			INT;			-- Ejercicio vigente
DECLARE Var_PeriodoVig				INT;			-- Periodo vigente
DECLARE Var_EjercicioID				INT;			-- Numero de ejercicio
DECLARE Var_PeriodoID				INT;			-- Numero de periodo
DECLARE Var_FechInicio				DATE;			-- Fecha de Inicio
DECLARE Var_FechFin					DATE;			-- Fecha de Fin
DECLARE Var_FechaCorte				DATE;			-- Fecha de corte
DECLARE Var_FormulaCreditos			VARCHAR(2000);	-- Formula de creditos
DECLARE Var_FormulaDepositos		VARCHAR(2000);	-- Formula depositos
DECLARE Var_FormulaCapital			VARCHAR(200);	-- Formula de capital
DECLARE Var_SaldosCreditos			DECIMAL(18,4);	-- Saldos de los creditos
DECLARE Var_SaldosDepositos			DECIMAL(18,4);	-- Saldos de depositos
DECLARE Var_SaldosCapital			DECIMAL(18,4);	-- Saldos de Capital
DECLARE Var_CCInicial				INT;			-- Centro de Costos Inicial
DECLARE Var_CCFinal					INT;			-- Centro de Costos final
DECLARE Var_FechaCorteMax			DATE;			-- Fecha de corte maximo
DECLARE Var_NatMovimiento			CHAR(1);		-- Naturaleza de movimiento
DECLARE Var_TiposBloqID				INT(4);			-- Tipos de bloqueos
DECLARE Var_CapitalNeto				DECIMAL(14,4);	-- Capital Neto
DECLARE Var_Grupo3					DECIMAL(14,4);	-- Grupo 3
DECLARE Var_Grupo2					DECIMAL(14,4);  -- Grupo 2
DECLARE Var_Grupo1					DECIMAL(14,4); 	-- Grupo 1
DECLARE Var_Grupo6					DECIMAL(14,4);	-- Grupo 6


DECLARE Var_CatCartera					DECIMAL(16,2);	-- Cartera
DECLARE Var_CatEstimacion				DECIMAL(16,2);	-- Estimacion
DECLARE Var_InvValores					DECIMAL(16,2);	-- Inversiones en valores
DECLARE Var_CatCaja 					DECIMAL(16,2);	-- Caja
DECLARE Var_CatDepValCre				DECIMAL(16,2);	-- Depositos creditos
DECLARE Var_CatCreActivos				DECIMAL(16,2);	-- Activos credito
DECLARE Var_CatCapContable				DECIMAL(16,2);	-- Capital contable
DECLARE Var_CatGastosOtros				DECIMAL(16,2);	-- Otros gastos
DECLARE Var_CatImpDifActi				DECIMAL(16,2);	-- Activos diferidos
DECLARE Var_CatOtrosIntan				DECIMAL(16,2);	-- Otros intangibles
DECLARE Var_CatPrestaLiqui				DECIMAL(16,2);	-- Prestamos de liquidez


DECLARE Var_GarantiaLiq				DECIMAL(14,4);  	-- Garantia liquida
DECLARE Var_ReqRiesgoCredito		DECIMAL(14,4);		-- Requerimiento por riesgo de credito
DECLARE Var_ReqTotalCapital			DECIMAL(14,4);		-- Requerimientos total de capital
DECLARE Var_ReqCapitalMercado		DECIMAL(14,4);	 	-- Requerimientos por mercado
DECLARE Var_SaldosAcumCred			DECIMAL(14,4);	 	-- Saldos acumulados de creditos
DECLARE Var_FormulaCartera			VARCHAR(100);		-- Formula de cartera
DECLARE Var_Cartera					DECIMAL(14,4);		-- Cartera
DECLARE Var_FormulaGastosInt		VARCHAR(100);		-- Formula de gastos por intereses
DECLARE Var_GastosInt				DECIMAL(18,4);		-- Otros Gastos
DECLARE Var_FormulaOtroInt			VARCHAR(100);		-- Otros intereses
DECLARE Var_OtroInt					DECIMAL(18,4);		-- Otros

DECLARE Rep_Excel				INT(1);					-- Reporte en excel
DECLARE Rep_Csv					INT(1);					-- Reporte en csv
DECLARE Entero_Cero				INT(2);					-- Entero cero
DECLARE Decimal_Cero			DECIMAL(4,2);			-- DECIMAL cero
DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
DECLARE Fecha_Vacia				DATE;					-- Fecha vacia
DECLARE Str_Tabulador			VARCHAR(20);			-- Tabulador
DECLARE Estatus_Pagado 			CHAR(1);				-- Pagado
DECLARE Estatus_Vigente			CHAR(1);				-- vigente
DECLARE Estatus_Activo			CHAR(1);				-- activo
DECLARE Estatus_Cancelado		CHAR(1);				-- cancelado
DECLARE Estatus_NoCerrado		CHAR(1);				-- no cerrado
DECLARE ValorFijo1				CHAR(10);				-- fijo 1
DECLARE ValorFijo2				CHAR(10);				-- fijo 2
DECLARE ValorFijo3				CHAR(10);				-- fijo 3
DECLARE VarDeudora				CHAR(1);				-- naturaleza deudora
DECLARE VarAcreedora			CHAR(1);				-- naturaleza acreedora
DECLARE SaldosActuales			CHAR(1);				-- Saldos actuales
DECLARE SaldosHistorico			CHAR(1);				-- Saldos historicos
DECLARE PorFecha				CHAR(1);				-- por fecha
DECLARE Credito_Vigente			CHAR(1);				-- credito vigente
DECLARE Credito_Vencido			CHAR(1);				-- credito vencido
DECLARE Version_2015			INT;					-- Version del reporte
DECLARE Registro_ID				INT(1);				-- Numero de registro


SET Rep_Excel			:= 1;
SET Rep_Csv				:= 2;
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Estatus_Pagado		:= 'P';
SET Estatus_Vigente		:= 'N';
SET Estatus_Activo		:= 'A';
SET Estatus_Cancelado	:= 'C';
SET Estatus_NoCerrado	:= 'N';
SET  ValorFijo2			:= '2111';
SET  ValorFijo3			:= '152';
SET VarDeudora      	:= 'D';
SET VarAcreedora   		:= 'A';
SET SaldosActuales		:= 'A';
SET SaldosHistorico		:= 'H';
SET PorFecha			:= 'F';
SET Credito_Vigente		:= 'V';
SET Credito_Vencido		:= 'B';
SET Version_2015		:= 2015;
SET Registro_ID			:= 1;

SET Var_ReporteID		:= 'A2111';
SET Var_NatMovimiento	:= 'B';
SET Var_TiposBloqID		:= 8;


SELECT Cat.CodigoOpcion INTO ValorFijo1
FROM CATNIVELENTIDADREG Cat,PARAMREGULATORIOS Par
WHERE Cat.NivelOperacionID = Par.NivelOperaciones
AND Cat.NivelPrudencialID = Par.NivelPrudencial;

SELECT ClaveEntidad
INTO Var_ClaveEntidad
FROM PARAMREGULATORIOS
WHERE ParametrosID = Registro_ID;

SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_FormulaDepositos := (SELECT CuentaContable FROM CONCEPTOSREGREP Con WHERE ConceptoID = 72 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);
SET Var_FormulaCreditos := (SELECT CuentaContable FROM CONCEPTOSREGREP  Con  WHERE ConceptoID = 79 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);
SET Var_FormulaCapital	:= (SELECT CuentaContable FROM CONCEPTOSREGREP Con  WHERE ConceptoID = 85 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);
SET Var_FechaCorteMax	:= (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= Var_FechaFin);
SET Var_FormulaCartera	:= (SELECT CuentaContable FROM CONCEPTOSREGREP Con  WHERE ConceptoID = 50 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);
SET Var_FormulaGastosInt:= (SELECT CuentaContable FROM CONCEPTOSREGREP Con  WHERE ConceptoID = 93 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);
SET Var_FormulaOtroInt	:= (SELECT CuentaContable FROM CONCEPTOSREGREP Con  WHERE ConceptoID = 95 AND  Con.ReporteID = Var_ReporteID AND  Con.ReporteID = Var_ReporteID AND Con.Version = 2015);



SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1	INTO
		Var_FechaSistema,					Var_EjercicioVig,							Var_PeriodoVig;


SELECT MIN(CentroCostoID), 	MAX(CentroCostoID) INTO
		Var_CCInicial, 		Var_CCFinal
	FROM CENTROCOSTOS;


DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;


DROP TABLE IF EXISTS TMPREGULATORIOA2111;
CREATE TEMPORARY TABLE TMPREGULATORIOA2111(
	TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
    ConceptoID      INT(11),
    Saldo			DECIMAL(18,4),
    Indicador		DECIMAL(18,4),
	ClaveEntidad	VARCHAR(300),
	ValorFijo1		CHAR(10),
	ValorFijo2		CHAR(10),
	ValorFijo3		CHAR(10),
	Naturaleza		CHAR(1),
	SaldoDeudor		DECIMAL(18,2),
	SaldoAcreedor	DECIMAL(18,2),
	CuentaCNBV		VARCHAR(40)
);



SELECT 	Inicio, 			Fin
	FROM PERIODOCONTABLE
	WHERE EjercicioID	= Var_EjercicioVig
		AND PeriodoID	= Var_PeriodoVig
		AND Estatus 	= Estatus_NoCerrado
INTO    Var_FechInicio,	    Var_FechFin;


SELECT  EjercicioID, 		PeriodoID, 		Inicio, 			Fin INTO
		Var_EjercicioID, 	Var_PeriodoID, 	Var_FechInicio, 	Var_FechFin
	FROM PERIODOCONTABLE
	WHERE Inicio	<= Var_FechFin
	  AND Fin		>= Var_FechFin;

IF (IFNULL(Var_EjercicioID, Entero_Cero) = Entero_Cero) THEN
	SELECT	MAX(EjercicioID),	 MAX(PeriodoID), 	MAX(Inicio), 		MAX(Fin) INTO
			Var_EjercicioID, 	Var_PeriodoID, 		Var_FechInicio, 	Var_FechFin
		FROM PERIODOCONTABLE
		WHERE Fin	<= Var_FechFin;
END IF;


IF(Var_FechaFin >= IFNULL(Var_FechFin,Fecha_Vacia))THEN

		INSERT INTO TMPCONTABLEBALANCE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
								Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
		SELECT 				 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
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
			 LEFT OUTER JOIN DETALLEPOLIZA   Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta	AND Pol.Fecha <= Var_FechaFin)
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



			UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal SET
				Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
				Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
			WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
			  AND Tmp.NumeroTransaccion = Sal.NumeroTransaccion
			  AND Sal.CuentaContable 	= Tmp.CuentaContable;
		END IF;





		CALL EVALFORMULAREGPRO(Var_SaldosDepositos,			Var_FormulaDepositos,	SaldosActuales,		PorFecha, 			Var_FechFin);

		SET Var_FormulaCreditos:= "1301%+1311%+1316%+1351%+136%+139%";
		CALL EVALFORMULAREGPRO(Var_SaldosCreditos,			Var_FormulaCreditos,	SaldosActuales,		PorFecha, 			Var_FechFin);
		SET Var_SaldosAcumCred	:= Var_SaldosCreditos;


		CALL EVALFORMULAREGPRO(Var_SaldosCapital,			Var_FormulaCapital,		SaldosActuales,		PorFecha, 			Var_FechFin);

        CALL EVALFORMULAREGPRO(Var_Cartera,			Var_FormulaCartera,	SaldosActuales,		PorFecha, 			Var_FechFin);

        CALL EVALFORMULAREGPRO(Var_GastosInt,			Var_FormulaGastosInt,	SaldosActuales,		PorFecha, 			Var_FechFin);

        CALL EVALFORMULAREGPRO(Var_OtroInt,			Var_FormulaOtroInt,	SaldosActuales,		PorFecha, 			Var_FechFin);


ELSE


		SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte <= Var_FechaFin);

		INSERT INTO TMPCONTABLEBALANCE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
								SaldoDeudor,				SaldoAcreedor)
		SELECT 				 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
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



		CALL EVALFORMULAREGPRO(Var_SaldosDepositos,			Var_FormulaDepositos,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);

		SET Var_FormulaCreditos:= "1301%+1311%+1316%+1351%+136%+139%";
		CALL EVALFORMULAREGPRO(Var_SaldosCreditos,			Var_FormulaCreditos,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
		SET Var_SaldosAcumCred	:= Var_SaldosCreditos;


		CALL EVALFORMULAREGPRO(Var_SaldosCapital,			Var_FormulaCapital,		SaldosActuales,		PorFecha, 			Var_FechaCorte);

        CALL EVALFORMULAREGPRO(Var_Cartera,			Var_FormulaCartera,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);

        CALL EVALFORMULAREGPRO(Var_GastosInt,			Var_FormulaGastosInt,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);

        CALL EVALFORMULAREGPRO(Var_OtroInt,			Var_FormulaOtroInt,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);


END IF;




DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
INSERT INTO TMPREGCREDITOS (NumTransaccion,		CreditoID,		Monto)
SELECT	Aud_NumTransaccion,	S.CreditoID,
		(S.SalCapVigente+S.SalCapAtrasado+S.SalCapVencido+S.SalCapVenNoExi+S.SalIntOrdinario+S.SalIntProvision+S.SalIntAtrasado+S.SalMoratorios+S.SalIntVencido+S.SaldoMoraVencido)
	FROM SALDOSCREDITOS S,
		CALRESCREDITOS	C
	WHERE CONVERT(S.FechaCorte,DATE) = Var_FechaCorteMax
		AND S.FechaCorte= C.Fecha
		AND S.CreditoID	= C.CreditoID
		AND S.EstatusCredito IN (Credito_Vigente,Credito_Vencido);



DROP TABLE IF EXISTS TMPCREDITOINVGAR2;
CREATE TEMPORARY TABLE TMPCREDITOINVGAR2
SELECT SUM(T.MontoEnGar) AS MontoEnGar , T.CreditoID
	FROM TMPREGCREDITOS		F,
		 CREDITOINVGAR	T
	WHERE	F.CreditoID		=	T.CreditoID
		AND FechaAsignaGar <= Var_FechaFin
AND F.NumTransaccion = Aud_NumTransaccion
	GROUP BY T.CreditoID;


UPDATE	TMPREGCREDITOS	Tmp,
		TMPCREDITOINVGAR2	Gar	SET
	Tmp.GarantiaLiq =	Gar.MontoEnGar
WHERE  Gar.CreditoID = Tmp.CreditoID
AND Tmp.NumTransaccion = Aud_NumTransaccion;



DROP TABLE IF EXISTS TMPHISCREDITOINVGAR2;
CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR2
SELECT SUM(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
	FROM TMPREGCREDITOS		Tmp,
		 HISCREDITOINVGAR	Gar
	WHERE	Gar.Fecha > Var_FechaFin
	  AND	Gar.FechaAsignaGar <= Var_FechaFin
	  AND	Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
	  AND	Gar.CreditoID = Tmp.CreditoID
	  AND Tmp.NumTransaccion = Aud_NumTransaccion
	GROUP BY Gar.CreditoID;



UPDATE	TMPREGCREDITOS		Tmp,
		TMPHISCREDITOINVGAR2	Gar
	SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) + Gar.MontoEnGar
	WHERE	Gar.CreditoID = Tmp.CreditoID
	  AND	Tmp.NumTransaccion = Aud_NumTransaccion;

DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
CREATE temporary TABLE TMPMONTOGARCUENTAS (
SELECT Blo.Referencia,	SUM(CASE WHEN Blo.NatMovimiento = Var_NatMovimiento
				THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
			 ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
		END) AS MontoEnGar
	FROM	BLOQUEOS 		Blo,
			TMPREGCREDITOS Tmp
		WHERE DATE(Blo.FechaMov) <= Var_FechaFin
			AND Blo.TiposBloqID = Var_TiposBloqID
			AND Blo.Referencia  = Tmp.CreditoID
			AND	Tmp.NumTransaccion = Aud_NumTransaccion
	 GROUP BY Blo.Referencia);



UPDATE	TMPREGCREDITOS 		Tmp,
		TMPMONTOGARCUENTAS 	Blo
	SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) +MontoEnGar
WHERE Blo.Referencia  = Tmp.CreditoID
AND Tmp.NumTransaccion = Aud_NumTransaccion;
DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;




	INSERT INTO TMPREGULATORIOA2111 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
									 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)
	SELECT 							 ConceptoID,		Var_ClaveEntidad,	ValorFijo1,			ValorFijo2,			ValorFijo3,
									 MIN(CuentaCNBV),		MAX(Tmp.Naturaleza),
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
    AND   Con.Version = Version_2015
	GROUP BY Con.CuentaContable, Con.ConceptoID
	ORDER BY Con.ConceptoID;


	UPDATE TMPREGULATORIOA2111	SET Saldo = (SELECT SUM(IFNULL(GarantiaLiq,Decimal_Cero)  )
												FROM TMPREGCREDITOS
												WHERE NumTransaccion = Aud_NumTransaccion)
	WHERE ConceptoID = 81;


	SET Var_SaldosDepositos	:= IFNULL(Var_SaldosDepositos, Decimal_Cero);
	SET Var_SaldosCreditos	:= IFNULL(Var_SaldosCreditos, Decimal_Cero);
	SET Var_SaldosCapital	:= IFNULL(Var_SaldosCapital, Decimal_Cero);
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_SaldosDepositos WHERE ConceptoID = 72;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_SaldosCreditos  WHERE ConceptoID = 79;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_SaldosCapital  WHERE ConceptoID = 85;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Cartera  WHERE ConceptoID = 50;

    UPDATE TMPREGULATORIOA2111	SET Saldo = Var_GastosInt  WHERE ConceptoID = 93;
    UPDATE TMPREGULATORIOA2111	SET Saldo = Var_OtroInt  WHERE ConceptoID = 95;



	UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Naturaleza = VarDeudora
							THEN SaldoDeudor
						 WHEN Naturaleza = VarAcreedora
							THEN SaldoAcreedor
						 ELSE Saldo
					END;


    UPDATE TMPREGULATORIOA2111	SET Saldo = ABS(Saldo)  WHERE ConceptoID = 51;

	/* ====================== Calculo de saldos e indicadores =========================================== */
    SET ValorFijo3		:= '153';
	UPDATE TMPREGULATORIOA2111 SET ValorFijo3 = ValorFijo3 WHERE ConceptoID BETWEEN 35 AND 37;

	SET Var_CapitalNeto := (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN (85, 86, 87));
	SET Var_CapitalNeto := IFNULL(Var_CapitalNeto, Decimal_Cero) - IFNULL((SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN (93, 94, 95, 96, 98)), Decimal_Cero);
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_CapitalNeto WHERE ConceptoID = 83;

	SET Var_GarantiaLiq	:= (SELECT Saldo FROM TMPREGULATORIOA2111 WHERE ConceptoID = 81);
	SET Var_Grupo3		:= (SELECT (IFNULL(Saldo, Decimal_Cero) + Var_SaldosCreditos) - (IFNULL(Var_GarantiaLiq, Decimal_Cero) * 1)  FROM TMPREGULATORIOA2111 WHERE ConceptoID = 80);
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo3 WHERE ConceptoID = 78;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo3 * 1 WHERE ConceptoID = 77;

	SET Var_Grupo2		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN (72,73,74,75,76));
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo2 WHERE ConceptoID = 71;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo2 * 0.2 WHERE ConceptoID = 70;

	SET Var_Grupo1		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN(65,66,67,68,69));
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo1 WHERE ConceptoID = 64;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo1 * 0 WHERE ConceptoID = 63;

	SET Var_ReqRiesgoCredito	:= ((Var_Grupo1 * 0) + (Var_Grupo2 * 0.2) + (Var_Grupo3 * 1));
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_ReqRiesgoCredito WHERE ConceptoID = 62;
	SET Var_ReqRiesgoCredito	:= Var_ReqRiesgoCredito * 0.08;
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_ReqRiesgoCredito WHERE ConceptoID IN (61, 41);


    SET Var_Grupo6 				:=  (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN(50,51,52));
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo6 WHERE ConceptoID = 49;
    UPDATE TMPREGULATORIOA2111	SET Saldo = (Var_Grupo6 * 0.01) WHERE ConceptoID = 47;

    SET Var_Grupo6 				:=  (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN(47));
    UPDATE TMPREGULATORIOA2111	SET Saldo = Var_Grupo6  WHERE ConceptoID IN (40);


	SET Var_ReqTotalCapital		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2111 WHERE ConceptoID IN(40,41,42));
	UPDATE TMPREGULATORIOA2111	SET Saldo = Var_ReqTotalCapital WHERE ConceptoID = 39;

	UPDATE TMPREGULATORIOA2111	SET Indicador = (Var_CapitalNeto / Var_ReqTotalCapital) * 100 WHERE ConceptoID = 35;

	SET Var_ReqRiesgoCredito	:= ((Var_Grupo1 * 0) + (Var_Grupo2 * 0.2) + (Var_Grupo3 * 1));
	UPDATE TMPREGULATORIOA2111	SET Indicador = (Var_CapitalNeto / Var_ReqRiesgoCredito) * 100 WHERE ConceptoID = 36;

	SET Var_ReqCapitalMercado	:= (SELECT IFNULL(Saldo, Decimal_Cero) FROM TMPREGULATORIOA2111 WHERE ConceptoID = 40);
	UPDATE TMPREGULATORIOA2111	SET Indicador = Var_CapitalNeto / (Var_ReqCapitalMercado + Var_ReqRiesgoCredito) * 100 WHERE ConceptoID = 37;

IF(Par_NumRep = Rep_Excel) THEN
	SELECT Con.Descripcion,							Con.FormulaSaldo,				Con.FormulaIndicador,     	   Con.ColorCeldaSaldo,			Con.ColorCeldaIndicador,
		   IFNULL(Tmp.Saldo, Decimal_Cero) 			AS Saldo,
		   IFNULL(Tmp.Indicador , Decimal_Cero) 	AS Indicador,
		   Con.SaldoEsNegrita,						Con.IndicadorEsNegrita,			Tmp.ClaveEntidad,				Con.CuentaCNBV,
		   Tmp.ValorFijo1,							Tmp.ValorFijo2,					Tmp.ValorFijo3
		FROM TMPREGULATORIOA2111 Tmp,
			 CONCEPTOSREGREP Con
		WHERE Tmp.ConceptoID = Con.ConceptoID
		 AND  Con.ReporteID = Var_ReporteID
         AND Con.Version = Version_2015;
END IF;

IF(Par_NumRep = Rep_Csv) THEN

	SELECT
		CONCAT(Tmp.ValorFijo1,';', Con.CuentaCNBV,';', Tmp.ValorFijo2,';', Tmp.ValorFijo3,';',
				ROUND(IFNULL(Tmp.Saldo, Decimal_Cero), Entero_Cero),';',
				CASE  WHEN IFNULL(Tmp.Indicador,Decimal_Cero) > Decimal_Cero THEN ROUND(Tmp.Indicador ,4)
					ELSE Entero_Cero END
		) AS Valor
		FROM TMPREGULATORIOA2111 Tmp,
			 CONCEPTOSREGREP Con
		WHERE Tmp.ConceptoID = Con.ConceptoID
			AND  Con.ReporteID = Var_ReporteID
			AND Tmp.CuentaCNBV != Cadena_Vacia
            AND Con.Version = Version_2015;


END IF;


	DROP TEMPORARY TABLE TMPREGULATORIOA2111;
	DELETE	FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
	DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$