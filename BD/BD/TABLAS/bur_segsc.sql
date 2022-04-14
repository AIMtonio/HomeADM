-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segsc
DELIMITER ;
DROP TABLE IF EXISTS `bur_segsc`;DELIMITER $$

CREATE TABLE `bur_segsc` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `SC_CONSEC` int(11) NOT NULL,
  `SC_SEGMEN` varchar(2) NOT NULL,
  `SC_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`SC_CONSEC`,`SC_SEGMEN`),
  CONSTRAINT `fk_bur_segsc_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$