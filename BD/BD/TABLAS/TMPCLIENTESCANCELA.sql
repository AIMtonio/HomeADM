-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCLIENTESCANCELA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCLIENTESCANCELA`;DELIMITER $$

CREATE TABLE `TMPCLIENTESCANCELA` (
  `ClienteID` bigint(20) DEFAULT NULL,
  `PermiteReactivacion` char(1) DEFAULT NULL,
  `FechaCancelacion` datetime DEFAULT NULL,
  KEY `ClienteID` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$