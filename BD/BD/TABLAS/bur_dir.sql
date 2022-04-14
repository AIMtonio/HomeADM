-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_dir
DELIMITER ;
DROP TABLE IF EXISTS `bur_dir`;DELIMITER $$

CREATE TABLE `bur_dir` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `DIR_CALLE` varchar(100) DEFAULT NULL,
  `DIR_NUMEXT` varchar(10) DEFAULT NULL,
  `DIR_NUMINT` varchar(10) DEFAULT NULL,
  `DIR_MZA` varchar(10) DEFAULT NULL,
  `DIR_LOTE` varchar(10) DEFAULT NULL,
  `DIR_COLONI` varchar(100) DEFAULT NULL,
  `DIR_DELEGA` varchar(100) DEFAULT NULL,
  `DIR_CODPOS` varchar(5) DEFAULT NULL,
  `DIR_CIUDAD` varchar(100) DEFAULT NULL,
  `DIR_ESTADO` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`BUR_SOLNUM`),
  CONSTRAINT `fk_bur_dir_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$