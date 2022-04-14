-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSARRENDA`;DELIMITER $$

CREATE TABLE `CONCEPTOSARRENDA` (
  `ConceptoArrendaID` int(11) NOT NULL COMMENT 'ID o Llave del Concepto',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion Del Concepto Contable',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos Contables del Modulo de ARRENDAMIENTO'$$