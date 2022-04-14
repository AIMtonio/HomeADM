-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TASASIMPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TASASIMPUESTOS`;DELIMITER $$

CREATE TABLE `HIS-TASASIMPUESTOS` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de la TasaBaseID',
  `TasaImpuestoID` int(11) NOT NULL COMMENT 'ID de la Tabla Base Impuestos',
  `Valor` decimal(12,2) DEFAULT NULL COMMENT 'Valor de la Tasa.',
  `ValorAnterior` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor de la tasa anterior al cambio de tasa.',
  `TipoTasa` char(1) DEFAULT 'N' COMMENT 'Indica el Tipo de Tasa ISR.\nN.- Nacional.\nE.- Para Residentes en el Extranjero.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria EmpresaID.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria Usuario.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria Fecha Actual.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria DireccionIP.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria Sucursal.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria NumTransaccion.',
  PRIMARY KEY (`Fecha`,`TasaImpuestoID`),
  KEY `fk_TasaImpuestoID1_idx` (`TasaImpuestoID`),
  CONSTRAINT `fk_TasaImpuestoID1` FOREIGN KEY (`TasaImpuestoID`) REFERENCES `TASASIMPUESTOS` (`TasaImpuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla historica de los cambios de tasa para el calculo de ISR.'$$