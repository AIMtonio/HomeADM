-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_SaldosDeCuentas
DELIMITER ;
DROP TABLE IF EXISTS `tmp_SaldosDeCuentas`;DELIMITER $$

CREATE TABLE `tmp_SaldosDeCuentas` (
  `Cuenta` bigint(12) NOT NULL,
  `NumTipCuenta` int(11) DEFAULT NULL,
  `TipoCuenta` varchar(30) DEFAULT NULL,
  `NumSucursal` int(11) DEFAULT NULL,
  `NombreSucurs` varchar(30) DEFAULT NULL,
  `SaldoIniMes` decimal(18,2) DEFAULT NULL,
  `SaldoDispon` decimal(18,2) DEFAULT NULL,
  `SaldoGarLiq` decimal(18,2) DEFAULT NULL,
  `SaldoTotal` decimal(18,2) DEFAULT NULL,
  PRIMARY KEY (`Cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$