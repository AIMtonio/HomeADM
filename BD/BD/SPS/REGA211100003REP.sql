-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA211100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA211100003REP`;
DELIMITER $$


CREATE PROCEDURE `REGA211100003REP`(
-- ---------------------------------------------------------------------------------
-- Genera el reporte A2111 Para Sofipos
-- ---------------------------------------------------------------------------------
	Par_Anio           		INT,				-- Ano
	Par_Mes					INT,				-- Mes
	Par_NumRep				TINYINT UNSIGNED, 	-- Numero de Reporte

    Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15), 		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50), 		-- Auditoria
    Aud_Sucursal        	INT(11), 			-- Auditoria
    Aud_NumTransaccion		BIGINT(20)  		-- Auditoria
	)

TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio
DECLARE Var_FechaFin				DATE;			-- Fecha de Fin
DECLARE Var_ReporteID				VARCHAR(10);	-- Numero de Reporte
DECLARE Var_ClaveEntidad			VARCHAR(300);	-- Clave de la entidad
DECLARE Var_EjercicioVig			INT(11);		-- Numero de Ejercicio
DECLARE Var_PeriodoVig				INT(11);		-- Periodo vigente
DECLARE Var_EjercicioID				INT(11);		-- Numero ID del Ejercicio vigente
DECLARE Var_PeriodoID				INT(11);		-- Numero del Periodo vigente
DECLARE Var_FechInicio				DATE;			-- Fecha del Ejercicio vigente
DECLARE Var_FechFin					DATE;			-- Fecha Fin del Ejercicio vigente
DECLARE Var_FechaCorte				DATE;			-- Fecha de Corte
DECLARE Var_CCInicial				INT(11);		-- Centro de costos Inicial
DECLARE Var_CCFinal					INT(11);		-- Centro de Costos Final
DECLARE Var_FechaCorteMax			DATE;			-- Fecha de corte maximo
DECLARE Var_NatMovimiento			CHAR(1);		-- Naturaleza del Movimiento
DECLARE Var_TiposBloqID				INT(4);			-- Clave tipo de Bloqueo
DECLARE Var_ResPrevCero				DECIMAL(21,2);	-- Variable de Reserva preventiva cero
DECLARE Var_NumFormulas 			INT(11);		-- Numero de registros con furmula contable
DECLARE Var_FormulaReg 				VARCHAR(500);	-- Formula contable del registro
DECLARE Var_SaldoReg	 			DECIMAL(21,2);	-- Saldo de la formula
DECLARE Var_Consecutivo				INT(11);		-- Consecutivo auxiliar

/* Variables para suma de grupos y calculo de indicadores */
DECLARE Var_NicapTotal				DECIMAL(21,4);			-- NICAP Total
DECLARE Var_NicapCredito			DECIMAL(21,4);			-- NICAP de Credito
DECLARE Var_NicapMercado			DECIMAL(21,4);			-- NICAP de Mercado
DECLARE Var_IndCapRiesgo			DECIMAL(21,4);			-- Indice de capital por riesgos
DECLARE Var_CapBasicoNeto			DECIMAL(21,4);			-- Capital basico entre neto
DECLARE Var_CapCompleNeto			DECIMAL(21,4);			-- Capital complementario entre Neto
DECLARE Var_CapBasicoComp			DECIMAL(21,4);			-- Capital basico entre complementario
DECLARE Var_ReqCapRiesgo			DECIMAL(21,2);			-- Requerimientos de capital por riesgo total
DECLARE Var_ReqRiegoMerca			DECIMAL(21,2);			-- Requerimientos de capital por riesgo de mercado
DECLARE Var_ReqRiesgoCred			DECIMAL(21,2);			-- Requerimientos de capital por riesgo de credito
DECLARE Var_Req1SobreA				DECIMAL(21,2);			-- Requerimiento de 1% sobre A
DECLARE Var_SumaCartera				DECIMAL(21,2);			-- Suma total de cartera
DECLARE Var_Req30B100C				DECIMAL(21,2);			-- Requerimiento de 30% sobre B o 100% sobre C
DECLARE Var_ReqCapRiesgoB			DECIMAL(21,2);			-- RequerimientosCap Riesgo B
DECLARE Var_ReqCapAnexoO			DECIMAL(21,2);			-- Requerimiento Cap Anexo O
DECLARE Var_Req8Credito				DECIMAL(21,2);			-- Requerimiento del 8% sobre credito
DECLARE Var_Req8ActPonde			DECIMAL(21,2);			-- Requerimiento del 8% de activo ponderado
DECLARE Var_SumaActPonde			DECIMAL(21,2);			-- Suma de activos ponderados
DECLARE Var_Grupo1Pond0				DECIMAL(21,2);			-- 0% del Grupo 1
DECLARE Var_SumaGrupo1				DECIMAL(21,2);			-- Suma del Grupo 1
DECLARE Var_Grupo2Pond20			DECIMAL(21,2);			-- 20% del grupo 2
DECLARE Var_SumaGrupo2				DECIMAL(21,2);			-- suma del grupo 2
DECLARE Var_Grupo3Pond100			DECIMAL(21,2);			-- 100% del grupo 3
DECLARE Var_SumaGrupo3				DECIMAL(21,2);			-- suma del grupo 3
DECLARE Var_CapitalNeto				DECIMAL(21,2);			-- Capital Neto
DECLARE Var_CapitalBasico			DECIMAL(21,2);			-- Capital Basico
DECLARE Var_SumaMenos				DECIMAL(21,2);			-- Suma de capitales
DECLARE Var_InvEmpresasAux			DECIMAL(21,2);			-- Inversion en empresas auxiliares
DECLARE Var_InvEmpresasRel			DECIMAL(21,2);			-- Inversion de Empresas Relacionadas
DECLARE Var_ImpuestoDiferi			DECIMAL(21,2);			-- Impuestos diferidos
DECLARE Var_CapitalComple			DECIMAL(21,2);			-- Capital complementario
DECLARE Var_CarteraTotal			DECIMAL(21,2);			-- Cartera total
DECLARE Var_ProvisionCart			DECIMAL(21,2);			-- Provision de Cartera

/* Fin Variables para suma de grupos y calculo de indicadores */
DECLARE Var_SumaCarteraAux			DECIMAL(21,2);	-- Suma de Cartera Auxiliar
DECLARE Var_NivelPrudencial			INT(11);		-- Nivel Prudencial de la Financiera
DECLARE Var_Redondeo				INT(11);		-- Redondeo de Decimales
DECLARE Var_AjustaSaldo				CHAR(1);		-- Ajuste de Saldo
DECLARE Var_SaldoMas				DECIMAL(14,2);	-- Saldo de Sumatorias

DECLARE Var_SaldoMenos				DECIMAL(14,2);	-- Saldo de Sumatorias
DECLARE Var_NumCliente				INT(11);		-- Numero de Cliente
DECLARE Var_ReserCero 				DECIMAL(16,2);	-- Reserva en Cero
DECLARE Var_ResConGarHipo			DECIMAL(16,2);	-- Reserva Concepto Garantia Hipotecaria
DECLARE Var_ResConGarLiq			DECIMAL(16,2);	-- Reserva Concepto Garantia Liquida

DECLARE Var_AjusteResPreventiva		CHAR(1);		-- Ajuste a Reserva Preventiva

-- Declaracion de Constantes
DECLARE Rep_Excel				INT(11);			-- Reporte en Excel
DECLARE Rep_Csv					INT(11);			-- Reporte en csv
DECLARE Registro_ID				INT(11);			-- Numero de registro
DECLARE Entero_Cero				INT(11);			-- Entero Cero
DECLARE Entero_Uno				INT(11);			-- Entero Uno
DECLARE Decimal_Cero			DECIMAL(4,2);	 	-- DECIMAL cero
DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
DECLARE Fecha_Vacia				DATE;				-- Fecha vacia
DECLARE Estatus_Pagado 			CHAR(1);			-- Estatus pagado
DECLARE Estatus_Vigente			CHAR(1);			-- Estatus vigente
DECLARE Estatus_Activo			CHAR(1);			-- Estatus activo
DECLARE Estatus_Cancelado		CHAR(1);			-- Estatus cancelado
DECLARE Estatus_NoCerrado		CHAR(1);			-- Estatus No Cerrado
DECLARE Nivel_Entidad			CHAR(10);			-- Nivel de la entidad
DECLARE ValorFijo2				CHAR(10);			-- Valor Fijo
DECLARE ValorFijo3				CHAR(10);			-- Valor fijo 2
DECLARE VarDeudora				CHAR(1);			-- Naturaleza deudora
DECLARE VarAcreedora			CHAR(1);			-- Naturaleza acreedora
DECLARE SaldosActuales			CHAR(1);			-- Saldos Actuales
DECLARE SaldosHistorico			CHAR(1);			-- Saldos Historicos
DECLARE PorFecha				CHAR(1);			-- Por Fecha
DECLARE Credito_Vigente			CHAR(1);			-- Credito Vigente
DECLARE Credito_Vencido			CHAR(1);			-- Credito Vencido
DECLARE Credito_Renovado		CHAR(1);			-- Credito Renovado
DECLARE Version_Reporte			INT(11);			-- Version del reporte
DECLARE Credito_Nuevo			CHAR(1);			-- Credito Nuevo
DECLARE Base_Cien				INT(11);			-- Base 100
DECLARE Credito_Reestructura	CHAR(1);
DECLARE Cons_SI					CHAR(1);
DECLARE Cliente_Sofiexpress		INT(11);

-- Asignacion de Constantes
SET Rep_Excel			:= 1;
SET Rep_Csv				:= 2;
SET Entero_Cero			:= 0;
SET Entero_Uno			:= 1;
SET Decimal_Cero		:= 0.0;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Estatus_Pagado		:= 'P';
SET Estatus_Vigente		:= 'N';
SET Estatus_Activo		:= 'A';
SET Estatus_Cancelado	:= 'C';
SET Estatus_NoCerrado	:= 'N';
SET ValorFijo2			:= '2111';
SET ValorFijo3			:= '152';
SET VarDeudora      	:= 'D';
SET VarAcreedora   		:= 'A';
SET SaldosActuales		:= 'A';
SET SaldosHistorico		:= 'H';
SET PorFecha			:= 'F';
SET Credito_Vigente		:= 'V';
SET Credito_Vencido		:= 'B';
SET Registro_ID			:= 1;
SET Version_Reporte		:= 2017;
SET Var_ReporteID		:= 'A2111';
SET Var_NatMovimiento	:= 'B';
SET Var_TiposBloqID		:= 8;
SET Credito_Nuevo		:= 'N';
SET Credito_Renovado	:= 'O';
SET Credito_Reestructura	:= 'R';
SET Cons_SI				:= 'S';
SET Base_Cien			:= 100;
SET Cliente_Sofiexpress := 15;

SELECT 	Cat.ClavePrudencial
INTO 	Nivel_Entidad
FROM 	CATPRUDENCIALOPERA Cat,PARAMREGULATORIOS Par
WHERE 	Cat.NivelID = Par.NivelPrudencial;


SELECT ClaveEntidad
INTO Var_ClaveEntidad
FROM PARAMREGULATORIOS
WHERE ParametrosID = Registro_ID;

SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
SET Var_FechaCorteMax	:= (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= Var_FechaFin);
SET Var_NumCliente		:= IFNULL(FNPARAMGENERALES('CliProcEspecifico'), Entero_Cero);



SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero)
INTO   Var_FechaSistema,					   Var_EjercicioVig,							Var_PeriodoVig
FROM PARAMETROSSIS
LIMIT 1	;


SELECT MIN(CentroCostoID), 	MAX(CentroCostoID) INTO
		Var_CCInicial, 		Var_CCFinal
	FROM CENTROCOSTOS;


DELETE FROM TMPCONTABLEBALANCE
WHERE NumeroTransaccion = Aud_NumTransaccion;


--  Tabla para los conceptoos y saldos del reporte
DROP TABLE IF EXISTS TMPREGULATORIOA2111;
CREATE TEMPORARY TABLE TMPREGULATORIOA2111(
	TmpID			INT(11) PRIMARY KEY AUTO_INCREMENT,
    ConceptoID      INT(11),
    Saldo			DECIMAL(14,4),
    Indicador		DECIMAL(14,4),
	ClaveEntidad	VARCHAR(300),
	ValorFijo1		CHAR(10),
	ValorFijo2		CHAR(10),
	ValorFijo3		CHAR(10),
	Naturaleza		CHAR(1),
	SaldoDeudor		DECIMAL(14,2),
	SaldoAcreedor	DECIMAL(14,2),
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



        INSERT INTO TMP_REGFORMULAS(ConceptoID,CuentaContable)
        SELECT ConceptoID,CuentaContable
        FROM CONCEPTOSREGREP
        WHERE ReporteID = Var_ReporteID
        AND (CuentaContable LIKE('%+%')
			  OR CuentaContable LIKE('%-%')
		AND Version = Version_Reporte);

		SELECT COUNT(*) AS NumFormulas
        INTO Var_NumFormulas
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



/*
* Se obtiene el total de los depositos considerados una garantia  -------------------------------------------------------------------------
*/
		DELETE FROM TMPREGCREDITOS
        WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMPREGCREDITOS (NumTransaccion,		CreditoID,		Monto)
		SELECT	Aud_NumTransaccion,	S.CreditoID,
				(S.SalCapVigente	+	S.SalCapAtrasado	+	S.SalCapVencido	+
                 S.SalCapVenNoExi	+	S.SalIntOrdinario	+	S.SalIntProvision	+
                 S.SalIntAtrasado	+	S.SalMoratorios		+	S.SalIntVencido		+
                 S.SaldoMoraVencido)
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
			WHERE	F.CreditoID	 =	T.CreditoID
			AND FechaAsignaGar 	 <= Var_FechaFin
			AND F.NumTransaccion = Aud_NumTransaccion
			GROUP BY T.CreditoID;


		UPDATE	TMPREGCREDITOS	Tmp,TMPCREDITOINVGAR2 Gar
        SET 	Tmp.GarantiaLiq 	=	Gar.MontoEnGar
		WHERE   Gar.CreditoID 		= Tmp.CreditoID
		AND     Tmp.NumTransaccion 	= Aud_NumTransaccion;


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



/*
* Fin de los depositos considerados una garantia  -------------------------------------------------------------------------
*/



    /* Se actualizan los saldos de acuerdo a las cuentas definidas en la tabla de configuracion */
	INSERT INTO TMPREGULATORIOA2111 (ConceptoID,		ClaveEntidad,		ValorFijo1,			ValorFijo2,			ValorFijo3,
									 CuentaCNBV,		Naturaleza,			SaldoDeudor,		SaldoAcreedor)
	SELECT 							 ConceptoID,		Var_ClaveEntidad,	Nivel_Entidad,		ValorFijo2,			ValorFijo3,
									 MAX(CuentaCNBV),	MAX(Tmp.Naturaleza),
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
		ON  Tmp.CuentaContable LIKE Con.CuentaContable
		AND Tmp.NumeroTransaccion = Aud_NumTransaccion
	WHERE Con.ReporteID = Var_ReporteID
    AND Con.Version = Version_Reporte
	GROUP BY Con.CuentaContable, Con.ConceptoID
	ORDER BY Con.ConceptoID;


	UPDATE TMPREGULATORIOA2111
	SET Saldo = CASE WHEN Naturaleza = VarDeudora
						THEN SaldoDeudor
					 WHEN Naturaleza = VarAcreedora
						THEN SaldoAcreedor
					 ELSE Saldo
			  END;

    /*
    Se actualizan los saldos de las cuentas que tienen formula
    */
    UPDATE TMPREGULATORIOA2111 Tem, TMP_REGFORMULAS Sal
	SET	Tem.Saldo  = IFNULL(Sal.Saldo,Entero_Cero)
    WHERE Tem.ConceptoID = Sal.ConceptoID;

	/*
	* Seccion temporal para Sofiexpress, se debe crear campos de CuentasSuma, cuentasResta en la tabla de configuracion, para que tome los saldos del catálogo minimo
	* Se debe poner dentro de un ciclo para que sea dinamico
	*/
	IF Var_NumCliente =  Cliente_Sofiexpress  THEN

		-- Capital Contable
		SELECT SUM(Monto)
		INTO Var_SaldoMas
		FROM `HIS-CATALOGOMINIMO` Catalogo
		WHERE Catalogo.Anio = Par_Anio
		  AND Catalogo.Mes = Par_Mes
		  AND Catalogo.CuentaContable IN ('510000000000','530000000000','540000000000','505000000000','410000000000','420100000000','420300000000');

		SELECT SUM(Monto)
		INTO Var_SaldoMenos
		FROM `HIS-CATALOGOMINIMO` Catalogo
		WHERE Catalogo.Anio = Par_Anio
		  AND Catalogo.Mes = Par_Mes
		  AND Catalogo.CuentaContable IN ('610000000000','520000000000','620000000000','630000000000','640000000000','570000000000','660000000000','560000000000','580000000000');

		UPDATE TMPREGULATORIOA2111 SET
			Saldo = IFNULL(Var_SaldoMas, Decimal_Cero) - IFNULL(Var_SaldoMenos, Decimal_Cero)
		WHERE ConceptoID = 62;


		-- Creditos y valores
		SELECT SUM(Monto)
		INTO Var_SaldoMas
		FROM `HIS-CATALOGOMINIMO` Catalogo
		WHERE Catalogo.Anio = Par_Anio
		  AND Catalogo.Mes = Par_Mes
		  AND Catalogo.CuentaContable IN ('130000000000','135000000000','139000000000','140103900000','140103040000','110301000000');

		UPDATE TMPREGULATORIOA2111 SET
			Saldo = IFNULL(Var_SaldoMas, Decimal_Cero)
		WHERE ConceptoID = 53;


		-- Cartera total
		SELECT SUM(Monto)
		INTO Var_SaldoMas
		FROM `HIS-CATALOGOMINIMO` Catalogo
		WHERE Catalogo.Anio = Par_Anio
		  AND Catalogo.Mes = Par_Mes
		  AND Catalogo.CuentaContable IN ('130000000000','135000000000','139000000000');

		UPDATE TMPREGULATORIOA2111 SET
			Saldo = IFNULL(Var_SaldoMas, Decimal_Cero)
		WHERE ConceptoID = 17;

		-- Estimaciones
		SELECT SUM(Monto)
		INTO Var_SaldoMas
		FROM `HIS-CATALOGOMINIMO` Catalogo
		WHERE Catalogo.Anio = Par_Anio
		  AND Catalogo.Mes = Par_Mes
		  AND Catalogo.CuentaContable IN ('139000000000');

		UPDATE TMPREGULATORIOA2111 SET
			Saldo = IFNULL(Var_SaldoMas, Decimal_Cero)
		WHERE ConceptoID = 18;

	END IF;

    /* Se actualiza el saldo total de depositos como garantia */
	UPDATE TMPREGULATORIOA2111	SET Saldo = (SELECT SUM(IFNULL(GarantiaLiq,Decimal_Cero)  )
												FROM TMPREGCREDITOS
												WHERE NumTransaccion = Aud_NumTransaccion)
	WHERE ConceptoID IN (56);	 -- Cambiar el numero

	SET Var_AjustaSaldo := (SELECT AjusteSaldo FROM PARAMREGULATORIOS LIMIT Entero_Uno);
	SET Var_Redondeo 	:= Entero_Cero;

	IF(Var_AjustaSaldo = Cons_SI) THEN
		SET Var_Redondeo 	:= Entero_Cero;
		UPDATE TMPREGULATORIOA2111	SET
		Saldo =  ROUND(Saldo, Var_Redondeo);
	END IF;

	SELECT	AjusteResPreventiva
	INTO Var_AjusteResPreventiva
	FROM PARAMREGULATORIOS
	LIMIT 1;

	IF( Var_AjusteResPreventiva <> Cons_SI ) THEN
		-- 1. Reservas preventivas para creditos con cero dias de mora y no emproblemados
		SELECT 	SUM(Cal.Reserva) AS Reserva
		INTO Var_ResPrevCero
		FROM CALRESCREDITOS Cal
		LEFT OUTER JOIN REESTRUCCREDITO Cre ON Cal.CreditoID = Cre.CreditoDestinoID
											AND Cre.Origen = Credito_Reestructura
											AND Cre.FechaRegistro <= Var_FechaFin
		WHERE Cal.Fecha = Var_FechaFin
		  AND (Cal.DiasAtraso = Entero_Cero AND Cre.CreditoDestinoID IS NULL);

	ELSE
		-- 2 -- Metodo de preventivas de Tamazula a cero dias de mora
		SET Var_ReserCero := (SELECT SUM(Reserva)
							  FROM CALRESCREDITOS
							  WHERE Fecha = Var_FechaFin
								AND DiasAtraso = Entero_Cero);

		SET Var_ReserCero := IFNULL(Var_ReserCero,Entero_Cero);

		SET Var_ResConGarHipo = (SELECT SUM(ReservaTotCubierto)
								 FROM CALRESCREDITOS
								 WHERE Fecha = Var_FechaFin
								   AND CreditoID IN (SELECT CreditoID
													 FROM CREGARPRENHIPO
													 WHERE MontoGarHipo > Entero_Cero));

		SET Var_ResConGarHipo := IFNULL(Var_ResConGarHipo,Entero_Cero);

		SET Var_ResConGarLiq = ( SELECT SUM(ReservaTotCubierto)
								 FROM CALRESCREDITOS
								 WHERE Fecha = Var_FechaFin
								   AND DiasAtraso >= Entero_Uno
								   AND  MontoGarantia > Entero_Cero
								   AND  CreditoID NOT IN (SELECT CreditoID
														  FROM CREGARPRENHIPO
														  WHERE MontoGarHipo > Entero_Cero));

		SET Var_ResConGarLiq := IFNULL(Var_ResConGarLiq,Entero_Cero);

		SET Var_ResPrevCero := Var_ReserCero - Var_ResConGarHipo - Var_ResConGarLiq;
	END IF;

	UPDATE TMPREGULATORIOA2111	SET
		Saldo =  CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_ResPrevCero,Decimal_Cero), Var_Redondeo) END
	WHERE ConceptoID = 89;


    /*
    * ==========================================================================
    *    CALCULO DE INDICADORES Y SUMAS
    * ==========================================================================
    */

		-- Capital Complementario (1 + 2)
		SELECT SUM(Saldo) AS CapComple
		INTO Var_CapitalComple
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (89,90);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_CapitalComple,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 87;


		-- 14. Impuestos diferidos activos
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_ImpuestoDiferi
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (83,84);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_ImpuestoDiferi,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 82;

        -- 7. Inversiones en empresas relacionadas:
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_InvEmpresasRel
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (75);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_InvEmpresasRel,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 74;

        -- 6. Inversiones en empresas de servicios auxiliares y complementarios
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_InvEmpresasAux
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (72,73);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_InvEmpresasAux,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 71;

		-- Saldos Manuales
		UPDATE TMPREGULATORIOA2111 tem,REGA2111SALDOS sal SET
			tem.Saldo = sal.Saldo
		WHERE tem.CuentaCNBV = sal.CuentaFija
		  AND sal.Anio = Par_Anio
		  AND sal.Mes  = Par_Mes;
		-- Saldos Manuales

        -- MENOS:
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_SumaMenos
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (68,69,70,71,74,76,77,78,79,80,81,82,85);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaMenos,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 66;

        -- Capital Basico: (1 + 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 - 10 - 11 - 12 - 13 - 14)
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_CapitalBasico
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (62,64);

        SET Var_CapitalBasico := IFNULL(Var_CapitalBasico,Decimal_Cero) - IFNULL(Var_SumaMenos,Decimal_Cero);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_CapitalBasico,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID = 60;

		SET Var_CapitalNeto := IFNULL(Var_CapitalBasico,Decimal_Cero) + IFNULL(Var_CapitalComple,Decimal_Cero);
         -- Capital Neto (Capital Basico + Capital Complementario)
		UPDATE TMPREGULATORIOA2111
		SET Saldo = Var_CapitalNeto
		WHERE ConceptoID = 58;

        -- Cambio de saldos
        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Saldo,Decimal_Cero) * -1, Var_Redondeo) END
		WHERE ConceptoID IN (40,49,56);

        -- Grupo 3 (A + B + C - D) ) y 3. Suma de Activos ponderados al 100% (Grupo 3)
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_SumaGrupo3
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (53,54,55,56);



		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaGrupo3,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (52,51);

        SET Var_Grupo3Pond100 := IFNULL(Var_SumaGrupo3,Decimal_Cero);

        -- Grupo 2 (A + B + C + D + E - F)
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_SumaGrupo2
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (44,45,46,47,48,49);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaGrupo2,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (43);

        -- 2. Suma de Activos Ponderados al 20% (Grupo 2)
        SET  Var_Grupo2Pond20 := IFNULL(Var_SumaGrupo2,Decimal_cero) * 0.2;

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Grupo2Pond20,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (42);

        -- Grupo 1 (A + B + C + D + E + F - G)
		SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_SumaGrupo1
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (34,35,36,37,38,39,40);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaGrupo1,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (33);

         -- Cambio de saldos
        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Saldo,Decimal_Cero) * -1, Var_Redondeo) END
		WHERE ConceptoID = 56;

        -- 1. Suma de Activos Ponderados al 0% (Grupo 1)
        SET Var_Grupo1Pond0 := IFNULL(Var_SumaGrupo1,Decimal_Cero) * Decimal_Cero;

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Grupo1Pond0,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (32);

        -- Suma de activos ponderados por riesgo de credito totales (1 + 2 + 3)
        SET Var_SumaActPonde := IFNULL(Var_Grupo1Pond0,Decimal_Cero) +
								IFNULL(Var_Grupo2Pond20,Decimal_Cero) +
                                IFNULL(Var_Grupo3Pond100,Decimal_Cero);

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaActPonde,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (30);

        -- Requerimiento de 8% sobre los Activos ponderados por riesgo
        SET Var_Req8ActPonde := IFNULL(Var_SumaActPonde,Decimal_Cero) * 0.08;
        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Req8ActPonde,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (28);

        -- Requerimiento por riesgo de credito = 8%  De la cartera de credito neta
        SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_CarteraTotal
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (17);



        -- Cartera de Credito Neta
        SET Var_Req8Credito := (IFNULL(Var_CarteraTotal,Decimal_Cero))* 0.08;

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Req8Credito,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (26);

        -- B) = Requerimiento de capitalizacion por riesgo de credito
        SET Var_ReqCapRiesgoB := IFNULL(Var_Req8Credito,Decimal_Cero)+
								 IFNULL(Var_Req8ActPonde,Decimal_Cero);

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_ReqCapRiesgoB,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (22);

        -- Requerimiento del 30% sobre B o 100% de C
        SET Var_Req30B100C := IFNULL(Var_ReqCapRiesgoB,Decimal_Cero) * 0.3;

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Req30B100C,Decimal_Cero), Var_Redondeo) END
        WHERE ConceptoID IN (21);

        -- A) = Suma de la cartera de creditos otorgada
        SELECT SUM(Saldo) AS SaldoSuma
		INTO Var_SumaCartera
		FROM TMPREGULATORIOA2111
		WHERE  ConceptoID IN (17,18,19);

         UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_SumaCartera,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (16);

        -- Requerimiento del 1% sobre A
        SET Var_Req1SobreA := IFNULL(Var_SumaCartera,Decimal_Cero)  * 0.01;

		UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_Req1SobreA,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (15);

        -- II. Requerimiento de capital por riesgo de credito
        SET  Var_ReqRiesgoCred:= IFNULL(Var_Req8Credito,Decimal_Cero)+
								 IFNULL(Var_Req8ActPonde,Decimal_Cero);


        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_ReqRiesgoCred,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (11);

        -- I. Requerimiento de capital por riesgo de mercado
        SET Var_ReqRiegoMerca := IFNULL(Var_Req1SobreA,Decimal_Cero);

        UPDATE TMPREGULATORIOA2111
		SET Saldo = CASE WHEN Var_AjustaSaldo = Cons_SI THEN ROUND(IFNULL(Var_ReqRiegoMerca,Decimal_Cero), Var_Redondeo) END
		WHERE ConceptoID IN (10);

        -- Requerimiento total de capital por riesgos (I + II)
        SET  Var_ReqCapRiesgo := IFNULL(Var_ReqRiesgoCred,Decimal_Cero) +
								 IFNULL(Var_ReqRiegoMerca,Decimal_Cero);

        UPDATE TMPREGULATORIOA2111
		SET Saldo = IFNULL(Var_ReqCapRiesgo,Decimal_Cero)
		WHERE ConceptoID IN (9);

        UPDATE TMPREGULATORIOA2111 SET
			Saldo = IFNULL(Saldo,Decimal_Cero)*-1
		WHERE ConceptoID IN (18);

        -- Capital basico entre capital complementario 1/
        SET Var_CapBasicoComp := ( CASE WHEN IFNULL(Var_CapitalComple,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalBasico,Decimal_Cero) /
											 IFNULL(Var_CapitalComple,Decimal_Cero))*Base_Cien) END);
        -- Capital complementario entre Capital Neto 1/
        SET Var_CapCompleNeto := ( CASE WHEN IFNULL(Var_CapitalNeto,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalComple,Decimal_Cero) /
											  IFNULL(Var_CapitalNeto,Decimal_Cero))*Base_Cien) END);
		-- Capital basico entre Capital Neto 1/
        SET Var_CapBasicoNeto := ( CASE WHEN IFNULL(Var_CapitalNeto,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalBasico,Decimal_Cero) /
											  IFNULL(Var_CapitalNeto,Decimal_Cero))*Base_Cien) END);
		-- Indice de capitalizacion (Riesgos de credito) = Capital neto / Activos ponderados por riesgo de credito 1/
        SET Var_IndCapRiesgo := ( CASE WHEN IFNULL(Var_SumaActPonde,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalNeto,Decimal_Cero) /
											  IFNULL(Var_SumaActPonde,Decimal_Cero))*Base_Cien) END);
        -- NICAP Mercado = Capital neto / Requerimiento total de capital por riesgos de mercado 1/
        SET Var_NicapMercado := ( CASE WHEN IFNULL(Var_ReqRiegoMerca,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalNeto,Decimal_Cero) /
											  IFNULL(Var_ReqRiegoMerca,Decimal_Cero))*Base_Cien) END);
		-- NICAP Credito = Capital neto / Requerimiento total de capital por riesgos de credito 1/
        SET Var_NicapCredito := ( CASE WHEN IFNULL(Var_ReqRiesgoCred,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalNeto,Decimal_Cero) /
											  IFNULL(Var_ReqRiesgoCred,Decimal_Cero))*Base_Cien) END);
        -- NICAP Total = Capital neto / Requerimiento total de capital por riesgos 1/
        SET Var_NicapTotal := ( CASE WHEN IFNULL(Var_ReqCapRiesgo,Decimal_Cero) = Entero_Cero THEN
											Entero_Cero
										ELSE
											((IFNULL(Var_CapitalNeto,Decimal_Cero) /
											  IFNULL(Var_ReqCapRiesgo,Decimal_Cero))*Base_Cien) END);

		-- Actualizar los datos
		UPDATE TMPREGULATORIOA2111
		SET Indicador = CASE ConceptoID WHEN 1 THEN IFNULL(Var_NicapTotal,Decimal_Cero)
										WHEN 2 THEN IFNULL(Var_NicapCredito,Decimal_Cero)
                                        WHEN 3 THEN IFNULL(Var_NicapMercado,Decimal_Cero)
                                        WHEN 4 THEN IFNULL(Var_IndCapRiesgo,Decimal_Cero)
                                        WHEN 5 THEN IFNULL(Var_CapBasicoNeto,Decimal_Cero)
                                        WHEN 6 THEN IFNULL(Var_CapCompleNeto,Decimal_Cero)
                                        WHEN 7 THEN IFNULL(Var_CapBasicoComp,Decimal_Cero) END
		WHERE ConceptoID IN (1,2,3,4,5,6,7);

    /*
    * ==========================================================================
    *    FIN DEL CALCULO DE INDICADORES Y SUMAS
    * ==========================================================================
    */

	SELECT NivelPrudencial INTO Var_NivelPrudencial FROM PARAMREGULATORIOS LIMIT 1;

	IF(Var_NivelPrudencial = 1  OR Var_NivelPrudencial = 2) THEN
		UPDATE TMPREGULATORIOA2111 SET
			Saldo = Decimal_Cero
		WHERE  ConceptoID IN (21,22,23);
	END IF;

	IF(Var_NivelPrudencial = 2 OR Var_NivelPrudencial = 3 OR Var_NivelPrudencial = 4) THEN
		UPDATE TMPREGULATORIOA2111 SET
			Saldo = Decimal_Cero
		WHERE  ConceptoID IN (25,26);
	END IF;

	IF(Var_NivelPrudencial = 1) THEN
		UPDATE TMPREGULATORIOA2111 SET
			Saldo = Decimal_Cero
		WHERE  ConceptoID IN (28);
	END IF;


	IF(Par_NumRep = Rep_Excel) THEN
		SELECT Con.ConceptoID, Con.Descripcion,			Con.FormulaSaldo,				Con.FormulaIndicador,     	   Con.ColorCeldaSaldo,			Con.ColorCeldaIndicador,
			   IFNULL(Tmp.Saldo, Decimal_Cero) 			AS Saldo,
			   IFNULL(Tmp.Indicador , Decimal_Cero) 	AS Indicador,
			   Con.SaldoEsNegrita,						Con.IndicadorEsNegrita,			Tmp.ClaveEntidad,				Con.CuentaCNBV,
			   Tmp.ValorFijo1,							Tmp.ValorFijo2,					Tmp.ValorFijo3,					Con.ColorCeldaSaldoProm
			FROM TMPREGULATORIOA2111 Tmp,
				 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
			 AND  Con.ReporteID = Var_ReporteID
             AND Con.Version = Version_Reporte;
	END IF;

	IF(Par_NumRep = Rep_Csv) THEN

		SELECT
			CONCAT(Nivel_Entidad,';', Con.CuentaCNBV,';',
					CASE WHEN Tmp.ConceptoID <= 7 THEN ROUND(IFNULL(Tmp.Indicador,Decimal_Cero) ,4)
												  ELSE ROUND(IFNULL(Tmp.Saldo, Decimal_Cero), 2)
                                                  END
			) AS Valor
			FROM TMPREGULATORIOA2111 Tmp,
				 CONCEPTOSREGREP Con
			WHERE Tmp.ConceptoID = Con.ConceptoID
				AND Con.ReporteID = Var_ReporteID
				AND Tmp.CuentaCNBV != Cadena_Vacia
                AND Con.Version = Version_Reporte
                AND Tmp.ConceptoID NOT IN (21,22,23,26,90);


	END IF;


	DROP TEMPORARY TABLE TMPREGULATORIOA2111;
	DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;
	DELETE FROM TMPREGCREDITOS WHERE NumTransaccion = Aud_NumTransaccion;
END TerminaStore$$