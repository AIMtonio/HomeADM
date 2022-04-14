-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DetContrato
DELIMITER ;
DROP TABLE IF EXISTS `DetContrato`;DELIMITER $$

CREATE TABLE `DetContrato` (
  `idContratos` int(11) NOT NULL,
  `idSecContrato` int(11) NOT NULL,
  `DescSecCont` varchar(45) DEFAULT NULL,
  `Clausulado` text,
  PRIMARY KEY (`idContratos`,`idSecContrato`),
  FULLTEXT KEY `texto` (`Clausulado`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$