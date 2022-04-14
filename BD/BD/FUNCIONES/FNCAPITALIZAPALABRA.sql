-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCAPITALIZAPALABRA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCAPITALIZAPALABRA`;DELIMITER $$

CREATE FUNCTION `FNCAPITALIZAPALABRA`(
# Funcion que convierte la primera letra de una palabra en Mayuscula

	Var_Palabras VARCHAR(255)

) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Posicion 	INT;
	DECLARE Var_Ciclo 		INT;
	DECLARE Var_NumItera	INT;
	DECLARE Var_Segmento 	VARCHAR(255);
	DECLARE Var_Cadena 		VARCHAR(255);

	-- Inicializaciones
	SET Var_Palabras = LOWER(Var_Palabras);
	SET Var_Ciclo = 0;
	SET Var_NumItera = LENGTH(Var_Palabras) - LENGTH(REPLACE(Var_Palabras, ' ', ''));
	SET Var_Cadena 		:= "";
	SET Var_Segmento	:= "";

	IF (Var_NumItera != 0) THEN

		WHILE (LOCATE(" ", Var_Palabras) != 0 AND Var_Ciclo < Var_NumItera) DO

			SET Var_Segmento	:= "";
			SET Var_Posicion := LOCATE(" ", Var_Palabras);
			SET Var_Segmento := LEFT(Var_Palabras, Var_Posicion);

			IF(Var_Segmento != " ") THEN

				IF(Var_Ciclo = 0) THEN
					SET Var_Cadena := CONCAT(UPPER(MID(Var_Segmento,1,1)),
											 MID(Var_Segmento,2,LENGTH(Var_Segmento)-1));
				ELSE
					SET Var_Cadena := CONCAT(Var_Cadena, " ",
											 UPPER(MID(Var_Segmento,1,1)),
											 MID(Var_Segmento,2,LENGTH(Var_Segmento)-1));
				END IF;

			END IF;

			SET Var_Palabras := RIGHT(Var_Palabras, LENGTH(Var_Palabras)-Var_Posicion);
			SET Var_Ciclo := Var_Ciclo + 1;

		END WHILE;

		IF( Var_Palabras != "") THEN
			SET Var_Cadena := CONCAT(Var_Cadena, " ",
								 UPPER(MID(Var_Palabras,1,1)),
								 MID(Var_Palabras,2,LENGTH(Var_Palabras)-1));
		END IF;

	ELSE

		SET Var_Cadena := CONCAT(UPPER(MID(Var_Palabras,1,1)),
								  MID(Var_Palabras,2,LENGTH(Var_Palabras)-1));

	END IF;


RETURN Var_Cadena;

END$$