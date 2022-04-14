-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmptemp
DELIMITER ;
DROP TABLE IF EXISTS `tmptemp`;DELIMITER $$

CREATE TABLE `tmptemp` (
  `Credito` bigint(20) DEFAULT NULL,
  `Saldo` decimal(12,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$