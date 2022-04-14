-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSFON
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAINSFON`;DELIMITER $$

CREATE TABLE `SUBCTAINSFON` (
  `ConceptoFonID` int(11) NOT NULL DEFAULT '0',
  `TipoFondeo` char(1) NOT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  `InstitutFondID` int(11) NOT NULL DEFAULT '0',
  `SubCuenta` char(6) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`ConceptoFonID`,`InstitutFondID`,`TipoFondeo`),
  KEY `fk_SUBCTAINSFON_1_idx` (`InstitutFondID`),
  CONSTRAINT `fk_SUBCTAINSFON_1` FOREIGN KEY (`InstitutFondID`) REFERENCES `INSTITUTFONDEO` (`InstitutFondID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='subcuenta instituciones de  fondeo'$$