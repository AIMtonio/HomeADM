-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINV
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORINV`;DELIMITER $$

CREATE TABLE `CUENTASMAYORINV` (
  `ConceptoInvID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Numero de Cuenta Mayor ',
  `Nomenclatura` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `NomenclaturaCR` varchar(60) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvID`),
  KEY `ConceptosInvID` (`ConceptoInvID`),
  CONSTRAINT `ConceptoInvID` FOREIGN KEY (`ConceptoInvID`) REFERENCES `CONCEPTOSINVER` (`ConceptoInvID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de Inversiones'$$