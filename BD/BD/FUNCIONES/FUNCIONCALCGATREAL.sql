-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCALCGATREAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCALCGATREAL`;DELIMITER $$

CREATE FUNCTION `FUNCIONCALCGATREAL`(
# =========================================================
# ----- FUNCION QUE REALIZA EL CALCULO DEL GAT NOMINAL-----
# =========================================================
	Par_ValorGat		DECIMAL(12,4), 	/* Valor Gat Nominal*/
	Par_Inflacion		DECIMAL(12,4)
) RETURNS decimal(12,4)
    DETERMINISTIC
BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,4);
	DECLARE	Salida_SI		CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_GatReal		DECIMAL(12,4);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0;
	SET	Salida_SI			:= 'S';

	-- Asignacion de Variables
	SET Var_GatReal			:= 0.00;

	SET Var_GatReal := ROUND(((((1 + (Par_ValorGat/100))/(1 + (Par_Inflacion/100)))-1)*100),2);

	RETURN Var_GatReal;
END$$