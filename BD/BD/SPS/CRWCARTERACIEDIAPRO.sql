-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCARTERACIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWCARTERACIEDIAPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWCARTERACIEDIAPRO`(
	Par_Fecha			DATE,
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

)
TerminaStore: BEGIN


DECLARE	Var_FechaBatch	DATE;
DECLARE	Var_FecBitaco 	DATETIME;
DECLARE	Var_MinutosBit 	INT(11);
DECLARE	Sig_DiaHab		DATE;
DECLARE Var_EsHabil		CHAR(1);
DECLARE	Fec_Calculo		DATE;
DECLARE Var_NumErr		INT(11);
DECLARE Var_ErrMen		VARCHAR(400);
DECLARE Fec_Fin			DATE;

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE Valor_SI        CHAR;

DECLARE	Pro_CieCartera	INT(11);
DECLARE	Pro_GenIntere 	INT(11);
DECLARE	Pro_PasoAtras 	INT(11);
DECLARE	Pro_PasoVenc 	INT(11);
DECLARE	Pro_CalSaldos	INT(11);
DECLARE	Pro_CieReserva	MEDIUMINT(3);
DECLARE SalidaNo		CHAR(1);

/* Variables del proceso de Fondeo */
DECLARE Var_DiasApliGarantia	INT(3);
DECLARE	Var_FechaBatchInv		DATE;
DECLARE	Decimal_Cero			DECIMAL(12,2);
DECLARE	Pro_CieInvKubo			INT(11);
DECLARE	Pro_GenIntereInv 		INT(11);
DECLARE	Pro_VencimInv			INT(11);
DECLARE	Pro_TraspaExi			INT(11);
DECLARE	Pro_CalSaldosInv		INT(11);
DECLARE Pro_AplicaGarantia		INT(11);
DECLARE	Par_Consecutivo			BIGINT;	

SET	Cadena_Vacia		:= '';					-- Cadena Vacia	
SET	Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
SET	Entero_Cero			:= 0;					-- Entero Cero

SET	Pro_CieCartera 		:= 200;					-- Proceso General de cierre de Cartera		
SET	Pro_GenIntere 		:= 201;					-- Proceso de cartera Generacion de Interes Ordinario
SET	Pro_PasoAtras 		:= 202;					-- Proceso de Cartera Traspaso Cartera Atrasada
SET	Pro_PasoVenc	 	:= 203;					-- Proceso de Cartera Traspaso Cartera Vencida
SET	Pro_CalSaldos	 	:= 204;					-- Proceso de Cartera Calculo de Saldos de Cartera

SET	Aud_ProgramaID		:= 'CRWCARTERACIEDIAPRO';

SET	Var_FecBitaco		:= NOW();
SET SalidaNo			:='N';
SET Valor_SI            :='S';

/* -Variables de Inversion -*/
SET	Pro_CieInvKubo 		:= 300;					-- Proceso Batch Cierre diario Kubo
SET	Pro_GenIntereInv	:= 301;					-- Proceso Batch Generacion de Interes Ordinario. Inv Kubo
SET	Pro_VencimInv 		:= 302;					-- Proceso Batch Vencimientos y Pagos de Inversion Kubo
SET	Pro_TraspaExi 		:= 303;					-- Proceso Batch Traspaso Exigible
SET	Pro_CalSaldosInv 	:= 304;					-- Proceso Batch Calculo de Saldos de Inv.Kubo
SET Pro_AplicaGarantia	:= 305;					-- Proceso Batch Aplicacion Automatica de Garantias
SET	Pro_CieReserva		:= 360;

SET Var_FecBitaco = NOW();

CALL DIASFESTIVOSCAL(
    Par_Fecha,      1,                  Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);

SET Fec_Calculo := Par_Fecha;

-- Corremos la Generacion de Moratorio, Paso a Vencido y Generacion de Interes
-- Por Varios Días hasta un dia antes del día habil siguiente
WHILE (Fec_Calculo < Sig_DiaHab) DO
	-- ---------
	-- 1) Procesos de Cartera.
	-- ----------------
	SET Aud_FechaActual := NOW();

	SET Var_FecBitaco = NOW();

	CALL CREPASOVENCIDOPRO(
		Fec_Calculo,		Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion	);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_PasoVenc, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	SET Var_FecBitaco = NOW();

	CALL GENERAINTERECREPRO(
		Fec_Calculo,		Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion	);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_GenIntere, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	SET Var_FecBitaco = NOW();
	
	-- --------------------------
	-- 2) Procesos de Inversiones
	-- --------------------------

	SET	Aud_ProgramaID			:= 'CRWCARTERACIEDIAPRO';	-- Proceso 
	-- insertamos en la bitacora
	IF(Par_Fecha=Fec_Calculo)THEN		
	
	        SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
            CALL BITACORABATCHALT(
                Pro_CieInvKubo, Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,		Aud_Usuario,
                NOW(),			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	END IF;
	
	SET Var_FecBitaco = NOW();
	-- Vencimiento de Fondeos
	CALL CRWFONVENCIMPRO(
		Fec_Calculo,     		 Par_EmpresaID,     		 SalidaNo,        		 Var_NumErr,      		 Var_ErrMen,
		Par_Consecutivo, 		 Aud_Usuario,       		 Aud_FechaActual, 		 Aud_DireccionIP, 		 Aud_ProgramaID,
		Aud_Sucursal,    		 Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_VencimInv, 		Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

	-- Inv. Kubo, Traspaso a Exigible
	SET Var_FecBitaco = NOW();

	CALL CRWFONTRASEXIPRO(
		Fec_Calculo, 		 Par_EmpresaID,   		 SalidaNo,        		 Var_NumErr,     		 Var_ErrMen,
		Aud_Usuario, 		 Aud_FechaActual, 		 Aud_DireccionIP, 		 Aud_ProgramaID, 		 Aud_Sucursal,
		Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_TraspaExi, 		Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	
	
	-- Devengamiento de Interes Inversiones.
	
	SET Var_FecBitaco = NOW();

	CALL CRWGENERAINTEREINVPRO(
		Fec_Calculo, 			 SalidaNo,        			 Var_NumErr,      			 Var_ErrMen,     			 Par_EmpresaID,
		Aud_Usuario, 			 Aud_FechaActual, 			 Aud_DireccionIP, 			 Aud_ProgramaID, 			 Aud_Sucursal,
		Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_GenIntereInv, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


	-- -----------------------
	-- 3) Procesos de Castigos / Garantias
	-- -------------------------
	
	-- Aplicacion de Garantias a Credito.
	SET Var_FecBitaco = NOW();
    IF(Fec_Calculo=Par_Fecha)THEN -- Solo se aplican en dia Habil.	

        CALL CRWINVGARANTIACIEPRO(
            Fec_Calculo, 		SalidaNo, 			Var_NumErr,			Var_ErrMen,		Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
            Aud_NumTransaccion);

        -- Castigo de creditos

        CALL CRECASTIGOCIERREPRO(
            Fec_Calculo, 		SalidaNo, 			Var_NumErr,		Var_ErrMen,		Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
            Aud_NumTransaccion);
    END IF; 

	-- --------------------------------------
	-- 4)  Procesos de Calculo de Historicos
	-- ---------------------------------	

	-- Invesiones Kubo
	SET Var_FecBitaco = NOW();

	CALL CRWINVCALSALDPRO(
		Fec_Calculo, 		 SalidaNo,        		 Var_NumErr,      		 Var_ErrMen,     		 Par_EmpresaID,
		Aud_Usuario, 		 Aud_FechaActual, 		 Aud_DireccionIP, 		 Aud_ProgramaID, 		 Aud_Sucursal,	
		Aud_NumTransaccion);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_CalSaldosInv, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	
	-- Cartera 
	SET Var_FecBitaco = NOW();


	CALL CRECALCULOSALDOSPRO(
		Fec_Calculo,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	
	CALL BITACORABATCHALT(
		Pro_CalSaldos, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
		NOW(),			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
        	
	-- --------------------------------------
	-- 5)  Proceso de Generación de Reservas
	-- ---------------------------------	

    IF(Fec_Calculo=last_day(Par_Fecha))THEN
		
        SET Var_FecBitaco = NOW();
        
		CALL CIERRERESERVAPRO(
			Fec_Calculo,        Valor_SI,           Par_EmpresaID,    Aud_Usuario,		Aud_FechaActual,	
			Aud_DireccionIP,    Aud_ProgramaID,	    Aud_Sucursal,     Aud_NumTransaccion);  
		
        SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		CALL BITACORABATCHALT(
			Pro_CieReserva, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
			NOW(),				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
    END IF;

	--  Actualizamos la fecha para hacer 
	-- el calculo del siguiente dia.
	
	SET Fec_Fin := Fec_Calculo;
	SET	Fec_Calculo	= ADDDATE(Fec_Calculo, 1);
    
END WHILE;

END TerminaStore$$