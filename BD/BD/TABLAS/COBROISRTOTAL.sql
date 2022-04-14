-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROISRTOTAL
DELIMITER ;
DROP TABLE IF EXISTS `COBROISRTOTAL`;DELIMITER $$

CREATE TABLE `COBROISRTOTAL` (
  `Fecha` date DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo del ISR',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente al que se le Calculo ISR',
  `InstrumentoID` int(11) DEFAULT NULL COMMENT 'InstrumentoID 2.-Ahorro, 13.-Inversiones, 28.- CEDES',
  `ProductoID` bigint(12) DEFAULT NULL COMMENT 'ProduectoID CedeID,CuentaAhoID,InversionID',
  `ISR` decimal(14,2) DEFAULT NULL COMMENT 'Monto ISR Total para el Instrumento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `Fecha` (`Fecha`),
  KEY `ClienteID` (`ClienteID`),
  KEY `InstrumentoID` (`InstrumentoID`),
  KEY `ProductoID` (`ProductoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Auxiliar para el Cobro de ISR,'$$