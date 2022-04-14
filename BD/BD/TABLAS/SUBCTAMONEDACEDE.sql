-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACEDE
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDACEDE`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDACEDE` (
  `ConceptoCedeID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSCEDE',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del Tipo de Moneda',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoCedeID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDACEDE_1` (`MonedaID`),
  KEY `fk_SUBCTAMONEDACEDE_2` (`ConceptoCedeID`),
  CONSTRAINT `fk_SUBCTAMONEDACEDE_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDACEDE_2` FOREIGN KEY (`ConceptoCedeID`) REFERENCES `CONCEPTOSCEDE` (`ConceptoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Divisas o Monedas para el Modulo de CEDES'$$