
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- APORTRECALISRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTRECALISRPRO`;

DELIMITER $$
CREATE PROCEDURE `APORTRECALISRPRO`(
/* ===============================================================
 * --- RECALCULA EL ISR POR CAMBIO DE TASA EN EL CIERRE DE DIA ---
 * --------------- EN TODAS LAS CUOTAS VIGENTES. -----------------
 * -------------------- CLIENTES NACIONALES. ---------------------
 * =============================================================== */
	Par_Fecha			DATE,			-- Fecha
	Par_Salida			CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),		-- Numero de error
	INOUT Par_ErrMen    VARCHAR(400),	-- Descripcion de error
	/* Parámetros de Auditoría. */
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

# Declaración de variables.
DECLARE Var_ExisteCambio		CHAR(1);				-- Indica si hay cambio de tasa en el día.
DECLARE Var_FechaCambioTasa		DATE;					-- Fecha del cambio de tasa.
DECLARE Var_TotalReg			BIGINT(20);				-- Total de Registros.
DECLARE Var_TotalAmor			BIGINT(20);				-- Total de Amortizaciones.
DECLARE Var_ConsID				BIGINT(20);				-- Contador de Registros.
DECLARE Var_PaisIDBase			INT(11);				-- Pais ID de Base.

DECLARE Var_AportacionID		INT(11);
DECLARE Var_AmortizacionID		INT(11);
DECLARE Var_FechaInicio			DATE;
DECLARE Var_FechaPago			DATE;
DECLARE Var_Capital				DECIMAL(18,2);
DECLARE Var_Interes				DECIMAL(18,2);
DECLARE Var_InteresRetener		DECIMAL(18,2);
DECLARE Var_Total				DECIMAL(18,2);
DECLARE Var_SaldoCap			DECIMAL(18,2);
DECLARE Var_TipoPeriodo			CHAR(1);
DECLARE Var_PagoIntCapitaliza	CHAR(1);
DECLARE Var_Dias1erPer			INT(11);
DECLARE Var_FechaFin1erPer		DATE;
DECLARE Var_ISR1erPer			DECIMAL(18,2);
DECLARE Var_Dias2doPer			INT(11);
DECLARE Var_FechaFin2doPer		DATE;
DECLARE Var_ISR2doPer			DECIMAL(18,2);
DECLARE Var_TasaFija			DECIMAL(12,4);
DECLARE Var_TasaISRActual		DECIMAL(12,4);
DECLARE Var_NuevaTasaISR		DECIMAL(12,4);
DECLARE Var_AmortSigID			INT(11);
DECLARE Var_AmortAntID			INT(11);
DECLARE Var_NvoSaldoCap			DECIMAL(18,2);
DECLARE Var_NvoInteresNeto		DECIMAL(18,2);
DECLARE Var_NvoInteresGen		DECIMAL(18,2);
DECLARE Var_NvoInteresRet		DECIMAL(18,2);
DECLARE Var_TotalInteresNeto	DECIMAL(18,2);
DECLARE Var_TotalInteresGen		DECIMAL(18,2);
DECLARE Var_TotalInteresRet		DECIMAL(18,2);
DECLARE Var_PlazoAmo			INT(11);

# Declaración de constantes.
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Fecha_Vacia     		DATE;
DECLARE Entero_Cero 	    	INT(11);
DECLARE Cons_NO					CHAR(1);
DECLARE Cons_SI					CHAR(1);
DECLARE Periodo_Reg				CHAR(1);
DECLARE Periodo_Irreg			CHAR(1);
DECLARE Est_Vigente				CHAR(1);
DECLARE Dias_BasePerReg	    	INT(11);
DECLARE TasaRetencion			INT(1);
DECLARE TasaInteres				INT(1);
DECLARE TasaRecalculoISR		INT(1);

# Asignación de constantes.
SET Cadena_Vacia    		:= '';					-- Cadena Vacia.
SET Fecha_Vacia     		:= '1900-01-01';		-- Fecha Vacia.
SET Entero_Cero     		:= 0;					-- Entero Cero.
SET Cons_NO					:= 'N';					-- Constante NO.
SET Cons_SI					:= 'S';					-- Constante SI.
SET Periodo_Reg				:= 'R';					-- Periodo Tipo Regular.
SET Periodo_Irreg			:= 'I';					-- Periodo Tipo Irregular.
SET Est_Vigente				:= 'N';					-- Estatus Vigente de Aportaciones.
SET Dias_BasePerReg    		:= 30;					-- Días base para periodo regular.
SET TasaRetencion			:= 0;					-- Para Calcula el Interés a Retener.
SET TasaInteres				:= 1;					-- Para Calcula el Interés Generado.
SET TasaRecalculoISR		:= 2;					-- Para Calcula el Interés a Retener (Recálculo).

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTRECALISRPRO');
		END;

		# SE VALIDA SI EN EL DÍA DE CIERRE EXISTE UN CAMBIO DE TASA.
		SET Var_ExisteCambio	:= FNEXISTECAMBIOISR(Par_Fecha,Par_Fecha);
		SET Var_ExisteCambio	:= IFNULL(Var_ExisteCambio,Cons_NO);

		# SE OBTIENE EL PAÍS BASE PARA IDENTIFICAR A LOS CLIENTES NACIONALES.
		SET Var_PaisIDBase		:= FNPARAMGENERALES('PaisIDBase');

		IF(Var_ExisteCambio = Cons_SI)THEN

			# SE SETEA LA FECHA DE CAMBIO CON LA FECHA DE CIERRE.
			SET Var_FechaCambioTasa := IFNULL(Par_Fecha, Fecha_Vacia);

			# SE RESPALDAN TODAS LAS APORTACIONES VIGENTES QUE ENTRAN EN EL CAMBIO DE TASA ISR.
			INSERT INTO HISAPORTACIONES (
				AportacionID,			TipoAportacionID,		CuentaAhoID,		ClienteID,				AperturaAport,
				FechaInicio,			FechaVencimiento,		FechaPago,			Monto,					Plazo,
				TasaFija,				TasaISR,				TasaNeta,			CalculoInteres,			TasaBase,
				SobreTasa,				PisoTasa,				TechoTasa,			InteresGenerado,		InteresRecibir,
				InteresRetener,			SaldoProvision,			SaldoISR,			ValorGat,				ValorGatReal,
				EstatusImpresion,		MonedaID,				FechaVenAnt,		FechaApertura,			Estatus,
				TipoPagoInt,			DiasPeriodo,			PagoIntCal,			AportacionRenovada,		PlazoOriginal,
				SucursalID,				Reinversion,			Reinvertir,			FechaCancela,			UsuarioAut,
				CajaRetiro,				ISRReal,				MontoGlobal,		TasaMontoGlobal,		IncluyeGpoFam,
				DiasPago,				PagoIntCapitaliza,		OpcionAport,		CantidadReno,			InvRenovar,
				Notas,					MotivoCancela,			ConCondiciones,		ConsolidarSaldos,		EmpresaID,
				UsuarioID,				FechaActual,			DireccionIP,		ProgramaID,				Sucursal,
				NumTransaccion)
			SELECT
				AP.AportacionID,		AP.TipoAportacionID,	AP.CuentaAhoID,		AP.ClienteID,			AP.AperturaAport,
				AP.FechaInicio,			AP.FechaVencimiento,	AP.FechaPago,		AP.Monto,				AP.Plazo,
				AP.TasaFija,			AP.TasaISR,				AP.TasaNeta,		AP.CalculoInteres,		AP.TasaBase,
				AP.SobreTasa,			AP.PisoTasa,			AP.TechoTasa,		AP.InteresGenerado,		AP.InteresRecibir,
				AP.InteresRetener,		AP.SaldoProvision,		AP.SaldoISR,		AP.ValorGat,			AP.ValorGatReal,
				AP.EstatusImpresion,	AP.MonedaID,			AP.FechaVenAnt,		AP.FechaApertura,		AP.Estatus,
				AP.TipoPagoInt,			AP.DiasPeriodo,			AP.PagoIntCal,		AP.AportacionRenovada,	AP.PlazoOriginal,
				AP.SucursalID,			AP.Reinversion,			AP.Reinvertir,		AP.FechaCancela,		AP.UsuarioAut,
				AP.CajaRetiro,			AP.ISRReal,				AP.MontoGlobal,		AP.TasaMontoGlobal,		AP.IncluyeGpoFam,
				AP.DiasPago,			AP.PagoIntCapitaliza,	AP.OpcionAport,		AP.CantidadReno,		AP.InvRenovar,
				AP.Notas,				AP.MotivoCancela,		AP.ConCondiciones,	AP.ConsolidarSaldos,	AP.EmpresaID,
				AP.UsuarioID,			AP.FechaActual,			AP.DireccionIP,		AP.ProgramaID,			AP.Sucursal,
				AP.NumTransaccion
			FROM APORTACIONES AP
				INNER JOIN CLIENTES C ON AP.ClienteID = C.ClienteID
			WHERE AP.Estatus = Est_Vigente
				AND C.PagaISR = Cons_SI
				AND C.PaisResidencia = Var_PaisIDBase
				AND Var_FechaCambioTasa BETWEEN AP.FechaInicio AND AP.FechaPago
				ORDER BY AP.AportacionID;

			# SE RESPALDAN TODAS LAS AMORTIZACIONES DE LAS APORTACIONES VIGENTES QUE ENTRAN EN EL CAMBIO DE TASA ISR.
			INSERT INTO HISAMORTIAPORT (
				AportacionID,		AmortizacionID,			FechaInicio,			FechaVencimiento,		FechaPago,
				Estatus,			Capital,				Interes,				InteresRetener,			Total,
				Dias,				SaldoProvision,			SaldoISR,				SaldoIsrAcum,			ISRCal,
				SaldoCap,			TipoPeriodo,			InteresRetenerRec,		EmpresaID,				Usuario,
				FechaActual,		DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
			SELECT
				AM.AportacionID,	AM.AmortizacionID,		AM.FechaInicio,			AM.FechaVencimiento,	AM.FechaPago,
				AM.Estatus,			AM.Capital,				AM.Interes,				AM.InteresRetener,		AM.Total,
				AM.Dias,			AM.SaldoProvision,		AM.SaldoISR,			AM.SaldoIsrAcum,		AM.ISRCal,
				AM.SaldoCap,		AM.TipoPeriodo,			AM.InteresRetenerRec,	AM.EmpresaID,			AM.Usuario,
				AM.FechaActual,		AM.DireccionIP,			AM.ProgramaID,			AM.Sucursal,			AM.NumTransaccion
			FROM APORTACIONES AP
				INNER JOIN AMORTIZAAPORT AM ON AP.AportacionID = AM.AportacionID
				INNER JOIN CLIENTES C ON AP.ClienteID = C.ClienteID
			WHERE AP.Estatus = Est_Vigente
				AND C.PagaISR = Cons_SI
				AND C.PaisResidencia = Var_PaisIDBase
				AND Var_FechaCambioTasa BETWEEN AP.FechaInicio AND AP.FechaPago
				ORDER BY AM.AportacionID, AM.AmortizacionID;

			DELETE FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion;

			SET @Var_TmpID := Entero_Cero;

			# SE TOMAN LAS AMORTIZACIONES QUE SE AFECTARÁN POR EL CAMBIO DE TASA. (CUOTA QUE ESTA CORRIENDO).
			INSERT INTO TMP_AMORTIAPORTISR(
				TmpID,
				AportacionID,			AmortizacionID,			FechaInicio,		FechaPago,			Capital,
				Interes,				InteresRetener,			Total,				TipoPeriodo,		SaldoCap,
				PagoIntCapitaliza,		NumTransaccion)
			SELECT
				(@Var_TmpID := @Var_TmpID +1),
				AM.AportacionID,		AM.AmortizacionID,		AM.FechaInicio,		AM.FechaPago,		AM.Capital,
				AM.Interes,				AM.InteresRetener,		AM.Total,			AM.TipoPeriodo,		IF(AP.PagoIntCapitaliza=Cons_SI,AM.SaldoCap,AP.Monto),
				AP.PagoIntCapitaliza,	Aud_NumTransaccion
			FROM APORTACIONES AP
				INNER JOIN AMORTIZAAPORT AM ON AP.AportacionID = AM.AportacionID
				INNER JOIN CLIENTES C ON AP.ClienteID = C.ClienteID
			WHERE AP.Estatus = Est_Vigente
				AND C.PagaISR = Cons_SI
				AND C.PaisResidencia = Var_PaisIDBase
				AND Var_FechaCambioTasa BETWEEN AM.FechaInicio AND AM.FechaPago
				ORDER BY AM.AportacionID, AM.AmortizacionID;

			SET Var_ConsID := 1;
			SET Var_TotalReg := (SELECT COUNT(*) FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion);

			WHILE(Var_ConsID <= Var_TotalReg)DO
				SELECT
					T.AportacionID,			T.AmortizacionID,		T.FechaInicio,		T.FechaPago,		T.Capital,
					T.Interes,				T.InteresRetener,		T.Total,			T.SaldoCap,			T.TipoPeriodo,
					T.PagoIntCapitaliza
				INTO
					Var_AportacionID,		Var_AmortizacionID,		Var_FechaInicio,	Var_FechaPago,		Var_Capital,
					Var_Interes,			Var_InteresRetener,		Var_Total,			Var_SaldoCap,		Var_TipoPeriodo,
					Var_PagoIntCapitaliza
				FROM TMP_AMORTIAPORTISR T
				WHERE T.TmpID = Var_ConsID
					AND T.NumTransaccion = Aud_NumTransaccion;

				SET Var_TasaISRActual	:= (SELECT TasaISR FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
				SET Var_NuevaTasaISR	:= CALCULATASAISR(Par_Fecha,Var_TasaISRActual);
				SET Var_FechaFin2doPer	:= Fecha_Vacia;
				SET Var_FechaFin1erPer	:= Fecha_Vacia;

				# RECÁLCULO PARA PERIODOS REGULARES (BASE 360).
				IF(Var_TipoPeriodo = Periodo_Reg)THEN
					/* RECALCULO DE LOS DÍAS DEL SEGUNDO CORTE (FECHA CAMBIO DE TASA Y LA FECHA DE PAGO).
					 * CON LA NUEVA TASA.
					 * Primero se saca los días del segundo corte o periodo, para obtener la diferencia en base a
					 * 30 días que le corresponde al primer corte (antes del cambio de tasa).
					 */
					SET Var_Dias2doPer := (datediff(Var_FechaPago,Var_FechaCambioTasa)+1);
					SET Var_FechaFin2doPer := DATE_ADD(Var_FechaCambioTasa, INTERVAL (Var_Dias2doPer-1) DAY);
					# Cálculo del ISR del 2do. corte con la nueva tasa.
					SET Var_ISR2doPer := FNINTERESCAL(Var_TipoPeriodo,TasaRecalculoISR,Var_SaldoCap,Var_Dias2doPer,Var_NuevaTasaISR,Entero_Cero,Entero_Cero,Entero_Cero);

					# RECALCULO DE LOS DÍAS DEL PRIMER CORTE Y LA FECHA FIN. (CON LA TASA ACTUAL -ANTES DEL CAMBIO DE TASA-).
					SET Var_Dias1erPer := (Dias_BasePerReg - Var_Dias2doPer);
					SET Var_FechaFin1erPer := DATE_ADD(Var_FechaInicio, INTERVAL Var_Dias1erPer DAY);
					# Cálculo del ISR del 1er. corte con la tasa actual.
					SET Var_ISR1erPer := FNINTERESCAL(Var_TipoPeriodo,TasaRecalculoISR,Var_SaldoCap,Var_Dias1erPer,Var_TasaISRActual,Entero_Cero,Entero_Cero,Entero_Cero);
				END IF;

				# RECÁLCULO ṔARA PERIODOS IRREGULARES (BASE 365).
				IF(Var_TipoPeriodo = Periodo_Irreg)THEN
					/* RECALCULO DE LOS DÍAS DEL SEGUNDO CORTE (FECHA CAMBIO DE TASA Y LA FECHA DE PAGO).
					 * CON LA NUEVA TASA.
					 * El plazo para periodos irregulares corresponden a los días naturales efectivamente transcurridos.
					 */
					SET Var_Dias2doPer := (DATEDIFF(Var_FechaPago,Var_FechaCambioTasa)+1);
					SET Var_FechaFin2doPer := DATE_ADD(Var_FechaCambioTasa, INTERVAL (Var_Dias2doPer-1) DAY);

					# Cálculo del ISR del 2do. corte con la nueva tasa.
					SET Var_ISR2doPer := FNINTERESCAL(Var_TipoPeriodo,TasaRetencion,Var_SaldoCap,Var_Dias2doPer,Var_NuevaTasaISR,Entero_Cero,Entero_Cero,Entero_Cero);


					# RECALCULO DE LOS DÍAS DEL PRIMER CORTE Y LA FECHA FIN. (CON LA TASA ACTUAL -ANTES DEL CAMBIO DE TASA-).
					SET Var_Dias1erPer := (DATEDIFF(Var_FechaCambioTasa,Var_FechaInicio)-1);
					SET Var_FechaFin1erPer := DATE_ADD(Var_FechaInicio, INTERVAL Var_Dias1erPer DAY);
					# Cálculo del ISR del 1er. corte con la tasa actual.
					SET Var_ISR1erPer := FNINTERESCAL(Var_TipoPeriodo,TasaRetencion,Var_SaldoCap,Var_Dias1erPer,Var_TasaISRActual,Entero_Cero,Entero_Cero,Entero_Cero);
				END IF;

				# Total del Interés a Retener (suma de los dos cortes).
				SET Var_InteresRetener := ROUND((Var_ISR1erPer + Var_ISR2doPer),2);

				# Actualización de los valores calculados.
				UPDATE TMP_AMORTIAPORTISR
				SET
					Dias1erPer		= Var_Dias1erPer,
					FechaFin1erPer	= Var_FechaFin1erPer,
					ISR1erPer		= Var_ISR1erPer,
					Dias2doPer		= Var_Dias2doPer,
					FechaFin2doPer	= Var_FechaFin2doPer,
					ISR2doPer		= Var_ISR2doPer,
					InteresRetener	= Var_InteresRetener,
					Total			= Interes - Var_InteresRetener
				WHERE TmpID = Var_ConsID
					AND NumTransaccion = Aud_NumTransaccion;

				# SE ACTUALIZA EL ISR (INTERESRETENER) Y EL INTERÉS NETO (TOTAL) LAS CUOTAS VIGENTES EN TRÁNSITO.
				UPDATE AMORTIZAAPORT AM
					INNER JOIN TMP_AMORTIAPORTISR TMP ON AM.AportacionID = TMP.AportacionID AND AM.AmortizacionID = TMP.AmortizacionID
				SET
					AM.InteresRetener = TMP.InteresRetener,
					AM.Total			= TMP.Total,
					AM.EmpresaID		= Par_EmpresaID,
					AM.Usuario			= Aud_Usuario,
					AM.FechaActual		= Aud_FechaActual,
					AM.DireccionIP		= Aud_DireccionIP,
					AM.ProgramaID		= Aud_ProgramaID,
					AM.Sucursal			= Aud_Sucursal,
					AM.NumTransaccion	= Aud_NumTransaccion
				WHERE TMP.NumTransaccion = Aud_NumTransaccion;

				# RECALCULO DE LAS SIGUIENTES COUTAS VIGENTES CON LA NUEVA TASA ISR.
				SET Var_AmortSigID := Var_AmortizacionID + 1;
				SET Var_TotalAmor := (SELECT MAX(AmortizacionID) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID);
				SET Var_TasaFija := (SELECT TasaFija FROM APORTACIONES WHERE AportacionID = Var_AportacionID);

				WHILE(Var_AmortSigID <= Var_TotalAmor)DO
					IF(Var_PagoIntCapitaliza = Cons_SI)THEN
						# SE OBTIENE LA AMORTIZACIÓN ANTERIOR.
						SET Var_AmortAntID := (Var_AmortSigID - 1);
						# SE OBTIENE EL INTERES NETO (TOTAL) DE LA AMORTIZACIÓN ANTERIOR.
						SELECT
							SaldoCap,			Total
						INTO
							Var_NvoSaldoCap,	Var_NvoInteresNeto
						FROM AMORTIZAAPORT
						WHERE AportacionID = Var_AportacionID
							AND AmortizacionID = Var_AmortAntID;

						# Se obtiene el plazo en días y el tipo de periodo de la amortización a actualizar.
						SET Var_PlazoAmo := (SELECT Dias FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortSigID);
						SET Var_TipoPeriodo := (SELECT TipoPeriodo FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortSigID);
						SET Var_PlazoAmo := IF(Var_TipoPeriodo = Periodo_Irreg,Var_PlazoAmo,Entero_Cero);

						# SE CALCULA EL NUEVO SALDO CAPITAL, EL INTERÉS GENERADO Y EL INTERÉS A RETENER.
						# Saldo Capital en base a la amortización anterior.
						SET Var_NvoSaldoCap := (Var_NvoSaldoCap + Var_NvoInteresNeto);
						# Recálculo del Interés con base al nuevo saldo capital.
						SET Var_NvoInteresGen := FNINTERESCAL(Var_TipoPeriodo,TasaInteres,Var_NvoSaldoCap,Var_PlazoAmo,Var_TasaFija,Entero_Cero,Entero_Cero,Entero_Cero);
						# Recálculo del Interés a Retener con base al nuevo saldo capital.
						SET Var_NvoInteresRet := FNINTERESCAL(Var_TipoPeriodo,TasaRetencion,Var_NvoSaldoCap,Var_PlazoAmo,Var_NuevaTasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
						SET Var_NvoInteresNeto := (Var_NvoInteresGen - Var_NvoInteresRet);

						# SE ACTUALIZAN LOS NUEVOS VALORES.
						UPDATE AMORTIZAAPORT AM
						SET
							AM.Interes			= Var_NvoInteresGen,
							AM.InteresRetener	= Var_NvoInteresRet,
							AM.Total			= Var_NvoInteresNeto,
							AM.SaldoCap			= Var_NvoSaldoCap,
							AM.EmpresaID		= Par_EmpresaID,
							AM.Usuario			= Aud_Usuario,
							AM.FechaActual		= Aud_FechaActual,
							AM.DireccionIP		= Aud_DireccionIP,
							AM.ProgramaID		= Aud_ProgramaID,
							AM.Sucursal			= Aud_Sucursal,
							AM.NumTransaccion	= Aud_NumTransaccion
						WHERE AM.AportacionID = Var_AportacionID
							AND AM.AmortizacionID = Var_AmortSigID;

						# SE ACTUALIZA EL CAPITAL DE LA ÚLTIMA AMORTIZACIÓN.
						IF(Var_AmortSigID = Var_TotalAmor)THEN
							UPDATE AMORTIZAAPORT AM
							SET
								AM.Capital = Var_NvoSaldoCap
							WHERE AM.AportacionID = Var_AportacionID
								AND AM.AmortizacionID = Var_AmortSigID;
						END IF;
					END IF;

					IF(Var_PagoIntCapitaliza = Cons_NO)THEN
						# SE OBTIENE EL SALDO CAPITAL DE LA AMORTIZACIÓN ACTUAL (ES EL MONTO DE LA APORTACION CUANDO NO CAPITALIZA).
						SELECT
							SaldoCap,			Total,				Interes,			Dias,			TipoPeriodo
						INTO
							Var_NvoSaldoCap,	Var_NvoInteresNeto,	Var_NvoInteresGen,	Var_PlazoAmo,	Var_TipoPeriodo
						FROM AMORTIZAAPORT
						WHERE AportacionID = Var_AportacionID
							AND AmortizacionID = Var_AmortSigID;

						# Al no capitalizar, se toma el monto de la aportación.
						SET Var_NvoSaldoCap := (SELECT Monto FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
						SET Var_PlazoAmo := IF(Var_TipoPeriodo = Periodo_Irreg,Var_PlazoAmo,Entero_Cero);

						# SOLO SE CALCULA EL NUEVO INTERÉS A RETENER.
						SET Var_NvoInteresRet := FNINTERESCAL(Var_TipoPeriodo,TasaRetencion,Var_NvoSaldoCap,Var_PlazoAmo,Var_NuevaTasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
						# Se actualiza el nuevo interés neto.
						SET Var_NvoInteresNeto := (Var_NvoInteresGen - Var_NvoInteresRet);

						# SE ACTUALIZAN LOS NUEVOS VALORES.
						UPDATE AMORTIZAAPORT AM
						SET
							AM.InteresRetener	= Var_NvoInteresRet,
							AM.Total			= Var_NvoInteresNeto,
							AM.EmpresaID		= Par_EmpresaID,
							AM.Usuario			= Aud_Usuario,
							AM.FechaActual		= Aud_FechaActual,
							AM.DireccionIP		= Aud_DireccionIP,
							AM.ProgramaID		= Aud_ProgramaID,
							AM.Sucursal			= Aud_Sucursal,
							AM.NumTransaccion	= Aud_NumTransaccion
						WHERE AM.AportacionID = Var_AportacionID
							AND AM.AmortizacionID = Var_AmortSigID;
					END IF;
					SET Var_AmortSigID := Var_AmortSigID + 1;
				END WHILE;

				# SE OBTIENEN LOS TOTALES DE TODO EL CALENDARIO.
				SET Var_TotalInteresGen := (SELECT SUM(Interes) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID);
				SET Var_TotalInteresRet := (SELECT SUM(InteresRetener) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID);
				SET Var_TotalInteresNeto := (SELECT SUM(Total) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID);

				# SE ACTUALIZAN EN APORTACIONES.
				UPDATE APORTACIONES
				SET
					InteresGenerado	= Var_TotalInteresGen,
					InteresRetener	= Var_TotalInteresRet,
					InteresRecibir	= Var_TotalInteresNeto,
					EmpresaID		= Par_EmpresaID,
					UsuarioID		= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE AportacionID = Var_AportacionID;

				SET Var_ConsID := Var_ConsID + 1;
			END WHILE;

		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Recalculo de ISR en Aportaciones Realizado Exitosamente.';

END ManejoErrores;

	IF (Par_Salida = Cons_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Entero_Cero	AS Consecutivo,
			Entero_Cero	AS Control;
	END IF;

END TerminaStore$$