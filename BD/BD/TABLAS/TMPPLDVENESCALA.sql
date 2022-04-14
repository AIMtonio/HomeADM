-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDVENESCALA
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDVENESCALA`;DELIMITER $$

CREATE TABLE `TMPPLDVENESCALA` (
  `FolioEscala` bigint(11) NOT NULL COMMENT 'Folio de detección',
  `OpcionCajaID` int(11) NOT NULL COMMENT 'OpcionCaja ID corresponde a la tabla de OPCIONESCAJA',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID corresponde a la tabla de CLIENTES',
  `UsuarioServicioID` int(11) DEFAULT NULL COMMENT 'Usuario Servicio ID corresponde a la tabla USUARIOSERVICIO',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de Ahorro corresponde a la tabla CUENTASAHO',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'MonedaID corresponde a la tabla de MONEDAS',
  `Monto` decimal(12,2) NOT NULL COMMENT 'Monto de la operación',
  `FechaOperacion` datetime NOT NULL COMMENT 'Fecha de la operación',
  `TipoResultEscID` char(1) NOT NULL COMMENT 'Corresponde a la tabla TIPORESULESCPLD',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`FolioEscala`),
  KEY `ClienteID` (`ClienteID`),
  KEY `UsuarioServicioID` (`UsuarioServicioID`),
  KEY `fk_TMPPLDVENESCALA_4` (`MonedaID`),
  KEY `fk_TMPPLDVENESCALA_5` (`TipoResultEscID`),
  CONSTRAINT `fk_TMPPLDVENESCALA_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `fk_TMPPLDVENESCALA_2` FOREIGN KEY (`UsuarioServicioID`) REFERENCES `USUARIOSERVICIO` (`UsuarioServicioID`),
  CONSTRAINT `fk_TMPPLDVENESCALA_4` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`),
  CONSTRAINT `fk_TMPPLDVENESCALA_5` FOREIGN KEY (`TipoResultEscID`) REFERENCES `TIPORESULESCPLD` (`TipoResultEscID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para guardar el escalamiento de operaciones en ingreso de operaciones'$$