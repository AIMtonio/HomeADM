-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPROARRENDA`;DELIMITER $$

CREATE TABLE `SUBCTATIPROARRENDA` (
  `ConceptoArrendaID` int(5) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder a un concepto de arrendamiento',
  `ProductoArrendaID` int(11) NOT NULL COMMENT '  Indica el producto de arrendamiento ',
  `SubCuenta` char(6) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`,`ProductoArrendaID`),
  KEY `FK_SUBCTATIPROARRENDA_1_idx` (`ProductoArrendaID`),
  CONSTRAINT `FK_SUBCTATIPROARRENDA_1` FOREIGN KEY (`ProductoArrendaID`) REFERENCES `PRODUCTOARRENDA` (`ProductoArrendaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Producto para el Modulo de arrendamiento '$$