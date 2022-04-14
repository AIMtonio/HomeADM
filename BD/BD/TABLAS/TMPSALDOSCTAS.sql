-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSCTAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSCTAS`;DELIMITER $$

CREATE TABLE `TMPSALDOSCTAS` (
  `ClienteID` int(11) DEFAULT NULL,
  `Cuenta` bigint(20) NOT NULL,
  `NumTipCuenta` int(11) DEFAULT NULL,
  `TipoCuenta` varchar(30) DEFAULT NULL,
  `NumSucursal` int(11) DEFAULT NULL,
  `NombreSucurs` varchar(30) DEFAULT NULL,
  `SaldoIniMes` decimal(18,2) DEFAULT NULL,
  `SaldoDispon` decimal(18,2) DEFAULT NULL,
  `SaldoGarLiq` decimal(18,2) DEFAULT NULL,
  `SaldoTotal` decimal(18,2) DEFAULT NULL,
  `EsMenor` char(1) DEFAULT NULL,
  `ClasiConta` char(1) DEFAULT NULL,
  PRIMARY KEY (`Cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$