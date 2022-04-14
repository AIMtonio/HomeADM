-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REEMPLAZACARACTERES
DELIMITER ;
DROP FUNCTION IF EXISTS `REEMPLAZACARACTERES`;DELIMITER $$

CREATE FUNCTION `REEMPLAZACARACTERES`(pattern VARCHAR(1000),replacement VARCHAR(1000),original VARCHAR(1000)) RETURNS varchar(1000) CHARSET latin1
    DETERMINISTIC
BEGIN
 DECLARE temp VARCHAR(1000);
 DECLARE ch VARCHAR(1);
 DECLARE i INT;
 SET i = 1;
 SET temp = '';
 IF original REGEXP pattern THEN
  loop_label: LOOP
   IF i>CHAR_LENGTH(original) THEN
    LEAVE loop_label;
   END IF;
   SET ch = SUBSTRING(original,i,1);
   IF NOT ch REGEXP pattern THEN
    SET temp = CONCAT(temp,ch);
   ELSE
    SET temp = CONCAT(temp,replacement);
   END IF;
   SET i=i+1;
  END LOOP;
 ELSE
  SET temp = original;
 END IF;
 RETURN temp;
END$$