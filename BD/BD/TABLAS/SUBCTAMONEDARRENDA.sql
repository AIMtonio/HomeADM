-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDARRENDA`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDARRENDA` (
  `ConceptoArrendaID` int(5) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del Tipo de Moneda',
  `SubCuenta` char(6) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`,`MonedaID`),
  KEY `FK_ SUBCTAMONEDARRENDA_1_idx` (`MonedaID`),
  CONSTRAINT `FK_ SUBCTAMONEDARRENDA_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Divisas o Monedas para el Modulo de arrendamiento '$$