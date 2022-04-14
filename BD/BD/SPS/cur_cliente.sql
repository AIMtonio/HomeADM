-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- cur_cliente
DELIMITER ;
DROP PROCEDURE IF EXISTS `cur_cliente`;DELIMITER $$

CREATE PROCEDURE `cur_cliente`()
BEGIN
DECLARE done INT DEFAULT 0;
  DECLARE a INT;
  DECLARE b VARCHAR(45);
  DECLARE cur1 CURSOR FOR SELECT ClienteID,NombreCli FROM microfin.clientes;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  OPEN cur1;
  read_loop: LOOP
      FETCH cur1 INTO a, b;
        IF done THEN
            LEAVE read_loop;
        END IF;
      select a,b;
  END LOOP;
  CLOSE cur1;
END$$