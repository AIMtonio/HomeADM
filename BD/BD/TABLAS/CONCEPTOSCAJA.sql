-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCAJA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCAJA`;DELIMITER $$

CREATE TABLE `CONCEPTOSCAJA` (
  `ConceptoCajaID` int(11) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Concepto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoCajaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Conceptos  para Cajas De Ahorro'$$