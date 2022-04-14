-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_seghr
DELIMITER ;
DROP TABLE IF EXISTS `bur_seghr`;DELIMITER $$

CREATE TABLE `bur_seghr` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `HR_CONSEC` int(11) NOT NULL,
  `HR_SEGMEN` varchar(2) NOT NULL,
  `HR_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`HR_CONSEC`,`HR_SEGMEN`),
  CONSTRAINT `fk_bur_seghr_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$