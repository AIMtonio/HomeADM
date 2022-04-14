-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORAHO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORAHO`;DELIMITER $$

CREATE TABLE `CUENTASMAYORAHO` (
  `ConceptoAhoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Capital de la cuenta de\nAhorro',
  `Nomenclatura` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `NomenclaturaCR` varchar(30) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoAhoID`),
  KEY `ConceptoAhoID` (`ConceptoAhoID`),
  CONSTRAINT `ConceptoAhoID` FOREIGN KEY (`ConceptoAhoID`) REFERENCES `CONCEPTOSAHORRO` (`ConceptoAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de Cuentas de Ahorro'$$