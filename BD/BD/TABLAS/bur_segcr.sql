-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segcr
DELIMITER ;
DROP TABLE IF EXISTS `bur_segcr`;DELIMITER $$

CREATE TABLE `bur_segcr` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `CR_CONSEC` int(11) NOT NULL,
  `CR_SEGMEN` varchar(4) NOT NULL,
  `CR_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`CR_CONSEC`,`CR_SEGMEN`),
  CONSTRAINT `fk_bur_segcr_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$