-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESCONSOL
DELIMITER ;
DROP TABLE IF EXISTS `AVALESCONSOL`;DELIMITER $$

CREATE TABLE `AVALESCONSOL` (
  `Numero` int(11) NOT NULL AUTO_INCREMENT,
  `aval` varchar(300) DEFAULT NULL,
  `direcAval` varchar(500) DEFAULT NULL,
  `aval_2` varchar(300) DEFAULT NULL,
  `direcAval_2` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`Numero`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1$$