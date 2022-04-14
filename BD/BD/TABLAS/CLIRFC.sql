-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIRFC
DELIMITER ;
DROP TABLE IF EXISTS `CLIRFC`;DELIMITER $$

CREATE TABLE `CLIRFC` (
  `ClienteID` int(11) DEFAULT NULL,
  `RFC` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$