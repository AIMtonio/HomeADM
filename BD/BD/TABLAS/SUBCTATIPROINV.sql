-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROINV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPROINV`;DELIMITER $$

CREATE TABLE `SUBCTATIPROINV` (
  `ConceptoInverID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `TipoProductoID` int(11) NOT NULL COMMENT 'ID del Tipo de Producto ',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInverID`,`TipoProductoID`),
  KEY `TipoInversionID` (`TipoProductoID`),
  KEY `fk_SUBCTATIPROINV_1` (`ConceptoInverID`),
  CONSTRAINT `TipoInversionID` FOREIGN KEY (`TipoProductoID`) REFERENCES `CATINVERSION` (`TipoInversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPROINV_1` FOREIGN KEY (`ConceptoInverID`) REFERENCES `CONCEPTOSINVER` (`ConceptoInvID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Producto para el Modulo de Inversiones'$$