-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_adiRes
DELIMITER ;
DROP TABLE IF EXISTS `tmp_adiRes`;DELIMITER $$

CREATE TABLE `tmp_adiRes` (
  `CuentaMayor` varchar(20) DEFAULT NULL,
  `Monto` decimal(38,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$