-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_env
DELIMITER ;
DROP TABLE IF EXISTS `bur_env`;DELIMITER $$

CREATE TABLE `bur_env` (
  `BUR_SOL_NUM` varchar(10) NOT NULL,
  `ENV_CADENV` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`BUR_SOL_NUM`),
  CONSTRAINT `fk_bur_env_bur_sol1` FOREIGN KEY (`BUR_SOL_NUM`) REFERENCES `bur_sol` (`SOL_NUMERO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$