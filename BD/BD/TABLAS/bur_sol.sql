-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- bur_sol
DELIMITER ;
DROP TABLE IF EXISTS `bur_sol`;DELIMITER $$

CREATE TABLE `bur_sol` (
  `SOL_NUMERO` varchar(10) NOT NULL DEFAULT '0000000001',
  `SOL_PRINOM` varchar(1000) DEFAULT NULL,
  `SOL_SEGNOM` varchar(1000) DEFAULT NULL,
  `SOL_APEPAT` varchar(1000) DEFAULT NULL,
  `SOL_APEMAT` varchar(1000) DEFAULT NULL,
  `SOL_FECNAC` date DEFAULT NULL,
  `SOL_RFC` varchar(13) DEFAULT NULL,
  `SOL_CURP` varchar(18) DEFAULT NULL,
  `SOL_TELEFO` varchar(10) DEFAULT NULL,
  `SOL_TIPO` varchar(2) DEFAULT NULL,
  `SOL_MEDIO` varchar(2) DEFAULT NULL,
  `SOL_REF` varchar(1000) DEFAULT NULL,
  `SOL_EXITO` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SOL_NUMERO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$