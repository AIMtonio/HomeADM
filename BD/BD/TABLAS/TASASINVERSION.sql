-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `TASASINVERSION`;DELIMITER $$

CREATE TABLE `TASASINVERSION` (
  `TasaInversionID` int(11) NOT NULL COMMENT 'Consegutivo de la Tasa de inversion',
  `TipoInversionID` int(11) NOT NULL COMMENT 'LLave foranea a tipo de invesion',
  `DiaInversionID` int(11) NOT NULL COMMENT 'Llave foranea del dia de invesion',
  `MontoInversionID` int(11) NOT NULL COMMENT 'llave faranea del monto',
  `ConceptoInversion` decimal(12,4) DEFAULT NULL,
  `FechaCreacion` datetime NOT NULL COMMENT 'Fecha en que se crea la tasa',
  `FechaActualizacion` datetime DEFAULT NULL COMMENT 'Fecha en la cual se modifica la tasa',
  `GatInformativo` decimal(12,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TasaInversionID`),
  KEY `FK_TIPOTINVERSION` (`TipoInversionID`),
  KEY `FK_DIAINVERSION` (`DiaInversionID`),
  KEY `FK_MONTOINVERSION` (`MontoInversionID`),
  CONSTRAINT `FK_DIAINVERSION` FOREIGN KEY (`DiaInversionID`) REFERENCES `DIASINVERSION` (`DiaInversionID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_MONTOINVERSION` FOREIGN KEY (`MontoInversionID`) REFERENCES `MONTOINVERSION` (`MontoInversionID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_TIPOINVERSION2` FOREIGN KEY (`TipoInversionID`) REFERENCES `CATINVERSION` (`TipoInversionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Matriz de tasa de inversion'$$