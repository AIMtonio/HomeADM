-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUCURSDIV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTASUCURSDIV`;DELIMITER $$

CREATE TABLE `SUBCTASUCURSDIV` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto de la \nDivisa',
  `SucursalID` int(11) NOT NULL DEFAULT '0' COMMENT 'Sucursal\ndel Catalogo\nde Sucursales',
  `SubCuenta` varchar(15) NOT NULL COMMENT 'SucCuenta \npor el Concepto\ny Sucursal',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMonID`,`SucursalID`),
  KEY `fk_SUBCTASUCURSDIV_1` (`ConceptoMonID`),
  KEY `fk_SUBCTASUCURSDIV_2` (`SucursalID`),
  CONSTRAINT `fk_SUBCTASUCURSDIV_1` FOREIGN KEY (`ConceptoMonID`) REFERENCES `CONCEPTOSDIVISA` (`ConceptoMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTASUCURSDIV_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Sucursal del Modulo de Divisas de Tesore'$$