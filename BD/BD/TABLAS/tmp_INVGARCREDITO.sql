-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_INVGARCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `tmp_INVGARCREDITO`;DELIMITER $$

CREATE TABLE `tmp_INVGARCREDITO` (
  `CreditoID` bigint(12) NOT NULL,
  `MontoEnGar` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$