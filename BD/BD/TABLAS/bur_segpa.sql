-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segpa
DELIMITER ;
DROP TABLE IF EXISTS `bur_segpa`;DELIMITER $$

CREATE TABLE `bur_segpa` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `PA_CONSEC` int(11) NOT NULL,
  `PA_SEGMEN` varchar(2) NOT NULL,
  `PA_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`PA_CONSEC`,`PA_SEGMEN`),
  CONSTRAINT `fk_bur_segpa_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$