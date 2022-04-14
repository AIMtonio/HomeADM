-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segar
DELIMITER ;
DROP TABLE IF EXISTS `bur_segar`;DELIMITER $$

CREATE TABLE `bur_segar` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `AR_CONSEC` int(11) NOT NULL,
  `AR_SEGMEN` varchar(2) NOT NULL,
  `AR_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`AR_CONSEC`,`AR_SEGMEN`),
  CONSTRAINT `fk_bur_segar_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$