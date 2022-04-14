-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segtl
DELIMITER ;
DROP TABLE IF EXISTS `bur_segtl`;DELIMITER $$

CREATE TABLE `bur_segtl` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `TL_CONSEC` int(11) NOT NULL,
  `TL_SEGMEN` varchar(2) NOT NULL,
  `TL_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`TL_CONSEC`,`TL_SEGMEN`),
  UNIQUE KEY `OTRA` (`BUR_SOLNUM`,`TL_CONSEC`,`TL_SEGMEN`),
  CONSTRAINT `fk_bur_segtl_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$