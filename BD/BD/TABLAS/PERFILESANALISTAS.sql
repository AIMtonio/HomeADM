-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERFILESANALISTAS
DELIMITER ;
DROP TABLE IF EXISTS `PERFILESANALISTAS`;
DELIMITER $$

CREATE TABLE `PERFILESANALISTAS` (
  `PerfilID` int(11) NOT NULL COMMENT 'Id de perfil analista',
  `RolID` int(11) DEFAULT NULL COMMENT 'Rol del usuario analista',
  `TipoPerfil` char(1) DEFAULT NULL COMMENT 'Tipo de perfil \nA.- Analista \nE.- Ejecutivo\n',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`PerfilID`),
  KEY `fk_PERFILESANALISTAS_1_idx` (`RolID`),
  CONSTRAINT `fk_PERFILESANALISTAS_1` FOREIGN KEY (`RolID`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el registro de Perfiles de Analistas de Credito'$$