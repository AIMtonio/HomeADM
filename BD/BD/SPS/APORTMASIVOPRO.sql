-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMASIVOPRO`;
DELIMITER $$

CREATE PROCEDURE `APORTMASIVOPRO`(
# ============================================================================
# --- SP QUE SE ENCARGA DE REALIZAR LA REINVERSION MASIVA DE APORTACIONES-----
# ============================================================================
	Par_Fecha               DATE,               -- Fecha de Operacion
	Par_TipoRegistro        CHAR(1),			-- Tipo de Registro
	INOUT Par_NumErr        INT(11),            -- Salida en Pantalla Numero de Error o Exito
	INOUT Par_ErrMen        VARCHAR(400),       -- Salida en Pantalla Numero de Error o Exito
	Par_Salida              CHAR(1),            -- Salida en Pantalla

	/*Contador vencimiento masivo */
	INOUT Par_ContadorTotal INT(11),    		-- Contador de Aportaciones Masivas Vencidas
	INOUT Par_ContadorExito INT(11),    		-- Contador de Aportaciones Masivas Vencidas Exitosamente
	Par_EmpresaID           INT(11),            -- Auditoria
	Aud_Usuario             INT(11),            -- Auditoria
	Aud_FechaActual         DATETIME,           -- Auditoria

	Aud_DireccionIP         VARCHAR(15),        -- Auditoria
	Aud_ProgramaID          VARCHAR(50),        -- Auditoria
	Aud_Sucursal            INT(11),            -- Auditoria
	Aud_NumTransaccion      BIGINT(20)          -- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(1);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SalidaNO            CHAR(1);
	DECLARE ReinversionSI       CHAR(1);
	DECLARE ReinvPosterior      CHAR(1);
	DECLARE EstatusVigente      CHAR(1);
	DECLARE ProcesoAport         INT(11);
	DECLARE EnteroUno           INT(11);
	DECLARE ProgramaVencMasivo  VARCHAR(100);
	DECLARE SI_Isr_Socio  		CHAR(1);
	DECLARE ISRpSocio			VARCHAR(10);
	DECLARE No_constante		VARCHAR(10);
	DECLARE Si_constante		VARCHAR(10);
	DECLARE TipoRegistroD       CHAR(1);
	DECLARE EstatusAut			CHAR(1);

	-- Declaracion de variables
	DECLARE ContadorTotal       INT(11);
	DECLARE ContadorExito       INT(11);
	DECLARE Var_NumAport        INT(11);
	DECLARE Var_NumAportCond	INT(11);
	DECLARE Var_FecBitaco       DATETIME;
	DECLARE Var_Control         VARCHAR(200);
	DECLARE Var_Capital         CHAR(1);
	DECLARE Var_CapitalInteres  CHAR(2);
	DECLARE Var_MinutosBit      INT(11);
	DECLARE	Var_FechaBatch		DATE;
	DECLARE Var_InstrumenAport   INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia        :=  '';                 -- Constante Cadena_Vacia
	SET Fecha_Vacia         :=  '1900-01-01';       -- Constante Fecha Vacia
	SET Entero_Cero         :=  0;                  -- Constante Entero Cero
	SET Decimal_Cero        :=  0.0;                -- Constante DECIMAL Cero
	SET SalidaSI            :=  'S';                -- Constante Salida SI
	SET SalidaNO            :=  'N';                -- Constante Salida NO
	SET ReinversionSI       :=  'S';                -- Constante Reinversion SI
	SET ReinvPosterior		:=  'F';                -- Tipo de Reinversion Posterior
	SET EstatusVigente      :=  'N';                -- Constante Estatus Vigente
	SET ProcesoAport         :=  1517;               -- ID Proceso Batch 'CIERRE DIARIO APORTACIONES'
	SET EnteroUno           :=  1;                  -- Valor Entero Uno
	SET ProgramaVencMasivo  := '/microfin/vencMasivoAportVista.htm';  -- Programa Vencimiento Masivo APORTACIONES
	SET Var_Capital         := 'C';                 -- Valor Var_Capital
	SET Var_CapitalInteres  := 'CI';                -- Valor Var_Capital Intereses
	SET SI_Isr_Socio		:= 'S';					-- constante para saber si se calcula el isr por socio
	SET ISRpSocio			:= 'ISR_pSocio';		-- constante para isr por socio de PARAMGENERALES
	SET No_constante		:= 'N';					-- constante NO
	SET Si_constante		:= 'S';					-- constante SI
	SET TipoRegistroD		:= 'D';					-- Tipo de Registro D
	SET Var_InstrumenAport	:=  31;                 -- Valor Instrumento Aportaciones.
	SET EstatusAut			:= 'A';					-- Estatus Autorizada para Condiciones de Vencimiento.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		   BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-APORTMASIVOPRO');
				SET Var_Control :='SQLEXCEPTION';
			END;

		SET Var_FecBitaco   := NOW();
		SET Aud_FechaActual := NOW();


		 -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoAport,			Par_Fecha,			Var_FechaBatch,		EnteroUno,	  		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN

			TRUNCATE TABLE TMPAPORTACIONES;
			INSERT INTO TMPAPORTACIONES(
				AportacionID,		ClienteID,          CuentaAhoID,            TipoAportacionID,       MonedaID,
				FechaInicio,        Monto,              PlazoOriginal,          Plazo,                  Tasa,
				TasaISR,            TasaNeta,           InteresGenerado,        InteresRecibir,         InteresRetener,
				TipoPagoInteres,    DiasPeriodo,	  	PagoIntCal,				Reinversion,        	Reinvertir,
				SaldoProAcumulado,	SucursalID,    		TasaFV,           		Calificacion,       	PlazoInferior,
				PlazoSuperior,      MontoInferior,		MontoSuperior,      	FechaVencimiento,   	FechaPago,
				NuevoPlazo,         MontoReinvertir,	NuevaTasa,          	NuevaTasaISR,       	NuevaTasaNeta,
				NuevoCalInteres,    NuevaTasaBaseID,	NuevaSobreTasa,     	NuevoPisoTasa,      	NuevoTechoTasa,
				NuevoIntGenerado,   NuevoIntRetener,    NuevoIntRecibir,   	 	NuevoValorGat,      	NuevoValorGatReal,
				AmortizacionID,     DiaInhabil,			MontoGlobal,			TasaMontoGlobal,		IncluyeGpoFam,
                DiasPago,			PagoIntCapitaliza,	OpcionAport,			CantidadReno,			InvRenovar,
				Notas,				EmpresaID,			UsuarioID,				FechaActual,			DireccionIP,
				ProgramaID, 		Sucursal,			NumTransaccion)
			SELECT
				AP.AportacionID,	AP.ClienteID,     AP.CuentaAhoID,       AP.TipoAportacionID,        AP.MonedaID,
				Par_Fecha,			AP.Monto,         AP.PlazoOriginal,     AP.Plazo,					AP.TasaFija,
				AP.TasaISR,			AP.TasaNeta,      amo.SaldoProvision,	(amo.SaldoProvision-(amo.SaldoISR+amo.SaldoIsrAcum)),   (amo.SaldoISR+amo.SaldoIsrAcum),
				AP.TipoPagoInt,		AP.DiasPeriodo,   AP.PagoIntCal,		AP.Reinversion,				AP.Reinvertir,
				AP.SaldoProvision,	AP.SucursalID,    tipo.TasaFV,       		Cadena_Vacia,       	Entero_Cero,
				Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Fecha_Vacia,        	Fecha_Vacia,
				Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				Entero_Cero,        Entero_Cero,        Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				Decimal_Cero,       Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				amo.AmortizacionID, tipo.DiaInhabil,	(FNAPORTMONTOGLOBAL(tipo.TipoAportacionID,AP.ClienteID)),
				tipo.TasaMontoGlobal,tipo.IncluyeGpoFam,
                AP.DiasPago,		AP.PagoIntCapitaliza,	AP.OpcionAport,		AP.CantidadReno,		AP.InvRenovar,
                AP.Notas,			Par_EmpresaID,      	Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,       	Aud_NumTransaccion
				FROM 	APORTACIONES AP
						INNER JOIN AMORTIZAAPORT amo ON AP.AportacionID = amo.AportacionID AND AP.FechaPago = amo.FechaPago
						INNER JOIN TIPOSAPORTACIONES tipo ON AP.TipoAportacionID = tipo.TipoAportacionID
				WHERE 	AP.FechaPago 		= Par_Fecha
				AND 	AP.Reinversion 	= ReinversionSI
				AND 	AP.Estatus 		= EstatusVigente
				AND 	AP.ConCondiciones = No_constante;

			# APORTACIONES CON CONDICIONES DE VENCIMIENTO.
			TRUNCATE TABLE TMPAPORTCONDICIONES;
			INSERT INTO TMPAPORTCONDICIONES(
				AportacionID,		ClienteID,          CuentaAhoID,            TipoAportacionID,       MonedaID,
				FechaInicio,        Monto,              PlazoOriginal,          Plazo,                  Tasa,
				TasaISR,            TasaNeta,           InteresGenerado,        InteresRecibir,         InteresRetener,
				TipoPagoInteres,    DiasPeriodo,	  	PagoIntCal,				Reinversion,        	Reinvertir,
				SaldoProAcumulado,	SucursalID,    		TasaFV,           		Calificacion,       	PlazoInferior,
				PlazoSuperior,      MontoInferior,		MontoSuperior,      	FechaVencimiento,   	FechaPago,
				NuevoPlazo,         MontoReinvertir,	NuevaTasa,          	NuevaTasaISR,       	NuevaTasaNeta,
				NuevoCalInteres,    NuevaTasaBaseID,	NuevaSobreTasa,     	NuevoPisoTasa,      	NuevoTechoTasa,
				NuevoIntGenerado,   NuevoIntRetener,    NuevoIntRecibir,   	 	NuevoValorGat,      	NuevoValorGatReal,
				AmortizacionID,     DiaInhabil,			MontoGlobal,			TasaMontoGlobal,		IncluyeGpoFam,
				DiasPago,			PagoIntCapitaliza,	OpcionAport,			CantidadReno,			InvRenovar,
				Notas,				CalculoInteres,		ConCondiciones,			ConsolidarSaldos,		EmpresaID,
				UsuarioID,			FechaActual,		DireccionIP,			ProgramaID,				Sucursal,
				NumTransaccion)
			SELECT
				AP.AportacionID,	AP.ClienteID,		AP.CuentaAhoID,			AP.TipoAportacionID,	AP.MonedaID,
				Par_Fecha,			AP.Monto,			AP.PlazoOriginal,		AP.Plazo,				AP.TasaFija,
				AP.TasaISR,			AP.TasaNeta,		amo.SaldoProvision,		(amo.SaldoProvision-(amo.SaldoISR+amo.SaldoIsrAcum)),   (amo.SaldoISR+amo.SaldoIsrAcum),
				AP.TipoPagoInt,		AP.DiasPeriodo,		AP.PagoIntCal,			AP.Reinversion,			AP.Reinvertir,
				AP.SaldoProvision,	AP.SucursalID,		tipo.TasaFV,       		Cadena_Vacia,       	Entero_Cero,
				Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Fecha_Vacia,        	Fecha_Vacia,
				Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				Entero_Cero,        Entero_Cero,        Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				Decimal_Cero,       Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
				amo.AmortizacionID, tipo.DiaInhabil,	(FNAPORTMONTOGLOBAL(tipo.TipoAportacionID,AP.ClienteID)),
				tipo.TasaMontoGlobal,tipo.IncluyeGpoFam,
				AP.DiasPago,		AP.PagoIntCapitaliza,	AP.OpcionAport,		AP.CantidadReno,		AP.InvRenovar,
				AP.Notas,			AP.CalculoInteres,	AP.ConCondiciones,		AP.ConsolidarSaldos,	Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion
				FROM 	APORTACIONES AP
						INNER JOIN AMORTIZAAPORT amo ON AP.AportacionID = amo.AportacionID AND AP.FechaPago = amo.FechaPago
						INNER JOIN TIPOSAPORTACIONES tipo ON AP.TipoAportacionID = tipo.TipoAportacionID
				WHERE 	AP.FechaPago 	= Par_Fecha
					AND ((AP.Reinversion IN (ReinversionSI, ReinvPosterior)
					AND AP.Estatus 		= EstatusVigente
					AND AP.ConCondiciones = Si_constante)

					OR (AP.Reinversion 	IN (ReinvPosterior)
					AND AP.Estatus 		= EstatusVigente
					AND AP.ConCondiciones = No_constante));

			# ACTUALIZACIÓN DE LAS NUEVAS CONDICIONES QUE SE ENCUENTREN AUTORIZADAS.
			UPDATE TMPAPORTCONDICIONES TMP
				INNER JOIN CONDICIONESVENCIMAPORT C ON TMP.AportacionID = C.AportacionID
			SET
				TMP.MontoReinvertir		= C.MontoRenovacion,
				TMP.MontoGlobal			= C.MontoGlobal,
				TMP.NuevoPlazo			= C.Plazo,
				TMP.PlazoOriginal		= C.PlazoOriginal,
				TMP.NuevaTasa			= C.TasaBruta,
				TMP.NuevaTasaISR		= C.TasaISR,
				TMP.NuevaTasaNeta		= C.TasaNeta,
				TMP.NuevoCalInteres		= TMP.CalculoInteres,
				TMP.NuevaTasaBaseID		= Entero_Cero,
				TMP.NuevaSobreTasa		= Entero_Cero,
				TMP.NuevoPisoTasa		= Entero_Cero,
				TMP.NuevoTechoTasa		= Entero_Cero,
				TMP.NuevoIntGenerado	= C.InteresGenerado,
				TMP.NuevoIntRetener		= C.ISRRetener,
				TMP.NuevoIntRecibir		= C.InteresRecibir,
				TMP.NuevoValorGat		= C.GatNominal,
				TMP.NuevoValorGatReal	= C.GatReal,
				TMP.NuevaOpcionAportID	= C.OpcionAportID,
				TMP.NuevaCantidadReno	= C.Cantidad,
				TMP.NuevaNotas			= C.Notas,
				TMP.FechaVencimiento    = C.FechaVencimiento,
				TMP.FechaPago           = C.FechaVencimiento,
				TMP.ReinversionPact		= C.ReinversionAutomatica,
				TMP.NuevoCapitalInteres	= C.CapitalizaInteres,
				TMP.NuevoDiasPago		= C.DiaPago
			WHERE C.ReinversionAutomatica = ReinversionSI
				AND C.Estatus = EstatusAut;

			/** ACTUALIZACIÓN DE LAS CONDICIONES QUE SE ENCUENTREN AUTORIZADAS
			 ** PERO QUE SE PACTARON COMO NO REINVERSIÓN.*/
			UPDATE TMPAPORTCONDICIONES TMP
				INNER JOIN CONDICIONESVENCIMAPORT C ON TMP.AportacionID = C.AportacionID
			SET
				TMP.ReinversionPact = C.ReinversionAutomatica
			WHERE C.ReinversionAutomatica = No_constante
				AND C.Estatus = EstatusAut;

			/** ACTUALIZACIÓN DE LAS CONDICIONES QUE NO SE ENCUENTREN AUTORIZADAS
			 ** (PENDIENTES Y POR AUTORIZAR).*/
			UPDATE TMPAPORTCONDICIONES TMP
				INNER JOIN CONDICIONESVENCIMAPORT C ON TMP.AportacionID = C.AportacionID
			SET
				TMP.ReinversionPact = No_constante
			WHERE C.Estatus != EstatusAut;

			/** ACTUALIZACIÓN DE LAS CONDICIONES QUE NO REINVIERTEN POR NO ESTAR AUTORIZADAS
			 ** (PENDIENTES Y POR AUTORIZAR).*/
			UPDATE CONDICIONESVENCIMAPORT C
				INNER JOIN TMPAPORTCONDICIONES TMP ON C.AportacionID = TMP.AportacionID
			SET
				C.EstatusRenovacion = No_constante,
				C.MotivoRenovacion = 'CONDICIONES DE VENCIMIENTO NO AUTORIZADAS.'
			WHERE C.Estatus != EstatusAut
				AND TMP.ReinversionPact = No_constante;

			/** ACTUALIZACIÓN DEL MOTIVO DE CANCELACIÓN
			 ** CUANDO LAS CONDICIONES ESTEN PENDIENTES.
			 ** (NO CAPTURADAS).*/
			UPDATE APORTACIONES AP
				INNER JOIN TMPAPORTCONDICIONES TMP ON AP.AportacionID = TMP.AportacionID
			SET
				AP.MotivoCancela = 'CONDICIONES DE VENCIMIENTO NO AUTORIZADAS.'
			WHERE TMP.ReinversionPact = No_constante
				AND TMP.ConCondiciones = No_constante;

			SET Var_NumAport		:= (SELECT COUNT(AportacionID) FROM TMPAPORTACIONES);
			SET Var_NumAportCond	:= (SELECT COUNT(AportacionID) FROM TMPAPORTCONDICIONES);
			SET Var_NumAport		:= IFNULL(Var_NumAport,Entero_Cero) + IFNULL(Var_NumAportCond,Entero_Cero);

			-- Actualización del Monto a Reinvertir y el Monto Global del Cliente y/o Gpo. Familiar.
			UPDATE TMPAPORTACIONES tmp SET
				tmp.MontoReinvertir =
									CASE
										WHEN (tmp.Reinvertir = Var_Capital) THEN tmp.Monto
										WHEN (tmp.Reinvertir = Var_CapitalInteres) THEN (tmp.Monto + tmp.InteresRecibir)
									END,
				tmp.MontoGlobal =
									CASE
										WHEN (tmp.Reinvertir = Var_Capital) THEN (tmp.Monto + tmp.MontoGlobal)
										WHEN (tmp.Reinvertir = Var_CapitalInteres) THEN (tmp.Monto + tmp.InteresRecibir + tmp.MontoGlobal)
									END;

			-- CALCULO DEL NUEVO MONTO A REINVERTIR PARA AQUELLAS APORTACIONES MADRES
			-- QUE TIENEN UN ANCLAJE, AL MONTO A REINVERTIR SE LE SUMAN SUS "HIJAS"
			-- ADEMAS EN EL PROCESO, PAGA LAS APORTACIONES HIJAS
			CALL APORTANCLAJEPRO(
				Par_Fecha,          SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);
			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- CALCULO DE LAS FECHAS DE VENCIMIENTO Y DE PAGO DE LA APORTACION
			-- CONSIDERANDO EL PRODUCTO O TIPO DE APORTACION, SI CONSIDERA HABIL EL SABADO O NO
            UPDATE TMPAPORTACIONES SET
				FechaVencimiento    = (DATE_ADD(FechaInicio, INTERVAL PlazoOriginal DAY));

			UPDATE TMPAPORTACIONES SET
				FechaPago           = (DATE_ADD(FechaInicio, INTERVAL PlazoOriginal DAY));

			-- CALCULO DE LAS TASAS PARA LOS NUEVOS APORTACIONES
			CALL APORTMASIVOTASACAL(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Par_EmpresaID,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- CALCULO DE INTERES GENERADO, GAT
			CALL APORTMASIVOCONDPRO(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP ,   Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL APORTSINTASAPRO(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL APORTMASIVACUR(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         ContadorTotal,          ContadorExito,
				SalidaNO,           Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NumErr = Entero_Cero) THEN
				SET Par_NumErr  :=  Entero_Cero;
				SET Par_ErrMen  :=  'Reinversion Masivo de Aportaciones Realizado Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo, si es diferente inserta*/
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoAport,        Par_Fecha,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco   := NOW();

			/*Contadores vencimiento masivo */
			SET Par_ContadorTotal:=ContadorTotal;
			SET Par_ContadorExito:=ContadorExito;

		END IF;

			SET Par_NumErr  :=  Entero_Cero;
			SET Par_ErrMen  :=  'Reinversion Masivo de Aportaciones Realizado Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				/*Contadores vencimiento masivo*/
				Par_ContadorTotal AS ContTotal,
				Par_ContadorExito AS ContExito;
	END IF;

END TerminaStore$$