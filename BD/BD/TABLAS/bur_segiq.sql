-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_segiq
DELIMITER ;
DROP TABLE IF EXISTS `bur_segiq`;DELIMITER $$

CREATE TABLE `bur_segiq` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `IQ_CONSEC` int(11) NOT NULL,
  `IQ_SEGMEN` varchar(2) NOT NULL,
  `IQ_VALOR` mediumtext,
  PRIMARY KEY (`BUR_SOLNUM`,`IQ_CONSEC`,`IQ_SEGMEN`),
  CONSTRAINT `fk_bur_segiq_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$