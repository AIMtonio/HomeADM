-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOARRENDA`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOARRENDA` (
  `ConceptoArrendaID` int(5) NOT NULL COMMENT 'Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
  `Plazo` char(1) NOT NULL COMMENT 'Valor del plazo L = largo plazo, C Corto Plazo',
  `SubCuenta` char(6) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoArrendaID`,`Plazo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Plazo para el Modulo de arrendamiento '$$