-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFONDEDOCIV
DELIMITER ;
DROP TABLE IF EXISTS `TMPFONDEDOCIV`;DELIMITER $$

CREATE TABLE `TMPFONDEDOCIV` (
  `Var_EstadoCiv` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='tabla temporal para estado civil y productos credito'$$