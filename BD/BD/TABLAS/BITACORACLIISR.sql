-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACLIISR
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACLIISR`;DELIMITER $$

CREATE TABLE `BITACORACLIISR` (
  `Fecha` date NOT NULL COMMENT 'Fecha de ejecucion',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora del proceso que  truca HISCLIENTESISR'$$