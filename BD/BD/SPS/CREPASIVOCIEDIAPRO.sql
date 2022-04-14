-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASIVOCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASIVOCIEDIAPRO`;
DELIMITER $$

CREATE PROCEDURE `CREPASIVOCIEDIAPRO`(
	/* Sp que hace el cierre diario de creditos pasivos*/
	Par_Fecha			date,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN
	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Fecha_Vacia		date;
	DECLARE	Entero_Cero		int;
	DECLARE	Pro_CieCartera	int;
	DECLARE	Pro_GenIntere 	int;
	DECLARE	Pro_PasoMora 	int;
	DECLARE	Pro_PasoVenc 	int;
	DECLARE	Pro_CalSaldos	int;
	DECLARE	Pro_CapIntere	int;
	DECLARE Pro_CapFlucCam 	INT(11);
	DECLARE Par_NumErr		int;
	DECLARE Par_ErrMen		varchar(400);

	/* DECLARACION DE VARIABLES*/
	DECLARE	Var_FechaBatch	date;
	DECLARE	Var_FecBitaco 	datetime;
	DECLARE	Var_MinutosBit 	int;
	DECLARE Var_Control		varchar(100);
	DECLARE	Sig_DiaHab		DATE;
	DECLARE Var_EsHabil		CHAR(1);
	DECLARE	Fec_Calculo		DATE;
	DECLARE Fec_Fin			DATE;
	DECLARE Var_UltimoDiaMes		DATE;




	/* ASIGNACION DE CONSTANTES*/
	Set Cadena_Vacia    	:= '';
	Set Fecha_Vacia     	:= '1900-01-01';
	Set Entero_Cero     	:= 0;
	Set Pro_CieCartera  	:= 300;         /* Cierre Diario Credito Pasivo - Corresponde con la tabla PROCESOSBATCH*/
	Set Pro_GenIntere   	:= 301;
	Set Pro_PasoMora    	:= 302;
	Set Pro_CalSaldos   	:= 305;         /* Proceso de Calculo de Saldos Diarios de Cartera Pasiva */
	Set Pro_CapIntere   	:= 306;         /* Proceso de Capitalizacion de Interes */
	Set Pro_CapFlucCam   	:= 307;         /* Proceso de Fluctuacion cambiaria de moneda */

	Set Aud_ProgramaID  	:= 'CREPASIVOCIEDIAPRO';

	/* ASIGNACION DE VARIABLES*/
	Set	Var_FecBitaco	:= now();
	Select Fecha into Var_FechaBatch
		from BITACORABATCH
		where Fecha 		= Par_Fecha
		and ProcesoBatchID	= Pro_CieCartera;

	Set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);

	if Var_FechaBatch != Fecha_Vacia then
		LEAVE TerminaStore;
	end if;

	Set Aud_FechaActual:=now();
	Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

	call BITACORABATCHALT(
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



	WHILE (Fec_Calculo < Sig_DiaHab) DO

			SET Aud_FechaActual := NOW();
		-- -----------------------------------------------------
		-- Proceso que Realiza la Capitalizacion de Interes ----
		-- -----------------------------------------------------
		Set Var_FecBitaco = now();
		call CREPASCAPITAINTPRO(
			Fec_Calculo,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

		Set Aud_FechaActual:=now();
		Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());

		call BITACORABATCHALT(
			Pro_CapIntere, 		Fec_Calculo, 			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		-- ---------------------------------------
		Set Var_FecBitaco = now();
		call GENINTMORCREPASPRO(/* Generacion de Interes Moratorio y comision por falta de pago  */
			Fec_Calculo,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);


		Set Aud_FechaActual :=now();
		Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
		call BITACORABATCHALT(
			Pro_PasoMora, 		Fec_Calculo, 			Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		Set Var_FecBitaco = now();
		call GENINTPROCREPASPRO( # Generacion de Interes Provisionado
			Fec_Calculo,			Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		Set Aud_FechaActual:=now();
		Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
		call BITACORABATCHALT(
			Pro_GenIntere, 	Fec_Calculo, 		Var_MinutosBit,	Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		Set Var_FecBitaco = now();
		-- Calculos de Saldos de Cartera Pasiva
		call CREPASCALSALDOSPRO(
			Fec_Calculo,      Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion	);
		Set Aud_FechaActual:=now();
		Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
		call BITACORABATCHALT(
			Pro_CalSaldos,      Fec_Calculo,          Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

		-- Fluctuacion por cambio de tipo de moneda
		Set Var_FecBitaco = now();
		CALL CREPASFLUCCAMBIOPRO(	Fec_Calculo,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

		Set Aud_FechaActual:=now();
		Set Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, now());
		call BITACORABATCHALT(
			Pro_CapFlucCam,      Fec_Calculo,          Var_MinutosBit, Par_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        SET Fec_Fin := Fec_Calculo;
		SET	Fec_Calculo	:= ADDDATE(Fec_Calculo, 1);

	END WHILE;

END TerminaStore$$