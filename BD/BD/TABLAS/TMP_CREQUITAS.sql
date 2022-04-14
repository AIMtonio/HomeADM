-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_CREQUITAS
DELIMITER ;
DROP TABLE IF EXISTS `TMP_CREQUITAS`;DELIMITER $$

CREATE TABLE `TMP_CREQUITAS` (
  `CreditoID` bigint(12) NOT NULL,
  `SaldoCapital` decimal(14,2) DEFAULT NULL,
  `InteresVencido` decimal(14,2) DEFAULT NULL,
  `InteresMoratorio` decimal(14,2) DEFAULT NULL,
  `InteresRefinanciado` decimal(14,2) DEFAULT NULL,
  `MontoCondonacion` decimal(14,2) DEFAULT NULL,
  `FechaRegistro` date DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$