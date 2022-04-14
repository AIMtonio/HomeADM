-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONTCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONTCIEDIAPRO`;DELIMITER $$

CREATE PROCEDURE `CRECONTCIEDIAPRO`(
# =================================================================
# -- SP para el Proceso de Cierre de Creditos Contingentes-
# =================================================================
	Par_Fecha			DATE,

	Par_Salida          CHAR(1),
  	INOUT Par_NumErr    INT(11),
  	INOUT Par_ErrMen    VARCHAR(400),

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
	DECLARE	Sig_DiaHab			DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE	Fec_Calculo			DATE;
	DECLARE Var_CanAutSolCre 	CHAR(1);
	DECLARE Var_FecSiguie   	DATE;
	DECLARE Var_FecOper 		DATE;
	DECLARE Var_FecActual   	DATETIME;
	DECLARE Var_Empresa     	INT;
	DECLARE Fec_Fin				DATE;
	DECLARE Var_FechaSig    	DATE;
	DECLARE Var_TipoInstitID 	INT(11);		-- Valor del Tipo de Institucion
    DECLARE Var_CobComApertMens	CHAR(1);		-- Contabilizar comision por apertura de forma mensual

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Entero_Uno		INT(11);
	DECLARE	Pro_CieCreCont	INT(11);
	DECLARE	Pro_GenIntere 	INT(11);
	DECLARE	Pro_IntMora 	INT(11);
	DECLARE	Pro_PasoVenc 	INT(11);
	DECLARE	Pro_CalSaldos	INT(11);
	DECLARE CancelaAutoSI	CHAR(1);
	DECLARE Pro_CancelSol	INT(11);
	DECLARE Un_DiaHabil     INT(11);
	DECLARE Es_DiaHabil     CHAR(1);
	DECLARE AplicaContaSI   CHAR;
	DECLARE Cero_DiaHabil   INT(11);
	DECLARE SiEs_DiaHabil   CHAR(1);
	DECLARE TipoInstSOFIPO  INT(11);            -- Tipo de Institucion: SOFIPO
	DECLARE Pro_GenSegCuota INT(11);
	DECLARE Pro_GenComAnual INT(11);
    DECLARE SalidaNO		CHAR(1);
    DECLARE Pro_ComAp		INT(11);
    DECLARE Cons_SI			CHAR(1);
	DECLARE Cons_NO			CHAR(1);
	DECLARE Salida_SI		CHAR(1);
	DECLARE CobComApertMens	VARCHAR(15);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Entero_Uno		:= 1;
	SET	Pro_CieCreCont 	:= 1400;
	SET	Pro_GenIntere 	:= 1401;
	SET	Pro_IntMora 	:= 1402;
	SET	Pro_CalSaldos	:= 1403;
	SET Pro_GenComAnual := 1404;			--  Proceso Batch para generar la Comision por Anualidad
	SET Pro_ComAp		:= 1405;			-- Proceso Batch para generar la Comision por Apertura de Credito
	SET CancelaAutoSI	:= 'S';      		-- Cancelacion Automatica Solicitudes de Creditos: SI
	SET	Var_FecBitaco	:= NOW();
	SET Un_DiaHabil    	:= 1;
	SET AplicaContaSI   :='S';
	SET Salida_SI		:= 'S';
	SET Cero_DiaHabil   := 0;
	SET SiEs_DiaHabil   := 'S';
	SET TipoInstSOFIPO  := 3;					-- Tipo de Institucion: SOFIPO
	SET SalidaNO		:= 'N';
    SET Cons_SI			:= 'S';					-- Constante S: SI
    SET Cons_NO			:= 'N';					-- COnstante N: NO
    SET CobComApertMens	:= 'CobComApertMens';	-- Cobro de la comision por apertura mensual
	SET	Aud_ProgramaID	:= 'CRECONTCIEDIAPRO';


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONTCIEDIAPRO');
        END;

	-- Se obtiene el valor del Tipo de Institucion
	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM INSTITUCIONES Ins,PARAMETROSSIS Par WHERE Par.InstitucionID = Ins.InstitucionID);
	SET Var_TipoInstitID := IFNULL(Var_TipoInstitID,Entero_Cero);

	SELECT FechaSistema, EmpresaDefault	 INTO Var_FecActual,	Var_Empresa
		FROM PARAMETROSSIS;
	SET Var_FecOper	:= Var_FecActual;

    SELECT	ValorParametro
		  INTO 	Var_CobComApertMens
			FROM PARAMGENERALES
			WHERE	LlaveParametro = CobComApertMens;

	SELECT Fecha INTO Var_FechaBatch
		FROM BITACORABATCH
		WHERE Fecha 			= Par_Fecha
		  AND ProcesoBatchID	= Pro_CieCreCont;

	SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);

	IF Var_FechaBatch != Fecha_Vacia THEN
		LEAVE TerminaStore;
	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

	CALL BITACORABATCHALT(
		Pro_CieCreCont, 	Par_Fecha, 			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET Var_FecBitaco := NOW();

	CALL DIASFESTIVOSCAL(
		Par_Fecha,      Un_DiaHabil,        Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	SET Fec_Calculo := Par_Fecha;

	-- Corremos la Generacion de Moratorio, Paso a Vencido y Generacion de Interes
	-- Por Varios Dias hasta un dia antes del dia habil siguiente

	WHILE (Fec_Calculo < Sig_DiaHab) DO

		SET Aud_FechaActual := NOW();

		-- Generacion de Interes Moratorio, Comisiones por Falta de Pago y Traspaso a Cartera en Atraso
		CALL GENERAINTERMORACONTPRO(
			Fec_Calculo,		Par_EmpresaID,		SalidaNO,			Par_NumErr,         Par_ErrMen,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
		    LEAVE ManejoErrores;
		END IF;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_IntMora, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();

		-- Generacion de Interes Ordinario
		CALL GENERAINTERECRECONTPRO(
			Fec_Calculo,		Par_EmpresaID,		SalidaNO,			Par_NumErr,         Par_ErrMen,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
		    LEAVE ManejoErrores;
		END IF;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_GenIntere, 		Fec_Calculo, 		Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();

		CALL CRECALCULOSALDOSCONTPRO(
			Fec_Calculo,		Par_EmpresaID,		SalidaNO,			Par_NumErr,         Par_ErrMen,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
		    LEAVE ManejoErrores;
		END IF;

		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Pro_CalSaldos, 		Fec_Calculo, 			Var_MinutosBit,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET Var_FecBitaco := NOW();

		-- Generacion de Comision por Anualidad de Crédito

		SET Fec_Fin := Fec_Calculo;
		SET	Fec_Calculo	:= ADDDATE(Fec_Calculo, Entero_Uno);

	END WHILE;

	SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'Cierre de Creditos Contingentes Realizado Exitosamente.';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen;
END IF;

END TerminaStore$$