-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRUEBA_OUTPUT_CALL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRUEBA_OUTPUT_CALL`;DELIMITER $$

CREATE PROCEDURE `PRUEBA_OUTPUT_CALL`(	)
BEGIN

DECLARE VARIABLE INT DEFAULT 1;

CALL PRUEBA_OUTPUT(VARIABLE);

SELECT VARIABLE as valor;


END$$