-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVNUMROM
DELIMITER ;
DROP FUNCTION IF EXISTS `CONVNUMROM`;DELIMITER $$

CREATE FUNCTION `CONVNUMROM`(
	Par_Numero INT(11)
) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE resultado VARCHAR(100);

CASE
WHEN Par_Numero = 1 	THEN SET resultado := 'I';
WHEN Par_Numero = 2 	THEN SET resultado := 'II';
WHEN Par_Numero = 3 	THEN SET resultado := 'III';
WHEN Par_Numero = 4 	THEN SET resultado := 'IV';
WHEN Par_Numero = 5 	THEN SET resultado := 'V';
WHEN Par_Numero = 6 	THEN SET resultado := 'VI';
WHEN Par_Numero = 7 	THEN SET resultado := 'VII';
WHEN Par_Numero = 8 	THEN SET resultado := 'VIII';
WHEN Par_Numero = 9 	THEN SET resultado := 'IX';
WHEN Par_Numero = 10 	THEN SET resultado := 'X';
WHEN Par_Numero = 11 	THEN SET resultado := 'XI';
WHEN Par_Numero = 12 	THEN SET resultado := 'XII';
WHEN Par_Numero = 13 	THEN SET resultado := 'XIII';
WHEN Par_Numero = 14 	THEN SET resultado := 'XIV';
WHEN Par_Numero = 15 	THEN SET resultado := 'XV';
WHEN Par_Numero = 16 	THEN SET resultado := 'XVI';
WHEN Par_Numero = 17 	THEN SET resultado := 'XVII';
WHEN Par_Numero = 18 	THEN SET resultado := 'XVIII';
WHEN Par_Numero = 19 	THEN SET resultado := 'XIX';
WHEN Par_Numero = 20 	THEN SET resultado := 'XX';
ELSE
	SET resultado := 'OUT OF RANGE';
END CASE;

RETURN resultado;
END$$