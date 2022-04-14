-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDIASATRASOCRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPDIASATRASOCRE`;DELIMITER $$

CREATE TABLE `TMPDIASATRASOCRE` (
  `CreditoID` bigint(20) NOT NULL,
  `FechaAtraso` date DEFAULT NULL,
  KEY `TMPDIASATRASOCRE_1` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$