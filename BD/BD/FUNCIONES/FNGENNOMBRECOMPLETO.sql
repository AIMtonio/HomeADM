-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGENNOMBRECOMPLETO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENNOMBRECOMPLETO`;DELIMITER $$

CREATE FUNCTION `FNGENNOMBRECOMPLETO`(
/*Funcion que genera el nombre completo*/
	Par_PrimerNombre			VARCHAR(50),		# Primer nombre de la persona
	Par_SegundoNombre			VARCHAR(50),		# Segundo nombre de la persona
	Par_TercerNombre			VARCHAR(50),		# Tercer nombre de la persona
	Par_ApellidoPaterno			VARCHAR(50),		# Apellido paterno de la persona
	Par_ApellidoMaterno			VARCHAR(50)			# Apellido materno de la persona


) RETURNS varchar(200) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			# Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);			# Cadena Vacia
	DECLARE Espacio					VARCHAR(1);			# Cadena Vacia

	-- Declaracion de variables
	DECLARE Var_NomCompleto			VARCHAR(200);		# Nombre completo

	-- Asignacion de constates
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Espacio						:= ' ';

	SET Par_PrimerNombre			:= TRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia));
	SET Par_SegundoNombre			:= TRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia));
	SET Par_TercerNombre			:= TRIM(IFNULL(Par_TercerNombre, Cadena_Vacia));
	SET Par_ApellidoPaterno			:= TRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia));
	SET Par_ApellidoMaterno			:= TRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia));

	SET Var_NomCompleto := Par_PrimerNombre;
	SET Var_NomCompleto := CONCAT(Var_NomCompleto,IF(CHAR_LENGTH(Par_SegundoNombre)>Entero_Cero,CONCAT(Espacio,Par_SegundoNombre),Cadena_Vacia));
	SET Var_NomCompleto := CONCAT(Var_NomCompleto,IF(CHAR_LENGTH(Par_TercerNombre)>Entero_Cero,CONCAT(Espacio,Par_TercerNombre),Cadena_Vacia));
	SET Var_NomCompleto := CONCAT(Var_NomCompleto,IF(CHAR_LENGTH(Par_ApellidoPaterno)>Entero_Cero,CONCAT(Espacio,Par_ApellidoPaterno),Cadena_Vacia));
	SET Var_NomCompleto := CONCAT(Var_NomCompleto,IF(CHAR_LENGTH(Par_ApellidoMaterno)>Entero_Cero,CONCAT(Espacio,Par_ApellidoMaterno),Cadena_Vacia));
	SET Var_NomCompleto := UPPER(IFNULL(Var_NomCompleto,Cadena_Vacia));
    SET Var_NomCompleto := TRIM(Var_NomCompleto);

	RETURN Var_NomCompleto;
END$$