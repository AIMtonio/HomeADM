-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFOLIOSPLANAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPFOLIOSPLANAHORRO`;DELIMITER $$

CREATE TABLE `TMPFOLIOSPLANAHORRO` (
  `Consecutivo` int(11) DEFAULT NULL,
  `BloqueoID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `FechaMov` date DEFAULT NULL,
  `MontoBloq` decimal(12,2) DEFAULT NULL,
  `ReferenciaBloq` bigint(20) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `IDX_Consecutivo` (`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$