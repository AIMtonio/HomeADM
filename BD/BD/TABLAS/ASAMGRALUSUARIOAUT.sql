-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASAMGRALUSUARIOAUT
DELIMITER ;
DROP TABLE IF EXISTS `ASAMGRALUSUARIOAUT`;DELIMITER $$

CREATE TABLE `ASAMGRALUSUARIOAUT` (
  `AsamGralID` bigint(20) NOT NULL COMMENT 'ID de los usuarios autorizados',
  `UsuarioID` int(11) NOT NULL COMMENT 'FK de usuarios',
  `NombreCompleto` varchar(150) NOT NULL COMMENT 'Nombre completo del Usuario autorizado',
  `RolID` int(11) NOT NULL COMMENT 'Rol o Perfil del Usuario',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`AsamGralID`),
  UNIQUE KEY `UsuarioID` (`UsuarioID`),
  KEY `fk_ASAMGRALUSUARIOAUT_1` (`UsuarioID`),
  CONSTRAINT `fk_ASAMGRALUSUARIOAUT_1` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena usuarios autorizados para registrar preinscripciones a asamblea Gral.'$$