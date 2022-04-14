-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACAJERODIV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTACAJERODIV`;DELIMITER $$

CREATE TABLE `SUBCTACAJERODIV` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto de la \nDivisa',
  `CajaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Caja\ndel Catalogo\nde CajasVentanilla',
  `SubCuenta` varchar(15) NOT NULL COMMENT 'SucCuenta \npor el Concepto\ny Caja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMonID`,`CajaID`),
  KEY `fk_SUBCTACAJERODIV_1` (`ConceptoMonID`),
  CONSTRAINT `fk_SUBCTACAJERODIV_1` FOREIGN KEY (`ConceptoMonID`) REFERENCES `CONCEPTOSDIVISA` (`ConceptoMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Cajero del Modulo de Divisas de Tesore'$$