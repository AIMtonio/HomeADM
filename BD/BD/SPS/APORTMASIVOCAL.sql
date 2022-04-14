-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMASIVOCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMASIVOCAL`;DELIMITER $$

CREATE PROCEDURE `APORTMASIVOCAL`(
# =========================================================================
# -------- SP QUE REALIZA EL CALCULO DE LA NUEVA FECHA DE VECIMIENTO-------
# =========================================================================
	Par_Fecha           DATE,				-- Fecha de Operacion
	INOUT Par_NumErr    INT(11),			-- Numero de error
	INOUT Par_ErrMen    VARCHAR(400),		-- Descripcion error
	Par_Salida          CHAR(1),			-- Salida en Pantalla
	Par_EmpresaID       INT(11),

	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),

	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore : BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero                 INT(11);
	DECLARE Fecha_Vacia                 DATE;
	DECLARE SalidaSI                    CHAR(1);
	DECLARE Var_ProcesoAport             INT(11);
	DECLARE Var_SabDom                  CHAR(2);
	DECLARE Entero_Uno           		INT(11);
	DECLARE Var_PrograVencMasivo        VARCHAR(100);   /*Programa vencimiento masivo de aportaciones */
    DECLARE Cons_SI						CHAR(1);		-- Constante si
    DECLARE Cons_PagProgra				CHAR(1);		-- Tipo pago programado

	-- Declaracion de Variables
	DECLARE Var_FechaPosibleVencim      DATE;
	DECLARE Var_FechaPosiblePago        DATE;
	DECLARE Var_FechaHabilSig           DATE;
	DECLARE Var_EsHabil                 CHAR(1);
	DECLARE Var_DiaInhabil              CHAR(2);
	DECLARE	Var_FechaBatch				DATE;
	DECLARE Var_FecBitaco               DATETIME;
	DECLARE Var_MinutosBit              INT(11);
    DECLARE Var_CapitalizaInt			CHAR(1);			-- Almacena si la aportacion capitaliza interes
    DECLARE Var_TipoPagoInt				CHAR(1);			-- Tipo de pago de interes

	DECLARE CurFechaVencimiento CURSOR FOR
		SELECT MAX(FechaVencimiento),  MAX(DiaInhabil), MAX(FechaPago),	MAX(PagoIntCapitaliza), MAX(TipoPagoInteres)
			FROM TMPAPORTACIONES
			GROUP BY FechaVencimiento;

	-- Asignacion de Constantes
	SET Entero_Cero         :=  0;					-- Constante Entero Cero
	SET Fecha_Vacia         := '1900-01-01';		-- Constante Fecha Vacia
	SET SalidaSI            := 'S';					-- Constante Salida SI
	SET Var_ProcesoAport    :=  1511;				-- ID Proceso Batch 'CIERRE DIARIO APORTACIONES'
	SET Var_SabDom          := 'SD';				-- Dia Inhabil: Sabado y Domingo
	SET Entero_Uno          :=  1;                  -- Valor Entero Uno
	/*Programa vencimiento masivo de aportaciones */
	SET Var_PrograVencMasivo :='/microfin/vencMasivoAportVista.htm';
    SET Cons_SI				:=	'S';
    SET Cons_PagProgra		:= 'E';

	ManejoErrores : BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  :=   999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									  'esto le ocasiona. Ref: SP-APORTMASIVOCAL');
		END;

		SET Var_FecBitaco   := NOW();
		SET Aud_FechaActual := NOW();

		 -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			Var_ProcesoAport,		Par_Fecha,			Var_FechaBatch,		Entero_Uno,			Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = Var_PrograVencMasivo) THEN

			UPDATE TMPAPORTACIONES SET
				FechaVencimiento    = (DATE_ADD(FechaInicio, INTERVAL PlazoOriginal DAY));

			UPDATE TMPAPORTACIONES SET
				FechaPago           = (DATE_ADD(FechaInicio, INTERVAL PlazoOriginal DAY));

			OPEN CurFechaVencimiento;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CicloCurFechaVencimiento:LOOP
					FETCH   CurFechaVencimiento
						INTO    Var_FechaPosibleVencim, Var_DiaInhabil, Var_FechaPosiblePago,Var_CapitalizaInt,Var_TipoPagoInt;

                        /*SI LA APORTACION NO CAPITALIZA INTERES  Y EL TIPO DE PAGO DE INTERES ES
                        DIFERENTE DE PROGRAMADO SE REALIZA LA ACTUALIZACION DE LA FECHA DE VENCIMIENTO.
                        EN CASO QUE LA APORTACION SI CAPITALICE INTERES, LA FECHA DE VENCIMIENTO ES EL DIA
                        INDICADO, NO IMPORTANDO SI ES DI HABIL O NO.*/
						IF(Var_CapitalizaInt <> Cons_SI AND Var_TipoPagoInt <> Cons_PagProgra)THEN
							SET Var_FechaHabilSig   :=  Fecha_Vacia;

							IF(Var_DiaInhabil = Var_SabDom) THEN
								CALL DIASFESTIVOSABDOMCAL(
									Var_FechaPosibleVencim, Entero_Cero,        Var_FechaHabilSig,  Var_EsHabil,    Par_EmpresaID,
									Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
									Aud_NumTransaccion);
							ELSE
								CALL DIASFESTIVOSCAL(
									Var_FechaPosibleVencim, Entero_Cero,        Var_FechaHabilSig,  Var_EsHabil,    Par_EmpresaID,
									Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
									Aud_NumTransaccion);
							END IF;

							UPDATE TMPAPORTACIONES SET
								FechaVencimiento = Var_FechaHabilSig
							WHERE FechaVencimiento = Var_FechaPosibleVencim;

							UPDATE TMPAPORTACIONES SET
								FechaPago = Var_FechaHabilSig
							WHERE FechaPago = Var_FechaPosiblePago;
						END IF; -- Fin si no capitaliza interes

					END LOOP CicloCurFechaVencimiento;
				END;

			CLOSE CurFechaVencimiento;

			UPDATE TMPAPORTACIONES SET
				NuevoPlazo = (DATEDIFF(FechaVencimiento, FechaInicio));

			IF(Par_NumErr = Entero_Cero) THEN
				SET Par_NumErr      :=  Entero_Cero;
				SET Par_ErrMen      :=  'Calculo de Fecha Vencimiento Realizado Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			 /*Programa vencimiento masivo de aportaciones */
			IF(Aud_ProgramaID!=Var_PrograVencMasivo)THEN
				CALL BITACORABATCHALT(
					Var_ProcesoAport,    Par_Fecha,          Var_MinutosBit,     Par_EmpresaID,      Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    	Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco   := NOW();

		END IF;

		SET Par_NumErr      :=  Entero_Cero;
		SET Par_ErrMen      :=  'Calculo de Fecha Vencimiento Realizado Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  AS  NumErr,
				Par_ErrMen  AS  ErrMen,
				Entero_Cero AS  Consecutivo,
				Entero_Cero AS  VarControl;
	END IF;

END TerminaStore$$