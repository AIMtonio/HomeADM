-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSMSEXTRAERJSONVALOR
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSMSEXTRAERJSONVALOR`;
DELIMITER $$

CREATE FUNCTION `FNSMSEXTRAERJSONVALOR`(
# =====================================================================================
#	FUNCION PARA EXTRAER LOS VALORES DE UN ARREGLO CON EL FORMATO JSON
# =====================================================================================
	Par_Identifica		VARCHAR(100),
	Par_JSON			VARCHAR(400)

) RETURNS VARCHAR(400)
DETERMINISTIC
BEGIN


	-- Declaracion de Variables
	DECLARE Var_Valor				VARCHAR(400);

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);


	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;

	IF LOCATE(Par_Identifica,Par_JSON) > 0 THEN

		SET Var_Valor := TRIM(REPLACE(SUBSTRING_INDEX(SUBSTRING(Par_JSON,LOCATE(Par_Identifica,Par_JSON)
								+ LENGTH(Par_Identifica)
								+ 2), ',', 1), '"', Cadena_Vacia));
	END IF;

    SET Var_Valor = IFNULL(Var_Valor, Cadena_Vacia);

    RETURN Var_Valor;
END$$