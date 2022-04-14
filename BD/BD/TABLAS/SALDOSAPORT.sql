-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSAPORT
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSAPORT`;DELIMITER $$

CREATE TABLE `SALDOSAPORT` (
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `AportacionID` int(11) NOT NULL COMMENT 'ID de la Aportación.',
  `TipoAportacionID` int(11) NOT NULL COMMENT 'Tipo de la Aportación.',
  `SaldoCapital` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital',
  `SaldoIntProvision` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Aportación.',
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
  PRIMARY KEY (`FechaCorte`,`AportacionID`),
  KEY `FK_SALDOSAPORT_1` (`AportacionID`),
  KEY `FK_SALDOSAPORT_2` (`TipoAportacionID`),
  CONSTRAINT `FK_SALDOSAPORT_1` FOREIGN KEY (`AportacionID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SALDOSAPORT_2` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Saldos Diarios de Aportaciones.'$$