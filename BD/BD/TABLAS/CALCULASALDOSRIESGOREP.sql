-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULASALDOSRIESGOREP
DELIMITER ;
DROP TABLE IF EXISTS `CALCULASALDOSRIESGOREP`;DELIMITER $$

CREATE TABLE `CALCULASALDOSRIESGOREP` (
  `ClienteID` int(11) DEFAULT NULL,
  `MontoAcumulado` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente'$$