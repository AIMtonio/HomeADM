-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTOTALGARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPTOTALGARANTIAS`;DELIMITER $$

CREATE TABLE `TMPTOTALGARANTIAS` (
  `ClienteID` int(11) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL,
  `SaldoDisponible` decimal(14,2) DEFAULT NULL,
  `SaldoBloqueado` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$