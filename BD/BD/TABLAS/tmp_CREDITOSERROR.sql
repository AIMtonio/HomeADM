-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_CREDITOSERROR
DELIMITER ;
DROP TABLE IF EXISTS `tmp_CREDITOSERROR`;DELIMITER $$

CREATE TABLE `tmp_CREDITOSERROR` (
  `Credito` int(11) DEFAULT NULL,
  `Amorti` int(11) DEFAULT NULL,
  `query` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1$$