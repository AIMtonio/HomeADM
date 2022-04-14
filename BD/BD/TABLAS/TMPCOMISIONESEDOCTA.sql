-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCOMISIONESEDOCTA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCOMISIONESEDOCTA`;DELIMITER $$

CREATE TABLE `TMPCOMISIONESEDOCTA` (
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `CantidadMov` decimal(14,2) DEFAULT NULL COMMENT 'Cantidad de comisiones cobradas ',
  KEY `indx1` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena las comisiones cobradas por cuenta para el estado de cuenta'$$