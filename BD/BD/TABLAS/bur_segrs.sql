-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segrs
DELIMITER ;
DROP TABLE IF EXISTS `bur_segrs`;DELIMITER $$

CREATE TABLE `bur_segrs` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `RS_CONSEC` int(11) NOT NULL,
  `RS_SEGMEN` varchar(2) NOT NULL,
  `RS_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`RS_CONSEC`,`RS_SEGMEN`),
  CONSTRAINT `fk_bur_segrs_bur_sol` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$