-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_mesbur
DELIMITER ;
DROP TABLE IF EXISTS `tmp_mesbur`;DELIMITER $$

CREATE TABLE `tmp_mesbur` (
  `mes` varchar(2) NOT NULL,
  PRIMARY KEY (`mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$