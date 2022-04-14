-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNOBTENEDOREPUB
DELIMITER ;
DROP FUNCTION IF EXISTS `FNOBTENEDOREPUB`;DELIMITER $$

CREATE FUNCTION `FNOBTENEDOREPUB`(
/*Funcion para buscar el id de los Estados usando su nombre (Esta funcion se usa en la carga de listas)*/
	Par_NombreEstado		VARCHAR(250)		# Nombre del Estado

) RETURNS int(11)
    DETERMINISTIC
BEGIN
	-- Declaracion de constates
	DECLARE Cadena_Vacia		CHAR(1);	# Cadena Vacia
	DECLARE Entero_Cero			INT(11);	# Entero Cero
    DECLARE CiudadDeMexico		INT(11);	# Clave de la entidad Distrito Federal
    DECLARE DescCiudadDeMexico	VARCHAR(20);# Descripcion de la entidad Distrito Federal (ahora Cd. de México)

	-- Declaracion de Variables
	DECLARE Var_EstadoID 		INT(11);	# ID del Estado

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Var_EstadoID			:= Entero_Cero;

    SET CiudadDeMexico			:= 9;
    SET DescCiudadDeMexico		:= 'CIUDAD DE MEXICO';
	SET Par_NombreEstado		:= IFNULL(Par_NombreEstado,Cadena_Vacia);

	IF(Par_NombreEstado = DescCiudadDeMexico) THEN
		SET Var_EstadoID := CiudadDeMexico;
	ELSEIF(Par_NombreEstado != Cadena_Vacia) THEN
		SET Var_EstadoID := (SELECT EstadoID FROM ESTADOSREPUB AS Es WHERE Es.Nombre LIKE(CONCAT('%',Par_NombreEstado,'%')) LIMIT 1);
	END IF;

	SET Var_EstadoID := IFNULL(Var_EstadoID, Entero_Cero);

RETURN Var_EstadoID;
END$$