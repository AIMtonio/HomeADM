DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDIASANTICITRAN`;
DELIMITER $$

CREATE TABLE `TMPPLDDIASANTICITRAN` (
  `RegistroID` bigint(12) UNSIGNED  NOT NULL AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY(RegistroID),
  KEY `IDX_TMPPLDDIASANTICITRAN_1` (`Transaccion`,`CreditoID`),
  KEY `IDX_TMPPLDDIASANTICITRAN_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal para dias anticipos en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$