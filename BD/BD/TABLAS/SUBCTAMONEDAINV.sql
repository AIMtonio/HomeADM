-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAINV
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDAINV`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDAINV` (
  `ConceptoInverID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVER',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del Tipo de Moneda',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInverID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDAINV_1` (`MonedaID`),
  KEY `fk_SUBCTAMONEDAINV_2` (`ConceptoInverID`),
  CONSTRAINT `fk_SUBCTAMONEDAINV_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDAINV_2` FOREIGN KEY (`ConceptoInverID`) REFERENCES `CONCEPTOSINVER` (`ConceptoInvID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Divisas o Monedas para el Modulo de Inversiones'$$