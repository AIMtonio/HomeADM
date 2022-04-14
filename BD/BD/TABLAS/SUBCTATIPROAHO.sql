-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAHO
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATIPROAHO`;DELIMITER $$

CREATE TABLE `SUBCTATIPROAHO` (
  `ConceptoAhoID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAHORRO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `TipoProductoID` int(11) NOT NULL COMMENT 'ID del Tipo de Producto ',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoAhoID`,`TipoProductoID`),
  KEY `fk_SUBCTATIPROAHO_1` (`ConceptoAhoID`),
  KEY `fk_SUBCTATIPROAHO_2` (`TipoProductoID`),
  CONSTRAINT `fk_SUBCTATIPROAHO_1` FOREIGN KEY (`ConceptoAhoID`) REFERENCES `CONCEPTOSAHORRO` (`ConceptoAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTATIPROAHO_2` FOREIGN KEY (`TipoProductoID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Producto para el Modulo de Cuentas de '$$