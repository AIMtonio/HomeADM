-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOS
DELIMITER ;
DROP TABLE IF EXISTS `USUARIOS`;DELIMITER $$

CREATE TABLE `USUARIOS` (
  `Clave` varchar(45) NOT NULL COMMENT 'Clave',
  `RolID` int(11) DEFAULT NULL COMMENT 'Rol o Perfil del\nUsuario',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Usuario\nA .- Activo\nB .- Bloqueado\nC .- Cancelado o Baja',
  `LoginsFallidos` int(11) DEFAULT NULL COMMENT 'Numero de Logins\nFallidos a la \nAplicacion',
  `EstatusSesion` char(1) DEFAULT NULL COMMENT 'Estatus de sesion\nValores\nA=Activo\nI=Inactivo',
  `Semilla` varchar(50) NOT NULL COMMENT 'Reservado',
  `OrigenDatos` varchar(45) DEFAULT NULL COMMENT 'Bd a la cual se Conectara el Usuario.',
  `RutaReportes` varchar(100) DEFAULT NULL,
  `RutaImgReportes` varchar(100) DEFAULT NULL,
  `LogoCtePantalla` varchar(100) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Llave Foranea Hacia Paquete Empresa\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`Clave`),
  KEY `USUARIOS_FK_1_idx` (`RolID`),
  CONSTRAINT `USUARIOS_FK_1` FOREIGN KEY (`RolID`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Manejo de Usuario del Sistema'$$