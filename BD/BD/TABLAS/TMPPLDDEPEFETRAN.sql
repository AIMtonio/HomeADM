DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDEPEFETRAN`;
DELIMITER $$

CREATE TABLE `TMPPLDDEPEFETRAN` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `NumeroMov` bigint(20) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `Monto` decimal(18,2) DEFAULT NULL,
  `NatMovimiento` char(1) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RegistroID`),
  KEY `NumeroMov` (`NumeroMov`,`ClienteID`,`CuentaAhoID`),
  KEY `IDX_TMPPLDDEPEFETRAN_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla Temporal que guarda todos los Abonos en Efectivo por transaccion para la deteccion operacionesn relevantes-PLDOPEREELEVANTRANSPRO'$$