-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPUESTOSGPOCRE
DELIMITER ;
DROP TABLE IF EXISTS `HISPUESTOSGPOCRE`;DELIMITER $$

CREATE TABLE `HISPUESTOSGPOCRE` (
  `HisPuestoGpoCreID` int(11) NOT NULL,
  `GrupoID` int(11) DEFAULT NULL COMMENT 'FK con GRUPOSCREDITO',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente que fue removido de su puesto',
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Prospecto que fue removido de su puesto',
  `Ciclo` int(11) DEFAULT NULL COMMENT 'Ciclo del grupo en el que se hace el Cambio puesto',
  `Cargo` int(11) DEFAULT NULL COMMENT 'Cargo que desempeñaba el Cliente o Prospecto cuando fue removido',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en el que se hace el cambio de puesto',
  `UsuarioRegistro` int(11) DEFAULT NULL COMMENT 'FK con USUARIOS, Usuario que registra el cambio',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`HisPuestoGpoCreID`),
  KEY `fk_HISPUESTOSGPOCRE_1_idx` (`GrupoID`),
  KEY `fk_HISPUESTOSGPOCRE_2_idx` (`UsuarioRegistro`),
  CONSTRAINT `fk_HISPUESTOSGPOCRE_1` FOREIGN KEY (`GrupoID`) REFERENCES `GRUPOSCREDITO` (`GrupoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_HISPUESTOSGPOCRE_2` FOREIGN KEY (`UsuarioRegistro`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para agregar los historicos de puesto de integrantes Grupo'$$