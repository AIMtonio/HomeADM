-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORTESO
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORTESO`;DELIMITER $$

CREATE TABLE `CUENTASMAYORTESO` (
  `ConceptoTesoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSTESO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Cuenta de Mayor',
  `Nomenclatura` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la Cuenta',
  `NomenclaturaCR` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura del Centro de Costo',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`),
  KEY `ConceptoTesoID` (`ConceptoTesoID`),
  CONSTRAINT `ConceptoTesoID` FOREIGN KEY (`ConceptoTesoID`) REFERENCES `CONCEPTOSTESO` (`ConceptoTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de Tesoreria'$$