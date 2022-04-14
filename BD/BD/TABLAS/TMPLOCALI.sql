-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLOCALI
DELIMITER ;
DROP TABLE IF EXISTS `TMPLOCALI`;DELIMITER $$

CREATE TABLE `TMPLOCALI` (
  `Estado` int(11) DEFAULT NULL,
  `Municipio` int(11) DEFAULT NULL,
  `Localidad` varchar(500) DEFAULT NULL,
  `NumHabitantes` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Borrame porfavor'$$