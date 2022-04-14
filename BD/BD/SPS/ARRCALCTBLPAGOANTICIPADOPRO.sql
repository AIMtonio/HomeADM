-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCALCTBLPAGOANTICIPADOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRCALCTBLPAGOANTICIPADOPRO`;DELIMITER $$

CREATE PROCEDURE `ARRCALCTBLPAGOANTICIPADOPRO`(
	-- STORED PROCEDURE MARCAR LA PRIMERA CUOTA COMO PAGADA Y ADELANTAR LAS FECHAS DE LAS SIGUIENTES CUOTAS
	Par_Salida				CHAR(1),				-- Salida Si o No
	INOUT Par_NumErr		INT(11),				-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);		-- Variable de control
	DECLARE Var_AmortiMin		INT(11);			-- Primera cuota del arrendamiento
	DECLARE Var_AmortiMax		INT(11);			-- Ultima cuota del arrendamiento
	DECLARE Var_Amorti			INT(11);			-- Contador para while
	DECLARE Var_AmortiAnt		INT(11);			-- Contador para while con la cuota previa
	DECLARE Var_FechaFinal		DATE;				-- Variable para valor fecha final
	DECLARE Var_FechaInicio		DATE;				-- Variable para valor fecha de inicio
	DECLARE Var_FechaExi		DATE;				-- Variable para valor fecha exigible
	DECLARE Var_Renta			DECIMAL(14,2);		-- Valor de la renta
	DECLARE Var_IVARenta		DECIMAL(14,2);		-- Valor del IVA de la renta
	DECLARE Var_PagoTotal		DECIMAL(14,2);		-- Valor del pago total de la cuota

	-- Declaracion de constantes
	DECLARE Entero_Uno			INT(11);			-- Entero uno
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Var_SI				CHAR(1);			-- SI
	DECLARE Var_No				CHAR(1);			-- NO
	DECLARE Est_Pagado			CHAR(1);			-- Estatus Pagado

	-- Asignacion de constantes
	SET Entero_Uno				:= 1;				-- Entero uno
	SET Decimal_Cero			:= 0.00;			-- DECIMAL CERO
	SET Var_SI					:= 'S';				-- Variable para valor SI
	SET Var_No					:= 'N';				-- Variable para valor NO
	SET Est_Pagado				:= 'P';				-- Estatus pagado

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRCALCTBLPAGOANTICIPADOPRO');
			SET Var_Control = 'sqlException';
		END;

		SELECT	MIN(Tmp_Consecutivo)
			INTO Var_AmortiMin
			FROM TMPARRENDAPAGOSIM
			WHERE	NumTransaccion = Aud_NumTransaccion;

		SELECT	MAX(Tmp_Consecutivo)
			INTO Var_AmortiMax
			FROM TMPARRENDAPAGOSIM
			WHERE	NumTransaccion = Aud_NumTransaccion;

		SET Var_Amorti := Var_AmortiMax;

		-- Se cambian las fechas de la cuota iterada por las de la cuota anterior
		IteraCuotas: WHILE (Var_Amorti >= Var_AmortiMin) DO
			/* Si la cuota iterada es la primera, se establecen las fechas de fin y exigible con la misma fecha de inicio
			y se actualiza el estatus a pagado */
			IF Var_Amorti = Var_AmortiMin THEN
				SELECT		Tmp_FecIni,			Tmp_Renta,	Tmp_Iva
					INTO	Var_FechaInicio,	Var_Renta,	Var_IVARenta
					FROM TMPARRENDAPAGOSIM
					WHERE	NumTransaccion = Aud_NumTransaccion
					  AND	Tmp_Consecutivo = Var_Amorti;

				SET Var_PagoTotal := Var_Renta + Var_IVARenta;

				UPDATE TMPARRENDAPAGOSIM SET
					Tmp_FecIni		= Var_FechaInicio,
					Tmp_FecFin		= Var_FechaInicio,
					Tmp_FecExi		= Var_FechaInicio,
					Tmp_Estatus		= Est_Pagado
					WHERE	NumTransaccion  = Aud_NumTransaccion
					  AND	Tmp_Consecutivo = Var_Amorti;

				SET Var_Amorti := Var_Amorti - 1;

				ITERATE IteraCuotas;
			END IF;

			SET Var_AmortiAnt = Var_Amorti - 1;

			SELECT		Tmp_FecIni,			Tmp_FecFin,		Tmp_FecExi
				INTO	Var_FechaInicio,	Var_FechaFinal,	Var_FechaExi
				FROM TMPARRENDAPAGOSIM
				WHERE	NumTransaccion = Aud_NumTransaccion
				AND	Tmp_Consecutivo = Var_AmortiAnt;

			UPDATE TMPARRENDAPAGOSIM SET
				Tmp_FecIni = Var_FechaInicio,
				Tmp_FecFin = Var_FechaFinal,
				Tmp_FecExi = Var_FechaExi
				WHERE	NumTransaccion  = Aud_NumTransaccion
				  AND	Tmp_Consecutivo = Var_Amorti;

			SET Var_Amorti := Var_Amorti - 1;
		END WHILE IteraCuotas;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONVERT(Var_PagoTotal,CHAR(20));
		SET Var_Control	:= 'Tmp_Consecutivo';

	END ManejoErrores;

	-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Var_AmortiMin AS consecutivo;
	END IF;
END TerminaStore$$