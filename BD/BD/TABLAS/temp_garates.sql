-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- temp_garates
DELIMITER ;
DROP TABLE IF EXISTS `temp_garates`;DELIMITER $$

CREATE TABLE `temp_garates` (
  `garante` varchar(300) DEFAULT NULL,
  `direcGarante` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$