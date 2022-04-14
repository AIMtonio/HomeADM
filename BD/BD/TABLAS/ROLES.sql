-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ROLES
DELIMITER ;
DROP TABLE IF EXISTS `ROLES`;
DELIMITER $$


CREATE TABLE `ROLES` (
  `RolID` int(11) NOT NULL COMMENT 'Numero de Rol',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `NombreRol` varchar(60) NOT NULL,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion\ndel ROL\n',
  `AutTimbrado` char(1) DEFAULT NULL COMMENT 'Campo que descripe el estatus de rol sobre la acción del timbrado. /nS-> si tiene permiso /n N..Si no tiene ',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RolID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Roles o Perfiles de Usuario'$$