-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSFINTESO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAINSFINTESO`;DELIMITER $$

CREATE TABLE `SUBCTAINSFINTESO` (
  `ConceptoTesoID` int(11) NOT NULL,
  `InstitucionID` int(11) NOT NULL,
  `SubCuenta` char(4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`,`InstitucionID`),
  KEY `fk_SUBCTAINSFINTESO_1` (`ConceptoTesoID`),
  KEY `fk_SUBCTAINSFINTESO_2` (`InstitucionID`),
  CONSTRAINT `fk_SUBCTAINSFINTESO_1` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAINSFINTESO_2` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por tipo Institucion Financiera para Tesoreria'$$