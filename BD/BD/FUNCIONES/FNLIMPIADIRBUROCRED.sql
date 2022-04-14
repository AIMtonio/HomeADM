-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLIMPIADIRBUROCRED
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLIMPIADIRBUROCRED`;DELIMITER $$

CREATE FUNCTION `FNLIMPIADIRBUROCRED`(
/* FUNCION QUE LIMPIA DIRECCIONES
	USADA PARA REPORTES DE BURO DE CREDITO */
	Par_Texto 			VARCHAR(2000) 		-- Texto a limpiar
) RETURNS varchar(2000) CHARSET latin1
    DETERMINISTIC
BEGIN

	/* Declaracion de Variables*/
	DECLARE Var_Longitud		INT(11);		-- Longitud de cadenas
	DECLARE Var_Resultado 		VARCHAR(2000);	-- Texto resultado final
	DECLARE Var_Caracter		VARCHAR(10);	-- Caracter
	DECLARE Var_Posicion		INT(11);		-- Posicion de la cadena
	DECLARE Var_CaracterAnt		CHAR(1);		-- caracter anterior
	DECLARE Var_CaracterPos		CHAR(1);		-- caracter anterior

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Entero_Uno			INT(11);		-- Entero uno

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;


	-- Limpia el texto de direccion
	SET Var_Longitud 	:= LENGTH(Par_Texto);
    SET Var_Resultado 	:= Cadena_Vacia;
    SET Var_Posicion 	:= Entero_Uno;

	WHILE Var_Longitud > Entero_Cero DO
		SET Var_Caracter 	:= substr(Par_Texto,Var_Posicion,Entero_Uno);

		IF(Var_Caracter regexp '^[0-9]')THEN

			SET Var_CaracterAnt := substr(Par_Texto,Var_Posicion - Entero_Uno ,Entero_Uno);
			SET Var_CaracterPos := substr(Par_Texto,Var_Posicion + Entero_Uno ,Entero_Uno);

            IF(Var_CaracterAnt <> ' ' AND Var_CaracterAnt NOT  regexp '^[0-9]' )THEN

				SET Var_Resultado:= CONCAT(Var_Resultado,' ');
			ELSE
				 IF(Var_CaracterPos <> ' ' AND Var_CaracterPos NOT  regexp '^[0-9]')THEN

					SET Var_Caracter:= CONCAT(Var_Caracter,' ');
                 END if;
			END IF;
        END IF;
		SET Var_Resultado := CONCAT(Var_Resultado,Var_Caracter);
		SET Var_Longitud 	:= Var_Longitud - Entero_Uno;
        SET Var_Posicion 	:= Var_Posicion + Entero_Uno;

	END WHILE;

SET Var_Resultado 	:= TRIM(UPPER(Var_Resultado));

RETURN Var_Resultado;

END$$