DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDEPEFETRANRESUL`;
DELIMITER $$

CREATE TABLE `TMPPLDDEPEFETRANRESUL` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `ClienteID` int(11) DEFAULT NULL,
  `Monto` decimal(18,2) DEFAULT NULL,
  `NatMovimiento` char(1) DEFAULT NULL,
  `Calle` varchar(100) DEFAULT NULL,
  `Colonia` varchar(200) DEFAULT NULL,
  `LocalidadSuc` varchar(10) DEFAULT NULL,
  `LocalidadCli` varchar(10) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL,
  `CP` char(5) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RegistroID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `IDX_TMPPLDDEPEFETRANRESUL_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla Temporal de resultados, en esta se guardaran temporalmente los clientes que se encontraron por rebasa el limite de  op. relevantes-PLDOPEREELEVANTRANSPRO'$$