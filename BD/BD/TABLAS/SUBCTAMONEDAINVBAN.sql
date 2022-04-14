-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDAINVBAN`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDAINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del Tipo de Moneda',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvBanID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDAINV_1` (`MonedaID`),
  KEY `fk_SUBCTAMONEDAINV_2` (`ConceptoInvBanID`),
  CONSTRAINT `fk_SUBCTAMONEDAINVBAN_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDAINVBAN_2` FOREIGN KEY (`ConceptoInvBanID`) REFERENCES `CONCEPTOSINVBAN` (`ConceptoInvBanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Divisas o Monedas para el Modulo de Inversiones Bancarias'$$