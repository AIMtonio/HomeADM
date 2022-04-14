-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNISRINFOCAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNISRINFOCAL`;DELIMITER $$

CREATE FUNCTION `FNISRINFOCAL`(
	/* FUNCIÓN QUE CALCULA EL ISR INFORMATIVO (SIN MONTO EXCENTO) */
	Par_Monto					DECIMAL(12,2),	-- Monto de la Inversión o CEDE
	Par_Plazo					INT(11),		-- Número de dias de la Inversión o CEDE
	Par_TasaISR					DECIMAL(8,4)	-- Tasa ISR

) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_FechaSistema	DATE;			-- FECHA DEL SISTEMA
	DECLARE Var_DiasInversion	DECIMAL(12,4);	-- DÍAS DE LA INVERSIÓN
	DECLARE Var_InteresRetener	DECIMAL(12,2);	-- INTERÉS ISR INFORMATIVO
	DECLARE Var_TasaISR			DECIMAL(8,4);	-- TASA ISR

	-- Declaracion de Constantes
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Dos			INT(11);
    DECLARE Entero_Cien			INT(11);

	-- Asignacion de Constantes
	SET Estatus_Activo			:= 'A';			-- ESTATUS ACTIVO
	SET Cadena_Vacia			:= '';			-- CADENA VACIA
	SET Fecha_Vacia				:= '1900-01-01';-- FECHA VACIA
	SET Entero_Cero				:= 0;			-- ENTERO CERO
	SET Entero_Dos				:= 02;			-- ENTERO DOS
    SET Entero_Cien				:= 100;			-- ENTERO CIEN

	SELECT
		DiasInversion,		FechaSistema
	INTO
		Var_DiasInversion,	Var_FechaSistema
	FROM PARAMETROSSIS;

	SET Var_FechaSistema	:= IFNULL(Var_FechaSistema, Fecha_Vacia);
	SET Var_DiasInversion	:= IFNULL(Var_DiasInversion, Entero_Cero);
	SET Var_TasaISR			:= (Par_TasaISR/Entero_Cien);

	SET Var_InteresRetener := ROUND((Par_Monto * Var_TasaISR / Par_Plazo *  Var_DiasInversion) / Entero_Cien, Entero_Dos);
	SET Var_InteresRetener := IFNULL(Var_InteresRetener, Entero_Cero);

RETURN Var_InteresRetener;
END$$