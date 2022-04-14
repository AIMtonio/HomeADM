-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- new_table
DELIMITER ;
DROP TABLE IF EXISTS `new_table`;DELIMITER $$

CREATE TABLE `new_table` (
  `idnew_table` int(11) NOT NULL,
  PRIMARY KEY (`idnew_table`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 PACK_KEYS=1$$