-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORFONDEO`;DELIMITER $$

CREATE TABLE `CUENTASMAYORFONDEO` (
  `ConceptoFondID` int(11) NOT NULL,
  `TipoFondeo` char(1) NOT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  `Cuenta` varchar(12) NOT NULL,
  `Nomenclatura` varchar(30) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoFondID`,`TipoFondeo`),
  KEY `fk_CUENTASMAYORFONDEO_1` (`ConceptoFondID`),
  CONSTRAINT `fk_CUENTASMAYORFONDEO_1` FOREIGN KEY (`ConceptoFondID`) REFERENCES `CONCEPTOSFONDEO` (`ConceptoFondID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas mayor para el modulo de FONDEO'$$