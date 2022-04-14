-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSFONDEO`;DELIMITER $$

CREATE TABLE `CONCEPTOSFONDEO` (
  `ConceptoFondID` int(11) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoFondID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de conceptos'$$