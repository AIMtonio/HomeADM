-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNLETRACAPITAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNLETRACAPITAL`;DELIMITER $$

CREATE FUNCTION `FNLETRACAPITAL`(
	Par_Cadena VARCHAR(100)


) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE Pos INT(11) DEFAULT 0;
DECLARE Tmp VARCHAR(100);
DECLARE Result VARCHAR(100);

SET Par_Cadena			:= IFNULL(Par_Cadena, '');
SET Tmp					:= '';
SET Result				:= '';

REPEAT
	SET Pos = LOCATE(' ', Par_Cadena);
	IF Pos = 0 THEN
		SET Pos = CHAR_LENGTH(Par_Cadena);
	END IF;
	SET tmp = LEFT(Par_Cadena,Pos);
	SET result = CONCAT(Result, UPPER(LEFT(Tmp,1)),LOWER(SUBSTR(Tmp,2)));
	SET Par_Cadena = RIGHT(Par_Cadena,CHAR_LENGTH(Par_Cadena)-Pos);
	UNTIL CHAR_LENGTH(Par_Cadena) = 0
 END REPEAT;
	SET Result = REPLACE(Result, ' De ', ' de ');
    SET Result = REPLACE(Result, ' Del ', ' del ');
	SET Result = REPLACE(Result, ' Los ', ' los ');
    SET Result = REPLACE(Result, ' La ', ' la ');
    SET Result = REPLACE(Result, ' Las ', ' las ');

	RETURN Result;
END$$