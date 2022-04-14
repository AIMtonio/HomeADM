-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDESCDISPERSION
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDESCDISPERSION`;
DELIMITER $$

CREATE FUNCTION `FNDESCDISPERSION`(
	/*Funcion para Obtener la Descripcion a partir del tipo de  Dispersion*/
	Par_TipoDispersion   CHAR(1)	-- Tipo de Dispersion
) RETURNS VARCHAR(20)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_DescDispersion	VARCHAR(20);	-- Descripcion

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Entero Cero

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;

	SET Var_DescDispersion := ( CASE Par_TipoDispersion
									WHEN "S"  THEN "SPEI"
									WHEN "C"  THEN "CHEQUE"
									WHEN "O"  THEN "ORD.PAGO"
									WHEN "E"  THEN "EFECTIVO"
									WHEN "A"  THEN "TRAN. SANTANDER"
									ELSE Cadena_Vacia
								END);

	RETURN Var_DescDispersion;

END$$