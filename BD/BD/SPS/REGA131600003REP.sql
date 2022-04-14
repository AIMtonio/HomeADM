-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA131600003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA131600003REP`;
DELIMITER $$

CREATE PROCEDURE `REGA131600003REP`(
	Par_FechaActual		DATE,
	Par_FechaAnterior	DATE,
	Par_TipoConsulta 	CHAR(1),
	Par_EmpresaID 		INT,
	Aud_Usuario 		INT,

	Aud_FechaActual 	DATETIME,
	Aud_DireccionIP 	VARCHAR(15),
	Aud_ProgramaID 		VARCHAR(50),
	Aud_Sucursal 		INT,
	Aud_NumTransaccion 	BIGINT

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FecConsultaActual			DATE;
	DECLARE Var_FecConsultaAnterior			DATE;
	DECLARE Var_FechaHistorica				DATE;
	DECLARE Var_FechaDetallePoliza			DATE;

	DECLARE Var_AcumuladoCta 				DECIMAL(18,2);
	DECLARE Var_DecimalCero 				DECIMAL(18,2);
	DECLARE Var_ActResultadoNeto			DECIMAL(18,2);
	DECLARE Var_ActAjustesPartida 			DECIMAL(18,2);
	DECLARE Var_ActFlujoNetoOperacion		DECIMAL(18,2);

	DECLARE Var_ActFlujoNetoInversion 		DECIMAL(18,2);
	DECLARE Var_ActFlujoNetoFinanciamiento 	DECIMAL(18,2);
	DECLARE Var_AntResultadoNeto			DECIMAL(18,2);
	DECLARE Var_AntAjustesPartida 			DECIMAL(18,2);
	DECLARE Var_AntFlujoNetoOperacion 		DECIMAL(18,2);

	DECLARE Var_AntFlujoNetoInversion 		DECIMAL(18,2);
	DECLARE Var_AntFlujoNetoFinanciamiento 	DECIMAL(18,2);
	DECLARE Var_EfectivoNeto 				DECIMAL(18,2);
	DECLARE Var_TotalEfectivo 				DECIMAL(18,2);
	DECLARE Var_EfectivoInicioPeriodo 		DECIMAL(18,2);

	DECLARE Var_EfectivoNetoEquivalente		DECIMAL(18,2);
	DECLARE Var_ResultadoNeto				VARCHAR(10);
	DECLARE Var_AjustesPartida				VARCHAR(10);
	DECLARE Var_FlujoNetoOperacion			VARCHAR(10);
	DECLARE Var_FlujoNetoInversion			VARCHAR(10);

	DECLARE Var_FlujoNetoFinanciamiento		VARCHAR(10);
	DECLARE Var_Formula						VARCHAR(200);
	DECLARE Var_NombreFormula 				VARCHAR(200);
	DECLARE Var_Descripcion					VARCHAR(200);

	DECLARE Var_ClaveEntidad 				VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_ConceptoFinanID				INT;
	DECLARE Var_ConceptoFinanIDMax			INT;

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia 					DATE;
	DECLARE Decimal_Cero 					DECIMAL(12,2);
	DECLARE Entero_Cero 					INT;
	DECLARE Tif_Balance 					INT;

	DECLARE Contador 						INT;
	DECLARE Reporte_Excel					INT;
	DECLARE Reporte_Csv						INT;
	DECLARE Con_NumCliente					INT;
	DECLARE Con_TipoReporte					INT;
	DECLARE Con_TipoSaldo					INT;

	DECLARE Grupo_ResulNeto					INT;
	DECLARE Grupo_AjustePartidas			INT;
	DECLARE Grupo_FlujoNetoOperacion		VARCHAR(10);
	DECLARE Grupo_FlujoNetoInversion		VARCHAR(10);
	DECLARE Grupo_FlujoNetoFinanciamiento	VARCHAR(10);

	DECLARE Con_NetoEfectivoEquivalente		VARCHAR(20);
	DECLARE Con_CambioEfectivoEquivalente	VARCHAR(20);
	DECLARE Con_EfectivoInicioPeriodo		VARCHAR(20);
	DECLARE Con_EfectivoFinPeriodo			VARCHAR(20);
	DECLARE Con_FlujoNetoOperacion 			VARCHAR(20);

	DECLARE Con_FlujoNetoInversion 			VARCHAR(20);
	DECLARE Con_FlujoNetoFinanciamiento		VARCHAR(20);
	DECLARE Con_AjustePartidas				VARCHAR(20);
	DECLARE Cadena_Vacia 					CHAR(1);
	DECLARE Con_UbiActual 					CHAR(1);
	DECLARE Con_UbiHistorica				CHAR(1);

	DECLARE Con_UbicaSaldoContable			CHAR(1);
	DECLARE Con_Fecha						CHAR(1);

	DECLARE cur_Balance CURSOR FOR
		SELECT CuentaContable,	SaldoDeudor
		FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion
		ORDER BY CuentaContable;

	-- Asignacion de Constantes
	SET Entero_Cero 		:= 0;					-- Entero Cero
	SET Decimal_Cero 		:= 0.0;					-- DECIMAL Cero
	SET Cadena_Vacia 		:= '';					-- Cadena Vacia
	SET Fecha_Vacia 		:= '1900-01-01';		-- Fecha Vacia
	SET Con_UbiActual 		:= 'A'; 				-- Ubicacion: Actual
	SET Con_UbiHistorica 	:= 'H'; 				-- Ubicacion: Historica
	SET Tif_Balance 		:= 4; 					-- Estado Finaciero: Balance
	SET Con_Fecha			:= 'F';					-- Tipo: Calculo por Fecha
	SET Con_TipoReporte		:= 1316;				-- Tipo de Regulatorio
	SET Con_TipoSaldo		:= 1;					-- Tipo de Saldo para el Regulatorio
	SET Reporte_Excel		:= 1;
	SET Reporte_Csv			:= 2;

	SET Grupo_ResulNeto					:= '82010350';
	SET Grupo_AjustePartidas			:= '82010360';
	SET Grupo_FlujoNetoOperacion		:= '820103';
	SET Grupo_FlujoNetoInversion		:= '820104';
	SET Grupo_FlujoNetoFinanciamiento	:= '820105';

	SET Con_NetoEfectivoEquivalente		:= '820100000000';
	SET Con_EfectivoInicioPeriodo		:= '820200000000';
	SET Con_EfectivoFinPeriodo			:= '820000000000';
	SET Con_FlujoNetoOperacion 			:= '820103000000';
	SET Con_FlujoNetoInversion 			:= '820104000000';

	SET Con_FlujoNetoFinanciamiento		:= '820105000000';
	SET Con_AjustePartidas				:= '820103600000';

	DELETE FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	SELECT IFNULL(ValorParametro, Entero_Cero) INTO Con_NumCliente
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'CliProcEspecifico';

	SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	SET Var_FecConsultaActual := Par_FechaActual ;
	SET Var_FecConsultaAnterior := Par_FechaAnterior ;

	SELECT MAX(Fecha) INTO Var_FechaHistorica
		FROM `HIS-DETALLEPOL`;

	SELECT MAX(Fecha) INTO Var_FechaDetallePoliza
		FROM DETALLEPOLIZA;

	SET Var_ConceptoFinanID := Entero_Cero;

	SET Var_ConceptoFinanIDMax := (SELECT MAX(ConceptoFinanID)
		FROM CONCEPESTADOSFIN WHERE EstadoFinanID = Tif_Balance AND NumClien = Con_NumCliente);

	-- FECHA ACTUAL --
	IF(Par_FechaActual <> Fecha_Vacia) THEN

		SET Contador := 1;
		SET Var_ActResultadoNeto	:= 0;
		SET Var_ActAjustesPartida	:= 0;
		SET Var_ActFlujoNetoOperacion := 0;
		SET Var_ActFlujoNetoInversion := 0;
		SET Var_ActFlujoNetoFinanciamiento := 0;
		SET Var_TotalEfectivo := 0;

		IF(Var_FecConsultaActual <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;

		WHILE (Contador <= Var_ConceptoFinanIDMax) DO

			SELECT ConceptoFinanID INTO
					Var_ConceptoFinanID
			 FROM CONCEPESTADOSFIN
			 WHERE ConceptoFinanID = contador
				AND (LOCATE('+', CuentaContable) > Entero_Cero OR LOCATE('-', CuentaContable) > Entero_Cero)
				AND EstadoFinanID = Tif_Balance AND NumClien = Con_NumCliente
						 ORDER BY ConceptoFinanID;

			SELECT CuentaFija, CuentaContable , Desplegado INTO
					Var_NombreFormula, Var_Formula, Var_Descripcion
			FROM CONCEPESTADOSFIN
			WHERE 	EstadoFinanID = Tif_Balance AND
					ConceptoFinanID = Contador AND NumClien = Con_NumCliente
					 ORDER BY ConceptoFinanID;

			SELECT SUBSTRING(Var_NombreFormula, 1, 8) INTO Var_ResultadoNeto;
			SELECT SUBSTRING(Var_NombreFormula, 1, 8) INTO Var_AjustesPartida;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoOperacion;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoInversion;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoFinanciamiento;

			IF(Var_ConceptoFinanID > Entero_Cero ) THEN
				IF(Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
					INSERT INTO TMPBALANZACONTA
					 (	`NumeroTransaccion`,`CuentaContable`, 	`Grupo`, 		`SaldoInicialDeu`, `SaldoInicialAcre`,
						`Cargos`, 			`Abonos`, 			`SaldoDeudor`, 	`SaldoAcreedor`, 	`DescripcionCuenta`,
						`CuentaMayor`, 		`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	Var_NombreFormula, 	Cadena_Vacia, 							Entero_Cero, 	Entero_Cero,
						Entero_Cero, 			Entero_Cero, 		IFNULL(Var_AcumuladoCta,Decimal_Cero), 	Entero_Cero, 	Var_Descripcion,
						Cadena_Vacia, 			Cadena_Vacia);

					IF(Var_FlujoNetoInversion = Grupo_FlujoNetoInversion) THEN
						SET Var_ActFlujoNetoInversion := Var_ActFlujoNetoInversion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_FlujoNetoFinanciamiento = Grupo_FlujoNetoFinanciamiento) THEN
						SET Var_ActFlujoNetoFinanciamiento := Var_ActFlujoNetoFinanciamiento + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_ResultadoNeto = Grupo_ResulNeto) THEN
						SET Var_ActResultadoNeto := Var_ActResultadoNeto + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSEIF(Var_AjustesPartida = Grupo_AjustePartidas) THEN
						SET Var_ActAjustesPartida := Var_ActAjustesPartida + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSE
						IF(Var_FlujoNetoOperacion = Grupo_FlujoNetoOperacion) THEN
							SET Var_ActFlujoNetoOperacion := Var_ActFlujoNetoOperacion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
						END IF;
					END IF;
				ELSE
					INSERT INTO TMPBALANZACONTA
					 (	`NumeroTransaccion`,`CuentaContable`, 	`Grupo`, 		`SaldoInicialDeu`, `SaldoInicialAcre`,
						`Cargos`, 			`Abonos`, 			`SaldoDeudor`, 	`SaldoAcreedor`, 	`DescripcionCuenta`,
						`CuentaMayor`, 		`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	Var_NombreFormula, 	Cadena_Vacia, 	Entero_Cero, 	Entero_Cero,
						Entero_Cero, 			Entero_Cero, 		Decimal_Cero, 	Entero_Cero, 	Var_Descripcion,
						Cadena_Vacia, 			Cadena_Vacia);
                END IF;

			ELSE
				IF(Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
					INSERT INTO TMPBALANZACONTA
					 (	`NumeroTransaccion`,`CuentaContable`, 	`Grupo`, 		`SaldoInicialDeu`, `SaldoInicialAcre`,
						`Cargos`, 			`Abonos`, 			`SaldoDeudor`, 	`SaldoAcreedor`, 	`DescripcionCuenta`,
						`CuentaMayor`, 		`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	Var_NombreFormula, 	Cadena_Vacia, 								Entero_Cero, 	Entero_Cero,
						Entero_Cero, 			Entero_Cero, 		IFNULL(Var_AcumuladoCta,Decimal_Cero), 	Entero_Cero, 	Var_Descripcion,
						Cadena_Vacia, 			Cadena_Vacia);
					IF(Var_FlujoNetoInversion = Grupo_FlujoNetoInversion) THEN
						SET Var_ActFlujoNetoInversion := Var_ActFlujoNetoInversion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_FlujoNetoFinanciamiento = Grupo_FlujoNetoFinanciamiento) THEN
						SET Var_ActFlujoNetoFinanciamiento := Var_ActFlujoNetoFinanciamiento + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_ResultadoNeto = Grupo_ResulNeto) THEN
						SET Var_ActResultadoNeto := Var_ActResultadoNeto + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
						ELSEIF(Var_AjustesPartida = Grupo_AjustePartidas) THEN
						SET Var_ActAjustesPartida := Var_ActAjustesPartida + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSE
						IF(Var_FlujoNetoOperacion = Grupo_FlujoNetoOperacion) THEN
							SET Var_ActFlujoNetoOperacion := Var_ActFlujoNetoOperacion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
						END IF;
					END IF;
				ELSE
					INSERT INTO TMPBALANZACONTA
					 (	`NumeroTransaccion`,`CuentaContable`, 	`Grupo`, 		`SaldoInicialDeu`, `SaldoInicialAcre`,
						`Cargos`, 			`Abonos`, 			`SaldoDeudor`, 	`SaldoAcreedor`, 	`DescripcionCuenta`,
						`CuentaMayor`, 		`CentroCosto`)
					VALUES(
						Aud_NumTransaccion, 	Var_NombreFormula, 	Cadena_Vacia, 	Entero_Cero, 	Entero_Cero,
						Entero_Cero, 			Entero_Cero, 		Decimal_Cero, 	Entero_Cero, 	Var_Descripcion,
						Cadena_Vacia, 			Cadena_Vacia);
                END IF;
			END IF;
			SET Contador := Contador +1;

		END WHILE;

		UPDATE TMPBALANZACONTA SET
				SaldoDeudor = Var_ActAjustesPartida
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_AjustePartidas;

		UPDATE TMPBALANZACONTA SET
				SaldoDeudor = Var_ActFlujoNetoOperacion
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_FlujoNetoOperacion;

		UPDATE TMPBALANZACONTA SET
			SaldoDeudor = Var_ActFlujoNetoInversion
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_FlujoNetoInversion;

		UPDATE TMPBALANZACONTA SET
			SaldoDeudor = Var_ActFlujoNetoFinanciamiento
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_FlujoNetoFinanciamiento;

		SET Var_TotalEfectivo := Var_ActFlujoNetoOperacion + Var_ActFlujoNetoInversion + Var_ActFlujoNetoFinanciamiento + Var_ActResultadoNeto + Var_ActAjustesPartida;

		UPDATE TMPBALANZACONTA SET
			SaldoDeudor = Var_TotalEfectivo
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= Con_NetoEfectivoEquivalente;

	END IF; -- FIN FECHA ACTUAL

	-- FECHA ANTERIOR
	IF(Par_FechaAnterior <> Fecha_Vacia) THEN

		SET Contador := 1;
		SET Var_AntResultadoNeto	:= 0;
		SET Var_AntAjustesPartida	:= 0;
		SET Var_AntFlujoNetoOperacion := 0;
		SET Var_AntFlujoNetoInversion := 0;
		SET Var_AntFlujoNetoFinanciamiento := 0;
		SET Var_TotalEfectivo := 0;

		IF(Var_FecConsultaAnterior <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;

		WHILE (Contador <= Var_ConceptoFinanIDMax) DO

			SELECT ConceptoFinanID INTO
					Var_ConceptoFinanID
				 FROM CONCEPESTADOSFIN
				 WHERE ConceptoFinanID = contador
					AND (LOCATE('+', CuentaContable) > Entero_Cero OR LOCATE('-', CuentaContable) > Entero_Cero)
					AND EstadoFinanID = Tif_Balance AND NumClien = Con_NumCliente
							 ORDER BY ConceptoFinanID;

			SELECT CuentaFija, CuentaContable , Desplegado INTO
					Var_NombreFormula, Var_Formula, Var_Descripcion
				FROM CONCEPESTADOSFIN
				WHERE 	EstadoFinanID = Tif_Balance AND
						ConceptoFinanID = Contador AND NumClien = Con_NumCliente
						 ORDER BY ConceptoFinanID;

			SELECT SUBSTRING(Var_NombreFormula, 1, 8) INTO Var_ResultadoNeto;
			SELECT SUBSTRING(Var_NombreFormula, 1, 8) INTO Var_AjustesPartida;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoOperacion;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoInversion;
			SELECT SUBSTRING(Var_NombreFormula, 1, 6) INTO Var_FlujoNetoFinanciamiento;

		 	IF(Var_ConceptoFinanID > Entero_Cero ) THEN
				IF(Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaAnterior);
						UPDATE TMPBALANZACONTA SET
							SaldoAcreedor = ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2),
							Cargos = SaldoDeudor - ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2)
						WHERE NumeroTransaccion = Aud_NumTransaccion AND
								CuentaContable 	= Var_NombreFormula;
					IF(Var_FlujoNetoInversion = Grupo_FlujoNetoInversion) THEN
						SET Var_AntFlujoNetoInversion := Var_AntFlujoNetoInversion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_FlujoNetoFinanciamiento = Grupo_FlujoNetoFinanciamiento) THEN
						SET Var_AntFlujoNetoFinanciamiento := Var_AntFlujoNetoFinanciamiento + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_ResultadoNeto = Grupo_ResulNeto) THEN
						SET Var_AntResultadoNeto := Var_AntResultadoNeto + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSEIF(Var_AjustesPartida = Grupo_AjustePartidas) THEN
						SET Var_AntAjustesPartida := Var_AntAjustesPartida + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSE
						IF(Var_FlujoNetoOperacion = Grupo_FlujoNetoOperacion) THEN
							SET Var_AntFlujoNetoOperacion := Var_AntFlujoNetoOperacion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
						END IF;
					END IF;
				ELSE
					UPDATE TMPBALANZACONTA SET
							SaldoAcreedor = Decimal_Cero,
							Cargos = SaldoDeudor - Decimal_Cero
						WHERE NumeroTransaccion = Aud_NumTransaccion AND
								CuentaContable 	= Var_NombreFormula;
                END IF;
			ELSE
				IF(Var_Formula <> Cadena_Vacia) THEN
					CALL EVALFORMULAREGPRO(Var_AcumuladoCta, Var_Formula, Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaAnterior);

					UPDATE TMPBALANZACONTA SET
							SaldoAcreedor = ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2),
							Cargos = SaldoDeudor - ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2)
						WHERE NumeroTransaccion = Aud_NumTransaccion AND
							  CuentaContable 	= Var_NombreFormula;

					IF(Var_FlujoNetoInversion = Grupo_FlujoNetoInversion) THEN
						SET Var_AntFlujoNetoInversion := Var_AntFlujoNetoInversion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_FlujoNetoFinanciamiento = Grupo_FlujoNetoFinanciamiento) THEN
						SET Var_AntFlujoNetoFinanciamiento := Var_AntFlujoNetoFinanciamiento + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					END IF;
					IF(Var_ResultadoNeto = Grupo_ResulNeto) THEN
						SET Var_AntResultadoNeto := Var_AntResultadoNeto + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSEIF (Var_AjustesPartida = Grupo_AjustePartidas) THEN
						SET Var_AntAjustesPartida := Var_AntAjustesPartida + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
					ELSE
						IF(Var_FlujoNetoOperacion = Grupo_FlujoNetoOperacion) THEN
							SET Var_AntFlujoNetoOperacion := Var_AntFlujoNetoOperacion + ROUND(IFNULL(Var_AcumuladoCta,Decimal_Cero),2);
						END IF;
					END IF;
                ELSE
					UPDATE TMPBALANZACONTA SET
							SaldoAcreedor = Decimal_Cero,
							Cargos = SaldoDeudor - Decimal_Cero
						WHERE NumeroTransaccion = Aud_NumTransaccion AND
								CuentaContable 	= Var_NombreFormula;
                END IF;
			END IF;
			SET Contador := Contador + 1;

		END WHILE;

        /* Se actualiza el Ajuste por partida */
		UPDATE TMPBALANZACONTA SET
				Cargos = Entero_Cero,
				SaldoAcreedor =  Entero_Cero ,
                SaldoDeudor = Entero_Cero
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	IN (
					'820103600000','820103000000','820104000000','820105000000'
                );


		UPDATE TMPBALANZACONTA SET
				Cargos = Cargos * -1 ,
				SaldoAcreedor =  SaldoAcreedor * -1 ,
                SaldoDeudor = SaldoDeudor * -1
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	IN (
					'820103600200','820103060000','820103100000','820103240000',
                    '820104020000'
                );

		SELECT SUM(Cargos) INTO Var_AntAjustesPartida
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	LIKE '8201036%';

        SELECT SUM(Cargos) INTO Var_AntFlujoNetoOperacion
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	LIKE '820103%';

        SELECT SUM(Cargos) INTO Var_AntFlujoNetoInversion
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	LIKE '820104%';

        SELECT SUM(Cargos) INTO Var_AntFlujoNetoFinanciamiento
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	LIKE '820105%';

		UPDATE TMPBALANZACONTA SET
				Cargos = IFNULL(Var_AntAjustesPartida,Entero_Cero)
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_AjustePartidas;

		-- Se actualiza el flujo neto de operacion
		UPDATE TMPBALANZACONTA SET
			Cargos = IFNULL(Var_AntFlujoNetoOperacion,Entero_Cero)
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_FlujoNetoOperacion;

		-- Se actualiza el flujo neto de la inversion
		UPDATE TMPBALANZACONTA SET
			Cargos = IFNULL(Var_AntFlujoNetoInversion,Entero_Cero)
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= Con_FlujoNetoInversion;

		-- Se actualiza el flujo neto de Financiamiento
		UPDATE TMPBALANZACONTA SET
			Cargos = IFNULL(Var_AntFlujoNetoFinanciamiento,Entero_Cero)
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= Con_FlujoNetoFinanciamiento;

		SET Var_TotalEfectivo := Var_AntFlujoNetoOperacion + Var_AntFlujoNetoInversion + Var_AntFlujoNetoFinanciamiento;

		-- Se actualiza el Incremento o disminucion neta de efectivo y equivalentes de efectivo
		UPDATE TMPBALANZACONTA SET
			SaldoAcreedor = Var_TotalEfectivo,
			Cargos = Var_TotalEfectivo
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= Con_NetoEfectivoEquivalente;

		-- Se actualiza el Efectivo y equivalentes de efectivo al inicio del periodo
		UPDATE TMPBALANZACONTA SET
			Cargos = SaldoAcreedor
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= Con_EfectivoInicioPeriodo;


		SELECT Cargos INTO Var_EfectivoNetoEquivalente
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
						CuentaContable 	= Con_NetoEfectivoEquivalente;

		SELECT Cargos INTO Var_EfectivoInicioPeriodo
			FROM TMPBALANZACONTA
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
						CuentaContable 	= Con_EfectivoInicioPeriodo;


		UPDATE TMPBALANZACONTA SET
			Cargos = Var_EfectivoInicioPeriodo + Var_EfectivoNetoEquivalente ,
			SaldoDeudor = Decimal_Cero,
			SaldoAcreedor = Decimal_Cero
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= Con_EfectivoFinPeriodo;

		UPDATE TMPBALANZACONTA SET
			Cargos = NULL
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
					CuentaContable 	= '';
	END IF; -- FIN PERIODO ANTERIOR


 IF(Reporte_Excel = Par_TipoConsulta) THEN

		SELECT balanza.NumeroTransaccion, balanza.CuentaContable, CONCAT( CASE WHEN conceptos.Negrita = 'N' THEN '          ' ELSE '' END, balanza.DescripcionCuenta) AS DescripcionCuenta, IFNULL(balanza.Cargos,'') AS Cargos, conceptos.Negrita
		FROM TMPBALANZACONTA balanza
		INNER JOIN CONCEPESTADOSFIN conceptos ON conceptos.CuentaFija = balanza.CuentaContable
		WHERE balanza.NumeroTransaccion = Aud_NumTransaccion AND conceptos.EstadoFinanID = Tif_Balance AND conceptos.NumClien = Con_NumCliente
		AND conceptos.CuentaFija = balanza.CuentaContable AND balanza.DescripcionCuenta= conceptos.Descripcion;

		DELETE FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	ELSE

		SELECT (CONCAT(CuentaContable,';',Con_TipoReporte,';',Con_TipoSaldo,';', ROUND(Cargos,2))) AS Valor
		FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion AND
		CuentaContable <> Cadena_Vacia;

		DELETE FROM TMPBALANZACONTA
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	END IF;

END TerminaStore$$