-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDECIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDECIEDIAPRO`;DELIMITER $$

CREATE PROCEDURE `CEDECIEDIAPRO`(
# =============================================================================
# --- SP PARA REALIZAR EL PAGO Y EL VENCIMIENTO DE CEDES EN EL CIERRE DE DIA---
# =============================================================================
    Par_Fecha			DATE,			-- Fecha

    Par_Salida			CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),		-- Numero de error
    INOUT Par_ErrMen    VARCHAR(400),	-- Descripcion de error

    Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FechaBatch		DATE;
	DECLARE	Var_FecBitaco 		DATETIME;
	DECLARE	Var_MinutosBit 		INT(11);
	DECLARE Fec_Calculo			DATE;
    DECLARE Var_FecBitacoCEDE	DATETIME;
	DECLARE Var_FecOper			DATE;
	DECLARE Var_FecActual 		DATETIME;
	DECLARE Var_FecSiguie		DATE;
	DECLARE Es_DiaHabil			CHAR(1);
	DECLARE Var_ContUnoTotal	INT(11); -- Contador total CEDEPAGOCIERREPRO vencimiento masivo cedes
	DECLARE Var_ContUnoExito 	INT(11); -- Contador exito CEDEPAGOCIERREPRO vencimiento masivo cedes
	DECLARE Var_ContDosTotal	INT(11); -- Contador total CEDEMASIVOPRO vencimiento masivo cedes
	DECLARE Var_ContDosExito	INT(11); -- Contador exito CEDEMASIVOPRO vencimiento masivo cedes
    DECLARE Var_CliProEsp	  	INT;


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Pro_CieDiaCed   	INT(11);
	DECLARE Pro_Provision   	INT(11);
	DECLARE Pro_PagoInv     	INT(11);
	DECLARE Pro_PagoInvfm   	INT(11);
	DECLARE Pro_CieDiaAut   	INT(11);
	DECLARE Pro_CalcSaldos   	INT(11);
	DECLARE Un_DiaHabil			INT(11);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE Salida_SI        	CHAR(1);
	DECLARE	Pago_NoReinversion 	CHAR(1);
	DECLARE ProcesoCierre		CHAR(1);
    DECLARE Entero_Uno			INT(11);
    DECLARE InstCede       		INT(11);
    DECLARE NoCliEsp		  	INT;
    DECLARE CliProcEspecifico 	VARCHAR(20);


	-- Asignacion de Constantes
	SET Cadena_Vacia    		:= '';					-- Cadena Vacia
	SET Fecha_Vacia     		:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero     		:= 0;					-- Entero en Cero
	SET Pro_CieDiaCed   		:= 1300;				-- Proceso Batch: Cierre General de Inversiones Main
	SET Pro_Provision   		:= 1305;				-- Proceso Batch: Provision de Intereses
	SET Pro_PagoInv     		:= 1306;				-- Proceso Batch: Pago de Inversiones
	SET Pro_PagoInvfm   		:= 1309;				-- Proceso Batch: Reinversion
	SET Pro_CieDiaAut   		:= 1310;				-- Proceso Batch: Cancelacion de CEDES
	SET Pro_CalcSaldos   		:= 1318;				-- Proceso Batch: Calculo de Saldos Diarios
	SET Un_DiaHabil				:= 1;					-- Un dia habil
	SET Salida_NO       		:= 'N';					-- Salida: NO
	SET Salida_SI       		:= 'S';					-- Salida: SI
	SET	Pago_NoReinversion 		:= 'N';					-- Tipo de Cedes que NO Reinvierten
	SET ProcesoCierre			:= 'C';					-- Proceso de Cierre
	SET Entero_Uno				:= 1;					-- Entero Uno
    SET InstCede   				:= 28;					-- Numero de Instrumento de Cedes
    SET NoCliEsp				:=24;				-- Cliente CrediClub
    SET CliProcEspecifico		:='CliProcEspecifico';



	-- Inicializaciones
	SET Var_FecBitaco			:= NOW();
	SET Aud_FechaActual			:= NOW();

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDECIEDIAPRO');
			END;

		SET Var_FecBitacoCEDE	:= NOW();

		SELECT FechaSistema INTO Var_FecActual
			FROM PARAMETROSSIS;

		SELECT ValorParametro INTO Var_CliProEsp
        FROM PARAMGENERALES
        where LlaveParametro= CliProcEspecifico;

			SET Var_FecOper	   := Var_FecActual;
		-- -------------------------------------------------------------------------------------------
		-- Proceso que Cancela Todas las CEDES que se dieron de alta hoy y que no fueron
		-- Autorizadas o Canceladas. Solo Cambia el Estatus a "C -Cancelado"
		-- -------------------------------------------------------------------------------------------
		-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			Pro_CieDiaAut,			Par_Fecha,			Var_FechaBatch,		Entero_Uno,		Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
            Aud_NumTransaccion);


		IF(Var_FechaBatch = Fecha_Vacia) THEN

			SET Var_FecBitaco := NOW();

			CALL CANCELACEDESPRO (
				  Par_Fecha,        Salida_NO,         	Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
				  Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				  Aud_NumTransaccion);

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual	:= NOW();

			CALL BITACORABATCHALT(
				Pro_CieDiaAut,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		END IF;

		-- -------------------------------------------------------------------------------------------
		-- Vencimiento y Pago de Cedes
		-- Que pague las de NO Reinversion
		-- -------------------------------------------------------------------------------------------
		-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			Pro_PagoInvfm,			Par_Fecha,			Var_FechaBatch,		Entero_Uno,			Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia) THEN
			SET Var_FecBitaco := NOW();

			IF (Var_CliProEsp = NoCliEsp) THEN
				CALL CEDEPAGOCIERREPRO024(
					Par_Fecha,			ProcesoCierre,		Pago_NoReinversion, Salida_NO,         	Par_NumErr,
					Par_ErrMen,			Var_ContUnoTotal, 	Var_ContUnoExito,	Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

			ELSE
				CALL CEDEPAGOCIERREPRO(
					Par_Fecha,			ProcesoCierre,		Pago_NoReinversion, Salida_NO,         	Par_NumErr,
					Par_ErrMen,			Var_ContUnoTotal, 	Var_ContUnoExito,	Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual	:= NOW();

			CALL BITACORABATCHALT(
				Pro_PagoInvfm,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		END IF;

		-- -------------------------------------------------------------------------------------------
		-- Proceso que Paga las CEDES, que su ultima amortizacion es el dia de hoy
		-- y que tiene Reinvertir SI
		-- -------------------------------------------------------------------------------------------
		CALL CEDEMASIVOPRO(
			Par_Fecha,			ProcesoCierre,		Par_NumErr,		Par_ErrMen,			Salida_NO,
			Var_ContDosTotal,	Var_ContDosExito,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual	:= NOW();

		 -- -------------------------------------------------------------------------------------------
		-- Proceso para el Calculo del Interes Real
		-- -------------------------------------------------------------------------------------------
		CALL CALCULOINTERESREALPRO (
			 Par_Fecha,			InstCede,			Salida_NO,			Par_NumErr,			Par_ErrMen,
             Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
             Aud_Sucursal,		Aud_NumTransaccion);

         IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		 END IF;
		-- -------------------------------------------------------------------------------------------
		-- Proceso para saber si el siguiente dia es habil
		-- -------------------------------------------------------------------------------------------
		CALL DIASFESTIVOSCAL(
			Var_FecOper,		Un_DiaHabil,		Var_FecSiguie,		Es_DiaHabil,	Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		SET Fec_Calculo 	:= Par_Fecha;
		SET Aud_FechaActual	:= NOW();
		SET Var_FecBitaco 	:= NOW();

		WHILE (Fec_Calculo < Var_FecSiguie) DO -- WHILE PARA HACER LAS POLIZAS POR DIA

			-- -------------------------------------------------------------------------------------------
			-- Proceso que Genera el Interes Provisionado del Dia.
			-- -------------------------------------------------------------------------------------------
			-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
			CALL BITACORABATCHCON (
				Pro_Provision,			Fec_Calculo,		Var_FechaBatch,		Entero_Uno,		Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
                Aud_NumTransaccion);

			IF(Var_FechaBatch = Fecha_Vacia) THEN
				CALL CEDEPROVISIONPRO(
					Fec_Calculo,		Par_EmpresaID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
				SET Aud_FechaActual	:= NOW();

				CALL BITACORABATCHALT(
					Pro_Provision, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			END IF;
			-- -------------------------------------------------------------------------------------------
			-- Proceso que Genera los Saldos de CEDES (Foto del como Cierra el dia el CEDE)
			-- -------------------------------------------------------------------------------------------
			-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
			CALL BITACORABATCHCON (
				Pro_CalcSaldos,			Fec_Calculo,		Var_FechaBatch,		Entero_Uno,			Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                Aud_NumTransaccion);


			SET Var_FecBitaco 	:= NOW();

			IF(Var_FechaBatch = Fecha_Vacia) THEN

				CALL CEDECALCULOSALDOSPRO(
					Fec_Calculo,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
				SET Aud_FechaActual	:= NOW();

				CALL BITACORABATCHALT(
					Pro_CalcSaldos,		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			END IF;

			SET Var_FecBitaco 	:= NOW();
			SET	Fec_Calculo		:= ADDDATE(Fec_Calculo, 1);

		END WHILE;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Cierre de Dia de CEDES Realizados Exitosamente.';

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitacoCEDE, NOW());
		SET Aud_FechaActual	:= NOW();

		CALL BITACORABATCHALT(
			Pro_CieDiaCed,		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Entero_Cero	AS Consecutivo,
				Entero_Cero	AS Control;
	END IF;


END TerminaStore$$