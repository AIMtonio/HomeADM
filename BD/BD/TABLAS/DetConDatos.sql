-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DetConDatos
DELIMITER ;
DROP TABLE IF EXISTS `DetConDatos`;DELIMITER $$

CREATE TABLE `DetConDatos` (
  `idSession` varchar(36) NOT NULL,
  `idContratos` int(11) NOT NULL,
  `idSecContrato` int(11) NOT NULL,
  `DescSecCont` varchar(45) DEFAULT NULL,
  `Clausulado` text,
  PRIMARY KEY (`idSession`,`idContratos`,`idSecContrato`),
  KEY `fk_Contrato_1` (`idContratos`),
  KEY `fk_DetContrato_1` (`idContratos`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1$$