-- FNGENERADIGVERIALG137
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENERADIGVERIALG137`;
DELIMITER $$

CREATE FUNCTION `FNGENERADIGVERIALG137`(
-- FUNCION QUE CALCULA EL DIGITO VERIFICADOR PARA EL ALGORITMO OXXO
	Par_Referencia 				VARCHAR(21)	-- Referencia base sobre el que se calculara el digito verificador
	
) RETURNS int(11)
    DETERMINISTIC
BEGIN
	
    -- Declaracion de variables
	DECLARE Var_Posicion		INT(11);	-- Posicion del caracter a evaluar 
	DECLARE Var_Acum			INT(11);	-- Numero acumulado total
	DECLARE Var_Identificador	INT(11);    -- Identificador
    DECLARE Var_Longitud		INT(11);	-- Longitud de la referencia
    DECLARE Var_LongDig			INT(11);	-- Longitud del digito a evaluar
    DECLARE Var_Digito			INT(11);	-- Digito a evaluar
    DECLARE Var_Resultado		INT(11);	-- Digito final	
    
	-- Declaracion de Constantes
	DECLARE	Entero_Cero			INT(11);

 	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;	
	SET Var_Posicion		:= 1;
	SET Var_Acum			:= 0;    
	SET Var_Identificador	:= 1;
    SET Var_Resultado		:= 0;
	
    
    SET Var_Longitud := LENGTH(Par_Referencia);
    
	WHILE Var_Posicion <= Var_Longitud DO
        IF(Var_Identificador > 3)THEN
           SET Var_Identificador := 1;
        END IF;
		
		SET Var_Digito := SUBSTRING(Par_Referencia, Var_Posicion, 1);
		
		IF (Var_Identificador = 1) THEN		
			SET Var_Digito := (Var_Digito * 1);
            
        ELSEIF(Var_Identificador = 2) THEN
			SET Var_Digito := (Var_Digito * 3);

        ELSE
            SET Var_Digito := (Var_Digito * 7);

		END IF;        
		
        SET Var_Acum := Var_Acum + Var_Digito;
        SET Var_Identificador := Var_Identificador + 1;
		SET Var_Posicion := Var_Posicion + 1;
		
	END WHILE;
	
    SET Var_Resultado := (Var_Acum % 9) + 1;	

	RETURN Var_Resultado;
END$$