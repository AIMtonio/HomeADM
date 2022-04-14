-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTIPOPERIODOAPORT
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTIPOPERIODOAPORT`;DELIMITER $$

CREATE FUNCTION `FNTIPOPERIODOAPORT`(
# FUNCIÓN PARA OBTENER EL TIPO DE PERIODO PARA CÁLCULO DE INTERÉS E ISR.
	Par_FechaInicio		DATE,		-- Fecha de inicio del periodo.
	Par_FechaVencim		DATE		-- Fecha de vencimiento del periodo.

) RETURNS char(1) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_TipoPeriodo		CHAR(1);

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE PeriodoRegul		CHAR(1);
	DECLARE PeriodoIrreg		CHAR(1);

	-- ASIGNACIÓN DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Str_SI					:= 'S';				-- Constante Si
	SET Str_NO					:= 'N'; 			-- Constante No
	SET PeriodoRegul			:= 'R'; 			-- Periodo Regular
	SET PeriodoIrreg			:= 'I'; 			-- Periodo Irregular

	/** SI EL DÍA DE LA FECHA DE INICIO ES IGUAL A LA FECHA DE VENCIMIENTO, ENTONCES
	 ** SE TRATA DE UN PERIODO REGULAR, SINO ES UN PERIODO IRREGULAR.
	 */
	SET Var_TipoPeriodo := IF(DAY(Par_FechaInicio)=DAY(Par_FechaVencim),PeriodoRegul,PeriodoIrreg);
	RETURN IFNULL(Var_TipoPeriodo, Cadena_Vacia);
END$$