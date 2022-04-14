-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLISALDOSREP
DELIMITER ;
DROP TABLE IF EXISTS `RIESGOCOMUNCLISALDOSREP`;DELIMITER $$

CREATE TABLE `RIESGOCOMUNCLISALDOSREP` (
  `ClienteID` int(11) DEFAULT NULL,
  `MontoAcumulado` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente'$$