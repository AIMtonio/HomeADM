-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEIMPFACT
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEIMPFACT`;DELIMITER $$

CREATE TABLE `DETALLEIMPFACT` (
  `ProveedorID` int(11) NOT NULL COMMENT 'ID del proveedor de la factura',
  `NoFactura` varchar(20) NOT NULL COMMENT 'Número de la factura',
  `NoPartidaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de partida del proveedor',
  `ImpuestoID` int(11) NOT NULL COMMENT 'ID del impuesto',
  `ImporteImpuesto` decimal(14,2) NOT NULL COMMENT 'Importe de Impuesto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ProveedorID`,`NoFactura`,`NoPartidaID`,`ImpuestoID`),
  CONSTRAINT `fk_DETALLEIMPFACT_1` FOREIGN KEY (`ProveedorID`, `NoFactura`, `NoPartidaID`) REFERENCES `DETALLEFACTPROV` (`ProveedorID`, `NoFactura`, `NoPartidaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los detalles de impuestos de cada factura.'$$