-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCALASOL
DELIMITER ;
DROP TABLE IF EXISTS `PLDESCALASOL`;DELIMITER $$

CREATE TABLE `PLDESCALASOL` (
  `FolioID` int(11) NOT NULL COMMENT 'ID de la tabla',
  `NivelRiesgoID` int(11) NOT NULL COMMENT 'Tipo de nievel de riesgo que maneja',
  `Peps` char(1) DEFAULT NULL COMMENT 'maneja pep''s\nS=Si\nN=No',
  `ActuaCuenTer` char(1) DEFAULT NULL COMMENT 'Actua por Cuenta de tercero sin declarar.\nS=Si\nN=No',
  `DudasAutDoc` char(1) DEFAULT NULL COMMENT 'Dudas de Autenticidad de Documentos  o Documentos base del perfil de transaccion.\nS=Si\nN=No',
  `RolTitular` int(11) DEFAULT NULL COMMENT 'Tipo de Rol del titular',
  `RolSuplente` int(11) DEFAULT NULL COMMENT 'Tipo de Rol del Suplente',
  `FechaVigencia` date DEFAULT NULL COMMENT 'Fecha de vigencia',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioID`),
  KEY `fk_ESCALASOL_1` (`NivelRiesgoID`),
  KEY `fk_ESCALASOL_2` (`RolTitular`),
  KEY `fk_ESCALASOL_3` (`RolSuplente`),
  CONSTRAINT `fk_ESCALASOL_1` FOREIGN KEY (`NivelRiesgoID`) REFERENCES `NIVELRIESCTEPLD` (`NivelRiesgoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ESCALASOL_2` FOREIGN KEY (`RolTitular`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ESCALASOL_3` FOREIGN KEY (`RolSuplente`) REFERENCES `ROLES` (`RolID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Escalamiento de solicitudes'$$