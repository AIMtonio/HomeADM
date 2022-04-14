-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- Temp_SaldosCredito
DELIMITER ;
DROP TABLE IF EXISTS `Temp_SaldosCredito`;DELIMITER $$

CREATE TABLE `Temp_SaldosCredito` (
  `CreditoID` bigint(12) NOT NULL,
  `NombreCompleto` varchar(200) DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `MontoCredito` decimal(12,2) DEFAULT NULL,
  `SaldoCapital` decimal(12,2) DEFAULT NULL,
  `SaldoInteres` decimal(12,2) DEFAULT NULL,
  `NombreSucurs` varchar(200) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$