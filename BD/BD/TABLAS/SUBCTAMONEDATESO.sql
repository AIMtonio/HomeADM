-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDATESO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDATESO`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDATESO` (
  `ConceptoTesoID` int(11) NOT NULL,
  `MonedaID` int(11) NOT NULL,
  `SubCuenta` char(2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDATESO_1` (`ConceptoTesoID`),
  KEY `fk_SUBCTAMONEDATESO_2` (`MonedaID`),
  CONSTRAINT `fk_SUBCTAMONEDATESO_1` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDATESO_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por tipo de moneda para Tesoreria'$$