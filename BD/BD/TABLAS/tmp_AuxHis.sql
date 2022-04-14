-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_AuxHis
DELIMITER ;
DROP TABLE IF EXISTS `tmp_AuxHis`;DELIMITER $$

CREATE TABLE `tmp_AuxHis` (
  `CreditoID` bigint(12) DEFAULT NULL,
  `CuentaID` bigint(12) DEFAULT NULL,
  `FechaHisCtaAho` date DEFAULT NULL,
  KEY `CreditoID` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$