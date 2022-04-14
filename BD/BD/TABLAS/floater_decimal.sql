-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- floater_decimal
DELIMITER ;
DROP TABLE IF EXISTS `floater_decimal`;DELIMITER $$

CREATE TABLE `floater_decimal` (
  `f` decimal(12,2) DEFAULT NULL,
  `d` decimal(10,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$