-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEMASIVOPRO`;DELIMITER $$

CREATE PROCEDURE `CEDEMASIVOPRO`(
# ============================================================================
# -------- SP QUE SE ENCARGA DE REALIZAR LA REINVERSION MASIVA DE CEDES-------
# ============================================================================
    Par_Fecha               DATE,               -- Fecha de Operacion
    Par_TipoRegistro        CHAR(1),			-- Tipo de Registro

    INOUT Par_NumErr        INT(11),            -- Salida en Pantalla Numero  de Error o Exito
    INOUT Par_ErrMen        VARCHAR(400),       -- Salida en Pantalla Numero  de Error o Exito
    Par_Salida              CHAR(1),            -- Salida en Pantalla

    /*Contador vencimiento masivo cedes*/
    INOUT Par_ContadorTotal INT(11),    		-- Contador de Cedes Masivas Vencidas
    INOUT Par_ContadorExito INT(11),    		-- Contador de Cedes Masivas Vencidas Exitosamente

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
	DECLARE EstatusVigente      CHAR(1);
	DECLARE ProcesoCede         INT(11);
	DECLARE EnteroUno           INT(11);
	DECLARE ProgramaVencMasivo  VARCHAR(100);
	DECLARE SI_Isr_Socio  		CHAR(1);
    DECLARE ISRpSocio			VARCHAR(10);
    DECLARE No_constante		VARCHAR(10);
    DECLARE TipoRegistroD       CHAR(1);


	-- Declaracion de variables
	DECLARE ContadorTotal       INT(11);
	DECLARE ContadorExito       INT(11);
	DECLARE Var_NumCedes        INT(11);
	DECLARE Var_FecBitaco       DATETIME;
	DECLARE Var_Control         VARCHAR(200);
	DECLARE Var_Capital         CHAR(1);
	DECLARE Var_CapitalInteres  CHAR(2);
	DECLARE Var_MinutosBit      INT(11);
	DECLARE	Var_FechaBatch		DATE;
    DECLARE Var_InstrumenCede   INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia        :=  '';                 -- Constante Cadena_Vacia
	SET Fecha_Vacia         :=  '1900-01-01';       -- Constante Fecha Vacia
	SET Entero_Cero         :=  0;                  -- Constante Entero Cero
	SET Decimal_Cero        :=  0.0;                -- Constante DECIMAL Cero
	SET SalidaSI            :=  'S';                -- Constante Salida SI
	SET SalidaNO            :=  'N';                -- Constante Salida NO
	SET ReinversionSI       :=  'S';                -- Constante Reinversion SI
	SET EstatusVigente      :=  'N';                -- Constante Estatus Vigente
	SET ProcesoCede         :=  1317;               -- ID Proceso Batch 'CIERRE DIARIO CEDES'
	SET EnteroUno           :=  1;                  -- Valor Entero Uno
	SET ProgramaVencMasivo  := '/microfin/cedesVencimientoMasivo.htm';  -- Programa Vencimiento Masivo CEDES
	SET Var_Capital         := 'C';                 -- Valor Var_Capital
	SET Var_CapitalInteres  := 'CI';                -- Valor Var_Capital Intereses
	SET SI_Isr_Socio		:= 'S';					-- constante para saber si se calcula el isr por socio
    SET ISRpSocio			:= 'ISR_pSocio';		-- constante para isr por socio de PARAMGENERALES
    SET No_constante		:= 'N';					-- constante NO
	SET TipoRegistroD		:= 'D';					-- Tipo de Registro D
	SET Var_InstrumenCede   :=  28;                 -- Valor Instrumento CEDES.

	ManejoErrores:BEGIN
	 	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		   BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CEDEMASIVOPRO');
				SET Var_Control ='SQLEXCEPTION';
			END;

		SET Var_FecBitaco   := NOW();
		SET Aud_FechaActual := NOW();


		 -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoCede,			Par_Fecha,			Var_FechaBatch,		EnteroUno,	  		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	    Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN

			TRUNCATE TABLE TEMPCEDES;
			INSERT INTO TEMPCEDES(
				CedeID,             ClienteID,          CuentaAhoID,            TipoCedeID,             MonedaID,
				FechaInicio,        Monto,              PlazoOriginal,          Plazo,                  Tasa,
				TasaISR,            TasaNeta,           InteresGenerado,        InteresRecibir,         InteresRetener,
				TipoPagoInteres,    DiasPeriodo,	  	PagoIntCal,				Reinversion,        	Reinvertir,
                SaldoProAcumulado,	SucursalID,    		TasaFV,           		Calificacion,       	PlazoInferior,
                PlazoSuperior,      MontoInferior,		MontoSuperior,      	FechaVencimiento,   	FechaPago,
                NuevoPlazo,         MontoReinvertir,	NuevaTasa,          	NuevaTasaISR,       	NuevaTasaNeta,
                NuevoCalInteres,    NuevaTasaBaseID,	NuevaSobreTasa,     	NuevoPisoTasa,      	NuevoTechoTasa,
                NuevoIntGenerado,   NuevoIntRetener,    NuevoIntRecibir,   	 	NuevoValorGat,      	NuevoValorGatReal,
                AmortizacionID,     DiaInhabil,			EmpresaID,         		UsuarioID,          	FechaActual,
                DireccionIP,        ProgramaID,			Sucursal,           	NumTransaccion)
			SELECT
				cede.CedeID,        cede.ClienteID,     cede.CuentaAhoID,       cede.TipoCedeID,        cede.MonedaID,
				Par_Fecha,          cede.Monto,         cede.PlazoOriginal,     cede.Plazo,             cede.TasaFija,
				cede.TasaISR,       cede.TasaNeta,      amo.SaldoProvision,		(amo.SaldoProvision-amo.ISRCal),   amo.ISRCal,
				cede.TipoPagoInt,   cede.DiasPeriodo,	cede.PagoIntCal,		cede.Reinversion,   	cede.Reinvertir,
                cede.SaldoProvision,cede.SucursalID, 	tipo.TasaFV,       		Cadena_Vacia,       	Entero_Cero,
                Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Fecha_Vacia,        	Fecha_Vacia,
                Entero_Cero,        Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
                Entero_Cero,        Entero_Cero,        Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
                Decimal_Cero,       Decimal_Cero,		Decimal_Cero,       	Decimal_Cero,       	Decimal_Cero,
                amo.AmortizacionID, tipo.DiaInhabil,	Par_EmpresaID,      	Aud_Usuario,        	Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       	Aud_NumTransaccion
				FROM 	CEDES cede
						INNER JOIN AMORTIZACEDES amo ON cede.CedeID = amo.CedeID AND cede.FechaPago = amo.FechaPago
						INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID = tipo.TipoCedeID
				WHERE 	cede.FechaPago 		= Par_Fecha
				AND 	cede.Reinversion 	= ReinversionSI
				AND 	cede.Estatus 		= EstatusVigente;

			SELECT  COUNT(CedeID)   INTO    Var_NumCedes    FROM TEMPCEDES;
			SET Var_NumCedes := IFNULL(Var_NumCedes,Entero_Cero);


		-- ============================== ISR POR CLIENTE ======================================================
			IF(Var_NumCedes > Entero_Cero) THEN

				DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

				INSERT INTO CTESVENCIMIENTOS(
						Fecha,              ClienteID,      EmpresaID,      UsuarioID,      FechaActual,
						DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
				SELECT  Par_Fecha,          cede.ClienteID, Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,
						Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
					FROM 	TEMPCEDES cede
					GROUP BY cede.ClienteID;

				CALL CALCULOISRPRO(
					Par_Fecha,        	Par_Fecha,      	EnteroUno,      TipoRegistroD,   	SalidaNO,
					Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

             /*Se actualiza el Interes a Retener y el Interes a Recibir*/
				UPDATE TEMPCEDES cede INNER JOIN CEDES Ce  ON Ce.CedeID=cede.CedeID SET
					cede.InteresRetener = FNTOTALISRCTE(cede.ClienteID,Var_InstrumenCede,cede.CedeID),
					cede.InteresRecibir = cede.InteresGenerado-FNTOTALISRCTE(cede.ClienteID,Var_InstrumenCede,cede.CedeID);


 		-- ==============================FIN ISR POR CLIENTE======================================================
			UPDATE TEMPCEDES tmp    SET
				tmp.MontoReinvertir =   CASE    WHEN (tmp.Reinvertir = Var_Capital)         THEN tmp.Monto
												WHEN (tmp.Reinvertir = Var_CapitalInteres ) THEN (tmp.Monto + tmp.InteresRecibir)
										END;

			-- CALCULO DEL NUEVO MONTO A REINVERTIR PARA AQUELLAS CEDES MADRES
			-- QUE TIENEN UN ANCLAJE, AL MONTO A REINVERTIR SE LE SUMAN SUS "HIJAS"
			-- ADEMAS EN EL PROCESO, PAGA LAS CEDES HIJAS
			CALL CEDESANCLAJEPRO(
				Par_Fecha,          SalidaNO,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);
			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- CALCULO DE LAS FECHAS DE VENCIMIENTO Y DE PAGO DEL CEDE
			-- CONSIDERANDO EL PRODUCTO O TIPO DE CEDE, SI CONSIDERA HABIL EL SABADO O NO
			CALL CEDEMASIVOCAL(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- CALCULO DE LAS TASAS PARA LOS NUEVOS CEDES
			CALL CEDEMASIVOTASACAL(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Par_EmpresaID,      Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- CALCULO DE INTERES GENERADO, GAT
			CALL CEDEMASIVOCONDICIONESPRO(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP ,   Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CEDESSINTASAPRO(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         SalidaNO,       Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CEDESMASIVACUR(
				Par_Fecha,          Par_NumErr,         Par_ErrMen,         ContadorTotal,          ContadorExito,
				SalidaNO,           Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NumErr = Entero_Cero) THEN
				SET Par_NumErr  :=  Entero_Cero;
				SET Par_ErrMen  :=  'Reinversion Masivo de CEDES Realizados Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo cedes, si es diferente inserta*/
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoCede,        Par_Fecha,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco   := NOW();

			/*Contadores vencimiento masivo cedes*/
			SET Par_ContadorTotal:=ContadorTotal;
			SET Par_ContadorExito:=ContadorExito;

			/* SE LIMPIA LA TABLA TEMPORAL DE PASO */
			DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

		END IF;

			SET Par_NumErr  :=  Entero_Cero;
			SET Par_ErrMen  :=  'Reinversion Masivo de CEDES Realizados Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				/*Contadores vencimiento masivo cedes*/
				Par_ContadorTotal AS ContTotal,
				Par_ContadorExito AS ContExito;
	END IF;

END TerminaStore$$