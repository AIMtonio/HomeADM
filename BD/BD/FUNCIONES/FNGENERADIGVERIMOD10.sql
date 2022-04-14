-- FNGENERADIGVERIMOD10
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENERADIGVERIMOD10`;
DELIMITER $$
CREATE FUNCTION `FNGENERADIGVERIMOD10`(
-- FUNCIONES QUE CALCULA EL DIGITO VERIFICADOR PARA EL ALGORITMO BANSEFI
	Par_Referencia 				CHAR(18)	-- Referencia base sobre el que se calculara el digito verificador

) RETURNS int(11)
    DETERMINISTIC
BEGIN
	-- Declaracion de variables
	DECLARE Var_Posicion		INT(11);	-- Posicion del caracter a evaluar
	DECLARE Var_Acum			INT(11);	-- Numero acumulado total
    DECLARE Var_Longitud		INT(11);	-- Longitud de la referencia a evaluar
    DECLARE Var_LongDig			INT(11);	-- Longitud del digito a evaluar
    DECLARE Var_CadenaInv		CHAR(25);	-- Referencia inversa
    DECLARE Var_Digito			INT(11);	-- Digito a evaluar
    DECLARE Var_NuevoDig		INT(11);	-- Nuevo digito acumulado
    DECLARE Var_Numero			INT(11);	-- Nuevo digito a evaluar
    DECLARE Var_Suma			INT(11);	-- Acumulado de la suma de todos los digitos evaluados
    DECLARE Var_Resultado		INT(11);	-- Digito final

	-- Declaracion de constantes
	DECLARE	Entero_Cero			INT(11);	-- Constante Entero Cero

 	-- Asignación de constantes
	SET Entero_Cero			:= 0;

	-- Inicializacion de variables
	SET Var_Posicion 	:= 1;
	SET Var_Acum 		:= 0;
    SET Var_NuevoDig	:= 0;
    SET Var_Suma 		:= 0;

    SET Var_Longitud := LENGTH(Par_Referencia);
    SET Var_CadenaInv := REVERSE(Par_Referencia);

	WHILE Var_Posicion <= Var_Longitud DO

		SET Var_Digito := SUBSTRING(Var_CadenaInv, Var_Posicion, 1);

		IF ((Var_Posicion % 2) != 0) THEN
			SET Var_Digito := (Var_Digito * 2);
		END IF;

        SET Var_LongDig := LENGTH(Var_Digito);

        IF(Var_LongDig > 1) THEN
			SET Var_Suma := Entero_Cero;
			WHILE(Var_LongDig > Entero_Cero) DO

				SET Var_Numero := SUBSTRING(Var_Digito, Var_LongDig, 1);

				SET Var_Suma := Var_Suma + Var_Numero;


				SET Var_LongDig := Var_LongDig -1;
			END WHILE;

            SET Var_NuevoDig := Var_Suma;
        ELSE
			SET Var_NuevoDig := Var_Digito;
        END IF;

        SET Var_Acum := Var_Acum + Var_NuevoDig;
		SET Var_Posicion := Var_Posicion + 1;

	END WHILE;

	SET Var_Acum := (Var_Acum % 10);

    IF(Var_Acum = Entero_Cero) THEN
		SET Var_Resultado := Entero_Cero;
    ELSE
        SET Var_Resultado := 10 - Var_Acum;

    END IF;

	RETURN Var_Resultado;
END$$