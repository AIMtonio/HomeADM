-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCARTERA2013411
DELIMITER ;
DROP TABLE IF EXISTS `TMPCARTERA2013411`;DELIMITER $$

CREATE TABLE `TMPCARTERA2013411` (
  `ConceptoID` int(11) NOT NULL AUTO_INCREMENT,
  `ClasifRegID` int(11) DEFAULT NULL,
  `ClaveConcepto` varchar(12) DEFAULT NULL,
  `ClaveCon` varchar(22) DEFAULT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `SaldoCapital` int(11) DEFAULT NULL,
  `SaldoInteres` int(11) DEFAULT NULL,
  `SaldoTotal` int(11) DEFAULT NULL,
  `InteresMes` int(11) DEFAULT NULL,
  `ComisionMes` int(11) DEFAULT NULL,
  `IndicadorEsNegrita` char(1) DEFAULT NULL,
  PRIMARY KEY (`ConceptoID`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=latin1$$