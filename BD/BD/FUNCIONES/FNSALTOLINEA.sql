-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSALTOLINEA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSALTOLINEA`;
DELIMITER $$

CREATE FUNCTION `FNSALTOLINEA`(
-- FUNCION PARA REALIZAR EL SALTO DE LINEA DE ACUERDO A LA LONGITUD DESEADA
	Par_CadenaOriginal	VARCHAR (5000),
	Par_Longitud		INT
) RETURNS varchar(7000) CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE Var_LongCadOrig INT;
    DECLARE Var_Saltos		INT;
    DECLARE Var_Contador	INT;
    
    DECLARE Var_LonCadResto	INT; -- MIA
    DECLARE Var_Respuesta	varchar(7000) ;


    SET Var_LongCadOrig	:= LENGTH(Par_CadenaOriginal);
    SET	Var_LonCadResto	:= LENGTH(Par_CadenaOriginal);
    
    SET Var_Respuesta            = '';


    IF Var_LongCadOrig > Par_Longitud THEN
		WHILE(Var_LonCadResto>Par_Longitud) DO
			SET Var_Respuesta		:= CONCAT(Var_Respuesta, LEFT(Par_CadenaOriginal, Par_Longitud), CHAR(13) , CHAR(10));
			SET Par_CadenaOriginal	:= SUBSTRING(Par_CadenaOriginal, Par_Longitud + 1);
			SET Var_LonCadResto		:=LENGTH(Par_CadenaOriginal);
		END WHILE;
		IF (Var_LonCadResto>0) THEN
			SET Var_Respuesta		:= CONCAT(Var_Respuesta, Par_CadenaOriginal);
		END IF;
	ELSE
        SET Var_Respuesta	:= Par_CadenaOriginal;
    END IF;
    
    RETURN Var_Respuesta;
END$$ 