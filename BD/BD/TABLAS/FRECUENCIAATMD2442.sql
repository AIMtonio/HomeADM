-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FRECUENCIAATMD2442
DELIMITER ;
DROP TABLE IF EXISTS `FRECUENCIAATMD2442`;DELIMITER $$

CREATE TABLE `FRECUENCIAATMD2442` (
  `NumeroCuenta` varchar(50) NOT NULL DEFAULT '',
  `Frecuencia` int(11) DEFAULT NULL,
  `Mes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Mes`,`NumeroCuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$