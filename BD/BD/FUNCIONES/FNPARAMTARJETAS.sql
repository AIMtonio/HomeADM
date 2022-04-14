-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNPARAMTARJETAS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNPARAMTARJETAS`;

DELIMITER $$
CREATE FUNCTION `FNPARAMTARJETAS`(
	-- Funcion para obtener el Valor de un Parametro de Tajetas
	Par_LlaveParametro	VARCHAR(50)		-- Nombre del parámetro a consultar.

) RETURNS VARCHAR(200) CHARSET latin1
DETERMINISTIC
BEGIN
	-- Declaracion de Variables
	DECLARE Var_ValorParametro	VARCHAR(200);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Entero Cero

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;

	SET Var_ValorParametro := (SELECT ValorParametro FROM PARAMTARJETAS WHERE LlaveParametro = Par_LlaveParametro LIMIT 1);
	RETURN IFNULL(Var_ValorParametro, Cadena_Vacia);
END$$