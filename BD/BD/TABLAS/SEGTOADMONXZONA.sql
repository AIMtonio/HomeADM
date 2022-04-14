-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXZONA
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOADMONXZONA`;DELIMITER $$

CREATE TABLE `SEGTOADMONXZONA` (
  `GestorID` int(11) NOT NULL COMMENT 'Id del Gestor al que se le asignara un Ambito',
  `TipoGestionID` int(11) NOT NULL COMMENT 'Tipo de Gestor al que pertenece el Ambito',
  `EstadoID` int(11) NOT NULL,
  `MunicipioID` int(11) NOT NULL,
  `LocalidadID` int(11) NOT NULL,
  `ColoniaID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GestorID`,`TipoGestionID`,`EstadoID`,`MunicipioID`,`LocalidadID`,`ColoniaID`),
  KEY `fk_SEGTOADMONXZONA_1_idx` (`GestorID`),
  KEY `fk_SEGTOADMONXZONA_2_idx` (`TipoGestionID`),
  CONSTRAINT `fk_SEGTOADMONXZONA_1` FOREIGN KEY (`GestorID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGTOADMONXZONA_2` FOREIGN KEY (`TipoGestionID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar informacion de Gestores por Zona Geografica'$$