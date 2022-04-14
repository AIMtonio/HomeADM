-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_CREDITOGARANTIA
DELIMITER ;
DROP TABLE IF EXISTS `tmp_CREDITOGARANTIA`;DELIMITER $$

CREATE TABLE `tmp_CREDITOGARANTIA` (
  `CreditoID` bigint(12) NOT NULL,
  `MontoEnGarCta` decimal(14,2) DEFAULT NULL,
  `MontoEnGarInv` decimal(14,2) DEFAULT NULL,
  `MontoTotGarantia` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$