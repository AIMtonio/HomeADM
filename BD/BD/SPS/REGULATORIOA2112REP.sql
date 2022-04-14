-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOA2112REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOA2112REP`;
DELIMITER $$

CREATE PROCEDURE `REGULATORIOA2112REP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE A2112 -----------------------------------------
# ============================================================================================================
	Par_Anio           		INT,				# Año de que se va hacer el reporte
	Par_Mes					INT,				# Mes del cual se va hacer el reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Tipo de reporte 1: Excel 2: CSV

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN

-- Declaracion de Variables
	DECLARE Var_FechaSistema			DATE;			-- Fecha del sistema
	DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio del periodo del reporte
	DECLARE Var_FechaFin				DATE;			-- Fecha fin del periodo del reporte
	DECLARE Var_ReporteID				VARCHAR(10);
	DECLARE Var_ClaveEntidad			VARCHAR(300);
	DECLARE Var_EjercicioVig			INT;
	DECLARE Var_PeriodoVig				INT;
	DECLARE Var_EjercicioID				INT;
	DECLARE Var_PeriodoID				INT;
	DECLARE Var_FechInicio				DATE;
	DECLARE Var_FechFin					DATE;
	DECLARE Var_FechaCorte				DATE;
	DECLARE Var_FormulaCreditos			VARCHAR(2000);
	DECLARE Var_FormulaDepositos		VARCHAR(2000);
	DECLARE Var_FormulaCapital			VARCHAR(2000);
	DECLARE Var_SaldosCreditos			DECIMAL(18,4);
	DECLARE Var_SaldosDepositos			DECIMAL(18,4);
	DECLARE Var_SaldosCapital			DECIMAL(18,4);
	DECLARE Var_CCInicial				INT;
	DECLARE Var_CCFinal					INT;
	DECLARE Var_FechaCorteMax			DATE;
	DECLARE Var_NatMovimiento			CHAR(1);
	DECLARE Var_TiposBloqID				INT(4);
	DECLARE Var_CapitalNeto				DECIMAL(14,4);
	DECLARE Var_Grupo3					DECIMAL(14,4);
	DECLARE Var_Grupo2					DECIMAL(14,4);
	DECLARE Var_Grupo1					DECIMAL(14,4);
	DECLARE Var_GarantiaLiq				DECIMAL(14,4);
	DECLARE Var_ReqRiesgoCredito		DECIMAL(14,4);
	DECLARE Var_ActPonRie				DECIMAL(14,4);
	DECLARE Var_ReqCapital				DECIMAL(14,4);
	DECLARE Var_ReqTotalCapital			DECIMAL(14,4);
	DECLARE Var_ReqCapitalMercado		DECIMAL(14,4);
	DECLARE Var_SaldosAcumCred			DECIMAL(14,4);
    DECLARE	Var_Cuenta22				VARCHAR(20);
    DECLARE	Var_Cuenta51				VARCHAR(20);

-- Declaracion de constantes
	DECLARE Rep_Excel				INT(1);
	DECLARE Rep_Csv					INT(1);
	DECLARE Entero_Cero				INT(2);
	DECLARE Decimal_Cero			DECIMAL(4,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Str_Tabulador			VARCHAR(20);
	DECLARE Estatus_Pagado 			CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Estatus_Cancelado		CHAR(1);
	DECLARE Estatus_NoCerrado		CHAR(1);
	DECLARE CatCapitalizacion		CHAR(10);
	DECLARE ValorFijo1				CHAR(10);
	DECLARE ValorFijo2				CHAR(10);
	DECLARE ValorFijo3				CHAR(10);
	DECLARE VarDeudora				CHAR(1);
	DECLARE VarAcreedora			CHAR(1);
	DECLARE SaldosActuales			CHAR(1);
	DECLARE SaldosHistorico			CHAR(1);
	DECLARE PorFecha				CHAR(1);
	DECLARE Credito_Vigente			CHAR(1);
	DECLARE Credito_Vencido			CHAR(1);

	-- Asignacion de Constantes
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
	SET  CatCapitalizacion	:= '1';

	SET  ValorFijo2			:= '2112';
	SET  ValorFijo3			:= '2103';
	SET VarDeudora      	:= 'D';
	SET VarAcreedora   		:= 'A';
	SET SaldosActuales		:= 'A';
	SET SaldosHistorico		:= 'H';
	SET PorFecha			:= 'F';
	SET Credito_Vigente		:= 'V';
	SET Credito_Vencido		:= 'B';


	SET Var_ReporteID		:= 'A2112';
	SET Var_NatMovimiento	:= 'B';
	SET Var_TiposBloqID		:= 8;
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
	SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
	SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);
	SET Var_FormulaDepositos := (SELECT CuentaContable FROM CONCEPTOSREGREP Con WHERE ConceptoID = 42 and  Con.ReporteID = Var_ReporteID );
	SET Var_FormulaCreditos := (SELECT CuentaContable FROM CONCEPTOSREGREP  Con  WHERE ConceptoID = 49 and  Con.ReporteID = Var_ReporteID );
	SET Var_FormulaCapital	:= (SELECT CuentaContable FROM CONCEPTOSREGREP Con  WHERE ConceptoID = 55 and  Con.ReporteID = Var_ReporteID );
	SET Var_FechaCorteMax	:= (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= Var_FechaFin);

	-- Modificada posicion
	SET Var_SaldosDepositos	:= IFNULL(Var_SaldosDepositos, Decimal_Cero);
	SET Var_SaldosCreditos	:= IFNULL(Var_SaldosCreditos, Decimal_Cero);
	SET Var_SaldosCapital	:= IFNULL(Var_SaldosCapital, Decimal_Cero);

    SELECT IFNULL(ClaveNivInstitucion, Cadena_Vacia) INTO ValorFijo1 FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1	INTO
			Var_FechaSistema,					Var_EjercicioVig,							Var_PeriodoVig;


	SELECT MIN(CentroCostoID), 	MAX(CentroCostoID) INTO
			Var_CCInicial, 		Var_CCFinal
		from CENTROCOSTOS;


	DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;


	DROP TABLE IF EXISTS TMPREGULATORIOA2112;
	CREATE TEMPORARY TABLE TMPREGULATORIOA2112(
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


	IF (IFNULL(Var_EjercicioID, Entero_Cero) = Entero_Cero) then
		SELECT	MAX(EjercicioID),	 MAX(PeriodoID), 	MAX(Inicio), 		MAX(Fin) into
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
				 left outer join DETALLEPOLIZA   Pol on (Cue.CuentaCompleta = Pol.CuentaCompleta	AND Pol.Fecha <= Var_FechaFin)
			GROUP BY Cue.CuentaCompleta;


			SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte < Var_FechaFin);

			IF(IFNULL(Var_FechaCorte, Fecha_Vacia) != Fecha_Vacia)THEN
				delete from TMPSALDOCONTABLE where NumeroTransaccion  = Aud_NumTransaccion;
				insert into TMPSALDOCONTABLE
				select	Aud_NumTransaccion,	Sal.CuentaCompleta, sum(CASE WHEN Tmp.Naturaleza = VarDeudora  THEN
												Sal.SaldoFinal
											ELSE
												Entero_Cero
										END) as SaldoInicialDeudor,
						sum(CASE WHEN Tmp.Naturaleza = VarAcreedora  THEN
												Sal.SaldoFinal
											ELSE
												Entero_Cero
										END) as SaldoInicialAcreedor

					from	TMPCONTABLEBALANCE Tmp,
							SALDOSCONTABLES Sal
					where Tmp.NumeroTransaccion = Aud_NumTransaccion
					  and Sal.CuentaCompleta	= Tmp.CuentaContable
					  and Sal.FechaCorte	= Var_FechaCorte
					group by Sal.CuentaCompleta ;



				UPDATE TMPCONTABLEBALANCE Tmp, TMPSALDOCONTABLE Sal SET
					Tmp.SaldoInicialDeu =  Sal.SaldoInicialDeu,
					Tmp.SaldoInicialAcr = Sal.SaldoInicialAcr
				WHERE Tmp.NumeroTransaccion = Aud_NumTransaccion
				  and Tmp.NumeroTransaccion = Sal.NumeroTransaccion
				  AND Sal.CuentaContable 	= Tmp.CuentaContable;
			END IF;


			CALL EVALFORMULAREGPRO(Var_SaldosDepositos,			Var_FormulaDepositos,	SaldosActuales,		PorFecha, 			Var_FechFin);

			SET Var_FormulaCreditos := (SELECT CuentaContable FROM CONCEPTOSREGREP Con WHERE ConceptoID =49 and  Con.ReporteID = Var_ReporteID );
			CALL EVALFORMULAREGPRO(Var_SaldosCreditos,			Var_FormulaCreditos,	SaldosActuales,		PorFecha, 			Var_FechFin);


			CALL EVALFORMULAREGPRO(Var_SaldosCapital,			Var_FormulaCapital,		SaldosHistorico,		PorFecha, 			Var_FechFin);

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

			SET Var_FormulaCreditos := (SELECT CuentaContable FROM CONCEPTOSREGREP Con WHERE ConceptoID =49 and  Con.ReporteID = Var_ReporteID );
			CALL EVALFORMULAREGPRO(Var_SaldosCreditos,			Var_FormulaCreditos,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);


			CALL EVALFORMULAREGPRO(Var_SaldosCapital,			Var_FormulaCapital,		SaldosHistorico,		PorFecha, 			Var_FechaCorte);

	END IF;


	DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
	INSERT INTO TMPREGCREDITOS (NumTransaccion,		CreditoID,		Monto)
	SELECT	Aud_NumTransaccion,	S.CreditoID,
			(S.SalCapVigente+S.SalCapAtrasado+S.SalCapVencido+S.SalCapVenNoExi+S.SalIntOrdinario+S.SalIntProvision+S.SalIntAtrasado+S.SalMoratorios+S.SalIntVencido+S.SaldoMoraVencido)
		FROM SALDOSCREDITOS S,
			CALRESCREDITOS	C
		WHERE convert(S.FechaCorte,date) = Var_FechaCorteMax
			and S.FechaCorte= C.Fecha
			and S.CreditoID	= C.CreditoID
			AND S.EstatusCredito IN (Credito_Vigente,Credito_Vencido);



	drop table if exists TMPCREDITOINVGAR2;
	CREATE TEMPORARY TABLE TMPCREDITOINVGAR2
	SELECT sum(T.MontoEnGar) AS MontoEnGar , T.CreditoID
		FROM TMPREGCREDITOS		F,
			 CREDITOINVGAR	T
		where	F.CreditoID		=	T.CreditoID
			and FechaAsignaGar <= Var_FechaFin
	and F.NumTransaccion = Aud_NumTransaccion
		GROUP BY T.CreditoID;


	UPDATE	TMPREGCREDITOS	Tmp,
			TMPCREDITOINVGAR2	Gar	SET
		Tmp.GarantiaLiq =	Gar.MontoEnGar
	WHERE  Gar.CreditoID = Tmp.CreditoID
	and Tmp.NumTransaccion = Aud_NumTransaccion;



	drop table if exists TMPHISCREDITOINVGAR2;
	CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR2
	SELECT sum(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
		FROM TMPREGCREDITOS		Tmp,
			 HISCREDITOINVGAR	Gar
		WHERE	Gar.Fecha > Var_FechaFin
		  and	Gar.FechaAsignaGar <= Var_FechaFin
		  and	Gar.ProgramaID not in ('CIERREGENERALPRO')
		  and	Gar.CreditoID = Tmp.CreditoID
		  and Tmp.NumTransaccion = Aud_NumTransaccion
		GROUP BY Gar.CreditoID;

	UPDATE	TMPREGCREDITOS		Tmp,
			TMPHISCREDITOINVGAR2	Gar
		SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) + Gar.MontoEnGar
		WHERE	Gar.CreditoID = Tmp.CreditoID
		  and	Tmp.NumTransaccion = Aud_NumTransaccion;

	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
	create temporary table TMPMONTOGARCUENTAS (
	SELECT Blo.Referencia,	SUM(CASE WHEN Blo.NatMovimiento = Var_NatMovimiento
					THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
				 ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
			END) AS MontoEnGar
		FROM	BLOQUEOS 		Blo,
				TMPREGCREDITOS Tmp
			WHERE DATE(Blo.FechaMov) <= Var_FechaFin
				AND Blo.TiposBloqID = Var_TiposBloqID
				AND Blo.Referencia  = Tmp.CreditoID
				and	Tmp.NumTransaccion = Aud_NumTransaccion
		 GROUP BY Blo.Referencia);

	UPDATE	TMPREGCREDITOS 		Tmp,
			TMPMONTOGARCUENTAS 	Blo
		SET Tmp.GarantiaLiq = IFNULL(Tmp.GarantiaLiq, Decimal_Cero) +MontoEnGar
	WHERE Blo.Referencia  = Tmp.CreditoID
	and Tmp.NumTransaccion = Aud_NumTransaccion;
	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;



	UPDATE	TMPREGCREDITOS	Tmp SET
		Tmp.GarantiaLiq =	Tmp.Monto
	WHERE GarantiaLiq > Monto
	and Tmp.NumTransaccion = Aud_NumTransaccion;



		INSERT INTO TMPREGULATORIOA2112 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
										 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)

		SELECT 							 ConceptoID,		Var_ClaveEntidad,	ValorFijo1,			ValorFijo2,			ValorFijo3,
										 CuentaCNBV,		Tmp.Naturaleza,
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
		GROUP BY Con.CuentaContable, Con.ConceptoID, CuentaCNBV, Tmp.Naturaleza
		ORDER BY Con.ConceptoID;


		UPDATE TMPREGULATORIOA2112	SET Saldo = (SELECT SUM(CASE WHEN GarantiaLiq > Monto
																	THEN IFNULL(Monto,Decimal_Cero)
																 ELSE IFNULL(GarantiaLiq,Decimal_Cero)
															END)
													FROM TMPREGCREDITOS
													WHERE NumTransaccion = Aud_NumTransaccion)
		WHERE ConceptoID = 51;




		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_SaldosDepositos WHERE ConceptoID = 42;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_SaldosCreditos  WHERE ConceptoID = 49;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_SaldosCapital  WHERE ConceptoID = 55;



		UPDATE TMPREGULATORIOA2112
			SET Saldo = CASE WHEN Naturaleza = VarDeudora
								THEN SaldoDeudor
							 WHEN Naturaleza = VarAcreedora
								THEN SaldoAcreedor
							 ELSE Saldo
						END;





		SET Var_CapitalNeto := (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID = 55);
		SET Var_CapitalNeto := IFNULL(Var_CapitalNeto, Decimal_Cero) - IFNULL((SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN (56,57,58,59,60,61,62)), Decimal_Cero);
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_CapitalNeto WHERE ConceptoID = 54;


		SET Var_GarantiaLiq	:= (SELECT Saldo FROM TMPREGULATORIOA2112 WHERE ConceptoID = 51);
		SET Var_Grupo3		:= (SELECT (IFNULL(Saldo, Decimal_Cero) + Var_SaldosCreditos) - (IFNULL(Var_GarantiaLiq, Decimal_Cero) * 1)  FROM TMPREGULATORIOA2112 WHERE ConceptoID = 50);
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo3 WHERE ConceptoID = 48;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo3 * 1 WHERE ConceptoID = 47;


		SET Var_Grupo2		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN (42,43,44,45,46));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo2 WHERE ConceptoID = 41;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo2 * 0.2 WHERE ConceptoID = 40;

		SET Var_Grupo1		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN(34,35,36,37,38));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo1 WHERE ConceptoID = 33;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_Grupo1 * 0 WHERE ConceptoID = 32;



		SET Var_ActPonRie	:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN (32,40,47));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ActPonRie WHERE ConceptoID = 31;

		SET Var_ReqRiesgoCredito	:= ((Var_Grupo1 * 0) + (Var_Grupo2 * 0.2) + (Var_Grupo3 * 1));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ReqRiesgoCredito WHERE ConceptoID = 30;
		SET Var_ReqRiesgoCredito	:= Var_ReqRiesgoCredito * 0.08;
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ReqRiesgoCredito WHERE ConceptoID IN (29,30,21,19);

		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ReqRiesgoCredito * 0.3 WHERE ConceptoID IN (17,18);


		SET Var_ReqCapital		:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN(9,17));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ReqCapital WHERE ConceptoID = 8;

		SET Var_ReqTotalCapital	:= (SELECT SUM(IFNULL(Saldo, Decimal_Cero)) FROM TMPREGULATORIOA2112 WHERE ConceptoID IN(8,21));
		UPDATE TMPREGULATORIOA2112	SET Saldo = Var_ReqTotalCapital WHERE ConceptoID = 7;

		UPDATE TMPREGULATORIOA2112	SET Saldo = ( CASE WHEN Var_ReqTotalCapital = Entero_Cero THEN
															Entero_Cero
														ELSE ( Var_CapitalNeto/Var_ReqTotalCapital) * 100 END )
												WHERE ConceptoID = 6;





	IF(Par_NumRep = Rep_Excel) THEN
		SELECT Con.Descripcion,							Con.FormulaSaldo,				Con.FormulaIndicador,     	   Con.ColorCeldaSaldo,			Con.ColorCeldaIndicador,
			   IFNULL(Tmp.Saldo, Decimal_Cero) 			AS Saldo,
			   IFNULL(Tmp.Indicador , Decimal_Cero) 	AS Indicador,
			   Con.SaldoEsNegrita,						Con.IndicadorEsNegrita,			Tmp.ClaveEntidad,				Con.CuentaCNBV,
			   Tmp.ValorFijo1,							Tmp.ValorFijo2,					Tmp.ValorFijo3
			FROM TMPREGULATORIOA2112 Tmp,
				 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
			 and  Con.ReporteID = Var_ReporteID	;
	END IF;

	IF(Par_NumRep = Rep_Csv) THEN
		SET Var_GarantiaLiq	:= (SELECT Saldo FROM TMPREGULATORIOA2112 WHERE ConceptoID = 51);

		UPDATE TMPREGULATORIOA2112 SET Saldo = Var_GarantiaLiq WHERE ConceptoID = 22;

		SELECT
			CONCAT( Tmp.ValorFijo3,';',CatCapitalizacion,';',Con.CuentaCNBV,';',
					case when Con.ConceptoID = 6 then (IFNULL(Tmp.Saldo, Decimal_Cero))
	                else ROUND((IFNULL(Tmp.Saldo, Decimal_Cero)),Decimal_Cero) end
			) AS Valor

			FROM TMPREGULATORIOA2112 Tmp,
				 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
				and  Con.ReporteID = Var_ReporteID
				AND Tmp.CuentaCNBV != Cadena_Vacia
                and Con.ConceptoID not in (9,10,11,12,13,14,15,16,17,51);

	END IF;


		DROP TEMPORARY TABLE TMPREGULATORIOA2112;
		DELETE	FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
		DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$