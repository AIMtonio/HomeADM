-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTMOV
DELIMITER ;
DROP TABLE IF EXISTS `APORTMOV`;
DELIMITER $$


CREATE TABLE `APORTMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AportacionID` int(11) DEFAULT NULL COMMENT 'Numero de Aportación.',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `TipoMovAportID` char(4) NOT NULL COMMENT 'Tipo de Movimiento.',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Aportación.',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Tipo de Movimiento\nC .- Cargo\nA .- Abono',
  `Referencia` varchar(100) DEFAULT NULL COMMENT 'Referencia',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `FK_APORTMOV_1` (`AportacionID`),
  KEY `FK_APORTMOV_2` (`MonedaID`),
  KEY `FK_APORTMOV_3` (`TipoMovAportID`),
  CONSTRAINT `FK_APORTMOV_1` FOREIGN KEY (`AportacionID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_APORTMOV_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_APORTMOV_3` FOREIGN KEY (`TipoMovAportID`) REFERENCES `TIPOSMOVSAPORT` (`TipoMovAportID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Movimientos de Aportaciones.'$$
