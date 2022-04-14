-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONGESTOR
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOADMONGESTOR`;DELIMITER $$

CREATE TABLE `SEGTOADMONGESTOR` (
  `GestorID` int(11) NOT NULL COMMENT 'Id del Gestor al que se le asignara un Ambito',
  `TipoGestionID` int(11) NOT NULL COMMENT 'Tipo de Gestor al que pertenece el Ambito',
  `SupervisorID` int(11) NOT NULL COMMENT 'Id del Supervisor al que se le asignara un Ambito',
  `Ambito` int(11) DEFAULT NULL COMMENT 'Ambito \n1.- Sus Clientes\n2.- Sucursales\n3.- Zona Geografica\n4.- Cuentas de Otro Promotor',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GestorID`,`TipoGestionID`,`SupervisorID`),
  KEY `fk_SEGTOADMONGESTOR_1_idx` (`GestorID`),
  KEY `fk_SEGTOADMONGESTOR_2_idx` (`TipoGestionID`),
  CONSTRAINT `fk_SEGTOADMONGESTOR_1` FOREIGN KEY (`GestorID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOADMONGESTOR_2` FOREIGN KEY (`TipoGestionID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar el encabezado de Administracion de Gestores'$$