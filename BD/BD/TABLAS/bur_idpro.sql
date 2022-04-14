-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_idpro
DELIMITER ;
DROP TABLE IF EXISTS `bur_idpro`;DELIMITER $$

CREATE TABLE `bur_idpro` (
  `BUR_SOLNUM` varchar(10) NOT NULL,
  `ID_TARJET` varchar(1) DEFAULT NULL,
  `ID_TARNUM` varchar(4) DEFAULT NULL,
  `ID_HIPOTE` varchar(1) DEFAULT NULL,
  `ID_AUTOMO` varchar(1) DEFAULT NULL,
  `ID_AUTORI` varchar(1) DEFAULT NULL,
  `ID_FECAUT` date DEFAULT NULL,
  PRIMARY KEY (`BUR_SOLNUM`),
  CONSTRAINT `fk_bur_idpro_bur_sol1` FOREIGN KEY (`BUR_SOLNUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$