-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segur
DELIMITER ;
DROP TABLE IF EXISTS `bur_segur`;DELIMITER $$

CREATE TABLE `bur_segur` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `UR_CONSEC` int(11) NOT NULL,
  `UR_SEGMEN` varchar(2) NOT NULL,
  `UR_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`UR_CONSEC`,`UR_SEGMEN`),
  CONSTRAINT `fk_bur_segur_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$