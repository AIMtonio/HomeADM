-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSTESO
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSTESO`;DELIMITER $$

CREATE TABLE `CONCEPTOSTESO` (
  `ConceptoTesoID` int(11) NOT NULL COMMENT 'ID o Llave del \nConcepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion\nDel Concepto\nContable',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoTesoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos Contables del Modulo de Tesoreria'$$