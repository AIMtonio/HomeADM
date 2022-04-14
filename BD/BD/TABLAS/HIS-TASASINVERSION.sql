-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TASASINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TASASINVERSION`;DELIMITER $$

CREATE TABLE `HIS-TASASINVERSION` (
  `Fecha` date NOT NULL COMMENT 'Fecha del\nHistorico, es la\nfecha en la cual\nse modifico la\ntasa',
  `TipoInversionID` int(11) NOT NULL COMMENT 'LLave foranea a tipo de invesion',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Plazo Inferior en \nDias',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Plazo Superior en \nDias',
  `MontoInferior` decimal(12,2) DEFAULT NULL,
  `MontoSuperior` decimal(12,2) DEFAULT NULL,
  `ConceptoInversion` decimal(12,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `FKEY_TIPOTINVERSION` (`TipoInversionID`),
  KEY `FKEY_DIAINVERSION` (`PlazoInferior`),
  KEY `FKEY_MONTOINVERSION` (`PlazoSuperior`),
  CONSTRAINT `FKEY_TIPOTINVERSION` FOREIGN KEY (`TipoInversionID`) REFERENCES `CATINVERSION` (`TipoInversionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historial de Matriz de tasa de inversion'$$