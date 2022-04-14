-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCOPEPRE
DELIMITER ;
DROP TABLE IF EXISTS `PLDESCOPEPRE`;DELIMITER $$

CREATE TABLE `PLDESCOPEPRE` (
  `FolioID` int(11) NOT NULL COMMENT 'ID de la tabla',
  `NivelRiesgoID` int(11) NOT NULL COMMENT 'Tipo de Nivel de Riesgo',
  `RolTitular` int(11) DEFAULT NULL COMMENT 'Tipo de Rol del Titular',
  `RolSuplente` int(11) DEFAULT NULL COMMENT 'Tipo de Rol del Suplente',
  `FechaVigencia` date DEFAULT NULL COMMENT 'Fecha de Vigencia ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioID`),
  KEY `fk_PLDESCOPEPRE_1` (`NivelRiesgoID`),
  KEY `fk_PLDESCOPEPRE_2` (`RolTitular`),
  KEY `fk_PLDESCOPEPRE_3` (`RolSuplente`),
  CONSTRAINT `fk_PLDESCOPEPRE_1` FOREIGN KEY (`NivelRiesgoID`) REFERENCES `NIVELRIESCTEPLD` (`NivelRiesgoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDESCOPEPRE_2` FOREIGN KEY (`RolTitular`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDESCOPEPRE_3` FOREIGN KEY (`RolSuplente`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Escalamiento de Operaciones Previo'$$