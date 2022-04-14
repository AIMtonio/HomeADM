-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSTINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAINSTINVBAN`;DELIMITER $$

CREATE TABLE `SUBCTAINSTINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `InstitucionID` int(11) NOT NULL COMMENT 'Id de la institucion.',
  `SubCuenta` char(4) DEFAULT NULL COMMENT 'Subcuenta ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvBanID`,`InstitucionID`),
  KEY `fk_SUBCTAINSTINVBAN_1_idx` (`InstitucionID`),
  KEY `fk_SUBCTAINSTINVBAN_2_idx` (`ConceptoInvBanID`),
  CONSTRAINT `fk_SUBCTAINSTINVBAN_1` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SUBCTAINSTINVBAN_2` FOREIGN KEY (`ConceptoInvBanID`) REFERENCES `CONCEPTOSINVBAN` (`ConceptoInvBanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Instituciones para el Modulo de Inversiones Bancarias'$$