-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CS_SALDOSBALANZA
DELIMITER ;
DROP TABLE IF EXISTS `CS_SALDOSBALANZA`;DELIMITER $$

CREATE TABLE `CS_SALDOSBALANZA` (
  `CuentaCompleta` varchar(50) DEFAULT NULL,
  `SaldoIniDeudor` decimal(12,2) DEFAULT NULL,
  `SaldoIniAcredor` decimal(12,2) DEFAULT NULL,
  `Cargos` decimal(12,2) DEFAULT NULL,
  `Abonos` decimal(12,2) DEFAULT NULL,
  `SaldoDeudor` decimal(12,2) DEFAULT NULL,
  `SaldoAcreedor` decimal(12,2) DEFAULT NULL,
  `NumTransaccion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$