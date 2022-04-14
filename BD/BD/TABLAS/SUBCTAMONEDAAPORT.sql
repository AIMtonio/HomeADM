-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAAPORT
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAMONEDAAPORT`;DELIMITER $$

CREATE TABLE `SUBCTAMONEDAAPORT` (
  `ConceptoAportID` int(5) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSAPORTACION',
  `MonedaID` int(11) NOT NULL COMMENT 'ID del Tipo de Moneda',
  `SubCuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptoAportID`,`MonedaID`),
  KEY `fk_SUBCTAMONEDAAPORT_1` (`MonedaID`),
  KEY `fk_SUBCTAMONEDAAPORT_2` (`ConceptoAportID`),
  CONSTRAINT `fk_SUBCTAMONEDAAPORT_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAMONEDAAPORT_2` FOREIGN KEY (`ConceptoAportID`) REFERENCES `CONCEPTOSAPORTACION` (`ConceptoAportID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Divisas o Monedas para el Modulo de APORTACIONES'$$