-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVPLAZOAMESES
DELIMITER ;
DROP FUNCTION IF EXISTS `CONVPLAZOAMESES`;DELIMITER $$

CREATE FUNCTION `CONVPLAZOAMESES`(
	Par_Plazo	INT,
	FrecPago	CHAR(1)

) RETURNS varchar(400) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE resultado VARCHAR(400);

SET resultado = '';

	CASE	FrecPago
		WHEN 'S' THEN SET resultado := CONCAT(TRUNCATE(Par_Plazo * 7 / 30,0), ' mes(es)');
		WHEN 'C' THEN SET resultado := CONCAT(TRUNCATE(Par_Plazo * 14 / 30,0), ' mes(es)');
		WHEN 'Q' THEN SET resultado := CONCAT(TRUNCATE(Par_Plazo * 15 / 30,0), ' mes(es)');
		WHEN 'M' THEN SET resultado := CONCAT(Par_Plazo , ' mes(es)');
		WHEN 'B' THEN SET resultado := CONCAT(Par_Plazo * 2, ' mes(es)');
		WHEN 'T' THEN SET resultado := CONCAT(Par_Plazo * 3, ' mes(es)');
		WHEN 'R' THEN SET resultado := CONCAT(Par_Plazo * 4, ' mes(es)');
		WHEN 'E' THEN SET resultado := CONCAT(Par_Plazo * 6, ' mes(es)');
		WHEN 'A' THEN SET resultado := CONCAT(Par_Plazo * 12,' mes(es)');
		ELSE SET resultado := 'No aplica';
	END CASE;

RETURN resultado;
END$$