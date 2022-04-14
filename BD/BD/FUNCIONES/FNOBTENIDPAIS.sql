-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNOBTENIDPAIS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNOBTENIDPAIS`;DELIMITER $$

CREATE FUNCTION `FNOBTENIDPAIS`(
/*Funcion para buscar el id de los paises usando su nombre (Esta funcion se usa en la carga de listas)*/
	Par_NombrePais		VARCHAR(250)		# Nombre del Pais

) RETURNS int(11)
    DETERMINISTIC
BEGIN
	-- Declaracion de constates
	DECLARE Cadena_Vacia		CHAR(1);	# Cadena Vacia
	DECLARE Entero_Cero			INT(11);	# Entero Cero
    DECLARE PaisExtranjero		INT(11);	# Pais Extranjero
	-- Declaracion de Variables
	DECLARE Var_PaisID INT(11);				# ID del Pais

	-- Asignacion de constantes
	SET Cadena_Vacia	:= '';
	SET Entero_Cero		:= 0;
    SET PaisExtranjero	:= 600;

	SET Par_NombrePais	:= IFNULL(Par_NombrePais,Cadena_Vacia);

	IF(Par_NombrePais != Cadena_Vacia) THEN
		SET Var_PaisID := (SELECT PaisID FROM PAISES AS Pa WHERE Pa.Nombre LIKE(CONCAT('%',Par_NombrePais,'%')) LIMIT 1);
	END IF;

	SET Var_PaisID := IFNULL(Var_PaisID, PaisExtranjero);

RETURN Var_PaisID;
END$$