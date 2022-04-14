-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCAJA
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORCAJA`;DELIMITER $$

CREATE TABLE `CUENTASMAYORCAJA` (
  `ConceptoCajaID` int(11) NOT NULL,
  `Cuenta` varchar(12) NOT NULL COMMENT 'Numero de Cuenta',
  `Nomenclatura` varchar(30) NOT NULL COMMENT 'Nomenclatura',
  `NomenclaturaCR` varchar(30) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCajaID`),
  CONSTRAINT `fk_ConceptosCajaID_1` FOREIGN KEY (`ConceptoCajaID`) REFERENCES `CONCEPTOSCAJA` (`ConceptoCajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas mayor para las Cajas de Ahorro'$$