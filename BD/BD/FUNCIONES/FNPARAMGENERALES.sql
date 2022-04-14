-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNPARAMGENERALES
DELIMITER ;
DROP FUNCTION IF EXISTS `FNPARAMGENERALES`;DELIMITER $$

CREATE FUNCTION `FNPARAMGENERALES`(
# FUNCIÓN PARA OBTENER EL VALOR DE UN PARÁMETRO GENERAL.
	Par_LlaveParametro	VARCHAR(50)		-- Nombre del parámetro a consultar.

) RETURNS varchar(200) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_ValorParametro	VARCHAR(200);

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);

	-- ASIGNACIÓN DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Str_SI					:= 'S';				-- Constante Si
	SET Str_NO					:= 'N'; 			-- Constante No

	SET Var_ValorParametro := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Par_LlaveParametro LIMIT 1);
	RETURN IFNULL(Var_ValorParametro, Cadena_Vacia);
END$$