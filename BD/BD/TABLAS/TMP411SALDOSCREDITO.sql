-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP411SALDOSCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TMP411SALDOSCREDITO`;DELIMITER $$

CREATE TABLE `TMP411SALDOSCREDITO` (
  `SaldoCapital` decimal(21,2) DEFAULT NULL,
  `SaldoInteres` decimal(21,2) DEFAULT NULL,
  `InteresMes` decimal(21,2) DEFAULT NULL,
  `ComisionMes` decimal(21,2) DEFAULT NULL,
  `ClasifRegID` decimal(21,2) DEFAULT NULL,
  KEY `id_indexClasifRegID` (`ClasifRegID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$