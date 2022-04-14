-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAPEOCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `MAPEOCONTABLE`;DELIMITER $$

CREATE TABLE `MAPEOCONTABLE` (
  `idefisys` varchar(20) DEFAULT NULL,
  `Cuenta` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$