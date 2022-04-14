-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_SaldosBloqueo
DELIMITER ;
DROP TABLE IF EXISTS `tmp_SaldosBloqueo`;DELIMITER $$

CREATE TABLE `tmp_SaldosBloqueo` (
  `Cuenta` bigint(12) NOT NULL,
  `Saldo` decimal(18,2) DEFAULT NULL,
  `Referencia` bigint(20) DEFAULT NULL,
  `SaldoAho` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`Cuenta`),
  KEY `tmp_idx` (`Referencia`),
  KEY `tmp_idx2` (`Cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$