-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPODIV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPODIV`;DELIMITER $$

CREATE TABLE `SUBCTATIPODIV` (
  `ConceptoMonID` int(11) NOT NULL COMMENT 'Concepto de la \nDivisa',
  `Billetes` varchar(15) DEFAULT NULL COMMENT 'SubCuenta por\nBilletes',
  `Monedas` varchar(15) DEFAULT NULL COMMENT 'SubCuenta por\nMonedas\nMetalicaas',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoMonID`),
  KEY `fk_SUBCTATIPODIV_1` (`ConceptoMonID`),
  CONSTRAINT `fk_SUBCTATIPODIV_1` FOREIGN KEY (`ConceptoMonID`) REFERENCES `CONCEPTOSDIVISA` (`ConceptoMonID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='SubCuenta por Tipo(Billete o Moneda) del modulo de Divisas d'$$