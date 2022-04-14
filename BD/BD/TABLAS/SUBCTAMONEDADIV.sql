-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDADIV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDADIV`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDADIV` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto de la \nDivisa',
  `MonedaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Moneda\ndel Catalogo\nde Monedas',
  `SubCuenta` varchar(15) DEFAULT NULL COMMENT 'SucCuenta \npor el Concepto\ny Moneda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMonID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDADIV_1` (`ConceptoMonID`),
  KEY `fk_SUBCTAMONEDADIV_2` (`MonedaID`),
  CONSTRAINT `fk_SUBCTAMONEDADIV_1` FOREIGN KEY (`ConceptoMonID`) REFERENCES `CONCEPTOSDIVISA` (`ConceptoMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDADIV_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Tipo de Moneda del Modulo de Divisas de Tesore'$$