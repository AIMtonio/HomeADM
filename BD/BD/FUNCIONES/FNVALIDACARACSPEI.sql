-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNVALIDACARACSPEI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNVALIDACARACSPEI`;DELIMITER $$

CREATE FUNCTION `FNVALIDACARACSPEI`(
-- =====================================================================================
-- ------- FUNCION PARA VALIDAR CARACTERES INVALIDOS MODULO SPEI ---------
-- =====================================================================================
   Par_Palabra         VARCHAR(210)

) RETURNS int(3)
    DETERMINISTIC
BEGIN

-- Declaracion de Variables
DECLARE Num_Val        	INT(3);
DECLARE texto          	VARCHAR(210);

-- Declaracion de Constantes
DECLARE Entero_Cero    	INT;
DECLARE Cadena_Vacia   	CHAR(1);
DECLARE contador       	INT;
DECLARE Lng            	INT;
DECLARE caracter      	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia        := '';
SET texto               := REPLACE(Par_Palabra,' ','');
SET Par_Palabra			:= IFNULL(Par_Palabra, Cadena_Vacia);


IF (texto = Cadena_Vacia) THEN
	SET Num_Val := 50;
	RETURN Num_Val;
ELSE
	SET Lng := LENGTH(texto);
END IF;


SET contador := 1;

cicloValida: LOOP
	SET caracter = SUBSTRING(texto,contador,1);
	IF (caracter REGEXP '[A-Za-z0-9!"#$%&()*+,-./:;?@\_áéíóúñÑ¿¡'']') = 0 THEN
		SET Num_Val := 100;
		RETURN Num_Val;
	END IF;

	IF contador = Lng THEN
		LEAVE cicloValida;
	ELSE
		SET contador = contador + 1;
     END IF;
END LOOP;

SET Num_Val := 0;

RETURN Num_Val;

END$$