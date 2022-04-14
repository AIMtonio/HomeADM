-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETCAJASMOV
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETCAJASMOV`;DELIMITER $$

CREATE TABLE `TMPDETCAJASMOV` (
  `Transaccion` int(11) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NomCajero` varchar(45) DEFAULT NULL,
  `Sucursal` varchar(45) DEFAULT NULL,
  `Efectivo` decimal(14,2) DEFAULT NULL,
  `MontoSBC` decimal(14,2) DEFAULT NULL,
  `NumCuenta` varchar(45) DEFAULT NULL,
  `Referencia` varchar(45) DEFAULT NULL,
  `TipoOperacion` int(11) DEFAULT NULL,
  `NaturalezaOp` int(11) DEFAULT NULL,
  `CajaID` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `TMPDETCAJASMOV_IDX_1` (`Referencia`,`NumTransaccion`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Tabla temporal se usa para el store OPERACIONESVENTREP'$$