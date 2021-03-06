-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA011100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA011100006REP`;
DELIMITER $$

CREATE PROCEDURE `REGA011100006REP`(

	Par_Anio           		INT,
	Par_Mes					INT,
	Par_NumRep				TINYINT UNSIGNED,
	Par_Version 			INT,

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion		BIGINT(20)

)
TerminaStore:BEGIN


	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FechaInicio			DATE;
	DECLARE Var_FechaFin			DATE;
	DECLARE Var_EjercicioVig		INT;
	DECLARE Var_PeriodoVig			INT;

	DECLARE Var_EjercicioID			INT;
	DECLARE Var_PeriodoID			INT;
	DECLARE Var_FechInicio			DATE;
	DECLARE Var_FechFin				DATE;
	DECLARE Var_FechaCorte			DATE;

	DECLARE Var_CCInicial			INT;
	DECLARE Var_CCFinal				INT;
	DECLARE Var_FechaCorteMax		DATE;
	DECLARE Var_NatMovimiento		CHAR(1);
	DECLARE Var_MaxEspacios			INT;

	DECLARE Var_ConceptoFinanID		INT;
	DECLARE Var_ConceptoFinanIDMax	INT;
	DECLARE Var_Formula				VARCHAR(200);
	DECLARE Var_SaldoCalculado		DECIMAL(18,2);
	DECLARE Var_ClaveNivInstitucion VARCHAR(10);

	DECLARE Var_AmortAcum			DECIMAL(16,2);
    DECLARE Var_MonedaExtID			INT;
    DECLARE Var_ValorMonedaExt		DECIMAL(16,2);
    DECLARE Var_FechaMoneda			DATE;
    DECLARE Saldo_Positivo			CHAR(1);

	DECLARE Saldo_Negativo			CHAR(2);
	DECLARE Cuenta_Detalle			CHAR(2);
	DECLARE Cuenta_Encabezado		CHAR(2);
	DECLARE Moneda_Nacional			INT;
	DECLARE Moneda_Extranjera		INT;

	DECLARE Clave_Reg				VARCHAR(3);

    DECLARE Var_TotActivo			DECIMAL(16,2);
    DECLARE Var_TotPasivo			DECIMAL(16,2);
    DECLARE Var_TotCapCon			DECIMAL(16,2);
    DECLARE Var_TotCapNeto1			DECIMAL(16,2);
    DECLARE Var_TotIngresos			DECIMAL(16,2);

    DECLARE Var_TotGastos			DECIMAL(16,2);
    DECLARE Var_TotCapNeto2			DECIMAL(16,2);
    DECLARE Var_Diferencia			DECIMAL(10,2);
    DECLARE Var_CarteraVig			DECIMAL(16,2);
    DECLARE Var_CarteraVen			DECIMAL(16,2);


	DECLARE Rep_Excel				INT(1);
	DECLARE Rep_Csv					INT(1);
	DECLARE Entero_Cero				INT(2);
	DECLARE Decimal_Cero			DECIMAL(21,2);
	DECLARE Cadena_Vacia			CHAR(1);

	DECLARE Fecha_Vacia				DATE;
	DECLARE Estatus_NoCerrado		CHAR(1);
	DECLARE VarDeudora				CHAR(1);
	DECLARE VarAcreedora			CHAR(1);
	DECLARE ConceptosCatMin			INT(2);

	DECLARE SaldosActuales			CHAR(1);
	DECLARE SaldosHistorico			CHAR(1);
	DECLARE PorFecha				CHAR(1);
	DECLARE version_anterior_2015 	INT;

	DECLARE version_2015			INT;
	DECLARE NumCliente				INT;


	SET version_anterior_2015	:=	2014;
	SET version_2015			:=	2015;
	SET Rep_Excel       		:= 	1;
	SET Rep_Csv					:= 	2;
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



	SELECT IFNULL(ValorParametro, Entero_Cero) INTO NumCliente
    FROM PARAMGENERALES
    WHERE  LlaveParametro = 'CliProcEspecifico';


	SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
	SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);

	SELECT IFNULL(ClaveNivInstitucion, Cadena_Vacia) INTO Var_ClaveNivInstitucion
    FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;


	SELECT IFNULL(FechaSistema, Fecha_Vacia),		IFNULL(EjercicioVigente, Entero_Cero),		IFNULL(PeriodoVigente, Entero_Cero) FROM PARAMETROSSIS LIMIT 1	INTO
					Var_FechaSistema,						Var_EjercicioVig,							Var_PeriodoVig;

	SELECT MIN(CentroCostoID), 	MAX(CentroCostoID) INTO
					Var_CCInicial, 		Var_CCFinal
				FROM CENTROCOSTOS;

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

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



	IF (Par_Version=version_2015) THEN

			IF (IFNULL(Var_EjercicioID, Entero_Cero) = Entero_Cero) THEN
				SELECT	MAX(EjercicioID),	 MAX(PeriodoID), 	MAX(Inicio), 		MAX(Fin) INTO
						Var_EjercicioID, 	Var_PeriodoID, 		Var_FechInicio, 	Var_FechFin
					FROM PERIODOCONTABLE
					WHERE Fin	<= Var_FechFin;
			END IF;


			DELETE FROM TMPREGCATMIN;
			DELETE FROM TMPCONTABLEBALANCE WHERE NumeroTransaccion = Aud_NumTransaccion;



			IF(Var_FechaFin >= IFNULL(Var_FechFin,Fecha_Vacia))THEN
					INSERT INTO TMPCONTABLEBALANCE(NumeroTransaccion, 			Fecha,				CuentaContable,			CentroCosto,		Naturaleza,
											Cargos,						Abonos,				SaldoDeudor,			SaldoAcreedor)
					SELECT 				 	Aud_NumTransaccion, 		Var_FechaFin,	 	Cue.CuentaCompleta,		Entero_Cero,		MAX(Cue.Naturaleza),
											SUM(IFNULL(Pol.Cargos, Decimal_Cero)),
											SUM(IFNULL(Pol.Abonos, Decimal_Cero)),
											CASE WHEN MAX(Cue.Naturaleza) = VarDeudora  THEN
													SUM( IFNULL(Pol.Cargos, Decimal_Cero)  - IFNULL(Pol.Abonos, Decimal_Cero) )
												 ELSE	Decimal_Cero
											END,
											CASE WHEN MAX(Cue.Naturaleza) =  VarAcreedora THEN
													SUM(IFNULL(Pol.Abonos, Decimal_Cero) - IFNULL(Pol.Cargos, Decimal_Cero) )
												 ELSE	Decimal_Cero
											END
					FROM CUENTASCONTABLES Cue
						  LEFT OUTER JOIN DETALLEPOLIZA AS Pol ON (Cue.CuentaCompleta = Pol.CuentaCompleta
			                                                             AND Pol.Fecha <= Var_FechaFin)
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
														SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero))
													ELSE
														Decimal_Cero
											END,
											CASE WHEN MAX(Cue.Naturaleza) = VarAcreedora
													THEN
														SUM(IFNULL(Sal.SaldoFinal, Decimal_Cero))
													ELSE
														Decimal_Cero
											END
					FROM CUENTASCONTABLES Cue,
						  SALDOSCONTABLES   Sal
						WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
							AND Sal.FechaCorte = Var_FechaCorte
					GROUP BY Cue.CuentaCompleta;


			END IF;




					INSERT INTO TMPREGCATMIN (	NumeroTransaccion,		ConceptoFinanID,		Fecha,				CuentaContable,			Naturaleza,
												Cargos,					Abonos,					SaldoInicialDeu,	SaldoInicialAcr, 		SaldoDeudor,
												SaldoAcreedor, CentroCosto)
					SELECT 						Aud_NumTransaccion, 	Con.ConceptoFinanID,	Var_FechaFin,		Con.CuentaContable,		MIN(Tmp.Naturaleza),
												MIN(Tmp.Cargos),				MIN(Tmp.Abonos),				Decimal_Cero,		Decimal_Cero,
												CASE WHEN MAX(Tmp.Naturaleza) = VarDeudora
														 THEN
															SUM(IFNULL((Tmp.SaldoInicialDeu), Decimal_Cero) -
															IFNULL((Tmp.SaldoInicialAcr), Decimal_Cero) +
																	(IFNULL(Tmp.SaldoDeudor, Decimal_Cero) -
																		IFNULL(Tmp.SaldoAcreedor, Decimal_Cero)))
														 ELSE
															Decimal_Cero
													END AS SaldoDeudorFin,
													CASE WHEN MAX(Tmp.Naturaleza) = VarAcreedora
															 THEN
																SUM(IFNULL((Tmp.SaldoInicialAcr), Entero_Cero) -
																IFNULL((Tmp.SaldoInicialDeu), Entero_Cero) +
																(	IFNULL(Tmp.SaldoAcreedor, Entero_Cero) -
																			IFNULL(Tmp.SaldoDeudor, Entero_Cero)))
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

				SET Var_FechaCorte	:= (SELECT MAX(FechaCorte) FROM  SALDOSCONTABLES WHERE FechaCorte <= Var_FechaFin);


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
							IF(Var_FechaFin >= IFNULL(Var_FechFin,Fecha_Vacia))THEN
									CALL EVALFORMULAREGPRO(Var_SaldoCalculado,			Var_Formula,	SaldosActuales,			PorFecha, 			Var_FechFin);
							ELSE
									CALL EVALFORMULAREGPRO(Var_SaldoCalculado,			Var_Formula,	SaldosHistorico,		PorFecha, 			Var_FechaCorte);

							END IF;

							UPDATE TMPREGCATMIN
								SET SaldoDeudor = Var_SaldoCalculado
							WHERE ConceptoFinanID 		= Var_ConceptoFinanID
								AND NumeroTransaccion	= Aud_NumTransaccion;


					END IF;


			    END WHILE;



			/*
            Actualiza saldos
            */
             DROP TABLE IF EXISTS TMPCAPMINIMO;
			CREATE TEMPORARY TABLE TMPCAPMINIMO
            SELECT Con.EstadoFinanID,Con.ConceptoFinanID,Con.NumClien,Con.Presentacion FROM
            CONCEPESTADOSFIN Con
			WHERE Con.EstadoFinanID = ConceptosCatMin
			AND Con.NumClien = NumCliente;


            UPDATE TMPREGCATMIN Tmp,TMPCAPMINIMO Cat SET
				Tmp.SaldoAcreedor		= ABS(Tmp.SaldoAcreedor) 	*-1,
				Tmp.SaldoDeudor			= ABS(Tmp.SaldoDeudor) 	*-1
			WHERE Tmp.ConceptoFinanID = Cat.ConceptoFinanID
            AND Cat.Presentacion = Saldo_Negativo;

            UPDATE TMPREGCATMIN Tmp,TMPCAPMINIMO Cat SET
				Tmp.SaldoAcreedor		= ABS(Tmp.SaldoAcreedor),
				Tmp.SaldoDeudor			= ABS(Tmp.SaldoDeudor)
			WHERE Tmp.ConceptoFinanID = Cat.ConceptoFinanID
            AND Cat.Presentacion = Saldo_Positivo;

            DROP TABLE IF EXISTS TMPCAPMINIMO;

            /* FIN SALDOS */


           DROP TABLE IF EXISTS TMPSALDOSFINCATMIN;
           CREATE  TABLE TMPSALDOSFINCATMIN
           	SELECT	Con.EstadoFinanID,	Con.ConceptoFinanID,	Con.Descripcion,	Con.Desplegado,	Con.CuentaContable,Con.Tipo,
						Con.EsCalculado,	Con.NombreCampo,		Con.Espacios,		Con.Negrita,	Con.Sombreado,
						Con.CombinarCeldas,	Tmp.NumeroTransaccion,	Tmp.Fecha,
						CASE WHEN Con.Desplegado = Cadena_Vacia THEN Cadena_Vacia
							 ELSE CASE WHEN Tmp.SaldoDeudor = Entero_Cero
											THEN ROUND(IFNULL(Tmp.SaldoAcreedor,Entero_Cero) ,Entero_Cero)
										ELSE	 ROUND(IFNULL(Tmp.SaldoDeudor,Entero_Cero),Entero_Cero)
								  END
							END AS Monto,Con.CuentaFija
				FROM 	CONCEPESTADOSFIN Con,
						TMPREGCATMIN Tmp
				WHERE 	Con.EstadoFinanID 		= ConceptosCatMin
					AND	Tmp.NumeroTransaccion	= Aud_NumTransaccion
					AND	Con.ConceptoFinanID		= Tmp.ConceptoFinanID
					AND Con.NumClien = NumCliente
				ORDER BY Con.ConceptoFinanID ASC;

				CREATE INDEX idx1 ON TMPSALDOSFINCATMIN(ConceptoFinanID);

           DROP TABLE IF EXISTS TMPCATDETALLE;
           CREATE TABLE TMPCATDETALLE
           SELECT * FROM TMPSALDOSFINCATMIN WHERE Tipo = Cuenta_Detalle;


		  DROP TABLE IF EXISTS TMPCATENCABE;
          CREATE TABLE TMPCATENCABE
           SELECT * FROM TMPSALDOSFINCATMIN WHERE Tipo = Cuenta_Encabezado;

			DROP TABLE IF EXISTS TMPSALDOFINALCATMIN;
			CREATE temporary TABLE TMPSALDOFINALCATMIN
			 SELECT enc.ConceptoFinanID,enc.CuentaContable,
			 SUM(IFNULL(det.Monto,0)) AS Monto
			 FROM TMPCATENCABE enc
			 LEFT OUTER JOIN TMPCATDETALLE det
			 ON det.CuentaContable LIKE enc.CuentaContable
			 GROUP BY enc.CuentaContable,enc.ConceptoFinanID
			 ORDER BY enc.ConceptoFinanID ;


			UPDATE TMPSALDOSFINCATMIN tmp,TMPSALDOFINALCATMIN sal
			SET tmp.Monto = IFNULL(sal.Monto,0)
			WHERE tmp.ConceptoFinanID = sal.ConceptoFinanID;

			DELETE FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = Par_Anio
				AND   Mes  = Par_Mes;

			INSERT INTO `HIS-CATALOGOMINIMO`
					(Anio, 		Mes, 	 ConceptoFinanID,  CuentaContable,  Monto, MonedaExt)
            SELECT
					Par_Anio, 	Par_Mes, Tmp.ConceptoFinanID,  IFNULL(Con.CuentaFija,Cadena_Vacia), 		Tmp.Monto, Decimal_Cero
            FROM TMPSALDOSFINCATMIN Tmp, CONCEPESTADOSFIN	Con
			WHERE Con.EstadoFinanID 		= ConceptosCatMin
				AND	Con.ConceptoFinanID		= Tmp.ConceptoFinanID
				AND Con.NumClien = NumCliente
				 ORDER BY Con.ConceptoFinanID;

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
						Con.CombinarCeldas,	Con.NumeroTransaccion,	Con.Fecha,			Var_MaxEspacios AS MaxEspacios,Con.Monto, Con.CuentaFija
				FROM 	TMPSALDOSFINCATMIN Con
                ORDER BY Con.ConceptoFinanID;

			END IF;

			IF(Par_NumRep = Rep_Csv) THEN


				(SELECT com.Valor
					FROM
					(SELECT	IFNULL(CONCAT (Var_ClaveNivInstitucion,';',CON.CuentaFija,';',Clave_Reg,';',
									Monto), Cadena_Vacia) AS Valor, IFNULL(CON.CuentaFija,'') AS cta
							FROM 	TMPSALDOSFINCATMIN 		TMP,
									CONCEPESTADOSFIN	CON
						WHERE 	CON.EstadoFinanID 		= ConceptosCatMin
							AND	TMP.NumeroTransaccion	= Aud_NumTransaccion
							AND	CON.ConceptoFinanID		= TMP.ConceptoFinanID
							AND CON.NumClien = NumCliente
						ORDER BY CON.ConceptoFinanID
					)AS com
					WHERE com.cta <> '');

			END IF;


		END IF;

END TerminaStore$$