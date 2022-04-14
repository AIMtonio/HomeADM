-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCEDE
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORCEDE`;DELIMITER $$

CREATE TABLE `CUENTASMAYORCEDE` (
  `ConceptoCedeID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSCEDE',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Numero de Cuenta Mayor ',
  `Nomenclatura` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `NomenclaturaCR` varchar(60) DEFAULT NULL COMMENT 'Nomenclatura del centro de costos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoCedeID`),
  KEY `ConceptosCedeID` (`ConceptoCedeID`),
  CONSTRAINT `FK_CUENTASMAYORCEDE_1` FOREIGN KEY (`ConceptoCedeID`) REFERENCES `CONCEPTOSCEDE` (`ConceptoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas Mayor para el Modulo de CEDES'$$