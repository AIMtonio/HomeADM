-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPOARRENDA`;DELIMITER $$

CREATE TABLE `SUBCTATIPOARRENDA` (
  `ConceptoArrendaID` int(11) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
  `TipoArrenda` char(1) NOT NULL COMMENT 'Indica el tipo de arrendamiento  "F = Financiero P = Puro" ',
  `SubCuenta` varchar(6) DEFAULT NULL COMMENT 'Indica el valor de la subcuenta ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`,`TipoArrenda`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena las subcuentas por tipo de arrendamiento'$$