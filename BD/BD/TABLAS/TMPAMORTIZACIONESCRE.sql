-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTIZACIONESCRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTIZACIONESCRE`;DELIMITER $$

CREATE TABLE `TMPAMORTIZACIONESCRE` (
  `CreditoID` bigint(12) NOT NULL,
  `TotalCuotas` int(11) DEFAULT NULL,
  `Cubiertas` int(4) DEFAULT NULL,
  `PorCubrir` int(4) DEFAULT NULL,
  `CapitalCubierto` decimal(14,2) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$