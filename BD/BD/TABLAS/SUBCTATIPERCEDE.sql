-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERCEDE
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPERCEDE`;DELIMITER $$

CREATE TABLE `SUBCTATIPERCEDE` (
  `ConceptoCedeID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSCEDE',
  `Fisica` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Fisica',
  `FisicaActEmp` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Fisica con actividad empresarial',
  `Moral` char(2) DEFAULT NULL COMMENT 'Subcuenta para el tipo de Persona Moral',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoCedeID`),
  KEY `fk_SUBCTATIPERCEDE_1` (`ConceptoCedeID`),
  CONSTRAINT `fk_SUBCTATIPERCEDE_1` FOREIGN KEY (`ConceptoCedeID`) REFERENCES `CONCEPTOSCEDE` (`ConceptoCedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Persona para el Modulo de CEDES'$$