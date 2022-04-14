-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA131100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA131100003REP`;
DELIMITER $$

CREATE PROCEDURE `REGA131100003REP`(
-- ------------- REPORTE REGULATORIO DE ESTADO DE VARIACION -----------
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
	DECLARE Var_FechaAnt					VARCHAR(100);

	DECLARE Var_FechaAct						VARCHAR(100);
	DECLARE Var_ParticipacionControladora		VARCHAR(200);
 	DECLARE Var_CapitalSocial					VARCHAR(200);
	DECLARE Var_AportacionesCapital				VARCHAR(200);
	DECLARE Var_PrimaVenta						VARCHAR(200);

	DECLARE Var_ObligacionesSubordinadas		VARCHAR(200);
	DECLARE Var_IncorporacionSocFinancieras		VARCHAR(200);
	DECLARE Var_ReservaCapital					VARCHAR(200);
	DECLARE Var_ResultadoEjerAnterior			VARCHAR(200);
	DECLARE Var_ResultadoTitulosVenta			VARCHAR(200);

    DECLARE Var_ResultadoValuacionInstrumentos	VARCHAR(200);
	DECLARE Var_EfectoAcomulado					VARCHAR(200);
	DECLARE Var_BeneficioEmpleados				VARCHAR(200);
	DECLARE Var_ResultadoMonetario				VARCHAR(200);
	DECLARE Var_ResultadoActivos				VARCHAR(200);

    DECLARE Var_ParticipacionNoControladora					VARCHAR(200);
	DECLARE Var_CapitalContable								DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaParticipacionControladora		DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaCapitalSocial					DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaAportacionesCapital				DECIMAL(18,2);

	DECLARE Var_AcumuladoCtaPrimaVenta						DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaObligacionesSubordinadas		DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaIncorporacionSocFinancieras		DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaReservaCapital					DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaResultadoEjerAnterior			DECIMAL(18,2);

    DECLARE Var_AcumuladoCtaResultadoValuacionInstrumentos	DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaResultadoTitulosVenta			DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaEfectoAcomulado					DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaBeneficioEmpleados				DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaResultadoMonetario				DECIMAL(18,2);

    DECLARE Var_AcumuladoCtaResultadoActivos			DECIMAL(18,2);
	DECLARE Var_AcumuladoCtaParticipacionNoControladora	DECIMAL(18,2);
    DECLARE Var_CapitalContableAct						DECIMAL(18,2);
	DECLARE Var_ParticipacionControladoraAct			DECIMAL(18,2);
	DECLARE Var_CapitalSocialAct						DECIMAL(18,2);

    DECLARE Var_AportacionesCapitalAct					DECIMAL(18,2);
	DECLARE Var_PrimaVentaAct							DECIMAL(18,2);
	DECLARE Var_ObligacionesSubordinadasAct				DECIMAL(18,2);
	DECLARE Var_IncorporacionSocFinancierasAct			DECIMAL(18,2);
	DECLARE Var_ReservaCapitalAct						DECIMAL(18,2);

    DECLARE Var_ResultadoEjerAnteriorAct				DECIMAL(18,2);
	DECLARE Var_ResultadoTitulosVentaAct				DECIMAL(18,2);
	DECLARE Var_ResultadoValuacionInstrumentosAct		DECIMAL(18,2);
	DECLARE Var_EfectoAcomuladoAct						DECIMAL(18,2);
	DECLARE Var_BeneficioEmpleadosAct					DECIMAL(18,2);

    DECLARE Var_ResultadoMonetarioAct					DECIMAL(18,2);
	DECLARE Var_ResultadoActivosAct						DECIMAL(18,2);
    DECLARE Var_ParticipacionNoControladoraAct			DECIMAL(18,2);
	DECLARE Var_ParticipacionControladoraTotAnt			DECIMAL(18,2);
	DECLARE Var_CapitalSocialTotAnt						DECIMAL(18,2);

    DECLARE Var_AportacionesCapitalTotAnt				DECIMAL(18,2);
	DECLARE Var_PrimaVentaTotAnt						DECIMAL(18,2);
	DECLARE Var_ObligacionesSubordinadasTotAnt			DECIMAL(18,2);
	DECLARE Var_IncorporacionSocFinancierasTotAnt		DECIMAL(18,2);
	DECLARE Var_ReservaCapitalTotAnt					DECIMAL(18,2);

    DECLARE Var_ResultadoEjerAnteriorTotAnt				DECIMAL(18,2);
	DECLARE Var_ResultadoTitulosVentaTotAnt				DECIMAL(18,2);
	DECLARE Var_ResultadoValuacionInstrumentosTotAnt	DECIMAL(18,2);
	DECLARE Var_EfectoAcomuladoTotAnt					DECIMAL(18,2);
	DECLARE Var_BeneficioEmpleadosTotAnt				DECIMAL(18,2);

    DECLARE Var_ResultadoActivosTotAnt					DECIMAL(18,2);
	DECLARE Var_ResultadoMonetarioTotAnt				DECIMAL(18,2);
	DECLARE Var_ParticipacionNoControladoraTotAnt		DECIMAL(18,2);
	DECLARE Var_CapitalContableTotAnt					DECIMAL(18,2);
	DECLARE Var_ParticipacionControladoraTotAct			DECIMAL(18,2);

    DECLARE Var_CapitalSocialTotAct						DECIMAL(18,2);
	DECLARE Var_AportacionesCapitalTotAct				DECIMAL(18,2);
	DECLARE Var_PrimaVentaTotAct						DECIMAL(18,2);
	DECLARE Var_ObligacionesSubordinadasTotAct			DECIMAL(18,2);
	DECLARE Var_IncorporacionSocFinancierasTotAct		DECIMAL(18,2);

    DECLARE Var_ReservaCapitalTotAct					DECIMAL(18,2);
	DECLARE Var_ResultadoEjerAnteriorTotAct				DECIMAL(18,2);
	DECLARE Var_ResultadoTitulosVentaTotAct				DECIMAL(18,2);
	DECLARE Var_ResultadoValuacionInstrumentosTotAct	DECIMAL(18,2);
	DECLARE Var_EfectoAcomuladoTotAct					DECIMAL(18,2);

    DECLARE Var_BeneficioEmpleadosTotAct				DECIMAL(18,2);
	DECLARE Var_ResultadoMonetarioTotAct				DECIMAL(18,2);
	DECLARE Var_ResultadoActivosTotAct					DECIMAL(18,2);
	DECLARE Var_ParticipacionNoControladoraTotAct		DECIMAL(18,2);
	DECLARE Var_CapitalContableTotAct					DECIMAL(18,2);

	DECLARE Var_ParticipacionControladoraTotal			DECIMAL(18,2);
	DECLARE Var_CapitalSocialTotal						DECIMAL(18,2);
	DECLARE Var_AportacionesCapitalTotal				DECIMAL(18,2);
	DECLARE Var_PrimaVentaTotal							DECIMAL(18,2);
	DECLARE Var_ObligacionesSubordinadasTotal			DECIMAL(18,2);

    DECLARE Var_IncorporacionSocFinancierasTotal		DECIMAL(18,2);
	DECLARE Var_ReservaCapitalTotal						DECIMAL(18,2);
	DECLARE Var_ResultadoEjerAnteriorTotal				DECIMAL(18,2);
	DECLARE Var_ResultadoTitulosVentaTotal				DECIMAL(18,2);
	DECLARE Var_ResultadoValuacionInstrumentosTotal		DECIMAL(18,2);

    DECLARE Var_EfectoAcomuladoTotal					DECIMAL(18,2);
	DECLARE Var_BeneficioEmpleadosTotal					DECIMAL(18,2);
	DECLARE Var_ResultadoMonetarioTotal					DECIMAL(18,2);
	DECLARE Var_ResultadoActivosTotal					DECIMAL(18,2);
	DECLARE Var_ParticipacionNoControladoraTotal		DECIMAL(18,2);

    DECLARE Var_CapitalContableTotal		DECIMAL(18,2);
	DECLARE Var_DecimalCero 				DECIMAL(14,2);
	DECLARE Var_Formula						VARCHAR(200);
	DECLARE Var_NombreFormula 				VARCHAR(100);
	DECLARE Var_Descripcion					VARCHAR(200);

    DECLARE Var_ClaveEntidad 				VARCHAR(10);	-- Clave de la entidad
	DECLARE Var_ConceptoFinanID				INT;
	DECLARE Var_ConceptoFinanIDMax			INT;
	DECLARE Var_ConceptoFinanIDMin			INT;

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia 					DATE;
	DECLARE Decimal_Cero 					DECIMAL(12,2);
	DECLARE Entero_Cero 					INT;
	DECLARE Tif_Balance 					INT;
	DECLARE Contador						INT;

    DECLARE Reporte_Excel					INT;
	DECLARE Reporte_Csv						INT;
	DECLARE Con_NumCliente					INT;
	DECLARE Grupo_ResulNeto					INT;
    DECLARE	Con_TotalAnterior				INT;

    DECLARE	Con_Anterior					INT;
    DECLARE	Con_TotalActual					INT;
    DECLARE	Con_Actual						INT;
    DECLARE	Con_Total						INT;
    DECLARE Con_TipoReporte					INT;
    DECLARE Con_TipoSaldo					INT;
	DECLARE Cadena_Vacia 					CHAR(1);

	DECLARE Con_UbiActual 					CHAR(1);
	DECLARE Con_UbiHistorica				CHAR(1);
	DECLARE Con_UbicaSaldoContable			CHAR(1);
	DECLARE Con_Fecha						CHAR(1);
	DECLARE Con_CuentaContableFechaAnterior	VARCHAR(15);

	DECLARE Con_UltCuentaContableFechaAnt	VARCHAR(15);
	DECLARE Con_CuentaContableFechaActual	VARCHAR(15);
	DECLARE Con_TotalFechaAnterior			VARCHAR(15);
	DECLARE Con_UltCuentaContableFechaAct	VARCHAR(15);
	DECLARE	Con_PriCuentaContableFechaAct	VARCHAR(15);

    DECLARE	Con_Inicial		VARCHAR(15);
	DECLARE	Con_Final		VARCHAR(15);

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
	SET Tif_Balance 		:= 5; 					-- Estado Finaciero: Balance
	SET Con_Fecha			:= 'F';					-- Tipo: Calculo por Fecha
	SET Reporte_Excel		:= 1;
    SET Reporte_Csv			:= 2;
    SET	Con_Inicial			:= 1;
    SET	Con_Final			:= 20;
	SET	Con_TotalAnterior	:= 9;
	SET	Con_Anterior		:= 8;
    SET	Con_TotalActual		:= 19;
	SET	Con_Actual			:= 11;
    SET	Con_Total			:= 20;
	SET Con_TipoReporte		:= 1311;				-- Tipo de Regulatorio
	SET Con_TipoSaldo		:= 1;					-- Tipo de Saldo para el Regulatorio

	SET Con_TotalFechaAnterior			:= '910200000000';
	SET Con_CuentaContableFechaAnterior	:= '910100000000';
	SET Con_UltCuentaContableFechaAnt	:= '910206000000';
	SET Con_CuentaContableFechaActual	:= '910000000000';
    SET	Con_UltCuentaContableFechaAct	:= '910305000000';
	SET	Con_PriCuentaContableFechaAct	:= '910300000000';

    SELECT IFNULL(ValorParametro, Entero_Cero) INTO Con_NumCliente
		FROM PARAMGENERALES
		WHERE  LlaveParametro = 'CliProcEspecifico';

    SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

    DELETE FROM TMPEDOVARIACIONES
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	CALL TRANSACCIONESPRO(Aud_NumTransaccion);

	SET Var_FecConsultaActual := Par_FechaActual;
	SET Var_FecConsultaAnterior := Par_FechaAnterior;


	SELECT MAX(Fecha) INTO Var_FechaHistorica
		FROM `HIS-DETALLEPOL`;

	SELECT MAX(Fecha) INTO Var_FechaDetallePoliza
		FROM DETALLEPOLIZA;

	-- INICIO FECHA ANTERIOR --
	IF(Par_FechaAnterior <> Fecha_Vacia) THEN

		SET Contador := 1;
		SET Var_CapitalContable := 0;
		SET Var_ConceptoFinanID := Entero_Cero;

		SET Var_ConceptoFinanIDMax := (SELECT MAX(CaTConceptos)
			FROM EDOVARIACIONES
            WHERE EstadoFinanID = Tif_Balance AND
				  NumeroCliente = Con_NumCliente);

        IF(Var_FecConsultaAnterior <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;


		WHILE (Contador <= Var_ConceptoFinanIDMax) DO

            SELECT 	CaTConceptos,	 				ParticipacionControladora, 		CapitalSocial,
					AportacionesCapital,			PrimaVenta,						ObligacionesSubordinadas,
					IncorporacionSocFinancieras,	ReservaCapital, 				ResultadoEjerAnterior,
					ResultadoTitulosVenta,			ResultadoValuacionInstrumentos,	EfectoAcomulado,
                    BeneficioEmpleados,				ResultadoMonetario,				ResultadoActivos,
					ParticipacionNoControladora

			INTO	Var_ConceptoFinanID,			Var_ParticipacionControladora, 		Var_CapitalSocial,
					Var_AportacionesCapital,		Var_PrimaVenta,						Var_ObligacionesSubordinadas,
					Var_IncorporacionSocFinancieras,Var_ReservaCapital, 				Var_ResultadoEjerAnterior,
					Var_ResultadoTitulosVenta,		Var_ResultadoValuacionInstrumentos,	Var_EfectoAcomulado,
                    Var_BeneficioEmpleados,			Var_ResultadoMonetario,				Var_ResultadoActivos,
					Var_ParticipacionNoControladora

			FROM EDOVARIACIONES
			WHERE CaTConceptos = contador AND
				  EstadoFinanID = Tif_Balance AND NumeroCliente = Con_NumCliente
			ORDER BY CaTConceptos;

			SELECT 	CuentaContable, 	Descripcion
			INTO	Var_NombreFormula, 	Var_Descripcion
			FROM 	EDOVARIACIONES
			WHERE 	EstadoFinanID = Tif_Balance AND
					CaTConceptos = Contador 	AND NumeroCliente = Con_NumCliente
			ORDER BY CaTConceptos;

            IF(Var_ParticipacionControladora = Cadena_Vacia) THEN
				SET Var_ParticipacionControladora := Entero_Cero;
			END IF;
			IF(Var_CapitalSocial = Cadena_Vacia) THEN
				SET Var_CapitalSocial := Entero_Cero;
			END IF;
			IF(Var_AportacionesCapital = Cadena_Vacia) THEN
				SET Var_AportacionesCapital := Entero_Cero;
			END IF;
			IF(Var_PrimaVenta = Cadena_Vacia) THEN
				SET Var_PrimaVenta := Entero_Cero;
			END IF;
			IF(Var_ObligacionesSubordinadas = Cadena_Vacia) THEN
				SET Var_ObligacionesSubordinadas := Entero_Cero;
			END IF;
			IF(Var_IncorporacionSocFinancieras = Cadena_Vacia) THEN
				SET Var_IncorporacionSocFinancieras := Entero_Cero;
			END IF;
			IF(Var_ReservaCapital = Cadena_Vacia) THEN
				SET Var_ReservaCapital := Entero_Cero;
			END IF;
			IF(Var_ResultadoEjerAnterior = Cadena_Vacia) THEN
				SET Var_ResultadoEjerAnterior := Entero_Cero;
			END IF;
			IF(Var_ResultadoTitulosVenta = Cadena_Vacia) THEN
				SET Var_ResultadoTitulosVenta := Entero_Cero;
			END IF;
			IF(Var_ResultadoValuacionInstrumentos = Cadena_Vacia) THEN
				SET Var_ResultadoValuacionInstrumentos := Entero_Cero;
			END IF;
			IF(Var_EfectoAcomulado = Cadena_Vacia) THEN
				SET Var_EfectoAcomulado := Entero_Cero;
			END IF;
			IF(Var_BeneficioEmpleados = Cadena_Vacia) THEN
				SET Var_BeneficioEmpleados := Entero_Cero;
			END IF;
			IF(Var_ResultadoMonetario = Cadena_Vacia) THEN
				SET Var_ResultadoMonetario := Entero_Cero;
			END IF;
			IF(Var_ResultadoActivos = Cadena_Vacia) THEN
				SET Var_ResultadoActivos := Entero_Cero;
			END IF;
			IF(Var_ParticipacionNoControladora = Cadena_Vacia) THEN
				SET Var_ParticipacionNoControladora := Entero_Cero;
			END IF;

		 	IF(Var_ConceptoFinanID > Entero_Cero ) THEN

                CALL EVALFORMULAREGPRO(Var_AcumuladoCtaParticipacionControladora, 		Var_ParticipacionControladora, 		Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaCapitalSocial, 					Var_CapitalSocial, 					Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaAportacionesCapital, 			Var_AportacionesCapital, 			Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaPrimaVenta,						Var_PrimaVenta, 					Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaObligacionesSubordinadas, 		Var_ObligacionesSubordinadas, 		Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaIncorporacionSocFinancieras,		Var_IncorporacionSocFinancieras,	Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaReservaCapital, 					Var_ReservaCapital,					Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoEjerAnterior, 			Var_ResultadoEjerAnterior, 			Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoTitulosVenta, 			Var_ResultadoTitulosVenta, 			Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoValuacionInstrumentos,	Var_ResultadoValuacionInstrumentos, Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaEfectoAcomulado, 				Var_EfectoAcomulado, 				Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaBeneficioEmpleados, 				Var_BeneficioEmpleados, 			Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoMonetario, 				Var_ResultadoMonetario, 			Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoActivos, 				Var_ResultadoActivos, 				Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaParticipacionNoControladora, 	Var_ParticipacionNoControladora, 	Con_UbicaSaldoContable,	Con_Fecha, 	Par_FechaAnterior);

				SET Var_AcumuladoCtaParticipacionControladora 		:= IFNULL(Var_AcumuladoCtaParticipacionControladora , Decimal_Cero);
				SET Var_AcumuladoCtaCapitalSocial 					:= IFNULL(Var_AcumuladoCtaCapitalSocial , Decimal_Cero);
				SET Var_AcumuladoCtaAportacionesCapital 			:= IFNULL(Var_AcumuladoCtaAportacionesCapital , Decimal_Cero);
				SET Var_AcumuladoCtaPrimaVenta 						:= IFNULL(Var_AcumuladoCtaPrimaVenta , Decimal_Cero);
				SET Var_AcumuladoCtaObligacionesSubordinadas 		:= IFNULL(Var_AcumuladoCtaObligacionesSubordinadas , Decimal_Cero);
				SET Var_AcumuladoCtaIncorporacionSocFinancieras 	:= IFNULL(Var_AcumuladoCtaIncorporacionSocFinancieras , Decimal_Cero);
				SET Var_AcumuladoCtaReservaCapital 					:= IFNULL(Var_AcumuladoCtaReservaCapital , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoEjerAnterior 			:= IFNULL(Var_AcumuladoCtaResultadoEjerAnterior , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoTitulosVenta 			:= IFNULL(Var_AcumuladoCtaResultadoTitulosVenta , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoValuacionInstrumentos 	:= IFNULL(Var_AcumuladoCtaResultadoValuacionInstrumentos , Decimal_Cero);
				SET Var_AcumuladoCtaEfectoAcomulado 				:= IFNULL(Var_AcumuladoCtaEfectoAcomulado , Decimal_Cero);
				SET Var_AcumuladoCtaBeneficioEmpleados 				:= IFNULL(Var_AcumuladoCtaBeneficioEmpleados , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoMonetario 				:= IFNULL(Var_AcumuladoCtaResultadoMonetario , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoActivos 				:= IFNULL(Var_AcumuladoCtaResultadoActivos , Decimal_Cero);
				SET Var_AcumuladoCtaParticipacionNoControladora 	:= IFNULL(Var_AcumuladoCtaParticipacionNoControladora , Decimal_Cero);

				SET Var_CapitalContable := 	Var_AcumuladoCtaParticipacionControladora + Var_AcumuladoCtaCapitalSocial + Var_AcumuladoCtaAportacionesCapital + Var_AcumuladoCtaPrimaVenta +
											Var_AcumuladoCtaObligacionesSubordinadas + Var_AcumuladoCtaIncorporacionSocFinancieras + Var_AcumuladoCtaReservaCapital +
											Var_AcumuladoCtaResultadoEjerAnterior + Var_AcumuladoCtaResultadoTitulosVenta + Var_AcumuladoCtaEfectoAcomulado +
											Var_AcumuladoCtaBeneficioEmpleados + Var_AcumuladoCtaResultadoActivos + Var_AcumuladoCtaParticipacionNoControladora +
                                            Var_AcumuladoCtaResultadoValuacionInstrumentos + Var_AcumuladoCtaResultadoMonetario;


				INSERT INTO TMPEDOVARIACIONES
					 (	`NumeroTransaccion`,	`CaTConceptos`, 		`CuentaContable`, 		`Descripcion`, 						`ParticipacionControladora`,
						`CapitalSocial`,		`AportacionesCapital`,	`PrimaVenta`, 			`ObligacionesSubordinadas`,			`IncorporacionSocFinancieras`,
						`ReservaCapital`, 		`ResultadoEjerAnterior`,`ResultadoTitulosVenta`,`ResultadoValuacionInstrumentos`,	`EfectoAcomulado`,
						`BeneficioEmpleados`, 	`ResultadoMonetario`, 	`ResultadoActivos`, 	`ParticipacionNoControladora`, 		`CapitalContable`,
                        `ClaveCampo`,			`FormulaReporte`,			`MostrarCampo`,			`Presentacion`)
				VALUES(
						Aud_NumTransaccion, 				Contador,								Var_NombreFormula, 						Var_Descripcion, 								Var_AcumuladoCtaParticipacionControladora,
						Var_AcumuladoCtaCapitalSocial,		Var_AcumuladoCtaAportacionesCapital,	Var_AcumuladoCtaPrimaVenta, 			Var_AcumuladoCtaObligacionesSubordinadas, 		Var_AcumuladoCtaIncorporacionSocFinancieras,
						Var_AcumuladoCtaReservaCapital,		Var_AcumuladoCtaResultadoEjerAnterior, 	Var_AcumuladoCtaResultadoTitulosVenta,	Var_AcumuladoCtaResultadoValuacionInstrumentos, Var_AcumuladoCtaEfectoAcomulado,
                        Var_AcumuladoCtaBeneficioEmpleados, Var_AcumuladoCtaResultadoMonetario,		Var_AcumuladoCtaResultadoActivos,		Var_AcumuladoCtaParticipacionNoControladora,	Var_CapitalContable,
                        Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia);

				END IF;

            SET Contador := Contador + 1;

		END WHILE;

	END IF;
    -- FIN FECHA ANTERIOR

	-- INICIO FECHA ACTUAL
	IF(Par_FechaActual <> Fecha_Vacia) THEN

		SET Contador := 1;
		SET Var_CapitalContable := 0;
		SET Var_ConceptoFinanID := Entero_Cero;

		SET Var_ConceptoFinanIDMax := (SELECT MAX(CaTConceptos )
			FROM EDOVARIACIONES
            WHERE EstadoFinanID = Tif_Balance AND
				  NumeroCliente = Con_NumCliente);

        IF(Var_FecConsultaActual <= Var_FechaHistorica) THEN
			SET Con_UbicaSaldoContable := Con_UbiHistorica;
		ELSE
			SET Con_UbicaSaldoContable := Con_UbiActual;
		END IF;

		WHILE (Contador <= Var_ConceptoFinanIDMax) DO

             SELECT CaTConceptos,	 				ParticipacionControladora, 		CapitalSocial,
					AportacionesCapital,			PrimaVenta,						ObligacionesSubordinadas,
					IncorporacionSocFinancieras,	ReservaCapital, 				ResultadoEjerAnterior,
					ResultadoTitulosVenta,			ResultadoValuacionInstrumentos,	EfectoAcomulado,
                    BeneficioEmpleados,				ResultadoMonetario,				ResultadoActivos,
					ParticipacionNoControladora

			INTO	Var_ConceptoFinanID,			Var_ParticipacionControladora, 		Var_CapitalSocial,
					Var_AportacionesCapital,		Var_PrimaVenta,						Var_ObligacionesSubordinadas,
					Var_IncorporacionSocFinancieras,Var_ReservaCapital, 				Var_ResultadoEjerAnterior,
					Var_ResultadoTitulosVenta,		Var_ResultadoValuacionInstrumentos,	Var_EfectoAcomulado,
                    Var_BeneficioEmpleados,			Var_ResultadoMonetario,				Var_ResultadoActivos,
					Var_ParticipacionNoControladora
			FROM EDOVARIACIONES
			WHERE CaTConceptos = contador AND
				  EstadoFinanID = Tif_Balance AND NumeroCliente = Con_NumCliente
			ORDER BY CaTConceptos;

			SELECT 	CuentaContable, 	Descripcion
			INTO	Var_NombreFormula, 	Var_Descripcion
			FROM 	EDOVARIACIONES
			WHERE 	EstadoFinanID = Tif_Balance AND
					CaTConceptos = Contador 	AND NumeroCliente = Con_NumCliente
			ORDER BY CaTConceptos;

			IF(Var_ParticipacionControladora = Cadena_Vacia) THEN
				SET Var_ParticipacionControladora := Entero_Cero;
			END IF;
			IF(Var_CapitalSocial = Cadena_Vacia) THEN
				SET Var_CapitalSocial := Entero_Cero;
			END IF;
			IF(Var_AportacionesCapital = Cadena_Vacia) THEN
				SET Var_AportacionesCapital := Entero_Cero;
			END IF;
			IF(Var_PrimaVenta = Cadena_Vacia) THEN
				SET Var_PrimaVenta := Entero_Cero;
			END IF;
			IF(Var_ObligacionesSubordinadas = Cadena_Vacia) THEN
				SET Var_ObligacionesSubordinadas := Entero_Cero;
			END IF;
			IF(Var_IncorporacionSocFinancieras = Cadena_Vacia) THEN
				SET Var_IncorporacionSocFinancieras := Entero_Cero;
			END IF;
			IF(Var_ReservaCapital = Cadena_Vacia) THEN
				SET Var_ReservaCapital := Entero_Cero;
			END IF;
			IF(Var_ResultadoEjerAnterior = Cadena_Vacia) THEN
				SET Var_ResultadoEjerAnterior := Entero_Cero;
			END IF;
			IF(Var_ResultadoTitulosVenta = Cadena_Vacia) THEN
				SET Var_ResultadoTitulosVenta := Entero_Cero;
			END IF;
			IF(Var_ResultadoValuacionInstrumentos = Cadena_Vacia) THEN
				SET Var_ResultadoValuacionInstrumentos := Entero_Cero;
			END IF;
			IF(Var_EfectoAcomulado = Cadena_Vacia) THEN
				SET Var_EfectoAcomulado := Entero_Cero;
			END IF;
			IF(Var_BeneficioEmpleados = Cadena_Vacia) THEN
				SET Var_BeneficioEmpleados := Entero_Cero;
			END IF;
			IF(Var_ResultadoMonetario = Cadena_Vacia) THEN
				SET Var_ResultadoMonetario := Entero_Cero;
			END IF;
			IF(Var_ResultadoActivos = Cadena_Vacia) THEN
				SET Var_ResultadoActivos := Entero_Cero;
			END IF;
			IF(Var_ParticipacionNoControladora = Cadena_Vacia) THEN
				SET Var_ParticipacionNoControladora := Entero_Cero;
			END IF;


		 	IF(Var_ConceptoFinanID > Entero_Cero ) THEN

                CALL EVALFORMULAREGPRO(Var_AcumuladoCtaParticipacionControladora, 		Var_ParticipacionControladora, 		Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaCapitalSocial, 					Var_CapitalSocial, 					Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaAportacionesCapital, 			Var_AportacionesCapital, 			Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaPrimaVenta,						Var_PrimaVenta, 					Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaObligacionesSubordinadas, 		Var_ObligacionesSubordinadas, 		Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaIncorporacionSocFinancieras,		Var_IncorporacionSocFinancieras,	Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaReservaCapital, 					Var_ReservaCapital,					Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoEjerAnterior, 			Var_ResultadoEjerAnterior, 			Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoTitulosVenta, 			Var_ResultadoTitulosVenta, 			Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoValuacionInstrumentos, 	Var_ResultadoValuacionInstrumentos, Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaEfectoAcomulado, 				Var_EfectoAcomulado, 				Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaBeneficioEmpleados, 				Var_BeneficioEmpleados, 			Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoMonetario, 				Var_ResultadoMonetario, 			Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaResultadoActivos, 				Var_ResultadoActivos, 				Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);
				CALL EVALFORMULAREGPRO(Var_AcumuladoCtaParticipacionNoControladora, 	Var_ParticipacionNoControladora, 	Con_UbicaSaldoContable,	Con_Fecha, 	Var_FecConsultaActual);

				SET Var_AcumuladoCtaParticipacionControladora 		:= IFNULL(Var_AcumuladoCtaParticipacionControladora , Decimal_Cero);
				SET Var_AcumuladoCtaCapitalSocial 					:= IFNULL(Var_AcumuladoCtaCapitalSocial , Decimal_Cero);
				SET Var_AcumuladoCtaAportacionesCapital 			:= IFNULL(Var_AcumuladoCtaAportacionesCapital , Decimal_Cero);
				SET Var_AcumuladoCtaPrimaVenta 						:= IFNULL(Var_AcumuladoCtaPrimaVenta , Decimal_Cero);
				SET Var_AcumuladoCtaObligacionesSubordinadas 		:= IFNULL(Var_AcumuladoCtaObligacionesSubordinadas , Decimal_Cero);
				SET Var_AcumuladoCtaIncorporacionSocFinancieras 	:= IFNULL(Var_AcumuladoCtaIncorporacionSocFinancieras , Decimal_Cero);
				SET Var_AcumuladoCtaReservaCapital 					:= IFNULL(Var_AcumuladoCtaReservaCapital , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoEjerAnterior 			:= IFNULL(Var_AcumuladoCtaResultadoEjerAnterior , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoTitulosVenta 			:= IFNULL(Var_AcumuladoCtaResultadoTitulosVenta , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoValuacionInstrumentos 	:= IFNULL(Var_AcumuladoCtaResultadoValuacionInstrumentos , Decimal_Cero);
				SET Var_AcumuladoCtaEfectoAcomulado 				:= IFNULL(Var_AcumuladoCtaEfectoAcomulado , Decimal_Cero);
				SET Var_AcumuladoCtaBeneficioEmpleados 				:= IFNULL(Var_AcumuladoCtaBeneficioEmpleados , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoMonetario 				:= IFNULL(Var_AcumuladoCtaResultadoMonetario , Decimal_Cero);
				SET Var_AcumuladoCtaResultadoActivos 				:= IFNULL(Var_AcumuladoCtaResultadoActivos , Decimal_Cero);
				SET Var_AcumuladoCtaParticipacionNoControladora 	:= IFNULL(Var_AcumuladoCtaParticipacionNoControladora , Decimal_Cero);

                IF(Contador > 1) THEN

					SET Var_ParticipacionControladoraAct		:= Var_AcumuladoCtaParticipacionControladora -  (SELECT ParticipacionControladora FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_CapitalSocialAct					:= Var_AcumuladoCtaCapitalSocial - (SELECT CapitalSocial FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_AportacionesCapitalAct				:= Var_AcumuladoCtaAportacionesCapital- (SELECT AportacionesCapital FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_PrimaVentaAct						:= Var_AcumuladoCtaPrimaVenta - (SELECT PrimaVenta FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ObligacionesSubordinadasAct			:= Var_AcumuladoCtaObligacionesSubordinadas - (SELECT ObligacionesSubordinadas FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_IncorporacionSocFinancierasAct		:= Var_AcumuladoCtaIncorporacionSocFinancieras - (SELECT IncorporacionSocFinancieras FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ReservaCapitalAct					:= Var_AcumuladoCtaReservaCapital - (SELECT ReservaCapital FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ResultadoEjerAnteriorAct			:= Var_AcumuladoCtaResultadoEjerAnterior - (SELECT ResultadoEjerAnterior FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ResultadoTitulosVentaAct			:= Var_AcumuladoCtaResultadoTitulosVenta - (SELECT ResultadoTitulosVenta FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ResultadoValuacionInstrumentosAct	:= Var_AcumuladoCtaResultadoValuacionInstrumentos - (SELECT ResultadoValuacionInstrumentos FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_EfectoAcomuladoAct					:= Var_AcumuladoCtaEfectoAcomulado - (SELECT EfectoAcomulado FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_BeneficioEmpleadosAct				:= Var_AcumuladoCtaBeneficioEmpleados - (SELECT BeneficioEmpleados FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ResultadoMonetarioAct				= Var_AcumuladoCtaResultadoMonetario - (SELECT ResultadoMonetario FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ResultadoActivosAct					:= Var_AcumuladoCtaResultadoActivos - (SELECT ResultadoActivos FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);
					SET Var_ParticipacionNoControladoraAct		:= Var_AcumuladoCtaParticipacionNoControladora - (SELECT ParticipacionNoControladora FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador);

                    SET Var_CapitalContableAct := Var_ParticipacionControladoraAct + Var_CapitalSocialAct + Var_AportacionesCapitalAct + Var_PrimaVentaAct +
							Var_ObligacionesSubordinadasAct + Var_IncorporacionSocFinancierasAct + Var_ReservaCapitalAct + Var_ResultadoEjerAnteriorAct +
							Var_ResultadoTitulosVentaAct + Var_EfectoAcomuladoAct + Var_BeneficioEmpleadosAct + Var_ResultadoActivosAct + Var_ParticipacionNoControladoraAct +
							Var_ResultadoValuacionInstrumentosAct + Var_ResultadoMonetarioAct;

                    UPDATE 	TMPEDOVARIACIONES SET
							ParticipacionControladora 		= Var_ParticipacionControladoraAct,
							CapitalSocial					= Var_CapitalSocialAct,
							AportacionesCapital				= Var_AportacionesCapitalAct,
							PrimaVenta						= Var_PrimaVentaAct,
							ObligacionesSubordinadas		= Var_ObligacionesSubordinadasAct,
							IncorporacionSocFinancieras		= Var_IncorporacionSocFinancierasAct,
							ReservaCapital					= Var_ReservaCapitalAct,
							ResultadoEjerAnterior			= Var_ResultadoEjerAnteriorAct,
							ResultadoTitulosVenta			= Var_ResultadoTitulosVentaAct,
							ResultadoValuacionInstrumentos	= Var_ResultadoValuacionInstrumentosAct,
							EfectoAcomulado					= Var_EfectoAcomuladoAct,
							BeneficioEmpleados				= Var_BeneficioEmpleadosAct,
							ResultadoMonetario				= Var_ResultadoMonetarioAct,
							ResultadoActivos				= Var_ResultadoActivosAct,
							ParticipacionNoControladora		= Var_ParticipacionNoControladoraAct,
							CapitalContable					= Var_CapitalContableAct
					WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Contador;

                END IF;

		 	END IF;

            SET Contador := Contador + 1;

	 	END WHILE;

		-- Seccion donde se actualiza el total del mes anterior
        SELECT  SUM(ParticipacionControladora),			SUM(CapitalSocial) ,			SUM(AportacionesCapital), 			SUM(PrimaVenta) , 				SUM(ObligacionesSubordinadas),
				SUM(IncorporacionSocFinancieras), 		SUM(ReservaCapital) , 			SUM(ResultadoEjerAnterior), 		SUM(ResultadoTitulosVenta) ,    SUM(ResultadoValuacionInstrumentos) ,
                SUM(EfectoAcomulado), 					SUM(BeneficioEmpleados),        SUM(ResultadoMonetario) ,			SUM(ResultadoActivos), 			SUM(ParticipacionNoControladora)

        INTO
			Var_ParticipacionControladoraTotAnt,       	Var_CapitalSocialTotAnt,		 Var_AportacionesCapitalTotAnt,		Var_PrimaVentaTotAnt,				Var_ObligacionesSubordinadasTotAnt,
            Var_IncorporacionSocFinancierasTotAnt,	   	Var_ReservaCapitalTotAnt	,	 Var_ResultadoEjerAnteriorTotAnt,	Var_ResultadoTitulosVentaTotAnt,	Var_ResultadoValuacionInstrumentosTotAnt,
            Var_EfectoAcomuladoTotAnt,				 	Var_BeneficioEmpleadosTotAnt,	 Var_ResultadoMonetarioTotAnt,		Var_ResultadoActivosTotAnt,			Var_ParticipacionNoControladoraTotAnt
        FROM TMPEDOVARIACIONES
        WHERE NumeroTransaccion = Aud_NumTransaccion
        AND CaTConceptos BETWEEN 2 AND Con_Anterior;

        SET Var_CapitalContableTotAnt := Var_ParticipacionControladoraTotAnt + Var_CapitalSocialTotAnt + Var_AportacionesCapitalTotAnt + Var_PrimaVentaTotAnt +
							Var_ObligacionesSubordinadasTotAnt + Var_IncorporacionSocFinancierasTotAnt + Var_ReservaCapitalTotAnt + Var_ResultadoEjerAnteriorTotAnt +
							Var_ResultadoTitulosVentaTotAnt + Var_EfectoAcomuladoTotAnt + Var_BeneficioEmpleadosTotAnt + Var_ResultadoActivosTotAnt + Var_ParticipacionNoControladoraTotAnt +
                            Var_ResultadoValuacionInstrumentosTotAnt + Var_ResultadoMonetarioTotAnt;

        UPDATE 	TMPEDOVARIACIONES SET
				ParticipacionControladora 		= Var_ParticipacionControladoraTotAnt,
				CapitalSocial					= Var_CapitalSocialTotAnt,
				AportacionesCapital				= Var_AportacionesCapitalTotAnt,
				PrimaVenta						= Var_PrimaVentaTotAnt,
				ObligacionesSubordinadas		= Var_ObligacionesSubordinadasTotAnt,
				IncorporacionSocFinancieras		= Var_IncorporacionSocFinancierasTotAnt,
				ReservaCapital					= Var_ReservaCapitalTotAnt,
				ResultadoEjerAnterior			= Var_ResultadoEjerAnteriorTotAnt,
				ResultadoTitulosVenta			= Var_ResultadoTitulosVentaTotAnt,
				ResultadoValuacionInstrumentos	= Var_ResultadoValuacionInstrumentosTotAnt,
				EfectoAcomulado					= Var_EfectoAcomuladoTotAnt,
				BeneficioEmpleados				= Var_BeneficioEmpleadosTotAnt,
				ResultadoMonetario				= Var_ResultadoMonetarioTotAnt,
				ResultadoActivos				= Var_ResultadoActivosTotAnt,
				ParticipacionNoControladora		= Var_ParticipacionNoControladoraTotAnt,
				CapitalContable					= Var_CapitalContableTotAnt
		WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Con_TotalAnterior;


        -- Seccion donde se actualiza el total del mes Actual
         SELECT SUM(ParticipacionControladora),			SUM(CapitalSocial) ,			SUM(AportacionesCapital), 			SUM(PrimaVenta) , 				SUM(ObligacionesSubordinadas),
				SUM(IncorporacionSocFinancieras), 		SUM(ReservaCapital) , 			SUM(ResultadoEjerAnterior), 		SUM(ResultadoTitulosVenta) ,    SUM(ResultadoValuacionInstrumentos) ,
                SUM(EfectoAcomulado), 					SUM(BeneficioEmpleados),        SUM(ResultadoMonetario) ,			SUM(ResultadoActivos), 			SUM(ParticipacionNoControladora)

        INTO
			Var_ParticipacionControladoraTotAct	, 		Var_CapitalSocialTotAct	, 		Var_AportacionesCapitalTotAct	,	Var_PrimaVentaTotAct,				Var_ObligacionesSubordinadasTotAct,
            Var_IncorporacionSocFinancierasTotAct,		Var_ReservaCapitalTotAct	, 	Var_ResultadoEjerAnteriorTotAct, 	Var_ResultadoTitulosVentaTotAct,	Var_ResultadoValuacionInstrumentosTotAct,
            Var_EfectoAcomuladoTotAct,					Var_BeneficioEmpleadosTotAct,	Var_ResultadoMonetarioTotAct	, 	Var_ResultadoActivosTotAct,			Var_ParticipacionNoControladoraTotAct
        FROM TMPEDOVARIACIONES
        WHERE NumeroTransaccion = Aud_NumTransaccion
        AND CaTConceptos BETWEEN 11 AND 18;

        SET Var_CapitalContableTotAct := Var_ParticipacionControladoraTotAct + Var_CapitalSocialTotAct + Var_AportacionesCapitalTotAct + Var_PrimaVentaTotAct +
							Var_ObligacionesSubordinadasTotAct + Var_IncorporacionSocFinancierasTotAct + Var_ReservaCapitalTotAct + Var_ResultadoEjerAnteriorTotAct +
							Var_ResultadoTitulosVentaTotAct + Var_EfectoAcomuladoTotAct + Var_BeneficioEmpleadosTotAct + Var_ResultadoActivosTotAct + Var_ParticipacionNoControladoraTotAct +
							Var_ResultadoValuacionInstrumentosTotAct + Var_ResultadoMonetarioTotAct;

        UPDATE 	TMPEDOVARIACIONES SET
				ParticipacionControladora 		= Var_ParticipacionControladoraTotAct,
				CapitalSocial					= Var_CapitalSocialTotAct,
				AportacionesCapital				= Var_AportacionesCapitalTotAct,
				PrimaVenta						= Var_PrimaVentaTotAct,
				ObligacionesSubordinadas		= Var_ObligacionesSubordinadasTotAct,
				IncorporacionSocFinancieras		= Var_IncorporacionSocFinancierasTotAct,
				ReservaCapital					= Var_ReservaCapitalTotAct,
				ResultadoEjerAnterior			= Var_ResultadoEjerAnteriorTotAct,
				ResultadoTitulosVenta			= Var_ResultadoTitulosVentaTotAct,
				ResultadoValuacionInstrumentos	= Var_ResultadoValuacionInstrumentosTotAct,
				EfectoAcomulado					= Var_EfectoAcomuladoTotAct,
				BeneficioEmpleados				= Var_BeneficioEmpleadosTotAct,
				ResultadoMonetario				= Var_ResultadoMonetarioTotAct,
				ResultadoActivos				= Var_ResultadoActivosTotAct,
				ParticipacionNoControladora		= Var_ParticipacionNoControladoraTotAct,
				CapitalContable					= Var_CapitalContableTotAct
		WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Con_TotalActual;


		-- Seccion donde se actualiza el total del la consultal
        SELECT  SUM(ParticipacionControladora),		SUM(CapitalSocial) ,			SUM(AportacionesCapital), 			SUM(PrimaVenta) , 				SUM(ObligacionesSubordinadas),
				SUM(IncorporacionSocFinancieras), 	SUM(ReservaCapital) , 			SUM(ResultadoEjerAnterior), 		SUM(ResultadoTitulosVenta) ,    SUM(ResultadoValuacionInstrumentos) ,
                SUM(EfectoAcomulado), 				SUM(BeneficioEmpleados),        SUM(ResultadoMonetario) ,			SUM(ResultadoActivos), 			SUM(ParticipacionNoControladora) ,
                SUM(CapitalContable)

        INTO
			Var_ParticipacionControladoraTotal,		Var_CapitalSocialTotal,			Var_AportacionesCapitalTotal,		Var_PrimaVentaTotal,			Var_ObligacionesSubordinadasTotal	,
            Var_IncorporacionSocFinancierasTotal,	Var_ReservaCapitalTotal, 		Var_ResultadoEjerAnteriorTotal, 	Var_ResultadoTitulosVentaTotal,	Var_ResultadoValuacionInstrumentosTotal,
            Var_EfectoAcomuladoTotal,				Var_BeneficioEmpleadosTotal,	Var_ResultadoMonetarioTotal,		Var_ResultadoActivosTotal,		Var_ParticipacionNoControladoraTotal,
            Var_CapitalContableTotal
        FROM TMPEDOVARIACIONES
        WHERE NumeroTransaccion = Aud_NumTransaccion
        AND CaTConceptos = 1;

        UPDATE 	TMPEDOVARIACIONES SET
				ParticipacionControladora 		= Var_ParticipacionControladoraTotal + Var_ParticipacionControladoraTotAnt + Var_ParticipacionControladoraTotAct,
				CapitalSocial					= Var_CapitalSocialTotal + Var_CapitalSocialTotAnt + Var_CapitalSocialTotAct,
				AportacionesCapital				= Var_AportacionesCapitalTotal + Var_AportacionesCapitalTotAnt + Var_AportacionesCapitalTotAct,
				PrimaVenta						= Var_PrimaVentaTotal + Var_PrimaVentaTotAnt + Var_PrimaVentaTotAct,
				ObligacionesSubordinadas		= Var_ObligacionesSubordinadasTotal + Var_ObligacionesSubordinadasTotAnt + Var_ObligacionesSubordinadasTotAct,
				IncorporacionSocFinancieras		= Var_IncorporacionSocFinancierasTotal + Var_IncorporacionSocFinancierasTotAnt + Var_IncorporacionSocFinancierasTotAct,
				ReservaCapital					= Var_ReservaCapitalTotal + Var_ReservaCapitalTotAnt + Var_ReservaCapitalTotAct,
				ResultadoEjerAnterior			= Var_ResultadoEjerAnteriorTotal +  Var_ResultadoEjerAnteriorTotAnt + Var_ResultadoEjerAnteriorTotAct,
				ResultadoTitulosVenta			= Var_ResultadoTitulosVentaTotal + Var_ResultadoTitulosVentaTotAnt + Var_ResultadoTitulosVentaTotAct,
				ResultadoValuacionInstrumentos	= Var_ResultadoValuacionInstrumentosTotal + Var_ResultadoValuacionInstrumentosTotAnt + Var_ResultadoValuacionInstrumentosTotAct,
				EfectoAcomulado					= Var_EfectoAcomuladoTotal + Var_EfectoAcomuladoTotAnt + Var_EfectoAcomuladoTotAct,
				BeneficioEmpleados				= Var_BeneficioEmpleadosTotal + Var_BeneficioEmpleadosTotAnt + Var_BeneficioEmpleadosTotAct,
				ResultadoMonetario				= Var_ResultadoMonetarioTotal + Var_ResultadoMonetarioTotAnt + Var_ResultadoMonetarioTotAct,
				ResultadoActivos				= Var_ResultadoActivosTotal + Var_ResultadoActivosTotAnt + Var_ResultadoActivosTotAct,
				ParticipacionNoControladora		= Var_ParticipacionNoControladoraTotal + Var_ParticipacionNoControladoraTotAnt + Var_ParticipacionNoControladoraTotAct,
				CapitalContable					= Var_CapitalContableTotal + Var_CapitalContableTotAnt + Var_CapitalContableTotAct
		WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Con_Total;

         UPDATE TMPEDOVARIACIONES SET
				ParticipacionControladora = CapitalSocial + AportacionesCapital + PrimaVenta + ObligacionesSubordinadas + IncorporacionSocFinancieras
											+ ReservaCapital + ResultadoEjerAnterior + ResultadoTitulosVenta + ResultadoValuacionInstrumentos
                                            + EfectoAcomulado + BeneficioEmpleados + ResultadoMonetario + ResultadoActivos
		WHERE 	NumeroTransaccion = Aud_NumTransaccion;

        UPDATE 	TMPEDOVARIACIONES SET
				Descripcion =  FUNCIONLETRASFECHA(Var_FecConsultaAnterior)
		WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Con_Inicial;

        UPDATE 	TMPEDOVARIACIONES SET
				Descripcion =  FUNCIONLETRASFECHA(Var_FecConsultaActual)
		WHERE 	NumeroTransaccion = Aud_NumTransaccion AND CaTConceptos = Con_Final;

		UPDATE TMPEDOVARIACIONES SET
				ParticipacionControladora 		= NULL,
				CapitalSocial					= NULL,
				AportacionesCapital				= NULL,
				PrimaVenta						= NULL,
				ObligacionesSubordinadas		= NULL,
				IncorporacionSocFinancieras		= NULL,
				ReservaCapital					= NULL,
				ResultadoEjerAnterior			= NULL,
				ResultadoTitulosVenta			= NULL,
				ResultadoValuacionInstrumentos	= NULL,
				EfectoAcomulado					= NULL,
				BeneficioEmpleados				= NULL,
				ResultadoMonetario				= NULL,
				ResultadoActivos				= NULL,
				ParticipacionNoControladora		= NULL,
				CapitalContable					= NULL
			WHERE NumeroTransaccion = Aud_NumTransaccion AND
				CuentaContable 	= '';
	END IF;

    IF(Reporte_Excel = Par_TipoConsulta) THEN
        SELECT	CONCAT( CASE WHEN conceptos.Negrita = 'N' THEN '          ' ELSE '' END, variacion.Descripcion) AS Descripcion,
			conceptos.Negrita,  variacion.NumeroTransaccion,	variacion.CaTConceptos,
			variacion.ParticipacionControladora, 	variacion.CapitalSocial,					variacion.AportacionesCapital, 			variacion.PrimaVenta,
			variacion.ObligacionesSubordinadas, 	variacion.IncorporacionSocFinancieras, 		variacion.ReservaCapital, 				variacion.ResultadoEjerAnterior,
			variacion.ResultadoTitulosVenta,		variacion.ResultadoValuacionInstrumentos, 	variacion.EfectoAcomulado, 				variacion.BeneficioEmpleados,
			variacion.ResultadoMonetario, 			variacion.ResultadoActivos,					variacion.ParticipacionNoControladora, 	variacion.CapitalContable
			FROM TMPEDOVARIACIONES variacion
			INNER JOIN EDOVARIACIONES conceptos ON conceptos.CuentaContable = variacion.CuentaContable
			WHERE variacion.NumeroTransaccion = Aud_NumTransaccion AND variacion.CaTConceptos = conceptos.CaTConceptos
				   AND conceptos.NumeroCliente = Con_NumCliente AND conceptos.CuentaContable = variacion.CuentaContable;

        DELETE FROM TMPEDOVARIACIONES
		WHERE NumeroTransaccion = Aud_NumTransaccion;

	ELSE

        (SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',558,';',ParticipacionControladora)) AS Valor
			FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',526,';',CapitalSocial)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',531,';',AportacionesCapital)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',529,';',PrimaVenta)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',554,';',ObligacionesSubordinadas)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',562,';',IncorporacionSocFinancieras)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',533,';',ReservaCapital)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',535,';',ResultadoEjerAnterior)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',537,';',ResultadoTitulosVenta)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
        (SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',556,';',ResultadoValuacionInstrumentos)) AS Valor
			FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',539,';',EfectoAcomulado)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',549,';',BeneficioEmpleados)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
		UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',561,';',ResultadoMonetario)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',548,';',ResultadoActivos)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',559,';',ParticipacionNoControladora)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia)
        UNION
		(SELECT (CONCAT( CuentaContable,';',Con_TipoReporte, ';',560,';',CapitalContable)) AS Valor
				FROM TMPEDOVARIACIONES WHERE NumeroTransaccion = Aud_NumTransaccion AND CuentaContable <> Cadena_Vacia);

	 	DELETE FROM TMPEDOVARIACIONES
		WHERE NumeroTransaccion = Aud_NumTransaccion;
	END IF;

END TerminaStore$$