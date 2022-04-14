-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCEDE
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCEDE`;DELIMITER $$

CREATE TABLE `CONCEPTOSCEDE` (
  `ConceptoCedeID` int(11) NOT NULL COMMENT 'ID o Llave del \nConcepto',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion\nDel Concepto\nContable',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoCedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos Contables del Modulo de CEDES'$$