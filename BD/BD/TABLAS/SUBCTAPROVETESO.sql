-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPROVETESO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPROVETESO`;DELIMITER $$

CREATE TABLE `SUBCTAPROVETESO` (
  `ConceptoTesoID` int(11) NOT NULL,
  `ProveedorID` int(11) NOT NULL,
  `SubCuenta` char(4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`,`ProveedorID`),
  KEY `fk_SUBCTAPROVETESO_1` (`ConceptoTesoID`),
  KEY `fk_SUBCTAPROVETESO_2` (`ProveedorID`),
  CONSTRAINT `fk_SUBCTAPROVETESO_1` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAPROVETESO_2` FOREIGN KEY (`ProveedorID`) REFERENCES `PROVEEDORES` (`ProveedorID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Provedor para Tesoreria'$$