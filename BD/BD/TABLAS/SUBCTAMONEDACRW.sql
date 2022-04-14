-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACRW
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDACRW`;

DELIMITER $$
CREATE TABLE `SUBCTAMONEDACRW` (
  `ConceptoCRWID` int(11) NOT NULL COMMENT 'ID del Concepto y FK que corresponde con la tabla de CONCEPTOSCRW.',
  `MonedaID` int(11) NOT NULL COMMENT 'ID de la Moneda.',
  `Subcuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`ConceptoCRWID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDACRW_1` (`ConceptoCRWID`),
  KEY `fk_SUBCTAMONEDACRW_2` (`MonedaID`),
  CONSTRAINT `fk_SUBCTAMONEDACRW_1` FOREIGN KEY (`ConceptoCRWID`) REFERENCES `CONCEPTOSCRW` (`ConceptoCRWID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDACRW_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Subcuenta de Divisas o Monedas para el Modulo de Crowdfunding.'$$