-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA201100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA201100003REP`;
DELIMITER $$

CREATE PROCEDURE `REGA201100003REP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE Coeficiente de Liquidez (A-2011) -----------------------------------------
# ============================================================================================================
	Par_Anio           		INT,				# Ano del cual se va hacer el reporte
	Par_Mes					INT,				# Mes del cual se va hacer el reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Tipo de reporte 1: Excel 2: CSV
	Par_Version				INT,				# Ano Version

    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion		BIGINT(20)			-- Auditoria
	)
TerminaStore:BEGIN

	DECLARE version_anterior_2015 	INT;	-- Reportes version anterior a el 2015
	DECLARE version_2015			INT;	-- Reportes version 2015

	-- Declaracion de variables
	-- Version anterior
	DECLARE Var_FechaSistema			DATE;				-- Fecha del sistema
	DECLARE Var_FechaInicio				DATE;				-- Fecha de inicio
	DECLARE Var_FechaFin				DATE;				-- Fecha fin
	DECLARE Var_ReporteID				VARCHAR(10);		-- Reporte ID
	DECLARE Var_ClaveEntidad			VARCHAR(300);		-- Clave de la entidad
	DECLARE Var_EjercicioVig			INT;				-- Ejercio vigente
	DECLARE Var_PeriodoVig				INT;				-- Periodo vigente
	DECLARE Var_EjercicioID				INT;				-- Ejercicio ID
	DECLARE Var_PeriodoID				INT;				-- Periodo ID
	DECLARE Var_FechInicio				DATE;				-- Fecha Inicio
	DECLARE Var_FechFin					DATE;				-- Fecha final
	DECLARE Var_FechFinMasDias			DATE;				-- Fecha fin mas dias
	DECLARE Var_FechaCorte				DATE;				-- Fecha de corte
	DECLARE Var_TitulosConservados 		DECIMAL(18,4);		-- Titulos conservados
	DECLARE Var_TitulosRecibidos 		DECIMAL(18,4);		-- Titulos recibidos
	DECLARE Var_Disponibilidades		DECIMAL(18,4);		-- Disponibilidades
	DECLARE Var_InversionValores		DECIMAL(18,4);		-- Inversion de valores
	DECLARE Var_ActivosLiquidos			DECIMAL(18,4);		-- Activos liquidos
	DECLARE Var_DeCortoPlazo			DECIMAL(18,4);		-- corto plazo
	DECLARE Var_ExigInmediata			DECIMAL(18,4);		-- Exigencia inmediata
	DECLARE Var_DepositoPlazo			DECIMAL(18,4);		-- Plazo de deposito
	DECLARE Var_DepCortoPlazo			DECIMAL(18,4);		-- Deposito a corto plazo
	DECLARE Var_TotalPasivos			DECIMAL(18,4);		-- Total pasivos
	DECLARE Var_DiasInversion			DECIMAL(18,2);		-- Dias de inversion
	-- Version 2015

	DECLARE Var_TitulosNegociar 		DECIMAL(18,4);		-- Titulos
	DECLARE VarTotalTitulos				DECIMAL(18,2);		-- Total de titulos
	DECLARE Var_Dispon					DECIMAL(18,2);		-- Disponibilidad
	DECLARE Var_Deud					DECIMAL(18,2);		-- Deuda
	DECLARE Var_ForTotalTitulos			VARCHAR(500);		-- Para total de titulos
	DECLARE Var_ForOtrosPas				VARCHAR(500);		-- Otros pasivos
	DECLARE VarOtrosPas					DECIMAL(18,2);		-- Otros pasivos
	DECLARE Var_Cliente_Inst        	INT;				-- Id cliente insitucional

	/* Formulas */
    DECLARE Var_NumFormulas 			INT;			-- Numero de registros con furmula contable
	DECLARE Var_FormulaReg 				VARCHAR(500);	-- Formula contable del registro
	DECLARE Var_SaldoReg	 			DECIMAL(21,2);	-- Saldo de la formula
	DECLARE Var_Consecutivo				INT;			-- Consecutivo auxiliar


-- Declaracion de constantes
-- VERsion anterior
	DECLARE FactorPorcentaje		DECIMAL(14,2);
	DECLARE Cliente_Inst        	INT;
	DECLARE Rep_Excel				INT(1);
	DECLARE Rep_Csv					INT(1);
	DECLARE Entero_Cero				INT(2);
	DECLARE Decimal_Cero			DECIMAL(4,4);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Str_Tabulador			VARCHAR(20);
	DECLARE Estatus_Pagado 			CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Estatus_Cancelado		CHAR(1);
	DECLARE Estatus_NoCerrado		CHAR(1);
	DECLARE ValorFijo1				CHAR(10);
	DECLARE Var_ClaveRep			CHAR(10);
	DECLARE ValorFijo3				CHAR(10);
	DECLARE NumeroDias_mes			INT(11);
	DECLARE VarDeudora				CHAR(1);
	DECLARE VarAcreedora			CHAR(1);

	-- Declaracion de constantes
	DECLARE PorFecha				CHAR(1);
	DECLARE SaldosHistorico			CHAR(1);
	DECLARE SaldosActuales			CHAR(1);
	DECLARE Version_Reporte			INT;
	DECLARE Saldo_Coeficiente		INT;
	DECLARE Saldo_Mensual			INT;
	DECLARE Saldo_Promedio			INT;
	DECLARE Registro_ID				INT;

	-- Asignacion de constantes
	SET Saldo_Mensual		:= 1;					-- Clave de Saldo Mensual
    SET Saldo_Promedio		:= 2;					-- Clave de saldo Promedio
	SET Rep_Excel			:= 1;					-- REporte en excel
	SET Rep_Csv				:= 2;					-- Reporte en CSV
	SET Entero_Cero			:= 0;					-- Entero cero
	SET Decimal_Cero		:= 0.0000;				-- DECIMAL cero
	SET Cadena_Vacia		:= '';					-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha vacia
	SET Str_Tabulador   	:= '     ';				-- String tabulador
	SET Estatus_Pagado		:= 'P'; 				-- Estatus pagado
	SET Estatus_Vigente		:= 'N';					-- Estatus vigente
	SET Estatus_Activo		:= 'A';					-- Estatus activo
	SET Estatus_Cancelado	:= 'C';					-- Estatus cancelado
	SET Estatus_NoCerrado	:= 'N';					-- Estatus no cerrado

	SET  Var_ClaveRep		:= '2011';				-- Valor fijo anio
	SET  ValorFijo3			:= '1';					--
	SET  Registro_ID		:= '1';					-- Registro ID
	SET NumeroDias_mes		:= 30;					-- numero de dias del mes

	SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);
	-- Constantes ver 2015
	SET SaldosActuales		:= 'A';
	SET PorFecha			:= 'F';
	SET SaldosHistorico		:= 'H';
	SET FactorPorcentaje	:= 100;

	-- asignacion de variables
	SELECT DiasInversion INTO Var_DiasInversion FROM PARAMETROSSIS ;
	SET VarDeudora      	:= 'D';
	SET VarAcreedora   		:= 'A';
    SET Version_Reporte		:= 2017;


    SELECT 	Cat.ClavePrudencial
	INTO 	ValorFijo1
	FROM 	CATPRUDENCIALOPERA Cat,PARAMREGULATORIOS Par
	WHERE 	Cat.NivelID = Par.NivelPrudencial;


	SELECT ClaveEntidad
	INTO Var_ClaveEntidad
	FROM PARAMREGULATORIOS
	WHERE ParametrosID = Registro_ID;


	SET Var_ReporteID		:= 'A2011';
	SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
	SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
	SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1
	INTO   Var_FechaSistema,						Var_EjercicioVig,							Var_PeriodoVig;



		DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOA2011;
		CREATE TEMPORARY TABLE TMPREGULATORIOA2011(
			TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
			ConceptoID		INT(11),
			Saldo			DECIMAL(18,4),
			SaldoPromedio	DECIMAL(18,4),
			ClaveEntidad	VARCHAR(300),
			ValorFijo1		CHAR(10),
			ValorFijo2		CHAR(10),
			ValorFijo3		CHAR(10),
			Naturaleza		CHAR(1),
			SaldoDeudor		DECIMAL(18,2),
			SaldoAcreedor	DECIMAL(18,2),
			CuentaCNBV		VARCHAR(40)
		);


        /*
		-- Guarda los saldos de las cuentas que tienen formula
		*/
		DROP TABLE IF EXISTS TMP_REGFORMULAS;
		CREATE TEMPORARY TABLE TMP_REGFORMULAS(
			Consecutivo  INT auto_increment PRIMARY KEY,
			ConceptoID   INT,
			CuentaContable VARCHAR(500),
			Saldo        DECIMAL(21,2)
		);

		SELECT 	Inicio, 			Fin
			FROM PERIODOCONTABLE
			WHERE EjercicioID	= Var_EjercicioVig
				AND PeriodoID	= Var_PeriodoVig
				AND Estatus 	= Estatus_NoCerrado
		INTO    Var_FechInicio,	    Var_FechFin;



		DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;


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
							 LEFT OUTER JOIN   DETALLEPOLIZA   Pol ON ( Cue.CuentaCompleta = Pol.CuentaCompleta AND Pol.Fecha 	  		<= Var_FechaFin)
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


                        -- Calculo de formulas
						INSERT INTO TMP_REGFORMULAS(ConceptoID,CuentaContable)
						SELECT ConceptoID,CuentaContable
						FROM CONCEPTOSREGREP
						WHERE (CuentaContable LIKE ('%+%')
						OR CuentaContable LIKE ('%-%'))
						AND ReporteID = Var_ReporteID
						AND Version = Version_Reporte;



						SELECT COUNT(*) AS NumFormulas INTO Var_NumFormulas
						FROM TMP_REGFORMULAS;

						SET Var_Consecutivo := 1;
						IF IFNULL(Var_NumFormulas,Entero_Cero) > Entero_Cero THEN
							REGFORMULA: LOOP

								IF Var_Consecutivo > Var_NumFormulas  THEN
								  LEAVE REGFORMULA;
								END IF;

								SELECT CuentaContable INTO Var_FormulaReg
								FROM TMP_REGFORMULAS
								WHERE Consecutivo = Var_Consecutivo;

								CALL EVALFORMULAREGPRO(Var_SaldoReg,Var_FormulaReg,	SaldosActuales,		PorFecha, 			Var_FechaFin);

								UPDATE TMP_REGFORMULAS
								SET Saldo = IFNULL(Var_SaldoReg,Entero_Cero)
								WHERE Consecutivo = Var_Consecutivo;

								SET Var_Consecutivo := Var_Consecutivo+1;

							END LOOP REGFORMULA;
						END IF;

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




                         -- Calculo de formulas
						INSERT INTO TMP_REGFORMULAS(ConceptoID,CuentaContable)
						SELECT ConceptoID,CuentaContable
						FROM CONCEPTOSREGREP
						WHERE ReporteID = Var_ReporteID
						AND (CuentaContable LIKE('%+%')
							  OR CuentaContable LIKE('%-%'))
						AND Version = Version_Reporte;

						SELECT COUNT(*) AS NumFormulas INTO Var_NumFormulas
						FROM TMP_REGFORMULAS;

						SET Var_Consecutivo := 1;
						IF IFNULL(Var_NumFormulas,Entero_Cero) > Entero_Cero THEN
							REGFORMULA: LOOP

								IF Var_Consecutivo > Var_NumFormulas  THEN
								  LEAVE REGFORMULA;
								END IF;

								SELECT CuentaContable INTO Var_FormulaReg
								FROM TMP_REGFORMULAS
								WHERE Consecutivo = Var_Consecutivo;


								CALL EVALFORMULAREGPRO(Var_SaldoReg,Var_FormulaReg,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);

								UPDATE TMP_REGFORMULAS
								SET Saldo = IFNULL(Var_SaldoReg,Entero_Cero)
								WHERE Consecutivo = Var_Consecutivo;

								SET Var_Consecutivo := Var_Consecutivo+1;

							END LOOP REGFORMULA;
						END IF;

				END IF;



			INSERT INTO TMPREGULATORIOA2011 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
											 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)
			SELECT 							 ConceptoID,		Var_ClaveEntidad,	ValorFijo1,			Var_ClaveRep,			ValorFijo3,
											 max(CuentaCNBV),	max(Tmp.Naturaleza),
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
                  AND 	Con.Version = Version_Reporte
			GROUP BY Con.CuentaContable, Con.ConceptoID
			ORDER BY Con.ConceptoID;



		SET Var_FechFinMasDias := DATE_ADD(Var_FechaFin, INTERVAL NumeroDias_mes DAY);

		DROP TABLE IF EXISTS TMPMONTOINVERSIONESREG;

		CREATE temporary TABLE TMPMONTOINVERSIONESREG
		SELECT SUM(Monto) + SUM(SaldoProvision) AS Suma
			FROM HISINVERSIONES Inv
			WHERE FechaCorte = Var_FechaFin
			AND Inv.Estatus = Estatus_Vigente
			AND	(Inv.FechaVencimiento > Var_FechaFin
			AND Inv.FechaVencimiento <= Var_FechFinMasDias);

		UPDATE 	TMPREGULATORIOA2011 Tmp,
				TMPMONTOINVERSIONESREG	Reg
		SET 	Saldo = Suma
			WHERE ConceptoID = 17;



			UPDATE TMPREGULATORIOA2011
				SET Saldo = CASE WHEN Naturaleza = VarDeudora
									THEN SaldoDeudor
								 WHEN Naturaleza = VarAcreedora
									THEN SaldoAcreedor
								 ELSE Saldo
							END;

		-- Actualizar Saldo de Formulas Contables
		UPDATE TMP_REGFORMULAS Tem, TMPREGULATORIOA2011 Reg
			SET Reg.Saldo = IFNULL(Tem.Saldo,Entero_Cero)
		WHERE Tem.ConceptoID = Reg.ConceptoID;


		/* Calculo de indicadores */
			--  4.- Inversiones en valores con vencimiento menor o igual a 30 dias  4/
			SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_InversionValores
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (8,9,10,11,12);

			UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_InversionValores, Decimal_Cero)
            WHERE ConceptoID IN (7);

			-- A. Total activos liquidos de corto plazo (1 + 2 + 3 + 4)
            SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_ActivosLiquidos
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (4,5,6,7);

            UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_ActivosLiquidos, Decimal_Cero)
            WHERE ConceptoID IN (3);

			-- 5. Depositos de corto plazo y titulos emitidos
            SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_DeCortoPlazo
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (16,17,18);

            UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_DeCortoPlazo, Decimal_Cero)
            WHERE ConceptoID IN (15);

            -- 6. Prestamos bancarios y de otros organismos
            SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_DepositoPlazo
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (20);

            UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_DepositoPlazo, Decimal_Cero)
            WHERE ConceptoID IN (19);


            -- 7. Otros pasivos
            SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_DepositoPlazo
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (22);

            UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_DepositoPlazo, Decimal_Cero)
            WHERE ConceptoID IN (21);

			-- B. Total  pasivos de corto plazo (5 + 6 + 7)
			SELECT SUM(IFNULL(Saldo,Decimal_Cero)) AS TotalSaldo
            INTO Var_TotalPasivos
            FROM TMPREGULATORIOA2011
            WHERE ConceptoID IN (15,19,21);

            UPDATE TMPREGULATORIOA2011
            SET Saldo = IFNULL(Var_TotalPasivos, Decimal_Cero)
            WHERE ConceptoID IN (14);

			IF(Var_TotalPasivos = Decimal_Cero) THEN SET Var_TotalPasivos := 1; END IF;

			UPDATE TMPREGULATORIOA2011
				SET Saldo = ((Var_ActivosLiquidos / Var_TotalPasivos ) * 100)
			WHERE ConceptoID = 1;


            /* --- Fin del Calculo de indicadores ---- */



		IF(Par_NumRep = Rep_Excel) THEN
			SELECT  Con.ConceptoID AS RegistroID, Con.Descripcion, 			Con.FormulaSaldo,			Con.FormulaSaldoProm,		Con.DescripcionEsNegrita,	Con.ColorCeldaSaldo,
					Con.ColorCeldaSaldoProm,	Tmp.ClaveEntidad,			Tmp.CuentaCNBV,
					ValorFijo1,					ValorFijo2,					ValorFijo3,
					IFNULL(Tmp.Saldo, Decimal_Cero)  			AS Saldo,
					IFNULL(Tmp.SaldoPromedio, Decimal_Cero)		AS SaldoPromedio
				FROM TMPREGULATORIOA2011 Tmp,
					 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
             AND 	Con.Version = 2017
			AND Con.ReporteID = Var_ReporteID;
		END IF;


		IF(Par_NumRep = Rep_Csv) THEN

            DROP TABLE IF EXISTS TMP_CSVA2011;
            CREATE temporary TABLE TMP_CSVA2011(
				Valor Text
            );

            INSERT INTO TMP_CSVA2011(Valor)
            SELECT
				CONCAT(
						Var_ClaveRep,';',
                        Tm.CuentaCNBV,';',
                        Saldo_Mensual,';',
                        CASE WHEN Tm.ConceptoID > 1 THEN ROUND(IFNULL(Tm.Saldo, Decimal_Cero),2) ELSE IFNULL(Tm.Saldo, Decimal_Cero) END,';'
                        ) AS Valor
				FROM TMPREGULATORIOA2011 Tm
					LEFT OUTER JOIN CONCEPTOSREGREP Con ON Tm.ConceptoID = Con.ConceptoID AND Con.ReporteID = Var_ReporteID
                    AND Con.Version = Version_Reporte
			WHERE Tm.CuentaCNBV != Cadena_Vacia;

            INSERT INTO TMP_CSVA2011(Valor)
            SELECT
				CONCAT(
						Var_ClaveRep,';',
                        Tm.CuentaCNBV,';',
                        Saldo_Promedio,';',
                        CASE WHEN Tm.ConceptoID > 1 THEN ROUND(IFNULL(Tm.SaldoPromedio, Decimal_Cero),2) ELSE IFNULL(Tm.SaldoPromedio, Decimal_Cero) END ,';'
                        ) AS Valor
				FROM TMPREGULATORIOA2011 Tm
					LEFT OUTER JOIN CONCEPTOSREGREP Con ON Tm.ConceptoID = Con.ConceptoID AND Con.ReporteID = Var_ReporteID
                    AND Con.Version = Version_Reporte
			WHERE Tm.CuentaCNBV != Cadena_Vacia
            AND Tm.ConceptoID > 1 ;



            SELECT Valor FROM TMP_CSVA2011;


		END IF;



		 DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
		 DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOA2011;
         DROP TEMPORARY TABLE IF EXISTS TMP_CSVA2011;



END TerminaStore$$