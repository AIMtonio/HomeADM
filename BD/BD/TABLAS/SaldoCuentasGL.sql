-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SaldoCuentasGL
DELIMITER ;
DROP TABLE IF EXISTS `SaldoCuentasGL`;DELIMITER $$

CREATE TABLE `SaldoCuentasGL` (
  `Cuenta` bigint(12) NOT NULL,
  `Importe` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`Cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$