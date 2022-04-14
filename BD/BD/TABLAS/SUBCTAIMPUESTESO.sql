-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAIMPUESTESO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAIMPUESTESO`;DELIMITER $$

CREATE TABLE `SUBCTAIMPUESTESO` (
  `ConceptoTesoID` int(11) NOT NULL,
  `TipImpuestoID` int(11) NOT NULL,
  `SubCuenta` char(4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`,`TipImpuestoID`),
  KEY `fk_SUBCTAIMPUESTESO_1` (`ConceptoTesoID`),
  KEY `fk_SUBCTAIMPUESTESO_2` (`TipImpuestoID`),
  CONSTRAINT `fk_SUBCTAIMPUESTESO_1` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAIMPUESTESO_2` FOREIGN KEY (`TipImpuestoID`) REFERENCES `TIPIMPUESTOSXPAG` (`TipImpuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Tipo de Impuesto para Tesoreria'$$