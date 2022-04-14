-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- prueba
DELIMITER ;
DROP TABLE IF EXISTS `prueba`;DELIMITER $$

CREATE TABLE `prueba` (
  `polizaID` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$