-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_rpt
DELIMITER ;
DROP TABLE IF EXISTS `bur_rpt`;DELIMITER $$

CREATE TABLE `bur_rpt` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `RPT_CADRPT` longblob,
  PRIMARY KEY (`BUR_SOLNUM`),
  CONSTRAINT `fk_bur_rpt_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$