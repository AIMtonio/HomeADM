-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_seghi
DELIMITER ;
DROP TABLE IF EXISTS `bur_seghi`;DELIMITER $$

CREATE TABLE `bur_seghi` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `HI_CONSEC` int(11) NOT NULL,
  `HI_SEGMEN` varchar(2) NOT NULL,
  `HI_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`HI_CONSEC`,`HI_SEGMEN`),
  KEY `BUR_SEGHI` (`BUR_SOLNUM`,`HI_CONSEC`),
  CONSTRAINT `fk_bur_seghi_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$