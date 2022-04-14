-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCAR
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORCAR`;DELIMITER $$

CREATE TABLE `CUENTASMAYORCAR` (
  `ConceptoCarID` int(11) NOT NULL,
  `Cuenta` varchar(25) NOT NULL,
  `Nomenclatura` varchar(60) NOT NULL,
  `NomenclaturaCR` varchar(60) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCarID`),
  KEY `fk_CUENTASMAYORCARTERA_1` (`ConceptoCarID`),
  CONSTRAINT `fk_CUENTASMAYORCARTERA_1` FOREIGN KEY (`ConceptoCarID`) REFERENCES `CONCEPTOSCARTERA` (`ConceptoCarID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='cuentas mayor para el modulo de cartera'$$