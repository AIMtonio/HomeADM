-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCAMBIOSUCURCLI
DELIMITER ;
DROP TABLE IF EXISTS `HISCAMBIOSUCURCLI`;DELIMITER $$

CREATE TABLE `HISCAMBIOSUCURCLI` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cliente al que se le hace cambio de sucursal',
  `SucursalOrigen` int(11) NOT NULL DEFAULT '0' COMMENT 'Sucursal origen del cliente',
  `SucursalDestino` int(11) NOT NULL DEFAULT '0' COMMENT 'Sucursal a la que se cambia el cliente',
  `PromotorAnterior` int(11) NOT NULL DEFAULT '0' COMMENT 'Promotor anterior del cliente',
  `PromotorActual` int(11) NOT NULL DEFAULT '0' COMMENT 'Nuevo promotor asignado en la nueva sucursal',
  `UsuarioID` int(11) NOT NULL DEFAULT '0' COMMENT 'Usuario que registra el cambio de sucursal',
  `Fecha` datetime DEFAULT NULL COMMENT 'Fecha y hora en la que se realiza el cambio de sucursal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `FK_ClienteID_6` (`ClienteID`),
  KEY `FK_SucursalID_4` (`SucursalOrigen`),
  KEY `FK_SucursalID_5` (`SucursalDestino`),
  KEY `FK_UsuarioID_4` (`UsuarioID`),
  KEY `FK_PromotorID_1` (`PromotorAnterior`),
  KEY `FK_PromotorID_2` (`PromotorActual`),
  CONSTRAINT `FK_ClienteID_6` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_PromotorID_1` FOREIGN KEY (`PromotorAnterior`) REFERENCES `PROMOTORES` (`PromotorID`),
  CONSTRAINT `FK_PromotorID_2` FOREIGN KEY (`PromotorActual`) REFERENCES `PROMOTORES` (`PromotorID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SucursalID_4` FOREIGN KEY (`SucursalOrigen`) REFERENCES `SUCURSALES` (`SucursalID`),
  CONSTRAINT `FK_SucursalID_5` FOREIGN KEY (`SucursalDestino`) REFERENCES `SUCURSALES` (`SucursalID`),
  CONSTRAINT `FK_UsuarioID_4` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena un historial de cambios de sucursal que ha registra'$$