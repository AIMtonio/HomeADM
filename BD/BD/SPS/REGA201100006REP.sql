-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA201100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA201100006REP`;
DELIMITER $$

CREATE PROCEDURE `REGA201100006REP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE Coeficiente de Liquidez (A-2011) -----------------------------------------
# ============================================================================================================
	Par_Anio           		INT,				# Año del cual se va hacer el reporte
	Par_Mes					INT,				# Mes del cual se va hacer el reporte
	Par_NumRep				TINYINT UNSIGNED, 	# Tipo de reporte 1: Excel 2: CSV
	Par_Version				INT,				# Año Version

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
	DECLARE Var_TitulosConservados 		DECIMAL(14,4);		-- Titulos conservados
	DECLARE Var_TitulosRecibidos 		DECIMAL(14,4);		-- Titulos recibidos
	DECLARE Var_Disponibilidades		DECIMAL(14,4);		-- Disponibilidades
	DECLARE Var_InversionValores		DECIMAL(14,4);		-- Inversion de valores
	DECLARE Var_ActivosLiquidos			DECIMAL(14,4);		-- Activos liquidos
	DECLARE Var_DeCortoPlazo			DECIMAL(14,4);		-- corto plazo
	DECLARE Var_ExigInmediata			DECIMAL(14,4);		-- Exigencia inmediata
	DECLARE Var_DepositoPlazo			DECIMAL(14,4);		-- Plazo de deposito
	DECLARE Var_DepCortoPlazo			DECIMAL(14,4);		-- Deposito a corto plazo
	DECLARE Var_TotalPasivos			DECIMAL(14,4);		-- Total pasivos
	DECLARE Var_DiasInversion			DECIMAL(14,2);		-- Dias de inversion
	-- Version 2015

	DECLARE Var_TitulosNegociar 		DECIMAL(14,4);		-- Titulos
	DECLARE VarTotalTitulos				DECIMAL(18,2);		-- Total de titulos
	DECLARE Var_Dispon					DECIMAL(14,2);		-- Disponibilidad
	DECLARE Var_Deud					DECIMAL(14,2);		-- Deuda
	DECLARE Var_ForTotalTitulos			VARCHAR(500);		-- Para total de titulos
	DECLARE Var_ForOtrosPas				VARCHAR(500);		-- Otros pasivos
	DECLARE VarOtrosPas					DECIMAL(18,2);		-- Otros pasivos
	DECLARE Var_Cliente_Inst        	INT;				-- Id cliente insitucional


-- Declaracion de constantes
-- Version anterior
	DECLARE FactorPorcentaje		DECIMAL(14,2);	-- Porcentaje
	DECLARE Cliente_Inst        	INT;			-- Cliente de Institucion
	DECLARE Rep_Excel				INT(1);			-- Reporte Excel
	DECLARE Rep_Csv					INT(1);			-- Reporte Csv
	DECLARE Entero_Cero				INT(2);			-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(4,4);	-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Str_Tabulador			VARCHAR(20);	-- Tabulador
	DECLARE Estatus_Pagado 			CHAR(1);		-- Estatus pagado
	DECLARE Estatus_Vigente			CHAR(1);		-- Estatus vigente
	DECLARE Estatus_Activo			CHAR(1);		-- Estatus Activo
	DECLARE Estatus_Cancelado		CHAR(1);		-- Estatus cancelado
	DECLARE Estatus_NoCerrado		CHAR(1);		-- Estatus No Cerrado
	DECLARE ValorFijo1				CHAR(10);		-- Fijo 1
	DECLARE ValorFijo2				CHAR(10);		-- Fijo 2
	DECLARE ValorFijo3				CHAR(10);		-- Fijo 3
	DECLARE NumeroDias_mes			INT(11);		-- Numero de dias al mes
	DECLARE VarDeudora				CHAR(1);		-- Naturaleza deudora
	DECLARE VarAcreedora			CHAR(1);		-- Naturaleza acreedora

	-- Declaracion de constantes
	DECLARE PorFecha				CHAR(1);			-- Por Fecha
	DECLARE SaldosHistorico			CHAR(1);			-- Saldos en Historico
	DECLARE SaldosActuales			CHAR(1); 			-- Saldos Actuales
	DECLARE ReporteID				VARCHAR(10);		-- Clave del Reporte

	-- Asignacion de constantes
	SET version_anterior_2015	=	2014;			-- Reporte regulatorio anterior 2015
	SET version_2015			=	2015;			-- Reporte regulatiorio version 2015

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

	SET  ValorFijo2			:= '2011';				-- Valor fijo anio
	SET  ValorFijo3			:= '1';					--
	SET NumeroDias_mes		:= 30;					-- numero de dias del mes

	SET Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);
	-- Constantes ver 2015
	SET SaldosActuales		:= 'A';
	SET PorFecha			:= 'F';
	SET SaldosHistorico		:= 'H';
	SET ReporteID			:= 'A2011';
	SET FactorPorcentaje	:= 100;

	-- asignacion de variables
	SELECT DiasInversion INTO Var_DiasInversion FROM PARAMETROSSIS ;
	SET VarDeudora      	:= 'D';
	SET VarAcreedora   		:= 'A';

	SELECT IFNULL(ClaveNivInstitucion, Cadena_Vacia) INTO ValorFijo1 FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	IF(Par_Version=version_anterior_2015) THEN

		SET Var_ReporteID		:= 'A2011';
		SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
		SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
		SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);
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

				END IF;



			INSERT INTO TMPREGULATORIOA2011 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
											 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)
			SELECT 							 ConceptoID,		Var_ClaveEntidad,	ValorFijo1,			ValorFijo2,			ValorFijo3,
											 MAX(CuentaCNBV),		MAX(Tmp.Naturaleza),
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
                  AND 	Con.Version = Entero_Cero
			GROUP BY Con.CuentaContable, Con.ConceptoID
			ORDER BY Con.ConceptoID;



		SET Var_FechFinMasDias := DATE_ADD(Var_FechaFin, INTERVAL NumeroDias_mes DAY);

		DROP TABLE IF EXISTS TMPMONTOINVERSIONESREG;
		IF(Par_Anio=2014 AND Par_Mes < 12) THEN
		CREATE TEMPORARY TABLE TMPMONTOINVERSIONESREG
		(SELECT SUM(Inv.Monto )+
						SUM(CASE WHEN  Inv.FechaVenAnt> Fecha_Vacia AND   Inv.FechaVenAnt <= FechaVencimiento THEN
						ROUND( ( ( (DATEDIFF(Var_FechaFin,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN Entero_Cero ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						ELSE
						ROUND( ( ( (DATEDIFF(Var_FechaFin,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN Entero_Cero ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						END

					) AS Suma
					FROM INVERSIONES Inv
						INNER JOIN	CLIENTES Cli ON Cli.ClienteID	= Inv.ClienteID
						LEFT JOIN	EQU_INVERSIONES Eq ON  Inv.InversionID = Eq.InversionIDSAFI
						WHERE Inv.ClienteID<>Cliente_Inst
							 AND ((Inv.Estatus = Estatus_Vigente
											AND	(Inv.FechaVencimiento > Var_FechaFin
											AND Inv.FechaVencimiento <= Var_FechFinMasDias) )
							   OR   ( Inv.Estatus = Estatus_Pagado
										AND	(Inv.FechaVencimiento > Var_FechaFin
											AND Inv.FechaVencimiento <= Var_FechFinMasDias) )
							  OR   ( Inv.Estatus = Estatus_Cancelado
									AND Inv.FechaVencimiento > Var_FechaFin
								AND Inv.FechaVencimiento <= Var_FechFinMasDias
								AND Inv.FechaVenAnt != Fecha_Vacia
								AND Inv.FechaVenAnt >= Var_FechaFin) )
		);
		ELSE

			CREATE TEMPORARY TABLE TMPMONTOINVERSIONESREG
			SELECT SUM(Monto) + SUM(SaldoProvision) AS Suma
				FROM HISINVERSIONES Inv
				WHERE FechaCorte = Var_FechaFin
				AND Inv.Estatus = Estatus_Vigente
				AND	(Inv.FechaVencimiento > Var_FechaFin
				AND Inv.FechaVencimiento <= Var_FechFinMasDias);
		END IF;

		UPDATE 	TMPREGULATORIOA2011 Tmp,
				TMPMONTOINVERSIONESREG	Reg
		SET 	Saldo = Suma
			WHERE ConceptoID = 8;



			UPDATE TMPREGULATORIOA2011
				SET Saldo = CASE WHEN Naturaleza = VarDeudora
									THEN SaldoDeudor
								 WHEN Naturaleza = VarAcreedora
									THEN SaldoAcreedor
								 ELSE Saldo
							END;




		IF(Par_NumRep = Rep_Excel) THEN
			SELECT  Con.Descripcion, 			Con.FormulaSaldo,			Con.FormulaSaldoProm,		Con.DescripcionEsNegrita,	Con.ColorCeldaSaldo,
					Con.ColorCeldaSaldoProm,	Tmp.ClaveEntidad,			Tmp.CuentaCNBV,
					ValorFijo1,					ValorFijo2,					ValorFijo3,
					IFNULL(Tmp.Saldo, Decimal_Cero)  			AS Saldo,
					IFNULL(Tmp.SaldoPromedio, Decimal_Cero)		AS SaldoPromedio
				FROM TMPREGULATORIOA2011 Tmp,
					 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
             AND 	Con.Version = Entero_Cero
			AND Con.ReporteID = Var_ReporteID;
		END IF;


		IF(Par_NumRep = Rep_Csv) THEN


			SET Var_TitulosConservados	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 19);
			SET Var_TitulosRecibidos	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 20);
			SET Var_InversionValores	:= IFNULL(Var_TitulosConservados,Decimal_Cero) + IFNULL(Var_TitulosRecibidos, Decimal_Cero);
			UPDATE TMPREGULATORIOA2011
				SET Saldo = Var_InversionValores
			WHERE ConceptoID = 16;

			SET Var_Disponibilidades	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 15);
			SET Var_ActivosLiquidos		:= IFNULL(Var_Disponibilidades, Decimal_Cero) + Var_InversionValores;
			UPDATE TMPREGULATORIOA2011
				SET Saldo = Var_ActivosLiquidos
			WHERE ConceptoID = 13;

			SET Var_DeCortoPlazo	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 11);
			UPDATE TMPREGULATORIOA2011
				SET Saldo = IFNULL(Var_DeCortoPlazo, Decimal_Cero)
			WHERE ConceptoID = 10;

			SET Var_ExigInmediata	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 7);
			SET Var_DepositoPlazo	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 8);
			SET Var_DepCortoPlazo	:= IFNULL(Var_ExigInmediata, Decimal_Cero) + IFNULL(Var_DepositoPlazo, Decimal_Cero);
			UPDATE TMPREGULATORIOA2011
				SET Saldo = Var_DepCortoPlazo
			WHERE ConceptoID = 6;

			SET Var_TotalPasivos	:= Var_DepCortoPlazo + IFNULL(Var_DeCortoPlazo, Decimal_Cero);
			UPDATE TMPREGULATORIOA2011
				SET Saldo = Var_TotalPasivos
			WHERE ConceptoID = 4;

			IF(Var_TotalPasivos = Decimal_Cero) THEN SET Var_TotalPasivos := 1; END IF;
			UPDATE TMPREGULATORIOA2011
				SET Saldo = ((Var_ActivosLiquidos / Var_TotalPasivos ) * 100)
			WHERE ConceptoID = 2;





		SET ValorFijo3 := 6;
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915000000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915100000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915101000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915101010000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915101020000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915101030000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915102000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915102010000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915200000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915201000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202000000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202010000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202020000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202030000',	ValorFijo2,		ValorFijo3,
										Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202040000',	ValorFijo2,		ValorFijo3,
									Decimal_Cero,		Decimal_Cero);
		INSERT INTO TMPREGULATORIOA2011(ClaveEntidad,		ValorFijo1,		CuentaCNBV,		ValorFijo2,		ValorFijo3,
										Saldo,				SaldoPromedio)
						VALUES			(Var_ClaveEntidad,	ValorFijo1,		'915202050000',	ValorFijo2,		ValorFijo3,
									Decimal_Cero,		Decimal_Cero);


		      SELECT
				CONCAT(ValorFijo1,';',	Tm.CuentaCNBV,';', ValorFijo2,';', Tm.ValorFijo3,';',
							CASE WHEN Tm.ConceptoID = 2 THEN IFNULL(Saldo, Entero_Cero)
								 ELSE ROUND(IFNULL(Tm.Saldo, Decimal_Cero), Entero_Cero)
							END,';',
							CASE WHEN Tm.ConceptoID = 2 THEN IFNULL(Entero_Cero, Entero_Cero)
								ELSE ROUND(IFNULL(Tm.SaldoPromedio, Entero_Cero), Entero_Cero)
							END) AS Valor
				FROM TMPREGULATORIOA2011 Tm
					LEFT OUTER JOIN CONCEPTOSREGREP Con ON Tm.ConceptoID = Con.ConceptoID AND Con.ReporteID = Var_ReporteID
                    AND Con.Version = Entero_Cero
			WHERE Tm.CuentaCNBV != Cadena_Vacia;


		END IF;



		 DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
		 DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOA2011;

	ELSE
	IF (Par_Version=version_2015) THEN

			SET Var_Cliente_Inst		:= (SELECT ClienteInstitucion FROM PARAMETROSSIS);
			SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
			SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
			SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);
			SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1
			INTO   Var_FechaSistema,						Var_EjercicioVig,							Var_PeriodoVig;


			DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOA2011;
			CREATE TEMPORARY TABLE TMPREGULATORIOA2011(
				TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
				ConceptoID		INT(11),
				Saldo			DECIMAL(16,4),
				SaldoPromedio	DECIMAL(16,4),
				ClaveEntidad	VARCHAR(300),
				ValorFijo1		CHAR(10),
				ValorFijo2		CHAR(10),
				ValorFijo3		CHAR(10),
				Naturaleza		CHAR(1),
				SaldoDeudor		DECIMAL(16,2),
				SaldoAcreedor	DECIMAL(16,2),
				CuentaCNBV		VARCHAR(40)
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


					SET Var_ForTotalTitulos := (SELECT CuentaContable FROM CONCEPTOSREGREP con WHERE con.ConceptoID = 19 AND con.Version = version_2015 AND con.ReporteID = ReporteID);

                    CALL EVALFORMULAREGPRO(VarTotalTitulos,			Var_ForTotalTitulos,	SaldosActuales,		PorFecha, 			Var_FechFin);


					SET Var_ForOtrosPas	 	:= (SELECT CuentaContable FROM CONCEPTOSREGREP con WHERE con.ConceptoID = 12 AND con.Version = version_2015  AND con.ReporteID = ReporteID);
			        CALL EVALFORMULAREGPRO(VarOtrosPas,			Var_ForOtrosPas,	SaldosActuales,		PorFecha, 			Var_FechFin);


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


					SET Var_ForTotalTitulos := (SELECT CuentaContable FROM CONCEPTOSREGREP con WHERE con.ConceptoID = 19 AND con.Version = version_2015 AND con.ReporteID = ReporteID);
					CALL EVALFORMULAREGPRO(VarTotalTitulos,			Var_ForTotalTitulos,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);
			        SET Var_ForOtrosPas	 	:= (SELECT CuentaContable FROM CONCEPTOSREGREP con WHERE con.ConceptoID = 12 AND con.Version = version_2015 AND con.ReporteID = ReporteID);
					CALL EVALFORMULAREGPRO(VarOtrosPas,			Var_ForOtrosPas,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);


			END IF;




				INSERT INTO TMPREGULATORIOA2011 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
												 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)
				SELECT 							 ConceptoID,		Var_ClaveEntidad,	ValorFijo1,			ValorFijo2,			ValorFijo3,
												 MAX(CuentaCNBV),		MAX(Tmp.Naturaleza),
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
				WHERE Con.ReporteID = ReporteID
			    AND 	Version = version_2015
				GROUP BY Con.CuentaContable, Con.ConceptoID
				ORDER BY Con.ConceptoID;



			SET Var_FechFinMasDias := DATE_ADD(Var_FechaFin, INTERVAL NumeroDias_mes DAY);

			DROP TABLE IF EXISTS TMPMONTOINVERSIONESREG;
				CREATE TEMPORARY TABLE TMPMONTOINVERSIONESREG
				SELECT SUM(Monto) + SUM(SaldoProvision) AS Suma
					FROM HISINVERSIONES Inv
					WHERE FechaCorte = Var_FechaFin
					AND Inv.Estatus = Estatus_Vigente
					AND	(Inv.FechaVencimiento > Var_FechaFin
					AND Inv.FechaVencimiento <= Var_FechFinMasDias);

			UPDATE 	TMPREGULATORIOA2011 Tmp,
					TMPMONTOINVERSIONESREG	Reg
			SET 	Saldo = Suma
				WHERE ConceptoID = 8;


				UPDATE TMPREGULATORIOA2011
					SET Saldo = CASE WHEN Naturaleza = VarDeudora
										THEN SaldoDeudor
									 WHEN Naturaleza = VarAcreedora
										THEN SaldoAcreedor
									 ELSE Saldo
								END;


				SET Var_TitulosNegociar	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 17);
				SET Var_TitulosConservados	:= VarTotalTitulos;
				SET Var_TitulosRecibidos	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 18);
				SET Var_InversionValores	:= IFNULL(Var_TitulosConservados,Decimal_Cero) + IFNULL(Var_TitulosRecibidos, Decimal_Cero)+ IFNULL(Var_TitulosNegociar, Decimal_Cero);
				UPDATE TMPREGULATORIOA2011
					SET Saldo = Var_InversionValores
				WHERE ConceptoID = 16;


			    UPDATE TMPREGULATORIOA2011
					SET Saldo = VarOtrosPas
				WHERE ConceptoID IN (12,13);

                                SET Var_Deud	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 21);
				SET Var_Disponibilidades	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 15);
				SET Var_ActivosLiquidos		:= IFNULL(Var_Disponibilidades, Decimal_Cero) + Var_InversionValores;

				SET Var_DeCortoPlazo	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 11);
				UPDATE TMPREGULATORIOA2011
					SET Saldo = IFNULL(Var_DeCortoPlazo, Decimal_Cero)
				WHERE ConceptoID = 10;

				SET Var_ExigInmediata	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 7);
				SET Var_DepositoPlazo	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 8);
				SET Var_DepCortoPlazo	:= IFNULL(Var_ExigInmediata, Decimal_Cero) + IFNULL(Var_DepositoPlazo, Decimal_Cero);
				UPDATE TMPREGULATORIOA2011
					SET Saldo = Var_DepCortoPlazo
				WHERE ConceptoID = 6;


				SET Var_TotalPasivos	:= ROUND(Var_DepCortoPlazo,Entero_Cero) + IFNULL(ROUND(Var_DeCortoPlazo,Entero_Cero), Decimal_Cero);
				UPDATE TMPREGULATORIOA2011
					SET Saldo = Var_TotalPasivos+VarOtrosPas
				WHERE ConceptoID = 4;

				IF(Var_TotalPasivos = Decimal_Cero) THEN SET Var_TotalPasivos := 1; END IF;




				SET Var_Dispon	:= (SELECT Saldo FROM TMPREGULATORIOA2011 WHERE ConceptoID = 15);


			UPDATE TMPREGULATORIOA2011

                        SET Saldo = ROUND(Var_InversionValores,Entero_Cero) + ROUND(Var_Dispon,Entero_Cero) + IFNULL(ROUND(Var_Deud,Entero_Cero),Entero_Cero)
			WHERE ConceptoID = 14;

			UPDATE TMPREGULATORIOA2011
				SET Saldo = ROUND(VarTotalTitulos,Entero_Cero)
			WHERE ConceptoID = 19;

			UPDATE TMPREGULATORIOA2011
				SET Saldo = ROUND(Saldo,Entero_Cero)
			WHERE ConceptoID != 2;


            SELECT Saldo INTO Var_ActivosLiquidos FROM TMPREGULATORIOA2011 WHERE ConceptoID = 14;


				UPDATE TMPREGULATORIOA2011
					SET Saldo = (((Var_ActivosLiquidos/ (Var_TotalPasivos+VarOtrosPas) ) * 100))
				WHERE ConceptoID = 2;


			IF(Par_NumRep = Rep_Excel) THEN
				SELECT  Con.Descripcion, 			Con.FormulaSaldo,			Con.FormulaSaldoProm,		Con.DescripcionEsNegrita,	Con.ColorCeldaSaldo,
						Con.ColorCeldaSaldoProm,	Tmp.ClaveEntidad,			Tmp.CuentaCNBV,
						ValorFijo1,					ValorFijo2,					ValorFijo3,
						IFNULL(Tmp.Saldo, Decimal_Cero)  			AS Saldo,
						IFNULL(Tmp.SaldoPromedio, Decimal_Cero)		AS SaldoPromedio
					FROM TMPREGULATORIOA2011 Tmp,
						 CONCEPTOSREGREP Con
				WHERE Tmp.ConceptoID = Con.ConceptoID
				AND Con.ReporteID = ReporteID
			    AND 	Version = version_2015;
			END IF;


			IF(Par_NumRep = Rep_Csv) THEN


				SET ValorFijo3 := 6;



				SELECT
                      CONCAT(ValorFijo1,';',	Tm.CuentaCNBV,';', ValorFijo2,';', Tm.ValorFijo3,';',
							CASE WHEN Tm.ConceptoID = 2 THEN IFNULL(Saldo, Entero_Cero)
								 ELSE ROUND(IFNULL(Tm.Saldo, Decimal_Cero), Entero_Cero)
							END,';',
							CASE WHEN Tm.ConceptoID = 2 THEN IFNULL(Entero_Cero, Entero_Cero)
								ELSE ROUND(IFNULL(Tm.SaldoPromedio, Entero_Cero), Entero_Cero)
							END)
					 AS Valor
					FROM TMPREGULATORIOA2011 Tm,
						 CONCEPTOSREGREP Con
				WHERE Tm.ConceptoID = Con.ConceptoID
				AND Con.ReporteID = ReporteID
			    AND 	Version = Par_Version
				AND Tm.CuentaCNBV != Cadena_Vacia;



			END IF;

			 DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
			 DROP TEMPORARY TABLE IF EXISTS TMPREGULATORIOA2011;
		END IF;
	END IF;

END TerminaStore$$