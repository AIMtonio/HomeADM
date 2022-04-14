-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segpe
DELIMITER ;
DROP TABLE IF EXISTS `bur_segpe`;DELIMITER $$

CREATE TABLE `bur_segpe` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `PE_CONSEC` int(11) NOT NULL,
  `PE_SEGMEN` varchar(2) NOT NULL,
  `PE_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`PE_CONSEC`,`PE_SEGMEN`),
  CONSTRAINT `fk_bur_segpe_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$