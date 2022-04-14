-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLPLAN
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEPOLPLAN`;DELIMITER $$

CREATE TABLE `DETALLEPOLPLAN` (
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(50) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `Cargos` decimal(12,2) DEFAULT NULL,
  `Abonos` decimal(12,2) DEFAULT NULL,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_DETALLEPOLPLAN_1` (`PolizaID`),
  KEY `fk_DETALLEPOLPLAN_2` (`MonedaID`),
  CONSTRAINT `fk_DETALLEPOLPLAN_1` FOREIGN KEY (`PolizaID`) REFERENCES `POLIZACONTAPLAN` (`PolizaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DETALLEPOLPLAN_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='PLANTILLA Poliza Contable'$$