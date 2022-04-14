-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPROVEIMPUES`;DELIMITER $$

CREATE TABLE `TIPOPROVEIMPUES` (
  `TipoProveedorID` int(11) NOT NULL COMMENT 'Tipo de Proveedor de acuerdo a clasificacion contable',
  `ImpuestoID` int(11) NOT NULL COMMENT 'Tipo de Impuesto',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden en que se aplica en el documento fiscal (factura, recibo, etc)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TipoProveedorID`,`ImpuestoID`),
  KEY `fk_TIPOPROVEIMPUES_TipoProv_idx` (`TipoProveedorID`),
  KEY `fk_TIPOPROVEIMPUES_Impuesto_idx` (`ImpuestoID`),
  CONSTRAINT `fk_TIPOPROVEIMPUES_Impuesto` FOREIGN KEY (`ImpuestoID`) REFERENCES `IMPUESTOS` (`ImpuestoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_TIPOPROVEIMPUES_TipoProv` FOREIGN KEY (`TipoProveedorID`) REFERENCES `TIPOPROVEEDORES` (`TipoProveedorID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Relacion entre tipo de proveedor e impuestos que aplican rel'$$