-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORKUBO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORKUBO`;DELIMITER $$

CREATE TABLE `CUENTASMAYORKUBO` (
  `ConceptoKuboID` int(11) NOT NULL,
  `Cuenta` varchar(12) NOT NULL,
  `Nomenclatura` varchar(30) NOT NULL,
  `NomenclaturaCR` varchar(30) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoKuboID`),
  KEY `fk_CUENTASMAYORKUBO_1` (`ConceptoKuboID`),
  CONSTRAINT `fk_CUENTASMAYORKUBO_1` FOREIGN KEY (`ConceptoKuboID`) REFERENCES `CONCEPTOSKUBO` (`ConceptoKuboID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas mayor para el modulo de Inv. Kubo'$$