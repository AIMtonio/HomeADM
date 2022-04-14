-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_fol
DELIMITER ;
DROP TABLE IF EXISTS `bur_fol`;DELIMITER $$

CREATE TABLE `bur_fol` (
  `FOLIO` varchar(8) DEFAULT NULL,
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `FOL_BUR` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`BUR_SOLNUM`),
  CONSTRAINT `fk_bur_fol_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$