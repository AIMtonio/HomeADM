-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROCEDE
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPROCEDE`;DELIMITER $$

CREATE TABLE `SUBCTATIPROCEDE` (
  `ConceptoCedeID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSCEDE',
  `TipoCedeID` int(11) NOT NULL COMMENT 'ID del Tipo de Producto ',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoCedeID`,`TipoCedeID`),
  KEY `TipoCedeID` (`TipoCedeID`),
  KEY `fk_SUBCTATIPROCEDE_1` (`ConceptoCedeID`),
  CONSTRAINT `fk_SUBCTATIPROCEDE_1` FOREIGN KEY (`ConceptoCedeID`) REFERENCES `CONCEPTOSCEDE` (`ConceptoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPROCEDE_2` FOREIGN KEY (`TipoCedeID`) REFERENCES `TIPOSCEDES` (`TipoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de CEDES para el Modulo de CEDES'$$