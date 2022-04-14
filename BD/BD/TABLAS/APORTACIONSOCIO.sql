-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIO
DELIMITER ;
DROP TABLE IF EXISTS `APORTACIONSOCIO`;DELIMITER $$

CREATE TABLE `APORTACIONSOCIO` (
  `AportaSocio` int(11) DEFAULT NULL COMMENT 'Numero consecutivo de Aportacion Social',
  `ClienteID` int(11) NOT NULL COMMENT 'Id del cliente',
  `Saldo` decimal(14,1) DEFAULT NULL COMMENT 'Campo que indica el Saldo de la aportacion\n',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID de la sucursal en donde se esta dando de  alta\n',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se da de alta\n',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que da de alta\n\n',
  `FechaCertificado` date DEFAULT NULL COMMENT 'fecha en que se genero el certificado de aportacion social',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `fk_APORTACIONSOCIO_1` (`SucursalID`),
  CONSTRAINT `fk_APORTACIONSOCIO_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ClienteID1` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Por cada socio almacena  un registro de su Aportación. Esta '$$