-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSTOTALGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSTOTALGARANTIAS`;DELIMITER $$

CREATE TABLE `TMPSTOTALGARANTIAS` (
  `ClienteID` int(11) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL,
  `SaldoDisponible` decimal(14,2) DEFAULT NULL,
  `SaldoBloqueado` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$