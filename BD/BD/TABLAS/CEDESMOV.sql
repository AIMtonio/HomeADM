-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESMOV
DELIMITER ;
DROP TABLE IF EXISTS `CEDESMOV`;
DELIMITER $$


CREATE TABLE `CEDESMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CedeID` int(11) DEFAULT NULL COMMENT 'Numero de \nCede',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha',
  `TipoMovCedeID` char(4) NOT NULL COMMENT 'Tipo de \nMovimiento',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Cede',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Tipo de\nMovimiento\nC .- Cargo\nA .- Abono',
  `Referencia` varchar(100) DEFAULT NULL COMMENT 'Referencia',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `FK_CEDESMOV_1` (`CedeID`),
  KEY `FK_CEDESMOV_2` (`MonedaID`),
  KEY `FK_CEDESMOV_3` (`TipoMovCedeID`),
  CONSTRAINT `FK_CEDESMOV_1` FOREIGN KEY (`CedeID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CEDESMOV_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CEDESMOV_3` FOREIGN KEY (`TipoMovCedeID`) REFERENCES `TIPOSMOVSCEDE` (`TipoMovCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Movimientos de CEDES'$$
