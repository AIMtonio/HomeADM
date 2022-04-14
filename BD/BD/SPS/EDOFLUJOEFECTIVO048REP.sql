-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOFLUJOEFECTIVO048REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOFLUJOEFECTIVO048REP`;

DELIMITER $$
CREATE PROCEDURE `EDOFLUJOEFECTIVO048REP`(
	-- SP para generar el Flujo de Efectivo del Cliente: NATGAS
	-- Modulo de Contabilidad --> Reportes --> Reportes Financieros

	Par_Ejercicio		INT(11),		-- Ejercicio de Consulta
	Par_Periodo			INT(11),		-- Periodo de Consulta
	Par_FechaActual		DATE,			-- Fecha Actual
	Par_TipoConsulta	CHAR(1),		-- Tipo de Consulta por D - Fecha o P - Periodo
	Par_SaldosCero		CHAR(1),		-- Indica si se muestran saldo en cero

	Par_Cifras			CHAR(1),		-- Indica si se va a mostrar en pesos redondeado a miles
	Par_CCInicial		INT(11),		-- Centro de Costo Inicial
	Par_CCFinal			INT(11),		-- Centro de Costo Final

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_ConceptoFinanID			INT(11);		-- Concepto Minimo Financiero
	DECLARE Var_ConceptoFinanIDMax		INT(11);		-- Concepto Maximo Financiero
	DECLARE Var_Contador				INT(11);		-- Contador de Ayuda en Ciclo
	DECLARE Var_ContadorWhile			INT(11);		-- Contador de Ayuda en Ciclo While
	DECLARE Var_MinCentroCostoID		INT(11);		-- Centro de Costo Minimo

	DECLARE Var_MaxCentroCostoID		INT(11);		-- Centro de Costo Maximo
	DECLARE Var_RegistroID				INT(11);		-- Numero de Registro
	DECLARE Var_EjercicioInicial		INT(11);		-- Ejercicio Inicial
	DECLARE Var_EjercicioFinal			INT(11);		-- Ejercicio Final
	DECLARE Var_PeriodoInicial			INT(11);		-- Periodo Inicial

	DECLARE Var_PeriodoFinal			INT(11);		-- Periodo Final
	DECLARE Var_NumCliente				INT(11);		-- Numero de Cliente
	DECLARE Var_IdxSignoMas 			INT(11);		-- Indice signo Mas
	DECLARE Var_IdxSignoMenos 			INT(11);		-- Indice signo Menos
	DECLARE Var_Bandera					INT(11);		-- Bandera que evalua un campo

	DECLARE Var_MesAct					INT(11);		-- Mes Actual
	DECLARE Var_MesIni					INT(11);		-- Mes inicial
	DECLARE Var_TipoConRegAct			CHAR(1);		-- Tipo Concepto Regulacion Actual
	DECLARE Var_TipoConRegAnt			CHAR(1);		-- Tipo Concepto Regulacion Anterior
	DECLARE Var_UbiSaldoContActual		CHAR(1);		-- Ubicacion Saldo Contable Actual

	DECLARE Var_UbiSaldoContAnterior	CHAR(1);		-- Ubicacion Saldo Contable Anterior
	DECLARE Var_UbicaSaldoContable		CHAR(1);		-- Ubicacion del Saldo Contable
	DECLARE Var_SignoOperacion			CHAR(1);		-- signo de la operacion
	DECLARE Var_AcumuladoCta 			DECIMAL(18,2);	-- Acomulado de la Cuenta
	DECLARE Var_AcumuladoCtaAux			DECIMAL(18,2);	-- Acomulado de la CuentaAux

	DECLARE Var_MontoCampo				DECIMAL(18,2);	-- Acomulado de la Cuenta
	DECLARE Var_FechaIniEjerAnt			DATE;			-- Fecha Inicio Ejercicio Actual
	DECLARE Var_FechaIniEjerAct			DATE;			-- Fecha Inicio Ejercicio Anterior
	DECLARE Par_FechaAnterior			DATE;			-- Fecha Anterior del Reporte
	DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio

	DECLARE	Var_FechaAct				DATE;			-- Fecha Actual del Reporte
	DECLARE Var_FechaCorte				DATE;			-- Fecha de Corte
	DECLARE Var_FecConsultaActual		DATE;			-- Fecha de Consulta Actual
	DECLARE Var_FecConsultaAnterior		DATE;			-- Fecha de Consulta Anterior
	DECLARE Var_FechaHistorica			DATE;			-- Fecha de Consulta Historica

	DECLARE Var_Presentacion			CHAR(1);		-- Tipo de Presentacion
	DECLARE Var_ClaveEntidad 			VARCHAR(10);	-- Entidad Financiera
	DECLARE Var_EdoNombreCampo			VARCHAR(300);	-- Nombre del Campo de Concepto Financier
	DECLARE Var_EdoMontoCargo			VARCHAR(30);	-- Monto de Cargo del concepto Financiero
	DECLARE Var_ContaGeneral			VARCHAR(250);	-- Contador General

	DECLARE Var_DirectGeneral			VARCHAR(250);	-- Director General
	DECLARE Var_DirectorFinanza 		VARCHAR(250);	-- Director de Finanzas
	DECLARE Var_FormulaContable			VARCHAR(300);	-- Formula Contable
	DECLARE Var_FormulaReporte			VARCHAR(300);	-- Catalogo de Concepto de Financiero
	DECLARE Var_Descripcion				VARCHAR(300);	-- Descripcion del Reporte

	DECLARE Var_CtaSegmento 			VARCHAR(300);	-- Segmento de Cuenta
	DECLARE Var_SegmentoAux				VARCHAR(300);	-- Segmento de Cuenta Auxiliar
	DECLARE Var_Texto					VARCHAR(1000);
	DECLARE Var_ConsultaEdoFin			TEXT;			-- Salida de conceptos Financiero

	DECLARE Var_FirmaRepLegal	        VARCHAR(200);   -- Firma Representante Legal
	DECLARE Var_FirmaCoordCont	        VARCHAR(200);   -- Firma Coordinardor Contable


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 				CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero					INT(11);		-- Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Entero Uno
	DECLARE Con_DosDecimales			INT(11);		-- Constante Dos Decimales
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Decimal Vacio

	DECLARE Con_Mil						DECIMAL(12,2);	-- Constante Mil
	DECLARE Fecha_Vacia					DATE;			-- Fecha Vacia
	DECLARE Con_UbiActual 				CHAR(1);		-- Ubicacion Actual
	DECLARE Con_UbiHistorica			CHAR(1);		-- Ubicacion Historica
	DECLARE Con_Fecha					CHAR(1);		-- Constante Fecha

	DECLARE Tipo_Miles					CHAR(1);		-- Tipo Miles de Pesos
	DECLARE Tipo_Fecha					CHAR(1);		-- Tipo de Fecha
	DECLARE Tipo_Periodo				CHAR(1);		-- Tipo de Periodo
	DECLARE Nivel_Encabezado			CHAR(1);		-- Nivel de Encabezado
	DECLARE Nivel_Detalle				CHAR(1);		-- Nivel de Detalle

	DECLARE Con_SI 						CHAR(1);		-- Constante SI
	DECLARE Signo_Mas					CHAR(1);		-- Signo Mas
	DECLARE Signo_Menos					CHAR(1);		-- Signo Menos
	DECLARE SaldoContableActual			CHAR(3);		-- Saldo Contable Actual
	DECLARE SaldoInicioFin				CHAR(3);		-- Saldo Actual-Anterior

	DECLARE SaldoFinInicio				CHAR(3);		-- Saldo Anterior-Actual
	DECLARE SaldoContableAnterior		CHAR(3);		-- Saldo Contable Anterior
	DECLARE Ope_ObtenSegmento			TINYINT UNSIGNED;-- Tipo de Operacion para obetener el segmento
	DECLARE Ope_EliminaSegmento			TINYINT UNSIGNED;-- Tipo de Operacion para eliminar el segmento

	-- Asignacion de Constantes
	SET Cadena_Vacia 		:= '';
	SET Entero_Cero 		:= 0;
	SET Entero_Uno			:= 1;
	SET Con_DosDecimales	:= 2;
	SET Decimal_Cero 		:= 0.0;

	SET Con_Mil				:= 1000;
	SET Fecha_Vacia 		:= '1900-01-01';
	SET Con_UbiActual 		:= 'A';
	SET Con_UbiHistorica 	:= 'H';
	SET Con_Fecha			:= 'F';

	SET Tipo_Miles			:= 'M';
	SET Tipo_Fecha			:= 'D';
	SET Tipo_Periodo		:= 'P';
	SET Nivel_Encabezado	:= 'E';
	SET Nivel_Detalle		:= 'D';

	SET Con_SI 				:= 'S';
	SET Signo_Mas			:= '+';
	SET Signo_Menos			:= '-';
	SET SaldoContableActual := 'SCI';
	SET SaldoInicioFin		:= 'SIF';

	SET SaldoFinInicio			:= 'SFI';
	SET SaldoContableAnterior	:= 'SCF';
	SET Ope_ObtenSegmento		:= 1;
	SET Ope_EliminaSegmento		:= 2;

	-- Se crean las Tablas Temporales
	-- Tabla de Salida
	DROP TABLE IF EXISTS TMP_EDOFINFLUJOEFECTIVOREP;
	CREATE TEMPORARY TABLE TMP_EDOFINFLUJOEFECTIVOREP(
		ConceptoFinanID		INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		CatConceptos		VARCHAR(15)		NOT NULL COMMENT 'Catalogo de Conceptos',
		ClaveCampo			VARCHAR(5)		NOT NULL COMMENT 'Clave de Campo',
		Descripcion			VARCHAR(300)	NOT NULL COMMENT 'Descripcion del Concepto Financiero',
		SaldoActual 		DECIMAL(16,2)	NOT NULL COMMENT 'Saldo Actual del Reporte',
		SaldoAnterior 		DECIMAL(16,2)	NOT NULL COMMENT 'Saldo Actual del Reporte',
		SaldoFinal			DECIMAL(16,2)	NOT NULL COMMENT 'Saldo Actual del Reporte',
		CampoReporte		VARCHAR(300)	NOT NULL COMMENT 'Campo a mostrar en reporte',
		Presentacion		CHAR(3)			NOT NULL COMMENT 'Presentación \n"SCI"- Saldo Contable Inicial \n"SIF".- Saldo Inicial-Final \n"SFI".- Saldo Final-Inicial \n"SCF".- Saldo Contable Final',
		NumeroTransaccion	BIGINT(20)		NOT NULL COMMENT 'Numero de transaccion',
		KEY `IDX_TMP_EDOFINFLUJOEFECTIVOREP_1` (`ConceptoFinanID`),
		KEY `IDX_TMP_EDOFINFLUJOEFECTIVOREP_2` (`NumeroTransaccion`));

	-- Tabla de Cuentas de Encabezado
	DROP TABLE IF EXISTS TMP_ENCEDOFINFLUJOEFECTIVO;
	CREATE TEMPORARY TABLE TMP_ENCEDOFINFLUJOEFECTIVO(
		RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
		ConceptoFinanID		INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		FormulaReporte		VARCHAR(300)	NOT NULL COMMENT 'Formula del Reportes "Este campo tiene prioridad sobre el campo FormulaContable"',
		NumeroTransaccion	BIGINT(20)		NOT NULL COMMENT 'Numero de transaccion',
		KEY `IDX_TMP_DETEDOFINFLUJOEFECTIVO_1` (`RegistroID`),
		KEY `IDX_TMP_ENCEDOFINFLUJOEFECTIVO_2` (`ConceptoFinanID`),
		KEY `IDX_TMP_ENCEDOFINFLUJOEFECTIVO_3` (`NumeroTransaccion`));

	-- Tablas de Cuentas de Detalle
	DROP TABLE IF EXISTS TMP_DETEDOFINFLUJOEFECTIVO;
	CREATE TEMPORARY TABLE TMP_DETEDOFINFLUJOEFECTIVO(
		RegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
		ConceptoFinanID		INT(11)			NOT NULL COMMENT 'Numero Consecutivo de Concepto',
		FormulaContable		VARCHAR(300)	NOT NULL COMMENT 'Formula Contable',
		NumeroTransaccion	BIGINT(20)		NOT NULL COMMENT 'Numero de transaccion',
		KEY `IDX_TMP_DETEDOFINFLUJOEFECTIVO_1` (`RegistroID`),
		KEY `IDX_TMP_DETEDOFINFLUJOEFECTIVO_2` (`ConceptoFinanID`),
		KEY `IDX_TMP_DETEDOFINFLUJOEFECTIVO_3` (`NumeroTransaccion`));

	SET Var_NumCliente		:= IFNULL(FNPARAMGENERALES('CliProcEspecifico'), 48);
	SET Var_FirmaRepLegal	:= IFNULL(FNPARAMGENERALES('RutaFirmaRepLegal'), Cadena_Vacia);
	SET Var_FirmaCoordCont	:= IFNULL(FNPARAMGENERALES('RutaFirmaCoordCont'), Cadena_Vacia);


	SELECT IFNULL(ClaveEntidad, Cadena_Vacia),	JefeContabilidad,	GerenteGeneral,		IFNULL(DirectorFinanzas, Cadena_Vacia)
	INTO   Var_ClaveEntidad,					Var_ContaGeneral,	Var_DirectGeneral,	Var_DirectorFinanza
	FROM PARAMETROSSIS
	LIMIT 1;

	SET Aud_NumTransaccion := ROUND(RAND()*1000000);

	SET Var_FechaInicio := DATE_ADD(DATE_FORMAT(DATE_SUB(Par_FechaActual, INTERVAL 1 YEAR),'%Y-12-31'), INTERVAL 1 DAY);
	SET Var_Texto = CONCAT('DEL 01 DE ENERO AL ', UPPER(FUNCIONLETRASFECHA(Par_FechaActual)));

	IF Par_CCInicial = Entero_Cero AND Par_CCFinal = Entero_Cero THEN
		SELECT MIN(CentroCostoID), 	 MAX(CentroCostoID)
		INTO 	Var_MinCentroCostoID,Var_MaxCentroCostoID
		FROM CENTROCOSTOS;
	ELSE
		SET Var_MinCentroCostoID := Par_CCInicial;
		SET Var_MaxCentroCostoID := Par_CCFinal;
	END IF;

	  /* Calculo de Fechas iniciales - ubicacion - ejercicio y periodo */
	SET Var_FecConsultaActual := Par_FechaActual;
	SET Var_FecConsultaAnterior := DATE_FORMAT(DATE_SUB(Par_FechaActual, INTERVAL 1 YEAR),'%Y-12-31');
	SET Par_FechaAnterior := Var_FecConsultaAnterior;

	SELECT MAX(FechaCorte)
	INTO Var_FechaCorte
	FROM SALDOSCONTABLES
	WHERE FechaCorte <= Var_FecConsultaAnterior;

	IF IFNULL(Var_FechaCorte,Fecha_Vacia) != Fecha_Vacia  THEN

		SELECT MAX(EjercicioID), 	MAX(PeriodoID)
		INTO   Var_EjercicioInicial,Var_PeriodoInicial
		FROM SALDOSCONTABLES
		WHERE FechaCorte = Var_FechaCorte;

		SET Var_FechaIniEjerAnt := DATE_ADD(Var_FechaCorte, INTERVAL 1 DAY);

		IF Var_FechaCorte = Var_FecConsultaAnterior THEN
			SET Var_TipoConRegAnt := Tipo_Periodo;
		ELSE
			SET Var_TipoConRegAnt := Tipo_Fecha;
		END IF;

	ELSE

		SET Var_EjercicioInicial := Entero_Cero;
		SET Var_PeriodoInicial   := Entero_Cero;
		SET Var_FechaIniEjerAnt  := Fecha_Vacia;
		SET Var_TipoConRegAnt    := Tipo_Fecha;

	END IF;

	IF(Var_FecConsultaAnterior <= Var_FechaCorte) THEN
		SET Var_UbiSaldoContAnterior := Con_UbiHistorica;
	ELSE
		SET Var_UbiSaldoContAnterior := Con_UbiActual;
	END IF;

	/* Calculo de Fechas Finales - ubicacion - ejercicio y periodo */
	SELECT	MAX(FechaCorte)
	INTO	Var_FechaHistorica
	FROM SALDOSCONTABLES
	WHERE FechaCorte <= Par_FechaActual;

	IF IFNULL(Var_FechaHistorica,Fecha_Vacia) != Fecha_Vacia THEN

		SELECT MAX(EjercicioID), 	MAX(PeriodoID)
		INTO Var_EjercicioFinal, 	Var_PeriodoFinal
		FROM SALDOSCONTABLES
		WHERE FechaCorte = Var_FechaHistorica;

		SET Var_FechaIniEjerAct := DATE_ADD(Var_FechaHistorica, INTERVAL 1 DAY);

		IF Var_FechaHistorica = Par_FechaActual THEN
			SET Var_TipoConRegAct := Tipo_Periodo;
		ELSE
			SET Var_TipoConRegAct := Tipo_Fecha;
		END IF;

	ELSE

		SET Var_EjercicioFinal  := Entero_Cero;
		SET Var_PeriodoFinal    := Entero_Cero;
		SET Var_FechaIniEjerAct := Fecha_Vacia;
		SET Var_TipoConRegAct   := Tipo_Fecha;

	END IF;

	IF(Par_FechaActual <= Var_FechaHistorica) THEN
		SET Var_UbiSaldoContActual := Con_UbiHistorica;
	ELSE
		SET Var_UbiSaldoContActual := Con_UbiActual;
	END IF;

	-- Fin Fechas Anteriores

	-- Se insertar las cuentas contables
	INSERT INTO TMP_EDOFINFLUJOEFECTIVOREP(
		ConceptoFinanID,	CatConceptos,		ClaveCampo,		Descripcion,
		SaldoActual,		SaldoAnterior,		SaldoFinal,		CampoReporte,
		Presentacion,		NumeroTransaccion)
	SELECT
		ConceptoFinanID,	CatConceptos,		ClaveCampo,		Descripcion,
		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,	CampoReporte,
		Presentacion,		Aud_NumTransaccion
	FROM EDOFLUJOEFECTIVO
	WHERE NumeroCliente = Var_NumCliente
	  AND MostrarCampo = Con_SI;

	-- Se insertar las cuentas contables de tipo encabezado
	INSERT INTO TMP_ENCEDOFINFLUJOEFECTIVO(
		RegistroID,		ConceptoFinanID,	FormulaReporte,		NumeroTransaccion)
	SELECT
		Entero_Cero,	ConceptoFinanID,	FormulaReporte,		Aud_NumTransaccion
	FROM EDOFLUJOEFECTIVO
	WHERE NumeroCliente = Var_NumCliente
	  AND FormulaReporte <> Cadena_Vacia
	  AND MostrarCampo = Con_SI;

	SET @Consecutivo := Entero_Cero;
	UPDATE TMP_ENCEDOFINFLUJOEFECTIVO SET
		RegistroID = (@Consecutivo:=(@Consecutivo + Entero_Uno))
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	-- Se insertar las cuentas contables de tipo detalle
	INSERT INTO TMP_DETEDOFINFLUJOEFECTIVO(
		RegistroID,		ConceptoFinanID,	FormulaContable,	NumeroTransaccion)
	SELECT
		Entero_Cero,	ConceptoFinanID,	FormulaContable,	Aud_NumTransaccion
	FROM EDOFLUJOEFECTIVO
	WHERE NumeroCliente = Var_NumCliente
	  AND FormulaContable <> Cadena_Vacia
	  AND MostrarCampo = Con_SI;

	SET @Consecutivo := Entero_Cero;
	UPDATE TMP_DETEDOFINFLUJOEFECTIVO SET
		RegistroID = (@Consecutivo:=(@Consecutivo + Entero_Uno))
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	-- Se evaluan los datos de la fecha Actual
	IF(Par_FechaActual <> Fecha_Vacia) THEN

		SET Var_Contador := Entero_Uno;

		SELECT IFNULL( MAX(RegistroID), Entero_Cero)
		INTO   Var_ConceptoFinanIDMax
		FROM TMP_DETEDOFINFLUJOEFECTIVO
		WHERE NumeroTransaccion = Aud_NumTransaccion;

		IF(Var_FecConsultaActual <= Var_FechaHistorica) THEN
			SET Var_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Var_UbicaSaldoContable := Con_UbiActual;
		END IF;

		-- Se evalua los registro de la tabla de formulas contables
		WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO

			-- Obtengo las formula contable y el campo a actualizar
			SELECT ConceptoFinanID,		FormulaContable
			INTO   Var_ConceptoFinanID,	Var_FormulaContable
			FROM TMP_DETEDOFINFLUJOEFECTIVO
			WHERE RegistroID = Var_Contador
			  AND NumeroTransaccion = Aud_NumTransaccion;

			SET Var_Descripcion := Cadena_Vacia;

			-- Si el ID existe en la tabla de configuracion  y la formula es diferente de vacia se evalua
			IF(Var_ConceptoFinanID > Entero_Cero) THEN
				IF(Var_FormulaContable <> Cadena_Vacia) THEN

					CALL EVALFORMULACONTAPRO(
						Var_FormulaContable,	Var_UbicaSaldoContable,	Var_TipoConRegAct,	Par_FechaActual,		Var_EjercicioFinal,
						Var_PeriodoFinal,		Var_FechaIniEjerAct,	Var_AcumuladoCta,	Var_MinCentroCostoID,	Var_MaxCentroCostoID,
						Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

					SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

					-- Si el parametro es en miles se divide
					IF Par_Cifras = Tipo_Miles THEN
						SET Var_AcumuladoCta := ROUND((Var_AcumuladoCta / Con_Mil), Con_DosDecimales);
					END IF;

				ELSE

					SET Var_AcumuladoCta := Decimal_Cero;

				END IF;

				-- Actualizo la tabla base/salida
				UPDATE TMP_EDOFINFLUJOEFECTIVOREP SET
					SaldoActual = Var_AcumuladoCta
				WHERE ConceptoFinanID = Var_ConceptoFinanID
				  AND NumeroTransaccion = Aud_NumTransaccion;

			END IF;

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_FormulaContable	:= Cadena_Vacia;
			SET Var_Descripcion		:= Cadena_Vacia;
			SET Var_Contador		:= Var_Contador + Entero_Uno;

		END WHILE;
	END IF;

	-- Se evaluan los datos de la fecha Anterior
	IF(Par_FechaAnterior <> Fecha_Vacia) THEN

		SET Var_Contador := Entero_Uno;

		-- Obtengo las formula contable y el campo a actualizar
		SELECT IFNULL( MAX(RegistroID), Entero_Cero)
		INTO   Var_ConceptoFinanIDMax
		FROM TMP_DETEDOFINFLUJOEFECTIVO
		WHERE NumeroTransaccion = Aud_NumTransaccion;

		IF(Var_FecConsultaAnterior <= Var_FechaHistorica) THEN
			SET Var_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Var_UbicaSaldoContable := Con_UbiActual;
		END IF;

		-- Se evalua los registro de la tabla de formulas contables
		WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO

			SELECT ConceptoFinanID,		FormulaContable
			INTO   Var_ConceptoFinanID,	Var_FormulaContable
			FROM TMP_DETEDOFINFLUJOEFECTIVO
			WHERE RegistroID = Var_Contador
			  AND NumeroTransaccion = Aud_NumTransaccion;

			-- Si el ID existe en la tabla de configuracion  y la formula es diferente de vacia se evalua
			IF(Var_ConceptoFinanID > Entero_Cero ) THEN
				IF(Var_FormulaContable <> Cadena_Vacia) THEN

					CALL EVALFORMULACONTAPRO(
						Var_FormulaContable,	Var_UbicaSaldoContable,	Var_TipoConRegAnt,	Var_FecConsultaAnterior,	Var_EjercicioInicial,
						Var_PeriodoInicial,		Var_FechaIniEjerAnt,	Var_AcumuladoCta,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
						Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

					SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero);

					-- Si el parametro es en miles se divide
					IF Par_Cifras = Tipo_Miles THEN
						SET Var_AcumuladoCta := ROUND((Var_AcumuladoCta / Con_Mil), Con_DosDecimales);
					END IF;

				ELSE

					SET Var_AcumuladoCta := Decimal_Cero;

				END IF;

				-- Actualizo la tabla base
				UPDATE TMP_EDOFINFLUJOEFECTIVOREP SET
					SaldoAnterior = Var_AcumuladoCta
				WHERE ConceptoFinanID = Var_ConceptoFinanID
				  AND NumeroTransaccion = Aud_NumTransaccion;

			END IF;

			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_FormulaContable	:= Cadena_Vacia;
			SET Var_Contador		:= Var_Contador + Entero_Uno;

		END WHILE;

		-- Se ajustan los saldos finales de acuerdo a la configuracion de salida
		UPDATE TMP_EDOFINFLUJOEFECTIVOREP SET
			SaldoFinal = CASE WHEN Presentacion = SaldoContableActual	THEN SaldoActual
							  WHEN Presentacion = SaldoInicioFin 		THEN SaldoActual - SaldoAnterior
							  WHEN Presentacion = SaldoFinInicio 		THEN SaldoAnterior - SaldoActual
							  WHEN Presentacion = SaldoContableAnterior THEN SaldoAnterior
						 END
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	END IF;

	SET Var_Contador := Entero_Uno;

	SELECT IFNULL( MAX(RegistroID), Entero_Cero)
	INTO   Var_ConceptoFinanIDMax
	FROM TMP_ENCEDOFINFLUJOEFECTIVO
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	-- Si existe al menos un registro de formula se ajusta el saldo final y se sustituye el monto calculado por la formula contable por
	-- el monto que se obtenga de la formula del reporte
	IF(Var_ConceptoFinanIDMax > Entero_Cero) THEN

		-- Inicio el recorrrido
		WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO


			-- Se evalua los registro de la tabla de formulas Reporte
			SELECT ConceptoFinanID,		FormulaReporte
			INTO   Var_ConceptoFinanID,	Var_FormulaReporte
			FROM TMP_ENCEDOFINFLUJOEFECTIVO
			WHERE RegistroID = Var_Contador
			  AND NumeroTransaccion = Aud_NumTransaccion;

			IF(Var_ConceptoFinanID > Entero_Cero ) THEN

				-- Elimino espacios en la formula
				SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
				SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
													THEN CONCAT(Signo_Mas, Var_FormulaReporte)
													ELSE Var_FormulaReporte END;


				-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
				IF((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) THEN
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN LEFT(Var_FormulaReporte, Var_IdxSignoMenos - Entero_Uno)
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN LEFT(Var_FormulaReporte, Var_IdxSignoMas - Entero_Uno )
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Mas, 2)
											   END;

						-- Elimino el segmento a evaluar de la formula
						SET Var_FormulaReporte := SUBSTRING( Var_FormulaReporte, LENGTH(Var_CtaSegmento)+ Entero_Uno, LENGTH(Var_FormulaReporte));

						-- Si la cadena cortada trae mas de un valor corto el primer segmento y el resto se agrega a la formula para su evaluacion
						IF((LOCATE(Signo_Mas, Var_CtaSegmento) > Entero_Cero OR LOCATE(Signo_Menos, Var_CtaSegmento) > Entero_Cero)) THEN

							-- Respaldo el Segmento de cadena
							SET Var_SegmentoAux := Var_CtaSegmento;

							-- Obtengo el nuevo Segmento
							IF((LOCATE(Signo_Mas, Var_CtaSegmento) > Entero_Cero)) THEN
								SET Var_CtaSegmento := SUBSTRING_INDEX(Var_CtaSegmento, Signo_Mas, 2);
							END IF;
							IF((LOCATE(Signo_Menos, Var_CtaSegmento) > Entero_Cero)) THEN
								SET Var_CtaSegmento := SUBSTRING_INDEX(Var_CtaSegmento, Signo_Menos, 2);
							END IF;

							-- Concateno el resto de la cadena a la formula para que se evalue
							SET Var_FormulaReporte := CONCAT(SUBSTRING(Var_SegmentoAux , LENGTH(Var_CtaSegmento)+Entero_Uno, length(Var_SegmentoAux)),Var_FormulaReporte);
						END IF;

						-- Obtengo el signo de la operacion
						SET Var_SignoOperacion := LEFT(Var_CtaSegmento, Entero_Uno);

						-- Obtengo el campo a evaluar
						SET Var_CtaSegmento := REPLACE( Var_CtaSegmento, Var_SignoOperacion, Cadena_Vacia);

						-- Se obtiene el monto de el campo
						SELECT SaldoFinal
						INTO Var_MontoCampo
						FROM TMP_EDOFINFLUJOEFECTIVOREP
						WHERE ClaveCampo = Var_CtaSegmento
						  AND NumeroTransaccion = Aud_NumTransaccion;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_SegmentoAux := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
					END WHILE;

					-- Actualizo la tabla base
					UPDATE TMP_EDOFINFLUJOEFECTIVOREP SET
						SaldoFinal = Var_AcumuladoCta
					WHERE ConceptoFinanID = Var_ConceptoFinanID
					  AND NumeroTransaccion = Aud_NumTransaccion;

				END IF;

			END IF;

			SET Var_MontoCampo		:= Decimal_Cero;
			SET Var_AcumuladoCta	:= Decimal_Cero;
			SET Var_Contador		:= Var_Contador + Entero_Uno;

		END WHILE;

	END IF;

	-- Se realizar cursor para la salida de los campo
	SET Var_ConsultaEdoFin := 'SELECT ';
	SET Var_Contador := Entero_Uno;

	SET Var_DirectorFinanza	:= CONCAT("Lic. ",Var_DirectorFinanza);
	SET Var_ContaGeneral	:= CONCAT("Lic. ",Var_ContaGeneral);
	SET Var_DirectGeneral	:= CONCAT("Lic. ",Var_DirectGeneral);

	SELECT IFNULL( MAX(ConceptoFinanID), Entero_Cero)
	INTO   Var_ConceptoFinanIDMax
	FROM TMP_EDOFINFLUJOEFECTIVOREP
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	-- Se arma el select de salida
	WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO

		SELECT CampoReporte,		SaldoFinal
		INTO   Var_EdoNombreCampo,	Var_EdoMontoCargo
		FROM TMP_EDOFINFLUJOEFECTIVOREP
		WHERE ConceptoFinanID = Var_Contador
		  AND NumeroTransaccion = Aud_NumTransaccion;

		IF( Var_EdoNombreCampo <> Cadena_Vacia  ) THEN
			SET Var_ConsultaEdoFin := CONCAT(Var_ConsultaEdoFin,' ',Var_EdoMontoCargo,' AS ', Var_EdoNombreCampo ,',');
		END IF;

		SET Var_Contador := Var_Contador + Entero_Uno;

	END WHILE;

	SET Var_ConsultaEdoFin := CONCAT(Var_ConsultaEdoFin,
									' "',Var_FirmaRepLegal,'" AS Par_FirmaRepLegal, ',
									' "',Var_FirmaCoordCont,'" AS Par_FirmaCoordCont, ',
									' "',Var_DirectorFinanza,'" AS Par_DirectorFinanzas, ',
									' "',Var_ContaGeneral,'" AS Par_JefeContabilidad, ',
									' "',Var_DirectGeneral,'" AS Par_GerenteGral, 0.00 AS Var_DecimalCero,"',
									 Var_Texto, '" AS Par_FechaPeriodo;');


	SET @SentenciaReg := (Var_ConsultaEdoFin);
	PREPARE EjecutaProcReg FROM @SentenciaReg;
	EXECUTE  EjecutaProcReg;
	DEALLOCATE PREPARE EjecutaProcReg;

	DROP TABLE IF EXISTS TMP_EDOFINFLUJOEFECTIVOREP;
	DROP TABLE IF EXISTS TMP_ENCEDOFINFLUJOEFECTIVO;
	DROP TABLE IF EXISTS TMP_DETEDOFINFLUJOEFECTIVO;

END TerminaStore$$
