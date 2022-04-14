-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOINVBAN`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `Plazo` int(11) NOT NULL COMMENT 'Plazo en dias',
  `SubPlazoMayor` varchar(6) NOT NULL COMMENT 'Subcuenta para el Plazo Mayor',
  `SubPlazoMenor` varchar(6) NOT NULL COMMENT 'Subcuenta para el Plazo Menor',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConceptoInvBanID`),
  KEY `fk_SUBCTAPLAZOINVBAN_1` (`ConceptoInvBanID`),
  CONSTRAINT `fk_SUBCTAPLAZOINVBAN_1` FOREIGN KEY (`ConceptoInvBanID`) REFERENCES `CONCEPTOSINVBAN` (`ConceptoInvBanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Tipos de Plazo para el Modulo de Inversiones Bancarias'$$