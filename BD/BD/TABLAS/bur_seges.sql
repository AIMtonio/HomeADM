-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_seges
DELIMITER ;
DROP TABLE IF EXISTS `bur_seges`;DELIMITER $$

CREATE TABLE `bur_seges` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `ES_CONSEC` int(11) NOT NULL,
  `ES_SEGMEN` varchar(2) NOT NULL,
  `ES_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`ES_CONSEC`,`ES_SEGMEN`),
  CONSTRAINT `fk_bur_seges_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$