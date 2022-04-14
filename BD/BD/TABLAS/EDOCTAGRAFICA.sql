-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAGRAFICA
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAGRAFICA`;
DELIMITER $$


CREATE TABLE `EDOCTAGRAFICA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `Descripcion` varchar(45) DEFAULT NULL,
  `Monto` decimal(14,2) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
