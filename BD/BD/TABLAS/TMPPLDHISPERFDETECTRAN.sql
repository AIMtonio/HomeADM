
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDHISPERFDETECTRAN`;

DELIMITER $$
CREATE TABLE `TMPPLDHISPERFDETECTRAN` (
  `RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ID',
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de transaccion del Registro',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_TMPPLDHISPERFDETECTRAN_1` (`ClienteID`,`TransaccionID`),
  KEY `IDX_TMPPLDHISPERFDETECTRAN_2` (`TransaccionID`),
  KEY `IDX_TMPPLDHISPERFDETECTRAN_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP:Tabla que almacena el historico del perfil transaccional-PLDOPEINUSALERTTRANSPRO'$$

