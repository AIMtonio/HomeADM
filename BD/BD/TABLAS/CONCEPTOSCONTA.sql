-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCONTA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCONTA`;DELIMITER $$

CREATE TABLE `CONCEPTOSCONTA` (
  `ConceptoContaID` int(11) NOT NULL COMMENT 'Numero del\nConcepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del\nConcepto\nContable',
  `Tipo` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(50) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Tipo de Concepto usado en la Contabilidad Electronica.',
  PRIMARY KEY (`ConceptoContaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos Contables'$$