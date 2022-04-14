-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_AuxAho
DELIMITER ;
DROP TABLE IF EXISTS `tmp_AuxAho`;DELIMITER $$

CREATE TABLE `tmp_AuxAho` (
  `CreditoID` bigint(12) DEFAULT NULL,
  `CuentaID` bigint(12) DEFAULT NULL,
  `FechaCtaAho` date DEFAULT NULL,
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$