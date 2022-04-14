-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROMPIMIENTOSGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `ROMPIMIENTOSGRUPO`;DELIMITER $$

CREATE TABLE `ROMPIMIENTOSGRUPO` (
  `RompimientoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de rompimientos',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente que se esta desintegrando del grupo',
  `GrupoID` int(10) DEFAULT NULL COMMENT 'Grupo al que se esta realizando el rompimiento',
  `CicloActual` int(11) DEFAULT NULL COMMENT 'Ciclo en el que estaba el grupo',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Solicitud de credito del cliente que se esta desintegrando',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito del cliente que se esta desintegrando',
  `EstatusSolicitud` char(1) DEFAULT NULL COMMENT 'Estatus en el que estaba la solicitud de credito',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus en el que estaba el credito',
  `ProductoCredito` int(11) DEFAULT NULL COMMENT 'Producto de credito relacionado',
  `Motivo` varchar(500) DEFAULT NULL COMMENT 'Motivo del rompimiento',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del sistema en que se genera el rompimiento',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que registra el rompimiento',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se registra el rompimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(15) DEFAULT NULL,
  PRIMARY KEY (`RompimientoID`),
  KEY `FK_ClienteID_13` (`ClienteID`),
  KEY `FK_GrupoID_2` (`GrupoID`),
  KEY `FK_ProducCreditoID_5` (`ProductoCredito`),
  KEY `FK_UsuarioID_5` (`UsuarioID`),
  KEY `FK_SucursalID_2` (`SucursalID`),
  CONSTRAINT `FK_ClienteID_13` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_GrupoID_2` FOREIGN KEY (`GrupoID`) REFERENCES `GRUPOSCREDITO` (`GrupoID`),
  CONSTRAINT `FK_ProducCreditoID_5` FOREIGN KEY (`ProductoCredito`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`),
  CONSTRAINT `FK_SucursalID_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_UsuarioID_5` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los rompimientos de grupos de credito que se han real'$$