-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVTIPOGASTO
DELIMITER ;
DROP TABLE IF EXISTS `PROVTIPOGASTO`;DELIMITER $$

CREATE TABLE `PROVTIPOGASTO` (
  `ProveedorID` int(11) NOT NULL COMMENT 'id del proveedor',
  `TipoGastoID` int(11) NOT NULL COMMENT 'id del tipo de gaso\nTESOCATTIPGAS',
  `SucursalID` int(11) NOT NULL COMMENT 'id de la Sucursal',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(50) DEFAULT NULL,
  `ProgramaID` varchar(70) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ProveedorID`,`TipoGastoID`,`SucursalID`),
  KEY `fk_PROVTIPOGASTO_1` (`ProveedorID`),
  KEY `fk_PROVTIPOGASTO_2` (`TipoGastoID`),
  KEY `fk_PROVTIPOGASTO_3` (`SucursalID`),
  CONSTRAINT `fk_PROVTIPOGASTO_1` FOREIGN KEY (`ProveedorID`) REFERENCES `PROVEEDORES` (`ProveedorID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PROVTIPOGASTO_2` FOREIGN KEY (`TipoGastoID`) REFERENCES `TESOCATTIPGAS` (`TipoGastoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PROVTIPOGASTO_3` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA RELACIÓN DE  LAS TABLAS PROVEEDORES Y TESOCATTIPGAS'$$