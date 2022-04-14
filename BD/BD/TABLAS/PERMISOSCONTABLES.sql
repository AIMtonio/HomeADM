-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERMISOSCONTABLES
DELIMITER ;
DROP TABLE IF EXISTS `PERMISOSCONTABLES`;DELIMITER $$

CREATE TABLE `PERMISOSCONTABLES` (
  `UsuarioID` int(11) NOT NULL COMMENT 'Numero de Usuario',
  `AfectacionFeVa` char(1) DEFAULT NULL COMMENT 'Permiso de Afectaciones Fecha Valor',
  `CierreEjercicio` char(1) DEFAULT NULL COMMENT 'Permiso de Afectaciones Fecha Valor',
  `CierrePeriodo` char(1) DEFAULT NULL COMMENT 'Permiso de Afectaciones Fecha Valor',
  `ModificaPolizas` char(1) DEFAULT NULL COMMENT 'Permiso de Afectaciones Fecha Valor',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia Paquete Empresa\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`UsuarioID`),
  KEY `fk_PERMISOSCONTABLES_1` (`UsuarioID`),
  CONSTRAINT `fk_PERMISOSCONTABLES_1` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para manejo de permisos contables para usuarios del si'$$