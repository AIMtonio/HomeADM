-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTERACIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTERACIEDIAPRO`;
DELIMITER $$

CREATE PROCEDURE `CARTERACIEDIAPRO`(
	/*SP para el Proceso de Cierre de Cartera*/
	Par_Fecha			DATE,			-- Fecha de Cierre

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_FechaBatch			DATE;
	DECLARE	Var_FecBitaco 			DATETIME;
	DECLARE	Var_MinutosBit 			INT(11);
	DECLARE	Sig_DiaHab				DATE;
	DECLARE Var_EsHabil				CHAR(1);
	DECLARE	Fec_Calculo				DATE;
	DECLARE Var_CancelAutSolCre 	CHAR(1);
	DECLARE Var_FecSiguie   		DATE;
	DECLARE Var_FecOper 			DATE;
	DECLARE Var_FecActual   		DATETIME;
	DECLARE Var_Empresa     		INT;
	DECLARE Fec_Fin					DATE;
	DECLARE Var_FechaSig    		DATE;
	DECLARE Var_TipoInstitID 		INT(11);		-- Valor del Tipo de Institucion
    DECLARE Par_NumErr      		INT(11);
    DECLARE Par_ErrMen      		VARCHAR(400);
    DECLARE Var_CobComApertMens		CHAR(1);		-- Contabilizar comision por apertura de forma mensual
    DECLARE Var_UltimoDiaMes		DATE;
    DECLARE Var_CobraAccesoriosGen	CHAR(1);		-- Valor del Cobro de Accesorios

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Pro_CieCartera	INT(11);
	DECLARE	Pro_GenIntere 	INT(11);
	DECLARE	Pro_PasoAtras 	INT(11);
	DECLARE	Pro_PasoVenc 	INT(11);
	DECLARE	Pro_CalSaldos	INT(11);
	DECLARE CancelaAutoSI	CHAR(1);
	DECLARE Pro_CancelSol	INT(11);
	DECLARE Un_DiaHabil     INT(11);
	DECLARE Es_DiaHabil     CHAR(1);
	DECLARE AplicaContaSI   CHAR;
	DECLARE ProgramaResID   VARCHAR(200);
	DECLARE	Pro_ClasiEPRC	INT(11);
	DECLARE	Pro_CalEPRC		INT(11);
	DECLARE Cero_DiaHabil   INT(11);
	DECLARE SiEs_DiaHabil   CHAR(1);
	DECLARE TipoInstSOFIPO  INT(11);            -- Tipo de Institucion: SOFIPO
	DECLARE Pro_GenSegCuota INT(11);
	DECLARE Pro_GenComAnual INT(11);
    DECLARE SalidaNO		CHAR(1);
    DECLARE Pro_ComAp		INT(11);
    DECLARE Cons_SI			CHAR(1);
	DECLARE Cons_NO			CHAR(1);
	DECLARE CobComApertMens	VARCHAR(15);
    DECLARE Pro_CobCreAut	INT(11);
    DECLARE Pro_CobAccesorios	INT(11);
    DECLARE Pro_CanAutConsolidacionAgro INT(11);	-- Proceso de Cancelacion Automatica de Consolidaciones Agro
    DECLARE Llave_CobraAccesorios	VARCHAR(100); -- Llave para Consutal Si cobra Accesorios
    DECLARE Pro_CobComAnualLin	INT(11);
    DECLARE Pro_ActInstNom	INT(11);				-- SP que actualiza el estatus de instalacion de nomina para que los creditos comiencen a devengar
	DECLARE Pro_IntPendAcc	INT(11);				-- SP que genera el interes de accesorios pendiente
	DECLARE Pro_GenIntPend	INT(11);				-- SP que genera el interes ordinario pendiente
	DECLARE Pro_GenIntAcc	INT(11);				-- SP que genera el interes de accesorios
	DECLARE Pro_LineasCredAgroVenDia	INT(11);	-- Proceso de Vencimiento de Lineas de Credito Agro

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Pro_CieCartera 	:= 200;
	SET	Pro_GenIntere 	:= 201;
	SET	Pro_PasoAtras 	:= 202;
	SET	Pro_PasoVenc	:= 203;
	SET	Pro_CalSaldos	:= 204;
	SET CancelaAutoSI	:= 'S';      # Cancelacion Automatica Solicitudes de Creditos: SI
	SET Pro_CancelSol   := 206;      # Proceso Batch para Cancelacion de Solicitudes de Credito
	SET	Aud_ProgramaID	:= 'CARTERACIEDIAPRO';

	SET	Var_FecBitaco	:= NOW();
	SET Un_DiaHabil    	:= 1;
	SET AplicaContaSI   :='S';
	SET ProgramaResID   :='EstimacionPreventivaDAO.generaEstimacionPreventiva';
	SET Pro_ClasiEPRC	:= 207;		# Proceso Batch para Clasificacion de estimaciones preventivas
	SET Pro_CalEPRC		:= 208;		# Proceso Batch para el calculo de la estimacion preventiva
	SET Cero_DiaHabil   := 0;
	SET SiEs_DiaHabil   := 'S';
	SET TipoInstSOFIPO  := 3;		-- Tipo de Institucion: SOFIPO
	SET Pro_GenSegCuota := 209;		-- Proceso Batch para generar el seguro por cuota
	SET Pro_GenComAnual := 210;		-- Proceso Batch para generar la Comision por Anualidad
    SET Pro_ComAp		:= 211;		-- Proceso Batch para generar la Comision por Apertura de Credito
    SET Pro_CobCreAut	:= 212;		-- Proceso Batch para realizar el cobro de creditos automaticos
    SET Pro_CobComAnualLin := 214; 	-- Proceso Batch para realizar el cobreo de la comisión anual de l a linea de crédito

	SET SalidaNO		:= 'N';
	SET Par_NumErr		:= 0;
    SET Par_ErrMen		:= '';
    SET Cons_SI			:= 'S';		-- Constante S: SI
    SET Cons_NO			:= 'N';		-- COnstante N: NO
    SET CobComApertMens	:= 'CobComApertMens';	-- Cobro de la comision por apertura mensual
    SET Pro_CobAccesorios	:= 213;		-- Proceso Batch para realizar el cobro de creditos automaticos
    SET Llave_CobraAccesorios	:= 'CobraAccesorios';	-- Llave para consulta el valor de Cobro de Accesorios
	SET Pro_CanAutConsolidacionAgro := 215;
	SET Pro_ActInstNom	:= 216;						-- SP que actualiza el estatus de instalacion de nomina para que los creditos comiencen a devengar
	SET Pro_IntPendAcc	:= 217;						-- SP que genera el interes de accesorios pendiente
	SET Pro_GenIntPend	:= 218;						-- SP que genera el interes ordinario pendiente
	SET Pro_GenIntAcc	:= 219;						-- SP que genera el interes de accesorios
	SET Pro_LineasCredAgroVenDia 	:= 220;

	-- Se obtiene el valor del Tipo de Institucion
	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM INSTITUCIONES Ins,PARAMETROSSIS Par WHERE Par.InstitucionID = Ins.InstitucionID);
	SET Var_TipoInstitID := IFNULL(Var_TipoInstitID,Entero_Cero);

	SELECT FechaSistema, EmpresaDefault	 INTO Var_FecActual,	Var_Empresa
		FROM PARAMETROSSIS;
	SET Var_FecOper	   := Var_FecActual;

    SELECT	ValorParametro
		  INTO 	Var_CobComApertMens
			FROM PARAMGENERALES
			WHERE	LlaveParametro = CobComApertMens;

	SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
	SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

	SELECT Fecha INTO Var_FechaBatch
		FROM BITACORABATCH
		WHERE Fecha 			= Par_Fecha
		  AND ProcesoBatchID	= Pro_CieCartera;

	SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);


	IF Var_FechaBatch != Fecha_Vacia THEN
		LEAVE TerminaStore;
	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_CieCartera, 	Par_Fecha, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	SET Var_FecBitaco := NOW();


	CALL DIASFESTIVOSCAL(
		Par_Fecha,      1,                  Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	SET Fec_Calculo := Par_Fecha;

	-- Se obtiene el ultimo dia del mes
	SET Var_UltimoDiaMes = LAST_DAY(Fec_Calculo);

		-- Corremos la Generacion de Moratorio, Paso a Vencido y Generacion de Interes
		-- Por Varios Dias hasta un dia antes del dia habil siguiente

	WHILE (Fec_Calculo < Sig_DiaHab) DO

		SET Aud_FechaActual := NOW();

		-- Actualizacion de estatus de instalacion nomina para que los creditos comiencen a devengar
		CALL CRENOMINAARCHINSTALCIERREPRO (
				Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT (
				Pro_ActInstNom, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		-- Puesta al dia del devengamiento pendiente de interes de accesorios en creditos de nomina
		CALL GENERAINTEREACCESPENDIENPRO (
				Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT (
				Pro_IntPendAcc, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

        -- Puesta al dia del devengamiento pendiente de interes ordinario en creditos de nomina
		CALL GENERAINTERECREPENDIENTEPRO (
				Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT (
				Pro_GenIntPend, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		# SE REALIZA EL COBRO DE CREDITOS AUTOMATICOS
		CALL PAGOCREAUTPRO(
			Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion	);

        -- Script para pagar aquellos que se metieron por el consumo del WS
        CALL PAGCREDWSPRO();

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_CobCreAut, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();

        -- Generacion de Interes Moratorio, Comisiones por Falta de Pago y Traspaso a Cartera en Atraso
		CALL GENERAINTERMORAPRO(
			Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_PasoAtras, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();

		-- Traspaso a Cartera Vencida
		CALL CREPASOVENCIDOPRO(
			Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_PasoVenc, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		SET Var_FecBitaco := NOW();

		-- Generacion de Interes Ordinario
		CALL GENERAINTERECREPRO(
			Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_GenIntere, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();
		CALL CRECALCULOSALDOSPRO(
			Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_CalSaldos, 		Fec_Calculo, 			Var_MinutosBit,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();
		-- Generacion de Seguro por Cuota
		CALL GENERASEGUROCUOTAPRO (
			Fec_Calculo,		SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
			Pro_GenSegCuota, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

        SET Var_FecBitaco := NOW();
		-- Generacion de Comision por Anualidad de Crédito
		CALL GENERACOMANUALPRO (
			Fec_Calculo,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
			Pro_GenComAnual, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

        IF(Var_CobComApertMens = Cons_NO) THEN
		SET Var_FecBitaco := NOW();

		CALL GENERACOMAPERPRO (
			Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
			Pro_ComAp, 			Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

        SET Var_FecBitaco := NOW();

       	IF(Var_CobraAccesoriosGen = Cons_SI) THEN
			-- Generacion de Seguro por Cuota
			CALL GENERAACCESORIOSPRO (
				Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Pro_CobAccesorios, 	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- Generacion de interes de accesorios
			CALL GENERAINTEREACCESPRO (
				Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT (
					Pro_GenIntAcc, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		END IF;

		SET Var_FecBitaco := NOW();
		CALL CANAUTCRECONAGROPRO (
			Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		SET Aud_FechaActual := NOW();
		CALL BITACORABATCHALT(
			Pro_CanAutConsolidacionAgro,	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		-- Vencimiento de Lineas de Credito Agro
		SET Var_FecBitaco := NOW();
		CALL LINEASCREDAGROVENDIAPRO (
			Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		SET Aud_FechaActual := NOW();
		CALL BITACORABATCHALT(
			Pro_LineasCredAgroVenDia,	Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


        IF(Fec_Calculo = Var_UltimoDiaMes)THEN

			-- Se realiza la reclasificacion de las estimaciones a instituciones que no sean SOPIPOS
			SET Var_FecBitaco := NOW();
			IF(Var_TipoInstitID != TipoInstSOFIPO) THEN
				CALL RECLASIFICAESTIMACIONES(Fec_Calculo);
			END IF;

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			CALL BITACORABATCHALT(
				Pro_ClasiEPRC, 		Fec_Calculo, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_FecBitaco := NOW();
			CALL CIERRERESERVAPRO(
				Fec_Calculo,     	AplicaContaSI,      	Entero_Cero,      	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,   	    ProgramaResID,		Aud_Sucursal,		Aud_NumTransaccion);


			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			CALL BITACORABATCHALT(
				Pro_CalEPRC, 		Fec_Calculo, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Var_CobComApertMens = Cons_SI) THEN
				SET Var_FecBitaco := NOW();

				CALL GENERACOMAPERMENSPRO (
					Fec_Calculo,		SalidaNO,			Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
				CALL BITACORABATCHALT(
					Pro_ComAp, 			Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			END IF;

			SET Var_FecBitaco := NOW();
            CALL LINEASCREDITOPRO(
				Fec_Calculo,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
                ProgramaResID,		Aud_Sucursal,			Aud_NumTransaccion);

            SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Pro_CobComAnualLin, 	Fec_Calculo, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

        END IF;

        SET Fec_Fin := Fec_Calculo;
		SET	Fec_Calculo	:= ADDDATE(Fec_Calculo, 1);

	END WHILE;


	# ======================== CANCELACION AUTOMATICA DE SOLICITUDES DE CREDITO INDIVIDUALES =========================#
	SET	Var_FecBitaco	:= NOW();

	SET Var_CancelAutSolCre := (SELECT IFNULL(CancelaAutSolCre,Cadena_Vacia) FROM PARAMETROSSIS);

	IF(Var_CancelAutSolCre = CancelaAutoSI) THEN
		CALL CANCELASOLCREPRO(
			Par_Fecha,		Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	END IF;

	SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_CancelSol, 		Par_Fecha,      	Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

	# --------------- Termina proceso de cancelacion automatica de solicitud de credito -----------------#

END TerminaStore$$
