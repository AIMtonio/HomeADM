-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CS_CUENTASMAYOR
DELIMITER ;
DROP TABLE IF EXISTS `CS_CUENTASMAYOR`;DELIMITER $$

CREATE TABLE `CS_CUENTASMAYOR` (
  `CuentaCompleta` varchar(50) DEFAULT NULL,
  `Nomenclatura` varchar(50) DEFAULT NULL,
  KEY `idxCuentaCompleta` (`CuentaCompleta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$