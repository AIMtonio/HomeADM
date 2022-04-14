-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROFUN
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTESPROFUN`;DELIMITER $$

CREATE TABLE `CLIENTESPROFUN` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero del Cliente',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se da de alta el registro',
  `SucursalReg` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se esta registrando el cliente ',
  `UsuarioReg` int(11) DEFAULT NULL COMMENT 'ID del usuario que registra, debe de existir en tabla USUARIOS',
  `UsuarioCan` int(11) DEFAULT NULL COMMENT 'ID del usuario que cancela, debe de existir en tabla USUARIOS',
  `SucursalCan` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se cancela el registro PROFUN, debe de existir en la tabla de sucursales.',
  `FechaCancela` date DEFAULT NULL COMMENT 'Fecha en que se cancela el registro',
  `Estatus` char(1) DEFAULT NULL COMMENT 'R â Registrado _ Al dar de alta el cliente en PROFUN\nC - Cancelado _ cuando el cliente ya no desea participar en PROFUN \nA â Autorizado_Cuando se autoriza la solicitud de PROFUN\nE â Rechazado_Cuando se rechaza la solicitud de PROFUN\nI â Inactivo_C',
  `FechaReactivacion` date DEFAULT NULL COMMENT 'Fecha de reactivación del socio en PROFUN',
  `MesesConsPago` int(11) DEFAULT '0' COMMENT 'Numero de Meses Constantes de Pago del Cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `fk_CLIENTESPROFUN_1` (`ClienteID`),
  KEY `fk_CLIENTESPROFUN_2_idx` (`UsuarioReg`),
  KEY `fk_CLIENTESPROFUN_3_idx` (`SucursalReg`),
  CONSTRAINT `fk_CLIENTESPROFUN_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIENTESPROFUN_2` FOREIGN KEY (`UsuarioReg`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIENTESPROFUN_3` FOREIGN KEY (`SucursalReg`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los registros de los socios que desean estar registra'$$