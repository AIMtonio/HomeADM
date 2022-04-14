-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORTARDEB
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORTARDEB`;DELIMITER $$

CREATE TABLE `CUENTASMAYORTARDEB` (
  `ConceptoTarDebID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSTARDEB',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Capital de Mayor del Concepto',
  `Nomenclatura` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la Cuenta',
  `NomenclaturaCR` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la CR',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'FechaActual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numeo de Transaccion',
  PRIMARY KEY (`ConceptoTarDebID`),
  KEY `ConceptoTarDebID` (`ConceptoTarDebID`),
  CONSTRAINT `ConceptoTarDebID` FOREIGN KEY (`ConceptoTarDebID`) REFERENCES `CONCEPTOSTARDEB` (`ConceptoTarDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de Tarjeta de Debito'$$