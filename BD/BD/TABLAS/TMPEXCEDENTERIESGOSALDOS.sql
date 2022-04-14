-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEXCEDENTERIESGOSALDOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPEXCEDENTERIESGOSALDOS`;DELIMITER $$

CREATE TABLE `TMPEXCEDENTERIESGOSALDOS` (
  `GrupoID` int(11) DEFAULT NULL,
  `SaldoGrupal` double(14,2) DEFAULT NULL,
  KEY `idx_TMPEXCEDENTERIESGOSALDOS_1` (`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$