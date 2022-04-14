-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCEDES
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSCEDES`;DELIMITER $$

CREATE TABLE `SALDOSCEDES` (
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `CedeID` int(11) NOT NULL COMMENT 'ID del CEDE',
  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de CEDE',
  `SaldoCapital` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital',
  `SaldoIntProvision` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del CEDE',
  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'tasa ISR',
  `InteresGenerado` decimal(12,2) DEFAULT '0.00' COMMENT 'Interes generado',
  `InteresRecibir` decimal(12,2) DEFAULT '0.00' COMMENT 'interes a recibr',
  `InteresRetener` decimal(12,2) DEFAULT '0.00' COMMENT 'interes a retener',
  `TasaBase` int(11) DEFAULT NULL COMMENT 'Tasa Base',
  `SobreTasa` decimal(12,4) DEFAULT '0.0000' COMMENT 'Sobre Tasa',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`FechaCorte`,`CedeID`),
  KEY `FK_SALDOSCEDES_1` (`CedeID`),
  KEY `FK_SALDOSCEDES_2` (`TipoCedeID`),
  CONSTRAINT `FK_SALDOSCEDES_1` FOREIGN KEY (`CedeID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SALDOSCEDES_2` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos Diarios de CEDES'$$