-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_CASTIGOS
DELIMITER ;
DROP TABLE IF EXISTS `TMP_CASTIGOS`;DELIMITER $$

CREATE TABLE `TMP_CASTIGOS` (
  `CreditoID` bigint(12) NOT NULL,
  `SaldoCapital` decimal(14,2) DEFAULT NULL,
  `InteresVencido` decimal(14,2) DEFAULT NULL,
  `InteresMoratorio` decimal(14,2) DEFAULT NULL,
  `InteresRefinanciado` decimal(14,2) DEFAULT NULL,
  `MontoCastigo` decimal(14,2) DEFAULT NULL,
  `FechaCastigo` date DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$