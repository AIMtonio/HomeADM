-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALESSTFL
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALESSTFL`;DELIMITER $$

CREATE TABLE `TMPAVALESSTFL` (
  `TransaccionID` bigint(20) DEFAULT NULL,
  `Consecutivo` int(11) DEFAULT NULL,
  `AvalNombre1` varchar(250) DEFAULT NULL,
  `AvalDomicilio1` varchar(250) DEFAULT NULL,
  `AvalNombre2` varchar(250) DEFAULT NULL,
  `AvalDomicilio2` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para calcular firmas de avales'$$