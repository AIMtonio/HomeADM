-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPOPVENREP
DELIMITER ;
DROP TABLE IF EXISTS `TMPOPVENREP`;DELIMITER $$

CREATE TABLE `TMPOPVENREP` (
  `Transaccion` int(11) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NomCajero` varchar(60) DEFAULT NULL,
  `Sucursal` varchar(45) DEFAULT NULL,
  `Efectivo` decimal(14,2) DEFAULT NULL,
  `MontoSBC` decimal(14,2) DEFAULT NULL,
  `NumCuenta` varchar(45) DEFAULT NULL,
  `Referencia` varchar(45) DEFAULT NULL,
  `TipoOperacion` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(80) DEFAULT NULL,
  `ReferenciaRep` varchar(45) DEFAULT NULL,
  `GrupoCred` int(11) DEFAULT NULL,
  `DescripcionOp` varchar(60) DEFAULT NULL,
  `NaturalezaOp` int(11) DEFAULT NULL,
  `CajaID` int(11) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT NULL,
  `NombreGrupo` varchar(200) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `Orden` int(11) DEFAULT NULL,
  KEY `TMPOPVENREP_IDX_1` (`Transaccion`,`Fecha`,`NumTransaccion`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Tabla temporal se usa para el store OPERACIONESVENTREP'$$