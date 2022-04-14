-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRUEBA_OUTPUT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRUEBA_OUTPUT`;DELIMITER $$

CREATE PROCEDURE `PRUEBA_OUTPUT`(out FolioCte int	)
BEGIN
select count(ClienteID) + 1 into FolioCte from CLIENTES;
END$$