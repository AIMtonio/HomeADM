-- CRWINVCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVCIEDIAPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWINVCIEDIAPRO`(
	Par_Fecha					DATE,				-- Parametro de fecha
	Par_EmpresaID				INT(11),			-- Parametro de empresa ID

	Par_Salida					CHAR(1),			-- TIPO DE SALIDA.
	INOUT Par_NumErr			INT(11),			-- Parametro de salida numero de error.
	INOUT Par_ErrMen			VARCHAR(400),		-- Parametro de salida de Mensaje de error.
	INOUT Par_Consecutivo		BIGINT,				-- Parametro de salida de numero de consecutivo.

	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT				-- Parametro de Auditoria
)
TerminaStore: BEGIN

DECLARE	Var_FechaBatch			DATE;
DECLARE	Var_FecBitaco 			DATETIME;
DECLARE	Var_MinutosBit 			INT(11);
DECLARE Var_DiasApliGarantia	INT(3);
DECLARE	Fec_Calculo				DATE;
DECLARE	Sig_DiaHab				DATE;
DECLARE Var_EsHabil				CHAR(1);
DECLARE Var_Control    			VARCHAR(100);   		-- Variable de Control
DECLARE Var_EstaHabilitado		CHAR(1);

DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE	Decimal_Cero			DECIMAL(12,2);
DECLARE	Pro_CieInv				INT(11);
DECLARE	Pro_GenIntere 			INT(11);
DECLARE	Pro_VencimInv			INT(11);
DECLARE	Pro_TraspaExi			INT(11);
DECLARE	Pro_CalSaldos			INT(11);
DECLARE	Cons_Si					CHAR(1);
DECLARE	Cons_No					CHAR(1);
DECLARE Pro_AplicaGarantia		INT(11);
DECLARE Entero_Uno				INT(11);

SET	Cadena_Vacia				:= '';					-- Cadena Vacia
SET	Fecha_Vacia					:= '1900-01-01';		-- Fecha Vacia
SET	Entero_Cero					:= 0;					-- entero Cero
SET Entero_Uno					:= 1;					-- Entero Uno
SET	Decimal_Cero				:= 0.00;				-- DECIMAL cero

SET	Pro_CieInv	 				:= 300;					-- Proceso Batch Cierre diario
SET	Pro_GenIntere				:= 301;					-- Proceso Batch Generacion de Interes Ordinario. Inv
SET	Pro_VencimInv 				:= 302;					-- Proceso Batch Vencimientos y Pagos de Inversion
SET	Pro_TraspaExi 				:= 303;					-- Proceso Batch Traspaso Exigible
SET	Pro_CalSaldos 				:= 304;					-- Proceso Batch Calculo de Saldos de Inv
SET Pro_AplicaGarantia			:= 305;					-- Proceso Batch Aplicacion Automatica de Garantias
SET Cons_Si						:= 'S';					-- Salida en Pantalla Si
SET	Cons_No						:= 'N';					-- Salida en Pantalla NO
SET	Aud_ProgramaID				:= 'CRWINVCIEDIAPRO';	-- Proceso

SET	Var_FecBitaco				:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWINVCIEDIAPRO');
		   SET Var_Control := 'SQLEXCEPTION';
		END;

	# VALIDACIÓN SI EL MÓDULO CROWDFUNDING ESTA HABILITADO.
	SET Var_EstaHabilitado := FNPARAMGENERALES('ActivoModCrowd');
	SET Var_EstaHabilitado := IFNULL(Var_EstaHabilitado,Cons_No);

	IF(Var_EstaHabilitado=Cons_Si)THEN
		SELECT Fecha INTO Var_FechaBatch
		FROM BITACORABATCH
		WHERE Fecha 			= Par_Fecha
		  AND ProcesoBatchID	= Pro_CieInv;

		SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

		IF Var_FechaBatch != Fecha_Vacia THEN
			LEAVE TerminaStore;
		END IF;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_CieInv, 		Par_Fecha, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco = NOW();
		CALL DIASFESTIVOSCAL(
		    Par_Fecha,      		Entero_Uno,         Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
		    Aud_Usuario,    		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		    Aud_NumTransaccion);

		SET Fec_Calculo := Par_Fecha;

		-- Corremos la Generacion de Moratorio, Paso a Vencido y Generacion de Interes
		-- Por Varios DÃ­AS hasta un dia antes del dÃ­a habil siguiente
		WHILE (Fec_Calculo < Sig_DiaHab) DO

			SET Var_FecBitaco = NOW();

			CALL CRWFONVENCIMPRO(
				Fec_Calculo,        Par_EmpresaID,    	Cons_No,       	Par_NumErr,       Par_ErrMen,
				Par_Consecutivo,  	Aud_Usuario,        Aud_FechaActual,  	Aud_DireccionIP,  Aud_ProgramaID,
				Aud_Sucursal,     	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Pro_VencimInv, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_FecBitaco = NOW();

			CALL CRWFONTRASEXIPRO(
				Fec_Calculo,   			 Par_EmpresaID,   			 Cons_No,      			 Par_NumErr,     			 Par_ErrMen,
				Aud_Usuario, 			 Aud_FechaActual, 			 Aud_DireccionIP, 			 Aud_ProgramaID, 			 Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Pro_TraspaExi, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_FecBitaco = NOW();

			CALL CRWGENERAINTEREINVPRO(
				Fec_Calculo,   		 Cons_No,      		 Par_NumErr,      		 Par_ErrMen,     		 Par_EmpresaID,
				Aud_Usuario, 		 Aud_FechaActual, 		 Aud_DireccionIP, 		 Aud_ProgramaID, 		 Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Pro_GenIntere, 		Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		 -- ------------------------- Aplicacion Automatica de Garantias ---------------------------------------------------}

		    CALL CRWINVGARANTIACIEPRO(
		    	Fec_Calculo,   		 Cons_No,      		 Par_NumErr,      		 Par_ErrMen,     		 Par_EmpresaID,
				Aud_Usuario, 		 Aud_FechaActual, 		 Aud_DireccionIP, 		 Aud_ProgramaID, 		 Aud_Sucursal,
				Aud_NumTransaccion);

		    IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CRWINVCALSALDPRO(
				Fec_Calculo,       	 Cons_No,     	 	 Par_NumErr,      		 Par_ErrMen,		Par_EmpresaID,
				Aud_Usuario,       	 Aud_FechaActual,	 Aud_DireccionIP, 	 	 Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

			SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());


			CALL BITACORABATCHALT(
				Pro_CalSaldos, 		Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

			SET	Fec_Calculo	= ADDDATE(Fec_Calculo, Entero_Uno);

		END WHILE;

	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := CONCAT('Proceso Terminado Exitosamente');

END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Cons_Si) THEN
		SELECT
			Par_NumErr 		AS NumErr,
			Par_ErrMen		AS ErrMen,
			'invieDia' 		AS control;
	END IF;

END TerminaStore$$