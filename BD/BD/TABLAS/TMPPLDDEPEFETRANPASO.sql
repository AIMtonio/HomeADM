DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDEPEFETRANPASO`;
DELIMITER $$

CREATE TABLE `TMPPLDDEPEFETRANPASO` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `NumeroMov` bigint(20) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `Monto` decimal(18,2) DEFAULT NULL,
  `NatMovimiento` char(1) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RegistroID`),
  KEY `NumeroMov` (`NumeroMov`,`ClienteID`),
  KEY `IDX_TMPPLDDEPEFETRANPASO_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla Temporal de paso que guarda el total de las transacciones que no rebasen el limite de op relevantes -PLDOPEREELEVANTRANSPRO'$$