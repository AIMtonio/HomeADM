-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPGASTESO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPGASTESO`;DELIMITER $$

CREATE TABLE `SUBCTATIPGASTESO` (
  `ConceptoTesoID` int(11) NOT NULL,
  `TipoGastoID` int(11) NOT NULL,
  `SubCuenta` char(4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`,`TipoGastoID`),
  KEY `fk_SUBCTATIPGASTESO_1` (`ConceptoTesoID`),
  KEY `fk_SUBCTATIPGASTESO_2` (`TipoGastoID`),
  CONSTRAINT `fk_SUBCTATIPGASTESO_1` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPGASTESO_2` FOREIGN KEY (`TipoGastoID`) REFERENCES `TESOCATTIPGAS` (`TipoGastoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta por Tipo de Gasto para Tesoreria'$$