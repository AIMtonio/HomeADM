-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSPROVCEDES
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSPROVCEDES`;DELIMITER $$

CREATE TABLE `TMPSALDOSPROVCEDES` (
  `CedeID` int(11) NOT NULL,
  `SaldoIntProv` decimal(14,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$