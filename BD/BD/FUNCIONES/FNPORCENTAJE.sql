-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNPORCENTAJE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNPORCENTAJE`;DELIMITER $$

CREATE FUNCTION `FNPORCENTAJE`(
	Par_CantidadTotal		DECIMAL(16,2),		# Cantidad que representa el 100%
	Par_CantidadParcial		DECIMAL(16,2),		# Cantidad parcial de la cual se requiere a que porcentaje equivale del 100%
	Par_TipoResultado		TINYINT				# Indica el tipo de resultado 0/1.- Entero 2.- Decimal. 3- Porcentaje Excendente (diff)

) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN
	# Declaracion de Variables
	DECLARE Var_Porcentaje			DECIMAL(16,2);

	# Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Decimal_Cien			DECIMAL(12,4);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE PorcentajeEntero		INT(11);
	DECLARE PorcentajeDecimal		INT(11);
	DECLARE PorcentajeDiff			INT(11);

	# Asignacion de Constantes
	SET Entero_Cero				:= 0;			-- Entero Cero
	SET Decimal_Cero			:= 0.0;			-- Decimal cero
	SET Decimal_Cien			:= 100.0;		-- Decimal cien
	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
	SET Cons_No					:= 'N';			-- Constantes No
	SET Cons_SI					:= 'S';			-- Constantes Si
	SET PorcentajeEntero		:= 01;			-- Regresa el resultado como un entero, ejemplo 25.00
	SET PorcentajeDecimal		:= 02;			-- Regresa el resultado como un entero, ejemplo 0.25
	SET PorcentajeDiff			:= 03;			-- Regresa el resultado como diferencia
	IF(Par_TipoResultado IN(1,2)) THEN
		SET Var_Porcentaje := IF(IFNULL(Par_CantidadTotal,Entero_Cero)>Entero_Cero, ROUND((Par_CantidadParcial * Decimal_Cien) / Par_CantidadTotal, 2), Entero_Cero);
		SET Var_Porcentaje := IF(Par_TipoResultado = PorcentajeDecimal, (Var_Porcentaje / Decimal_Cien),Var_Porcentaje);
	END IF;
	IF(Par_TipoResultado = PorcentajeDiff) THEN
		SET Par_CantidadParcial := IFNULL(Par_CantidadParcial,Entero_Cero);
		SET Par_CantidadTotal := IFNULL(Par_CantidadTotal,Entero_Cero);
		IF(Par_CantidadTotal!=Entero_Cero) THEN
			SET Var_Porcentaje := ROUND((Par_CantidadParcial / Par_CantidadTotal)*100, 2);
		  ELSE
		  	SET Var_Porcentaje := 100;
		END IF;
	END IF;
	RETURN IFNULL(Var_Porcentaje, Decimal_Cero);
END$$