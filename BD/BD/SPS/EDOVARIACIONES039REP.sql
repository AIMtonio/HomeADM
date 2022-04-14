-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOVARIACIONES039REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOVARIACIONES039REP`;

DELIMITER $$
CREATE PROCEDURE `EDOVARIACIONES039REP`(
	-- SP para generar el Estado de Variacion de Capital MEXI - REGIO
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

	-- Declaracion  de Variables
	DECLARE Var_ConceptoFinanIDMax		INT(11);		-- Maximo Numero de Conceptos
	DECLARE Var_EjercicioInicial		INT(11);		-- Ejercicio Inicial
	DECLARE Var_EjercicioFinal			INT(11);		-- Ejercicio Final
	DECLARE Var_PeriodoInicial			INT(11);		-- Periodo Inicial
	DECLARE Var_PeriodoFinal			INT(11);		-- Periodo Final

	DECLARE Var_MinCentroCostoID		INT(11);		-- Centro de Costo Minimo
	DECLARE Var_MaxCentroCostoID		INT(11);		-- Centro de Costo Maximo
	DECLARE Var_Contador				INT(11);		-- Contador para ciclo
	DECLARE Var_NumCliente				INT(11);		-- Numero de Cliente
	DECLARE Var_IdxSignoMas 			INT(11);		-- Indice signo Mas
	DECLARE Var_IdxSignoMenos 			INT(11);		-- Indice signo Menos
	DECLARE Var_Bandera					INT(11);		-- Indice signo Menos

	DECLARE Var_FechaCorte				DATE;			-- Fecha de Corte
	DECLARE Var_FecConsultaActual		DATE;			-- Fecha de Consulta Actual
	DECLARE Var_FecConsultaAnterior		DATE;			-- Fecha de Consulta Anterior
	DECLARE Var_FechaHistorica			DATE;			-- Fecha de Consulta Historica
	DECLARE Var_FechaIniEjerAnt			DATE;			-- Fecha Inicio Ejercicio Actual
	DECLARE Var_FechaDetallePoliza		DATE;			-- Fecha de Consulta Detalle Poliza
	DECLARE Par_FechaAnterior			DATE;			-- Fecha Anterior del Reporte

	DECLARE Var_FechaIniEjerAct			DATE;			-- Fecha Inicio Ejercicio Anterior
	DECLARE Var_TipoConRegAct			CHAR(1);		-- Tipo Concepto Regulacion Actual
	DECLARE Var_TipoConRegAnt			CHAR(1);		-- Tipo Concepto Regulacion Anterior
	DECLARE Var_UbiSaldoContAnterior	CHAR(1);		-- Ubicacion Saldo Contable Anterior
	DECLARE Var_UbiSaldoContActual		CHAR(1);		-- Ubicacion Saldo Contable Actual

	DECLARE Var_UbicaSaldoContable		CHAR(1);		-- Ubicacion del Saldo Contable
	DECLARE Var_MostrarFila				CHAR(1);		-- Evalua Mostrar Fila
	DECLARE Var_SignoOperacion			CHAR(1);		-- Signo de la formula
	DECLARE Var_Presentacion			CHAR(3);		-- Presentacion del la formula
	DECLARE Var_FormulaConcepto			VARCHAR(250);	-- Formula del Concepto Contable
	DECLARE Var_CuentaConcepto			VARCHAR(250);	-- Cuenta Contable
	DECLARE Var_ContaGeneral			VARCHAR(250);	-- Contador General

	DECLARE Var_DirectGeneral			VARCHAR(250);	-- Director General
	DECLARE Var_FormulaReporte			VARCHAR(300);	-- Campos a Evaluar del Reporte
	DECLARE Var_ClaveCampo				VARCHAR(300);	-- Campos a Evaluar Contable
	DECLARE Var_NombreCampo				VARCHAR(300);	-- Nombre del Campo
	DECLARE Var_Descripcion				VARCHAR(300);	-- Nueva Descripcion
	DECLARE Var_CtaSegmento 			VARCHAR(300);	-- Segmento de Cuenta
	DECLARE Var_SegmentoAux				VARCHAR(300);	-- Segmento de Cuenta Auxiliar

	DECLARE Var_SaldoConceptoAnt		DECIMAL(18,2);	-- Saldo Anterior el Concepto Financiero
	DECLARE Var_SaldoConceptoAct		DECIMAL(18,2);	-- Saldo Actual el Concepto Financiero
	DECLARE Var_SaldoConcepto			DECIMAL(16,2);	-- Saldo Total el Concepto Financiero
	DECLARE Var_MontoCampo				DECIMAL(18,2);	-- Acomulado de la Cuenta
	DECLARE Var_AcumuladoCta 			DECIMAL(18,2);	-- Acomulado de la Cuenta
	DECLARE Var_Acumulado 				DECIMAL(16,2);	-- Acomulado de la Cuenta

	DECLARE Var_ParticipacionControladora		CHAR(1);
	DECLARE Var_CapitalSocial					CHAR(1);
	DECLARE Var_AportacionesCapital				CHAR(1);
	DECLARE Var_PrimaVenta 						CHAR(1);
	DECLARE Var_ObligacionesSubordinadas		CHAR(1);
	DECLARE Var_IncorporacionSocFinancieras		CHAR(1);
	DECLARE Var_ReservaCapital					CHAR(1);
	DECLARE Var_ResultadoEjerAnterior			CHAR(1);
	DECLARE Var_ResultadoTitulosVenta			CHAR(1);
	DECLARE Var_ResultadoValuacionInstrumentos	CHAR(1);
	DECLARE Var_EfectoAcomulado 				CHAR(1);
	DECLARE Var_BeneficioEmpleados 				CHAR(1);
	DECLARE Var_ResultadoMonetario				CHAR(1);
	DECLARE Var_ResultadoActivos				CHAR(1);
	DECLARE Var_ParticipacionNoControladora		CHAR(1);
	DECLARE Var_CapitalContable					CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Constante Entero Uno
	DECLARE Cadena_Vacia				CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia					DATE;			-- Constante Fecha Vacia
	DECLARE Decimal_Cero				DECIMAL(12,2);	-- Constante Decimal Cero

	DECLARE Con_UbiActual				CHAR(1);		-- Constante Ubicacion actual
	DECLARE Con_UbiHistorica			CHAR(1);		-- Constante Ubicacion historica
	DECLARE Con_Fecha					CHAR(1);		-- Constante Fecha
	DECLARE Tipo_Miles					CHAR(1);		-- Formato de Miles
	DECLARE Tipo_Fecha					CHAR(1);		-- Tipo fecha

	DECLARE Tipo_Periodo				CHAR(1);		-- Tipo de Periodo
	DECLARE Con_SI 						CHAR(1);		-- Constante SI
	DECLARE Signo_Mas					CHAR(1);		-- Signo Mas
	DECLARE Signo_Menos					CHAR(1);		-- Signo Menos

	DECLARE SaldoContableActual			CHAR(3);		-- Saldo Contable Actual
	DECLARE SaldoInicioFin				CHAR(3);		-- Saldo Actual-Anterior
	DECLARE SaldoFinInicio				CHAR(3);		-- Saldo Anterior-Actual
	DECLARE SaldoContableAnterior		CHAR(3);		-- Saldo Contable Anterior
	DECLARE Cuenta_SaldoAnt				VARCHAR(15);	-- Cuenta Contable Saldo Anterior

	DECLARE Cuenta_SaldoAct				VARCHAR(15);	-- Cuenta Contable Saldo Actual
	DECLARE Con_EdoVariacion			INT(11);		-- Constantes de Estado de Resultados
	DECLARE Con_DosDecimales			INT(11);		-- Constante Dos Decimales
	DECLARE Con_Mil						DECIMAL(12,2);	-- Constante Mil

	DECLARE Ope_ObtenSegmento			TINYINT UNSIGNED;-- Tipo de Operacion para obetener el segmento
	DECLARE Ope_EliminaSegmento			TINYINT UNSIGNED;-- Tipo de Operacion para eliminar el segmento

	-- Asignacion de Constantes
	SET Entero_Cero 		:= 0;
	SET Entero_Uno			:= 1;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Decimal_Cero		:= 0.0;

	SET Con_UbiActual		:= 'A';
	SET Con_UbiHistorica	:= 'H';
	SET Con_Fecha			:= 'F';
	SET Tipo_Miles			:= 'M';
	SET Tipo_Fecha			:= 'D';

	SET Tipo_Periodo		:= 'P';
	SET Con_SI 				:= 'S';
	SET Signo_Mas			:= '+';
	SET Signo_Menos			:= '-';

	SET SaldoContableActual := 'SCI';
	SET SaldoInicioFin		:= 'SIF';
	SET SaldoFinInicio		:= 'SFI';
	SET SaldoContableAnterior := 'SCF';

	SET Cuenta_SaldoAnt		:= '910100000000';
	SET Cuenta_SaldoAct		:= '910000000000';

	SET Con_EdoVariacion	:= 5;
	SET Con_DosDecimales	:= 2;
	SET Con_Mil				:= 1000;
	SET Ope_ObtenSegmento	:= 1;
	SET Ope_EliminaSegmento	:= 2;

	SELECT IFNULL(ValorParametro, Entero_Cero)
	INTO Var_NumCliente
	FROM PARAMGENERALES
	WHERE LlaveParametro = 'CliProcEspecifico';

	SELECT JefeContabilidad,	GerenteGeneral
	INTO   Var_ContaGeneral,	Var_DirectGeneral
	FROM PARAMETROSSIS
	WHERE EmpresaID = Par_EmpresaID;

	SET Aud_NumTransaccion := ROUND(RAND()*1000000);
	DELETE FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion;

	IF Par_CCInicial = Entero_Cero AND Par_CCFinal = Entero_Cero THEN
		SELECT MIN(CentroCostoID), MAX(CentroCostoID)
		INTO Var_MinCentroCostoID, Var_MaxCentroCostoID
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
	SELECT MAX(FechaCorte)
	INTO Var_FechaHistorica
	FROM SALDOSCONTABLES
	WHERE FechaCorte <= Par_FechaActual;

	IF IFNULL(Var_FechaHistorica,Fecha_Vacia) != Fecha_Vacia THEN

		SELECT MAX(EjercicioID), MAX(PeriodoID)
		INTO Var_EjercicioFinal, Var_PeriodoFinal
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

	-- Se insertan los datos a mostrar
	INSERT INTO TMPEDOVARIACIONES(
		NumeroTransaccion,		CaTConceptos,			CuentaContable,					ClaveCampo,						FormulaReporte,
		MostrarCampo,			Descripcion,			Presentacion,					ParticipacionControladora,		CapitalSocial,
		AportacionesCapital,	PrimaVenta,				ObligacionesSubordinadas,		IncorporacionSocFinancieras,	ReservaCapital,
		ResultadoEjerAnterior,	ResultadoTitulosVenta,	ResultadoValuacionInstrumentos,	EfectoAcomulado,				BeneficioEmpleados,
		ResultadoMonetario,		ResultadoActivos,		ParticipacionNoControladora,	CapitalContable)
	SELECT
		Aud_NumTransaccion,		CaTConceptos,			CuentaContable,					ClaveCampo,						FormulaReporte,
		MostrarCampo,			Descripcion,			Presentacion,					Decimal_Cero,					Decimal_Cero,
		Decimal_Cero,			Decimal_Cero,			Decimal_Cero,					Decimal_Cero,					Decimal_Cero,
		Decimal_Cero,			Decimal_Cero,			Decimal_Cero,					Decimal_Cero,					Decimal_Cero,
		Decimal_Cero,			Decimal_Cero,			Decimal_Cero,					Decimal_Cero
	FROM EDOVARIACIONES
	WHERE EstadoFinanID = Con_EdoVariacion
	  AND CaTConceptos > Entero_Cero
	  AND NumeroCliente = Var_NumCliente
	  AND MostrarCampo = Con_SI;

	UPDATE TMPEDOVARIACIONES SET
		Descripcion = CONCAT('Saldo al ',FUNCIONLETRASFECHA(DATE_ADD(Var_FecConsultaAnterior, INTERVAL Entero_Uno DAY)))
	WHERE NumeroTransaccion = Aud_NumTransaccion
	  AND CuentaContable = Cuenta_SaldoAnt;

	UPDATE TMPEDOVARIACIONES SET
		Descripcion = CONCAT('Saldo al ',FUNCIONLETRASFECHA(Par_FechaActual))
	WHERE NumeroTransaccion = Aud_NumTransaccion
	  AND CuentaContable = Cuenta_SaldoAct;

	SELECT MAX(CaTConceptos)
	INTO Var_ConceptoFinanIDMax
	FROM TMPEDOVARIACIONES
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	UPDATE TMPEDOVARIACIONES SET
		Descripcion = CONCAT('Saldo al ',FUNCIONLETRASFECHA(Par_FechaActual))
	WHERE NumeroTransaccion = Aud_NumTransaccion
	  AND CaTConceptos = Var_ConceptoFinanIDMax;

	SET Var_Contador := Entero_Uno;
	-- Se recorre la tabla base

	WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO

		-- Evaluacion de Participacion Controladora
		SELECT TRIM(ParticipacionControladora), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,   			Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ParticipacionControladora = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
												 WHEN Var_Presentacion = SaldoInicioFin		   THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
												 WHEN Var_Presentacion = SaldoFinInicio		   THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
												 WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
											END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;

		-- Evaluacion de Capital Social
		SELECT TRIM(CapitalSocial), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,   Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				CapitalSocial = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
									 WHEN Var_Presentacion = SaldoInicioFin		   THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
									 WHEN Var_Presentacion = SaldoFinInicio		   THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
									 WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
								END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Aportaciones de Capital
		SELECT TRIM(AportacionesCapital),CuentaContable,	Presentacion
		INTO Var_FormulaConcepto,   Var_CuentaConcepto,		Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				AportacionesCapital = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
										   WHEN Var_Presentacion = SaldoInicioFin		 THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
										   WHEN Var_Presentacion = SaldoFinInicio		 THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
										   WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
									  END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Prima Venta
		SELECT TRIM(PrimaVenta),  CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,   Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				PrimaVenta = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
								  WHEN Var_Presentacion = SaldoInicioFin		THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
								  WHEN Var_Presentacion = SaldoFinInicio		THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
								  WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
							 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Obligaciones Subordinadas
		SELECT TRIM(ObligacionesSubordinadas), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,   		   Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ObligacionesSubordinadas = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
												WHEN Var_Presentacion = SaldoInicioFin		  THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
												WHEN Var_Presentacion = SaldoFinInicio		  THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
												WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
											 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Incorporacion Sociedades Financieras
		SELECT TRIM(IncorporacionSocFinancieras), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,				  Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				IncorporacionSocFinancieras = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoInicioFin		 THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
												   WHEN Var_Presentacion = SaldoFinInicio		 THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
											   END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Reserva Capital
		SELECT TRIM(ReservaCapital), CuentaContable,	 Presentacion
		INTO Var_FormulaConcepto,    Var_CuentaConcepto, Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ReservaCapital = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
									  WHEN Var_Presentacion = SaldoInicioFin		THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
									  WHEN Var_Presentacion = SaldoFinInicio		THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
									  WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
								 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado de Ejercicio Anterior
		SELECT TRIM(ResultadoEjerAnterior), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,  			Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ResultadoEjerAnterior = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
											 WHEN Var_Presentacion = SaldoInicioFin		   THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
											 WHEN Var_Presentacion = SaldoFinInicio		   THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
											 WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
										END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado de Titulos de Venta
		SELECT TRIM(ResultadoTitulosVenta), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,  			Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ResultadoTitulosVenta = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
											 WHEN Var_Presentacion = SaldoInicioFin		   THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
											 WHEN Var_Presentacion = SaldoFinInicio		   THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
											 WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
										END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado de Valuacion de Instrumentos
		SELECT TRIM(ResultadoValuacionInstrumentos), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,					 Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ResultadoValuacionInstrumentos = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
													  WHEN Var_Presentacion = SaldoInicioFin		THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
													  WHEN Var_Presentacion = SaldoFinInicio		THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
													  WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
												 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado de Efecto Acomulado
		SELECT TRIM(EfectoAcomulado), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,	  Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				EfectoAcomulado = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
									   WHEN Var_Presentacion = SaldoInicioFin		 THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
									   WHEN Var_Presentacion = SaldoFinInicio		 THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
									   WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
								  END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Beneficio de Empleados
		SELECT TRIM(BeneficioEmpleados), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,		 Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				BeneficioEmpleados = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
										  WHEN Var_Presentacion = SaldoInicioFin		THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
										  WHEN Var_Presentacion = SaldoFinInicio		THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
										  WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
									 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado Monetarios
		SELECT TRIM(ResultadoMonetario), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,		 Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ResultadoMonetario = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
										  WHEN Var_Presentacion = SaldoInicioFin		THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
										  WHEN Var_Presentacion = SaldoFinInicio		THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
										  WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
									 END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Resultado de Activos
		SELECT TRIM(ResultadoActivos), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,	   Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ResultadoActivos = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
										WHEN Var_Presentacion = SaldoInicioFin		  THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
										WHEN Var_Presentacion = SaldoFinInicio		  THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
										WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
								   END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Participacion No Controladora
		SELECT TRIM(ParticipacionNoControladora), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,				  Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				ParticipacionNoControladora = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoInicioFin		 THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
												   WHEN Var_Presentacion = SaldoFinInicio		 THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
											  END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;


		-- Evaluacion de Participacion No Controladora
		SELECT TRIM(CapitalContable), CuentaContable,		Presentacion
		INTO Var_FormulaConcepto,	  Var_CuentaConcepto,	Var_Presentacion
		FROM EDOVARIACIONES
		WHERE EstadoFinanID = Con_EdoVariacion
		  AND CaTConceptos = Var_Contador
		  AND NumeroCliente = Var_NumCliente;

		-- Formula Contable
		IF IFNULL(Var_FormulaConcepto,Cadena_Vacia) <> Cadena_Vacia THEN

			-- Saldo Anterior
			IF Var_CuentaConcepto <> Cuenta_SaldoAct THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContAnterior,	Var_TipoConRegAnt,		Var_FecConsultaAnterior,	Var_EjercicioInicial,
					Var_PeriodoInicial,		Var_FechaIniEjerAnt,		Var_SaldoConceptoAnt,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Saldo Actual
			IF Var_CuentaConcepto <> Cuenta_SaldoAnt THEN
				CALL EVALFORMULACONTAPRO(
					Var_FormulaConcepto,	Var_UbiSaldoContActual,		Var_TipoConRegAct,		Var_FecConsultaActual,		Var_EjercicioFinal,
					Var_PeriodoFinal,		Var_FechaIniEjerAct,		Var_SaldoConceptoAct,	Var_MinCentroCostoID,		Var_MaxCentroCostoID,
					Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			SET Var_SaldoConceptoAnt := IFNULL(Var_SaldoConceptoAnt, Decimal_Cero);
			SET Var_SaldoConceptoAct := IFNULL(Var_SaldoConceptoAct, Decimal_Cero);

			UPDATE TMPEDOVARIACIONES SET
				CapitalContable = CASE WHEN Var_Presentacion = SaldoContableActual   THEN Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoInicioFin		 THEN Var_SaldoConceptoAct - Var_SaldoConceptoAnt
												   WHEN Var_Presentacion = SaldoFinInicio		 THEN Var_SaldoConceptoAnt - Var_SaldoConceptoAct
												   WHEN Var_Presentacion = SaldoContableAnterior THEN Var_SaldoConceptoAnt
											  END
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			SET Var_SaldoConceptoAnt := Decimal_Cero;
			SET Var_SaldoConceptoAct := Decimal_Cero;

		END IF;

		IF Par_Cifras = Tipo_Miles THEN
			UPDATE TMPEDOVARIACIONES SET
				ParticipacionControladora		= ROUND((ParticipacionControladora / Con_Mil), Con_DosDecimales),
				CapitalSocial					= ROUND((CapitalSocial / Con_Mil), Con_DosDecimales),
				AportacionesCapital				= ROUND((AportacionesCapital / Con_Mil), Con_DosDecimales),
				PrimaVenta						= ROUND((PrimaVenta / Con_Mil), Con_DosDecimales),
				ObligacionesSubordinadas		= ROUND((ObligacionesSubordinadas / Con_Mil), Con_DosDecimales),
				IncorporacionSocFinancieras		= ROUND((IncorporacionSocFinancieras / Con_Mil), Con_DosDecimales),
				ReservaCapital					= ROUND((ReservaCapital / Con_Mil), Con_DosDecimales),
				ResultadoEjerAnterior			= ROUND((ResultadoEjerAnterior / Con_Mil), Con_DosDecimales),
				ResultadoTitulosVenta			= ROUND((ResultadoTitulosVenta / Con_Mil), Con_DosDecimales),
				ResultadoValuacionInstrumentos	= ROUND((ResultadoValuacionInstrumentos / Con_Mil), Con_DosDecimales),
				EfectoAcomulado					= ROUND((EfectoAcomulado / Con_Mil), Con_DosDecimales),
				BeneficioEmpleados				= ROUND((BeneficioEmpleados / Con_Mil), Con_DosDecimales),
				ResultadoMonetario				= ROUND((ResultadoMonetario / Con_Mil), Con_DosDecimales),
				ResultadoActivos				= ROUND((ResultadoActivos / Con_Mil), Con_DosDecimales),
				ParticipacionNoControladora		= ROUND((ParticipacionNoControladora / Con_Mil), Con_DosDecimales),
				CapitalContable					= ROUND((CapitalContable / Con_Mil), Con_DosDecimales)
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;
		END IF;

		SET Var_Contador := Var_Contador + Entero_Uno;

	END WHILE;

	SELECT	ParticipacionControladora,			CapitalSocial,			AportacionesCapital,		PrimaVenta,					ObligacionesSubordinadas,
			IncorporacionSocFinancieras,		ReservaCapital,			ResultadoEjerAnterior,		ResultadoTitulosVenta,		ResultadoValuacionInstrumentos,
			EfectoAcomulado,					BeneficioEmpleados,		ResultadoMonetario,			ResultadoActivos,			ParticipacionNoControladora,
			CapitalContable
	INTO	Var_ParticipacionControladora,		Var_CapitalSocial,		Var_AportacionesCapital,	Var_PrimaVenta,				Var_ObligacionesSubordinadas,
			Var_IncorporacionSocFinancieras,	Var_ReservaCapital,		Var_ResultadoEjerAnterior,	Var_ResultadoTitulosVenta,	Var_ResultadoValuacionInstrumentos,
			Var_EfectoAcomulado,				Var_BeneficioEmpleados,	Var_ResultadoMonetario,		Var_ResultadoActivos,		Var_ParticipacionNoControladora,
			Var_CapitalContable
	FROM EDOVARIACIONES
	WHERE EstadoFinanID = Con_EdoVariacion
	  AND CaTConceptos = Entero_Cero
	  AND NumeroCliente = Var_NumCliente;


	-- Se realizar cursor para la salida de los campo
	SET Var_Contador := Entero_Uno;

	-- Se realiza mapeo de nombre de Campo y Monto de la salida del reporte. Se  ajustan los saldos de acuerdo a las formulas de la tabla EDOVARIACIONESFINREP
	WHILE (Var_Contador <= Var_ConceptoFinanIDMax) DO

		-- Columna Participacion Controladora
		IF( Var_ParticipacionControladora = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ParticipacionControladora
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ParticipacionControladora = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Capital Social
		IF( Var_CapitalSocial = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT CapitalSocial
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						CapitalSocial = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Aportaciones de Capital
		IF( Var_AportacionesCapital = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT AportacionesCapital
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						AportacionesCapital = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Prima Venta
		IF( Var_PrimaVenta = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT PrimaVenta
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						PrimaVenta = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Obligaciones Subordinadas
		IF( Var_ObligacionesSubordinadas = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ObligacionesSubordinadas
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ObligacionesSubordinadas = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Incorporacion Sociedades Finaciera
		IF( Var_IncorporacionSocFinancieras = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT IncorporacionSocFinancieras
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						IncorporacionSocFinancieras = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Reserva Capital
		IF( Var_ReservaCapital = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ReservaCapital
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ReservaCapital = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Ejercicio Anterior
		IF( Var_ResultadoEjerAnterior = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ResultadoEjerAnterior
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ResultadoEjerAnterior = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Resultados Titulos en Venta
		IF( Var_ResultadoTitulosVenta = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ResultadoTitulosVenta
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ResultadoTitulosVenta = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Resultados Valuacion de Instrumentos
		IF( Var_ResultadoValuacionInstrumentos = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ResultadoValuacionInstrumentos
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ResultadoValuacionInstrumentos = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Efecto Acomulado
		IF( Var_EfectoAcomulado = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT EfectoAcomulado
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;
					UPDATE TMPEDOVARIACIONES SET
						EfectoAcomulado = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Beneficiario Empleados
		IF( Var_BeneficioEmpleados = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT BeneficioEmpleados
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						BeneficioEmpleados = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Resultado Monetario
		IF( Var_ResultadoMonetario = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ResultadoMonetario
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ResultadoMonetario = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Resultado Activos
		IF( Var_ResultadoActivos = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ResultadoActivos
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ResultadoActivos = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Participacion No Controladora
		IF( Var_ParticipacionNoControladora = Con_SI ) THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				-- Elimino espacios en la formula
				SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
				SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
													THEN CONCAT(Signo_Mas, Var_FormulaReporte)
													ELSE Var_FormulaReporte END;

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					SET Var_AcumuladoCta := Decimal_Cero;
					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT ParticipacionNoControladora
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						ParticipacionNoControladora = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

				END IF;
			END IF;
		END IF;

		-- Columna Capital Contable
		IF( Var_CapitalContable = Con_SI )THEN

			SELECT ClaveCampo, 		FormulaReporte, 	MostrarCampo
			INTO   Var_ClaveCampo,	Var_FormulaReporte,	Var_MostrarFila
			FROM TMPEDOVARIACIONES Edo
			WHERE NumeroTransaccion = Aud_NumTransaccion
			  AND CaTConceptos = Var_Contador;

			IF( Var_MostrarFila = Con_SI ) THEN

				IF( Var_FormulaReporte <> Cadena_Vacia) THEN

					-- Elimino espacios en la formula
					SET Var_FormulaReporte := REPLACE(Var_FormulaReporte, ' ',Cadena_Vacia);
					SET Var_FormulaReporte := CASE WHEN LEFT(Var_FormulaReporte, Entero_Uno) NOT IN (Signo_Mas, Signo_Menos)
														THEN CONCAT(Signo_Mas, Var_FormulaReporte)
														ELSE Var_FormulaReporte END;
					SET Var_AcumuladoCta := Decimal_Cero;

					-- Si existe al menos un signo - o + realizo el ciclo para obtener los montos de los campos
					WHILE ((LOCATE(Signo_Mas, Var_FormulaReporte) > Entero_Cero OR LOCATE(Signo_Menos, Var_FormulaReporte) > Entero_Cero)) DO

						-- Obtengo las posiciones de los signo + -
						SET Var_IdxSignoMas   := LOCATE(Signo_Mas, Var_FormulaReporte);
						SET Var_IdxSignoMenos := LOCATE(Signo_Menos, Var_FormulaReporte);

						-- Obtengo el segmento a evaluar en la operacion
						SET Var_CtaSegmento := CASE WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMenos - Entero_Uno )
													WHEN (Var_IdxSignoMenos > Var_IdxSignoMas AND Var_IdxSignoMas = Entero_Cero)
														THEN SUBSTRING_INDEX(Var_FormulaReporte, Signo_Menos , 2)
													WHEN (Var_IdxSignoMas > Var_IdxSignoMenos AND Var_IdxSignoMenos > Entero_Cero)
														THEN SUBSTRING(Var_FormulaReporte, Entero_Uno, Var_IdxSignoMas - Entero_Uno )
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
						SELECT CapitalContable
						INTO Var_MontoCampo
						FROM TMPEDOVARIACIONES
						WHERE NumeroTransaccion = Aud_NumTransaccion
						  AND ClaveCampo = Var_CtaSegmento;

						SET Var_MontoCampo   := IFNULL(Var_MontoCampo, Decimal_Cero);

						-- Si la operacion es una resta multiplico por -1
						IF( Var_SignoOperacion = Signo_Menos) THEN
							SET Var_MontoCampo := Var_MontoCampo * -1;
						END IF;

						-- Asigno el monto al acomulado de la formula
						SET Var_AcumuladoCta := IFNULL(Var_AcumuladoCta, Decimal_Cero) + Var_MontoCampo;

						SET Var_CtaSegmento := Cadena_Vacia;
						SET Var_SignoOperacion := Cadena_Vacia;
						SET Var_MontoCampo := Decimal_Cero;
						SET Var_SegmentoAux := Cadena_Vacia;

					END WHILE;

					UPDATE TMPEDOVARIACIONES SET
						CapitalContable = Var_AcumuladoCta
					WHERE NumeroTransaccion = Aud_NumTransaccion
					  AND CaTConceptos = Var_Contador;

					END IF;
				END IF;
		END IF;

		SET Var_Contador := Var_Contador + Entero_Uno;

	END WHILE;

	-- Actualiza capital contable
	UPDATE TMPEDOVARIACIONES SET
		CapitalContable = CapitalSocial +		AportacionesCapital+	PrimaVenta +			ObligacionesSubordinadas + 		IncorporacionSocFinancieras +
						  ReservaCapital +		ResultadoEjerAnterior+	ResultadoTitulosVenta +	ResultadoValuacionInstrumentos+ EfectoAcomulado +
						  BeneficioEmpleados +	ResultadoMonetario+		ResultadoActivos +		ParticipacionNoControladora,
		ParticipacionControladora =  CapitalSocial +		AportacionesCapital+	PrimaVenta +			ObligacionesSubordinadas + 		IncorporacionSocFinancieras +
									 ReservaCapital +		ResultadoEjerAnterior+	ResultadoTitulosVenta +	ResultadoValuacionInstrumentos+ EfectoAcomulado +
									 BeneficioEmpleados +	ResultadoMonetario+		ResultadoActivos +		ParticipacionNoControladora
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	SELECT	Descripcion,					ParticipacionControladora,		CapitalSocial,		AportacionesCapital,	PrimaVenta,
			ObligacionesSubordinadas,		IncorporacionSocFinancieras,	ReservaCapital,		ResultadoEjerAnterior,	ResultadoTitulosVenta,
			ResultadoValuacionInstrumentos,	EfectoAcomulado,				BeneficioEmpleados,	ResultadoMonetario,		ResultadoActivos,
			ParticipacionNoControladora,	CapitalContable
	FROM TMPEDOVARIACIONES
	WHERE NumeroTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion;
END TerminaStore$$
