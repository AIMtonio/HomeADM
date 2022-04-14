-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- gen_folnum
DELIMITER ;
DROP TABLE IF EXISTS `gen_folnum`;DELIMITER $$

CREATE TABLE `gen_folnum` (
  `GEN_FOLNUM` int(11) NOT NULL DEFAULT '1',
  `GEN_SOLCAD` varchar(10) DEFAULT NULL,
  `GEN_FOLCAD` varchar(10) DEFAULT NULL,
  `BUR_SOLNUM` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`GEN_FOLNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$