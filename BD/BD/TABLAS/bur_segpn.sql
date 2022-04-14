-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segpn
DELIMITER ;
DROP TABLE IF EXISTS `bur_segpn`;DELIMITER $$

CREATE TABLE `bur_segpn` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `PN_CONSEC` int(11) NOT NULL,
  `PN_SEGMEN` varchar(2) NOT NULL,
  `PN_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`PN_CONSEC`,`PN_SEGMEN`),
  CONSTRAINT `fk_bur_segpn_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$