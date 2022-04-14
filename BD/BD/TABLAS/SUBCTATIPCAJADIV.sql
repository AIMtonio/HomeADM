-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPCAJADIV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPCAJADIV`;DELIMITER $$

CREATE TABLE `SUBCTATIPCAJADIV` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto de la \nDivisa',
  `TipoCaja` char(2) NOT NULL DEFAULT '0' COMMENT 'Tipo de Caja',
  `SubCuenta` varchar(15) NOT NULL COMMENT 'SucCuenta \npor el Concepto\ny Tipo de Caja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMonID`,`TipoCaja`),
  KEY `fk_SUBCTATIPCAJADIV_1` (`ConceptoMonID`),
  CONSTRAINT `fk_SUBCTATIPCAJADIV_1` FOREIGN KEY (`ConceptoMonID`) REFERENCES `CONCEPTOSDIVISA` (`ConceptoMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Tipo de Caja del Modulo de Divisas de Tesore'$$